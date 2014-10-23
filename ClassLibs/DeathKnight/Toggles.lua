if select(3,UnitClass("player")) == 6 then

function BloodToggles()

   -- Aoe Button
    if  AoEModesLoaded ~= "Blood DK AoE Modes" then
        AoEModes = {
            [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cff00FF00Recommended for \n|cffFFDD11Single Target(1-2).", highlight = 0, icon = 45477 },
            [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffFF0000Recommended for \n|cffFFDD11AoE(3+).", highlight = 0, icon = 49998 },
            [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffFFDD11Recommended for \n|cffFFDD11Lazy people like me.", highlight = 1, icon = 43265 }
        };
        CreateButton("AoE",1,0);
        AoEModesLoaded = "Blood DK AoE Modes";
    end

    -- Interrupts Button
    if  InterruptsModesLoaded ~= "Blood DK Interrupts Modes" then
        InterruptsModes = {
            [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Mind Freeze, \nStrangulate.", highlight = 1, icon = 47528 }
        };
        CreateButton("Interrupts",3,0);
        InterruptsModesLoaded = "Blood DK Interrupts Modes";
    end

    -- Defensive Button
    if  DefensiveModesLoaded ~= "Blood DK Defensive Modes" then
        DefensiveModes = {
            [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Blood Tap, \nIcebound Fortitude, \nAnti-Magic Shell.", highlight = 1, icon = 48792 }
        };
        CreateButton("Defensive",2,0);
        DefensiveModesLoaded = "Blood DK Defensive Modes";
    end
end

function FrostToggles()
   -- Aoe Button
   if AoEModesLoaded ~= "Frost DK AoE Modes" then
            CustomAoEModes = {
                [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 0, icon = SweepingStrikes },
                [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = Whirlwind },
                [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = MortalStrike }
            };
           AoEModes = CustomAoEModes
           CreateButton("AoE",1,0)
           AoEModesLoaded = "Frost DK AoE Modes";
        end

    -- Cooldowns Button
    if CooldownsModesLoaded ~= "Frost DK Cooldown Modes" then
        CustomCooldownsModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = _PillarOfFrost },
            [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = _PillarOfFrost },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = _PillarOfFrost }
        };
       CooldownsModes = CustomCooldownsModes
       CreateButton("Cooldowns",2,0)
       CooldownsModesLoaded = "Frost DK Cooldown Modes";
    end

    -- Interrupts Button
    if  InterruptsModesLoaded ~= "Frost DK Interrupts Modes" then
        InterruptsModes = {
            [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Mind Freeze, \nStrangulate.", highlight = 1, icon = 47528 }
        };
        CreateButton("Interrupts",3,0);
        InterruptsModesLoaded = "Frost DK Interrupts Modes";
    end

    -- Defensive Button
    if  DefensiveModesLoaded ~= "Frost DK Defensive Modes" then
        DefensiveModes = {
            [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Blood Tap, \nIcebound Fortitude, \nAnti-Magic Shell.", highlight = 1, icon = 48792 }
        };
        CreateButton("Defensive",4,0);
        DefensiveModesLoaded = "Frost DK Defensive Modes";
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