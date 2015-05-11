if select(3, UnitClass("player")) == 11 then
	function MoonkinToggles()








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