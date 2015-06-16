if select(3, UnitClass("player")) == 5 then

	function ShadowToggles()

		-- Defensive Button
		if DefensiveModesLoaded ~= "Shadow Priest Defensive Modes" then
			DefensiveModes = {
				[1] = { mode = "off", value = 1, overlay = "Defensive Disabled", tip = "|cffFF0000Defensive \n|cffFFDD11No Defensive Cooldowns will be used.", highlight = 0, icon = 17 },
				[2] = { mode = "on", value = 2, overlay = "Defensive Enabled", tip = "|cff00FF00Defensive \n|cffFF0000", highlight = 1, icon = 17 }
			};
			CreateButton("Defensive",1,0)
			DefensiveModesLoaded = "Shadow Priest Defensive Modes";
		end

		-- DoT Button
		if DoTModesLoaded ~= "Shadow Priest DoT Modes" then
			DoTModes = {
				[1] = { mode = "off", value = 1 , overlay = "DotEmAll off", tip = "|cffFF0000No Multidot \n|cffFFDD11", highlight = 0, icon = 155271 },
				[2] = { mode = "SWP", value = 2 , overlay = "SWP only on", tip = "|cff00FF00SWP only \n|cffFFDD11Dots all Targets with SWP.\nSet min. health and max targets in Options", highlight = 1, icon = 589 },
				[3] = { mode = "VT", value = 3 , overlay = "VT only on", tip = "|cff00FF00VT only \n|cffFFDD11Dots all Targets with VT.\nSet min. health and max targets in Options", highlight = 1, icon = 34914 },
				[4] = { mode = "All", value = 4 , overlay = "DotEmAll", tip = "|cff00FF00SWP&VT \n|cffFFDD11Dots all Targets with SWP&VT.\nSet min. health and max targets in Options", highlight = 1, icon = 165370 }
			};
			CreateButton("DoT",2,0)
			DoTModesLoaded = "Shadow Priest DoT Modes";
		end

		-- Boss Helper Button
		if BossHelperModesLoaded ~= "Shadow Priest Boss Helper Modes" then
			BossHelperModes = {
				[1] = { mode = "off", value = 1, overlay = "Boss Helper Disabled", tip = "|cffFF0000Boss Helper \n|cffFFDD11Boss Helper inactive.", highlight = 0, icon = 15031 },
				[2] = { mode = "on", value = 2, overlay = "Boss Helper Enabled", tip = "|cff00FF00Boss Helper \n|cffFFDD11Boss Helper activated.", highlight = 1, icon = 15031 }
			};
			CreateButton("BossHelper",3,0)
			BossHelperModesLoaded = "Shadow Priest Boss Helper Modes";
		end

		--[[                Upper Line                ]]

		-- Halo Button
		if HaloModesLoaded ~= "Shadow Priest Halo Modes" then
			HaloModes = {
				[1] = { mode = "off", value = 1 , overlay = "Halo/Cascade Disabled", tip = "|cffFF0000Halo/Star/Cascade \n|cffFFDD11wont be used.", highlight = 0, icon = 120644 },
				[2] = { mode = "on", value = 2 , overlay = "Halo/Cascade Enabled", tip = "|cff00FF00Halo/Star/Cascade \n|cffFFDD11will be used.", highlight = 1, icon = 120644 }
			};
			CreateButton("Halo",4,0)
			HaloModesLoaded = "Shadow Priest Halo Modes";
		end

		-- Cooldowns Button
		if CooldownsModesLoaded ~= "Shadow Priest Cooldowns Modes" then
			CooldownsModes = {
				[1] = { mode = "off", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000Cooldowns \n|cffFFDD11No cooldowns will be used.", highlight = 0, icon = 34433 },
				[2] = { mode = "on", value = 2 , overlay = "Cooldowns Enabled", tip = "|cff00FF00Cooldowns \n|cffFFDD11Only used if enabled in Settings.", highlight = 1, icon = 34433 }
			};
			CreateButton("Cooldowns",5,0)
			CooldownsModesLoaded = "Shadow Priest Cooldowns Modes";
		end

		-- Feather Button
		if FeathertModesLoaded ~= "Shadow Priest Feather Modes" then
			FeatherModes = {
				[1] = { mode = "off", value = 1 , overlay = "Feather Disabled", tip = "|cffFF0000Feather", highlight = 0, icon = 121536 },
				[2] = { mode = "auto", value = 2 , overlay = "Feather Auto", tip = "|cff00FF00Feather", highlight = 1, icon = 121536 }
			};
			--CreateButton("Feather",0,1)
			CreateButton("Feather",6,0)
			FeatherModesLoaded = "Shadow Priest Feather Modes";
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