-- ragnar T18 rotation
if select(3, UnitClass("player")) == 5 and GetSpecialization() == 3 then

function cShadow:shadowRavens()
		-- Locals
		local player,orbs,health = "player",self.orbs,self.health
		local buff,cd,mode,talent,glyph,gcd = self.buff,self.cd,self.mode,self.talent,self.glyph,self.gcd
		local isChecked,enemies,units = isChecked,self.enemies,self.units
		local spell,options,eq = self.spell,self.options,self.eq
		local AS = self.AS
		local active_enemies_30, active_enemies_40 = self.enemies.active_enemies_30, self.enemies.active_enemies_40

		------------------------------------------------------------------------------------------------------
		-- Spell Queue ---------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------

		-- setup queue: in OOC
		-- if _Queues[120644] == nil or _Queues == nil then
		-- 	_Queues = {
		-- 		[120644]  = false,		-- Halo
		-- 		[127632] = 	false,		-- Cascade
		-- 		[2944] = 	false,		-- Devouring Plague
		-- 		[34433] = 	false,		-- Shadowfiend
		-- 		[123040] = 	false,		-- Mindbender
		-- 	}
		-- end

		-- -- check queue vars
		-- if _Queues ~= nil then
		-- 	if _Queues[120644] ~= true then 	_Queues[120644]=false end
		-- 	if _Queues[127632] ~= true then 	_Queues[127632]=false end
		-- 	if _Queues[2944] ~= true then 		_Queues[2944]=false end
		-- 	if _Queues[34433] ~= true then 		_Queues[34433]=false end
		-- 	if _Queues[123040] ~= true then 	_Queues[123040]=false end
		-- end


		-- Check for queued spells
		if _Queues[spell.halo] == true then
			ChatOverlay("Q - HALO")
			if self.castHalo() then return end
		end
		if _Queues[spell.cascade] == true then
			ChatOverlay("Q - CASCADE")
			if self.castCascade() then return end
		end
		if _Queues[spell.devouring_plague] == true then
			ChatOverlay("Q - DP")
			if self.castDP("target") then return end
		end
		if _Queues[spell.shadowfiend] == true then
			ChatOverlay("Q - SHADOWFIEND")
			if self.castShadowfiend("target") then return end
		end
		if _Queues[spell.mindbender] == true then
			ChatOverlay("Q - MINDBENDER")
			if self.castMindbender("target") then return end
		end
		if _Queues[spell.dispersion] == true then
			ChatOverlay("Q - Dispersion")
			if self.castDispersion() then return end
		end

		------------------------------------------------------------------------------------------------------
		-- Do everytime --------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if mode.feather == 2 and IsMovingTime(0.2) then
			if self.castAngelicFeatherOnMe() then return end
		end
		
		-- Pause toggle
		-- if options.utilities.pause.enabled and SpecificToggle("Pause Toggle") == true then
		-- 	ChatOverlay("|cffFF0000BadBoy Paused", 0) return
		-- end

		-- shadow form
		if not shadowform then
			if self.castShadowform() then return end
		end

		-- lastVTTime nil prevention
		if lastVTTime == nil then lastVTTime=GetTime()-10 end
		if lastVTTarget == nil then lastVTTarget="0" end

		-- DP queue fix
		if _Queues[2944]==true and orbs<3 then _Queues[2944]=false end
		
		------------------------------------------------------------------------------------------------------
		-- Boss Helper ---------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if mode.bosshelper == 2 then
			--self.BossHelperT17()
			self:BossHelperT18()
		end

		------------------------------------------------------------------------------------------------------
		-- Defensive -----------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if mode.defensive == 2 then
			-- power word: shield
			if options.defensive.PWS then
				if health <= options.defensive.PWSvalue then
					if self.castPWS("player") then return end
				end
			end
			-- desperate prayer
			if options.defensive.Desperate_Prayer then
				if health <= options.defensive.Desperate_Prayervalue then
					if self.castDesperatePrayer() then return end
				end
			end
			-- fade glyph
			if options.defensive.Fade then
				if glyph.fade then
					if health <= options.defensive.Fadevalue then
						if self.castFade() then return end
					end
				end
			end
			-- healing tonic
			if options.defensive.Healing_Tonic then
				if health <= options.defensive.Healing_Tonicvalue then
					if canUse(109223) then useItem(109223) return end
				end
			end
			-- dispersion
			if options.defensive.Dispersion then
				if health <= options.defensive.Dispersionvalue then
					if self.castDispersion() then return end
				end
			end			
		end

		------------------------------------------------------------------------------------------------------
		-- Offensive -----------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if options.cooldowns.PI then
			if self.castPowerInfusion() then return end
		end

		------------------------------------------------------------------------------------------------------
		-- Special keys --------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if options.rotation.Burst_SI then
			if SpecificToggle("Burst SI") then
				-- Mind Blast
				if options.rotation.Burst_SI == false then
					if orbs <= 3 then
						if self.castMindBlast("target") then return end
					end
				end
				-- DP
				if select(1,UnitChannelInfo("player")) ~= "Searing Insanity" then
					if not buff.insanity then
						if self.castDP("target") then return end
					end
				end
				-- Clip it
				if buff.insanity and buff.remain.insanity <= 2*gcd then
					if select(1,UnitChannelInfo("player")) ~= nil then
						local cEnd = select(6,UnitChannelInfo("player"))
						local cRem = cEnd - GetTime()*1000
						local rnd = math.random(100,500)
						-- Clip it
						if cRem < rnd then
							if self.castMindFlay("target") then return end
						end
					end
				end
				-- Searing Insanity
				if buff.insanity then
					if select(1,UnitChannelInfo("player")) ~= "Searing Insanity" then
						if self.castMindSear("target") then return end
					end
				end
				if UnitChannelInfo("player") == "Searing Insanity" then
					return
				end
			end
		end

		------------------------------------------------------------------------------------------------------
		-- dot farm ------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------

		--if options.utilities.dot_farm.enabled then return end

		------------------------------------------------------------------------------------------------------
		-- Rotation ------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		--[[ auspicious_spirits ]]
		if talent.auspicious_spirits then
			-- Mindbender
			if talent.mindbender then 
				if self.castMindbender("target") then return end
			end

			-- Shadowfiend
			if not talent.mindbender then
				if self.castShadowfiend("target") then return end
			end

			-- Shadow Word: Death
			if self.castSWDAuto("target") then return end

			-- Mind Blast with Mind Harvest TBD

			-- DP logics
				-- spread DPx5 on SoD
				if orbs == 5 then
					if talent.surge_of_darkness then
						if getDebuffRemain("target",spell.devouring_plague,"player") == 0 then
							if self.castDP("target") then return end
						else
							for i=1,#enemiesTable do
								local thisUnit = enemiesTable[i].unit
								if getDebuffRemain(thisUnit,spell.devouring_plague,"player") <= 0 then
									if self.castDP(thisUnit) then return end
								end
							end
						end
					end
				end
				-- DP 5 orbs
				if orbs == 5 then
					if self.castDP("target") then return end
				end
				-- dump for incoming spirits 3+3
				if orbs >= 3 then
					if AS.flying >= 3 then
						--if AS.nextImpactRemaining <= 1.5*gcd then
							if self.castDP("target") then return end
						--end
					end
				end
				-- dump for incoming spirits 4+2
				if orbs >= 4 then
					if AS.flying >= 2 then
						if self.castDP("target") then return end
					end
				end
				-- t18_4pc
				if orbs >= 3 then
					if eq.t18_4pc then
						if buff.premonition or AS.flying > 2 then
							if self.castDP("target") then return end
						end
					end
				end
				-- without any 4pc
				if orbs >= 3 then
					if not eq.t18_4pc then
						if getDebuffRemain("target",spell.devouring_plague,"player") <= 0 then
							if self.castDP("target") then return end
						end
					end
				end


			-- Mind Blast: Mind Harvest -- TBD

			-- Mind Blast
			if self.castMindBlast("target") then return end

			-- SWP cycle targets 7
			if self.castSWPAutoApply(options.rotation.max_Targetsvalue) then return end

			-- Searing Insanity: Automode
				-- TBD

			-- Insanity
			if buff.insanity then
				if select(1,UnitChannelInfo("player")) == "Insanity" then
					if getCastTimeRemain("player") < 0.61 then
						if self.castMindFlay("target") then return end
					end
				end
				if select(1,UnitChannelInfo("player")) == nil then
					if self.castMindFlay("target") then return end
				end
			end

			-- Halo
			if mode.t90 == 2 then
				if talent.halo then
					if getDistance("player","target") <= 30 then
						if active_enemies_30 > 2 then
							if self.castHalo() then return end
						end
					end
				end
			end

			-- Cascade
			if mode.t90 == 2 then
				if talent.cascade then
					if active_enemies_40 > 2 then
						if self.castCascade() then return end
					end
				end
			end

			-- Vampiric Touch cycle targets 5
			--if mode.multidot == 3 or mode.multidot == 4 then
				if self.castVTAutoApply(options.rotation.max_Targetsvalue) then return end
			--end

			-- SoD proc
			if buff.surge_of_darkness then
				if buff.premonition then
					if self.castMindSpike("target") then return end
				end
			end

			-- SoD proc
			if getBuffStacks("player",spell.surge_of_darkness) >= 3 then
				if self.castMindSpike("target") then return end
			end

			-- Halo
			if mode.t90 == 2 then
				if talent.halo then
					if getDistance("player","target") <= 30 then
						if getDistance("player","target") >= 17 then
							if self.castHalo() then return end
						end
					end
				end
			end

			-- Cascade
			if mode.t90 == 2 then
				if talent.cascade then
					if (active_enemies_40 > 1 or getDistance("player","target") >= 28) then
						if self.castCascade() then return end
					end
				end
			end

			-- -- wait for SWD
			-- if cd.shadow_word_death < 0.5 then
			-- 	if active_enemies_40 <= 1 then
			-- 		return
			-- 	end
			-- end

			-- -- wait for MB
			-- if cd.mind_blast < 0.5 then
			-- 	if enemies.active_enemies_40 <= 1 then
			-- 		return
			-- 	end
			-- end

			-- SoD procs not T18_4pc
			if not eq.t18_4pc then
				if buff.surge_of_darkness then
					if self.castMindSpike("target") then return end
				end
			end

			-- SoD procs with T18_4pc
			if eq.t18_4pc then
				if buff.surge_of_darkness then
					if buff.premonition or talent.mindbender then
						if self.castMindSpike("target") then return end
					end
				end
			end

			-- SoD procs with T18_4pc
			if eq.t18_4pc then
				if buff.surge_of_darkness then
					if not talent.mindbender then
						if cd.shadowfiend > 13 then
							if buff.surge_of_darkness < (1.1*gcd*getBuffStacks("player",spell.surge_of_darkness)) then
								if self.castMindSpike("target") then return end
							end
						end
					end
				end
			end

			-- Mind Flay
			if select(1,UnitChannelInfo("player")) ~= "Insanity" then
				if select(1,UnitChannelInfo("player")) == "Mind Flay" then
					if getCastTimeRemain("player") < 0.61 then
						if self.castMindFlay("target") then return end
					end
					return false
				end
				if self.castMindFlay("target") then return end
			end

			-- -- moving
			-- if IsMovingTime(0.3) then
			-- 	-- SWD
			-- 	if self.castSWDAuto("target",true) then return end
			-- 	-- PWS
			-- 	if talent.body_and_soul then
			-- 		if getDebuffRemain("player",6788) <= 0 then
			-- 			if self.castPWS("player") then return end
			-- 		end
			-- 	end
			-- 	-- SWP
			-- 	if self.castSWPAutoApply(10) then return end
			-- end
		end -- AS rotation

		--[[ clarity_of_power ]]
		if talent.clarity_of_power then
			--[[ start stopcasting ]]
			local mfrefreshtime = 2*gcd

			-- mindflay if full t18 class trinket stacks
			if UnitChannelInfo("player") == "Mind Flay" and eq.t18_classTrinket then
				if getDebuffStacks("target",spell.mental_fatigue,"player") >= 5 and getDebuffRemain("target",spell.mental_fatigue,"player") > mfrefreshtime then
					SpellStopCasting()
					return
				end
			end

			-- clip mindflay while building stacks
			if UnitChannelInfo("player") == "Mind Flay" and eq.t18_classTrinket then
				if getDebuffStacks("target",spell.mental_fatigue,"player") < 5 then
					if getCastTimeRemain("player") < 0.61 then
						SpellStopCasting()
						return
					end
				end
			end

			-- clip mindflay while building stacks
			if eq.t18_classTrinket then
			--if UnitChannelInfo("player") == "Insanity" and eq.t18_classTrinket then
				if buff.insanity and buff.remain.insanity < 1 then
					--if getCastTimeRemain("player") < (3 / ((UnitSpellHaste("player")/100)+1))*0.25 then
						if self.castMindFlay("target") then return end
						return
					--end
				end
			end

			-- MB ready
			if UnitChannelInfo("player") == "Mind Flay" or UnitChannelInfo("Insanity") then
				if cd.mind_blast < 0.1 and cd.mind_blast > 0
				or cd.shadow_word_death < 0.1 and cd.shadow_word_death > 0 then
					SpellStopCasting()
					return
				end
			end

			-- return rest
			if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then return end
			--[[ end stopcasting ]]
			
			--[[ ravens ]]
			if talent.mindbender then
				-- High Priority
				-- Shadow Word: Death
				if self.castSWDAuto("target") then return end

				-- Mind Blast
				if orbs < 5 then
					if self.castMindBlast("target") then return end
				end

				-- DP before stacks
				if eq.t18_classTrinket then
					if getDebuffStacks("player",spell.mental_fatigue,"player") < 5 and getDebuffRemain("target",spell.mental_fatigue,"player") > 1.2*gcd then
						if orbs >= 3 then
							if self.castDP("target") then return end
						end
					end
				end

				-- Insanity: extend mental fatigue
				if eq.t18_classTrinket then
					if (getDebuffRemain("target",spell.mental_fatigue,"player") > 0 and getDebuffRemain("target",spell.mental_fatigue,"player") < mfrefreshtime) 
					or getDebuffStacks("target",spell.mental_fatigue,"player") < 5 then
						if self.castMindFlay("target") then return end
					end
				end

				-- Below 20%, Devouring Plague
				if getHP("target") <= 20 then
					if self.castDP("target") then return end
				end

				-- Filler
				-- Shadowfiend
				if self.castShadowfiend("target") then return end

				-- Cascade/Halo
				if mode.t90 == 2 then
					if self.castCascade() then return end
					if self.castHalo() then return end
				end

				-- Power Word: Shield (only when taking damage)
				--if talent.mindbender and (lastSpellCast==2944 or lastSpellCast==17 or lastSpellCast==127632) then
					if glyph.pws then
						if getDebuffRemain("player",6788) <= 0 then
							if self.castPWS("player") then return end
						end
					end
				--end

				-- Mind Flay while DP on target
				if getDebuffRemain("target",spell.devouring_plague,"player") >= select(4,GetSpellInfo(spell.mind_spike))/1000 then
					if self.castMindFlay("target") then return end
				end	

				-- Mind Spike
				if select(1,UnitChannelInfo("player")) == nil
				or getDebuffRemain("target",spell.devouring_plague,"player") <= select(4,GetSpellInfo(spell.mind_spike))/1000
				or select(1,UnitChannelInfo("player")) == "Mind Flay" and getDebuffStacks("target",185104,"player")>=5 then
					if self.castMindSpike("target") then return end
				end
			end

			---------------------------------------------------------------------------------------------------------------------------------------- the other rotation
			--[[ simcraft ]]
			if talent.insanity then
				-- Simcraft: CoP_Insanity

				-- actions.cop_insanity=devouring_plague,if=shadow_orb=5|(active_enemies>=5&!buff.insanity.remains)
				if orbs == 5 then
					if self.castDP("target") then return end
				end

				-- actions.cop_insanity+=/mind_blast,if=active_enemies<=5&cooldown_react
				--if #enemiesTable <= 5 then
					if self.castMindBlast("target") then return end
				--end

				-- actions.cop_insanity+=/shadow_word_death,if=target.health.pct<20,cycle_targets=1
				if self.castSWDAuto("target") then return end

				-- actions.cop_insanity+=/insanity,if=t18_class_trinket&target.debuff.mental_fatigue.remains<gcd,interrupt_if=target.debuff.mental_fatigue.remains>gcd
				if eq.t18_classTrinket then
					if (getDebuffRemain("target",spell.mental_fatigue,"player") > 0 and getDebuffRemain("target",spell.mental_fatigue,"player") < mfrefreshtime) 
					or getDebuffStacks("target",spell.mental_fatigue,"player") < 5 then
						if self.castMindFlay("target") then return end
					end
				end

				-- actions.cop_insanity+=/devouring_plague,if=shadow_orb>=3&!set_bonus.tier17_2pc&!set_bonus.tier17_4pc&(cooldown.mind_blast.remains<gcd|(target.health.pct<20&cooldown.shadow_word_death.remains<gcd)),cycle_targets=1
				if orbs >= 3 then
					if getHP("target")<20 and (cd.shadow_word_death<gcd or cd.mind_blast<gcd) then
						if self.castDP("target") then return end
					end
				end
				
				-- actions.cop_insanity+=/shadowfiend,if=!talent.mindbender.enabled&set_bonus.tier18_2pc
				if eq.tier18_2pc then
					if self.castShadowfiend("target") then return end
				end
				
				-- actions.cop_insanity+=/mindbender,if=talent.mindbender.enabled&set_bonus.tier18_2pc
				if eq.tier18_2pc then
					if self.castMindbender("target") then return end
				end
				
				-- actions.cop_insanity+=/searing_insanity,if=buff.insanity.remains<0.5*gcd&active_enemies>=3&cooldown.mind_blast.remains>0.5*gcd,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1),target_if=max:spell_targets.mind_sear_tick
				
				-- actions.cop_insanity+=/searing_insanity,if=active_enemies>=5,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1),target_if=max:spell_targets.mind_sear_tick
				
				-- actions.cop_insanity+=/mindbender,if=talent.mindbender.enabled
				if self.castMindbender("target") then return end
				
				-- actions.cop_insanity+=/shadowfiend,if=!talent.mindbender.enabled
				if self.castShadowfiend("target") then return end
				
				-- actions.cop_insanity+=/mind_flay,if=t18_class_trinket&(target.debuff.mental_fatigue.remains<gcd|(cooldown.mind_blast.remains<2*gcd&target.debuff.mental_fatigue.remains<2*gcd)),interrupt_if=target.debuff.mental_fatigue.remains>gcd
				if eq.t18_classTrinket then
					if getDebuffRemain("target",spell.mental_fatigue,"player") > 0 then
						if getDebuffRemain("target",spell.mental_fatigue,"player") < gcd or (cd.mind_blast < 2*gcd and getDebuffRemain("target",spell.mental_fatigue,"player") < 2*gcd) then
							if self.castMindFlay("target") then return end
						end
					end
				end
				 
				-- actions.cop_insanity+=/shadow_word_pain,if=remains<(18*0.3)&target.time_to_die>(18*0.75)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
				
				-- actions.cop_insanity+=/vampiric_touch,if=remains<(15*0.3+cast_time)&target.time_to_die>(15*0.75+cast_time)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
				
				-- actions.cop_insanity+=/insanity,if=buff.insanity.remains<0.5*gcd&active_enemies<=2,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|(cooldown.shadow_word_death.remains<=0.1&target.health.pct<20))
				if buff.insanity and buff.remain.insanity<0.5*gcd then
					if self.castMindFlay("target") then return end
				end
				
				-- actions.cop_insanity+=/insanity,if=active_enemies<=2,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|(cooldown.shadow_word_death.remains<=0.1&target.health.pct<20))
				if buff.insanity then
					if self.castMindFlay("target") then return end
				end
				
				-- actions.cop_insanity+=/halo,if=talent.halo.enabled&!set_bonus.tier18_4pc&target.distance<=30&target.distance>=17
				if mode.t90 == 2 then
					if (not eq.tier18_4pc or buff.premonition) and getDistance("player","target") <= 30 and getDistance("player","target") >= 17 then
						if self.castHalo() then return end
					end
				end
				
				-- actions.cop_insanity+=/cascade,if=talent.cascade.enabled&!set_bonus.tier18_4pc&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
				if mode.t90 == 2 then
					if not eq.tier18_4pc or buff.premonition then
						if getDistance("player","target") >= 28 and getDistance("player","target") >= 11 then
							if self.castCascade("target") then return end
						end
					end
				end
													
				-- actions.cop_insanity+=/mind_flay,if=t18_class_trinket&(target.debuff.mental_fatigue.remains<gcd|(cooldown.mind_blast.remains<2*gcd&target.debuff.mental_fatigue.remains<2*gcd)),interrupt_if=target.debuff.mental_fatigue.remains>gcd
				if eq.t18_classTrinket then
					if getDebuffRemain("target",spell.mental_fatigue,"player") > 0 then
						if getDebuffRemain("target",spell.mental_fatigue,"player") < gcd or (cd.mind_blast < 2*gcd and getDebuffRemain("target",spell.mental_fatigue,"player") < 2*gcd) then
							if self.castMindFlay("target") then return end
						end
					end
				end
				
				-- actions.cop_insanity+=/mind_sear,if=active_enemies>=8,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1),target_if=max:spell_targets.mind_sear_tick
				
				-- actions.cop_insanity+=/mind_flay,if=t18_class_trinket&target.debuff.mental_fatigue.stack<5
				if eq.t18_classTrinket then
					if getDebuffStacks("target",spell.mental_fatigue,"player") < 5 then
						if self.castMindFlay("target") then return end
					end
				end
				
				-- actions.cop_insanity+=/mind_spike
				if self.castMindSpike("target") then return end
			end
		end -- CoP rotation
	end
end
