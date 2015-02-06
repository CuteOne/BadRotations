if select(3,UnitClass("player")) == 7 then

  function ElementalConfig()
    local redColor = "|cffFF0011"
    local whiteColor = "|cffFFFFFF"
    local myClassColor = classColors[select(3,UnitClass("player"))].hex
    local function generateWrapper(wrapName)
      CreateNewWrap(thisConfig,whiteColor.."- "..redColor..wrapName..whiteColor.." -")
    end

    ClearConfig()
    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,"Elemental CodeMyLife")

    -- Wrapper
    generateWrapper("Buffs")

    -- Lightning Shield
    CreateNewCheck(thisConfig,"Lightning Shield")
    CreateNewText(thisConfig,"Lightning Shield")

    -- Wrapper
    generateWrapper("Cooldowns")

    -- Ancestral Swiftness
    if isKnown(_AncestralSwiftness) then
      CreateNewCheck(thisConfig,"Ancestral Swiftness")
      CreateNewDrop(thisConfig, "Ancestral Swiftness", 1,"CD")
      CreateNewText(thisConfig,"Ancestral Swiftness")
    end

    -- Ascendance
    CreateNewCheck(thisConfig,"Ascendance")
    CreateNewDrop(thisConfig, "Ascendance", 1,"CD")
    CreateNewText(thisConfig,"Ascendance")

    -- Elemental Mastery
    if isKnown(_ElementalMastery) then
      CreateNewCheck(thisConfig,"Elemental Mastery")
      CreateNewDrop(thisConfig,"Elemental Mastery",1,"CD")
      CreateNewText(thisConfig,"Elemental Mastery")
    end

    -- Fire Elemental
    CreateNewCheck(thisConfig,"Fire Elemental")
    CreateNewDrop(thisConfig,"Fire Elemental",1,"CD")
    CreateNewText(thisConfig,"Fire Elemental")

    -- Storm Elemental Totem
    if isKnown(_StormElementalTotem) then
      CreateNewCheck(thisConfig,"Storm Elemental Totem")
      CreateNewDrop(thisConfig,"Storm Elemental Totem",1,"CD")
      CreateNewText(thisConfig,"Storm Elemental Totem")
    end

    -- Wrapper
    generateWrapper("DPS Tweaks")

    -- EarthQuake
    CreateNewCheck(thisConfig,"EarthQuake")
    CreateNewDrop(thisConfig,"EarthQuake",1,"CD")
    CreateNewText(thisConfig,"EarthQuake")

    -- Thunderstorm
    CreateNewCheck(thisConfig,"Thunderstorm")
    CreateNewDrop(thisConfig,"Thunderstorm",1,"CD")
    CreateNewText(thisConfig,"Thunderstorm")

    -- Wrapper
    generateWrapper("Defensive")

    -- Astral Shift
    CreateNewCheck(thisConfig,"Astral Shift")
    CreateNewBox(thisConfig,"Astral Shift",0,100,5,30,"|cffFFBB00Under what %HP to use |cffFFFFFFAstral Shit")
    CreateNewText(thisConfig,"Astral Shift")

    -- Healing Stream
    CreateNewCheck(thisConfig,"Healing Stream")
    CreateNewBox(thisConfig,"Healing Stream",0,100,5,50,"|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream")
    CreateNewText(thisConfig,"Healing Stream")

    -- Healing Rain
    CreateNewCheck(thisConfig,"Healing Rain")
    CreateNewBox(thisConfig,"Healing Rain",0,100,5,50,"|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream")
    CreateNewText(thisConfig,"Healing Rain")

    -- Shamanistic Rage
    CreateNewCheck(thisConfig,"Shamanistic Rage")
    CreateNewBox(thisConfig,"Shamanistic Rage",0,100,5,70,"|cffFFBB00Under what %HP to use |cffFFFFFFShamanistic Rage")
    CreateNewText(thisConfig,"Shamanistic Rage")

    -- Wrapper
    generateWrapper("Utilities")

    -- Healing Surge Toggle
    CreateNewCheck(thisConfig,"Healing Surge Toggle")
    CreateNewDrop(thisConfig,"Healing Surge Toggle",4,"Toggle2")
    CreateNewText(thisConfig,"Healing Surge Toggle")

    -- Pause Toggle
    CreateNewCheck(thisConfig,"Pause Toggle")
    CreateNewDrop(thisConfig,"Pause Toggle",3,"Toggle2")
    CreateNewText(thisConfig,"Pause Toggle")

    -- Standard Interrupt
    CreateNewCheck(thisConfig,"Wind Shear")
    CreateNewBox(thisConfig,"Wind Shear",0,100,5,35,"|cffFFBB00Over what % of cast we want to |cffFFFFFFWind Shear.")
    CreateNewText(thisConfig,"Wind Shear")

    -- General Configs
    CreateGeneralsConfig()

    WrapsManager()
  end

end
