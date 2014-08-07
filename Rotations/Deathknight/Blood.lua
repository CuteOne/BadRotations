if select(3, UnitClass("player")) == 6 then
function Blood()
	--ChatOverlay(getNumEnnemies("player",10))
	if AoEModesLoaded ~= "Blood DK AoE Modes" then
		BloodOptions();
		BloodToggles();
	end

	-- Locals
	local runicPower = UnitPower("player");
	local runesBlood = getRunes("blood");
	local runesUnholy = getRunes("unholy");
	local runesFrost = getRunes("frost");
	local runesDeath = getRunes("death");

	local numEnnemies = numEnnemies;
	local meleeEnnemies = getNumEnnemies("player",4);
	if getDistance("player","target") < 5 then
		numEnnemies = getNumEnnemies("target",10);
	else
		numEnnemies = getNumEnnemies("player",10);
	end

	-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then return false; end

	if UnitAffectingCombat("player") then
		-- Mind Freeze
		-- Rebuke
		if isChecked("MindFreeze") then
			if canInterrupt(_MindFreeze, value("Mind Freeze")) and getDistance("player","target") <= 4 then
				castSpell("target",_MindFreeze,false);
			end
		end

    	-- Anti Magic Shell
    	if getHP("player") <= getValue("Anti-Magic Shell") then
    		if castSpell("player",_AntiMagicShell,true) then return; end
    	end

    	-- Dancing Rune Weapon
    	if getHP("player") <= getValue("Dancing Rune Weapon") then
    		if castSpell("player",_DancingRuneWeapon,true) then return; end
    	end

    	-- Conversion
        if getHP("player") <= getValue("Conversion") then
    		if castSpell("player",_Conversion,true) then return; end
    	end

    	-- Vampiric Blood
        if getHP("player") <= getValue("Vampiric Blood") then
    		if castSpell("player",_VampiricBlood,true) then return; end
    	end

    	-- Icebound Fortitude
        if getHP("player") <= getValue("Icebound Fortitude") then
    		if castSpell("player",_IceboundFortitude,true) then return; end
    	end

    	-- Rune Tap
        if getHP("player") <= getValue("Rune Tap") then
    		if castSpell("player",_RuneTap,true) then return; end
    	end

    	-- Empower Rune Weapon
        if getHP("player") <= getValue("Empower Rune Weapon") then
    		if castSpell("player",_EmpowerRuneWeapon,true) then return; end
    	end
	end


	if isCasting() then return false; end

    -- Blood Presence
    if UnitLevel("player") >= 57 then
    	if UnitBuffID("player",_BloodPresence) == nil then
    		if castSpell("player",_BloodPresence,true) then return; end
    	end
    end

	-- Horn of Winter
	if castSpell("player",_HornOfWinter,true) then return; end

	if isInCombat("player") and isAlive() and isEnnemy() then




		-- Raise Dead
		if isSelected("Raise Dead") then
			if castSpell("player",_RaiseDead,true) then return; end
		end

    	-- Bone Shield
    	if isChecked("Bone Shield") and UnitBuffID("player",_BoneShield) == nil then
    		if castSpell("player",_BoneShield,true) then return; end
    	end

    	-- Death and Decay
		if isSelected("Death And Decay") and (getRunes("unholy") >= 1 or getRunes("death") >= 1) then
			if getGround("target") == true and UnitExists("target") and ((isDummy("target") and getDistance("target","targettarget") <= 10) or getDistance("target","targettarget") <= 20) then
				if castGroundBetween("target",_DeathAndDecay,30) then return; end
			end
		end    	

	    -- Blood Tap
	    if getBuffStacks("player",114851) >= 5 and canTap() then
	    	if castSpell("player",_BloodTap,true) then return; end
	    end


--[[	-- When pulling, you’ll want to apply diseases using Outbreak. 
		
		-- Then you can Heart Strike with both Blood Runes, and use Death Strike to take advantage of the Death Strike mechanics (healing for damage taken in preceding 5 sec).

		-- You’ll want to keep diseases active at all times. 
		-- The most efficient way to refresh your diseases is with Blood Boil thanks to Scarlet Fever. 
		-- However, if a disease expires, refresh the disease via Outbreak. 
		-- If Outbreak is on cooldown, then use Icy Touch and/or Plague Strike.

		-- Beyond diseases, you’ll want to Death Strike as much as possible with your Frost, Unholy, and Death Runes. 
		-- Use Heart Strike with Blood Runes, and Rune Strike whenever all Runes are depleted or when you are capped with Runic Power. 
		-- Soul Reaper replaces Heart Strike when your target has 35% or less Health.

]]

	    -- Rune Strike//Death Coil
	    if runicPower >= 90 then
	    	if isKnown(_RuneStrike) then
	    		if castSpell("target",_RuneStrike,false) then return; end
	   		else
	   			-- Death Coil
	    		if castSpell("target",_DeathCoil,false) then return; end
	    	end
	    end

	    -- Pestilence
	    if runesBlood >= 1 then
			if canCast(_Pestilence) then
				if getDebuffRemain("target",55078) == 0 then
					for i = 1, GetTotalObjects(TYPE_UNIT) do
						local Guid = IGetObjectListEntry(i)
						ISetAsUnitID(Guid,"thisUnit");
						if getDebuffRemain("thisUnit",55078,"player") >= 2 and getFacingSightDistance("player","thisUnit") <= 10 then
							if castSpell("thisUnit",_Pestilence,true) then return; end								
						end
					end	
				end
			end
	    end

	    -- Outbreak
	    if UnitDebuffID("target",55095,"player") == nil then
	    	if castSpell("target",_Outbreak,false) then return; end
	    end

	    -- Icy Touch
	    if (runesFrost >= 1 or runesDeath >= 1) and getDebuffRemain("target",55095) < 4 then
		    --if castSpell("target",_IcyTouch,false) then return; end
	    end

	    -- Plague Strike
	    if (runesUnholy >= 1 or runesDeath >= 1) and getDebuffRemain("target",55078) < 4 then
	    	if castSpell("target",_PlagueStrike,false) then return; end
	    end

	    local numEnnemies = getNumEnnemies("target", 10)

	    -- Pestilence
	    if numEnnemies > 2 and runesBlood >= 1 then
			if canCast(_Pestilence) then
				if getDebuffRemain("target",55078,"player") >= 2 then
					for i = 1, GetTotalObjects(TYPE_UNIT) do
						local Guid = IGetObjectListEntry(i)
						ISetAsUnitID(Guid,"thisUnit");
						if getDistance("target",thisUnit) <= 5 then
							if castSpell("target",_Pestilence,true) then return; end								
						end
					end	
				end
			end
	    end


	    -- Blood Boil
	    if targetDistance <= 5 and runesBlood > 1 and (getDebuffRemain("target",55078,"player") < 6 or numEnnemies >= 3) then
	    	if castSpell("player",_BloodBoil,true) then return; end
	    end

	    -- Heart Strike//Blood Strike
	    if runesBlood > 1 or runesDeath > 1 then
	    	if isKnown(_HeartStrike) then
	    		if castSpell("target",_HeartStrike,false) then return; end
	    	else
	    		if castSpell("target",_BloodStrike,false) then return; end
	    	end
	    end

	    -- Death Strike
	    if (runesFrost >= 1 and runesUnholy >= 1) 
	      or (runesFrost >= 1 and runesDeath >= 1)
	      or (runesDeath >= 1 and runesUnholy >= 1)
	      or (runesDeath >= 2) then
	    	if castSpell("target",_DeathStrike,false) then return; end
	    end
	   
	    -- Blood Boil
	    if targetDistance <= 5 and UnitBuffID("player",81141) ~= nil then
	    	if castSpell("player",_BloodBoil,true) then return; end
	    end

	    -- Icy Touch
	    if runesFrost > 1 then
	    	if castSpell("target",_IcyTouch,false) then return; end
	    end

	    -- Soul Reaper
	    if getHP("target") < 35 then
	    	if castSpell("target",_SoulReaper,false) then return; end
	    end

	    -- Rune Strike//Death Coil
	    if runicPower >= 40 then
		    if isKnown(_RuneStrike) then
		    	if castSpell("target",_RuneStrike,false) then return; end
		    else
		    	if castSpell("target",_DeathCoil,false) then return; end
		    end
		end

	    -- Horn of Winter
	    if UnitBuffID("player",_HornOfWinter) == nil then
	    	if castSpell("player",_HornOfWinter,true) then return; end
	    end

		--ChatOverlay("A L'ATTAQUE");

	end
end
end




