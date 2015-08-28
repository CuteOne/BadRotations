if select(3, UnitClass("player")) == 4 then

  function AssToggles()
    if GetSpecialization() == 1 then
      -- AoE Button
      if AoEModesLoaded ~= "Cute AoE Modes" then
        CustomAoEModes = {
          [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = _FanOfKnives},
          [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = _FanOfKnives},
          [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = _Mutilate}
        };
        AoEModes = CustomAoEModes
        CreateButton("AoE",1,0)
        AoEModesLoaded = "Cute AoE Modes";
      end

      -- Cooldowns Button
      if CooldownsModesLoaded ~= "Cute Cooldowns Modes" then
        CustomCooldownsModes = {
          [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = _Preparation},
          [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = _Preparation},
          [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = _Preparation}
        };
        CooldownsModes = CustomCooldownsModes
        CreateButton("Cooldowns",2,0)
        CooldownsModesLoaded = "Cute Cooldowns Modes";
      end

      -- Defensive Button
      if DefensiveModesLoaded ~= "Cute Defensive Modes" then
        CustomDefensiveModes = {
          [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = _Evasion},
          [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = _Evasion}
        };
        DefensiveModes = CustomDefensiveModes
        CreateButton("Defensive",3,0)
        DefensiveModesLoaded = "Cute Defensive Modes";
      end

      -- Interrupts Button
      if InterruptsModesLoaded ~= "Cute Interrupt Modes" then
        CustomInterruptsModes = {
          [1] = { mode = "On", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = _Kick},
          [2] = { mode = "Off", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = _Kick}
        };
        InterruptsModes = CustomInterruptsModes
        CreateButton("Interrupts",4,0)
        InterruptsModesLoaded = "Cute Interrupt Modes";
      end

      -- Cleave Button
      if CleaveModesLoaded ~= "Cute Cleave Modes" then
          CustomCleaveModes = {
              [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = _CrimsonTempest },
              [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = _CrimsonTempest }
          };
          CleaveModes = CustomCleaveModes
          CreateButton("Cleave",5,0)
          CleaveModesLoaded = "Cute Cleave Modes";
      end

      -- Pick Pocket Button
      if PickerModesLoaded ~= "Cute Pick Pocket Modes" then
        CustomPickerModes = {
          [1] = { mode = "Auto", value = 2 , overlay = "Auto Pick Pocket Enabled", tip = "Profile will attempt to Pick Pocket prior to combat.", highlight = 1, icon = _PickPocket},
          [2] = { mode = "Only", value = 1 , overlay = "Only Pick Pocket Enabled", tip = "Profile will attempt to Sap and only Pick Pocket, no combat.", highlight = 0, icon = _PickPocket},
          [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Profile will not use Pick Pocket.", highlight = 0, icon = _PickPocket}
        };
        PickerModes = CustomPickerModes
        CreateButton("Picker",6,0)
        PickerModesLoaded = "Cute Pick Pocket Modes";
      end

      function SpecificToggle(toggle)
        if getOptionValue(toggle) == 1 then
          return IsLeftControlKeyDown();
        elseif getOptionValue(toggle) == 2 then
          return IsLeftShiftKeyDown();
        elseif getOptionValue(toggle) == 3 then
          return IsRightControlKeyDown();
        elseif getOptionValue(toggle) == 4 then
          return IsRightShiftKeyDown();
        elseif getOptionValue(toggle) == 5 then
          return IsRightAltKeyDown();
        elseif getOptionValue(toggle) == 6 then
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

      --Cleave Key Toggle
      if CleaveTimer == nil then CleaveTimer = 0; end
      if SpecificToggle("Cleave Mode") and not GetCurrentKeyBoardFocus() and GetTime() - CleaveTimer > 0.25 then
        CleaveTimer = GetTime()
        UpdateButton("Cleave")
      end

      --Pick Pocket Key Toggle
      if PPTimer == nil then PPTimer = 0; end
      if SpecificToggle("Pick Pocket Mode") and not GetCurrentKeyBoardFocus() and GetTime() - PPTimer > 0.25 then
        PPTimer = GetTime()
        UpdateButton("Picker")
      end

    end
  end
end
