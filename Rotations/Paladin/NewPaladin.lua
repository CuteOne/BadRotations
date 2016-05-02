if select(3, UnitClass("player")) == 2 then
	function NewPaladin()
		if Currentconfig ~= "New Mage CuteOne" then
            Currentconfig = "New Mage CuteOne";
        end
    ---===LOCALS===---
    	local crusaderStrike 	= 35395
    	local judgment 			= 20271
    	local hammerOfJustice 	= 853
    	local sealOfCommand 	= 105361
    	local wordOfGlory 		= 85673
    	local hasSeal 			= GetShapeshiftForm() == 1
    	local holyPower 		= UnitPower("player",9)
    	local distance 			= getDistance(dynamicTarget(5,true))
    	local moving 			= isMoving("player")
    	local power 			= getPower("player")
    	local powerPerc 		= ((UnitPower("player")/UnitPowerMax("player"))*100)
    	local thisUnit 			= dynamicTarget(5,true)

    ---===ROTATION===---
    	if UnitExists("target") and canAttack("target","player") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("target","player") and not pause() then
    	-- Hammer of Justice
    		for i=1, #getEnemies("player",10) do
				thisUnit = getEnemies("player",10)[i]
				if canInterrupt(thisUnit,50) then
					if castSpell(thisUnit,hammerOfJustice,false,false,false) then return end
				end
			end
		-- Word of Glosy
			if holyPower > 0 and getHP("player")<50 and getSpellCD(wordOfGlory) == 0 then
				if castSpell("player",wordOfGlory,false,false,false) then return end
			end
    	-- Seal of Command
    		if not hasSeal then
    			if castSpell("player",sealOfCommand,false,false,false) then return end
    		end
    	-- Judgment
    		if distance < 30 and powerPerc > 5 and getSpellCD(judgment) == 0 and hasSeal then
    			if castSpell(thisUnit,judgment,false,false,false) then return end
	  		end
    	-- Crusader Strike
	    	if distance < 5 and powerPerc > 10 and getSpellCD(crusaderStrike) == 0 then
	    		if castSpell(thisUnit,crusaderStrike,false,false,false) then return end
	  		end
    	end
	end
end