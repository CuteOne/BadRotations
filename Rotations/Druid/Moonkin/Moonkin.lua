if select(3, UnitClass("player")) == 11 then
function DruidMoonkin()
	if currentConfig ~= "Moonkin CodeMyLife" then
		MoonkinFunctions()
		MoonkinConfig()
		MoonkinToggles()
		currentConfig = "Moonkin CodeMyLife"
	end

	-- localising core functions stuff
	local buff,cd,mode,talent,glyph = core.buff,core.cd,core.mode,core.talent,core.glyph
	local eclipseEnergy = core.eclipseEnergy
	if UnitAffectingCombat("player") then
		core:update()
	else
		core:ooc()
	end

	core.debugEnabled = false
	-- Pause toggle
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then
		ChatOverlay("|cffFF0000BadBoy Paused", 0)
		return
	end
	-- Focus Toggle
	if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == 1 then
		RunMacroText("/focus mouseover")
	end

	if castingUnit() then
		return false
	end

	-- Rejuvenation
	if core:castRejuvenation() then
		return
	end

	-- Mark of the wild
	if isChecked("Mark Of The Wild") and core:castMarkOfTheWild() then
		return
	end

	if UnitAffectingCombat("player") == true and canRun() then


		-- actions.precombat+=/stellar_flare
		-- actions=potion,name=draenic_intellect,if=buff.celestial_alignment.up
		-- actions+=/blood_fury,if=buff.celestial_alignment.up
		-- actions+=/berserking,if=buff.celestial_alignment.up
		-- actions+=/arcane_torrent,if=buff.celestial_alignment.up
		-- actions+=/force_of_nature,if=trinket.stat.intellect.up|charges=3|target.time_to_die<21
		core:cooldowns()


		-- actions+=/call_action_list,name=single_target,if=active_enemies=1
		if core.mode.aoe == 1 or (core.mode.aoe == 3 and core.activeEnemies == 1) then
			if core.lastStarsurge < GetTime() - 2 and core.castingStarsurge < GetTime() - 0.5 then
				-- actions.single_target=starsurge,if=buff.lunar_empowerment.down&eclipse_energy>20
				if buff.lunarEmpowerment == 0 and
				  ((eclipseEnergy < 20 and core.eclipseDirection == "moon")
				  or (eclipseEnergy < -80 and core.eclipseDirection == "sun")) then
					if core:castStarsurge() then
						return
					end
				end
				-- actions.single_target+=/starsurge,if=buff.solar_empowerment.down&eclipse_energy<-40
				if buff.solarEmpowerment == 0 and
				  ((eclipseEnergy > -20 and core.eclipseDirection == "sun")
				  or (eclipseEnergy > 80 and core.eclipseDirection == "moon")) then
					if core:castStarsurge() then
						return
					end
				end
				-- actions.single_target+=/starsurge,if=(charges=2&recharge_time<6)|charges=3
				if (core.surgeStacks == 2 and core.surgeTime < 6) or core.surgeStacks == 3 then
					if core:castStarsurge() then
						return
					end
				end
			end
			-- actions.single_target+=/celestial_alignment,if=eclipse_energy>40
			if eclipseEnergy < -99 then
				if core:castCelestialAlignment() then
					return
				end
			end
			-- actions.single_target+=/incarnation,if=eclipse_energy>0
			if eclipseEnergy > 0 then
				if core:castIncarnation() then
					return
				end
			end
			-- actions.single_target+=/sunfire,if=remains<7|buff.solar_peak.up
			if buff.solarPeak > 0
			  or (getDebuffRemain(core.units.dyn40,core.spell.sunfire,"player") < 4 and core.eclipseEnergy < 50 and core.eclipseDirection == "sun") then
				if core:castSunfire() then
					return
				end
			end
			-- actions.single_target+=/stellar_flare,if=remains<7
			-- actions.single_target+=/moonfire,if=buff.lunar_peak.up&remains<eclipse_change+20|remains<4|(buff.celestial_alignment.up&buff.celestial_alignment.remains<=2&remains<eclipse_change+20)
			if buff.lunarPeak > 0
			  or (getDebuffRemain(core.units.dyn40,core.spell.moonfire,"player") < 4 and core.eclipseEnergy > -50 and core.eclipseDirection == "moon")
			  or (buff.celestialAlignment > 0 and buff.celestialAlignment <= 2 and getDebuffRemain(core.units.dyn40,core.spell.moonfire,"player") < 12) then
				if core:castMoonfire() then
					return
				end
			end
			if core:castFiller() then
				return
			end
		else
			-- actions+=/call_action_list,name=aoe,if=active_enemies>1
			-- actions.aoe=celestial_alignment,if=lunar_max<8|target.time_to_die<20
			if eclipseEnergy < -99 then
				if core:castCelestialAlignment() then
					return
				end
			end
			-- actions.aoe+=/incarnation,if=buff.celestial_alignment.up
			if buff.celestialAlignment > 0 then
				if core:castIncarnation() then
					return
				end
			end
			-- actions.aoe+=/sunfire,if=remains<8
			if buff.solarPeak > 0
			  or (getDebuffRemain(core.units.dyn40,core.spell.sunfire,"player") < 4 and core.eclipseEnergy < 50 and core.eclipseDirection == "sun") then
				if core:castSunfire() then
					return
				end
			end
			-- actions.aoe+=/starfall,if=!buff.starfall.up
			if buff.starfall == 0 then
				if core:castStarfall() then
					return
				end
			end
			-- actions.aoe+=/moonfire,cycle_targets=1,if=remains<12
			if core:castMultiMoonfire() then
				return
			end
			-- actions.aoe+=/stellar_flare,cycle_targets=1,if=remains<7
			-- actions.aoe+=/starsurge,if=(charges=2&recharge_time<6)|charges=3
			if core.surgeStacks == 3 or core.surgeStacks == 2 and core.surgeTime < 6 then
				if core:castStarsurge() then
					return
				end
			end
			-- actions.aoe+=/wrath,if=(eclipse_energy<=0&eclipse_change>cast_time)|(eclipse_energy>0&cast_time>eclipse_change)
			-- actions.aoe+=/starfire,if=(eclipse_energy>=0&eclipse_change>cast_time)|(eclipse_energy<0&cast_time>eclipse_change)
			if core:castFiller() then
				return
			end
		end
	end
end
end

--Todo



