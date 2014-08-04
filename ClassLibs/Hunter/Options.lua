
--[[           ]]	--[[           ]]		  --[[]]		--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]	     --[[  ]]		--[[           ]]	--[[           ]]
--[[]]	   --[[]]	--[[]]				    --[[    ]] 		--[[]]					 --[[ ]]
--[[         ]]		--[[           ]]	   --[[      ]] 	--[[           ]]		 --[[ ]]
--[[]]	   --[[]]	--[[]]				  --[[        ]]			   --[[]]		 --[[ ]]
--[[           ]]	--[[           ]]	 --[[]]    --[[]]	--[[           ]]		 --[[ ]]		
--[[           ]] 	--[[           ]]	--[[]]      --[[]]	--[[           ]]		 --[[ ]]

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


-- Config Panel
function BeastConfig()
    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,"Beastmaster CodeMyLife");

    -- Wrapper
    CreateNewWrap(thisConfig,"--- Pet Management ---");

    -- Auto Call Pet Toggle
    CreateNewCheck(thisConfig,"Auto Call Pet");
    CreateNewDrop(thisConfig, "Auto Call Pet", 1, "|cffFFDD11Set to desired |cffFFFFFFPet to Whistle.", "|cffFFDD11Pet 1", "|cffFFDD11Pet 2", "|cffFFDD11Pet 3", "|cffFFDD11Pet 4", "|cffFFDD11Pet 5");
    CreateNewText(thisConfig,"Auto Call Pet");

    -- Intimidation
    CreateNewCheck(thisConfig,"Intimidation");
    CreateNewDrop(thisConfig,"Intimidation", 2,"|cffFFDD11Sets how you want |cffFFFFFFIntimidation |cffFFDD11to react.", "|cffFF0000Me.Aggro", "|cff00FF00Always")
    CreateNewText(thisConfig,"Intimidation");
    
    -- Mend Pet
    CreateNewCheck(thisConfig,"Mend Pet");
    CreateNewBox(thisConfig, "Mend Pet", 0, 100  , 5, 75, "|cffFFDD11Under what Pet %HP to use |cffFFFFFFMend Pet");
    CreateNewText(thisConfig,"Mend Pet");

    -- Wrapper
    CreateNewWrap(thisConfig,"----- Cooldowns -----");

    -- Stampede
    CreateNewCheck(thisConfig,"Stampede");
    CreateNewDrop(thisConfig,"Stampede", 2, "CD")
    CreateNewText(thisConfig,"Stampede");

    -- Bestial Wrath
    CreateNewCheck(thisConfig,"Bestial Wrath");
    CreateNewDrop(thisConfig,"Bestial Wrath", 3, "CD")
    CreateNewText(thisConfig,"Bestial Wrath");

    -- Rapid Fire
    CreateNewCheck(thisConfig,"Rapid Fire");
    CreateNewDrop(thisConfig,"Rapid Fire", 2, "CD")
    CreateNewText(thisConfig,"Rapid Fire");

    -- Focus Fire
    CreateNewCheck(thisConfig,"Focus Fire");
    CreateNewDrop(thisConfig,"Focus Fire", 3, "CD")
    CreateNewText(thisConfig,"Focus Fire");

    -- Dire Beast
    CreateNewCheck(thisConfig,"Dire Beast");
    CreateNewBox(thisConfig, "Dire Beast", 0, 120, 5, 65, "|cffFFDD11Focus/120 to use |cffFFFFFFDire Beast.");
    CreateNewText(thisConfig,"Dire Beast");


    -- Wrapper
    CreateNewWrap(thisConfig,"----- DPS Tweaks -----");

    -- Hunter's Mark
    CreateNewCheck(thisConfig,"Hunters Mark");
    CreateNewBox(thisConfig, "Hunters Mark", 1, 10 , 1, 3, "|cffFFDD11Time to wait before |cffFFFFFFHunter's Mark.");
    CreateNewText(thisConfig,"Hunter's Mark");

    -- Serpent Sting
    CreateNewCheck(thisConfig,"Serpent Sting");
    CreateNewText(thisConfig,"Serpent Sting");

    -- Explosive Trap
    CreateNewCheck(thisConfig,"Explosive Trap");
    CreateNewDrop(thisConfig,"Explosive Trap", 2,"|cffFFDD11Sets how you want |cffFFFFFFExplosive Trap |cffFFDD11to react.", "|cffFF0000Never", "|cffFFDD113 mobs", "|cff00FF00Always")
    CreateNewText(thisConfig,"Explosive Trap");

    -- Wrapper
    CreateNewWrap(thisConfig,"------ Defensive -------");

    -- Misdirection
    CreateNewCheck(thisConfig,"Misdirection");
    CreateNewDrop(thisConfig,"Misdirection", 2,"|cffFFDD11Sets how you want |cffFFFFFFMisdirection |cffFFDD11to react.", "|cffFF0000Me.Aggro", "|cffFFDD11Any.Aggro", "|cffFFFF00Enforce", "|cff00FF00Always")
    CreateNewText(thisConfig,"Misdirection");

    -- Feign Death
    CreateNewCheck(thisConfig,"Feign Death");
    CreateNewBox(thisConfig, "Feign Death", 0, 100  , 5, 20, "|cffFFDD11Under what %HP to use |cffFFFFFFFeign Death");
    CreateNewText(thisConfig,"Feign Death");

    -- Deterrence
    CreateNewCheck(thisConfig,"Deterrence");
    CreateNewBox(thisConfig, "Deterrence", 0, 100  , 5, 20, "|cffFFDD11Under what %HP to use |cffFFFFFFDeterrence");
    CreateNewText(thisConfig,"Deterrence");


    -- Wrapper
    CreateNewWrap(thisConfig,"-------- General -------");

    -- Auto-Aspect Toggle
    CreateNewCheck(thisConfig,"Auto-Cheetah");
    CreateNewBox(thisConfig, "Auto-Cheetah", 1, 10, 1, 3, "|cffFFDD11How long do you want to run before enabling |cffFFFFFFAspect of the Cheetah.");
    CreateNewText(thisConfig,"Auto-Cheetah");

    -- Standard Interrupt
    CreateNewCheck(thisConfig,"Counter Shot");
    CreateNewBox(thisConfig, "Counter Shot", 0, 100  , 5, 35 , "|cffFFDD11Over what % of cast we want to |cffFFFFFFCounter Shot.");
    CreateNewText(thisConfig,"Counter Shot");

    -- PokeRotation
    --CreateNewCheck(thisConfig,"PokeRotation");
   -- CreateNewText(thisConfig,"PokeRotation");

    -- Debug
    CreateNewCheck(thisConfig,"Debug", "|cffFFDD11Check this to start |cffFFFFFFChat Debug |cffFFDD11of casted spells.");
    CreateNewText(thisConfig,"Debug");

   -- Bound
    CreateNewBound(thisConfig,"End"); 
    WrapsManager();
end

--[[]]     --[[]] 		  --[[]]		--[[           ]]	--[[]]	   --[[]]	--[[           ]]
--[[ ]]   --[[ ]] 		 --[[  ]] 		--[[           ]]	--[[]]	  --[[]]	--[[           ]]
--[[           ]] 	    --[[    ]]		--[[]]	   --[[]]	--[[        ]]		--[[]]
--[[           ]]	   --[[      ]] 	--[[           ]] 	--[[    ]] 			--[[           ]]
--[[]] 	   --[[]]	  --[[        ]]	--[[        ]]		--[[        ]]				   --[[]]
--[[]]	   --[[]]	 --[[]]    --[[]]	--[[]]	  --[[]]	--[[]]	  --[[]]	--[[           ]]
--[[]]	   --[[]]	--[[]]      --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]

--[[           ]] 	--[[]]	   --[[]]	--[[           ]]  	--[[]]	   --[[]]
--[[           ]] 	--[[]]	   --[[]]	--[[           ]] 	--[[]]	   --[[]]
--[[]]				--[[]]	   --[[]]	--[[]]	   --[[]]	 --[[]]	  --[[]]
--[[           ]] 	--[[]]	   --[[]]	--[[           ]] 	 --[[]]	  --[[]]
	   	   --[[]]	--[[]]	   --[[]]	--[[        ]]		  --[[]] --[[]]
--[[           ]] 	--[[           ]] 	--[[]]	  --[[]]	  --[[       ]]
--[[           ]] 	--[[           ]] 	--[[]]	   --[[]]	   --[[     ]]













