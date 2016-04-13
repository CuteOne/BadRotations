if select(3,UnitClass("player")) == 3 then


  -- Config Panel
  function BeastConfig()

      bb.ui.window.profile = bb.ui:createProfileWindow("Beastmaster")
      local section

      --- Wrapper
      section = bb.ui:createSection(bb.ui.window.profile, "Pet Management")
      -- Auto Call Pet Toggle
      bb.ui:createDropdown(section, "Auto Call Pet", {"|cffFFDD11Pet 1","|cffFFDD11Pet 2","|cffFFDD11Pet 3","|cffFFDD11Pet 4","|cffFFDD11Pet 5"}, 1, "|cffFFDD11Set to desired |cffFFFFFFPet to Whistle.")
      -- Intimidation
      bb.ui:createCheckbox(section,"Intimidation")
      -- Mend Pet
      bb.ui:createSpinner(section, "Mend Pet", 35, 0, 100, 5, "|cffFFDD11Under what Pet %HP to use |cffFFFFFFMend Pet")
      bb.ui:checkSectionState(section)

      --- Wrapper
      section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
      -- Bestial Wrath
      bb.ui:createDropdown(section, "Bestial Wrath", bb.dropOptions.CD, 3)
      -- Explosive Trap
      bb.ui:createDropdown(section, "Explosive Trap", {"|cffFF0000Never","|cffFFDD112 mobs","|cff00FF00Always"}, 2, "|cffFFDD11Sets how you want |cffFFFFFFExplosive Trap |cffFFDD11to react.")
      -- Focus Fire
      bb.ui:createDropdown(section, "Focus Fire", bb.dropOptions.CD, 3)
      -- Stampede
      bb.ui:createDropdown(section, "Stampede", bb.dropOptions.CD, 2)
      bb.ui:checkSectionState(section)

      --- Wrapper
      section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
      -- Deterrence
      bb.ui:createSpinner(section, "Deterrence", 20, 0, 100, 5, "|cffFFDD11Under what %HP to use |cffFFFFFFDeterrence")
      -- Feign Death
      bb.ui:createSpinner(section, "Feign Death", 20, 0, 100, 5, "|cffFFDD11Under what %HP to use |cffFFFFFFFeign Death")
      -- Misdirection
      bb.ui:createDropdown(section, "Misdirection", {"|cffFF0000Me.Aggro","|cffFFDD11Any.Aggro","|cffFFFF00Enforce","|cff00FF00Always"}, 2, "|cffFFDD11Sets how you want |cffFFFFFFMisdirection |cffFFDD11to react.")
      bb.ui:checkSectionState(section)


      --- Wrapper
      section = bb.ui:createSection(bb.ui.window.profile, "Utilities")
      -- Auto-Aspect Toggle
      bb.ui:createSpinner(section, "Auto-Aspect", 3, 1, 10, 1, "|cffFFDD11How long do you want to run before enabling |cffFFFFFFAspect.")
      bb.ui:createDropdown(section, "Aspect", {"|cffFF0000Cheetah","|cffFFDD11Pack"}, 1, "|cffFFDD11Sets which Aspect to use.")
      -- Standard Interrupt
      bb.ui:createSpinner(section, "Counter Shot", 35, 0, 100, 5, "|cffFFDD11Over what % of cast we want to |cffFFFFFFCounter Shot.")
      bb.ui:checkSectionState(section)


      --[[ Rotation Dropdown ]]--
      bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"CodeMyLife"})
      bb:checkProfileWindowStatus()
  end


end
