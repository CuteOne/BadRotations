if select(3,UnitClass("player")) == 10 then


--[[           ]]	--[[           ]]	--[[           ]]	--[[]] 	   --[[]]
--[[           ]]	--[[           ]]	--[[           ]]	--[[]] 	   --[[]]	
--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]				--[[ ]]   --[[ ]]
--[[         ]]		--[[           ]]	--[[           ]]	--[[           ]]
--[[]]	   --[[]]	--[[        ]]		--[[]]				--[[           ]]
--[[           ]]	--[[]]	  --[[]]	--[[           ]]	--[[ ]]   --[[ ]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	 --[[]]   --[[]]




   function MonkBrewToggles()

        -- Aoe Button
        if  AoEModesLoaded ~= "Brew Monk AoE Modes" then 
            AoEModes = { 
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cff00FF00Recommended for \n|cffFFDD11Single Target(1-2).", highlight = 0 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffFF0000Recommended for \n|cffFFDD11AoE(3+).", highlight = 0 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffFFDD11Recommended for \n|cffFFDD11Lazy people like me.", highlight = 1 }
            };
            CreateButton("AoE",0.5,1)
            AoEModesLoaded = "Brew Monk AoE Modes";
        end
        -- Interrupts Button
        if  InterruptsModesLoaded ~= "Brew Monk Interrupts Modes" then 
            InterruptsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffFF0000No Interrupts will be used.", highlight = 0 },
                [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffFF0000Spells Included: \n|cffFFDD11Rebuke.", highlight = 1 }
            };
            CreateButton("Interrupts",1,0)
            InterruptsModesLoaded = "Brew Monk Interrupts Modes";
        end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "Brew Monk Defensive Modes" then 
            DefensiveModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffFF0000No Defensive Cooldowns will be used.", highlight = 0 },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Spells Included: \n|cffFFDD11Ardent Defender, \nDivine Protection, \nGuardian of Ancient Kings.", highlight = 1 }
            };
            CreateButton("Defensive",1.5,1)
            DefensiveModesLoaded = "Brew Monk Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Brew Monk Cooldowns Modes" then 
            CooldownsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000No cooldowns will be used.", highlight = 0 },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffFF0000Cooldowns Included: \n|cffFFDD11Config's selected spells.", highlight = 1 },
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Cooldowns Included: \n|cffFFDD11Avenging Wrath, \nHoly Avenger.", highlight = 1 }
            };
            CreateButton("Cooldowns",2,0)
            CooldownsModesLoaded = "Brew Monk Cooldowns Modes";
        end
    end


--[[           ]]	--[[           ]]	--[[           ]]	--[[]] 	   --[[]]
--[[           ]]	--[[           ]]	--[[           ]]	--[[]] 	   --[[]]	
--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]				--[[ ]]   --[[ ]]
--[[         ]]		--[[           ]]	--[[           ]]	--[[           ]]
--[[]]	   --[[]]	--[[        ]]		--[[]]				--[[           ]]
--[[           ]]	--[[]]	  --[[]]	--[[           ]]	--[[ ]]   --[[ ]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	 --[[]]   --[[]]






function MonkBrewConfig()
    if currentConfig ~= "Brewmaster CodeMyLife" then
        ClearConfig();
        thisConfig = 0
        -- Title
        CreateNewTitle(thisConfig,"Restoration |cffFF0000Masoud");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"---------- Buffs ---------");

        -- Stance
        CreateNewCheck(thisConfig,"Stance");
        CreateNewDrop(thisConfig, "Stance", 1, "Choose Stance to use.", "|cffFFBB00Ox", "|cff0077FFTiger")
        CreateNewText(thisConfig,"Stance");

        -- Legacy of the Emperor
        CreateNewCheck(thisConfig,"Legacy of the Emperor");
        CreateNewText(thisConfig,"Legacy of the Emperor");




        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Cooldowns ------");


        -- Incarnation
        CreateNewCheck(thisConfig,"Incarnation");
        CreateNewBox(thisConfig, "Incarnation", 0, 100  , 5, 45, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFIncarnation.");
        CreateNewText(thisConfig,"Incarnation");   

        -- Innervate
        CreateNewCheck(thisConfig,"Innervate");
        CreateNewBox(thisConfig, "Innervate", 0, 100  , 5, 80, "|cffFFBB00Under what |cff297BFF%Mana|cffFFBB00 to use |cffFFFFFFInnervate.");
        CreateNewText(thisConfig,"Innervate");   

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------- Defensive ------");

        -- Healthstone
        CreateNewCheck(thisConfig,"Healthstone");
        CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFortifying Brew");
        CreateNewText(thisConfig,"Healthstone");

        -- Fortifying Brew
        CreateNewCheck(thisConfig,"Fortifying Brew");
        CreateNewBox(thisConfig, "Fortifying Brew", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFortifying Brew");
        CreateNewText(thisConfig,"Fortifying Brew");

        -- Guard
        CreateNewCheck(thisConfig,"Guard");
        CreateNewBox(thisConfig, "Guard", 0, 100  , 5, 70, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGuard");
        CreateNewText(thisConfig,"Guard");        

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"-------- Toggles --------");

        -- Pause Toggle
        CreateNewCheck(thisConfig,"Pause Toggle");
        CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle")
        CreateNewText(thisConfig,"Pause Toggle");  

        -- Focus Toggle
        CreateNewCheck(thisConfig,"Focus Toggle");
        CreateNewDrop(thisConfig,"Focus Toggle", 2, "Toggle")
        CreateNewText(thisConfig,"Focus Toggle"); 

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Utilities ------");

        -- Focus Toggle
        CreateNewCheck(thisConfig,"Roll");
        CreateNewText(thisConfig,"Roll");         

        -- General Configs
        CreateGeneralsConfig();

        
        WrapsManager();
    end
end










end