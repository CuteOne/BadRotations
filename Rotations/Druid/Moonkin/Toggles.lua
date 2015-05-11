if select(3, UnitClass("player")) == 11 then
	function MoonkinToggles()

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
	end -- end toggles
end