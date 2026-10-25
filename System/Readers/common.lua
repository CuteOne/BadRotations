local _, br = ...
br.readers.common = br.readers.common or {}
local common = br.readers.common

-- Pre-register all event frames at module load time to avoid ADDON_ACTION_FORBIDDEN in NnLua runtime context
local _lfgFrame         = br._G.CreateFrame("Frame"); _lfgFrame:RegisterEvent("LFG_PROPOSAL_SHOW")
local _merchantFrame    = br._G.CreateFrame("Frame"); _merchantFrame:RegisterEvent("MERCHANT_SHOW")
local _regenDisFrame    = br._G.CreateFrame("Frame"); _regenDisFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
local _regenEnFrame     = br._G.CreateFrame("Frame"); _regenEnFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
local _uiErrFrame       = br._G.CreateFrame("Frame"); _uiErrFrame:RegisterEvent("UI_ERROR_MESSAGE")
local _superFrame       = br._G.CreateFrame("Frame")
local autoAttackGUID      -- the unit auto attack started on (PLAYER_ENTER_COMBAT), for the Cast Debug stop line
_superFrame:RegisterEvent("CHAT_MSG_ADDON")
_superFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
_superFrame:RegisterEvent("PLAYER_STARTED_MOVING")
-- Auto-attack starting and stopping (unit:isAutoAttacking)
_superFrame:RegisterEvent("PLAYER_ENTER_COMBAT")
_superFrame:RegisterEvent("PLAYER_LEAVE_COMBAT")
_superFrame:RegisterEvent("PLAYER_STOPPED_MOVING")
_superFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
_superFrame:RegisterEvent("UNIT_AURA")
_superFrame:RegisterEvent("UNIT_SPELLCAST_START")
_superFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
_superFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
_superFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
_superFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
_superFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
_superFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
_superFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
_superFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
_superFrame:RegisterEvent("UNIT_POWER_UPDATE")
_superFrame:RegisterEvent("ENCOUNTER_START")
_superFrame:RegisterEvent("ENCOUNTER_END")
_superFrame:RegisterUnitEvent("AZERITE_ESSENCE_ACTIVATED")
_superFrame:RegisterUnitEvent("PLAYER_EQUIPMENT_CHANGED")
_superFrame:RegisterUnitEvent("PLAYER_LEVEL_UP")
_superFrame:RegisterUnitEvent("PLAYER_TALENT_UPDATE")
_superFrame:RegisterUnitEvent("TRAIT_CONFIG_UPDATED")
_superFrame:RegisterUnitEvent("UI_ERROR_MESSAGE")
-- Fired when the local player changes specialization (all supported expansions).
-- Sets a dirty flag so Core.lua re-evaluates the spec on the next pulse tick
-- instead of calling getEffectiveSpecID() on every tick.
_superFrame:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")
-- Fired when the spellbook changes (a spell learned at a trainer or on level-up, talents, spec).
_superFrame:RegisterEvent("SPELLS_CHANGED")

-- The unit auto attack started on is dead or gone
local function autoAttackTargetDied()
	if autoAttackGUID == nil then return false end
	local unit = br._G.GetObjectWithGUID and br._G.GetObjectWithGUID(autoAttackGUID)
	return unit == nil or br.functions.unit:GetUnitIsDeadOrGhost(unit)
end

-- Max stacks of an aura on a unit (buff.X.stackMax), from UNIT_AURA's added auras. Called through
-- pcall: aura fields may be secret-tainted (e.g. by Details), and indexing with a secret spellId
-- raises "table index is secret". A module function, not a closure made for every aura.
local function recordMaxStacks(unitTarget, aura)
	local maxStacks = br.readers.common.auraMaxStacks
	local sid = aura.spellId
	maxStacks[sid] = maxStacks[sid] or {}
	maxStacks[sid][unitTarget] = aura.maxCharges or 0
end

function common:commonReaders()
	---------------
	--[[ Readers ]]
	---------------
	----------------
	--[[ Auto Join]]
	local Frame = _lfgFrame  -- pre-registered at module load time
	local function MerchantShow_AutoJoin(_, event, _)
		if br.functions.misc:getOptionCheck("Accept Queues") == true then
			if event == "LFG_PROPOSAL_SHOW" then
				br.functions.misc.readyToAccept = br._G.GetTime()
			end
		end
	end
	Frame:SetScript("OnEvent", MerchantShow_AutoJoin)
	--------------
	-- --[[ Eclipse]] -- Errors in Patch 8.0 (BfA)
	-- local Frame = CreateFrame('Frame')
	-- Frame:RegisterEvent("ECLIPSE_DIRECTION_CHANGE")
	-- local function Eclipse(self, event, ...)
	-- 	if event == "ECLIPSE_DIRECTION_CHANGE" then
	-- 		if select(1,...) == "sun" then
	-- 			eclipseDirection = 1
	-- 		else
	-- 			eclipseDirection = 0
	-- 		end
	-- 	end
	-- end
	-- Frame:SetScript("OnEvent", Eclipse)
	----------------------
	--[[ timer Frame --]]
	br._G.CreateFrame("Frame"):SetScript(
		"OnUpdate",
		function()
			if br.uiDropdownTimer ~= nil then
				br.uiTimerStarted = br._G.GetTime()
			end
			if br.uiTimerStarted and br._G.GetTime() - br.uiTimerStarted >= 0.5 then
				br._G.clearChilds(br.uiDropdownTimer)
				br.uiDropdownTimer = false
				br.uiTimerStarted = nil
			end
		end
	)
	-----------------------
	--[[ Merchant Show --]]
	Frame = _merchantFrame  -- pre-registered at module load time
	local function MerchantShow_AutoSellRepair(_, event, _)
		if event == "MERCHANT_SHOW" then
			if br.functions.misc:getOptionCheck("Auto-Sell/Repair") then
				br.engines.lootEngine:sellGreys()
			end
		end
	end
	Frame:SetScript("OnEvent", MerchantShow_AutoSellRepair)
	-------------------------
	--[[ Entering Combat --]]
	Frame = _regenDisFrame  -- pre-registered at module load time
	local function EnteringCombat(_, event, _)
		if event == "PLAYER_REGEN_DISABLED" then
			-- here we should manage stats snapshots
			br.AgiSnap = br.functions.misc:getAgility()

			br.functions.combat:setInCombat(true)
			br.ui.chatOverlay:Show("|cffFF0000Entering Combat")
		end
	end
	Frame:SetScript("OnEvent", EnteringCombat)
	-----------------------
	--[[ Leaving Combat --]]
	Frame = _regenEnFrame  -- pre-registered at module load time
	local function LeavingCombat(_, event, _)
		if event == "PLAYER_REGEN_ENABLED" then
			-- start loot manager
			if br.lM then
				if not br._G.IsMounted("player") then
					br.lM.shouldLoot = true
					br.lM.looted = 0
				end
			end
			br.potionReuse = true
			br.AgiSnap = 0
			br.usePot = true
			br.functions.combat:setInCombat(false)
			br.ui.chatOverlay:Show("|cff00FF00Leaving Combat")
			-- clean up out of combat
			br.Rip_sDamage = {}
			br.Rake_sDamage = {}
			br.Thrash_sDamage = {}
			br.petAttacking = false
			br.functions.lastCast.lastCastTable.line_cd = {}
			br._G.wipe(br.readers.combatLog.debuffTracker)
		end
	end
	Frame:SetScript("OnEvent", LeavingCombat)
	---------------------------
	--[[ UI Error Messages --]]
	Frame = _uiErrFrame  -- pre-registered at module load time
	local function UiErrorMessages(_, _, errorType, message)
		-- Remember casts the game refused (stronger aura, line of sight, facing, range)
		-- so they aren't retried endlessly against the same unit.
		br.functions.cast:handleCastError(message)
		br.lastError = br._G.GetGameMessageInfo(errorType)
		br.lastErrorTime = br._G.GetTime()
		local param = br.lastError
		--br._G.print("|cffFF0000UI Error: " .. errorType .. " - " .. param)
		if param == "ERR_PET_SPELL_DEAD" then
			br.data.settings[br.loader.selectedSpec]["Pet Dead"] = true
			br.data.settings[br.loader.selectedSpec]["Pet Whistle"] = false
		end
		if param == "PETTAME_NOTDEAD" .. "." then
			br.data.settings[br.loader.selectedSpec]["Pet Dead"] = false
			br.data.settings[br.loader.selectedSpec]["Pet Whistle"] = true
		end
		if param == "SPELL_FAILED_ALREADY_HAVE_PET" then
			br.data.settings[br.loader.selectedSpec]["Pet Dead"] = true
			br.data.settings[br.loader.selectedSpec]["Pet Whistle"] = false
		end
		if param == "PETTAME_CANTCONTROLEXOTIC" .. "." then
			if br.data.settings[br.loader.selectedSpec]["Box PetManager"] < 5 then
				br.data.settings[br.loader.selectedSpec]["Box PetManager"] = br.data.settings[br.loader.selectedSpec]
				["Box PetManager"] + 1
			else
				br.data.settings[br.loader.selectedSpec]["Box PetManager"] = 1
			end
		end
		if param == "PETTAME_NOPETAVAILABLE" .. "." then
			br.data.settings[br.loader.selectedSpec]["Pet Dead"] = false
			br.data.settings[br.loader.selectedSpec]["Pet Whistle"] = true
		end
		if param == "SPELL_FAILED_TARGET_NO_WEAPONS" then
			br.functions.unit.isDisarmed = true
		end
		if param == "ERR_SPELL_FAILED_S" and br.pickPocketing then --"SPELL_FAILED_TARGET_NO_POCKETS"
			br.log:say("Pick Pocket", "no pockets")
			br.unpickable = true
			br.pickPocketing = false
		end
		if param == "ERR_ALREADY_PICKPOCKETED" then
			br.log:say("Pick Pocket", "already pickpocketed")
			br.unpickable = true
			br.pickPocketing = false
		end
		if errorType == "ERR_NO_LOOT" and br.pickPocketing then
			br.log:say("Pick Pocket", "no loot")
			br.unpickable = true
			br.pickPocketing = false
		end
	end
	Frame:SetScript("OnEvent", UiErrorMessages)
	-- ------------------------
	-- --[[ Spells Changed --]]
	-- Frame = br._G.CreateFrame("Frame")
	-- Frame:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE")
	-- local function SpellsChanged(_, _, _)
	-- 	if not br.configReloadTimer or br.configReloadTimer <= br._G.GetTime() - 1 then
	-- 		br.currentConfig, br.configReloadTimer = nil, br._G.GetTime()
	-- 	end
	-- end
	-- Frame:SetScript("OnEvent", SpellsChanged)
	--- under devlopment not working as of now
	--[[ Addon reader ]]
	-- local Frame = CreateFrame('Frame')
	-- Frame:RegisterEvent("CHAT")
	--    "GROUP_ROSTER_UPDATE",
	--    "INSTANCE_GROUP_SIZE_CHANGED",
	--     "CHAT_MSG_ADDON",
	--     "BN_CHAT_MSG_ADDON",
	--     "PLAYER_REGEN_DISABLED",
	--     "PLAYER_REGEN_ENABLED",
	--     "INSTANCE_ENCOUNTER_ENGAGE_UNIT",
	--     "UNIT_TARGETABLE_CHANGED",
	--     "UNIT_SPELLCAST_SUCCEEDED",
	--     "ENCOUNTER_START",
	--     "ENCOUNTER_END",
	--     --"SPELL_UPDATE_CHARGES",
	--     "UNIT_DIED",
	--     "UNIT_DESTROYED",
	--     "UNIT_HEALTH mouseover target focus player",
	--     "CHAT_MSG_WHISPER",
	--     "CHAT_MSG_BN_WHISPER",
	--     "CHAT_MSG_MONSTER_YELL",
	--     "CHAT_MSG_MONSTER_EMOTE",
	--     "CHAT_MSG_MONSTER_SAY",
	--     "CHAT_MSG_RAID_BOSS_EMOTE",
	--     "RAID_BOSS_EMOTE",
	--     "PLAYER_ENTERING_WORLD",
	--     "LFG_ROLE_CHECK_SHOW",
	--     "LFG_PROPOSAL_SHOW",
	--     "LFG_PROPOSAL_FAILED",
	--     "LFG_PROPOSAL_SUCCEEDED",
	--     "UPDATE_BATTLEFIELD_STATUS",
	--     "CINEMATIC_START",
	--     "LFG_COMPLETION_REWARD",
	--     --"WORLD_STATE_TIMER_START",
	--     --"WORLD_STATE_TIMER_STOP",
	--     "CHALLENGE_MODE_START",
	--     "CHALLENGE_MODE_RESET",
	--     "CHALLENGE_MODE_END",
	--     "ACTIVE_TALENT_GROUP_CHANGED",
	--     "UPDATE_SHAPESHIFT_FORM",
	--     "PARTY_INVITE_REQUEST",
	--     "LOADING_SCREEN_DISABLED"
	-- )
	-- local function addonReader(...)
	-- 	function br._G.DBM:AddMsg(text, prefix)
	-- 		prefix = prefix or (self.localization and self.localization.general.name) or "Deadly Boss Mods"
	-- 		local frame = br._G[tostring(_G.DBM.Options.ChatFrame)]
	-- 		br._G.print("!!")
	-- 		frame = frame and frame:IsShown() and frame or br._G["DEFAULT_CHAT_FRAME"]
	-- 		frame:AddMessage(("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(tostring(prefix), tostring(text)), 0.41, 0.8, 0.94)
	-- 	end
	-- 	br._G.print(...)
	-- end
	--Frame:SetScript("OnEvent", addonReader)

	---------------------------
	--[[ Combat Log Reader --]]
	local superReaderFrame = _superFrame  -- pre-registered at module load time; all RegisterEvent calls are above at module scope
	-- superReaderFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
	-- superReaderFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
	-- superReaderFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_UPDATE")
	-- superReaderFrame:RegisterUnitEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
	local function SuperReader(_, event, ...)
		-- Aura Max Stacks
		if event == "UNIT_AURA" then
			local unitTarget, updateInfo = ...
			if updateInfo and updateInfo.addedAuras then
				br.readers.common.auraMaxStacks = br.readers.common.auraMaxStacks or {}
				for _, aura in ipairs(updateInfo.addedAuras) do
					-- aura fields from UNIT_AURA updateInfo may be secret-tainted (e.g. by Details);
					-- pcall guards against "table index is secret" on aura.spellId
					pcall(recordMaxStacks, unitTarget, aura)
				end
			end
		end
		-- A mob's flee emote ("%s attempts to run away in fear!"): unit:isFleeing. The text can be
		-- secret, and a secret string can't index a table, hence the pcall
		if event == "CHAT_MSG_MONSTER_EMOTE" then
			local text, name = ...
			pcall(br.functions.unit.noteFleeEmote, br.functions.unit, text, (select(12, ...)), name)
		end
		-- Azerite Essence
		if event == "AZERITE_ESSENCE_ACTIVATED" and br.player then
			br.player.updatePlayer = true
		end
		-- Auto-attack on / off
		if event == "PLAYER_ENTER_COMBAT" or event == "PLAYER_LEAVE_COMBAT" then
			br.functions.unit:setAutoAttacking(event == "PLAYER_ENTER_COMBAT")
			-- The unit auto attack started on, so a stop can tell "it died" from "the target changed"
			local targetGUID = br._G.UnitGUID("target")
			if not br.functions.misc:canUseValue(targetGUID) then targetGUID = nil end
			if event == "PLAYER_ENTER_COMBAT" then autoAttackGUID = targetGUID end
			-- Cast Debug: when auto attack stops mid-fight (a queued Maul / Heroic Strike goes with it,
			-- "Interrupted"), say what was going on, so the cause can be told from the log. Not when the
			-- unit it started on died: the game drops a dead target, the fight's normal end.
			-- Checked half a second later: when the attacked unit dies, auto attack stops before the game
			-- marks it dead and before combat ends (2026-10-19: "no target" right before looting each kill)
			if event == "PLAYER_LEAVE_COMBAT" and br._G.UnitAffectingCombat("player")
				and br.functions.misc:isChecked("Cast Debug") -- a diagnostic: Cast Debug only
			then br._G.C_Timer.After(0.5, function()
				if autoAttackTargetDied() or not br._G.UnitAffectingCombat("player") then return end
				local unit, misc = br.functions.unit, br.functions.misc
				-- A part built from a flagged value can't print (2026-10-12 the whole line came out as "a debug
				-- line holding a secret value"): each value goes in as a plain copy, and the line names the
				-- flagged ones, or "?" for one BR may not use.
				local flaggedParts = {}
				local function plainPart(label, value)
					if not misc:isFlagged(value) then return value end
					flaggedParts[#flaggedParts + 1] = label
					if not misc:canUseValue(value) then return "?" end
					if type(value) == "number" then return misc:plainNumber(value) end
					return misc:plainText(value)
				end
				local target = "no target"
				if unit:GetUnitExists("target") then
					local distance = plainPart("distance", br.functions.range:getDistance("target") or -1)
					target = tostring(plainPart("target name", br._G.UnitName("target")) or "target")
						.. (type(distance) == "number" and string.format(" %.1f yds", distance) or " ? yds")
						.. (unit:GetUnitIsDeadOrGhost("target") and ", dead" or "")
					if autoAttackGUID ~= nil and targetGUID ~= nil and targetGUID ~= autoAttackGUID then
						target = target .. " (not the unit auto attack started on)"
					end
				end
				local lastCast = ""
				if br.botSpell and br.botCastTime then
					local ago = plainPart("time since the cast", br._G.GetTime() - br.botCastTime)
					lastCast = ", BR's last cast " .. tostring(plainPart("spell name", br.api.wow.GetSpellInfo(br.botSpell)))
						.. (type(ago) == "number" and string.format(" %.1fs ago", ago) or " ? ago")
				end
				local controlled = br.functions.combat.hasHardControl and br.functions.combat:hasHardControl() and ", you're crowd controlled" or ""
				local flaggedNote = #flaggedParts > 0 and (" [flagged: " .. table.concat(flaggedParts, ", ") .. "]") or ""
				br.log:systemDebug("[AUTO ATTACK OFF] mid-fight: " .. target .. lastCast .. controlled .. flaggedNote)
			end) end
			return
		end
		-- Player moving
		if event == "PLAYER_STARTED_MOVING" then
			if br.player ~= nil then
				br.player.moving = true
			end
			return
		end
		if event == "PLAYER_STOPPED_MOVING" then
			if br.player ~= nil then
				br.player.moving = false
			end
			return
		end
		-- Update Player Info
		-- if event == "PLAYER_TALENT_UPDATE" and select(2, GetSpecializationInfo(GetSpecialization())) == br.loader.selectedSpec then
		-- 	br.loader.rotationChanged = true
		-- end
		if event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_EQUIPMENT_CHANGED" --[[or event == "AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED"]] or event == "TRAIT_CONFIG_UPDATED" then
			if br.player then
				br.player.updatePlayer = true
			end
		end
		-----------------------------
		--[[ SpellCast Succeeded --]]
		-- (The sent / start / stop / interrupted / failed / channel handlers here were removed: they
		-- set values nothing reads, and their Hunter branch compared the class name with a number,
		-- so it never ran.)
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			local SourceUnit = select(1, ...)
			local SpellID = select(3, ...)
			if br.botCast == true then
				br.botCast = false
			end
			-- Queue Casting: the queued spell went off, drop it from the queue
			if SourceUnit == "player" and br.player ~= nil and #br.player.queue ~= 0 then
				for i = 1, #br.player.queue do
					local queuedID = br.player.queue[i].id
					if type(queuedID) == "table" and br.functions and br.functions.spell and br.functions.spell.getHighestKnownRank then
						queuedID = br.functions.spell:getHighestKnownRank(queuedID) or queuedID[1]
					elseif type(queuedID) == "table" then
						queuedID = queuedID[1]
					end
					if br.api.wow.GetSpellInfo(SpellID) == br.api.wow.GetSpellInfo(queuedID) then
						br._G.tremove(br.player.queue, i)
						if br._G.IsAoEPending() then
							br._G.SpellStopTargeting()
						end
						if not br.functions.misc:isChecked("Mute Queue") then
							br.log:say("Queue", "Cast " .. br.log.highlight(br.api.wow.GetSpellInfo(queuedID)) .. ", removed from the queue")
						end
						break
					end
				end
			end
		end
		if event == "UI_ERROR_MESSAGE" then
			local errorMsg = select(1, ...)
			local messageErr = select(2, ...)
			-- Print("Error "..errorMsg..": "..messageErr)
			-- 51 = "Your Pet is Dead"
			-- 203 = "Cannot attack while dead"
			-- 278 = "Your Pet is not Dead" / "Your pet is dead. Use Revive Pet"
			if errorMsg == 278 then
				local revive = br.api.wow.GetSpellInfo(50769) -- Used for string matching error messasge.
				local match = string.find(messageErr, revive) ~= nil
				if match then
					br.readers.combatLog.deadPet = true
				else
					br.readers.combatLog.deadPet = false
				end
			end
			if not br.functions.unit:GetUnitIsDeadOrGhost("player") and (br.functions.unit:GetUnitIsDeadOrGhost("pet") or not br.functions.unit:GetUnitExists("pet")) and (errorMsg == 51 or errorMsg == 203) then --or errorMsg == 277 or errorMsg == 275 then
				br.readers.combatLog.deadPet = true
				-- if deadPet == false then
				-- elseif deadPet == true and br._G.UnitHealth("pet") > 0 then
				-- 	deadPet = false
				-- end
			end
		end
		if event == "ENCOUNTER_START" then
			if br.player ~= nil then
				br.player.eID = select(1, ...)
			end
		end
		if event == "ENCOUNTER_END" then
			if br.player ~= nil then
				br.player.eID = 0
			end
		end
		if event == "ACTIVE_PLAYER_SPECIALIZATION_CHANGED" then
			br.bootstrap:noteSpecChange()
		end
		-- Spells known, spell types, talents and current ranks that are remembered
		if event == "SPELLS_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "TRAIT_CONFIG_UPDATED"
			or event == "PLAYER_LEVEL_UP" or event == "ACTIVE_PLAYER_SPECIALIZATION_CHANGED"
		then
			br.functions.cast:clearSpellFacts()
			br.functions.spell:clearRankCache()
			br.functions.lastCast:clearAbilityIDs()
			br.functions.range:invalidateMeleeSpellCache()
		end
	end
	superReaderFrame:SetScript("OnEvent", SuperReader)
end

br.lifecycle:onStart(21, "readers", function() common:commonReaders() end)
