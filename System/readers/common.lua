function br.read.commonReaders()
	---------------
	--[[ Readers ]]
	---------------
	-----------------------
	--[[ Bag Update ]]
	local Frame = CreateFrame("Frame")
	Frame:RegisterEvent("BAG_UPDATE")
	local function BagUpdate(self, event, ...)
		if event == "BAG_UPDATE" then
			br.bagsUpdated = true
		end
	end
	Frame:SetScript("OnEvent", BagUpdate)
	-----------------------
	--[[ Loss of control ]]
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("LOSS_OF_CONTROL_UPDATE")
	local function lostControl(self, event, ...)
		-- Print(...)
	end
	frame:SetScript("OnEvent", lostControl)
	----------------
	--[[ Auto Join]]
	Frame = CreateFrame("Frame")
	Frame:RegisterEvent("LFG_PROPOSAL_SHOW")
	local function MerchantShow(self, event, ...)
		if getOptionCheck("Accept Queues") == true then
			if event == "LFG_PROPOSAL_SHOW" then
				readyToAccept = GetTime()
			end
		end
	end
	Frame:SetScript("OnEvent", MerchantShow)
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
	DontMoveStartTime = nil
	CreateFrame("Frame"):SetScript(
		"OnUpdate",
		function()
			if GetUnitSpeed("Player") == 0 then
				if not DontMoveStartTime then
					DontMoveStartTime = GetTime()
				end
				isMovingStartTime = 0
			else
				if isMovingStartTime == 0 then
					isMovingStartTime = GetTime()
				end
				DontMoveStartTime = nil
			end
		end
	)
	----------------------
	--[[ timer Frame --]]
	CreateFrame("Frame"):SetScript(
		"OnUpdate",
		function()
			if uiDropdownTimer ~= nil then
				uiTimerStarted = GetTime()
			end
			if uiTimerStarted and GetTime() - uiTimerStarted >= 0.5 then
				clearChilds(uiDropdownTimer)
				uiDropdownTimer = false
				uiTimerStarted = nil
			end
		end
	)
	-----------------------
	--[[ Merchant Show --]]
	Frame = CreateFrame("Frame")
	Frame:RegisterEvent("MERCHANT_SHOW")
	local function MerchantShow(self, event, ...)
		if event == "MERCHANT_SHOW" then
			if getOptionCheck("Auto-Sell/Repair") then
				SellGreys()
			end
		end
	end
	Frame:SetScript("OnEvent", MerchantShow)
	-------------------------
	--[[ Entering Combat --]]
	Frame = CreateFrame("Frame")
	Frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	local function EnteringCombat(self, event, ...)
		if event == "PLAYER_REGEN_DISABLED" then
			-- here we should manage stats snapshots
			AgiSnap = getAgility()

			if br.data.settings ~= nil then
				br.data.settings[br.selectedSpec]["Combat Started"] = GetTime()
			end
			ChatOverlay("|cffFF0000Entering Combat")
		end
	end
	Frame:SetScript("OnEvent", EnteringCombat)
	-----------------------
	--[[ Leaving Combat --]]
	Frame = CreateFrame("Frame")
	Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	local function LeavingCombat(self, event, ...)
		if event == "PLAYER_REGEN_ENABLED" then
			-- start loot manager
			if lM then
				if not IsMounted("player") then
					lM.shouldLoot = true
					lM.looted = 0
				end
			end
			potionReuse = true
			AgiSnap = 0
			usePot = true
			leftCombat = GetTime()
			br.data.successCasts = 0
			br.data.failCasts = 0
			if br.data.settings ~= nil then
				br.data.settings[br.selectedSpec]["Combat Started"] = 0
			end
			ChatOverlay("|cff00FF00Leaving Combat")
			-- clean up out of combat
			Rip_sDamage = {}
			Rake_sDamage = {}
			Thrash_sDamage = {}
			petAttacking = false
			br.lastCast.line_cd = {}
			wipe(br.read.debuffTracker)
		end
	end
	Frame:SetScript("OnEvent", LeavingCombat)
	---------------------------
	--[[ UI Error Messages --]]
	Frame = CreateFrame("Frame")
	Frame:RegisterEvent("UI_ERROR_MESSAGE")
	local function UiErrorMessages(self, event, ...)
		lastError = ...
		lastErrorTime = GetTime()
		local param = (...)
		if param == ERR_PET_SPELL_DEAD then
			br.data.settings[br.selectedSpec]["Pet Dead"] = true
			br.data.settings[br.selectedSpec]["Pet Whistle"] = false
		end
		if param == PETTAME_NOTDEAD .. "." then
			br.data.settings[br.selectedSpec]["Pet Dead"] = false
			br.data.settings[br.selectedSpec]["Pet Whistle"] = true
		end
		if param == SPELL_FAILED_ALREADY_HAVE_PET then
			br.data.settings[br.selectedSpec]["Pet Dead"] = true
			br.data.settings[br.selectedSpec]["Pet Whistle"] = false
		end
		if param == PETTAME_CANTCONTROLEXOTIC .. "." then
			if br.data.settings[br.selectedSpec]["Box PetManager"] < 5 then
				br.data.settings[br.selectedSpec]["Box PetManager"] = br.data.settings[br.selectedSpec]["Box PetManager"] + 1
			else
				br.data.settings[br.selectedSpec]["Box PetManager"] = 1
			end
		end
		if param == PETTAME_NOPETAVAILABLE .. "." then
			br.data.settings[br.selectedSpec]["Pet Dead"] = false
			br.data.settings[br.selectedSpec]["Pet Whistle"] = true
		end
		if param == SPELL_FAILED_TARGET_NO_WEAPONS then
			isDisarmed = true
		end
		if param == SPELL_FAILED_TARGET_NO_POCKETS then
			canPickpocket = false
		end
		if param == ERR_ALREADY_PICKPOCKETED then
			canPickpocket = false
		end
		if param == ERR_NO_LOOT then
			canPickpocket = false
		end
	end
	Frame:SetScript("OnEvent", UiErrorMessages)
	------------------------
	--[[ Spells Changed --]]
	Frame = CreateFrame("Frame")
	Frame:RegisterEvent("LEARNED_SPELL_IN_TAB")
	local function SpellsChanged(self, event, ...)
		if not configReloadTimer or configReloadTimer <= GetTime() - 1 then
			currentConfig, configReloadTimer = nil, GetTime()
		end
	end
	Frame:SetScript("OnEvent", SpellsChanged)
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
	local function addonReader(...)
		function DBM:AddMsg(text, prefix)
			prefix = prefix or (self.localization and self.localization.general.name) or "Deadly Boss Mods"
			local frame = _G[tostring(DBM.Options.ChatFrame)]
			Print("!!")
			frame = frame and frame:IsShown() and frame or DEFAULT_CHAT_FRAME
			frame:AddMessage(("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(tostring(prefix), tostring(text)), 0.41, 0.8, 0.94)
		end
		Print(...)
	end
	--Frame:SetScript("OnEvent", addonReader)
	GameTooltip:HookScript("OnTooltipSetUnit", function(self)
		if br.unlocked --[[EWT]] and GetObjectCountBR() ~= nil then
			local name,lunit = self:GetUnit()
			if not UnitIsVisible(lunit) then
				return
			end
			local unit = ObjectPointer(lunit)
			local burnUnit = getOptionCheck("Forced Burn") and isBurnTarget(unit) > 0
			local playerTarget = GetUnitIsUnit(unit, "target")
			local targeting = isTargeting(unit)
			local hasThreat = hasThreat(unit) or targeting or isInProvingGround() or burnUnit
			local reaction = GetUnitReaction(unit, "player") or 10
			if isChecked("Target Validation Debug") and (not UnitIsPlayer(unit) or UnitIsCharmed(unit) or UnitDebuffID("player", 320102)) then
				if isValidUnit(unit) then
					self:AddLine("Unit is Valid",0,1,0)
				elseif not getLineOfSight("player",unit) then
					self:AddLine("LoS Fail",1,0,0)
				elseif not (br.units[unit] ~= nil or GetUnitIsUnit(unit,"target") or br.lists.threatBypass[GetObjectID(unit)] ~= nil or burnUnit) then
					self:AddLine("Not in Units Table",1,0,0)
				elseif not (not UnitIsTapDenied(unit) or dummy) then
					self:AddLine("Unit is Tap Denied",1,0,0)
				elseif not (isSafeToAttack(unit) or burnUnit) then
					self:AddLine("Safe Attack Fail",1,0,0)
				elseif not ((reaction < 5 and not isChecked("Hostiles Only")) or (isChecked("Hostiles Only") and (reaction < 4 or playerTarget or targeting)) or dummy or burnUnit) then
					self:AddLine("Reaction Value Fail",1,0,0)
				elseif not ((isChecked("Attack MC Targets") and (not GetUnitIsFriend(unit, "player") or (UnitIsCharmed(unit) and UnitCanAttack("player", unit)))) or not GetUnitIsFriend(unit, "player")) then
					self:AddLine("MC Check Fail",1,0,0)
				elseif getOptionCheck("Don't break CCs") and isLongTimeCCed(unit) then
					self:AddLine("CC Check Fail",1,0,0)
				elseif not hasThreat then
					self:AddLine("Threat Fail",1,0,0)
				end
			end
		end
	end)
	---------------------------
	--[[ Combat Log Reader --]]
	local superReaderFrame = CreateFrame("Frame")
	superReaderFrame:RegisterEvent("CHAT_MSG_ADDON")
	superReaderFrame:RegisterEvent("PLAYER_STARTED_MOVING")
	superReaderFrame:RegisterEvent("PLAYER_STOPPED_MOVING")
	superReaderFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_START")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	superReaderFrame:RegisterEvent("UNIT_POWER_UPDATE")
	superReaderFrame:RegisterEvent("ENCOUNTER_START")
	superReaderFrame:RegisterEvent("ENCOUNTER_END")
	superReaderFrame:RegisterUnitEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
	superReaderFrame:RegisterUnitEvent("AZERITE_ESSENCE_ACTIVATED")
	superReaderFrame:RegisterUnitEvent("PLAYER_EQUIPMENT_CHANGED")
	superReaderFrame:RegisterUnitEvent("PLAYER_LEVEL_UP")
	superReaderFrame:RegisterUnitEvent("PLAYER_TALENT_UPDATE")
	superReaderFrame:RegisterUnitEvent("UI_ERROR_MESSAGE")
	superReaderFrame:RegisterEvent("LOADING_SCREEN_ENABLED")
	superReaderFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
	local function SuperReader(self, event, ...)
		-- Azerite Essence
		if event == "AZERITE_ESSENCE_ACTIVATED" then
			br.updatePlayerInfo = true
		end
		-- Warlock Soul Shards
		if event == "UNIT_POWER_UPDATE" and select(2, ...) == "SOUL_SHARDS" then
			shards = WarlockPowerBar_UnitPower("player")
		end
		if event == "PLAYER_EQUIPMENT_CHANGED" then
			br.equipHasChanged = true
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
		-- if event == "PLAYER_TALENT_UPDATE" and select(2, GetSpecializationInfo(GetSpecialization())) == br.selectedSpec then
		-- 	br.rotationChanged = true
		-- end
		if event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_EQUIPMENT_CHANGED" or event == "AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED" then
			br.updatePlayerInfo = true
		end
		-------------------------------------------------
		--[[ SpellCast Sents (used to define target) --]]
		if event == "UNIT_SPELLCAST_SENT" then
			local SourceUnit = select(1, ...)
			local SpellName = select(2, ...)
			spellCastTarget = select(4, ...)
			--Print("UNIT_SPELLCAST_SENT spellCastTarget = "..spellCastTarget)
			local MyClass = select(2, UnitClass("player"))
			if SourceUnit == "player" then
				-- Blizz CastSpellByName bug bypass
				if spell == "Metamorphosis" then
					CastSpellByID(191427, "player")
				end
			end
		end

		if event == "UNIT_SPELLCAST_INTERRUPTED" then
			local SourceUnit = select(1, ...)
			local SpellID = select(5, ...)
			if SourceUnit == "player" then
				local MyClass = select(2, UnitClass("player"))
				if MyClass == "MAGE" then -- Mage
				end
				-- if MyClass == "MONK" then -- Monk
				-- 	local br = _G["br"]
				-- 	local spec = _G["GetSpecialization"]
				-- 	if br.player ~= nil and spec() == 3 and br.player.spell.fistsOfFury ~= nil then
				-- 		local cd 	= br.player.cd
				-- 		local spell = br.player.spell
				-- 		local unit 	= br.player.unit
				-- 		local var 	= br.player.variables
				-- 		local comboSpells = {
				-- 			[spell.blackoutKick]              = true,
				-- 			[spell.chiBurst]                  = true,
				-- 			[spell.chiWave]                   = true,
				-- 			[spell.cracklingJadeLightning]    = true,
				-- 			[spell.fistsOfFury]               = true,
				-- 			[spell.fistOfTheWhiteTiger]       = true,
				-- 			[spell.flyingSerpentKick]         = true,
				-- 			[spell.risingSunKick]             = true,
				-- 			[spell.rushingJadeWind]           = true,
				-- 			[spell.spinningCraneKick]         = true,
				-- 			[spell.tigerPalm]                 = true,
				-- 			[spell.touchOfDeath]              = true,
				-- 			[spell.whirlingDragonPunch]       = true,
				-- 		}
				-- 		if var.prevCombo == nil or not unit.inCombat() then var.prevCombo = 6603 end
				-- 		if var.lastCombo == nil or not unit.inCombat() then var.lastCombo = 6603 end
				-- 		if comboSpells[spell] and not (cd[spell].remain() > unit.gcd("true")) and unit.inCombat() then
				-- 			var.lastCombo = var.prevCombo
				-- 			var.prevCombo = 6603
				-- 		end
				-- 	end
				-- end
			end
		end
		-----------------------------
		--[[ SpellCast Succeeded --]]
		if event == "UNIT_SPELLCAST_START" then
			local SourceUnit = select(1, ...)
			local SpellID = select(5, ...)
			if SourceUnit == "player" then
				local MyClass = UnitClass("player")
				-- Hunter
				if MyClass == 3 then
					-- Serpent Sting
					if SpellID == 1978 then
						LastSerpent = GetTime()
						LastSerpentTarget = spellCastTarget
					end
					-- Steady Shot Logic
					if SpellID == 56641 then
						if SteadyCast and SteadyCast >= GetTime() - 2 and SteadyCount == 1 then
							SteadyCast = GetTime()
							SteadyCount = 2
						else
							SteadyCast = GetTime()
							SteadyCount = 1
						end
					end
					-- Focus Generation
					if SpellID == 77767 then
						focusBuilt = GetTime()
					end
				end
				if MyClass == "Mage" then -- Mage
				end
			end
		end
		if event == "UNIT_SPELLCAST_STOP" then
			local SourceUnit = select(1, ...)
			local SpellID = select(5, ...)
			if SourceUnit == "player" then
				local MyClass = UnitClass("player")
				if MyClass == "Mage" then -- Mage
				end
			end
		end

		-----------------------------
		--[[ SpellCast Succeeded --]]
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			local SourceUnit = select(1, ...)
			local SpellID = select(5, ...)
			if botCast == true then
				botCast = false
			end
			if sourceName ~= nil then
				if GetUnitIsUnit(sourceName, "player") then
				end
			end
			if SourceUnit == "player" then
				lastSucceeded = spell -- Used for lastCast tracking
				-- Queue Casting
				if br.player ~= nil then
					if #br.player.queue ~= 0 then
						for i = 1, #br.player.queue do
							if GetSpellInfo(spell) == GetSpellInfo(br.player.queue[i].id) then
								tremove(br.player.queue, i)
								if IsAoEPending() then
									SpellStopTargeting()
								end
								if not isChecked("Mute Queue") then
									Print("Cast Success! - Removed |cFFFF0000" .. GetSpellInfo(spell) .. "|r from the queue.")
								end
								break
							end
						end
					end
				end
				---
				local MyClass = UnitClass("player")
				-- Hunter
				if MyClass == 3 then
					-- Serpent Sting
					if SpellID == 1978 then
						LastSerpent = GetTime()
						LastSerpentTarget = spellCastTarget
					end
					-- Steady Shot Logic
					if SpellID == 56641 then
						if SteadyCast and SteadyCast >= GetTime() - 2 and SteadyCount == 1 then
							SteadyCast = GetTime()
							SteadyCount = 2
						else
							SteadyCast = GetTime()
							SteadyCount = 1
						end
					end
					-- Focus Generation
					if SpellID == 77767 then
						focusBuilt = GetTime()
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
			local SpellID = select(5, ...)
			local MyClass = UnitClass("player")
			if SourceUnit == "player" and isKnown(SpellID) then
				-- Kill Command
				if SpellID == 34026 then
				---Print("Kill Command FAILED")
				end
				-- Whistle failed
				if SpellID == 883 or SpellID == 83242 or SpellID == 83243 or SpellID == 83244 or SpellID == 83245 then
					lastFailedWhistle = GetTime()
				end
			end
			if SourceUnit == "player" then
				if MyClass == "Mage" then -- Mage
				end
			end
		end
		-----------------------------
		--[[ Spell Failed Immune --]]
		if event == "SPELL_FAILED_IMMUNE" then
			local SourceUnit = select(1, ...)
			local SpellID = select(5, ...)
			local isDisarmed = false
			if SourceUnit == "player" and isKnown(SpellID) then
				-- Disarm - Warrior
				if SpellID == 676 then
					isDisarmed = true
				end
				-- Clench - Hunter (Scorpid Pet)
				if SpellID == 50541 then
					isDisarmed = true
				end
				-- Dismantle - Rogue
				if SpellID == 51722 then
					isDisarmed = true
				end
				-- Psychic Horror - Priest
				if SpellID == 64058 then
					isDisarmed = true
				end
				-- Snatch - Hunter (Bird of Prey Pet)
				if SpellID == 91644 then
					isDisarmed = true
				end
				-- Grapple Weapon - Monk
				if SpellID == 117368 then
					isDisarmed = true
				end
				-- Disarm - Warlock (Voidreaver/Voidlord Pet)
				if SpellID == 118093 then
					isDisarmed = true
				end
				-- Ring of Peace - Monk
				if SpellID == 137461 or SpellID == 140023 then
					isDisarmed = true
				end
			end
		end
		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			local SourceUnit = select(1, ...)
			local SpellID = select(5, ...)
			if SourceUnit == "player" then
				--Print("Channel Start")
				lastStarted = SpellID
			end
		end
		if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
			local SourceUnit = select(1, ...)
			local SpellID = select(5, ...)
			if SourceUnit == "player" then
				--Print("Channel STOP")
				lastFinished = SpellID
			end
		end
		if event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
			local SourceUnit = select(1, ...)
			local SpellID = select(5, ...)
			if SourceUnit == "player" then
			--Print("Channel Update")
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
				local revive = GetSpellInfo(50769) -- Used for string matching error messasge.
				local match = string.find(messageErr,revive) ~= nil
				if match then br.deadPet = true else br.deadPet = false end
			end
			if not UnitIsDeadOrGhost("player") and (UnitIsDeadOrGhost("pet") or not UnitExists("pet")) and (errorMsg == 51 or errorMsg == 203) then --or errorMsg == 277 or errorMsg == 275 then
				br.deadPet = true
				-- if deadPet == false then
				-- elseif deadPet == true and UnitHealth("pet") > 0 then
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
		if event == "LOADING_SCREEN_ENABLED" and disableControl == false then
			disableControl = true
		end
		if event == "LOADING_SCREEN_DISABLED" and disableControl == true then
			disableControl = false
		end
	end
	superReaderFrame:SetScript("OnEvent", SuperReader)
end
