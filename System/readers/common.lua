function bb.read.commonReaders()
	---------------
	--[[ Readers ]]
	---------------
	-----------------------
	--[[ Loss of control ]]
	local frame = CreateFrame('Frame')
	frame:RegisterEvent("LOSS_OF_CONTROL_UPDATE")
	local function lostControl(self,event,...)
		print(...)
	end
	frame:SetScript("OnEvent",lostControl)
	----------------
	--[[ Auto Join]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("LFG_PROPOSAL_SHOW")
	local function MerchantShow(self,event,...)
		if getOptionCheck("Accept Queues") == true then
			if event == "LFG_PROPOSAL_SHOW" then
				readyToAccept = GetTime()
			end
		end
	end
	Frame:SetScript("OnEvent",MerchantShow)
	--------------
	--[[ Eclipse]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("ECLIPSE_DIRECTION_CHANGE")
	local function Eclipse(self, event, ...)
		if event == "ECLIPSE_DIRECTION_CHANGE" then
			if select(1,...) == "sun" then
				eclipseDirection = 1
			else
				eclipseDirection = 0
			end
		end
	end
	Frame:SetScript("OnEvent", Eclipse)
	--------------------------
	--[[ isStanding Frame --]]
	DontMoveStartTime = nil
	CreateFrame("Frame"):SetScript("OnUpdate", function ()
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
	end)
	----------------------
	--[[ timer Frame --]]
	CreateFrame("Frame"):SetScript("OnUpdate", function ()
		if uiDropdownTimer ~= nil then
			uiTimerStarted = GetTime()
		end
		if uiTimerStarted and GetTime() - uiTimerStarted >= 0.5 then
			clearChilds(uiDropdownTimer)
			uiDropdownTimer = false
			uiTimerStarted = nil
		end
	end)
	-----------------------
	--[[ Merchant Show --]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("MERCHANT_SHOW")
	local function MerchantShow(self,event,...)
		if event == "MERCHANT_SHOW" then
			if getOptionCheck("Auto-Sell/Repair") then
				SellGreys()
			end
		end
	end
	Frame:SetScript("OnEvent",MerchantShow)
	-------------------------
	--[[ Entering Combat --]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	local function EnteringCombat(self,event,...)
		if event == "PLAYER_REGEN_DISABLED" then
			-- here we should manage stats snapshots
			AgiSnap = getAgility()
			BadBoy_data["Combat Started"] = GetTime()
			ChatOverlay("|cffFF0000Entering Combat")
		end
	end
	Frame:SetScript("OnEvent",EnteringCombat)
	-----------------------
	--[[ Leaving Combat --]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	local function LeavingCombat(self,event,...)
		if event == "PLAYER_REGEN_ENABLED" then
			-- wipe interupts table
			--bb.im:debug("Wiping casters table as we left combat.")
			--  table.wipe(bb.im.casters)
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
			BadBoy_data.successCasts = 0
			BadBoy_data.failCasts = 0
			BadBoy_data["Combat Started"] = 0
			ChatOverlay("|cff00FF00Leaving Combat")
			-- clean up out of combat
			Rip_sDamage = {}
			Rake_sDamage = {}
			Thrash_sDamage = {}
			petAttacking = false
		end
	end
	Frame:SetScript("OnEvent",LeavingCombat)
	---------------------------
	--[[ UI Error Messages --]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("UI_ERROR_MESSAGE")
	local function UiErrorMessages(self,event,...)
		lastError = ...; lastErrorTime = GetTime()
		local param = (...)
		if param == ERR_PET_SPELL_DEAD  then
			BadBoy_data["Pet Dead"] = true
			BadBoy_data["Pet Whistle"] = false
		end
		if param == PETTAME_NOTDEAD.. "." then
			BadBoy_data["Pet Dead"] = false
			BadBoy_data["Pet Whistle"] = true
		end
		if param == SPELL_FAILED_ALREADY_HAVE_PET then
			BadBoy_data["Pet Dead"] = true
			BadBoy_data["Pet Whistle"] = false
		end
		if param == PETTAME_CANTCONTROLEXOTIC.. "." then
			if BadBoy_data["Box PetManager"] < 5 then
				BadBoy_data["Box PetManager"] = BadBoy_data["Box PetManager"] + 1
			else
				BadBoy_data["Box PetManager"] = 1
			end
		end
		if param == PETTAME_NOPETAVAILABLE.. "." then
			BadBoy_data["Pet Dead"] = false
			BadBoy_data["Pet Whistle"] = true
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
	local Frame = CreateFrame('Frame')
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
			print("!!")
			frame = frame and frame:IsShown() and frame or DEFAULT_CHAT_FRAME
			frame:AddMessage(("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(tostring(prefix), tostring(text)), 0.41, 0.8, 0.94)
		end
		print(...)
	end
	--Frame:SetScript("OnEvent", addonReader)
	---------------------------
	--[[ Combat Log Reader --]]
	local superReaderFrame = CreateFrame('Frame')
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
	local function SuperReader(self,event,...)
		-------------------------------------------------
		--[[ SpellCast Sents (used to define target) --]]
		if event == "UNIT_SPELLCAST_SENT" then
			local SourceUnit 	= select(1,...)
			local SpellName 	= select(2,...)
			spellCastTarget 	= select(4,...)
			--print("UNIT_SPELLCAST_SENT spellCastTarget = "..spellCastTarget)
			local MyClass = UnitClass("player")
			if SourceUnit == "player" then
				if MyClass == "Mage" then -- Mage
					if SpellName == "Arcane Blast" then --ArcaneBlast
						insertSpellCastSent(ArcaneBlast, GetTime())
				end
				end
			end
		end

		if event == "UNIT_SPELLCAST_INTERRUPTED" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			if SourceUnit == "player" then
				local MyClass = UnitClass("player")
				if MyClass == "Mage" then -- Mage
					if SpellID == 30451 then --ArcaneBlast
						insertSpellCastInterrupted(ArcaneBlast, GetTime())
				end
				end
			end
		end
		-----------------------------
		--[[ SpellCast Succeeded --]]
		if event == "UNIT_SPELLCAST_START" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
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
							SteadyCast = GetTime(); SteadyCount = 2
						else
							SteadyCast = GetTime(); SteadyCount = 1
						end
					end
					-- Focus Generation
					if SpellID == 77767 then
						focusBuilt = GetTime()
					end
				end
				if MyClass == "Mage" then -- Mage
					if SpellID == 30451 then --ArcaneBlast
						insertSpellCastStart(ArcaneBlast, GetTime())
				end
				end
			end
		end
		if event == "UNIT_SPELLCAST_STOP" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			if SourceUnit == "player" then
				local MyClass = UnitClass("player")
				if MyClass == "Mage" then -- Mage
					if SpellID == 30451 then --ArcaneBlast
						insertSpellCastStop(ArcaneBlast, GetTime())
				end
				end
			end
		end

		-----------------------------
		--[[ SpellCast Succeeded --]]
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
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
							SteadyCast = GetTime(); SteadyCount = 2
						else
							SteadyCast = GetTime(); SteadyCount = 1
						end
					end
					-- Focus Generation
					if SpellID == 77767 then
						focusBuilt = GetTime()
					end
				end
				if MyClass == "Mage" then -- Mage
					if SpellID == 30451 then --ArcaneBlast
						insertSpellCastSucceeded(ArcaneBlast, GetTime())
				end
				end
			end
		end
		--------------------------
		--[[ SpellCast Failed --]]
		if event == "UNIT_SPELLCAST_FAILED" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			local MyClass = UnitClass("player")
			if SourceUnit == "player" and isKnown(SpellID) then
				-- Kill Command
				if SpellID == 34026 then
				---print("Kill Command FAILED")
				end
				-- Whistle failed
				if SpellID == 883 or SpellID == 83242 or SpellID == 83243 or SpellID == 83244 or SpellID == 83245 then
					lastFailedWhistle = GetTime()
				end
			end
			if SourceUnit == "player" then
				if MyClass == "Mage" then -- Mage
					if SpellID == 30451 then --ArcaneBlast
						insertSpellCastFailed(ArcaneBlast, GetTime())
				end
				end
			end
		end
		-----------------------------
		--[[ Spell Failed Immune --]]
		if event == "SPELL_FAILED_IMMUNE" then
			local SourceUnit	= select(1,...)
			local SpellID 		= select(5,...)
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
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			if SourceUnit == "player" then
			--print("Channel Start")
			end
		end
		if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			if SourceUnit == "player" then
			--print("Channel STOP")
			end
		end
		if event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			if SourceUnit == "player" then
			--print("Channel Update")
			end
		end
	end
	superReaderFrame:SetScript("OnEvent", SuperReader)
end
