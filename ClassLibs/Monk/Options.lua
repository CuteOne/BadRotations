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
    if currentConfig ~= "Brewmaster Chumii" then
      ClearConfig();
      thisConfig = 0

      -- Title
      CreateNewTitle(thisConfig,"Brewmaster |cffFF0000Chumii");
      --Spacer
      CreateNewText(thisConfig," ");
      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"-------- General Rotation --------");

      -- Legacy of the Emperor
      -- CreateNewCheck(thisConfig,"Legacy of the White Tiger");
      -- CreateNewText(thisConfig,"Legacy of the White Tiger");

      -- Detox
      CreateNewCheck(thisConfig,"Detox");
      CreateNewText(thisConfig,"Detox");

      -- Pause Toggle
      CreateNewCheck(thisConfig,"Pause Toggle");
      CreateNewDrop(thisConfig,"Pause Toggle", 4, "Toggle")
      CreateNewText(thisConfig,"Pause Toggle");

      -- Dizzying Haze
      CreateNewCheck(thisConfig,"Dizzying Haze Key");
      CreateNewDrop(thisConfig,"Dizzying Haze Key", 2, "Toggle2")
      CreateNewText(thisConfig,"Dizzying Haze Key");

      -- Dizzying Haze
      CreateNewCheck(thisConfig,"Black Ox Statue Key");
      CreateNewDrop(thisConfig,"Black Ox Statue Key", 2, "Toggle2")
      CreateNewText(thisConfig,"Black Ox Statue Key");

      --Spacer
      CreateNewText(thisConfig," ");
      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"------ Cooldowns ------");

      -- Xuen
      CreateNewCheck(thisConfig,"Invoke Xuen");
      CreateNewText(thisConfig,"Invoke Xuen");

      --Spacer
      CreateNewText(thisConfig," ");
      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"------- Defensive ------");

      -- -- Dazzling Brew
      -- CreateNewCheck(thisConfig,"Dazzling Brew");
      -- CreateNewText(thisConfig,"Dazzling Brew");

      -- Fortifying Brew
      CreateNewCheck(thisConfig,"Fortifying Brew");
      CreateNewBox(thisConfig, "Fortifying Brew", 0, 100  , 5, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFortifying Brew");
      CreateNewText(thisConfig,"Fortifying Brew");

      -- Diffuse Magic
      CreateNewCheck(thisConfig,"Diffuse Magic");
      CreateNewBox(thisConfig, "Diffuse Magic", 0, 100  , 5, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFortifying Brew");
      CreateNewText(thisConfig,"Diffuse Magic");

      -- Dampen Harm
      CreateNewCheck(thisConfig,"Dampen Harm");
      CreateNewBox(thisConfig, "Dampen Harm", 0, 100  , 5, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFortifying Brew");
      CreateNewText(thisConfig,"Dampen Harm");

      -- Guard
      CreateNewCheck(thisConfig,"Guard on CD");
      CreateNewText(thisConfig,"Guard on CD");

      -- Diffuse Magic
      CreateNewCheck(thisConfig,"Expel Harm");
      CreateNewBox(thisConfig, "Expel Harm", 0, 100  , 5, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFortifying Brew");
      CreateNewText(thisConfig,"Expel Harm");

      -- Healthstone
      CreateNewCheck(thisConfig,"Healthstone");
      CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
      CreateNewText(thisConfig,"Healthstone");


      --Spacer
      CreateNewText(thisConfig," ");
      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"------ Utilities ------");


      -- Angry Monk
      CreateNewCheck(thisConfig,"Angry Monk","|cffFF0000Disable Combat Check.");
      CreateNewText(thisConfig,"Angry Monk");


      -- Resuscitate
      CreateNewCheck(thisConfig,"Resuscitate");
      CreateNewText(thisConfig,"Resuscitate");

      --Spacer
      CreateNewText(thisConfig," ");
      -- General Configs
      CreateGeneralsConfig();


      WrapsManager();
    end
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
      CreateNewDrop(thisConfig,"Detox", 1, "|cffFFBB00MMouse:|cffFFFFFFMouse / Match List. \n|cffFFBB00MRaid:|cffFFFFFFRaid / Match List. \n|cffFFBB00AMouse:|cffFFFFFFMouse / All. \n|cffFFBB00ARaid:|cffFFFFFFRaid / All.",
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
      CreateNewBox(thisConfig, "Chi Wave", 0, 100  , 5, 55, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFChi Wave.");
      CreateNewText(thisConfig,"Chi Wave");

      -- Enveloping Mist
      CreateNewCheck(thisConfig,"Enveloping Mist");
      CreateNewBox(thisConfig, "Enveloping Mist", 0, 100  , 5, 45, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFEnveloping Mist.");
      CreateNewText(thisConfig,"Enveloping Mist");

      -- Renewing Mist
      CreateNewCheck(thisConfig,"Renewing Mist");
      CreateNewBox(thisConfig, "Renewing Mist", 0, 100  , 5, 85, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRenewing Mist.");
      CreateNewText(thisConfig,"Renewing Mist");

      -- Soothing Mist
      CreateNewCheck(thisConfig,"Soothing Mist");
      CreateNewBox(thisConfig, "Soothing Mist", 0, 100  , 5, 75, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSoothing Mist.");
      CreateNewText(thisConfig,"Soothing Mist");

      -- Surging Mist
      CreateNewCheck(thisConfig,"Surging Mist");
      CreateNewBox(thisConfig, "Surging Mist", 0, 100  , 5, 65, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSurging Mist.");
      CreateNewText(thisConfig,"Surging Mist");

      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"----- AoE Healing -----");


      -- Wrapper -----------------------------------------
      CreateNewWrap(thisConfig,"------- Defensive ------");

      -- Expel Harm
      CreateNewCheck(thisConfig,"Expel Harm");
      CreateNewBox(thisConfig, "Expel Harm", 0, 100  , 5, 80, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFExpel Harm");
      CreateNewText(thisConfig,"Expel Harm");

      -- Fortifying Brew
      CreateNewCheck(thisConfig,"Fortifying Brew");
      CreateNewBox(thisConfig, "Fortifying Brew", 0, 100  , 5, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFortifying Brew");
      CreateNewText(thisConfig,"Fortifying Brew");

      -- Healthstone
      CreateNewCheck(thisConfig,"Healthstone");
      CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
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
      CreateNewBox(thisConfig, "Follow Tank", 10, 40  , 1, 25, "|cffFFBB00Range from focus...");
      CreateNewText(thisConfig,"Follow Tank");

      -- Spear Hand Strike
      CreateNewCheck(thisConfig,"Spear Hand Strike");
      CreateNewBox(thisConfig, "Spear Hand Strike", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFSpear and Strike.");
      CreateNewText(thisConfig,"Spear Hand Strike");

      -- Quaking Palm
      CreateNewCheck(thisConfig,"Quaking Palm");
      CreateNewBox(thisConfig, "Quaking Palm", 0, 100  , 5, 30 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFQuaking Palm.");
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
