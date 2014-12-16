if select(3, UnitClass("player")) == 4 then

function SubToggles()
   -- Aoe Button
    if  AoEModesLoaded ~= "Sub Rogue AoE Modes" then
        AoEModes = {
            [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cff00FF00Recommended for \n|cffFFDD11Single Target(1-2).", highlight = 0, icon = 1752 },
            [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffFF0000Recommended for \n|cffFFDD11AoE (5+).", highlight = 0, icon = 51723 },
            [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffFFDD11Recommended for \n|cffFFDD11Lazy people.", highlight = 1, icon = 121411 }
        };
        CreateButton("AoE",1.5,1);
        AoEModesLoaded = "Sub Rogue AoE Modes";
    end

    -- Interrupts Button
    if  InterruptsModesLoaded ~= "Sub Rogue Interrupts Modes" then
        InterruptsModes = {
            [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Kick.", highlight = 1, icon = 1766 }
        };
        CreateButton("Interrupts",0.5,1);
        InterruptsModesLoaded = "Sub Rogue Interrupts Modes";
    end

    -- Defensive Button
    if  DefensiveModesLoaded ~= "Sub Rogue Defensive Modes" then
        DefensiveModes = {
            [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Feint, \nRecuperate.", highlight = 1, icon = 73651 }
        };
        CreateButton("Defensive",1,0);
        DefensiveModesLoaded = "Sub Rogue Defensive Modes";
    end

    -- Cooldowns Button
    if  CooldownsModesLoaded ~= "Sub Rogue Cooldowns Modes" then
        CooldownsModes = {
            [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]] },
            [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Vanish, Shadow Blades, \nShadow Dance, Shadowmeld.", highlight = 1, icon = 121471 }
        };
        CreateButton("Cooldowns",2,0);
        CooldownsModesLoaded = "Sub Rogue Cooldowns Modes";
    end
end
end
