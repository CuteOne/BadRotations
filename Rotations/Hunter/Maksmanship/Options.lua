if select(3,UnitClass("player")) == 3 then

-- Config Panel
function MarkConfig()
    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,"Mavmins Marksmanship")

    -- Wrapper
    CreateNewWrap(thisConfig,"<-Cooldowns->")

    -- Potions
    CreateNewCheck(thisConfig,"Potions","Check if you want to use Potions automatically")
    CreateNewText(thisConfig,"Potions")

    -- Racials
    CreateNewCheck(thisConfig,"Racials","Check if you want to use Bloodfury/Berserking/Arcane Torrent automatically")
    CreateNewText(thisConfig,"Racials")

    -- Rapid Fire
    CreateNewCheck(thisConfig,"Rapid Fire","Check if you want to use Rapid Fire automatically")
    CreateNewText(thisConfig,"Rapid Fire")

    -- Dire Beast
    CreateNewCheck(thisConfig,"Dire Beast","Check if you want to use Dire Beast automatically")
    CreateNewText(thisConfig,"Dire Beast")

    -- A Murder of Crows
    CreateNewCheck(thisConfig,"A Murder of Crows","Check if you want to use A Murder of Crows automatically")
    CreateNewText(thisConfig,"A Murder of Crows")

    -- Stampede
    CreateNewCheck(thisConfig,"Stampede","Check if you want to use Stampede automatically")
    CreateNewText(thisConfig,"Stampede")

    -- Glaive Toss
    CreateNewCheck(thisConfig,"Glaive Toss","Check if you want to use Glaive Toss automatically")
    CreateNewText(thisConfig,"Glaive Toss")

    -- Power Shot
    CreateNewCheck(thisConfig,"Power Shot","Check if you want to use Power Shot automatically")
    CreateNewText(thisConfig,"Power Shot")

    -- Barrage
    CreateNewCheck(thisConfig,"Barrage","Check if you want to use Barrage automatically")
    CreateNewText(thisConfig,"Barrage")

    -- Wrapper
    CreateNewWrap(thisConfig,"<-Defensive->")

    -- Healthstone
    CreateNewCheck(thisConfig,"Healthstone/Potion")
    CreateNewBox(thisConfig,"Healthstone/Potion",0,100,5,20,"|cffFFDD11At what %HP to use |cffFFFFFFHealthstone")
    CreateNewText(thisConfig,"Healthstone/Potion")

    -- Misdirection
    CreateNewCheck(thisConfig,"Misdirection")
    CreateNewDrop(thisConfig,"Misdirection",2,"|cffFFDD11Sets target for |cffFFFFFFMisdirection |cffFFDD11on Aggro","|cffFFDD11Pet","|cffFFFF00Focus")
    CreateNewText(thisConfig,"Misdirection")

    -- Feign Death
    CreateNewCheck(thisConfig,"Feign Death")
    CreateNewBox(thisConfig,"Feign Death",0,100,5,20,"|cffFFDD11At what %HP to use |cffFFFFFFFeign Death")
    CreateNewText(thisConfig,"Feign Death")

    -- Deterrence
    CreateNewCheck(thisConfig,"Deterrence")
    CreateNewBox(thisConfig,"Deterrence",0,100,5,20,"|cffFFDD11At what %HP to use |cffFFFFFFDeterrence")
    CreateNewText(thisConfig,"Deterrence")

    -- Disengage
    CreateNewCheck(thisConfig,"Disengage")
    CreateNewBox(thisConfig,"Disengage",0,100,5,20,"|cffFFDD11Auto use |cffFFFFFFDeterrence |cffFFDD11at set range")
    CreateNewText(thisConfig,"Disengage")

    -- Wrapper
    CreateNewWrap(thisConfig,"<-Pet->")

    -- Auto Call Pet Toggle
    CreateNewCheck(thisConfig,"Auto Summon")
    CreateNewDrop(thisConfig,"Auto Summon",1,"|cffFFDD11Set to desired |cffFFFFFFPet to Whistle.","|cffFFDD11Pet 1","|cffFFDD11Pet 2","|cffFFDD11Pet 3","|cffFFDD11Pet 4","|cffFFDD11Pet 5")
    CreateNewText(thisConfig,"Auto Summon")

    -- Mend Pet
    CreateNewCheck(thisConfig,"Mend Pet")
    CreateNewBox(thisConfig,"Mend Pet",0,100,5,75,"|cffFFDD11Under what Pet %HP to use |cffFFFFFFMend Pet")
    CreateNewText(thisConfig,"Mend Pet")

    -- Intimidation
    CreateNewCheck(thisConfig,"Intimidation")
    CreateNewDrop(thisConfig,"Intimidation",2,"|cffFFDD11Sets how you want |cffFFFFFFIntimidation |cffFFDD11to react.","|cffFF0000Aggro","|cff00FF00Interrupt","|cffFFDD11Both")
    CreateNewText(thisConfig,"Intimidation")

    -- Wrapper
    CreateNewWrap(thisConfig,"<-Other->")

    CreateNewCheck(thisConfig,"Trap Launcher","Check if you want to use Trap Launcher")
    CreateNewText(thisConfig,"Trap Launcher")

    -- Explosive Trap
    CreateNewCheck(thisConfig,"Explosive Trap","Check if you want to use Explosive Trap in rotation")
    CreateNewText(thisConfig,"Explosive Trap")

    -- Exotic Munitions
    CreateNewCheck(thisConfig,"Exotic Munitions")
    CreateNewDrop(thisConfig,"Exotic Munitions",1,"|cffFFDD11Set which ammo to use","|cffFFDD11Incendiary","|cffFFDD11Poison","|cffFFDD11Frozen")
    CreateNewText(thisConfig,"Exotic Munitions")

    -- Auto-Aspect Toggle
    CreateNewCheck(thisConfig,"Auto-Cheetah")
    CreateNewText(thisConfig,"Auto-Cheetah")

    -- Standard Interrupt
    CreateNewCheck(thisConfig,"Counter Shot")
    CreateNewBox(thisConfig,"Counter Shot",0,100,5,35,"|cffFFDD11Over what % of cast we want to |cffFFFFFFCounter Shot.")
    CreateNewText(thisConfig,"Counter Shot")


    -- General Configs
    CreateGeneralsConfig()

    WrapsManager()
end

end