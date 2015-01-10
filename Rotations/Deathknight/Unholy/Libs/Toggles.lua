if select(3,UnitClass("player")) == 6 then
function UnholyToggles()
        -- if AoEModesLoaded ~= "Unholy DK AoE Modes" then
        --     AoEModes = {
        --         [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = ThunderClap },
        --         [2] = { mode = "Sing", value = 2 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = Devastate }
        --     };
        --    CreateButton("AoE",1,0)
        --    AoEModesLoaded = "Unholy DK AoE Modes";
        -- end
        if AoEModesLoaded ~= "Unholy DK AoE Modes" then
                CustomAoEModes = {
                    [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = _Outbreak },
                    [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = _BloodBoil },
                    [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = _ScourgeStrike }
                };
               AoEModes = CustomAoEModes
               CreateButton("AoE",1,0)
               AoEModesLoaded = "Unholy DK AoE Modes";
            end
        -- Cooldowns Button
        if CooldownsModesLoaded ~= "Cooldown Modes" then
            CustomCooldownsModes = {
                [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = _SummonGargoyle },
                [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = _EmpowerRuneWeapon },
                [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] }
            };
           CooldownsModes = CustomCooldownsModes
           CreateButton("Cooldowns",2,0)
           CooldownsModesLoaded = "Cooldown Modes";
        end

        -- Defensive Button
        if DefensiveModesLoaded ~= "Defensive Modes" then
            CustomDefensiveModes = {
                [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = _IceboundFortitude },
                [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] }
            };
            DefensiveModes = CustomDefensiveModes
            CreateButton("Defensive",3,0)
            DefensiveModesLoaded = "Defensive Modes";
        end

     -- Interrupts Button
        if InterruptsModesLoaded ~= "Interrupt Modes" then
            CustomInterruptsModes = {
                [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = _MindFreeze },
                [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] }
            };
            InterruptsModes = CustomInterruptsModes
            CreateButton("Interrupts",4,0)
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