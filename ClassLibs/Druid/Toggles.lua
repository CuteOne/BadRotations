if select(3, UnitClass("player")) == 11 then
--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]   
--[[ ]]   --[[ ]]   --[[           ]]   --[[           ]]   --[[  ]]   --[[]]   
--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[    ]] --[[]]       
--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]   
--[[]]     --[[]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]   
--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[]]   --[[  ]]   
--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]   


    function MoonkinToggles()
        -- Aoe Button
        if  AoEModesLoaded ~= "Moonkin Druid AoE Modes" then 
            AoEModes = { 
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cff00FF00Single Target (1-2)", highlight = 0, icon = 108557 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cffFF0000AoE (3+)", highlight = 0, icon = 101546 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Auto-AoE", highlight = 1, icon = 116812 }
            };
            CreateButton("AoE",0.5,1)
            AoEModesLoaded = "Moonkin Druid AoE Modes";
        end
        -- Interrupts Button
        if  InterruptsModesLoaded ~= "Moonkin Druid Interrupts Modes" then 
            InterruptsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000Spells Included: \n|cffFFDD11Spear Hand Strike.", highlight = 1, icon = 116705 }
            };
            CreateButton("Interrupts",1,0)
            InterruptsModesLoaded = "Moonkin Druid Interrupts Modes";
        end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "Moonkin Druid Defensive Modes" then 
            DefensiveModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffC0C0C0Defensive \n|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffC0C0C0Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Fortifying Brew, \nElusive Brew, \nGuard", highlight = 1, icon = 115203 }
            };
            CreateButton("Defensive",1.5,1)
            DefensiveModesLoaded = "Moonkin Druid Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Moonkin Druid Cooldowns Modes" then 
            CooldownsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]]},
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Avenging Wrath, \nHoly Avenger.", highlight = 1, icon = 115080 }
            };
            CreateButton("Cooldowns",2,0)
            CooldownsModesLoaded = "Moonkin Druid Cooldowns Modes";
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



--[[           ]]         --[[]]        --[[           ]]
--[[           ]]        --[[  ]]       --[[           ]]
--[[]]                  --[[    ]]           --[[ ]]    
--[[]]                 --[[      ]]          --[[ ]]    
--[[]]                --[[        ]]         --[[ ]]    
--[[           ]]    --[[]]    --[[]]        --[[ ]]        
--[[           ]]   --[[]]      --[[]]       --[[ ]]    
    function KeyToggles()
     -- AoE Button
        if AoEModesLoaded ~= "Cute AoE Modes" then 
            CustomAoEModes = { 
                [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = sw },  
                [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = sw },
                [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = mgl }
            };
           AoEModes = CustomAoEModes
           CreateButton("AoE",1,0)
           AoEModesLoaded = "Cute AoE Modes";
        end
            
     -- Cooldowns Button
        if CooldownsModesLoaded ~= "Cute Cooldowns Modes" then 
            CustomCooldownsModes = { 
                [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = ber },  
                [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = ber },
                [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = ber }
            };
           CooldownsModes = CustomCooldownsModes
           CreateButton("Cooldowns",2,0)
           CooldownsModesLoaded = "Cute Cooldowns Modes";
        end

     -- Defensive Button
        if DefensiveModesLoaded ~= "Cute Defensive Modes" then 
            CustomDefensiveModes = { 
                [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = si },
                [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = si }
            };
            DefensiveModes = CustomDefensiveModes
            CreateButton("Defensive",3,0)
            DefensiveModesLoaded = "Cute Defensive Modes";
        end

     -- Interrupts Button
        if InterruptsModesLoaded ~= "Cute Interrupt Modes" then 
            CustomInterruptsModes = { 
                [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = sb },
                [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = sb }
            };
            InterruptsModes = CustomInterruptsModes
            CreateButton("Interrupts",4,0)
            InterruptsModesLoaded = "Cute Interrupt Modes";
        end
     -- Thrash Button
        if ThrashModesLoaded ~= "Cute Thrash Modes" then 
            CustomThrashModes = { 
                [1] = { mode = "On", value = 1 , overlay = "Thrash Enabled", tip = "Rotation will use Thrash", highlight = 1, icon = thr },
                [2] = { mode = "Off", value = 2 , overlay = "Thrash Disabled", tip = "Rotation will not use Thrash", highlight = 0, icon = thr }
            };
            ThrashModes = CustomThrashModes
            CreateButton("Thrash",5,0)
            ThrashModesLoaded = "Cute Thrash Modes";
        end
     -- Symbiosis Button
        if SymbiosisModesLoaded ~= "Cute Symbiosis Modes" then 
            CustomSymbiosisModes = { 
                [1] = { mode = "On", value = 1 , overlay = "Symbiosis Enabled", tip = "Rotation will auto-select Symbiosis target.", highlight = 1, icon = sym },
                [2] = { mode = "Off", value = 2 , overlay = "Symbiosis Disabled", tip = "Rotation will not auto-select Symbiosis target.", highlight = 0, icon = sym }
            };
            SymbiosisModes = CustomSymbiosisModes
            CreateButton("Symbiosis",6,0)
            SymbiosisModesLoaded = "Cute Symbiosis Modes";
        end

        function SpecificToggle(toggle)
            if getValue(toggle) == 1 then
                return IsLeftControlKeyDown();
            elseif getValue(toggle) == 2 then
                return IsLeftShiftKeyDown();
            elseif getValue(toggle) == 3 then
                return IsRightControlKeyDown();
            elseif getValue(toggle) == 4 then
                return IsRightShiftKeyDown();
            elseif getValue(toggle) == 5 then
                return IsRightAltKeyDown();
            elseif getValue(toggle) == 6 then
                return 0
            end
        end

        --AoE Key Toggle
        if AOETimer == nil then AOETimer = 0; end
        if SpecificToggle("Rotation Mode") == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - AOETimer > 0.25 then
            AOETimer = GetTime()
            if BadBoy_data['AoE'] ~= #AoEModes then
                BadBoy_data['AoE'] = BadBoy_data['AoE']+1
            else
                BadBoy_data['AoE'] = 1
            end
            UpdateButton("AoE")
        end

        --Cooldown Key Toggle
        if CDTimer == nil then CDTimer = 0; end
        if SpecificToggle("Cooldown Mode") == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - CDTimer > 0.25 then
            CDTimer = GetTime()
            if BadBoy_data['Cooldowns'] ~= #CooldownsModes then
                BadBoy_data['Cooldowns'] = BadBoy_data['Cooldowns']+1
            else
                BadBoy_data['Cooldowns'] = 1
            end
            UpdateButton("Cooldowns")
        end

        --Defensive Key Toggle
        if DefTimer == nil then DefTimer = 0; end
        if SpecificToggle("Defensive Mode") == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - DefTimer > 0.25 then
            DefTimer = GetTime()
            if BadBoy_data['Defensive'] ~= #DefensiveModes then
                BadBoy_data['Defensive'] = BadBoy_data['Defensive']+1
            else
                BadBoy_data['Defensive'] = 1
            end
            UpdateButton("Defensive")
        end

        --Interrupt Key Toggle
        if IntTimer == nil then IntTimer = 0; end
        if SpecificToggle("Interrupt Mode") == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - IntTimer > 0.25 then
            IntTimer = GetTime()
            if BadBoy_data['Interrupts'] ~= #InterruptsModes then
                BadBoy_data['Interrupts'] = BadBoy_data['Interrupts']+1
            else
                BadBoy_data['Interrupts'] = 1
            end
            UpdateButton("Interrupts")
        end

        --Thrash Key Toggle
        if ThrashTimer == nil then ThrashTimer = 0; end
        if ThrashMode == nil then ThrashMode = 1; end
        if SpecificToggle("Thrash Toggle") == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - ThrashTimer > 0.25 then
            ThrashTimer = GetTime()
            if BadBoy_data['Thrash'] ~= #ThrashModes then
                BadBoy_data['Thrash'] = BadBoy_data['Thrash']+1
            else
                BadBoy_data['Thrash'] = 1
            end
            UpdateButton("Thrash")
        end

        --Symbiosis Key Toggle
        if SymTimer == nil then SymTimer = 0; end
        if SymMode == nil then SymMode = 1; end
        if SpecificToggle("Symbiosis Toggle") == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - SymTimer > 0.25 then
            SymTimer = GetTime()
            if BadBoy_data['Symbiosis'] ~= #SymbiosisModes then
                BadBoy_data['Symbiosis'] = BadBoy_data['Symbiosis']+1
            else
                BadBoy_data['Symbiosis'] = 1
            end
            UpdateButton("Symbiosis")
        end
    end


--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[]]     --[[]]   --[[]]              --[[]]                   --[[ ]]        --[[]]     --[[]]
--[[           ]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[]]     --[[]]
--[[        ]]      --[[]]                         --[[]]        --[[ ]]        --[[]]     --[[]]
--[[]]    --[[]]    --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]


    function RestorationToggles()






        -- Healing Button
        if  HealingModesLoaded ~= "Masou Restoration Healing Modes" then 
            HealingModes = { 
                [1] = { mode = "Off", value = 1 , overlay = "Healing Disabled", tip = "Will not allow healing.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "On", value = 2 , overlay = "Healing Enabled", tip = "Will allow healing.", highlight = 1, icon = 48438 },
             };
            CreateButton("Healing",1,0);
            HealingModesLoaded = "Masou Restoration Healing Modes";
        end
        -- DPS Button
        if  DPSModesLoaded ~= "Masou Restoration DPS Modes" then 
            DPSModes = { 
                [1] = { mode = "Off", value = 1 , overlay = "DPS Disabled", tip = "Will not allow DPSing.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "On", value = 2 , overlay = "DPS Enabled", tip = "Will allow DPSing.", highlight = 1, icon = 8921 },
             };
            CreateButton("DPS",0.5,1);
            DPSModesLoaded = "Masou Restoration DPS Modes";
        end
        -- Defensive Button
        if  DefensiveModesLoaded ~= "Masou Restoration Defensive Modes" then 
            DefensiveModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Barkskin.", highlight = 1, icon = 22812 }
            };
            CreateButton("Defensive",2,0);
            DefensiveModesLoaded = "Masou Restoration Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Masou Restoration Cooldowns Modes" then 
            CooldownsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Includes config's selected spells.", highlight = 1, icon = 92364 },
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Tranquility.", highlight = 1, icon = 740 }
            };
            CreateButton("Cooldowns",1.5,1);
            CooldownsModesLoaded = "Masou Restoration Cooldowns Modes";
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