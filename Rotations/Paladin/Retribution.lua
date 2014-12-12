if select(3, UnitClass("player")) == 2 then
	function PaladinRetribution()
	if currentConfig ~= "Retribution Paladin" then --Where is currentConfig set? Is this only used for init?
		--PaladinRetFunctions(); --Prot functions is SacredShield and GetHolyGen
		PaladinRetToggles() -- Setting up Toggles, AoE, Interrupt, Defensive CD, CD, Healing
		PaladinRetOptions() -- Reading Config values from gui?
		currentConfig = "Retribution Paladin"
	end
	dynamicUnit = {
		dyn5 = dynamicTarget(5,true),
		dyn8AoE = dynamicTarget(8,false),
		dyn8 = dynamicTarget(8,true),
		dyn16AoE = dynamicTarget(16,false),
		dyn30 = dynamicTarget(30,true),
		dyn30AoE = dynamicTarget(30,false),
		dyn40 = dynamicTarget(40,true)
	}
	-- Locals Variables
	local _HolyPower = UnitPower("player", 9)
	-- Gabbz:Get number of enemies within melee range. Does this also work for large hotboxes?
	-- CML:Last time i did test with it i was able to test range from a mob to sha
	-- with a -3 yard precision under 10 yard
	local meleeEnemies = #getEnemies("player", 5)
	local buffDivineCrusader = getBuffRemain("player",_DivineCrusader)
	local buffHolyAvenger = getBuffRemain("player",_HolyAvenger)
	local buffDivinePurpose = getBuffRemain("player",_DivinePurpose)
	local buffFinalVerdict = getBuffRemain("player",_FinalVerdict)
	local buffSeraPhim = getBuffRemain("player",_Seraphim)
	local buffBlazingContemp = getBuffRemain("player",_BlazingContemp)
	local buffAvengingWrath = getBuffRemain("player",_AvengingWrath)
	local buffLiadrinsRighteousness = getBuffRemain("player",156989)
	local buffMaraadsTruth = getBuffRemain("player",156990)
	local cdSeraphim = getSpellCD(_Seraphim)
	local sealOfTruth = GetShapeshiftForm() == 1 or nil
	local sealOfRighteousness = GetShapeshiftForm() == 2 or nil
	local talentEmpoweredSeal = isKnown(152263)
	local talentFinalVerdict = isKnown(_FinalVerdict)
	local talentSeraphim = isKnown(_Seraphim)
	local glyphMassExorcism = hasGlyph(122028)
	local glyphDoubleJeopardy = hasGlyph(54922)
	local meleeAoEEnemies = meleeEnemies
	local meleeAoEEnemies = #getEnemies("player", 8)
	if buffFinalVerdict then
		meleeAoEEnemies = #getEnemies("player", 16)
	end

	-- Food/Invis Check
	-- Gabbz:Hm here we are checking if we should abort the rotation pulse due to if we are a vehicle or some stuff
	-- CML:Can find this function atop general funcs
	if canRun() ~= true then
		return false
	end

	-- OFF-GCD here we add the spells we want to be spamming all the time
	if UnitAffectingCombat("player") then
		-- Rebuke
		castRebuke(unit)

		-- Divine Protection
		castDivineProtection()
	end

	-- GCD check
	if castingUnit() then
		return
	end

	-- Combats Starts Here
	if isInCombat("player") then
		-- Lay on Hands
		if getHP("player") <= getValue("Lay On Hands") then
			castLayOnHands("player")
		else
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Lay On Hands") then
					castLayOnHands(nNova[i].unit)
				end
			end
		end

		-- Selfless Healer
		if getHP("player") <= getValue("Selfless Healer") then
			if castSpell("player",_FlashOfLight,true) then
				return
			end
		else
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Selfless Healer") then
					if castSpell(nNova[i].unit,_FlashOfLight,true) then
						return
					end
				end
			end
		end

		-- potion,name=draenic_strength,if=(buff.bloodlust.react|buff.avenging_wrath.up|target.time_to_die<=40)
		--[[Always]]
		-- auto_attack
		if isInMelee() and getFacing("player","target") == true then
			RunMacroText("/startattack")
		end

		castCrowdControl("any",105593,20) -- 853
		-- speed_of_light,if=movement.distance>5

		-- execution_sentence
		castExecutionSentence(dynamicUnit.dyn40)

		-- lights_hammer
		castLightsHammer(dynamicUnit.dyn30AoE)

		-- Holy Avenger
		castHolyAvenger(_HolyPower)

		-- Avenging Wrath
		castAvengingWrath()

		-- use_item,name=vial_of_convulsive_shadows,if=buff.avenging_wrath.up
		-- blood_fury
		-- berserking
		-- arcane_torrent
		-- seraphim
		castSeraphim(_HolyPower)
		--[[Single(1-2)]]
		if meleeAoEEnemies < 3 then
			-- divine_storm,if=buff.divine_crusader.react&holy_power=5&buff.final_verdict.up
			if (buffDivineCrusader > 0 and _HolyPower == 5 and buffFinalVerdict > 0)
			  -- divine_storm,if=buff.divine_crusader.react&holy_power=5&active_enemies=2&!talent.final_verdict.enabled
			  or (buffDivineCrusader > 0 and _HolyPower == 5 and meleeAoEEnemies == 2)
			  -- divine_storm,if=holy_power=5&active_enemies=2&buff.final_verdict.up
			  or (_HolyPower == 5 and meleeAoEEnemies == 2 and buffFinalVerdict > 0)
			  -- divine_storm,if=buff.divine_crusader.react&holy_power=5&(talent.seraphim.enabled&cooldown.seraphim.remains<=4)
			  or (_HolyPower == 5 and meleeAoEEnemies == 2 and talentSeraphim and cdSeraphim <= 4) then
			  	castDivineStorm()
			end
			-- templars_verdict,if=holy_power=5|buff.holy_avenger.up&holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
			if _HolyPower == 5
			  or ((buffHolyAvenger and _HolyPower >= 3) and (not talentSeraphim or cdSeraphim > 4))
			  -- templars_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<4
			  or (buffDivinePurpose > 0 and buffDivinePurpose < 4) then
			  	castTemplarsVerdict()
			end
			-- divine_storm,if=buff.divine_crusader.react&buff.divine_crusader.remains<4&!talent.final_verdict.enabled
			if buffDivineCrusader and buffDivineCrusader < 4 and not talentFinalVerdict then
			  	castDivineStorm()
			end
			if talentFinalVerdict
			  -- final_verdict,if=holy_power=5|buff.holy_avenger.up&holy_power>=3
			 and (_HolyPower == 5 or (buffHolyAvenger > 1 and _HolyPower >= 3)
			  -- final_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<4
			  or (buffDivinePurpose > 0 and buffDivinePurpose < 4)) then
			  	castTemplarsVerdict()
			end
			-- hammer_of_wrath
			castMultiHammerOfWrath()
			-- judgment,if=talent.empowered_seals.enabled&((seal.truth&buff.maraads_truth.remains<cooldown.judgment.duration*2)
			if talentEmpoweredSeal then
				if buffLiadrinsRighteousness < 8 then
					if (sealOfTruth and buffMaraadsTruth < getSpellCD(_Judgment) + 5)
					  -- |(seal.righteousness&buff.liadrins_righteousness.remains<cooldown.judgment.duration*2))
					  or (sealOfRighteousness and buffLiadrinsRighteousness < getSpellCD(_Judgment) + 5) then
					  	castJudgement()
					end
				end
			end
			-- exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
			if UnitBuffID("player",_BlazingContemp) and HolyPower <= 2 then
				castExorcism(dynamicUnit.dyn30)
			end
			-- seal_of_truth,if=talent.empowered_seals.enabled&buff.maraads_truth.remains<(cooldown.judgment.duration)&buff.maraads_truth.remains<=3
			if talentEmpoweredSeal then
				if buffMaraadsTruth < getSpellCD(_Judgment) and buffMaraadsTruth <= 3 then
					castSealOfTruth()
				end
			end
			-- divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
			if _DivineCrusader > 0 and buffFinalVerdict > 0 and (buffAvengingWrath or getHP(dynamicUnit.dyn5) < 35) then
				castDivineStorm()
			end
			-- final_verdict,if=buff.divine_purpose.react|target.health.pct<35
			if buffDivinePurpose > 0 or getHP(dynamicUnit.dyn5) < 35 then
				castTemplarsVerdict()
			end
			-- templars_verdict,if=buff.avenging_wrath.up|target.health.pct<35&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
			if buffAvengingWrath > 0 or getHP(dynamicUnit.dyn5) < 35 and (not talentSeraphim or cdSeraphim > 4) then
				castTemplarsVerdict()
			end
			-- crusader_strike
			castCrusaderStrike(dynamicUnit.dyn5)
			-- divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
			if buffDivineCrusader > 0 and (buffAvengingWrath > 0 or getHP(dynamicUnit.dyn5) < 35) and not talentFinalVerdict then
				castDivineStorm()
			end
			-- divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
			if buffDivineCrusader > 0 and buffFinalVerdict > 0 then
				castDivineStorm()
			end
			-- final_verdict
			if talentFinalVerdict then
				castTemplarsVerdict()
			end
			-- seal_of_righteousness,if=talent.empowered_seals.enabled&buff.liadrins_righteousness.remains<(cooldown.judgment.duration)&buff.liadrins_righteousness.remains<=3
			if talentEmpoweredSeal then
				if buffLiadrinsRighteousness < getSpellCD(_Judgment) and buffLiadrinsRighteousness <= 3 then
					castSealOfRigtheousness()
				end
			end
			-- judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled
			if glyphDoubleJeopardy then
				castJeopardy()
			end
			-- judgment
			castJudgement()
			-- templars_verdict,if=buff.divine_purpose.react
			if _DivinePurpose > 0 then
				castTemplarsVerdict()
			end
			-- divine_storm,if=buff.divine_crusader.react&!talent.final_verdict.enabled
			if buffDivineCrusader and not talentFinalVerdict then
			  	castDivineStorm()
			end
			-- templars_verdict,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
			if _HolyPower >= 4 and (not talentSeraphim or cdSeraphim > 4) then
				castTemplarsVerdict()
			end
			-- exorcism
			castExorcism()
			-- templars_verdict,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
			if _HolyPower >= 3 and (not talentSeraphim or cdSeraphim > 4) then
				castTemplarsVerdict()
			end
			-- holy_prism
			castHolyPrism(dynamicUnit.dyn40,false)
		elseif meleeAoEEnemies < 5 then
			--[[Cleave(3-4)]]
			-- final_verdict,if=buff.final_verdict.down&holy_power=5
			if talentFinalVerdict then
				if buffFinalVerdict == 0 and _HolyPower == 5 then
					castTemplarsVerdict()
				end
			end
			-- divine_storm,if=buff.divine_crusader.react&holy_power=5&buff.final_verdict.up
			if buffDivineCrusader > 0 and _HolyPower == 5 and buffFinalVerdict > 0 then
				castDivineStorm()
			end
			-- divine_storm,if=holy_power=5&buff.final_verdict.up
			if _HolyPower == 5 and buffFinalVerdict > 0 then
				castDivineStorm()
			end
			-- divine_storm,if=buff.divine_crusader.react&holy_power=5&!talent.final_verdict.enabled
			if buffDivineCrusader > 0 and _HolyPower == 5 and not talentFinalVerdict then
				castDivineStorm()
			end
			-- divine_storm,if=holy_power=5&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)&!talent.final_verdict.enabled
			if _HolyPower == 5 and (not talentSeraphim or cdSeraphim > 4) and not talentFinalVerdict then
				castDivineStorm()
			end
			-- exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
			if buffBlazingContemp > 0 and _HolyPower <= 2 and not buffHolyAvenger then
				castExorcism()
			end
			-- hammer_of_wrath
			castMultiHammerOfWrath()
			-- judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<=5
			if talentEmpoweredSeal then
				if sealOfRighteousness and buffLiadrinsRighteousness <= 5 then
					castJudgement()
				end
			end
			-- divine_storm,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>6)&!talent.final_verdict.enabled
			if _HolyPower >= 4 and (not talentSeraphim or cdSeraphim > 6) and not talentFinalVerdict then
				castDivineStorm()
			end
			-- crusader_strike
			castCrusaderStrike(dynamicUnit.dyn5)
			-- divine_storm,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>7)&!talent.final_verdict.enabled
			if _HolyPower >= 3 and (not talentSeraphim or cdSeraphim > 7) and not talentFinalVerdict then
				castDivineStorm()
			end
			-- final_verdict,if=buff.final_verdict.down
			if buffFinalVerdict == 0 then
				castTemplarsVerdict()
			else
			-- divine_storm,if=buff.final_verdict.up
				castDivineStorm()
			end
			-- holy_prism,target=self
			castHolyPrism("player",true)
			-- exorcism,if=glyph.mass_exorcism.enabled
			if glyphMassExorcism then
				castExorcism()
			end
			-- judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled
			if glyphDoubleJeopardy then
				castJeopardy()
			end
			-- judgment
			castJudgement()
			-- exorcism
			castExorcism()
		else
			--[[AoE(5+)]]
			-- divine_storm,if=holy_power=5&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
			if _HolyPower == 5 and (not talentSeraphim or cdSeraphim > 4) then
				castDivineStorm()
			end
			-- exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
			if buffBlazingContemp > 0 and _HolyPower <= 2 and buffHolyAvenger == 0 then
				castExorcism()
			end
			-- hammer_of_wrath
			castMultiHammerOfWrath()
			-- hammer_of_the_righteous
			castHammerOfTheRighteous(dynamicUnit.dyn5)
			-- judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<=5
			if talentEmpoweredSeal then
				if sealOfRighteousness and buffLiadrinsRighteousness <= 5 then
					castJudgement()
				end
			end
			-- divine_storm,if=(!talent.seraphim.enabled|cooldown.seraphim.remains>6)
			if not talentSeraphim or cdSeraphim > 6 then
				castDivineStorm()
			end
			-- exorcism,if=glyph.mass_exorcism.enabled
			if glyphMassExorcism then
				castExorcism()
			end
			-- holy_prism,target=self
			castHolyPrism("player",true)
			-- judgment,cycle_targets=1,if=last_judgment_target!=target&glyph.double_jeopardy.enabled
			if glyphDoubleJeopardy then
				castJeopardy()
			end
			-- judgment
			castJudgement()
			-- exorcism
			castExorcism()
		end
	end
end
end