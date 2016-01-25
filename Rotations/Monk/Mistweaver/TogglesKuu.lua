function MistweaverToggles()


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
        [1] = { mode = "Off", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "On", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Fortifying Brew.", highlight = 1, icon = 115203 }
      };
      CreateButton("Defensive",2,0);
      DefensiveModesLoaded = "Mist Monk Defensive Modes";
    end
    -- Cooldowns Button
    if  CooldownsModesLoaded ~= "Mist Monk Cooldowns Modes" then
      CooldownsModes = {
        [1] = { mode = "Off", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Revival.", highlight = 1, icon = 115310 }
      };
      CreateButton("Cooldowns",1.5,1);
      CooldownsModesLoaded = "Mist Monk Cooldowns Modes";
    end
    if InterruptsModesLoaded ~= "Mist Monk Interrupts Modes" then
      InterruptsModes = {
        [1] = { mode = "Off", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = _SpearHandStrike},
        [2] = { mode = "On", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = _SpearHandStrike}
      };
      CreateButton("Interrupts",3,0)
      InterruptsModesLoaded = "Mist Monk Interrupts Modes";
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