function Blood()
	--ChatOverlay(getNumEnnemies("player",10))
	if AoEModesLoaded ~= "Blood DK AoE Modes" then
		BloodOptions();
		BloodToggles();
	end

	-- Locals
	local _RunicPower = UnitPower("player");
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
		if isSelected("Death And Decay") and (getRunes("unholy") > 1 or getRunes("death") > 1) then
			if getGround("target") == true and isMoving("target") == false and UnitExists("target") and (isDummy("target") or getDistance("target","targettarget") <= 5) then
				if castGround("target",_DeathAndDecay,30) then return; end
			end
		end    	
   
	    -- Blood Tap
	    if getBuffStacks("player",114851) >= 5 and canTap() then
	    	if castSpell("player",_BloodTap,true) then return; end
	    end

	    -- Rune Strike//Death Coil
	    if getPower("player") >= 90 then
	    	if isKnown(_RuneStrike) then
	    		if castSpell("target",_RuneStrike,false) then return; end
	   		else
	   			-- Death Coil
	    		if castSpell("target",_DeathCoil,false) then return; end
	    	end
	    end

	    -- Outbreak
	    if UnitDebuffID("target",55095,"player") == nil then
	    	if castSpell("target",_Outbreak,false) then return; end
	    end

	    -- Blood Boil
	    if UnitDebuffID("target",55095,"player") ~= nil and getDebuffRemain("target",55095,"player") < 4 then
	    	if castSpell("player",_BloodBoil,true) then return; end
	    end

	    -- Frost Fever
	    if getDebuffRemain("target",55095,"player") < 4 then
	    	if castSpell("target",_FrostFever,false) then return; end
	    end

	    -- Plague Strike
	    if getDebuffRemain("target",55078,"player") < 4 then
	    	if castSpell("target",_PlagueStrike,false) then return; end
	    end

	    -- Heart Strike//Blood Strike
	    if getRunes("blood") >= 1 then
	    	if isKnown(_HeartStrike) then
	    		if castSpell("target",_HeartStrike,false) then return; end
	    	else
	    		-- Blood Strike
	    		if getRunes("blood") == 2 then
	    			if castSpell("target",_BloodStrike,false) then return; end
	    		end
	    	end
	    end

	    -- Death Strike
	    if castSpell("target",_DeathStrike,false) then return; end
	   
	    -- Blood Boil
	    if UnitBuffID("player",81141) ~= nil and (BadBoy_data["AoE"] == 3 or getNumEnnemies("player",5)) >= 3 then
	    	if castSpell("target",_BloodBoil,true) then return; end
	    end

	    -- Soul Reaper
	    if getHP("target") < 35 then
	    	if castSpell("target",_SoulReaper,false) then return; end
	    end

	    -- Rune Strike//Death Coil
	    if isKnown(_RuneStrike) then
	    	if castSpell("target",_RuneStrike,false) then return; end
	    elseif getPower("player") >= 65 then
	    	if castSpell("target",_DeathCoil,false) then return; end
	    end

	    -- Horn of Winter
	    if UnitBuffID("player",_HornOfWinter) == nil then
	    	if castSpell("player",_HornOfWinter,true) then return; end
	    end

		--ChatOverlay("A L'ATTAQUE");

	end
end





