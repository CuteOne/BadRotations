if select(3, UnitClass("player")) == 5 then

--[[         ]]		--[[           ]]	--[[           ]]	--[[           ]]
--[[          ]]		  --[[]]		--[[           ]]	--[[           ]]
--[[]]	   --[[]]		  --[[]]		--[[]]	   			--[[]]
--[[]]	   --[[]]		  --[[]]		--[[           ]]	--[[]]
--[[]]	   --[[]]		  --[[]]				   --[[]]	--[[]]	  
--[[          ]]		  --[[]]		--[[           ]]	--[[           ]]
--[[         ]] 	--[[           ]]	--[[           ]]	--[[           ]]

--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]	   
--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
--[[           ]]	--[[]]	   --[[]]	--[[]]					 --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]

--[[           ]]	--[[]]	   --[[]]		  --[[]]		--[[         ]]		--[[           ]]	--[[]] 	   --[[]]
--[[           ]]	--[[]]	   --[[]]	     --[[  ]]		--[[          ]]	--[[           ]]	--[[]] 	   --[[]]
--[[]]				--[[]]	   --[[]]	    --[[    ]] 		--[[]]	   --[[]]	--[[]]	   --[[]]	--[[ ]]   --[[ ]]
--[[           ]]	--[[           ]]	   --[[      ]] 	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]
		   --[[]] 	--[[]]	   --[[]] 	  --[[        ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]
--[[           ]]	--[[]]	   --[[]]	 --[[]]    --[[]]	--[[          ]]	--[[           ]]	--[[ ]]   --[[ ]]
--[[           ]]	--[[]]	   --[[]]	--[[]]      --[[]]	--[[         ]]		--[[           ]]	 --[[]]   --[[]]


function ShadowConfig()
    if currentConfig ~= "Shadow ragnar" then
        ClearConfig();
        thisConfig = 0;
        --[[Title]]
        CreateNewTitle(thisConfig,"Shadow |cffFF0000ragnar");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"---------- Buffs ---------");

        --[[Power Word: Fortitude]]
        CreateNewCheck(thisConfig,"Power Word: Fortitude");
        CreateNewText(thisConfig,"Power Word: Fortitude");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Cooldowns ------");

        
        if isKnown(_Mindbender) then
        	--[[Mindbender]]
	        CreateNewCheck(thisConfig,"Mindbender");
	        CreateNewBox(thisConfig, "Mindbender", 0, 100  , 5, 70, "|cffFFBB00Under what |cff3895FF%Mana|cffFFBB00 to use |cffFFFFFFMindbender.");
	        CreateNewText(thisConfig,"Mindbender");   
	    else
	        --[[Shadowfiend]]
	        CreateNewCheck(thisConfig,"Shadowfiend");
	        CreateNewBox(thisConfig, "Shadowfiend", 0, 100  , 5, 70, "|cffFFBB00Under what |cff3895FF%Mana|cffFFBB00 to use |cffFFFFFFShadowfiend.");
	        CreateNewText(thisConfig,"Shadowfiend");  
	    end

        --[[Dispersion]]
        CreateNewCheck(thisConfig,"Dispersion Health");
        CreateNewBox(thisConfig, "Dispersion Health", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDispersion");
        CreateNewText(thisConfig,"Dispersion Health");

        --[[Dispersion]]
        CreateNewCheck(thisConfig,"Dispersion Mana");
        CreateNewBox(thisConfig, "Dispersion Mana", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%Mana|cffFFBB00 to use |cffFFFFFFDispersion");
        CreateNewText(thisConfig,"Dispersion Mana");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"--------- Healing -------");

        --[[Power Word: Shield]]
        CreateNewCheck(thisConfig,"Power Word: Shield");
        CreateNewBox(thisConfig, "Power Word: Shield", 0, 100  , 5, 75, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFPower Word: Shield.");
        CreateNewText(thisConfig,"Power Word: Shield");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------- Offensive ------");

        CreateNewCheck(thisConfig,"Power Infusion");
        CreateNewDrop(thisConfig,"Power Infusion", 5, "Toggle2");
        CreateNewText(thisConfig,"Power Infusion");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------- Defensive ------");

        --[[Healthstone]]
        CreateNewCheck(thisConfig,"Healthstone");
        CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
        CreateNewText(thisConfig,"Healthstone");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"-------- Toggles --------");

        --[[Pause Toggle]]
        CreateNewCheck(thisConfig,"Pause Toggle");
        CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle2")
        CreateNewText(thisConfig,"Pause Toggle");  

        --[[Focus Toggle]]
        CreateNewCheck(thisConfig,"Focus Toggle");
        CreateNewDrop(thisConfig,"Focus Toggle", 2, "Toggle2")
        CreateNewText(thisConfig,"Focus Toggle"); 

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Utilities ------");

        --[[Multi-Dotting]]
        CreateNewCheck(thisConfig,"Multi-Dotting");
        CreateNewText(thisConfig,"Multi-Dotting");

        if isKnown(_AngelicFeather) then
	        --[[Angelic Feather]]
	        CreateNewCheck(thisConfig,"Angelic Feather");
            CreateNewText(thisConfig,"Angelic Feather");
	    elseif isKnown(_BodyAndSoul) then
	        --[[Body And Soul]]
	        CreateNewCheck(thisConfig,"Body And Soul");
	        CreateNewText(thisConfig,"Body And Soul");
	    end	    	

        --[[Follow Tank]]
        CreateNewCheck(thisConfig,"Follow Tank");
        CreateNewBox(thisConfig, "Follow Tank", 10, 40  , 1, 25, "|cffFFBB00Range from focus...");
        CreateNewText(thisConfig,"Follow Tank");

        --[[General Configs]]
        CreateGeneralsConfig();

        
        WrapsManager();
    end
end

end
