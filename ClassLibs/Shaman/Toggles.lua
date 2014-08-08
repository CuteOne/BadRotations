if select(3, UnitClass("player")) == 7 then

--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]         --[[]]        --[[]]     --[[]]   --[[           ]]   --[[           ]]       
--[[           ]]   --[[  ]]   --[[]]   --[[]]     --[[]]        --[[  ]]       --[[  ]]   --[[]]   --[[           ]]   --[[           ]]
--[[]]              --[[    ]] --[[]]   --[[]]     --[[]]       --[[    ]]      --[[    ]] --[[]]   --[[]]              --[[]]
--[[           ]]   --[[           ]]   --[[           ]]      --[[      ]]     --[[           ]]   --[[]]              --[[           ]]
--[[]]              --[[           ]]   --[[]]     --[[]]     --[[        ]]    --[[           ]]   --[[]]              --[[]]
--[[           ]]   --[[]]   --[[  ]]   --[[]]     --[[]]    --[[]]    --[[]]   --[[]]   --[[  ]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[]]      --[[]]  --[[]]     --[[]]   --[[           ]]   --[[           ]]


    function SpecificToggle()
        if BadBoy_data["Drop AoE Toggle"] == 1 then
            return IsLeftControlKeyDown();
        elseif BadBoy_data["Drop AoE Toggle"] == 2 then
            return IsLeftShiftKeyDown();
        elseif BadBoy_data["Drop AoE Toggle"] == 3 then
            return IsRightControlKeyDown();
        elseif BadBoy_data["Drop AoE Toggle"] == 4 then
            return IsRightShiftKeyDown();
        elseif BadBoy_data["Drop AoE Toggle"] == 5 then
            return IsRightAltKeyDown();
        end
    end

    function KeyToggles()
     -- AoE Button
        if AoEModesLoaded ~= "Cute AoE Modes" then 
            CustomAoEModes = { 
                [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range."},  
                [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used."},
                [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used."}
            };
           AoEModes = CustomAoEModes
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
           CooldownsModesLoaded = "Cute Cooldowns Modes";
        end

     -- Defensive Button
        if DefensiveModesLoaded ~= "Cute Defensive Modes" then 
            CustomDefensiveModes = { 
                [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns."},
                [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used."}
            };
            DefensiveModes = CustomDefensiveModes
            DefensiveModesLoaded = "Cute Defensive Modes";
        end

     -- Interrupts Button
        if InterruptsModesLoaded ~= "Cute Interrupt Modes" then 
            CustomInterruptsModes = { 
                [1] = { mode = "On", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts."},
                [2] = { mode = "Off", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used."}
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
    end

--[[           ]]   --[[]]              --[[           ]]
--[[           ]]   --[[]]              --[[           ]]
--[[]]              --[[]]              --[[]]
--[[           ]]   --[[]]              --[[           ]]
--[[]]              --[[]]              --[[]]
--[[           ]]   --[[]]              --[[           ]]
--[[           ]]   --[[           ]]   --[[           ]]


    function ElementalToggles()
        -- Aoe Button
        if  AoEModesLoaded ~= "CML Elemental AoE Modes" then 
            AoEModes = { 
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "Recommended for one or two targets.", highlight = 0 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "Recommended for three targets or more.", highlight = 0 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "Recommended for lazy people like me.", highlight = 1 }
            };
            AoEModesLoaded = "CML Elemental AoE Modes";
        end
        -- Interrupts Button
        if  InterruptsModesLoaded ~= "CML Elemental Interrupts Modes" then 
            InterruptsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0 },
                [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1 }
            };
            InterruptsModesLoaded = "CML Elemental Interrupts Modes";
        end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "CML Elemental Defensive Modes" then 
            DefensiveModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0 },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "Includes Deterrence.", highlight = 1 }
            };
            DefensiveModesLoaded = "CML Elemental Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "CML Elemental Cooldowns Modes" then 
            CooldownsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0 },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Includes config's selected spells.", highlight = 1 },
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "Includes Ascendance, Stormlash.", highlight = 1 }
            };
            CooldownsModesLoaded = "CML Elemental Cooldowns Modes";
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
        -- Aoe Button
        if  AoEModesLoaded ~= "CML Restoration AoE Modes" then 
            AoEModes = { 
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "Recommended for one or two targets.", highlight = 0 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "Recommended for three targets or more.", highlight = 0 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "Recommended for lazy people like me.", highlight = 1 }
            };
            AoEModesLoaded = "CML Restoration AoE Modes";
        end
        -- Interrupts Button
        if  InterruptsModesLoaded ~= "CML Restoration Interrupts Modes" then 
            InterruptsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0 },
                [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1 }
            };
            InterruptsModesLoaded = "CML Restoration Interrupts Modes";
        end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "CML Restoration Defensive Modes" then 
            DefensiveModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0 },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "Includes Deterrence.", highlight = 1 }
            };
            DefensiveModesLoaded = "CML Restoration Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "CML Restoration Cooldowns Modes" then 
            CooldownsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0 },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Includes config's selected spells.", highlight = 1 },
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "Includes Ascendance, Stormlash.", highlight = 1 }
            };
            CooldownsModesLoaded = "CML Restoration Cooldowns Modes";
        end
    end

end