if select(3, UnitClass("player")) == 1 then
	
	  --[[]]		--[[           ]]	--[[]]     --[[]] 	--[[           ]]
     --[[  ]]		--[[           ]]	--[[ ]]   --[[ ]]	--[[           ]]
    --[[    ]] 		--[[]]	   --[[]]	--[[           ]]	--[[]]
   --[[      ]] 	--[[         ]]		--[[           ]] 	--[[           ]]
  --[[        ]]	--[[        ]]		--[[]] 	   --[[]]			   --[[]]
 --[[]]    --[[]]	--[[]]	  --[[]]	--[[]] 	   --[[]]	--[[           ]]	
--[[]]      --[[]]	--[[]]	   --[[]]	--[[]] 	   --[[]]	--[[           ]]

function WarriorArmsConfig()
    if currentConfig ~= "Arms Avery/Chumii" then
        ClearConfig();
        thisConfig = 0;
        -- Title
        CreateNewTitle(thisConfig,"Arms |cffFF0000Avery/Chumii");

        -- Wrapper -------------------------------------------
        CreateNewWrap(thisConfig,"---------- Buffs ---------");

        -- -- Stance
        -- CreateNewCheck(thisConfig,"Stance");
        -- CreateNewDrop(thisConfig, "Stance", 1, "Choose Stance to use.", "|cffFFBB00Defensive", "|cff0077FFBattle")
        -- CreateNewText(thisConfig,"Stance");

        -- Shout
        CreateNewCheck(thisConfig,"Shout");
        CreateNewDrop(thisConfig, "Shout", 1, "Choose Shout to use.", "|cffFFBB00Commanding", "|cff0077FFBattle")
        CreateNewText(thisConfig,"Shout");

        -- Shout OOC
        CreateNewCheck(thisConfig, "ShoutOOC","Uncheck this if you want to use the selected Shout only while in combat");
        CreateNewText(thisConfig, "Shout out of Combat");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Cooldowns ------");

        -- Recklessness
        CreateNewCheck(thisConfig,"Recklessness");
        CreateNewDrop(thisConfig, "Recklessness", 1, "Choose Shout to use.", "|cffFFBB00Always", "|cff0077FFBossDummy")
        CreateNewText(thisConfig,"Recklessness"); 

        -- SkullBanner
        CreateNewCheck(thisConfig,"SkullBanner");
        CreateNewDrop(thisConfig, "SkullBanner", 1, "Choose Shout to use.", "|cffFFBB00Always", "|cff0077FFBossDummy")
        CreateNewText(thisConfig,"SkullBanner"); 

        -- Avatar
        CreateNewCheck(thisConfig,"Avatar");
        CreateNewDrop(thisConfig, "Avatar", 1, "Choose Shout to use.", "|cffFFBB00Always", "|cff0077FFBossDummy")
        CreateNewText(thisConfig,"Avatar"); 

        -- Racial
        CreateNewCheck(thisConfig,"Racial");
        CreateNewDrop(thisConfig, "Racial", 1, "Choose Shout to use.", "|cffFFBB00Always", "|cff0077FFBossDummy")
        CreateNewText(thisConfig,"Racial (Orc / Troll)");

        -- Wrapper ------------------------------------------
        CreateNewWrap(thisConfig,"------- Defensive ------");

        -- Die by the Sword
        CreateNewCheck(thisConfig,"DiebytheSword");
        CreateNewBox(thisConfig, "DiebytheSword", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDie by the Sword");
        CreateNewText(thisConfig,"DiebytheSword");

        -- Rallying Cry
        CreateNewCheck(thisConfig,"RallyingCry");
        CreateNewBox(thisConfig, "RallyingCry", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRallying Cry");
        CreateNewText(thisConfig,"RallyingCry");

        -- Shield Wall
        CreateNewCheck(thisConfig,"ShieldWall");
        CreateNewBox(thisConfig, "ShieldWall", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFShield Wall");
        CreateNewText(thisConfig,"ShieldWall");

        -- Def Stance
        CreateNewCheck(thisConfig,"DefensiveStance");
        CreateNewBox(thisConfig, "DefensiveStance", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDefensive Stance");
        CreateNewText(thisConfig,"DefensiveStance");

        -- Healthstone
        CreateNewCheck(thisConfig,"Healthstone");
        CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
        CreateNewText(thisConfig,"Healthstone");

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

        -- Dummy DPS Test
            CreateNewCheck(thisConfig,"DPS Testing");
            CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1");
            CreateNewText(thisConfig,"DPS Testing");

        -- General Configs
        CreateGeneralsConfig();

        
        WrapsManager();
    end
end
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]	  --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]	  --[[]]
--[[]] 				--[[]]	   --[[]]	--[[]]	   --[[]]	   --[[    ]]	
--[[           ]]	--[[]]	   --[[]]	--[[         ]]		   --[[    ]]	
--[[           ]]	--[[]]	   --[[]]	--[[        ]]			 --[[]]
--[[]] 				--[[           ]]	--[[]]	  --[[]]		 --[[]]	
--[[]]      		--[[           ]]	--[[]]		--[[]]		 --[[]]


function WarriorFuryConfig()
    if currentConfig ~= "Fury Avery/Chumii" then
        ClearConfig();
        thisConfig = 0;
        -- Title
        CreateNewTitle(thisConfig,"Fury |cffFF0000Avery/Chumii");

        -- Wrapper -------------------------------------------
        CreateNewWrap(thisConfig,"---------- Buffs ---------");

        -- Stance
        CreateNewCheck(thisConfig,"Stance");
        CreateNewDrop(thisConfig, "Stance", 1, "Choose Stance to use.", "|cffFFBB00Defensive", "|cff0077FFBattle")
        CreateNewText(thisConfig,"Stance");

        -- Shout
		CreateNewCheck(thisConfig,"Battle");
        CreateNewText(thisConfig,"Battle"); 
		
		CreateNewCheck(thisConfig,"Commanding");
        CreateNewText(thisConfig,"Commanding"); 

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Cooldowns ------");
		
		CreateNewCheck(thisConfig,"Shattering Throw");
        CreateNewText(thisConfig,"Shattering Throw"); 

        -- Wrapper ------------------------------------------
        CreateNewWrap(thisConfig,"------- Defensive ------");

        -- Healthstone
        CreateNewCheck(thisConfig,"Healthstone");
        CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
        CreateNewText(thisConfig,"Healthstone");

        -- Wrapper ---------------------------------------------
        CreateNewWrap(thisConfig,"-------- Utilities --------");

        -- Charge
        CreateNewCheck(thisConfig,"Charge");
        CreateNewText(thisConfig,"Charge"); 

        -- Pummel
        CreateNewCheck(thisConfig,"Pummel");
        CreateNewBox(thisConfig, "Pummel", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFPummel.");
        CreateNewText(thisConfig,"Pummel");
		
		-- Disrupting Shout
        CreateNewCheck(thisConfig,"Disrupting Shout");
        CreateNewBox(thisConfig, "Disrupting Shout", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFDisrupting Shout.");
        CreateNewText(thisConfig,"Disrupting Shout");

        if isKnown(107079) then
            -- Quaking Palm
            CreateNewCheck(thisConfig,"Quaking Palm");
            CreateNewBox(thisConfig, "Quaking Palm", 0, 100  , 5, 30 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFQuaking Palm.");
            CreateNewText(thisConfig,"Quaking Palm");   
        end    

        -- General Configs
        --CreateGeneralsConfig();

        
        --WrapsManager();
    end
end



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
