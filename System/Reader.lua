function ReaderRun()
---------------
--[[ Readers ]]
---------------

-- Vars
if AgiSnap == nil then AgiSnap = 0; end

-------------------
--[[ Auto Join --]]
local Frame = CreateFrame('Frame');
Frame:RegisterEvent("LFG_PROPOSAL_SHOW");
local function MerchantShow(self, event, ...)
	if isChecked("Accept Queues") == true then
		if event == "LFG_PROPOSAL_SHOW" then
			AcceptProposal()
		end
	end
end
Frame:SetScript("OnEvent", MerchantShow);

--------------------------
--[[ isStanding Frame --]]
DontMoveStartTime = nil;
CreateFrame("Frame"):SetScript("OnUpdate", function ()
	if GetUnitSpeed("Player") == 0 then
		if not DontMoveStartTime then
			DontMoveStartTime = GetTime();
		end
	else
		DontMoveStartTime = nil;
	end
end);

-----------------------
--[[ Merchant Show --]]
local Frame = CreateFrame('Frame');
Frame:RegisterEvent("MERCHANT_SHOW");
local function MerchantShow(self, event, ...)
	if event == "MERCHANT_SHOW" then
		if isChecked("Auto-Sell/Repair") == true then
			SellGreys();
		end
	end
end
Frame:SetScript("OnEvent", MerchantShow);

-------------------------
--[[ Entering Combat --]]
local Frame = CreateFrame('Frame');
Frame:RegisterEvent("PLAYER_REGEN_DISABLED");
local function EnteringCombat(self, event, ...)
	if event == "PLAYER_REGEN_DISABLED" then
		AgiSnap = getAgility();
		BadBoy_data["Combat Started"] = GetTime();
		--tinsert(debugTable, 1, { textString = BadBoy_data.successCasts.."|cffFF001E/"..getCombatTime().."/Entering Combat" , number = ":D" })
		if debugTable ~= nil and #debugTable > 249 then tremove(debugTable, 250); end
		if debugRefresh ~= nil and BadBoy_data.ActualRow == 0 then debugRefresh(); end
		ChatOverlay("|cffFF0000Entering Combat");
	end
end
Frame:SetScript("OnEvent", EnteringCombat);

-----------------------
--[[ Leving Combat --]]
local Frame = CreateFrame('Frame');
Frame:RegisterEvent("PLAYER_REGEN_ENABLED");
local function LeavingCombat(self, event, ...)
	if event == "PLAYER_REGEN_ENABLED" then
		AgiSnap = 0;
		BadBoy_data.successCasts = 0;
		BadBoy_data.failCasts = 0;
		BadBoy_data["Combat Started"] = 0;
		--tinsert(debugTable, 1, { textString = BadBoy_data.successCasts.."|cff12C8FF/"..getCombatTime().."/Leaving Combat" , number = ":D" })
		if #debugTable > 249 then tremove(debugTable, 250); end
		if BadBoy_data.ActualRow == 0 then debugRefresh(); end
		ChatOverlay("|cffFF0000Leaving Combat");
		-- clean up out of combat
        Rip_sDamage = {}
        Rake_sDamage = {}
        Thrash_sDamage = {}
	end
end
Frame:SetScript("OnEvent", LeavingCombat);

---------------------------
--[[ UI Error Messages --]]
local Frame = CreateFrame('Frame');
Frame:RegisterEvent("UI_ERROR_MESSAGE");
local function UiErrorMessages(self, event, ...)
	if event == "UI_ERROR_MESSAGE" then 
		lastError = ...; lastErrorTime = GetTime(); 
	  	local Events = (...)
	  	local msg = select(1, ...)
	  	-- print(...)
	  	if Events == ERR_PET_SPELL_DEAD  then
			BadBoy_data["Pet Dead"] = true;
			BadBoy_data["Pet Whistle"] = false;
		end
		if Events == PETTAME_NOTDEAD.. "." then
			BadBoy_data["Pet Dead"] = false;
			BadBoy_data["Pet Whistle"] = true;
		end
		if Events == SPELL_FAILED_ALREADY_HAVE_PET then
			BadBoy_data["Pet Dead"] = true;
			BadBoy_data["Pet Whistle"] = false;
		end
		if Events == PETTAME_CANTCONTROLEXOTIC.. "." then
			if BadBoy_data["Box PetManager"] < 5 then
				BadBoy_data["Box PetManager"] = BadBoy_data["Box PetManager"] + 1;
			else
				BadBoy_data["Box PetManager"] = 1;
			end
		end
		if Events == PETTAME_NOPETAVAILABLE.. "." then
			BadBoy_data["Pet Dead"] = false;
			BadBoy_data["Pet Whistle"] = true;
		end
		if Events == SPELL_FAILED_TARGET_NO_POCKETS then
			BadBoy_data["Pickpocket"] = false;
		end
		if Events == ERR_ALREADY_PICKPOCKETED then
			BadBoy_data["Pickpocket"] = false;
		end
		if Events == ERR_NO_LOOT then
			BadBoy_data["Pickpocket"] = false
		end
	end
end
Frame:SetScript("OnEvent", UiErrorMessages)

------------------------
--[[ Spells Changed --]]
local Frame = CreateFrame('Frame');
Frame:RegisterEvent("PLAYER_TALENT_UPDATE");
Frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
Frame:RegisterEvent("CHARACTER_POINTS_CHANGED");
Frame:RegisterEvent("SPELLS_CHANGED");
local function SpellsChanged(self, event, ...)
	if event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "CHARACTER_POINTS_CHANGED" or event == "SPELLS_CHANGED" then
		currentConfig = nil;
	end
end
Frame:SetScript("OnEvent", SpellsChanged)


---------------------------
--[[ Combat Log Reader --]]
local superReaderFrame = CreateFrame('Frame');
superReaderFrame:RegisterEvent("PLAYER_TOTEM_UPDATE");
superReaderFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SENT");
superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
superReaderFrame:RegisterEvent("UNIT_SPELLCAST_FAILED");
function SuperReader(self, event, ...)
	if friendlyDot == nil then friendlyDot = { }; end
    if debugTable == nil then debugTable = { }; end

    if select(3, UnitClass("player")) == 11 then Rip_sDamage = Rip_sDamage or {}; Rake_sDamage = Rake_sDamage or {}; end
    --Thrash_sDamage = Thrash_sDamage or {}
	
    
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then

    	local timestamp 	= select(1,...);
    	local param 		= select(2,...);
		local source 		= select(4,...);
		local sourceName	= select(5,...);
        local destination 	= select(8,...);
		local spell 		= select(12,...);

		------------------------
		--[[ Debuff/Rejuv --]]
		if param == "SPELL_PERIODIC_DAMAGE" then
			ISetAsUnitID(destination,"poorguy");
			if UnitIsFriend("player","poorguy") then
				friendlyDot[destination] = GetTime();
				--print(UnitName("poorguy"))
			end
		end

		------------------------
		--[[ Bleed Recorder --]]
		if select(3, UnitClass("player")) == 11 and GetSpecialization("player") == 2 then
	        --print(param..", "..source..", "..spell)
	        -- snapshot on spellcast
	        if source == UnitGUID("player") and param == "SPELL_CAST_SUCCESS" then
	            if spell == 1079 then
	                Rip_sDamage_cast = CRPD()
	            elseif spell == 1822 then
	                Rake_sDamage_cast = CRKD()
	            --elseif spell == 106830 then
	            --    WA_calcStats_feral()
	            --    Thrash_sDamage_cast = WA_stats_ThrashTick
	            end
	            
	            -- but only record the snapshot if it successfully applied
	        elseif source == UnitGUID("player") and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") then
	            --print(source..", "..spell..", "..destination)
	            if spell == 1079 then
	                Rip_sDamage[destination] = Rip_sDamage_cast

	            elseif spell == 1822 then
	                Rake_sDamage[destination] = Rake_sDamage_cast
	            --elseif spell == 106830 then
	           --     Thrash_sDamage[destination] = Thrash_sDamage_cast
	            end
	        end
	    end

        --------------------
        --[[ Fire Totem --]] 
        if source == UnitGUID("player") and  param == "SPELL_SUMMON" and (spell == _SearingTotem or spell == _MagmaTotem) then
        	activeTotem = destination;
        end
        if param == "UNIT_DESTROYED" and activeTotem == destination then
        	activeTotem = nil;
        end

        -----------------------
        --[[ Wild Mushroom --]]
        if source == UnitGUID("player") and  param == "SPELL_SUMMON" and (spell == 147349 or spell == 145205) then
        	if shroomsTable == nil then shroomsTable = { } end
        	if shroomsTable[destination] == nil then
        		shroomsTable[1] = destination;
        	end
        end
        if (param == "UNIT_DIED" or  param == "UNIT_DESTROYED") and shroomsTable ~= nil and shroomsTable[1] == destination then
        	shroomsTable = { };
        end        

        ---------------
        --[[ Debug --]]
        if BadBoy_data["Check Debug"] == 1 then
        	if source == UnitGUID("player") then
        		if param == "SPELL_CAST_SUCCESS" then
        			local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName = ...;
        			if SpellID ~= 75 and SpellID ~= 88263 then -- Add spells we dont want to appear here.
        				local color = "|cff12C8FF";
        				BadBoy_data.successCasts = BadBoy_data.successCasts + 1;
        				if sourceGUID == nil then debugSource = "" 	else debugSource = 	"\n|cffFFFFFF"..sourceName.." "..sourceGUID; end
        				if spellID == nil then debugSpell = "" 		else debugSpell = 	"\n|cffFFDD11"..spellName.." "..spellID; end
        				if currentTarget ~= nil then ISetAsUnitID(currentTarget,"castUnit"); targetName = UnitName("castUnit"); end
        				if currentTarget == nil then targetUnit = "" else targetUnit = 	"\n|cffFFDD11"..targetName.." "..currentTarget; end
        				local Power = "\n|cffFFFFFFPower: "..UnitPower("player");
        				tinsert(debugTable, 1, { textString = BadBoy_data.successCasts.."|cffFF001E/"..color..getCombatTime().."|cffFF001E/|cffFFFFFF"..spellName, toolTip = "|cffFF001ERoll Mouse to Scroll Rows"..debugSource.." "..debugSpell.." "..Power..targetUnit });
						if #debugTable > 249 then tremove(debugTable, 250); end
						if BadBoy_data.ActualRow == 0 and debugRefresh ~= nil then debugRefresh(); end
					end
        		end

           		if param == "SPELL_CAST_FAILED" then
        			local lasterror, destGUID, distance, power = lasterror, destGUID, distance, power;
        			local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName = ...;
           			if SpellID ~= 75 and SpellID ~= 88263 then -- Add spells we dont want to appear here.
						local color = "|cffFF001E";
        				if spellCastTarget == UnitName("target") then 
        					destGUID = UnitGUID("target"); 
        					Distance = targetDistance;
        				end
        				if lastError and lastErrorTime >= GetTime() - 0.2 then lasterror = "\n|cffFF0000 "..lastError; else lasterror = ""; end
        				BadBoy_data.failCasts = BadBoy_data.failCasts + 1;	
        				if sourceGUID == nil then debugSource = "" 	else debugSource = 	"\n|cffFFFFFF"..sourceName..sourceGUID; end
        				if spellID == nil then debugSpell = "" 		else debugSpell = 	"\n|cffFFDD11"..spellID..spellName; end
        				if currentTarget ~= nil then ISetAsUnitID(currentTarget,"castUnit"); targetName = UnitName("castUnit"); end
        				if currentTarget == nil then targetUnit = "" else targetUnit = 	"\n|cffFFDD11"..targetName.." "..currentTarget; end
         				local Power = "\n|cffFFFFFFPower: "..UnitPower("player");
        				tinsert(debugTable, 1, { textString = BadBoy_data.failCasts.."|cffFF001E/"..color..getCombatTime().."|cffFF001E/|cffFFFFFF"..spellName, toolTip = "|cffFF001ERoll Mouse to Scroll Rows"..debugSource.." "..debugSpell.." "..Power.." "..lasterror..targetUnit });
						if #debugTable > 249 then tremove(debugTable, 250); end
						if BadBoy_data.ActualRow == 0 and debugRefresh ~= nil then debugRefresh(); end
					end
        		end
        	end
        end
    end

	-------------------------------------------------
	--[[ SpellCast Sents (used to define target) --]]
	if event == "UNIT_SPELLCAST_SENT" then
		spellCastTarget = select(4,...);
		--print("UNIT_SPELLCAST_SENT spellCastTarget = "..spellCastTarget);
	end

	-----------------------------
	--[[ SpellCast Succeeded --]]
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local SourceUnit 	= select(1,...);
		local SpellID 		= select(5,...);
		if SourceUnit == "player" then

			local MyClass = UnitClass("player");

			-- Hunter
			if MyClass == 3 then
				-- Serpent Sting
				if SpellID == 1978 then
					LastSerpent = GetTime();
					LastSerpentTarget = spellCastTarget;
				end
				-- Steady Shot Logic
				if SpellID == 56641 then
					if SteadyCast and SteadyCast >= GetTime() - 2 and SteadyCount == 1 then SteadyCast = GetTime(); SteadyCount = 2; else SteadyCast = GetTime(); SteadyCount = 1; end
				end	
				-- Focus Generation
				if SpellID == 77767 then
					focusBuilt = GetTime();
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
end

superReaderFrame:SetScript("OnEvent", SuperReader)



--------------------
--[[ Poke Setup --]]
pokeEngineFrame = CreateFrame('Frame');
pokeEngineFrame:RegisterEvent("CHAT_MSG_PET_BATTLE_COMBAT_LOG");
function PokeReader(self, event, ...)
	-- print("Round 6")
end
pokeEngineFrame:SetScript("OnEvent", PokeReader);
--CHAT_MSG_PET_BATTLE_COMBAT_LOG → ?
--CHAT_MSG_PET_BATTLE_INFO → ?
--CHAT_MSG_PET_INFO → Communication

end

local waitTimeBeforeTransform = 1.5
local EventFrame
local race = select(2,UnitRace("player"))
local class = select(3,UnitClass("player"))
local waitTimerForTransformation = 0.5
local numDruidFormZeroFires = 0

if race == "Worgen" and class ~= 11 then

	EventFrame = CreateFrame( "Frame", nil, UIParent )
	
	EventFrame:RegisterEvent( "PLAYER_REGEN_ENABLED" )
	EventFrame:RegisterEvent( "PET_ATTACK_STOP" )
	EventFrame:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" )

	-- Function: OnEvent
	EventFrame:SetScript( "OnEvent", function( self, e, ... )
		if EventFrame.HasTwoFormsBeenDetected then		
			local _,SubEvent,SourceGUID,_,_,_,_,_,SpellID,_,_,EventMessage = ...;

			-- if running wild cast is cancelled
			if e == "COMBAT_LOG_EVENT_UNFILTERED" and SourceGUID == UnitGUID( "player" ) and SubEvent == "SPELL_CAST_FAILED" and SpellID == 87840 and EventMessage == SPELL_FAILED_INTERRUPTED then
				self.IsTransformationPending = true
				self.isTransformationDone = false
			end
			
			-- if player enters rested state OR pet attack stops OR running wild/darkflight ends
			if not self.isTransformationDone and ( e == "PLAYER_REGEN_ENABLED" or e == "PET_ATTACK_STOP" or ( ( e == "COMBAT_LOG_EVENT_UNFILTERED" and SourceGUID == UnitGUID( "player" ) ) and ( ( SubEvent == "SPELL_AURA_REMOVED" and SpellID == 68992 ) or ( SubEvent == "SPELL_AURA_REMOVED" and SpellID == 87840 ) ) ) ) then
				self.IsTransformationPending = true
				self.isTransformationDone = false
			end
		end
	end );
	

	-- Function: OnUpdate
	EventFrame:SetScript( "OnUpdate", function( self, e, ... )
		local isTransformationUnlocked = true

		self.HasTwoFormsBeenDetected = ( self.HasTwoFormsBeenDetected or isTransformationUnlocked )
		
		if self.IsTransformationPending and self.isTransformationDone then 
			self.IsTransformationPending = false
		end

		if isTransformationUnlocked and self.IsTransformationPending and not self.isTransformationDone then
			if waitTimerForTransformation <= 0 then
				waitTimerForTransformation = GetTime() + waitTimeBeforeTransform
			end
		end

		if isTransformationUnlocked and waitTimerForTransformation ~= 0 and waitTimerForTransformation <= GetTime() and not self.isTransformationDone then

			if isChecked("Worgen/Human") then castSpell("player",68996,true) end
			self.isTransformationDone = true
			self.IsTransformationPending = false
			waitTimerForTransformation = 0
				
		else
			if not isTransformationUnlocked then
				self.isTransformationDone = false
			end
		end
	end);
end