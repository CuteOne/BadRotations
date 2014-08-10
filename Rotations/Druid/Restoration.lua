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

		-- DPS Managements
		if BadBoy_data["DPS"] == 2 then
			if IsLeftShiftKeyDown() then
				if targetDistance <= 5 then
					--- Catform
			  		if not UnitBuffID("player",768) and not UnitBuffID("player",783) and not UnitBuffID("player",5487) then 
						if castSpell("player",768) then return; end
					end
					-- Ferocious Bite
					if getCombo() == 5 and UnitBuffID("player",768) ~= nil then 
						if castSpell("target",22568,false) then return; end
					end
					-- Rake
					if getDebuffRemain("target",1822) < 2 then 
						if castSpell("target",1822) then return; end
					end
					-- Mangle
					if castSpell("target",33876) then return; end
				else
					if UnitBuffID("player",768) ~= nil then 
						CancelShapeshiftForm();
					end
					-- Moonfire
					if getDebuffRemain("target",8921) < 3 or isMoving("player")then
						if castSpell("target",8921) then return; end
					end
					-- Wrath
					if castSpell("target",5176) then return; end

				end
			else
				if UnitBuffID("player",768) ~= nil then 
					CancelShapeshiftForm();
				end	
			end
		end

		-- Mark of the Wild
		if isChecked("Mark of the Wild") then
			for i = 1, #nNova do
		  		if not isBuffed(nNova[i].unit,{115921,20217,1126,90363}) then
		  			if castSpell("player",1126,true) then return; end
				end 
			end
		end

 		-- Regrowth Omen
		if isChecked("Regrowth Omen") and UnitBuffID("player",113043) then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Regrowth Omen") then
					if castSpell(nNova[i].unit,8936,true) then return; end
				end
			end
		end

		-- Wild Growth
		for i = 1, #nNova do
			local allies40Yards = getAllies(nNova[i].unit,40)
			if #allies40Yards >= 3 then
				local count = 0;
				for j = 1, #allies40Yards do
					if getHP(allies40Yards[j]) < 90 then
						count = count + 1
					end
				end
				if count > 3 then
					if castSpell(nNova[i].unit,48438,true) then return; end
				end
			end
		end

		-- Incarnation
		if isKnown(106731) then
			if UnitBuffID("player", 33891) then
				for i = 1, #nNova do
					if getBuffRemain(nNova[i].unit, 33763) == 0 then
						if castSpell(nNova[i].unit, 33763) then return; end
					end
				end
				for i = 1, #nNova do
					if getBuffStacks(nNova[i].unit, 33763) == 1 then
						if castSpell(nNova[i].unit, 33763) then return; end
					end
				end	
				for i = 1, #nNova do
					if getBuffStacks(nNova[i].unit, 33763) == 2 then
						if castSpell(nNova[i].unit, 33763) then return; end
					end
				end		
				for i = 1, #nNova do
					if getBuffStacks(nNova[i].unit, 33763) == 3 and getBuffRemain(nNova[i].unit, 33763) < 3 then
						if castSpell(nNova[i].unit, 33763) then return; end
					end
				end											
			end
		end

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
		if isChecked("Mushrooms") and canCast(145205,false,false) and (shroomsTable == nil or #shroomsTable == 0) then
			if castHealGround(145205,15,100,3) then return; end
		end
		-- Mushroom Replace
		if isChecked("Mushrooms") and canCast(145205,false,false) and (shroomsTable ~= nil and #shroomsTable ~= 0) then
			ISetAsUnitID(shroomsTable[1],"myShroom")
			local allies15Yards = getAllies("myShroom",15)
			if #allies15Yards < getValue("Mushrooms Count") then
				if castHealGround(145205,15,getValue("Mushrooms") ,getValue("Mushrooms Count")) then return; end
			else
				local found = 0;
				for i = 1, #allies15Yards do
					if getHP(allies15Yards[i]) <= getValue("Mushrooms Bloom") then
						found = found + 1;
					end
				end
				if found > getValue("Mushrooms Bloom Count") and castSpell("player",102791,true) then return; end
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
				for i = 1, #nNova do
					if getBuffRemain(nNova[i].unit,774) > 1 or getBuffRemain(nNova[i].unit,8936) > 1 then
						if castSpell(nNova[i].unit,18562,true) then return; end
					end
				end
			end
		end

		-- Genesis
		if isChecked("Genesis") and canCast(145518) and (lastGenesis == nil or lastGenesis <= GetTime() - 10) then
			local GenCount=0
			for i=1, #nNova do
				if nNova[i].hp <= getValue("Genesis") and getBuffRemain(nNova[i].unit,774) > 2 then 	
					GenCount = GenCount + 1
					if GenCount >= getValue("Genesis Count") then if castSpell("player",145518,true) then lastGenesis = GetTime(); return; end end 	
				end
			end
		end

 		-- Rejuvenation
		if isChecked("Rejuvenation") then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Rejuvenation") and getBuffRemain(nNova[i].unit,774) == 0 then
					if castSpell(nNova[i].unit,774,true) then return; end
				end
			end
		end

 		-- Regrowth
		if isChecked("Regrowth") then
			for i = 1, #nNova do
				if (nNova[i].role == "TANK" and nNova[i].hp <= getValue("Regrowth Tank")) or (nNova[i].role ~= "TANK" and nNova[i].hp <= getValue("Regrowth")) then
					if castSpell(nNova[i].unit,8936,true) then return; end
				end
			end
		end


	end
end
end