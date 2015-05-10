if select(3, UnitClass("player")) == 7 then

  function KeyToggles()
    -- AoE Button
    if AoEModesLoaded ~= "Cute AoE Modes" then
      CustomAoEModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = _ChainLightning},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = _ChainLightning},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = _LightningBolt}
      };
      AoEModes = CustomAoEModes
      CreateButton("AoE",1,0)
      AoEModesLoaded = "Cute AoE Modes";
    end

    -- Cooldowns Button
    if CooldownsModesLoaded ~= "Cute Cooldowns Modes" then
      CustomCooldownsModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = _AscendanceEnhancement},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = _AscendanceEnhancement},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = _AscendanceEnhancement}
      };
      CooldownsModes = CustomCooldownsModes
      CreateButton("Cooldowns",2,0)
      CooldownsModesLoaded = "Cute Cooldowns Modes";
    end

    -- Defensive Button
    if DefensiveModesLoaded ~= "Cute Defensive Modes" then
      CustomDefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = _ShamanisticRage},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = _ShamanisticRage}
      };
      DefensiveModes = CustomDefensiveModes
      CreateButton("Defensive",3,0)
      DefensiveModesLoaded = "Cute Defensive Modes";
    end

    -- Interrupts Button
    if InterruptsModesLoaded ~= "Cute Interrupt Modes" then
      CustomInterruptsModes = {
        [1] = { mode = "On", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = _WindShear},
        [2] = { mode = "Off", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = _WindShear}
      };
      InterruptsModes = CustomInterruptsModes
      CreateButton("Interrupts",4,0)
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
      UpdateButton("AoE")
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
      UpdateButton("Cooldowns")
    end
  end
end
