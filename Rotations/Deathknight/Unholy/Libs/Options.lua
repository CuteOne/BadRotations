if select(3,UnitClass("player")) == 6 then
  function UnholyConfig()
    if currentConfig ~= "Unholy Chumii" then
      ClearConfig();
      thisConfig = 0;
      -- Title
      CreateNewTitle(thisConfig,"Unholy |cffFF0000Chumii");

      -- Wrapper
      CreateNewWrap(thisConfig,"--- General Rotation ---");

      -- Pause Toggle
      CreateNewCheck(thisConfig,"Pause Key");
      CreateNewDrop(thisConfig,"Pause Key", 4, "Toggle2")
      CreateNewText(thisConfig,"Pause Key");

      -- 2nd Pause Toggle
      CreateNewCheck(thisConfig,"2nd Pause Key");
      CreateNewDrop(thisConfig,"2nd Pause Key", 4, "Toggle2")
      CreateNewText(thisConfig,"2nd Pause Key");

      -- DnD / Defile Key
      CreateNewCheck(thisConfig,"DnD / Defile Key");
      CreateNewDrop(thisConfig,"DnD / Defile Key", 4, "Toggle2")
      CreateNewText(thisConfig,"DnD / Defile Key");

      -- AMZ Key
      CreateNewCheck(thisConfig,"AMZ Key");
      CreateNewDrop(thisConfig,"AMZ Key", 4, "Toggle2")
      CreateNewText(thisConfig,"AMZ Key");

      -- Blood Boil Spam Targets
      CreateNewBox(thisConfig, "Blood Boil Spam", 0, 10  , 1, 5, "Start spamming Blood Boil at |cffFF0000XX|cffFFBB00 targets. (Simc Rotation only)");
      CreateNewText(thisConfig,"Blood Boil Spam");

      CreateNewCheck(thisConfig,"Rotation")
      CreateNewDrop(thisConfig,"Rotation",1,"Choose Rotation to use.","Simc","Simple")
      CreateNewText(thisConfig,"Rotation")

      -- Wrapper
      CreateNewWrap(thisConfig,"--- Buffs ---");

      -- Horn of Winter
      CreateNewCheck(thisConfig,"Horn of Winter");
      CreateNewText(thisConfig,"Horn of Winter");

      -- Wrapper
      CreateNewWrap(thisConfig,"--- Cooldowns ---");

      -- Potion
      CreateNewCheck(thisConfig,"Potion");
      CreateNewText(thisConfig,"Potion");

      -- Empower Rune Weapon
      CreateNewCheck(thisConfig,"Empower Rune Weapon");
      CreateNewText(thisConfig,"Empower Rune Weapon");

      -- Summon Gargoyle
      CreateNewCheck(thisConfig,"Summon Gargoyle");
      CreateNewText(thisConfig,"Summon Gargoyle");

      -- Breath of Sindragosa
      CreateNewCheck(thisConfig,"Breath of Sindragosa");
      CreateNewText(thisConfig,"Breath of Sindragosa");

      -- -- Dark Transformation
      -- CreateNewCheck(thisConfig,"Dark Transformation");
      -- CreateNewText(thisConfig,"Dark Transformation");

      -- Racial (Orc/Troll)
      CreateNewCheck(thisConfig,"Racial (Orc/Troll)");
      CreateNewText(thisConfig,"Racial (Orc/Troll)");

      -- Wrapper
      CreateNewWrap(thisConfig,"--- Defensives ---");

      -- Icebound Fortitude
      CreateNewCheck(thisConfig,"Icebound Fortitude");
      CreateNewBox(thisConfig, "Icebound Fortitude", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFIcebound Fortitude");
      CreateNewText(thisConfig,"Icebound Fortitude");

      -- Anti Magic Shell
      CreateNewCheck(thisConfig,"Anti Magic Shell");
      CreateNewBox(thisConfig, "Anti Magic Shell", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFAnti Magic Shell");
      CreateNewText(thisConfig,"Anti Magic Shell");

      -- Healthstone / Pot
      CreateNewCheck(thisConfig,"Healthstone / Potion");
      CreateNewBox(thisConfig, "Healthston / Potion", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone / Healing Potion");
      CreateNewText(thisConfig,"Healthstone / Potion");

      -- Death Pact
      CreateNewCheck(thisConfig,"Death Pact");
      CreateNewBox(thisConfig, "Death Pact", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDeath Pact");
      CreateNewText(thisConfig,"Death Pact");

      -- Death Siphon
      CreateNewCheck(thisConfig,"Death Siphon");
      CreateNewBox(thisConfig, "Death Siphon", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDeath Siphon");
      CreateNewText(thisConfig,"Death Siphon");

      -- Death Strike
      CreateNewCheck(thisConfig,"Death Strike");
      CreateNewBox(thisConfig, "Death Strike", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDeath Strike");
      CreateNewText(thisConfig,"Death Strike");

      -- Death Strike (Dark Succor)
      -- CreateNewCheck(thisConfig,"Death Strike (Dark Succor)");
      -- CreateNewBox(thisConfig, "Death Strike (Dark Succor)", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDeath Strike (Dark Succor)");
      -- CreateNewText(thisConfig,"Death Strike (Dark Succor)");

       -- Wrapper
      CreateNewWrap(thisConfig,"--- Interrupts ---");

      -- Mind Freeze
      CreateNewCheck(thisConfig,"Mind Freeze");
      CreateNewBox(thisConfig, "Mind Freeze", 0, 100  , 5, 20, "Interrupt at % casttime with Mind Freeze");
      CreateNewText(thisConfig,"Mind Freeze");

      -- Strangulate
      CreateNewCheck(thisConfig,"Strangulate");
      CreateNewBox(thisConfig, "Strangulate", 0, 100  , 5, 20, "Interrupt at % casttime with Strangulate");
      CreateNewText(thisConfig,"Strangulate");

      -- Wrapper
      CreateNewWrap(thisConfig,"--- Misc ---");

      -- Dummy DPS Test
      CreateNewCheck(thisConfig,"DPS Testing");
      CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1");
      CreateNewText(thisConfig,"DPS Testing");

      CreateGeneralsConfig();
      WrapsManager();
    end
  end
end