if select(3, UnitClass("player")) == 1 then

  function WarriorArmsToggles()

    -- AoE Button
    -- if AoEModesLoaded ~= "Arms Warrior AoE Modes" then
    --     CustomAoEModes = {
    --     [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip ="Automatic Rotation Mode based on number of targets in range", highlight = 0, icon = SweepingStrikes },
    --     [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip ="Multiple Target Rotation", highlight = 0, icon = Cleave },
    --     [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip ="Multiple Target Rotation", highlight = 0, icon = MortalStrike }
    --     };
    --     AoEModes = CustomAoEModes
    --     CreateButton("AoE",1,0)
    --     AoEModesLoaded = "Arms Warrior AoE Modes";
    -- end

    if AoEModesLoaded ~= "Arms Warrior AoE Modes" then
      CustomAoEModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 0, icon = _SweepingStrikes },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = _Whirlwind },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = _MortalStrike }
      };
      AoEModes = CustomAoEModes
      CreateButton("AoE",1,0)
      AoEModesLoaded = "Arms Warrior AoE Modes";
    end

    -- Cooldowns Button
    if CooldownsModesLoaded ~= "Cooldown Modes" then
      CustomCooldownsModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = _Recklessness },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = _Recklessness },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = _Recklessness }
      };
      CooldownsModes = CustomCooldownsModes
      CreateButton("Cooldowns",2,0)
      CooldownsModesLoaded = "Cooldown Modes";
    end

    -- Defensive Button
    if DefensiveModesLoaded ~= "Defensive Modes" then
      CustomDefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = _DiebytheSword },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = _DiebytheSword }
      };
      DefensiveModes = CustomDefensiveModes
      CreateButton("Defensive",3,0)
      DefensiveModesLoaded = "Defensive Modes";
    end

    -- Interrupts Button
    if InterruptsModesLoaded ~= "Interrupt Modes" then
      CustomInterruptsModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = _Pummel },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = _Pummel }
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


end
