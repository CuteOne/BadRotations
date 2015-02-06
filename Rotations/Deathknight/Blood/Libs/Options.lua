if select(3,UnitClass("player")) == 6 then

  function BloodOptions()
    local redColor = "|cffFF0011"
    local whiteColor = "|cffFFFFFF"
    local myClassColor = classColors[select(3,UnitClass("player"))].hex
    local function generateWrapper(wrapName)
      CreateNewWrap(thisConfig,whiteColor.."- "..redColor..wrapName..whiteColor.." -")
    end
    ClearConfig()

    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,myClassColor.."Blood "..whiteColor.."CodeMyLife")

    -- Wrapper
    generateWrapper("Buffs")

    -- Horn of Winter
    if isKnown(_HornOfWinter) then
      CreateNewCheck(thisConfig,"Horn of Winter")
      CreateNewText(thisConfig,"Horn of Winter")
    end

    -- Blood Presence
    if isKnown(_BloodPresence) then
      CreateNewCheck(thisConfig,"Presence")
      CreateNewDrop(thisConfig,"Presence",1,"Choose Presence to use.","|cffFF0000Blood","|cff00EEFFFrost")
      CreateNewText(thisConfig,"Presence")
    else
      CreateNewCheck(thisConfig,"Frost Presence")
      CreateNewText(thisConfig,"Frost Presence")
    end
    -- Bone Shield
    if isKnown(_BoneShield) then
      CreateNewCheck(thisConfig,"Bone Shield")
      CreateNewText(thisConfig,"Bone Shield")
    end

    -- Wrapper
    generateWrapper("Cooldowns")

    -- Raise Dead
    CreateNewCheck(thisConfig,"Raise Dead")
    CreateNewDrop(thisConfig,"Raise Dead",1,"CD")
    CreateNewText(thisConfig,"Raise Dead")

    -- Wrapper
    generateWrapper("DPS Tweaks")

    -- Death And Decay
    if isKnown(_DeathAndDecay) then
      CreateNewCheck(thisConfig,"Death And Decay")
      CreateNewDrop(thisConfig,"Death And Decay",1,"CD")
      CreateNewText(thisConfig,"Death And Decay")
    end

    -- Wrapper
    generateWrapper("Defensive")

    -- Anti-Magic Shell
    if isKnown(_AntiMagicShell) then
      CreateNewCheck(thisConfig,"Anti-Magic Shell")
      CreateNewBox(thisConfig,"Anti-Magic Shell",0,100,5,70,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFAnti-Magic Shell")
      CreateNewText(thisConfig,"Anti-Magic Shell")
    end

    -- Conversion
    if isKnown(_Conversion) then
      CreateNewCheck(thisConfig,"Conversion")
      CreateNewBox(thisConfig,"Conversion",0,100,5,30,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFConversion")
      CreateNewText(thisConfig,"Conversion")
    end

    -- Dancing Rune Weapon
    if isKnown(_DancingRuneWeapon) then
      CreateNewCheck(thisConfig,"Dancing Rune Weapon")
      CreateNewBox(thisConfig,"Dancing Rune Weapon",0,100,5,90,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDancing Rune Weapon")
      CreateNewText(thisConfig,"Dancing Rune Weapon")
    end

    -- Empower Rune Weapon
    if isKnown(_EmpowerRuneWeapon) then
      CreateNewCheck(thisConfig,"Empower Rune Weapon")
      CreateNewBox(thisConfig,"Empower Rune Weapon",0,100,5,70,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEmpower Rune Weapon")
      CreateNewText(thisConfig,"Empower Rune Weapon")
    end

    -- Icebound Fortitude
    if isKnown(_IceboundFortitude) then
      CreateNewCheck(thisConfig,"Icebound Fortitude")
      CreateNewBox(thisConfig,"Icebound Fortitude",0,100,5,30,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFIcebound Fortitude")
      CreateNewText(thisConfig,"Icebound Fortitude")
    end

    -- Rune Tap
    if isKnown(_RuneTap) then
      CreateNewCheck(thisConfig,"Rune Tap")
      CreateNewBox(thisConfig,"Rune Tap",0,100,5,50,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFRune Tap")
      CreateNewText(thisConfig,"Rune Tap")
    end

    -- Vampiric Blood
    if isKnown(_VampiricBlood) then
      CreateNewCheck(thisConfig,"Vampiric Blood")
      CreateNewBox(thisConfig,"Vampiric Blood",0,100,5,50,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFVampiric Blood")
      CreateNewText(thisConfig,"Vampiric Blood")
    end

    -- Wrapper
    generateWrapper("Healing")

    -- Death Siphon
    CreateNewCheck(thisConfig,"Death Siphon")
    CreateNewBox(thisConfig,"Death Siphon",0,100,5,30,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDeath Siphon")
    CreateNewText(thisConfig,"Death Siphon")


    -- Wrapper
    generateWrapper("Utilities")

    -- Mind Freeze
    if isKnown(_MindFreeze) then
      CreateNewCheck(thisConfig,"Mind Freeze")
      CreateNewBox(thisConfig,"Mind Freeze",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFMind Freeze.")
      CreateNewText(thisConfig,"Mind Freeze")
    end

    if isKnown(_Strangulate) then
      CreateNewCheck(thisConfig,"Strangulate")
      CreateNewBox(thisConfig,"Strangulate",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFStangulate.")
      CreateNewText(thisConfig,"Strangulate")
    end
    -- General Configs
    CreateGeneralsConfig()

    WrapsManager()
  end

end
