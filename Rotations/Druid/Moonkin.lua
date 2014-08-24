if select(3, UnitClass("player")) == 11 then
function DruidMoonkin()
	if currentConfig ~= "Moonkin CodeMyLife" then
		MoonkinConfig();
		MoonkinToggles();
		currentConfig = "Moonkin CodeMyLife";
	end

	local ennemiesTable = getEnnemies("target",20);

	--[[Eclipse Direction]]
	if eclipseDirection == nil then
		if UnitPower("player",8) < 0 then
			if UnitBuffID("player",_EclipseLunar) then
				eclipseDirection = 1;
			else
				eclipseDirection = 0;
			end
		elseif UnitPower("player",8) > 0 then
			if UnitBuffID("player",_EclipseSolar) then
				eclipseDirection = 0;
			else
				eclipseDirection = 1;
			end
		else
			if castSpell("player",_AstralCommunion,true,true) then return; end
		end
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
	if isCasting() then return false; end

--[[ 	-- On GCD After here, palce out of combats spells here
]]	

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
					if nNova[i].dispel == true then
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

		--[[ Mouseover/Target/Focus support]]
		castMouseoverHealing("Druid");

		--[[ 2 - Defencive --(U can use Defencive in cat form)]]
		-- Barkskin if < 30%
		if isChecked("Barkskin") and getHP("player") <= getValue("Barkskin") then
			if castSpell("player",22812,true,false) then return; end
		end

		-- Might of Ursoc
		if isChecked("Might of Ursoc") and getHP("player") <= getValue("Might of Ursoc") then
			if castSpell("player",106922,true,false) then return; end
		end

		-- Bear Management(MoU)
		if UnitBuffID("player",5487) ~= nil and UnitBuffID("player",106922) ~= nil then
			if UnitPower("player",SPELL_POWER_RAGE) >= 60 then
				if castSpell("player",22842,true,false) then return; end
			end
		end

		-- Healthstone
		if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") then
			if canUse(5512) ~= false then
				UseItemByName(tostring(select(1,GetItemInfo(5512))));
			end
		end

		-- MoU Attacks
		if UnitBuffID("player",5487) ~= nil and UnitBuffID("player",106922) ~= nil then
			if castSpell("target",33878,false,false) then return; end
			if getDebuffStacks("target",33745) < 3 or getDebuffRemain("target",33745) < 3 then
				if castSpell("target",33745,false,false) then return; end
			end
			return;
		end

		--[[ 3 - NS healing Touch --(U can NS healing Touch While in cat form)]]
        -- Healing Touch via Ns
		if isChecked("Healing Touch Ns") and canCast(5185,false,false) then
			if getHP("player") <= getValue("Healing Touch Ns") then
				if castSpell("player",132158,true) then 
				    if castSpell("player",5185,true,false) then return; end 
				end
			  	-- For lag  
			   	if UnitBuffID("player",132158) then 
			   		if castSpell("player",5185,true,false) then return; end
			    end
			end
		end

		-- flask,type=warm_sun
		-- food,type=mogu_fish_stew
		-- mark_of_the_wild,if=!aura.str_agi_int.up
		-- wild_mushroom,if=buff.wild_mushroom.stack<buff.wild_mushroom.max_stack
		-- healing_touch,if=!buff.dream_of_cenarius.up&talent.dream_of_cenarius.enabled
		-- moonkin_form
		-- snapshot_stats
		-- jade_serpent_potion

		
		-- jade_serpent_potion,if=buff.bloodlust.react|target.time_to_die<=40|buff.celestial_alignment.up
		
		--[[starfall,if=!buff.starfall.up]]
		if isChecked("Starfall") and not UnitBuffID("player",_Starfall) then
			if castSpell("player",_Starfall,true,false) then return; end
		end

		--[[force_of_nature,if=talent.force_of_nature.enabled]]
		if isChecked("Force Of Nature") and isKnown(_ForceOfNature) then
			if castSpell("target",_ForceOfNature,true,false) then return; end
		end		

		-- berserking,if=buff.celestial_alignment.up
		-- use_item,slot=hands,if=buff.celestial_alignment.up|cooldown.celestial_alignment.remains>30
		-- wild_mushroom_detonate,moving=0,if=buff.wild_mushroom.stack>0&buff.solar_eclipse.up
		-- natures_swiftness,if=talent.dream_of_cenarius.enabled
		-- healing_touch,if=talent.dream_of_cenarius.enabled&!buff.dream_of_cenarius.up&mana.pct>25
		-- incarnation,if=talent.incarnation.enabled&(buff.lunar_eclipse.up|buff.solar_eclipse.up)
		-- celestial_alignment,if=(!buff.lunar_eclipse.up&!buff.solar_eclipse.up)&(buff.chosen_of_elune.up|!talent.incarnation.enabled|cooldown.incarnation.remains>10)
		
		--[[natures_vigil,if=talent.natures_vigil.enabled]]
		if isChecked("Natures Vigil") and isKnown(_NaturesVigil) then
			if castSpell("target",_NaturesVigil,true,false) then return; end
		end

		--[[starsurge,if=buff.shooting_stars.react&(active_enemies<5|!buff.solar_eclipse.up)]]
		if UnitBuffID("player",_ShootingStars) then
			if #ennemiesTable < 5 or not UnitBuffID("player",_EclipseSolar) then
				if castSpell("target",_Starsurge,false,false) then return; end
			end
		end

		--[[moonfire,cycle_targets=1,if=buff.lunar_eclipse.up&(remains<(buff.natures_grace.remains-2+2*set_bonus.tier14_4pc_caster))]]
		if UnitBuffID("player",_EclipseLunar) then
			if getDebuffRemain("target",_Moonfire) < 2 then if castSpell("target",_Moonfire,false,false) then return; end end
			for i = 1, #ennemiesTable do
				ISetAsUnitID(ennemiesTable[i],"thisUnit")
				if getDebuffRemain("thisUnit",_Moonfire) < 2 then
					if castSpell("thisUnit",_Moonfire,false,false) then return; end
				end
			end
		end

		--[[sunfire,cycle_targets=1,if=buff.solar_eclipse.up&(remains<(buff.natures_grace.remains-2+2*set_bonus.tier14_4pc_caster))]]
		if UnitBuffID("player",_EclipseSolar) then
			if getDebuffRemain("target",_Sunfire) < 2 then if castSpell("target",_Sunfire,false,false) then return; end end
			for i = 1, #ennemiesTable do
				ISetAsUnitID(ennemiesTable[i],"thisUnit")
				if getDebuffRemain("thisUnit",_Sunfire) < 2 then
					if castSpell("thisUnit",_Sunfire,false,false) then return; end
				end
			end
		end

		-- hurricane,if=active_enemies>4&buff.solar_eclipse.up&buff.natures_grace.up
		-- moonfire,cycle_targets=1,if=active_enemies<5&(remains<(buff.natures_grace.remains-2+2*set_bonus.tier14_4pc_caster))
		-- sunfire,cycle_targets=1,if=active_enemies<5&(remains<(buff.natures_grace.remains-2+2*set_bonus.tier14_4pc_caster))

		-- hurricane,if=active_enemies>5&buff.solar_eclipse.up&mana.pct>25
		-- moonfire,cycle_targets=1,if=buff.lunar_eclipse.up&ticks_remain<2
		-- sunfire,cycle_targets=1,if=buff.solar_eclipse.up&ticks_remain<2
		
		--[[hurricane,if=active_enemies>4&buff.solar_eclipse.up&mana.pct>25]]
		if isStanding(0.3) and getNumEnnemies("target",10) > 5 and UnitBuffID("player",_EclipseSolar) and getMana("player") > 25 then
			if castGround("target",_Hurricane,30) then return; end
		end
		--[[arcane_storm,if=active_enemies>4&buff.lunar_eclipse.up&mana.pct>25]]
		if isStanding(0.3) and getNumEnnemies("target",10) > 5 and UnitBuffID("player",_EclipseLunar) and getMana("player") > 25 then
			if castGround("target",_ArcaneStorm,30) then return; end
		end

		--[[starsurge,if=cooldown_react]]
		if castSpell("target",_Starsurge,false,true) then return; end

		-- starfire,if=buff.celestial_alignment.up&cast_time<buff.celestial_alignment.remains
		-- wrath,if=buff.celestial_alignment.up&cast_time<buff.celestial_alignment.remains

		--[[starfire,if=eclipse_dir=1|(eclipse_dir=0&eclipse>0)]]
		if isStanding(0.3) and eclipseDirection == 1 and castSpell("target",_Starfire,false,true) then return; end	
		
		--[[wrath,if=eclipse_dir=-1|(eclipse_dir=0&eclipse<=0)]]
		if isStanding(0.3) and eclipseDirection == 0 and castSpell("target",_Wrath,false,true) then return; end		
		
		--[[moonfire,moving=1,cycle_targets=1,if=ticks_remain<2]]
		if getDebuffRemain("target",_Moonfire) < 2 and castSpell("target",_Moonfire,false,false) then return; end
		for i = 1, #ennemiesTable do
			ISetAsUnitID(ennemiesTable[i],"thisUnit")
			if getDebuffRemain("thisUnit",_Moonfire) < 2 then
				if castSpell("thisUnit",_Moonfire,false,false) then return; end
			end
		end

		--[[sunfire,moving=1,cycle_targets=1,if=ticks_remain<2]]
		if getDebuffRemain("target",_Sunfire) < 2 and castSpell("target",_Sunfire,false,false) then return; end
		for i = 1, #ennemiesTable do
			ISetAsUnitID(ennemiesTable[i],"thisUnit")
			if getDebuffRemain("thisUnit",_Sunfire) < 2 then
				if castSpell("thisUnit",_Sunfire,false,false) then return; end
			end
		end
		--wild_mushroom,moving=1,if=buff.wild_mushroom.stack<buff.wild_mushroom.max_stack

		--[[starsurge,moving=1,if=buff.shooting_stars.react]]
		if UnitBuffID("player",_ShootingStars) and castSpell("target",_Starsurge,false,true) then return; end
		
		--[[moonfire,moving=1,if=buff.lunar_eclipse.up]]
		if UnitBuffID("player",_EclipseLunar) then
			if getDebuffRemain("target",_Moonfire) < 5 and castSpell("target",_Moonfire,false,false) then return; end
			for i = 1, #ennemiesTable do
				ISetAsUnitID(ennemiesTable[i],"thisUnit")
				if getDebuffRemain("thisUnit",_Moonfire) < 5 then
					if castSpell("thisUnit",_Moonfire,false,false) then return; end
				end
			end
			if castSpell("target",_Moonfire,false,false) then return; end
		end
		
		--[[sunfire,moving=1]]	
		if UnitBuffID("target",_Sunfire) and castSpell("target",_Sunfire,false,false) then return; end
		for i = 1, #ennemiesTable do
			ISetAsUnitID(ennemiesTable[i],"thisUnit")
			if getDebuffRemain("thisUnit",_Sunfire) < 5 then
				if castSpell("thisUnit",_Sunfire,false,false) then return; end
			end
		end
		if castSpell("target",_Sunfire,false,false) then return; end
	end
end
end





