local _, br = ...
if br.lists == nil then br.lists = {} end

br.lists.racials = {
    -- Alliance
    Dwarf              = 20594,  -- Stoneform
    Gnome              = 20589,  -- Escape Artist
    Human              = 59752,  -- Every Man for Himself
    NightElf           = 58984,  -- Shadowmeld
    Worgen             = 68992,  -- Darkflight
    -- Horde
    Goblin             = 69041,  -- Rocket Barrage
    Tauren             = 20549,  -- War Stomp
    Troll              = 26297,  -- Berserking
    Scourge            = 7744,   -- Will of the Forsaken
    -- Both
    Pandaren           = 107079, -- Quaking Palm
    -- Allied Races
    HighmountainTauren = 255654, -- Bull Rush
    LightforgedDraenei = 255647, -- Light's Judgment
    Nightborne         = 260364, -- Arcane Pulse
    VoidElf            = 256948, -- Spatial Rift
    DarkIronDwarf      = 265221, -- Fireblood
    MagharOrc          = 274738, -- Ancestral Call
    ZandalariTroll     = 291944, -- Regeneratin'
    KulTiran           = 287712, -- Haymaker
    Vulpera            = 312411, -- Bag of Tricks
    Mechagnome         = 312924, -- Hyper Organic Light Originator
    -- Base lookup IDs for dynamically-resolved racials (Arcane Torrent, Gift of the Naaru, Blood Fury)
    _bloodElfBase      = 69179,
    _draeneiBase       = 28880,
    _orcBase           = 33702,
}

br.lists.spells = {}
br.lists.spells.Shared = {
        Shared = {
            abilities        = {
                autoAttack     = 6603,
                autoShot       = 75,
                giftOfTheNaaru = br.functions.spell:getRacial("Draenei"), --select(7, GetSpellInfo(GetSpellInfo(28880))),
                global         = 61304,
                heartOfAzeroth = 296208,  -- used for isActiveEssence icon comparison
                latentArcana   = 296971,
                lightsJudgment = 255647,
                quakingPalm    = 107079,
                racial         = br.functions.spell:getRacial(),
                shadowmeld     = 58984,
            },
            buffs            = {
                ancientHysteria                = 90355,
                battlePotionOfAgility          = 279152,
                battlePotionOfIntellect        = 279151,
                battlePotionOfStrength         = 279153,
                superiorBattlePotionOfAgility  = 298146,
                potionOfUnbridledFury          = 300714,
                blessingOfSacrifice            = 6940,
                -- greaterBlessingOfKings         = 203538,
                -- greaterBlessingOfWisdom        = 203539,
                battleScarredAugmentation      = 270058, -- BfA Augment Rune Buff
                blessingOfFreedom              = 1044,
                blessingOfProtection           = 1022,
                bloodLust                      = {
                    ancientHysteria     = 90355,
                    bloodlust           = 2825,
                    drumsOfRage         = 146555,
                    drumsOfTheMaelstrom = 256740,
                    drumsOfTheMountain  = 230935,
                    heroism             = 32182,
                    netherwinds         = 160452,
                    primalRage          = 264667,
                    timewarp            = 80353,
                },
                concordanceOfTheLegionfall     = 239042,
                defiledAugmentation            = 224001, -- Lightforged Augment Rune buff
                felFocus                       = 242551,
                flaskOfTenThousandScars        = 188035,
                flaskOfTheCountlessArmies      = 188034,
                flaskOfTheSeventhDemon         = 188033,
                flaskOfTheWhisperedPact        = 188031,
                flaskOfTheCurrents             = 251836,
                flaskOfEndlessFathoms          = 251837,
                flaskOfTheVastHorizon          = 251838,
                flaskOfTheUndertow             = 251839,
                flayedWingToxin                = 345546,
                forTheAlliance                 = 193863, -- BfA seasonal event buff
                forTheHorde                    = 193864, -- BfA seasonal event buff
                fruitfulMachinatins            = 242623, -- Absorb Shield from Deceiver's Grand Design
                mistcallerOcarina              = 330067, -- SL Trinket with group buff
                greaterFlaskOfEndlessFathoms   = 298837,
                greaterFlaskOfTheCurrents      = 298836,
                greaterFlaskOfTheUndertow      = 298841,
                greaterFlaskOfTheVastHorizon   = 298839,
                guidingHand                    = 242622, -- from The Deceiver's Grand Design
                heroism                        = 32182,
                ineffableTruth                 = 316801,
                latentArcana                   = 296962,
                netherwinds                    = 160452,
                norgannonsForesight            = 236373,
                overchargeMana                 = 299624,
                potionOfBurstingBlood          = 265514,
                potionOfFocusedResolve         = 298317,
                prolongedPower                 = 229206,
                queensDecreeUnstoppable        = 302417, -- M+ Beguiling affix: prevents interrupt
                racial                         = br.functions.spell:getRacial(),
                razorCoral                     = 303570, -- Crit Buff from Ashvane's Razor Coral
                sephuz1                        = 208051, -- the fulltime 10% movement, 2% haste buff
                sephuz2                        = 208052, -- the proc, 70% movement, 25% haste buff
                sephuzCooldown                 = 226262, -- CD (30 seconds) for the proc
                shadowmeld                     = 58984,
                symbolOfHope                   = 64901,
                timeWarp                       = 80353,
                whispersOfInsanity             = 176151,
                cracklingTourmaline            = 290372,
                saphireofBrilliance            = 290365,
                vigorEngaged                   = 287916,
                soulshape                      = 310143,
                soulIgnition                   = 345251,
                spectralFlaskOfPower           = 307185,
                elementalPotionOfPower         = 371024,
                elementalPotionOfUltimatePower = 371028,
                phialOfGlacialFury             = 373257,
                phialOfTepidVersatility        = 371172,
                icedPhialOfCorruptingRage      = 374000,
                domineeringArrogance           = 411661,

            },
            --TODO Add to API
            -- itemEnchantments = {
            --     --Dragonflight weapon Imbue's from inscription enchantments
            --     --Quality of aura should always be GOLD,SILVER,COPPER
            --     buzzingRune  = { 6514, 6513, 6512 },
            --     chirpingRune = { 6695, 6694, 6515 },
            --     howlingRune  = { 6518, 6517, 6516 },
            --     hissingRune  = { 6839, 6837, 6838 },
            -- },
            debuffs          = {
                bloodOfTheEnemy   = 297108,
                concentratedFlame = 295368,
                conductiveInk     = 302565,
                dampening         = 110310,
                eyeOfLeotheras    = 206649,
                necroticWound     = 209858,
                razorCoral        = 303568, --304877,
                repeatPerformance = 304409,
                shiverVenom       = 301624,
                temptation        = 234143,
                eyeOfCorruption   = 315161,
                grandDelusions    = 319695,
                graspingTendrils  = 315176,
                creepingMadness   = 313255,
                fixate            = 318078,
                thirstForBlood    = 266107,
                mightyBash        = 5211,
                defiledGround     = 314565,
                vileCorruption    = 314392,
                timeToFeed        = 162415, -- Oshir Iron Docks
                cascadingTerror   = 314478,
                bwonsamdiWrath    = 284663, -- Bwonsamdi's Wrath debuff
                quaking           = 240448, -- M+ Quaking affix
                reaping           = 288388, -- M+ Reaping affix
                promiseOfPower    = 282566, -- M+ Promise of Power affix
                arcaneBurst       = 303657, -- M+ Arcane Burst affix
            },
            essences         = {
            },
        },
    }
