if select(3, UnitClass("player")) == 2 then
	function PaladinRetribution()
	if currentConfig ~= "Retribution Paladin" and ret == nil then --Where is currentConfig set? Is this only used for init?
		PaladinRetToggles() -- Setting up Toggles, AoE, Interrupt, Defensive CD, CD, Healing
		PaladinRetOptions() -- Reading Config values from gui?
		---if not (core and core.profile == "Retribution") then
		--	PaladinRetFunctions()
		--end
		ret = cRetribution:new()
		setmetatable(ret, {__index = cRetribution})
		ret:updateOOC()
		ret:update()
		currentConfig = "Retribution Paladin"
	end

	-- ToDo add pause toggle
	-- Manual Input
	if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
		return true
	end
	if IsLeftControlKeyDown() then -- Pause the script, keybind in wow ctrl+1 etc for manual cast
		return true
	end
	if IsLeftAltKeyDown() then
		return true
	end

	if not UnitAffectingCombat("player") then
		ret:updateOOC()
	end
	ret:update()

	--[[
	-- Food/Invis Check
	if canRun() ~= true then
		return false
	end

	-- localising retCore functions stuff
	-- local with short names
	local buff,cd,mode,talent,glyph = core.buff,core.cd,core.mode,core.talent,core.glyph
	local holyPower = core.holyPower
	if UnitAffectingCombat("player") then
		core:update()
	else
		core:ooc()
	end

	-- Cast selected blessing or auto
	castBlessing()


	-- make sure we have a seal(often removed by changing talents/glyph)
	-- Default: Truth
	if core.seal == 0 then
		if core:castSeal(1) then
			return
		end
	end

	-- OFF-GCD here we add the spells we want to be spamming all the time
	if core.inCombat then
		-- Rebuke
		-- Currently interrupts not working
		--core:castRebuke()

		-- Divine Protection
		castDivineProtection()
	end

	-- GCD check -- it means we want off-gcd above
	if castingUnit() then
		return
	end

	-- Combats Starts Here
	if core.inCombat then
		-- Lay on Hands
		--castLayOnHands()
		-- Divine Shield
		if core:castDivineShield() then
			return
		end
		-- Selfless Healer
		if isChecked("Selfless Healer") and core:castSelfLessHealer() then
			return
		end
    -- Sacred Shield
    if isChecked("Sacred Shield") then
      if core:castSacredShield() then
        return
      end
    end
		-- Self Glory
		if isChecked("Self Glory") then
			core:castWordOfGlory()
		end
		--Always
		-- auto_attack
		if isInMelee() and getFacing("player","target") == true then
			RunMacroText("/startattack")
		end
		castCrowdControl("any",105593,20)
		-- execution_sentence
		if core:castExecutionSentence(core.units.dyn40) then
			return
		end
		-- lights_hammer
		if core:castLightsHammer() then
			return
		end
		-- Holy Avenger (off gcd)
		-- actions+=/holy_avenger,sync=seraphim,if=talent.seraphim.enabled
		-- actions+=/holy_avenger,if=holy_power<=2&!talent.seraphim.enabled
		if holyPower <= 2 then
			core:castHolyAvenger()
		end 
		-- Avenging Wrath (off gcd) (sync with SoK)
		-- actions+=/avenging_wrath,sync=seraphim,if=talent.seraphim.enabled
		-- actions+=/avenging_wrath,if=!talent.seraphim.enabled
		if core:castAvengingWrath() then
			core:castSoK()
		end
		-- holy_prism 2+
		if core:castHolyPrism(2) then
			return
		end
		-- Seraphim (off gcd) 
		-- actions+=/seraphim 
		core:castSeraphim()
		-- actions+=/wait,sec=cooldown.seraphim.remains,if=talent.seraphim.enabled&cooldown.seraphim.remains>0&cooldown.seraphim.remains<gcd.max&holy_power>=5
		if (talent.seraphim and cd.seraphim > 0 and cd.seraphim < cd.globalCooldown and holyPower == 5) then
			return
		end

		----------------
		-- Single 1-2 --
		----------------
		--actions+=/call_action_list,name=single
		if ((core.melee8Yards < 3 or (talent.finalVerdict and core.melee12Yards < 3))  and mode.aoe == 3) or mode.aoe == 1 then
			-- actions.single+=/divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&buff.final_verdict.up
			if (buff.divineCrusader > 0 and (holyPower == 5 or (buff.holyAvenger > 0 and holyPower >= 3)) and buff.finalVerdict > 0)
				-- actions.single+=/divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&active_enemies=2&!talent.final_verdict.enabled
				or (buff.divineCrusader > 0 and (holyPower == 5 or (buff.holyAvenger > 0 and holyPower >= 3)) and core.melee8Yards == 2 and not talent.finalVerdict)
				-- actions.single+=/divine_storm,if=(holy_power=5|buff.holy_avenger.up&holy_power>=3)&active_enemies=2&buff.final_verdict.up
				or ((holyPower == 5 or (buff.holyAvenger > 0 and holyPower >= 3)) and core.melee12Yards == 2 and buff.finalVerdict > 0)
				-- actions.single+=/divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&(talent.seraphim.enabled&cooldown.seraphim.remains<gcd*4)
				or (buff.divineCrusader > 0 and (holyPower == 5 or (buff.holyAvenger > 0 and holyPower >= 3)) and (talent.seraphim and cd.seraphim <= cd.globalCooldown*4)) then
					if core:castDivineStorm() then
						return
					end
			end
			-- actions.single+=/templars_verdict,if=(holy_power=5|buff.holy_avenger.up&holy_power>=3)&(buff.avenging_wrath.down|target.health.pct>35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)
			if ( (holyPower == 5 or (buff.holyAvenger > 0 and holyPower >= 3)) and (buff.avengingWrath == 0 or getHP(core.units.dyn5) > 35) and (not talent.seraphim or cd.seraphim > cd.globalCooldown*4) )
				-- actions.single+=/templars_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<3
				or (buff.divinePurpose > 0 and buff.divinePurpose < 3) then
					if core:castTemplarsVerdict() then
						return
					end
			end
			-- actions.single+=/divine_storm,if=buff.divine_crusader.react&buff.divine_crusader.remains<3& !talent.final_verdict.enabled
			-- actions.single+=/divine_storm,if=buff.divine_crusader.react&buff.divine_crusader.remains<3& buff.final_verdict.up
			if buff.divineCrusader > 0 and buff.divineCrusader < 3 and (not talent.finalVerdict or buff.finalVerdict > 0) then
				if core:castDivineStorm() then
					return
				end
			end
			-- actions.single+=/final_verdict
			if talent.finalVerdict
				-- actions.single+=/final_verdict,if=holy_power=5|buff.holy_avenger.up&holy_power>=3
				and (holyPower == 5 or (buff.holyAvenger > 0 and holyPower >= 3)
				-- actions.single+=/final_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<3
				or (buff.divinePurpose > 0 and buff.divinePurpose < 3)) then
					if core:castTemplarsVerdict() then
						return
					end
			end
			-- actions.single+=/hammer_of_wrath
			if core:castHammerOfWrath() then
				return
			end
			-- actions.single+=/judgment,if=talent.empowered_seals.enabled
			if talent.empoweredSeals then
				-- &seal.truth&buff.maraads_truth.remains<cooldown.judgment.duration
				if (core.seal == true and (buff.maraadsTruth < core.recharge.judgment or buff.maraadsTruth == 0))
				-- & seal.righteousness&buff.liadrins_righteousness.remains<cooldown.judgment.duration
				or (core.seal == false and (buff.liadrinsRighteousness < core.recharge.judgment or buff.liadrinsRighteousness == 0))
				-- &seal.righteousness&cooldown.avenging_wrath.remains<cooldown.judgment.duration
				or (core.seal == false and cd.avengingWrath < core.recharge.judgment) then
					if core:castJudgment() then
						return
					end
				end
			end
			-- actions.single+=/exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
			if buff.blazingContempt > 0 and holyPower <= 2 and buff.holyAvenger == 0 then
				if core:castExorcism() then
					return
				end
			end
			-- actions.single+=/seal_of_truth,if=talent.empowered_seals.enabled
			if talent.empoweredSeals then
				-- &buff.maraads_truth.down
				if (core.seal ~= true and buff.maraadsTruth == 0) 
					-- &cooldown.avenging_wrath.remains<cooldown.judgment.duration&buff.liadrins_righteousness.remains>cooldown.judgment.duration
					or (core.seal ~= true and cd.avengingWrath < core.recharge.judgment and buff.liadrinsRighteousness > core.recharge.judgment) then
						if core:castSeal(1) then
							return
						end
				-- actions.single+=/seal_of_righteousness &buff.maraads_truth.remains>cooldown.judgment.duration&buff.liadrins_righteousness.down&!buff.avenging_wrath.up&!buff.bloodlust.up
				elseif (core.seal == true and buff.maraadsTruth > core.recharge.judgment and buff.liadrinsRighteousness == 0 and buff.avengingWrath == 0 and not hasBloodLust()) then
					if core:castSeal(2) then
						return
					end
				end
			end
			-- actions.single+=/divine_storm,if=buff.divine_crusader.react 	&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
			-- actions.single+=/divine_storm,if=active_enemies=2			&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
			if (buff.divineCrusader > 0 or core.melee12Yards == 2) and buff.finalVerdict > 0 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) then
				if core:castDivineStorm() then
					return
				end
			end
			-- actions.single+=/final_verdict,if=buff.avenging_wrath.up|target.health.pct<35
			if talent.finalVerdict and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) then
				if core:castTemplarsVerdict() then
					return
				end
			end
			-- actions.single+=/divine_storm,if=buff.divine_crusader.react&active_enemies=2&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
			if buff.divineCrusader > 0 and core.melee8Yards == 2 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) and not talent.finalVerdict then
				if core:castDivineStorm() then
					return
				end
			end
			-- actions.single+=/templars_verdict,if=holy_power=5&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*3)
			if (holyPower == 5 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > cd.globalCooldown*3))
				-- actions.single+=/templars_verdict,if=holy_power=4&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)
				or (holyPower == 4 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > cd.globalCooldown*4))
				-- actions.single+=/templars_verdict,if=holy_power=3&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)
				or (holyPower == 3 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > cd.globalCooldown*5)) then
					if core:castTemplarsVerdict() then
						return
					end
			end
			-- actions.single+=/crusader_strike,if=holy_power<5&talent.seraphim.enabled
			if (holyPower < 5 and talent.seraphim) 
				-- actions.single+=/crusader_strike,if=holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down)
				or (holyPower <= 3 or (holyPower == 4 and buff.avengingWrath == 0 or getHP(core.units.dyn5) >= 35)) then
					if core:castCrusaderStrike() then
						return
					end
			end
			-- actions.single+=/divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
			if buff.divineCrusader > 0 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) and not talent.finalVerdict then
				if core:castDivineStorm() then
					return
				end
			end
			-- actions.single+=/judgment,cycle_targets=1,if=last_judgment_target!=target&glyph.double_jeopardy.enabled&holy_power<5
			if glyph.doubleJeopardy and holyPower < 5 then
				if core:castJeopardy() then
					return
				end
			end

			-- actions.single+=/exorcism,if=glyph.mass_exorcism.enabled&active_enemies>=2&holy_power<5&!glyph.double_jeopardy.enabled&!set_bonus.tier17_4pc=1
			-- TODO: update

			-- actions.single+=/judgment,if=holy_power<5&talent.seraphim.enabled
			if (holyPower < 5 and talent.seraphim) 
				-- actions.single+=/judgment,if=holy_power<=3|(holy_power=4&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down)
				or (holyPower <= 3 or (holyPower == 4 and cd.crusaderStrike >= cd.globalCooldown*2 and buff.avengingWrath == 0 or getHP(core.units.dyn5) > 35)) then
					if core:castJudgment() then
						return
					end
			end
			-- actions.single+=/divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
			if (buff.divineCrusader > 0 and buff.finalVerdict > 0) 
				-- actions.single+=/divine_storm,if=active_enemies=2&holy_power>=4&buff.final_verdict.up
				or (core.melee12Yards == 2 and holyPower >= 4 and buff.finalVerdict > 0) then
					if core:castDivineStorm() then
						return
					end
			end
			-- actions.single+=/final_verdict,if=buff.divine_purpose.react
			-- actions.single+=/final_verdict,if=holy_power>=4
			if talent.finalVerdict and (buff.divinePurpose > 0 or holyPower >= 4) then
				if core:castTemplarsVerdict() then
					return
				end
			end
			-- actions.single+=/divine_storm,if=buff.divine_crusader.react&active_enemies=2&holy_power>=4&!talent.final_verdict.enabled
			if (buff.divineCrusader > 0 and core.melee8Yards == 2 and holyPower >= 4 and not talent.finalVerdict) then
				if core:castDivineStorm() then
					return
				end
			end
			-- actions.single+=/templars_verdict,if=buff.divine_purpose.react
			if buff.divinePurpose > 0 then
				if core:castTemplarsVerdict() then
					return
				end
			end
			-- actions.single+=/divine_storm,if=buff.divine_crusader.react&!talent.final_verdict.enabled
			if buff.divineCrusader > 0 and not talent.finalVerdict then
				if core:castDivineStorm() then
					return
				end
			end
			-- actions.single+=/templars_verdict,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)
			if holyPower >= 4 and (not talent.seraphim or cd.seraphim > cd.globalCooldown*5) then
				if core:castTemplarsVerdict() then
					return
				end
			end
			-- actions.single+=/seal_of_truth,if=talent.empowered_seals.enabled
			if talent.empoweredSeals then
				-- actions.single+=/seal_of_truth,if=talent.empowered_seals.enabled&buff.maraads_truth.remains<cooldown.judgment.duration
				if (core.seal ~= true and buff.maraadsTruth < core.recharge.judgment) then
					if core:castSeal(1) then
						return
					end
				-- actions.single+=/seal_of_righteousness,if=talent.empowered_seals.enabled&buff.liadrins_righteousness.remains<cooldown.judgment.duration&!buff.bloodlust.up
				elseif (core.seal == true and buff.liadrinsRighteousness < core.recharge.judgment and not hasBloodLust()) then
					if core:castSeal(2) then
						return
					end
				end
			end
			-- actions.single+=/exorcism,if=holy_power<5&talent.seraphim.enabled
			if (holyPower < 5 and talent.seraphim)
				-- actions.single+=/exorcism,if=holy_power<=3|(holy_power=4&(cooldown.judgment.remains>=gcd*2&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
				or (holyPower <= 3 or (holyPower == 4 and core.recharge.judgment >= cd.globalCooldown*2  and cd.crusaderStrike >= cd.globalCooldown*2 and buff.avengingWrath == 0 or getHP(core.units.dyn5) > 35)) then
					if core:castExorcism() then
						return
					end
			end
			-- actions.single+=/divine_storm,if=active_enemies=2&holy_power>=3&buff.final_verdict.up
			if (core.melee12Yards == 2 and holyPower >= 3 and buff.finalVerdict > 0) then
				if core:castDivineStorm() then
					return
				end
			end
			-- actions.single+=/final_verdict,if=holy_power>=3
			if (talent.finalVerdict and holyPower >= 3) then
				if core:castTemplarsVerdict() then
					return
				end
			end
			-- actions.single+=/templars_verdict,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*6)
			if holyPower >= 3 and (not talent.seraphim or cd.seraphim > cd.globalCooldown*6) then
				if core:castTemplarsVerdict() then
					return
				end
			end
			-- actions.single+=/holy_prism
			if core:castHolyPrism(1) then
				return
			end
		----------------
		-- Cleave >2  --
		----------------
		elseif ((core.melee8Yards >= 3 or (talent.finalVerdict and core.melee12Yards >= 3))  and mode.aoe == 3) or mode.aoe == 2 then
			-- actions.cleave=final_verdict,if=buff.final_verdict.down&holy_power=5
			if (talent.finalVerdict and buff.finalVerdict == 0 and holyPower == 5) then
				if core:castTemplarsVerdict() then
					return
				end
			end
			-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&holy_power=5&buff.final_verdict.up
			if (buff.divineCrusader > 0 and holyPower == 5 and buff.finalVerdict > 0) 
				-- actions.cleave+=/divine_storm,if=holy_power=5&buff.final_verdict.up
				or (holyPower == 5 and buff.finalVerdict > 0)
				-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&holy_power=5&!talent.final_verdict.enabled
				or (buff.divineCrusader > 0 and holyPower == 5 and not talent.finalVerdict)
				-- actions.cleave+=/divine_storm,if=holy_power=5&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)&!talent.final_verdict.enabled
				or (holyPower == 5 and (not talent.seraphim or cd.seraphim > cd.globalCooldown*4) and not talent.finalVerdict) then
					if core:castDivineStorm() then
						return
					end
			end
			-- actions.cleave+=/hammer_of_wrath
			if core:castHammerOfWrath() then
				return
			end
			-- actions.cleave+=/judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<cooldown.judgment.duration
			if (talent.empoweredSeals and core.seal == false and buff.liadrinsRighteousness < core.recharge.judgment) then
				if core:castJudgment() then
					return
				end
			end
			-- actions.cleave+=/exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
			if buff.blazingContempt > 0 and holyPower <= 2 and buff.holyAvenger == 0 then
				if core:castExorcism() then
					return
				end
			end
			-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
			-- actions.cleave+=/divine_storm,if=                           buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
			if (buff.finalVerdict > 0 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35)) then
				if core:castDivineStorm() then
					return
				end
			end
			-- actions.cleave+=/final_verdict,if=buff.final_verdict.down&(buff.avenging_wrath.up|target.health.pct<35)
			if (talent.finalVerdict and buff.finalVerdict == 0 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35)) then
				if core:castTemplarsVerdict() then
					return
				end
			end
			-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
			if not talent.finalVerdict then
				if (buff.divineCrusader > 0 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35)) 
				-- actions.cleave+=/divine_storm,if=holy_power=5&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*3)&!talent.final_verdict.enabled
				or (holyPower == 5 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > cd.globalCooldown*3))
				-- actions.cleave+=/divine_storm,if=holy_power=4&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)&!talent.final_verdict.enabled
				or (holyPower == 4 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > cd.globalCooldown*4))
				-- actions.cleave+=/divine_storm,if=holy_power=3&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)&!talent.final_verdict.enabled
				or (holyPower == 3 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > cd.globalCooldown*5)) then
					if core:castDivineStorm() then
						return
					end
				end
			end
			-- actions.cleave+=/hammer_of_the_righteous,if=active_enemies>=4&holy_power<5&talent.seraphim.enabled
			-- actions.cleave+=/hammer_of_the_righteous,if=active_enemies>=4&(holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down))
			if (core.melee8Yards >= 4 and holyPower < 5 and talent.seraphim) 
				or (core.melee8Yards >= 4 and (holyPower <= 3 or (holyPower == 4 and getHP(core.units.dyn5) >= 35 and buff.avengingWrath == 0))) then
					if core:castHammerOfTheRighteous() then
						return
					end
			end
			-- actions.cleave+=/crusader_strike,if=holy_power<5&talent.seraphim.enabled
			-- actions.cleave+=/crusader_strike,if=holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down)
			if (holyPower == 5 and talent.seraphim)
				or (holyPower <= 3 or (holyPower == 4 and getHP(core.units.dyn5) >= 35 and buff.avengingWrath == 0)) then
					if core:castCrusaderStrike() then
						return
					end
			end
			-- actions.cleave+=/exorcism,if=glyph.mass_exorcism.enabled&holy_power<5&!set_bonus.tier17_4pc=1
			-- TODO: update

			-- actions.cleave+=/judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled&holy_power<5
			if glyph.doubleJeopardy and holyPower < 5 then
				if core:castJeopardy() then
					return
				end
			end
			-- actions.cleave+=/judgment,if=holy_power<5&talent.seraphim.enabled
			-- actions.cleave+=/judgment,if=holy_power<=3|(holy_power=4&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down)
			if (holyPower < 5 and talent.seraphim)
				or (holyPower <= 3 or (holyPower == 4 and cd.crusaderStrike >= cd.globalCooldown*2 and getHP(core.units.dyn5) > 35 and buff.avengingWrath == 0)) then
					if core:castJudgment() then
						return
					end
			end
			-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
			-- actions.cleave+=/divine_storm,if=buff.divine_purpose.react& buff.final_verdict.up
			-- actions.cleave+=/divine_storm,if=holy_power>=4&             buff.final_verdict.up
			if ((buff.finalVerdict > 0) and (buff.divineCrusader > 0 or buff.divinePurpose > 0 or holyPower >= 4)) then
				if core:castDivineStorm() then
					return
				end
			end
			-- actions.cleave+=/final_verdict,if=buff.divine_purpose.react 	&buff.final_verdict.down
			-- actions.cleave+=/final_verdict,if=holy_power>=4				&buff.final_verdict.down
			if (talent.finalVerdict and buff.finalVerdict == 0) then
				if (buff.divinePurpose > 0 or holyPower >= 4) then
					if core:castTemplarsVerdict() then
						return
					end
				end
			end
			-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react 												&!talent.final_verdict.enabled
			-- actions.cleave+=/divine_storm,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)&!talent.final_verdict.enabled
			if (not talent.finalVerdict) then
				if (buff.divineCrusader > 0)
					or (holyPower >= 4 and (not talent.seraphim or cd.seraphim > cd.globalCooldown*5)) then
						if core:castDivineStorm() then
							return
						end
				end
			end
			-- actions.cleave+=/exorcism,if=holy_power<5&talent.seraphim.enabled
			-- actions.cleave+=/exorcism,if=holy_power<=3|(holy_power=4&(cooldown.judgment.remains>=gcd*2&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
			if (holyPower < 5 and talent.seraphim)
				or (holyPower <= 3 or (holyPower == 4 and (core.recharge.judgment >= cd.globalCooldown*2 and cd.crusaderStrike >= cd.globalCooldown*2 and getHP(core.units.dyn5) > 35 and buff.avengingWrath == 0))) then
					if core:castExorcism() then
						return
					end
			end
			-- actions.cleave+=/divine_storm,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*6)&!talent.final_verdict.enabled
			-- actions.cleave+=/divine_storm,if=holy_power>=3&buff.final_verdict.up
			if (holyPower >= 3 and (not talent.seraphim or cd.seraphim > cd.globalCooldown*6) and not talent.finalVerdict)
				or (holyPower >= 3 and buff.finalVerdict > 0) then
					if core:castDivineStorm() then
						return
					end
			end
			-- actions.cleave+=/final_verdict,if=holy_power>=3&buff.final_verdict.down
			if (talent.finalVerdict and holyPower >= 3 and buff.finalVerdict == 0) then
				if core:castTemplarsVerdict() then
					return
				end
			end
			-- actions.cleave+=/holy_prism,target=self
			if core:castHolyPrism(1) then
				return
			end
		end
		end]]
	end
end

--- NEW ROTATION ---