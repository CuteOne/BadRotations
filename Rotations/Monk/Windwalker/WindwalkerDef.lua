if select(2, UnitClass("player")) == "MONK" then
    function cWindwalker:WindwalkerDef()

-- if select(3, UnitClass("player")) == 10 then
-- 	function WindwalkerMonk()
		if currentConfig ~= "Windwalker Defmaster" then
			MonkWwToggles()
			-- MonkWwOptions()

			if not (core and core.profile == "Windwalker") then
			  MonkWwFunctions()
			end

			core:ooc()
			core:update()
			currentConfig = "Windwalker Defmaster";
		end

        --SEF Key Toggle
        if SEFTimer == nil then SEFTimer = 0; end
        if SpecificToggle("SEF Mode") --[[and not GetCurrentKeyBoardFocus()]] and GetTime() - SEFTimer > 0.25 then
            SEFTimer = GetTime()
            UpdateButton("SEF")
        end

		--ChatOverlay(GetCurrentKeyBoardFocus())


		-- Manual Input
		-- PAUSE
		if SpecificToggle("Pause Mode") then -- Pause the script, keybind in wow shift+1 etc for manual cast
            ChatOverlay("PAUSE", 1)
			return true
		end

		-- Food/Invis Check
		if canRun() ~= true then
			return false
		end

		--------------
		--- Locals ---
		--------------
		local buff,cd,mode,talent,glyph = core.buff,core.cd,core.mode,core.talent,core.glyph
		local chi,chiMax,chiDiff,stacks,recharge,charges = core.chi,core.chiMax,core.chiDiff,core.stacks,core.recharge,core.charges
		local debuffRisingSunKick,channel = 130320,core.channel

		if tigereyeBrewCast == nil then tigereyeBrewCast = 0; end

		if UnitAffectingCombat("player") then
			core:update()
		else
			core:ooc()
		end

		-- Track Tigereyebrew Damage Buff 
		if tigereyeBrewCast ~= 0 then
			tigereyeBrewRemain = tigereyeBrewCast - GetTime()
		else
			tigereyeBrewRemain = 0
		end

		-----------------
		--- OOC Stuff ---
		-----------------
		if not core.inCombat  then
			-- Surging Mist
			--if isChecked(getOption(_SurgingMist)) and php<=getValue(getOption(_SurgingMist)) and not isInCombat("player") and power>=30 and not isMoving("player") then
			--	if castSpell("player",_SurgingMist,true,false) then 
			--		return 
			--	end
			--end

			-- Cast Buff
			-- TODO: cast buff
		end

		-- Combat
		if core.inCombat then
			-- dont interrupt channel
			if getCastTimeRemain("player") > 0 then
				return
			end
			--- Defensives


			-- actions=auto_attack
			if isInMelee() and getFacing("player","target") == true then
				RunMacroText("/startattack")
			end

			-- Track Tigereyebrew Damage Buff
			if tigereyeBrewCast ~= 0 then
				if tigereyeBrewCast <= GetTime() then
					tigereyeBrewCast = 0
				end
			end

			-- actions+=/invoke_xuen
			if core:castInvokeXuen() then
				return
			end

			-- actions+=/storm_earth_and_fire,target=2,if=debuff.storm_earth_and_fire_target.down
			-- actions+=/storm_earth_and_fire,target=3,if=debuff.storm_earth_and_fire_target.down
			if mode.sef == 1 then -- Check for toggle
				if GetObjectExists(core.units.dyn40AoE) then
					local sefEnemies = getEnemies("player",40)
					if #sefEnemies>1 then
						for i=1, #sefEnemies do
							local sefTarget = sefEnemies[i]
							local sefGUID = UnitGUID(sefTarget)
							local tarGUID = UnitGUID("target")
							local sefed = UnitDebuffID(sefTarget,core.spell.stormEarthFireDebuff,"player")~=nil
							if not sefed and sefGUID~=tarGUID and stacks.stormEarthFire<2 and isInCombat(sefTarget) then
								if castSpell(sefTarget,core.spell.stormEarthFire,true,false,false) then sefTarget1 = sefTarget; return end
							elseif sefed and sefGUID==tarGUID then
								CancelUnitBuff("player", GetSpellInfo(core.spell.stormEarthFire))
							end
						end
					elseif stacks.stormEarthFire>0 and #sefEnemies==1 then
						CancelUnitBuff("player", GetSpellInfo(core.spell.stormEarthFire))
					end
				end
			else
				-- Always remove SEF on current target
				if (UnitDebuffID("target", core.spell.stormEarthFireDebuff, "player")) then
					CancelUnitBuff("player", GetSpellInfo(core.spell.stormEarthFire))
				end
			end

			-- actions+=/potion,name=draenic_agility,if=buff.serenity.up|(!talent.serenity.enabled&(trinket.proc.agility.react|trinket.proc.multistrike.react))|buff.bloodlust.react|target.time_to_die<=60
			-- TODO: DPS Potion
			if (isChecked("Agi-Pot") and isBoss()) then
				if (buff.serenity > 0 or hasBloodLust() or getTimeToDie("target") <= 60) then
					if useItem(109217) then
						return
					end
				end
			end

			-- actions+=/call_action_list,name=opener,if=talent.serenity.enabled&talent.chi_brew.enabled&cooldown.fists_of_fury.up&time<20
			if (talent.serenity and talent.chiBrew and cd.fistsOfFury > 0 and getCombatTime() < 20) then
				if rotationOpener() then
					return
				end
			end

			-- actions+=/blood_fury,if=buff.tigereye_brew_use.up|target.time_to_die<18
			-- actions+=/berserking,if=buff.tigereye_brew_use.up|target.time_to_die<18
			-- actions+=/arcane_torrent,if=chi.max-chi>=1&(buff.tigereye_brew_use.up|target.time_to_die<18)
			-- TODO: Racial

			-- actions+=/chi_brew,if=chi.max-chi>=2&((charges=1&recharge_time<=10)|charges=2|target.time_to_die<charges*10)&buff.tigereye_brew.stack<=16
			if (chiMax-chi >= 2 and ((charges.chiBrew == 1 and recharge.chiBrew <= 10) or charges.chiBrew == 2 or getTimeToDie("target") < charges.chiBrew*10) and stacks.tigereyeBrewStacks <= 16) then
				if core:castChiBrew() then
					return
				end
			end

			-- actions+=/tiger_palm,if=!talent.chi_explosion.enabled&buff.tiger_power.remains<6.6
			if (not talent.chiExplosion and buff.tigerPower < 6.6) then
				if core:castTigerPalm() then
					return
				end
			end

			-- actions+=/tiger_palm,if=talent.chi_explosion.enabled&(cooldown.fists_of_fury.remains<5|cooldown.fists_of_fury.up)&buff.tiger_power.remains<5
			if (talent.chiExplosion and (cd.fistsOfFury < 5 or cd.fistsOfFury == 0) and buff.tigerPower < 5) then
				if core:castTigerPalm() then
					return
				end
			end

			-- actions+=/tigereye_brew,if=buff.tigereye_brew_use.down& buff.tigereye_brew.stack=20
			-- actions+=/tigereye_brew,if=buff.tigereye_brew_use.down& buff.tigereye_brew.stack>=9&buff.serenity.up
			-- actions+=/tigereye_brew,if=buff.tigereye_brew_use.down& buff.tigereye_brew.stack>=9&cooldown.fists_of_fury.up&chi>=3&debuff.rising_sun_kick.up&buff.tiger_power.up
			-- actions+=/tigereye_brew,if=buff.tigereye_brew_use.down& talent.hurricane_strike.enabled&buff.tigereye_brew.stack>=9&cooldown.hurricane_strike.up&chi>=3&debuff.rising_sun_kick.up&buff.tiger_power.up
			-- actions+=/tigereye_brew,if=buff.tigereye_brew_use.down& chi>=2&(buff.tigereye_brew.stack>=16|target.time_to_die<40)&debuff.rising_sun_kick.up&buff.tiger_power.up
			if (tigereyeBrewRemain == 0) then 
				if (stacks.tigereyeBrewStacks == 20) 
					or (stacks.tigereyeBrewStacks >= 9 and buff.serenity > 0)
					or (stacks.tigereyeBrewStacks >= 9 and cd.fistsOfFury == 0  and chi >= 3 and getDebuffDuration("target",debuffRisingSunKick) > 0 and buff.tigerPower > 0 )
					or (stacks.tigereyeBrewStacks >= 9 and talent.hurricaneStrike and cd.hurricaneStrike == 0 and chi >= 3 and getDebuffDuration("target",debuffRisingSunKick) > 0 and buff.tigerPower > 0)
					or (chi >= 2 and (stacks.tigereyeBrewStacks >= 16 or getTimeToDie("target") < 40) and getDebuffDuration("target",debuffRisingSunKick) > 0 and buff.tigerPower > 0) 
					then
						if core:castTigereyeBrew() then
							tigereyeBrewCast = GetTime()+15;
							return
						end
				end
			end

			-- actions+=/rising_sun_kick,if=(debuff.rising_sun_kick.down|debuff.rising_sun_kick.remains<3)
			if (getDebuffDuration("target",debuffRisingSunKick) == 0 or getDebuffDuration("target",debuffRisingSunKick) < 3) then
				if core:castRisingSunKick() then
					return
				end
			end

			-- actions+=/serenity,if=chi>=2&buff.tiger_power.up&debuff.rising_sun_kick.up
			if (chi >= 2 and getDebuffDuration("target",debuffRisingSunKick) > 0 and buff.tigerPower > 0) then
				if core:castSerenity() then
					return
				end
			end

			-- actions+=/fists_of_fury,if=buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&energy.time_to_max>cast_time&!buff.serenity.up
			if (buff.tigerPower > channel.fistsOfFury and getDebuffDuration("target",debuffRisingSunKick) > channel.fistsOfFury and core.energyTimeToMax > channel.fistsOfFury and buff.serenity == 0) then
				if core:castFistsOfFury() then
					return
				end
			end

			-- actions+=/fortifying_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&(glyph.touch_of_death.enabled|chi>=3)
			if (getHP(core.units.dyn5) < 10 and isAlive(core.units.dyn5) and cd.touchOfDeath == 0 and (glyph.touchOfDeath or chi >= 3)) then
				core:castFortifyingBrew()
			end

			-- actions+=/touch_of_death,if=target.health.percent<10&(glyph.touch_of_death.enabled|chi>=3)
			if (getHP(core.units.dyn5) < 10 and (glyph.touchOfDeath or chi >= 3)) then
				if core:castTouchOfDeath() then
					return
				end
			end

			-- actions+=/hurricane_strike,if=energy.time_to_max>cast_time&buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&buff.energizing_brew.down
			if (core.energyTimeToMax > channel.hurricaneStrike and buff.tigerPower > channel.hurricaneStrike and getDebuffDuration("target",debuffRisingSunKick) > channel.hurricaneStrike and buff.energizingBrew == 0) then
				if core:castHurricaneStrike() then
					return
				end
			end

			-- actions+=/energizing_brew,if=cooldown.fists_of_fury.remains>6&(!talent.serenity.enabled|(!buff.serenity.remains&cooldown.serenity.remains>4))&energy+energy.regen<50
			if (cd.fistsOfFury > 6 and (not talent.serenity or (buff.serenity == 0 and cd.serenity > 4)) and (getPower("player")+getRegen("player")) < 50 ) then
				core:castEnergizingBrew()
			end

			-- actions+=/call_action_list,name=st,if=active_enemies<3&(level<100|!talent.chi_explosion.enabled)
			if (core.melee8Yards < 3 and not talent.chiExplosion) then
				if rotationSingleTarget() then
					return
				end
			end

			-- actions+=/call_action_list,name=st_chix,if=active_enemies=1&talent.chi_explosion.enabled
			if (core.melee8Yards <= 1 and talent.chiExplosion) then
				if rotationSingleTargetChiExplosion() then
					return
				end
			end

			-- actions+=/call_action_list,name=cleave_chix,if=(active_enemies=2|active_enemies=3&!talent.rushing_jade_wind.enabled)&talent.chi_explosion.enabled
			if (talent.chiExplosion and (core.melee8Yards == 2 or (core.melee8Yards == 3 and not talent.rushingJadeWind))) then
				if rotationCleaveChiExplosion() then
					return
				end
			end

			-- actions+=/call_action_list,name=aoe_norjw,if=active_enemies>=3&!talent.rushing_jade_wind.enabled&!talent.chi_explosion.enabled
			if (core.melee8Yards >= 3 and not talent.rushingJadeWind and not talent.chiExplosion) then
				if rotationAoeNoRJW() then
					return
				end
			end

			-- actions+=/call_action_list,name=aoe_norjw_chix,if=active_enemies>=4&!talent.rushing_jade_wind.enabled&talent.chi_explosion.enabled
			if (core.melee8Yards >= 4 and not talent.rushingJadeWind and talent.chiExplosion) then
				if rotationAoeNoRJWChiExplosion() then
					return
				end
			end

			-- actions+=/call_action_list,name=aoe_rjw,if=active_enemies>=3&talent.rushing_jade_wind.enabled
			if (core.melee8Yards >= 3 and talent.rushingJadeWind) then
				if rotationAoeRJW() then
					return
				end
			end
		end -- Combat

		-----------------
		--- Rotations ---
		-----------------
		function rotationSingleTarget()
			-- actions.st=rising_sun_kick
			if core:castRisingSunKick() then
				return
			end

			-- actions.st+=/blackout_kick,if=buff.combo_breaker_bok.react|buff.serenity.up
			if (buff.comboBreakerBlackoutKick > 0 or buff.serenity > 0) then
				if core:castBlackoutKick() then
					return
				end
			end

			-- actions.st+=/tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
			if (buff.comboBreakerTigerPalm > 0 and buff.comboBreakerTigerPalm <= 2) then
				if core:castTigerPalm() then
					return
				end
			end

			-- actions.st+=/chi_wave,if=energy.time_to_max>2&buff.serenity.down
			if (talent.chiWave and core.energyTimeToMax > 2 and buff.serenity == 0) then
				if core:castChiWave() then
					return
				end
			end

			-- actions.st+=/chi_burst,if=energy.time_to_max>2&buff.serenity.down
			if (talent.chiBurst and core.energyTimeToMax > 2 and buff.serenity == 0) then
				if core:castChiBurst() then
					return
				end
			end

			-- actions.st+=/zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
			if (talent.zenSphere and core.energyTimeToMax > 2 and buff.serenity == 0) then
				if core:castZenSphere() then
					return
				end
			end

			-- Who is using chi torpedo as WW ?!
			-- actions.st+=/chi_torpedo,if=energy.time_to_max>2&buff.serenity.down

			-- actions.st+=/blackout_kick,if=chi.max-chi<2
			if (chiDiff < 2) then
				if core:castBlackoutKick() then
					return
				end
			end

			-- actions.st+=/expel_harm,if=chi.max-chi>=2&health.percent<95
			if (chiDiff >= 2 and core.health < 95) then
				if core:castExpelHarm() then
					return
				end
			end

			-- actions.st+=/jab,if=chi.max-chi>=2
			if (chiDiff >= 2) then
				if core:castJab() then
					return
				end
			end
		end
	
		function rotationSingleTargetChiExplosion()
			-- actions.st_chix=chi_explosion,if=chi>=2&buff.combo_breaker_ce.react&cooldown.fists_of_fury.remains>2
			if (chi >= 2 and buff.comboBreakerChiExplosion > 0 and cd.fistsOfFury > 2) then
				if core:castChiExplosion() then
					return
				end
			end

			-- actions.st_chix+=/tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
			if (buff.comboBreakerTigerPalm > 0 and buff.comboBreakerTigerPalm <= 2) then
				if core:castTigerPalm() then
					return
				end
			end

			-- actions.st_chix+=/rising_sun_kick
			if core:castRisingSunKick() then
				return
			end

			-- actions.st_chix+=/chi_wave,if=energy.time_to_max>2
			if (talent.chiWave and core.energyTimeToMax > 2) then
				if core:castChiWave() then
					return
				end
			end

			-- actions.st_chix+=/chi_burst,if=energy.time_to_max>2
			if (talent.chiBurst and core.energyTimeToMax > 2) then
				if core:castChiBurst() then
					return
				end
			end

			-- actions.st_chix+=/zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking
			if (talent.zenSphere and core.energyTimeToMax > 2) then
				if core:castZenSphere() then
					return
				end
			end

			-- actions.st_chix+=/tiger_palm,if=chi=4&!buff.combo_breaker_tp.react
			if (chi == 4 and not (buff.comboBreakerTigerPalm > 0)) then
				if core:castTigerPalm() then
					return
				end
			end

			-- actions.st_chix+=/chi_explosion,if=chi>=3&cooldown.fists_of_fury.remains>4
			if (chi >= 3 and cd.fistsOfFury > 4) then
				if core:castChiExplosion() then
					return
				end
			end

			-- actions.st_chix+=/chi_torpedo,if=energy.time_to_max>2

			-- actions.st_chix+=/expel_harm,if=chi.max-chi>=2&health.percent<95
			if (chiDiff >= 2 and core.health < 95) then
				if core:castExpelHarm() then
					return
				end
			end

			-- actions.st_chix+=/jab,if=chi.max-chi>=2
			if (chiDiff >= 2) then
				if core:castJab() then
					return
				end
			end
		end
	
		function rotationCleaveChiExplosion()
			-- actions.cleave_chix=chi_explosion,if=chi>=4&cooldown.fists_of_fury.remains>4
			if (chi >= 4 and cd.fistsOfFury > 4) then
				if core:castChiExplosion() then
					return
				end
			end

			-- actions.cleave_chix+=/tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
			if (buff.comboBreakerTigerPalm > 0 and buff.comboBreakerTigerPalm <= 2) then
				if core:castTigerPalm() then
					return
				end
			end

			-- actions.cleave_chix+=/chi_wave,if=energy.time_to_max>2
			if (talent.chiWave and core.energyTimeToMax > 2) then
				if core:castChiWave() then
					return
				end
			end

			-- actions.cleave_chix+=/chi_burst,if=energy.time_to_max>2
			if (talent.chiBurst and core.energyTimeToMax > 2) then
				if core:castChiBurst() then
					return
				end
			end

			-- actions.cleave_chix+=/zen_sphere,if=energy.time_to_max>2
			if (talent.zenSphere and core.energyTimeToMax > 2 and buff.zenSphere == 0) then
				if core:castZenSphere() then
					return
				end
			end

			-- actions.cleave_chix+=/chi_torpedo,if=energy.time_to_max>2

			-- actions.cleave_chix+=/expel_harm,if=chi.max-chi>=2&health.percent<95
			if (chiDiff >= 2 and core.health < 95) then
				if core:castExpelHarm() then
					return
				end
			end

			-- actions.cleave_chix+=/jab,if=chi.max-chi>=2
			if (chiDiff >= 2) then
				if core:castJab() then
					return
				end
			end
		end

		function rotationAoeNoRJW()
			-- actions.aoe_norjw=chi_wave,if=energy.time_to_max>2&buff.serenity.down
			if (talent.chiWave and core.energyTimeToMax > 2 and buff.serenity == 0) then
				if core:castChiWave() then
					return
				end
			end

			-- actions.aoe_norjw+=/chi_burst,if=energy.time_to_max>2&buff.serenity.down
			if (talent.chiBurst and core.energyTimeToMax > 2 and buff.serenity == 0) then
				if core:castChiBurst() then
					return
				end
			end

			-- actions.aoe_norjw+=/zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
			if (talent.zenSphere and core.energyTimeToMax > 2 and buff.serenity == 0) then
				if core:castZenSphere() then
					return
				end
			end

			-- actions.aoe_norjw+=/blackout_kick,if=buff.combo_breaker_bok.react|buff.serenity.up
			if (buff.comboBreakerBlackoutKick > 0 or buff.serenity > 0) then
				if core:castBlackoutKick() then
					return
				end
			end

			-- actions.aoe_norjw+=/tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
			if (buff.comboBreakerTigerPalm > 0 and buff.comboBreakerTigerPalm <= 2) then
				if core:castTigerPalm() then
					return
				end
			end

			-- actions.aoe_norjw+=/blackout_kick,if=chi.max-chi<2&cooldown.fists_of_fury.remains>3
			if (chiDiff < 2 and cd.fistsOfFury > 3) then
				if core:castBlackoutKick() then
					return
				end
			end

			-- actions.aoe_norjw+=/chi_torpedo,if=energy.time_to_max>2

			-- actions.aoe_norjw+=/spinning_crane_kick
			if core:castSpinningCraneKick() then
				return
			end
		end

		function rotationAoeNoRJWChiExplosion()
			-- actions.aoe_norjw_chix=chi_explosion,if=chi>=4&cooldown.fists_of_fury.remains>4
			if (chi >= 4 and cd.fistsOfFury > 4) then
				if core:castChiExplosion() then
					return
				end
			end

			-- actions.aoe_norjw_chix+=/rising_sun_kick,if=chi=chi.max
			if (chi == chiMax) then
				if core:castRisingSunKick() then
					return
				end
			end

			-- actions.aoe_norjw_chix+=/chi_wave,if=energy.time_to_max>2
			if (talent.chiWave and core.energyTimeToMax > 2) then
				if core:castChiWave() then
					return
				end
			end
			
			-- actions.aoe_norjw_chix+=/chi_burst,if=energy.time_to_max>2
			if (talent.chiBurst and core.energyTimeToMax > 2) then
				if core:castChiBurst() then
					return
				end
			end
			
			-- actions.aoe_norjw_chix+=/zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking
			if (talent.zenSphere and core.energyTimeToMax > 2) then
				if core:castZenSphere() then
					return
				end
			end
			
			-- actions.aoe_norjw_chix+=/chi_torpedo,if=energy.time_to_max>2

			-- actions.aoe_norjw_chix+=/spinning_crane_kick
			if core:castSpinningCraneKick() then
				return
			end
		end

		function rotationAoeRJW()
			-- actions.aoe_rjw=chi_explosion,if=chi>=4&cooldown.fists_of_fury.remains>4
			if (chi >= 4 and cd.fistsOfFury > 4) then
				if core:castChiExplosion() then
					return
				end
			end

			-- actions.aoe_rjw+=/rushing_jade_wind
			if core:castRushingJadeWind() then
				return
			end

			-- actions.aoe_rjw+=/chi_wave,if=energy.time_to_max>2&buff.serenity.down
			if (talent.chiWave and core.energyTimeToMax > 2 and buff.serenity == 0) then
				if core:castChiWave() then
					return
				end
			end
			
			-- actions.aoe_rjw+=/chi_burst,if=energy.time_to_max>2&buff.serenity.down
			if (talent.chiBurst and core.energyTimeToMax > 2 and buff.serenity == 0) then
				if core:castChiBurst() then
					return
				end
			end
			
			-- actions.aoe_rjw+=/zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
			if (talent.zenSphere and core.energyTimeToMax > 2 and buff.serenity == 0) then
				if core:castZenSphere() then
					return
				end
			end
			
			-- actions.aoe_rjw+=/blackout_kick,if=buff.combo_breaker_bok.react|buff.serenity.up
			if (buff.comboBreakerBlackoutKick > 0 or buff.serenity > 0) then
				if core:castBlackoutKick() then
					return
				end
			end
			
			-- actions.aoe_rjw+=/tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
			if (buff.comboBreakerTigerPalm > 0 and buff.comboBreakerTigerPalm <= 2) then
				if core:castTigerPalm() then
					return
				end
			end
			
			-- actions.aoe_rjw+=/blackout_kick,if=chi.max-chi<2&cooldown.fists_of_fury.remains>3
			if (chiDiff < 2 and cd.fistsOfFury > 3) then
				if core:castBlackoutKick() then
					return
				end
			end
			
			-- actions.aoe_rjw+=/chi_torpedo,if=energy.time_to_max>2

			
			-- actions.aoe_rjw+=/expel_harm,if=chi.max-chi>=2&health.percent<95
			if (chiDiff >= 2 and core.health < 95) then
				if core:castExpelHarm() then
					return
				end
			end
			
			-- actions.aoe_rjw+=/jab,if=chi.max-chi>=2
			if (chiDiff >= 2) then
				if core:castJab() then
					return
				end
			end
		end

		function rotationOpener()
			-- actions.opener=tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=9
			if (tigereyeBrewRemain == 0 and stacks.tigereyeBrewStacks >= 9) then
				if core:castTigereyeBrew() then
					tigereyeBrewCast = GetTime()+15;
					return
				end
			end

			-- actions.opener+=/blood_fury,if=buff.tigereye_brew_use.up
			-- actions.opener+=/berserking,if=buff.tigereye_brew_use.up
			-- actions.opener+=/arcane_torrent,if=buff.tigereye_brew_use.up&chi.max-chi>=1
			-- TODO: racial

			-- actions.opener+=/fists_of_fury,if=buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&buff.serenity.up&buff.serenity.remains<1.5
			if (buff.tigerPower > channel.fistsOfFury and getDebuffDuration("target",130320) > channel.fistsOfFury and buff.serenity > 0 and buff.serenity < 1.5) then
				if core:castFistsOfFury() then
					return
				end
			end

			-- actions.opener+=/tiger_palm,if=buff.tiger_power.remains<2
			if (buff.tigerPower < 2) then
				if core:castTigerPalm() then
					return
				end
			end
			
			-- actions.opener+=/rising_sun_kick
			if core:castRisingSunKick() then
				return
			end

			-- actions.opener+=/blackout_kick,if=chi.max-chi<=1&cooldown.chi_brew.up|buff.serenity.up
			if (chiDiff <= 1 and ((charges.chiBrew <= 0 and recharge.chiBrew > 0) or buff.serenity > 0)) then
				if core:castBlackoutKick() then
					return
				end
			end

			-- actions.opener+=/chi_brew,if=chi.max-chi>=2
			if (chiDiff >= 2) then
				if core:castChiBrew() then
					return
				end
			end

			-- actions.opener+=/serenity,if=chi.max-chi<=2
			if (chiDiff <= 2) then
				if core:castSerenity() then
					return
				end
			end

			-- actions.opener+=/jab,if=chi.max-chi>=2&!buff.serenity.up
			if (chiDiff >= 2 and buff.serenity == 0) then
				if core:castJab() then
					return
				end
			end
		end
	end -- function WindwalkerMonk()
end -- select(3, UnitClass("player")) == 10
