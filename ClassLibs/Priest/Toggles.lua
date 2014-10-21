if select(3, UnitClass("player")) == 5 then


--[[         ]]     --[[           ]]   --[[           ]]   --[[           ]]
--[[          ]]          --[[]]        --[[           ]]   --[[           ]]
--[[]]     --[[]]         --[[]]        --[[]]              --[[]]
--[[]]     --[[]]         --[[]]        --[[           ]]   --[[]]
--[[]]     --[[]]         --[[]]                   --[[]]   --[[]]
--[[          ]]          --[[]]        --[[           ]]   --[[           ]]
--[[         ]]     --[[           ]]   --[[           ]]   --[[           ]]

--[[]]     --[[]]   --[[           ]]   --[[]]              --[[]]    --[[]]
--[[]]     --[[]]   --[[           ]]   --[[]]              --[[]]    --[[]]
--[[           ]]   --[[]]     --[[]]   --[[]]                 --[[    ]]
--[[           ]]   --[[]]     --[[]]   --[[]]                 --[[    ]]
--[[           ]]   --[[]]     --[[]]   --[[]]                   --[[]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[]]

--[[           ]]   --[[]]     --[[]]         --[[]]        --[[         ]]     --[[           ]]   --[[]]     --[[]]
--[[           ]]   --[[]]     --[[]]        --[[  ]]       --[[          ]]    --[[           ]]   --[[]]     --[[]]
--[[]]              --[[]]     --[[]]       --[[    ]]      --[[]]     --[[]]   --[[]]     --[[]]   --[[ ]]   --[[ ]]
--[[           ]]   --[[           ]]      --[[      ]]     --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]
           --[[]]   --[[]]     --[[]]     --[[        ]]    --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]
--[[           ]]   --[[]]     --[[]]    --[[]]    --[[]]   --[[          ]]    --[[           ]]   --[[ ]]   --[[ ]]
--[[           ]]   --[[]]     --[[]]   --[[]]      --[[]]  --[[         ]]     --[[           ]]    --[[]]   --[[]]



    function ShadowToggles()
        -- Multidot Button
        if MultidotModesLoaded ~= "Shadow Priest Multidot Modes" then
            MultidotModes = {
                [1] = { mode = "!MD", value = 1, overlay = "Multidotting Disabled", tip = "|cffC0C0C0Multidotting \n|cffFF0000No auto multidotting active.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]},
                [2] = { mode = "On", value =2, overlay = "Multidotting Activated", tip = "|cffC0C0C0Multidotting \n|cffFF0000Multidotting active.", highlight = 1, icon = 589}
            };
            CreateButton("Multidot",0,1)
            MultidotModesLoaded = "Shadow Priest Multidot Modes";
        end
        -- -- Aoe Button
        -- if  AoEModesLoaded ~= "Shadow Priest AoE Modes" then
        --     AoEModes = {
        --         [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cff00FF00Single Target (1)", highlight = 0, icon = 108557 },
        --         [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cffFF0000AoE (3+)", highlight = 0, icon = 101546 },
        --         [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Auto-AoE", highlight = 1, icon = 116812 }
        --     };
        --     CreateButton("AoE",1,1)
        --     AoEModesLoaded = "Shadow Priest AoE Modes";
        -- end
        -- Defensive Button
        if  DefensiveModesLoaded ~= "Shadow Priest Defensive Modes" then
            DefensiveModes = {
                [1] = { mode = "!DEF", value = 1 , overlay = "Defensive Disabled", tip = "|cffC0C0C0Defensive \n|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "Inst", value = 2 , overlay = "Defensive Enabled Instant", tip = "|cffC0C0C0Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Power Word: Shield \nFade (glyphed) \nDesperate Prayer \nHealthstone", highlight = 1, icon = 17 },
                [3] = { mode = "All", value = 3, overlay = "Defensive Enabled All", tip = "|cffC0C0C0Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Power Word: Shield \nFade (glyphed) \nDesperate Prayer \nHealthstone \nPrayer of Mending", highlight=1, icon = 33076}
            };
            CreateButton("Defensive",2,1)
            DefensiveModesLoaded = "Shadow Priest Defensive Modes";
        end
        -- Interrupts Button
        if  InterruptsModesLoaded ~= "Shadow Priest Interrupts Modes" then
            InterruptsModes = {
                [1] = { mode = "!INT", value = 1 , overlay = "Interrupts Disabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "On", value = 2 , overlay = "Interrupts Enabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000Spells Included: \n|cffFFDD11Silence", highlight = 1, icon = 15487 },
                [3] = { mode = "B11", value = 3 , overlay = "Interrupts Enabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000Spells Included: \n|cffFFDD11Silence \nArcane Torret (BloodElv Racial)", highlight = 1, icon = 28730 }

            };
            CreateButton("Interrupts",1,0)
            InterruptsModesLoaded = "Shadow Priest Interrupts Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Shadow Priest Cooldowns Modes" then
            CooldownsModes = {
                [1] = { mode = "!CD", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \nOnly used if enabled in Settings. \n|cffFF0000Spells Included: \n|cffFFDD11Power Infusion, \nShadowfiend \nMindbender", highlight = 1, icon = 115080 }
            };
            CreateButton("Cooldowns",2,0)
            CooldownsModesLoaded = "Shadow Priest Cooldowns Modes";
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