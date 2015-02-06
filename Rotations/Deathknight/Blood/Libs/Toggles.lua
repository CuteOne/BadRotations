if select(3,UnitClass("player")) == 6 then

  function BloodToggles()

    -- Aoe Button
    if  AoEModesLoaded ~= "Blood DK AoE Modes" then
      AoEModes = {
        [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cff00FF00Recommended for \n|cffFFDD11Single Target(1-2).", highlight = 0, icon = 45477 },
        [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffFF0000Recommended for \n|cffFFDD11AoE(3+).", highlight = 0, icon = 49998 },
        [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffFFDD11Recommended for \n|cffFFDD11Lazy people like me.", highlight = 1, icon = 43265 }
      };
      CreateButton("AoE",1,0)
      AoEModesLoaded = "Blood DK AoE Modes"
    end

    -- Interrupts Button
    if  InterruptsModesLoaded ~= "Blood DK Interrupts Modes" then
      InterruptsModes = {
        [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Mind Freeze, \nStrangulate.", highlight = 1, icon = 47528 }
      };
      CreateButton("Interrupts",3,0)
      InterruptsModesLoaded = "Blood DK Interrupts Modes"
    end

    -- Defensive Button
    if  DefensiveModesLoaded ~= "Blood DK Defensive Modes" then
      DefensiveModes = {
        [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFDD11Blood Tap, \nIcebound Fortitude, \nAnti-Magic Shell.", highlight = 1, icon = 48792 }
      }
      CreateButton("Defensive",2,0)
      DefensiveModesLoaded = "Blood DK Defensive Modes"
    end
  end

end
