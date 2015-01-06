if select(3, UnitClass("player")) == 6 then
function Blood()
	--ChatOverlay(getNumEnemies("player",10))
	if AoEModesLoaded ~= "Blood DK AoE Modes" then
		BloodOptions()
		BloodToggles()
	end

	-- Locals
	getRuneInfo()
    local runicPower, runesBlood, runesUnholy, runesFrost, runesDeath = UnitPower("player"), getRunes("blood"), getRunes("unholy"), getRunes("frost"), getRunes("death")
    local myHealth = getHP("player")
	-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false end
	if IsMounted("player") then return false end

    dynamicUnit = {
        dyn5 = dynamicTarget(5,true),
        dyn6 = dynamicTarget(6,true),
        dyn30 = dynamicTarget(30,true),
        dyn30AoE = dynamicTarget(30,false),
        dyn40 = dynamicTarget(40,true)
    }

    -- ill add ranges to my dynamic stuff
    dynamicUnit.dyn5Range = getDistance("player",dynamicUnit.dyn5)
    dynamicUnit.dyn8Range = getDistance("player",dynamicUnit.dyn8)
    dynamicUnit.dyn30Range = getDistance("player",dynamicUnit.dyn30)
    dynamicUnit.dyn40Range = getDistance("player",dynamicUnit.dyn40)

    -- we want to avoid wasting CDs when targets are not hitting us
	if UnitAffectingCombat("player") and dynamicUnit.dyn5Range < 5 then

        -- Mind Freeze
        if isChecked("Mind Freeze") == true then
            castInterrupt(_MindFreeze, getValue("Mind Freeze"))
        end

    	-- Anti Magic Shell
    	if isChecked("Anti-Magic Shell") == true and myHealth <= getValue("Anti-Magic Shell")
          and dynamicUnit.dyn5Range < 5 then
    		if castSpell("player",_AntiMagicShell,true,false) then return end
    	end

    	-- Dancing Rune Weapon
    	if isChecked("Dancing Rune Weapon") == true and myHealth <= getValue("Dancing Rune Weapon") then
    		if castSpell(dynamicUnit.dyn30,_DancingRuneWeapon,true,false) then return end
    	end

    	-- Conversion
        if isChecked("Conversion") == true and myHealth <= getValue("Conversion") then
    		if castSpell("player",_Conversion,true,false) then return end
    	end

    	-- Vampiric Blood
        if isChecked("Vampiric Blood") == true and myHealth <= getValue("Vampiric Blood") then
    		if castSpell("player",_VampiricBlood,true,false) then return end
    	end

    	-- Icebound Fortitude
        if isChecked("Icebound Fortitude") == true and myHealth <= getValue("Icebound Fortitude") then
    		if castSpell("player",_IceboundFortitude,true) then return end
    	end

    	-- Rune Tap
        if isChecked("Rune Tap") == true and myHealth <= getValue("Rune Tap") then
    		if castSpell("player",_RuneTap,true,false) then return end
    	end

    	-- Empower Rune Weapon
        if isChecked("Empower Rune Weapon") == true and myHealth <= getValue("Empower Rune Weapon") then
    		if castSpell("player",_EmpowerRuneWeapon,true,false) then return end
    	end
	end

	if castingUnit() or getSpellCD(61304) > 0 then return end

    -- Presence
    if isKnown(_BloodPresence) and isChecked("Presence") then
    	if getValue("Presence") == 1 and UnitBuffID("player",_BloodPresence) == nil then
    		if castSpell("player",_BloodPresence,true) then return end
    	elseif getValue("Presence") == 2 and UnitBuffID("player",_FrostPresence) == nil then
    		if castSpell("player",_FrostPresence,true,false) then return end
    	end
    elseif isChecked("Frost Presence") then
    	if getValue("Presence") == 2 and UnitBuffID("player",_FrostPresence) == nil then
    		if castSpell("player",_FrostPresence,true,false) then return end
    	end
    end

	-- Horn of Winter
	if getBuffRemain("player",_HornOfWinter) <= 4 then
		if castSpell("player",_HornOfWinter,true) then return end
	end

	if isInCombat("player") then

        -- Strangulate
        if isChecked("Strangulate") == true then
            castInterrupt(_Strangulate, getValue("Strangulate"))
        end

        -- auto_attack
        if (startAttackThrottle == nil or startAttackThrottle < GetTime() - 1) and isInMelee() and getFacing("player", "target") == true then
            RunMacroText("/startattack"); startAttackThrottle = GetTime()
        end

	    -- Death Siphon
	    if runesDeath >= 1 and getHP("player") <= getValue("Death Siphon") then
	    	if castSpell(dynamicUnit.dyn5,_DeathSiphon,false,false) then return end
	    end

		-- Raise Dead
		if isSelected("Raise Dead") then
			if castSpell("player",_RaiseDead,true,false) then return end
		end

    	-- Bone Shield
    	if isChecked("Bone Shield") and UnitBuffID("player",_BoneShield) == nil then
    		if castSpell("player",_BoneShield,true,false) then return end
    	end

    	-- Death and Decay
		if isSelected("Death And Decay") and (getRunes("unholy") >= 1 or getRunes("death") >= 1) and (getHP("target") > 75 or UnitHealth("target") > UnitHealth("player") * 10) then
			if getGround("target") == true and UnitExists("target") and ((isDummy("target") or getDistance("target","targettarget") <= 5)) then
				if castGround("target",_DeathAndDecay,30) then return end
			end
		end

	    -- Blood Tap
	    if getBuffStacks("player",114851) >= 5 and canTap() then
	    	if castSpell("player",_BloodTap,true,false) then return end
	    end

	    -- Runic Dump
	    if runicPower >= 90 then
	    	if dynamicUnit.dyn40Range < 40 then
	   			-- Death Coil
	    		if castSpell(dynamicUnit.dyn30,_DeathCoil,false,false) then return end
	    	end
	    end

	    if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
	    	meleeEnemies, ScanTimer = #getEnemies("player",8), GetTime()
	    end

	    -- Blood Boil - Refresh
        local deathPlague = getDebuffRemain(dynamicUnit.dyn5,55078,"player")
	    if (runesBlood >= 1 or runesDeath >= 1) and deathPlague < 6 and deathPlague > 0 then
	    	if castSpell("player",_BloodBoil,true) then return end
	    end
	    -- Outbreak
	    if deathPlague == 0 then
	    	if castSpell(dynamicUnit.dyn5,_Outbreak,false,false) then return end
	    end

	    -- Plague Strike
	    if (runesUnholy >= 1 or runesDeath >= 1) and deathPlague < 3 then

            --CastSpellByName(GetSpellInfo(_PlagueStrike),"target")
	    	if castSpell(dynamicUnit.dyn5,_PlagueStrike,false,false,true,true,false) then return end
	    end

	    -- Icy Touch
	    if (runesFrost > 0 or (runesDeath > 0 and deathPlague > 4)) and getDebuffRemain("target",55095) < 4 then
		    if castSpell(dynamicUnit.dyn30,_IcyTouch,false,false) then return end
	    end

	    -- Pestilence/Rolling Blood - Spread Diseases
	    -- Here i do my target checks and i make sure i want to iterate. I use canCadt prior to everything just to save
        -- power, i dont want to scan if that spell is not ready, i dont have energy or in my case if there are no
        -- diseases on my target.
        if canCast(_BloodBoil) and meleeEnemies >= 2 and (runesBlood >= 1 or runesDeath >= 1) then
            local unitDebuffed = false
            local unitNotDebuffed = false
            -- im gonna scan the list of valid units
            for i = 1, #enemiesTable do
                if ObjectExists(enemiesTable[i].unit) then
                    if enemiesTable[i].distance < 8 then
                        if UnitDebuffID(enemiesTable[i].unit,55078,"player") then
                            unitDebuffed = true
                        else
                            unitNotDebuffed = true
                        end
                    end
                    if unitDebuffed == true and unitNotDebuffed == true then
                        if castSpell("player",_BloodBoil,true,false) then
                            return
                        end
                    end
                end
            end
        end


	    -- Death Strike
	    if (runesFrost >= 1 and runesUnholy >= 1)
	      or (runesFrost >= 1 and runesDeath >= 1)
	      or (runesDeath >= 1 and runesUnholy >= 1)
	      or (runesDeath >= 2) then
	    	if castSpell(dynamicUnit.dyn5,_DeathStrike,false,false) then return end
	    end

	    -- Blood Boil - Scarlet Fever
	    if UnitBuffID("player",81141) ~= nil then
	    	if castSpell(dynamicUnit.dyn5,50842,true,false) then return end
	    end

        -- Soul Reaper
        if getHP("target") < 35 then
            if castSpell(dynamicUnit.dyn5,_SoulReaper,false,false) then return end
        end

	    -- Icy Touch
	    if runesFrost > 1 then
	    	if castSpell(dynamicUnit.dyn30,_IcyTouch,false,false) then return end
	    end

	    -- Rune Strike//Death Coil (70)
	    if runicPower >= 70 then
		    if castSpell(dynamicUnit.dyn40,47541,false,false) then return end
		end

	    -- Blood Boil - Scarlet Fever (dump)
	    if runesBlood == 2 then
	    	if castSpell("player",50842,true,false) then return end
	    end

        -- Rune Strike//Death Coil (30)
        if runicPower >= 30 then
            if castSpell(dynamicUnit.dyn40,47541,false,false) then return end
        end

        -- Horn of Winter
        if UnitBuffID("player",_HornOfWinter) == nil then
            if castSpell("player",_HornOfWinter,true,false) then return end
        end
	end
end
end




