if select(3, UnitClass("player")) == 8 then

    function FrostMageToggles()

        -- AutoRune Button
        if  RuneModesLoaded ~= "Frost Mage Rune Modes" then
            RuneModes = {
                [1] = { mode = "On", value = 1 , overlay = "Auto Rune Enabled", tip = "|cff00FF00Auto Rune \n|cffFFDD11Automatic place Rune of Power infight under Player enabled.", highlight = 1, icon = 116011 },
                [2] = { mode = "Off", value = 2 , overlay = "Auto Rune Enabled", tip = "|cffFF0000Auto Rune \n|cffFFDD11Automatic place Rune of Power infight under Player enabled.", highlight = 0, icon = 116011 }
            };
            CreateButton("Rune",1,0)
            RuneModesLoaded = "Frost Mage Rune Modes";
        end

        -- Petmode Button
        if  PetModesLoaded ~= "Frost Mage Pet Modes" then
            PetModes = {
                [1] = { mode = "On", value = 1 , overlay = "Auto Pet Enabled", tip = "|cff00FF00Petmode \n|cffFFDD11Automatic Petpassive/-agressive infight/outfight enabled.", highlight = 1, icon = 31687 },
                [2] = { mode = "Off", value = 2 , overlay = "Auto Pet Disabled", tip = "|cffFF0000Petmode \n|cffFFDD11Automatic Petpassive/-agressive infight/outfight disabled.", highlight = 0, icon = 31687},
             };
            CreateButton("Pet",0.5,1);
            PetModesLoaded = "Frost Mage Pet Modes";
        end
        -- Defensive Button
        if  DefensiveModesLoaded ~= "Frost Mage Defensive Modes" then
            DefensiveModes = {
                [1] = { mode = "Off", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0 },
                [2] = { mode = "On", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11", highlight = 1 }
            };
            CreateButton("Defensive",2,0);
            DefensiveModesLoaded = "Frost Mage Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Frost Mage Cooldowns Modes" then
            CooldownsModes = {
                [1] = { mode = "Off", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000Cooldowns \n|cffFFDD11No cooldowns will be used.", highlight = 0, icon = 55342},
                [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "|cff00FF00Cooldowns \n|cffFFDD11Only used if enabled in Settings. \n|cffFF0000Spells Included: \n|cffFFDD11Mirror Image \nIcy Veins \nRacial", highlight = 1, icon = 55342 }
            };
            CreateButton("Cooldowns",1.5,1);
            CooldownsModesLoaded = "Frost Mage Cooldowns Modes";
        end
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


    function ArcaneMageToggles()
        -- Aoe Button
        if  AoEModesLoaded ~= "Arcane Mage AoE Modes" then
            AoEModes = {
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cff00FF00AoE \n|cffFFDD11Recommended for \n|cff00FF00Single Target (1)", highlight = 0, icon = 5143 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cff00FF00AoE \n|cffFFDD11Recommended for \n|cffFF0000AoE (5+)", highlight = 0, icon = 1449 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cff00FF00AoE \n|cffFFDD11Auto-AoE", highlight = 1, icon = 116812 }
            };
            CreateButton("AoE",0.5,1)
            AoEModesLoaded = "Arcane Mage AoE Modes";
        end

        -- AutoRune Button
        --if  RuneModesLoaded ~= "Arcane Mage Rune Modes" then
        --	RuneModes = {
        --      [1] = { mode = "On", value = 1 , overlay = "Auto Rune Enabled", tip = "|cff00FF00Auto Rune \n|cffFFDD11Automatic place Rune of Power infight under Player enabled.", highlight = 1, icon = 116011 },
        --      [2] = { mode = "Off", value = 2 , overlay = "Auto Rune Enabled", tip = "|cffFF0000Auto Rune \n|cffFFDD11Automatic place Rune of Power infight under Player enabled.", highlight = 0, icon = 116011 }
        -- };
        --    CreateButton("Rune",1,0)
        --    RuneModesLoaded = "Arcane Mage Rune Modes";
        --end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "Arcane Mage Defensive Modes" then
            DefensiveModes = {
                [1] = { mode = "Off", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0, icon = 66 },
                [2] = { mode = "On", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Evanesce", highlight = 1, icon = 66 }
            };
            CreateButton("Defensive",2,0);
            DefensiveModesLoaded = "Arcane Mage Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Arcane Mage Cooldowns Modes" then
            CooldownsModes = {
                [1] = { mode = "Off", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000Cooldowns \n|cffFFDD11No cooldowns will be used.", highlight = 0, icon = 12042},
                [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "|cff00FF00Cooldowns \n|cffFFDD11Only used if enabled in Settings. \n|cffFF0000Spells Included: \n|cffFFDD11Mirror Image \nArcane Power \nRacial \nCold Snap", highlight = 1, icon = 12042 }
            };
            CreateButton("Cooldowns",1.5,1);
            CooldownsModesLoaded = "Arcane Mage Cooldowns Modes";
        end
    end

    function FireMageToggles()
        -- Aoe Button
        if  AoEModesLoaded ~= "Fire Mage AoE Modes" then
            AoEModes = {
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cff00FF00AoE \n|cffFFDD11Recommended for \n|cff00FF00Single Target (1)", highlight = 0, icon = 5143 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cff00FF00AoE \n|cffFFDD11Recommended for \n|cffFF0000AoE (5+)", highlight = 0, icon = 1449 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cff00FF00AoE \n|cffFFDD11Auto-AoE", highlight = 1, icon = 116812 }
            };
            CreateButton("AoE",0.5,1)
            AoEModesLoaded = "Fire Mage AoE Modes";
        end

        -- AutoRune Button
        --if  RuneModesLoaded ~= "Arcane Mage Rune Modes" then
        --	RuneModes = {
        --      [1] = { mode = "On", value = 1 , overlay = "Auto Rune Enabled", tip = "|cff00FF00Auto Rune \n|cffFFDD11Automatic place Rune of Power infight under Player enabled.", highlight = 1, icon = 116011 },
        --      [2] = { mode = "Off", value = 2 , overlay = "Auto Rune Enabled", tip = "|cffFF0000Auto Rune \n|cffFFDD11Automatic place Rune of Power infight under Player enabled.", highlight = 0, icon = 116011 }
        -- };
        --    CreateButton("Rune",1,0)
        --    RuneModesLoaded = "Arcane Mage Rune Modes";
        --end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "Fire Mage Defensive Modes" then
            DefensiveModes = {
                [1] = { mode = "Off", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0, icon = 66 },
                [2] = { mode = "On", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Evanesce", highlight = 1, icon = 66 }
            };
            CreateButton("Defensive",2,0);
            DefensiveModesLoaded = "Fire Mage Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Fire Mage Cooldowns Modes" then
            CooldownsModes = {
                [1] = { mode = "Off", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000Cooldowns \n|cffFFDD11No cooldowns will be used.", highlight = 0, icon = 12042},
                [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "|cff00FF00Cooldowns \n|cffFFDD11Only used if enabled in Settings. \n|cffFF0000Spells Included: \n|cffFFDD11Mirror Image \nArcane Power \nRacial \nCold Snap", highlight = 1, icon = 12042 }
            };
            CreateButton("Cooldowns",1.5,1);
            CooldownsModesLoaded = "Fire Mage Cooldowns Modes";
        end
    end
end