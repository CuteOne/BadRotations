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
                [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cff00FF00Single Target (1-2)", highlight = 0, icon = 108557 },
                [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Recommended for \n|cffFF0000AoE (3+)", highlight = 0, icon = 101546 },
                [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "|cffC0C0C0AoE \n|cffFFDD11Auto-AoE", highlight = 1, icon = 116812 }
            };
            CreateButton("AoE",0.5,1)
            AoEModesLoaded = "Brew Monk AoE Modes";
        end
        -- Interrupts Button
        if  InterruptsModesLoaded ~= "Brew Monk Interrupts Modes" then 
            InterruptsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffC0C0C0Interrupts \n|cffFF0000Spells Included: \n|cffFFDD11Spear Hand Strike.", highlight = 1, icon = 116705 }
            };
            CreateButton("Interrupts",1,0)
            InterruptsModesLoaded = "Brew Monk Interrupts Modes";
        end

        -- Defensive Button
        if  DefensiveModesLoaded ~= "Brew Monk Defensive Modes" then 
            DefensiveModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "|cffC0C0C0Defensive \n|cffFF0000No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffC0C0C0Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Fortifying Brew, \nElusive Brew, \nGuard", highlight = 1, icon = 115203 }
            };
            CreateButton("Defensive",1.5,1)
            DefensiveModesLoaded = "Brew Monk Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Brew Monk Cooldowns Modes" then 
            CooldownsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]]},
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffC0C0C0Cooldowns \n|cffFF0000Spells Included: \n|cffFFDD11Avenging Wrath, \nHoly Avenger.", highlight = 1, icon = 115080 }
            };
            CreateButton("Cooldowns",2,0)
            CooldownsModesLoaded = "Brew Monk Cooldowns Modes";
        end



        function SpecificToggle(toggle)
            if getValue(toggle) == 1 then
                return IsLeftControlKeyDown();
            elseif getValue(toggle) == 2 then
                return IsLeftShiftKeyDown();
            elseif getValue(toggle) == 3 then
                return IsLeftAltKeyDown();
            elseif getValue(toggle) == 4 then
                return IsRightControlKeyDown();
            elseif getValue(toggle) == 5 then
                return IsRightShiftKeyDown();
            elseif getValue(toggle) == 6 then
                return IsRightAltKeyDown();
            elseif getValue(toggle) == 7 then
                return 1
            end
        end


    end


--[[           ]]	--[[           ]]	--[[           ]]	--[[]] 	   --[[]]
--[[           ]]	--[[           ]]	--[[           ]]	--[[]] 	   --[[]]	
--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]				--[[ ]]   --[[ ]]
--[[         ]]		--[[           ]]	--[[           ]]	--[[           ]]
--[[]]	   --[[]]	--[[        ]]		--[[]]				--[[           ]]
--[[           ]]	--[[]]	  --[[]]	--[[           ]]	--[[ ]]   --[[ ]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	 --[[]]   --[[]]

_Guard							=   115295;
_BreathOfFire					=   115181;
_KegSmash						=	121253;
_DazzlingBrew					= 	115180;
_SpearHandStrike                =   116705;
_TigersLust                     =   116841;

function MonkBrewConfig()
    if currentConfig ~= "Brewmaster CodeMyLife" then
        ClearConfig();
        thisConfig = 0
        -- Title
        CreateNewTitle(thisConfig,"Brewmaster |cffFF0000CodeMyLife");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"---------- Buffs ---------");

        -- Stance
        CreateNewCheck(thisConfig,"Stance");
        CreateNewDrop(thisConfig, "Stance", 1, "Choose Stance to use.", "|cffFFBB00Ox", "|cff0077FFTiger")
        CreateNewText(thisConfig,"Stance");

        -- Legacy of the Emperor
        CreateNewCheck(thisConfig,"Legacy of the Emperor");
        CreateNewText(thisConfig,"Legacy of the Emperor");

        -- Detox
        CreateNewCheck(thisConfig,"Detox");
        CreateNewText(thisConfig,"Detox");



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


        -- Expel Harm
        CreateNewCheck(thisConfig,"Expel Harm");
        CreateNewBox(thisConfig, "Expel Harm", 0, 100  , 5, 80, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFExpel Harm");
        CreateNewText(thisConfig,"Expel Harm");

        -- Healthstone
        CreateNewCheck(thisConfig,"Healthstone");
        CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
        CreateNewText(thisConfig,"Healthstone");

        -- Fortifying Brew
        CreateNewCheck(thisConfig,"Fortifying Brew");
        CreateNewBox(thisConfig, "Fortifying Brew", 0, 100  , 5, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFortifying Brew");
        CreateNewText(thisConfig,"Fortifying Brew");

        -- Guard
        CreateNewCheck(thisConfig,"Guard");
        CreateNewBox(thisConfig, "Guard", 0, 100  , 5, 70, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGuard");
        CreateNewText(thisConfig,"Guard");        

        -- Dazzling Brew
        CreateNewCheck(thisConfig,"Dazzling Brew");
        CreateNewText(thisConfig,"Dazzling Brew");        

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Utilities ------");
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

        -- Focus Toggle
        CreateNewCheck(thisConfig,"Roll");
        CreateNewText(thisConfig,"Roll");         

        -- General Configs
        CreateGeneralsConfig();

        
        WrapsManager();
    end
end






--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[ ]]   --[[ ]]        --[[ ]]        --[[           ]]   --[[           ]]
--[[           ]]        --[[ ]]        --[[]]                   --[[ ]]
--[[           ]]        --[[ ]]        --[[           ]]        --[[ ]]
--[[]]     --[[]]        --[[ ]]                   --[[]]        --[[ ]]
--[[]]     --[[]]        --[[ ]]        --[[           ]]        --[[ ]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[ ]]



   function MonkMistToggles()

 
        -- Healing Button
        if  HealingModesLoaded ~= "Mist Monk Healing Modes" then 
            HealingModes = { 
                [1] = { mode = "Off", value = 1 , overlay = "Healing Disabled", tip = "Will not allow healing.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "On", value = 2 , overlay = "Healing Enabled", tip = "Will allow healing.", highlight = 1, icon = 115151 },
             };
            CreateButton("Healing",1,0);
            HealingModesLoaded = "Mist Monk Healing Modes";
        end
        -- DPS Button
        if  DPSModesLoaded ~= "Mist Monk DPS Modes" then 
            DPSModes = { 
                [1] = { mode = "Off", value = 1 , overlay = "DPS Disabled", tip = "Will not allow DPSing.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "On", value = 2 , overlay = "DPS Enabled", tip = "Will allow DPSing.", highlight = 1, icon = 100787 },
             };
            CreateButton("DPS",0.5,1);
            DPSModesLoaded = "Mist Monk DPS Modes";
        end
        -- Defensive Button
        if  DefensiveModesLoaded ~= "Mist Monk Defensive Modes" then 
            DefensiveModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Fortifying Brew.", highlight = 1, icon = 115203 }
            };
            CreateButton("Defensive",2,0);
            DefensiveModesLoaded = "Mist Monk Defensive Modes";
        end
        -- Cooldowns Button
        if  CooldownsModesLoaded ~= "Mist Monk Cooldowns Modes" then 
            CooldownsModes = { 
                [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
                [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Includes config's selected spells.", highlight = 1, icon = [[INTERFACE\ICONS\inv_misc_blackironbomb]] },
                [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "|cffFF0000Includes: \n|cffFFdd11Revival.", highlight = 1, icon = 115310 }
            };
            CreateButton("Cooldowns",1.5,1);
            CooldownsModesLoaded = "Mist Monk Cooldowns Modes";
        end


        function SpecificToggle(toggle)
            if getValue(toggle) == 1 then
                return IsLeftControlKeyDown();
            elseif getValue(toggle) == 2 then
                return IsLeftShiftKeyDown();
            elseif getValue(toggle) == 3 then
                return IsLeftAltKeyDown();
            elseif getValue(toggle) == 4 then
                return IsRightControlKeyDown();
            elseif getValue(toggle) == 5 then
                return IsRightShiftKeyDown();
            elseif getValue(toggle) == 6 then
                return IsRightAltKeyDown();
            elseif getValue(toggle) == 7 then
                return 1
            end
        end


    end


--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[ ]]   --[[ ]]        --[[ ]]        --[[           ]]   --[[           ]]
--[[           ]]        --[[ ]]        --[[]]                   --[[ ]]
--[[           ]]        --[[ ]]        --[[           ]]        --[[ ]]
--[[]]     --[[]]        --[[ ]]                   --[[]]        --[[ ]]
--[[]]     --[[]]        --[[ ]]        --[[           ]]        --[[ ]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[ ]]


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