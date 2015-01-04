if select(3, UnitClass("player")) == 11 then
function DruidMoonkin()
	if currentConfig ~= "Moonkin CodeMyLife" then
		MoonkinConfig();
		MoonkinToggles();
		currentConfig = "Moonkin CodeMyLife";
	end

	--[[Eclipse Status]]
	if GetEclipseDirection() == "sun" then
	 	eclipseDirection = 1;
	else
		eclipseDirection = 0;
	end
	eclipseEnergy = UnitPower("player",SPELL_POWER_ECLIPSE);
	surgeStack, _, surgeTime = GetSpellCharges(_Starsurge);
	forceOfNatureStack, _, forceOfNatureTime = GetSpellCharges(_Starsurge);

	--[[Set Ennemies Table]]
	if myEnemiesTableTimer == nil or myEnemiesTable == nil or myEnemiesTableTimer <= GetTime() - 1 then
		myEnemiesTable, myEnemiesTableTimer = getEnemies("player",40), GetTime();
	end

	--[[Pause toggle]]
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then ChatOverlay("|cffFF0000BadBoy Paused", 0); return; end
	--[[Focus Toggle]]
	if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == 1 then
		RunMacroText("/focus mouseover");
	end



-------------------------------------------------
--- Misc ---
--------------------------------------------------
		local falling = getFallTime()
		local swimming = IsSwimming()
		local travel = UnitBuffID("player", trf)
		local flight = UnitBuffID("player", flf)
		local cat = UnitBuffID("player",cf)
		local stag = hasGlyph(114338)

	-- Flying Form
	    if falling > 1 and not isInCombat("player") and IsFlyableArea() then
	        if ((not travel and not flight) or (not swimming and travel))  then
	            if stag then
	                if castSpell("player",flf,true,false,false) then return; end
	            elseif not stag then
	                if castSpell("player",trf,true,false,false) then return; end
	            end
	        else
	            if castSpell("player",cf,true,false,false) then return; end
	        end
	    end
	-- Aquatic Form
	    if swimming and not travel and not hasTarget then
	        if castSpell("player",trf,true,false,false) then return; end
	    end
	-- Cat Form
	    --if ((not dead and hastar and attacktar and tarDist<=40)
	    --		or (isMoving("player") and not travel and not IsFalling()))
	      --  and (not IsFlying() or (IsFlying() and targetDistance<10))
	        --and not cat
	       -- and (falling==0 or tarDist<10)
	        --and not isInCombat("player")
	    --then
	      --  if castSpell("player",cf,true,false,false) then return; end
	    --end
	-- PowerShift
	    if hasNoControl() then
	        for i=1, 6 do
	            if i == GetShapeshiftForm() then
	                CastShapeshiftForm(i)
	                return true
	            end
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

	--[[Mark of the Wild]]
	if isChecked("Mark Of The Wild") == true and canCast(1126,false,false) and (lastMotw == nil or lastMotw <= GetTime() - 5) then
		for i = 1, #nNova do
	  		if isPlayer(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{115921,20217,1126,90363}) then
	  			if castSpell("player",1126,true) then lastMotw = GetTime(); return; end
			end
		end
	end

--[[ 	-- Combats Starts Here
]]
	if UnitAffectingCombat("player") == true then
   
		if isChecked("Celestial Alignment") == true and canCast(112071,false,false)
				then 
					if surgeStack > 1 then if castSpell("player",112071,true,false) then return; end
					end
		end

		if UnitBuffID("player",112071) then
			if 	(getDebuffRemain("target",_Moonfire,"player") < 4 or getDebuffRemain("target",_Sunfire,"player") < 4 ) then
					if castSpell("target",_Moonfire,true,false,false) then return; 
					end
			end

			if 	not (UnitBuffID("player",_EmpowermentLunar) or UnitBuffID("player",_EmpowermentSolar))  and (Starsurgetimer == nil or Starsurgetimer <= GetTime() - 2) then 
				 if castSpell("target",_Starsurge,false,false) then Starsurgetimer = GetTime() return; end
			end

			if getBuffRemain("player",112071) < 3 then
				if 	getDebuffRemain("target",_Moonfire,"player") < 30 then
					if castSpell("target",_Moonfire,true,false,false) then return; end
				end
			end
			if (isCastingSpell(2912) == true or isCastingSpell(5176) == true) and (getBuffStacks(164547) == 1 or getBuffStacks(164545) == 1) then
				if castSpell("target",_Starsurge,false,false) then Starsurgetimer = GetTime() return; end
			end
		end



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

--[[


]]

		-- potion,name=jade_serpent,if=buff.celestial_alignment.up
		-- blood_fury,if=buff.celestial_alignment.up
		-- berserking,if=buff.celestial_alignment.up
		-- arcane_torrent,if=buff.celestial_alignment.up

		--[[force_of_nature,if=trinket.stat.intellect.up|charges=3|target.time_to_die<21]]
		if isChecked("Force Of Nature") and isKnown(_ForceOfNature) then
			if select(2,UnitStat("player",4)) > 0 or forceOfNatureStack == 3 or getTimeToDie("target") < 21 then
				if castSpell("target",_ForceOfNature,true,false) then return; end
			end
		end

		--[[call_action_list,name=single_target,if=active_enemies=1]]
		if (#myEnemiesTable == 1 and BadBoy_data["AoE"] == 3) or BadBoy_data["AoE"] == 1 then

			-- celestial_alignment,if=lunar_max<8|target.time_to_die<20
			-- incarnation,if=buff.celestial_alignment.up


			--[[sunfire,if=remains<7|buff.solar_peak.up]]
			if (getDebuffRemain("target",_Sunfire,"player") < 7 and eclipseEnergy > 0) or UnitBuffID("player",_EclipseSolar) then
				if castSpell("target",_Moonfire,true,false,false) then return; end
			end

			--[[moonfire,if=buff.lunar_peak.up&remains<eclipse_change+20
			|remains<4
			|(buff.celestial_alignment.up&buff.celestial_alignment.remains<=2&remains<eclipse_change+20)]]
			if 	(getDebuffRemain("target",_Moonfire,"player") < 4 and eclipseEnergy < 0)
				or UnitBuffID("player",_EclipseLunar) then
					if castSpell("target",_Moonfire,true,false,false) then return; 
					end
			end

			--[[starsurge,if=buff.lunar_empowerment.down&eclipse_energy>20]]--[[starsurge,if=buff.solar_empowerment.down&eclipse_energy<-20]]--[[starsurge,if=(charges=2&recharge_time<15)|charges=3]]
			if isStanding(0.3) 
				and (
						(not UnitBuffID("player",_EmpowermentLunar) and eclipseDirection == 0 and eclipseEnergy < -70)
						or (not UnitBuffID("player",_EmpowermentSolar) and eclipseDirection == 1 and eclipseEnergy > 80)
						or (surgeStack == 2 and surgeTime - GetTime() < 15)
						or surgeStack == 3 
					) 
				and not(eclipseEnergy > -30 and UnitBuffID("player",_EmpowermentSolar))	
				and not(eclipseEnergy < 30 and UnitBuffID("player",_EmpowermentLunar))
				and  (Starsurgetimer == nil or Starsurgetimer <= GetTime() - 2)
				and  castSpell("target",_Starsurge,false,false) then Starsurgetimer = GetTime() print("Testing Starsurge before sun peak "..eclipseEnergy) return; 
						
			end
			--we are in Lunar but we still cast Wrath cause when the spell lands we will be in sun
			if 	isStanding(0.3) 
				and (eclipseDirection == 1 and eclipseEnergy > -30)  
				and castSpell("target",_Wrath,false,true) then  return; 
			end
			--we are in sun but we still cast starfire cause when the spell lands we will be in lunar
			if 	isStanding(0.3) 
				and (eclipseDirection == 0 and eclipseEnergy < 30) 
				and castSpell("target",_Starfire,false,true) then  return; 
			end
			-- wrath,if=(eclipse_energy<=0&eclipse_change>cast_time)|(eclipse_energy>0&cast_time>eclipse_change)
			if 	isStanding(0.3) 
				and eclipseEnergy >= 0
				--and (eclipseDirection == 0 or (eclipseDirection == 1 and eclipseEnergy > -80)) 
				and castSpell("target",_Wrath,false,true) then  return; 
			end


			-- starfire,if=(eclipse_energy>=0&eclipse_change>cast_time)|(eclipse_energy<0&cast_time>eclipse_change)
			if 	isStanding(0.3) 
				and eclipseEnergy <= 0
				--and (eclipseDirection == 1 or (eclipseDirection == 0 and eclipseEnergy < -80)) 
				and castSpell("target",_Starfire,false,true) then  return; 
			end

			--[[Moonfire Filler]]
			if castSpell("target",_Moonfire,true,false,true) then return; end
		else



			-- celestial_alignment,if=lunar_max<8|target.time_to_die<20
			-- incarnation,if=buff.celestial_alignment.up
			--[[sunfire,if=remains<8]]
			if getDebuffRemain("target",_Sunfire,"player") < 7 and eclipseEnergy > 0 then
				if castSpell("target",_Moonfire,true,false,false)  then return; end
			end

			for i = 1, #myEnemiesTable do
				local thisUnit = myEnemiesTable[i]
				if getDebuffRemain(thisUnit,_Sunfire,"player") < 6 and eclipseEnergy > 0 then
					if castSpell(thisUnit,_Moonfire,false,false) then return; end
				end
			end

			-- starfall
			if castSpell("player",_Starfall,true,false) then return; end

			-- moonfire,cycle_targets=1,if=remains<12
			if getDebuffRemain("target",_Moonfire,"player") < 3 and eclipseEnergy < 0 then
				if castSpell("target",_Moonfire,false,false) then return; end
			end 
			for i = 1, #myEnemiesTable do
				local thisUnit = myEnemiesTable[i]
				if getDebuffRemain(thisUnit,_Moonfire,"player") < 6 and eclipseEnergy < 0 then
					if castSpell(thisUnit,_Moonfire,false,false) then return; end
				end
			end

			--we are in Lunar but we still cast Wrath cause when the spell lands we will be in sun
			if 	isStanding(0.3) 
				and (eclipseDirection == 1 and eclipseEnergy > -30)  
				and castSpell("target",_Wrath,false,true) then  return; 
			end

			--we are in sun but we still cast starfire cause when the spell lands we will be in lunar
			if 	isStanding(0.3) 
				and (eclipseDirection == 0 and eclipseEnergy < 30) 
				and castSpell("target",_Starfire,false,true) then  return; 
			end
			
			-- wrath,if=(eclipse_energy<=0&eclipse_change>cast_time)|(eclipse_energy>0&cast_time>eclipse_change)
			if 	isStanding(0.3) 
				and eclipseEnergy >= 0
				--and (eclipseDirection == 0 or (eclipseDirection == 1 and eclipseEnergy > -80)) 
				and castSpell("target",_Wrath,false,true) then  return; end


			-- starfire,if=(eclipse_energy>=0&eclipse_change>cast_time)|(eclipse_energy<0&cast_time>eclipse_change)
			if 	isStanding(0.3) 
				and eclipseEnergy <= 0
				--and (eclipseDirection == 1 or (eclipseDirection == 0 and eclipseEnergy < -80)) 
				and castSpell("target",_Starfire,false,true) then  return; 
			end

		end
	end
end
end

--Todo 



