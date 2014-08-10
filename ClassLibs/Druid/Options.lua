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
    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,"|cff00EEFFRestoration |cffFF0000Masoud");

    -- Wrapper
    CreateNewWrap(thisConfig,"----- Buffs -----");

    -- Mark Of The Wild
    CreateNewCheck(thisConfig,"Mark Of The Wild");
    CreateNewText(thisConfig,"Mark Of The Wild");


    -- Wrapper
    CreateNewWrap(thisConfig,"---- Cooldowns ----");

    -- Innervate
    CreateNewCheck(thisConfig,"Innervate");
    CreateNewBox(thisConfig, "Innervate", 0, 100  , 5, 80, "|cffFFBB00Under what %HP Mana to use |cffFFFFFFInnervate.");
    CreateNewText(thisConfig,"Innervate");   

    -- Wrapper
    CreateNewWrap(thisConfig,"----- Healing Engine -----")

    -- No Absorbs
    CreateNewCheck(thisConfig,"No Absorbs");
    CreateNewText(thisConfig,"No Absorbs");

    -- Wrapper
    CreateNewWrap(thisConfig,"----- AoE Healing -----")

    -- Genesis
    CreateNewCheck(thisConfig,"Genesis");
    CreateNewBox(thisConfig, "Genesis", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFGenesis.");
    CreateNewText(thisConfig,"Genesis");

    -- Genesis Count
    CreateNewBox(thisConfig, "Genesis Count", 0, 25  , 1, 5, "|cffFFBB00Number of members under Genesis treshold needed to use |cffFFFFFFGenesis.");
    CreateNewText(thisConfig,"Genesis Count");

    -- Wild Mushrooms
    CreateNewCheck(thisConfig,"Wild Mushrooms");
    CreateNewBox(thisConfig, "Wild Mushrooms", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFWild Mushrooms.");
    CreateNewText(thisConfig,"Wild Mushrooms");

    -- Wild Mushrooms Count
    CreateNewBox(thisConfig, "Wild Mushrooms Count", 0, 25  , 1, 5, "|cffFFBB00Number of members under Wild Mushrooms treshold needed to use |cffFFFFFFWild Mushrooms.");
    CreateNewText(thisConfig,"Wild Mushrooms Count");

    -- Wild Mushrooms Bloom
    CreateNewCheck(thisConfig,"Wild Mushrooms Bloom");
    CreateNewBox(thisConfig, "Wild Mushrooms Bloom", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFWild Mushrooms Bloom.");
    CreateNewText(thisConfig,"Wild Mushrooms Bloom");

    -- Wild Mushrooms Bloom Count
    CreateNewBox(thisConfig, "Wild Mushrooms Bloom Count", 0, 25  , 1, 5, "|cffFFBB00Number of members under Wild Mushrooms Bloom treshold needed to use |cffFFFFFFWild Mushrooms Bloom.");
    CreateNewText(thisConfig,"Wild Mushrooms Bloom Count");

    -- Wrapper
    CreateNewWrap(thisConfig,"----- Healing -----")

    -- Lifebloom
    CreateNewCheck(thisConfig,"Lifebloom");
    CreateNewBox(thisConfig, "Lifebloom", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFLifebloom |cffFFBB00on Focus.");
    CreateNewText(thisConfig,"Lifebloom");

    -- Regrowth
    CreateNewCheck(thisConfig,"Regrowth");
    CreateNewBox(thisConfig, "Regrowth", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFRegrowth.");
    CreateNewText(thisConfig,"Regrowth");

    -- Rejuvenation
    CreateNewCheck(thisConfig,"Rejuvenation");
    CreateNewBox(thisConfig, "Rejuvenation", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFRejuvenation.");
    CreateNewText(thisConfig,"Rejuvenation");

    -- Healing Touch
    CreateNewCheck(thisConfig,"Healing Touch Ns");
    CreateNewBox(thisConfig, "Healing Touch Ns", 0, 100  , 5, 35, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Touch.");
    CreateNewText(thisConfig,"Healing Touch Ns");

    -- Wrapper
    CreateNewWrap(thisConfig,"------ Defensive -------");

    -- Barkskin
    CreateNewCheck(thisConfig,"Barkskin");
    CreateNewBox(thisConfig, "Barkskin", 0, 100  , 5, 30, "|cffFFBB00Under what %HP to use |cffFFFFFFBarkskin");
    CreateNewText(thisConfig,"Barkskin");

    -- Wrapper
    CreateNewWrap(thisConfig,"-------- General -------");

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