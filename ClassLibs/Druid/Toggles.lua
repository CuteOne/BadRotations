if select(3, UnitClass("player")) == 11 then

    function KeyToggles()
     -- AoE Button
        if AoEModesLoaded ~= "Cute AoE Modes" then 
            CustomAoEModes = { 
                [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 3 },  
                [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 2 },
                [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 1 }
            };
           AoEModes = CustomAoEModes
           CreateButton("AoE",1,0)
           AoEModesLoaded = "Cute AoE Modes";
        end
            
     -- Cooldowns Button
        if CooldownsModesLoaded ~= "Cute Cooldowns Modes" then 
            CustomCooldownsModes = { 
                [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1 },  
                [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1 },
                [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 2 }
            };
           CooldownsModes = CustomCooldownsModes
           CreateButton("Cooldowns",2,0)
           CooldownsModesLoaded = "Cute Cooldowns Modes";
        end

     -- Defensive Button
        if DefensiveModesLoaded ~= "Cute Defensive Modes" then 
            CustomDefensiveModes = { 
                [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1 },
                [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 2 }
            };
            DefensiveModes = CustomDefensiveModes
            CreateButton("Defensive",3,0)
            DefensiveModesLoaded = "Cute Defensive Modes";
        end

     -- Interrupts Button
        if InterruptsModesLoaded ~= "Cute Interrupt Modes" then 
            CustomInterruptsModes = { 
                [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1 },
                [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 2 }
            };
            InterruptsModes = CustomInterruptsModes
            CreateButton("Interrupts",4,0)
            InterruptsModesLoaded = "Cute Interrupt Modes";
        end
     -- Thrash Button
        if ThrashModesLoaded ~= "Cute Thrash Modes" then 
            CustomThrashModes = { 
                [1] = { mode = "On", value = 1 , overlay = "Thrash Enabled", tip = "Includes Basic Interrupts.", highlight = 1 },
                [2] = { mode = "Off", value = 2 , overlay = "Thrash Disabled", tip = "No Interrupts will be used.", highlight = 2 }
            };
            ThrashModes = CustomThrashModes
            CreateButton("Thrash",1,-1)
            ThrashModesLoaded = "Cute Thrash Modes";
        end
     -- Symbiosis Button
        if SymbiosisModesLoaded ~= "Cute Symbiosis Modes" then 
            CustomSymbiosisModes = { 
                [1] = { mode = "On", value = 1 , overlay = "Symbiosis Enabled", tip = "Includes Basic Interrupts.", highlight = 1 },
                [2] = { mode = "Off", value = 2 , overlay = "Symbiosis Disabled", tip = "No Interrupts will be used.", highlight = 2 }
            };
            SymbiosisModes = CustomSymbiosisModes
            CreateButton("Symbiosis",3,-1)
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
                return 0
            end
        end




        -- Healing Button
        if  HealingModesLoaded ~= "Masou Restoration Healing Modes" then 
            HealingModes = { 
                [1] = { mode = "Off", value = 1 , overlay = "Healing Disabled", tip = "Will not allow healing.", highlight = 0 },
                [2] = { mode = "On", value = 2 , overlay = "Healing Enabled", tip = "Will allow healing.", highlight = 1 },
             };
            CreateButton("Healing",1,0);
            HealingModesLoaded = "Masou Restoration Healing Modes";
        end
        -- DPS Button
        if  DPSModesLoaded ~= "Masou Restoration DPS Modes" then 
            DPSModes = { 
                [1] = { mode = "Off", value = 1 , overlay = "DPS Disabled", tip = "Will not allow DPSing.", highlight = 0 },
                [2] = { mode = "On", value = 2 , overlay = "DPS Enabled", tip = "Will allow DPSing.", highlight = 1 },
             };
            CreateButton("DPS",0.5,1);
            DPSModesLoaded = "Masou Restoration DPS Modes";
        end
        -- Defensive Button
        if  DefensiveModesLoaded ~= "Masou Restoration Defensive Modes" then 
            DefensiveModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0 },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Barkskin.", highlight = 1 }
            };
            CreateButton("Defensive",2,0);
            DefensiveModesLoaded = "Masou Restoration Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Masou Restoration Cooldowns Modes" then 
            CooldownsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0 },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Includes config's selected spells.", highlight = 1 },
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Tranquility.", highlight = 1 }
            };
            CreateButton("Cooldowns",1.5,1);
            CooldownsModesLoaded = "Masou Restoration Cooldowns Modes";
        end
    end



end