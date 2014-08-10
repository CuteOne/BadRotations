if select(3, UnitClass("player")) == 11 then
function DruidRestoration()
	if currentConfig ~= "Restoration Masou" then
		RestorationConfig();
		RestorationToggles();
		currentConfig = "Restoration Masou";
	end

	-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end

--[[ 	-- On GCD After here, palce out of combats spells here
]]

	if isCasting() then return false; end

	-- Barkskin if < 30%
	if isChecked("Barkskin") and getHP("player") <= getValue("Barkskin") then
		if castSpell("player",22812,true) then return; end
	end


--[[ 	-- Combats Starts Here
]]

	if isInCombat("player") then

		--if isAlive() and (isEnnemy() or isDummy("target")) and getLineOfSight("player","target") == true and getFacing("player","target") == true then

        -- Healing Touch via Ns
		if isChecked("Healing Touch Ns") and nNova[1].hp <= getValue("Healing Touch Ns") then
		   	if castSpell("player",132158,true) then 
		   		if castSpell(nNova[1].unit,5185,true) then return; end 
		   	end
		  	-- For lag  
		   	if UnitBuffID("player",132158) then 
		   		if castSpell(nNova[1].unit,5185,true) then return; end
		    end
		end

		-- Lifebloom
		if isChecked("Lifebloom") then
			if getHP("focus") <= getValue("Lifebloom") and (getBuffRemain("focus",33763) < 4 or getBuffStacks("focus",33763) < 3) then
				if castSpell("focus",33763,true) then return; end
			end
		end		

 		-- Healing Touch via Sage Mender
 		local SMName, _, _, SMcount, _, _, SMexpirationTime = UnitBuffID("player", 144871) --Sage Mender - 2p bonus tier 16  
		if SMName and  SMcount >= 5   then
			if isChecked("Healing Touch") and nNova[1].hp <= getValue("Healing Touch") then
				if castSpell(nNova[1].unit,5185,true) then return; end
			end
		end

		-- Innervate
		if getMana("player") <= getValue("Innervate") then
			if castSpell("player",29166,true) then return; end
		end

		-- Mushrooms
		if canCast(145205,false,false) and (shroomsTable == nil or #shroomsTable == 0) then
			if castHealGround(145205,15,100,3) then return; end
		end
		-- Mushroom Replace
		if isChecked("Wild Mushrooms") and canCast(145205,false,false) and (shroomsTable ~= nil and #shroomsTable ~= 0) then
			ISetAsUnitID(shroomsTable[1],"myShroom")
			local allies10Yards = getAllies("myShroom",10)
			if #allies10Yards < getValue("Wild Mushrooms Count") then
				if castHealGround(145205,15,getValue("Wild Mushrooms") ,getValue("Wild Mushrooms Count")) then return; end
			else
				local found = 0;
				for i = 1, #allies10Yards do
					if getHP(allies10Yards[i]) <= getValue("Wild Mushrooms Bloom") then
						found = found + 1;
					end
				end
				if found > getValue("Wild Mushrooms Bloom Count") and castSpell("player",102791,true) then return; end
			end
		end		
		
		-- Swiftmend (Unglyphed)
		if hasGlyph(145529) ~= true then
			local allies10Yards;
			if getBuffRemain(nNova[1].unit,774) > 1 or getBuffRemain(nNova[1].unit,8936) > 1 then
				allies10Yards = getAllies(nNova[1].unit,10)
				if #allies10Yards >= 3 then
					local count = 0;
					for i = 1, #allies10Yards do
						if getHP(allies10Yards[i]) < 100 then
							count = count + 1
						end
					end
					if count > 3 then
						if castSpell(nNova[1].unit,18562,true) then return; end
					end
				end
			end
		else
			-- Swiftmend (Glyphed)
			if getBuffRemain("player", 100977) < 3 then
				if getBuffRemain(nNova[1].unit,774) > 1 or getBuffRemain(nNova[1].unit,8936) > 1 then
					if castSpell(nNova[1].unit,18562,true) then return; end
				end
			end
		end

		-- Genesis
		if isChecked("Genesis") and canCast(145518) then
			local GenCount=0
			for i=1, #nNova do
				if nNova[i].hp <= getValue("Genesis") and getBuffRemain(nNova[i].unit,774) > 2 then 	
					GenCount = GenCount + 1
					if GenCount >= getValue("Genesis Count") then if castSpell("player",145518,true) then return; end end 	
				end
			end
		end

 		-- Rejuvenation
		if isChecked("Rejuvenation") then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Rejuvenation") and getBuffRemain(nNova[i].unit,774) < 2 then
					if castSpell(nNova[i].unit,774,true) then return; end
				end
			end
		end

 		-- Regrowth
		if isChecked("Regrowth") then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Regrowth") then
					if castSpell(nNova[i].unit,8936,true) then return; end
				end
			end
		end


		--end
	end
end
end