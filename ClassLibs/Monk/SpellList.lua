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

        -- Mark Of The Wild
        CreateNewCheck(thisConfig,"Mark Of The Wild");
        CreateNewText(thisConfig,"Mark Of The Wild");

        -- Nature's Cure
        CreateNewCheck(thisConfig,"Nature's Cure")
        CreateNewDrop(thisConfig,"Nature's Cure", 1, "|cffFFBB00MMouse:|cffFFFFFFMouse / Match List. \n|cffFFBB00MRaid:|cffFFFFFFRaid / Match List. \n|cffFFBB00AMouse:|cffFFFFFFMouse / All. \n|cffFFBB00ARaid:|cffFFFFFFRaid / All.", 
            "|cffFFDD11MMouse", 
            "|cffFFDD11MRaid",
            "|cff00FF00AMouse",
            "|cff00FF00ARaid")
        CreateNewText(thisConfig,"Nature's Cure"); 

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
        CreateNewWrap(thisConfig,"---- Level 60 Talent ---");

        if isKnown(114107) then
            -- Harmoney SotF
            CreateNewCheck(thisConfig,"Harmoney SotF");
            CreateNewBox(thisConfig, "Harmoney SotF", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 to refresh Harmoney.");
            CreateNewText(thisConfig,"Harmoney SotF");

            -- WildGrowth SotF
            CreateNewCheck(thisConfig,"WildGrowth SotF");
            CreateNewBox(thisConfig, "WildGrowth SotF", 0, 100  , 5, 45, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSwiftmend.");
            CreateNewText(thisConfig,"WildGrowth SotF"); 

            -- WildGrowth SotF Count
            CreateNewCheck(thisConfig,"WildGrowth SotF Count");
            CreateNewBox(thisConfig, "WildGrowth SotF Count", 1, 25  , 1, 3, "|cffFFBB00Number of members under Force of Nature treshold needed to use |cffFFFFFFSwiftmend.");
            CreateNewText(thisConfig,"WildGrowth SotF Count"); 
        elseif isKnown(106737) then
            -- Force of Nature
            CreateNewCheck(thisConfig,"Force of Nature");
            CreateNewBox(thisConfig, "Force of Nature", 0, 100  , 5, 45, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFForce of Nature.");
            CreateNewText(thisConfig,"Force of Nature"); 

            -- Force of Nature Count
            CreateNewCheck(thisConfig,"Force of Nature Count");
            CreateNewBox(thisConfig, "Force of Nature Count", 1, 25  , 1, 3, "|cffFFBB00Number of members under Force of Nature treshold needed to use |cffFFFFFFForce of Nature.");
            CreateNewText(thisConfig,"Force of Nature Count"); 
        elseif isKnown(106731) then
            -- Lifebloom Tol
            CreateNewCheck(thisConfig,"Lifebloom Tol");
            CreateNewText(thisConfig,"Lifebloom Tol");

            -- Rejuvenation Tol
            CreateNewCheck(thisConfig,"Rejuvenation Tol");
            CreateNewBox(thisConfig, "Rejuvenation Tol", 0, 100  , 5, 90, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation|cffFFBB00 while in Tree of Life. \n|cffFFDD11Used after Rejuvenation if Rejuvenation All Tol is not selected.");
            CreateNewText(thisConfig,"Rejuvenation Tol");

            -- Rejuvenation All Tol
            CreateNewCheck(thisConfig,"Rejuvenation All Tol");
            CreateNewText(thisConfig,"Rejuvenation All Tol");

            -- Regrowth Tol
            CreateNewCheck(thisConfig,"Regrowth Tol");
            CreateNewBox(thisConfig, "Regrowth Tol", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 while in Tree of Life.");
            CreateNewText(thisConfig,"Regrowth Tol");

            -- Regrowth Tank Tol
            CreateNewCheck(thisConfig,"Regrowth Tank Tol");
            CreateNewBox(thisConfig, "Regrowth Tank Tol", 0, 100  , 5, 85, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 on tanks while in Tree of Life .");
            CreateNewText(thisConfig,"Regrowth Tank Tol");

            -- Regrowth Omen Tol
            CreateNewCheck(thisConfig,"Regrowth Omen Tol");
            CreateNewBox(thisConfig, "Regrowth Omen Tol", 0, 100  , 5, 85, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 while in Tree of Life and Omen proc.");
            CreateNewText(thisConfig,"Regrowth Omen Tol");

            -- WildGrowth Tol
            CreateNewCheck(thisConfig,"WildGrowth Tol");
            CreateNewBox(thisConfig, "WildGrowth Tol", 0, 100  , 5, 85, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWildGrowth|cffFFBB00 while in Tree of Life.");
            CreateNewText(thisConfig,"WildGrowth Tol");

            -- Mushrooms Bloom Count
            CreateNewBox(thisConfig, "WildGrowth Tol Count", 1, 25  , 1, 5, "|cffFFBB00Number of members under WildGrowth Tol treshold needed to use |cffFFFFFFWildGrowth|cffFFBB00 while in Tree of Life.");
            CreateNewText(thisConfig,"WildGrowth Tol Count");
        end


        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"--------- Healing -------");

        -- Lifebloom
        CreateNewCheck(thisConfig,"Lifebloom");
        CreateNewBox(thisConfig, "Lifebloom", 0, 100  , 5, 85, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to |cffFFFFFFlet Lifebloom Bloom |cffFFBB00on Focus.");
        CreateNewText(thisConfig,"Lifebloom");

        -- Regrowth
        CreateNewCheck(thisConfig,"Regrowth");
        CreateNewBox(thisConfig, "Regrowth", 0, 100  , 5, 65, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth.");
        CreateNewText(thisConfig,"Regrowth");

        -- Regrowth Tank
        CreateNewCheck(thisConfig,"Regrowth Tank");
        CreateNewBox(thisConfig, "Regrowth Tank", 0, 100  , 5, 55, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 on Tanks.");
        CreateNewText(thisConfig,"Regrowth Tank");

        -- Regrowth Omen
        CreateNewCheck(thisConfig,"Regrowth Omen");
        CreateNewBox(thisConfig, "Regrowth Omen", 0, 100  , 5, 80, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 with Omen of Clarity.");
        CreateNewText(thisConfig,"Regrowth Omen");

        -- Rejuvenation
        CreateNewCheck(thisConfig,"Rejuvenation");
        CreateNewBox(thisConfig, "Rejuvenation", 0, 100  , 5, 80, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation.");
        CreateNewText(thisConfig,"Rejuvenation");

        -- Rejuvenation Tank
        CreateNewCheck(thisConfig,"Rejuvenation Tank");
        CreateNewBox(thisConfig, "Rejuvenation Tank", 0, 100  , 5, 65, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation |cffFFBB00on Tanks.");
        CreateNewText(thisConfig,"Rejuvenation Tank");

        -- Rejuvenation Meta
        CreateNewCheck(thisConfig,"Rejuvenation Meta", "Check to force rejuv |cffFFBB00on all targets(meta proc).");
        CreateNewText(thisConfig,"Rejuvenation Meta");

        -- Rejuvenation All
        CreateNewCheck(thisConfig,"Rejuvenation All", "Check to force rejuv |cffFFBB00on all targets(low prio).");
        CreateNewText(thisConfig,"Rejuvenation All");

        -- Rejuvenation Filler
        CreateNewCheck(thisConfig,"Rejuv Filler Count");
        CreateNewBox(thisConfig, "Rejuv Filler Count", 1, 25  , 1, 5, "|cffFFBB00Number of members to keep |cffFFFFFFRejuvenation |cffFFBB00as Filler.");
        CreateNewText(thisConfig,"Rejuv Filler Count");

        -- Rejuvenation Debuff
        CreateNewCheck(thisConfig,"Rejuvenation Debuff");
        CreateNewBox(thisConfig, "Rejuvenation Debuff", 0, 100  , 5, 65, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation |cffFFBB00on Debuffed units.");
        CreateNewText(thisConfig,"Rejuvenation Debuff");

        -- Healing Touch Ns
        CreateNewCheck(thisConfig,"Healing Touch Ns");
        CreateNewBox(thisConfig, "Healing Touch Ns", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 with |cffFFFFFFNature Swiftness.");
        CreateNewText(thisConfig,"Healing Touch Ns");
  
        -- Healing Touch Sm
        CreateNewCheck(thisConfig,"Healing Touch Sm");
        CreateNewBox(thisConfig, "Healing Touch Sm", 0, 100  , 5, 70, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 for |cffFFFFFF Sage Mender.");
        CreateNewText(thisConfig,"Healing Touch Sm");      
        
        if isKnown(114107) ~= true then
            -- Swiftmend
            CreateNewCheck(thisConfig,"Swiftmend");
            CreateNewBox(thisConfig, "Swiftmend", 0, 100  , 5, 35, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSwiftmend.");
            CreateNewText(thisConfig,"Swiftmend");

            -- Harmoney
            CreateNewCheck(thisConfig,"Swiftmend Harmoney");
            CreateNewBox(thisConfig, "Swiftmend Harmoney", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSwiftmend|cffFFBB00 to refresh Harmoney.");
            CreateNewText(thisConfig,"Swiftmend Harmoney");        
        end
        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"----- AoE Healing -----");

        -- WildGrowth
        CreateNewCheck(thisConfig,"WildGrowth");
        CreateNewBox(thisConfig, "WildGrowth", 0, 100  , 5, 85, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWildGrowth.");
        CreateNewText(thisConfig,"WildGrowth");

        -- WildGrowth Count
        CreateNewBox(thisConfig, "WildGrowth Count", 1, 25  , 1, 5, "|cffFFBB00Number of members under WildGrowth treshold needed to use |cffFFFFFFWildGrowth.");
        CreateNewText(thisConfig,"WildGrowth Count");

        -- WildGrowth All
        CreateNewCheck(thisConfig,"WildGrowth All");
        CreateNewBox(thisConfig, "WildGrowth All", 0, 100  , 5, 85, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWildGrowth.");
        CreateNewText(thisConfig,"WildGrowth All");
        
        -- WildGrowth All Count
        CreateNewBox(thisConfig, "WildGrowth All Count", 1, 25  , 1, 5, "|cffFFBB00Number of members under WildGrowth treshold needed to use |cffFFFFFFWildGrowth.");
        CreateNewText(thisConfig,"WildGrowth All Count");

        -- Genesis
        CreateNewCheck(thisConfig,"Genesis");
        CreateNewBox(thisConfig, "Genesis", 0, 100  , 5, 85, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGenesis.");
        CreateNewText(thisConfig,"Genesis");

        -- Genesis Count
        CreateNewBox(thisConfig, "Genesis Count", 1, 25  , 1, 5, "|cffFFBB00Number of members under Genesis treshold needed to use |cffFFFFFFGenesis.");
        CreateNewText(thisConfig,"Genesis Count");

        -- Genesis Filler
        CreateNewCheck(thisConfig,"Genesis Filler");
        CreateNewBox(thisConfig, "Genesis Filler", 0, 100  , 5, 85, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGenesis |cffFFBB00as Filler(low prio).");
        CreateNewText(thisConfig,"Genesis Filler");

        -- Mushrooms
        CreateNewCheck(thisConfig,"Mushrooms");
        CreateNewBox(thisConfig, "Mushrooms", 0, 100  , 5, 85, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWild Mushrooms.");
        CreateNewText(thisConfig,"Mushrooms");

        -- Mushrooms Count
        CreateNewBox(thisConfig, "Mushrooms Count", 1, 25  , 1, 5, "|cffFFBB00Number of members under Wild Mushrooms treshold needed to use |cffFFFFFFWild Mushrooms.");
        CreateNewText(thisConfig,"Mushrooms Count");

        -- Mushrooms Bloom
        CreateNewCheck(thisConfig,"Mushrooms Bloom");
        CreateNewBox(thisConfig, "Mushrooms Bloom", 0, 100  , 5, 85, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWild Mushrooms Bloom.");
        CreateNewText(thisConfig,"Mushrooms Bloom");

        -- Mushrooms Bloom Count
        CreateNewBox(thisConfig, "Mushrooms Bloom Count", 1, 25  , 1, 5, "|cffFFBB00Number of members under Wild Mushrooms Bloom treshold needed to use |cffFFFFFFWild Mushrooms Bloom.");
        CreateNewText(thisConfig,"Mushrooms Bloom Count");

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------- Defensive ------");

        -- Healthstone
        CreateNewCheck(thisConfig,"Healthstone");
        CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
        CreateNewText(thisConfig,"Healthstone");

        -- Barkskin
        CreateNewCheck(thisConfig,"Barkskin");
        CreateNewBox(thisConfig, "Barkskin", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin");
        CreateNewText(thisConfig,"Barkskin");

        -- Might of Ursoc
        CreateNewCheck(thisConfig,"Might of Ursoc");
        CreateNewBox(thisConfig, "Might of Ursoc", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFMight of Ursoc");
        CreateNewText(thisConfig,"Might of Ursoc");        

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"-------- Toggles --------");

        -- Genesis Toggle
        CreateNewCheck(thisConfig,"Genesis Toggle");
        CreateNewDrop(thisConfig,"Genesis Toggle", 4, "Toggle")
        CreateNewText(thisConfig,"Genesis Toggle");      

        -- Pause Toggle
        CreateNewCheck(thisConfig,"Pause Toggle");
        CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle")
        CreateNewText(thisConfig,"Pause Toggle");  

        -- Focus Toggle
        CreateNewCheck(thisConfig,"Focus Toggle");
        CreateNewDrop(thisConfig,"Focus Toggle", 2, "Toggle")
        CreateNewText(thisConfig,"Focus Toggle"); 

        -- DPS Toggle
        CreateNewCheck(thisConfig,"DPS Toggle");
        CreateNewDrop(thisConfig,"DPS Toggle", 1, "Toggle")
        CreateNewText(thisConfig,"DPS Toggle"); 

        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Utilities ------");

        -- Accept Queues
        CreateNewCheck(thisConfig,"Accept Queues");
        CreateNewText(thisConfig,"Accept Queues");

        -- Follow Tank
        CreateNewCheck(thisConfig,"Follow Tank");
        CreateNewBox(thisConfig, "Follow Tank", 10, 40  , 1, 25, "|cffFFBB00Range from focus...");
        CreateNewText(thisConfig,"Follow Tank");


        -- Zoo Master
        CreateNewCheck(thisConfig,"Zoo Master");
        CreateNewText(thisConfig,"Zoo Master");


        -- General Configs
        CreateGeneralsConfig();

        
        WrapsManager();
    end
end










end