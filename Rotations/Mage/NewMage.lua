if select(3, UnitClass("player")) == 8 then
	function NewMage()
		if Currentconfig ~= "New Mage CuteOne" then
            Currentconfig = "New Mage CuteOne";
        end
    ---===LOCALS===---
    	local counterspell 		= 2139
    	local frostfireBolt		= 44614
    	local frostNova 		= 122
    	local fireBlast 		= 2136
    	local distance 			= getDistance("target")
    	local moving 			= isMoving("player")
    	local power 			= getPower("player")
    	local powerPerc 		= ((UnitPower("player")/UnitPowerMax("player"))*100)

    ---===ROTATION===---
    	if UnitExists("target") and canAttack("target","player") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("target","player") and not pause() then
    		if distance<40 then
    	-- Counterspell
    			for i=1, #getEnemies("player",40) do
					thisUnit = getEnemies("player",40)[i]
					if canInterrupt(thisUnit,50) then
						if castSpell(thisUnit,counterspell,false,false,false) then return end
					end
				end
    	-- Frost Nova
    			if powerPerc > 2 and distance < 10 and getSpellCD(frostNova)==0 then
    				if castSpell("player",frostNova,false,false,false) then return end
    			end
    	-- Fire Blast
    			if powerPerc > 2 and distance < 30 and getSpellCD(fireBlast)==0 then
    				if castSpell("target",fireBlast,false,false,false) then return end
    			end
    	-- Frostfire Bolt
    			if powerPerc > 4 and not moving then
    				if castSpell("target",frostfireBolt,false,false,false) then return end
    			end
    		end
    	end
	end
end	