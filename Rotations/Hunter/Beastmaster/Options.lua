if select(3,UnitClass("player")) == 3 then


  -- Config Panel
  function BeastConfig()

      bb.profile_window = createNewProfileWindow("Beastmaster")
      local section

      --- Wrapper
      section = createNewSection(bb.profile_window, "Pet Management")
      -- Auto Call Pet Toggle
      createNewDropdown(section, "Auto Call Pet", {"|cffFFDD11Pet 1","|cffFFDD11Pet 2","|cffFFDD11Pet 3","|cffFFDD11Pet 4","|cffFFDD11Pet 5"}, 1, "|cffFFDD11Set to desired |cffFFFFFFPet to Whistle.")
      -- Intimidation
      createNewCheckbox(section,"Intimidation")
      -- Mend Pet
      createNewSpinner(section, "Mend Pet", 35, 0, 100, 5, "|cffFFDD11Under what Pet %HP to use |cffFFFFFFMend Pet")
      checkSectionState(section)

      --- Wrapper
      section = createNewSection(bb.profile_window, "Cooldowns")
      -- Bestial Wrath
      createNewDropdown(section, "Bestial Wrath", bb.dropOptions.CD, 3)
      -- Explosive Trap
      createNewDropdown(section, "Explosive Trap", {"|cffFF0000Never","|cffFFDD112 mobs","|cff00FF00Always"}, 2, "|cffFFDD11Sets how you want |cffFFFFFFExplosive Trap |cffFFDD11to react.")
      -- Focus Fire
      createNewDropdown(section, "Focus Fire", bb.dropOptions.CD, 3)
      -- Stampede
      createNewDropdown(section, "Stampede", bb.dropOptions.CD, 2)
      checkSectionState(section)

      --- Wrapper
      section = createNewSection(bb.profile_window, "Defensive")
      -- Deterrence
      createNewSpinner(section, "Deterrence", 20, 0, 100, 5, "|cffFFDD11Under what %HP to use |cffFFFFFFDeterrence")
      -- Feign Death
      createNewSpinner(section, "Feign Death", 20, 0, 100, 5, "|cffFFDD11Under what %HP to use |cffFFFFFFFeign Death")
      -- Misdirection
      createNewDropdown(section, "Misdirection", {"|cffFF0000Me.Aggro","|cffFFDD11Any.Aggro","|cffFFFF00Enforce","|cff00FF00Always"}, 2, "|cffFFDD11Sets how you want |cffFFFFFFMisdirection |cffFFDD11to react.")
      checkSectionState(section)


      --- Wrapper
      section = createNewSection(bb.profile_window, "Utilities")
      -- Auto-Aspect Toggle
      createNewSpinner(section, "Auto-Aspect", 3, 1, 10, 1, "|cffFFDD11How long do you want to run before enabling |cffFFFFFFAspect.")
      createNewDropdown(section, "Aspect", {"|cffFF0000Cheetah","|cffFFDD11Pack"}, 1, "|cffFFDD11Sets which Aspect to use.")
      -- Standard Interrupt
      createNewSpinner(section, "Counter Shot", 35, 0, 100, 5, "|cffFFDD11Over what % of cast we want to |cffFFFFFFCounter Shot.")
      checkSectionState(section)


      --[[ Rotation Dropdown ]]--
      createNewRotationDropdown(bb.profile_window.parent, {"CodeMyLife"})
      bb:checkProfileWindowStatus()
  end


end
