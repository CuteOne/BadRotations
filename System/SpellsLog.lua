local _, br = ...
---------------------------------------------------------------------------------------------------
-- Spells Log (diagnostic)
---------------------------------------------------------------------------------------------------
-- The spell lists (Expansions/<Name>/<CLASS>/Class.lua and the shared lists) checked against the game
-- itself, so a client patch that renumbers ranks or changes talents shows up as plain IDs. Spells.log
-- gets, once per session for each:
--   spellbook   a spell in your spellbook (known, or shown as a future spell) whose ID isn't in your
--               class's lists: name, rank text, ID, the level it's learned at, passive or not
--   talent      every talent in your talent tree, learned or not: name, spell ID, ranks taken of the most,
--               and whether the lists have it; written again when its ranks change
-- Scanned at the first rotation tick, then after SPELLS_CHANGED, PLAYER_LEVEL_UP or a talent change, at
-- most every SCAN_GAP seconds. A client without C_SpellBook or a talent tree (C_ClassTalents, C_Traits)
-- skips that part; a call that errors stops the scan for the session with one line saying where.
br.log.spells = br.log.spells or {}
local spellsLog = br.log.spells

local SCAN_GAP = 2 -- seconds between scans while spells keep changing
local write = br.log:file("Spells.log", 400)
local pending = true -- scan at the next rotation tick
local lastScan = -math.huge
local stopped = false
local listed       -- spell ID -> true: every ID in the class's and the shared lists
local seen = {}    -- "book:<id>" / "talent:<id>" -> the last line's state, so each is written once per change

-- A game value as a plain one, or nil when BR may not use it (secret values on Forever)
local function plain(value)
	if value == nil then return nil end
	local misc = br.functions.misc
	local ok, result = pcall(function()
		if not misc:canUseValue(value) then return nil end
		if type(value) == "number" then return misc:plainNumber(value) end
		if type(value) == "string" then return misc:plainText(value) end
		if type(value) == "boolean" then return value == true end
		return value
	end)
	if not ok then return nil end
	return result
end

local function collect(list, into)
	for _, value in pairs(list) do
		if type(value) == "number" then into[value] = true
		elseif type(value) == "table" then collect(value, into) end
	end
end

-- Every spell ID the lists hold for the player's class, all specs, plus the shared lists
local function listedIDs()
	if listed then return listed end
	local ids = {}
	local spells = br.lists and br.lists.spells or {}
	local _, class = br.game.UnitClass("player")
	if spells[class] then collect(spells[class], ids) end
	if spells.Shared then collect(spells.Shared, ids) end
	listed = ids
	return ids
end

local function spellName(id)
	return plain(br.game.C_Spell.GetSpellName(id)) or ("spell " .. id)
end

local function levelText(id)
	local level = plain(br.game.C_Spell.GetSpellLevelLearned(id))
	return (level and level > 0) and (", learned at " .. level) or ""
end

local function note(key, state, line)
	if seen[key] == state then return end
	seen[key] = state
	write(line)
end

local ITEM_KINDS = { [1] = "known", [2] = "future spell" }

local function scanSpellbook(class, ids)
	local book = br.game.C_SpellBook
	if not (book and book.GetNumSpellBookSkillLines and book.GetSpellBookItemInfo) then return end
	local bank = br.game.Enum and br.game.Enum.SpellBookSpellBank and br.game.Enum.SpellBookSpellBank.Player or 0
	for line = 1, plain(book.GetNumSpellBookSkillLines()) or 0 do
		local skill = book.GetSpellBookSkillLineInfo(line)
		local offset, count = skill and plain(skill.itemIndexOffset), skill and plain(skill.numSpellBookItems)
		if offset and count and not plain(skill.isGuild) then
			local tab = plain(skill.name) or ("tab " .. line)
			for slot = offset + 1, offset + count do
				local item = book.GetSpellBookItemInfo(slot, bank)
				local kind = item and ITEM_KINDS[plain(item.itemType)]
				local id = item and (plain(item.spellID) or plain(item.actionID))
				-- a listed spell the book has but BR's known check misses: what the slot holds (2026-11-08:
				-- Feral Charge (Cat) 414924 refused NOT_KNOWN while the book listed it)
				local known = br.functions and br.functions.spell and br.functions.spell.isKnown
				if kind == "known" and id and ids[id] and known and not plain(item.isPassive) and not known(br.functions.spell, id) then
					local found = br.game.FindSpellBookSlotBySpellID and br.game.FindSpellBookSlotBySpellID(id, false)
					note("unknown:" .. id, "x", ("spellbook (%s): %s %d in the lists but BR reads it as not known: slot %d spellID %s actionID %s, FindSpellBookSlotBySpellID %s, IsPlayerSpell %s, IsSpellKnown %s"):format(
						tab, plain(item.name) or spellName(id), id, slot, tostring(plain(item.spellID)), tostring(plain(item.actionID)),
						tostring(plain(found)), tostring(br.game.IsPlayerSpell(id)), tostring(br.game.IsSpellKnown(id))))
				end
				if kind and id and not ids[id] then
					local rank = plain(item.subName)
					note("book:" .. id, kind, ("spellbook (%s): %s%s %d not in the %s lists (%s%s%s)"):format(tab,
						plain(item.name) or spellName(id), (rank and rank ~= "") and (" (" .. rank .. ")") or "", id, class,
						kind, plain(item.isPassive) and ", passive" or "", levelText(id)))
				end
			end
		end
	end
end

local function scanTalents(class, ids)
	local talents, traits = br.game.C_ClassTalents, br.game.C_Traits
	if not (talents and talents.GetActiveConfigID and traits and traits.GetConfigInfo) then return end
	local configID = plain(talents.GetActiveConfigID())
	if configID == nil then
		note("talents", "none", "talents: no active talent configuration on this client")
		return
	end
	local config = traits.GetConfigInfo(configID)
	for _, treeID in pairs(config and config.treeIDs or {}) do
		for _, nodeID in pairs(traits.GetTreeNodes(treeID) or {}) do
			local node = traits.GetNodeInfo(configID, nodeID)
			if node and plain(node.isVisible) ~= false then
				local taken, most = plain(node.ranksPurchased) or 0, plain(node.maxRanks) or 0
				local active = node.activeEntry and plain(node.activeEntry.entryID)
				for _, entryID in pairs(node.entryIDs or {}) do
					local entry = traits.GetEntryInfo(configID, entryID)
					local definition = entry and plain(entry.definitionID) and traits.GetDefinitionInfo(entry.definitionID)
					local id = definition and plain(definition.spellID)
					if id then
						-- a choice node: only the chosen entry has the node's ranks
						local ranks = (#node.entryIDs == 1 or plain(entryID) == active) and taken or 0
						local state = ranks .. "/" .. most
						note("talent:" .. id, state, ("talent: %s %d, ranks %s%s, %s"):format(spellName(id), id, state,
							#node.entryIDs > 1 and " (choice)" or "", ids[id] and "in the lists" or ("not in the " .. class .. " lists")))
					end
				end
			end
		end
	end
end

--- Scans when something changed (the rotation tick, System/Loader/Rotation.lua)
function spellsLog:watch()
	if not pending or stopped then return end
	local now = br.game.GetTime()
	if now - lastScan < SCAN_GAP then return end
	pending, lastScan = false, now
	local _, class = br.game.UnitClass("player")
	local ids = listedIDs()
	for _, part in ipairs({ { "spellbook", scanSpellbook }, { "talents", scanTalents } }) do
		local ok, err = pcall(part[2], class, ids)
		if not ok then
			stopped = true
			write(("stopped: reading the %s failed (%s); no more scans this session"):format(part[1], plain(tostring(err)) or "?"))
			return
		end
	end
end

local events = br.game.CreateFrame("Frame")
for _, event in ipairs({ "SPELLS_CHANGED", "PLAYER_LEVEL_UP", "TRAIT_CONFIG_UPDATED", "PLAYER_TALENT_UPDATE",
	"CHARACTER_POINTS_CHANGED" }) do
	pcall(events.RegisterEvent, events, event)
end
events:SetScript("OnEvent", function() pending = true end)
