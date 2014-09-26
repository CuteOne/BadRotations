if select(3, UnitClass("player")) == 2 then
	function PaladinProtection()
	-- Init Protection specific funnctions, toggles and configs.
		if currentConfig ~= "Protection CodeMyLife" then --Where is currentConfig set? Is this only used for init?
			PaladinProtFunctions(); --Prot functions is SacredShield and GetHolyGen
			PaladinProtToggles(); -- Setting up Toggles, AoE, Interrupt, Defensive CD, CD, Healing
			PaladinProtOptions(); -- Reading Config values from gui?
			currentConfig = "Protection CodeMyLife";
		end

		-- Locals Variables
		_HolyPower = UnitPower("player", 9);
		-- Aoe Affects
		-- Concentration, around player X yards
		-- Holy Wrath, 10 yards, but divided so only max damage regarldess how many
		-- Hammer Of Righteous, 8 yards from the target
		-- Blinding Light 10 yards from player
		-- Lights hammer 10 yards around groundarea
		-- Holy Prism If target ally, give damage 15 yards from ally, if on enemy heal 15 yards around target
		
		--Get 
		numberOfTargetsMelee = getNumEnnemies("player",4); --Get number of enemies within melee range. Does this also work for large hotboxes?
		--numberOfTargetsAroundTarget = getNumEnnemies("target",10);
		--numberOfTargetsTenYards = getNumEnnemies("player",10);
		numberOfTargetsHolyPrismDamage = getNumEnnemies("player",15);
		
		-- canRun is already checking UnitInVehicle and some other stuff im not sure about.
		if canRun() ~= true then 
			return false; 
		end

		if UnitAffectingCombat("player") then
		--	Todos
		-- ProtPaladinDispells() -- Handling the dispelling self and party
		-- Divine Shield Taunting. ie taunt and use Divine Shield gives 3 seconds being attacked with immunity but still being fixated.
		-- Other to think about
		-- HandsLogic, including removal of debuffs via protection
		-- TankManager, including salvation on self, checking what to tank and not to tank(boss debuff forcing tank switch etc, taunting if party member is being attacked etc.
		
			-- If we are close to dying
			if ProtPaladinSurvivalSelf() then -- Check if we are close to dying and act accoridingly
				return -- This is perhaps not true since some of this are not on GCD?
			end
			-- If someone else is close to dying
			if ProtPaladinSurvivalOther() then -- Check if raidmember are close to dying and act accoridingly
				return
			end
			
			-- Interrupt 
			if BadBoy_data["Interrupts"] ~= 1 then -- If value are something else then None
				if ProtPaladinInterrupt() then 
					return; -- Quit rotation if we succesfully cast a spell
				end 
			end
			
			-- Wrong place but if we are casting dont interuppt
			if isCasting() then -- This needs to be investigated, where should we stop an cast or not
				return false; 
			end
			
			-- auto_attack
			if isInMelee() and getFacing("player","target") == true then
				RunMacroText("/startattack");
			end
		
			-- Check if we are missing any buffs
			if ProtPaladinBuffs() then -- Make sure that we are buffed, 2 modes, inCombat and Out Of Combat, Blessings, RF, 
				return; -- We are missing functionality regarding blessings here
			end
		
			-- Seal logic
			if BadBoy_data["Check Seal"] == 1 then 
				if ProtPaladinSealLogic() then 
					return;
				end 
			end
			
			if ProtPaladinOffensiveCooldowns() then -- Handles the use of offensive Coolsdowns, ProtPaladinSurvival... handles the defensive.
				return
			end			

			-- Handle the use of HolyPower
			if ProtPaladinHolyPowerConsumers() then
			end
		
			if ProtPaladingHolyPowerCreaters() then -- Handle the normal rotation including not createers
				return
			end
		end
	end
end