if select(3, UnitClass("player")) == 11 then
  function MoonkinToggles()
    -- Aoe Button
    if  MoonAoEModesLoaded ~= "Moonkin Druid AoE Modes" then
      MoonAoEModes = {
        [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cff00FF00Single Target (1-2)", highlight = 0, icon = core.spell.moonfire },
        [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cffFF0000AoE (3+)", highlight = 0, icon = core.spell.starfall },
        [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Auto-AoE", highlight = 1, icon = core.spell.sunfire }
      }
      CreateButton("MoonAoE",0.5,1)
      AoEModesLoaded = "Moonkin Druid AoE Modes"
    end
    -- Interrupts Button
    if  InterruptsModesLoaded ~= "Moonkin Druid Interrupts Modes" then
      MoonInterruptsModes = {
        [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000Spells Included: \n|cffFFDD11Solar Beam.", highlight = 1, icon = core.spell.solarBeam }
      }
      CreateButton("MoonInterrupts",1,0)
      InterruptsModesLoaded = "Moonkin Druid Interrupts Modes"
    end
    -- Defensive Button
    if  DefensiveModesLoaded ~= "Moonkin Druid Defensive Modes" then
      MoonDefensiveModes = {
        [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffC0C0C0Defensive \n|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffC0C0C0Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Barkskin,\nRejuvenation,\nHealing Touch.", highlight = 1, icon = core.spell.barkskin }
      }
      CreateButton("MoonDefensive",1.5,1)
      DefensiveModesLoaded = "Moonkin Druid Defensive Modes"
    end
    -- Cooldowns Button
    if  CooldownsModesLoaded ~= "Moonkin Druid Cooldowns Modes" then
      MoonCooldownsModes = {
        [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]]},
        [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Celestial Alignment,\nIncarnation,\nForce of Nature.", highlight = 1, icon = core.spell.forceOfNature }
      }
      CreateButton("MoonCooldowns",2,0)
      CooldownsModesLoaded = "Moonkin Druid Cooldowns Modes"
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
