if select(3, UnitClass("player")) == 4 then


  function titleOp(string)
    return CreateNewTitle(thisConfig,string);
  end
  function checkOp(string,tip)
    if tip == nil then
      return CreateNewCheck(thisConfig,string);
    else
      return CreateNewCheck(thisConfig,string,tip);
    end
  end
  function textOp(string)
    return CreateNewText(thisConfig,string);
  end
  function wrapOp(string)
    return CreateNewWrap(thisConfig,string);
  end
  function boxOp(string, minnum, maxnum, stepnum, defaultnum, tip)
    if tip == nil then
      return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum);
    else
      return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum, tip);
    end
  end
  function dropOp(string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
    return CreateNewDrop(thisConfig, string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10);
  end
  -- Config Panel
  function NewRogueConfig()
    --if not doneConfig then
    thisConfig = 0
    -- Title
    titleOp("CuteOne New Rogue");
    -- Spacer
    CreateGeneralsConfig();

    WrapsManager();
  --end
  end

  -- Config Panel
  function CombatOptions()
    --if not doneConfig then
    thisConfig = 0
    -- Title
    titleOp("Combat Defmaster");
    rogueCombat:baseOptions()
    rogueCombat:classOptions()

    wrapOp("--- General ---");

    -- Rotation
    dropOp("Rotation",1,"Select Rotation.","|cff00FF00SimC");
    textOp("Rotation");

    -- Dummy DPS Test
    --checkOp("DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.");
    --boxOp("DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
    --textOp("DPS Testing");

    -- Stealth Timer
    checkOp("Stealth Timer");
    boxOp("Stealth Timer", 0, 2, 0.25, 1, "|cffFFBB00How long to wait(seconds) before using \n|cffFFFFFFStealth.");
    textOp("Stealth Timer");

    -- Stealth
    checkOp("Stealth");
    dropOp("Stealth",1,"Stealthing method.","|cff00FF00Always","|cffFFDD00PrePot","|cffFF000020Yards");
    textOp("Stealth");

    -- Spacer
    textOp(" ");
    wrapOp("--- Cooldowns ---");

    -- Agi Pot
    --checkOp("Agi-Pot");
    --textOp("Agi-Pot");

    -- Flask / Crystal
    --checkOp("Flask / Crystal");
    --textOp("Flask / Crystal");

    -- Vanish
    checkOp("Vanish","Enable or Disable usage of Vanish.");
    dropOp("Vanish",2,"CD")
    textOp("Vanish");

    -- Adrenaline Rush
    checkOp("Adrenaline Rush","Enable or Disable usage of Adrenaline Rush.");
    dropOp("Adrenaline Rush",2,"CD")
    textOp("Adrenaline Rush");

    -- Killing Spree
    checkOp("Killing Spree","Enable or Disable usage of Killing Spree.");
    dropOp("Killing Spree",2,"CD")
    textOp("Killing Spree");

    -- Blade Flurry
    checkOp("Blade Flurry","Enable or Disable usage of Blade Flurry.",1);
    textOp("Blade Flurry");

    -- Spacer
    textOp(" ");
    wrapOp("--- Defensive ---");

    -- Healthstone
    checkOp("Pot/Stoned");
    boxOp("Pot/Stoned", 0, 100, 5, 60, "|cffFFBB00Health Percentage to use at.");
    textOp("Pot/Stoned");


    -- Spacer --
    --textOp(" ");
    --wrapOp("--- Interrupts ---");


    -- Interrupt Percentage
    --checkOp("Interrupts");
    --boxOp("Interrupts", 5, 95, 5, 0, "|cffFFBB00Cast Percentage to use at.");
    --textOp("Interrupt At");

    -- Spacer
    textOp(" ");
    wrapOp("--- Toggle Keys ---");

    -- Single/Multi Toggle
    checkOp("Rotation Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFRotation Mode Toggle Key|cffFFBB00.");
    dropOp("Rotation Mode", 4, "Toggle")
    textOp("Rotation Mode");

    --Cooldown Key Toggle
    checkOp("Cooldown Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFCooldown Mode Toggle Key|cffFFBB00.");
    dropOp("Cooldown Mode", 3, "Toggle")
    textOp("Cooldowns")

    --Defensive Key Toggle
    checkOp("Defensive Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFDefensive Mode Toggle Key|cffFFBB00.");
    dropOp("Defensive Mode", 6, "Toggle")
    textOp("Defensive")

    --Interrupts Key Toggle
    checkOp("Interrupt Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFInterrupt Mode Toggle Key|cffFFBB00.");
    dropOp("Interrupt Mode", 6, "Toggle")
    textOp("Interrupts")



    -- General Configs
    CreateGeneralsConfig();

    WrapsManager();
  --end
  end

end
