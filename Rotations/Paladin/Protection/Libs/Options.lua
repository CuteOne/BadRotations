if select(3,UnitClass("player")) == 2 then

  function PaladinProtOptions()
    ClearConfig()

    local myColor = "|cffC0C0C0"
    local redColor = "|cffFF0011"
    local whiteColor = "|cffFFFFFF"
    local myClassColor = classColors[select(3,UnitClass("player"))].hex
    local function generateWrapper(wrapName)
      CreateNewWrap(thisConfig,whiteColor.."- "..redColor..wrapName..whiteColor.." -")
    end

    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,"Protection Gabbz")

    -- Wrapper
    generateWrapper("Buffs")

    -- Blessing
    CreateNewCheck(thisConfig,"Blessings")
    CreateNewDrop(thisConfig,"Blessings",1,"|cffFFFFFFWhich blessing do you want to maintain on raid","|cff0374FEKings","|cffFFBC40Might","|cff00FF0DAuto")
    CreateNewText(thisConfig,"Blessings")

    -- Righteous Fury
    CreateNewCheck(thisConfig,"Righteous Fury")
    CreateNewText(thisConfig,"Righteous Fury")

    -- Wrapper
    generateWrapper("Rotation Management")

    -- Light's Hammer
    if isKnown(114158) then
      CreateNewCheck(thisConfig,"Light's Hammer",nil,1)
      CreateNewDrop(thisConfig,"Light's Hammer",2,"CD")
      CreateNewText(thisConfig,"Light's Hammer")
    end
    -- Execution Sentence
    if isKnown(114157) then
      CreateNewCheck(thisConfig,"Execution Sentence",nil,1)
      CreateNewDrop(thisConfig,"Execution Sentence",2,"CD")
      CreateNewText(thisConfig,"Execution Sentence")
    end
    -- Holy Avenger
    if isKnown(105809) then
      CreateNewCheck(thisConfig,"Holy Avenger",nil,1)
      CreateNewDrop(thisConfig,"Holy Avenger",2,"CD")
      CreateNewText(thisConfig,"Holy Avenger")
    end
    -- Seraphim
    if isKnown(152262) then
      CreateNewCheck(thisConfig,"Seraphim",nil,1)
      CreateNewDrop(thisConfig,"Seraphim",2,"CD")
      CreateNewText(thisConfig,"Seraphim")
    end

    -- Max DPS HP
    CreateNewBox(thisConfig,"Max DPS HP",51,100,1,70,"|cffFFBB00Over what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFMaximum DPS Rotation")
    CreateNewText(thisConfig,"Max DPS HP")
    -- Max Survival HP
    CreateNewBox(thisConfig,"Max Survival HP",0,50,1,30,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFMaximum Survival Rotation")
    CreateNewText(thisConfig,"Max Survival HP")

    -- Wrapper
    generateWrapper("Healing")

    -- Word Of Glory Party
    CreateNewCheck(thisConfig,"Word Of Glory On Self","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFWord of Glory|cffFFBB00 on self.",1)
    CreateNewBox(thisConfig,"Word Of Glory On Self",0,100,1,30,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to heal self with \n|cffFFFFFFWords Of Glory")
    CreateNewText(thisConfig,"Word Of Glory On Self")

    -- LoH options
    generalPaladinOptions()

    -- Todo: reimplement later
    --CreateNewCheck(thisConfig,"Hand Of Freedom","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFHand Of Freedom|cffFFBB00.",1)
    --CreateNewDrop(thisConfig,"Hand Of Freedom",1,"Under which conditions do we use Hand of Freedom on self.","|cffFFFFFFWhitelist","|cff00FF00All")
    --CreateNewText(thisConfig,"Hand Of Freedom")

    generateWrapper("Defensive")

    CreateNewCheck(thisConfig,"Divine Protection","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFDivine Protection.",1)
    CreateNewBox(thisConfig,"Divine Protection",0,100,1,65,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Protection")
    CreateNewText(thisConfig,"Divine Protection")

    CreateNewCheck(thisConfig,"Ardent Defender","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFArdent Defender.",1)
    CreateNewBox(thisConfig,"Ardent Defender",0,100,1,20,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFArdent Defender")
    CreateNewText(thisConfig,"Ardent Defender")

    CreateNewCheck(thisConfig,"Guardian Of Ancient Kings","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFGuardian Of Ancients Kings.",1)
    CreateNewBox(thisConfig,"Guardian Of Ancient Kings",0,100,1,30,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFGuardian Of Ancients Kings")
    CreateNewText(thisConfig,"Guardian Of Ancient Kings")

    -- Wrapper Interrupt
    generateWrapper("Interrupts")

    CreateNewCheck(thisConfig,"Rebuke","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFRebuke|cffFFBB00.",1)
    CreateNewBox(thisConfig,"Rebuke",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFRebuke.")
    CreateNewText(thisConfig,"Rebuke")

    CreateNewCheck(thisConfig,"Avengers Shield Interrupt","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFusing AS as Interrupt|cffFFBB00.",1)
    CreateNewBox(thisConfig,"Avengers Shield Interrupt",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFAS as interrupt.")
    CreateNewText(thisConfig,"Avengers Shield Interrupt")

    if isKnown(28730) then
      CreateNewCheck(thisConfig,"Arcane Torrent Interrupt","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFusing Arcane Torrent as Interrupt|cffFFBB00.",1)
      CreateNewBox(thisConfig,"Arcane Torrent Interrupt",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFArcane Torrent as interrupt.")
      CreateNewText(thisConfig,"Arcane Torrent Interrupt")
    end

    --CreateNewCheck(thisConfig,"Gabbz Debug","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFDebugging|cffFFBB00.",1)
    --CreateNewText(thisConfig,"Gabbz Debug")
    -- General Configs
    CreateGeneralsConfig()

    WrapsManager()
  end
end
