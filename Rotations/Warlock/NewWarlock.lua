if select(3, UnitClass("player")) == 9 then
	function NewWarlock()
		if Currentconfig ~= "New Warlock CuteOne" then
            Currentconfig = "New Warlock CuteOne";
        end
    ---===LOCALS===---
    	local shadowBolt 		= 686
    	local summonImp			= 688
    	local corruption 	 	= 172
    	local corrupted 		= UnitDebuffID("target",172,"player")~=nil or false
    	local summonVoidwalker	= 697
    	local createHealthstone	= 6201
    	local healthstone 		= 5512
    	local petExists 		= UnitExists("pet")
    	local distance 			= getDistance("target")
    	local hp 				= getHP("player")
        local level 			= UnitLevel("player")
        local powerPerc 		= ((UnitPower("player")/UnitPowerMax("player"))*100)
        local moving 			= isMoving("player")
        local inCombat			= isInCombat("target")

    ---===ROTATION===---
    	-- Summon Demons
    	if not petExists then
    		if level < 8 and lastSpellCast~=summonImp then
    			if castSpell("player",summonImp,false,false,false) then return end
    		end
    		if level >= 8 and lastSpellCast~=summonVoidwalker then
    			if castSpell("player",summonVoidwalker,false,false,false) then return end
    		end
    	end
    	-- Healthstone
    	if not hasItem(healthstone) and hasEmptySlots() and lastSpellCast~=createHealthstone then
    		if castSpell("player",createHealthstone,false,false,false) then return end
    	end
    	if hasItem(healthstone) and canUse(healthstone) and hp < 50 then
    		useItem(healthstone)
    	end
    	if UnitExists("target") and canAttack("target","player") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("target","player") and not pause() then
    	-- Corruption
        	if distance < 40 and inCombat and not corrupted and powerPerc>1.25 then
        		if castSpell("target",corruption,false,false,false) then return end
        	end 
        -- Shadow Bolt
        	if distance < 40 and not isMoving("player") and powerPerc>5.5 then
        		if not inCombat and (lastSpellCast~=shadowBolt or lastSpellTarget~=UnitGUID("target")) and level>=3 then
        			if castSpell("target",shadowBolt,false,false,false) then return end
        		end
        		if isInCombat("player") or level<3 then
        			if castSpell("target",shadowBolt,false,false,false) then return end
        		end
        	end
        -- Corruption: Opening
        	if distance < 40 and not inCombat and not corrupted and level>=3 and powerPerc>1.25 then
        		if castSpell("target",corruption,false,false,false) then return end
        	end
    	end
	end
end