if select(3,UnitClass("player")) == 9 then
  function AfflictionConfig()
    if currentConfig ~= "Demonology CodeMyLife" then

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
      CreateNewTitle(thisConfig,"Demonology |cffFF0000CodeMyLife")
      generateWrapper("Buffs")

      generateWrapper("DPS")

      -- Multi-Moonfire
      CreateNewCheck(thisConfig,"Multi-Dotting")
      CreateNewText(thisConfig,"Multi-Dotting")

      generateWrapper("Cooldowns")

      generateWrapper("Healing")

      generateWrapper("Defensive")

      -- Healthstone
      CreateNewCheck(thisConfig,"Healthstone")
      CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 35, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
      CreateNewText(thisConfig,"Healthstone")

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
