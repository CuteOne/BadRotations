	--	Todos
	--  ProtPaladinDispells() -- Handling the dispelling self and party
	--  Divine Shield Taunting. ie taunt and use Divine Shield gives 3 seconds being attacked with immunity but still being fixated.
	--  Other to think about
	--  HandsLogic, including removal of debuffs via protection
	--  TankManager, including salvation on self, checking what to tank and not to tank(boss debuff forcing tank switch etc, taunting if party member is being attacked etc.

if select(3, UnitClass("player")) == 2 then
	function PaladinProtection()
		-- Init if this is the first time we are running.
		if currentConfig ~= "Protection CodeMyLife" then
			PaladinProtFunctions()
			PaladinProtToggles()
			PaladinProtOptions()
			currentConfig = "Protection CodeMyLife"
		end

		-- Todo, add this to GUI and create a sub function, should also cater for macros for manual casting
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
--		if IsRightControlKeyDown() then
--		end
--		if IsRightShiftKeyDown() then
--		end
--		if IsRightAltKeyDown() then
--		end
--		if IsMouseButtonDown(1) then -- Mousebutton 1-5
--		end
		
		-- Set Global variables that will be used.
		_HolyPower = UnitPower("player", 9)

		-- Check if we should run the rotation
		if canRun() ~= true then
			return false
		end

		-- Only run rotation if we or our target is in combat.
		if UnitAffectingCombat("player") then

			--Todo SpecialEvent, checks if there is something that are special that we need to handle
			-- Auto attack
			if startAttackTimer == nil or startAttackTimer <= GetTime() - 1 then
				RunMacroText("/startattack")
			end

			ProtPaladinEnemyUnitHandler() -- Fetch information about enemy units
			ProtPaladinFriendlyUnitHandler() --Fetch and handle friendly units information

			-- If we are close to dying
			if ProtPaladinSurvivalSelf() then -- Check if we are close to dying and act accoridingly
				return true
			end

			-- If someone else is close to dying
			if ProtPaladinSurvivalOther() then -- Check if raidmember are close to dying and act accoridingly
				return
			end

			-- Interrupt
			if ProtPaladinInterrupt() then
				return true
			end

			-- Dispell Logics Todo, includes removal using Divine Shield and Hand of Protection
			if ProtPaladinDispell() then
				return true
			end

			-- If we are already casting then dont continue
			if castingUnit() then
				return false
			end
			
			if ProtPaladinControl("target") then
				return true
			end

			if ProtPaladinUtility() then
				--print("Casting Utility spell")
				return true
			end

			-- Check if we are missing any buffs
			if ProtPaladinBuffs() then -- Make sure that we are buffed, 2 modes, inCombat and Out Of Combat, Blessings, RF,
				return true
			end

			-- Casting SS here for the time being, should be part of something earlier such as buffs or survival
			if castSacredShield(3) then
				return true
			end
			--Todo Check number of targets in range do Concentration and have it earlier.

			-- Handle the use of HolyPower
			if ProtPaladinHolyPowerConsumers() then
				-- Dont return since this is off GCD
				--print("We use HoPo now")
			end

			if ProtPaladinHolyPowerCreaters() then -- Handle the normal rotation
				--print("Something is cast within PowerCreaters")
				return true
			end
			--print("We did not do anything")
		end
	end
end