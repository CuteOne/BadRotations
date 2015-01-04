if select(3,UnitClass("player")) == 10 then

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
    function WindwalkerConfig()
        --if not doneConfig then
            thisConfig = 0
            -- Title
            titleOp("CuteOne Windwalker");
                    -- Spacer
            textOp(" ");
            wrapOp("--- General ---");

                -- Auto Looter
                checkOp("Auto Looter","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic corpse looting.")
                textOp("Auto Looter")

                -- Death Monk
                checkOp("Death Monk Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.");
                textOp("Death Monk Mode");

                -- Legacy of the White Tiger
                checkOp("Legacy of the White Tiger","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Legacy of the White Tiger usage. When enabled rotation will scan party/raid groups and cast if anyone in range in missing a similar buff.");
                textOp(tostring(select(1,GetSpellInfo(_LegacyOfTheWhiteTiger))));

                -- Dummy DPS Test
                checkOp("DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.");
                boxOp("DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
                textOp("DPS Testing");

            -- Spacer
            textOp(" ");
            wrapOp("--- Cooldowns ---");

                -- Agi Pot
                checkOp("Agi-Pot");
                textOp("Agi-Pot");

                -- Flask / Crystal
                checkOp("Flask / Crystal");
                textOp("Flask / Crystal");

                -- Racial
                checkOp("Racial");
                textOp("Racial");

                -- Xuen
                checkOp("Xuen");
                textOp(tostring(select(1,GetSpellInfo(_InvokeXuen))));

            -- Spacer
            textOp(" ");
            wrapOp("--- Defensive ---");

                -- Healthstone
                checkOp("Pot/Stoned");
                boxOp("Pot/Stoned", 0, 100, 5, 60, "|cffFFFFFFHealth Percent to Cast At");
                textOp("Pot/Stoned");

                --  Expel Harm
                checkOp("Expel Harm");
                boxOp("Expel Harm", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                textOp(tostring(select(1,GetSpellInfo(_ExpelHarm))));

                -- Surging Mist
                checkOp("Surging Mist");
                boxOp("Surging Mist", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                textOp(tostring(select(1,GetSpellInfo(_SurgingMist))));

                -- Touch of Karma
                checkOp("Touch of Karma");
                boxOp("Touch of Karma", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                textOp(tostring(select(1,GetSpellInfo(_TouchOfKarma))));

                -- Fortifying Brew
                checkOp("Fortifying Brew");
                boxOp("Fortifying Brew", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                textOp(tostring(select(1,GetSpellInfo(_FortifyingBrew))));

                -- Diffuse Magic/Dampen Harm
                checkOp("Diffuse/Dampen");
                boxOp("Diffuse/Dampen", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                if getTalent(5,2) then
                    textOp(tostring(select(1,GetSpellInfo(_DampenHarm))));
                else
                    textOp(tostring(select(1,GetSpellInfo(_DiffuseMagic))));
                end

                -- Zen Meditation
                checkOp("Zen Meditation");
                boxOp("Zen Meditation", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                textOp(tostring(select(1,GetSpellInfo(_ZenMeditation))));

                -- Nimble Brew
                checkOp("Nimble Brew");
                textOp(tostring(select(1,GetSpellInfo(_NimbleBrew))));

            -- Spacer --
            textOp(" ");
            wrapOp("--- Interrupts ---");
                --Quaking Palm
                checkOp("Quaking Palm")
                textOp(tostring(select(1,GetSpellInfo(_QuakingPalm))))

                -- Spear Hand Strike
                checkOp("Spear Hand Strike")
                textOp(tostring(select(1,GetSpellInfo(_SpearHandStrike))))

                -- Paralysis
                checkOp("Paralysis")
                textOp(tostring(select(1,GetSpellInfo(_Paralysis))))

                -- Leg Sweep
                checkOp("Leg Sweep")
                textOp(tostring(select(1,GetSpellInfo(_LegSweep))))

                -- Interrupt Percentage
                checkOp("Interrupt At");
                boxOp("Interrupt At", 5, 95, 5, 0, "|cffFFFFFFCast Percent to Cast At");
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

                -- SEF Toggle
                checkOp("SEF Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFSEF Toggle Key|cffFFBB00.");
                dropOp("SEF Mode", 5, "Toggle")
                textOp("Storm, Earth, and Fire");

                -- FSK Toggle
                checkOp("FSK Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFFSK Toggle Key|cffFFBB00.");
                dropOp("FSK Mode", 5, "Toggle")
                textOp("Flying Serpent Kick");

                -- Chi Builder Toggle
                checkOp("Builder Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFChi Builder Toggle Key|cffFFBB00.");
                dropOp("Builder Mode", 5, "Toggle")
                textOp("Chi Builder");

                -- Pause Toggle
                checkOp("Pause Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFPause Toggle Key - None Defaults to LeftAlt|cffFFBB00.")
                dropOp("Pause Mode", 6, "Toggle")
                textOp("Pause Mode")

            -- Spacer
            textOp(" ");

            -- General Configs
            CreateGeneralsConfig();

            WrapsManager();
        --end
    end

end
