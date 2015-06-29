-- SimC Rotation
-- Based on Version: 6.2.0 r1
-- Released on 23 Jun 2015
if select(3, UnitClass("player")) == 2 and GetSpecialization() == 3 then

function cRetribution:retributionSimC()
-- Locals
	local player,holyPower,seal,recharge = "player",self.holyPower,self.seal,self.recharge
	local buff,cd,mode,talent,glyph,gcd = self.buff,self.cd,self.mode,self.talent,self.glyph,self.gcd
	local isChecked,enemies,units,eq,getCombatTime = isChecked,self.enemies,self.units,self.eq,getCombatTime
	local lastSpellCast = lastSpellCast


-- actions+=/execution_sentence,if=!talent.seraphim.enabled
-- actions+=/execution_sentence,sync=seraphim,if=talent.seraphim.enabled
	if (not talent.seraphim) or
		(talent.seraphim and buff.seraphim > 0)
		then
			if self.castExecutionSentence() then return end
	end

-- actions+=/lights_hammer,if=!talent.seraphim.enabled
-- actions+=/lights_hammer,sync=seraphim,if=talent.seraphim.enabled
	if (not talent.seraphim) or 
		(talent.seraphim and buff.seraphim > 0)
		then
			if self.castLightsHammer() then return end
	end

-- actions+=/use_item,name=thorasus_the_stone_heart_of_draenor,if=buff.avenging_wrath.up
	-- Legendary Ring, use it @ raid leaders call

-- actions+=/avenging_wrath,sync=seraphim,if=talent.seraphim.enabled
-- actions+=/avenging_wrath,if=!talent.seraphim.enabled&set_bonus.tier18_4pc=0
-- actions+=/avenging_wrath,if=!talent.seraphim.enabled&time<20&set_bonus.tier18_4pc=1
-- actions+=/avenging_wrath,if=prev.execution_sentence&set_bonus.tier18_4pc=1&talent.execution_sentence.enabled&!talent.seraphim.enabled
-- actions+=/avenging_wrath,if=prev.lights_hammer&set_bonus.tier18_4pc=1&talent.lights_hammer.enabled&!talent.seraphim.enabled
	if (talent.seraphim and buff.seraphim > 0) or 
		(not talent.seraphim and not eq.t18_4pc) or
		(not talent.seraphim and eq.t18_4pc and getCombatTime() < 20) or
		(not talent.seraphim and eq.t18_4pc and (lastSpellCast == spell.executionSentence or lastSpellCast == spell.lightsHammer))
		then
			if self.castAvengingWrath() then return end
	end

-- actions+=/holy_avenger,sync=avenging_wrath,if=!talent.seraphim.enabled
-- actions+=/holy_avenger,sync=seraphim,if=talent.seraphim.enabled
-- actions+=/holy_avenger,if=holy_power<=2&!talent.seraphim.enabled
	if (not talent.seraphim and buff.avengingWrath > 0) or
		(talent.seraphim and buff.seraphim > 0) or
		(not talent.seraphim and holyPower <= 2)
		then
			self.castHolyAvenger()
	end
-- [[     -------------------------        ]]

-- Divine Shield
	if self.castDivineShield() then
		return
	end

-- Selfless Healer
	if isChecked("Selfless Healer") then
		if self.castSelfLessHealer() then return end
	end

-- Sacred Shield
    if isChecked("Sacred Shield") then
    	if self.castSacredShield() then return end
    end

-- Self Glory
	if isChecked("Self Glory") then
		if self.castWordOfGlory() then return end
	end

-- holy_prism 2+
	if self.castHolyPrism(2) then
		return
	end

-- Seraphim (off gcd) 
	-- actions+=/seraphim 
	self.castSeraphim()
	-- actions+=/wait,sec=cooldown.seraphim.remains,if=talent.seraphim.enabled&cooldown.seraphim.remains>0&cooldown.seraphim.remains<gcd.max&holy_power>=5
	if (talent.seraphim and cd.seraphim > 0 and cd.seraphim < gcd and holyPower == 5) then return end

----------------
-- Single 1-2 --
----------------
--actions+=/call_action_list,name=single
	if ((enemies.yards8 < 3 or (talent.finalVerdict and enemies.yards12 < 3))  and mode.aoe == 3) or mode.aoe == 1 then

	-- actions.single+=/divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&buff.final_verdict.up
		if (buff.divineCrusader > 0 and (holyPower == 5 or (buff.holyAvenger > 0 and holyPower >= 3)) and buff.finalVerdict > 0)
			-- actions.single+=/divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&active_enemies=2&!talent.final_verdict.enabled
			or (buff.divineCrusader > 0 and (holyPower == 5 or (buff.holyAvenger > 0 and holyPower >= 3)) and enemies.yards8 == 2 and not talent.finalVerdict)
			-- actions.single+=/divine_storm,if=(holy_power=5|buff.holy_avenger.up&holy_power>=3)&active_enemies=2&buff.final_verdict.up
			or ((holyPower == 5 or (buff.holyAvenger > 0 and holyPower >= 3)) and enemies.yards12 == 2 and buff.finalVerdict > 0)
			-- actions.single+=/divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&(talent.seraphim.enabled&cooldown.seraphim.remains<gcd*4)
			or (buff.divineCrusader > 0 and (holyPower == 5 or (buff.holyAvenger > 0 and holyPower >= 3)) and (talent.seraphim and cd.seraphim <= gcd*4)) then
				if self.castDivineStorm() then return end
		end

	-- actions.single+=/templars_verdict,if=(holy_power=5|buff.holy_avenger.up&holy_power>=3)&(buff.avenging_wrath.down|target.health.pct>35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)
		if ( (holyPower == 5 or (buff.holyAvenger > 0 and holyPower >= 3)) and (buff.avengingWrath == 0 or getHP(units.dyn5) > 35) and (not talent.seraphim or cd.seraphim > gcd*4) )
			-- actions.single+=/templars_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<3
			or (buff.divinePurpose > 0 and buff.divinePurpose < 3) then
				if self.castTemplarsVerdict() then return end
		end

	-- actions.single+=/divine_storm,if=buff.divine_crusader.react&buff.divine_crusader.remains<3&buff.final_verdict.up
		if buff.divineCrusader > 0 and buff.divineCrusader < 3 and buff.finalVerdict > 0 then
			if self.castDivineStorm() then return end
		end

	-- actions.single+=/final_verdict
		if talent.finalVerdict
			-- actions.single+=/final_verdict,if=holy_power=5|buff.holy_avenger.up&holy_power>=3
			and (holyPower == 5 or (buff.holyAvenger > 0 and holyPower >= 3)
			-- actions.single+=/final_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<3
			or (buff.divinePurpose > 0 and buff.divinePurpose < 3)) then
				if self.castTemplarsVerdict() then return end
		end

	-- actions.single+=/crusader_strike,if=t18_class_trinket=1&buff.focus_of_vengeance.remains<gcd.max*2
		if eq.t18_classTrinket and buff.focusOfVengeance < gcd*2 then
			if self.castCrusaderStrike() then return end
		end 

	-- actions.single+=/hammer_of_wrath
		if self.castHammerOfWrath() then return end

	-- actions.single+=/exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
		if buff.blazingContempt > 0 and holyPower <= 2 and buff.holyAvenger == 0 then
			if self.castExorcism() then return end
		end
	
	-- actions.single+=/divine_storm,if=buff.divine_crusader.react 	&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
	-- actions.single+=/divine_storm,if=active_enemies=2			&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
		if (buff.divineCrusader > 0 or enemies.yards12 == 2) and buff.finalVerdict > 0 and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35) then
			if self.castDivineStorm() then return end
		end

	-- actions.single+=/final_verdict,if=buff.avenging_wrath.up|target.health.pct<35
		if talent.finalVerdict and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35) then
			if self.castTemplarsVerdict() then return end
		end

	-- actions.single+=/divine_storm,if=buff.divine_crusader.react&active_enemies=2&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
		if buff.divineCrusader > 0 and enemies.yards8 == 2 and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35) and not talent.finalVerdict then
			if self.castDivineStorm() then return end
		end

	-- actions.single+=/templars_verdict,if=holy_power=5&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*3)
		if (holyPower == 5 and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > gcd*3))
			-- actions.single+=/templars_verdict,if=holy_power=4&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)
			or (holyPower == 4 and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > gcd*4))
			-- actions.single+=/templars_verdict,if=holy_power=3&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)
			or (holyPower == 3 and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > gcd*5)) then
				if self.castTemplarsVerdict() then return end
		end

	-- actions.single+=/judgment,if=talent.empowered_seals.enabled
		if talent.empoweredSeals then
			-- &seal.truth&buff.maraads_truth.remains<cooldown.judgment.duration*1.5
			if (seal == true and (buff.maraadsTruth < recharge.judgment*1.5 or buff.maraadsTruth == 0))
			-- &seal.righteousness&buff.liadrins_righteousness.remains<cooldown.judgment.duration*1.5
			or (seal == false and (buff.liadrinsRighteousness < recharge.judgment*1.5 or buff.liadrinsRighteousness == 0))
			then
				if self.castJudgment() then return end
			end
		end

	-- actions.single+=/seal_of_truth,if=talent.empowered_seals.enabled
		if talent.empoweredSeals then
			-- &buff.maraads_truth.remains<(cooldown.judgment.duration|buff.maraads_truth.down)&(buff.avenging_wrath.up|target.health.pct<35)&!buff.wings_of_liberty.up
			if (seal ~= true) and 
				(buff.maraadsTruth == 0 or buff.maraadsTruth < recharge.judgment) and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35) and buff.wingsOfLiberty == 0 then
					if self.castSeal(1) then return end
			-- &buff.liadrins_righteousness.remains<cooldown.judgment.duration&buff.maraads_truth.remains>cooldown.judgment.duration*1.5&target.health.pct<35&!buff.wings_of_liberty.up&!buff.bloodlust.up
			elseif (seal == true) and 
				buff.liadrinsRighteousness < recharge.judgment and buff.maraadsTruth > recharge.judgment*1.5 and getHP(units.dyn5) < 35 and buff.wingsOfLiberty == 0 and not hasBloodLust() then
					if self.castSeal(2) then return end
			end
		end

	-- actions.single+=/crusader_strike,if=talent.seraphim.enabled
		if (talent.seraphim) 
			-- actions.single+=/crusader_strike,if=holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down)
			or (holyPower <= 3 or (holyPower == 4 and buff.avengingWrath == 0 or getHP(units.dyn5) >= 35)) then
				if self.castCrusaderStrike() then return end
		end

	-- actions.single+=/divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
		if buff.divineCrusader > 0 and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35) and not talent.finalVerdict then
			if self.castDivineStorm() then return end
		end

	-- actions.single+=/exorcism,if=glyph.mass_exorcism.enabled&spell_targets.exorcism>=2&!glyph.double_jeopardy.enabled&!set_bonus.tier17_4pc=1
		-- TODO: update

	-- actions.single+=/judgment,cycle_targets=1,if=last_judgment_target!=target&talent.seraphim.enabled&glyph.double_jeopardy.enabled
	-- actions.single+=/judgment,if=talent.seraphim.enabled
		if talent.seraphim then
			if self.castJeopardy() then return end
		end

	-- actions.single+=/judgment,cycle_targets=1,if=last_judgment_target!=target&glyph.double_jeopardy.enabled&(holy_power<=3|(holy_power=4&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
	-- actions.single+=/judgment,if=holy_power<=3|(holy_power=4&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down)
		if (holyPower <= 3 or (holyPower == 4 and cd.crusaderStrike >= gcd*2 and buff.avengingWrath == 0 or getHP(units.dyn5) > 35)) then
				if self.castJeopardy() then return end
		end

	-- actions.single+=/divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
		if (buff.divineCrusader > 0 and buff.finalVerdict > 0) 
			-- actions.single+=/divine_storm,if=active_enemies=2&holy_power>=4&buff.final_verdict.up
			or (enemies.yards12 == 2 and holyPower >= 4 and buff.finalVerdict > 0) then
				if self.castDivineStorm() then return end
		end

	-- actions.single+=/final_verdict,if=buff.divine_purpose.react
	-- actions.single+=/final_verdict,if=holy_power>=4
		if talent.finalVerdict and (buff.divinePurpose > 0 or holyPower >= 4) then
			if self.castTemplarsVerdict() then return end
		end

	-- actions.single+=/seal_of_truth,if=talent.empowered_seals.enabled
		if talent.empoweredSeals then
			-- &buff.maraads_truth.remains<cooldown.judgment.duration*1.5&buff.liadrins_righteousness.remains>cooldown.judgment.duration*1.5
			if (seal ~= true) and 
				buff.maraadsTruth < recharge.judgment*1.5 and buff.liadrinsRighteousness > recharge.judgment*1.5 then
					if self.castSeal(1) then return end
			-- actions.single+=/seal_of_righteousness,if=talent.empowered_seals.enabled
			-- &buff.liadrins_righteousness.remains<cooldown.judgment.duration*1.5&buff.maraads_truth.remains>cooldown.judgment.duration*1.5&!buff.bloodlust.up
			elseif (seal == true) and 
				buff.liadrinsRighteousness < recharge.judgment*1.5 and buff.maraadsTruth > recharge.judgment*1.5 and not hasBloodLust() then
					if self.castSeal(2) then return end
			end
		end

	-- actions.single+=/divine_storm,if=buff.divine_crusader.react&active_enemies=2&holy_power>=4&!talent.final_verdict.enabled
		if (buff.divineCrusader > 0 and enemies.yards8 == 2 and holyPower >= 4 and not talent.finalVerdict) then
			if self.castDivineStorm() then return end
		end

	-- actions.single+=/templars_verdict,if=buff.divine_purpose.react
		if buff.divinePurpose > 0 then
			if self.castTemplarsVerdict() then return end
		end

	-- actions.single+=/divine_storm,if=buff.divine_crusader.react&!talent.final_verdict.enabled
		if buff.divineCrusader > 0 and not talent.finalVerdict then
			if self.castDivineStorm() then return end
		end

	-- actions.single+=/templars_verdict,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)
		if holyPower >= 4 and (not talent.seraphim or cd.seraphim > gcd*5) then
			if self.castTemplarsVerdict() then return end
		end

	-- actions.single+=/exorcism,if=talent.seraphim.enabled
		if (talent.seraphim)
			-- actions.single+=/exorcism,if=holy_power<=3|(holy_power=4&(cooldown.judgment.remains>=gcd*2&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
			or (holyPower <= 3 or (holyPower == 4 and recharge.judgment >= gcd*2  and cd.crusaderStrike >= gcd*2 and buff.avengingWrath == 0 or getHP(units.dyn5) > 35)) then
			if self.castExorcism() then return end
		end

	-- actions.single+=/divine_storm,if=active_enemies=2&holy_power>=3&buff.final_verdict.up
		if (enemies.yards12 == 2 and holyPower >= 3 and buff.finalVerdict > 0) then
			if self.castDivineStorm() then return end
		end

	-- actions.single+=/final_verdict,if=holy_power>=3
		if (talent.finalVerdict and holyPower >= 3) then
			if self.castTemplarsVerdict() then return end
		end

	-- actions.single+=/templars_verdict,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*6)
		if holyPower >= 3 and (not talent.seraphim or cd.seraphim > gcd*6) then
			if self.castTemplarsVerdict() then return end
		end

	-- actions.single+=/holy_prism
		if self.castHolyPrism(1) then return end

----------------
-- Cleave >2  --
----------------
-- Cleave > 2 Targets 
	elseif ((enemies.yards8 >= 3 or (talent.finalVerdict and enemies.yards12 >= 3))  and mode.aoe == 3) or mode.aoe == 2 then
		
	-- actions.cleave=final_verdict,if=buff.final_verdict.down&holy_power=5
		if (talent.finalVerdict and buff.finalVerdict == 0 and holyPower == 5) then
			if self.castTemplarsVerdict() then return end
		end

	-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&holy_power=5&buff.final_verdict.up
		if (buff.divineCrusader > 0 and holyPower == 5 and buff.finalVerdict > 0) 
			-- actions.cleave+=/divine_storm,if=holy_power=5&buff.final_verdict.up
			or (holyPower == 5 and buff.finalVerdict > 0)
			-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&holy_power=5&!talent.final_verdict.enabled
			or (buff.divineCrusader > 0 and holyPower == 5 and not talent.finalVerdict)
			-- actions.cleave+=/divine_storm,if=holy_power=5&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)&!talent.final_verdict.enabled
			or (holyPower == 5 and (not talent.seraphim or cd.seraphim > gcd*4) and not talent.finalVerdict) then
				if self.castDivineStorm() then return end
		end

	-- actions.cleave+=/hammer_of_wrath
		if self.castHammerOfWrath() then return end

	-- actions.cleave+=/hammer_of_the_righteous,if=t18_class_trinket=1&buff.focus_of_vengeance.remains<gcd.max*2
		if eq.t18_classTrinket and buff.focusOfVengeance < gcd*2 then
			if self.castHammerOfTheRighteous() then return end
		end

	-- actions.cleave+=/judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<cooldown.judgment.duration
		if (talent.empoweredSeals and seal == false and buff.liadrinsRighteousness < recharge.judgment) then
			if self.castJudgment() then return end
		end

	-- actions.cleave+=/exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
		if buff.blazingContempt > 0 and holyPower <= 2 and buff.holyAvenger == 0 then
			if self.castExorcism() then return end
		end

	-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
		-- actions.cleave+=/divine_storm,if=                           buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
		if (buff.finalVerdict > 0 and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35)) then
			if self.castDivineStorm() then return end
		end

	-- actions.cleave+=/final_verdict,if=buff.final_verdict.down&(buff.avenging_wrath.up|target.health.pct<35)
		if (talent.finalVerdict and buff.finalVerdict == 0 and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35)) then
			if self.castTemplarsVerdict() then return end
		end

	-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
		if not talent.finalVerdict then
			if (buff.divineCrusader > 0 and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35)) 
			-- actions.cleave+=/divine_storm,if=holy_power=5&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*3)&!talent.final_verdict.enabled
			or (holyPower == 5 and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > gcd*3))
			-- actions.cleave+=/divine_storm,if=holy_power=4&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)&!talent.final_verdict.enabled
			or (holyPower == 4 and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > gcd*4))
			-- actions.cleave+=/divine_storm,if=holy_power=3&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)&!talent.final_verdict.enabled
			or (holyPower == 3 and (buff.avengingWrath > 0 or getHP(units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > gcd*5)) then
				if self.castDivineStorm() then return end
			end
		end

	-- actions.cleave+=/hammer_of_the_righteous,if=spell_targets.hammer_of_the_righteous>=4&talent.seraphim.enabled
	-- actions.cleave+=/hammer_of_the_righteous,,if=spell_targets.hammer_of_the_righteous>=4&(holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down))
		if (enemies.yards8 >= 4 and talent.seraphim) 
			or (enemies.yards8 >= 4 and (holyPower <= 3 or (holyPower == 4 and getHP(units.dyn5) >= 35 and buff.avengingWrath == 0))) then
			if self.castHammerOfTheRighteous() then return end
		end

	-- actions.cleave+=/crusader_strike,if=talent.seraphim.enabled
	-- actions.cleave+=/crusader_strike,if=holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down)
		if (talent.seraphim)
			or (holyPower <= 3 or (holyPower == 4 and getHP(units.dyn5) >= 35 and buff.avengingWrath == 0)) then
			if self.castCrusaderStrike() then return end
		end

	-- actions.cleave+=/exorcism,if=glyph.mass_exorcism.enabled&!set_bonus.tier17_4pc=1
		-- TODO: update

	-- actions.cleave+=/judgment,cycle_targets=1,if=last_judgment_target!=target&talent.seraphim.enabled&glyph.double_jeopardy.enabled
	-- actions.cleave+=/judgment,if=talent.seraphim.enabled
		if talent.seraphim then
			if self.castJeopardy() then return end
		end

	--actions.cleave+=/judgment,cycle_targets=1,if=last_judgment_target!=target&glyph.double_jeopardy.enabled&(holy_power<=3|(holy_power=4&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
		if (holyPower <= 3 or (holyPower == 4 and cd.crusaderStrike >= gcd*2 and getHP(units.dyn5) > 35 and buff.avengingWrath == 0)) then
				if self.castJeopardy() then return end
		end

	-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
	-- actions.cleave+=/divine_storm,if=buff.divine_purpose.react& buff.final_verdict.up
	-- actions.cleave+=/divine_storm,if=holy_power>=4&             buff.final_verdict.up
		if ((buff.finalVerdict > 0) and (buff.divineCrusader > 0 or buff.divinePurpose > 0 or holyPower >= 4)) then
			if self.castDivineStorm() then return end
		end

	-- actions.cleave+=/final_verdict,if=buff.divine_purpose.react 	&buff.final_verdict.down
	-- actions.cleave+=/final_verdict,if=holy_power>=4				&buff.final_verdict.down
		if (talent.finalVerdict and buff.finalVerdict == 0) then
			if (buff.divinePurpose > 0 or holyPower >= 4) then
				if self.castTemplarsVerdict() then return end
			end
		end

	-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react 												&!talent.final_verdict.enabled
	-- actions.cleave+=/divine_storm,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)&!talent.final_verdict.enabled
		if (not talent.finalVerdict) then
			if (buff.divineCrusader > 0)
				or (holyPower >= 4 and (not talent.seraphim or cd.seraphim > gcd*5)) then
					if self.castDivineStorm() then return end
			end
		end

	-- actions.cleave+=/exorcism,if=holy_power<5&talent.seraphim.enabled
	-- actions.cleave+=/exorcism,if=holy_power<=3|(holy_power=4&(cooldown.judgment.remains>=gcd*2&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
		if (talent.seraphim)
			or (holyPower <= 3 or (holyPower == 4 and (recharge.judgment >= gcd*2 and cd.crusaderStrike >= gcd*2 and getHP(units.dyn5) > 35 and buff.avengingWrath == 0))) then
				if self.castExorcism() then return end
		end

	-- actions.cleave+=/divine_storm,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*6)&!talent.final_verdict.enabled
	-- actions.cleave+=/divine_storm,if=holy_power>=3&buff.final_verdict.up
		if (holyPower >= 3 and (not talent.seraphim or cd.seraphim > gcd*6) and not talent.finalVerdict)
			or (holyPower >= 3 and buff.finalVerdict > 0) then
			if self.castDivineStorm() then return end
		end

	-- actions.cleave+=/final_verdict,if=holy_power>=3&buff.final_verdict.down
		if (talent.finalVerdict and holyPower >= 3 and buff.finalVerdict == 0) then
			if self.castTemplarsVerdict() then return end
		end

	-- actions.cleave+=/holy_prism,target=self
		if self.castHolyPrism(1) then return end

	end	-- End if single or cleave
end -- Main rota function
end -- Select Paladin and Retribution