if select(3, UnitClass("player")) == 2 then
	function PaladinRetribution()
	-- Init Protection specific funnctions, toggles and configs.
		if currentConfig ~= "Retribution CodeMyLife" then --Where is currentConfig set? Is this only used for init?
			PaladinRetFunctions(); --Prot functions is SacredShield and GetHolyGen
			PaladinRetToggles(); -- Setting up Toggles, AoE, Interrupt, Defensive CD, CD, Healing
			PaladinRetConfig(); -- Reading Config values from gui?
			currentConfig = "Retribution CodeMyLife";
		end

	-- Locals Variables
	local _HolyPower = UnitPower("player", 9);
	local numEnemies = numEnemies;  --Why are we declaring this? Should we not initialise? Its not a global variables so it will be overwritten each time?
	local meleeEnemies = getNumEnemies("player",4); --Get number of enemies within melee range. Does this also work for large hotboxes?
	
	if getDistance("player","target") < 25 then   --Do not understand this, why are we not just getting TargetProximityTargets and PlayerProximityTargets?
		numEnemies = getNumEnemies("target",10);
	else
		numEnemies = getNumEnemies("player",10);
	end

	-- Food/Invis Check   Hm here we are checking if we should abort the rotation pulse due to if we are a vehicle or some stuff
	-- canRun is already checking UnitInVehicle and some other stuff im not sure about.
	if canRun() ~= true or UnitInVehicle("Player") then 
		return false; 
	end
	
	if IsMounted("player") then  --canRun is already checking for mounted and we will not get here.
		waitForPetToAppear = nil;  --Why? Is this from hunter rotation? What pet are we waiting for?
		return false; 
	end

	if UnitAffectingCombat("player") then
		-- Rebuke
		if isChecked("Rebuke") then --Hm we have InterruptsModes from Prot Toggles, why are we checking for Rebuke? There are more ways to interrupt then Rebuke.
			if canInterrupt(_Rebuke, tonumber(BadBoy_data["Box Rebuke"])) and getDistance("player","target") <= 4 then  --We are checking for 4 but rebuke have 5 yards range?
				castSpell("target",_Rebuke,false);
				-- Other interrupts are, binding light, Fist of Justice, Which have different ranges.
				--Should we not return if successful? castSpell returns either true or false
			end
		end
		--Here comes defensive CDs, however we are not checking if we have already done one CD, only checking for HP, should add check for other CDs timers.
		-- Also in the toggles there is a DefensiveModes table, are we not using this?
		 -- Missing LayOnHands and Divine Shield, also perhaps Avenging Wrath for increased self healing.
		-- Ardent Defender
		if BadBoy_data["Check Ardent Defender"] == 1 and getHP("player") <= BadBoy_data["Box Ardent Defender"] then
			if castSpell("player",_ArdentDefender,true) then 
				return;  --Here we return as we should
			end
		end
		-- Divine Protection
		if BadBoy_data["Check Divine Protection"] == 1 and getHP("player") <= BadBoy_data["Box Divine Protection"] then -- Should we check if damage is physical?
			if castSpell("player",_DivineProtection,true) then 
				return; 
			end
		end
	end --We are we stopping the incombat check here?


--[[ 	-- On GCD After here
]]

	if isCasting() then 
		return false; 
	end

	-- Seal logic, should be a Paladin function for easier to read code.
	--  it seems regardless if seal = 1 or 2 we cast seal of insight?
	-- if isChecked("Seal") then
	-- 	local seal = getValue("Seal");
 -- 		if seal == 1 then 
 -- 			if GetShapeshiftForm() ~= 3 then 
 -- 				if castSpell("player",_SealOfInsight,true) then 
	-- 				return; 
	-- 			end 
 -- 			end 
 -- 		end
	-- 	if seal == 2 then 
	-- 		if GetShapeshiftForm() ~= 1 then 
 -- 				if castSpell("player",_SealOfInsight,true) then --Should be changed to SealOfTruth
	-- 				return; 
	-- 			end 
	-- 		end 
	-- 	end
	-- 	if seal == 3 then
	-- 		if getHP("player") < 50 then 
	-- 			if GetShapeshiftForm() ~= 3 then 
 -- 					if castSpell("player",_SealOfInsight,true) then return; end 
	-- 			end 
	-- 		elseif getHP("player") > 60 and numEnemies < 3 then 
	-- 			if GetShapeshiftForm() ~= 1 then 
 -- 					if castSpell("player",_SealOfThruth,true) then return; end 
	-- 			end 
	-- 		elseif getHP("player") > 60 and GetShapeshiftForm() ~= 2 then 
 -- 				if castSpell("player",_SealOfRighteousness,true) then return; end 
	-- 		end
	-- 	end
	-- end


--[[ 	-- Combats Starts Here
]]
	-- Hm we already had that check before? Why is the code above not incombat valid?
	if isInCombat("player") then
		-- Lay on Hands
		-- This should be moved to Defensive CDs
		if getHP("player") <= getValue("Lay On Hands") then
			if castSpell("player",_LayOnHands,true) then 
				return; 
			end
			-- If we dont need Lay of Hands, check if the raid needs.
			-- Should be careful, if its a tank we in some cases do not want to give them forebarance?
		elseif nNova[1].hp <= getValue("Lay On Hands") then
			if castSpell(nNova[1].unit,_LayOnHands,true) then 
				return; 
			end
		end

		-- Eternal Flame/Word Of Glory
		if isKnown(_EternalFlame) then
			if getHP("player") <= getValue("Self Flame") and not UnitBuffID("player",_EternalFlame) then
				if castSpell("player",_EternalFlame,true) then 
					return; 
				end
			elseif nNova[1].hp <= getValue("Eternal Flame") then --we do not check if we are supposed to heal party here.
				if castSpell(nNova[1].unit,_EternalFlame,true) and not UnitBuffID(nNova[1].unit,_EternalFlame) then 
					return; 
				end
			end
		else
			if getHP("player") <= getValue("Self Glory") and getBuffStacks("player",114637) > 3 then
				if castSpell("player",_WordOfGlory,true) then 
					return; 
				end
			elseif nNova[1].hp <= getValue("Word Of Glory") then
				if castSpell(nNova[1].unit,_WordOfGlory,true) then 
					return; 
				end
			end
		end

		-- sacred_shield,if=talent.sacred_shield.enabled
		if isKnown(_SacredShield) then
			if isChecked("Sacred Shield") and UnitBuffID("player",_SacredShield) == nil then
				if castSpell("player",_SacredShield,true) then return; end
			end	
		end

		-- auto_attack
		if isInMelee() and getFacing("player","target") == true then
			RunMacroText("/startattack");
		end

		-- blood_fury
		-- berserking
		-- arcane_torrent

		-- avenging_wrath
		if isInMelee() and isSelected("Avenging Wrath") then
			if castSpell("player",_AvengingWrath,true) then return; end
		end

		-- holy_avenger,if=talent.holy_avenger.enabled
		if isInMelee() and isSelected("Holy Avenger") then
			if castSpell("player",_HolyAvenger,true) then return; end
		end		

		-- judgment,if=talent.sanctified_wrath.enabled&buff.avenging_wrath.react

		-- wait,sec=cooldown.judgment.remains,if=talent.sanctified_wrath.enabled&cooldown.judgment.remains>0&cooldown.judgment.remains<=0.5


		local strike = strike;
		if BadBoy_data["AoE"] == 3 or meleeEnemies > 2 then strike = _HammerOfTheRighteous; else strike = _CrusaderStrike; end
		-- crusader_strike
		if isInMelee() then
			if castSpell("target",strike,false) then return; end
		else
			for i = 1, GetTotalObjects(TYPE_UNIT) do
				local Guid = IGetObjectListEntry(i)
				ISetAsUnitID(Guid,"thisUnit");
				if getFacing("player","thisUnit") == true
				  and isInMelee("thisUnit") then
					if castSpell("thisUnit",strike,false) then return; end								
				end
			end
		end				

		-- wait,sec=cooldown.crusader_strike.remains,if=cooldown.crusader_strike.remains>0&cooldown.crusader_strike.remains<=0.5
		-- judgment
		if canCast(_Judgment) and getDistance("player","target") <= 30 then
			if castSpell("target",_Judgment,true) then return; end
		elseif canCast(_Judgment) then
			for i = 1, GetTotalObjects(TYPE_UNIT) do
				local Guid = IGetObjectListEntry(i)
				ISetAsUnitID(Guid,"thisUnit");
				if getDistance("player","thisUnit") <= 30 then
					if castSpell("thisUnit",_Judgment,true) then return; end								
				end
			end
		end	
		
		-- wait,sec=cooldown.judgment.remains,if=cooldown.judgment.remains>0&cooldown.judgment.remains<=0.5&(cooldown.crusader_strike.remains-cooldown.judgment.remains)>=0.5
		if GetHolyGen() == true then return; end

		-- execution_sentence,if=talent.execution_sentence.enabled
		if isSelected("Execution Sentence") then
			if (isDummy("target") or (UnitHealth("target") >= 150*UnitHealthMax("player")/100)) then
				if castSpell("target",_ExecutionSentence,false) then return; end
			end
		end		
		
		-- lights_hammer,if=talent.lights_hammer.enabled
		if isSelected("Light's Hammer") then
			if getGround("target") == true and isMoving("target") == false and UnitExists("target") and (isDummy("target") or getDistance("target","targettarget") <= 5) then
				if castGround("target",_LightsHammer,30) then return; end
			end
		end

		-- hammer_of_wrath
		if canCast(_HammerOfWrath) and getLineOfSight("player","target") and getDistance("player","target") <= 30 and getHP("target") <= 20 then
			if castSpell("target",_HammerOfWrath,false) then return; end
		elseif canCast(_HammerOfWrath) then
			for i = 1, GetTotalObjects(TYPE_UNIT) do
				local Guid = IGetObjectListEntry(i)
				ISetAsUnitID(Guid,"thisUnit");
				if getHP("thisUnit") <= 20 and getLineOfSight("player","thisUnit") and getDistance("player","thisUnit") < 30 and getFacing("player","thisUnit") == true then
					if castSpell("thisUnit",_HammerOfWrath,false) then return; end								
				end
			end			
		end

		-- holy_prism,if=talent.holy_prism.enabled
		if numEnemies > 1 then
			if castSpell("player",_HolyPrism,false) then return; end
		else
			if castSpell("target",_HolyPrism,false) then return; end
		end
	end
end
end