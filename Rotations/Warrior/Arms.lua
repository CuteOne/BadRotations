if select(3,UnitClass("player")) == 1 then

function ArmsWarrior()
	if AoEModesLoaded ~= "Arms Warrior AoE Modes" then
		WarriorArmsToggles();
		WarriorArmsConfig();
	end

-- Locals
	local rage = UnitPower("player");
	local myHP = getHP("player");
	local ennemyUnits = getNumEnnemies("player", 5)

-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then return false; end

------------------
--- Defensives ---
------------------
--[[ Berserker Regeneration
	if getHP("player") <= 60 and getPower("player") >= 40 and not isCasting("player") then
		if castSpell("player",12345,true) then return; end
	end]]
--[[ Berserker Rage
	if hasNoControl() then
		if castSpell("player",12345,true) then 
			return;
		end
	end]]


	if not isInCombat("player") then
---------------------
--- Out of Combat ---
---------------------
		
		--[[Stance]]
		if isChecked("Stance") == true then
			--[[Defensive]]
			if getValue("Stance") == 1 then
	 			if GetShapeshiftForm() ~= 2 then 
	 				if castSpell("player",71,true) then return; end 
	 			end
	 		--[[Battle]]
	 		elseif getValue("Stance") == 2 then
	 			if GetShapeshiftForm() ~= 1 then 
	 				if castSpell("player",2457,true) then return; end 
	 			end
	 		end
	 	end

		--[[Charge if getDistance > 10]]
		if isChecked("Charge") == true and canAttack("target","player") and not UnitIsDeadOrGhost("target") and getDistance("player","target") > 10 then
			if targetDistance <= 40 and getGround("target") == true and UnitExists("target") then
				if castSpell("target",100,false,false) then return; end
			end
		end

	end
	if pause() ~= true and isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then			
-----------------
--- In Combat ---
-----------------

		--[[Quaking Palm]]
		if isChecked("Quaking Palm") and canInterrupt(107079,tonumber(getValue("Quaking Palm"))) then
			if castSpell("target",107079,false) then return; end
		end

		--[[Pummel]]
		if isChecked("Pummel") and canInterrupt(6552,tonumber(getValue("Pummel"))) then
			if castSpell("target",6552,false) then return; end
		end

    	--[[Last Stand]]
    	if isChecked("Last Stand") == true and myHP <= getValue("Last Stand") then
    		if castSpell("player",12975,true) then return; end
    	end

		if isCasting() then return false; end
		if targetDistance > 5 and targetDistance <= 40 then
--------------------
--- Out of Range ---
--------------------

			--[[Charge]]
			if isChecked("Charge") == true and canAttack("target","player") and not UnitIsDeadOrGhost("target") and getDistance("player","target") > 10 then
				if targetDistance <= 40 and getGround("target") == true and UnitExists("target") then
					if castSpell("target",100,false,false) then return; end
				end
			end

		elseif UnitExists("target") and not UnitIsDeadOrGhost("target") and isEnnemy("target") == true and getCreatureType("target") == true then
----------------
--- In Range ---
----------------

		    -- berserker_rage,if=buff.enrage.down&rage<=rage.max-10

		    if castSpell("target",12294,false,false) then return; end 

		    --[[Cleave if numEnnemies > 2]] 
		    if ennemyUnits > 2 then
		    	if rage >= UnitPowerMax("player") - 10 then castSpell("target",845,false,false); end
		    	if getDistance("player","target") <= 6 then
		    		if castSpell("target",6343,false,false) then return; end 
		    	end
		    end

		    --[[heroic_strike]] 
		    if (ennemyUnits < 3 or isKnown(845) ~= true) and (rage >= UnitPowerMax("player") - 10) then
			    if castSpell("target",78,false,false) then return; end
			end    	

		    --[[normal_rotation+=/battle_shout,if=rage<=rage.max-20]]
		    if isChecked("Shout") == true and rage < UnitPowerMax("player") - 20 then 
		    	if getValue("Shout") == 1 then
		    		if castSpell("target",6673,true,false) then return; end  
		    	else
		    		if castSpell("target",469,true,false) then return; end  
		    	end
		    end 

		    --[[normal_rotation+=/thunder_clap]]
		    if getDistance("player","target") <= 6 then
		    	if castSpell("target",6343,false,false) then return; end 
		    end

		    --normal_rotation+=/demoralizing_shout

		    --[[normal_rotation+=/impending_victory,if=enabled]]
		    if isKnown(103840) == true then
		    	if castSpell("target",103840,false,false) then return; end 
		    end  

		    --[[normal_rotation+=/victory_rush,if=!talent.impending_victory.enabled]]  
		    if isKnown(103840) ~= true and getHP("target") <= 20 then
		    	if castSpell("target",34428,false,false) then return; end 
		    end

		end
	end
end
end
