if select(3,UnitClass("player")) == 2 then
  function PaladinRetOptions()

    local myColor = "|cffC0C0C0"
    local redColor = "|cffFF0011"
    local whiteColor = "|cffFFFFFF"
    local myClassColor = classColors[select(3,UnitClass("player"))].hex
    local function generateWrapper(wrapName)
      CreateNewWrap(thisConfig,whiteColor.."- "..redColor..wrapName..whiteColor.." -")
    end

    ClearConfig()
    -- Title
    CreateNewTitle(thisConfig,"Retribution Gabbz & CML")
    ret:baseOptions()

    -- Wrapper
    generateWrapper("Buffs")

    -- Blessing
    CreateNewCheck(thisConfig,"Blessings")
    CreateNewDrop(thisConfig,"Blessings",1,"|cffFFFFFFWhich blessing do you want to maintain on raid","|cff0374FEKings","|cffFFBC40Might","|cff00FF0DAuto")
    CreateNewText(thisConfig,"Blessings")

    -- Wrapper
    generateWrapper("Coooldowns")

    -- Avenging Wrath
    CreateNewCheck(thisConfig,"Avenging Wrath")
    CreateNewDrop(thisConfig,"Avenging Wrath",1,"CD")
    CreateNewText(thisConfig,"Avenging Wrath")

    if isKnown(_LightsHammer) then
      -- Light's Hammer
      CreateNewCheck(thisConfig,"Light's Hammer")
      CreateNewDrop(thisConfig,"Light's Hammer",1,"CD")
      CreateNewText(thisConfig,"Light's Hammer")
    elseif isKnown(_ExecutionSentence) then
      -- Execution sentence
      CreateNewCheck(thisConfig,"Execution sentence")
      CreateNewDrop(thisConfig,"Execution sentence",1,"CD")
      CreateNewText(thisConfig,"Execution sentence")
    elseif isKnown(_HolyPrism) then
      -- Execution sentence
      CreateNewCheck(thisConfig,"Holy Prism")
      CreateNewDrop(thisConfig,"Holy Prism",1,"CD")
      CreateNewText(thisConfig,"Holy Prism")
    end

    -- Holy Avenger
    if isKnown(_HolyAvenger) then
      CreateNewCheck(thisConfig,"Holy Avenger")
      CreateNewDrop(thisConfig,"Holy Avenger",1,"CD")
      CreateNewText(thisConfig,"Holy Avenger")
    end

    -- Seraphim
    if isKnown(_Seraphim) then
      CreateNewCheck(thisConfig,"Seraphim")
      CreateNewDrop(thisConfig,"Seraphim",1,"CD")
      CreateNewText(thisConfig,"Seraphim")
    end

    -- Wrapper
    generateWrapper("Defensive")

    -- Divine Protection
    CreateNewCheck(thisConfig,"Divine Protection","Divine Protection",1)
    CreateNewBox(thisConfig,"Divine Protection",0,100,1,75,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Protection")
    CreateNewText(thisConfig,"Divine Protection")

    -- Divine Shield
    CreateNewCheck(thisConfig,"Divine Shield",1)
    CreateNewBox(thisConfig,"Divine Shield",0,100,1,10,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Shield")
    CreateNewText(thisConfig,"Divine Shield")

    -- Wrapper
    generateWrapper("Healing")



    if isKnown(_HandOfPurity) == true then
      CreateNewCheck(thisConfig,"Hand of Purity")
      CreateNewBox(thisConfig,"Hand of Purity",0,100,1,50,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand of Purity")
      CreateNewText(thisConfig,"Hand of Purity")
    end
    -- Hand of Sacrifice
    CreateNewCheck(thisConfig,"Hand Of Sacrifice")
    CreateNewBox(thisConfig,"Hand Of Sacrifice",0,100,1,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand Of Sacrifice")
    CreateNewText(thisConfig,"Hand Of Sacrifice")

    -- LoH options
    generalPaladinOptions()

    -- Tier 3 talents
    if isKnown(_SacredShield) then
      CreateNewCheck(thisConfig,"Sacred Shield")
      CreateNewBox(thisConfig,"Sacred Shield",0,100,5,95,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSacred Shield")
      CreateNewText(thisConfig,"Sacred Shield")
    elseif isKnown(_SelflessHealer) then
      CreateNewCheck(thisConfig,"Selfless Healer")
      CreateNewBox(thisConfig,"Selfless Healer",0,100,5,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSelfless Healer on Raid")
      CreateNewText(thisConfig,"Selfless Healer")
    else
      CreateNewCheck(thisConfig,"Self Flame")
      CreateNewBox(thisConfig,"Self Flame",0,100,5,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Self")
      CreateNewText(thisConfig,"Self Flame")
      CreateNewCheck(thisConfig,"Eternal Flame")
      CreateNewBox(thisConfig,"Eternal Flame",0,100,5,20,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Raid")
      CreateNewText(thisConfig,"Eternal Flame")
    end

    if isKnown(_SelflessHealer) or isKnown(_SacredShield) then
      CreateNewCheck(thisConfig,"Self Glory")
      CreateNewBox(thisConfig,"Self Glory",0,100,5,70,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Self")
      CreateNewText(thisConfig,"Self Glory")
      CreateNewCheck(thisConfig,"Word Of Glory")
      CreateNewBox(thisConfig,"Word Of Glory",0,100,5,70,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWord Of Glory on Raid")
      CreateNewText(thisConfig,"Word Of Glory")
    end

    -- Wrapper
    generateWrapper("Utilities")

    -- Rebuke
    CreateNewCheck(thisConfig,"Rebuke",redColor.."Check" ..whiteColor.."to use "..redColor.."Rebuke"..whiteColor..".",1)
    CreateNewBox(thisConfig,"Rebuke",0,100,5,35,redColor.."Over what % of cast"..whiteColor.." we want to use "..redColor.."Rebuke"..whiteColor..".")
    CreateNewText(thisConfig,"Rebuke")

    -- General Configs
    CreateGeneralsConfig()
    WrapsManager()
  end
end
