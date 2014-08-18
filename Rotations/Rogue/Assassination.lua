if select(3, UnitClass("player")) == 4 then
	function AssassinationRogue()
		if Currentconfig ~= "Assassination CuteOne" then
			AssOptions();
			Currentconfig = "Assassination CuteOne"
		end
		AssToggles();
--------------
--- Poison ---
--------------
	-- Deadly Poison
		if getBuffRemain("player",_DeadlyPoison)<5 and not isMoving("player") and not isCastingSpell(_DeadlyPoison) then
			if castSpell("player",_DeadlyPoison) then return; end
		end
---------------
--- Healing ---
---------------
	-- Recuperate
		if getHP("player") < 80 and getBuffRemain("player",_Recuperate)==0 and getCombo("player")>0 then
			if castSpell("player",_Recuperate) then return; end
		end
--------------
--- Opener ---
--------------
	-- Opener
		if not UnitBuffID("player",_Stealth) and canAttack("player","target") and not UnitIsDeadOrGhost("target") and targetDistance < 20 then
			if castSpell("player",_Stealth) then return; end
		end
		if canAttack("player","target") and not UnitIsDeadOrGhost("target") and targetDistance < 20 then
	-- Sap

		end	
	end
end