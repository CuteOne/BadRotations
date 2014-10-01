if select(3, UnitClass("player")) == 1 then
    
      --[[]]        --[[           ]]   --[[]]     --[[]]   --[[           ]]
     --[[  ]]       --[[           ]]   --[[ ]]   --[[ ]]   --[[           ]]
    --[[    ]]      --[[]]     --[[]]   --[[           ]]   --[[]]
   --[[      ]]     --[[         ]]     --[[           ]]   --[[           ]]
  --[[        ]]    --[[        ]]      --[[]]     --[[]]              --[[]]
 --[[]]    --[[]]   --[[]]    --[[]]    --[[]]     --[[]]   --[[           ]]   
--[[]]      --[[]]  --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]

   function WarriorArmsToggles()
        AoEModesLoaded = "Arms Warrior AoE Modes"

        -- Aoe Button
        AoEModes = { 
            [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cff00FF00Single Target (1-2)", highlight = 0, icon = 78 },
            [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cffFF0000AoE (3+)", highlight = 0, icon = 845 },
            [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Auto-AoE", highlight = 1, icon = 84615 }
        };
        CreateButton("AoE",0.5,1)

        -- Interrupts Button
        InterruptsModes = { 
            [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000Spells Included: \n|cffFFDD11Pummel.", highlight = 1, icon = 6552 }
        };
        CreateButton("Interrupts",1,0)

        -- Defensive Button
        DefensiveModes = { 
            [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffC0C0C0Defensive \n|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffC0C0C0Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Shield Wall, \nLast Stand.", highlight = 1, icon = 871 }
        };
        CreateButton("Defensive",1.5,1)

        -- Cooldowns Button
        CooldownsModes = { 
            [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]]},
            [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Berserker Rage, \nBlood Bath.", highlight = 1, icon = 18499 }
        };
        CreateButton("Cooldowns",2,0)

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

--[[           ]]   --[[]]     --[[]]   --[[           ]]   --[[]]    --[[]]
--[[           ]]   --[[]]     --[[]]   --[[           ]]   --[[]]    --[[]]
--[[]]              --[[]]     --[[]]   --[[]]     --[[]]      --[[    ]]   
--[[           ]]   --[[]]     --[[]]   --[[         ]]        --[[    ]]   
--[[           ]]   --[[]]     --[[]]   --[[        ]]           --[[]]
--[[]]              --[[           ]]   --[[]]    --[[]]         --[[]] 
--[[]]              --[[           ]]   --[[]]      --[[]]       --[[]]

   function WarriorFuryToggles()
        AoEModesLoaded = "Fury Warrior AoE Modes";

        -- Aoe Button
        AoEModes = { 
            [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cff00FF00Single Target (1-2)", highlight = 0, icon = 78 },
            [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cffFF0000AoE (3+)", highlight = 0, icon = 845 },
            [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Auto-AoE", highlight = 1, icon = 84615 }
        };
        CreateButton("AoE",0.5,1)

        -- Interrupts Button
        InterruptsModes = { 
            [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000Spells Included: \n|cffFFDD11Pummel.", highlight = 1, icon = 6552 }
        };
        CreateButton("Interrupts",1,0)

        -- Defensive Button
        DefensiveModes = { 
            [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffC0C0C0Defensive \n|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffC0C0C0Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Shield Wall, \nLast Stand.", highlight = 1, icon = 871 }
        };
        CreateButton("Defensive",1.5,1)

        -- Cooldowns Button
        CooldownsModes = { 
            [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]]},
            [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Berserker Rage, \nBlood Bath.", highlight = 1, icon = 18499 }
        };
        CreateButton("Cooldowns",2,0)

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

--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[]]     --[[]]   --[[]]     --[[]]   --[[]]     --[[]]        --[[ ]]
--[[         ]]     --[[         ]]     --[[]]     --[[]]        --[[ ]]
--[[       ]]       --[[        ]]      --[[]]     --[[]]        --[[ ]]
--[[]]              --[[]]    --[[]]    --[[           ]]        --[[ ]]        
--[[]]              --[[]]     --[[]]   --[[           ]]        --[[ ]]    


   function WarriorProtToggles()
        AoEModesLoaded = "Prot Warrior AoE Modes";

        -- Aoe Button
        AoEModes = { 
            [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cff00FF00Single Target (1-2)", highlight = 0, icon = 78 },
            [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cffFF0000AoE (3+)", highlight = 0, icon = 845 },
            [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Auto-AoE", highlight = 1, icon = 84615 }
        };
        CreateButton("AoE",0.5,1)

        -- Interrupts Button
        InterruptsModes = { 
            [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000Spells Included: \n|cffFFDD11Pummel.", highlight = 1, icon = 6552 }
        };
        CreateButton("Interrupts",1,0)

        -- Defensive Button
        DefensiveModes = { 
            [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffC0C0C0Defensive \n|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffC0C0C0Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Shield Wall, \nLast Stand.", highlight = 1, icon = 871 }
        };
        CreateButton("Defensive",1.5,1)

        -- Cooldowns Button
        CooldownsModes = { 
            [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]]},
            [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Berserker Rage, \nBlood Bath.", highlight = 1, icon = 18499 }
        };
        CreateButton("Cooldowns",2,0)

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
