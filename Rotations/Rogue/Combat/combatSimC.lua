-- SimC Rotation
-- Based on Version: 6.2.0 r1
-- Released on 23 Jun 2015
if select(2, UnitClass("player")) == "ROGUE" then

function cCombat:combatSimC()
-- Locals
	local player,comboPoints,recharge,stealth,power = "player",self.comboPoints,self.recharge,self.stealth,self.power
	local buff,cd,mode,talent,glyph,gcd = self.buff,self.cd,self.mode,self.talent,self.glyph,self.gcd
	local isChecked,enemies,units,eq,getCombatTime = isChecked,self.enemies,self.units,self.eq,getCombatTime
	local lastSpellCast,getTimeToDie,UnitExists = lastSpellCast,getTimeToDie,UnitExists
	local timeToDie = getTimeToDie("target")
	local hasTarget = UnitExists("target")
	local targetDistance = getDistance("target","player")

	--------------------
	--- Action Lists ---
	--------------------

	-- # Adrenaline Rush
	-- TODO: Trinket and Ring buff
	-- actions.adrenaline_rush=adrenaline_rush,if=target.time_to_die>=44
	-- actions.adrenaline_rush+=/adrenaline_rush,if=target.time_to_die<44&(buff.archmages_greater_incandescence_agi.react|trinket.proc.any.react|trinket.stacking_proc.any.react)
	-- actions.adrenaline_rush+=/adrenaline_rush,if=target.time_to_die<=buff.adrenaline_rush.duration*1.5
	function actionList_AdrenalineRush()
		if timeToDie >= 44
		or timeToDie <= buff.adrenalineRush * 1.5 
		then
			if self:castAdrenalineRush() then return end
		end
	end

	-- # Killing Spree
	-- TODO: Trinket and Ring buff
	-- actions.killing_spree=killing_spree,if=target.time_to_die>=44
	-- actions.killing_spree+=/killing_spree,if=target.time_to_die<44&buff.archmages_greater_incandescence_agi.react&buff.archmages_greater_incandescence_agi.remains>=buff.killing_spree.duration
	-- actions.killing_spree+=/killing_spree,if=target.time_to_die<44&trinket.proc.any.react&trinket.proc.any.remains>=buff.killing_spree.duration
	-- actions.killing_spree+=/killing_spree,if=target.time_to_die<44&trinket.stacking_proc.any.react&trinket.stacking_proc.any.remains>=buff.killing_spree.duration
	-- actions.killing_spree+=/killing_spree,if=target.time_to_die<=buff.killing_spree.duration*1.5
	function actionList_KillingSpree()
		if timeToDie >= 44
		or timeToDie <= buff.killingSpree * 1.5 
		then
			if self:castKillingSpree() then return end
		end
	end

	-- # Combo point generators
	function actionList_Generator()
		-- actions.generator=revealing_strike,if=(combo_points=4&dot.revealing_strike.remains<7.2&(target.time_to_die>dot.revealing_strike.remains+7.2)|(target.time_to_die<dot.revealing_strike.remains+7.2&ticks_remain<2))|!ticking
		if (comboPoints == 4 and self:getRevealingStrikeDebuff() < 7.2 and (timeToDie > self:getRevealingStrikeDebuff() + 7.2) or (timeToDie < self:getRevealingStrikeDebuff() + 7.2 and self:getRevealingStrikeDebuff() < 2)) or self:getRevealingStrikeDebuff() == 0 then
			if self:castRevealingStrike() then return end
		end

		-- actions.generator+=/sinister_strike,if=dot.revealing_strike.ticking
		if self:getRevealingStrikeDebuff() > 0 then
			if self:castSinisterStrike() then return end
		end
	end

	-- # Combo point finishers
	function actionList_Finisher()
        -- Crimson Tempest
        if enemies.yards10 >= 5 and self:getCrimsonTempestDebuff() < 8 then
          if self:castCrimsonTempest() then return end
        end

		-- actions.finisher=death_from_above
		if talent.deathFromAbove then
			if self:castDeathFromAbove() then return end
		end

		-- actions.finisher+=/eviscerate,if=(!talent.death_from_above.enabled|cooldown.death_from_above.remains)
		if (not talent.deathFromAbove or cd.deathFromAbove > 0) then
			if self:castEviscerate() then return end
		end
	end

	function actionList_OOC()
		if not (IsMounted() or IsFlying() or UnitIsFriend("target","player")) then
			-- Stealth
			if isChecked("Stealth") and (stealthTimer == nil or stealthTimer <= GetTime()-getValue("Stealth Timer")) and getCreatureType("target") == true and not stealth then
				-- Always
				if getValue("Stealth") == 1 then
					if self:castStealth() then stealthTimer=GetTime(); return end
				end
				-- Pre-Pot
				--if getValue("Stealth") == 2 and getBuffRemain("player",105697) > 0 and tarDist < 20 then
				--	if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
				--end
				-- 20 Yards
				--if getValue("Stealth") == 3 and tarDist < 20 then
				--	if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
				--end
			end
		end

		-- actions.precombat+=/marked_for_death
		-- actions.precombat+=/slice_and_dice,if=talent.marked_for_death.enabled
		if getCombatTime() < 5 and talent.markedForDeath and hasTarget and targetDistance < 10 and not UnitIsFriend("target","player") then
			if comboPoints == 0 then
				self:castMarkedForDeath()
			elseif comboPoints == 5 then
				if self:castSliceAndDice() then return end
			end
		end

		return true
	end 

	---                  ---
	--- END Action Lists ---
	--- --------------------

	if self.inCombat == false then
		if actionList_OOC() then return end
	end

	-- actions.precombat+=/potion,name=draenic_agility
	-- actions.precombat+=/stealth



	-- actions=potion,name=draenic_agility,if=buff.bloodlust.react|target.time_to_die<40|(buff.adrenaline_rush.up&buff.maalus.up&(trinket.proc.any.react|trinket.stacking_proc.any.react|buff.archmages_greater_incandescence_agi.react))
	-- TODO: Pot usage

	-- actions+=/preparation,if=!buff.vanish.up&cooldown.vanish.remains>30
	if buff.vanish == 0 and cd.vanish > 30 then
		if self:castPreparation() then return end
	end

	-- actions+=/blood_fury
	-- actions+=/berserking
	-- actions+=/arcane_torrent,if=energy<60
	if self.race == "BloodElf" and power < 60 then
		if self:castRacial() then return end
	elseif self.race == "Orc" or self.race == "Troll" then
		if self:castRacial() then return end
	end

	-- actions+=/blade_flurry,if=(spell_targets.blade_flurry>=2&!buff.blade_flurry.up)|(spell_targets.blade_flurry<2&buff.blade_flurry.up)
	if (enemies.yards8 >= 2 and buff.bladeFlurry == nil ) then
		self:castBladeFlurry()
	elseif (enemies.yards8 < 2 and buff.bladeFlurry ~= nil) then
		CancelUnitBuff("player", buff.bladeFlurry ) -- as sometimes just using again does not work
	end

	-- actions+=/shadow_reflection,if=(cooldown.killing_spree.remains<10&combo_points>3)|buff.adrenaline_rush.up
	if (cd.killingSpree < 10 and comboPoints > 3) or buff.adrenalineRush > 0 then
		if self:castShadowReflection() then return end
	end

	-- actions+=/ambush
	if stealth then
		if self:castAmbush() then return end
	end

	-- actions+=/vanish,if=time>10&(combo_points<3|(talent.anticipation.enabled&anticipation_charges<3)|(combo_points<4|(talent.anticipation.enabled&anticipation_charges<4)))&((talent.shadow_focus.enabled&buff.adrenaline_rush.down&energy<90&energy>=15)|(talent.subterfuge.enabled&energy>=90)|(!talent.shadow_focus.enabled&!talent.subterfuge.enabled&energy>=60))
	-- TODO: fucking long line

	-- actions+=/slice_and_dice,if=buff.slice_and_dice.remains<2|((target.time_to_die>45&combo_points=5&buff.slice_and_dice.remains<12)&buff.deep_insight.down)
	if buff.sliceAndDice < 2 or ((getTimeToDie("target") > 45 and comboPoints == 5 and buff.sliceAndDice < 12) and buff.deepInsight == 0) then
		if self:castSliceAndDice() then return end
	end

	-- actions+=/call_action_list,name=adrenaline_rush,if=cooldown.killing_spree.remains>10
	if cd.killingSpree > 10 then
		if actionList_AdrenalineRush() then return end
	end

	-- actions+=/call_action_list,name=killing_spree,if=(energy<40|(buff.bloodlust.up&time<10)|buff.bloodlust.remains>20)&buff.adrenaline_rush.down&(!talent.shadow_reflection.enabled|cooldown.shadow_reflection.remains>30|buff.shadow_reflection.remains>3)
	if (power < 40 or (hasBloodLust() and getCombatTime() < 10)) and buff.adrenalineRush == 0 and (not talent.shadowReflection or cd.shadowReflection > 30 or buff.shadowReflection > 3) then
		if actionList_KillingSpree() then return end
	end

	-- actions+=/marked_for_death,if=combo_points<=1&dot.revealing_strike.ticking&(!talent.shadow_reflection.enabled|buff.shadow_reflection.up|cooldown.shadow_reflection.remains>30)
	if comboPoints <= 1 and self:getRevealingStrikeDebuff() > 0 and (not talent.shadowReflection or buff.shadowReflection > 0 or cd.shadowReflection > 30) then
		if self:castMarkedForDeath() then return end
	end

	-- actions+=/call_action_list,name=generator,if=combo_points<5|!dot.revealing_strike.ticking|(talent.anticipation.enabled&anticipation_charges<3&buff.deep_insight.down)
	if comboPoints < 5 or self:getRevealingStrikeDebuff() == 0 or (talent.anticipation and charges.anticipation < 3 and buff.deepInsight == 0) then
		if actionList_Generator() then return end
	end

	-- actions+=/call_action_list,name=finisher,if=combo_points=5&dot.revealing_strike.ticking&(buff.deep_insight.up|!talent.anticipation.enabled|(talent.anticipation.enabled&anticipation_charges>=3))
	if comboPoints == 5 and self:getRevealingStrikeDebuff() > 0 and (buff.deepInsight > 0 or not talent.anticipation or (talent.anticipation and charges.anticipation >= 3)) then
		if actionList_Finisher() then return end
	end

	---- Rotation END -----
	-----------------------

end -- Main rota function
end -- Select Rogue