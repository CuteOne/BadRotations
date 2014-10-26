if select(3, UnitClass("player")) == 8 then
      --[[]]        --[[           ]]   --[[           ]]         --[[]]        --[[]]     --[[]]   --[[           ]]
     --[[  ]]       --[[           ]]   --[[           ]]        --[[  ]]       --[[  ]]   --[[]]   --[[           ]]
    --[[    ]]      --[[]]     --[[]]   --[[]]                  --[[    ]]      --[[    ]] --[[]]   --[[]]
   --[[      ]]     --[[         ]]     --[[]]                 --[[      ]]     --[[           ]]   --[[           ]]
  --[[        ]]    --[[        ]]      --[[]]                --[[        ]]    --[[           ]]   --[[]]
 --[[]]    --[[]]   --[[]]    --[[]]    --[[           ]]    --[[]]    --[[]]   --[[]]   --[[  ]]   --[[           ]]
--[[]]      --[[]]  --[[]]     --[[]]   --[[           ]]   --[[]]      --[[]]  --[[]]     --[[]]   --[[           ]]

--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[           ]]        --[[ ]]        --[[           ]]   --[[           ]]
--[[]]                   --[[ ]]        --[[]]     --[[]]   --[[]]
--[[           ]]        --[[ ]]        --[[           ]]   --[[           ]]
--[[]]                   --[[ ]]        --[[        ]]      --[[]]
--[[]]                   --[[ ]]        --[[]]    --[[]]    --[[           ]]
--[[]]              --[[           ]]   --[[]]     --[[]]   --[[           ]]

--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[]]              --[[]]     --[[]]   --[[]]     --[[]]   --[[]]                   --[[ ]]
--[[           ]]   --[[           ]]   --[[]]     --[[]]   --[[           ]]        --[[ ]]
--[[]]              --[[        ]]      --[[]]     --[[]]              --[[]]        --[[ ]]
--[[]]              --[[]]    --[[]]    --[[           ]]   --[[           ]]        --[[ ]]
--[[]]              --[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[ ]]

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
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0 },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Barkskin.", highlight = 1 }
            };
            CreateButton("Defensive",2,0);
            DefensiveModesLoaded = "Frost Mage Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Frost Mage Cooldowns Modes" then
            CooldownsModes = {
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0, icon = 55342},
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Includes config's selected spells.", highlight = 1, icon = 55342 },
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11.", highlight = 1, icon = 55342 }
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

end