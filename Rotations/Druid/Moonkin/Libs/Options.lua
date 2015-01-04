if select(3, UnitClass("player")) == 11 then
    function MoonkinConfig()
        if currentConfig ~= "Moonkin CodeMyLife" then
            ClearConfig()
            thisConfig = 0
            -- Title
            CreateNewTitle(thisConfig,"Moonkin |cffFF0000CodeMyLife")
            -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"---------- Buffs ---------")

            -- Mark Of The Wild
            CreateNewCheck(thisConfig,"Mark Of The Wild")
            CreateNewText(thisConfig,"Mark Of The Wild")

            -- Nature's Cure
            CreateNewCheck(thisConfig,"Nature's Cure")
            CreateNewDrop(thisConfig,"Nature's Cure", 1, "|cffFFBB00MMouse:|cffFFFFFFMouse / Match List. \n|cffFFBB00MRaid:|cffFFFFFFRaid / Match List. \n|cffFFBB00AMouse:|cffFFFFFFMouse / All. \n|cffFFBB00ARaid:|cffFFFFFFRaid / All.",
                "|cffFFDD11MMouse",
                "|cffFFDD11MRaid",
                "|cff00FF00AMouse",
                "|cff00FF00ARaid")
            CreateNewText(thisConfig,"Nature's Cure")

            -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"------ Cooldowns ------")

            -- Force Of Nature
            CreateNewCheck(thisConfig,"Force Of Nature")
            CreateNewText(thisConfig,"Force Of Nature")

            -- Natures Vigil
            CreateNewCheck(thisConfig,"Natures Vigil")
            CreateNewText(thisConfig,"Natures Vigil")

            -- Starfall
            CreateNewCheck(thisConfig,"Celestial Alignment")
            CreateNewText(thisConfig,"Celestial Alignment")

            -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"--------- Healing -------")

            -- Healing Touch Ns
            CreateNewCheck(thisConfig,"Healing Touch Ns")
            CreateNewBox(thisConfig, "Healing Touch Ns", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 with |cffFFFFFFNature Swiftness.")
            CreateNewText(thisConfig,"Healing Touch Ns")

            -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"------- Defensive ------")

            -- Healthstone
            CreateNewCheck(thisConfig,"Healthstone")
            CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
            CreateNewText(thisConfig,"Healthstone")

            -- Barkskin
            CreateNewCheck(thisConfig,"Barkskin")
            CreateNewBox(thisConfig, "Barkskin", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")
            CreateNewText(thisConfig,"Barkskin")

            -- Might of Ursoc
            CreateNewCheck(thisConfig,"Might of Ursoc")
            CreateNewBox(thisConfig, "Might of Ursoc", 0, 100  , 5, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFMight of Ursoc")
            CreateNewText(thisConfig,"Might of Ursoc")

            -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"-------- Toggles --------")

            -- Pause Toggle
            CreateNewCheck(thisConfig,"Pause Toggle")
            CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle2")
            CreateNewText(thisConfig,"Pause Toggle")

            -- Focus Toggle
            CreateNewCheck(thisConfig,"Focus Toggle")
            CreateNewDrop(thisConfig,"Focus Toggle", 2, "Toggle2")
            CreateNewText(thisConfig,"Focus Toggle")

            -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"------ Utilities ------")

            -- Follow Tank
            CreateNewCheck(thisConfig,"Follow Tank")
            CreateNewBox(thisConfig, "Follow Tank", 10, 40  , 1, 25, "|cffFFBB00Range from focus...")
            CreateNewText(thisConfig,"Follow Tank")

            -- General Configs
            CreateGeneralsConfig()


            WrapsManager()
        end
    end


end