-- ragnar T18 rotation
-- Last Update: 2015-06-25
if select(3, UnitClass("player")) == 5 and GetSpecialization() == 3 then

	function cShadow:shadowRagnar()
		-- Locals
		local player,orbs,health = "player",self.orbs,self.health
		local buff,cd,mode,talent,glyph,gcd = self.buff,self.cd,self.mode,self.talent,self.glyph,self.gcd
		local isChecked,enemies,units = isChecked,self.enemies,self.units
		local spell,options,set_bonus = self.spell,self.options,self.set_bonus
		local AS = self.AS
		local active_enemies_30, active_enemies_40 = self.enemies.active_enemies_30, self.enemies.active_enemies_40

		------------------------------------------------------------------------------------------------------
		-- Spell Queue ---------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------

		-- setup queue
		if _Queues == nil then
			_Queues = {
				[120644]  = false,		-- Halo
				[127632] = 	false,		-- Cascade
				[2944] = 	false,		-- Devouring Plague
				[34433] = 	false,		-- Shadowfiend
				[123040] = 	false,		-- Mindbender
			}
		end

		-- check queue vars
		if _Queues ~= nil then
			if _Queues[120644] ~= true then 		_Queues[120644]=false end
			if _Queues[127632] ~= true then 		_Queues[127632]=false end
			if _Queues[2944] ~= true then 			_Queues[2944]=false end
			if _Queues[34433] ~= true then 			_Queues[34433]=false end
			if _Queues[123040] ~= true then 		_Queues[123040]=false end
		end


		-- Check for queued spells
		if _Queues[120644] == true then
			ChatOverlay("Q - HALO")
			if self.castHalo() then return end
		end
		if _Queues[127632] == true then
			ChatOverlay("Q - CASCADE")
			if self.castCascadeAuto() then return end
		end
		if _Queues[2944] == true then
			if orbs < 3 then _Queues[2944] = false end
			ChatOverlay("Q - DP")
			if self.castDP("target") then return end
		end
		if _Queues[34433] == true or _Queues[123040] == true then
			if self.castShadowfiend("target") then return end
			if self.castMindbender("target") then return end
		end

		------------------------------------------------------------------------------------------------------
		-- Do everytime --------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		self.castAngelicFeatherOnMe()
		-- Pause toggle
		if options.utilities.pause.enabled and SpecificToggle("Pause Toggle") == true then
			ChatOverlay("|cffFF0000BadBoy Paused", 0) return
		end

		-- shadow form
		if not shadowform then
			if self.castShadowform() then return end
		end
		
		------------------------------------------------------------------------------------------------------
		-- Boss Helper ---------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		--self.BossHelperT17()
		self.BossHelperT18()

		------------------------------------------------------------------------------------------------------
		-- Defensive -----------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if mode.defensive == 2 then
			-- dispersion
			if options.defensive.dispersion.enabled then
				if health <= options.defensive.dispersion.value then
					if self.castDispersion() then return end
				end
			end
			-- desperate prayer
			if options.defensive.desperate_prayer.enabled then
				if health <= options.defensive.desperate_prayer.value then
					if self.castDesperatePrayer() then return end
				end
			end
			-- power word: shield
			if options.defensive.pws.enabled then
				if health <= options.defensive.pws.value then
					if self.castPWS("player") then return end
				end
			end
			-- healing tonic
			if options.defensive.healing_tonic.enabled then
				if health <= options.defensive.healing_tonic.value then
					if canUse(109223) then UseItemByName("Healing Tonic") return end
				end
			end
			-- fade aggro
			if options.defensive.fade_aggro.enabled then
				if IsInRaid() ~= false and getThreat()>=3 then
					if self.castFade() then return end
				end
			end
			-- fade glyph
			if options.defensive.fade_glyph.enabled then
				if glyph.fade then
					if health <= options.defensive.fade_glyph.value then
						if self.castFade() then return end
					end
				end
			end
		end

		------------------------------------------------------------------------------------------------------
		-- Offensive -----------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------------
		-- Special keys --------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if options.rotation.msi_key.enabled then
			if SpecificToggle("MSinsanity Key") then
				-- Mind Blast
				if options.rotation.msi_burst.enabled then
					if orbs <= 3 then
						if self.castMindBlast("target") then return end
					end
				end
				-- DP
				if select(1,UnitChannelInfo("player")) ~= "Searing Insanity" then
					if buff.insanity <= 0 then
						if self.castDP("target") then return end
					end
				end
				-- Clip it
				if buff.insanity > 0 and buff.insanity <= 2*gcd then
					if select(1,UnitChannelInfo("player")) ~= nil then
						local cEnd = select(6,UnitChannelInfo("player"))
						local cRem = cEnd - GetTime()*1000
						-- Clip it
						if cRem<666 then
							if self.castMindFlay("target") then return end
						end
					end
				end
				-- Searing Insanity
				if buff.insanity > 0 then
					if select(1,UnitChannelInfo("player")) ~= "Searing Insanity" then
						if self.castMindSear("target") then return end
					end
				end
			end
			if UnitChannelInfo("player") == "Searing Insanity" then
				return
			end
		end

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
				-- 10 spread DPx5 on SoD
				if orbs == 5 then
					if talent.surge_of_darkness or set_bonus.tier17_4pc then
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
				-- -- 20 spread DPx4 on SoD
				-- if orbs >= 4 then
				-- 	if talent.auspicious_spirits then
				-- 		if talent.surge_of_darkness then
				-- 			if getDebuffRemain("target",spell.devouring_plague,"player") == 0 then
				-- 				if castDP("target") then return end
				-- 			else
				-- 				for i=1,#enemiesTable do
				-- 					local thisUnit = enemiesTable[i].unit
				-- 					if getDebuffRemain(thisUnit,spell.devouring_plague,"player") <= 0 then
				-- 						if castDP(thisUnit) then return end
				-- 					end
				-- 				end
				-- 			end
				-- 		end
				-- 	end
				-- end
				-- 30 DPx5
				if orbs == 5 then
					if self.castDP("target") then return end
				end
				--40 dump for incoming spirits
				if orbs >= 3 then
					if talent.auspicious_spirits then
						if AS.flying >= 3 then
							if self.castDP("target") then return end
						end
					end
				end
				-- 50 dump for incoming spirits
				if orbs >= 4 then
					if talent.auspicious_spirits then
						if AS.flying >= 2 then
							if self.castDP("target") then return end
						end
					end
				end
				-- 60 extend mental instinct
				if orbs >= 3 then
					if buff.mental_instinct > 0 then
						if buff.mental_instinct < 2.5 then
							if self.castDP("target") then return end
						end
					end
				end
				-- 70 mindbender and t18_4pc
				if orbs >= 3 then
					if set_bonus.tier18_4pc then
						if talent.mindbender then
							if self.castDP("target") then return end
						end
					end
				end

			-- Mind Blast: Mind Harvest -- TBD

			-- Mind Blast
			if self.castMindBlast("target") then return end

			-- SWP cycle targets 7
			if self.castSWPAutoApply(7) then return end

			-- Insanity: extend mental fatigue
			if set_bonus.class_trinket then
				if buff.insanity > 0 then
					if getDebuffRemain("target",spell.mental_fatigue,"player") < gcd then
						if getDebuffRemain("target",spell.mental_fatigue,"player") > 0 then
							if self.castMindFlay("target") then return end
						end
					end
				end
			end

			-- Searing Insanity: Automode
				-- TBD

			-- Insanity
			if buff.insanity > 0 then
				if self.castMindFlay("target") then return end
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
						if self.castCascadeAuto() then return end
					end
				end
			end

			-- Vampiric Touch cycle targets 5
			if mode.multidot == 3 or mode.multidot == 4 then
				if self.castVTAutoApply(5) then return end
			end

			-- SoD proc
			if buff.surge_of_darkness > 0 then
				if buff.premonition > 0 then
					if self.castMindSpike("target",proc) then return end
				end
			end

			-- SoD proc
			if getBuffStacks("player",spell.surge_of_darkness) >= 3 then
				if self.castMindSpike("target",proc) then return end
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
						if self.castCascadeAuto() then return end
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
			-- 	if active_enemies_40 <= 1 then
			-- 		return
			-- 	end
			-- end

			-- SoD procs not T18_4pc
			if not set_bonus.tier18_4pc then
				if buff.surge_of_darkness > 0 then
					if self.castMindSpike("target",proc) then return end
				end
			end

			-- SoD procs with T18_4pc
			if set_bonus.tier18_4pc then
				if buff.surge_of_darkness > 0 then
					if buff.premonition > 0 or talent.mindbender then
						if self.castMindSpike("target",proc) then return end
					end
				end
			end

			-- SoD procs with T18_4pc
			if set_bonus.tier18_4pc then
				if buff.surge_of_darkness > 0 then
					if not talent.mindbender then
						if cd.shadowfiend > 13 then
							if buff.surge_of_darkness < (1.1*gcd*getBuffStacks("player",spell.surge_of_darkness)) then
								if self.castMindSpike("target",proc) then return end
							end
						end
					end
				end
			end

			-- Mind Flay
			if self.castMindFlay("target") then return end

			-- moving
			if IsMovingTime(0.3) then
				-- SWD
				if self.castSWDAuto("target",true) then return end
				-- PWS
				if talent.body_and_soul then
					if getDebuffRemain("player",6788) <= 0 then
						if self.castPWS("player") then return end
					end
				end
				-- SWP
				if self.castSWPAutoApply(10) then return end
			end
		end -- AS rotation
		--[[ clarity_of_power ]]
		if talent.clarity_of_power then

		end -- CoP rotation
	end
end
