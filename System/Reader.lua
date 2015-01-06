function ReaderRun()
---------------
--[[ Readers ]]
---------------

-- Vars
if AgiSnap == nil then
	AgiSnap = 0
end
if canPickpocket == nil then
	canPickpocket = true
end
if usePot == nil then
	usePot = true
end

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

--------------------------
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
		AgiSnap = getAgility()
		BadBoy_data["Combat Started"] = GetTime()
		if debugTable ~= nil and #debugTable > 249 then
			tremove(debugTable, 250)
		end
		if debugRefresh ~= nil and BadBoy_data.ActualRow == 0 then
			debugRefresh()
		end
		ChatOverlay("|cffFF0000Entering Combat")
	end
end
Frame:SetScript("OnEvent",EnteringCombat)

-----------------------
--[[ Leving Combat --]]
local Frame = CreateFrame('Frame')
Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
local function LeavingCombat(self,event,...)
	if event == "PLAYER_REGEN_ENABLED" then
		potionReuse = true
		AgiSnap = 0
		usePot = true
		leftCombat = GetTime()
		BadBoy_data.successCasts = 0
		BadBoy_data.failCasts = 0
		BadBoy_data["Combat Started"] = 0
		--tinsert(debugTable, 1, { textString = BadBoy_data.successCasts.."|cff12C8FF/"..getCombatTime().."/Leaving Combat" , number = ":D" })
		if debugTable and #debugTable > 49 then
			tremove(debugTable, 50)
		end
		if BadBoy_data.ActualRow == 0 then
            badboyFrameRefresh("debug")
		end
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
	if event == "UI_ERROR_MESSAGE" then
		lastError = ...; lastErrorTime = GetTime()
	  	local Events = (...)
	  	-- print(...)
	  	if Events == ERR_PET_SPELL_DEAD  then
			BadBoy_data["Pet Dead"] = true
			BadBoy_data["Pet Whistle"] = false
		end
		if Events == PETTAME_NOTDEAD.. "." then
			BadBoy_data["Pet Dead"] = false
			BadBoy_data["Pet Whistle"] = true
		end
		if Events == SPELL_FAILED_ALREADY_HAVE_PET then
			BadBoy_data["Pet Dead"] = true
			BadBoy_data["Pet Whistle"] = false
		end
		if Events == PETTAME_CANTCONTROLEXOTIC.. "." then
			if BadBoy_data["Box PetManager"] < 5 then
				BadBoy_data["Box PetManager"] = BadBoy_data["Box PetManager"] + 1
			else
				BadBoy_data["Box PetManager"] = 1
			end
		end
		if Events == PETTAME_NOPETAVAILABLE.. "." then
			BadBoy_data["Pet Dead"] = false
			BadBoy_data["Pet Whistle"] = true
		end
		if Events == SPELL_FAILED_TARGET_NO_WEAPONS then
			isDisarmed = true
		end
		if Events == SPELL_FAILED_TARGET_NO_POCKETS then
			canPickpocket = false
		end
		if Events == ERR_ALREADY_PICKPOCKETED then
			canPickpocket = false
		end
		if Events == ERR_NO_LOOT then
			canPickpocket = false
		end
	end
end
Frame:SetScript("OnEvent", UiErrorMessages)

------------------------
--[[ Spells Changed --]]
local Frame = CreateFrame('Frame')
Frame:RegisterEvent("LEARNED_SPELL_IN_TAB")
local function SpellsChanged(self, event, ...)
	if event == "LEARNED_SPELL_IN_TAB" then
		if not configReloadTimer or configReloadTimer <= GetTime() - 1 then
			currentConfig, configReloadTimer = nil, GetTime()
		end
	end
end
Frame:SetScript("OnEvent", SpellsChanged)



--[[ Addon reader ]]
local Frame = CreateFrame('Frame')
Frame:RegisterEvent("CHAT")
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
function addonReader(...)
    function DBM:AddMsg(text, prefix)
        prefix = prefix or (self.localization and self.localization.general.name) or "Deadly Boss Mods"
        local frame = _G[tostring(DBM.Options.ChatFrame)]
        print("!!")
        frame = frame and frame:IsShown() and frame or DEFAULT_CHAT_FRAME
        frame:AddMessage(("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(tostring(prefix), tostring(text)), 0.41, 0.8, 0.94)
    end
    print(...)
end
Frame:SetScript("OnEvent", addonReader)


---------------------------
--[[ Combat Log Reader --]]
local superReaderFrame = CreateFrame('Frame')
superReaderFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
superReaderFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
superReaderFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
function SuperReader(self,event,...)
	if friendlyDot == nil then
		friendlyDot = {}
	end
    if debugTable == nil then
    	debugTable = {}
    end

    if select(3, UnitClass("player")) == 11 then
    	Rip_sDamage = Rip_sDamage or {}; Rake_sDamage = Rake_sDamage or {} end
    --Thrash_sDamage = Thrash_sDamage or {}


    if event == "COMBAT_LOG_EVENT_UNFILTERED" then

    	local timestamp 	= select(1,...)
    	local param 		= select(2,...)
		local source 		= select(4,...)
		local sourceName	= select(5,...)
        local destination 	= select(8,...)
		local spell 		= select(12,...)
        local playerGUID    = UnitGUID("player")
        local playerClass   = select(3, UnitClass("player"))
		--------------------------------------
		--[[ Pick Pocket Success Recorder --]]
		if param == "SPELL_CAST_SUCCESS" and spell==921 then
			canPickpocket = false
		end

		-----------------------------------
		--[[ Item Use Success Recorder --]]
		if param == "SPELL_CAST_SUCCESS" and isInCombat("player") then
			if spell == 105697 then --Virmen's Bite Buff
				usePot = false
			end
			if spell == 105708 then --Healing Potions
				usePot = false
			end
		end

        if playerClass == 3 then
            -- Steady Focus
            if spell == 77767 and param == "SPELL_CAST_SUCCESS" then
                if BadBoy_data["1stFocus"] ~= true then
                    BadBoy_data["1stFocus"] = true
                else
                    BadBoy_data["1stFocus"] = false
                end
            end
        end

        -----------------------
        --[[ Double Jeopardy ]]
        if core ~= nil and playerClass == 2 and spell == 20271 and source == playerGUID and previousJudgmentTarget ~= destination then
            core.previousJudgmentTarget = destination
        end

		---------------------
		--[[ Pet Manager --]]
		if playerClass == 9 then
	        if source == playerGUID and param == "SPELL_CAST_SUCCESS" then
	        	if spell == 688 or spell == 112866 then
	        		petSummoned = 1
	        		petSummonedTime = GetTime()
	        	end
	        	if spell == 697 or spell == 112867 then
	        		petSummoned = 2
	        		petSummonedTime = GetTime()
	        	end
	        	if spell == 691 or spell == 112869 then
	        		petSummoned = 3
	        		petSummonedTime = GetTime()
	        	end
	        	if spell == 712 or spell == 112868 then
	        		petSummoned = 4
	        		petSummonedTime = GetTime()
	        	end
	        	if spell == 30146 or spell == 112870 then
	        		petSummoned = 5
	        		petSummonedTime = GetTime()
	        	end
			end
		end

		----------------------------------
		--[[ Bleed Recorder (Warrior) --]]
		if playerClass == 1 and GetSpecialization("player") == 1 then
	        -- snapshot on spellcast
	        if source == playerGUID and param == "SPELL_CAST_SUCCESS" then
	            if spell == 115767 then
	                deepWoundsCastAP = UnitAttackPower("player")
	            end
	        -- but only record the snapshot if it successfully applied
	        elseif source == playerGUID and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") and deepWoundsCastAP ~= nil then
	            if spell == 115767 then
	                deepWoundsStoredAP = deepWoundsCastAP
	            end
	        end
	    end

		------------------------
		--[[ Bleed Recorder --]]
		if playerClass == 11 and GetSpecialization() == 2 then
			if source == playerGUID then
				function WA_calcStats()
				    local DamageMult = 1

				    local CP = GetComboPoints("player", "target")
				    if CP == 0 then CP = 5 end

				    if UnitBuffID("player",5217) then
				        DamageMult = DamageMult * 1.15
				    end

				    if UnitBuffID("player",174544) then
				        DamageMult = DamageMult * 1.4
				    end

				    WA_stats_BTactive = WA_stats_BTactive or  0
				    if UnitBuffID("player",155672) then
				        WA_stats_BTactive = GetTime()
				        DamageMult = DamageMult * 1.3
				    elseif GetTime() - WA_stats_BTactive < .2 then
				        DamageMult = DamageMult * 1.3
				    end

				    local RakeMult = 1
				    WA_stats_prowlactive = WA_stats_prowlactive or  0
				    if UnitBuffID("player",102543) then
				        RakeMult = 2
				    elseif UnitBuffID("player",5215) or UnitBuffID("player",58984) then
				        WA_stats_prowlactive = GetTime()
				        RakeMult = 2
				    elseif GetTime() - WA_stats_prowlactive < .2 then
				        RakeMult = 2
				    end

				    stats_RipTick = CP*DamageMult
				    stats_RipTick5 = 5*DamageMult
				    stats_RakeTick = DamageMult*RakeMult
				    stats_ThrashTick = DamageMult
				end
	            -- snapshot on spellcast
	            if spell == 1079 and param == "SPELL_CAST_SUCCESS" then
	            	WA_calcStats()
	                Rip_sDamage_cast = stats_RipTick
	            elseif spell == 1822 and (param == "SPELL_CAST_SUCCESS" or param == "SPELL_DAMAGE" or param == "SPELL_MISSED") then
	                WA_calcStats()
	                Rake_sDamage_cast = stats_RakeTick
	            elseif spell == 106830 and param == "SPELL_CAST_SUCCESS" then
	                WA_calcStats()
	                Thrash_sDamage_cast = stats_ThrashTick
	            end
	            -- but only record the snapshot if it successfully applied
	            if spell == 1079 and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") then
	                Rip_sDamage[destination] = Rip_sDamage_cast
	            elseif spell == 155722 and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") then
	                Rake_sDamage[destination] = Rake_sDamage_cast
	            -- elseif spell == 106830 and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") then
	            --     Thrash_sDamage[destination] = Thrash_sDamage_cast
	            end
	        end
	    end

        --------------------
        --[[ Fire Totem --]]
        if source == playerGUID and  param == "SPELL_SUMMON" and (spell == _SearingTotem or spell == _MagmaTotem) then
        	activeTotem = destination
        	activeTotemPosition = ObjectPosition("player")
        end
        if param == "UNIT_DESTROYED" and activeTotem == destination then
        	activeTotem = nil
        end

        -----------------------
        --[[ Wild Mushroom --]]
        if shroomsTable == nil then
        	shroomsTable = { }
        	shroomsTable[1] = { }
        end
        if source == playerGUID and  param == "SPELL_SUMMON" and (spell == 147349 or spell == 145205) then
       		shroomsTable[1].guid = destination
       		shroomsTable[1].x = nil
       		shroomsTable[1].y = nil
       		shroomsTable[1].z = nil
        end
        if (param == "UNIT_DIED" or  param == "UNIT_DESTROYED" or GetTotemInfo(1) ~= true) and shroomsTable ~= nil and shroomsTable[1].guid == destination then
        	shroomsTable[1] = { }
        end
        -- Moonkin
        if source == playerGUID and playerClass == 11 and GetSpecialization() == 1 then
            -- Starsurge Casted
            if spell == 78674 and param == "SPELL_CAST_SUCCESS" then
                if core then
                    core.lastStarsurge = GetTime()
                end
            end
        end

        ----------------
        --[[Item locks]]
        if source == playerGUID then
			local DPSPotionsSet = {
				[1] = {Buff = 105702, Item = 76093}, -- Intel
				[2] = {Buff = 105697, Item = 76089}, -- Agi
				[3] = {Buff = 105706, Item = 76095}, -- Str
			}

			-- Synapse Springs
			if spell == 126734 then
				synapseUsed = GetTime()
			end
			-- Lifeblood
			if spell == 121279 or spell == 74497 then
				lifeBloodUsed = GetTime()
			end
			-- DPS potions
			for i = 1, #DPSPotionsSet do
				if spell == DPSPotionsSet[i].Buff then
					potionUsed = GetTime()
					if UnitAffectingCombat("player") then
						ChatOverlay("Potion Used, can reuse in 60 secs.")
						potionReuse = false
					else
						ChatOverlay("Potion Used, cannot reuse.")
						potionReuse = true
					end
				end
				-- Lifeblood
				if spell == 121279 or spell == 74497 then
					lifeBloodUsed = GetTime()
				end
				-- DPS potions
				for i = 1, #DPSPotionsSet do
					if spell == DPSPotionsSet[i].Buff then
						potionUsed = GetTime()
						if UnitAffectingCombat("player") then
							ChatOverlay("Potion Used, cannot reuse.")
							potionReuse = false
						else
							ChatOverlay("Potion Used, can reuse in 60 secs.")
							potionReuse = true
						end
					end
				end
			end
		end

        ------------------
        --[[Spell Queues]]
        if getOptionCheck("Spell Queues") then
        	-----------------
        	--[[Cast Failed --> Queue]]
           	if param == "SPELL_CAST_FAILED" then
				if _Queues[spell] ~= true and _Queues[spell] ~= nil then
					if (_Queues[spell] == false or _Queues[spell] < (GetTime() - 10)) and getSpellCD(spell) <= 3 then
						_Queues[spell] = true
						ChatOverlay("Queued "..GetSpellInfo(spell))
					end
				end
			end
			------------------
			--[[Queue Casted]]
	        if param == "SPELL_CAST_SUCCESS" then
	        	if source == playerGUID then
	        		if _Queues == nil then _Queues = { } end
					if _Queues and _Queues[spell] ~= nil then
						if _Queues[spell] == true then
							_Queues[spell] = GetTime()
						end
					end
				end
			end
		end

        ---------------
        --[[ Debug --]]
        if getOptionCheck("Debug Frame") == true then
        	if source == playerGUID then
        		if param == "SPELL_CAST_SUCCESS" then
        			local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName = ...
                    if SpellID ~= 75 and SpellID ~= 88263 and SpellID ~= 172 and SpellID ~= 8690 then -- Add spells we dont want to appear here.
        				local color = "|cff12C8FF"
                        if BadBoy_data.successCasts == nil then
                            BadBoy_data.successCasts = 0
                        end
        				BadBoy_data.successCasts = BadBoy_data.successCasts + 1
        				if destGUID == nil or destName == nil then
        					debugdest = ""
        				else
        					debugdest = "\n|cffFF0000"..destName.." "..destGUID
        				end
						if sourceGUID == nil then
							debugSource = ""
						else
							debugSource = 	"\n|cff12C8FF"..sourceName.." "..sourceGUID
						end
        				if spellID == nil then
        					debugSpell = ""
        				else
        					debugSpell = 	"\n|cffFFDD11"..spellName.." "..spellID
        				end
        				local Power = "\n|cffFFFFFFPower: "..UnitPower("player")
        				tinsert(debugTable,1,{ textString = BadBoy_data.successCasts.."|cffFF001E/"..color..getCombatTime().."|cffFF001E/|cffFFFFFF"..spellName, toolTip = "|cffFF001ERoll Mouse to Scroll Rows"..debugSource.." "..debugdest.." "..debugSpell.." "..Power })
						if #debugTable > 49 then
							tremove(debugTable,50)
						end
						badboyFrameRefresh("debug")
					end
        		end

           		if param == "SPELL_CAST_FAILED" then
        			local lasterror, destGUID, distance, power = lasterror, destGUID, distance, power
        			local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName = ...
           			if SpellID ~= 75 and SpellID ~= 88263 then -- Add spells we dont want to appear here.
						local color = "|cffFF001E"
                        if BadBoy_data.failCasts == nil then
                            BadBoy_data.failCasts = 0
                        end
        				if spellCastTarget == UnitName("target") then
        					destGUID = UnitGUID("target")
        					Distance = targetDistance
        				end
        				if lastError and lastErrorTime >= GetTime() - 0.2 then
        					lasterror = "\n|cffFF0000 "..lastError
        				else
        					lasterror = ""
        				end
        				BadBoy_data.failCasts = BadBoy_data.failCasts + 1
        				if sourceGUID == nil then
        					debugSource = ""
        				else
        					debugSource = "\n|cff12C8FF"..sourceName..sourceGUID
        				end
        				if spellID == nil then
        					debugSpell = ""
        				else
        					debugSpell = "\n|cffFFDD11"..spellID..spellName
        				end
         				local Power = "\n|cffFFFFFFPower: "..UnitPower("player")
         				if getOptionCheck("Display Failcasts") == true then
        					tinsert(debugTable,1,{textString = BadBoy_data.failCasts.."|cffFF001E/"..color..getCombatTime().."|cffFF001E/|cffFFFFFF"..spellName, toolTip = "|cffFF001ERoll Mouse to Scroll Rows"..debugSource.." "..debugSpell.." "..Power.." "..lasterror })
						end
						if #debugTable > 49 then
							tremove(debugTable,50)
						end
						badboyFrameRefresh("debug")
					end
        		end
        	end
        end
    end

	-------------------------------------------------
	--[[ SpellCast Sents (used to define target) --]]
	if event == "UNIT_SPELLCAST_SENT" then
		spellCastTarget = select(4,...)
		--print("UNIT_SPELLCAST_SENT spellCastTarget = "..spellCastTarget)
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
		end
	end

	--------------------------
	--[[ SpellCast Failed --]]
	if event == "UNIT_SPELLCAST_FAILED" then
		local SourceUnit 	= select(1,...)
		local SpellID 		= select(5,...)
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
end

superReaderFrame:SetScript("OnEvent", SuperReader)

end