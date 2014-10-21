if select(3, UnitClass("player")) == 5 then
	function PriestShadow()

	if currentConfig ~= "Shadow ragnar" then
		ShadowConfig();
		ShadowToggles();
		currentConfig = "Shadow ragnar";
	end


	------------
	-- LOCALS --
	------------
	local GT = GetTime();
	local lastPWF = nil;
	local ORBS = UnitPower("player", SPELL_POWER_SHADOW_ORBS)
	local SWPrefresh = 3;
	local StandingTime = 0.15;
	local MBCD = getSpellCD(_MindBlast)
	local SWDCD = getSpellCD(_ShadowWordDeath)
	-- local CastMindFlay = isCastingSpell(_MindFlay)
	local HASTE = GetHaste()
	local GCDTIME = 1.5/(1+HASTE/100)




	-- MindFlay CastTime
	local MFCASTTIME = 3.0/(1+HASTE/100)

	-- SW:P
	local SWP_TIMER,_,_,_,_,_,_,_,_,_ = select(7,UnitDebuffID("target",_ShadowWordPain,"player"))
	if SWP_TIMER ~= nil then
		SWP_REM = SWP_TIMER-GT;
	end

	-- VT Remaining
	local VT_TIMER,_,_,_,_,_,_,_,_,_ = select(7,UnitDebuffID("target",_VampiricTouch,"player"))
	if VT_TIMER ~= nil then
		VT_REM = VT_TIMER-GT;
	end
	--VT CastTime
	local VTCASTTIME = select(4,GetSpellInfo(_VampiricTouch))/1000;
	-- LastVT
	if lastVT == nil then
		lastVT = GT;
	end


	-- DP
	local DPTIME = 6.0/(1+HASTE/100)
	local DPTICK = DPTIME/6;

	-- Shadowy Insight
	local SI_TIMER,_,_,_,_,_,_,_,_,_ = select(7,UnitBuffID("player",_ShadowyInsight))
	if SI_TIMER ~= nil then
		SI_REM = SI_TIMER-GT;
	end

	-- Surge of Darkness
	local SoD_TIMER,_,_,_,_,_,_,_,_,_ = select(7,UnitBuffID("player",_SurgeOfDarkness))
	if SoD_TIMER ~= nil then
		SoD_REM = SoD_TIMER-GT;
	end

	--print(SWP_TIMER);
	-- local VT_DEBUFF,_,_,_,_,_,VT_TIMER = UnitDebuffID("target",_VampiricTouch,"PLAYER")
	-- local DP_DEBUFF,_,_,_,_,_,DP_TIMER = UnitDebuffID("target",_DevouringPlague,"PLAYER")

	--local SWP_REM = GT-SWP_TIMER;
	-- local VT_REM = GT-VT_TIMER;
	-- local DP_REM = GT-DP_TIMER;



	-------------
	-- TOGGLES --
	-------------

	-- Pause toggle
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then
		ChatOverlay("|cffFF0000BadBoy Paused", 0);
		return;
	end

	-- Focus Toggle
	if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == 1 then
		RunMacroText("/focus mouseover");
	end

	-- Auto Resurrection
	if not isInCombat("player") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("player","mouseover") then
		if castSpell("mouseover",_Resurrection,true,true) then
			return;
		end
	end

	------------
	-- CHECKS --
	------------

	-- Food/Invis Check
	if canRun() ~= true then
		return false;
	end

	-- Mounted Check
	if IsMounted("player") then
		return false;
	end


	-- Do not Interrupt "player" while GCD (61304)
	if getSpellCD(61304) > 0 then
		return false;
	end

	-- Pause Check
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then
		ChatOverlay("|cffFF0000BadBoy Paused", 0);
		return;
	end

	-------------------
	-- OUT OF COMBAT --
	-------------------

	-- Power Word: Fortitude
	if isChecked("Power Word: Fortitude") == true and canCast(_PowerWordFortitude,false,false) and (lastPWF == nil or lastPWF <= GetTime() - 5) then

		for i = 1, #nNova do
			if nNova[i].hp < 249 then
				if isPlayer(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{21562,109773,469,90364}) or (getBuffRemain(nNova[i].unit,_PowerWordFortitude) < 10*60 and isSpellInRange(_PowerWordFortitude,nNova[i].unit)) then
					if castSpell("player",_PowerWordFortitude,true) then lastPWF = GetTime(); return; end
				end
			end
		end
	end

	-- Shadowform
	if not UnitBuffID("player",_Shadowform) then
		if castSpell("player",_Shadowform,true,false) then return; end
	end

	-- Angelic Feather
	if isKnown(_AngelicFeather) and isChecked("Angelic Feather") and getGround("player") and IsMovingTime(0.33) and not UnitBuffID("player",_AngelicFeatherBuff) then
		if castGround("player",_AngelicFeather,30) then
			SpellStopTargeting();
			return;
		end
	end

	-- Body and Soul
	if isKnown(_BodyAndSoul) and isChecked("Body And Soul") and getGround("player") and IsMovingTime(0.75) and not UnitBuffID("player",_PowerWordShield) and not UnitDebuffID("player",_WeakenedSoul) then
		if castSpell("player",_PowerWordShield,true,false) then
			return;
		end
	end

	------------
	-- COMBAT --
	------------

	-- Break MindFlay cast...
	if select(1,UnitChannelInfo("player")) == "Mind Flay" then

		-- ...for MindBlast cast and proc
		if canCast(_MindBlast) and getSpellCD(_MindBlast) == 0 then
			-- cast MindBlast from DI proc
			if isKnown(_ShadowyInsight) and UnitBuffID("player",_ShadowyInsight) then
				RunMacroText("/stopcasting");
				if castSpell("target",_MindBlast,false,false) then
					return;
				end
			end
			-- cast MindBlast as spell
			if canCast(_MindBlast) and getSpellCD(_MindBlast) == 0 then
				RunMacroText("/stopcasting");
				if castSpell("target",_MindBlast,false,true) then
					return;
				end
			end
		end

		-- -- ...for SWP refresh
		-- if getDebuffRemain("target",_ShadowWordPain) <= SWPrefresh then
		-- 	StopMFCasting();
		-- 	-- RunMacroText("/stopcasting");
		-- end
		-- -- ...for VT refresh
		-- if getDebuffRemain("target",_VampiricTouch) <= VTrefresh then
		-- 	StopMFCasting();
		-- 	-- RunMacroText("/stopcasting");
		-- end

		-- ...for MindSpike Proc (Surge of Darkness)
		if isKnown(_SurgeOfDarkness) and getBuffStacks("player",_SurgeOfDarkness) > 2 then
			RunMacroText("/stopcasting");
			if castSpell("target",_MindSpike,false,false) then
				return;
			end
		end

		-- -- ...for Halo
		-- if getTalent(18) and canCast(_Halo) then
		-- 	StopMFCasting();
		-- 	-- RunMacroText("/stopcasting");
		-- end
	end

	-- -- insanity,if=buff.shadow_word_insanity.remains<0.5*gcd&active_enemies<=2,chain=1
	-- -- Break Insanity and Cast for new
	-- if select(1,UnitChannelInfo("player")) == "Insanity" then
	-- 	if getBuffRemain("player",_InsanityBuff) < 0.5*GCDTIME then
	-- 		RunMacroText("/stopcasting");
	-- 		if castSpell("target",_Insanity,false,true,false,true) then
	-- 			print("BREAK BREAK BREAK");
	-- 			return;
	-- 		end
	-- 	end
	-- end


	-- AffectingCombat, Pause, Target, Dead/Ghost Check
	if pause() ~= true and UnitAffectingCombat("player") and UnitExists("target") and not UnitIsDeadOrGhost("target") then

		-- Target Tables
		if isChecked("Multi-Dotting") then
			if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
				targetEnemies, ScanTimer = getEnemies("target",20), GetTime();
			end
		end


		--[[ DEFENSIVES ]]

		-- Fade glyphed
		if (BadBoy_data['Defensive'] == 2 or BadBoy_data['Defensive'] == 3) and isChecked("Fade") and getHP("player") <= getValue("Fade") and hasGlyph(55684) then
			if castSpell("player",_Fade,true,false) then
				return;
			end
		end

		-- Fade
		if isChecked("Fade") and UnitThreatSituation("player") == 3 and GetNumGroupMembers() >= 2 then
			if castSpell("player",_Fade,true,false) then
				return;
			end
		end

		-- Healthstone
		if isChecked("Healthstone") and (BadBoy_data['Defensive'] == 2 or BadBoy_data['Defensive'] == 3) and getHP("player") <= getValue("Healthstone") then
			if canUse(5512) ~= false then
				UseItemByName(tostring(select(1,GetItemInfo(5512))));
			end
		end

		-- Power Word: Shield
		if isChecked("Power Word: Shield") and (BadBoy_data['Defensive'] == 2 or BadBoy_data['Defensive'] == 3) and not UnitBuffID("player",_PowerWordShield) and not UnitDebuffID("player",_WeakenedSoul) then
			if getHP("player") <= getValue("Power Word: Shield") then
				if castSpell("player",_PowerWordShield,true,false) then
					return;
				end
			end
		end

		-- Desperate Prayer
		if isKnown(_DesperatePrayer) then
			if isChecked("Desperate Prayer") and (BadBoy_data['Defensive'] == 2 or BadBoy_data['Defensive'] == 3) and getHP("player") <= getValue("Desperate Prayer") then
				if castSpell("player",true,false) then
					return;
				end
			end
		end


		--[[ INTERRUPT ]]
		if BadBoy_data['Interrupt'] == 1 then
		end


		--[[ OFFENSIVES ]]

		-- Power Infusion
		if isChecked("PI Toggle") and isKnown(_PowerInfusion) and BadBoy_data['Cooldowns'] == 2 and isChecked("Power Infusion") == true then
			if castSpell("player",_PowerInfusion,true,false) then
				ChatOverlay("PI fired");
				return;
			end
		end


		--[[ ROTATION ]]

		-- mindbender,if=talent.mindbender.enabled
		if isKnown(_Mindbender) and BadBoy_data['Cooldowns'] == 2 and isChecked("Mindbender") == true then
			if castSpell("target",_Mindbender,true,false) then
				return;
			end
		end

		-- shadowfiend,if=!talent.mindbender.enabled
		if isKnown(_Shadowfiend) and BadBoy_data['Cooldowns'] == 2 and isChecked("Shadowfiend") == true then
			if castSpell("target",_Shadowfiend,true,false) then
				return;
			end
		end

		-- void_entropy,if=talent.void_entropy.enabled&shadow_orb>=3&miss_react&!ticking&target.time_to_die>60&cooldown.mind_blast.remains<=gcd*2,cycle_targets=1,max_cycle_targets=3
		if isKnown(_VoidEntropy) then
			if ORBS >= 3 and not UnitDebuffID("target",_VoidEntropy,"player") and getTimeToDie("target") > 60 and MBCD <= 2*GCDTIME then
				if castSpell("target",_VoidEntropy,true,false) then
					return;
				end
			end
		end

		-- devouring_plague,if=talent.void_entropy.enabled&shadow_orb>=3&dot.void_entropy.ticking&dot.void_entropy.remains<10,cycle_targets=1,max_cycle_targets=3
		if canCast(_DevouringPlague) then
			if isKnown(_VoidEntropy) and ORBS >= 3 and UnitDebuffID("target",_VoidEntropy,"player") and getDebuffRemain("target",_VoidEntropy) < 10 then
				if castSpell("target",_DevouringPlague,true,false) then
					return;
				end
			end
		end

		-- devouring_plague,if=talent.void_entropy.enabled&shadow_orb>=3&dot.void_entropy.ticking&dot.void_entropy.remains<20,cycle_targets=1,max_cycle_targets=3
		if canCast(_DevouringPlague) then
			if isKnown(_VoidEntropy) and ORBS >= 3 and UnitDebuffID("target",_VoidEntropy,"player") and getDebuffRemain("target",_VoidEntropy) < 20 then
				if castSpell("target",_DevouringPlague,true,false) then
					return;
				end
			end
		end

		-- devouring_plague,if=talent.void_entropy.enabled&shadow_orb=5
		if canCast(_DevouringPlague) then
			if isKnown(_VoidEntropy) and ORBS == 5 then
				if castSpell("target",_DevouringPlague,true,false) then
					return;
				end
			end
		end

		-- devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=4&!target.dot.devouring_plague_tick.ticking&talent.surge_of_darkness.enabled,cycle_targets=1
		if canCast(_DevouringPlague) then
			if not isKnown(_VoidEntropy) and ORBS >= 4 and not UnitDebuffID("target",_DevouringPlague,"player") and isKnown(_SurgeOfDarkness) then
				if castSpell("target",_DevouringPlague,true,false) then
					return;
				end
			end
		end

		-- devouring_plague,if=!talent.void_entropy.enabled&((shadow_orb>=4)|(shadow_orb>=3&set_bonus.tier17_2pc))
		if canCast(_DevouringPlague) then
			if not isKnown(_VoidEntropy) and (ORBS >= 4 or ORBS>=3 and isKnown(_T16_2)) then
				if castSpell("target",_DevouringPlague,true,false) then
					return;
				end
			end
		end

		-- shadow_word_death,if=buff.shadow_word_death_reset_cooldown.stack=1,cycle_targets=1
		if canCast(_ShadowWordDeath) and getHP("target")<20 then
			if castSpell("target",_ShadowWordDeath,true,false) then
				return;
			end
		end

		-- shadow_word_death,if=buff.shadow_word_death_reset_cooldown.stack=0,cycle_targets=1

		-- mind_blast,if=!glyph.mind_harvest.enabled&active_enemies<=5&cooldown_react    1202=MindHarverGlyph
		--if canCast(_MindBlast) then
			if not hasGlyph(1202) then
				if castSpell("target",_MindBlast,false,true) then
					return;
				end
			end
		--end

		-- devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=3&(cooldown.mind_blast.remains<1.5|target.health.pct<20&cooldown.shadow_word_death.remains<1.5)&!target.dot.devouring_plague_tick.ticking&talent.surge_of_darkness.enabled,cycle_targets=1
		if canCast(_DevouringPlague) then
			if not isKnown(_VoidEntropy) and ORBS >= 3 and (MBCD<1.5 or getHP("target")<20 and SWDCD<1.5) and not UnitDebuffID("target",_DevouringPlague,"player") and isKnown(_SurgeOfDarkness) then
				if castSpell("target",_DevouringPlague,true,false) then
					return;
				end
			end
		end

		-- devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=3&(cooldown.mind_blast.remains<1.5|target.health.pct<20&cooldown.shadow_word_death.remains<1.5)
		if canCast(_DevouringPlague) and getHP("target")<20 then
			if not isKnown(_VoidEntropy) and ORBS >= 3 and (MBCD<1.5 or (getHP("target")<20 and SWDCD<1.5)) then
				if castSpell("target",_ShadowWordDeath,true,false) then
					return;
				end
			end
		end

		-- mind_blast,if=glyph.mind_harvest.enabled&mind_harvest=0,cycle_targets=1

		-- mind_blast,if=active_enemies<=5&cooldown_react
		if isStanding(0.2) then
		--if isStanding(0.2) and canCast(_MindBlast) then
			if castSpell("target",_MindBlast,false,true) then
				return;
			end
		end

		-- insanity,if=buff.shadow_word_insanity.remains<0.5*gcd&active_enemies<=2,chain=1
		if isKnown(_Insanity) then
			if getDebuffRemain("target",_DevouringPlague)<0.5*GCDTIME then
				if castSpell("target",_Insanity,false,true,false,true) then
					return;
				end
			end
		end

		-- insanity,interrupt=1,chain=1,if=active_enemies<=2

		-- halo,if=talent.halo.enabled&target.distance<=30&active_enemies>2
		if isKnown(_Halo) then
			if getDistance("player","target") <= 30 and getEnemies("player",30) then
				if castSpell("target",_Halo,true,false) then
					return;
				end
			end
		end

		-- cascade,if=talent.cascade.enabled&active_enemies>2&target.distance<=40
		if isKnown(_Cascade) then
			if getDistance("player","target") <= 40 then
				if castSpell("target",_Cascade,true,false) then
					return;
				end
			end
		end

		-- divine_star,if=talent.divine_star.enabled&active_enemies>4&target.distance<=24
		if isKnown(_DivineStar) then
			if getDistance("player","target") <= 24 then
				if castSpell("target",_DivineStar,false,false) then
					return;
				end
			end
		end

		-- shadow_word_pain,if=talent.auspicious_spirits.enabled&remains<(18*0.3)&miss_react,cycle_targets=1
		if isStanding(0.2) and canCast(_ShadowWordPain) then
			if isKnown(_AuspiciousSpirits) and getDebuffRemain("target",_ShadowWordPain) < (18*0.3) then
				if castSpell("target",_ShadowWordPain,true,false) then
					return;
				end
			end
		end

		-- shadow_word_pain,if=!talent.auspicious_spirits.enabled&remains<(18*0.3)&miss_react,cycle_targets=1,max_cycle_targets=5
		-- Here i do my target checks and i make sure i want to iterate. I use canCast prior to everything just to save power, i dont want to scan if that spell is not ready.
		if canCast(_ShadowWordPain,false,false) and BadBoy_data["Multidot"] == 2 then
		if not isKnown(_AuspiciousSpirits) then
				-- Shadow word pain
				-- Iterating Object Manager
				-- I add this part here
				if myEnemies == nil or myEnemiesTimer == nil or myEnemiesTimer <= GetTime() - 1 then
					myEnemies, myEnemiesTimer = getEnemies("player",40), GetTime();
				end

				-- then instead of iterating objectmanager i iterate myEnemies

				-- begin loop
				if myEnemies ~= nil then
					for i = 1, #myEnemies do
						-- we check if it's a valid unit
						if getCreatureType(myEnemies[i]) == true then
							-- now that we know the unit is valid, we can use it to check whatever we want.. let's call it thisUnit
							local thisUnit = myEnemies[i]
							-- Here I do my specific spell checks
							if ((UnitCanAttack(thisUnit,"player") == true and UnitAffectingCombat(thisUnit) == true) or isDummyByName(UnitName(thisUnit))) and getDebuffRemain(thisUnit,_ShadowWordPain) < (18*0.3) and getDistance("player",thisUnit) < 40 then
								-- All is good, let's cast.
								if castSpell(thisUnit,_ShadowWordPain,true,false) then
									return;
								end
							end
						end
					end
				end
			end
		end

		-- shadow_word_pain,if=!talent.auspicious_spirits.enabled&remains<(18*0.3)&miss_react,cycle_targets=1,max_cycle_targets=5
		--if canCast(_ShadowWordPain) then
			if getDebuffRemain("target",_ShadowWordPain) < (18*0.3) then
				if castSpell("target",_ShadowWordPain,true,false) then
					return;
				end
			end
		--end

		-- vampiric_touch,if=remains<(15*0.3+cast_time)&miss_react,cycle_targets=1,max_cycle_targets=5
		if canCast(_VampiricTouch) and BadBoy_data['Multidot'] == 1 then
			-- Vampiric Touch
			-- Iterating Object Manager
			-- begin loop
			for i=1,ObjectCount() do
				-- we check if it's a valid unit
				if getCreatureType(ObjectWithIndex(i)) == true then
					-- now we know the unit is valid, we can use it to check whatever we want..
					local thisUnit = ObjectWithIndex(i)
					-- Here i do my specific spell checks
					if (UnitCanAttack(thisUnit,"player") == true and UnitAffectingCombat(thisUnit) == true) and getDebuffRemain(thisUnit,_VampiricTouch) < (15*0.3+VTCASTTIME) and getDistance("player",thisUnit) < 40 then
						-- let's cast
						if castSpell(thisUnit,_VampiricTouch,true,true) then
							return;
						end
					end
				end
			end
		end

		-- vampiric_touch,if=remains<(15*0.3+cast_time)&miss_react,cycle_targets=1,max_cycle_targets=5
		--if canCast(_VampiricTouch) then
			if getDebuffRemain("target",_VampiricTouch) < (15*0.3+VTCASTTIME) and (GT-lastVT > 2) then
				if castSpell("target",_VampiricTouch,true,true) then
					lastVT = GT;
					return;
				end
			end
		--end

		-- devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=3&ticks_remain<=1
		if canCast(_DevouringPlague) then
			if not isKnown(_VoidEntropy) and ORBS >= 3 and (getDebuffRemain("target",_DevouringPlague)<=DPTICK) then
				if castSpell("target",_DevouringPlague,true,false) then
					return;
				end
			end
		end

		-- mind_spike,if=active_enemies<=5&buff.surge_of_darkness.react=3
		--if canCast(_MindSpike) then
			if _SurgeOfDarkness == 3 then
				if castSpell("target",_MindSpike,false,false) then
					return;
				end
			end
		--end

		-- halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
		if isKnown(_Halo) then
			if getDistance("player","target") <= 30 and getDistance("player","target") >= 17 then
				if castSpell("target",_Halo,true,false) then
					return;
				end
			end
		end

		-- cascade,if=talent.cascade.enabled&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
		-- divine_star,if=talent.divine_star.enabled&(active_enemies>1|target.distance<=24)
		-- wait,sec=cooldown.shadow_word_death.remains,if=target.health.pct<20&cooldown.shadow_word_death.remains&cooldown.shadow_word_death.remains<0.5&active_enemies<=1
		-- wait,sec=cooldown.mind_blast.remains,if=cooldown.mind_blast.remains<0.5&cooldown.mind_blast.remains&active_enemies<=1

		-- mind_spike,if=buff.surge_of_darkness.react&active_enemies<=5
		--if canCast(_MindSpike) then
			if UnitBuffID("player",_SurgeOfDarkness) then
				if castSpell("target",_MindSpike,false,false) then
					return;
				end
			end
		--end

		-- divine_star,if=talent.divine_star.enabled&target.distance<=28&active_enemies>1
		if isKnown(_DivineStar) then
			if getDistance("player","target") <= 28 then
				if castSpell("target",_DivineStar,false,false) then
					return;
				end
			end
		end

		-- mind_sear,chain=1,interrupt=1,if=active_enemies>=4
		--if canCast(_MindSear) then
			if getNumEnemies("target",10) >= 4 then
				if castSpell("target",_MindSear,false,true) then
					return;
				end
			end
		--end

		-- shadow_word_pain,if=shadow_orb>=2&ticks_remain<=3&talent.insanity.enabled
		--if canCast(_ShadowWordPain) then
			if ORBS >= 2 and getDebuffRemain("target",_ShadowWordPain) <= 9 and isKnown(_Insanity) then
				if castSpell("target",_ShadowWordPain,true,false) then
					return;
				end
			end
		--end

		-- vampiric_touch,if=shadow_orb>=2&ticks_remain<=3.5&talent.insanity.enabled
		--if canCast(_VampiricTouch) then
			if ORBS >= 2 and UnitDebuffID("target",_VampiricTouch,"player") and getDebuffRemain("target",_VampiricTouch) <= 10.5 and isKnown(_Insanity) then
				if castSpell("target",_VampiricTouch,true,true) then
					lastVT = GT;
					return;
				end
			end
		--end

		-- mind_flay,chain=1,interrupt=1
		--if canCast(_MindFlay) then
			if select(1,UnitChannelInfo("player")) == nil then
				if castSpell("target",_MindFlay,false,true) then
					return;
				end
			end
		--end

		-- shadow_word_death,moving=1
		--if canCast(_ShadowWordDeath) then
			if getHP("target") < 20 then
				if castSpell("target",_ShadowWordDeath,true,false) then
					return;
				end
			end
		--end

		-- mind_blast,moving=1,if=buff.shadowy_insight.react&cooldown_react
		--if canCast(_MindBlast) then
			if UnitBuffID("player",_ShadowyInsight) then
				if castSpell("target",_MindBlast,false,false) then
					return;
				end
			end
		--end

		-- divine_star,moving=1,if=talent.divine_star.enabled&target.distance<=28
		if isKnown(_DivineStar) then
			if isMoving("player") and getDistance("player","target") <= 28 then
				if castSpell("target",_DivineStar,false,false) then
					return;
				end
			end
		end

		-- cascade,moving=1,if=talent.cascade.enabled&target.distance<=40
		if isKnown(_Cascade) then
			if isMoving("player") and getDistance("player","target") <= 40 then
				if castSpell("target",_Cascade,true,false) then
					return;
				end
			end
		end

		-- shadow_word_pain,moving=1,cycle_targets=1
		--if canCast(_ShadowWordPain) then
			if isMoving("player") then
				if castSpell("target",_ShadowWordPain,true,false) then
					return;
				end
			end
		--end



	end
end
end
