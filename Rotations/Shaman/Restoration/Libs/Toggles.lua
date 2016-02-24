if select(3, UnitClass("player")) == 7 then

  function RestorationToggles()
    -- Healing Button
    if  HealingModesLoaded ~= "Restoration Shaman Healing Modes" then
      HealingModes = {
        [1] = { mode = "Off", value = 1 , overlay = "Healing Disabled", tip = "Will not allow healing.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "On", value = 2 , overlay = "Healing Enabled", tip = "Will allow healing.", highlight = 1, icon = 73920 },
      };
      CreateButton("Healing",0.5,1);
      HealingModesLoaded = "Restoration Shaman Healing Modes";
    end
    -- Interrupts Button
    if  InterruptsModesLoaded ~= "Restoration Shaman Interrupts Modes" then
      InterruptsModes = {
        [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0,icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1 , icon = 57994}
      }
      CreateButton("Interrupts",1.5,1)
      InterruptsModesLoaded = "Restoration Shaman Interrupts Modes"
    end

    -- Defensive Button
    if  DefensiveModesLoaded ~= "Restoration Shaman Defensive Modes" then
      DefensiveModes = {
        [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "Includes Deterrence.", highlight = 1 , icon = 108271}
      }
      CreateButton("Defensive",1,0)
      DefensiveModesLoaded = "Restoration Shaman Defensive Modes"
    end
    -- Cooldowns Button
    if  CooldownsModesLoaded ~= "Restoration Shaman Cooldowns Modes" then
      CooldownsModes = {
        [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0 , icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]},
        [2] = { mode = "All", value = 2 , overlay = "Cooldowns Enabled", tip = "Includes Ascendance, Stormlash.", highlight = 1, icon = 114052 }
      }
      CreateButton("Cooldowns",2,0)
      CooldownsModesLoaded = "Restoration Shaman Cooldowns Modes"
    end
    -- Cooldowns Button
    if  DamageModesLoaded ~= "Restoration Shaman Damage Modes" then
      DamageModes = {
        [1] = { mode = "None", value = 1 , overlay = "Damage Disabled", tip = "Will not use Damage.", highlight = 0 , icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]},
        [2] = { mode = "All", value = 2 , overlay = "Damage Enabled", tip = "Will DPS", highlight = 1, icon = 51505 }
      }
      CreateButton("Damage",2.5,1)
      DamageModesLoaded = "Restoration Shaman Damage Modes"
    end
  end

end

  