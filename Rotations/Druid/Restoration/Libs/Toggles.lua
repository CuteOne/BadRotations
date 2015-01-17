if select(3, UnitClass("player")) == 11 then
    function RestorationToggles()
        -- Healing Button
        if  HealingModesLoaded ~= "Masou Restoration Healing Modes" then
            HealingModes = {
                [1] = { mode = "Off", value = 1 , overlay = "Healing Disabled", tip = "|cffFF1100Healing\n|cffFFDD11Will not allow healing.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "On", value = 2 , overlay = "Healing Enabled", tip = "|cffFF1100Healing\n|cffFFDD11Will allow healing.", highlight = 1, icon = 48438 },
             }
            CreateButton("Healing",1,0)
            HealingModesLoaded = "Masou Restoration Healing Modes"
        end
        -- DPS Button
        if  DPSModesLoaded ~= "Masou Restoration DPS Modes" then
            DPSModes = {
                [1] = { mode = "Off", value = 1 , overlay = "DPS Disabled", tip = "|cffFF1100DPS\n|cffFFDD11Will not allow DPSing.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "On", value = 2 , overlay = "DPS Enabled", tip = "|cffFF1100DPS\n|cffFFDD11Will allow DPSing.", highlight = 1, icon = 8921 },
             }
            CreateButton("DPS",2,0)
            DPSModesLoaded = "Masou Restoration DPS Modes"
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