-- SimC Rotation
-- Last Update: 2015-06-18
if select(3, UnitClass("player")) == 5 and GetSpecialization() == 3 then

	function cShadow:shadowSimC()
		-- Locals
		local player,orbs = "player",self.orbs
		local buff,cd,mode,talent,glyph,gcd = self.buff,self.cd,self.mode,self.talent,self.glyph,self.gcd
		local isChecked,enemies,units = isChecked,self.enemies,self.units
		local spell,options,set_bonus = self.spell,self.options,self.set_bonus
		local AS = self.AS

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
				-- actions.main=mindbender,if=talent.mindbender.enabled
				if talent.mindbender then
					if self.castMindbender("target") then return end
				end

				-- actions.main+=/shadowfiend,if=!talent.mindbender.enabled
				if not talent.mindbender then
					if self.castShadowfiend("target") then return end
				end

				-- actions.main+=/shadow_word_death,if=natural_shadow_word_death_range&shadow_orb<=4,cycle_targets=1
				if self.castSWDAuto("target") then return end

				-- actions.main+=/mind_blast,if=glyph.mind_harvest.enabled&shadow_orb<=2&active_enemies<=5&cooldown_react
				-- tbd

				-- actions.main+=/devouring_plague,if=shadow_orb=5&!target.dot.devouring_plague_dot.ticking&(talent.surge_of_darkness.enabled|set_bonus.tier17_4pc),cycle_targets=1
				if orbs==5 and not getDebuffRemain("target",spell.devouring_plague,"player")>0 then
					if (talent.surge_of_darkness or set_bonus.tier18_4pc) then
						if self.castDP("target") then return end
					end
				end

				-- actions.main+=/devouring_plague,if=shadow_orb=5
				if orbs == 5 then
					if self.castDP("target") then return end
				end

				-- actions.main+=/devouring_plague,if=shadow_orb>=3&talent.auspicious_spirits.enabled&shadowy_apparitions_in_flight>=3
				if orbs >= 3 then
					if talent.auspicious_spirits then
						if AS.flying >= 3 then
							if self.castDP("target") then return end
						end
					end
				end

				-- actions.main+=/devouring_plague,if=shadow_orb>=4&talent.auspicious_spirits.enabled&shadowy_apparitions_in_flight>=2
				if orbs >= 4 then
					if talent.auspicious_spirits then
						if AS.flying >= 2 then
							if self.castDP("target") then return end
						end
					end
				end

				-- actions.main+=/devouring_plague,if=shadow_orb>=3&buff.mental_instinct.remains<gcd&buff.mental_instinct.remains>(gcd*0.7)&buff.mental_instinct.remains
				if orbs >= 3 then
					if buff.mental_instinct < gcd then
						if buff.mental_instinct > (gcd*0.7) then
							if castDP("target") then return end
						end
					end
				end

				-- actions.main+=/devouring_plague,if=shadow_orb>=4&talent.auspicious_spirits.enabled&((cooldown.mind_blast.remains<gcd&!set_bonus.tier17_2pc&(!set_bonus.tier18_4pc&!talent.mindbender.enabled))|(natural_shadow_word_death_range&cooldown.shadow_word_death.remains<gcd))&!target.dot.devouring_plague_tick.ticking&talent.surge_of_darkness.enabled,cycle_targets=1
				if orbs >= 4 then
					if talent.auspicious_spirits then
						if ((cd.mind_blast<gcd and not set_bonus.tier17_2pc and (not set_bonus.tier17_4pc and not talent.mindbender)) or (cd.shadow_word_death<gcd)) then 
							if not UnitBuffID("target",spell.devouring_plague,"player") and talent.surge_of_darkness then
								if castDP("target") then return end
							end
						end
					end
				end

				-- actions.main+=/devouring_plague,if=shadow_orb>=4&talent.auspicious_spirits.enabled&((cooldown.mind_blast.remains<gcd&!set_bonus.tier17_2pc&(!set_bonus.tier18_4pc&!talent.mindbender.enabled))|(target.health.pct<20&cooldown.shadow_word_death.remains<gcd))
				if orbs >= 4 then
					if talent.auspicious_spirits then
						((cooldown.mind_blast.remains<gcd&!set_bonus.tier17_2pc&(!set_bonus.tier18_4pc&!talent.mindbender.enabled))|(target.health.pct<20&cooldown.shadow_word_death.remains<gcd))
						if ((cd.mind_blast<gcd and not set_bonus.tier17_2pc and (not set_bonus.tier18_4pc and not talent.mindbender))
						or (getHP("target")<20 and cd.shadow_word_death<gcd)) then
							if castDP("target") then return end
						end
					end
				end
				
				-- actions.main+=/devouring_plague,if=shadow_orb>=3&!talent.auspicious_spirits.enabled&((cooldown.mind_blast.remains<gcd&!set_bonus.tier17_2pc&(!set_bonus.tier18_4pc&!talent.mindbender.enabled))|(natural_shadow_word_death_range&cooldown.shadow_word_death.remains<gcd))&!target.dot.devouring_plague_tick.ticking&talent.surge_of_darkness.enabled,cycle_targets=1
				if orbs >= 3 then
					if not talent.auspicious_spirits then
						if ((cd.mind_blast<gcd and not set_bonus.tier17_2pc and (not set_bonus.tier18_4pc and not talent.mindbender)) 
						or (cd.shadow_word_death<gcd)) and not UnitDebuffID("target",spell.devouring_plague,"player") and talent.surge_of_darkness then
							if castDP("target") then return end
						end
					end
				end

				-- actions.main+=/devouring_plague,if=shadow_orb>=3&!talent.auspicious_spirits.enabled&((cooldown.mind_blast.remains<gcd&!set_bonus.tier17_2pc&(!set_bonus.tier18_4pc&!talent.mindbender.enabled))|(target.health.pct<20&cooldown.shadow_word_death.remains<gcd))
				if orbs >= 3 then
					if not talent.auspicious_spirits then
						if ((cd.mind_blast < gcd and not set_bonus.tier17_2pc and (not set_bonus.tier18_4pc and not talent.mindbender)) 
						or getHP("target")<20 and cd.shadow_word_death<gcd) then
							if castDP("target") then return end
						end
					end
				end
				
				-- actions.main+=/devouring_plague,if=shadow_orb>=3&talent.auspicious_spirits.enabled&set_bonus.tier18_4pc&talent.mindbender.enabled&buff.premonition.up
				if orbs >= 3 then
					if talent.auspicious_spirits then
						if set_bonus.tier18_4pc then
							if talent.mindbender then
								if buff.premonition > 0 then
									if castDP("target") then return end
								end
							end
						end
					end
				end

				-- actions.main+=/mind_blast,if=glyph.mind_harvest.enabled&mind_harvest=0,cycle_targets=1

				-- actions.main+=/mind_blast,if=talent.auspicious_spirits.enabled&active_enemies<=4&cooldown_react
				if talent.auspicious_spirits then
					if #getEnemies("player",40)<=4 then
						if castMB("target") then return end
					end
				end

				-- actions.main+=/shadow_word_pain,if=talent.auspicious_spirits.enabled&remains<(18*0.3)&target.time_to_die>(18*0.75)&miss_react,cycle_targets=1,max_cycle_targets=7

				-- actions.main+=/mind_blast,if=cooldown_react
				if castMB("target") then return end

				-- actions.main+=/insanity,if=t18_class_trinket&target.debuff.mental_fatigue.remains<gcd,interrupt_if=target.debuff.mental_fatigue.remains>gcd
				if set_bonus.class_trinket then
					if getDebuffRemain("target",spell.mental_fatigue,"player")<gcd then
						if castMindFlay("target") then return end
					end
				end

				-- actions.main+=/searing_insanity,if=buff.insanity.remains<0.5*gcd&active_enemies>=3&cooldown.mind_blast.remains>0.5*gcd,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1),target_if=max:spell_targets.mind_sear_tick
				if buff.insanity<0.5*gcd then
					if #getEnemies("player",40) >= 3 then
						if cd.mind_blast > 0.5*gcd then
							-- cast searing insanity
						end
					end
				end

				-- actions.main+=/searing_insanity,if=active_enemies>=3&cooldown.mind_blast.remains>0.5*gcd,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1),target_if=max:spell_targets.mind_sear_tick

				-- actions.main+=/insanity,if=buff.insanity.remains<0.5*gcd&active_enemies<=2,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1|shadow_orb=5)
				if buff.insanity < 0.5*gcd then
					if #getEnemies("player",40) <=2 then
						if castMF("target") then return end
					end
				end

				-- actions.main+=/insanity,chain=1,if=active_enemies<=2,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1|shadow_orb=5)

				-- actions.main+=/halo,if=talent.halo.enabled&target.distance<=30&active_enemies>2
				if talent.halo then
					if getDistance("player","target") <= 30
						if #getEnemies("player",30) > 2 then
							if castHalo() then return end
						end
					end
				end

				-- actions.main+=/cascade,if=talent.cascade.enabled&set_bonus.tier18_4pc&buff.premonition.up&active_enemies>2&target.distance<=40
				if talent.cascade then
					if set_bonus.tier18_4pc then
						if buff.premonition > 0 then
							if #getEnemies("player",40) > 2 then
									if castCascadeAuto() then return end
								end
							end
						end
					end
				end

				-- actions.main+=/divine_star,if=talent.divine_star.enabled&set_bonus.tier18_4pc&buff.premonition.up&active_enemies>4&target.distance<=24

				-- actions.main+=/cascade,if=talent.cascade.enabled&!set_bonus.tier18_4pc&active_enemies>2&target.distance<=40
				if talent.cascade then
					if not set_bonus.tier18_4pc then
						if #getEnemies("player",40) > 2 then
							if castCascadeAuto() then return end
						end
					end
				end

				-- actions.main+=/divine_star,if=talent.divine_star.enabled&!set_bonus.tier18_4pc&active_enemies>4&target.distance<=24
				
				-- actions.main+=/shadow_word_pain,if=!talent.auspicious_spirits.enabled&remains<(18*0.3)&target.time_to_die>(18*0.75)&miss_react&active_enemies<=5,cycle_targets=1,max_cycle_targets=5
				
				-- actions.main+=/vampiric_touch,if=remains<(15*0.3+cast_time)&target.time_to_die>(15*0.75+cast_time)&miss_react&active_enemies<=5,cycle_targets=1,max_cycle_targets=5
				
				-- actions.main+=/devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=3&ticks_remain<=1
				if not talent.void_entropy then
					if orbs >= 3
						if getDebuffRemain("target",spell.devouring_plague,"player") <= 4*gcd/6 then
							if castDP("target") then return end
						end
					end
				end

				-- actions.main+=/mind_spike,if=buff.surge_of_darkness.react&active_enemies<=5&set_bonus.tier18_4pc&buff.premonition.up
				if buff.surge_of_darkness > 0 then
					if #getEnemies("player",40) <= 5 then
						if set_bonus.tier18_4pc then
							if buff.premonition > 0 then
								if castMindSpike("target",true) then return end
							end
						end
					end
				end

				-- actions.main+=/mind_spike,if=active_enemies<=5&buff.surge_of_darkness.react=3
				if #getEnemies("player",40) <= 5 then
					if getBuffStacks("player",spell.surge_of_darkness) == 3 then
						if castMindSpike("target",true) then return end
					end
				end

				-- actions.main+=/halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
				if talent.halo then
					if getDistance("player","target") <= 30 then
						if getDistance("player","target") >= 17 then
							if castHalo() then return end
						end
					end
				end

				-- actions.main+=/cascade,if=talent.cascade.enabled&set_bonus.tier18_4pc&buff.premonition.up&(active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11
				if talent.cascade then
					if set_bonus.tier18_4pc then
						if buff.premonition > 0 then
							if #getEnemies("player",40) > 1 then
								if castCascadeAuto() then return end
							end
						end
					end
				end

				-- actions.main+=/divine_star,if=talent.divine_star.enabled&set_bonus.tier18_4pc&buff.premonition.up&target.distance<=24

				-- actions.main+=/cascade,if=talent.cascade.enabled&!set_bonus.tier18_4pc&(active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11
				if talent.cascade then
					if not set_bonus.tier18_4pc then
						if #getEnemies("player",40) > 1 then
							if castCascadeAuto() then return end
						end
					end
				end

				-- actions.main+=/divine_star,if=talent.divine_star.enabled&!set_bonus.tier18_4pc&target.distance<=24
				-- actions.main+=/wait,sec=cooldown.shadow_word_death.remains,if=natural_shadow_word_death_range&cooldown.shadow_word_death.remains<0.5&active_enemies<=1,cycle_targets=1
				if cd.shadow_word_death < 0.5 then
					if #getEnemies("player",40) <= 1 then return end
				end

				-- actions.main+=/wait,sec=cooldown.mind_blast.remains,if=cooldown.mind_blast.remains<0.5&cooldown.mind_blast.remains&active_enemies<=1
				if cd.mind_blast < 0.5 then
					if #getEnemies("player",40) <= 1 then return end
				end

				-- actions.main+=/mind_spike,if=buff.surge_of_darkness.react&active_enemies<=5&!set_bonus.tier18_4pc
				if buff.surge_of_darkness > 0 then
					if #getEnemies("player",40) <= 5 then
						if not set_bonus.tier18_4pc then
							if castMindSpike("target",true) then return end
						end
					end
				end

				-- actions.main+=/mind_spike,if=buff.surge_of_darkness.react&active_enemies<=5&set_bonus.tier18_4pc&(buff.premonition.up|talent.mindbender.enabled)
				if buff.surge_of_darkness > 0 then
					if #getEnemies("player",40) <= 5 then
						if set_bonus.tier18_4pc then
							if (buff.premonition>0 or talent.mindbender) then
								if castMindSpike("target",true) then return end
							end
						end
					end
				end

				-- actions.main+=/mind_spike,if=buff.surge_of_darkness.react&active_enemies<=5&set_bonus.tier18_4pc&!talent.mindbender.enabled&cooldown.shadowfiend.remains>13&buff.surge_of_darkness.remains<(1.1*gcd*buff.surge_of_darkness.react)
				if buff.surge_of_darkness > 0 then
					if #getEnemies("player",40) <= 5 then
						if set_bonus.tier18_4pc then
							if not talent.mindbender then
								if cd.shadowfiend > 13 then
									if buff.surge_of_darkness < (1.1*gcd*getBuffStacks("player",spell.surge_of_darkness)) then
										if castMindSpike("target",true) then return end
									end
								end
							end
						end
					end
				end

				-- actions.main+=/divine_star,if=talent.divine_star.enabled&target.distance<=28&active_enemies>1

				-- actions.main+=/mind_sear,chain=1,if=active_enemies>=4,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1|shadow_orb=5),target_if=max:spell_targets.mind_sear_tick
				
				-- actions.main+=/shadow_word_pain,if=talent.auspicious_spirits.enabled&remains<(18*0.9)&target.time_to_die>(18*0.75)&active_enemies>=3&miss_react,cycle_targets=1,max_cycle_targets=7
				
				-- actions.main+=/shadow_word_pain,if=shadow_orb>=2&ticks_remain<=3&target.time_to_die>(18*0.75)&talent.insanity.enabled
				
				-- actions.main+=/vampiric_touch,if=shadow_orb>=2&ticks_remain<=3.5&target.time_to_die>(15*0.75+cast_time)&talent.insanity.enabled
				
				-- actions.main+=/mind_flay,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1|shadow_orb=5)
				
				-- actions.main+=/shadow_word_death,moving=1,if=movement.remains>=1*gcd
				if isMoving("player") then
					if castSWDAuto() then return end
				end
				
				-- actions.main+=/power_word_shield,moving=1,if=talent.body_and_soul.enabled&movement.distance>=25
				
				-- actions.main+=/halo,if=talent.halo.enabled&target.distance<=30,moving=1
				
				-- actions.main+=/divine_star,moving=1,if=talent.divine_star.enabled&target.distance<=28
				
				-- actions.main+=/cascade,moving=1,if=talent.cascade.enabled&target.distance<=40
				
				-- actions.main+=/shadow_word_pain,moving=1,cycle_targets=1

			-- actions.decision+=/call_action_list,name=vent,if=talent.void_entropy.enabled&!talent.clarity_of_power.enabled&!talent.auspicious_spirits.enabled
			

			-- actions.decision+=/call_action_list,name=cop,if=talent.clarity_of_power.enabled&!talent.insanity.enabled
			

			-- actions.decision+=/call_action_list,name=cop_dotweave,if=talent.clarity_of_power.enabled&talent.insanity.enabled&target.health.pct>20&active_enemies<=6
			

			-- actions.decision+=/call_action_list,name=cop_insanity,if=talent.clarity_of_power.enabled&talent.insanity.enabled

				