if select(3,UnitClass("player")) == 2 then
    function PaladinRetToggles()
        -- Aoe Button
        if AoEModesLoaded ~= "Ret Pal AoE Modes" then
            AoEModes = {
                [1] = {
                    mode = "1-2",
                    value = 1,
                    overlay = "|cffFFFFFFSingle Target Enabled",
                    tip = "|cff00FF00Recommended for \n|cffFFDD11Single Target(1-2).",
                    highlight = 0,
                    icon = 35395
                },
                [2] = {
                    mode = "3-4",
                    value = 2,
                    overlay = "|cffFFBC0BCleave AoE Enabled",
                    tip = "|cffFF0000Recommended for \n|cffFFDD11AoE(3-4).",
                    highlight = 0,
                    icon = 53385
                },
                [3] = {
                    mode = "5+",
                    value = 3,
                    overlay = "|cffAA55FFMass AoE Enabled",
                    tip = "|cffFFDD11Recommended for \n|cffFFDD11AoE(5+) people.",
                    highlight = 0,
                    icon = 53595
                },
                [4] = {
                    mode = "Auto",
                    value = 4,
                    overlay = "|cff00F900Auto-AoE Enabled",
                    tip = "|cffFFDD11Recommended for \n|cffFFDD11Lazy people.",
                    highlight = 1,
                    icon = 114158
                }
            }
            CreateButton("AoE",0,1)
            AoEModesLoaded = "Ret Pal AoE Modes"
        end
        -- Interrupts Button
        if  InterruptsModesLoaded ~= "Ret Pal Interrupts Modes" then
            InterruptsModes = {
                [1] = {
                    mode = "None",
                    value = 1 ,
                    overlay = "Interrupts Disabled",
                    tip = "|cffFF0000No Interrupts will be used.",
                    highlight = 0,
                    icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]
                },
                [2] = {
                    mode = "All",
                    value = 2 ,
                    overlay = "Interrupts Enabled",
                    tip = "|cffFF0000Spells Included: \n|cffFFDD11Rebuke.",
                    highlight = 1,
                    icon = 96231
                }
            }
            CreateButton("Interrupts",1,0)
            InterruptsModesLoaded = "Ret Pal Interrupts Modes"
        end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "Ret Pal Defensive Modes" then
            DefensiveModes = {
                [1] = {
                    mode = "None",
                    value = 1 ,
                    overlay = "Defensive Disabled",
                    tip = "|cffFF0000No Defensive Cooldowns will be used.",
                    highlight = 0,
                    icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]
                },
                [2] = {
                    mode = "User",
                    value = 1 ,
                    overlay = "Selective Defense Enabled",
                    tip = "|cffFF0000Will use selected defensive spells.",
                    highlight = 0,
                    icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]
                },
                [3] = {
                    mode = "All",
                    value = 2 ,
                    overlay = "Defensive Enabled",
                    tip = "|cffFF0000Spells Included: \nDivine Protection, \nDivine Shield.",
                    highlight = 1,
                    icon = 86659
                }
            }
            CreateButton("Defensive",1,1)
            DefensiveModesLoaded = "Ret Pal Defensive Modes"
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Ret Pal Cooldowns Modes" then
            CooldownsModes = {
                [1] = {
                    mode = "None",
                    value = 1 ,
                    overlay = "Cooldowns Disabled",
                    tip = "|cffFF0000No cooldowns will be used.",
                    highlight = 0,
                    icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]
                },
                [2] = {
                    mode = "User",
                    value = 2 ,
                    overlay = "User Cooldowns Enabled",
                    tip = "|cffFF0000Cooldowns Included: \n|cffFFDD11Config's selected spells.",
                    highlight = 1,
                    icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]]
                },
                [3] = {
                    mode = "All",
                    value = 3 ,
                    overlay = "Cooldowns Enabled",
                    tip = "|cffFF0000Cooldowns Included: \n|cffFFDD11Avenging Wrath, \nHoly Avenger, \nLight's Hammer.",
                    highlight = 1,
                    icon = 31884
                }
            }
            CreateButton("Cooldowns",2,0)
            CooldownsModesLoaded = "Ret Pal Cooldowns Modes";
        end
         -- Healing Button
        if  TrashModesLoaded ~= "Ret Pal Healing Modes" then
            HealingModes = {
                [1] = {
                    mode = "Self",
                    value = 1 ,
                    overlay = "Heal only Self.",
                    tip = "|cffFF0000Healing: |cffFFDD11On self only.",
                    highlight = 0,
                    icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]
                },
                [2] = {
                    mode = "All",
                    value = 2 ,
                    overlay = "Heal Everyone.",
                    tip = "|cffFF0000Healing: |cffFFDD11Everyone.",
                    highlight = 1,
                    icon = 19750
                }
            }
            CreateButton("Healing",2,1)
            HealingModesLoaded = "Ret Pal Healing Modes"
        end
    end
end