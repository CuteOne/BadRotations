if select(3,UnitClass("player")) == 10 then

--[[           ]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]
--[[           ]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]
--[[]]     --[[]]   --[[]]     --[[]]   --[[]]              --[[ ]]   --[[ ]]
--[[         ]]     --[[           ]]   --[[           ]]   --[[           ]]
--[[]]     --[[]]   --[[        ]]      --[[]]              --[[           ]]
--[[           ]]   --[[]]    --[[]]    --[[           ]]   --[[ ]]   --[[ ]]
--[[           ]]   --[[]]     --[[]]   --[[           ]]    --[[]]   --[[]]

   function MonkBrewToggles()

        -- Aoe Button
        if  AoEModesLoaded ~= "Brew Monk AoE Modes" then
            AoEModes = {
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cff00FF00Single Target (1-2)", highlight = 0, icon = 108557 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cffFF0000AoE (3+)", highlight = 0, icon = 101546 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Auto-AoE", highlight = 1, icon = 116812 }
            };
            CreateButton("AoE",0.5,1)
            AoEModesLoaded = "Brew Monk AoE Modes";
        end
        -- Interrupts Button
        if  InterruptsModesLoaded ~= "Brew Monk Interrupts Modes" then
            InterruptsModes = {
                [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000Spells Included: \n|cffFFDD11Spear Hand Strike.", highlight = 1, icon = 116705 }
            };
            CreateButton("Interrupts",1,0)
            InterruptsModesLoaded = "Brew Monk Interrupts Modes";
        end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "Brew Monk Defensive Modes" then
            DefensiveModes = {
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffC0C0C0Defensive \n|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffC0C0C0Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Fortifying Brew, \nElusive Brew, \nGuard", highlight = 1, icon = 115203 }
            };
            CreateButton("Defensive",1.5,1)
            DefensiveModesLoaded = "Brew Monk Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Brew Monk Cooldowns Modes" then
            CooldownsModes = {
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]]},
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Avenging Wrath, \nHoly Avenger.", highlight = 1, icon = 115080 }
            };
            CreateButton("Cooldowns",2,0)
            CooldownsModesLoaded = "Brew Monk Cooldowns Modes";
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

--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[ ]]   --[[ ]]        --[[ ]]        --[[           ]]   --[[           ]]
--[[           ]]        --[[ ]]        --[[]]                   --[[ ]]
--[[           ]]        --[[ ]]        --[[           ]]        --[[ ]]
--[[]]     --[[]]        --[[ ]]                   --[[]]        --[[ ]]
--[[]]     --[[]]        --[[ ]]        --[[           ]]        --[[ ]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[ ]]

   function MonkMistToggles()


        -- Healing Button
        if  HealingModesLoaded ~= "Mist Monk Healing Modes" then
            HealingModes = {
                [1] = { mode = "Off", value = 1 , overlay = "Healing Disabled", tip = "Will not allow healing.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "On", value = 2 , overlay = "Healing Enabled", tip = "Will allow healing.", highlight = 1, icon = 115151 },
             };
            CreateButton("Healing",1,0);
            HealingModesLoaded = "Mist Monk Healing Modes";
        end
        -- DPS Button
        if  DPSModesLoaded ~= "Mist Monk DPS Modes" then
            DPSModes = {
                [1] = { mode = "Off", value = 1 , overlay = "DPS Disabled", tip = "Will not allow DPSing.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "On", value = 2 , overlay = "DPS Enabled", tip = "Will allow DPSing.", highlight = 1, icon = 100787 },
             };
            CreateButton("DPS",0.5,1);
            DPSModesLoaded = "Mist Monk DPS Modes";
        end
        -- Defensive Button
        if  DefensiveModesLoaded ~= "Mist Monk Defensive Modes" then
            DefensiveModes = {
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Fortifying Brew.", highlight = 1, icon = 115203 }
            };
            CreateButton("Defensive",2,0);
            DefensiveModesLoaded = "Mist Monk Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Mist Monk Cooldowns Modes" then
            CooldownsModes = {
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Includes config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]] },
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Revival.", highlight = 1, icon = 115310 }
            };
            CreateButton("Cooldowns",1.5,1);
            CooldownsModesLoaded = "Mist Monk Cooldowns Modes";
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
                [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = _SpinningCraneKick},
                [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = _SpinningCraneKick},
                [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = _Jab}
            };
           AoEModes = CustomAoEModes
           CreateButton("AoE",1,0)
           AoEModesLoaded = "Cute AoE Modes";
        end

     -- Cooldowns Button
        if CooldownsModesLoaded ~= "Cute Cooldowns Modes" then
            CustomCooldownsModes = {
                [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = _InvokeXuen},
                [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = _InvokeXuen},
                [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = _InvokeXuen}
            };
           CooldownsModes = CustomCooldownsModes
           CreateButton("Cooldowns",2,0)
           CooldownsModesLoaded = "Cute Cooldowns Modes";
        end

     -- Defensive Button
        if DefensiveModesLoaded ~= "Cute Defensive Modes" then
            CustomDefensiveModes = {
                [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = _DampenHarm},
                [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = _DampenHarm}
            };
            DefensiveModes = CustomDefensiveModes
            CreateButton("Defensive",3,0)
            DefensiveModesLoaded = "Cute Defensive Modes";
        end

     -- Interrupts Button
        if InterruptsModesLoaded ~= "Cute Interrupt Modes" then
            CustomInterruptsModes = {
                [1] = { mode = "On", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = _SpearHandStrike},
                [2] = { mode = "Off", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = _SpearHandStrike}
            };
            InterruptsModes = CustomInterruptsModes
            CreateButton("Interrupts",4,0)
            InterruptsModesLoaded = "Cute Interrupt Modes";
        end

     -- Storm, Earth, and Fire Button
        if SEFModesLoaded ~= "Cute SEF Modes" then
            CustomSEFModes = {
                [1] = { mode = "On", value = 2 , overlay = "Auto SEF Enabled", tip = "Will cast Storm, Earth, and Fire.", highlight = 1, icon = _StormEarthFire},
                [2] = { mode = "Off", value = 1 , overlay = "Auto SEF Disabled", tip = "Will NOT cast Storm, Earth, and Fire.", highlight = 0, icon = _StormEarthFire}
            };
            SEFModes = CustomSEFModes
            CreateButton("SEF",5,0)
            SEFModesLoaded = "Cute SEF Modes";
        end

     -- Flying Serpent Kick Button
        if FSKModesLoaded ~= "Cute FSK Modes" then
            CustomFSKModes = {
                [1] = { mode = "On", value = 2 , overlay = "Auto FSK Enabled", tip = "Will cast Flying Serpent Kick.", highlight = 1, icon = _FlyingSerpentKick},
                [2] = { mode = "Off", value = 1 , overlay = "Auto FSK Disabled", tip = "Will NOT cast Flying Serpent Kick.", highlight = 0, icon = _FlyingSerpentKick}
            };
            FSKModes = CustomFSKModes
            CreateButton("FSK",6,0)
            FSKModesLoaded = "Cute FSK Modes";
        end

     -- Chi Builder Button
        if BuilderModesLoaded ~= "Cute Chi Builder Modes" then
            CustomBuilderModes = {
                [1] = { mode = "On", value = 2 , overlay = "Chi Builder Enabled", tip = "Generates Chi when out of combat.", highlight = 1, icon = _ExpelHarm},
                [2] = { mode = "Off", value = 1 , overlay = "Chi Builder Disabled", tip = "No Chi will be generated when out of combat.", highlight = 0, icon = _ExpelHarm}
            };
            BuilderModes = CustomBuilderModes
            CreateButton("Builder",7,0)
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
                return false
            end
        end

    --AoE Key Toggle
        if AOETimer == nil then AOETimer = 0; end
        if SpecificToggle("Rotation Mode") and not GetCurrentKeyBoardFocus() and GetTime() - AOETimer > 0.25 then
            AOETimer = GetTime()
            UpdateButton("AoE")
        end

        --Cooldown Key Toggle
        if CDTimer == nil then CDTimer = 0; end
        if SpecificToggle("Cooldown Mode") and not GetCurrentKeyBoardFocus() and GetTime() - CDTimer > 0.25 then
            CDTimer = GetTime()
            UpdateButton("Cooldowns")
        end

        --Defensive Key Toggle
        if DefTimer == nil then DefTimer = 0; end
        if SpecificToggle("Defensive Mode") and not GetCurrentKeyBoardFocus() and GetTime() - DefTimer > 0.25 then
            DefTimer = GetTime()
            UpdateButton("Defensive")
        end

        --Interrupt Key Toggle
        if IntTimer == nil then IntTimer = 0; end
        if SpecificToggle("Interrupt Mode") and not GetCurrentKeyBoardFocus() and GetTime() - IntTimer > 0.25 then
            IntTimer = GetTime()
            UpdateButton("Interrupts")
        end

        --SEF Key Toggle
        if SEFTimer == nil then SEFTimer = 0; end
        if SpecificToggle("SEF Mode") and not GetCurrentKeyBoardFocus() and GetTime() - SEFTimer > 0.25 then
            SEFTimer = GetTime()
            UpdateButton("SEF")
        end

        --FSK Key Toggle
        if FSKTimer == nil then FSKTimer = 0; end
        if SpecificToggle("FSK Mode") and not GetCurrentKeyBoardFocus() and GetTime() - FSKTimer > 0.25 then
            FSKTimer = GetTime()
            UpdateButton("FSK")
        end

        --Chi Key Toggle
        if ChiTimer == nil then ChiTimer = 0; end
        if SpecificToggle("Builder Mode") and not GetCurrentKeyBoardFocus() and GetTime() - ChiTimer > 0.25 then
            ChiTimer = GetTime()
            UpdateButton("Builder")
        end
    end





end