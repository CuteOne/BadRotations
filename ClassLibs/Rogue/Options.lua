if select(3, UnitClass("player")) == 4 then
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

	  --[[]]		--[[           ]]	--[[           ]]		  --[[]]		--[[           ]]	--[[           ]]
     --[[  ]]		--[[           ]]	--[[           ]]	     --[[  ]]		--[[           ]]	--[[           ]]
    --[[    ]] 		--[[]]				--[[]]				    --[[    ]] 		--[[]]				--[[]]
   --[[      ]] 	--[[           ]]	--[[           ]]	   --[[      ]] 	--[[           ]]	--[[           ]]
  --[[        ]]			   --[[]]		 	   --[[]]	  --[[        ]]			   --[[]]		 	   --[[]]
 --[[]]    --[[]]	--[[           ]]	--[[           ]]	 --[[]]    --[[]]	--[[           ]]	--[[           ]]
--[[]]      --[[]]	--[[           ]]	--[[           ]] 	--[[]]      --[[]]	--[[           ]]	--[[           ]]

--[[           ]] 	--[[           ]]	--[[]]     --[[]]	--[[           ]] 		  --[[]]		--[[           ]]
--[[           ]] 	--[[           ]]	--[[ ]]   --[[ ]]	--[[           ]] 	  	 --[[  ]] 		--[[           ]]
--[[]]				--[[]]	   --[[]]	--[[           ]]	--[[]]	   --[[]]	    --[[    ]]			 --[[ ]]
--[[]] 				--[[]]	   --[[]]	--[[           ]]	--[[         ]]	 	   --[[      ]] 		 --[[ ]]
--[[]]				--[[]]	   --[[]]	--[[]] 	   --[[]]	--[[]]	   --[[]]	  --[[        ]]		 --[[ ]]
--[[           ]] 	--[[           ]] 	--[[]] 	   --[[]]	--[[           ]] 	 --[[]]    --[[]]		 --[[ ]]
--[[           ]] 	--[[           ]] 	--[[]] 	   --[[]]	--[[           ]]	--[[]]      --[[]]		 --[[ ]]



function CombatOptions()

    if currentConfig ~= "Combat Toxin" then
        currentConfig = "Combat Toxin"
        ClearConfig();
        thisConfig = 0
        -- Title
        CreateNewTitle(thisConfig,"Combat |cffFF0000Toxin");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"---------- Buffs ---------");


        -- Stealth Timer
        --CreateNewCheck(thisConfig,"Stealth Timer");
        --CreateNewBox(thisConfig, "Stealth Timer", 0, 10  , 1, 2 , "|cffFFBB00How long to wait(seconds) before using \n|cffFFFFFFStealth.");
        --CreateNewText(thisConfig,"Stealth Timer");

        -- Stealth
        CreateNewCheck(thisConfig,"Stealth");
        --CreateNewDrop(thisConfig,"Stealth",1,"Stealthing method.","|cffFF000030Yards");
        CreateNewText(thisConfig,"Stealth");

        -- Left Poison
        CreateNewCheck(thisConfig,"Left Poison");
        CreateNewDrop(thisConfig,"Left Poison",2,"Left Hand poison.","|cff6600FFCrip","|cff00CF1CLeech");
        CreateNewText(thisConfig,"Left Poison");

        -- Right Poison
        CreateNewCheck(thisConfig,"Right Poison");
        CreateNewDrop(thisConfig,"Right Poison",1,"Right Hand poison.","|cff13A300Deadly","|cffFF8000Wound");
        CreateNewText(thisConfig,"Right Poison");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Cooldowns ------");

        -- Shadow Blades (Ability pruned 6.0.2 sad day)
        --CreateNewCheck(thisConfig,"Shadow Blades");
        --CreateNewText(thisConfig,"Shadow Blades");

        --Adrenaline Rush
        CreateNewCheck(thisConfig,"Adrenaline Rush");
        CreateNewText(thisConfig,"Adrenaline Rush");

        -- Vanish
        CreateNewCheck(thisConfig,"Vanish");
        CreateNewText(thisConfig,"Vanish");

        -- Shadowmeld
        CreateNewCheck(thisConfig,"Shadowmeld");
        CreateNewText(thisConfig,"Shadowmeld");

        -- Preparation
        CreateNewCheck(thisConfig,"Preparation");
        CreateNewText(thisConfig,"Preparation");


        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------- Defensive ------");


        -- Evasion
        CreateNewCheck(thisConfig,"Evasion");
        CreateNewBox(thisConfig, "Evasion", 0, 100  , 5, 30 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFEvasion.");
        CreateNewText(thisConfig,"Evasion");

        -- Feint
        CreateNewCheck(thisConfig,"Feint");
        CreateNewBox(thisConfig, "Feint", 0, 100  , 5, 50 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFFeint.");
        CreateNewText(thisConfig,"Feint");

        -- Recuperate
        CreateNewCheck(thisConfig,"Recuperate");
        CreateNewBox(thisConfig, "Recuperate", 0, 100  , 5, 30 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFRecuperate.");
        CreateNewText(thisConfig,"Recuperate");

        -- Combat Readiness
        CreateNewCheck(thisConfig,"Combat Readiness");
        CreateNewBox(thisConfig, "Combat Readiness", 0, 100  , 5, 30 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFCombat Readiness.");
        CreateNewText(thisConfig,"Combat Readiness");


        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Utilities ------");
        -- Kick
        CreateNewCheck(thisConfig,"Kick");
        CreateNewBox(thisConfig, "Kick", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFKick.");
        CreateNewText(thisConfig,"Kick");

        -- General Configs
        CreateGeneralsConfig();


        WrapsManager();
    end
end

--[[           ]] 	--[[]]	   --[[]]	--[[           ]]
--[[           ]] 	--[[]]	   --[[]]	--[[           ]]
--[[]]				--[[]]	   --[[]]	--[[]]	   --[[]]
--[[           ]] 	--[[]]	   --[[]]	--[[         ]]
	   	   --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]
--[[           ]] 	--[[           ]] 	--[[           ]]
--[[           ]] 	--[[           ]] 	--[[           ]]

function SubOptions()

    if currentConfig ~= "Subtlety CoRe" then
    	currentConfig = "Subtlety CoRe"
        ClearConfig();
        thisConfig = 0
        -- Title
        CreateNewTitle(thisConfig,"Subtlety |cffFF0000CoRe");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"---------- Buffs ---------");


        -- Stealth Timer
        CreateNewCheck(thisConfig,"Stealth Timer");
        CreateNewBox(thisConfig, "Stealth Timer", 0, 10  , 1, 2 , "|cffFFBB00How long to wait(seconds) before using \n|cffFFFFFFStealth.");
        CreateNewText(thisConfig,"Stealth Timer");

        -- Stealth
        CreateNewCheck(thisConfig,"Stealth");
        CreateNewDrop(thisConfig,"Stealth",1,"Stealthing method.","|cff00FF00Always","|cffFFDD00PrePot","|cffFF000030Yards");
        CreateNewText(thisConfig,"Stealth");

        -- Left Poison
        CreateNewCheck(thisConfig,"Left Poison");
        CreateNewDrop(thisConfig,"Left Poison",2,"Left Hand poison.","|cff6600FFCrip","|cff00CF1CLeech");
        CreateNewText(thisConfig,"Left Poison");

        -- Right Poison
        CreateNewCheck(thisConfig,"Right Poison");
        CreateNewDrop(thisConfig,"Right Poison",1,"Right Hand poison.","|cff13A300Deadly","|cffFF8000Wound");
        CreateNewText(thisConfig,"Right Poison");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Cooldowns ------");

        -- Shadow Blades
        CreateNewCheck(thisConfig,"Shadow Blades");
        CreateNewText(thisConfig,"Shadow Blades");

        -- Shadow Dance
        CreateNewCheck(thisConfig,"Shadow Dance");
        CreateNewText(thisConfig,"Shadow Dance");

        -- Vanish
        CreateNewCheck(thisConfig,"Vanish");
        CreateNewText(thisConfig,"Vanish");

        -- Shadowmeld
        CreateNewCheck(thisConfig,"Shadowmeld");
        CreateNewText(thisConfig,"Shadowmeld");

        -- Preparation
        CreateNewCheck(thisConfig,"Preparation");
        CreateNewText(thisConfig,"Preparation");


        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------- Defensive ------");


        -- Evasion
        CreateNewCheck(thisConfig,"Evasion");
        CreateNewBox(thisConfig, "Evasion", 0, 100  , 5, 30 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFEvasion.");
        CreateNewText(thisConfig,"Evasion");

     	-- Feint
	    CreateNewCheck(thisConfig,"Feint");
	    CreateNewBox(thisConfig, "Feint", 0, 100  , 5, 50 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFFeint.");
	    CreateNewText(thisConfig,"Feint");

        -- Recuperate
	    CreateNewCheck(thisConfig,"Recuperate");
	    CreateNewBox(thisConfig, "Recuperate", 0, 100  , 5, 30 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFRecuperate.");
	    CreateNewText(thisConfig,"Recuperate");

        -- Combat Readiness
	    CreateNewCheck(thisConfig,"Combat Readiness");
	    CreateNewBox(thisConfig, "Combat Readiness", 0, 100  , 5, 30 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFCombat Readiness.");
	    CreateNewText(thisConfig,"Combat Readiness");


        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Utilities ------");
    	-- Kick
	    CreateNewCheck(thisConfig,"Kick");
	    CreateNewBox(thisConfig, "Kick", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFKick.");
	    CreateNewText(thisConfig,"Kick");

        -- General Configs
        CreateGeneralsConfig();


        WrapsManager();
    end
end
end
