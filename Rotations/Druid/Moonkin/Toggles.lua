if select(3, UnitClass("player")) == 11 then
	function MoonkinToggles()

		-- Defensive Button
		if DefensiveModesLoaded ~= "Boomkin Defensive Modes" then
			DefensiveModes = {
				[1] = { mode = "off", value = 1, overlay = "Defensive Disabled", tip = "|cffFF0000Defensive \n|cffFFDD11No Defensive Cooldowns will be used.", highlight = 0, icon = 774 },
				[2] = { mode = "on", value = 2, overlay = "Defensive Enabled", tip = "|cff00FF00Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Rejuvenation \nHealing Touch", highlight = 1, icon = 774 }
			};
			CreateButton("Defensive",1,0)
			DefensiveModesLoaded = "Boomkin Defensive Modes";
		end

		-- DoT Button
		if DoTModesLoaded ~= "Boomkin DoT Modes" then
			DoTModes = {
				[1] = { mode = "off", value = 1 , overlay = "DotEmAll off", tip = "|cffFF0000Multidot off \n|cffFFDD11No multidotting.", highlight = 0, icon = [[INTERFACE\ICONS\achievement_doublerainbow]] },
				[2] = { mode = "on", value = 2 , overlay = "DotEmAll", tip = "|cff00FF00Multidot on \n|cffFFDD11Dots all Targets with Moonfire & Sunfire.\nSet minimum health and maxTargets in Options", highlight = 1, icon = [[INTERFACE\ICONS\achievement_doublerainbow]] }
			};
			CreateButton("DoT",2,0)
			DoTModesLoaded = "Boomkin DoT Modes";
		end

		-- Boss Helper Button
		if BossHelperModesLoaded ~= "Boomkin Boss Helper Modes" then
			BossHelperModes = {
				[1] = { mode = "off", value = 1, overlay = "Boss Helper Disabled", tip = "|cffFF0000Boss Helper \n|cffFFDD11Boss Helper inactive.", highlight = 0, icon = 15031 },
				[2] = { mode = "on", value = 2, overlay = "Boss Helper Enabled", tip = "|cff00FF00Boss Helper \n|cffFF0000Boss Helper activated.", highlight = 1, icon = 15031 }
			};
			CreateButton("BossHelper",3,0)
			BossHelperModesLoaded = "Boomkin Boss Helper Modes";
		end

		-- Starfall Button
		if StarfallModesLoaded ~= "Boomkin Starfall Modes" then
			StarfallModes = {
				[1] = { mode = "off", value = 1, overlay = "Starfall Disabled", tip = "|cffFF0000Starfall \n|cffFFDD11Starfall inactive.", highlight = 0, icon = 48505 },
				[2] = { mode = "on", value = 2, overlay = "Starfall Enabled", tip = "|cff00FF00Starfall \n|cffFF0000Starfall activated.", highlight = 1, icon = 48505 }
			};
			CreateButton("Starfall",4,0)
			StarfallModesLoaded = "Boomkin Starfall Modes";
		end

		-- Cooldowns Button
		if CooldownsModesLoaded ~= "Boomkin Cooldowns Modes" then
			CooldownsModes = {
				[1] = { mode = "off", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000Cooldowns \n|cffFFDD11No cooldowns will be used.", highlight = 0, icon = 112071 },
				[2] = { mode = "on", value = 2 , overlay = "Cooldowns Enabled", tip = "|cff00FF00Cooldowns \n|cffFFDD11Only used if enabled in Settings. \n|cffFF0000Spells Included: \n|cffFFDD11Celestial Alignment \nIncarnation", highlight = 1, icon = 112071 }
			};
			CreateButton("Cooldowns",5,0)
			CooldownsModesLoaded = "Boomkin Cooldowns Modes";
		end






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
	end -- end toggles
end