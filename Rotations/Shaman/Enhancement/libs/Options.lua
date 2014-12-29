if select(3,UnitClass("player")) == 7 then

function EnhancementConfig()
    function titleOp(string)
        return CreateNewTitle(thisConfig,string)
    end
    function checkOp(string,tip)
        if tip == nil then
            return CreateNewCheck(thisConfig,string)
        else
            return CreateNewCheck(thisConfig,string,tip)
        end
    end
    function textOp(string)
        return CreateNewText(thisConfig,string)
    end
    function wrapOp(string)
        return CreateNewWrap(thisConfig,string)
    end
    function boxOp(string, minnum, maxnum, stepnum, defaultnum, tip)
        if tip == nil then
            return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum)
        else
            return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum, tip)
        end
    end
    function dropOp(string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
        return CreateNewDrop(thisConfig, string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
    end

-- Config Panel
    --if not doneConfig then
        thisConfig = 0
        -- Title
        titleOp("Cpoworks Enhancement")
                -- Spacer
        textOp(" ")
        wrapOp("--- General ---")

            -- Death Cat
            --checkOp("Death Cat Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.")
            --textOp("Death Cat Mode")

            -- Mark Of The Wild
            --checkOp("Mark of the Wild","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Mark of Wild usage. When enabled rotation will scan party/raid groups and cast if anyone in range in missing a similar buff.")
            --textOp(tostring(select(1,GetSpellInfo(mow))))

            -- Dummy DPS Test
            checkOp("DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.")
            boxOp("DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            textOp("DPS Testing")

            -- Single/Multi Toggle
            checkOp("Rotation Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFRotation Mode Key Toggle|cffFFBB00.")
            dropOp("Rotation Mode", 1, "Toggle")
            textOp("Rotation Mode")

        -- Spacer
        textOp(" ")
        wrapOp("--- Cooldowns ---")
        --dropOp("Cooldown Key", 1, "Toggle")

            -- Agi Pot
            checkOp("Agi-Pot")
            textOp("Agi-Pot")

            -- Flask / Crystal
            checkOp("Flask / Crystal")
            textOp("Flask / Crystal")

			-- Earth  Ele
            checkOp("Earth  Ele")
            textOp("Earth  Ele")

        -- Spacer
        textOp(" ")
        wrapOp("--- Defensive ---")

            -- Healthstone
            checkOp("Pot/Stoned")
            boxOp("Pot/Stoned", 0, 100, 5, 60)
            textOp("Pot/Stoned")

            -- Barkskin
            --checkOp("Barkskin")
            --boxOp("Barkskin", 0, 100, 5, 50)
            --textOp(tostring(select(1,GetSpellInfo(bar))))

            -- Survival Instincts
            --checkOp("Survival Instincts")
            --boxOp("Survival Instincts", 0, 100, 5, 40)
            --textOp(tostring(select(1,GetSpellInfo(si))))

            -- Frenzied Regeneration
            --checkOp("Frenzied Regen")
            --boxOp("Frenzied Regen", 0, 100, 5, 30)
            --textOp(tostring(select(1,GetSpellInfo(fr))))

        -- Spacer --
        textOp(" ")
        wrapOp("--- Interrupts ---")

            -- Skull Bash
            --checkOp("Skull Bash")
            --textOp(tostring(select(1,GetSpellInfo(sb))))

            -- Mighty Bash
            --checkOp("Mighty Bash")
            --textOp(tostring(select(1,GetSpellInfo(mb))))

            -- Maim
            --checkOp("Maim")
            --textOp(tostring(select(1,GetSpellInfo(ma))))


            -- Standard Interrupt
            checkOp("Interrupts")
            boxOp("Interrupts", 5, 95, 5, 0)
            textOp("Interrupt At")


        -- General Configs
        CreateGeneralsConfig()

        WrapsManager()
    --end
end
end