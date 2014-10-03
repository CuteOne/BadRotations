if select(3,UnitClass("player")) == 1 then

function ProtectionWarrior()
if Currentconfig ~= "Protection CodeMyLife" then
 WarriorProtConfig();
 WarriorProtToggles()
 Currentconfig = "Protection CodeMyLife";
end
if isChecked("Rotation Up") then
		if SpecificToggle("Rotation Up") == 1 and GetCurrentKeyBoardFocus() == nil then
	 	if myTimer == nil or myTimer <= GetTime() -0.7 then
	  		myTimer = GetTime()
	  		ToggleValue("AoE");
	 	end
	end
end
if isChecked("Rotation Down") then
    if SpecificToggle("Rotation Down") == 1 and GetCurrentKeyBoardFocus() == nil then
	 	if myTimer == nil or myTimer <= GetTime() -0.7 then
	  		myTimer = GetTime()
	  		ToggleMinus("AoE");
	 	end
	end
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



	if not isInCombat("player") then
---------------------
--- Out of Combat ---
---------------------
		
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
		
		-- Shield Block / Barrier
		if getValue("BlockBarrier") == 1 and not UnitBuffID("player",ShieldBlockBuff) then
			if castSpell("player",ShieldBlock,true) then
				return;
			end
		elseif getValue("BlockBarrier") == 2 and not UnitBuffID("player",ShieldBarrierBuff) and rage >= 50 then
			if castSpell("player",ShieldBarrier,true) then
				return
			end
		end

---------------------
--- Single Target ---
---------------------

		-- shield slam on cd / sword and board proc
		if castSpell("target",ShieldSlam,false,false) then
			return;
		end		
		-- revenge on cd
		if castSpell("target",Revenge,false,false) then
			return;
		end			
		-- shout if need rage
		if rage < 40 then
			if castSpell("target",CommandingShout,false,false) then
				return;
			end	
		end
		-- thunderclap if weakened blows missing
		if not UnitDebuffID("target",WeakenedBlows) then
			if castSpell("target",ThunderClap,true) then
				return;
			end
		end			
		-- heroic strike on ultimatum proc
		if rage > 100 or UnitBuffID("player",Ultimatum) then
			if castSpell("target",HeroicStrike,false,false) then
				return;
			end
		end
		-- devastate filler
		if castSpell("target",Devastate,false,false,false,true) then
			return;
		end	

--------------------
--- Multi Target ---
--------------------

		-- thunderclap on cd		
		-- t4 talent (shockwave/bladestorm/dragonroar)
		-- shield slam on cd / sword and board proc
		-- revenge on cd
		-- devastate filler
		-- cleave on ultimatum

		end
	end
end
end
