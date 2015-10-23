if select(3,UnitClass("player")) == 6 then
  function UnholyConfig()
      bb.profile_window = createNewProfileWindow("Unholy")

      local section

      --- General Rotation
      section = createNewSection(bb.profile_window, "General Rotation")

      -- Pause Toggle
      createNewDropdown(section, "Pause Key", bb.dropOptions.Toggle2 ,4)

      -- 2nd Pause Toggle
      createNewDropdown(section, "2nd Pause Key", bb.dropOptions.Toggle2 ,4)

      -- DnD / Defile Key
      createNewDropdown(section, "DnD / Defile Key", bb.dropOptions.Toggle2 ,4)

      -- AMZ Key
      createNewDropdown(section, "AMZ Key", bb.dropOptions.Toggle2 ,4)

      -- Blood Boil Spam Targets
      createNewSpinner(section, "Start spamming Blood Boil at |cffFF0000XX|cffFFBB00 targets.",5,0,10,1,"Start spamming Blood Boil at |cffFF0000XX|cffFFBB00 targets.")

      checkSectionState(section)




      -- Wrapper
      section = createNewSection(bb.profile_window, "Buffs")

      -- Horn of Winter
      createNewCheckbox(section,"Horn of Winter")

      checkSectionState(section)



      -- Wrapper
      section = createNewSection(bb.profile_window, "Cooldowns")

      -- Potion
      createNewCheckbox(section,"Potion")

      -- Empower Rune Weapon
      createNewCheckbox(section,"Empower Rune Weapon")

      -- Summon Gargoyle
      createNewCheckbox(section,"Summon Gargoyle")

      -- Breath of Sindragosa
      createNewCheckbox(section,"Breath of Sindragosa")

      -- Dark Transformation
      -- createNewCheckbox(section,"Dark Transformation")

      -- Racial (Orc/Troll)
      createNewCheckbox(section,"Racial (Orc/Troll)")

      checkSectionState(section)



      -- Wrapper
      section = createNewSection(bb.profile_window, "Defensives")

      -- Icebound Fortitude
      createNewSpinner(section, "Icebound Fortitude", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFIcebound Fortitude")

      -- Anti Magic Shell
      createNewSpinner(section, "Anti-Magic Shell", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFAnti Magic Shell")

      -- Healthstone / Pot
      createNewSpinner(section, "Healthstone / Potion", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone / Healing Potion")

      -- Death Pact
      createNewSpinner(section, "Death Pact", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDeath Pact")

      -- Death Siphon
      createNewSpinner(section, "Death Siphon", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDeath Siphon")

      -- Death Strike
      createNewSpinner(section, "Death Strike", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDeath Strike")

      -- Death Strike (Dark Succor)
      -- createNewSpinner(section, "Death Strike (Dark Succor)", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDeath Strike (Dark Succor)")

      checkSectionState(section)



      -- Wrapper
      section = createNewSection(bb.profile_window, "Interrupts")

      -- Mind Freeze
      createNewSpinner(section, "Mind Freeze", 20, 0, 100, 5, "Interrupt at % casttime with Mind Freeze")

      -- Strangulate
      createNewSpinner(section, "Mind Freeze", 20, 0, 100, 5, "Interrupt at % casttime with Strangulate");

      checkSectionState(section)



      -- Wrapper
      section = createNewSection(bb.profile_window, "Misc")

      -- Dummy DPS Test
      createNewSpinner(section, "DPS Testing", 5, 1, 15, 1, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1")

      checkSectionState(section)


      --[[ Rotation Dropdown ]]--
      createNewRotationDropdown(bb.profile_window.parent, {"Chumii"})
      bb:checkProfileWindowStatus()
  end
end
