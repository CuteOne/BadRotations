if select(3, UnitClass("player")) == 1 then
	
	  --[[]]		--[[           ]]	--[[]]     --[[]] 	--[[           ]]
     --[[  ]]		--[[           ]]	--[[ ]]   --[[ ]]	--[[           ]]
    --[[    ]] 		--[[]]	   --[[]]	--[[           ]]	--[[]]
   --[[      ]] 	--[[         ]]		--[[           ]] 	--[[           ]]
  --[[        ]]	--[[        ]]		--[[]] 	   --[[]]			   --[[]]
 --[[]]    --[[]]	--[[]]	  --[[]]	--[[]] 	   --[[]]	--[[           ]]	
--[[]]      --[[]]	--[[]]	   --[[]]	--[[]] 	   --[[]]	--[[           ]]

--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]	  --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]	  --[[]]
--[[]] 				--[[]]	   --[[]]	--[[]]	   --[[]]	   --[[    ]]	
--[[           ]]	--[[]]	   --[[]]	--[[         ]]		   --[[    ]]	
--[[           ]]	--[[]]	   --[[]]	--[[        ]]			 --[[]]
--[[]] 				--[[           ]]	--[[]]	  --[[]]		 --[[]]	
--[[]]      		--[[           ]]	--[[]]		--[[]]		 --[[]]

--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]
--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]		 --[[ ]]
--[[         ]]		--[[         ]]	    --[[]]	   --[[]]		 --[[ ]]
--[[       ]]		--[[        ]]		--[[]]	   --[[]]		 --[[ ]]
--[[]]				--[[]]	  --[[]]	--[[           ]]	 	 --[[ ]]		
--[[]] 				--[[]]	   --[[]]	--[[           ]]		 --[[ ]]	



function WarriorProtConfig()
    if currentConfig ~= "Protection CodeMyLife" then
        ClearConfig();
        thisConfig = 0;
        -- Title
        CreateNewTitle(thisConfig,"Protection |cffFF0000CodeMyLife");

        -- Wrapper -------------------------------------------
        CreateNewWrap(thisConfig,"---------- Buffs ---------");

        -- Stance
        CreateNewCheck(thisConfig,"Stance");
        CreateNewDrop(thisConfig, "Stance", 1, "Choose Stance to use.", "|cffFFBB00Defensive", "|cff0077FFBattle")
        CreateNewText(thisConfig,"Stance");

        -- Shout
        CreateNewCheck(thisConfig,"Shout");
        CreateNewDrop(thisConfig, "Shout", 1, "Choose Shout to use.", "|cffFFBB00Battle", "|cff0077FFBattle")
        CreateNewText(thisConfig,"Shout");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Cooldowns ------");

        -- Wrapper ------------------------------------------
        CreateNewWrap(thisConfig,"------- Defensive ------");

        -- Healthstone
        CreateNewCheck(thisConfig,"Healthstone");
        CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
        CreateNewText(thisConfig,"Healthstone");

        -- Last Stand
        CreateNewCheck(thisConfig,"Last Stand");
        CreateNewBox(thisConfig, "Last Stand", 0, 100  , 5, 15, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFLast Stand");
        CreateNewText(thisConfig,"Last Stand");

        -- Shield Block
        CreateNewCheck(thisConfig,"Shield Block");
        CreateNewBox(thisConfig, "Shield Block", 0, 100  , 5, 70, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFShield Block");
        CreateNewText(thisConfig,"Shield Block");        

        -- Wrapper ---------------------------------------------
        CreateNewWrap(thisConfig,"-------- Utilities --------");

        -- Charge
        CreateNewCheck(thisConfig,"Charge");
        CreateNewText(thisConfig,"Charge"); 

    	-- Pummel
	    CreateNewCheck(thisConfig,"Pummel");
	    CreateNewBox(thisConfig, "Pummel", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFPummel.");
	    CreateNewText(thisConfig,"Pummel");

	    if isKnown(107079) then
	    	-- Quaking Palm
		    CreateNewCheck(thisConfig,"Quaking Palm");
		    CreateNewBox(thisConfig, "Quaking Palm", 0, 100  , 5, 30 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFQuaking Palm.");
		    CreateNewText(thisConfig,"Quaking Palm");	
		end    

        -- General Configs
        CreateGeneralsConfig();

        
        WrapsManager();
    end
end


end
