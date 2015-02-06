if select(3,UnitClass("player")) == 7 then

  function RestorationConfig()
    local myClassColor = classColors[select(3,UnitClass("player"))].hex
    ClearConfig()
    --if not doneConfig then
    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,"|cff00EEFFRestoration |cffFF0000CodeMyLife")

    -- Wrapper
    CreateNewWrap(thisConfig,"--- |cffFF0011Buffs "..myClassColor.."---")

    -- Earthliving Weapon
    CreateNewCheck(thisConfig,"Earthliving Weapon")
    CreateNewText(thisConfig,"Earthliving Weapon")

    -- Water Shield
    CreateNewCheck(thisConfig,"Water Shield")
    CreateNewText(thisConfig,"Water Shield")


    -- Wrapper
    CreateNewWrap(thisConfig,"--- |cffFF0011Healing "..myClassColor.."---")

    CreateNewCheck(thisConfig,"Healing Wave","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFHealing Wave|cffFFBB00.",1)
    CreateNewBox(thisConfig,"Healing Wave",0,100,5,85,"|cffFFBB00Under what %HP to use |cffFFFFFFHealing Wave.")
    CreateNewText(thisConfig,"Healing Wave")

    CreateNewCheck(thisConfig,"Healing Surge","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFHealing Surge|cffFFBB00.",1)
    CreateNewBox(thisConfig,"Healing Surge",0,100,5,40,"|cffFFBB00Under what %HP to use |cffFFFFFFHealing Surge.")
    CreateNewText(thisConfig,"Healing Surge")

    CreateNewCheck(thisConfig,"Chain Heal","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFChain Heal|cffFFBB00.",1)
    CreateNewBox(thisConfig,"Chain Heal",0,100,5,70,"|cffFFBB00Under what %HP to use |cffFFFFFFChain Heal on 3 targets.")
    CreateNewText(thisConfig,"Chain Heal")



    -- Wrapper
    CreateNewWrap(thisConfig,"--- |cffFF0011Cooldowns "..myClassColor.."---")

    -- Ascendance
    CreateNewCheck(thisConfig,"Ascendance")
    CreateNewDrop(thisConfig,"Ascendance",1,"CD")
    CreateNewText(thisConfig,"Ascendance")

    -- Fire Elemental
    CreateNewCheck(thisConfig,"Fire Elemental")
    CreateNewDrop(thisConfig,"Fire Elemental",1,"CD")
    CreateNewText(thisConfig,"Fire Elemental")

    -- Stormlash
    CreateNewCheck(thisConfig,"Stormlash")
    CreateNewDrop(thisConfig,"Stormlash",1,"CD")
    CreateNewText(thisConfig,"Stormlash")

    -- Wrapper
    CreateNewWrap(thisConfig,"--- |cffFF0011DPS Tweaks "..myClassColor.."---")




    -- Wrapper
    CreateNewWrap(thisConfig,"--- |cffFF0011Defensive "..myClassColor.."---")

    -- Astral Shift
    CreateNewCheck(thisConfig,"Astral Shift")
    CreateNewBox(thisConfig,"Astral Shift",0,100,5,30,"|cffFFBB00Under what %HP to use |cffFFFFFFAstral Shit")
    CreateNewText(thisConfig,"Astral Shift")

    -- Healing Stream
    CreateNewCheck(thisConfig,"Healing Stream")
    CreateNewBox(thisConfig,"Healing Stream",0,100,5,50,"|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream")
    CreateNewText(thisConfig,"Healing Stream")

    -- Shamanistic Rage
    CreateNewCheck(thisConfig,"Shamanistic Rage")
    CreateNewBox(thisConfig,"Shamanistic Rage",0,100,5,70,"|cffFFBB00Under what %HP to use |cffFFFFFFShamanistic Rage")
    CreateNewText(thisConfig,"Shamanistic Rage")

    -- Wrapper
    CreateNewWrap(thisConfig,"--- |cffFF0011Utilities "..myClassColor.."---")

    -- Standard Interrupt
    CreateNewCheck(thisConfig,"Wind Shear")
    CreateNewBox(thisConfig,"Wind Shear",0,100,5,35 ,"|cffFFBB00Over what % of cast we want to |cffFFFFFFWind Shear.")
    CreateNewText(thisConfig,"Wind Shear")


    -- General Configs
    CreateGeneralsConfig()

    WrapsManager()
    --end
  end
end
