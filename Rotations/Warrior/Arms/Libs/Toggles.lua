if select(3, UnitClass("player")) == 1 and GetSpecialization() == 1 then

	function WarriorArmsToggles()

		-- Defensive Button
		if DefensiveModesLoaded ~= "Arms Warrior Defensive Modes" then
			CustomDefensiveModes = {
				[1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = 118038 },
				[2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = 118038 }
			};
			DefensiveModes = CustomDefensiveModes
			CreateButton("Defensive",1,0)
			DefensiveModesLoaded = "Arms Warrior Defensive Modes";
		end

		-- Boss Helper Button
		if BossHelperModesLoaded ~= "Arms Warrior Boss Helper Modes" then
			BossHelperModes = {
				[1] = { mode = "off", value = 1, overlay = "Boss Helper Disabled", tip = "|cffFF0000Boss Helper \n|cffFFDD11Boss Helper inactive.", highlight = 0, icon = 15031 },
				[2] = { mode = "on", value = 2, overlay = "Boss Helper Enabled", tip = "|cff00FF00Boss Helper \n|cffFFDD11Boss Helper activated.", highlight = 1, icon = 15031 }
			};
			CreateButton("BossHelper",2,0)
			BossHelperModesLoaded = "Arms Warrior Boss Helper Modes";
		end

		-- Cooldowns Button
		if CooldownsModesLoaded ~= "Arms Warrior Cooldown Modes" then
			CustomCooldownsModes = {
				[1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = 1719 },
				[2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = 1719 },
				[3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = 1719 }
			};
			CooldownsModes = CustomCooldownsModes
			CreateButton("Cooldowns",3,0)
			CooldownsModesLoaded = "Arms Warrior Cooldown Modes";
		end

		-- AoE
		if AoEModesLoaded ~= "Arms Warrior AoE Modes" then
			CustomAoEModes = {
				[1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = 157461 },
				[2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = 1680 },
				[3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = 12294 }
			};
			AoEModes = CustomAoEModes
			CreateButton("AoE",4,0)
			AoEModesLoaded = "Arms Warrior AoE Modes";
		end
	end -- END TOGGLES




	-- handle specific toggles
	function SpecificToggle(toggle)
		if getValue(toggle) == 1 then
			return IsLeftControlKeyDown();
		elseif getValue(toggle) == 2 then
			return IsLeftShiftKeyDown();
		elseif getValue(toggle) == 3 then
			return IsLeftAltKeyDown();
		elseif getValue(toggle) == 4 then
			return IsRightControlKeyDown();
		elseif getValue(toggle) == 5 then
			return IsRightShiftKeyDown();
		elseif getValue(toggle) == 6 then
			return IsRightAltKeyDown();
		elseif getValue(toggle) == 7 then
			return 1
		end
	end
end