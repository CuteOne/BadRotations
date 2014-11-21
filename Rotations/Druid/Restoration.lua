if select(3, UnitClass("player")) == 11 then
function DruidRestoration()
	if currentConfig ~= "Restoration Masou" then
		RestorationConfig();
		RestorationToggles();
		currentConfig = "Restoration Masou";
	end


	--[[Lowest]]
	lowestHP, lowestUnit, lowestTankHP, lowestTankUnit, averageHealth = 100, "player", 100, "player", 0;
	for i = 1, #nNova do
		if nNova[i].role == "TANK" then
			if nNova[i].hp < lowestTankHP then
				lowestTankHP = nNova[i].hp;
				lowestTankUnit = nNova[i].unit;
			end
		end
		if nNova[i].hp < lowestHP then
			lowestHP = nNova[i].hp;
			lowestUnit = nNova[i].unit;
		end
		averageHealth = averageHealth + nNova[i].hp;
	end
	averageHealth = averageHealth/#nNova;

	--[[Follow Tank]]
	if isChecked("Follow Tank") then
		local favoriteTank = { name = "NONE" , health = 0};
		if UnitExists("focus") == nil and favoriteTank.name == "NONE" then
			for i = 1, # nNova do
				if UnitIsDeadOrGhost("focus") == nil and nNova[i].role == "TANK" and UnitHealthMax(nNova[i].unit) > favoriteTank.health then
					favoriteTank = { name = UnitName(nNova[i].unit), health = UnitHealthMax(nNova[i].unit) }
					RunMacroText("/focus "..favoriteTank.name)
				end
			end
		end
		if GetUnitSpeed("focus") == 0 and isStanding(0.5) and UnitCastingInfo("player") == nil and UnitChannelInfo("player") == nil and UnitIsDeadOrGhost("focus") == nil and UnitExists("focus") ~= nil and getDistance("player", "focus") > getValue("Follow Tank") then
			local myDistance = getDistance("player", "focus");
			local myTankFollowDistance = getValue("Follow Tank");
			local myDistanceToMove = myDistance - myTankFollowDistance;
			if Player ~= nil and Focus ~= nil then
				MoveTo (GetPointBetweenObjects(Player, Focus, myDistanceToMove+5));
			end
		end
		if UnitIsDeadOrGhost("focus") then
			if favoriteTank.name ~= "NONE" then
				favoriteTank = { name = "NONE" , health = 0};
				ClearFocus()
			end
		end
	end
    -- Wild Mushroom Toggle
	if isChecked("WildMushroom") and SpecificToggle("WildMushroom") == true then
      if not IsMouselooking() then
          CastSpellByName(GetSpellInfo(145205))
          if SpellIsTargeting() then
              CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
              return true;
          end
      end
  	end
	-- Reju  Toggle
	if isChecked("Reju Toggle")  and SpecificToggle("Reju Toggle") == true then
		for i = 1, #nNova do
			if nNova[i].hp <= 249 and getBuffRemain(nNova[i].unit,774,"player") == 0 then
				if castSpell(nNova[i].unit,774,true,false) then return; end
			end
		end
	end
	-- WildGroth Toggle
    if isChecked("WG Toggle") and SpecificToggle("WG Toggle") == true then
		    for i = 1, #nNova do
		    	if nNova[i].hp < 249 then
			    	local allies30Yards = getAllies(nNova[i].unit,30);
				    if #allies30Yards >= 1 then
			            if castSpell(nNova[i].unit,48438,true,false) then return; end
					end
				end
			end
		end
	-- Regrowht Toggle
	if isChecked("Regrowht Toggle") and SpecificToggle("Regrowht Toggle") == true then
			if not UnitIsDeadOrGhost("mouseover") then
				if castSpell("mouseover",8936,true,false) then return; end
			end
		end
	-- Pause toggle
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then ChatOverlay("|cffFF0000BadBoy Paused", 0); return; end
	-- Focus Toggle
	if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == true then
		RunMacroText("/focus mouseover");
	end

	-- Stop in other forms
	if UnitBuffID("player",768) ~= nil then -- Kitty
		if UnitBuffID("player", 5215) ~= nil or UnitBuffID("player", 1850) ~= nil then -- Prowl or Dash
			return false;
		end
	elseif UnitBuffID("player",783) ~= nil then -- Travel
		return false;
	elseif UnitBuffID("player", af) then
		return false;
	end



	--[[ Rebirth ]]
	if (isChecked("MouseOver Rebirth") and isChecked("Rebirth Toggle") ~= true) or (isChecked("Rebirth Toggle") and SpecificToggle("Rebirth Toggle") == true) then
	if isInCombat("player")	and isStanding(0.3) and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("player","mouseover")
	and getSpellCD(20484) == 0 then
		CastSpellByName(GetSpellInfo(20484),"mouseover") return; end
	end

	--[[ Revive ]]
	if isChecked("Revive") then
	if not isInCombat("player") and isStanding(0.3)  and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("player","mouseover") then
		CastSpellByName(GetSpellInfo(50769),"mouseover") return; end
	end

	--[[ 7 - Stop Casting--(perevent from over healing when u cast somthing can heal target)]]
	if isChecked("Overhealing Cancel") and isCastingDruid() and shouldNotOverheal(spellCastTarget) >= getValue("Overhealing Cancel") and SpecificToggle("Regrowht Toggle") == false then
		local noOverHealSpells = {5185}
		local castingSpell = UnitCastingInfo("player")
		if castingSpell ~= nil then
			for i = 1, #noOverHealSpells do
				if (GetSpellInfo(noOverHealSpells[i]) == castingSpell and getBuffRemain("player", 100977) > 5) or (isCastingSpell(8936) and UnitBuffID("player",16870) == nil) then RunMacroText("/stopcasting"); return; end
			end
		end
	end
-- Stop Cast HealingToch
if isChecked("Healing Touch") or isChecked("Healing Touch Tank") then
	if isCastingSpell(5185) then
	if (getLowAllies(60) > 1 
	or lowestHP <= getValue("Regrowth Tank") 
	or lowestHP <= getValue("Regrowth"))
	and select(2,DruidCastTime()) >= 1 then 
	RunMacroText("/stopcasting");return end end end
-- Food/Invis Check
	if canRun() ~= true then return false; end

--[[ 	-- On GCD After here, palce out of combats spells here
]]
	if isCastingDruid() then return false; end
	if isCastingSpell(740) then return false; end

--[[ 	-- Combats Starts Here
]]

	--[[ 1 - Buff Out of Combat]]
	-- Mark of the Wild
	if isChecked("Mark Of The Wild") == true and canCast(1126,false,false) and (lastMotw == nil or lastMotw <= GetTime() - 5) then
		for i = 1, #nNova do
			if nNova[i].hp < 249 then
		  		if isPlayer(nNova[i].unit) == true and UnitIsVisible(nNova[i].unit) and not isBuffed(nNova[i].unit,{115921,20217,1126,90363}) then
		  			if castSpell("player",1126,true,false) then lastMotw = GetTime(); return; end
				end
			end
		end
	end

	if BadBoy_data["Healing"] == 2 then

		--[[ 4 - Dispel --(U can Dispel  While in cat form)]]
		if isChecked("Nature's Cure") and canCast(88423,false,false) and not (getBossID("boss1") == 71734 and not UnitBuffID("player",144359)) then
			if getValue("Nature's Cure") == 1 then -- Mouse Match
				if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
					for i = 1, #nNova do
						if nNova[i].guid == UnitGUID("mouseover") and nNova[i].dispel == true then
							if castSpell(nNova[i].unit,88423, true,false) then return; end
						end
					end
				end
			elseif getValue("Nature's Cure") == 2 then -- Raid Match
				for i = 1, #nNova do
					if nNova[i].hp < 249 and nNova[i].dispel == true then
						if castSpell(nNova[i].unit,88423, true,false) then return; end
					end
				end
			elseif getValue("Nature's Cure") == 3 then -- Mouse All
				if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
				    for n = 1,40 do
				      	local buff,_,_,count,bufftype,duration = UnitDebuff("mouseover", n)
			      		if buff then
			        		if bufftype == "Magic" or bufftype == "Curse" or bufftype == "Poison" then
			        			if castSpell("mouseover",88423, true,false) then return; end
			        		end
			      		else
			        		break;
			      		end
				  	end
				end
			elseif getValue("Nature's Cure") == 4 then -- Raid All
				for i = 1, #nNova do
					if nNova[i].hp < 249 then
					    for n = 1,40 do
					      	local buff,_,_,count,bufftype,duration = UnitDebuff(nNova[i].unit, n)
				      		if buff then
				        		if bufftype == "Magic" or bufftype == "Curse" or bufftype == "Poison" then
				        			if castSpell(nNova[i].unit,88423, true,false) then return; end
				        		end
				      		else
				        		break;
				      		end
					  	end
					  end
				end
			end
		end

		--[[ Mouseover/Target/Focus support]]
		castMouseoverHealing("Druid");

		--[[ 2 - Defencive --(U can use Defencive in cat form)]]
		-- Barkskin if < 30%
		if isChecked("Barkskin") and getHP("player") <= getValue("Barkskin") then
			if castSpell("player",22812,true,false) then return; end
		end

		-- Healthstone
		if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") then
			if canUse(5512) ~= false then
				UseItemByName(tostring(select(1,GetItemInfo(5512))));
			end
		end

		--[[ 3 - NS healing Touch --(U can NS healing Touch While in cat form)]]
        -- Healing Touch via Ns
		if isChecked("Healing Touch Ns") and canCast(5185,false,false) and lowestHP <= getValue("Healing Touch Ns") then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Healing Touch Ns") and getDistance(nNova[i].unit,"player") < 43 then
				   	if castSpell("player",132158,true,false) then
				   		if castSpell(nNova[i].unit,5185,true,false) then return; end
				   	end
				  	-- For lag
				   	if UnitBuffID("player",132158) then
				   		if castSpell(nNova[i].unit,5185,true,false) then return; end
				    end
				end
			end
		end

		--[[ 5 - DPs --(range and  melee)]]
		if BadBoy_data["DPS"] == 2 and not (isChecked("Safe DPS Treshold") and lowestHP < getValue("Safe DPS Treshold")) then
			if isChecked("DPS Toggle") == true and SpecificToggle("DPS Toggle") == true  then
		        -- Let's get angry :D
		        makeEnemiesTable(40)
		        if UnitExists("target") == true and UnitCanAttack("target","player") == true then
		        	myTarget = "target"
		        	myDistance = targetDistance
		        elseif enemiesTable and enemiesTable[1] ~= nil then
		        	myTarget = enemiesTable[1].unit
		        	myDistance = enemiesTable[1].distance
		        else
		        	myTarget = "target"
		        end
			    if UnitExists(myTarget) and UnitCanAttack(myTarget,"player") == true then
					if myDistance < 5 and not isChecked("No Kitty DPS") then
						--- Catform
				  		if not UnitBuffID("player",768) and not UnitBuffID("player",783) and not UnitBuffID("player",5487) then
							if castSpell("player",768,true,false) then catSwapped = GetTime() return; end
						end
						if UnitBuffID("player",768) and catSwapped <= GetTime() - 1.5 then
							-- Ferocious Bite
							if getCombo() == 5 and UnitBuffID("player",768) ~= nil then
								if castSpell(myTarget,22568,false,false) then return; end
							end
							-- Trash
							if getDebuffRemain(myTarget,106830) < 2 then
								if castSpell("player",106832,false,false) then return; end
							end
							-- Shred
							if castSpell(myTarget,5221,false,false) then return; end
						end
					else
						if UnitBuffID("player",768) ~= nil then
							CancelShapeshiftForm();
						end
						-- Moonfire
						if isChecked("Multidotting") then
							MultiMoon()
						end

						if isStanding(0.1) == false then
							-- MonFire Spam
							if castSpell(myTarget,_Moonfire,false,false) then return; end
						else
						if getDebuffRemain(myTarget,164812) < 2 then
						if castSpell(myTarget,_Moonfire,false,false) then return; end end
						-- Wrath
							if castSpell(myTarget,5176,false,true) then return; end

					end
				end
			end

			else
				if UnitBuffID("player",768) ~= nil then
					CancelShapeshiftForm();
				end
			end
		end

	    --[[ 6 - Genesis--(WITH Hotkey)]]
        if isChecked("Genesis Toggle") and SpecificToggle("Genesis Toggle") == true and GetCurrentKeyBoardFocus() == nil then
			if canCast(145518,false,false) then
				if castSpell("player",145518,true,false) then return; end
			end
		end

		--[[ 7 - Stop Casting--(perevent from over healing when u cast somthing can heal target) Placed at top]]



		--[[ 8 - Force Of Nature]]
		if isKnown(102693) then --FOn Spell ID
		    if isChecked("Force of Nature") and canCast(102693,false,false) and lowestHP < getValue("Force of Nature") then
		        for i = 1, #nNova do
		        	if nNova[i].hp < 249 then
			            local allies10Yards = getAllies(nNova[i].unit,10);
						if #allies10Yards >=  getValue("Force of Nature Count") then
							local count = 0;
							for j = 1, #allies10Yards do
								if getHP(allies10Yards[j]) < getValue("Force of Nature") then
									count = count + 1;
								end
							end
							if count >= getValue("Force of Nature Count") and (lastFon  == nil or lastFon  <= GetTime() - 2) then -- Set Delay for Cast
								if castSpell(nNova[i].unit,102693,true,false) then lastFon = GetTime(); return; end
							end
						end
					end
				end
			end
		end

		--[[ 9 - HealingTouch Sm]]
 		local SMName, _, _, SMcount, _, _, SMexpirationTime = UnitBuffID("player", 144871) --Sage Mender - 2p bonus tier 16
		if SMName and  SMcount >= 5   then
			if isChecked("Healing Touch Sm") == true and lowestHP <= getValue("Healing Touch Sm") then
				if castSpell(lowestUnit,5185,true,false) then return; end
			end
		end

		--[[ 11 - Swiftmend--(cast if hp < value, Glyped or unGlyphed)]]
		if isKnown(114107) ~= true then
			SwiftMender();
		end

		--[[ 13 - WildGrowth Tol --(Tree of Life)]]
		if isKnown(33891) and isChecked("WildGrowth Tol") and UnitBuffID("player", 33891) and isStanding(0.3) and canCast(48438,false,false) and lowestHP < getValue("WildGrowth Tol") then
	        for i = 1, #nNova do
	        	if nNova[i].hp < 249 then
			        local allies30Yards = getAllies(nNova[i].unit,30);
			        if #allies30Yards >= getValue("WildGrowth Tol Count") then
				        local count = 0;
				        for j = 1, #allies30Yards do
					        if getHP(allies30Yards[j]) < getValue("WildGrowth Tol") then
					            count = count + 1;
					        end
				        end
		                if count > getValue("WildGrowth Tol Count") then
		                    if castSpell(nNova[i].unit,48438,true) then return; end
		                end
				    end
				end
          	end
		end

		--[[ 14 - Regrowth  Tol]]
		if isKnown(33891) and UnitBuffID("player", 33891) and canCast(8936,false,false) and (lowestHP < getValue("Regrowth Tank Tol") or lowestHP < getValue("Regrowth Tol") or lowestHP < getValue("Regrowth Omen Tol")) then
			for i = 1, #nNova do
				if nNova[i].hp < 249 then
				    if (isChecked("Regrowth Tank Tol") and nNova[i].role == "TANK" and nNova[i].hp <= getValue("Regrowth Tank Tol"))
					  or (isChecked("Regrowth Tol") and nNova[i].role ~= "TANK" and nNova[i].hp <= getValue("Regrowth Tol"))
				      or (isChecked("Regrowth Omen Tol") and nNova[i].hp <= getValue("Regrowth Omen Tol") and getBuffRemain("player",16870) > 1)  then
						if castSpell(nNova[i].unit,8936,true,false) then return; end
			        end
			    end
	        end
		end

		--[[ 15 - WildMushroom(if not any mushroom active )]]
		if isKnown(33891) and UnitBuffID("player", 33891) then
		if isChecked("Mushrooms") and (getValue("Mushrooms Who") == 2 or UnitExists("focus") == false) and (shroomTimer == nil or shroomTimer <= GetTime() - 2) then
			if canCast(145205,false,false) and (shroomsTable == nil or #shroomsTable == 0 or shroomsTable[1].guid == nil) then
				if castHealGround(145205,15,100,3) then  shroomTimer = GetTime() spellDebug("Shroom Tol Applied to 3 units for 1st time.") return; end
			end
		end
    end
		--[[ 15.1 - WildMushroom(Replace)]]
		if isKnown(33891) and UnitBuffID("player", 33891) then
		if isChecked("Mushrooms") and (getValue("Mushrooms Who") == 2 or UnitExists("focus") == false) and (shroomTimer == nil or shroomTimer <= GetTime() - 2) then
			if canCast(145205,false,false) and (shroomsTable ~= nil and #shroomsTable ~= 0) and lowestHP <= getValue("Mushrooms") then
				if shroomsTable ~= nil and findShroom() then
					local allies10Yards = getAlliesInLocation(shroomsTable[1].x,shroomsTable[1].y,shroomsTable[1].z,15)
					if #allies10Yards < 3 then
						if castHealGround(145205,15,getValue("Mushrooms") ,3) then shroomTimer = GetTime() spellDebug("Shroom Tol Rapplied to 3 units.") return; end
					end
				end
			end
		end
    end
		--[[ 15.2 - WildMushroom Tank(if not any mushroom active )]]
		if isKnown(33891) and UnitBuffID("player", 33891) then
		if isChecked("Mushrooms") and getValue("Mushrooms Who") == 1 then
			if GetUnitSpeed("focus") == 0 and canCast(145205,false,false) and (shroomsTable == nil or #shroomsTable == 0 or shroomsTable[1].guid == nil) then
				if castGround("focus", 145205, 40) then  shroomTimer = GetTime() spellDebug("Shroom Tol Applied to tank for 1st time.") return; end
			end
		end
    end
		--[[ 16 - reju All Tol --(use reju on all with out health check only Reju buff check)]]
		if isKnown(33891) and isChecked("Rejuvenation All Tol") and UnitBuffID("player", 33891) and canCast(774,false,false) then
	        for i = 1, #nNova do
		       	if nNova[i].hp < 249 and getBuffRemain(nNova[i].unit,774,"player") == 0 then
			        if castSpell(nNova[i].unit,774,true,false) then return; end
		        end
	        end
		end

		--[[ 18 - reju Tol --( use reju on player with health check if not lifebloom tol check)]]
		if isKnown(33891)  and UnitBuffID("player", 33891) and canCast(774,false,false) and lowestHP < getValue("Rejuvenation Tol") then
	        for i = 1, #nNova do
		       	if nNova[i].hp <= getValue("Rejuvenation Tol") and getBuffRemain(nNova[i].unit,774,"player") == 0 then
			        if castSpell(nNova[i].unit,774,true,false) then return; end
		        end
	        end
		end
        	--[[ 18.1 - WildMushroom tank(Replace)]]
	if isKnown(33891) and UnitBuffID("player", 33891) then
		if isChecked("Mushrooms") and getValue("Mushrooms Who") == 1 and (shroomTimer == nil or shroomTimer <= GetTime() - 2) then
			if GetUnitSpeed("focus") == 0 and canCast(145205,false,false) then
				if shroomsTable ~= nil and #shroomsTable ~= 0 and findShroom() then
					if getDistanceToObject("focus",shroomsTable[1].x,shroomsTable[1].y,shroomsTable[1].z) > 12 then
						if castGround("focus", 145205, 40) then shroomTimer = GetTime() spellDebug("Shroom Tol Reapplied to tank.") return; end
					end
				end
			end
		end
	end

      
		
		--[[ 20 - Regrowth --(cast regrowth on all usualy between 30 - 40)]]
		if isChecked("Regrowth") and isStanding(0.3) and canCast(8936,false,true) and lowestHP <= getValue("Regrowth") then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Regrowth") then
					if castSpell(nNova[i].unit,8936,true) then return; end
				end
			end
		end
--[[ 21 - Regrowth Tank --(cast regrowth on tank usualy between 45 - 60 )]]
		if isChecked("Regrowth Tank") and isStanding(0.3) and canCast(8936,false,true) and lowestTankHP <= getValue("Regrowth Tank") then
			for i = 1, #nNova do
				if (nNova[i].role == "TANK" and nNova[i].hp <= getValue("Regrowth Tank")) then
					if castSpell(nNova[i].unit,8936,true) then return; end
				end
			end
		end
			--[[ 37 - Genesis --(if reju buff remain and health < 60 or custome on single target)]]
		if isChecked("Genesis Filler") and canCast(145518,false,false) and lowestHP < getValue("Genesis Filler") and getLowAllies(75) < 2 then
			for i=1, #nNova do
				if nNova[i].hp <= getValue("Genesis Filler") and getBuffRemain(nNova[i].unit,774,"player") > 3 and not UnitBuffID(nNova[i].unit,162359,"player") then
				    if castSpell("player",145518,true,false) then return; end
				end
			end
		end
         --[[ 34 - OmenRegrowth--()]]
		if isChecked("Regrowth Omen") and isStanding(0.3) and UnitBuffID("player",16870) and canCast(8936,false,false) and lowestHP < getValue("Regrowth Omen") and getLowAllies(70) < 3 then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Regrowth Omen") then
					if castSpell(nNova[i].unit,8936,true) then return; end
				end
			end
		end
		--[[ 22 - Harmony]]
		if isKnown(114107) ~= true then
			if UnitAffectingCombat("player") and isChecked("Swiftmend Harmoney") then
				if getBuffRemain("player", 100977) < 3 then
               for i = 1, #nNova do
				if (getBuffRemain(nNova[i].unit,774,"player") > 1 or getBuffRemain(nNova[i].unit,8936,"player") > 1) and getSpellCD(18562) == 0 then
						-- Swiftmend
						CastSpellByName(GetSpellInfo(18562),nNova[i].unit) return true
						--if castSpell(nNova[i].unit,18562,true,false) then return; end
					end
				end
			end
		end
		else
			if isChecked("Harmoney SotF") == true and getBuffRemain("player", 100977) < 3 then
				-- Natures Swiftness
				if castSpell("player",132158,true) then return; end
		   		-- Healing Touch
			   	if UnitBuffID("player",132158) then
			   		if castSpell(lowestUnit,5185,true,false) then return; end
			    end
			    -- Regrowth
				if castSpell(lowestUnit,8936,true) then return; end
			end
		end

		--[[ 23 - Genesis--(With out Hotkey)]]
		if isChecked("Genesis") == true and canCast(145518,false,false) and lowestHP < getValue("Genesis") then
			local GenCount=0
			for i=1, #nNova do
				if nNova[i].hp <= getValue("Genesis") and getBuffRemain(nNova[i].unit,774,"player") > 2 and not UnitBuffID(nNova[i].unit,162359,"player") then
					GenCount = GenCount + 1
					if GenCount >= getValue("Genesis Count") then if castSpell("player",145518,true,false) then return; end end
				end
			end
		end

		--[[ 24 - WildGrowth all--(Use on all with out health check only with player count check)(some time in fight u need check it fast)]]
		if isChecked("WildGrowth All") and isStanding(0.3) and canCast(48438,false,false) then
		    for i = 1, #nNova do
		    	if nNova[i].hp < 249 then
			    	local allies30Yards = getAllies(nNova[i].unit,30);
				    if #allies30Yards >= getValue("WildGrowth All Count") then
			            if castSpell(nNova[i].unit,48438,true) then return; end
					end
				end
			end
		end

		--[[ 25 - WildGrowth--(Use with health and player count check)]]
		if isChecked("WildGrowth") and isStanding(0.3) and canCast(48438,false,false) and lowestHP < getValue("WildGrowth") then
			if isKnown(114107) ~= true and getSpellCD(48438) < 2 then
				for i = 1, #nNova do
					local allies30Yards = 0;
					for j = 1, # nNova do
						if nNova[j].hp < getValue("WildGrowth") and getDistance(nNova[i].unit,nNova[j].unit) <= 30 then
							allies30Yards = allies30Yards + 1;
							if allies30Yards > getValue("WildGrowth Count") then break; end
						end
					end
					if allies30Yards > getValue("WildGrowth Count") then
						if castSpell(nNova[i].unit,48438,true) then return; end
					end
				end
			elseif getSpellCD(48438) < 2 and canCast(48438,false,false) then
				for i = 1, #nNova do
					local allies30Yards = 0;
					for j = 1, # nNova do
						if nNova[j].hp < getValue("WildGrowth SotF") and getDistance(nNova[i].unit,nNova[j].unit) <= 30 then
							allies30Yards = allies30Yards + 1;
							if allies30Yards > getValue("WildGrowth Count") then break; end
						end
					end
					if allies30Yards > getValue("WildGrowth SotF Count") then
						SwiftMender(getSpellCD(48438));
						if castSpell(nNova[i].unit,48438,true) then return; end
					end
				end
			end
		end

	--[[ 18.5 - LifeBloom Fast Swich]]
		if isChecked("Lifebloom") and canCast(33763,false,false) then
	    	for i = 1, #nNova do
				if nNova[i].hp < 249 and not UnitIsDeadOrGhost("focus") and getBuffRemain("focus",33763) == 0 and UnitExists("focus")
				and getDistance("player","focus") < 43 then
					if castSpell("focus",33763,true,false) then return; end
				end
			end
		end
		--[[ 26 - WildMushroom(if not any mushroom active )]]
		if isChecked("Mushrooms") and (getValue("Mushrooms Who") == 2 or UnitExists("focus") == false) and (shroomTimer == nil or shroomTimer <= GetTime() - 2) then
			if canCast(145205,false,false) and (shroomsTable == nil or #shroomsTable == 0 or shroomsTable[1].guid == nil) then
				if castHealGround(145205,15,100,3) then  shroomTimer = GetTime() spellDebug("Shroom Applied to 3 units for 1st time.") return; end
			end
		end

		--[[ 30 - WildMushroom(Replace)]]
		if isChecked("Mushrooms") and (getValue("Mushrooms Who") == 2 or UnitExists("focus") == false) and (shroomTimer == nil or shroomTimer <= GetTime() - 2) then
			if canCast(145205,false,false) and (shroomsTable ~= nil and #shroomsTable ~= 0) and lowestHP <= getValue("Mushrooms") then
				if shroomsTable ~= nil and findShroom() then
					local allies10Yards = getAlliesInLocation(shroomsTable[1].x,shroomsTable[1].y,shroomsTable[1].z,15)
					if #allies10Yards < 3 then
						if castHealGround(145205,15,getValue("Mushrooms") ,3) then shroomTimer = GetTime() spellDebug("Shroom Rapplied to 3 units.") return; end
					end
				end
			end
		end

		--[[ 27 - WildMushroom Tank(if not any mushroom active )]]
		if isChecked("Mushrooms") and getValue("Mushrooms Who") == 1 then
			if GetUnitSpeed("focus") == 0 and canCast(145205,false,false) and (shroomsTable == nil or #shroomsTable == 0 or shroomsTable[1].guid == nil) then
				if castGround("focus", 145205, 40) then  shroomTimer = GetTime() spellDebug("Shroom Applied to tank for 1st time.") return; end
			end
		end












		--[[ 28 - LifebloomFocus--(Refresh if over treshold)]]
      	if isChecked("Lifebloom") then
			if not UnitIsDeadOrGhost("focus") and getHP("focus") >= getValue("Lifebloom") and getBuffRemain("focus",33763,"player") < 2
			and getDistance("player","focus") < 43 and UnitExists("focus") then
				if castSpell("focus",33763,true,false) then return; end
			end
		end

		--[[ 29 - Rejuvenation--(check health and Buff)]]
		if isChecked("Rejuvenation") and canCast(774,false,false) and lowestHP < getValue("Rejuvenation") then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Rejuvenation") and getBuffRemain(nNova[i].unit,774,"player") == 0 then
					if castSpell(nNova[i].unit,774,true,false) then return; end
				end
			end
		end

		--[[ Hot Friendly Dot ]]
		if isChecked("Rejuvenation Debuff") and friendlyDot ~= nil and canCast(774,false,false) and lowestHP < getValue("Rejuvenation Debuff") then
			for i = 1, #nNova do
				if nNova[i].hp < 249 and friendlyDot[nNova[i].guid] ~= nil then
					if GetTime() - friendlyDot[nNova[i].guid] < 3 then
						if getBuffRemain(nNova[i].unit, 774,"player") == 0 then
							if castSpell(nNova[i].unit, 774, true, false) then return; end
						end
					else
						friendlyDot[nNova[i].guid] = nil;
					end
				end
			end
		end












		--[[ 31- WildMushroom tank(Replace)]]
		if isChecked("Mushrooms") and getValue("Mushrooms Who") == 1 and (shroomTimer == nil or shroomTimer <= GetTime() - 2) then
			if GetUnitSpeed("focus") == 0 and canCast(145205,false,false) then
				if shroomsTable ~= nil and #shroomsTable ~= 0 and findShroom() then
					if getDistanceToObject("focus",shroomsTable[1].x,shroomsTable[1].y,shroomsTable[1].z) > 12 then
						if castGround("focus", 145205, 40) then shroomTimer = GetTime() spellDebug("Shroom Reapplied to tank.") return; end
					end
				end
			end
		end














		--[[ 32 - Rejuvenation all--(if meta proc)(137331 buff id)]]
		if isChecked("Rejuvenation Meta") and getBuffRemain("player",137331) > 0 and canCast(774,false,false) then
			for i = 1, #nNova do
				if getBuffRemain(nNova[i].unit,774,"player") == 0 and nNova[i].hp <= 100 then
					if castSpell(nNova[i].unit,774,true,false) then return; end
				end
			end
		end

		--[[ 33 - reju All --(use reju on all with out health check only Reju buff check)]]
		if isChecked("Rejuvenation All") and canCast(774,false,false) then
			for i = 1, #nNova do
				if nNova[i].hp < 249 and getBuffRemain(nNova[i].unit,774,"player") == 0 then
					if castSpell(nNova[i].unit,774,true,false) then return; end
				end
			end
		end

		--[[ 34 - OmenRegrowth--()]]
		if isChecked("Regrowth Omen") and isStanding(0.3) and UnitBuffID("player",16870) and canCast(8936,false,false) and lowestHP < getValue("Regrowth Omen") then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Regrowth Omen") then
					if castSpell(nNova[i].unit,8936,true) then return; end
				end
			end
		end



		--[[ 36 - Rejuvenation Tank]]
		if isChecked("Rejuvenation Tank") and canCast(774,false,false) and lowestTankHP < getValue("Rejuvenation Tank") then
   			for i = 1, #nNova do
    			if (nNova[i].role == "TANK" or UnitGroupRolesAssigned(nNova[i].unit) == "TANK") and nNova[i].hp <= getValue("Rejuvenation Tank") and getBuffRemain(nNova[i].unit,774,"player") == 0 then
     				if castSpell(nNova[i].unit,774,true,false) then return; end
    			end
   			end
  		end

		--[[ 37 - Genesis --(if reju buff remain and health < 60 or custome on single target)]]
		if isChecked("Genesis Filler") and canCast(145518,false,false) and lowestHP < getValue("Genesis Filler") then
			for i=1, #nNova do
				if nNova[i].hp <= getValue("Genesis Filler") and getBuffRemain(nNova[i].unit,774,"player") > 3 and not UnitBuffID(nNova[i].unit,162359,"player") then
				    if castSpell("player",145518,true,false) then return; end
				end
			end
		end

		--[[ 38 - use Rejuvenation for filler--(we can up reju on 5 or 6 player or custome value all time)]]
		if isChecked("Rejuv Filler Count") and canCast(774,false,false) then
			local numberRejuvUps = 0;
			for i = 1, #nNova do
				if getBuffRemain(nNova[i].unit,774,"player") ~= 0 then
					numberRejuvUps = numberRejuvUps + 1;
				end
			end
			if numberRejuvUps < getValue("Rejuv Filler Count") then
				for i = 1, #nNova do
					if nNova[i].hp < 249 and getBuffRemain(nNova[i].unit,774,"player") == 0 then
						if castSpell(nNova[i].unit,774,true,false) then return; end
					end
				end
			end
		end
	  
	 
	  -- Healing Touch -- Harmoney
if isChecked("Healing Touch") and isStanding(0.3) and canCast(5185,false,true) then	 
	if getBuffRemain("player", 100977) < 5 then
	for i = 1, #nNova do
				if nNova[i].hp <= 249 then
	  if castSpell(nNova[i].unit,5185,true) then return; end
	  end
	  end
	  end
	  end
	  --[[ 19 - Healing Touch --(cast Healing Touch on all usualy between 70 - 90)]]
		if isChecked("Healing Touch") and isStanding(0.3) and canCast(5185,false,true) and lowestHP <= getValue("Healing Touch") then
			if (lowestHP > getValue("Regrowth Tank") or lowestHP > getValue("Regrowth")) then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Healing Touch") then
					if castSpell(nNova[i].unit,5185,true) then return; end
				end
			end
		end
		end
		--[[ 19.5 - Healing Touch Tank --(cast Healing Touch on tank usualy between 60 - 90 )]]
		if isChecked("Healing Touch Tank") and isStanding(0.3) and canCast(5185,false,true) and lowestTankHP <= getValue("Healing Touch Tank") then
			if (lowestHP > getValue("Regrowth Tank") or lowestHP > getValue("Regrowth")) then
			for i = 1, #nNova do
				if (nNova[i].role == "TANK" and nNova[i].hp <= getValue("Healing Touch Tank")) then
					if castSpell(nNova[i].unit,5185,true) then return; end
				end
			end
		end
	
	end
end
end

end



