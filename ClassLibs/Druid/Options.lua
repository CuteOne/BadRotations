if select(3, UnitClass("player")) == 11 then
--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]   
--[[ ]]   --[[ ]]   --[[           ]]   --[[           ]]   --[[  ]]   --[[]]   
--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[    ]] --[[]]       
--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]   
--[[]]     --[[]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]   
--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[]]   --[[  ]]   
--[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]   
 
--[[           ]]         --[[]]        --[[           ]]
--[[           ]]        --[[  ]]       --[[           ]]
--[[]]                  --[[    ]]           --[[ ]]    
--[[]]                 --[[      ]]          --[[ ]]    
--[[]]                --[[        ]]         --[[ ]]    
--[[           ]]    --[[]]    --[[]]        --[[ ]]        
--[[           ]]   --[[]]      --[[]]       --[[ ]]    

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
function FeralCatConfig()
    --if not doneConfig then
        thisConfig = 0
        -- Title
        titleOp("CuteOne Feral Cat");
                -- Spacer
        textOp(" ");
        wrapOp("--- General ---");

            -- Death Cat
            checkOp("Death Cat Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.");
            textOp("Death Cat Mode");

            -- Mark Of The Wild
            checkOp("Mark of the Wild","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Mark of Wild usage. When enabled rotation will scan party/raid groups and cast if anyone in range in missing a similar buff.");
            textOp(tostring(select(1,GetSpellInfo(mow))));

            -- Dummy DPS Test
            checkOp("DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.");
            boxOp("DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            textOp("DPS Testing");

            -- Rake Multi-Target
            checkOp("Multi-Rake","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFMulti-Target Raking|cffFFBB00.");
            textOp("Multi-Rake");


        -- Spacer
        textOp(" ");
        wrapOp("--- Cooldowns ---");

            -- Agi Pot
            checkOp("Agi-Pot");
            textOp("Agi-Pot");

            -- Flask / Crystal
            checkOp("Flask / Crystal");
            textOp("Flask / Crystal");
        
        -- Spacer
        textOp(" ");
        wrapOp("--- Defensive ---");

            -- Healthstone
            checkOp("Pot/Stoned");
            boxOp("Pot/Stoned", 0, 100, 5, 60);
            textOp("Pot/Stoned");

            -- Barkskin
            checkOp("Barkskin");
            boxOp("Barkskin", 0, 100, 5, 50);
            textOp(tostring(select(1,GetSpellInfo(bar))));

            -- Survival Instincts
            checkOp("Survival Instincts");
            boxOp("Survival Instincts", 0, 100, 5, 40);
            textOp(tostring(select(1,GetSpellInfo(si))));

            -- Frenzied Regeneration
            checkOp("Frenzied Regen");
             boxOp("Frenzied Regen", 0, 100, 5, 30);
            textOp(tostring(select(1,GetSpellInfo(fr))));

        -- Spacer --
        textOp(" ");
        wrapOp("--- Interrupts ---");

            -- Skull Bash
            checkOp("Skull Bash")
            textOp(tostring(select(1,GetSpellInfo(sb))))

            -- Mighty Bash
            checkOp("Mighty Bash")
            textOp(tostring(select(1,GetSpellInfo(mb))))

            -- Maim
            checkOp("Maim")
            textOp(tostring(select(1,GetSpellInfo(ma))))

            -- Interrupt Percentage
            checkOp("Interrupts");
            boxOp("Interrupts", 5, 95, 5, 0);
            textOp("Interrupt At");

        -- Spacer
        textOp(" ");
        wrapOp("--- Toggle Keys ---");

            -- Single/Multi Toggle
            checkOp("Rotation Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFRotation Mode Toggle Key|cffFFBB00.");
            dropOp("Rotation Mode", 4, "Toggle")
            textOp("Rotation");

            --Cooldown Key Toggle
            checkOp("Cooldown Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFCooldown Mode Toggle Key|cffFFBB00.");
            dropOp("Cooldown Mode", 3, "Toggle")
            textOp("Cooldowns")

            --Defensive Key Toggle
            checkOp("Defensive Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFDefensive Mode Toggle Key|cffFFBB00.");
            dropOp("Defensive Mode", 6, "Toggle")
            textOp("Defensive")

            --Interrupts Key Toggle
            checkOp("Interrupt Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFInterrupt Mode Toggle Key|cffFFBB00.");
            dropOp("Interrupt Mode", 6, "Toggle")
            textOp("Interrupts")

            -- Thrash Toggle
            checkOp("Thrash Toggle","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFThrash Toggle Key|cffFFBB00.");
            dropOp("Thrash Toggle", 6, "Toggle")
            textOp("Thrash");

            -- Symbiosis Toggle
            checkOp("Symbiosis Toggle","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFSymbiosis Toggle Key|cffFFBB00.");
            dropOp("Symbiosis Toggle", 5, "Toggle")
            textOp("Symbiosis");

        -- Spacer
        textOp(" ");
        wrapOp("--- Utilities ---");

            -- Throttle
            CreateNewCheck(thisConfig,"Throttle");
            CreateNewBox(thisConfig, "Throttle", 0, 1000  , 5, 50 , "|cffFFBB00Time to throttle profile refiring.");
            CreateNewText(thisConfig,"Throttle");
            
            -- PokeRotation
            checkOp("PokeRotation");
            textOp("PokeRotation");

            -- Debug
            checkOp("Debug");
            textOp("Debug");

       -- Bound
        CreateNewBound(thisConfig,"End"); 

        doneConfig = true;
        WrapsManager();
    --end
end


--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[]]     --[[]]   --[[]]              --[[]]                   --[[ ]]        --[[]]     --[[]]
--[[           ]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[]]     --[[]]
--[[        ]]      --[[]]                         --[[]]        --[[ ]]        --[[]]     --[[]]
--[[]]    --[[]]    --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]


function RestorationConfig()
    if currentConfig ~= "Restoration Masou" then
        ClearConfig();
        thisConfig = 0
        -- Title
        CreateNewTitle(thisConfig,"|cff00EEFFRestoration |cffFF0000Masoud");

        -- Wrapper
        CreateNewWrap(thisConfig,"----- Buffs -----");

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

        -- Wrapper
        CreateNewWrap(thisConfig,"----- Cooldowns -----");


        -- Incarnation
        CreateNewCheck(thisConfig,"Incarnation");
        CreateNewBox(thisConfig, "Incarnation", 0, 100  , 5, 45, "|cffFFBB00Under what %HP to use |cffFFFFFFIncarnation.");
        CreateNewText(thisConfig,"Incarnation");   

        -- Innervate
        CreateNewCheck(thisConfig,"Innervate");
        CreateNewBox(thisConfig, "Innervate", 0, 100  , 5, 80, "|cffFFBB00Under what %Mana to use |cffFFFFFFInnervate.");
        CreateNewText(thisConfig,"Innervate");   

        -- Wrapper
        CreateNewWrap(thisConfig,"-- Level 60 Talent --")

        if isKnown(114107) then
            -- Harmoney SotF
            CreateNewCheck(thisConfig,"Harmoney SotF");
            CreateNewBox(thisConfig, "Harmoney SotF", 0, 100  , 5, 40, "|cffFFBB00Under what %HP to use |cffFFFFFFRegrowth|cffFFBB00 to refresh Harmoney.");
            CreateNewText(thisConfig,"Harmoney SotF");

            -- WildGrowth SotF
            CreateNewCheck(thisConfig,"WildGrowth SotF");
            CreateNewBox(thisConfig, "WildGrowth SotF", 0, 100  , 5, 45, "|cffFFBB00Under what %HP to use |cffFFFFFFSwiftmend.");
            CreateNewText(thisConfig,"WildGrowth SotF"); 

            -- WildGrowth SotF Count
            CreateNewCheck(thisConfig,"WildGrowth SotF Count");
            CreateNewBox(thisConfig, "WildGrowth SotF Count", 1, 25  , 1, 3, "|cffFFBB00Number of members under Force of Nature treshold needed to use |cffFFFFFFSwiftmend.");
            CreateNewText(thisConfig,"WildGrowth SotF Count"); 
        elseif isKnown(106737) then
            -- Force of Nature
            CreateNewCheck(thisConfig,"Force of Nature");
            CreateNewBox(thisConfig, "Force of Nature", 0, 100  , 5, 45, "|cffFFBB00Under what %HP to use |cffFFFFFFForce of Nature.");
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
            CreateNewBox(thisConfig, "Rejuvenation Tol", 0, 100  , 5, 90, "|cffFFBB00Under what %HP to use |cffFFFFFFRejuvenation|cffFFBB00 while in Tree of Life. \n|cffFFDD11Used after Rejuvenation if Rejuvenation All Tol is not selected.");
            CreateNewText(thisConfig,"Rejuvenation Tol");

            -- Rejuvenation All Tol
            CreateNewCheck(thisConfig,"Rejuvenation All Tol");
            CreateNewText(thisConfig,"Rejuvenation All Tol");

            -- Regrowth Tol
            CreateNewCheck(thisConfig,"Regrowth Tol");
            CreateNewBox(thisConfig, "Regrowth Tol", 0, 100  , 5, 40, "|cffFFBB00Under what %HP to use |cffFFFFFFRegrowth|cffFFBB00 while in Tree of Life.");
            CreateNewText(thisConfig,"Regrowth Tol");

            -- Regrowth Tank Tol
            CreateNewCheck(thisConfig,"Regrowth Tank Tol");
            CreateNewBox(thisConfig, "Regrowth Tank Tol", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFRegrowth|cffFFBB00 on tanks while in Tree of Life .");
            CreateNewText(thisConfig,"Regrowth Tank Tol");

            -- Regrowth Omen Tol
            CreateNewCheck(thisConfig,"Regrowth Omen Tol");
            CreateNewBox(thisConfig, "Regrowth Omen Tol", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFRegrowth|cffFFBB00 while in Tree of Life and Omen proc.");
            CreateNewText(thisConfig,"Regrowth Omen Tol");

            -- WildGrowth Tol
            CreateNewCheck(thisConfig,"WildGrowth Tol");
            CreateNewBox(thisConfig, "WildGrowth Tol", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFWildGrowth|cffFFBB00 while in Tree of Life.");
            CreateNewText(thisConfig,"WildGrowth Tol");

            -- Mushrooms Bloom Count
            CreateNewBox(thisConfig, "WildGrowth Tol Count", 1, 25  , 1, 5, "|cffFFBB00Number of members under WildGrowth Tol treshold needed to use |cffFFFFFFWildGrowth|cffFFBB00 while in Tree of Life.");
            CreateNewText(thisConfig,"WildGrowth Tol Count");
        end


        -- Wrapper
        CreateNewWrap(thisConfig,"------ Healing ------")

        -- Lifebloom
        CreateNewCheck(thisConfig,"Lifebloom");
        CreateNewBox(thisConfig, "Lifebloom", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to |cffFFFFFFlet Lifebloom Bloom |cffFFBB00on Focus.");
        CreateNewText(thisConfig,"Lifebloom");

        -- Regrowth
        CreateNewCheck(thisConfig,"Regrowth");
        CreateNewBox(thisConfig, "Regrowth", 0, 100  , 5, 65, "|cffFFBB00Under what %HP to use |cffFFFFFFRegrowth.");
        CreateNewText(thisConfig,"Regrowth");

        -- Regrowth Tank
        CreateNewCheck(thisConfig,"Regrowth Tank");
        CreateNewBox(thisConfig, "Regrowth Tank", 0, 100  , 5, 55, "|cffFFBB00Under what %HP to use |cffFFFFFFRegrowth|cffFFBB00 on Tanks.");
        CreateNewText(thisConfig,"Regrowth Tank");

        -- Regrowth Omen
        CreateNewCheck(thisConfig,"Regrowth Omen");
        CreateNewBox(thisConfig, "Regrowth Omen", 0, 100  , 5, 80, "|cffFFBB00Under what %HP to use |cffFFFFFFRegrowth|cffFFBB00 with Omen of Clarity.");
        CreateNewText(thisConfig,"Regrowth Omen");

        -- Rejuvenation
        CreateNewCheck(thisConfig,"Rejuvenation");
        CreateNewBox(thisConfig, "Rejuvenation", 0, 100  , 5, 80, "|cffFFBB00Under what %HP to use |cffFFFFFFRejuvenation.");
        CreateNewText(thisConfig,"Rejuvenation");

        -- Rejuvenation Tank
        CreateNewCheck(thisConfig,"Rejuvenation Tank");
        CreateNewBox(thisConfig, "Rejuvenation Tank", 0, 100  , 5, 65, "|cffFFBB00Under what %HP to use |cffFFFFFFRejuvenation |cffFFBB00on Tanks.");
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
        CreateNewBox(thisConfig, "Rejuvenation Debuff", 0, 100  , 5, 65, "|cffFFBB00Under what %HP to use |cffFFFFFFRejuvenation |cffFFBB00on Debuffed units.");
        CreateNewText(thisConfig,"Rejuvenation Debuff");

        -- Healing Touch Ns
        CreateNewCheck(thisConfig,"Healing Touch Ns");
        CreateNewBox(thisConfig, "Healing Touch Ns", 0, 100  , 5, 25, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Touch|cffFFBB00 with |cffFFFFFFNature Swiftness.");
        CreateNewText(thisConfig,"Healing Touch Ns");
  
        -- Healing Touch Sm
        CreateNewCheck(thisConfig,"Healing Touch Sm");
        CreateNewBox(thisConfig, "Healing Touch Sm", 0, 100  , 5, 70, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Touch|cffFFBB00 for |cffFFFFFF Sage Mender.");
        CreateNewText(thisConfig,"Healing Touch Sm");      
        
        if isKnown(114107) ~= true then
            -- Swiftmend
            CreateNewCheck(thisConfig,"Swiftmend");
            CreateNewBox(thisConfig, "Swiftmend", 0, 100  , 5, 35, "|cffFFBB00Under what %HP to use |cffFFFFFFSwiftmend.");
            CreateNewText(thisConfig,"Swiftmend");

            -- Harmoney
            CreateNewCheck(thisConfig,"Swiftmend Harmoney");
            CreateNewBox(thisConfig, "Swiftmend Harmoney", 0, 100  , 5, 40, "|cffFFBB00Under what %HP to use |cffFFFFFFSwiftmend|cffFFBB00 to refresh Harmoney.");
            CreateNewText(thisConfig,"Swiftmend Harmoney");        
        end
        -- Wrapper
        CreateNewWrap(thisConfig,"----- AoE Healing -----")

        -- WildGrowth
        CreateNewCheck(thisConfig,"WildGrowth");
        CreateNewBox(thisConfig, "WildGrowth", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFWildGrowth.");
        CreateNewText(thisConfig,"WildGrowth");

        -- WildGrowth Count
        CreateNewBox(thisConfig, "WildGrowth Count", 1, 25  , 1, 5, "|cffFFBB00Number of members under WildGrowth treshold needed to use |cffFFFFFFWildGrowth.");
        CreateNewText(thisConfig,"WildGrowth Count");

        -- WildGrowth All
        CreateNewCheck(thisConfig,"WildGrowth All");
        CreateNewBox(thisConfig, "WildGrowth All", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFWildGrowth.");
        CreateNewText(thisConfig,"WildGrowth All");
        
        -- WildGrowth All Count
        CreateNewBox(thisConfig, "WildGrowth All Count", 1, 25  , 1, 5, "|cffFFBB00Number of members under WildGrowth treshold needed to use |cffFFFFFFWildGrowth.");
        CreateNewText(thisConfig,"WildGrowth All Count");

        -- Genesis
        CreateNewCheck(thisConfig,"Genesis");
        CreateNewBox(thisConfig, "Genesis", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFGenesis.");
        CreateNewText(thisConfig,"Genesis");

        -- Genesis Count
        CreateNewBox(thisConfig, "Genesis Count", 1, 25  , 1, 5, "|cffFFBB00Number of members under Genesis treshold needed to use |cffFFFFFFGenesis.");
        CreateNewText(thisConfig,"Genesis Count");

        -- Genesis Filler
        CreateNewCheck(thisConfig,"Genesis Filler");
        CreateNewBox(thisConfig, "Genesis Filler", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFGenesis |cffFFBB00as Filler(low prio).");
        CreateNewText(thisConfig,"Genesis Filler");

        -- Mushrooms
        CreateNewCheck(thisConfig,"Mushrooms");
        CreateNewBox(thisConfig, "Mushrooms", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFWild Mushrooms.");
        CreateNewText(thisConfig,"Mushrooms");

        -- Mushrooms Count
        CreateNewBox(thisConfig, "Mushrooms Count", 1, 25  , 1, 5, "|cffFFBB00Number of members under Wild Mushrooms treshold needed to use |cffFFFFFFWild Mushrooms.");
        CreateNewText(thisConfig,"Mushrooms Count");

        -- Mushrooms Bloom
        CreateNewCheck(thisConfig,"Mushrooms Bloom");
        CreateNewBox(thisConfig, "Mushrooms Bloom", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFWild Mushrooms Bloom.");
        CreateNewText(thisConfig,"Mushrooms Bloom");

        -- Mushrooms Bloom Count
        CreateNewBox(thisConfig, "Mushrooms Bloom Count", 1, 25  , 1, 5, "|cffFFBB00Number of members under Wild Mushrooms Bloom treshold needed to use |cffFFFFFFWild Mushrooms Bloom.");
        CreateNewText(thisConfig,"Mushrooms Bloom Count");

        -- Wrapper
        CreateNewWrap(thisConfig,"------ Defensive -------");

        -- Healthstone
        CreateNewCheck(thisConfig,"Healthstone");
        CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what %HP to use |cffFFFFFFHealthstone");
        CreateNewText(thisConfig,"Healthstone");

        -- Barkskin
        CreateNewCheck(thisConfig,"Barkskin");
        CreateNewBox(thisConfig, "Barkskin", 0, 100  , 5, 40, "|cffFFBB00Under what %HP to use |cffFFFFFFBarkskin");
        CreateNewText(thisConfig,"Barkskin");

        -- Might of Ursoc
        CreateNewCheck(thisConfig,"Might of Ursoc");
        CreateNewBox(thisConfig, "Might of Ursoc", 0, 100  , 5, 20, "|cffFFBB00Under what %HP to use |cffFFFFFFMight of Ursoc");
        CreateNewText(thisConfig,"Might of Ursoc");        

        -- Hotkeys
        CreateNewWrap(thisConfig,"------ Toggles -------");

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

        -- Wrapper
        CreateNewWrap(thisConfig,"--- Healing Engine ---")

        -- Engine Debug
        CreateNewCheck(thisConfig,"Engine Debug");       
        CreateNewBox(thisConfig, "Engine Debug", 0, 1000  , 5, 0, "|cffFFBB00Time to wait before refreshing engine.");
        CreateNewText(thisConfig,"Engine Debug");

        -- Engine Refresh
        CreateNewCheck(thisConfig,"Engine Refresh");       
        CreateNewBox(thisConfig, "Engine Refresh", 0, 1000  , 5, 0, "|cffFFBB00Time to wait before refreshing engine.");
        CreateNewText(thisConfig,"Engine Refresh");

        -- Overhealing Cancel Cast
        CreateNewCheck(thisConfig,"Overhealing Cancel");       
        CreateNewBox(thisConfig, "Overhealing Cancel", 100, 200  , 5, 100, "|cffFFBB00Stop casting heal if target is going to have over this amount of HP after heal.");
        CreateNewText(thisConfig,"Overhealing Cancel");

        -- No Absorbs
        CreateNewCheck(thisConfig,"No Absorbs");
        CreateNewText(thisConfig,"No Absorbs");

        -- Special Heal
        CreateNewCheck(thisConfig,"Special Heal");
        CreateNewDrop(thisConfig,"Special Heal", 2, "|cffFFDD11Select wich targets you want to add to engine:Mouseover/Focus/Target Heal. \n|cffFF0000All: |cffFFDD11All targets. \n|cffFF0000Special: |cffFFDD11Only special Units.", "|cffFF0000All", "|cffFFDD11Special")
        CreateNewText(thisConfig,"Special Heal");

        -- Special Priority
        CreateNewCheck(thisConfig,"Special Priority","|cffFFBB00Priorise Special targets.");     
        CreateNewText(thisConfig,"Special Priority");

        -- Heal Pets
        CreateNewCheck(thisConfig,"Heal Pets");
        CreateNewText(thisConfig,"Heal Pets");

        -- Blacklist
        CreateNewCheck(thisConfig,"Blacklist");
        CreateNewBox(thisConfig, "Blacklist", 0, 105  , 5, 105, "|cffFFBB00How much HP do we want to add to |cffFFDD00Blacklisted |cffFFBB00units.");
        CreateNewText(thisConfig,"Blacklist");


        -- No Incoming Heals
        CreateNewCheck(thisConfig,"No Incoming Heals");
        CreateNewText(thisConfig,"No Incoming Heals");

        -- Wrapper
        CreateNewWrap(thisConfig,"-------- General -------");


        -- Follow Tank
        CreateNewCheck(thisConfig,"Follow Tank");
        CreateNewBox(thisConfig, "Follow Tank", 0, 40  , 1, 30, "|cffFFBB00Range from focus...");
        CreateNewText(thisConfig,"Follow Tank");


        -- Zoo Master
        CreateNewCheck(thisConfig,"Zoo Master");
        CreateNewText(thisConfig,"Zoo Master");

        -- Lag Tolerance
        CreateNewCheck(thisConfig,"Lag Tolerance");
        CreateNewBox(thisConfig, "Lag Tolerance", 0, 400  , 5, 30, "|cffFFBB00You know...");
        CreateNewText(thisConfig,"Lag Tolerance");

        -- PokeRotation
        CreateNewCheck(thisConfig,"PokeRotation");
        CreateNewText(thisConfig,"PokeRotation");

        -- Debug
        CreateNewCheck(thisConfig,"Debug", "|cffFFBB00Check this to start |cffFFFFFFChat Debug |cffFFBB00of casted spells.");
        CreateNewText(thisConfig,"Debug");

       -- Bound
        CreateNewBound(thisConfig,"End"); 

        doneConfig = true;
        WrapsManager();
    end
end




end