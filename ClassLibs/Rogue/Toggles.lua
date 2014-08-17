if select(3, UnitClass("player")) == 4 then
    
      --[[]]        --[[           ]]   --[[           ]]         --[[]]        --[[           ]]   --[[           ]]
     --[[  ]]       --[[           ]]   --[[           ]]        --[[  ]]       --[[           ]]   --[[           ]]
    --[[    ]]      --[[]]              --[[]]                  --[[    ]]      --[[]]              --[[]]
   --[[      ]]     --[[           ]]   --[[           ]]      --[[      ]]     --[[           ]]   --[[           ]]
  --[[        ]]               --[[]]              --[[]]     --[[        ]]               --[[]]              --[[]]
 --[[]]    --[[]]   --[[           ]]   --[[           ]]    --[[]]    --[[]]   --[[           ]]   --[[           ]]   
--[[]]      --[[]]  --[[           ]]   --[[           ]]   --[[]]      --[[]]  --[[           ]]   --[[           ]]
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
                [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target."},
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

     -- Pick Pocket Button
        if PickerModesLoaded ~= "Cute Pick Pocket Modes" then 
            CustomPickerModes = { 
                [1] = { mode = "Auto", value = 2 , overlay = "Auto Pick Pocket Enabled", tip = "Profile will attempt to Pick Pocket prior to combat."},
                [2] = { mode = "Only", value = 1 , overlay = "Only Pick Pocket Enabled", tip = "Profile will attempt to Sap and only Pick Pocket, no combat."}
                [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Profile will not use Pick Pocket."}
            };
            PickerModes = CustomPickerModes
            CreateButton("Picker",5,0)
            BuilderModesLoaded = "Cute Pick Pocket Modes";
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

        --Pick Pocket Key Toggle
        if PPTimer == nil then PPTimer = 0; end
        if SpecificToggle("Picker Mode") == 1 and GetCurrentKeyBoardFocus() == nil and GetTime() - PPTimer > 0.25 then
            PPTimer = GetTime()
            if BadBoy_data['Picker'] ~= #PickerModes then
                BadBoy_data['Picker'] = BadBoy_data['Picker']+1
            else
                BadBoy_data['Picker'] = 1
            end
            UpdateButton("Picker")
        end
    end

--[[           ]]   --[[           ]]   --[[]]     --[[]]   --[[           ]]         --[[]]        --[[           ]]
--[[           ]]   --[[           ]]   --[[ ]]   --[[ ]]   --[[           ]]        --[[  ]]       --[[           ]]
--[[]]              --[[]]     --[[]]   --[[           ]]   --[[]]     --[[]]       --[[    ]]           --[[ ]]
--[[]]              --[[]]     --[[]]   --[[           ]]   --[[         ]]        --[[      ]]          --[[ ]]
--[[]]              --[[]]     --[[]]   --[[]]     --[[]]   --[[]]     --[[]]     --[[        ]]         --[[ ]]
--[[           ]]   --[[           ]]   --[[]]     --[[]]   --[[           ]]    --[[]]    --[[]]        --[[ ]]
--[[           ]]   --[[           ]]   --[[]]     --[[]]   --[[           ]]   --[[]]      --[[]]       --[[ ]]

--[[           ]]   --[[]]     --[[]]   --[[           ]] 
--[[           ]]   --[[]]     --[[]]   --[[           ]] 
--[[]]              --[[]]     --[[]]   --[[]]     --[[]]
--[[           ]]   --[[]]     --[[]]   --[[         ]]  
           --[[]]   --[[]]     --[[]]   --[[]]     --[[]]
--[[           ]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[           ]]   --[[           ]]
function SubToggles()
   -- Aoe Button
    if  AoEModesLoaded ~= "Sub Rogue AoE Modes" then 
        AoEModes = { 
            [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cff00FF00Recommended for \n|cffFFDD11Single Target(1-2).", highlight = 0 },
            [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffFF0000Recommended for \n|cffFFDD11AoE(3+).", highlight = 0 },
            [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffFFDD11Recommended for \n|cffFFDD11Lazy people like me.", highlight = 1 }
        };
        CreateButton("AoE",1.5,1);
        AoEModesLoaded = "Sub Rogue AoE Modes";
    end

    -- Interrupts Button
    if  InterruptsModesLoaded ~= "Sub Rogue Interrupts Modes" then 
        InterruptsModes = { 
            [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffFF0000No Interrupts will be used.", highlight = 0 },
            [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Mind Freeze.", highlight = 1 }
        };
        CreateButton("Interrupts",0.5,1);
        InterruptsModesLoaded = "Sub Rogue Interrupts Modes";
    end

    -- Defensive Button
    if  DefensiveModesLoaded ~= "Sub Rogue Defensive Modes" then 
        DefensiveModes = { 
            [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffFF0000No Defensive Cooldowns will be used.", highlight = 0 },
            [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Blood Tap, \nBlood Truc, \nGuardian of Ancient Kings.", highlight = 1 }
        };
        CreateButton("Defensive",1,0);
        DefensiveModesLoaded = "Sub Rogue Defensive Modes";
    end

    -- Cooldowns Button
    if  CooldownsModesLoaded ~= "Sub Rogue Cooldowns Modes" then 
        CooldownsModes = { 
            [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000No cooldowns will be used.", highlight = 0 },
            [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Config's selected spells.", highlight = 1 },
            [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Blood Fru, \nHBlood Fâché.", highlight = 1 }
        };
        CreateButton("Cooldowns",2,0);
        CooldownsModesLoaded = "Sub Rogue Cooldowns Modes";
    end
end
end
