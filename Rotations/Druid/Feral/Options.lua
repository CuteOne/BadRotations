if select(3, UnitClass("player")) == 11 then

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
    function FeralCatConfig()
        if GetSpecialization() == 2 then 
            if Currentconfig ~= "Feral CuteOne" then
                ClearConfig()
                thisConfig = 0
                -- Title
                titleOp("CuteOne Feral Cat")
                        -- Spacer
                textOp(" ")
                wrapOp("--- General (Profile) ---")

                    -- Death Cat
                    checkOp("Death Cat Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.")
                    textOp("Death Cat Mode")

                    -- Mark Of The Wild
                    checkOp("Mark of the Wild","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Mark of Wild usage. When enabled rotation will scan party/raid groups and cast if anyone in range in missing a similar buff.")
                    textOp(tostring(select(1,GetSpellInfo(mow))))

                    -- Dummy DPS Test
                    checkOp("DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.")
                    boxOp("DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
                    textOp("DPS Testing")

                    -- Travel Shapeshifts
                    checkOp("Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFAuto Shapeshifting to best form for situation.|cffFFBB00.")
                    textOp("Auto Shapeshifts")

                    -- Mouseover Targeting
                    checkOp("Mouseover Targeting","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFmouseover target validation.|cffFFBB00.")
                    textOp("Mouseover Targeting")

                -- Spacer
                textOp(" ")
                wrapOp("--- Cooldowns ---")

                    -- Agi Pot
                    checkOp("Agi-Pot")
                    textOp("Agi-Pot")

                    -- Flask / Crystal
                    checkOp("Flask / Crystal")
                    textOp("Flask / Crystal")

                -- Spacer
                textOp(" ")
                wrapOp("--- Defensive ---")

                    -- Rejuvenation
                    checkOp("Rejuvenation")
                    boxOp("Rejuvenation", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
                    textOp("Rejuvenation")

                    -- Auto Rejuvenation
                    checkOp("Auto Rejuvenation")
                    boxOp("Auto Rejuvenation", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
                    textOp("Auto Rejuvenation")

                    -- Healthstone
                    checkOp("Pot/Stoned")
                    boxOp("Pot/Stoned", 0, 100, 5, 60, "|cffFFFFFFHealth Percent to Cast At")
                    textOp("Pot/Stoned")

                    -- Nature's Vigil
                    checkOp("Nature's Vigil")
                    boxOp("Nature's Vigil", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At")
                    textOp(tostring(select(1,GetSpellInfo(nv))))

                    -- Survival Instincts
                    checkOp("Survival Instincts")
                    boxOp("Survival Instincts", 0, 100, 5, 40, "|cffFFFFFFHealth Percent to Cast At")
                    textOp(tostring(select(1,GetSpellInfo(si))))

                    -- Healing Touch
                    checkOp("Healing Touch")
                    boxOp("Healing Touch", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At")
                    textOp(tostring(select(1,GetSpellInfo(ht))))

                    -- Dream of Cenarius Auto-Heal
                    checkOp("Auto Heal")
                    dropOp("Auto Heal", 1, "|cffFFFFFFSelect Target to Auto-Heal",
                        "|cffFFDD11LowestHP",
                        "|cffFFDD11Self")
                    textOp("Auto-Heal (DoC)")

                -- Spacer --
                textOp(" ")
                wrapOp("--- Interrupts ---")

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
                    checkOp("Interrupts")
                    boxOp("Interrupts", 0, 95, 5, 0, "|cffFFFFFFCast Percent to Cast At")
                    textOp("Interrupt At")

                -- Spacer
                textOp(" ")
                wrapOp("--- Toggle Keys ---")

                    -- Single/Multi Toggle
                    checkOp("Rotation Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFRotation Mode Toggle Key|cffFFBB00.")
                    dropOp("Rotation Mode", 4, "Toggle")
                    textOp("Rotation")

                    -- Cooldown Key Toggle
                    checkOp("Cooldown Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFCooldown Mode Toggle Key|cffFFBB00.")
                    dropOp("Cooldown Mode", 3, "Toggle")
                    textOp("Cooldowns")

                    -- Defensive Key Toggle
                    checkOp("Defensive Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFDefensive Mode Toggle Key|cffFFBB00.")
                    dropOp("Defensive Mode", 6, "Toggle")
                    textOp("Defensive")

                    -- Interrupts Key Toggle
                    checkOp("Interrupt Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFInterrupt Mode Toggle Key|cffFFBB00.")
                    dropOp("Interrupt Mode", 6, "Toggle")
                    textOp("Interrupts")

                    -- Cleave Toggle
                    checkOp("Cleave Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFCleave Toggle Key|cffFFBB00.")
                    dropOp("Cleave Mode", 6, "Toggle")
                    textOp("Cleave Mode")

                    -- Prowl Toggle
                    checkOp("Prowl Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFProwl Toggle Key|cffFFBB00.")
                    dropOp("Prowl Mode", 6, "Toggle")
                    textOp("Prowl Mode")

                -- General Configs
                CreateGeneralsConfig()

                WrapsManager()
            end
        end
    end
end