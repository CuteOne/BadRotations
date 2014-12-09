if select(3,UnitClass("player")) == 6 then
  function UnholyConfig()
    if currentConfig ~= "Unholy Chumii" then
      ClearConfig();
      thisConfig = 0;
      -- Title
      CreateNewTitle(thisConfig,"Unholy |cffFF0000Chumii");

      -- Wrapper
      CreateNewWrap(thisConfig,"---------- Keys ----------");

      -- Pause Toggle
      CreateNewCheck(thisConfig,"Pause Toggle");
      CreateNewDrop(thisConfig,"Pause Toggle", 4, "Toggle")
      CreateNewText(thisConfig,"Pause Key");

      -- Dummy DPS Test
      CreateNewCheck(thisConfig,"DPS Testing");
      CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1");
      CreateNewText(thisConfig,"DPS Testing");

      CreateGeneralsConfig();
      WrapsManager();
    end
  end
end