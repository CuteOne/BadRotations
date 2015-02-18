function SubToggles()
    if select(3, UnitClass("player")) == 4 and GetSpecialization()==3 then
       -- Aoe Button
        if  AoEModesLoaded ~= "Sub AoE Modes" then
            AoEModes = {
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cff00FF00Recommended for \n|cffFFDD11Single Target(1-2).", highlight = 0, icon = 1752 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffFF0000Recommended for \n|cffFFDD11AoE (5+).", highlight = 0, icon = 51723 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffFFDD11Recommended for \n|cffFFDD11Lazy people.", highlight = 1, icon = 121411 }
            };
            CreateButton("AoE",1,0);
            AoEModesLoaded = "Sub AoE Modes";
        end

        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Sub Cooldowns Modes" then
            CooldownsModes = {
                [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = _Preparation},
                [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target(stupid mode).", highlight = 0, icon = _Preparation},
                [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used(shit dps mode).", highlight = 0, icon = _Preparation}
            };
            CreateButton("Cooldowns",2,0);
            CooldownsModesLoaded = "Sub Cooldowns Modes";
        end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "Sub Defensive Modes" then
            DefensiveModes = {
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Feint, \nRecuperate.", highlight = 1, icon = 73651 }
            };
            CreateButton("Defensive",3,0);
            DefensiveModesLoaded = "Sub Defensive Modes";
        end

        -- Interrupts Button
        if  InterruptsModesLoaded ~= "Sub Interrupts Modes" then
            InterruptsModes = {
                [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Kick.", highlight = 1, icon = 1766 }
            };
            CreateButton("Interrupts",4,0);
            InterruptsModesLoaded = "Sub Interrupts Modes";
        end
    end
end
