if select(3, UnitClass("player")) == 11 then
  function GuardianToggles()
    -- Aoe Button

    --[2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = thb },
    if AoEModesLoaded ~= "Guardian Druid AoE Modes" then
      AoEModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = thb },
        [2] = { mode = "Sing", value = 2 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = mgl }
      }
      CreateButton("AoE",1,0)
      AoEModesLoaded = "Guardian Druid AoE Modes"
    end
    -- -- Interrupts Button
    -- if  InterruptsModesLoaded ~= "Guardian Druid Interrupts Modes" then
    --     InterruptsModes = {
    --         [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
    --         [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000Spells Included: \n|cffFFDD11Spear Hand Strike.", highlight = 1, icon = 116705 }
    --     }
    --     CreateButton("Interrupts",1,0)
    --     InterruptsModesLoaded = "Guardian Druid Interrupts Modes"
    -- end

    -- Defensive Button
    if  DefensiveModesLoaded ~= "Guardian Druid Defensive Modes" then
      DefensiveModes = {
        [1] = { mode = "SD", value = 1 , overlay = "SD Mode", tip = "|cffC0C0C0Defensive \n|cffFF0000SD Mode", highlight = 1, icon = 62606 },
        [2] = { mode = "FR", value = 2 , overlay = "FR Mode", tip = "|cffC0C0C0Defensive \n|cffFF0000FR Mode", highlight = 1, icon = 22842 },
        [3] = { mode = "none", value = 3 , overlay = "Manual Mode", tip = "|cffC0C0C0Defensive \n|cffFF0000Manual Mode", highlight = 1, icon = 22842 }
      }
      CreateButton("Defensive",2,0)
      DefensiveModesLoaded = "Guardian Druid Defensive Modes"
    end
    -- -- Cooldowns Button
    -- if  CooldownsModesLoaded ~= "Guardian Druid Cooldowns Modes" then
    --     CooldownsModes = {
    --         [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
    --         [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]]},
    --         [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Avenging Wrath, \nHoly Avenger.", highlight = 1, icon = 115080 }
    --     }
    --     CreateButton("Cooldowns",2,0)
    --     CooldownsModesLoaded = "Guardian Druid Cooldowns Modes"
    -- end

    function SpecificToggle(toggle)
      if getValue(toggle) == 1 then
        return IsLeftControlKeyDown()
      elseif getValue(toggle) == 2 then
        return IsLeftShiftKeyDown()
      elseif getValue(toggle) == 3 then
        return IsLeftAltKeyDown()
      elseif getValue(toggle) == 4 then
        return IsRightControlKeyDown()
      elseif getValue(toggle) == 5 then
        return IsRightShiftKeyDown()
      elseif getValue(toggle) == 6 then
        return IsRightAltKeyDown()
      elseif getValue(toggle) == 7 then
        return 1
      end
    end

    --AoE Key Toggle
    if AOETimer == nil then AOETimer = 0 end
    if SpecificToggle("Rotation Mode") and not GetCurrentKeyBoardFocus() and GetTime() - AOETimer > 0.25 then
      AOETimer = GetTime()
      UpdateButton("AoE")
    end
  end
end
