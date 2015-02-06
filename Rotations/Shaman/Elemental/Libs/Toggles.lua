if select(3, UnitClass("player")) == 7 then

  function ElementalToggles()
    -- Aoe Button
    if  AoEModesLoaded ~= "CML Elemental AoE Modes" then
      AoEModes = {
        [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "Recommended for one or two targets.", highlight = 0, icon = 403 },
        [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "Recommended for three targets or more.", highlight = 0, icon = 421 },
        [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "Recommended for lazy people like me.", highlight = 1, icon = 51505 }
      }
      CreateButton("AoE",0.5,1)
      AoEModesLoaded = "CML Elemental AoE Modes"
    end
    -- Interrupts Button
    if  InterruptsModesLoaded ~= "CML Elemental Interrupts Modes" then
      InterruptsModes = {
        [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = 57994 }
      }
      CreateButton("Interrupts",1.5,1)
      InterruptsModesLoaded = "CML Elemental Interrupts Modes"
    end

    -- Defensive Button
    if  DefensiveModesLoaded ~= "CML Elemental Defensive Modes" then
      DefensiveModes = {
        [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "Includes Deterrence.", highlight = 1, icon = 108271 }
      }
      CreateButton("Defensive",1,0)
      DefensiveModesLoaded = "CML Elemental Defensive Modes"
    end
    -- Cooldowns Button
    if  CooldownsModesLoaded ~= "CML Elemental Cooldowns Modes" then
      CooldownsModes = {
        [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Includes config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]] },
        [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "Includes Ascendance, Stormlash.", highlight = 1, icon = 114049 }
      }
      CreateButton("Cooldowns",2,0)
      CooldownsModesLoaded = "CML Elemental Cooldowns Modes"
    end

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
  end
end
