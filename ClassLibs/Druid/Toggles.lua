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
           CooldownsModesLoaded = "Cute Cooldowns Modes";
        end

     -- Defensive Button
        if DefensiveModesLoaded ~= "Cute Defensive Modes" then 
            CustomDefensiveModes = { 
                [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1 },
                [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 2 }
            };
            DefensiveModes = CustomDefensiveModes
            DefensiveModesLoaded = "Cute Defensive Modes";
        end

     -- Interrupts Button
        if InterruptsModesLoaded ~= "Cute Interrupt Modes" then 
            CustomInterruptsModes = { 
                [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1 },
                [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 2 }
            };
            InterruptsModes = CustomInterruptsModes
            InterruptsModesLoaded = "Cute Interrupt Modes";
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
        end

        --Thrash Key Toggle
        if ThrashTimer == nil then ThrashTimer = 0; end
        if ThrashMode == nil then ThrashMode = 0; end
        if SpecificToggle("Thrash Toggle") == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - ThrashTimer > 0.25 then
            ThrashTimer = GetTime()
            if isChecked("Thrash Toggle") then
                if ThrashMode==0 then
                    ThrashMode = 1
                    ChatOverlay("|cff15FF00-Thrash Enabled-")
                elseif ThrashMode == 1 then
                    ThrashMode = 0
                    ChatOverlay("|cffD60000-Thrash Disabled-")
                end
            else
                return false
            end
        end

        --Symbiosis Key Toggle
        if SymTimer == nil then SymTimer = 0; end
        if SymMode == nil then SymMode = 0; end
        if SpecificToggle("Symbiosis Toggle") == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - SymTimer > 0.25 then
            SymTimer = GetTime()
            if isChecked("Symbiosis Toggle") then
                if SymMode==0 then
                    SymMode = 1
                    ChatOverlay("|cff15FF00-Symbiosis Enabled-")
                elseif SymMode == 1 then
                    SymMode = 0
                    ChatOverlay("|cffD60000-Symbiosis Disabled-")
                end
            else
                return false
            end
        end  
    end

end