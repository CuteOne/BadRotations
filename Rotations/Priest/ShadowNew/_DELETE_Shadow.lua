if select(3, UnitClass("player")) == 5 then
	function PriestShadow()

		if currentConfig ~= "Shadow ragnar" then
			ShadowConfig()
			ShadowToggles()
			currentConfig = "Shadow ragnar"
		end
		-- Head End

		spell = {
			angelic_feather = 121536,
			cascade = 127632,
			desperate_prayer = 19236,
			devouring_plague = 2944,
			dispel_magic = 523,
			dispersion = 47585,
			divine_star = 122121,
			dominate_mind = 605,
			fade = 586,
			fear_ward = 6346,
			flash_heal = 2061,
			halo = 120644,
			leap_of_faith = 73325,
			levitate = 1706,
			mass_dispel = 32375,
			mindbender = 123040,
			mind_blast = 8092,
			mind_flay = 15407,
			mind_sear = 48045,
			mind_spike = 73510,
			mind_vision = 2096,
			power_infusion = 10060,
			power_word_fortitude = 21562,
			power_word_shield = 17,
			prayer_of_mending = 33076,
			psychic_horror = 64044,
			resurrection = 2006,
			shackle_undead = 9484,
			shadow_word_death = 32379,
			shadow_word_pain = 589,
			shadowfiend = 34433,
			shadowform = 15473,
			silence = 15487,
			surge_of_darkness = 87160,
			spectral_guise = 112833,
			vampiric_embrace = 15286,
			vampiric_touch = 34914,
			void_entropy = 155361,
		}

		talent = {
			deperate_prayer = 	{enabled=getTalent(1,1)},
			spectral_guise = 	{enabled=getTalent(1,2)},
			angelic_bulwark = 	{enabled=getTalent(1,3)},

			body_and_soul = 	{enabled=getTalent(2,1)},
			angelic_feather = 	{enabled=getTalent(2,2)},
			phantasm = 			{enabled=getTalent(2,3)},

			surge_of_darkness = {enabled=getTalent(3,1)},
			mindbender =		{enabled=getTalent(3,2)},
			insanity = 			{enabled=getTalent(3,3)},

			void_tendrils = 	{enabled=getTalent(4,1)},
			psychic_scream = 	{enabled=getTalent(4,2)},
			dominate_mind = 	{enabled=getTalent(4,3)},

			twist_of_fate = 	{enabled=getTalent(5,1)},
			power_infusion = 	{enabled=getTalent(5,2)},
			shadowy_insight = 	{enabled=getTalent(5,3)},

			cascade = 			{enabled=getTalent(6,1)},
			divine_star = 		{enabled=getTalent(6,2)},
			halo = 				{enabled=getTalent(6,3)},

			clarity_of_power =	{enabled=getTalent(7,1)},
			void_entropy = 		{enabled=getTalent(7,2)},
			auspicious_spirits = {enabled=getTalent(7,3)},
		}

		buff = {
			surge_of_darkness = {react=UnitDebuffID("player",spell.surge_of_darkness)},
		}

		dot = {
		}

		cooldown = {
		}

		set_bonus = {
			tier17_2pc = TierScan("T17") >= 2,
			tier17_4pc = TierScan("T17") >= 2,
			tier18_2pc = TierScan("T18") >= 2,
			tier18_4pc = TierScan("T18") >= 4,
		}

		glyph = {
		}

		player = {
			hp = getHP("player"),
			mana = getMana("player"),
			shadowform = getDruidForm(),
			GCD = 1.5/(1+UnitSpellHaste("player")/100),
		}

		local shadow_orb = UnitPower("player", SPELL_POWER_SHADOW_ORBS)


		------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- CHECKS --------------------------------------------------------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------------------------------------------------------------

		-- Ko'ragh Mind Controll Check
			if UnitDebuffID("player",163472) then return end

			-- Food/Invis Check
			if canRun() ~= true then return false end

			-- Mounted Check (except nagrand outpost mounts)
			if IsMounted("player") and not (UnitBuffID("player",164222) or UnitBuffID("player",165803)) then return false end

			if _Queues == nil then
				_Queues = {
					[Halo]  = false,
					[Cascade] = false,
					[DP] = false,
				}
			end

			if _Queues ~= nil then
				if _Queues[Halo] ~= true then 		_Queues[Halo]=false end
				if _Queues[Cascade] ~= true then 	_Queues[Cascade]=false end
				if _Queues[DP] ~= true then 		_Queues[DP]=false end
			end

		------------------------------------------------------------------------------------------------------
		-- Pause ---------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
			ChatOverlay("|cffFF0000BadBoy Paused", 0) return
		end
		------------------------------------------------------------------------------------------------------
		-- Input / Keys --------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------------
		-- Always check --------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------------
		-- Out of Combat -------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------------
		-- In Combat -----------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if isInCombat("player") or isInCombat("target") then

			------------------------------------------------------------------------------------------------------
			-- Dummy Test ----------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			if isChecked("DPS Testing") then
				if UnitExists("target") then
					if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
						StopAttack()
						ClearTarget()
						print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
					end
				end
			end

			------------------------------------------------------------------------------------------------------
			-- Queued Spells -------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			if _Queues[Halo] == true then
				ChatOverlay("Q - HALO")
				if castSpell("player",Halo,true,false) then return end
			end
			if _Queues[Cascade] == true then
				ChatOverlay("Q - CASCADE")
				if castSpell("target",Cascade,true,false) then return end
			end
			if _Queues[DP] == true then
				if options.player.ORBS < 3 then _Queues[DP] = false end
				ChatOverlay("Q - DP")
				if castSpell("target",DP,false,true) then return end
			end
			if _Queues[AngelicFeather] == true then
				if castGround("player",AngelicFeather,30) then
					SpellStopTargeting()
					return
				end
			end

			------------------------------------------------------------------------------------------------------
			-- Do everytime --------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------
			-- Defensive -----------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------
			-- Offensive -----------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------
			-- Rotation ------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

				------------------------------------------------------------------------------------------------------
				-- call always ---------------------------------------------------------------------------------------
				------------------------------------------------------------------------------------------------------
				-- actions=shadowform,if=!buff.shadowform.up
				-- actions+=/use_item,slot=finger1
				-- actions+=/potion,name=draenic_intellect,if=buff.bloodlust.react|target.time_to_die<=40
				-- actions+=/use_item,name=nithramus_the_allseer
				-- actions+=/power_infusion,if=talent.power_infusion.enabled
				-- actions+=/silence,if=target.debuff.casting.react
				-- actions+=/blood_fury
				-- actions+=/berserking
				-- actions+=/arcane_torrent
				-- actions+=/call_action_list,name=pvp_dispersion,if=set_bonus.pvp_2pc
				-- actions+=/call_action_list,name=decision

				-- actions.decision=call_action_list,name=main,if=(!talent.clarity_of_power.enabled&!talent.void_entropy.enabled)|(talent.clarity_of_power.enabled&buff.bloodlust.up&buff.power_infusion.up)
				-- actions.decision+=/call_action_list,name=vent,if=talent.void_entropy.enabled&!talent.clarity_of_power.enabled&!talent.auspicious_spirits.enabled
				-- actions.decision+=/call_action_list,name=cop,if=talent.clarity_of_power.enabled&!talent.insanity.enabled
				-- actions.decision+=/call_action_list,name=cop_dotweave,if=talent.clarity_of_power.enabled&talent.insanity.enabled&target.health.pct>20&active_enemies<=6
				-- actions.decision+=/call_action_list,name=cop_insanity,if=talent.clarity_of_power.enabled&talent.insanity.enabled
				
				------------------------------------------------------------------------------------------------------
				-- main ----------------------------------------------------------------------------------------------
				------------------------------------------------------------------------------------------------------
				-- actions.main=mindbender,if=talent.mindbender.enabled
				
				-- actions.main+=/shadowfiend,if=!talent.mindbender.enabled
				-- actions.main+=/shadow_word_death,if=natural_shadow_word_death_range&shadow_orb<=4,cycle_targets=1
				-- actions.main+=/mind_blast,if=glyph.mind_harvest.enabled&shadow_orb<=2&active_enemies<=5&cooldown_react
				-- actions.main+=/devouring_plague,if=shadow_orb=5&!target.dot.devouring_plague_dot.ticking&(talent.surge_of_darkness.enabled|set_bonus.tier17_4pc),cycle_targets=1
				-- actions.main+=/devouring_plague,if=shadow_orb=5
				-- actions.main+=/devouring_plague,if=shadow_orb>=3&talent.auspicious_spirits.enabled&shadowy_apparitions_in_flight>=3
				-- actions.main+=/devouring_plague,if=shadow_orb>=4&talent.auspicious_spirits.enabled&shadowy_apparitions_in_flight>=2
				-- actions.main+=/devouring_plague,if=shadow_orb>=3&buff.mental_instinct.remains<gcd&buff.mental_instinct.remains>(gcd*0.7)&buff.mental_instinct.remains
				-- actions.main+=/devouring_plague,if=shadow_orb>=4&talent.auspicious_spirits.enabled&((cooldown.mind_blast.remains<gcd&!set_bonus.tier17_2pc&(!set_bonus.tier18_4pc&!talent.mindbender.enabled))|(natural_shadow_word_death_range&cooldown.shadow_word_death.remains<gcd))&!target.dot.devouring_plague_tick.ticking&talent.surge_of_darkness.enabled,cycle_targets=1
				-- actions.main+=/devouring_plague,if=shadow_orb>=4&talent.auspicious_spirits.enabled&((cooldown.mind_blast.remains<gcd&!set_bonus.tier17_2pc&(!set_bonus.tier18_4pc&!talent.mindbender.enabled))|(target.health.pct<20&cooldown.shadow_word_death.remains<gcd))
				-- actions.main+=/devouring_plague,if=shadow_orb>=3&!talent.auspicious_spirits.enabled&((cooldown.mind_blast.remains<gcd&!set_bonus.tier17_2pc&(!set_bonus.tier18_4pc&!talent.mindbender.enabled))|(natural_shadow_word_death_range&cooldown.shadow_word_death.remains<gcd))&!target.dot.devouring_plague_tick.ticking&talent.surge_of_darkness.enabled,cycle_targets=1
				-- actions.main+=/devouring_plague,if=shadow_orb>=3&!talent.auspicious_spirits.enabled&((cooldown.mind_blast.remains<gcd&!set_bonus.tier17_2pc&(!set_bonus.tier18_4pc&!talent.mindbender.enabled))|(target.health.pct<20&cooldown.shadow_word_death.remains<gcd))
				-- actions.main+=/devouring_plague,if=shadow_orb>=3&talent.auspicious_spirits.enabled&set_bonus.tier18_4pc&talent.mindbender.enabled&buff.premonition.up
				-- actions.main+=/mind_blast,if=glyph.mind_harvest.enabled&mind_harvest=0,cycle_targets=1
				-- actions.main+=/mind_blast,if=talent.auspicious_spirits.enabled&active_enemies<=4&cooldown_react
				-- actions.main+=/shadow_word_pain,if=talent.auspicious_spirits.enabled&remains<(18*0.3)&target.time_to_die>(18*0.75)&miss_react,cycle_targets=1,max_cycle_targets=7
				-- actions.main+=/mind_blast,if=cooldown_react
				-- actions.main+=/insanity,if=t18_class_trinket&target.debuff.mental_fatigue.remains<gcd,interrupt_if=target.debuff.mental_fatigue.remains>gcd
				-- actions.main+=/mind_flay,if=t18_class_trinket&target.debuff.mental_fatigue.remains<gcd,interrupt_if=target.debuff.mental_fatigue.remains>gcd
				-- actions.main+=/searing_insanity,if=buff.insanity.remains<0.5*gcd&active_enemies>=3&cooldown.mind_blast.remains>0.5*gcd,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1),target_if=max:spell_targets.mind_sear_tick
				-- actions.main+=/searing_insanity,if=active_enemies>=3&cooldown.mind_blast.remains>0.5*gcd,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1),target_if=max:spell_targets.mind_sear_tick
				-- actions.main+=/insanity,if=buff.insanity.remains<0.5*gcd&active_enemies<=2,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1|shadow_orb=5)
				-- actions.main+=/insanity,chain=1,if=active_enemies<=2,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1|shadow_orb=5)
				-- actions.main+=/halo,if=talent.halo.enabled&target.distance<=30&active_enemies>2
				-- actions.main+=/cascade,if=talent.cascade.enabled&set_bonus.tier18_4pc&buff.premonition.up&active_enemies>2&target.distance<=40
				-- actions.main+=/divine_star,if=talent.divine_star.enabled&set_bonus.tier18_4pc&buff.premonition.up&active_enemies>4&target.distance<=24
				-- actions.main+=/cascade,if=talent.cascade.enabled&!set_bonus.tier18_4pc&active_enemies>2&target.distance<=40
				-- actions.main+=/divine_star,if=talent.divine_star.enabled&!set_bonus.tier18_4pc&active_enemies>4&target.distance<=24
				-- actions.main+=/shadow_word_pain,if=!talent.auspicious_spirits.enabled&remains<(18*0.3)&target.time_to_die>(18*0.75)&miss_react&active_enemies<=5,cycle_targets=1,max_cycle_targets=5
				-- actions.main+=/vampiric_touch,if=remains<(15*0.3+cast_time)&target.time_to_die>(15*0.75+cast_time)&miss_react&active_enemies<=5,cycle_targets=1,max_cycle_targets=5
				-- actions.main+=/devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=3&ticks_remain<=1
				-- actions.main+=/mind_spike,if=buff.surge_of_darkness.react&active_enemies<=5&set_bonus.tier18_4pc&buff.premonition.up
				-- actions.main+=/mind_spike,if=active_enemies<=5&buff.surge_of_darkness.react=3
				-- actions.main+=/halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
				-- actions.main+=/cascade,if=talent.cascade.enabled&set_bonus.tier18_4pc&buff.premonition.up&(active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11
				-- actions.main+=/divine_star,if=talent.divine_star.enabled&set_bonus.tier18_4pc&buff.premonition.up&target.distance<=24
				-- actions.main+=/cascade,if=talent.cascade.enabled&!set_bonus.tier18_4pc&(active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11
				-- actions.main+=/divine_star,if=talent.divine_star.enabled&!set_bonus.tier18_4pc&target.distance<=24
				-- actions.main+=/wait,sec=cooldown.shadow_word_death.remains,if=natural_shadow_word_death_range&cooldown.shadow_word_death.remains<0.5&active_enemies<=1,cycle_targets=1
				-- actions.main+=/wait,sec=cooldown.mind_blast.remains,if=cooldown.mind_blast.remains<0.5&cooldown.mind_blast.remains&active_enemies<=1
				-- actions.main+=/mind_spike,if=buff.surge_of_darkness.react&active_enemies<=5&!set_bonus.tier18_4pc
				-- actions.main+=/mind_spike,if=buff.surge_of_darkness.react&active_enemies<=5&set_bonus.tier18_4pc&(buff.premonition.up|talent.mindbender.enabled)
				-- actions.main+=/mind_spike,if=buff.surge_of_darkness.react&active_enemies<=5&set_bonus.tier18_4pc&!talent.mindbender.enabled&cooldown.shadowfiend.remains>13&buff.surge_of_darkness.remains<(1.1*gcd*buff.surge_of_darkness.react)
				-- actions.main+=/divine_star,if=talent.divine_star.enabled&target.distance<=28&active_enemies>1
				-- actions.main+=/mind_sear,chain=1,if=active_enemies>=4,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1|shadow_orb=5),target_if=max:spell_targets.mind_sear_tick
				-- actions.main+=/shadow_word_pain,if=talent.auspicious_spirits.enabled&remains<(18*0.9)&target.time_to_die>(18*0.75)&active_enemies>=3&miss_react,cycle_targets=1,max_cycle_targets=7
				-- actions.main+=/shadow_word_pain,if=shadow_orb>=2&ticks_remain<=3&target.time_to_die>(18*0.75)&talent.insanity.enabled
				-- actions.main+=/vampiric_touch,if=shadow_orb>=2&ticks_remain<=3.5&target.time_to_die>(15*0.75+cast_time)&talent.insanity.enabled
				-- actions.main+=/mind_flay,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1|shadow_orb=5)
				-- actions.main+=/shadow_word_death,moving=1,if=movement.remains>=1*gcd
				-- actions.main+=/power_word_shield,moving=1,if=talent.body_and_soul.enabled&movement.distance>=25
				-- actions.main+=/halo,if=talent.halo.enabled&target.distance<=30,moving=1
				-- actions.main+=/divine_star,moving=1,if=talent.divine_star.enabled&target.distance<=28
				-- actions.main+=/cascade,moving=1,if=talent.cascade.enabled&target.distance<=40
				-- actions.main+=/shadow_word_pain,moving=1,cycle_targets=1

				------------------------------------------------------------------------------------------------------
				-- 2 -------------------------------------------------------------------------------------------------
				------------------------------------------------------------------------------------------------------

			end
		end
	end
end