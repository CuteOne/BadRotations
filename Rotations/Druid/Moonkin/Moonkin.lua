if select(3, UnitClass("player")) == 11 then
	function DruidMoonkin()
		if currentConfig ~= "boomkin ragnar" then
			MoonkinToggles()
			MoonkinConfig()
			currentConfig = "boomkin ragnar"
		end

		spell = {
			-- casts
			moonfire = 8921,
			moonfireDebuff = 164812,
			sunfire = 93402,
			sunfireDebuff = 164815,
			starsurge = 78674,
			wrath = 5176,
			wrathCastTime = (select(4, GetSpellInfo(5176))/1000),
			starfire = 2912,
			starfireCastTime = (select(4, GetSpellInfo(2912))/1000),
			starfall = 48505,
			celestialAlignment = 112071,
			incarnation = 102560,
			barkskin = 22812,
			
			markOfTheWild = 1126,
			moonkinForm = 24858,
			
			rejuvenation = 774,
			healingTouch = 5185,

			--buffs
			lunarEmpowerment = 164547,
			solarEmpowerment = 164545,
			lunarPeak = 171743,
			solarPeak = 171744,
			}

		buff = {
			-- moonfire buff
			lunarPeak = {
				up = UnitBuffID("player",171743),
				remains = getBuffRemain("player",171743),
				cd = getSpellCD(171743),
				},
			-- sunfire buff
			solarPeak = {
				up = UnitBuffID("player",171744),
				remains = getBuffRemain("player",171744),
				cd = getSpellCD(171744),
				},
			-- starfire buff
			lunarEmpowerment = {
				up = UnitBuffID("player",164547),
				remains = getBuffRemain("player",164547),
				cd = getSpellCD(164547),
				},
			-- wrath buff
			solarEmpowerment = {
				up = UnitBuffID("player",164545),
				remains = getBuffRemain("player",164545),
				cd = getSpellCD(164545),
				},
			-- cooldown
			celestialAlignment = {
				up = UnitBuffID("player",112071),
				remains = getBuffRemain("player",112071),
				cd = getSpellCD(112071),
				},
			-- Incarnation
			incarnation = {
				up = UnitBuffID("player",102560),
				remains = getBuffRemain("player",102560),
				cd = getSpellCD(102560),
				},
			-- Celestial Alignment
			celestialAlignment = {
				up = UnitBuffID("player",112071),
				remains = getBuffRemain("player",112071),
				cd = getSpellCD(112071),
				},
			-- AoE
			starfall = {
				up = UnitBuffID("player",48505),
				remains = getBuffRemain("player",48505),
				cd = getSpellCD(48505),
				},
		}
		local debuff = {

		}

		player = {
			hp = getHP("player"),
			mana = getMana("player"),
			form = getDruidForm(),
			GCD = 1.5/(1+UnitSpellHaste("player")/100),
			buffs = {
				solarPeak = UnitBuffID("player",171744),
				lunarPeak = UnitBuffID("player",171743),
			},
		}

		eclipse = {
			energy = GetEclipseDirection(),
			energy = GetEclipseDirection(),
			direction =	GetEclipseDirection(),
			energy = UnitPower("player",8),
			timer = getEclipseTimer(),
			changeTimer = getEclipseChangeTimer(),
			timeTillLunarMax = lunar_max(),
			timeTillSolarMax = solar_max(),
		}

		if lastLunarReach then 
			eclipse.lastLunarReach = lastLunarReach
		end
		if lastSolarReach then
			eclipse.lastSolarReach = lastSolarReach
		end

		starsurge = {
			last = 0,
			charges = GetSpellCharges(spell.starsurge),
			rechargeTime = getRecharge(spell.starsurge),
		}

		talent = {
			felineSwiftness=131768, displacerBeast=102280, 		wildCharge=102401,
			yserasGift=145110, 		renewal=108238, 			cenarionWard=102351,
			fearieSwarm=102355, 	massEntanglement=102359, 	typhoon=132469,
			soulOfTheForest=114107, incarnation=102560, 		forceOfNature=33831,
			incapacitatingRoar=99, 	ursolsVortex=102793, 		mightyBash=5211,
			heartOfTheWild=108291, 	dreamOfCenarius=108373, 	naturesVigil=124974,
			euphoria=152222, 		stellarFlare=152221, 		balanceOfPower=125220,
		}

		options = {
			offensive = {
				isBoss = {check=isChecked("isBoss")},
				berserking = {check=isChecked("Berserking")},
				celestialAlignment = {check=isChecked("Celestial Alignment")},
				caWrath = {check=isChecked("CA: Wrath")},
				incarnation = {check=isChecked("Incarnation")},
				trinket1 = {check=isChecked("Trinket 1")},
				trinket2 = {check=isChecked("Trinket 2")},
			},
			defensive = {
				rejuvenation = {check=isChecked("Rejuvenation"),value=getValue("Rejuvenation")},
				healingTouch = {check=isChecked("Healing Touch"),value=getValue("Healing Touch")},
				naturesVigil = {check=isChecked("Natures Vigil")},
				healingTonic = {check=isChecked("Healing Tonic"),value=getValue("Healing Tonic")},
			},
			boss = {},
			multitarget = {
				--sortByHPabs = {check=isChecked("sortByHPabs")},
				minHP = {value=getValue("Min Health")*1000000},
				maxTargets = {value=getValue("Max Targets")},
				starfallCharges = {check=isChecked("Starfall Charges"),value=getValue("Starfall Charges")},
			},
			utilities = {
				pauseToggle = {check=isChecked("Pause Toggle")},
				MotW = {check=isChecked("MotW")},
				boomkinForm = {check=isChecked("Boomkin Form")},
			}
		}

		toggles = {
			defensive = 	BadBoy_data['Defensive'],
			multidot = 		BadBoy_data['DoT'],
			bossHelper = 	BadBoy_data['BossHeler'],
			cooldowns = 	BadBoy_data['Cooldowns'],
			starfall = 		BadBoy_data['Starfall'],
		}


		------------------------------------------------------------------------------------------------------
		-- Food/Invis Check ----------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if canRun() ~= true or UnitInVehicle("Player") then
			return false
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

		-- Sort enemiesTable by absolute HP
		--if options.multitarget.sortByHPabs.check then
			if enemiesTable then
				if enemiesTableTimer <= GetTime() - 0.5 then
					table.sort(enemiesTable, function(x,y)
						return x.hpabs and y.hpabs and x.hpabs > y.hpabs or false
					end)
				end
			end
		--end
		-- last Starsurge TBD - table creation -> delete the old value
		if UnitCastingInfo("player") == GetSpellInfo(_starsurge) then
			starsurge.last = GetTime()
		end



		-- eclipse table
			if eclipse.energy==(-100) and eclipse.direction=="moon" then
				lastLunarReach = GetTime()
			end
			if eclipse.energy==100 and eclipse.direction=="sun" then
				lastSolarReach = GetTime()
			end

			if eclipse.nextLunarReach then
				eclipse.nextLunarReach = eclipse.lastLunarReach + 20 - GetTime()
				eclipse.nextSolarReach = eclipse.nextSolarReach + 20 - GetTime()
			end


			-- TBD boomOpener()
		

		------------------------------------------------------------------------------------------------------
		-- Out of Combat -------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if not isInCombat("player") then
		end -- Out of Combat end
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
			-- Defensive -----------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------
			-- Offensive -----------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			if toggles.cooldowns==2 then
				if options.offensive.isBoss.check and isBoss()
				or not options.offensive.isBoss.check then
					-- Incarnation
					if castSpell("player",spell.incarnation) then return end
					-- Celestial Alignment
					if buff.incarnation.up then
						if select(2,GetSpellCooldown(61304))<=0.1 then 
							if castSpell("player",spell.celestialAlignment) then return end
						end
					end
				end
			end

			------------------------------------------------------------------------------------------------------
			-- Do everytime --------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------
			-- Rotation ------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

				------------------------------------------------------------------------------------------------------
				-- call always ---------------------------------------------------------------------------------------
				------------------------------------------------------------------------------------------------------

				-- boomkin form
				if not UnitBuffID("player",spell.moonkinForm) then
					if castSpell("player",spell.moonkinForm) then return end
				end

				-- actions=potion,name=draenic_intellect,if=buff.celestial_alignment.up
				-- actions+=/blood_fury,if=buff.celestial_alignment.up
				-- actions+=/berserking,if=buff.celestial_alignment.up
				-- actions+=/arcane_torrent,if=buff.celestial_alignment.up
				-- actions+=/force_of_nature,if=trinket.stat.intellect.up|charges=3|target.time_to_die<21
				-- actions+=/call_action_list,name=single_target,if=active_enemies=1
				-- actions+=/call_action_list,name=aoe,if=active_enemies>1

				-- if casting prevention
				if castingUnit("player") then return end
				------------------------------------------------------------------------------------------------------
				-- AoE -----------------------------------------------------------------------------------------------
				------------------------------------------------------------------------------------------------------
					-- if getNumEnemies("player",40)>=2 then 
					-- 	-- actions.aoe=celestial_alignment,if=lunar_max<8|target.time_to_die<20
					-- 	if toggles.cooldowns==2 then
					-- 		if eclipse.timeTillLunarMax<8 then
					-- 			if castSpell("player",spell.celestialAlignment) then return end
					-- 		end
					-- 	end

					-- 	-- actions.aoe+=/incarnation,if=buff.celestial_alignment.up
					-- 	if toggles.cooldowns==2 then
					-- 		if buff.celestialAlignment.up then
					-- 			if castSpell("player",spell.incarnation) then return end
					-- 		end
					-- 	end

					-- 	-- actions.aoe+=/sunfire,cycle_targets=1,if=remains<8
					-- 	if throwSunfire(options.multitarget.maxTargets.value,options.multitarget.minHP.value) then return end

					-- 	-- actions.aoe+=/starfall,if=!buff.starfall.up&active_enemies>2
					-- 	if toggles.starfall == 2 then
					-- 		if getNumEnemies("player",40)>2 and not buff.starfall.up then
					-- 			if castSpell("player",spell.starfall) then return end
					-- 		end
					-- 	end

					-- 	-- actions.aoe+=/starsurge,if=(charges=2&recharge_time<6)|charges=3
					-- 	if starsurge.charges==2 and starsurge.rechargeTime<6
					-- 	or starsurge.charges==3 then
					-- 		if castSpell("target",spell.starsurge,false,false) then return end
					-- 	end

					-- 	-- actions.aoe+=/moonfire,cycle_targets=1,if=remains<12
					-- 	if throwMoonfire(options.multitarget.maxTargets.value,options.multitarget.minHP.value) then return end

					-- 	-- actions.aoe+=/stellar_flare,cycle_targets=1,if=remains<7
						
					-- 	-- actions.aoe+=/starsurge,if=buff.lunar_empowerment.down&eclipse_energy>20&active_enemies=2
					-- 	if getNumEnemies("player",40)>2 then
					-- 		if (not buff.lunarEmpowerment.up) and eclipse.energy>20 then
					-- 			if castSpell("target",spell.starsurge,false,false) then return end
					-- 		end
					-- 	end

					-- 	-- actions.aoe+=/starsurge,if=buff.solar_empowerment.down&eclipse_energy<-40&active_enemies=2
					-- 	if getNumEnemies("player",40)>2 then
					-- 		if (not buff.solarEmpowerment.up) and eclipse.energy<(-40) then
					-- 			if castSpell("target",spell.starsurge,false,false) then return end
					-- 		end
					-- 	end

					-- 	-- actions.aoe+=/wrath,if=(eclipse_energy<=0&eclipse_change>cast_time)|(eclipse_energy>0&cast_time>eclipse_change)
					-- 	if (eclipse.energy>0 and eclipse.direction=="sun")
					-- 		or (eclipse.energy<0 and eclipse.direction=="sun" and eclipse.timer<spell.wrathCastTime)
					-- 		or (eclipse.energy>0 and eclipse.direction=="moon" and eclipse.timer>spell.wrathCastTime) then
					-- 			if castSpell("target",spell.wrath,false,true) then return end
					-- 		end

					-- 	-- actions.aoe+=/starfire,if=(eclipse_energy>=0&eclipse_change>cast_time)|(eclipse_energy<0&cast_time>eclipse_change)
					-- 	if (eclipse.energy<0 and eclipse.direction=="moon")
					-- 		or (eclipse.energy>0 and eclipse.direction=="moon" and eclipse.timer<spell.starfireCastTime)
					-- 		or (eclipse.energy<0 and eclipse.direction=="sun" and eclipse.timer>spell.starfireCastTime) then
					-- 			if castSpell("target",spell.starfire,false,true) then return end
					-- 		end

					-- 	-- actions.aoe+=/wrath
					-- 	if castSpell("target",spell.wrath,false,true) then return end
					-- end

					
				------------------------------------------------------------------------------------------------------
				-- SingleTarget --------------------------------------------------------------------------------------
				------------------------------------------------------------------------------------------------------

					-- 0) refresh moon-/sunfire at the end of CA
					if buff.celestialAlignment.remains<2*player.GCD then
						if castSpell("target",spell.moonfire,false,false) then return end
					end

					-- 1) Starsurge if capped on charges and do not have Lunar Empowerment/Solar Empowerment up.
					if starsurge.charges == 3 then
						-- lunar side without lunar empowerment
						if (eclipse.energy<0 and buff.lunarEmpowerment.up==nil)
						-- solar side without solar empowerment
						or (eclipse.energy>0 and buff.solarEmpowerment.up==nil) then
							if castSpell("target",spell.starsurge,false,false) then return end
						end
					end						
					-- 2) Starfall if you're capped on charges and have Lunar Empowerment/Solar Empowerment up.
					if toggles.starfall==2 then
						if starsurge.charges == 3 then
							-- lunar side with lunar empowerment
							if (eclipse.energy<0 and buff.lunarEmpowerment.up)
							-- solar side with solar empowerment
							or (eclipse.energy>0 and buff.solarEmpowerment.up) then
								if castSpell("player",spell.starfall,true,false) then return end
							end
						end
					end

					-- 2b) Starfall AoE
					if toggles.starfall==2 then
						if shouldStarfall() then
							if getBuffRemain("player",spell.starfall)<=0 then
								if options.multitarget.starfallCharges.value >= starsurge.charges then
									if castSpell("player",spell.starfall,true,false) then return end
								end
							end
						end
					end

					-- 3) Refresh Sunfire with  Solar Peak if it will fall off before the next solar phase.
					if isSunfire() then
						if (getDebuffRemain("target",spell.sunfireDebuff,"player")<eclipse.timeTillSolarMax and UnitDebuffID("target",spell.sunfireDebuff,"player"))
						or (not UnitDebuffID("target",spell.sunfireDebuff,"player") and buff.solarPeak.up) then
							if castSpell("target",spell.moonfire,false,false) then return end
						end
					end

					-- 3b) Sunfire more targets
					-- if toggles.multidot==2 then
					-- 	if getSunfire() <= options.multitarget.maxTargets.value then
					-- 		if getSunfire() < #enemiesTable then
					-- 			if not UnitIsUnit("target",getBiggestUnitCluster(5)) then
					-- 				print("4a")
					-- 				if throwSunfireMax(options.multitarget.maxTargets.value) then return end
					-- 			else
					-- 				print("4b")
					-- 				if throwSunfire(options.multitarget.maxTargets.value,options.multitarget.minHP.value) then return end
					-- 			end
					-- 		end
					-- 	end
					-- end
					if toggles.multidot==2 then
						if throwSunfire(options.multitarget.maxTargets.value,options.multitarget.minHP.value) then return end
					end

					-- 4) Refresh Moonfire with Lunar Peak if it will fall off before the next lunar phase.
					if (getDebuffRemain("target",spell.moonfireDebuff,"player")<eclipse.timeTillLunarMax and UnitDebuffID("target",spell.moonfireDebuff,"player"))
					or (not UnitDebuffID("target",spell.moonfireDebuff,"player") and buff.lunarPeak.up) then
						if castSpell("target",spell.moonfire,false,false) then return end
					end

					-- 4b) Moonfire more targets
					if toggles.multidot==2 then
						if throwMoonfire(options.multitarget.maxTargets.value,options.multitarget.minHP.value) then return end
						if refreshMoonfire(options.multitarget.maxTargets.value,options.multitarget.minHP.value) then return end
					end

					-- 5) Starsurge if at two charges or shortly before reaching two charges and Lunar Empowerment/Solar Empowerment are down 
					--	  and you are not about to be in lunar phase with Celestial Alignment up.
					if starsurge.charges==2 or (starsurge.charges==1 and starsurge.rechargeTime<6) then
						-- lunar side with lunar empowerment
						if (eclipse.energy<0 and buff.lunarEmpowerment.up==nil)
						-- solar side with solar empowerment
						or (eclipse.energy>0 and buff.solarEmpowerment.up==nil) then
							if buff.celestialAlignment.up==nil and eclipse.energy>0 then
								if buff.celestialAlignment.cd>starsurge.rechargeTime then
									if castSpell("target",spell.starsurge,false,false) then return end
								end
							end
						end
					end
					
					-- 6) Starfall if at two charges or shortly before reaching two charges and Lunar Empowerment/Solar Empowerment are down 
					--    and you are not about to be in lunar phase with Celestial Alignment up. 
					--    and you are for some reason unable to cast  Starsurge.

					-- 7) Starsurge if Lunar Empowerment/Solar Empowerment are down 
					--    and you have a non-haste trinket proc 
					--    and you are not about to be in lunar phase with Celestial Alignment up.


					-- 8a) Starfire / Wrath with Celestial Alignment
					if buff.celestialAlignment.up then
						if options.offensive.caWrath.check then
							if castSpell("target",spell.wrath,false,true) then return end
						else
							if castSpell("target",spell.starfire,false,true) then return end
						end
					end

					-- 8b) Starfire / Wrath
					-- wrath
						if (eclipse.energy>0 and eclipse.direction=="sun")
						or (eclipse.energy<0 and eclipse.direction=="sun" and eclipse.timer<spell.starfireCastTime)
						or (eclipse.energy>0 and eclipse.direction=="moon" and eclipse.timer>spell.wrathCastTime) then
							if castSpell("target",spell.wrath,false,true) then return end
						end

					-- starfire
						if (eclipse.energy<0 and eclipse.direction=="moon")
						or (eclipse.energy>0 and eclipse.direction=="moon" and eclipse.timer<spell.starfireCastTime)
						or (eclipse.energy<0 and eclipse.direction=="sun" and eclipse.timer>spell.starfireCastTime) then
							if castSpell("target",spell.starfire,false,true) then return end
						end
				--[[																								]]
					-- -- actions.single_target=starsurge,if=buff.lunar_empowerment.down&eclipse_energy>20
					-- if (not buff.lunarEmpowerment.up) and eclipse.energy>20 then
					-- 	if castSpell("target",spell.starsurge,false,false) then return end
					-- end
					
					-- -- actions.single_target+=/starsurge,if=buff.solar_empowerment.down&eclipse_energy<-40
					-- if (not buff.solarEmpowerment.up) and eclipse.energy<(-40) then
					-- 	if castSpell("target",spell.starsurge,false,false) then return end
					-- end
					
					-- -- -- actions.single_target+=/starsurge,if=(charges=2&recharge_time<6)|charges=3
					-- if starsurge.charges==2 and starsurge.rechargeTime<6
					-- or starsurge.charges==3 then
					-- 	if castSpell("target",spell.starsurge,false,false) then return end
					-- end
					
					-- -- actions.single_target+=/celestial_alignment,if=eclipse_energy>40
					-- if toggles.cooldowns==2 then
					-- 	if eclipse.energy>40 then
					-- 		if castSpell("player",spell.celestialAlignment) then return end
					-- 	end
					-- end
					
					-- -- actions.single_target+=/incarnation,if=eclipse_energy>0
					-- if toggles.cooldowns==2 then
					-- 	if eclipse.energy>0 then
					-- 		if castSpell("player",spell.incarnation) then return end
					-- 	end
					-- end
					
					-- -- actions.single_target+=/sunfire,if=remains<7|(buff.solar_peak.up&!talent.balance_of_power.enabled)
					-- if isSunfire() then
					-- 	if getDebuffRemain("target",spell.sunfireDebuff,"player")<7
					-- 	or (buff.solarPeak.up and not getTalent(7,3)) then
					-- 		if castSpell("target",spell.moonfire,false,false) then return end
					-- 	end
					-- end
					
					-- -- actions.single_target+=/stellar_flare,if=remains<7
					-- if getTalent(7,2) then
					-- 	if getDebuffRemain("target",talent.stellarFlare,"player")<7 then
					-- 		if castSpell("target",talent.stellarFlare,false,true) then return end
					-- 	end
					-- end
					
					-- -- actions.single_target+=/moonfire,if=!talent.balance_of_power.enabled&(buff.lunar_peak.up&remains<eclipse_change+20|remains<4|(buff.celestial_alignment.up&buff.celestial_alignment.remains<=2&remains<eclipse_change+20))
					-- if not getTalent(7,3) then
					-- 	if buff.lunarPeak.up and buff.lunarPeak.remains<eclipse.changeTimer+20
					-- 	or getDebuffRemain("target",spell.moonfireDebuff,"player")<4
					-- 	or (buff.celestialAlignment.up and buff.celestialAlignment.remains<=2 and getDebuffRemain("target",spell.moonfireDebuff,"player")<eclipse.changeTimer+20) then
					-- 		if castSpell("target",spell.moonfire,false,false) then return end
					-- 	end
					-- end

					-- -- actions.single_target+=/moonfire,if=talent.balance_of_power.enabled&(remains<4|(buff.celestial_alignment.up&buff.celestial_alignment.remains<=2&remains<eclipse_change+20))
					-- if getTalent(7,3) then
					-- 	if getDebuffRemain("target",spell.moonfireDebuff,"player")<4
					-- 	or (buff.celestialAlignment.up and buff.celestialAlignment.remains<=2 and getDebuffRemain("target",spell.moonfireDebuff,"player")<eclipse.changeTimer+20) then
					-- 		if castSpell("target",spell.moonfire,false,false) then return end
					-- 	end
					-- end

					-- -- wrath
					-- if (eclipse.energy>0 and eclipse.direction=="sun")
					-- or (eclipse.energy<0 and eclipse.direction=="sun" and eclipse.timer<spell.wrathCastTime)
					-- or (eclipse.energy>0 and eclipse.direction=="moon" and eclipse.timer>spell.wrathCastTime) then
					-- 	if castSpell("target",spell.wrath,false,true) then return end
					-- end

					-- -- starfire
					-- if (eclipse.energy<0 and eclipse.direction=="moon")
					-- or (eclipse.energy>0 and eclipse.direction=="moon" and eclipse.timer<spell.starfireCastTime)
					-- or (eclipse.energy<0 and eclipse.direction=="sun" and eclipse.timer>spell.starfireCastTime) then
					-- 	if castSpell("target",spell.starfire,false,true) then return end
					-- end

					-- -- actions.single_target+=/wrath
					-- if castSpell("target",spell.wrath,false,true) then return end
				


		end -- In Combat end
	end -- DruidMoonkin()
end --select class end




