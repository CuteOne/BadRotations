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

        -- Aoe Button
        if  AoEModesLoaded ~= "Frost Mage AoE Modes" then 
            AoEModes = { 
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cff00FF00Recommended for \n|cffFFDD11Single Target(1-2).", highlight = 0 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffFF0000Recommended for \n|cffFFDD11AoE(3+).", highlight = 0 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffFFDD11Recommended for \n|cffFFDD11Lazy people like me.", highlight = 1 }
            };
            CreateButton("AoE",1,0)
            AoEModesLoaded = "Frost Mage AoE Modes";
        end

        -- DPS Button
        if  DPSModesLoaded ~= "Frost Mage DPS Modes" then 
            DPSModes = { 
                [1] = { mode = "Off", value = 1 , overlay = "DPS Disabled", tip = "Will not allow DPSing.", highlight = 0 },
                [2] = { mode = "On", value = 2 , overlay = "DPS Enabled", tip = "Will allow DPSing.", highlight = 1 },
             };
            CreateButton("DPS",0.5,1);
            DPSModesLoaded = "Frost Mage DPS Modes";
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
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0 },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Includes config's selected spells.", highlight = 1 },
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Tranquility.", highlight = 1 }
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