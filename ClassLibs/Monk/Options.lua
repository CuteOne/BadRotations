if select(3,UnitClass("player")) == 10 then



  --[[This function will create a Value Box.]]
  -- function CreateNewBox(value,textString,minValue,maxValue,step,base,tip1)

  --[[This function will create a Check Box.]]
  -- function CreateNewCheck(value, textString, tip1)

  --[[This function will create a Menu, up to 10 values can be passed.]]
  -- function CreateNewDrop(value, textString, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)

  --[[This function will create the TextString.
This function must always be last, it will increase table row.]]
  -- function CreateNewText(value, textString)

  --[[This function will create the Title String.
This function will use table row #1.]]
  -- function CreateNewTitle(value, textString)

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
  function NewMonkConfig()
    --if not doneConfig then
    thisConfig = 0
    -- Title
    titleOp("CuteOne New Monk");
    -- Spacer
    CreateGeneralsConfig();

    WrapsManager();
  --end
  end

  --[[           ]]	--[[           ]]	--[[           ]]	--[[]] 	   --[[]]
  --[[           ]]	--[[           ]]	--[[           ]]	--[[]] 	   --[[]]
  --[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]				--[[ ]]   --[[ ]]
  --[[         ]]		--[[           ]]	--[[           ]]	--[[           ]]
  --[[]]	   --[[]]	--[[        ]]		--[[]]				--[[           ]]
  --[[           ]]	--[[]]	  --[[]]	--[[           ]]	--[[ ]]   --[[ ]]
  --[[           ]]	--[[]]	   --[[]]	--[[           ]]	 --[[]]   --[[]]

  function MonkBrewConfig()
      bb.profile_window = createNewProfileWindow("Brewmaster")

      local dropOptionsToggle = bb.dropOptions.Toggle
      local dropOptionsToggle2 = bb.dropOptions.Toggle2
      local dropOptionsCD = bb.dropOptions.CD
      local section

      section = createNewSection(bb.profile_window, "General")
      -- Stats Buff
      createNewCheckbox(section, "Stats Buff")
      -- Detox
      createNewCheckbox(section, "Detox")
      -- Pause Toggle
      createNewDropdown(section, "Pause Toggle", dropOptionsToggle ,4)
      -- Dizzying Haze
      createNewDropdown(section, "Dizzying Haze Key", dropOptionsToggle2 ,2)
      -- Dizzying Haze
      createNewDropdown(section, "Black Ox Statue Key", dropOptionsToggle2 ,2)
      checkSectionState(section)



      section = createNewSection(bb.profile_window, "Cooldowns")
      -- Xuen
      createNewCheckbox(section, "Invoke Xuen")
      -- Breath of Fire
      createNewCheckbox(section, "Breath of Fire", "Disable usage of Breath of Fire")
      -- Elusive Brew"
      createNewSpinner(section, "Elusive Brew", 9, 0, 16, 1, "At what |cffFF0000Stack to use |cffFFFFFFElusive Brew")
      checkSectionState(section)



      section = createNewSection(bb.profile_window, "Defensive")
      -- Dazzling Brew
      --createNewCheckbox(section, "Dazzling Brew")
      -- Fortifying Brew
      createNewSpinner(section, "Fortifying Brew", 30, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFFortifying Brew")
      -- Diffuse Magic
      createNewSpinner(section, "Diffuse Magic", 30, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFDiffuse Magic")
      -- Dampen Harm
      createNewSpinner(section, "Dampen Harm", 30, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFDampen Harm")
      -- Guard
      createNewCheckbox(section, "Guard on CD")
      -- Expel Harm
      createNewSpinner(section, "Expel Harm", 30, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFExpel Harm")
      -- Healthstone
      createNewSpinner(section, "Healthstone", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFHealthstone")
      checkSectionState(section)


      section = createNewSection(bb.profile_window, "Utilities")
      -- Angry Monk
      createNewCheckbox(section, "Angry Monk", "|cffFF0000Disable Combat Check.")
      -- Resuscitate
      createNewCheckbox(section, "Resuscitate")
      checkSectionState(section)


      --[[ Rotation Dropdown ]]--
      createNewRotationDropdown(bb.profile_window.parent, {"Chumii"})

      bb:checkProfileWindowStatus()
  end

  --[[]]     --[[]]	--[[           ]]	--[[           ]]	--[[           ]]
  --[[ ]]   --[[ ]] 		 --[[ ]]		--[[           ]]	--[[           ]]
  --[[           ]] 		 --[[ ]]		--[[]]	   				 --[[ ]]
  --[[           ]]		 --[[ ]]		--[[           ]]		 --[[ ]]
  --[[]] 	   --[[]]		 --[[ ]]				   --[[]]		 --[[ ]]
  --[[]]	   --[[]]		 --[[ ]]		--[[           ]]		 --[[ ]]
  --[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[ ]]

  function MonkMistConfig()
    if currentConfig ~= "Mistweaver CodeMyLife" then
      ClearConfig();
      thisConfig = 0
      -- Title
      CreateNewTitle(thisConfig,"Mistweaver |cffFF0000CodeMyLife");

      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"---------- Buffs ---------");

      -- Stance
      CreateNewCheck(thisConfig,"Stance");
      CreateNewDrop(thisConfig, "Stance", 1, "Choose Stance to use.", "|cff00FF55Serpent", "|cff0077FFTiger")
      CreateNewText(thisConfig,"Stance");

      -- Legacy of the Emperor
      CreateNewCheck(thisConfig,"Legacy of the Emperor");
      CreateNewText(thisConfig,"Legacy of the Emperor");

      -- Nature's Cure
      CreateNewCheck(thisConfig,"Detox")
      CreateNewDrop(thisConfig,"Detox", 1, "MMouse:|cffFFFFFFMouse / Match List. \nMRaid:|cffFFFFFFRaid / Match List. \nAMouse:|cffFFFFFFMouse / All. \nARaid:|cffFFFFFFRaid / All.",
        "|cffFFDD11MMouse",
        "|cffFFDD11MRaid",
        "|cff00FF00AMouse",
        "|cff00FF00ARaid")
      CreateNewText(thisConfig,"Detox");
      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"------ Cooldowns ------");


      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"--------- Healing -------");

      -- Chi Wave
      CreateNewCheck(thisConfig,"Chi Wave");
      CreateNewBox(thisConfig, "Chi Wave", 0, 100  , 5, 55, "Under what |cffFF0000%HP to use |cffFFFFFFChi Wave.");
      CreateNewText(thisConfig,"Chi Wave");

      -- Enveloping Mist
      CreateNewCheck(thisConfig,"Enveloping Mist");
      CreateNewBox(thisConfig, "Enveloping Mist", 0, 100  , 5, 45, "Under what |cffFF0000%HP to use |cffFFFFFFEnveloping Mist.");
      CreateNewText(thisConfig,"Enveloping Mist");

      -- Renewing Mist
      CreateNewCheck(thisConfig,"Renewing Mist");
      CreateNewBox(thisConfig, "Renewing Mist", 0, 100  , 5, 85, "Under what |cffFF0000%HP to use |cffFFFFFFRenewing Mist.");
      CreateNewText(thisConfig,"Renewing Mist");

      -- Soothing Mist
      CreateNewCheck(thisConfig,"Soothing Mist");
      CreateNewBox(thisConfig, "Soothing Mist", 0, 100  , 5, 75, "Under what |cffFF0000%HP to use |cffFFFFFFSoothing Mist.");
      CreateNewText(thisConfig,"Soothing Mist");

      -- Surging Mist
      CreateNewCheck(thisConfig,"Surging Mist");
      CreateNewBox(thisConfig, "Surging Mist", 0, 100  , 5, 65, "Under what |cffFF0000%HP to use |cffFFFFFFSurging Mist.");
      CreateNewText(thisConfig,"Surging Mist");

      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"----- AoE Healing -----");


      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"------- Defensive ------");

      -- Expel Harm
      CreateNewCheck(thisConfig,"Expel Harm");
      CreateNewBox(thisConfig, "Expel Harm", 0, 100  , 5, 80, "Under what |cffFF0000%HP to use |cffFFFFFFExpel Harm");
      CreateNewText(thisConfig,"Expel Harm");

      -- Fortifying Brew
      CreateNewCheck(thisConfig,"Fortifying Brew");
      CreateNewBox(thisConfig, "Fortifying Brew", 0, 100  , 5, 30, "Under what |cffFF0000%HP to use |cffFFFFFFFortifying Brew");
      CreateNewText(thisConfig,"Fortifying Brew");

      -- Healthstone
      CreateNewCheck(thisConfig,"Healthstone");
      CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 20, "Under what |cffFF0000%HP to use |cffFFFFFFHealthstone");
      CreateNewText(thisConfig,"Healthstone");

      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"-------- Toggles --------");

      -- Uplift Toggle
      CreateNewCheck(thisConfig,"Uplift Toggle");
      CreateNewDrop(thisConfig,"Uplift Toggle", 4, "Toggle2")
      CreateNewText(thisConfig,"Uplift Toggle");

      -- Pause Toggle
      CreateNewCheck(thisConfig,"Pause Toggle");
      CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle2")
      CreateNewText(thisConfig,"Pause Toggle");

      -- Focus Toggle
      CreateNewCheck(thisConfig,"Focus Toggle");
      CreateNewDrop(thisConfig,"Focus Toggle", 2, "Toggle2")
      CreateNewText(thisConfig,"Focus Toggle");

      -- DPS Toggle
      CreateNewCheck(thisConfig,"DPS Toggle");
      CreateNewDrop(thisConfig,"DPS Toggle", 1, "Toggle2")
      CreateNewText(thisConfig,"DPS Toggle");

      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"------ Utilities ------");

      -- Follow Tank
      CreateNewCheck(thisConfig,"Follow Tank");
      CreateNewBox(thisConfig, "Follow Tank", 10, 40  , 1, 25, "Range from focus...");
      CreateNewText(thisConfig,"Follow Tank");

      -- Spear Hand Strike
      CreateNewCheck(thisConfig,"Spear Hand Strike");
      CreateNewBox(thisConfig, "Spear Hand Strike", 0, 100  , 5, 60 , "Over what % of cast we want to \n|cffFFFFFFSpear and Strike.");
      CreateNewText(thisConfig,"Spear Hand Strike");

      -- Quaking Palm
      CreateNewCheck(thisConfig,"Quaking Palm");
      CreateNewBox(thisConfig, "Quaking Palm", 0, 100  , 5, 30 , "Over what % of cast we want to \n|cffFFFFFFQuaking Palm.");
      CreateNewText(thisConfig,"Quaking Palm");

      -- Resuscitate
      CreateNewCheck(thisConfig,"Resuscitate");
      CreateNewText(thisConfig,"Resuscitate");

      -- Roll
      CreateNewCheck(thisConfig,"Roll");
      CreateNewText(thisConfig,"Roll");


      -- General Configs
      CreateGeneralsConfig();


      WrapsManager();
    end
  end

end
