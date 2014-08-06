function ReaderRun()

-- Return Time in minuts/seconds.
local function GetTimeString()
	local TimeString = nil;
	TimeString = tostring(math.floor(GetTime()*100)/100);
	return TimeString
end

------------------
-- Super Reader	--
------------------
superReaderFrame = CreateFrame('Frame');
superReaderFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
superReaderFrame:RegisterEvent("PLAYER_TALENT_UPDATE");
superReaderFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
superReaderFrame:RegisterEvent("PLAYER_TOTEM_UPDATE");
superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SENT");
superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
superReaderFrame:RegisterEvent("UNIT_SPELLCAST_FAILED");
superReaderFrame:RegisterEvent("UI_ERROR_MESSAGE");
superReaderFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
superReaderFrame:RegisterEvent("CHARACTER_POINTS_CHANGED");
superReaderFrame:RegisterEvent("SPELLS_CHANGED");
superReaderFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
function SuperReader(self, event, ...)

	if event == "PLAYER_TALENT_UPDATE" then
		currentConfig = nil;
	end
	if event == "ACTIVE_TALENT_GROUP_CHANGED" then
		currentConfig = nil;
	end

	------------------------------------------
	-- Get Combat Time
	if event == "PLAYER_REGEN_DISABLED" then
		BadBoy_data["Combat Started"] = GetTime();
		ChatOverlay("Entering Combat");
		healthFrame.Border:SetTexture([[Interface\FullScreenTextures\LowHealth]],0.25);
	end
	if event == "PLAYER_REGEN_ENABLED" then
		BadBoy_data["Combat Started"] = 0;
		ChatOverlay("Leaving Combat");
		healthFrame.Border:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]],0.25);
		-- clean up out of combat
        Rip_sDamage = {}
        Rake_sDamage = {}
        Thrash_sDamage = {}
	end


	------------------------------------------
	-- Spells changed // reload configs	
	--if event == "CHARACTER_POINTS_CHANGED" or event == "SPELLS_CHANGED" then
	--	FeralCatConfig();
	--	ChatOverlay("Config Updated");
	--end

    Rip_sDamage = Rip_sDamage or {}
    Rake_sDamage = Rake_sDamage or {}
    --Thrash_sDamage = Thrash_sDamage or {}
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    	
    	local param 		= select(2,...);
		local source 		= select(4,...);
		local sourceName	= select(5,...)
		local spell 		= select(12,...);
        local destination 	= select(8,...);

        -------------------------------------------
        --- Debug ---------------------------------
        if source == UnitGUID("player") and (param == "SPELL_CAST_SUCCESS" or param == "SPELL_CAST_FAILED") and BadBoy_data["Check Debug"] == 1 
          and SpellID ~= 75 and SpellID ~= 88263 then -- Add spells we dont want to appear here.
			if debugTable == nil then debugTable = { }; end
        	local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName = ...;
        	local color = "";
        	if param == "SPELL_CAST_SUCCESS" then color = "|cff12C8FF"; else color = "|cffFF001E"; end
        	tinsert(debugTable, 1, { textString = color..string.sub(timeStamp,8).."|cffFF001E/|cffFFFFFF"..spellName , sourceguid = sourceGUID, sourcename = sourceName, spellid = spellID, spellname = spellName, destguid = destGUID, destname = destName })
			if #debugTable > 99 then tremove(debugTable, 100); end
			if BadBoy_data.ActualRow == 0 then debugRefresh(); end
        end


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
        if source == UnitGUID("player") and param == "SPELL_SUMMON" then
        	activeTotem = destination;
        end
        if activeTotem == destination and param == "UNIT_DESTROYED" then
        	activeTotem = nil;
        end
    end

	------------------------------------------
	-- SpellCast Sents (used to define target)
	if event == "UNIT_SPELLCAST_SENT" then
		spellCastTarget = select(4,...);
		--print("UNIT_SPELLCAST_SENT spellCastTarget = "..spellCastTarget);
	end

	----------------------
	-- SpellCast Succeeded
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

	----------------------
	-- SpellCast Failed
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


	----------------------
	-- UI ERROR MESSAGE
	if event == "UI_ERROR_MESSAGE" then
	  	local Events = (...)
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
	end



	if event == "ACTIVE_TALENT_GROUP_CHANGED" then
		BadBoy_data.playerSpec = GetSpecialization("player");
	end
end

superReaderFrame:SetScript("OnEvent", SuperReader)



----------------
-- Poke Setup --
----------------
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
local class = select(2,UnitClass("player"))
local waitTimerForTransformation = 0.5
local numDruidFormZeroFires = 0

if race == "Worgen" then

	EventFrame = CreateFrame( "Frame", nil, UIParent )
	
	EventFrame:RegisterEvent( "PLAYER_REGEN_ENABLED" )
	EventFrame:RegisterEvent( "PET_ATTACK_STOP" )
	EventFrame:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" )

	-- add shapeshift event for druids
	if( class == "DRUID" ) then
		EventFrame:RegisterEvent( "UPDATE_SHAPESHIFT_FORM" )
	end
	
	-- Function: OnEvent
	EventFrame:SetScript( "OnEvent", function( self, e, ... )
		if EventFrame.HasTwoFormsBeenDetected then		
			local _,SubEvent,SourceGUID,_,_,_,_,_,SpellID,_,_,EventMessage = ...;

			-- if running wild cast is cancelled
			if e == "COMBAT_LOG_EVENT_UNFILTERED" and SourceGUID == UnitGUID( "player" ) and SubEvent == "SPELL_CAST_FAILED" and SpellID == 87840 and EventMessage == SPELL_FAILED_INTERRUPTED then
				self.IsTransformationPending = true
				self.isTransformationDone = false
			end
			
			-- if shapeshift form is updated ( 0 = Humanoid, 1 through 5/6 are animal forms)
			if( e == "UPDATE_SHAPESHIFT_FORM" and class == "DRUID" ) then 
			
				if( GetShapeshiftForm() == 0 ) then
					numDruidFormZeroFires = numDruidFormZeroFires + 1
					
					if ( numDruidFormZeroFires >= 2 ) then
						numDruidFormZeroFires = 0
						self.IsTransformationPending = true
						self.isTransformationDone = false
					end
				else
					numDruidFormZeroFires = 0
					waitTimerForTransformation = 0
					self.IsTransformationPending = false
				end
			end

			-- if player enters rested state OR pet attack stops OR running wild/darkflight ends
			if not self.isTransformationDone and ( e == "PLAYER_REGEN_ENABLED" or e == "PET_ATTACK_STOP" or ( ( e == "COMBAT_LOG_EVENT_UNFILTERED" and SourceGUID == UnitGUID( "player" ) ) and ( ( SubEvent == "SPELL_AURA_REMOVED" and SpellID == 68992 ) or ( SubEvent == "SPELL_AURA_REMOVED" and SpellID == 87840 ) ) ) ) then
				
				if( class ~= "DRUID" or ( class == "DRUID" and GetShapeshiftForm() == 0 ) ) then
					self.IsTransformationPending = true
					self.isTransformationDone = false
				end
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
			
			if( class ~= "DRUID" or ( class == "DRUID" and GetShapeshiftForm() == 0 ) ) then
				if isChecked("Worgen/Human") then castSpell("player",68996,true) end
			end

			self.isTransformationDone = true
			self.IsTransformationPending = false
			waitTimerForTransformation = 0
				
		else
			if not isTransformationUnlocked then
				self.isTransformationDone = false
			end
		end
	end );
end