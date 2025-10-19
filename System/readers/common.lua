local _, br = ...
br.readers.common = br.readers.common or {}
local common = br.readers.common

function common:commonReaders()
	---------------
	--[[ Readers ]]
	---------------
	-----------------------
	--[[ Bag Update ]]
	local Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("BAG_UPDATE")
	local function BagUpdate(_, event, _)
		if event == "BAG_UPDATE" and br.player then
			br.player.bagsUpdated = true
		end
	end
	Frame:SetScript("OnEvent", BagUpdate)
	-----------------------
	--[[ Loss of control ]]
	local frame = br._G.CreateFrame("Frame")
	frame:RegisterEvent("LOSS_OF_CONTROL_UPDATE")
	local function lostControl(_, _, ...)
		-- Print(...)
	end
	frame:SetScript("OnEvent", lostControl)
	----------------
	--[[ Auto Join]]
	Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("LFG_PROPOSAL_SHOW")
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
	--------------------------
	--[[ isStanding Frame --]]
	common.DontMoveStartTime = 0
	common.isMovingStartTime = 0
	br._G.CreateFrame("Frame"):SetScript(
		"OnUpdate",
		function()
			if br._G.GetUnitSpeed("Player") == 0 then
				if not common.DontMoveStartTime then
					common.DontMoveStartTime = br._G.GetTime()
				end
				common.isMovingStartTime = 0
			else
				if common.isMovingStartTime == 0 then
					common.isMovingStartTime = br._G.GetTime()
				end
				common.DontMoveStartTime = 0
			end
		end
	)
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
	Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("MERCHANT_SHOW")
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
	Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	local function EnteringCombat(_, event, _)
		if event == "PLAYER_REGEN_DISABLED" then
			-- here we should manage stats snapshots
			br.AgiSnap = br.functions.misc:getAgility()

			if br.data.settings ~= nil then
				br.data.settings[br.loader.selectedSpec]["Combat Started"] = br._G.GetTime()
			end
			br.ui.chatOverlay:Show("|cffFF0000Entering Combat")
		end
	end
	Frame:SetScript("OnEvent", EnteringCombat)
	-----------------------
	--[[ Leaving Combat --]]
	Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
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
			br.leftCombat = br._G.GetTime()
			br.data.successCasts = 0
			br.data.failCasts = 0
			if br.data.settings ~= nil then
				br.data.settings[br.loader.selectedSpec]["Combat Started"] = 0
			end
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
	Frame = br._G.CreateFrame("Frame")
	Frame:RegisterEvent("UI_ERROR_MESSAGE")
	local function UiErrorMessages(_, _, errorType, _)
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
			br.isDisarmed = true
		end
		if param == "ERR_SPELL_FAILED_S" and br.pickPocketing then --"SPELL_FAILED_TARGET_NO_POCKETS"
			br._G.print("|cffFF0000NO POCKETS")
			br.unpickable = true
			br.pickPocketing = false
		end
		if param == "ERR_ALREADY_PICKPOCKETED" then
			br._G.print("|cffFF0000ALREADY PICKPOCKETED")
			br.unpickable = true
			br.pickPocketing = false
		end
		if errorType == "ERR_NO_LOOT" and br.pickPocketing then
			br._G.print("|cffFF0000NO LOOT")
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
	local superReaderFrame = br._G.CreateFrame("Frame")
	superReaderFrame:RegisterEvent("CHAT_MSG_ADDON")
	superReaderFrame:RegisterEvent("PLAYER_STARTED_MOVING")
	superReaderFrame:RegisterEvent("PLAYER_STOPPED_MOVING")
	superReaderFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
	superReaderFrame:RegisterEvent("UNIT_AURA")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_START")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	-- superReaderFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
	-- superReaderFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
	-- superReaderFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_UPDATE")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	superReaderFrame:RegisterEvent("UNIT_POWER_UPDATE")
	superReaderFrame:RegisterEvent("ENCOUNTER_START")
	superReaderFrame:RegisterEvent("ENCOUNTER_END")
	-- superReaderFrame:RegisterUnitEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
	superReaderFrame:RegisterUnitEvent("AZERITE_ESSENCE_ACTIVATED")
	superReaderFrame:RegisterUnitEvent("PLAYER_EQUIPMENT_CHANGED")
	superReaderFrame:RegisterUnitEvent("PLAYER_LEVEL_UP")
	superReaderFrame:RegisterUnitEvent("PLAYER_TALENT_UPDATE")
	superReaderFrame:RegisterUnitEvent("TRAIT_CONFIG_UPDATED")
	superReaderFrame:RegisterUnitEvent("UI_ERROR_MESSAGE")
	superReaderFrame:RegisterEvent("LOADING_SCREEN_ENABLED")
	superReaderFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
	local function SuperReader(_, event, ...)
		-- Aura Max Stacks
		if event == "UNIT_AURA" then
			local unitTarget, updateInfo = ...
			if updateInfo and updateInfo.addedAuras then
				for _, aura in ipairs(updateInfo.addedAuras) do
					br.readers.common.auraMaxStacks = br.readers.common.auraMaxStacks or {}
					br.readers.common.auraMaxStacks[aura.spellId] = br.readers.common.auraMaxStacks[aura.spellId] or {}
					br.readers.common.auraMaxStacks[aura.spellId][unitTarget] = aura.maxCharges or 0
				end
			end
		end
		-- Azerite Essence
		if event == "AZERITE_ESSENCE_ACTIVATED" then
			br.player.updatePlayer = true
		end
		if event == "PLAYER_EQUIPMENT_CHANGED" and br.player then
			br.player.equipHasChanged = true
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
		-- 	br.rotationChanged = true
		-- end
		if event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_EQUIPMENT_CHANGED" --[[or event == "AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED"]] or event == "TRAIT_CONFIG_UPDATED" then
			br.player.updatePlayer = true
		end
		-------------------------------------------------
		--[[ SpellCast Sents (used to define target) --]]
		if event == "UNIT_SPELLCAST_SENT" then
			local SourceUnit = select(1, ...)
			-- local SpellID = select(4, ...)
			br.spellCastTarget = select(2, ...)
			--Print("UNIT_SPELLCAST_SENT spellCastTarget = "..spellCastTarget)
			-- local MyClass = select(2, br._G.UnitClass("player"))
			if SourceUnit == "player" then

			end
		end

		if event == "UNIT_SPELLCAST_INTERRUPTED" then
			local SourceUnit = select(1, ...)
			-- local SpellID = select(3, ...)
			if SourceUnit == "player" then
				local MyClass = select(2, br._G.UnitClass("player"))
				if MyClass == "MAGE" then -- Mage
				end
			end
		end
		-----------------------------
		--[[ SpellCast Succeeded --]]
		if event == "UNIT_SPELLCAST_START" then
			local SourceUnit = select(1, ...)
			local SpellID = select(3, ...)
			br.spellCastTarget = select(2, ...)
			if SourceUnit == "player" then
				local MyClass = br._G.UnitClass("player")
				-- Hunter
				if MyClass == 3 then
					-- Serpent Sting
					if SpellID == 1978 then
						br.LastSerpent = br._G.GetTime()
						br.LastSerpentTarget = br.spellCastTarget
					end
					-- Steady Shot Logic
					if SpellID == 56641 then
						if br.SteadyCast and br.SteadyCast >= br._G.GetTime() - 2 and br.SteadyCount == 1 then
							br.SteadyCast = br._G.GetTime()
							br.SteadyCount = 2
						else
							br.SteadyCast = br._G.GetTime()
							br.SteadyCount = 1
						end
					end
					-- Focus Generation
					if SpellID == 77767 then
						br.focusBuilt = br._G.GetTime()
					end
				end
				if MyClass == "Mage" then -- Mage
				end
			end
		end
		if event == "UNIT_SPELLCAST_STOP" then
			local SourceUnit = select(1, ...)
			-- local SpellID = select(3, ...)
			if SourceUnit == "player" then
				local MyClass = br._G.UnitClass("player")
				if MyClass == "Mage" then -- Mage
				end
			end
		end

		-----------------------------
		--[[ SpellCast Succeeded --]]
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			local SourceUnit = select(1, ...)
			local SpellID = select(3, ...)
			if br.botCast == true then
				br.botCast = false
			end
			if SourceUnit == "player" then
				br.lastSucceeded = SpellID -- Used for lastCast tracking
				-- Queue Casting
				if br.player ~= nil then
					if #br.player.queue ~= 0 then
						for i = 1, #br.player.queue do
							if br._G.GetSpellInfo(SpellID) == br._G.GetSpellInfo(br.player.queue[i].id) then
								br._G.tremove(br.player.queue, i)
								if br._G.IsAoEPending() then
									br._G.SpellStopTargeting()
								end
								if not br.functions.misc:isChecked("Mute Queue") then
									br._G.print("Cast Success! - Removed |cFFFF0000" ..
									br._G.GetSpellInfo(SpellID) .. "|r from the queue.")
								end
								break
							end
						end
					end
				end
				---
				local MyClass = br._G.UnitClass("player")
				-- Hunter
				if MyClass == 3 then
					-- Serpent Sting
					if SpellID == 1978 then
						br.LastSerpent = br._G.GetTime()
					end
					-- Steady Shot Logic
					if SpellID == 56641 then
						if br.SteadyCast and br.SteadyCast >= br._G.GetTime() - 2 and br.SteadyCount == 1 then
							br.SteadyCast = br._G.GetTime()
							br.SteadyCount = 2
						else
							br.SteadyCast = br._G.GetTime()
							br.SteadyCount = 1
						end
					end
					-- Focus Generation
					if SpellID == 77767 then
						br.focusBuilt = br._G.GetTime()
					end
				end
				if MyClass == "Mage" then -- Mage
				end
			end
		end
		--------------------------
		--[[ SpellCast Failed --]]
		if event == "UNIT_SPELLCAST_FAILED" then
			local SourceUnit = select(1, ...)
			local SpellID = select(3, ...)
			local MyClass = br._G.UnitClass("player")
			if SourceUnit == "player" and br.functions.spell:isKnown(SpellID) then
				-- Kill Command
				if SpellID == 34026 then
					---Print("Kill Command FAILED")
				end
				-- Whistle failed
				if SpellID == 883 or SpellID == 83242 or SpellID == 83243 or SpellID == 83244 or SpellID == 83245 then
					br.lastFailedWhistle = br._G.GetTime()
				end
			end
			if SourceUnit == "player" then
				if MyClass == "Mage" then -- Mage
				end
			end
		end
		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			local SourceUnit = select(1, ...)
			local SpellID = select(3, ...)
			if SourceUnit == "player" then
				--Print("Channel Start")
				br.lastStarted = SpellID
			end
		end
		if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
			local SourceUnit = select(1, ...)
			local SpellID = select(3, ...)
			if SourceUnit == "player" then
				--Print("Channel STOP")
				br.lastFinished = SpellID
			end
		end
		if event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
			local SourceUnit = select(1, ...)
			-- local SpellID = select(3, ...)
			if SourceUnit == "player" then
				--Print("Channel Update")
			end
		end
		-- if event == "UNIT_SPELLCAST_EMPOWER_START" then
		-- 	local SourceUnit = select(1, ...)
		-- 	local SpellID = select(3, ...)
		-- 	if SourceUnit == "player" then
		-- 		--Print("Channel Start")
		-- 		br.empowerID = SpellID
		-- 	end
		-- end
		-- if event == "UNIT_SPELLCAST_EMPOWER_STOP" then
		-- 	local SourceUnit = select(1, ...)
		-- 	local SpellID = select(3, ...)
		-- 	if SourceUnit == "player" then
		-- 		--Print("Channel STOP")
		-- 		br.empowerID = 0
		-- 	end
		-- end
		-- if event == "UNIT_SPELLCAST_EMPOWER_UPDATE" then
		-- 	local SourceUnit = select(1, ...)
		-- 	-- local SpellID = select(3, ...)
		-- 	if SourceUnit == "player" then
		-- 		--Print("Channel Update")
		-- 	end
		-- end
		if event == "UI_ERROR_MESSAGE" then
			local errorMsg = select(1, ...)
			local messageErr = select(2, ...)
			-- Print("Error "..errorMsg..": "..messageErr)
			-- 51 = "Your Pet is Dead"
			-- 203 = "Cannot attack while dead"
			-- 278 = "Your Pet is not Dead" / "Your pet is dead. Use Revive Pet"
			if errorMsg == 278 then
				local revive = br._G.GetSpellInfo(50769) -- Used for string matching error messasge.
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
		if event == "LOADING_SCREEN_ENABLED" and br.disableControl == false then
			br.disableControl = true
		end
		if event == "LOADING_SCREEN_DISABLED" and br.disableControl == true then
			br.disableControl = false
		end
	end
	superReaderFrame:SetScript("OnEvent", SuperReader)
end
