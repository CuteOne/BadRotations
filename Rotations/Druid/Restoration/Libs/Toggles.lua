if select(3, UnitClass("player")) == 11 then
    function RestorationToggles()
        -- Healing Button
        if  HealingModesLoaded ~= "Masou Restoration Healing Modes" then
            HealingModes = {
                [1] = { mode = "Off", value = 1 , overlay = "Healing Disabled", tip = "Will not allow healing.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "On", value = 2 , overlay = "Healing Enabled", tip = "Will allow healing.", highlight = 1, icon = 48438 },
             }
            CreateButton("Healing",1,0)
            HealingModesLoaded = "Masou Restoration Healing Modes"
        end
        -- DPS Button
        if  DPSModesLoaded ~= "Masou Restoration DPS Modes" then
            DPSModes = {
                [1] = { mode = "Off", value = 1 , overlay = "DPS Disabled", tip = "Will not allow DPSing.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "On", value = 2 , overlay = "DPS Enabled", tip = "Will allow DPSing.", highlight = 1, icon = 8921 },
             }
            CreateButton("DPS",0.5,1)
            DPSModesLoaded = "Masou Restoration DPS Modes"
        end
        -- Defensive Button
        if  DefensiveModesLoaded ~= "Masou Restoration Defensive Modes" then
            DefensiveModes = {
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Barkskin.", highlight = 1, icon = 22812 }
            }
            CreateButton("Defensive",2,0)
            DefensiveModesLoaded = "Masou Restoration Defensive Modes"
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Masou Restoration Cooldowns Modes" then
            CooldownsModes = {
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Includes config's selected spells.", highlight = 1, icon = 92364 },
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Tranquility.", highlight = 1, icon = 740 }
            }
            CreateButton("Cooldowns",1.5,1)
            CooldownsModesLoaded = "Masou Restoration Cooldowns Modes"
        end

        function SpecificToggle(toggle)
            if getValue(toggle) == 1 then
                return IsLeftControlKeyDown()
            elseif getValue(toggle) == 2 then
                return IsLeftShiftKeyDown()
            elseif getValue(toggle) == 3 then
                return IsLeftAltKeyDown()
            elseif getValue(toggle) == 4 then
                return IsRightControlKeyDown()
            elseif getValue(toggle) == 5 then
                return IsRightShiftKeyDown()
            elseif getValue(toggle) == 6 then
                return IsRightAltKeyDown()
            elseif getValue(toggle) == 7 then
                return IsMouseButtonDown(3)
			elseif getValue(toggle) == 8 then
                return IsMouseButtonDown(4)
			elseif getValue(toggle) == 9 then
                return IsMouseButtonDown(5)
			elseif getValue(toggle) == 10 then
                return true
            end
        end
    end
end