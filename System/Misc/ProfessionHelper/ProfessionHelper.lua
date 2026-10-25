local _, br = ...
br.misc.ProfessionHelper = br.misc.ProfessionHelper or {}
local ProfessionHelper = br.misc.ProfessionHelper

-- Profession Helper (Other Features): out of combat, turns bag items into materials, one action per
-- recast delay. It mills and prospects what the game's tooltip marks Millable / Prospectable, so
-- every flavour and expansion works without item lists; disenchants the listed crafts
-- (br.lists.professions.disenchant); and picks and opens locked boxes. Expansions add their own
-- steps to br.api.professionSteps (Expansions/Retail/Professions.lua).

-- When the helper last acted. A loot window that opens within OWN_LOOT seconds of that is the
-- helper's (milling, prospecting, a lockbox) and it empties it; any other window is left alone.
local lastAction
local OWN_LOOT = 5
local STACK = 5 -- Milling and Prospecting take five from one stack

-- What an item's tooltip says, read once per item per session: facts[itemID][text] = true / false
local facts = {}
local function itemSays(entry, text)
	if text == nil then return false end
	local known = facts[entry.itemID]
	if known == nil then
		known = {}
		facts[entry.itemID] = known
	end
	if known[text] == nil then
		-- nil (tooltip not readable yet) isn't kept, so it's asked again next time
		known[text] = br.functions.item:bagTooltipHas(entry.bag, entry.slot, text)
	end
	return known[text] == true
end

-- The spell from the spell lists, when the player knows it
local function knownSpell(key)
	local spellID = br.functions.spell:getHighestSpellID(key)
	if spellID and br.functions.spell:isKnown(spellID) then return spellID end
	return nil
end

-- Casts a spell that takes a bag item (Milling, Disenchant, Pick Lock, ...) on that slot's item
local function castOnItem(spellID, entry)
	br._G.RunMacroText("/cast " .. br.functions.spell:getName(spellID))
	br._G.RunMacroText("/use " .. entry.bag .. " " .. entry.slot)
end

-- Mill Herbs / Prospect Ores: the first stack of five the tooltip marks with the game's text
local function processMarked(option, spellKey, text)
	return function(slots)
		if not br.functions.misc:isChecked(option) then return false end
		local spellID = knownSpell(spellKey)
		if spellID == nil or text == nil then return false end
		for i = 1, #slots do
			local entry = slots[i]
			if entry.count >= STACK and itemSays(entry, text) then
				castOnItem(spellID, entry)
				return true
			end
		end
		return false
	end
end

local function disenchant(slots)
	if not br.functions.misc:isChecked("Disenchant") then return false end
	local spellID = knownSpell("disenchant")
	if spellID == nil then return false end
	local listed = br.lists.professions.disenchant
	for i = 1, #slots do
		if listed[slots[i].itemID] then
			castOnItem(spellID, slots[i])
			return true
		end
	end
	return false
end

-- Lockboxes: an item the tooltip showed as Locked is a lockbox. While it's still locked, Pick Lock;
-- once it isn't, open it (the loot window is then the helper's).
local function lockboxes(slots)
	if not br.functions.misc:isChecked("Lockboxes") then return false end
	local spellID = knownSpell("pickLock")
	local lockedText = br._G.LOCKED
	if spellID == nil or lockedText == nil then return false end
	for i = 1, #slots do
		local entry = slots[i]
		if itemSays(entry, lockedText) then
			if br.functions.item:bagTooltipHas(entry.bag, entry.slot, lockedText) then
				castOnItem(spellID, entry)
			else
				br._G.RunMacroText("/use " .. entry.bag .. " " .. entry.slot)
			end
			return true
		end
	end
	return false
end

local steps = {
	processMarked("Mill Herbs", "milling", br._G.ITEM_MILLABLE),
	processMarked("Prospect Ores", "prospecting", br._G.ITEM_PROSPECTABLE),
	disenchant,
	lockboxes,
}

-- Each step gets the bag slots and the count per itemID (item:getBagItems) and returns true when it
-- acted; the first that does ends the turn.
local function runSteps(list, slots, totals)
	if list == nil then return false end
	for i = 1, #list do
		if list[i](slots, totals) then return true end
	end
	return false
end

function ProfessionHelper:ProfessionHelper()
	local misc = br.functions.misc
	if not misc:isChecked("Profession Helper") then return end
	if misc:isInCombat("player") or br._G.IsMounted() or br._G.IsFlying() then return end
	local now = br._G.GetTime()
	if br._G.LootFrame:IsShown() then
		if lastAction and now - lastAction < OWN_LOOT then
			br.engines.lootEngine:manuallyLootAll()
		end
		return
	end
	if lastAction and lastAction > now - misc:getValue("Profession Helper") then return end
	local slots, totals = br.functions.item:getBagItems()
	if runSteps(steps, slots, totals) or runSteps(br.api.professionSteps, slots, totals) then
		lastAction = now
	end
end

br.lifecycle:onTick(90, "profession helper", function() ProfessionHelper:ProfessionHelper() end)
