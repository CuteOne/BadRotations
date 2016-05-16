if select(3, UnitClass("player")) == 5 then
	function NewPriest()
		if Currentconfig ~= "New Priest CuteOne" then
            Currentconfig = "New Priest CuteOne";
        end
    ---===LOCALS===---
    	local smite 			= 585
    	local shadowWordPain	= 589
    	local swped 			= UnitDebuffID("target",589,"player")~=nil or false
    	local powerWordShield 	= 17
    	local shielded 			= UnitBuffID("player",17)~=nil or false
    	local flashHeal 		= 2061
    	local distance 			= getDistance(dynamicTarget(5,true))
    	local moving 			= isMoving("player")
    	local powerPerc 		= ((UnitPower("player")/UnitPowerMax("player"))*100)
    	local inCombat			= isInCombat("target")
        local level 			= UnitLevel("player")
        local hp 				= getHP("player")

    ---===ROTATION===---
    	-- Flash Heal
    	if hp<50 and powerPerc>4.14 then
    		if castSpell("player",flashHeal,false,false,false) then return end
    	end
    	if UnitExists("target") and canAttack("target","player") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("target","player") and not pause() then
    	-- Power Word: Shield
    		if distance < 10 and inCombat and not shielded and powerPerc>2.4 then
    			if castSpell("player",powerWordShield,false,false,false) then return end
    		end
    	-- Shadow Word: Pain
        	if distance < 40 and inCombat and not swped and powerPerc>0.25 then
        		if castSpell("target",shadowWordPain,false,false,false) then return end
        	end 
        -- Smite
        	if distance < 30 and not isMoving("player") and powerPerc>1.5 then
        		if not inCombat and (lastSpellCast~=smite or lastSpellTarget~=UnitGUID("target")) and level>=3 then
        			if castSpell("target",smite,false,false,false) then return end
        		end
        		if isInCombat("player") or level<3 then
        			if castSpell("target",smite,false,false,false) then return end
        		end
        	end
        -- Shadow Word: Pain: Opening
        	if distance < 40 and not inCombat and not swped and level>=3 and powerPerc>0.25 then
        		if castSpell("target",shadowWordPain,false,false,false) then return end
        	end
    	end
	end
end