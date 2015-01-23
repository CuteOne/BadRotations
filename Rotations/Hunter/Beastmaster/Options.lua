if select(3,UnitClass("player")) == 3 then


-- Config Panel
function BeastConfig()

    local silverColor = "|cffC0C0C0"
    local redColor = "|cffFF0011"
    local whiteColor = "|cffFFFFFF"
    local myClassColor = classColors[select(3,UnitClass("player"))].hex
    local function generateWrapper(wrapName)
        CreateNewWrap(thisConfig,whiteColor.."- "..redColor..wrapName..whiteColor.." -")
    end

    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,myClassColor.."Beastmaster"..redColor.." CodeMyLife")

    -- Wrapper
    generateWrapper("Pet Management")

    -- Auto Call Pet Toggle
    CreateNewCheck(thisConfig,"Auto Call Pet")
    CreateNewDrop(thisConfig,"Auto Call Pet",1,"|cffFFDD11Set to desired |cffFFFFFFPet to Whistle.","|cffFFDD11Pet 1","|cffFFDD11Pet 2","|cffFFDD11Pet 3","|cffFFDD11Pet 4","|cffFFDD11Pet 5")
    CreateNewText(thisConfig,"Auto Call Pet")

    -- Intimidation
    CreateNewCheck(thisConfig,"Intimidation")
    CreateNewText(thisConfig,"Intimidation")

    -- Mend Pet
    CreateNewCheck(thisConfig,"Mend Pet")
    CreateNewBox(thisConfig,"Mend Pet",0,100,5,35,"|cffFFDD11Under what Pet %HP to use |cffFFFFFFMend Pet")
    CreateNewText(thisConfig,"Mend Pet")

    -- Wrapper
    generateWrapper("Cooldowns")

    -- Bestial Wrath
    CreateNewCheck(thisConfig,"Bestial Wrath")
    CreateNewDrop(thisConfig,"Bestial Wrath",3,"CD")
    CreateNewText(thisConfig,"Bestial Wrath")

    -- Explosive Trap
    CreateNewCheck(thisConfig,"Explosive Trap")
    CreateNewDrop(thisConfig,"Explosive Trap",2,"|cffFFDD11Sets how you want |cffFFFFFFExplosive Trap |cffFFDD11to react.","|cffFF0000Never","|cffFFDD112 mobs","|cff00FF00Always")
    CreateNewText(thisConfig,"Explosive Trap")

    -- Focus Fire
    CreateNewCheck(thisConfig,"Focus Fire")
    CreateNewDrop(thisConfig,"Focus Fire",3,"CD")
    CreateNewText(thisConfig,"Focus Fire")

    if isKnown(Stampede) then
        -- Stampede
        CreateNewCheck(thisConfig,"Stampede")
        CreateNewDrop(thisConfig,"Stampede",2,"CD")
        CreateNewText(thisConfig,"Stampede")
    end

    -- Wrapper
    generateWrapper("Defensive")

    -- Deterrence
    CreateNewCheck(thisConfig,"Deterrence")
    CreateNewBox(thisConfig,"Deterrence",0,100,5,20,"|cffFFDD11Under what %HP to use |cffFFFFFFDeterrence")
    CreateNewText(thisConfig,"Deterrence")

    -- Feign Death
    CreateNewCheck(thisConfig,"Feign Death")
    CreateNewBox(thisConfig,"Feign Death",0,100,5,20,"|cffFFDD11Under what %HP to use |cffFFFFFFFeign Death")
    CreateNewText(thisConfig,"Feign Death")

    -- Misdirection
    CreateNewCheck(thisConfig,"Misdirection")
    CreateNewDrop(thisConfig,"Misdirection",2,"|cffFFDD11Sets how you want |cffFFFFFFMisdirection |cffFFDD11to react.","|cffFF0000Me.Aggro","|cffFFDD11Any.Aggro","|cffFFFF00Enforce","|cff00FF00Always")
    CreateNewText(thisConfig,"Misdirection")

    -- Wrapper
    generateWrapper("Utilities")

    -- Auto-Aspect Toggle
    CreateNewCheck(thisConfig,"Auto-Aspect")
    CreateNewBox(thisConfig,"Auto-Aspect",1,10,1,3,"|cffFFDD11How long do you want to run before enabling |cffFFFFFFAspect.")
    CreateNewText(thisConfig,"Auto-Aspect")

    CreateNewDrop(thisConfig,"Aspect",1,"|cffFFDD11Sets which Aspect to use.","|cffFF0000Cheetah","|cffFFDD11Pack")
    CreateNewText(thisConfig,"Aspect")

    -- Standard Interrupt
    CreateNewCheck(thisConfig,"Counter Shot")
    CreateNewBox(thisConfig,"Counter Shot",0,100,5,35,"|cffFFDD11Over what % of cast we want to |cffFFFFFFCounter Shot.")
    CreateNewText(thisConfig,"Counter Shot")


    -- General Configs
    CreateGeneralsConfig()

    WrapsManager()
end


end