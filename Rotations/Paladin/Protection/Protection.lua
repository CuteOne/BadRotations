if select(3, UnitClass("player")) == 2 then
	function PaladinProtection()
		-- Init if this is the first time we are running.
		if currentConfig ~= "Protection Gabbz & CML" then
			PaladinProtFunctions()
			PaladinProtToggles()
			PaladinProtOptions()
			currentConfig = "Protection Gabbz & CML"
		end

		-- Manual Input
		if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
			return true
		end
		--if IsLeftControlKeyDown() then -- Pause the script, keybind in wow ctrl+1 etc for manual cast
		--	return true
		--end
		if IsLeftAltKeyDown() then
			return true
		end

		if canRun() ~= true then
			return false
		end
		
		-- Only run rotation if we or our target is in combat.
		-- this should be handled by the dynamic target
		if UnitAffectingCombat("player")  or (not UnitAffectingCombat("player") and IsLeftControlKeyDown() ) then  -- Only start if we and target is in combat or not in combat and pressing left control
			-- Locals Variables
			_HolyPower = UnitPower("player", 9) --ToDo: We should normalise the variables name, playerHP, buffDivine etc. _HolyPower is not consistent with the rest.
			playerHP = getHP("player")
			buffDivineCrusader = getBuffRemain("player",_DivineCrusader)
			buffHolyAvenger = getBuffRemain("player",_HolyAvenger)
			buffDivinePurpose = getBuffRemain("player",_DivinePurpose)
			buffGrandCrusader = getBuffRemain("player",85043) --Todo: Add this to spellist as _GrandCrusader, at the moment i dont know what hte purpose is of the differnt spelllist files
			buffSeraPhim = getBuffRemain("player",_Seraphim)
			sealOfTruth = GetShapeshiftForm() == 1 or nil
			sealOfRighteousness = GetShapeshiftForm() == 2 or nil
			sealOfInsight = GetShapeshiftForm() == 3 or nil
			
			
			-- Auto attack
			if startAttackTimer == nil or startAttackTimer <= GetTime() - 1 then
				RunMacroText("/startattack")
			end

			-- function for handling units to attack
			ProtPaladinEnemyUnitHandler()
			
			ProtPaladinFriendlyUnitHandler()

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