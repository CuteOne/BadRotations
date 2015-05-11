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
			sunfireDebuff = 164815,
			sunfire = 93402,
			starsurge = 78674,
			wrath = 5176,
			starfire = 2912,
			starfireCastTime = (select(4, GetSpellInfo(2912))/1000),
			wrathCastTime = (select(4, GetSpellInfo(5176))/1000),
			celestialAlignment = 112071,
			incarnation = 102560,
			barkskin = 22812,
			healingTouch = 5185,
			markOfTheWild = 1126,
			moonkinForm = 24858,
			rejuvenation = 774,

			--buffs
			lunarEmpowerment = 164547,
			solarEmpowerment = 164545,
			lunarPeak = 171743,
			solarPeak = 171744,
			}

		buff = {
			lunarPeak = {
				up = UnitBuffID("player",171743),
				remains = getBuffRemain("player",171743),
				cd = getSpellCD(171743),
				},
			solarPeak = {
				up = UnitBuffID("player",171744),
				remains = getBuffRemain("player",171744),
				cd = getSpellCD(171744),
				},
			lunarEmpowerment = {
				up = UnitBuffID("player",164547),
				remains = getBuffRemain("player",164547),
				cd = getSpellCD(164547),
				},
			solarEmpowerment = {
				up = UnitBuffID("player",164545),
				remains = getBuffRemain("player",164545),
				cd = getSpellCD(164545),
				},
			
			celestialAlignment = {
				up = UnitBuffID("player",112071),
				remains = getBuffRemain("player",112071),
				cd = getSpellCD(112071),
				},
			incarnation = {
				up = UnitBuffID("player",102560),
				remains = getBuffRemain("player",102560),
				cd = getSpellCD(102560),
				},
		}
		local debuff = {

		}

		player = {
			hp = getHP("player"),
			mana = getMana("player"),
			form = getDruidForm(),
			buffs = {
				solarPeak = UnitBuffID("player",171744),
				lunarPeak = UnitBuffID("player",171743),
			},
		}

		eclipse = {
			direction = GetEclipseDirection(),
			energy = UnitPower("player",8),
			timer = getEclipseTimer(),
			changeTimer = getEclipseTimer2(),
		}

		starsurge = {
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
			-- TBD Raidbuff
			-- TBD autoBoomkin
			
			-- TBD boomOpener()
		------------------------------------------------------------------------------------------------------
		-- Out of Combat -------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if not isInCombat("player") then
		end -- Out of Combat end
		------------------------------------------------------------------------------------------------------
		-- In Combat -----------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if isInCombat("player") then

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
			-- Defensive Cooldowns -------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------
			-- Offensive Cooldowns -------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------
			-- Do everytime --------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------
			-- Rotation ------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
				
				------------------------------------------------------------------------------------------------------
				-- call always --------------------------------------------------------------------------------------
				------------------------------------------------------------------------------------------------------
				-- actions=potion,name=draenic_intellect,if=buff.celestial_alignment.up
				-- actions+=/blood_fury,if=buff.celestial_alignment.up
				-- actions+=/berserking,if=buff.celestial_alignment.up
				-- actions+=/arcane_torrent,if=buff.celestial_alignment.up
				-- actions+=/force_of_nature,if=trinket.stat.intellect.up|charges=3|target.time_to_die<21
				-- actions+=/call_action_list,name=single_target,if=active_enemies=1
				-- actions+=/call_action_list,name=aoe,if=active_enemies>1

				------------------------------------------------------------------------------------------------------
				-- AoE --------------------------------------------------------------------------------------
				------------------------------------------------------------------------------------------------------
				-- actions.aoe=celestial_alignment,if=lunar_max<8|target.time_to_die<20
				-- actions.aoe+=/incarnation,if=buff.celestial_alignment.up
				-- actions.aoe+=/sunfire,cycle_targets=1,if=remains<8
				-- actions.aoe+=/starfall,if=!buff.starfall.up&active_enemies>2
				-- actions.aoe+=/starsurge,if=(charges=2&recharge_time<6)|charges=3
				-- actions.aoe+=/moonfire,cycle_targets=1,if=remains<12
				-- actions.aoe+=/stellar_flare,cycle_targets=1,if=remains<7
				-- actions.aoe+=/starsurge,if=buff.lunar_empowerment.down&eclipse_energy>20&active_enemies=2
				-- actions.aoe+=/starsurge,if=buff.solar_empowerment.down&eclipse_energy<-40&active_enemies=2
				-- actions.aoe+=/wrath,if=(eclipse_energy<=0&eclipse_change>cast_time)|(eclipse_energy>0&cast_time>eclipse_change)
				-- actions.aoe+=/starfire,if=(eclipse_energy>=0&eclipse_change>cast_time)|(eclipse_energy<0&cast_time>eclipse_change)
				-- actions.aoe+=/wrath

					
				------------------------------------------------------------------------------------------------------
				-- SingleTarget --------------------------------------------------------------------------------------
				------------------------------------------------------------------------------------------------------
				-- actions.single_target=starsurge,if=buff.lunar_empowerment.down&eclipse_energy>20
				if (not buff.lunarEmpowerment.up) and eclipse.energy>20 then
					if castSpell("target",spell.starsurge,false,false) then return end
				end
				
				-- actions.single_target+=/starsurge,if=buff.solar_empowerment.down&eclipse_energy<-40
				if (not buff.solarEmpowerment.up) and eclipse.energy<(-40) then
					if castSpell("target",spell.starsurge,false,false) then return end
				end
				
				-- -- actions.single_target+=/starsurge,if=(charges=2&recharge_time<6)|charges=3
				if starsurge.charges==2 and starsurge.rechargeTime<6
				or starsurge.charges==3 then
					if castSpell("target",spell.starsurge,false,false) then return end
				end
				
				-- -- actions.single_target+=/celestial_alignment,if=eclipse_energy>40
				-- if eclipse.energy>40 then
				-- 	if castSpell("player",spell.celestialAlignment) then return end
				-- end
				
				-- -- actions.single_target+=/incarnation,if=eclipse_energy>0
				-- if eclipse.energy>0 then
				-- 	if castSpell("player",spell.incarnation) then return end
				-- end
				
				-- actions.single_target+=/sunfire,if=remains<7|(buff.solar_peak.up&!talent.balance_of_power.enabled)
				if isSunfire() then
					if getDebuffRemain("target",spell.sunfireDebuff,"player")<7
					or (buff.solarPeak.up and not getTalent(7,3)) then
						if castSpell("target",spell.moonfire,false,false) then return end
					end
				end
				
				-- actions.single_target+=/stellar_flare,if=remains<7
				if getTalent(7,2) then
					if getDebuffRemain("target",talent.stellarFlare,"player")<7 then
						if castSpell("target",talent.stellarFlare,false,true) then return end
					end
				end
				
				-- actions.single_target+=/moonfire,if=!talent.balance_of_power.enabled&(buff.lunar_peak.up&remains<eclipse_change+20|remains<4|(buff.celestial_alignment.up&buff.celestial_alignment.remains<=2&remains<eclipse_change+20))
				if not getTalent(7,3) then
					if buff.lunarPeak.up and buff.lunarPeak.remains<eclipse.changeTimer+20
					or getDebuffRemain("target",spell.moonfireDebuff,"player")<4
					or (buff.celestialAlignment.up and buff.celestialAlignment.remains<=2 and getDebuffRemain("target",spell.moonfireDebuff,"player")<eclipse.changeTimer+20) then
						if castSpell("target",spell.moonfire,false,false) then return end
					end
				end

				-- actions.single_target+=/moonfire,if=talent.balance_of_power.enabled&(remains<4|(buff.celestial_alignment.up&buff.celestial_alignment.remains<=2&remains<eclipse_change+20))
				if getTalent(7,3) then
					if getDebuffRemain("target",spell.moonfireDebuff,"player")<4
					or (buff.celestialAlignment.up and buff.celestialAlignment.remains<=2 and getDebuffRemain("target",spell.moonfireDebuff,"player")<eclipse.changeTimer+20) then
						if castSpell("target",spell.moonfire,false,false) then return end
					end
				end

				-- actions.single_target+=/wrath,if=(eclipse_energy<=0&eclipse_change>cast_time)|(eclipse_energy>0&cast_time>eclipse_change)
				if (eclipse.energy<0 and eclipse.changeTimer>spell.wrathCastTime)
				or (eclipse.energy>0 and spell.wrathCastTime>eclipse.changeTimer) then
					if castSpell("target",spell.wrath,false,true) then return end
				end

				-- actions.single_target+=/starfire,if=(eclipse_energy>=0&eclipse_change>cast_time)|(eclipse_energy<0&cast_time>eclipse_change)
				if (eclipse.energy>0 and eclipse.changeTimer<spell.starfireCastTime) 
				or (eclipse.energy<0 and spell.starfireCastTime>eclipse.changeTimer) then
					if castSpell("target",spell.starfire,false,true) then return end
				end

				-- -- actions.single_target+=/wrath
				-- if castSpell("target",spell.wrath,false,true) then return end


		end -- In Combat end
	end -- DruidMoonkin()
end --select class end




