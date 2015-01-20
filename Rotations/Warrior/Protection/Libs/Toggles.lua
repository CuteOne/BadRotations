if select(3, UnitClass("player")) == 1  then

   function WarriorProtToggles()
        if AoEModesLoaded ~= "Prot Warrior AoE Modes" then
            AoEModes = {                
				[1] = { mode = "Sing", value = 1 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = Devastate },
                [2] = { mode = "AoE", value = 2 , overlay = "Aoe Target Rotation", tip = "Aoe target rotation used.", highlight = 0, icon = ThunderClap },
				[3] = { mode = "Auto", value = 3 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = ThunderClap }
            };
           CreateButton("AoE",1,0)
           AoEModesLoaded = "Prot Warrior AoE Modes";
        end

        -- Defensive Button
        if DefensiveModesLoaded ~= "Defensive Modes" then
            CustomDefensiveModes = {
                [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = ShieldWall },
                [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = ShieldWall }
            };
            DefensiveModes = CustomDefensiveModes
            CreateButton("Defensive",2,0)
            DefensiveModesLoaded = "Defensive Modes";
        end

		-- Interrupts Button
        if InterruptsModesLoaded ~= "Interrupt Modes" then
            CustomInterruptsModes = {
                [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = Pummel },
                [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = Pummel }
            };
            InterruptsModes = CustomInterruptsModes
            CreateButton("Interrupts",3,0)
            InterruptsModesLoaded = "Interrupt Modes";
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