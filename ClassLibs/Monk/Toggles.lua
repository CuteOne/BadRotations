if select(3,UnitClass("player")) == 10 then

--[[           ]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]
--[[           ]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]   
--[[]]     --[[]]   --[[]]     --[[]]   --[[]]              --[[ ]]   --[[ ]]
--[[         ]]     --[[           ]]   --[[           ]]   --[[           ]]
--[[]]     --[[]]   --[[        ]]      --[[]]              --[[           ]]
--[[           ]]   --[[]]    --[[]]    --[[           ]]   --[[ ]]   --[[ ]]
--[[           ]]   --[[]]     --[[]]   --[[           ]]    --[[]]   --[[]]

--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[ ]]   --[[ ]]        --[[ ]]        --[[           ]]   --[[           ]]
--[[           ]]        --[[ ]]        --[[]]                   --[[ ]]
--[[           ]]        --[[ ]]        --[[           ]]        --[[ ]]
--[[]]     --[[]]        --[[ ]]                   --[[]]        --[[ ]]
--[[]]     --[[]]        --[[ ]]        --[[           ]]        --[[ ]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[ ]]

--[[]]     --[[]]   --[[           ]]   --[[]]     --[[]]   --[[         ]]
--[[]]     --[[]]         --[[]]        --[[  ]]   --[[]]   --[[          ]]
--[[ ]]   --[[ ]]         --[[]]        --[[    ]] --[[]]   --[[]]     --[[]]
--[[           ]]         --[[]]        --[[           ]]   --[[]]     --[[]]
--[[           ]]         --[[]]        --[[           ]]   --[[]]     --[[]]
--[[ ]]   --[[ ]]         --[[]]        --[[]]   --[[  ]]   --[[          ]]
 --[[]]   --[[]]    --[[           ]]   --[[]]     --[[]]   --[[         ]]

    function WindwalkerToggles()
        -- AoE Button
        if AoEModesLoaded ~= "Cute AoE Modes" then 
            CustomAoEModes = { 
                [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range."},  
                [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used."},
                [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used."}
            };
           AoEModes = CustomAoEModes
           CreateButton("AoE",1,0)
           AoEModesLoaded = "Cute AoE Modes";
        end
            
     -- Cooldowns Button
        if CooldownsModesLoaded ~= "Cute Cooldowns Modes" then 
            CustomCooldownsModes = { 
                [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection."},  
                [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target."},
                [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used."}
            };
           CooldownsModes = CustomCooldownsModes
           CreateButton("Cooldowns",2,0)
           CooldownsModesLoaded = "Cute Cooldowns Modes";
        end

     -- Defensive Button
        if DefensiveModesLoaded ~= "Cute Defensive Modes" then 
            CustomDefensiveModes = { 
                [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns."},
                [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used."}
            };
            DefensiveModes = CustomDefensiveModes
            CreateButton("Defensive",3,0)
            DefensiveModesLoaded = "Cute Defensive Modes";
        end

     -- Interrupts Button
        if InterruptsModesLoaded ~= "Cute Interrupt Modes" then 
            CustomInterruptsModes = { 
                [1] = { mode = "On", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts."},
                [2] = { mode = "Off", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used."}
            };
            InterruptsModes = CustomInterruptsModes
            CreateButton("Interrupts",4,0)
            InterruptsModesLoaded = "Cute Interrupt Modes";
        end

     -- Chi Builder Button
        if BuilderModesLoaded ~= "Cute Chi Builder Modes" then 
            CustomBuilderModes = { 
                [1] = { mode = "On", value = 2 , overlay = "Chi Builder Enabled", tip = "Generates Chi when out of combat."},
                [2] = { mode = "Off", value = 1 , overlay = "Chi Builder Disabled", tip = "No Chi will be generated when out of combat."}
            };
            BuilderModes = CustomBuilderModes
            CreateButton("Builder",5,0)
            BuilderModesLoaded = "Cute Chi Builder Modes";
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

        --Chi Key Toggle
        if ChiTimer == nil then ChiTimer = 0; end
        if SpecificToggle("Builder Mode") == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - ChiTimer > 0.25 then
            ChiTimer = GetTime()
            if BadBoy_data['Builder'] ~= #BuilderModes then
                BadBoy_data['Builder'] = BadBoy_data['Builder']+1
            else
                BadBoy_data['Builder'] = 1
            end
            UpdateButton("Builder")
        end
    end





end