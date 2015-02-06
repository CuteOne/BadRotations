if select(3,UnitClass("player")) == 10 then


  function MonkBrewToggles()

    -- Aoe Button
    if AoEModesLoaded ~= "Brew Monk AoE Modes" then
      AoEModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = _SpinningCraneKick },
        [2] = { mode = "Sing", value = 2 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = _Jab }
      };
      CreateButton("AoE",1,0)
      AoEModesLoaded = "Brew Monk AoE Modes";
    end
    -- Cooldowns Button
    if CooldownsModesLoaded ~= "Cooldown Modes" then
      CustomCooldownsModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = _InvokeXuen },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = _InvokeXuen },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] }
      };
      CooldownsModes = CustomCooldownsModes
      CreateButton("Cooldowns",2,0)
      CooldownsModesLoaded = "Cooldown Modes";
    end

    -- Defensive Button
    if DefensiveModesLoaded ~= "Defensive Modes" then
      CustomDefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Defensive Cooldowns - Adjust in config", highlight = 1, icon = _Guard },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] }
      };
      DefensiveModes = CustomDefensiveModes
      CreateButton("Defensive",3,0)
      DefensiveModesLoaded = "Defensive Modes";
    end

    -- Interrupts Button
    if InterruptsModesLoaded ~= "Interrupt Modes" then
      CustomInterruptsModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = _SpearHandStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] }
      };
      InterruptsModes = CustomInterruptsModes
      CreateButton("Interrupts",4,0)
      InterruptsModesLoaded = "Interrupt Modes";
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
  -- TODO: Switch AOE mode to just single or auto - no need for forced AOE
  -- TODO: Add option/switch to assign a keyboard press (like alt or ctrl) to cast barrel throw and ox statue

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


  -- TODO: Add toggle for FoF
  -- TODO: Switch AOE mode to just single or auto - no need for forced AOE
  -- TODO: Add option/switch to assign a keyboard press (like alt or ctrl) to cast touch of karma and leg sweep




end
