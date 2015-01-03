if select(3, UnitClass("player")) == 4 then
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
function NewRogueConfig()
    --if not doneConfig then
        thisConfig = 0
        -- Title
        titleOp("CuteOne New Rogue");
                -- Spacer
        CreateGeneralsConfig();

        WrapsManager();
    --end
end

-- Config Panel
function AssOptions()
    --if not doneConfig then
        thisConfig = 0
        -- Title
        titleOp("CuteOne Assassination");
                -- Spacer
        textOp(" ");
        wrapOp("--- General ---");

            -- Death Cat
            --checkOp("Death Cat Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.");
            --textOp("Death Cat Mode");

            -- Mark Of The Wild
            --checkOp("Mark of the Wild","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Mark of Wild usage. When enabled rotation will scan party/raid groups and cast if anyone in range in missing a similar buff.");
            --textOp(tostring(select(1,GetSpellInfo(mow))));

            -- Dummy DPS Test
            checkOp("DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.");
            boxOp("DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            textOp("DPS Testing");

            -- Stealth Timer
            checkOp("Stealth Timer");
            boxOp("Stealth Timer", 0, 2, 0.25, 1, "|cffFFBB00How long to wait(seconds) before using \n|cffFFFFFFStealth.");
            textOp("Stealth Timer");

            -- Stealth
            checkOp("Stealth");
            dropOp("Stealth",1,"Stealthing method.","|cff00FF00Always","|cffFFDD00PrePot","|cffFF000020Yards");
            textOp("Stealth");

            -- Leathal Poison
            checkOp("Lethal Poison");
            dropOp("Lethal Poison",1,"Lethal Poison.","|cff13A300Deadly","|cffFF8000Wound");
            textOp("Lethal");

            -- Non-Leathal Poison
            checkOp("Non-Lethal Poison");
            dropOp("Non-Lethal Poison",2,"Non-Lethal Poison.","|cff6600FFCrip","|cff00CF1CLeech");
            textOp("Non-Lethal");

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
            boxOp("Pot/Stoned", 0, 100, 5, 60, "|cffFFBB00Health Percentage to use at.");
            textOp("Pot/Stoned");

            -- Barkskin
            --checkOp("Barkskin");
            --boxOp("Barkskin", 0, 100, 5, 50);
            --textOp(tostring(select(1,GetSpellInfo(bar))));

            -- Survival Instincts
            --checkOp("Survival Instincts");
            --boxOp("Survival Instincts", 0, 100, 5, 40);
            --textOp(tostring(select(1,GetSpellInfo(si))));

            -- Frenzied Regeneration
            --checkOp("Frenzied Regen");
            --boxOp("Frenzied Regen", 0, 100, 5, 30);
            --textOp(tostring(select(1,GetSpellInfo(fr))));

        -- Spacer --
        textOp(" ");
        wrapOp("--- Interrupts ---");

            -- Skull Bash
            --checkOp("Skull Bash")
            --textOp(tostring(select(1,GetSpellInfo(sb))))

            -- Mighty Bash
            --checkOp("Mighty Bash")
            --textOp(tostring(select(1,GetSpellInfo(mb))))

            -- Maim
            --checkOp("Maim")
            --textOp(tostring(select(1,GetSpellInfo(ma))))

            -- Interrupt Percentage
            checkOp("Interrupts");
            boxOp("Interrupts", 5, 95, 5, 0, "|cffFFBB00Cast Percentage to use at.");
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

            -- Pick Pocket Toggle
            checkOp("Picker Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFThrash Toggle Key|cffFFBB00.");
            dropOp("Picker Mode", 5, "Toggle")
            textOp("Pick Pocket");

            -- Pause Toggle
            checkOp("Pause Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFPause Toggle Key - None Defaults to LeftAlt|cffFFBB00.")
            dropOp("Pause Mode", 6, "Toggle")
            textOp("Pause Mode")

        -- General Configs
        CreateGeneralsConfig();

        WrapsManager();
    --end
end

end
