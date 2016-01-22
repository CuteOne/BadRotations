if select(3,UnitClass("player")) == 9 then
  function DestructionToggles()
    -- AoE Button
   if  AoEModesLoaded ~= "Destruction Warlock AoE Modes" then
      AoEModes = {
        [1] = { mode = "Off", value = 1 , overlay = "AoE Disabled", tip = "Will not AoE.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "On", value = 2 , overlay = "AoE Enabled", tip = "Will allow AoE.", highlight = 1, icon = 104232 },
      };
      CreateButton("AoE",1,0);
      AoEModesLoaded = "Destruction Warlock AoE Modes";
    end
    -- DPS Button
    if  STModesLoaded ~= "Destruction Warlock ST Modes" then
      STModes = {
        [1] = { mode = "Off", value = 1 , overlay = "Single Target Disabled", tip = "Will not allow Single Target.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "On", value = 2 , overlay = "Single Target Enabled", tip = "Will allow Single Target.", highlight = 1, icon = 116858 },
      };
      CreateButton("ST",2,0);
      STModesLoaded = "Destruction Warlock ST Modes";
    end
    -- Defensive Button
    if  DefensiveModesLoaded ~= "Destruction Warlock Defensive Modes" then
      DefensiveModes = {
        [1] = { mode = "Off", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "On", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Fortifying Brew.", highlight = 1, icon = 104773 }
      };
      CreateButton("Defensive",0.5,1);
      DefensiveModesLoaded = "Destruction Warlock Defensive Modes";
    end
    -- Cooldowns Button
    if  CooldownsModesLoaded ~= "Destruction Warlock Cooldowns Modes" then
      CooldownsModes = {
        [1] = { mode = "Off", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Revival.", highlight = 1, icon = 113858 }
      };
      CreateButton("Cooldowns",1.5,1);
      CooldownsModesLoaded = "Destruction Warlock Cooldowns Modes";
    end
    if InterruptsModesLoaded ~= "Destruction Warlock Interrupts Modes" then
      InterruptsModes = {
        [1] = { mode = "Off", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]},
        [2] = { mode = "On", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = 30283}
      };
      CreateButton("Interrupts",3,0)
      InterruptsModesLoaded = "Destruction Warlock Interrupts Modes";
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