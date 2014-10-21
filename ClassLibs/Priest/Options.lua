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
        CreateNewWrap(thisConfig,"== Buffs");

        --[[Power Word: Fortitude]]
        CreateNewCheck(thisConfig,"Power Word: Fortitude");
        CreateNewText(thisConfig,"Power Word: Fortitude");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"== Cooldowns");

        CreateNewCheck(thisConfig,"Power Infusion");
        CreateNewText(thisConfig,"Power Infusion");

        if isKnown(_Mindbender) then
        	--[[Mindbender]]
	        CreateNewCheck(thisConfig,"Mindbender");
	        CreateNewText(thisConfig,"Mindbender");
	    else
	        --[[Shadowfiend]]
	        CreateNewCheck(thisConfig,"Shadowfiend");
	        CreateNewText(thisConfig,"Shadowfiend");
	    end

        -- Wrapper -----------------------------------------
        -- CreateNewWrap(thisConfig,"--------- Healing -------");

        -- Wrapper -----------------------------------------
        --CreateNewWrap(thisConfig,"------- Offensive ------");



        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"== Defensive");

        --[[Healthstone]]
        CreateNewCheck(thisConfig,"Healthstone");
        CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
        CreateNewText(thisConfig,"Healthstone");

        --[[Power Word: Shield]]
        CreateNewCheck(thisConfig,"Power Word: Shield");
        CreateNewBox(thisConfig, "Power Word: Shield", 0, 100  , 5, 80, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFPower Word: Shield.");
        CreateNewText(thisConfig,"Power Word: Shield");

        --[[Dispersion]]
        CreateNewCheck(thisConfig,"Dispersion");
        CreateNewBox(thisConfig, "Dispersion", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDispersion");
        CreateNewText(thisConfig,"Dispersion");

        --[[Fade]]
        CreateNewCheck(thisConfig,"Fade");
        CreateNewBox(thisConfig, "Fade", 0, 100  , 5, 80, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFade");
        CreateNewText(thisConfig,"Fade");

        --[[Desperate Prayer]]
        CreateNewCheck(thisConfig,"Desperate Prayer");
        CreateNewBox(thisConfig, "Desperate Prayer", 0, 100  , 5, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDesperate Prayer");
        CreateNewText(thisConfig,"Desperate Prayer");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"== Toggles");

        --[[Pause Toggle]]
        CreateNewCheck(thisConfig,"Pause Toggle");
        CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle2")
        CreateNewText(thisConfig,"Pause Toggle");

        --[[Focus Toggle]]
        CreateNewCheck(thisConfig,"Focus Toggle");
        CreateNewDrop(thisConfig,"Focus Toggle", 2, "Toggle2")
        CreateNewText(thisConfig,"Focus Toggle");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"== Utilities");

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
        --CreateNewCheck(thisConfig,"Follow Tank");
        --CreateNewBox(thisConfig, "Follow Tank", 10, 40  , 1, 25, "|cffFFBB00Range from focus...");
        --CreateNewText(thisConfig,"Follow Tank");

        --[[General Configs]]
        CreateGeneralsConfig();


        WrapsManager();
    end
end

end
