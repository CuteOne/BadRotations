if select(3, UnitClass("player")) == 11 then
  function MoonkinConfig()
    if currentConfig ~= "Moonkin CodeMyLife" then

      local myColor = "|cffC0C0C0"
      local redColor = "|cffFF0011"
      local whiteColor = "|cffFFFFFF"
      local myClassColor = classColors[select(3,UnitClass("player"))].hex
      local function generateWrapper(wrapName)
        CreateNewWrap(thisConfig,whiteColor.."- "..redColor..wrapName..whiteColor.." -")
      end


      ClearConfig()
      thisConfig = 0
      -- Title
      CreateNewTitle(thisConfig,"Moonkin |cffFF0000CodeMyLife")
      generateWrapper("Buffs")

      -- Mark Of The Wild
      CreateNewCheck(thisConfig,"Mark Of The Wild")
      CreateNewText(thisConfig,"Mark Of The Wild")

      generateWrapper("DPS")
      -- Multi-Moonfire
      CreateNewCheck(thisConfig,"Multi-Moonfire")
      CreateNewText(thisConfig,"Multi-Moonfire")

      -- Starfall
      CreateNewCheck(thisConfig,"Starfall")
      CreateNewDrop(thisConfig,"Starfall",2,"CD")
      CreateNewText(thisConfig,"Starfall")

      generateWrapper("Cooldowns")

      -- Celestial Alignment
      CreateNewCheck(thisConfig,"Celestial Alignment")
      CreateNewDrop(thisConfig,"Celestial Alignment",1,"CD")
      CreateNewText(thisConfig,"Celestial Alignment")

      -- Force Of Nature
      if isKnown(core.spell.forceOfNature) then
        CreateNewCheck(thisConfig,"Force Of Nature")
        CreateNewDrop(thisConfig,"Force Of Nature",1,"CD")
        CreateNewText(thisConfig,"Force Of Nature")
      end

      -- Incarnation
      if isKnown(core.spell.incarnation) then
        CreateNewCheck(thisConfig,"Incarnation")
        CreateNewDrop(thisConfig,"Incarnation",1,"CD")
        CreateNewText(thisConfig,"Incarnation")
      end

      generateWrapper("Healing")

      -- Healing Touch
      CreateNewCheck(thisConfig,"Healing Touch")
      CreateNewBox(thisConfig, "Healing Touch", 0, 100  , 5, 75, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation|cffFFBB00 on |cffFFFFFFSelf.")
      CreateNewText(thisConfig,"Healing Touch")

      -- Natures Vigil
      if isKnown(core.spell.naturesVigil) then
        CreateNewCheck(thisConfig,"Natures Vigil")
        CreateNewDrop(thisConfig,"Natures Vigil",1,"CD")
        CreateNewText(thisConfig,"Natures Vigil")
      end

      -- Rejuvenation
      CreateNewCheck(thisConfig,"Rejuvenation")
      CreateNewBox(thisConfig, "Rejuvenation", 0, 100  , 5, 75, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation|cffFFBB00 on |cffFFFFFFSelf.")
      CreateNewText(thisConfig,"Rejuvenation")

      generateWrapper("Defensive")

      -- Healthstone
      CreateNewCheck(thisConfig,"Healthstone")
      CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 35, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
      CreateNewText(thisConfig,"Healthstone")

      -- Barkskin
      CreateNewCheck(thisConfig,"Barkskin")
      CreateNewBox(thisConfig, "Barkskin", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")
      CreateNewText(thisConfig,"Barkskin")

      generateWrapper("Toggles")

      -- Pause Toggle
      CreateNewCheck(thisConfig,"Pause Toggle")
      CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle2")
      CreateNewText(thisConfig,"Pause Toggle")

      -- Focus Toggle
      CreateNewCheck(thisConfig,"Focus Toggle")
      CreateNewDrop(thisConfig,"Focus Toggle", 2, "Toggle2")
      CreateNewText(thisConfig,"Focus Toggle")

      generateWrapper("Utilities")

      --Debug
      CreateNewCheck(666,"Debug")
      CreateNewText(666,"Debug")
      -- General Configs
      CreateGeneralsConfig()


      WrapsManager()
    end
  end


end
