local _, br = ...
if br.lists == nil then br.lists = {} end
function br.getHeirloomNeck()
    local necks = {
        eternalAmuletOfTheRedeemed  = 122663,
        eternalEmberfuryTalisman    = 122667,
        eternalHorizonChoker        = 122664,
        eternalTalismanOfEvasion    = 122662,
        eternalWillOfTheMartyr      = 122668,
        eternalWovenIvyNecklace     = 122666,
        manariTrainingAmulet        = 153130,
    }
    for _,v in pairs(necks) do
        if br.hasEquiped(v,2) then return v end
    end
    return 0
end
br.lists.items = {
    -- Dragon Isle Food buffs
    thousandboneTongueslicer        = 197786,
    deviouslyDeviledEggs            = 204072,
    
    -- Death Knight: Frost
    consortsColdCore                = 144293,
    koltirasNewfoundWill            = 132366,
    perseveranceOfTheEbonMartyr     = 132459,
    -- Death Knight: Shared
    coldHeart                       = 151796,
    -- Demonhunter: Shared
    felCrystalFragments             = 129210,
    inquisitorsMenacingEye          = 129192,
    soulOfTheSlayer                 = 151639,
    -- Druid: Shared
    ailuroPouncers                  = 137024,
    burningSeeds                    = 94604,
    chatoyantSignet                 = 137040,
    fandralsSeedPouch               = 122304,
    luffaWrappings                  = 137056,
    theWildshapersClutch            = 137094,
    -- Evoker: Devastation
    kharnalexTheFirstLight          = 195519,
	-- Mage: Shares
	manaGem                         = 36799,
    -- Monk: Shared
    drinkingHornCover               = 137097,
    hiddenMastersForbiddenTouch     = 137057,
    theEmperorsCapacitor            = 144239,
    -- Warrior: Shared
    archavonsHeavyHand              = 137060,
    kazzalaxFujiedasFury            = 137053,
    weightOfTheEarth                = 137077,
    -- All Shared
    -- Augment Runes
    battleScarredAugmentRune        = 160053, -- BfA augment rune item
    defiledAugmentRune              = 140587,
    lightforgedAugmentRune          = 153023, -- 7.3 augment rune item
    -- Flasks
    flaskOfTenThousandScars         = 127850,
    flaskOfTheCountlessArmies       = 127849,
    flaskOfTheSeventhDemon          = 127848,
    flaskOfTheWhisperedPact         = 127847,
    flaskOfTheCurrents              = 152638,
    flaskOfEndlessFathoms           = 152639,
    flaskOfTheVastHorizon           = 152640,
    flaskOfTheUndertow              = 152641,
    -- Flask-like Items
    oraliusWhisperingCrystal        = 118922,
    repurposedFelFocuser            = 147707,
    -- Greater Flasks
    greaterFlaskOfEndlessFathoms    = 168652,
    greaterFlaskOfTheCurrents       = 168651,
    greaterFlaskOfTheUndertow       = 168654,
    greaterFlaskOfTheVastHorizon    = 168653,
    -- Healing Items
    phialOfSerenity                  = 177278,
    -- Healthstones
    healthstone                     = 5512,
    legionHealthstone               = 129196,
    -- Heirlooms
    eternalAmuletOfTheRedeemed      = 122663,
    eternalEmberfuryTalisman        = 122667,
    eternalHorizonChoker            = 122664,
    eternalTalismanOfEvasion        = 122662,
    eternalWillOfTheMartyr          = 122668,
    eternalWovenIvyNecklace         = 122666,
    heirloomNeck                    = br.getHeirloomNeck(),
    manariTrainingAmulet            = 153130,
    touchOfTheVoid                  = 128318,
    -- Potions
    battlePotionOfAgility           = 163223,
    battlePotionOfIntellect         = 163222,
    battlePotionOfStrength          = 163224,
    potionOfBurstingBlood           = 152560,
    potionOfProlongedPower          = 142117,
    potionOfTheOldWar               = 127844,
    -- 8.2 Potions
    abyssalHealingPotion            = 169451,
    potionOfUnbridledFury           = 169299, -- DPS Potion
    potionOfEmpoweredProximity      = 168529, -- DPS Potion (AoE)
    potionOfFocusedResolve          = 168506, -- Crit Damage Potion
    potionOfWildMending             = 169300, -- Healer Potion
    superiorSteelskinPotion         = 168501, -- Armor Potion
    superiorBattlePotionOfAgility   = 168489,
    superiorBattlePotionOfIntellect = 168498,
    superiorBattlePotionOfStrength  = 168500,
    superiorBattlePotionOfStamina   = 168499,
    -- Rings
    ringOfCollapsingFutures         = 142173,
    -- Wrists
    hyperthreadWristWraps           = 168989,
    wrapsOfElectrostaticPotential   = 169069,
    --Trinkets
    ashvanesRazorCoral              = 169311,
    aquipotentNautilus              = 169305,
    azsharasFontOfPower             = 169314,
    bygoneBeeAlmanac                = 163936,
    convergenceOfFates              = 140806,
    darkmoonDeckPutrescence         = 173069,
    deceiversGrandDesign            = 147007,
    draughtOfSouls                  = 140808,
    dribblingInkpod                 = 169319,
    feloiledInfernalMachine         = 144482,
    galecallersBeak                 = 161379,
    galecallersBoon                 = 159614,
    grongsPrimalRage                = 165574,
    hornOfValor                     = 133642,
    jesHowler                       = 159627,
    lustrousGoldenPlumage           = 159617,
    pocketSizedComputationDevice    = 167555,
    rampingAmplitudeGigavoltEngine  = 165580,
    remoteGuidanceDevice            = 169769,
    rotcrustedVoodooDoll            = 159624,
    shiverVenomRelic                = 168905,
    specterOfBetrayal               = 151190,
    tidestormCodex                  = 165576,
    umbralMoonglaives               = 147012,
    vialOfCeaselessToxins           = 147011,
    vialOfStorms                    = 158224,
    vigorTrinket                    = 165572,
    visionOfDemise                  = 169307,
    hummingBlackDragonscale         = 174044,

    --weapons that are clickable
    neuralSynapseEnhancer           = 168973,
    -- Legendary 8.3 cloak
    shroudOfResolve                 = 169223,
    ----------- SL items below -----------
    --Trinkets
    -- Inscrutable Quantum Device
    inscrutableQuantumDevice        = 179350,
    -- Instructor's Divine Bell
    instructorsDivineBell           = 184842,
    -- Bottled Flayed Wing Toxin
    bottledFlayedWingToxin          = 178742,
    dreadfireVessel                 = 184030,
    -- Empyreal Ordnance
    empyrealOrdnance                = 180117,
    -- Everchill Brambles
    everchillBrambles               = 182452,
    -- Flame of Battle
    flameOfBattle                   = 181501,
    -- Gladiator's Insignia of Alacrity
    gladiatorsBadge                 = 175921,
    -- Gladiator's Badge of Ferocity
    gladiatorsBadgeAlacrity         = 175921,
    -- Glyph of Assimilation
    glyphOfAssimilation             = 184021,
    -- Macabre Sheet Music
    macabreSheetMusic               = 184024,
    -- Sunblood Amethyst
    sunbloodAmethyst                = 178826,
    -- Soulletting Ruby
    soulettingRuby                  = 178809,
    -- Soul Ignitor
    soulIgnitor                     = 184019,
    -- Tuft of Smoldering Plumage
    tuftOfSmolderingPlumage         = 184020,
    -- Wakener's Frond
    wakenersFrond                   = 181457,
    -- Wrath Stone
    wrathstone                      = 156000,
    -- Vial of Spectral
    vialOfSpectral                  = 178810,
    --Consumables
    potionOfSpectralAgility         = 171270,
    shadowCoreOil                   = 171285,
    spectralFlaskOfPower            = 171276,
    -- Music of Bastion
    ascendedFlute                   = 180064,
    benevolentGong                  = 179977,
    heavenlyDrum                    = 180062,
    kyrianBell                      = 179982,
    unearthlyChime                  = 180063,
    --- Dragonflight Items Below ---
    algetharPuzzleBox               = 193701,
    ashesOfTheEmbersoul             = 207167,
    elementalPotionOfUltimatePower  = 191383,
    mirrorOfFracturedTomorrows      = 207581,
    witherbarksBranch               = 109999,
    integratedPrimalFire            = 200868,
    lifeflameAmpoule                = 198451,

    --Dragonflight variable quality items
    --Gold, Silver, Copper
    --Fleeting first in order, i.e. Gold Fleeting, gold regular, silver fleeting, silver regular, etc.
    elementalPotionOfUltimatePowerQualities = {191914,191383,191913,191382,191912,191381},
    elementalPotionOfPowerQualities = {191907,191389,191906,191388,191905,191387},
    buzzingRuneQualities =  {194823, 194822, 194821},
    chirpingRuneQualities = {194826, 194825, 194824},
    howlingRuneQualities =  {194820, 194819, 194817},
    hissingRuneQualities =  {204973, 204972, 204971},
    phialOfGlacialFuryQualities={204660,191335,204659,191334,204658,191333},
    icedPhialOfCorruptingRageQualities={204654,191329,204653,191328,204652,191327},
    phialOfTepidVersatilityQualities = {204666,191341,204665,191340,204664,191339},

    


}

