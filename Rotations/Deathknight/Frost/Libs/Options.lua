if select(3,UnitClass("player")) == 6 then

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
    function FrostOptions()
        if GetSpecialization() == 2 then    
            if Currentconfig ~= "Frost DK" then
                ClearConfig()
                thisConfig = 0
                -- Title
                titleOp("Frost Death Knight")
                        -- Spacer
                textOp(" ")
                wrapOp("--- General (Profile) ---")

                    -- Auto Looter
                    checkOp("Auto Looter","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic corpse looting.")
                    textOp("Auto Looter")

                    -- Mouseover Targeting
                    checkOp("Mouseover Targeting","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFmouseover target validation.|cffFFBB00.")
                    textOp("Mouseover Targeting")

                    -- Horn of Winter
                    checkOp("Horn of Winter","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Horn of Winter usage. When enabled rotation will scan party/raid groups and cast if anyone in range in missing a similar buff.")
                    textOp(tostring(select(1,GetSpellInfo(_HornOfWinter))))

                    -- Dummy DPS Test
                    checkOp("DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.")
                    boxOp("DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
                    textOp("DPS Testing")

                -- Spacer
                textOp(" ")
                wrapOp("--- Cooldowns ---")

                    -- Agi Pot
                    checkOp("Agi-Pot")
                    textOp("Agi-Pot")

                    -- Flask / Crystal
                    checkOp("Flask / Crystal")
                    textOp("Flask / Crystal")

                    -- Trinkets
                    checkOp("Trinkets")
                    textOp("Trinkets")

                    -- Empower Rune Weapon
                    if isKnown(_EmpowerRuneWeapon) then
                       checkOp("Empower Rune Weapon")
                       textOp("Empower Rune Weapon")
                    end 

                -- Spacer
                textOp(" ")
                wrapOp("--- Defensive ---")

                    -- Healthstone
                    checkOp("Pot/Stoned")
                    boxOp("Pot/Stoned", 0, 100, 5, 60, "|cffFFFFFFHealth Percent to Cast At")
                    textOp("Pot/Stoned")

                    -- Blood Presence
                    checkOp("Blood Presence")
                    boxOp("Blood Presence", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
                    textOp(tostring(select(1,GetSpellInfo(_BloodPresence))))

                    -- Death Strike
                    checkOp("Death Strike")
                    boxOp("Death Strike", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
                    textOp(tostring(select(1,GetSpellInfo(_DeathStrike))))

                    -- Icebound Fortitude
                    checkOp("Icebound Fortitude")
                    boxOp("Icebound Fortitude", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
                    textOp(tostring(select(1,GetSpellInfo(_IceboundFortitude))))

                    -- Anti-Magic Shell/Zone
                    if getTalent(2,2) then
                        checkOp("Anti-Magic Zone")
                        boxOp("Anti-Magic Zone", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
                        textOp(tostring(select(1,GetSpellInfo(_AntiMagicZone))))
                    else
                        checkOp("Anti-Magic Shell")
                        boxOp("Anti-Magic Shell", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
                        textOp(tostring(select(1,GetSpellInfo(_AntiMagicShell))))
                    end

                    -- Death Pact
                    if getTalent(5,1) then
                        checkOp("Death Pact")
                        boxOp("Death Pact", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
                        textOp(tostring(select(1,GetSpellInfo(_DeathPact))))
                    end

                    -- Death Siphon
                    if getTalent(5,2) then
                        checkOp("Death Siphon")
                        boxOp("Death Siphon", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
                        textOp(tostring(select(1,GetSpellInfo(_DeathSiphon))))
                    end

                    -- Conversion
                    if getTalent(5,3) then
                        checkOp("Conversion")
                        boxOp("Conversion", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
                        textOp(tostring(select(1,GetSpellInfo(_Conversion))))
                    end

                -- Spacer --
                textOp(" ")
                wrapOp("--- Interrupts ---")

                    -- Mind Freeze
                    checkOp("Mind Freeze")
                    textOp(tostring(select(1,GetSpellInfo(_MindFreeze))))

                    if isKnown(_Asphyxiate) then
                        -- Asphyxiate
                        checkOp("Asphyxiate")
                        textOp(tostring(select(1,GetSpellInfo(_Asphyxiate))))
                    else
                        -- Strangulate
                        checkOp("Strangulate")
                        textOp(tostring(select(1,GetSpellInfo(_Strangulate))))
                    end

                    -- Dark Simulacrum
                    checkOp("Dark Simulacrum")
                    textOp(tostring(select(1,GetSpellInfo(_DarkSimulacrum))))

                    -- Interrupt Percentage
                    checkOp("Interrupt At")
                    boxOp("Interrupt At", 5, 95, 5, 0, "|cffFFFFFFCast Percent to Cast At")
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

                -- General Configs
                CreateGeneralsConfig()

                WrapsManager()
            end
        end
    end
end