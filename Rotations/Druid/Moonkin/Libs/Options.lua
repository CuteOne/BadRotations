if select(3, UnitClass("player")) == 11 then
    function MoonkinConfig()
        if currentConfig ~= "Moonkin CodeMyLife" then

            local myColor = "|cffC0C0C0"
            local redColor = "|cffFF0011"
            local whiteColor = "|cffFFFFFF"
            local myClassColor = classColors[select(3,UnitClass("player"))].hex
            local function generateWrapper(wrapName)
                CreateNewWrap(thisConfig,whiteColor.."- "..redColor..wrapName..whiteColor.." -")
            end


            ClearConfig()
            thisConfig = 0
            -- Title
            CreateNewTitle(thisConfig,"Moonkin |cffFF0000CodeMyLife")
            generateWrapper("Buffs")

            -- Mark Of The Wild
            CreateNewCheck(thisConfig,"Mark Of The Wild")
            CreateNewText(thisConfig,"Mark Of The Wild")

            generateWrapper("DPS")
            -- Multi-Moonfire
            CreateNewCheck(thisConfig,"Multi-Moonfire")
            CreateNewText(thisConfig,"Multi-Moonfire")

            generateWrapper("Cooldowns")

            -- Force Of Nature
            CreateNewCheck(thisConfig,"Force Of Nature")
            CreateNewText(thisConfig,"Force Of Nature")

            -- Natures Vigil
            CreateNewCheck(thisConfig,"Natures Vigil")
            CreateNewText(thisConfig,"Natures Vigil")

            -- Starfall
            CreateNewCheck(thisConfig,"Celestial Alignment")
            CreateNewText(thisConfig,"Celestial Alignment")

            generateWrapper("Healing")

            -- Healing Touch Ns
            CreateNewCheck(thisConfig,"Healing Touch Ns")
            CreateNewBox(thisConfig, "Healing Touch Ns", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 with |cffFFFFFFNature Swiftness.")
            CreateNewText(thisConfig,"Healing Touch Ns")

            -- Rejuvenation
            CreateNewCheck(thisConfig,"Rejuvenation")
            CreateNewBox(thisConfig, "Rejuvenation", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 with |cffFFFFFFNature Swiftness.")
            CreateNewText(thisConfig,"Rejuvenation")

            generateWrapper("Defensive")

            -- Healthstone
            CreateNewCheck(thisConfig,"Healthstone")
            CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
            CreateNewText(thisConfig,"Healthstone")

            -- Barkskin
            CreateNewCheck(thisConfig,"Barkskin")
            CreateNewBox(thisConfig, "Barkskin", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")
            CreateNewText(thisConfig,"Barkskin")

            generateWrapper("Toggles")

            -- Pause Toggle
            CreateNewCheck(thisConfig,"Pause Toggle")
            CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle2")
            CreateNewText(thisConfig,"Pause Toggle")

            -- Focus Toggle
            CreateNewCheck(thisConfig,"Focus Toggle")
            CreateNewDrop(thisConfig,"Focus Toggle", 2, "Toggle2")
            CreateNewText(thisConfig,"Focus Toggle")

            -- General Configs
            CreateGeneralsConfig()


            WrapsManager()
        end
    end


end