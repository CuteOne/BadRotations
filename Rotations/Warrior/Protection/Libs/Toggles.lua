if select(3, UnitClass("player")) == 1  then

  function WarriorProtToggles()
    if AoEModesLoaded ~= "Prot Warrior AoE Modes" then
      AoEModes = {
        [1] = { mode = "Sing", value = 1 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = 20243 },
        [2] = { mode = "AoE", value = 2 , overlay = "Aoe Target Rotation", tip = "Aoe target rotation used.", highlight = 0, icon = 6343 },
        [3] = { mode = "Auto", value = 3 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = 6343 }
      };
      CreateButton("AoE",1,0)
      AoEModesLoaded = "Prot Warrior AoE Modes";
    end

    -- Cooldowns Button
    if CooldownsModesLoaded ~= "Prot Warrior Cooldowns Modes" then
      CustomCooldownsModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = 107574 },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = 107574 },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = 107574 }
      };
      CooldownsModes = CustomCooldownsModes
      CreateButton("Cooldowns",2,0)
      CooldownsModesLoaded = "Prot Warrior Cooldowns Modes";
    end

    -- Defensive Button
    if DefensiveModesLoaded ~= "Prot Warrior Defensive Modes" then
      CustomDefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = 871 },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = 871 }
      };
      DefensiveModes = CustomDefensiveModes
      CreateButton("Defensive",3,0)
      DefensiveModesLoaded = "Prot Warrior Defensive Modes";
    end

    -- Interrupts Button
    if InterruptsModesLoaded ~= "Prot Warrior Interrupt Modes" then
      CustomInterruptsModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = 6552 },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = 6552 }
      };
      InterruptsModes = CustomInterruptsModes
      CreateButton("Interrupts",4,0)
      InterruptsModesLoaded = "Prot Warrior Interrupt Modes";
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