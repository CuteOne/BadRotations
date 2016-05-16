if select(3, UnitClass("player")) == 7 then
	function NewShaman()
		if Currentconfig ~= "New Shaman CuteOne" then
            Currentconfig = "New Shaman CuteOne";
        end
    ---===LOCALS===---
    	local lightningBolt 	= 403
    	local primalStrike 		= 73899
    	local healingSurge 		= 8004
    	local lightningShield 	= 324
    	local lightningShieled 	= UnitBuffID("player",324)~=nil or false
        local distance 			= getDistance(dynamicTarget(5,true))
        local hp 				= getHP("player")
        local level 			= UnitLevel("player")
        local powerPerc 		= ((UnitPower("player")/UnitPowerMax("player"))*100)
        local thisUnit  		= dynamicTarget(5,true)
        local moving 			= isMoving("player")

	---===ROTATION===---
		-- Healing Surge
		if hp < 50 and powerPerc > 20.7 and level >= 7 and not moving then
			if castSpell("player",healingSurge,false,false,false) then return end
		end
		-- Lightning Shield
		if not lightningShieled and level >= 8 then
			if castSpell("player",lightningShield,false,false,false) then return end
		end
        if UnitExists("target") and canAttack("target","player") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("target","player") and not pause() then
        -- Primal Stike
        	if distance < 5 and powerPerc > 9.4 and getSpellCD(primalStrike) == 0 and level >= 3 then
        		if castSpell(thisUnit,primalStrike,false,false,false) then return end
        	end
        -- Lightning Bolt
        	if distance < 30 and powerPerc > 1.75 and not moving then
        		if castSpell(thisUnit,lightningBolt,false,false,false) then return end
        	end
    	end
	end
end