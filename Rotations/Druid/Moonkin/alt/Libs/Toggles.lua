if select(3, UnitClass("player")) == 11 then
	function MoonkinToggles()

		if  AoEModesLoaded ~= "Moonkin Druid AoE Modes" then
			CustomAoEModes = {
				[1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cff00FF00Single Target (1-2)", highlight = 0, icon = _moonfire },
				[2] = { mode = "Auto", value = 2 , overlay = "Auto-AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Auto-AoE", highlight = 0, icon = [[INTERFACE\ICONS\Inv_enchant_essencecosmicgreater]] }
			}
			AoEModes = CustomAoEModes
			CreateButton("AoE",1,0)
			AoEModesLoaded = "Moonkin Druid AoE Modes"
		end

		-- Cooldowns Button
		if  CooldownsModesLoaded ~= "Moonkin Druid Cooldowns Modes" then
			MoonCooldownsModes = {
				[1] = { mode = "Off", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
				[2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Config's selected spells.", highlight = 1, icon = _incarnationboom}
			}
			CreateButton("MoonCooldowns",2,0)
			CooldownsModesLoaded = "Moonkin Druid Cooldowns Modes"
		end

		-- Defensive Button
		if  DefensiveModesLoaded ~= "Moonkin Druid Defensive Modes" then
			MoonDefensiveModes = {
				[1] = { mode = "Off", value = 1 , overlay = "Defensive Disabled", tip = "|cffC0C0C0Defensive \n|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
				[2] = { mode = "On", value = 2 , overlay = "Defensive Enabled", tip = "|cffC0C0C0Defensive \n|cffFF0000Defensive Cooldowns will be used.", highlight = 1, icon = _barkskin }
			}
			CreateButton("MoonDefensive",3,0)
			DefensiveModesLoaded = "Moonkin Druid Defensive Modes"
		end

		-- Starfall Button
		if StarfallModesLoaded ~= "Starfall Modes" then
			CustomStarfallModes = {
				[1] = { mode = "On", value = 1 , overlay = "Starfall Enabled", tip = "Rotation will use Starfall on AoE", highlight = 1, icon = _starfall },
				[2] = { mode = "Off", value = 2 , overlay = "Starfall Disabled", tip = "Rotation will not use Starfall on AoE", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] }
			};
			StarfallModes = CustomStarfallModes
			CreateButton("Starfall",4,0)
			StarfallModesLoaded = "Starfall Modes";
		end

		--Multidot Button
		if MultidotModesLoaded ~= "Multidot Modes" then
			CustomMultidotModes = {
				[1] = { mode = "On", value = 1 , overlay = "Multidotting Enabled", tip = "Rotation will Multidot on AoE", highlight = 1, icon = [[INTERFACE\ICONS\achievement_doublerainbow]] },
				[2] = { mode = "Off", value = 2 , overlay = "Multidotting Disabled", tip = "Rotation will not Multidot on AoE", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] }
			};
			MultidotModes = CustomMultidotModes
			CreateButton("Multidot",5,0)
			MultidotModesLoaded = "Multidot Modes";
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

	end
end
