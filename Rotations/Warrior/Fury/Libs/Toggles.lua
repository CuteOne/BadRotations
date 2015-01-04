if select(3, UnitClass("player")) == 1 then

	function KeyToggles()

        if AoEModesLoaded ~= "Fury Warrior AoE Modes" then
            CustomAoEModes = {
			[1] = { mode = "One", value = 1 , overlay = "Single Target Enabled", tip = "", highlight = 0, icon = Bloodthirst },
            [2] = { mode = "Two", value = 2 , overlay = "Two Target Enabled", tip = "", highlight = 0, icon = RagingBlow },
            [3] = { mode = "Three", value = 3 , overlay = "Three Target Enabled", tip = "", highlight = 0, icon = Whirlwind },
			[4] = { mode = "Four", value = 4 , overlay = "Four+ Target Enabled", tip = "", highlight = 0, icon = Whirlwind }
            };
			AoEModes = CustomAoEModes
			CreateButton("AoE",1,0)
			AoEModesLoaded = "Fury Warrior AoE Modes";
        end

		if InterruptsModesLoaded ~= "Fury Interrupt Modes" then
            CustomInterruptsModes = {
                [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "", highlight = 1, icon = Pummel },
                [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "", highlight = 0, icon = Pummel }
            };
			InterruptsModes = CustomInterruptsModes
            CreateButton("Interrupts",2,0)
            InterruptsModesLoaded = "Fury Interrupt Modes";
        end

		function SpecificToggle(toggle)
            if getValue(toggle) == 1 then
                return IsLeftControlKeyDown();
            elseif getValue(toggle) == 2 then
                return IsLeftShiftKeyDown();
            elseif getValue(toggle) == 3 then
                return IsRightControlKeyDown();
            elseif getValue(toggle) == 4 then
                return IsRightShiftKeyDown();
            elseif getValue(toggle) == 5 then
                return IsRightAltKeyDown();
            elseif getValue(toggle) == 6 then
                return 0
            end
        end

    end

end