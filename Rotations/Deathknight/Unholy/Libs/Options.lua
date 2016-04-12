if select(3,UnitClass("player")) == 6 then
  function UnholyConfig()
      bb.ui.window.profile = bb.ui:createProfileWindow("Unholy")

      local section

      --- General Rotation
      section = bb.ui:createSection(bb.ui.window.profile, "General Rotation")

      -- Pause Toggle
      bb.ui:createDropdown(section, "Pause Key", bb.dropOptions.Toggle2 ,4)

      -- 2nd Pause Toggle
      bb.ui:createDropdown(section, "2nd Pause Key", bb.dropOptions.Toggle2 ,4)

      -- DnD / Defile Key
      bb.ui:createDropdown(section, "DnD / Defile Key", bb.dropOptions.Toggle2 ,4)

      -- AMZ Key
      bb.ui:createDropdown(section, "AMZ Key", bb.dropOptions.Toggle2 ,4)

      -- Blood Boil Spam Targets
      bb.ui:createSpinner(section, "Start spamming Blood Boil at |cffFF0000XX|cffFFBB00 targets.",5,0,10,1,"Start spamming Blood Boil at |cffFF0000XX|cffFFBB00 targets.")

      bb.ui:checkSectionState(section)




      -- Wrapper
      section = bb.ui:createSection(bb.ui.window.profile, "Buffs")

      -- Horn of Winter
      bb.ui:createCheckbox(section,"Horn of Winter")

      bb.ui:checkSectionState(section)



      -- Wrapper
      section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")

      -- Potion
      bb.ui:createCheckbox(section,"Potion")

      -- Empower Rune Weapon
      bb.ui:createCheckbox(section,"Empower Rune Weapon")

      -- Summon Gargoyle
      bb.ui:createCheckbox(section,"Summon Gargoyle")

      -- Breath of Sindragosa
      bb.ui:createCheckbox(section,"Breath of Sindragosa")

      -- Dark Transformation
      -- bb.ui:createCheckbox(section,"Dark Transformation")

      -- Racial (Orc/Troll)
      bb.ui:createCheckbox(section,"Racial (Orc/Troll)")

      bb.ui:checkSectionState(section)



      -- Wrapper
      section = bb.ui:createSection(bb.ui.window.profile, "Defensives")

      -- Icebound Fortitude
      bb.ui:createSpinner(section, "Icebound Fortitude", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFIcebound Fortitude")

      -- Anti Magic Shell
      bb.ui:createSpinner(section, "Anti-Magic Shell", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFAnti Magic Shell")

      -- Healthstone / Pot
      bb.ui:createSpinner(section, "Healthstone / Potion", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone / Healing Potion")

      -- Death Pact
      bb.ui:createSpinner(section, "Death Pact", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDeath Pact")

      -- Death Siphon
      bb.ui:createSpinner(section, "Death Siphon", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDeath Siphon")

      -- Death Strike
      bb.ui:createSpinner(section, "Death Strike", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDeath Strike")

      -- Death Strike (Dark Succor)
      -- bb.ui:createSpinner(section, "Death Strike (Dark Succor)", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDeath Strike (Dark Succor)")

      bb.ui:checkSectionState(section)



      -- Wrapper
      section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")

      -- Mind Freeze
      bb.ui:createSpinner(section, "Mind Freeze", 20, 0, 100, 5, "Interrupt at % casttime with Mind Freeze")

      -- Strangulate
      bb.ui:createSpinner(section, "Mind Freeze", 20, 0, 100, 5, "Interrupt at % casttime with Strangulate");

      bb.ui:checkSectionState(section)



      -- Wrapper
      section = bb.ui:createSection(bb.ui.window.profile, "Misc")

      -- Dummy DPS Test
      bb.ui:createSpinner(section, "DPS Testing", 5, 1, 15, 1, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1")

      bb.ui:checkSectionState(section)


      --[[ Rotation Dropdown ]]--
      bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"Chumii"})
      bb:checkProfileWindowStatus()
  end
end
