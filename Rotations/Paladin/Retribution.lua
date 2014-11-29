if select(3, UnitClass("player")) == 2 then
	function PaladinRetribution()
	if currentConfig ~= "Retribution Paladin" then --Where is currentConfig set? Is this only used for init?
		--PaladinRetFunctions(); --Prot functions is SacredShield and GetHolyGen
		PaladinRetToggles() -- Setting up Toggles, AoE, Interrupt, Defensive CD, CD, Healing
		PaladinRetOptions() -- Reading Config values from gui?
		currentConfig = "Retribution Paladin"
	end
	local myTarget = "target"
	-- Locals Variables
	local _HolyPower = UnitPower("player", 9)
	local meleeEnemies = #getEnemies("player", 5) --Get number of enemies within melee range. Does this also work for large hotboxes?

	-- Food/Invis Check   Hm here we are checking if we should abort the rotation pulse due to if we are a vehicle or some stuff
	-- canRun is already checking UnitInVehicle and some other stuff im not sure about.
	if canRun() ~= true then
		return false
	end

	if UnitAffectingCombat("player") then
		-- Rebuke
		makeSpellCastersTable() 
		castRebuke(unit)

		-- Divine Protection
		if isChecked("Divine Protection") and getHP("player") <= getValue("Divine Protection") then
			if castSpell("player",_DivineProtection,true) then
				return;
			end
		end
	end

	-- GCD check
	if castingUnit() then
		return false
	end

	-- Combats Starts Here

	if isInCombat("player") then
		-- Lay on Hands
		if getHP("player") <= getValue("Lay On Hands") then
			if castSpell("player",_LayOnHands,true) then
				return
			end
		else
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Lay On Hands") then
					if castSpell(nNova[i].unit,_LayOnHands,true) then
						return
					end
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

		-- Auto Attack
		if isInMelee() and getFacing("player", myTarget) == true then
			RunMacroText("/startattack")
		end

		-- Avenging Wrath
		if isInMelee() and isSelected("Avenging Wrath") then
			if castSpell("player",_AvengingWrath,true) then 
				return 
			end
		end

		-- Holy Avenger
		if isInMelee() and isSelected("Holy Avenger") then
			if castSpell("player",_HolyAvenger,true) then 
				return
			end
		end

		-- Single/AoE switch
		local verdict = verdict
		local strike = strike
		if meleeEnemies > 2 then 
			strike = _HammerOfTheRighteous
			verdict = _DivineStorm
		else 
			strike = _CrusaderStrike
			verdict = _TemplarsVerdict
		end

		-- Verdit/DivineStorm: Dump holy power if at 5
		if _HolyPower == 5 and getDistance("player", selectedUnit) < 5 then
			if castSpell(selectedUnit, verdict, false, false) then 
				return 
			end
		end

		-- Hammer of wrath
		if getHP(selectedUnit) <= 20 or UnitBuffID("player",31884) then
			if castSpell(selectedUnit, _HammerOfWrath, false) then 
				return 
			end
		end

		-- Crusader Strike
		if getDistance("player", myTarget) < 5 then
			if castSpell(selectedUnit, strike, false, false) then 
				return 
			end
		end

		-- Judgment
		castJudgement(selectedUnit)

		-- Verdit/DivineStorm: If over 3 holy power
		if _HolyPower >= 3 and getDistance("player", myTarget) < 5 then
			if castSpell(selectedUnit, verdict, false, false) then return end
		end

		-- execution Sentence
		if isSelected("Execution Sentence") then
			if (isDummy(selectedUnit) or (UnitHealth(selectedUnit) >= 150*UnitHealthMax("player")/100)) then
				if castSpell(selectedUnit, _ExecutionSentence, false, false) then return; end
			end
		end

		-- Light's Hammer
		castLightsHammer(selectedUnit)

		-- Holy Prism
		if meleeEnemies > 2 then
			if castSpell("player",_HolyPrism,false) then 
				return 
			end
		else
			if castSpell(selectedUnit,_HolyPrism,false) then 
				return 
			end
		end
	end
end
end