if select(3, UnitClass("player")) == 1 then
	function NewWarrior()
		if Currentconfig ~= "New Warrior CuteOne" then
            Currentconfig = "New Warrior CuteOne";
        end
    ---===LOCALS===---
    	local battleStance 		= 2457
    	local battled 			= UnitBuffID("player",2457)~=nil or false
    	local heroicStrike 		= 78
    	local charge 			= 100
    	local victoryRush 		= 34428
    	local impendingVictory 	= 103840
    	local defensiveStance 	= 71
    	local defended 			= UnitBuffID("player",71)~=nil or false
    	local distance 			= getDistance(dynamicTarget(5,true))
    	local moving 			= isMoving("player")
    	local power 			= getPower("player")
    	local powerPerc 		= ((UnitPower("player")/UnitPowerMax("player"))*100)
    	local thisUnit 			= dynamicTarget(5,true)
    	local hp 				= getHP("player")

    ---===ROTATION===---
    	-- Battle/Defensive Stance
    	if isInCombat("player") and hp < 50 and not defended then
    		if castSpell("player",defensiveStance,false,false,false) then return end
    	elseif not battled and hp >= 50 then
    		if castSpell("player",battleStance,false,false,false) then return end
    	end
    	-- Charge
    	if distance < 25 and distance >= 8 and getSpellCD(charge)==0 then
    		if castSpell(thisUnit,charge,false,false,false) then return end
    	end
    	if UnitExists("target") and canAttack("target","player") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("target","player") and not pause() then
    	-- Victory Rush
    		if distance < 5 and impendingVictory then
    			if castSpell(thisUnit,victoryRush,false,false,false) then return end
    		end
    	-- Heroic Strike
	    	if distance < 5 and power > 30 and getSpellCD(heroicStrike) == 0 then
	    		if castSpell(thisUnit,heroicStrike,false,false,false) then return end
	  		end
	  		if distance < 5 then
	  			StartAttack()
	  		end
    	end
	end
end