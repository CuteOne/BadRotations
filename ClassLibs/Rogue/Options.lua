if select(3, UnitClass("player")) == 4 then
	
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

        -- Stance
        CreateNewCheck(thisConfig,"Stealth");
        CreateNewDrop(thisConfig,"Stealth",1,"Stealthing method.","Always","PrePot");
        CreateNewText(thisConfig,"Stealth");

        -- Left Poison
        CreateNewCheck(thisConfig,"Left Poison");
        CreateNewDrop(thisConfig,"Left Poison",3,"Left Hand poison.","Crip","Mind","Leech");
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
