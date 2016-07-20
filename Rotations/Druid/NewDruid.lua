if select(3, UnitClass("player")) == 11 then
	function NewDruid()
		if Currentconfig ~= "New Druid CuteOne" then
            Currentconfig = "New Druid CuteOne";
        end
    ---===LOCALS===---
    	local bear 			= 5487
    	local bearForm 		= UnitBuffID("player",5487)~=nil or false
        local cat 			= 768
        local catForm 		= UnitBuffID("player",768)~=nil or false
        local combo 		= getCombo("player")
        local distance 		= getDistance("target")
        local ferociousBite = 22568
        local growl 		= 6795
        local hasAggro		= hasThreat("target")
        local hp 			= getHP("player")
        local inCombat		= isInCombat("target")
        local level 		= UnitLevel("player")
        local mangle 		= 33917
        local moonfire  	= 8921
        local moonfired 	= UnitDebuffID("target",164812,"player")~=nil or false
        local power 		= getPower("player")
        local rake 			= 1822
        local rakeRemain 	= getDebuffRemain(dynamicTarget(5,true),1822,"player") or 0
        local rejuv			= 774
        local rejuved 		= UnitBuffID("player",774)~=nil or false
        local shred 		= 5221
        local thisUnit  	= dynamicTarget(5,true)
        local ttd 			= getTimeToDie("target")
        local wrath 		= 5176

		local function hasDelay(name, time)
			return bb.timer:useTimer(name, time)
		end

	---===ROTATION===---
		---===BEAR FORM===---
		-- if bearForm then
		-- 	-- Rejuvenation
		-- 	if hp < 30 and not rejuved then
		-- 		if castSpell("player",rejuv,false,false,false) then return end
		-- 	end
		-- 	if UnitExists("target") and canAttack("target","player") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("target","player") and not pause() then
		-- 	-- Growl
		-- 		if distance < 30 and not inCombat or not hasAggro then
		-- 			if castSpell("target",growl,false,false,false) then return end
		-- 		end 
		-- 	-- Mangle
		-- 		if distance < 5 then
		-- 			if castSpell(thisUnit,mangle,false,false,false) then return end
		-- 		end
		-- 	end
		-- end
		---===CAT FORM===---
		if catForm then
			-- -- Rejuvenation
			-- if hp < 30 and not rejuved then
			-- 	if castSpell("player",rejuv,false,false,false) then return end
			-- end
			if UnitExists("target") and canAttack("target","player") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("target","player") and not pause() then
			-- Ferocious Bite
				if combo > 0 and ttd < 2 and power > 25 and level >= 3 then
					if castSpell(thisUnit,ferociousBite,false,false,false) then return end
				end
			-- Rake 
				if rakeRemain<3 and level >= 6 then
					if castSpell(thisUnit,rake,false,false,false) then return end
				end
			-- Shred
				if (combo < 5 or level < 3) and power > 40 then
					if castSpell(thisUnit,shred,false,false,false) then return end
				end
			-- Ferocious Bite
				if combo == 5 and power > 25 and level >= 3 then
					if castSpell(thisUnit,ferociousBite,false,false,false) then return end
				end
			end
		end		
		-- ---===NON-SHAPESHIFT===---
		-- if not catForm and not bearForm then
		-- 	-- Rejuvenation
		-- 	if hp < 50 and not rejuved then
		-- 		if castSpell("player",rejuv,false,false,false) then return end
		-- 	end
	 --        if UnitExists("target") and canAttack("target","player") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("target","player") and not pause() then
	 --        	-- Moonfire
	 --        	if distance < 40 and inCombat and not moonfired then
	 --        		if castSpell("target",moonfire,false,false,false) then return end
	 --        	end 
	 --        	-- Wrath
	 --        	if distance < 40 and not isMoving("player") then
	 --        		if not inCombat and (lastSpellCast~=wrath or lastSpellTarget~=UnitGUID("target")) and level>=3 then
	 --        			if castSpell("target",wrath,false,false,false) then return end
	 --        		end
	 --        		if isInCombat("player") or level<3 then
	 --        			if castSpell("target",wrath,false,false,false) then return end
	 --        		end
	 --        	end
	 --        	-- Moonfire: Opening
	 --        	if distance < 40 and not inCombat and not moonfired and level>=3 then
	 --        		if castSpell("target",moonfire,false,false,false) then return end
	 --        	end
	 --    	end
	 --    end
	end
end