if select(3, UnitClass("player")) == 6 then
function Blood()
	--ChatOverlay(getNumEnemies("player",10))
	if AoEModesLoaded ~= "Blood DK AoE Modes" then
		BloodOptions();
		BloodToggles();
	end

	-- Locals
	local runicPower, runesBlood, runesUnholy, runesFrost, runesDeath = UnitPower("player"), getRunes("blood"), getRunes("unholy"), getRunes("frost"), getRunes("death")

	-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then return false; end

	if UnitAffectingCombat("player") then

		-- Mind Freeze
		if isChecked("Mind Freeze") == true and targetDistance <= 4 then
			if canInterrupt(_MindFreeze, getValue("Mind Freeze")) then
				castSpell("target",_MindFreeze,false);
			end
		end

    	-- Anti Magic Shell
    	if isChecked("Anti-Magic Shell") == true and getHP("player") <= getValue("Anti-Magic Shell") and targetDistance <= 20 then
    		if castSpell("player",_AntiMagicShell,true) then return; end
    	end

    	-- Dancing Rune Weapon
    	if isChecked("Dancing Rune Weapon") == true and getHP("player") <= getValue("Dancing Rune Weapon") then
    		if castSpell("player",_DancingRuneWeapon,true) then return; end
    	end

    	-- Conversion
        if isChecked("Conversion") == true and getHP("player") <= getValue("Conversion") then
    		if castSpell("player",_Conversion,true) then return; end
    	end

    	-- Vampiric Blood
        if isChecked("Vampiric Blood") == true and getHP("player") <= getValue("Vampiric Blood") then
    		if castSpell("player",_VampiricBlood,true) then return; end
    	end

    	-- Icebound Fortitude
        if isChecked("Icebound Fortitude") == true and getHP("player") <= getValue("Icebound Fortitude") then
    		if castSpell("player",_IceboundFortitude,true) then return; end
    	end

    	-- Rune Tap
        if isChecked("Rune Tap") == true and getHP("player") <= getValue("Rune Tap") then
    		if castSpell("player",_RuneTap,true) then return; end
    	end

    	-- Empower Rune Weapon
        if isChecked("Empower Rune Weapon") == true and getHP("player") <= getValue("Empower Rune Weapon") then
    		if castSpell("player",_EmpowerRuneWeapon,true) then return; end
    	end
	end


	if castingUnit() or getSpellCD(61304) > 0 then return false; end

    -- Presence
    if isKnown(_BloodPresence) and isChecked("Presence") then
    	if getValue("Presence") == 1 and UnitBuffID("player",_BloodPresence) == nil then
    		if castSpell("player",_BloodPresence,true) then return; end
    	elseif getValue("Presence") == 2 and UnitBuffID("player",_FrostPresence) == nil then
    		if castSpell("player",_FrostPresence,true) then return; end
    	end
    elseif isChecked("Frost Presence") then
    	if getValue("Presence") == 2 and UnitBuffID("player",_FrostPresence) == nil then
    		if castSpell("player",_FrostPresence,true) then return; end
    	end
    end

	-- Horn of Winter
	if getBuffRemain("player",_HornOfWinter) <= 4 then
		if castSpell("player",_HornOfWinter,true) then return; end
	end

	if isInCombat("player") and isAlive() and (isEnnemy() or isDummy("target")) then

	    -- Death Siphon
	    if runesDeath >= 1 and getHP("player") <= getValue("Death Siphon") then
	    	if castSpell("target",_DeathSiphon,false) then return; end
	    end

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

	    -- Runic Dump
	    if runicPower >= 90 then
	    	if targetDistance < 40 then
	   			-- Death Coil
	    		if castSpell("target",_DeathCoil,false) then return; end
	    	end
	    end

	    if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
	    	meleeEnemies, ScanTimer = getNumEnemies("player",10), GetTime();
	    end

	    -- Blood Boil - Refresh
	    if targetDistance <= 5 and (runesBlood >= 1 or runesDeath >= 1) and ((UnitDebuffID("target",55078,"player") ~= nil and getDebuffRemain("target",55078,"player") < 6)) then
	    	if castSpell("player",_BloodBoil,true) then return; end
	    end

	    -- Outbreak
	    if targetDistance <= 5 and UnitDebuffID("target",55078,"player") == nil then
	    	if castSpell("target",_Outbreak,false) then return; end
	    end

	    -- Plague Strike
	    if targetDistance <= 5 and (runesUnholy >= 1 or runesDeath >= 1) and getDebuffRemain("target",55078,"player") < 4 then
	    	if castSpell("target",_PlagueStrike,false) then return; end
	    end

	    -- Icy Touch
	    if (runesFrost >= 1 or (runesDeath >= 1 and getDebuffRemain("target",55078,"player") > 4)) and getDebuffRemain("target",55095) < 4 then
		    if castSpell("target",_IcyTouch,false) then return; end
	    end

	    -- Pestilence/Rolling Blood - Spread Diseases
	    -- Here i do my target checks and i make sure i want to iterate. I use canCadt prior to everything just to save power, i dont want to scan if that spell is not ready, i dont have energy or in my case if there are no diseases on my target.
	    if canSpreadDiseases() then
		    -- Iterating Object manager
		    -- begin loop
		    for i = 1, #ObjectCount do
		    	-- we check if it's a valid unit
		    	if getCreatureType(ObjectWithIndex(i)) == true then
		    		-- now that we know the unit is valid, we can use it to check whatever we want.. let's call it thisUnit
		    		local thisUnit = ObjectWithIndex(i)
	    			-- Here I do my specific spell checks
	    			if UnitDebuffID(thisUnit,55078,"player") == nil and getDistance("player",thisUnit) < 8 and getDistance("target",thisUnit) then
	    				-- All is good, let's cast. I add a timer to make sure i dont recast while my spell is "flying"
	    				if castSpell("target",PestiSpell,true) then pestiTimer = GetTime(); return; end
	    			end
		    	end
		    end
	    end



	    -- Death Strike
	    if (runesFrost >= 1 and runesUnholy >= 1)
	      or (runesFrost >= 1 and runesDeath >= 1)
	      or (runesDeath >= 1 and runesUnholy >= 1)
	      or (runesDeath >= 2) then
	    	if castSpell("target",_DeathStrike,false) then return; end
	    end

	    -- Blood Boil - Scarlet Fever
	    if targetDistance <= 5 and UnitBuffID("player",81141) ~= nil then
	    	if castSpell("player",50842,true) then return; end
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
	    if runicPower >= 30 then
		    if targetDistance < 40 then
		    	if castSpell("target",47541,false) then return; end
		    end
		end

	    -- Blood Boil - Scarlet Fever
	    if targetDistance <= 8 and runesBlood == 2 then
	    	if castSpell("player",50842,true) then return; end
	    end

	    -- Horn of Winter
	    if UnitBuffID("player",_HornOfWinter) == nil then
	    	if castSpell("player",_HornOfWinter,true) then return; end
	    end
	end
end
end




