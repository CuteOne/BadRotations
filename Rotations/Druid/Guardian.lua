function DruidGuardian()
    if currentConfig ~= "Guardian Masoud" then
    	GuardianConfig()
		GuardianToggles();
		currentConfig = "Guardian Masoud";
	end



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

	--[[Pause toggle]]
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then ChatOverlay("|cffFF0000BadBoy Paused", 0); return; end
	--[[Focus Toggle]]
	if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == 1 then
		RunMacroText("/focus mouseover");
	end

	if isChecked("Zoo Master") and IsOutdoors() and not IsMounted("player") then
		--[[ Flying Form ]]
		if (getFallTime() > 1 or outOfWater()) and not isInCombat("player") and IsFlyableArea() then
			if not (UnitBuffID("player", sff) or UnitBuffID("player", flf)) then
				if castSpell("player", sff) then return; elseif castSpell("player", flf) then return; end
			end
		--[[ Aquatic Form ]]
		elseif IsSwimming() and not UnitBuffID("player",af) and not UnitExists("target") then
			if castSpell("player",af) then return; end
		elseif IsMovingTime(2) and IsFalling() == nil and IsSwimming() == nil and IsFlying() == nil and UnitBuffID("player",783) == nil and UnitBuffID("player", sff) == nil and UnitBuffID("player", flf) == nil then
			if castSpell("player",783) then return; end
		end
	end

	--[[Stop in other forms]]
	if UnitBuffID("player",768) ~= nil then -- Kitty
		if UnitBuffID("player", 5215) ~= nil or UnitBuffID("player", 1850) ~= nil then -- Prowl or Dash
			return false;
		end
	elseif UnitBuffID("player",783) ~= nil then -- Travel
		return false;
	elseif UnitBuffID("player", flf) or UnitBuffID("player", sff) then -- Flight Form
		return false;
	elseif UnitBuffID("player", af) then
		return false;
	end

	--[[ Rebirth ]]
	if isInCombat("player")	and isStanding(0.3) and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("player","mouseover") and not UnitIsUnit("player","traget") then
		if castSpell("mouseover",20484,true,true) then return; end
	end

	--[[ Revive ]]
	if not isInCombat("player") and isStanding(0.3)  and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("player","mouseover") then
		if castSpell("mouseover",50769,true,true) then return; end
	end

	--[[Food/Invis Check]]
	if canRun() ~= true then return false; end
	if castingUnit() then return false; end

--[[ 	-- On GCD After here, palce out of combats spells here
]]
    -- Healthstone
		if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") then
			if canUse(5512) ~= false then
				UseItemByName(tostring(select(1,GetItemInfo(5512))));
			end
		end
	--[[ 1 - Buff Out of Combat]]
	-- Mark of the Wild
	if isChecked("Mark Of The Wild") == true and canCast(1126,false,false) and (lastMotw == nil or lastMotw <= GetTime() - 5) then
		for i = 1, #nNova do
	  		if isPlayer(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{115921,20217,1126,90363}) then
	  			if castSpell("player",1126,true) then lastMotw = GetTime(); return; end
			end
		end
	end

--[[ 	-- Combats Starts Here
]]

	if UnitAffectingCombat("player") then
local isTanking2 = select(2,UnitDetailedThreatSituation("player", "target")) --player is under 100% of threat but is current target
local isTanking3 = select(3,UnitDetailedThreatSituation("player", "target")) --player has 100% of theat and is current target
local Sd = UnitBuffID("player",132402)
local SdBuff = select(4,UnitBuffID("player",132402))
local HasTierCount = select(4,UnitBuffID("player",138217))
		--Single target Rotation

		--thrash_bear,if=debuff.weakened_blows.remains<3

		if  UnitBuffID("player",5487) then
		if targetDistance <= 8 and getDebuffRemain("target",115798,"player") < 3 then
				if castSpell("target",77758,true) then return; end
			end
        end
		--Mangle
		if  UnitBuffID("player",5487) then
		if castSpell("target",33878,false) then return; end end
        -- Maul
		if  UnitBuffID("player",5487) then
		if isChecked("Maul Toggle") == true and SpecificToggle("Maul Toggle") == 1 then
		if castSpell("target",6807,false) then return; end
		end end
		-- SD
		if BadBoy_data["Defensive"] == 1 then
		if  UnitBuffID("player",5487) then
		if UnitPower("player",SPELL_POWER_RAGE) > 59
        and not UnitBuffID("player", 62606)
		and isTanking2 or isTanking3
		then
		if castSpell("player",62606,true) then return; end
		end end end
		-- FR
		if BadBoy_data["Defensive"] == 2 then
		if  UnitBuffID("player",5487) then
		if getHP("player") < 85 and UnitPower("player",SPELL_POWER_RAGE) > 40 then
		if castSpell("player",22842,true) then return; end
		end end end
		-- SD In FR Mode
		if BadBoy_data["Defensive"] == 2 then
		if  UnitBuffID("player",5487) then
		if  UnitPower("player",SPELL_POWER_RAGE) > 90 then
		if castSpell("player",62606,true) then return; end
		end end end
		--Thrash
		if  UnitBuffID("player",5487) then
		if targetDistance <= 8 and getDebuffRemain("target",77758,"player") < 2 then
				if castSpell("target",77758,true) then return; end
			end
        end
		if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
    		meleeEnemies, targetEnemies, ScanTimer = getNumEnemies("player",8), getEnemies("target",10), GetTime();
    	end
        if  UnitBuffID("player",5487) then
    	if canCast(77758) then
			for i = 1, #targetEnemies do
				local Guid = targetEnemies[i]
				ISetAsUnitID(Guid,"thisUnit");
				if getCreatureType("thisUnit") == true and getDebuffRemain("thisUnit",77758,"player") < 2 and getDistance("player","thisUnit") <= 8 then
					if castSpell("player",77758,true) then return; end
				end
			end
		end
        end
		--Siwpe
		if  UnitBuffID("player",5487) then
		if meleeEnemies > 1 then
		 	if castSpell("player",779,true) then return; end
		end
        end


		--Faerie Fire
		if  UnitBuffID("player",5487) then
		if getDebuffRemain("target",770,"player") < 3 then
		 	if castSpell("target",770,true) then return; end
		end
        end
		--Lacerate
		if  UnitBuffID("player",5487) then
		if castSpell("target",33745,false) then return; end
        end
	    --Maul
		if UnitBuffID("player",5487) then
        if Sd and SdBuff > 2
        and isTanking2 or isTanking3
        and UnitPower("player",SPELL_POWER_RAGE) > 80
        and getHP("player") > 75
        and UnitBuffID("player",135288) then
        if castSpell("target",6807,false) then return; end
        elseif
        UnitPower("player",SPELL_POWER_RAGE) > 30
        and getHP("player") > 75
        and not isTanking2 or not isTanking3 then
        if castSpell("target",6807,false) then return; end

        end
        end
		--FR
		if  UnitBuffID("player",5487) then
		if not UnitBuffID("player",138217) then
        if Sd and SdBuff >= 2
           and UnitPower("player",SPELL_POWER_RAGE) > 59
            and getHP("player")< 75 then
            CastSpellByName(tostring(GetSpellInfo(22842)))
        end
        end
	    end

	end
end