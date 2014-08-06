if select(3, UnitClass("player")) == 11 then


    function SpecificToggle()
        if BadBoy_data["Drop Rotation Mode"] == 1 then
            return IsLeftControlKeyDown();
        elseif BadBoy_data["Drop Rotation Mode"] == 2 then
            return IsLeftShiftKeyDown();
        elseif BadBoy_data["Drop Rotation Mode"] == 3 then
            return IsRightControlKeyDown();
        elseif BadBoy_data["Drop Rotation Mode"] == 4 then
            return IsRightShiftKeyDown();
        elseif BadBoy_data["Drop Rotation Mode"] == 5 then
            return IsRightAltKeyDown();
        end
    end

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




        --AoE Key Toggle
        if AOETimer == nil then AOETimer = 0; end
        if SpecificToggle() == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - AOETimer > 0.25 then
            AOETimer = GetTime()
            if BadBoy_data['AoE'] ~= #AoEModes then
                BadBoy_data['AoE'] = BadBoy_data['AoE']+1
            else
                BadBoy_data['AoE'] = 1
            end
        end

        --Cooldown Key Toggle
        if CDTimer == nil then CDTimer = 0; end
        if IsRightControlKeyDown() == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - CDTimer > 0.25 then
            CDTimer = GetTime()
            if BadBoy_data['Cooldowns'] ~= #CooldownsModes then
                BadBoy_data['Cooldowns'] = BadBoy_data['Cooldowns']+1
            else
                BadBoy_data['Cooldowns'] = 1
            end
        end

        --Thrash Key Toggle
        if ThrashTimer == nil then ThrashTimer = 0; end
        if ThrashMode == nil then ThrashMode = 0; end
        if IsRightAltKeyDown() == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - ThrashTimer > 0.25 then
            ThrashTimer = GetTime()
            if BadBoy_data['Check Thrash Toggle'] == 1 then
                if ThrashMode==0 then
                    ThrashMode = 1
                    ChatOverlay("|cff15FF00-Thrash Enabled-")
                elseif ThrashMode == 1 then
                    ThrashMode = 0
                    ChatOverlay("|cffD60000-Thrash Disabled-")
                end
            end
        end 
    end

end