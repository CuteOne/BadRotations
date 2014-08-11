if select(3, UnitClass("player")) == 11 then
function DruidRestoration()
	if currentConfig ~= "Restoration Masou" then
		RestorationConfig();
		RestorationToggles();
		currentConfig = "Restoration Masou";
	end

	-- Pause toggle
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then ChatOverlay("|cffFF0000BadBoy Paused", 0); return; end
	-- Focus Toggle
	if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == 1 then 
		if UnitExists("mouseover") then RunMacroText("/focus mouseover"); return; end
	end

	--[[ 7 - Stop Casting--(perevent from over healing when u cast somthing can heal target)]]
	if isChecked("Overhealing Cancel Cast") and shouldNotOverheal(spellCastTarget) > getValue("Overhealing Cancel Cast") then
		local noOverHealSpells = { 5185, 8936, 50464,  }
		local castingSpell = UnitCastingInfo("player")
		if castingSpell ~= nil then 
			for i = 1, #noOverHealSpells do
				if GetSpellInfo(noOverHealSpells[i]) == castingSpell then RunMacroText("/stopcasting"); return; end
			end
		end
	end

	-- Food/Invis Check
	if canRun() ~= true then return false; end

--[[ 	-- On GCD After here, palce out of combats spells here
]]	if isCasting() then return false; end

--[[ 	-- Combats Starts Here
]]

	--[[ 1 - Buff Out of Combat]]
	-- Mark of the Wild
	if isChecked("Mark of the Wild") then
		for i = 1, #nNova do
	  		if not isBuffed(nNova[i].unit,{115921,20217,1126,90363}) then
	  			--if castSpell("player",1126,true) then return; end
			end 
		end
	end


	if BadBoy_data["Healing"] == 2 then
		--[[ 2 - Defencive --(U can use Defencive in cat form)]]
		-- Barkskin if < 30%
		if isChecked("Barkskin") and getHP("player") <= getValue("Barkskin") then
			if castSpell("player",22812,true) then return; end
		end

		-- Healthstone
		if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") then
			if canUse(5512) then
				UseItemByName(tostring(select(1,GetItemInfo(5512))))
			elseif canUse(76097) then
				UseItemByName(tostring(select(1,GetItemInfo(76097))))
			end
		end

		--[[ 3 - NS healing Touch --(U can NS healing Touch While in cat form)]]
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

		--[[ 4 - Dispel --(U can Dispel  While in cat form)]]
		if isChecked("Nature's Cure") then
			if getValue("Nature's Cure") == 1 then -- Mouse Match
				if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
					for i = 1, #nNova do
						if nNova[i].guid == UnitGUID("mouseover") and nNova[i].dispel == true then
							if castSpell(nNova[i].unit,88423, true) then return; end
						end
					end		
				end		
			elseif getValue("Nature's Cure") == 2 then -- Raid Match
				for i = 1, #nNova do
					if nNova[i].dispel == true then
						if castSpell(nNova[i].unit,88423, true) then return; end
					end
				end
			elseif getValue("Nature's Cure") == 3 then -- Mouse All
				if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
				    for n = 1,40 do 
				      	local buff,_,_,count,bufftype,duration = UnitDebuff("mouseover", n)
			      		if buff then 
			        		if bufftype == "Magic" or bufftype == "Curse" or bufftype == "Poison" then 
			        			if castSpell("mouseover",88423, true) then return; end 
			        		end 
			      		else
			        		break;
			      		end   
				  	end
				end		
			elseif getValue("Nature's Cure") == 3 then -- Raid All
				for i = 1, #nNova do
				    for n = 1,40 do 
				      	local buff,_,_,count,bufftype,duration = UnitDebuff(nNova[i].unit, n)
			      		if buff then 
			        		if bufftype == "Magic" or bufftype == "Curse" or bufftype == "Poison" then 
			        			if castSpell(nNova[i].unit,88423, true) then return; end 
			        		end 
			      		else
			        		break;
			      		end 
				  	end
				end	
			end
		end

		--[[ 5 - DPs --(range and  melee)]]
		if BadBoy_data["DPS"] == 2 then
			if isChecked("DPS Toggle") and SpecificToggle("DPS Toggle") == 1  then
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

		--[[ 6 - Genesis--(WITH Hotkey)]]
		if isChecked("Genesis Toggle") and SpecificToggle("Genesis Toggle") == 1 and GetCurrentKeyBoardFocus() == nil then 
			if canCast(145518) and (lastGenesis == nil or lastGenesis <= GetTime() - 10) then
				if castSpell("player",145518,true) then lastGenesis = GetTime(); return; end
			end		
		end	

		--[[ 7 - Stop Casting--(perevent from over healing when u cast somthing can heal target) Placed at top]]

		--[[ 8 - Force Of Nature]]
		if isKnown(102693) then --FOn Spell ID
		    if isChecked("Force of Nature") then 
		        for i = 1, #nNova do
		            local allies10Yards = getAllies(nNova[i].unit,10)
					if #allies10Yards >=  getValue("Force of Nature Count") then
						local count = 0;
						for j = 1, #allies10Yards do
							if getHP(allies10Yards[j]) < getValue("Force of Nature") then
								count = count + 1
							end
						end
						if count >= getValue("Force of Nature Count") and (lastFon  == nil or lastFon  <= GetTime() - 2) then -- Set Delay for Cast
							if castSpell(nNova[i].unit,102693,true) then lastFon = GetTime() return; end
						end
					end
				end
			end	
		end

		--[[ 9 - HealingTouch Sm]]
 		local SMName, _, _, SMcount, _, _, SMexpirationTime = UnitBuffID("player", 144871) --Sage Mender - 2p bonus tier 16  
		if SMName and  SMcount >= 5   then
			if isChecked("Healing Touch Sm") and nNova[1].hp <= getValue("Healing Touch Sm") then
				if castSpell(nNova[1].unit,5185,true) then return; end
			end
		end		

		--[[ 10 - WildMushroom Bloom]]
		local allies10Yards = getAllies("myShroom",10)
		if isChecked("Mushrooms Bloom") and #allies10Yards >= getValue("Mushrooms Bloom Count") then
			local found = 0;
			for i = 1, #allies10Yards do
				if getHP(allies10Yards[i]) <= getValue("Mushrooms Bloom") then
					found = found + 1;
				end
			end
			if found > getValue("Mushrooms Bloom Count") and castSpell("player",102791,true) then return; end
		end

		--[[ 11 - Swiftmend--(cast if hp < value, Glyped or unGlyphed)]]
		if isChecked("Swiftmend") then
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
				if nNova[1].hp <= getValue("Swiftmend") then
					if getBuffRemain(nNova[1].unit,774) > 1 or getBuffRemain(nNova[1].unit,8936) > 1 then
						if castSpell(nNova[1].unit,18562,true) then return; end
					end
				end
			end		
		end

		--[[ 12 - Innervate]]
		if getMana("player") <= getValue("Innervate") then
			if castSpell("player",29166,true) then return; end
		end

		--[[ 13 - WildGrowth Tol --(Tree of Life)]]
		if isKnown(106731) and UnitBuffID("player", 33891) and isChecked("WildGrowth Tol") then
	        for i = 1, #nNova do
		        local allies30Yards = getAllies(nNova[i].unit,30)
		        if #allies30Yards >= getValue("WildGrowth Tol Count") then
			        local count = 0;
			        for j = 1, #allies30Yards do
				        if getHP(allies30Yards[j]) < getValue("WildGrowth Tol") then
				            count = count + 1
				        end
			        end
	                if count > getValue("WildGrowth Tol Count") then
	                    if castSpell(nNova[i].unit,48438,true) then return; end
	                end
			    end
          	end
		end

		--[[ 14 - Regrowth  Tol]]
		if isKnown(106731) and UnitBuffID("player", 33891) and isChecked("Regrowth Tol") then
			for i = 1, #nNova do
			    if (nNova[i].role == "TANK" and nNova[i].hp <= getValue("Regrowth Tank Tol")) 
				  or (nNova[i].role ~= "TANK" and nNova[i].hp <= getValue("Regrowth Tol")) 
			      or (nNova[i].hp <= getValue("Regrowth Omen Tol") and UnitBuffID("player",113043))  then
					if castSpell(nNova[i].unit,8936,true) then return; end
		        end
	        end
		end

		--[[ 15 - Mushrooms Tol or WildMushroom Tank tol--(if not any mushroom active or Replace)]]
		if isKnown(106731) and UnitBuffID("player", 33891) and isChecked("Mushrooms Tol") then
			if isChecked("Mushrooms") and canCast(145205,false,false) and (shroomsTable == nil or #shroomsTable == 0) then
				if castHealGround(145205,15,100,getValue("Mushrooms Tol Count")) then return; end
			end
			if isChecked("Mushrooms Tank Tol") and canCast(145205,false,false) and (shroomsTable == nil or #shroomsTable == 0) then
				for i = 1, nNova do
					if nNova[i].role == "TANK" then
						if castGround(nNova[i].unit, 145205, 40) then return; end
					end
				end
			end	
		end	

		--[[ 16 - reju All Tol --(use reju on all with out health check only Reju buff check)]]
		if isKnown(106731) and UnitBuffID("player", 33891) and isChecked("Rejuvenation All Tol") then
	        for i = 1, #nNova do
		       	if getBuffRemain(nNova[i].unit,774) == 0 then
			        if castSpell(nNova[i].unit,774,true) then return; end
		        end
	        end
		end

		--[[ 17 - Lifebloom - ToL support]]
		if isKnown(106731) and UnitBuffID("player", 33891) then
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

		--[[ 18 - reju Tol --( use reju on player with health check if not lifebloom tol check)]]
		if isKnown(106731) and UnitBuffID("player", 33891) and isChecked("Rejuvenation All Tol") == false then
	        for i = 1, #nNova do
		       	if nNova[i].hp <= getValue("Rejuvenation Tol") and getBuffRemain(nNova[i].unit,774) == 0 then
			        if castSpell(nNova[i].unit,774,true) then return; end
		        end
	        end
		end


		--[[ 19 - Regrowth --(cast regrowth on all usualy between 30 - 40)]]
		if isChecked("Regrowth") and isStanding(0.3) then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Regrowth") then
					if castSpell(nNova[i].unit,8936,true) then return; end
				end
			end
		end

		--[[ 20 - OmenRegrowth--(usualy use omen regrowth on tank even if his health full becuse Living Seed) and (if health other memeber +90)]]
		if isChecked("Regrowth Omen") and getBuffRemain("player",113043) ~= 0 then
			for i = 1, #nNova do
				if nNova[i].role == "TANK" or nNova[i].hp <= getValue("Regrowth Omen") then
					if castSpell(nNova[i].unit,8936,true) then return; end
				end
			end
			if getBuffRemain("player",113043) < 2 and castSpell(nNova[1].unit,8936,true) then return; end
		end		

		--[[ 21 - Regrowth Tank --(cast regrowth on tank usualy between 45 - 60 )]]
		if isChecked("Regrowth Tank") and isStanding(0.3) then
			for i = 1, #nNova do
				if (nNova[i].role == "TANK" and nNova[i].hp <= getValue("Regrowth Tank")) or (nNova[i].role ~= "TANK" and nNova[i].hp <= getValue("Regrowth")) then
					if castSpell(nNova[i].unit,8936,true) then return; end
				end
			end
		end

		--[[ 22 - Swiftmend Harmony]]
		if isChecked("Swiftmend Harmoney") then
			if getBuffRemain("player", 100977) < 3 then
				if getBuffRemain(nNova[1].unit,774) > 1 or getBuffRemain(nNova[1].unit,8936) > 1 then
					if castSpell(nNova[1].unit,18562,true) then return; end
				end
			end
		end

		--[[ 23 - Genesis--(With out Hotkey)]]
		if isChecked("Genesis") and canCast(145518) and (lastGenesis == nil or lastGenesis <= GetTime() - 10) then
			local GenCount=0
			for i=1, #nNova do
				if nNova[i].hp <= getValue("Genesis") and getBuffRemain(nNova[i].unit,774) > 2 then 	
					GenCount = GenCount + 1
					if GenCount >= getValue("Genesis Count") then if castSpell("player",145518,true) then lastGenesis = GetTime(); return; end end 	
				end
			end
		end

		--[[ 24 - WildGrowth all--(Use on all with out health check only with player count check)(some time in fight u need check it fast)]]
		if isChecked("WildGrowth All") then
		    for i = 1, #nNova do
		    	local allies30Yards = getAllies(nNova[i].unit,30);
			    if #allies30Yards >= getValue("WildGrowth All Count") then
		            if castSpell(nNova[i].unit,48438,true) then return; end
				end
			end
		end		

		--[[ 25 - WildGrowth--(Use with health and player count check)]]
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

		--[[ 26 - WildMushroom--(if not any mushroom active )]]
		if isChecked("Mushrooms") and canCast(145205,false,false) and (shroomsTable == nil or #shroomsTable == 0) then
			if castHealGround(145205,15,100,getValue("Mushrooms Count")) then return; end
		end

		--[[ 27 - WildMushroom--(tank check(if not any mushroom active )]]
		if isChecked("Mushrooms") and canCast(145205,false,false) and (shroomsTable == nil or #shroomsTable == 0) then
			if castHealGround(145205,15,100,getValue("Mushrooms Count")) then return; end
		end		


		--[[ 28 - LifebloomFocus--(Refresh if over treshold)]]
      	if isChecked("Lifebloom") then
			if getHP("focus") >= getValue("Lifebloom") and (getBuffRemain("focus",33763) < 4 and getBuffStacks("focus",33763) == 3 ) then
				if castSpell("focus",33763,true) then return; end
			end
		end	
		--[[ 29 - Rejuvenation--(check health and Buff)]]
		if isChecked("Rejuvenation") then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Rejuvenation") and getBuffRemain(nNova[i].unit,774) == 0 then
					if castSpell(nNova[i].unit,774,true) then return; end
				end
			end
		end

		--[[ 30 - WildMushroom--(Replace )]]
		if isChecked("Mushrooms") and canCast(145205,false,false) and (shroomsTable ~= nil and #shroomsTable ~= 0) then
			ISetAsUnitID(shroomsTable[1],"myShroom")
			
			if #allies10Yards < getValue("Mushrooms Count") then
				if castHealGround(145205,15,getValue("Mushrooms") ,getValue("Mushrooms Count")) then return; end
			end
		end		

		--[[ 31- WildMushroom tank--(Replace all)]]
		if isChecked("Mushrooms Tank") and canCast(145205,false,false) and (shroomsTable == nil or #shroomsTable == 0) then
			for i = 1, nNova do
				if nNova[i].role == "TANK" and nNova[i].hp <= getValue("Mushrooms Tank") then
					if castGround(nNova[i].unit, 145205, 40) then return; end
				end
			end
		end	

		--[[ 32 - Rejuvenation all--(if meta proc)(137331 buff id)]]
		if isChecked("Rejuvenation Meta") and getBuffRemain("player",137331) > 0 then
			for i = 1, #nNova do
				if getBuffRemain(nNova[i].unit,774) == 0 then
					if castSpell(nNova[i].unit,774,true) then return; end
				end
			end
		end

		--[[ 33 - reju All --(use reju on all with out health check only Reju buff check)]]
		if isChecked("Rejuvenation All") then
			for i = 1, #nNova do
				if getBuffRemain(nNova[i].unit,774) == 0 then
					if castSpell(nNova[i].unit,774,true) then return; 
					end
				end
			end
		end

		--[[ 34 - OmenRegrowth--()]]
		if isChecked("Regrowth Omen") and UnitBuffID("player",113043) then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Regrowth Omen") then
					if castSpell(nNova[i].unit,8936,true) then return; end
				end
			end
		end

		--[[ 35 - Lifebloom - --(Force Stacks)]]
		if isChecked("Lifebloom") then
			if getBuffStacks("focus",33763) < 3 then
				if castSpell("focus",33763,true) then return; end
			end
		end	

		--[[ 36 - Rejuvenation Tank]]
		if isChecked("Rejuvenation") then
			for i = 1, #nNova do
				if nNova[i].role == "TANK" and nNova[i].hp <= getValue("Rejuvenation Tank") and getBuffRemain(nNova[i].unit,774) == 0 then
					if castSpell(nNova[i].unit,774,true) then return; end
				end
			end
		end

		--[[ 37 - Genesis --(if reju buff remain and health < 60 or custome on single target)]]
		if isChecked("Genesis Filler") and canCast(145518) and (lastGenesis == nil or lastGenesis <= GetTime() - 10) then
			for i=1, #nNova do
				if nNova[i].hp <= getValue("Genesis Filler") and getBuffRemain(nNova[i].unit,774) > 3 then 	
				    if castSpell("player",145518,true) then lastGenesis = GetTime(); return; end 
				end 	
			end
		end

		--[[ 38 - use Rejuvenation for filler--(we can up reju on 5 or 6 player or custome value all time)]]
		if isChecked("Rejuv Filler Count") then
			local numberRejuvUps = 0;
			for i = 1, #nNova do
				if getBuffRemain(nNova[i].unit,774) ~= 0 then
					numberRejuvUps = numberRejuvUps + 1;
				end
			end
			if numberRejuvUps < getValue("Rejuv Filler Count") then
				for i = 1, #nNova do
					if getBuffRemain(nNova[i].unit,774) == 0 then	
						if castSpell(nNova[i].unit,774,true) then return; end
					end
				end
			end
		end
	end
end
end





