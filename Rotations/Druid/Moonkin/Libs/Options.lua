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

      generateWrapper("General")

      -- Pause Toggle
      CreateNewCheck(thisConfig,"Pause Toggle")
      CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle2")
      CreateNewText(thisConfig,"Pause Toggle")

      -- Mark Of The Wild
      CreateNewCheck(thisConfig,"Mark of the Wild")
      CreateNewText(thisConfig,"Mark of the Wild")

       -- Mark Of The Wild
      CreateNewCheck(thisConfig,"Moonkin Form")
      CreateNewText(thisConfig,"Moonkin Form")

      -- Dummy DPS Test
      CreateNewCheck(thisConfig,"DPS Testing");
      CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1");
      CreateNewText(thisConfig,"DPS Testing");

      generateWrapper("Cooldowns")

      -- Celestial Alignment
      CreateNewCheck(thisConfig,"Celestial Alignment")
      CreateNewText(thisConfig,"Celestial Alignment")

      -- Force Of Nature
      CreateNewCheck(thisConfig,"Force Of Nature")
      CreateNewText(thisConfig,"Force Of Nature")

      -- Incarnation
      CreateNewCheck(thisConfig,"Incarnation")
      CreateNewText(thisConfig,"Incarnation")

      -- Racial
      CreateNewCheck(thisConfig,"Racial");
      CreateNewText(thisConfig,"Racial");

      -- Trinket
      CreateNewCheck(thisConfig,"Use Trinket");
      CreateNewText(thisConfig,"Use Trinket");

      generateWrapper("Healing")

      -- Healing Touch
      CreateNewCheck(thisConfig,"Healing Touch")
      CreateNewBox(thisConfig, "Healing Touch", 0, 100  , 5, 75, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation|cffFFBB00 on |cffFFFFFFSelf.")
      CreateNewText(thisConfig,"Healing Touch")

      -- Natures Vigil
      CreateNewCheck(thisConfig,"Natures Vigil")
      CreateNewText(thisConfig,"Natures Vigil")

      -- Rejuvenation
      CreateNewCheck(thisConfig,"Rejuvenation")
      CreateNewBox(thisConfig, "Rejuvenation", 0, 100  , 5, 75, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation|cffFFBB00 on |cffFFFFFFSelf.")
      CreateNewText(thisConfig,"Rejuvenation")

      generateWrapper("Defensive")

      -- Healthstone
      CreateNewCheck(thisConfig,"Healthstone / Potion")
      CreateNewBox(thisConfig, "Healthstone / Potion", 0, 100  , 5, 35, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone or Healing Potion (Pot > Stone)")
      CreateNewText(thisConfig,"Healthstone / Potion")

      -- Barkskin
      CreateNewCheck(thisConfig,"Barkskin")
      CreateNewBox(thisConfig, "Barkskin", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")
      CreateNewText(thisConfig,"Barkskin")

      generateWrapper("Utilities")
      -- General Configs
      CreateGeneralsConfig()


      WrapsManager()
    end
  end


end
