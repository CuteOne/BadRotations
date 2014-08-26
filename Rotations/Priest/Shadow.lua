if select(3, UnitClass("player")) == 5 then
function PriestShadow()
	if currentConfig ~= "Shadow CodeMyLife" then
		ShadowConfig();
		ShadowToggles();
		currentConfig = "Shadow CodeMyLife";
	end



_AngelicFeather 	= 121536;
_DevouringPlague 	= 2944;
_DispelMagic 		= 528;
_Fade 				= 586;
_FlashHeal 			= 2061;
_InnerFire 			= 588;
_Levitate 			= 1706;
_Mindbender			= 123040;
_MindBlast 			= 8092;
_MindFlay 			= 15407;
_MindSpike 			= 73510;
_MindVision 		= 2096;
_PowerInfusion		= 10060;
_PowerWordFortitude = 52562;
_PowerWordShield 	= 17;
_PsychicScream 		= 8122;
_Renew 				= 139;
_Resurrection 		= 2006;
_ShackleUndead 		= 9484;
_ShadowWordDeath 	= 32379;
_ShadowWordPain 	= 589;
_Shadowfiend 		= 34433;
_Shadowform 		= 15473;
_VampiricTouch 		= 34914;
_VoidTendrils 		= 108920;
_WeakenedSoul 		= 6788;

	local orbs = UnitPower("player", SPELL_POWER_SHADOW_ORBS)

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


	--[[Resurrection]]
	if not isInCombat("player") and isStanding(0.3)  and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("player","mouseover") then
		if castSpell("mouseover",_Resurrection,true,true) then return; end
	end

	--[[Food/Invis Check]]
	if canRun() ~= true then return false; end
	if isCasting() == true or getSpellCD(61304) > 0 then return false; end

--[[ 	-- On GCD After here, palce out of combats spells here
]]	

	--[[Power Word: Fortitude]]
	if isChecked("Power Word: Fortitude") == true and canCast(_PowerWordFortitude,false,false) and (lastMotw == nil or lastMotw <= GetTime() - 5) then
		for i = 1, #nNova do
	  		if isPlayer(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{_PowerWordFortitude,469}) then
	  			if castSpell("player",_PowerWordFortitude,true,false) then lastMotw = GetTime(); return; end
			end 
		end
	end

	--[[Inner Fire]]
	if not UnitBuffID("player",_InnerFire) then
		if castSpell("player",_InnerFire,true,false) then return; end
	end

	--[[Shadowform]]
	if not UnitBuffID("player",_Shadowform) then
		if castSpell("player",_Shadowform,true,false) then return; end
	end

	--[[Angelic Feather]]
	if getTalent(5) and isChecked("Angelic Feather") and getGround("player") and IsMovingTime(0.75) and not UnitBuffID("player",_AngelicFeatherBuff) then
		if castGround("player",_AngelicFeather,30) then SpellStopTargeting(); return; end
	end
	--[[Body And Soul]]
	if getTalent(4) and isChecked("Body And Soul") and getGround("player") and IsMovingTime(0.75) and not UnitBuffID("player",_PowerWordShield) and not UnitDebuffID("player",_WeakenedSoul) then
		if castSpell("player",_PowerWordShield,true,false) then return; end
	end

--[[ 	-- Combats Starts Here
]]

	if UnitAffectingCombat("player") and UnitExists("target") and not UnitIsDeadOrGhost("target") then

		--[[Targets Tables]]
		if isChecked("Multi-Dotting") then
		    if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
		    	targetEnnemies, ScanTimer = getEnnemies("target",20), GetTime(); 
		    end
		end
		surroundingEnnemies = getNumEnnemies("player",30)

		--[[Fade]]
		if isChecked("Fade") and getHP("player") <= getValue("Fade") and UnitThreatSituation("player") == 3 and GetNumGroupMembers() >= 2 then
			if castSpell("player",_Fade,true,false) then return; end
		end

		--[[Healthstone]]
		if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") then
			if canUse(5512) ~= false then
				UseItemByName(tostring(select(1,GetItemInfo(5512))));
			end
		end

		--[[Power Word: Shield]]
		if isChecked("Power Word: Shield") and canCast(_PowerWordShield,false,false) and not UnitBuffID("player",_PowerWordShield) and not UnitDebuffID("player",_WeakenedSoul) then
			if getHP("player") <= getValue("Power Word: Shield") then
			   	if castSpell("player",_PowerWordShield,true,false) then return; end
			end
		end

		--[[Renew]]
		if isChecked("Renew") and canCast(_PowerWordShield,false,false) and not UnitBuffID("player",_Renew) then
			if getHP("player") <= getValue("Renew") then
			   	if castSpell("player",_Renew,true,false) then return; end
			end
		end


		--[[mindbender,if=talent.mindbender.enabled]]
		if isChecked("Mindbender") and isKnown(_Mindbender) and getMana("player") <= getValue("Mindbender") then
			if castSpell("target",_Mindbender,false,false) then return; end
		end

		--[[shadowfiend,if=!talent.mindbender.enabled]]
		if isChecked("Shadowfiend") and not isKnown(_Mindbender) and getMana("player") <= getValue("Shadowfiend") then
			if castSpell("target",_Shadowfiend,false,false) then return; end
		end		

		--[[power_infusion,if=talent.power_infusion.enabled]]
		if isChecked("Power Infusion") and isKnown(_PowerInfusion) then
			if castSpell("player",_PowerInfusion,true,false) then return; end
		end			

		--[[shadow_word_death,if=buff.shadow_word_death_reset_cooldown.stack=1&active_enemies<=5]]
		

		--[[devouring_plague,if=shadow_orb=3&(cooldown.mind_blast.remains<1.5|target.health.pct<20&cooldown.shadow_word_death.remains<1.5)]]
		if orbs == 3 and (getSpellCD(_MindBlast) < 1.5 or (getHP("target") <= 20 and getSpellCD(_ShadowWordDeath) < 1.5)) then
			if castSpell("target",_DevouringPlague,false,false) then return; end
		end

		--[[mind_blast,if=active_enemies<=5&cooldown_react]]
		if isStanding(0.3) and castSpell("target",_MindBlast,false,true) then return; end

		--[[shadow_word_death,if=buff.shadow_word_death_reset_cooldown.stack=0&active_enemies<=5]]
		if getHP("target") <= 20 and castSpell("target",_ShadowWordDeath,false,false) then return; end

		--[[mind_flay_insanity,if=target.dot.devouring_plague_tick.ticks_remain=1,chain=1]]
		if isStanding(0.3) and getDebuffRemain("target",_DevouringPlague) > 2 then
			if castSpell("target",_MindFlay,false,true) then return; end
		end

		--[[mind_flay_insanity,interrupt=1,chain=1,if=active_enemies<=5]]

	    if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
	    	meleeEnnemies, targetEnnemies, ScanTimer = getNumEnnemies("player",4), getEnnemies("target",10), GetTime(); 
	    end

		--[[shadow_word_pain,cycle_targets=1,max_cycle_targets=5,if=miss_react&!ticking]]
		if getDebuffRemain("target",_ShadowWordPain) == 0 then if castSpell("target",_ShadowWordPain,true,false) then return; end end
		if isChecked("Multi-Dotting") then
			for i = 1, #targetEnnemies do
				ISetAsUnitID(targetEnnemies[i],"thisUnit")
				if UnitAffectingCombat("thisUnit") and getDebuffRemain("thisUnit",_ShadowWordPain) == 0 then
					if castSpell("thisUnit",_ShadowWordPain,true,false) then return; end
				end
			end
		end

		--[[vampiric_touch,cycle_targets=1,max_cycle_targets=5,if=remains<cast_time&miss_react]]
		if isStanding(0.3) and getDebuffRemain("target",_VampiricTouch) == 0 and (vampTimer == nil or (vampTimer and vampTimer <= GetTime() - 2) or vampTarget ~= UnitGUID("target")) then if castSpell("target",_VampiricTouch,false,false) then vampTarget = UnitGUID("target"); vampTimer = GetTime(); return; end end
		if isChecked("Multi-Dotting") then
			for i = 1, #targetEnnemies do
				ISetAsUnitID(targetEnnemies[i],"thisUnit")
				if UnitAffectingCombat("thisUnit") and getDebuffRemain("thisUnit",_VampiricTouch) == 0 and (vampTimer == nil or (vampTimer and vampTimer <= GetTime() - 2) or vampTarget ~= UnitGUID("thisUnit")) then
					if castSpell("thisUnit",_VampiricTouch,false,false) then vampTarget = UnitGUID("thisUnit"); vampTimer = GetTime(); return; end
				end
			end	
		end		

		--[[shadow_word_pain,cycle_targets=1,max_cycle_targets=5,if=miss_react&ticks_remain<=1]]
		if getDebuffRemain("target",_ShadowWordPain) < 2 then if castSpell("target",_ShadowWordPain,true,false) then return; end end
		if isChecked("Multi-Dotting") then
			for i = 1, #targetEnnemies do
				ISetAsUnitID(targetEnnemies[i],"thisUnit")
				if UnitAffectingCombat("thisUnit") and getDebuffRemain("thisUnit",_ShadowWordPain) < 2 then
					if castSpell("thisUnit",_ShadowWordPain,true,false) then return; end
				end
			end
		end

		--[[vampiric_touch,cycle_targets=1,max_cycle_targets=5,if=remains<cast_time+tick_time&miss_react]]
		if isStanding(0.3) and getDebuffRemain("target",_VampiricTouch) < 2 and (vampTimer == nil or (vampTimer and vampTimer <= GetTime() - 2) or vampTarget ~= UnitGUID("target")) then if castSpell("target",_VampiricTouch,false,false) then vampTarget = UnitGUID("target"); vampTimer = GetTime(); return; end end
		if isChecked("Multi-Dotting") then
			for i = 1, #targetEnnemies do
				ISetAsUnitID(targetEnnemies[i],"thisUnit")
				if UnitAffectingCombat("thisUnit") and getDebuffRemain("thisUnit",_VampiricTouch) < 2 and (vampTimer == nil or (vampTimer and vampTimer <= GetTime() - 2) or vampTarget ~= UnitGUID("thisUnit")) then
					if castSpell("thisUnit",_VampiricTouch,false,false) then vampTarget = UnitGUID("thisUnit"); vampTimer = GetTime(); return; end
				end
			end	
		end		

		--[[vampiric_embrace,if=shadow_orb=3&health.pct<=40]]

		--[[devouring_plague,if=shadow_orb=3&ticks_remain<=1]]
		if orbs == 3 and getDebuffRemain("target",_DevouringPlague) < 2 then
			if castSpell("target",_DevouringPlague,false,false) then return; end
		end

		--[[mind_spike,if=active_enemies<=5&buff.surge_of_darkness.react=2]]

		--[[halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17]]
		if surroundingEnnemies > 5 then

		end

		--[[cascade_damage,if=talent.cascade.enabled&(active_enemies>1|(target.distance>=25&stat.mastery_rating<15000)|target.distance>=28)&target.distance<=40&target.distance>=11]]
		
		--[[divine_star,if=talent.divine_star.enabled&(active_enemies>1|stat.mastery_rating<3500)&target.distance<=24]]
		
		--[[wait,sec=cooldown.shadow_word_death.remains,if=target.health.pct<20&cooldown.shadow_word_death.remains<0.5&active_enemies<=1]]
		--[[wait,sec=cooldown.mind_blast.remains,if=cooldown.mind_blast.remains<0.5&active_enemies<=1]]
		
		--[[mind_spike,if=buff.surge_of_darkness.react&active_enemies<=5]]
		
		--[[mind_sear,chain=1,interrupt=1,if=active_enemies>=3]]
		
		--[[mind_flay,chain=1,interrupt=1]]
		if isStanding(0.3) and castSpell("target",_MindFlay,false,true,false,true) then return; end
		
		--[[shadow_word_death,moving=1]]
		
		--[[mind_blast,moving=1,if=buff.divine_insight_shadow.react&cooldown_react]]
		
		--[[divine_star,moving=1,if=talent.divine_star.enabled&target.distance<=28]]
		
		--[[cascade_damage,moving=1,if=talent.cascade.enabled&target.distance<=40]]
		
		--[[shadow_word_pain,moving=1]]
		
		--[[dispersion]]














	end
end
end





