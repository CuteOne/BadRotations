if select(3, UnitClass("player")) == 11 then
function GuardianConfig()
    if currentConfig ~= "Guardian chumii" then
        ClearConfig()
        thisConfig = 0
        -- Title
        CreateNewTitle(thisConfig,"Guardian |cffFF0000chumii")
        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"---------- Buffs ---------")

        -- Mark Of The Wild
        CreateNewCheck(thisConfig,"Mark Of The Wild")
        CreateNewText(thisConfig,"Mark Of The Wild")

		checkOp("Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFAuto Shapeshifting to best form for situation.|cffFFBB00.")
        textOp("Auto Shapeshifts")

        CreateNewText(thisConfig," ")
        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"--------- Healing -------")
        -- DoC Healing Touch
        CreateNewCheck(thisConfig, "DoCHT")
        CreateNewDrop(thisConfig, "DoCHT", 2, "Use DoC Procs Healing Touch on...", "|cffFFBB00Player", "|cff0077FFLowest")
        CreateNewText(thisConfig,"Healing Touch")

        -- Cenarion Ward
        CreateNewDrop(thisConfig, "CenWard", 2, "Use Cenarion Ward on...", "|cffFFBB00Player", "|cff0077FFLowest")
        CreateNewText(thisConfig,"Cenarion Ward")

        CreateNewText(thisConfig," ")
        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------- Cooldowns -----")

        CreateNewCheck(thisConfig,"useBerserk", "Check to use Berserk on CD (Boss/Dummy)")
        CreateNewText(thisConfig,"Berserk")

        CreateNewCheck(thisConfig,"useHotW", "Check to use Berserk on CD (Boss/Dummy)")
        CreateNewBox(thisConfig, "useHotW", 0, 100  , 5, 65, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHotW and start keeping Rejuvenation up")
        CreateNewText(thisConfig,"Heart of the Wild")

        CreateNewCheck(thisConfig,"useNVigil", "Check to use Berserk on CD (Boss/Dummy)")
        CreateNewText(thisConfig,"Nature's Vigil")

        CreateNewCheck(thisConfig,"useIncarnation", "Check to use Berserk on CD (Boss/Dummy)")
        CreateNewText(thisConfig,"Incarnation")

        CreateNewText(thisConfig," ")
        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------- Defensive ------")

        -- Healthstone
        CreateNewCheck(thisConfig,"Healthstone")
        CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
        CreateNewText(thisConfig,"Healthstone")
        -- Survival Instincts
        CreateNewCheck(thisConfig,"Survival Instincts")
        CreateNewBox(thisConfig, "Survival Instincts", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSurvival Instincts")
        CreateNewText(thisConfig,"Survival Instincts")
        -- Barkskin
        CreateNewCheck(thisConfig,"Barkskin")
        CreateNewBox(thisConfig, "Barkskin", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")
        CreateNewText(thisConfig,"Barkskin")
        -- Renewal
        CreateNewCheck(thisConfig,"Renewal")
        CreateNewBox(thisConfig, "Renewal", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRenewal")
        CreateNewText(thisConfig,"Renewal")

        CreateNewText(thisConfig," ")
        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"-------- Toggles --------")
        -- Pause Toggle
        CreateNewCheck(thisConfig,"Pause Toggle")
        CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle2")
        CreateNewText(thisConfig,"Pause Toggle")

        CreateNewText(thisConfig," ")
        -- Wrapper -----------------------------------------
        CreateNewWrap(thisConfig,"------ Utilities ------")

        -- Follow Tank
        CreateNewCheck(thisConfig,"Follow Tank")
        CreateNewBox(thisConfig, "Follow Tank", 10, 40  , 1, 25, "|cffFFBB00Range from focus...")
        CreateNewText(thisConfig,"Follow Tank")

        -- Zoo Master
        CreateNewCheck(thisConfig,"Zoo Master")
        CreateNewText(thisConfig,"Zoo Master")

        -- General Configs
        CreateGeneralsConfig()


        WrapsManager()
    end

end

end