if select(3, UnitClass("player")) == 2 then
	function PaladinRetribution()
	if currentConfig ~= "Retribution Paladin" then --Where is currentConfig set? Is this only used for init?
		--PaladinRetFunctions(); --Prot functions is SacredShield and GetHolyGen
		PaladinRetToggles() -- Setting up Toggles, AoE, Interrupt, Defensive CD, CD, Healing
		PaladinRetOptions() -- Reading Config values from gui?
		currentConfig = "Retribution Paladin"
	end

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
	_HolyPower = UnitPower("player",9)
	-- Gabbz:Get number of enemies within melee range. Does this also work for large hotboxes?
	-- CML:Last time i did test with it i was able to test range from a mob to sha
	-- with a -3 yard precision under 10 yard
	local buffDivineCrusader = getBuffRemain("player",_DivineCrusader)
	local buffHolyAvenger = getBuffRemain("player",_HolyAvenger)
	local buffDivinePurpose = getBuffRemain("player",_DivinePurpose)
	local buffFinalVerdict = getBuffRemain("player",_FinalVerdict)
	local buffSeraPhim = getBuffRemain("player",_Seraphim)
	local buffBlazingContemp = IsSpellOverlayed(122032)
	local buffAvengingWrath = getBuffRemain("player",_AvengingWrath)
	local buffLiadrinsRighteousness = getBuffRemain("player",156989)
	local buffMaraadsTruth = getBuffRemain("player",156990)
	local cdAvengingWrath = getSpellCD(_AvengingWrath)
	local cdSeraphim = getSpellCD(_Seraphim)
	local glyphMassExorcism = hasGlyph(122028)
	local glyphDoubleJeopardy = hasGlyph(54922)
	local meleeEnemies = #getEnemies("player",5)
	local meleeAoEEnemies = meleeEnemies
	local meleeAoEEnemies = #getEnemies("player",8)
	if buffFinalVerdict then
		meleeAoEEnemies = #getEnemies("player",16)
	end
	local modeAoE = BadBoy_data["AoE"]
	local modeCooldown = BadBoy_data["Cooldowns"]
	local modeDefense = BadBoy_data["Defensive"]
	local modeHealing = BadBoy_data["Healing"]
	local playerHealth = getHP("player")
	local sealOfTruth = GetShapeshiftForm() == 1 or nil
	local sealOfRighteousness = GetShapeshiftForm() == 2 or nil
	local talentEmpoweredSeal = isKnown(152263)
	local talentFinalVerdict = isKnown(_FinalVerdict)
	local talentSeraphim = isKnown(_Seraphim) and isSelected("Seraphim")

	-- this is to get judgment spell cd duration, we query GetSpellCooldown but since its returning 1
	-- when spells are on cd, we will take out bad values trough this funtion
	local cdCheckJudgment = select(2,GetSpellCooldown(_Judgment))
	-- the first time before the very first judgment we will take into account 4.5s
	if cdDurationJudgment == nil then
		cdDurationJudgment = 4.5
	end
	-- after first judgment we begin to store the variable we need and overwrite it each time it changes
	if cdCheckJudgment ~= nil and cdCheckJudgment > 2 and cdCheckJudgment ~= cdDurationJudgment then
		cdDurationJudgment = cdCheckJudgment
	end

	local cdJudgment = getSpellCD(_Judgment)


	-- Food/Invis Check
	-- Gabbz:Hm here we are checking if we should abort the rotation pulse due to if we are a vehicle or some stuff
	-- CML:Can find this function atop general funcs
	if canRun() ~= true then
		return false
	end

	-- Cast selected blessing or auto
	castBlessing()

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
		--castLayOnHands()
		-- Divine Shield
		if (isChecked("Divine Shield") and modeDefense == 2) or modeDefense == 3 then
			castDivineShield(playerHealth)
		end
		-- Selfless Healer
		if isChecked("Selfless Healer") then
			castSelfLessHealer(playerHealth)
		end
		-- Self Glory
		if isChecked("Self Glory") then
			castWordOfGlory("player",getValue("Self Glory"),3)
		end
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
		--if buffAvengingWrath > 0 or not isSelected("Avenging Wrath") or cdAvengingWrath > 15 then
			if castLightsHammer(dynamicUnit.dyn30AoE) then
				return
			end
		--end
		-- Holy Avenger
		castHolyAvenger(_HolyPower)
		-- Avenging Wrath
		castAvengingWrath()
		-- holy_prism 2+
		if #getEnemies("player",15) > 1 then
			if castHolyPrism("player",false) then
				return
			end
		end
		-- seraphim
		castSeraphim(_HolyPower)
		--[[Single(1-2)]]
----------------
-- Single 1-2 --
----------------
		if (meleeAoEEnemies < 3  and modeAoE == 4) or modeAoE == 1 then
			-- divine_storm,if=buff.divine_crusader.react&holy_power=5&buff.final_verdict.up
			if (buffDivineCrusader > 0 and _HolyPower == 5 and buffFinalVerdict > 0)
			  -- divine_storm,if=buff.divine_crusader.react&holy_power=5&active_enemies=2&!talent.final_verdict.enabled
			  or (buffDivineCrusader > 0 and _HolyPower == 5 and meleeAoEEnemies == 2 and not talentFinalVerdict)
			  -- divine_storm,if=holy_power=5&active_enemies=2&buff.final_verdict.up
			  or (_HolyPower == 5 and meleeAoEEnemies == 2 and buffFinalVerdict > 0)
			  -- divine_storm,if=buff.divine_crusader.react&holy_power=5&(talent.seraphim.enabled&cooldown.seraphim.remains<=4)
			  or (_HolyPower == 5 and meleeAoEEnemies == 2 and talentSeraphim and cdSeraphim <= 4) then
			  	if castDivineStorm() then
			  		return
			  	end
			end
			-- templars_verdict,if=holy_power=5|buff.holy_avenger.up&holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
			if _HolyPower == 5
			  or ((buffHolyAvenger > 0 and _HolyPower >= 3) and (not talentSeraphim or cdSeraphim > 4))
			  -- templars_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<4
			  or (buffDivinePurpose > 0 and buffDivinePurpose < 4) then
			  	if castTemplarsVerdict() then
			  		return
			  	end
			end
			-- divine_storm,if=buff.divine_crusader.react&buff.divine_crusader.remains<4&!talent.final_verdict.enabled
			if buffDivineCrusader > 0 and buffDivineCrusader < 4 and not talentFinalVerdict then
			  	if castDivineStorm() then
			  		return
			  	end
			end
			if talentFinalVerdict
			  -- final_verdict,if=holy_power=5|buff.holy_avenger.up&holy_power>=3
			 and (_HolyPower == 5 or (buffHolyAvenger > 1 and _HolyPower >= 3)
			  -- final_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<4
			  or (buffDivinePurpose > 0 and buffDivinePurpose < 4)) then
			  	if castTemplarsVerdict() then
			  		return
			  	end
			end
			-- hammer_of_wrath
			if castHammerOfWrathMulti() then
				return
			end
			-- templars verdict to dump holy power if avenging wrath up
			if _HolyPower >= 4 and buffAvengingWrath > 0 then
				if castTemplarsVerdict() then
					return
				end
			end
			-- judgment,if=talent.empowered_seals.enabled&((seal.truth&buff.maraads_truth.remains<cooldown.judgment.duration*2)
			if talentEmpoweredSeal then
				if (sealOfTruth and buffMaraadsTruth < cdDurationJudgment*2)
				  -- |(seal.righteousness&buff.liadrins_righteousness.remains<cooldown.judgment.duration*2))
				  or (sealOfRighteousness and buffLiadrinsRighteousness < cdDurationJudgment*2) then
				  	if castJudgement() then
				  		--print("!??")
				  		return
				  	end
				end
			end
			-- exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
			if buffBlazingContemp and _HolyPower <= 2 then
				if castExorcism(dynamicUnit.dyn30) then
					return
				end
			end
			-- seal_of_truth,if=talent.empowered_seals.enabled&buff.maraads_truth.remains<(cooldown.judgment.duration)&buff.maraads_truth.remains<=3
			if talentEmpoweredSeal then
				if not sealOfTruth and buffMaraadsTruth < cdDurationJudgment and cdJudgment <= 3 then
					if castSealOfTruth() then
						return
					end
				end
			end
			-- divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
			if buffDivineCrusader > 0 and buffFinalVerdict > 0 and (buffAvengingWrath > 0 or getHP(dynamicUnit.dyn5) < 35) then
				if castDivineStorm() then
					return
				end
			end
			-- final_verdict,if=buff.divine_purpose.react|target.health.pct<35
			if talentFinalVerdict and buffDivinePurpose > 0 or getHP(dynamicUnit.dyn5) < 35 then
				if castTemplarsVerdict() then
					return
				end
			end
			-- templars_verdict,if=buff.avenging_wrath.up|target.health.pct<35&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
			if (buffAvengingWrath > 0 or getHP(dynamicUnit.dyn5) < 35) and (not talentSeraphim or cdSeraphim > 4) then
				if castTemplarsVerdict() then
					return
				end
			end
			-- crusader_strike
			-- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
			if castCrusaderStrike(dynamicUnit.dyn5) then
				return
			end
			-- divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
			if buffDivineCrusader > 0 and (buffAvengingWrath > 0 or getHP(dynamicUnit.dyn5) < 35) and not talentFinalVerdict then
				if castDivineStorm() then
					return
				end
			end
			-- divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
			if buffDivineCrusader > 0 and buffFinalVerdict > 0 then
				if castDivineStorm() then
					return
				end
			end
			-- final_verdict
			if talentFinalVerdict then
				if castTemplarsVerdict() then
					return
				end
			end
			-- seal_of_righteousness,if=talent.empowered_seals.enabled&buff.liadrins_righteousness.remains<(cooldown.judgment.duration)&buff.liadrins_righteousness.remains<=3
			if talentEmpoweredSeal then
				if not sealOfRighteousness and buffLiadrinsRighteousness < cdDurationJudgment and cdJudgment <= 3 then
					if castSealOfRigtheousness() then
						return
					end
				end
			end
			-- judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled
			if glyphDoubleJeopardy then
				if castJeopardy() then
					return
				end
			end
			-- judgment
			castJudgement()
			-- templars_verdict,if=buff.divine_purpose.react
			if buffDivinePurpose > 0 then
				if castTemplarsVerdict() then
					return
				end
			end
			-- divine_storm,if=buff.divine_crusader.react&!talent.final_verdict.enabled
			if buffDivineCrusader > 0 and not talentFinalVerdict and (not talentSeraphim or cdSeraphim < 4) then
			  	if castDivineStorm() then
			  		return
			  	end
			end
			-- templars_verdict,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
			if _HolyPower >= 4 and (not talentSeraphim or cdSeraphim > 4) then
				if castTemplarsVerdict() then
					return
				end
			end
			-- exorcism
			if castExorcism() then
				return
			end
			-- templars_verdict,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
			if _HolyPower >= 3 and (not talentSeraphim or cdSeraphim > 4) then
				if castTemplarsVerdict() then
					return
				end
			end
			-- holy_prism 1
			if castHolyPrism(dynamicUnit.dyn40,false) then
				return
			end
			-- seal fillers
			if talentEmpoweredSeal then
				if not sealOfTruth and buffMaraadsTruth < 7 then
					if castSealOfTruth() then
						return
					end
				end
				if not sealOfRighteousness and buffLiadrinsRighteousness < 7 then
					if castSealOfRigtheousness() then
						return
					end
				end
			end
----------------
-- Cleave 3-4 --
----------------
		elseif (meleeAoEEnemies < 5  and modeAoE == 4) or modeAoE == 2 then
			--[[Cleave(3-4)]]
			-- final_verdict,if=buff.final_verdict.down&holy_power=5
			if talentFinalVerdict then
				if buffFinalVerdict == 0 and _HolyPower == 5 then
					if castTemplarsVerdict() then
						return
					end
				end
			end
			-- divine_storm,if=buff.divine_crusader.react&holy_power=5&buff.final_verdict.up
			if buffDivineCrusader > 0 and _HolyPower == 5 and buffFinalVerdict > 0 then
				if castDivineStorm() then
					return
				end
			end
			-- divine_storm,if=holy_power=5&buff.final_verdict.up
			if _HolyPower == 5 and buffFinalVerdict > 0 then
				if castDivineStorm() then
					return
				end
			end
			-- divine_storm,if=buff.divine_crusader.react&holy_power=5&!talent.final_verdict.enabled
			if buffDivineCrusader > 0 and _HolyPower == 5 and not talentFinalVerdict then
				if castDivineStorm() then
					return
				end
			end
			-- divine_storm,if=holy_power=5&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)&!talent.final_verdict.enabled
			if _HolyPower == 5 and (not talentSeraphim or cdSeraphim > 4) and not talentFinalVerdict then
				if castDivineStorm() then
					return
				end
			end
			-- exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
			if buffBlazingContemp and _HolyPower <= 2 and buffHolyAvenger == 0 then
				if castExorcism() then
					return
				end
			end
			-- hammer_of_wrath
			castHammerOfWrathMulti()
			-- judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<=5
			if talentEmpoweredSeal then
				if sealOfRighteousness and buffLiadrinsRighteousness <= 5 then
					if castJudgement() then
						return
					end
				end
			end
			-- divine_storm,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>6)&!talent.final_verdict.enabled
			if _HolyPower >= 4 and (not talentSeraphim or cdSeraphim > 6) and not talentFinalVerdict then
				if castDivineStorm() then
					return
				end
			end
			-- crusader_strike
			-- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
			--castStrike()
			if castHammerOfTheRighteous(dynamicUnit.dyn5) then
				return
			end

			-- divine_storm,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>7)&!talent.final_verdict.enabled
			if _HolyPower >= 3 and (not talentSeraphim or cdSeraphim > 7) and not talentFinalVerdict then
				if castDivineStorm() then
					return
				end
			end
			-- final_verdict,if=buff.final_verdict.down
			if buffFinalVerdict == 0 then
				if castTemplarsVerdict() then
					return
				end
			-- divine_storm,if=buff.final_verdict.up
			elseif castDivineStorm() then
				return
			end
			-- holy_prism,target=self
			if castHolyPrism("player",true) then
				return
			end
			-- exorcism,if=glyph.mass_exorcism.enabled
			if glyphMassExorcism then
				if castExorcism() then
					return
				end
			end
			-- judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled
			if glyphDoubleJeopardy then
				if castJeopardy() then
					return
				end
			end
			-- judgment
			if castJudgement() then
				return
			end
			-- exorcism
			if castExorcism() then
				return
			end
------------
-- AoE 5+ --
------------
		elseif (meleeAoEEnemies >= 5 and modeAoE == 4) or modeAoE == 3 then
			--[[AoE(5+)]]
			-- divine_storm,if=holy_power=5&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
			if _HolyPower == 5 and (not talentSeraphim or cdSeraphim > 4) then
				if castDivineStorm() then
					return
				end
			end
			-- exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
			if buffBlazingContemp and _HolyPower <= 2 and buffHolyAvenger == 0 then
				if castExorcism() then
					return
				end
			end
			-- hammer_of_wrath
			if castHammerOfWrathMulti() then
				return
			end
			-- hammer_of_the_righteous
			-- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
			if castHammerOfTheRighteous(dynamicUnit.dyn5) then
				return true
			end

			-- judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<=5
			if talentEmpoweredSeal then
				if sealOfRighteousness and buffLiadrinsRighteousness <= 5 then
					if castJudgement() then
						return
					end
				end
			end
			-- divine_storm,if=(!talent.seraphim.enabled|cooldown.seraphim.remains>6)
			if not talentSeraphim or cdSeraphim > 6 then
				if castDivineStorm() then
					return
				end
			end
			-- exorcism,if=glyph.mass_exorcism.enabled
			if glyphMassExorcism then
				if castExorcism() then
					return
				end
			end
			-- holy_prism,target=self
			if castHolyPrism("player",true) then
				return
			end
			-- judgment,cycle_targets=1,if=last_judgment_target!=target&glyph.double_jeopardy.enabled
			if glyphDoubleJeopardy then
				if castJeopardy() then
					return
				end
			end
			-- judgment
			if castJudgement() then
				return
			end
			-- exorcism
			if castExorcism() then
				return
			end
		end
	end
end
end