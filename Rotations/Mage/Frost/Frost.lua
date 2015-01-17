-- Todo : When we pause BB we should make sure the pet is put on passive.
-- Todo : We need to figure out how to handle the pet, how do we set him in BB to active and passive?
-- Todo : We should not do anything OOC unless we manually overide, like with a modifier, in order to not look like a bot
-- Todo : We need to add a prepull logic that would start casting something and then, prepot
-- Todo : Falling logic, we should somewhere place Slow Fall
-- Todo : Spellsteal, not only as dispell enrages but also get buffed

if select(3, UnitClass("player")) == 8 then

	function FrostMage()
		if currentConfig ~= "Frost ragnar" then
			FrostMageConfig()
			FrostMageToggles()
			currentConfig = "Frost ragnar"
		end

		-- Pause
		if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
			ChatOverlay("|cffFF0000BadBoy Paused", 0)
			return true
		end


		-- Manual Input
		if IsLeftShiftKeyDown() or IsLeftAltKeyDown() or not canRun then -- Pause the script, keybind in wow shift+1 etc for manual cast
			return true
		end
		
		if not UnitAffectingCombat("player") and IsLeftControlKeyDown() then -- If we are OOC we can use left shift to auto prepull
			------------
			-- CHECKS --
			------------
			-- Pet active/passive
			-- check if pet is dead
			if not UnitExists("pet") and isChecked("Auto Summon Pet") then
				if castSpell("player",SummonPet,true,true) then
					return true
				end
			end
			-- Petpassive, Petagressive
			if getOptionCheck("Start/Stop BadBoy") then
				if IsPetAttackActive() == true then
					RunMacroText("/petpassive")
					return true
				end
			end
			if getOptionCheck("Start/Stop BadBoy") then
				if select(5,GetPetActionInfo(8)) == false then
					RunMacroText("/petassist")
					return true
				end
			end

			--Ice barrier should be up when solo PvE
			if not UnitBuffID("player",_IceBarrier)  then -- Ice barrier
				if castSpell("player",_IceBarrier,false,false) then 
					return true
				end
			end

			-- Todo : Buff with Arcane Brilliance on all
			if isChecked("Arcane Brilliance") then
				if not isBuffed("player", _ArcaneBrilliance)  then
					if castSpell("player", _ArcaneBrilliance,false,false) then
						return true
					end
				end
			end

		end		
		------------
		-- COMBAT --
		------------

		-- AffectingCombat, Pause, Target, Dead/Ghost Check
		if UnitAffectingCombat("player") then
			---------------
			-- Variables --
			---------------
			local dynamicUnit = {
			["dyn5"] = dynamicTarget(5,true), --Melee
			["dyn12AoE"] = dynamicTarget(12,false), -- Frost Nova
			["dyn30"] = dynamicTarget(30,true), --
			["dyn35"] = dynamicTarget(35,true), -- Deep Freeze, Blizzard
			["dyn40"] = dynamicTarget(40,true), -- SpellSteal, 
			["dyn40AoE"] = dynamicTarget(40,false), -- 
			}

			-- Get GCD Time
			local haste = GetHaste()
			local gcdTime = 1.5/(1+haste/100)

			isPlayerMoving = isMoving("player")

			--Todo 
			-- FrostMageDefensives()
			-- Interrupts
			-- Dispells
			-- FrostMageCooldowns(), ie burst logic
			
			-- Single Target Rotation
			if not isPlayerMoving then
				if castSpell(dynamicUnit.dyn40,_Frostbolt,false,false) then
					return true
				end
			end

			if isPlayerMoving then
				if castSpell(dynamicUnit.dyn40, _IceLance,false,false) then
					return true
				end
			end
		end
	end
end