if select(3, UnitClass("player")) == 9 then
    function DemonologyToggles()
        -- Aoe Button
        if  DemoAoEModesLoaded ~= "Demonology Warlock AoE Modes" then
            DemoAoEModes = {
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cff00FF00Single Target (1-2)", highlight = 0, icon = 108557 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cffFF0000AoE (3+)", highlight = 0, icon = 101546 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Auto-AoE", highlight = 1, icon = 116812 }
            }
            CreateButton("DemoAoE",0.5,1)
            DemoAoEModesLoaded = "Demonology Warlock AoE Modes"
        end
        -- Interrupts Button
        if  DemoInterruptsModesLoaded ~= "Demonology Warlock Interrupts Modes" then
            DemoInterruptsModes = {
                [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000Spells Included: \n|cffFFDD11Spear Hand Strike.", highlight = 1, icon = 116705 }
            }
            CreateButton("DemoInterrupts",1,0)
            DemoInterruptsModesLoaded = "Demonology Warlock Interrupts Modes"
        end
        -- Defensive Button
        if  DemoDefensiveModesLoaded ~= "Demonology Warlock Defensive Modes" then
            DemoDefensiveModes = {
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffC0C0C0Defensive \n|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffC0C0C0Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Fortifying Brew, \nElusive Brew, \nGuard", highlight = 1, icon = 115203 }
            }
            CreateButton("DemoDefensive",1.5,1)
            DemoDefensiveModesLoaded = "Demonology Warlock Defensive Modes"
        end
        -- Cooldowns Button
        if  DemoCooldownsModesLoaded ~= "Demonology Warlock Cooldowns Modes" then
            DemoCooldownsModes = {
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]]},
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Avenging Wrath, \nHoly Avenger.", highlight = 1, icon = 115080 }
            }
            CreateButton("DemoCooldowns",2,0)
            DemoCooldownsModesLoaded = "Demonology Warlock Cooldowns Modes"
        end
    end
end
