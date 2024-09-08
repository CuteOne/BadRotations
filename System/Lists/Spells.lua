local _, br = ...
local function flipRace()
    local race = select(2, br._G.UnitRace("player"))
    local class = select(3, br._G.UnitClass("player"))
    if br.UnitBuffID("player", 193863) then
        if race == "Orc" then
            return "Dwarf"
        elseif race == "Undead" then
            return "Human"
        elseif race == "Troll" then
            if class == 7 then
                return "Draenei"
            elseif class == 9 then
                return "Human"
            else
                return "NightElf"
            end
        elseif race == "Tauren" then
            if class == 11 then
                return "NightElf"
            else
                return "Draenei"
            end
        elseif race == "BloodElf" then
            if class == 12 then
                return "NightElf"
            else
                return "Human"
            end
        elseif race == "Goblin" then
            if class == 3 or class == 7 then
                return "Dwarf"
            else
                return "Gnome"
            end
        elseif race == "Pandaren" then
            return "Pandaren"
        elseif race == "HighmountainTauren" then
            if class == 11 then
                return "NightElf"
            else
                return "Draenei"
            end
        elseif race == "Nightborne" then
            if class == 9 then
                return "Human"
            else
                return "NightElf"
            end
        elseif race == "MagharOrc" then
            return "DarkIronDwarf"
        end
    elseif br.UnitBuffID("player", 193864) then
        if race == "Worgen" then
            return "Troll"
        elseif race == "DarkIronDwarf" then
            return "MagharOrc"
        elseif race == "Human" then
            if class == 2 then
                return "BloodElf"
            else
                return "Undead"
            end
        elseif race == "NightElf" then
            if class == 12 then
                return "BloodElf"
            else
                return "Troll"
            end
        elseif race == "Dwarf" then
            if class == 2 then
                return "Tauren"
            elseif class == 5 then
                return "Undead"
            else
                return "Orc"
            end
        elseif race == "Draenei" then
            if class == 8 then
                return "Orc"
            else
                return "Tauren"
            end
        elseif race == "Pandaren" then
            return "Pandaren"
        elseif race == "Gnome" then
            if class == 10 then
                return "BloodElf"
            else
                return "Goblin"
            end
        elseif race == "VoidElf" then
            if class == 3 or class == 5 or class == 1 then
                return "BloodElf"
            else
                return "Troll"
            end
        elseif race == "LightforgedDraenei" then
            if class == 8 then
                return "Orc"
            else
                return "Tauren"
            end
        end
    end
end

function br.getRacial(thisRace)
    local forTheAlliance = br.UnitBuffID("player", 193863) or false
    local forTheHorde = br.UnitBuffID("player", 193864) or false
    local race = select(2, br._G.UnitRace("player"))
    if forTheAlliance or forTheHorde then
        race = flipRace()
    end
    local BloodElfRacial
    local DraeneiRacial
    local OrcRacial

    if race == "BloodElf" or race == thisRace then
        BloodElfRacial = select(7, br._G.GetSpellInfo(br._G.GetSpellInfo(69179)))
    end
    if race == "Draenei" or race == thisRace then
        DraeneiRacial = select(7, br._G.GetSpellInfo(br._G.GetSpellInfo(28880)))
    end
    if race == "Orc" or race == thisRace then
        OrcRacial = select(7, br._G.GetSpellInfo(br._G.GetSpellInfo(33702)))
    end
    local racialSpells = {
        -- Alliance
        Dwarf              = 20594,          -- Stoneform
        Gnome              = 20589,          -- Escape Artist
        Draenei            = DraeneiRacial,  -- Gift of the Naaru
        Human              = 59752,          -- Every Man for Himself
        NightElf           = 58984,          -- Shadowmeld
        Worgen             = 68992,          -- Darkflight
        -- Horde
        BloodElf           = BloodElfRacial, -- Arcane Torrent
        Goblin             = 69041,          -- Rocket Barrage
        Orc                = OrcRacial,      -- Blood Fury
        Tauren             = 20549,          -- War Stomp
        Troll              = 26297,          -- Berserking
        Scourge            = 7744,           -- Will of the Forsaken
        -- Both
        Pandaren           = 107079,         -- Quaking Palm
        -- Allied Races
        HighmountainTauren = 255654,         -- Bull Rush
        LightforgedDraenei = 255647,         -- Light's Judgment
        Nightborne         = 260364,         -- Arcane Pulse
        VoidElf            = 256948,         -- Spatial Rift
        DarkIronDwarf      = 265221,         -- Fireblood
        MagharOrc          = 274738,         -- Ancestral Call
        ZandalariTroll     = 291944,         -- Regeneratin'
        KulTiran           = 287712,         -- Haymaker
        Vulpera            = 312411,         -- Bag of Tricks
        Mechagnome         = 312924,         -- Hyper Organic Light Originator
    }
    if thisRace ~= nil and racialSpells[thisRace] ~= nil then return racialSpells[thisRace] end
    return racialSpells[race]
    -- return racialSpells[race]
end

if br.lists == nil then br.lists = {} end
br.lists.spells = {
    DEATHKNIGHT = {
        -- Blood
        [250] = {
            abilities = {
                deathsCaress = 195292,
            },
            artifacts = {
                allConsumingRot    = 192464,
                bloodFeast         = 192548,
                bonebreaker        = 192538,
                coagulopathy       = 192460,
                consumption        = 205223,
                danceOfDarkness    = 192514,
                grimPerseverance   = 192447,
                ironHeart          = 192450,
                meatShield         = 192453,
                mouthOfHell        = 192570,
                rattlingBones      = 192557,
                sanguinaryAffinity = 221775,
                skeletalShattering = 192558,
                theHungeringMaw    = 214903,
                umbilicusEternus   = 193213,
                unendingThirst     = 192567,
                veinrender         = 192457,
            },
            buffs     = {
                boneShield        = 195181,
                bloodShield       = 77535,
                coagulopathy      = 391477,
                crimsonScourge    = 81136,
                dancingRuneWeapon = 81256,
                hemostasis        = 273947,
                ossuary           = 219786,
                runeTap           = 194679,
                tombstone         = 219809,
                vampiricBlood     = 55233,
                vampiricStrength  = 408356,
            },
            debuffs   = {
                asphyxiate   = 221562,
                blooddrinker = 206931,
                heartStrike  = 206930,
                markOfBlood  = 206940,
            },
            glyphs    = {

            },
            talents   = {
                antimagicBarrier           = 205727,
                bloodBoil                  = 50842,
                bloodFeast                 = 391386,
                bloodTap                   = 221699,
                blooddrinker               = 206931,
                bloodiedBlade              = 458753,
                bloodshot                  = 391398,
                bloodworms                 = 195679,
                boneCollector              = 458572,
                bonestorm                  = 194844,
                carnage                    = 458752,
                coagulopathy               = 391477,
                consumption                = 274156,
                dancingRuneWeapon          = 49028,
                everlastingBond            = 377668,
                foulBulwark                = 206974,
                gorefiendsGrasp            = 108199,
                gripOfTheDead              = 273952,
                heartStrike                = 206930,
                heartbreaker               = 221536,
                heartrend                  = 377655,
                hemostasis                 = 273946,
                improvedBoneShield         = 374715,
                improvedHeartStrike        = 374717,
                improvedVampiricBlood      = 317133,
                insatiableBlade            = 377637,
                ironHeart                  = 391395,
                leechingStrike             = 377629,
                markOfBlood                = 206940,
                marrowrend                 = 195182,
                ossifiedVitriol            = 458744,
                ossuary                    = 219786,
                perseveranceOfTheEbonBlade = 374747,
                purgatory                  = 114556,
                rapidDecomposition         = 194662,
                redThirst                  = 205723,
                reinforcedBones            = 374737,
                relishInBlood              = 317610,
                runeTap                    = 194679,
                sanguineGround             = 391458,
                shatteringBone             = 377640,
                tighteningGrasp            = 206970,
                tombstone                  = 219809,
                umbilicusEternus           = 391517,
                vampiricBlood              = 55233,
                voracious                  = 273953,
                willOfTheNecropolis        = 206967,
            },
        },
        -- Frost
        [251] = {
            abilities = {
                empowerRuneWeapon = 47568,
                frostStrike       = 49143,
                frostwyrmsFury    = 279302,
                howlingBlast      = 49184,
                obliterate        = 49020,
                pillarOfFrost     = 51271,
                remorselessWinter = 196770,
            },
            artifacts = {

            },
            buffs     = {
                breathOfSindragosa = 155166,
                coldHeart          = 281210,
                darkSuccor         = 101568,
                empowerRuneWeapon  = 47568,
                eradicatingBlow    = 337936,
                frozenPulse        = 195750,
                icyCitadel         = 272723,
                icyTalons          = 194879,
                killingMachine     = 51124,
                pillarOfFrost      = 51271,
                remorselessWinter  = 196770,
                rime               = 59052,
                unleashedFrenzy    = 338501,
            },
            conduits  = {
                eradicatingBlow = 337934,
                everfrost       = 337988,
                unleashedFrenzy = 338492,
            },
            debuffs   = {
                breathOfSindragosa = 155166,
                remorselessWinter  = 196771,
            },
            glyphs    = {

            },
            talents   = {
                asphyxiate          = 108194,
                avalanche           = 207142,
                breathOfSindragosa  = 152279,
                coldHeart           = 281208,
                frostscythe         = 207230,
                frozenPulse         = 194909,
                gatheringStorm      = 194912,
                glacialAdvance      = 194913,
                hornOfWinter        = 57330,
                hypothermicPresence = 321995,
                icecap              = 207126,
                inexorableAssault   = 253593,
                murderousEffeciency = 207061,
                obliteration        = 281238,
            },
            traits    = {
                frozenTempest = 278487,
                icyCitadel    = 272718,
            }
        },
        -- Unholy
        [252] = {
            abilities = {
                apocalypse         = 275699,
                armyOfTheDead      = 42650,
                darkTransformation = 63560,
                epidemic           = 207317,
                festeringStrike    = 85948,
                outbreak           = 77575,
                scourgeStrike      = 55090,
                -- Pet Abilities
                claw               = 47468,
                gnaw               = 47481,
                huddle             = 47484,
                hook               = 212468,
                leap               = 47482,
            },
            artifacts = {

            },
            buffs     = {
                corpseShield       = 207319,
                darkSuccor         = 101568,
                darkTransformation = 63560,
                festermight        = 274373,
                huddle             = 91838,
                necrosis           = 207346,
                soulReaper         = 215711,
                suddenDoom         = 49530,
                runicCorruption    = 51460,
                unholyAssault      = 207289,
                unholyBlight       = 115989,
                empowerRuneWeapon  = 47568,
                commanderOfTheDead = 390259,
                summonGargoyle     = 61777,
            },
            conduits  = {
                convocationOfTheDead = 338553,
            },
            debuffs   = {
                festeringWound = 194310,
                unholyBlight   = 115994,
                virulentPlague = 191587,
                rottenTouch    = 390275,
                deathRot       = 377537,

            },
            glyphs    = {

            },
            talents   = {
                allWillServe       = 194916,
                armyOfTheDamned    = 276837,
                burstingSores      = 207264,
                clawingShadows     = 207311,
                defile             = 152280,
                ebonFever          = 207269,
                gripOfTheDead      = 273952,
                harbingerOfDoom    = 276023,
                infectedClaws      = 207272,
                pestilence         = 277234,
                summonGargoyle     = 49206,
                unholyAssault      = 207289,
                unholyBlight       = 115989,
                unholyPact         = 319230,
                wraithWalk         = 212552,
                commanderOfTheDead = 390259,
                deathRot           = 377537,
                improvedDeathCoil  = 377580,
                coilOfDevastation  = 390270,
                festermight        = 377590,
                rottenTouch        = 390275,
                vileContagion      = 390279,
            },
            traits    = {
                magusOfTheDead = 288417,
            },
        },
        -- All
        Shared = {
            abilities     = {
				
                antiMagicShell = 48707,
                chainsOfIce    = 45524,
                darkCommand    = 56222,
                deathAndDecay  = 43265,
                deathCoil      = 47541,
                deathGate      = 50977,
                deathGrip      = 49576,
                deathsAdvance  = 48265,
                lichborne      = 49039,
                pathOfFrost    = 3714,
                raiseAlly      = 61999,
                runeforging    = 53428,
            },
            artifacts     = {

            },
            buffs         = {
                antiMagicShell    = 48707,
                coldHeartItem     = 235599,
                deathAndDecay     = 188290,
                deathsDue         = 324164,
                iceboundFortitude = 48792,
                icyTalons         = 194878,
                pathOfFrost       = 3714,
                unholyStrength    = 53365,
                wraithWalk        = 212552,
            },
            covenants     = {
                abominationLimb    = 315443,
                deathsDue          = 324128,
                shackleTheUnworthy = 312202,
                swarmingMist       = 311648,
            },
            debuffs       = {
                bloodPlague   = 55078,
                chainsOfIce   = 45524,
                controlUndead = 111673,
                darkCommand   = 56222,
                frostBreath   = 190780,
                frostFever    = 55095,
                razorice      = 51714,
                soulReaper    = 343294,
            },
            glyphs        = {

            },
            runeforges    = {
                bitingCold    = 334678,
                deadliestCoil = 334949,
                phearomones   = 335177,
                superstrain   = 334974,
            },
            talents       = {
				runeStrike	         = 316239,
                abominationLimb      = 383269,
                antimagicZone        = 51052,
                asphyxiate           = 221562,
                assimilation         = 374383,
                blindingSleet        = 207167,
                bloodDraw            = 374598,
                bloodScent           = 374030,
                brittle              = 374504,
                cleavingStrikes      = 316916,
                coldthirst           = 378848,
                controlUndead        = 111673,
                deathStrike          = 49998,
                deathPact            = 48743,
                deathsEcho           = 356367,
                deathsReach          = 276079,
                enfeeble             = 392566,
                gloomWard            = 391571,
                icePrison            = 454786,
                iceboundFortitude    = 48792,
                icyTalons            = 194878,
                improvedDeathStrike  = 374277,
                insidiousChill       = 391566,
                marchOfDarkness      = 391546,
                mindFreeze           = 47528,
                nullMagic            = 454842,
                osmosis              = 454835,
                permafrost           = 207200,
                proliferatingChill   = 373930,
                raiseDead            = 46585,
                runeMastery          = 374574,
                runicAttenuation     = 207104,
                runicProtection      = 454788,
                sacrificialPact      = 327574,
                soulReaper           = 343294,
                subduingGrasp        = 454822,
                suppression          = 374049,
                unholyBond           = 374261,
                unholyEndurance      = 389682,
                unholyGround         = 374265,
                unyieldingWill       = 457574,
                vestigialShell       = 454851,
                veteranOfTheThirdWar = 48263,
                wraithWalk           = 212552,
            },
            talentsHeroic = {
                -- Deathbringer
                bindInDarkness        = 440031,
                bloodFever            = 440002,
                darkTalons            = 436687,
                deathsMessenger       = 437122,
                expellingShield       = 439948,
                exterminate           = 441378,
                grimReaper            = 434905,
                pactOfTheDeathbringer = 440476,
                painfulDeath          = 443564,
                reapersMark           = 439843,
                runeCarvedPlates      = 440282,
                soulRupture           = 437161,
                swiftEnd              = 443560,
                waveOfSouls           = 439851,
                witherAway            = 441894,
                -- Rider of the Apocalypse
                aFeastOfSouls         = 444072,
                apocalypseNow         = 444040,
                deathCharge           = 444010,
                furyOfTheHorsemen     = 444069,
                horsemansAid          = 444074,
                hungeringThirst       = 444037,
                mawswornMenace        = 444099,
                mograinesMight        = 444047,
                nazgrimsConquest      = 444052,
                onAPalerHorse         = 444008,
                pactOfTheApocalypse   = 444083,
                ridersChampion        = 444005,
                trollbanesIcyFury     = 444097,
                whitemanesFamine      = 444033,
                -- Sanlayn
                bloodsoakedGround     = 434033,
                bloodyFortitude       = 434136,
                frenziedBloodthirst   = 434075,
                giftOfTheSanlayn      = 434152,
                inciteTerror          = 434151,
                inflictionOfSorrow    = 434143,
                newlyTurned           = 433934,
                pactOfTheSanlayn      = 434261,
                sanguineScent         = 434263,
                theBloodIsLife        = 434260,
                vampiricAura          = 434100,
                vampiricSpeed         = 434028,
                vampiricStrike        = 433901,
                visceralStrength      = 434157,
            }
        },
    },
    DEMONHUNTER = {
        -- Havoc
        [577] = {
            abilities = {
                annihilation = 201427,
                bladeDance   = 188499,
                blur         = 198589,
                chaosStrike  = 162794,
                deathSweep   = 210152,
                demonsBite   = 162243,
                felRush      = 195072,
            },
            artifacts = {

            },
            buffs     = {
                furiousGaze   = 343312,
                initiative    = 391215,
                innerDemon    = 337313,
                metamorphosis = 162264,
                momentum      = 208628,
                potion        = 371024,
                prepared      = 203650,
                unboundChaos  = 347462, --234059,
            },
            conduits  = {
                serratedGlaive = 339230,
            },
            debuffs   = {
                essenceBreak = 320338,
                exposedWound = 339229,
            },
            glyphs    = {

            },
            items     = {
                algetharPuzzleBox       = 193701,
                augmentation            = 201325,
                beaconToTheBeyond       = 203963,
                dragonfireBombDispenser = 202610,
                elementiumPocketAnvil   = 202617,
                irideusFragment         = 193743,
                manicGrieftorch         = 194308,
                potion                  = 191381,
                stormeatersBoon         = 194302,
            },
            talents   = {
                aFireInside           = 427775,
                acceleratedBlade      = 391275,
                anyMeansNecessary     = 388114,
                blindFury             = 203550,
                burningHatred         = 320374,
                burningWound          = 391189,
                chaosTheory           = 389687,
                chaoticDisposition    = 428492,
                chaoticTransformation = 388112,
                criticalChaos         = 320413,
                cycleOfHatred         = 258887,
                dancingWithFate       = 389978,
                dashOfChaos           = 427794,
                deflectingDance       = 427776,
                demonBlades           = 203555,
                demonHide             = 428241,
                desperateInstincts    = 205411,
                essenceBreak          = 258860,
                eyeBeam               = 198013,
                felBarrage            = 258925,
                felblade              = 232893,
                firstBlood            = 206416,
                furiousGaze           = 343311,
                furiousThrows         = 393029,
                glaiveTempest         = 342817,
                growingInferno        = 390158,
                improvedChaosStrike   = 343206,
                improvedFelRush       = 343017,
                inertia               = 427640,
                initiative            = 388108,
                innerDemon            = 389693,
                insatiableHunger      = 258876,
                isolatedPrey          = 388113,
                knowYourEnemy         = 388118,
                looksCanKill          = 320415,
                momentum              = 206476,
                mortalDance           = 328725,
                netherwalk            = 196555,
                ragefire              = 388107,
                relentlessOnslaught   = 389977,
                restlessHunter        = 390142,
                scarsOfSuffering      = 428232,
                serratedGlaive        = 390154,
                shatteredDestiny      = 388116,
                soulscar              = 388106,
                tacticalRetreat       = 389688,
                trailOfRuin           = 258881,
                unboundChaos          = 347461,
            },
            traits    = {
                chaoticTransformation = 288754,
                eyesOfRage            = 278500,
                furiousGaze           = 273231,
                revolvingBlades       = 279581,
                unboundChaos          = 275144,
            },
        },
        -- Vengeance
        [581] = {
            abilities = {
                demonSpikes    = 203720,
                --felDevastation              = 212084,
                --fieryBrand                  = 204021,
                immolationAura = 258920,
                infernalStrike = 189110,
                metamorphosis  = 187827,
                shear          = 203782,
                --sigilOfChains               = 202138,
                --sigilOfMisery               = 207684,
                soulCleave     = 228477,
                throwGlaive    = 204157,
            },
            artifacts = {

            },
            buffs     = {
                bladeTurning   = 247254,
                demonSpikes    = 203819,
                empowerWards   = 218256,
                feastofSouls   = 207693,
                felBombardment = 337775,
                metamorphosis  = 187827,
                soulFragments  = 203981,
                siphonedPower  = 218561,
            },
            debuffs   = {
                fieryBrand = 207744,
                frailty    = 247456,
            },
            glyphs    = {

            },
            items     = {
                augmentation = 201325,
                potion       = 191383,
            },
            talents   = {
                agonizingFlames         = 207548,
                ascendingFlame          = 428603,
                auraOfPain              = 207347,
                bulkExtraction          = 320341,
                burningAlive            = 207739,
                burningBlood            = 390213,
                calcifiedSpikes         = 389720,
                chainsOfAnger           = 389715,
                charredFlesh            = 336639,
                charredWarblades        = 213010,
                cycleOfBinding          = 389718,
                darkglareBoon           = 389708,
                deflectingSpikes        = 321028,
                downInFlames            = 389732,
                extendedSpikes          = 389721,
                fallout                 = 227174,
                feastofSouls            = 207697,
                feedTheDemon            = 218612,
                felDevastation          = 212084,
                felFlameFortification   = 389705,
                felblade                = 232893,
                fieryBrand              = 204021,
                fieryDemise             = 389220,
                focusedCleave           = 343207,
                fracture                = 263642,
                frailty                 = 389958,
                illuminatedSigils       = 428557,
                infernalArmor           = 320331,
                lastResort              = 209258,
                meteoricStrikes         = 389724,
                painbringer             = 207387,
                perfectlyBalancedGlaive = 320387,
                quickenedSigils         = 209281,
                retaliation             = 389729,
                revelInPain             = 343014,
                roaringFire             = 391178,
                ruinousBulwark          = 326853,
                shearFury               = 389997,
                sigilOfChains           = 202138,
                sigilOfSilence          = 202137,
                soulBarrier             = 263648,
                soulCarver              = 207407,
                soulFurnace             = 391165,
                soulCrush               = 389985,
                soulmonger              = 389711,
                spiritBomb              = 247454,
                stokeTheFlames          = 393827,
                voidReaver              = 268175,
                volatileFlameblood      = 390808,
                vulnerability           = 389976,
            },
        },
        -- Initial Demon Hunter 8-10
        [1456] = {
            abilities = {
                chaosStrike  = 344862, --162794,
                demonsBite   = 344859, --162243,
                felRush      = 344865, --195072,
                sigilOfFlame = 204596,
            },
            buffs     = {

            },
            debuffs   = {
                sigilOfFlame = 204598,
            },
        },
        -- All
        Shared = {
            abilities  = {
                chaosStrike    = 344862,
                demonsBite     = 344859,
                disrupt        = 183752,
                felRush        = 344865,
                glide          = 131347,
                immolationAura = 258920,
                metamorphosis  = 191427,
                sigilOfFlame   = 204596,
                soulCarver     = 214743,
                spectralSight  = 188501,
                throwGlaive    = 185123,
                torment        = 185245,
            },
            artifacts  = {

            },
            buffs      = {
                chaosTheory        = 337567,
                felBarrage         = 258925,
                felBombardment     = 337849,
                felCrystalInfusion = 193547,
                gazeOfTheLegion    = 193456,
                glide              = 131347,
                immolationAura     = 258920,
                inertia            = 427641,
                tacticalRetreat    = 389890,
                twistedHeart       = 396046,
            },
            covenants  = {
                -- elysianDecree               = 306830,
                -- fodderToTheFlame            = 329554,
                -- sinfulBrand                 = 317009,
                -- theHunt                     = 323639,
            },
            debuffs    = {
                burningWound = 346278,
                essenceBreak = 320338,
                sigilOfFlame = 204598,
                sinfulBrand  = 317009,
            },
            glyphs     = {
                glyphOfCracklingFlames       = 219831,
                glyphOfFallowWings           = 220083,
                glyphOfFearsomeMetamorphosis = 220831,
                glyphOfFelTouchedSouls       = 219713,
                glyphOfFelWings              = 220228,
                glyphOfFelEnemies            = 220240,
                glyphOfManaTouchedSouls      = 219744,
                glyphOfShadowEnemies         = 220244,
                glyphOfTatteredWings         = 220226,
            },
            runeforges = {
                agonyGaze           = 355886,
                burningWound        = 346279,
                chaosTheory         = 337551,
                darkglareMedallion  = 337534,
                felBombardment      = 337775,
                razelikhsDefilement = 337544,
            },
            talents    = {
                aldrachiDesign        = 391409,
                blazingPath           = 320416,
                bouncingGlaives       = 320386,
                championOfTheGlaive   = 429211,
                chaosFragments        = 320412,
                chaosNova             = 179057,
                collectiveAnguish     = 390152,
                consumeMagic          = 278326,
                darkness              = 196718,
                demonic               = 213410,
                demonMuzzle           = 388111,
                elysianDecree         = 390163,
                erraticFelheart       = 391397,
                felfireHaste          = 389846,
                flamesOfFury          = 389694,
                illidariKnowledge     = 389696,
                imprison              = 217832,
                improvedDisrupt       = 320361,
                improvedSigilOfMisery = 320418,
                internalStruggle      = 393822,
                liveByTheGlaive       = 428607,
                longNight             = 389781,
                lostInDarkness        = 389849,
                masterOfTheGlaive     = 389763,
                pitchBlack            = 389783,
                preciseSigils         = 389799,
                pursuit               = 320654,
                rushOfChaos           = 320421,
                shatteredRestoration  = 389824,
                sigilOfMisery         = 207684,
                soulRending           = 204909,
                soulSigils            = 395446,
                swallowedAnger        = 320313,
                theHunt               = 370965,
                unrestrainedFury      = 320770,
                vengefulBonds         = 320635,
                vengefulRetreat       = 198793,
                willOfTheIllidari     = 389695,
            },
        },
    },
    DRUID = {
        -- Initial
        [1447] = {

        },
        -- Balance
        [102] = {
            abilities  = {
                celestialAlignment = 194223,
                fullMoon           = 274283,
                furyOfElune        = 202770,
                halfMoon           = 274282,
                innervate          = 29166,
                starfire           = 194153,
                newMoon            = 274281,
                removeCorruption   = 2782,
                solarBeam          = 78675,
                typhoon            = 132469,
                wrath              = 190984,
                starfall           = 191034,
                starsurge          = 78674,
                sunfire            = 93402,
                stellarFlare       = 202347,
            },
            artifacts  = {

            },
            buffs      = {
                blessingOfElune             = 202737,
                blessingOfAnshe             = 202739,
                incarnationChoseOfElune     = 102560,
                celestialAlignment          = 194223,
                eclipse_lunar               = 48518,
                eclipse_solar               = 48517,
                onethsOverconfidence        = 209407,
                onethsIntuition             = 209406,
                solarEmpowerment            = 164545,
                innervate                   = 29166,
                lunarEmpowerment            = 164547,
                warriorOfElune              = 202425,
                balanceForm                 = 24858,
                stellarDrift                = 202461,
                emeraldDreamcatcher         = 208190,
                owlkinFrenzy                = 157228,
                powerOfEluneTheMoonGoddness = 208284,
                sephuzSecret                = 208052,
                astralAcceleration          = 242232,
                newMoonController           = -2027671,
                solstice                    = 343648,
                starfall                    = 191034,
                starLord                    = 279709, --backwards compatible
                starlord                    = 279709,
                livelySpirit                = 279279,
                arcanicPulsar               = 287790,
                primordialArcanicPulsar     = 338668,
                balanceOfAllThings          = 339942,
                balanceOfAllThingsNature    = 339943, -- Nature Buff
                balanceOfAllThingsArcane    = 339946, -- Arcane Buff
                timewornDreambinder         = 339949,
                kindredEmpowerment          = 327022,
                onethsClearVision           = 338661,
                ravenousFrenzy              = 323546,

            },
            conduits   = {
                preciseAlignment = 340706,


            },
            covenants  = {
                loneEmpowerment = 338142,
                ravenousFrenzy  = 323546,
                empowerBond     = 326446,
            },
            debuffs    = {
                stellarFlare       = 202347,
                moonfire           = 164812,
                sunfire            = 164815,
                stellarEmpowerment = 197637,
            },
            glyphs     = {
            },
            runeforges = {
                balanceOfAllThings      = 339942,
                lycarasFleetingGlimpse  = 340059,
                primordialArcanicPulsar = 338668,
                timewornDreambinder     = 339949,

            },
            talents    = {
                aetherialKindling        = 327541,
                astralCommunion          = 202359,
                astralSmolder            = 394058,
                balanceOfAllThings       = 394049,
                bloomingInfusion         = 429433,
                bounteousBloom           = 429215,
                celestialAlignment       = 194223,
                cenariusMight            = 455797,
                controlOfTheDream        = 434249,
                convokeTheSpirits        = 323764,
                denizenOfTheDream        = 394076,
                dreamSurge               = 433831,
                durabilityOfNature       = 429227,
                earlySpring              = 428937,
                eclipse                  = 79577,
                elunesGuidance           = 393991,
                expansiveness            = 429399,
                forceOfNature            = 205636,
                furyOfElune              = 202770,
                grovesInspiration        = 429402,
                harmonyOfTheGrove        = 428731,
                incarnationChosenOfElune = 394013,
                lightOfTheSun            = 202918,
                lunarShrapnel            = 393868,
                naturesBalance           = 202430,
                naturesGrace             = 393959,
                newMoon                  = 274281,
                orbitBreaker             = 383197,
                potentEnchantments       = 429420,
                powerOfGoldrinn          = 394046,
                powerOfNature            = 428859,
                powerOfTheDream          = 434220,
                protectiveGrowth         = 433748,
                radiantMoonlight         = 394121,
                rattleTheStars           = 393954,
                shootingStars            = 202342,
                solarBeam                = 78675,
                solstice                 = 343647,
                soulOfTheForest          = 114107,
                starfall                 = 191034,
                starlord                 = 202345,
                starweaver               = 393940,
                stellarFlare             = 202347,
                sunderedFirmament        = 294108,
                treantsOfTheMoon         = 428544,
                twinMoons                = 279620,
                umbralEmbrace            = 393760,
                umbralIntensity          = 383195,
                waningTwilight           = 393956,
                warriorOfElune           = 202425,
                wildMushroom             = 88747,
            },
            traits     = {
                arcanicPulsar  = 287773,
                dawningSun     = 276152,
                highNoon       = 278505,
                lunarShrapnel  = 278507,
                powerOfTheMoon = 273367,
                streakingStars = 272871,
                sunblaze       = 274397,
            }
        },
        -- Feral
        [103] = {
            abilities = {
                adaptiveSwarmDamage = 391889, -- Not Castable but needed for In-Flight
                adaptiveSwarmHeal   = 391891, -- Not Castable but needed for In-Flight
                moonfireCat         = 155625,
            },
            buffs     = {
                adaptiveSwarmDamage         = 391889,
                adaptiveSwarmHeal           = 391891,
                apexPredator                = 255984,
                apexPredatorsCraving        = 391882, --339140,
                berserk                     = 106951,
                bloodtalons                 = 145152,
                clearcasting                = 135700,
                elunesGuidance              = 202060,
                fieryRedMaimers             = 236757,
                incarnationAvatarOfAshamane = 102543,
                ironJaws                    = 276021,
                jungleStalker               = 252071,
                overflowingPower            = 405189,
                predatorRevealed            = 408468,
                predatorySwiftness          = 69369,
                sabertooth                  = 391722,
                savageRoar                  = 52610,
                scentOfBlood                = 285646,
                smolderingFrenzy            = 422751,
                stampedingRoar              = 77764,
                suddenAmbush                = 391974,
                survivalInstincts           = 61336,
                tigersFury                  = 5217,
            },
            debuffs   = {
                adaptiveSwarmDamage = 391889,
                adaptiveSwarmHeal   = 391891,
                bloodseekerVines    = 439531,
                direFixation        = 417713,
                feralFrenzy         = 274838,
                moonfireCat         = 155625,
                primalWrath         = 1079,
                rakeStun            = 163505,
                thrashCat           = 405233,
            },
            items     = {
                algetharPuzzleBox          = 193701,
                ashesOfTheEmbersoul        = 207167,
                augmentation               = 201325, -- Generic, place item id of desired augmentation
                bandolierOfTwistedBlades   = 207165,
                fyrakksTaintedRageheart    = 207164,
                manicGrieftorch            = 194308,
                mirrorOfFracturedTomorrows = 207581,
                mydasTalisman              = 158319,
                potion                     = 191383, -- Generic, place item id of desired potion
                witherbarksBranch          = 109999,
            },
            talents   = {
                adaptiveSwarm               = 391888,
                aggravateWounds             = 441829,
                apexPredatorsCraving        = 391881,
                ashamanesGuidance           = 391548,
                berserk                     = 106951,
                berserkFrenzy               = 384668,
                berserkHeartOfTheLion       = 391174,
                bestialStrength             = 441841,
                bloodtalons                 = 319439,
                bondWithNature              = 439929,
                brutalSlash                 = 202028,
                carnivorousInstinct         = 390902,
                circleOfLifeAndDeath        = 400320,
                clawRampage                 = 441835,
                coiledToSpring              = 449537,
                convokeTheSpirits           = 391528,
                doubleclawedRake            = 391700,
                dreadfulBleeding            = 391045,
                dreadfulWound               = 441809,
                empoweredShapeshifting      = 441689,
                entanglingVortex            = 439895,
                feralFrenzy                 = 274837,
                flowerWalk                  = 439901,
                fountOfStrength             = 441675,
                franticMomentum             = 391875,
                harmoniousConstitution      = 440116,
                huntBeneathTheOpenSkies     = 439868,
                implant                     = 440118,
                incarnationAvatarOfAshamane = 102543,
                infectedWounds              = 48484,
                killingStrikes              = 441824,
                lethalPreservation          = 455461,
                lionsStrength               = 391972,
                lunarInspiration            = 155580,
                mercilessClaws              = 231063,
                momentOfClarity             = 236068,
                omenOfClarity               = 16864,
                packsEndurance              = 441844,
                pouncingStrikes             = 390772,
                predator                    = 202021,
                predatorySwiftness          = 16974,
                primalWrath                 = 285381,
                ragingFury                  = 391078,
                rampantFerocity             = 391709,
                ravage                      = 441583,
                ripAndTear                  = 391347,
                ruthlessAggression          = 441814,
                saberJaws                   = 421432,
                sabertooth                  = 202031,
                savageFury                  = 449645,
                soulOfTheForest             = 158476,
                strategicInfusion           = 439890,
                strikeForTheHeart           = 441845,
                suddenAmbush                = 384667,
                survivalInstincts           = 61336,
                tasteForBlood               = 384665,
                tearDownTheMighty           = 441846,
                thrashingClaws              = 405300,
                thrivingGrowth              = 439528,
                tigersFury                  = 5217,
                tigersTenacity              = 391872,
                tirelessEnergy              = 383352,
                twinSprouts                 = 440117,
                unbridledSwarm              = 391951,
                veinripper                  = 391978,
                vigorousCreepers            = 440119,
                wildSlashes                 = 390864,
                wildpowerSurge              = 441691,
                wildshapeMastery            = 441678,
                wildstalkersPower           = 439926,
            },
        },
        -- Guardian
        [104] = {
            abilities = {
                berserk                    = 50334,
                incapacitatingRoar         = 99,
                incarnationGuardianOfUrsoc = 102558,
                maul                       = 6807,
                removeCorruption           = 2782,
                skullBash                  = 106839,
                stampedingRoar             = 106898,
                survivalInstincts          = 61336,
            },
            artifacts = {

            },
            buffs     = {
                berserk                    = 50334,
                galacticGuardian           = 213708,
                goryFur                    = 201671,
                incarnationGuardianOfUrsoc = 102558,
                gore                       = 93622,
                pulverize                  = 158792,
                savageCombatant            = 340613,
                survivalInstincts          = 61336,
                toothAndClaw               = 135286,
            },
            conduits  = {
                savageCombatant = 340609,

            },
            covenants = {
                loneProtection = 338018,
            },
            debuffs   = {
                moonfireGuardian = 164812,
                toothAndClaw     = 135601,
            },
            glyphs    = {

            },
            talents   = {
                afterTheWildfire           = 371905,
                aggravateWounds            = 441829,
                berserkPersistence         = 377779,
                berserkRavage              = 343240,
                berserkUncheckedAggression = 377623,
                bestialStrength            = 441841,
                bloodFrenzy                = 203962,
                brambles                   = 203953,
                bristlingFur               = 155835,
                circleOfLifeAndDeath       = 391969,
                clawRampage                = 441835,
                convokeTheSpirits          = 323764,
                dreadfulWound              = 441809,
                dreamOfCenarius            = 372119,
                earthwarden                = 203974,
                elunesFavored              = 370586,
                empoweredShapeshifting     = 441689,
                flashingClaws              = 393427,
                fountOfStrength            = 441675,
                -- frontOfThePack             = 377835,
                furyOfNature               = 370695,
                galacticGuardian           = 203964,
                gore                       = 210706,
                goryFur                    = 200854,
                guardianOfElune            = 213680,
                improvedSurvivalInstincts  = 328767,
                incarnationGuardianOfUrsoc = 102558,
                infectedWounds             = 345208,
                innateResolve              = 377811,
                killingStrikes             = 441824,
                layeredMane                = 279552,
                mangle                     = 231064,
                maul                       = 6807,
                packsEndurance             = 441844,
                pulverize                  = 80313,
                rageOfTheSleeper           = 200851,
                ravage                     = 441583,
                reinforcedFur              = 393618,
                reinvigoration             = 372945,
                rendAndTear                = 204053,
                ruthlessAggression         = 441814,
                scintillatingMoonlight     = 238049,
                soulOfTheForest            = 158477,
                strikeForTheHeart          = 441845,
                survivalInstincts          = 61336,
                survivalOfTheFittest       = 203965,
                tearDownTheMighty          = 441846,
                toothAndClaw               = 135288,
                twinMoonfire               = 372567,
                untamedSavagery            = 372943,
                -- ursineAdept                = 300346,
                ursocsEndurance            = 393611,
                ursocsFury                 = 372505,
                ursocsGuidance             = 393414,
                viciousCycle               = 371999,
                vulnerableFlesh            = 372618,
                wildpowerSurge             = 441691,
                wildshapeMastery           = 441678,
            },
            traits    = {
                layeredMane  = 279552,
                twistedClaws = 275906,
            },
        },
        -- Restoration
        [105] = {
            abilities  = {
                efflorescence    = 145205,
                innervate        = 29166,
                ironbark         = 102342,
                lifebloom        = 33763,
                naturesCure      = 88423,
                nourish          = 50464,
                revitalize       = 212040,
                wrath            = 5176,
                sunfire          = 93402,
                tranquility      = 740,
                typhoon          = 132469,
                yserasGift       = 145108,
                naturesSwiftness = 132158,
            },
            artifacts  = {

            },
            buffs      = {
                abundance               = 207640,
                cenarionWard            = 102352,
                clearcasting            = 16870,
                incarnationTreeOfLife   = 33891,
                innervate               = 29166,
                groveTending            = 279793,
                rejuvenationGermination = 155777,
                lifebloom               = 33763,
                eclipse_lunar           = 48518,
                eclipse_solar           = 48517,
                --lunarEmpowerment            = 164547,
                regrowth                = 8936,
                --solarEmpowerment            = 164545,
                soulOfTheForest         = 114108,
                cultivat                = 200389,
                tranquility             = 157982,
                springblossom           = 207386,
                symbolOfHope            = 64901,
                fullbloom               = 290213,
                heartOfTheWild          = 108291,
            },
            conduits   = {
                loneMeditation = 338035,
            },
            debuffs    = {
                moonfire = 164812,
                sunfire  = 164815,
            },
            glyphs     = {

            },
            runeforges = {
                theDarkTitansLesson = 338831,
                verdantInfusion     = 338829,

            },
            talents    = {
                abundance               = 207383,
                balanceAffinity         = 197632,
                bloomingInfusion        = 429433,
                bondWithNature          = 439929,
                bounteousBloom          = 429215,
                buddingLeaves           = 392167,
                burstingGrowth          = 440120,
                callOfTheElderDruid     = 426784,
                cenarionWard            = 102351,
                cenariusGuidance        = 393371,
                cenariusMight           = 455797,
                controlOfTheDream       = 434249,
                cultivation             = 200390,
                dreamSurge              = 433831,
                durabilityOfNature      = 429227,
                earlySpring             = 428937,
                entanglingVortex        = 439895,
                expansiveness           = 429399,
                feralAffinity           = 197490,
                flourish                = 197721,
                flowerWalk              = 439901,
                germination             = 155675,
                grovesInspiration       = 429402,
                guardianAffinity        = 197491,
                harmoniousConstitution  = 440116,
                harmonyOfTheGrove       = 428731,
                huntBeneathTheOpenSkies = 439868,
                implant                 = 440118,
                incarnationTreeOfLife   = 33891,
                innerPeace              = 197073,
                lethalPreservation      = 455461,
                nourish                 = 50464,
                overgrowth              = 203651,
                photosynthesis          = 274902,
                potentEnchantments      = 429420,
                powerOfNature           = 428859,
                powerOfTheDream         = 434220,
                protectiveGrowth        = 433748,
                resilientFlourishing    = 439880,
                rootNetwork             = 439882,
                soulOfTheForest         = 158478,
                springBlossoms          = 207385,
                strategicInfusion       = 439890,
                thrivingGrowth          = 439528,
                treantsOfTheMoon        = 428544,
                twinSprouts             = 440117,
                vigorousCreepers        = 440119,
                wildstalkersPower       = 439926,
            },
            traits     = {
                dawningSun = 276152,
                highNoon   = 278505,
            }
        },
        -- All
        Shared = {
            abilities     = {
                barkskin              = 22812,
                bearForm              = 5487,
                catForm               = 768,
                charmWoodlandCreature = 127757, -- Tome of the Wilds
                cyclone               = 33786,
                dash                  = 1850,
                dreamwalk             = 193753,
                entanglingRoots       = 339,
                ferociousBite         = 22568,
                flap                  = 164862,
                flightForm            = 165962,
                growl                 = 6795,
                mangle                = 33917,
                markOfTheWild         = 1126,
                moonfire              = 8921,
                mountForm             = 210053,
                prowl                 = 5215,
                rebirth               = 20484,
                regrowth              = 8936,
                revive                = 50769,
                shred                 = 5221,
                sunfire               = 164815,
                swipe                 = 213764,
                swipeBear             = 213771,
                swipeCat              = 106785,
                teleportMoonglade     = 18960,
                thrashBear            = 77758,
                thrashCat             = 106830,
                trackBeasts           = 210065,
                trackHumanoids        = 5225,
                travelForm            = 783,
                wrath                 = 5176,
            },
            animas        = {
                lycarasBargin = 329960,
                lycarasTwig   = 330666,
            },
            artifacts     = {

            },
            buffs         = {
                adaptiveSwarm              = 325748,
                barkskin                   = 22812,
                bearForm                   = 5487,
                burningEssence             = 138927,
                catForm                    = 768,
                convokeTheSpirits          = 391528,
                dash                       = 1850,
                tigerDash                  = 252216,
                flightForm                 = 165962,
                frenziedRegeneration       = 22842,
                heartOfTheWild             = 319454,
                ironfur                    = 192081,
                kindredEmpowerment         = 327139,
                kindredSpiritsBuff         = 326967, --This is buff on ourselves...at least as dps
                kindredEmpowermentEnergize = 327022, --/kindred-empowerment  this is when someone else cast it on you
                loneSpirit                 = 338041,
                lycarasTwig                = 330668, -- Anima Power Torghast
                markOfTheWild              = 1126,
                moonkinForm                = 197625,
                onethsPerception           = 339800,
                prowl                      = 5215,
                rejuvenation               = 774,
                regrowth                   = 8936,
                shadowmeld                 = 58984,
                soulshape                  = 310143,
                stagForm                   = 210053,
                stampedingRoar             = 106898,
                stampedingRoarCat          = 77764,
                suddenAmbush               = 340698,
                travelForm                 = 783,
                treantForm                 = 114282,
                wildGrowth                 = 48438,
            },
            conduits      = {
                deepAllegiance = 341378,
                tasteForBlood  = 340682,
            },
            covenants     = {
                adaptiveSwarm             = 325727,
                adaptiveSwarmHeal         = 325748,
                convokeTheSpiritsCovenant = 323764,
                kindredSpirits            = 326434,
                ravenousFrenzy            = 323546,
            },
            debuffs       = {
                adaptiveSwarm    = 325733,
                cyclone          = 33786,
                entanglingRoots  = 339,
                growl            = 6795,
                hibernate        = 2637,
                lycarasBargin    = 329961,
                moonfire         = 164812, --8921,
                rake             = 155722,
                rip              = 1079,
                thrashBear       = 192090,
                thrashCat        = 106830,
                massEntanglement = 102359,
            },
            glyphs        = {
                glyphOfTheCheetah        = 131113,
                glyphOfTheDoe            = 224122,
                glyphOfTheFeralChameleon = 210333,
                glyphOfTheOrca           = 114333,
                glyphOfTheSentinel       = 219062,
                glyphOfTheUrsolChameleon = 107059,
            },
            runeforges    = {
                apexPredatorsCraving  = 339139,
                eyeOfFearfullSymmetry = 339141,
                frenzyband            = 340053,
            },
            talents       = {
                astralInfluence         = 197524,
                cyclone                 = 33786,
                felineSwiftness         = 131768,
                fluidForm               = 449193,
                forestwalk              = 400129,
                frenziedRegeneration    = 22842,
                heartOfTheWild          = 319454,
                hibernate               = 2637,
                improvedBarkskin        = 327993,
                improvedRejuvenation    = 231040,
                improvedStampedingRoar  = 288826,
                improvedSunfire         = 231050,
                incapacitatingRoar      = 99,
                innervate               = 29166,
                instinctsOfTheClaw      = 449184,
                ironfur                 = 192081,
                killerInstinct          = 108299,
                loreOfTheGrove          = 449185,
                lycarasTeachings        = 378988,
                maim                    = 22570,
                massEntanglement        = 102359,
                mattedFur               = 385786,
                mightyBash              = 5211,
                naturalRecovery         = 377796,
                naturesVigil            = 124974,
                nurturingInstinct       = 33873,
                oakskin                 = 449191,
                primalFury              = 159286,
                rake                    = 1822,
                rejuvenation            = 774,
                removeCorruption        = 2782,
                renewal                 = 108238,
                rip                     = 1079,
                risingLightFallingNight = 417712,
                skullBash               = 106839,
                soothe                  = 2908,
                stampedingRoar          = 106898,
                starfire                = 197628,
                starlightConduit        = 451211,
                starsurge               = 197626,
                sunfire                 = 93402,
                thickHide               = 16931,
                thrash                  = 106832,
                tigerDash               = 252216,
                typhoon                 = 132469,
                ursineVigor             = 377842,
                ursocsSpirit            = 449182,
                ursolsVortex            = 102793,
                verdantHeart            = 301768,
                wellhonedInstincts      = 377847,
                wildCharge              = 102401,
                wildGrowth              = 48438,
            },
            talentsHeroic = {
                bloomingInfusion     = 429433,
                bounteousBloom       = 429215,
                burstingGrowth       = 440120,
                cenariusMight        = 455797,
                controlOfTheDream    = 434249,
                dreamSurge           = 433831,
                durabilityOfNature   = 429227,
                earlySpring          = 428937,
                expansiveness        = 429399,
                grovesInspiration    = 429402,
                harmonyOfTheGrove    = 428731,
                potentEnchantments   = 429420,
                powerOfNature        = 428859,
                powerOfTheDream      = 434220,
                protectiveGrowth     = 433748,
                resilientFlourishing = 439880,
                rootNetwork          = 439882,
                treantsOfTheMoon     = 428544,
            },
            traits        = {
                livelySpirit = 279642,
            },
        },
    },
    EVOKER = {
        -- Initial Evoker
        [1465] = {
            abilities = {
                fireBreath = 357208,
            },
        },
        -- Devastation
        [1467] = {
            abilities  = {

            },
            artifacts  = {

            },
            buffs      = {
                burnout         = 375802,
                chargedBlast    = 370454,
                dragonrage      = 375087,
                emeraldTrance   = 424155,
                essenceBurst    = 359618,
                iridescenceBlue = 386399,
                iridescenceRed  = 386353,
                leapingFlames   = 370901,
                powerSwell      = 376850,
                snapFire        = 370818,
            },
            conduits   = {

            },
            covenants  = {

            },
            debuffs    = {
                shatteringStar = 370452,
            },
            glyphs     = {

            },
            runeforges = {

            },
            talents    = {
                animosity             = 375797,
                arcaneIntensity       = 375618,
                arcaneVigor           = 386342,
                azureEssenceBurst     = 375721,
                burnout               = 375801,
                catalyze              = 386283,
                causality             = 375777,
                chargedBlast          = 370455,
                denseEnergy           = 370962,
                dragonrage            = 375087,
                engulfingBlaze        = 370837,
                eternitySurge         = 359073,
                eternitysSpan         = 375757,
                eventHorizon          = 411164,
                everburningFlame      = 370819,
                eyeOfInfinity         = 411165,
                feedTheFlames         = 369846,
                firestorm             = 368847,
                focusingIris          = 386336,
                fontOfMagic           = 411212,
                heatWave              = 375725,
                hoardedPower          = 375796,
                honedAggression       = 371038,
                immenentDestruction   = 370781,
                imposingPresence      = 371016,
                innerRadiance         = 386405,
                iridescence           = 370867,
                layWaste              = 371034,
                onyxLegacy            = 386348,
                powerSwell            = 370839,
                pyre                  = 357211,
                ragingInferno         = 405659,
                rubyEmbers            = 365937,
                rubyEssenceBurst      = 376872,
                scintillation         = 370821,
                shatteringStar        = 370452,
                snapFire              = 370783,
                spellweaversDominance = 370845,
                titanicWrath          = 386272,
                tyranny               = 376888,
                volatility            = 369089,
            },
            traits     = {

            },
        },
        -- Preservation
        [1468] = {
            abilities  = {
                echo       = 364343,
                naturalize = 360823,
                reversion  = 366155,
                rewind     = 363534,

            },
            artifacts  = {

            },
            buffs      = {
                echo         = 364343,
                essenceBurst = 369297,
                reversion    = 366155,
                timeDilation = 357170,

            },
            conduits   = {

            },
            covenants  = {

            },
            debuffs    = {

            },
            glyphs     = {

            },
            runeforges = {

            },
            talents    = {
                dreamBreath      = 355936,
                emeraldCommunion = 370960,
                spiritbloom      = 367226,
                timeDilation     = 357170,
                temporalAnomaly  = 373861,

            },
            traits     = {

            },
        },
        -- All
        Shared = {
            abilities  = {
                azureStrike         = 362969,
                blessingOfTheBronze = 364342,
                choosenIdentity     = 360022,
                deepBreath          = 357210,
                disintegrate        = 356995,
                emeraldBlossom      = 355913,
                fireBreath          = 357208,
                furyOfTheAspects    = 390386,
                hover               = 358267,
                livingFlame         = 361469,
                -- quell               = 351338,
                -- renewingBlaze       = 374348,
                returnEvoker        = 361227,
                tailSwipe           = 368970,
                wingBuffet          = 357214,
                visage              = 351239,
            },
            animas     = {

            },
            artifacts  = {

            },
            buffs      = {
                ancientFlame        = 375583,
                blazingShards       = 409848,
                blessingOfTheBronze = 364342,
                hover               = 358267,
                scarletAdaptation   = 372470,
                soar                = 381322,
                sourceOfMagic       = 372581,
                tipTheScales        = 370553,
                visage              = 372014,
                visageForm          = 351239,
            },
            conduits   = {

            },
            covenants  = {

            },
            debuffs    = {
                fireBreath     = 357209,
                shatteringStar = 370452,
            },
            glyphs     = {

            },
            runeforges = {

            },
            talents    = {
                aerialMastery      = 365933,
                ancientFlame       = 369990,
                attunedToTheDream  = 376930,
                blastFurnace       = 375510,
                bountifulBloom     = 370886,
                cauterizingFlame   = 374251,
                clobberingSweep    = 375443,
                draconicLegacy     = 376166,
                enkindled          = 375554,
                essenceAttunement  = 375722,
                expunge            = 365585,
                extendedFlight     = 375517,
                exuberance         = 375542,
                fireWithin         = 375577,
                fociOfLife         = 375574,
                forgerOfMountains  = 375528,
                heavyWingbeats     = 368838,
                inherentResistance = 375544,
                innateMagic        = 375520,
                instinctiveArcana  = 376164,
                landslide          = 358385,
                leapingFlames      = 369939,
                lushGrowth         = 375561,
                naturalConvergence = 369913,
                obsidianBulwark    = 375406,
                obsidianScales     = 363916,
                oppressingRoar     = 372048,
                overawe            = 374346,
                panacea            = 387761,
                permeatingChill    = 370897,
                potentMana         = 418101,
                powerNexus         = 369908,
                protractedTalons   = 369909,
                quell              = 351338,
                recall             = 371806,
                regenerativeMagic  = 387787,
                renewingBlaze      = 374348,
                rescue             = 370665,
                scarletAdaptation  = 372469,
                sleepWalk          = 360806,
                sourceOfMagic      = 369459,
                tailwind           = 375556,
                terrorOfTheSkies   = 371032,
                timeSpiral         = 374968,
                tipTheScales       = 370553,
                twinGuardian       = 370888,
                unravel            = 368432,
                verdantEmbrace     = 360995,
                wallopingBlow      = 387341,
                zephyr             = 374227,
            },
            traits     = {

            },
        },
    },
    HUNTER = {
        -- BeastMastery
        [253] = {
            abilities = {
                aspectOfTheWild = 193530,
                barbedShot      = 217200,
                bestialWrath    = 19574,
                cobraShot       = 193455,
                concussiveShot  = 5116,
                counterShot     = 147362,
                intimidation    = 19577,
                killCommand     = 34026,
                killShot        = 53351,
                multishot       = 2643,
            },
            animas    = {
                piercingScope = 331183,
            },
            artifacts = {

            },
            buffs     = {
                aspectOfTheWild = 193530,
                barbedShot      = 217200,
                beastCleave     = 118455,
                berserking      = 26297,
                bestialWrath    = 19574,
                danceOfDeath    = 274443,
                direBeast       = 120694,
                frenzy          = 272790,
                parselsTongue   = 248084,
                spittingCobra   = 194407,
                volley          = 194386,
            },
            debuffs   = {
                barbedShot = 217200,
            },
            glyphs    = {

            },
            talents   = {
                animalCompanion = 267116,
                barrage         = 120360,
                bloodshed       = 321530,
                direBeast       = 120679,
                killCleave      = 378207,
                killerCobra     = 199532,
                killerInstinct  = 273887,
                oneWithThePack  = 199528,
                scentOfBlood    = 193532,
                stampede        = 201430,
                stomp           = 199530,
                thrillOfTheHunt = 257944,
                wailingArrow    = 392060,
            },
            traits    = {
                danceOfDeath    = 274441,
                primalInstincts = 279806,
                rapidReload     = 278530,
            },
        },
        -- Marksmanship
        [254] = {
            abilities  = {
            },
            artifacts  = {
            },
            buffs      = {
                bulletstorm    = 389020,
                bullseye       = 204090,
                deadEye        = 321461,
                deathblow      = 378770,
                feignDeath     = 5384,
                inTheRhythm    = 272733,
                lethalShots    = 260395,
                lockAndLoad    = 194594,
                masterMarksman = 269576,
                preciseShots   = 260242,
                razorFragments = 388993,
                salvo          = 400456,
                steadyFocus    = 193534,
                trickShots     = 257622,
                trueshot       = 288613,
                unerringVision = 274447,
            },
            debuffs    = {
                huntersMark  = 257284,
                serpentSting = 271788,
            },
            glyphs     = {

            },
            interrupts = {
                counterShot = 147362,
            },
            talents    = {
                aimedShot               = 19434,
                barrage                 = 120360,
                bindingShackles         = 321468,
                bulletstorm             = 389019,
                bullseye                = 204089,
                callingTheShots         = 260404,
                carefulAim              = 260228,
                chimaeraShot            = 342049,
                crackShot               = 321293,
                deathblow               = 378769,
                eagletalonsTrueFocus    = 389449,
                explosiveShot           = 212431,
                fanTheHammer            = 459794,
                focusedAim              = 378767,
                heavyAmmo               = 378910,
                hydrasBite              = 260241,
                improvedSteadyShot      = 321018,
                inTheRhythm             = 407404,
                killShot                = 53351,
                killZone                = 459921,
                killerAccuracy          = 378765,
                legacyOfTheWindrunners  = 406425,
                lightAmmo               = 378913,
                lockAndLoad             = 194595,
                loneWolf                = 155228,
                masterMarksman          = 260309,
                multishot               = 257620,
                nightHunter             = 378766,
                penetratingShots        = 459783,
                preciseShots            = 260240,
                rapidFire               = 257044,
                rapidFireBarrage        = 459800,
                razorFragments          = 384790,
                readiness               = 389865,
                salvo                   = 400456,
                serpentstalkersTrickery = 378888,
                smallGameHunter         = 459802,
                steadyFocus             = 193533,
                streamline              = 260367,
                surgingShots            = 391559,
                tacticalReload          = 400472,
                trickShots              = 257621,
                trueshot                = 288613,
                unerringVision          = 386878,
                volley                  = 260243,
                wailingArrow            = 459806,
            },
            traits     = {
                focusedFire    = 278531,
                inTheRhythm    = 264198,
                rapidReload    = 278530,
                steadyAim      = 277651,
                surgingShots   = 287707,
                unerringVision = 274444,
            },
        },
        -- Survival
        [255] = {
            abilities = {
                aspectOfTheEagle   = 186289,
                carve              = 187708,
                coordinatedAssault = 266779,
                harpoon            = 190925,
                intimidation       = 19577,
                killCommand        = 259489,
                killShot           = 320976,
                muzzle             = 187707,
                pheromoneBomb      = 270323, -- Wildfire Infusion
                raptorStrike       = 186270,
                serpentSting       = 259491,
                shrapnelBomb       = 270335, -- Wildfire Infusion
                volatileBomb       = 271045, -- Wildfire Infusion
                wakeUp             = 210000,
                wildfireBomb       = 259495,
            },
            artifacts = {

            },
            buffs     = {
                aspectOfTheEagle   = 186289,
                blurOfTalons       = 277969,
                coordinatedAssault = 360952,
                exposedFlank       = 252094, -- Tier 21
                mongooseFury       = 259388,
                tipOfTheSpear      = 260286,
                vipersVenom        = 268552,
                madBombardier      = 363805, -- Tier 28
            },
            debuffs   = {
                bloodseeker      = 259277,
                internalBleeding = 270343,
                serpentSting     = 259491,
                shrapnelBomb     = 270339,
                wildfireBomb     = 269747,
                pheromoneBomb    = 270332,
            },
            glyphs    = {

            },
            talents   = {
                alphaPredator     = 269737,
                birdsOfPrey       = 260331,
                bloodseeker       = 260248,
                butchery          = 212436,
                crackShot         = 321293,
                flankingStrike    = 269751,
                furyOfTheEagle    = 203415,
                guerrillaTactics  = 264332,
                hydrasBite        = 260241,
                mongooseBite      = 259387,
                steelTrap         = 162488,
                termsOfEngagement = 265895,
                tipOfTheSpear     = 260285,
                vipersVenom       = 268501,
                wildfireInfusion  = 271014,
            },
            traits    = {
                blurOfTalons       = 277653,
                latentPoison       = 273283,
                primevalIntuition  = 288570,
                upCloseAndPersonal = 278533,
                venomousFangs      = 274590,
                wildernessSurvival = 279589,
            }
        },
        -- All
        Shared = {
            abilities     = {
                -- Hunter Abilities
                arcaneShot           = 185358,
                aspectOfTheChameleon = 61648,
                aspectOfTheCheetah   = 186257,
                aspectOfTheTurtle    = 186265,
                disengage            = 781,
                eagleEye             = 6197,
                exhilaration         = 109304,
                eyeOfTheBeast        = 321297,
                feignDeath           = 5384,
                flare                = 1543,
                fortitudeOfTheBear   = 392956,
                freezingTrap         = 187650,
                huntersMark          = 257284,
                steadyShot           = 56641,
                trackBeasts          = 1494,
                trackDemons          = 19878,
                trackDragonkin       = 19879,
                trackElementals      = 19880,
                trackGiants          = 19882,
                trackHidden          = 19885,
                trackHumanoids       = 19883,
                trackMechanicals     = 229533,
                trackUndead          = 19884,
                wingClip             = 195645,
                -- Pet Management
                beastLore            = 1462,
                callPet              = 9,
                callPet1             = 883,
                callPet2             = 83242,
                callPet3             = 83243,
                callPet4             = 83244,
                callPet5             = 83245,
                commandPet           = 272651,
                dismissPet           = 2641,
                feedPet              = 6991,
                fetch                = 125050,
                mendPet              = 136,
                playDead             = 209997,
                revivePet            = 982,
                tameBeast            = 1515,
                wakeUp               = 210000,
                ----------------------------
                -- Pet - Basic Abilities ---
                ----------------------------
                bite                 = 17253, -- Basalisk, Bat, Beetle, Blood Beast, Boar, Carapid, Carrion Bird, Chimera, Core Hound, Crocolisk, Devilsaur, Direhorn, Dragonhawk, Feathermane, Fox, Hound, Hydra, Hyena, Lizard, Mechanical, Pterrordax, Ravager, Ray, Riverbeast, Serpent, Shale Beast, Spider, Stone Hound, Turtle, Warp Stalker, Water Strider, Wind Serpent, Wolf, Worm
                claw                 = 16827, -- Aqiri, Bear, Bird of Prey, Cat, Crab, Raptor, Rodent, Scorpid, Spirit Beast, Tallstrider
                dash                 = 61684, -- Speed Increase (ALL PETS)
                smack                = 49966, -- Camel, Clefthoof, Courser, Crane, Gorilla, Gruffhorn, Mammoth, Monkey, Moth, Oxen, Scalehide, Sporebat, Stag, Toad, Wasp
                growl                = 2649,  -- Taunt (ALL PETS)
                ---------------------------
                -- Pet - Spec Abilities ---
                ---------------------------
                primalRage           = 264667, -- Ferocity Dmg Cd
                -- survivalOfTheFittest = 264735, -- Tenacity Def Cd
                mastersCall          = 53271,  -- Cunning Freedom
                ------------------------------
                -- Pet - Special Abilities ---
                ------------------------------
                -- AOE
                burrowAttack         = 93433,  -- Worm
                froststormBreath     = 92380,  -- Chimera - Channeled Cone AOE
                -- Defense/Dodge
                agileReflexes        = 160011, -- Fox - Dodge
                bristle              = 263869, -- Boar - Defensive
                bulwark              = 279410, -- Carapid - Defensive
                catlikeReflexes      = 263892, -- Cat - Dodge
                defenseMatrix        = 263868, -- Mechanical - Defensive
                dragonsGuile         = 263887, -- Dragonhawk - Dodge
                featherFlurry        = 263916, -- Feathermane - Dodge
                fleethoof            = 341117, -- Courser - Dodge
                hardenCarapace       = 90339,  -- Beetle - Defensive
                obsidianSkin         = 263867, -- Core Hound - Defensive
                primalAgility        = 160044, -- Monkey - Dodge
                scaleShield          = 263865, -- Scalehide - Defensive
                serpentSwiftness     = 263904, -- Serpent - Dodge
                shellShield          = 26064,  -- Turtle - Defensive
                solidShell           = 160063, -- Shale Beast - Defensive
                swarmOfFlies         = 279336, -- Toad - Dodge
                wingedAgility        = 264360, -- Wind Serpent - Dodge
                -- Dispel
                chiJiTranq           = 344350, -- Crane
                naturesGrace         = 344352, -- Stag
                netherEnergy         = 344349, -- Ray -- netherEnergy
                serenityDust         = 344353, -- Moth
                sonicScreech         = 344348, -- Bat -- sonicScreech
                soothingWater        = 344346, -- Water Strider
                spiritPulse          = 344351, -- Spirit Beast -- spiritPulse
                sporeCloud           = 344347, -- Sporebat
                -- Heal
                eternalGuardian      = 267922, -- Stone Hound - Ressurect
                feast                = 159953, -- Devilsaur - Heal (req dead humanoid/beast nearby)
                spiritmend           = 90361,  -- Spirit Beast - Heal
                -- Mortal Wounds Debuff
                acidBite             = 263863, -- Hydra - Mortal Wounds Debuff
                bloodyScreech        = 24423,  -- Carrion Bird - Mortal Wounds Debuff
                deadlySting          = 160060, -- Scorpid - Mortal Wounds Debuff
                gnaw                 = 263856, -- Rodent - Mortal Wounds Debuff
                gore                 = 263861, -- Direhorn - Mortal Wounds Debuff
                grievousBite         = 279362, -- Lizard - Mortal Wounds Debuff
                gruesomeBite         = 160018, -- Riverbeast - Mortal Wounds Debuff
                infectedBite         = 263853, -- Hyena - Mortal Wounds Debuff
                monsterousBite       = 54680,  -- Devilsaur - Mortal Wounds Debuff
                ravage               = 263857, -- Ravager - Mortal Wounds Debuff
                savageRend           = 263854, -- Savage Rend - Mortal Wounds Debuff
                toxicSting           = 263858, -- Wasp - Mortal Wounds Debuff
                -- Slow
                acidSpit             = 263446, -- Worm - Slow
                ankleCrack           = 50433,  -- Crocolisk - Slow
                bloodBolt            = 288962, -- Blood Beast - Slow
                dustCloud            = 50285,  -- Tallstrider - Slow
                frostBreath          = 54644,  -- Chimera - Slow
                furiousBite          = 263840, -- Wolf - Slow
                lockJaw              = 263423, -- Hound - Slow
                petrifyingGaze       = 263841, -- Basilisk - Slow
                pin                  = 50245,  -- Crab - Slow
                talonRend            = 263852, -- Bird of Prey - Slow
                tendonRip            = 160065, -- Aqiri - Slow
                trample              = 341118, -- Mammoth - Slow
                warpTime             = 35346,  -- Warp Stalker - Slow
                webSpray             = 160067, -- Spider - Slow
                -- Slow Fall
                updraft              = 160007, -- Feathermane/Pterrordax - Slow Fall
                -- Stealth
                prowl                = 24450,  -- Stealth
                spiritWalk           = 90328,  -- Spirit Beast - Stealth
                -- Tricks / Play / Rest
                play                 = 90347,  -- Fox
                restBear             = 94019,  -- Bear
                restRodent           = 126364, -- Rodent
                trickCrane           = 126259, -- Crane
                trickBirdOfPrey      = 94022,  -- Bird of Prey
                -- Water Walking
                surfaceTrot          = 126311, -- Water Strider - Water Walking
            },
            animas        = {
                soulforgeEmbers = 331197,
            },
            artifacts     = {

            },
            buffs         = {
                aspectOfTheTurtle            = 186265,
                eagletalonsTrueFocus         = 336851,
                feignDeath                   = 5384,
                flayersMark                  = 324156, -- Covenant
                killingFrenzy                = 363665, -- T28 4pc
                mendPet                      = 136,
                nesingwarysTrappingApparatus = 336744,
                playDead                     = 209997,
                prowl                        = 24450,
                resonatingArrow              = 356263, -- Covenant
                spiritWalk                   = 90328,
                surfaceTrot                  = 126311, -- Water Strider - Water Walking
                updraft                      = 160007, -- Feathermane/Pterrordax - Slow Fall
                volley                       = 260243,
                wildSpirits                  = 328231,
            },
            conduits      = {
                bloodletting       = 341440,
                marksmansAdvantage = 339264,
            },
            covenants     = {
                flayedShot      = 324149,
                resonatingArrow = 308491,
                wildSpirits     = 328231,
            },
            debuffs       = {
                bestialFerocity = 191413,
                freezingTrap    = 3355,
                huntersMark     = 257284,
                intimidation    = 24934,
                latentPoison    = 378015,
                mortalWounds    = 115804, -- Pet Ability Debuff
                resonatingArrow = 308498, -- Covenant
                soulforgeEmbers = 331269, -- Covenant
                tarTrap         = 135299,
                wildMark        = 328275, -- Covenant
            },
            glyphs        = {

            },
            interrupts    = {
                freezingTrap = 187650,
            },
            runeforges    = {
                bagOfMunitions                  = 356264,
                eagletalonsTrueFocus            = 336849,
                nesingwarysTrappingApparatus    = 336743,
                pouchOfRazorFragments           = 356618,
                rylakstalkersConfoundingStrikes = 336901,
                secretsOfTheUnblinkingVigil     = 336878,
                serpentstalkersTrickery         = 336870,
                soulforgeEmbers                 = 336745,
                surgingShots                    = 336867,
                qaplaEredunWarOrder             = 336830,
            },
            talents       = {
                bindingShot           = 109248,
                blackrockMunitions    = 462036,
                bornToBeWild          = 266921,
                burstingShot          = 186387,
                camouflage            = 199483,
                concussiveShot        = 5116,
                counterShot           = 147362,
                devilsaurTranquilizer = 459991,
                disruptiveRounds      = 343244,
                emergencySalve        = 459517,
                entrapment            = 393344,
                ghillieSuit           = 459466,
                highExplosiveTrap     = 236776,
                huntersAvoidance      = 384799,
                implosiveTrap         = 462031,
                improvedKillShot      = 343248,
                improvedTraps         = 343247,
                intimidation          = 19577,
                keenEyesight          = 378004,
                kindlingFlare         = 459506,
                kodoTranquilizer      = 459983,
                loneSurvivor          = 388039,
                misdirection          = 34477,
                momentOfOpportunity   = 459488,
                naturalMending        = 270581,
                noHardFeelings        = 459546,
                paddedArmor           = 459450,
                pathfinding           = 378002,
                posthaste             = 109215,
                quickLoad             = 378771,
                rejuvenatingWind      = 385539,
                roarOfSacrifice       = 53480,
                scareBeast            = 1513,
                scatterShot           = 213691,
                scoutsInstincts       = 459455,
                scrappy               = 459533,
                serratedTips          = 459502,
                survivalOfTheFittest  = 264735,
                specializedArsenal    = 459542,
                tarTrap               = 187698,
                tarcoatedBindings     = 459460,
                territorialInstincts  = 459507,
                trailblazer           = 199921,
                tranquilizingShot     = 19801,
                triggerFinger         = 459534,
                unnaturalCauses       = 459527,
                wildernessMedicine    = 343242,
            },
            talentsHeroic = {
                -- Dark Ranger
                blackArrow         = 430703,
                darkChains         = 430712,
                darkEmpowerment    = 430718,
                deathShade         = 430711,
                darknessCalls      = 430722,
                embraceTheShadows  = 430704,
                graveReaper        = 430719,
                overshadow         = 430716,
                shadowErasure      = 430720,
                shadowHounds       = 430707,
                shadowLash         = 430717,
                shadowSurge        = 430714,
                smokeScreen        = 430709,
                witheringFire      = 430715,
                -- Pack Leader
                beastOfOpportunity = 445700,
                corneredPrey       = 445702,
                coveringFire       = 445715,
                cullTheHerd        = 445717,
                denRecovery        = 445710,
                frenziedTear       = 445696,
                furiousAssault     = 445699,
                howlOfThePack      = 445707,
                packAssault        = 445721,
                packCoordination   = 445505,
                scatteredPrey      = 445768,
                tirelessHunt       = 445701,
                viciousHunt        = 445404,
                wildAttacks        = 445708,
                -- Sentinel
                catchOut           = 451516,
                crescentSteel      = 451530,
                extrapolatedShots  = 450374,
                eyesClosed         = 450381,
                dontLookBack       = 450373,
                invigoratingPulse  = 450379,
                lunarStorm         = 450385,
                overwatch          = 450384,
                releaseAndReload   = 450376,
                sentinel           = 450369,
                sentinelPrecision  = 450375,
                sentinelWatch      = 451546,
                sideline           = 450378,
                symphonicArsenal   = 450383,
            },
        },
    },
    MAGE = {
        -- Arcane
        [62] = {
            abilities = {
                alterTime           = 342245,
                arcaneBarrage       = 44425,
                arcaneBlast         = 30451,
                arcaneFamiliar      = 205022,
                arcaneMissiles      = 5143,
                arcaneOrb           = 153626,
                arcanePower         = 12042,
                chargedUp           = 205032,
                conjuremanaGem      = 759,
                displacement        = 212801,
                erosion             = 205039,
                evocation           = 12051,
                --  fireblast                   = 519836,
                greaterInvisibility = 110959,
                markOfAluneth       = 224968,
                netherTempest       = 114923,
                presenceofMind      = 205025,
                prismaticBarrier    = 235450,
                runeofPower         = 116011,
                slow                = 31589,
                supernova           = 157980,
                touchOfTheMagi      = 321507,
            },
            artifacts = {
                aegwynnsAscendance       = 187680,
                aegwynnsFury             = 187287,
                aegwynnsInperative       = 187264,
                aegwynnsIntensity        = 238054,
                aegwynnsWrath            = 187321,
                alunethsAvarice          = 238090,
                ancientPower             = 214917,
                arcanePurification       = 187313,
                arcaneRebound            = 188006,
                blastingRod              = 187258,
                cracklingEnergy          = 187310,
                etherealSensitivity      = 187276,
                everywhereAtOnce         = 187301,
                forceBarrier             = 210716,
                intensityOfTheTirisgarde = 241121,
                markOfAluneth            = 224968,
                mightOfTheGuardians      = 187318,
                ruleOfThrees             = 215463,
                sloooowDown              = 210730,
                timeAndSpace             = 238126,
                torrentialBarrage        = 187304,
                touchOfTheMagi           = 210725,
            },
            buffs     = {
                arcaneCharge              = 36032,
                arcaneFamiliar            = 210126,
                arcanePower               = 12042,
                -- arcaneCharge                  = 36032,
                evocation                 = 12051,
                expandedPotential         = 327495,
                arcaneMissles             = 79683,
                presenceOfMind            = 205025,
                prismaticBarrier          = 235450,
                rhoninsAssaultingArmwraps = 208081,
                runeofPower               = 116011,
                ruleOfThrees              = 264774,
                brainStorm                = 273330,
                clearcasting              = 263725,
            },
            debuffs   = {
                arcaneCharge   = 36032,
                netherTempest  = 114923,
                touchoftheMagi = 210824,


            },
            glyphs    = {

            },
            talents   = {
                arcaneEcho     = 342231,
                amplification  = 236628,
                arcaneFamiliar = 205022,
                arcaneOrb      = 153626,
                chronoShift    = 235711,
                mastersOfTime  = 342249,
                --erosion                     = 205039,
                netherTempest  = 114923,
                overpowered    = 155147,
                resonance      = 205028,
                reverberate    = 281482,
                rulesOfThrees  = 264354,
                slipstream     = 236457,
                supernova      = 157980,
                timeAnomaly    = 210805
                --temporalFlux                = 234302,
                --wordsOfPower                = 205035,
            },
            traits    = {
                anomalousImpact  = 279867,
                arcanePressure   = 274594,
                arcanePummeling  = 270669,
                brainStorm       = 273326,
                explosiveEcho    = 278537,
                galvanizingSpark = 278536,
            },
        },
        -- Fire
        [63] = {
            abilities  = {
                alterTime           = 108978,
                blazingBarrier      = 235313,
                blastWave           = 157981,
                cinderstorm         = 198929,
                combustion          = 190319,
                dragonsBreath       = 31661,
                disciplinaryCommand = 327365,
                fireball            = 133,
                fireBlast           = 108853,
                fireBlast2          = 319836,
                flameOn             = 205029,
                flamestrike         = 2120,
                infernalCascade     = 336821,
                livingBomb          = 44457,
                meteor              = 153561,
                phoenixFlames       = 257541,
                pyroblast           = 11366,
                shiftingPower       = 314791,
                scorch              = 2948,
                soulIgnition        = 345211,
            },
            artifacts  = {
                aftershocks   = 194431,
                phoenixReborn = 215773,
            },
            buffs      = {
                blazingBarrier           = 235313,
                blasterMaster            = 274598,
                combustion               = 190319,
                disciplinaryArcane       = 327369,
                disciplinaryCommand      = 327365,
                disciplinaryCommandFrost = 327366,
                disciplinaryCommandFire  = 327368,
                firestorm                = 333097,
                heatingUp                = 48107,
                hotStreak                = 48108,
                iceFloes                 = 108839,
                infernalCascade          = 336832,
                kaelthasUltimateAbility  = 209455,
                preheat                  = 273333,
                pyroclasm                = 269651,
                shiftingPower            = 314791,
                sunKingsBlessings        = 333313,
                soulIgnition             = 345211,
            },
            debuffs    = {
                ignite     = 12654,
                meteorBurn = 155158,
                cauterized = 87024,

            },
            glyphs     = {

            },
            talents    = {
                alexstraszasFury = 235870,
                blastWave        = 157981,
                blazingSoul      = 235365,
                --cinderstorm                 = 198929,
                conflagration    = 205023,
                --controlledBurn              = 205033,
                freneticSpeed    = 236058,
                firestarter      = 205026,
                flameOn          = 205029,
                flamePatch       = 205037,
                kindling         = 155148,
                livingBomb       = 44457,
                meteor           = 153561,
                focusMagic       = 321358,
                fromTheAshes     = 342344,
                pyromaniac       = 205020,
                pyroclasm        = 269650,
                searingTouch     = 269644,
            },
            covenants  = {
                shiftingPower = 314791,
            },
            traits     = {
                preheat       = 273332,
                blasterMaster = 274596,
            },
            conduits   = {
                infernalCascade = 336821,
            },
            runeforges = {
                firestorm           = 333097,
                grislyIcicle        = 333393,
                disciplinaryCommand = 327365,
                sunKingsBlessings   = 333313
            }
        },
        -- Frost
        [64] = {
            abilities = {
                alterTime            = 108978,
                blizzard             = 190356,
                coldSnap             = 235219,
                coneOfCold           = 120,
                --fireBlast                   = 108853, - Fire Mage version, Frost should not have this and already listed fireBlast below
                flurry               = 44614,
                freeze               = 231596,
                frostbolt            = 116,
                frostBomb            = 112948,
                frozenOrb            = 84714,
                frozenTouch          = 205030,
                fireBlast            = 319836,
                iceBarrier           = 11426,
                iceFloes             = 108839,
                iceForm              = 198144,
                iceLance             = 30455,
                iceNova              = 157997,
                icyVeins             = 12472,
                petFreeze            = 33395,
                rayOfFrost           = 205021,
                runeofPower          = 116011,
                removeCurse          = 475,
                summonWaterElemental = 31687,
                waterbolt            = 31707,
            },
            artifacts = {
                -- icyHand                     = 220817,
            },
            buffs     = {
                brainFreeze          = 190446,
                concentratedCoolness = 198148,
                freezingRain         = 270232,
                frostBomb            = 112948,
                fingersOfFrost       = 44544,
                icyVeins             = 12472,
                chainReaction        = 195418,
                zannesuJourney       = 226852,
                timeWarp             = 80353,
                iceFloes             = 108839,
                iceForm              = 198144,
                iceBarrier           = 11426,
                icicles              = 205473,
                frozenMass           = 242253,
            },
            debuffs   = {
                chainsOfIce  = 65173,
                chilled      = 205708,
                frostBomb    = 112948,
                frostNova    = 122,
                iceNova      = 157997,
                wintersChill = 228358,
            },
            glyphs    = {

            },
            talents   = {
                --articGale                   = 205038,
                boneChilling      = 205027,
                cometStorm        = 153595,
                chainReaction     = 278309,
                ebonbolt          = 257537,
                --frostBomb                   = 112948,
                frozenTouch       = 205030,
                frigidWinds       = 235224,
                freezingRain      = 270233,
                focusMagic        = 321358,
                glacialSpike      = 199786,
                glacialInsulation = 235297,
                iceNova           = 157997,
                iceFloes          = 108839,
                lonelyWinter      = 205024,
                rayOfFrost        = 205021,
                splittingIce      = 56377,
                thermalVoid       = 155149,
            },
        },
        -- All
        Shared = {
            abilities  = {
                fireBlast          = 319836,
                frostbolt          = 116,
                arcaneIntellect    = 1459,
                arcaneExplosion    = 1449,
                blink              = 1953,
                counterspell       = 2139,
                conjureRefreshment = 190336,
                --  fireBlast                   = 319836,
                frostBolt          = 116,
                frostNova          = 122,
                iceBlock           = 45438,
                invisibility       = 66,
                mirrorImage        = 55342,
                polymorph          = 118,
                removeCurse        = 475,
                ringOfFrost        = 113724,
                runeOfPower        = 116011,
                --shimmer                     = 212653,
                slowFall           = 130,
                spellsteal         = 30449,
                teleportExodar     = 32271,
                timeWarp           = 80353,
                waterJet           = 135029,
            },
            artifacts  = {

            },
            buffs      = {
                arcaneIntellect     = 1459,
                disciplinaryCommand = 327365,
                expandedPotential   = 327489,
                focusMagic          = 321358,
                freezingWinds       = 327364,
                iceBlock            = 45438,
                incantersFlow       = 1463,
                slowFall            = 130,
                slickIce            = 327509,
                runeOfPower         = 116014,
            },
            conduits   = {

            },
            covenants  = {
                deathborne       = 324220,
                mirrorsOfTorment = 314793,
                radiantSpark     = 307443,
                shiftingPower    = 314791,
            },
            debuffs    = {
                frostNova        = 122,
                mirrorsOfTorment = 314793,
            },
            glyphs     = {

            },
            runeforges = {
                disciplinaryCommand = 327365,
                sunKingsBlessings   = 333313,
                grislyIcicle        = 333393,
                firestorm           = 333097,

            },
            talents    = {
                incantersFlow = 1463,
                iceWard       = 205036,
                focusMagic    = 321358,
                ringOfFrost   = 113724,
                runeOfPower   = 116011,
                shimmer       = 212653,
                --unstableMagic               = 157976,
            },
        },
    },
    MONK = {
        -- Brewmaster
        [268] = {
            abilities = {
                blackoutKick      = 205523,
                breathOfFire      = 115181,
                celestialBrew     = 322507,
                clash             = 324312,
                invokeNiuzao      = 132578,
                kegSmash          = 121253,
                purifyingBrew     = 119582,
                spinningCraneKick = 322729,
                zenMeditation     = 115176
            },
            artifacts = {

            },
            buffs     = {
                eyeOfTheTiger          = 196608,
                ironskinBrew           = 215479,
                blackoutCombo          = 228563,
                purifiedChi            = 325092,
                rushingJadeWind        = 116847,
                zenMeditation          = 115176,
                celestialBrew          = 322507,
                invokeNiuzao           = 132578,
                counterStrike          = 383800,
                hitScheme              = 383696,
                shuffle                = 322120,
                invokeNiuzaoTheBlackOx = 132578,
                weaponsOfOrder         = 387184,
                charredPassions        = 386965,
                bonedustBrew           = 386276,
            },
            debuffs   = {
                breathOfFire    = 146222,
                moderateStagger = 124274,
                heavyStagger    = 124273,
                kegSmash        = 121253,
                weaponsOfOrder  = 387184,
                bonedustBrew    = 386276,

            },
            glyphs    = {

            },
            talents   = {
                blackoutCombo                  = 196736,
                blackOxBrew                    = 115399,
                blackOxStatue                  = 115399,
                bobAndWeave                    = 280515,
                celestialFlame                 = 325177,
                explodingKeg                   = 325153,
                eyeOfTheTiger                  = 196607,
                healingElixir                  = 122281,
                highTolerance                  = 196737,
                lightBrewing                   = 325093,
                rushingJadeWind                = 116847,
                specialDelivery                = 196730,
                summonBlackOxStatue            = 115315,
                detox                          = 218164,
                improvedPurifyingBrew          = 343743,
                invokeNiuzaoTheBlackOx         = 132578,
                improvedInvokeNiuzaoTheBlackOx = 322740,
                weaponsOfOrder                 = 387184,
                charredPassions                = 386965,
                pressTheAdvantage              = 418359,
                bonedustBrew                   = 386276,
            },
        },
        -- Mistweaver
        [270] = {
            abilities  = {

                envelopingMist            = 124682,
                essenceFont               = 191837,
                invokeYulon               = 322118,
                reawaken                  = 212051,
                renewingMist              = 115151,
                revival                   = 115310,
                risingSunKick             = 107428,
                soothingMist              = 115175,
                thunderFocusTea           = 116680,
                invokeYulonTheJadeSerpent = 322118,
                invokeChiJiTheRedCrane    = 325197,
                fortifyingBrew            = 243435,
                zenFocusTea               = 209584,
                transcendenceTransfer     = 119996,
                sheilunsGift              = 399491,
                detox                     = 115450,
                manaTea                   = 115294,
            },
            artifacts  = {
            },
            buffs      = {
                weaponsOfOrder                = 310454,
                fortifyingBrew                = 243435,
                soothingMist                  = 115175,
                renewingMist                  = 115151,
                envelopingMist                = 124682,
                thunderFocusTea               = 116680,
                lifeCyclesEnvelopingMist      = 197919,
                lifeCyclesVivify              = 197916,
                surgeOfMist                   = 246328,
                danceOfMist                   = 247891,
                upliftTrance                  = 197206,
                refreshingJadeWind            = 196725,
                lifeCocoon                    = 116849,
                transcendence                 = 101643,
                tigersLust                    = 116841,
                teachingsOfTheMonastery       = 202090,
                diffuseMagic                  = 122783,
                dempenHarm                    = 122278,
                innervate                     = 29166,
                symbolOfHope                  = 64901,
                wayOfTheCrane                 = 216113,
                essenceFont                   = 191840,
                risingMist                    = 22170,
                soothingMistJadeStatue        = 198533,
                envelopingBreath              = 325209,
                invokeChiJiTheRedCrane        = 343820,
                ancientTeachingOfTheMonastery = 347553,
                fallenOrder                   = 326860,
                vivaciousVivification         = 392883,
                rushingJadeWind               = 116847,
                ancientTeachings              = 388023,
                sheilunsGift                  = 399491,
                manaTea                       = 115867,
            },
            debuffs    = {
                mysticTouch = 113746,
            },
            glyphs     = {
            },
            talents    = {
                diffuseMagic              = 122783,
                focusedThunder            = 197895,
                invokeChiJiTheRedCrane    = 325197,
                lifecycles                = 197915,
                mistWrap                  = 197900,
                refreshingJadeWind        = 196725,
                risingMist                = 274909,
                songOfChiJi               = 198898,
                summonJadeSerpentStatue   = 115313,
                upwelling                 = 274963,
                faelineStomp              = 388193,
                zenPulse                  = 124081,
                ancienTeachings           = 388023,
                invokeYulonTheJadeSerpent = 322118,
                lifeCocoon                = 116849,
                sheilunsGift              = 399491,
                spearHandStrike           = 116705,
                --manaTea                     = 197908,

            },
            runeforges = {
                ancientTeachingsOfTheMonastery = 337172,
                tearOfMorning                  = 337473,
            }
        },
        -- Windwalker
        [269] = {
            abilities  = {
                disable                 = 116095,
                fistsOfFury             = 113656,
                flyingSerpentKick       = 101545,
                flyingSerpentKickEnd    = 115057,
                fortifyingBrew          = 243435,
                invokeXuenTheWhiteTiger = 123904,
                risingSunKick           = 107428,
                stormEarthAndFire       = 137639,
                stormEarthAndFireFixate = 221771,
                touchOfKarma            = 122470,
                grappleWeapon           = 233759,
                fallenOrder             = 326860,
                flashcraft              = 324631,
                summonWhiteTigerStatue  = 388686,
            },
            artifacts  = {

            },
            buffs      = {
                alphaTiger              = 287504,
                fortifyingBrew          = 243435,
                invokersDelight         = 338321,
                blackoutKick            = 116768,
                chiEnergy               = 337571,
                danceOfChiJi            = 325202,
                hitCombo                = 196741,
                pressurePoint           = 247255,
                rushingJadeWind         = 116847,
                serenity                = 152173,
                stormEarthAndFire       = 137639,
                swiftRoundhouse         = 278710,
                theEmperorsCapacitor    = 235054,
                touchOfKarma            = 122470,
                transferThePower        = 195321,
                whirlingDragonPunch     = 152175,
                fallenOrder             = 326860,
                bonedustBrew            = 325216,
                teachingsOfTheMonastery = 202090,
            },
            debuffs    = {
                disable            = 116095,
                disableRoot        = 116706,
                markOfTheCrane     = 228287,
                mortalWounds       = 115804,
                risingFist         = 242259,
                skyreachExhaustion = 337341,
                jadefireBrand      = 395414,
            },
            glyphs     = {
                glyphOfRisingTigerKick = 125151,
            },
            talents    = {
                ascension           = 115396,
                danceOfChiJi        = 325201,
                diffuseMagic        = 122783,
                eyeOfTheTiger       = 196607,
                hitCombo            = 196740,
                rushingJadeWind     = 116847,
                serenity            = 152173,
                spiritualFocus      = 280197,
                strikeOfTheWindlord = 392983,
                whirlingDragonPunch = 152175,
                skyreach            = 392991,
                skytouch            = 405044,
                detox               = 218164,
                jadefireHarmony     = 391412,
                bonedustBrew        = 386276,
                stormEarthAndFire   = 137639,
                jadefireStomp       = 388193,

            },
            traits     = {
                gloryOfTheDawn  = 288634,
                openPalmStrikes = 279918,
                swiftRoundhouse = 277669,
            },
            runeforges = {
                fatalTouch = 337296
            }
        },
        -- All
        Shared = {
            abilities = {
                blackoutKick           = 100784,
                cracklingJadeLightning = 117952,
                expelHarm              = 322101,
                legSweep               = 119381,
                provoke                = 115546,
                resuscitate            = 115178,
                roll                   = 109132,
                spinningCraneKick      = 101546,
                tigerPalm              = 100780,
                touchOfDeath           = 322109,
                touchOfFatality        = 169340,
                vivify                 = 116670,
                zenFlight              = 125883,
                zenPilgrimage          = 126892,
                zenPilgrimageReturn    = 126895,
            },
            artifacts = {

            },
            buffs     = {
                theEmperorsCapacitor   = 235054,
                transcendence          = 101643,
                weaponsOfOrder         = 328908, --310454,
                weaponsOfOrderWW       = 310454, --311054,
                prideful               = 340880,
                vivaciousVivification  = 392883,
                powerStrikes           = 129914, --bonus chi proc buff
                hitCombo               = 196741,
                kicksOfFlowingMomentum = 394944,
                blackoutReinforcement  = 424454,
            },
            conduits  = {
                calculatedStrikes    = 336526,
                coordinatedOffensive = 336598,
                pustuleEruption      = 351094
            },
            covenants = {
                bonedustBrew   = 325216,
                faelineStomp   = 327104,
                fallenOrder    = 326860,
                weaponsOfOrder = 310454,
            },
            debuffs   = {
                bonedustBrew = 325216,
            },
            glyphs    = {

            },
            talents   = {
                bounceBack               = 389577,
                calmingPresence          = 388664,
                celerity                 = 115173,
                chiBurst                 = 123986,
                chiTorpedo               = 115008,
                chiWave                  = 115098,
                closeToHeart             = 389574,
                dampenHarm               = 122278,
                disable                  = 116095,
                elusiveMists             = 388681,
                escapeFromReality        = 394110,
                expeditiousFortification = 388813,
                fastFeet                 = 388809,
                fatalTouch               = 394123,
                ferocityOfXuen           = 388674,
                generousPour             = 389575,
                graceOfTheCrane          = 388811,
                hastyProvocation         = 328670,
                improvedParalysis        = 344359,
                improvedRoll             = 328669,
                improvedTouchOfDeath     = 322113,
                ironshellBrew            = 388814,
                paralysis                = 115078,
                profoundRebuttal         = 392910,
                resonantFists            = 389578,
                ringOfPeace              = 116844,
                risingSunKick            = 107428,
                saveThemAll              = 389579,
                spearHandStrike          = 116705,
                strengthOfSpirit         = 387276,
                summonWhiteTigerStatue   = 388686,
                tigerTailSweep           = 264348,
                tigersLust               = 116841,
                transcendence            = 101643,
                vigorousExpulsion        = 392900,
                vivaciousVivication      = 388812,
                windwalking              = 157411,
            },
        },
    },
    PALADIN = {
        -- Holy
        [65] = {
            abilities  = {
                absolution       = 212056,
                auraMastery      = 31821,
                barrierOfFaith   = 148039,
                beaconOfFaith    = 156910,
                beaconOfLight    = 53563,
                beaconOfVirtue   = 200025,
                blessingOfAutumn = 388010,
                blessingOfSpring = 388013,
                blessingOfSummer = 388007,
                blessingOfWinter = 388011,
                cleanse          = 4987,
                divineProtection = 498,
                holyLight        = 82326,
                holyShock        = 20473,
                lightOfDawn      = 85222,
                lightOfTheMartyr = 183998,
                --lightsHammer     = 114158,

            },
            artifacts  = {

            },
            buffs      = {
                --sealOfClarity        = 384810,
                avengingCrusader     = 216331,
                auraMastery          = 31821,
                avengingWrath        = 31884,
                avengingWrathCrit    = 294027,
                afterimage           = 400745,
                beaconOfLight        = 53563,
                beaconOfFaith        = 156910,
                blessingOfSacrifice  = 6940,
                beaconOfVirtue       = 200025,
                --bestowFaith          = 223306,
                --glimmerOfLight       = 287280,
                blessingOfDawn       = 337747,
                blessingOfDusk       = 385126,
                divineProtection     = 498,
                divinePurpose        = 223819,
                --ferventMartyr        = 223316,
                infusionOfLight      = 54149,
                innervate            = 29166,
                --ruleOfLaw            = 214202,
                liberation           = 461471,
                --theLightSaves        = 200423,
                vindicator           = 200376,
                symbolOfHope         = 64901,
                divineSteed          = 254474,
                --maraadsBreath        = 340459,
                unendingLight        = 394709,
                untemperedDedication = 339990,
                veneration           = 392939,
            },
            debuffs    = {
                judgement       = 214222,
                judgmentOfLight = 196941,
                --glimmerOfLight  = 287280,
                consecration    = 204242,
                dawnWillCome    = 364851,

            },
            glyphs     = {

            },
            talents    = {
                avengingCrusader = 216331,
                --awakening        = 248033,
                beaconOfFaith    = 156910,
                beaconOfVirtue   = 200025,
                --bestowFaith      = 223306,
                blessingOfSummer = 388007,
                breakingDawn     = 387879,
                crusadersMight   = 196926,
                --glimmerOfLight   = 325966,
                holyPrism        = 114165,
                judgmentOfLight  = 183778,
                --lightsHammer     = 114158,
                --ruleOfLaw        = 214202,
                --sanctifiedWrath            = 53376,
                savedByTheLight  = 157047,
                divineToll       = 375576,
            },
            traits     = {
                graceoftheJusticar = 278593,
                indomitableJustice = 275496,
            },
            runeforges = {
                shadowbreaker      = 337812,
                shockBarrier       = 337825,
                maraadsDyingBreath = 340458,
            }
        },
        -- Protection
        [66] = {
            abilities = {
                ardentDefender         = 31850,
                avengersShield         = 31935,
                blessedHammer          = 229976,
                cleanseToxins          = 213644,
                divineProtection       = 498,
                guardianOfAncientKings = 86659,
                hammerOfTheRighteous   = 53595,
                judgment               = 275779,
                judgmentsOfTheWise     = 105424,
                rebuke                 = 96231,
                righteousFury          = 25780,
            },
            artifacts = {

            },
            buffs     = {
                ardentDefender         = 31850,
                avengingWrath          = 31884,
                blessingOfSpellwarding = 204018,
                bulwarkOfOrder         = 209388,
                consecration           = 188370,
                divineShield           = 642,
                divinePurpose          = 223819,
                guardianOfAncientKings = 86659,
                shieldOfTheRighteous   = 132403,
                shiningLight           = 327510,
                avengersValor          = 197561,
                divineSteed            = 254474,
                royalDecree            = 340147,
            },
            debuffs   = {
                blessedHammer   = 204301,
                judgmentOfLight = 196941,
                judgment        = 197277,
            },
            glyphs    = {

            },
            talents   = {
                layOnHands                = 633,
                blessedHammer             = 204019,
                hammerOfTheRighteous      = 53595,
                innerLight                = 386568,
                redoubt                   = 280373,
                holyShield                = 152261,
                grandCrusader             = 85043,
                -- shiningLight                = 321136, -- No longer a talent?
                consecratedGround         = 204054,
                improvedLayOnHands        = 393027,
                inspiringVanguard         = 393022,
                ardentDefender            = 31850,
                barricadeOfFaith          = 385726,
                consecrationInFlame       = 379022,
                improvedHolyShield        = 393030,
                sanctuary                 = 379021,
                bulwarkOfOrder            = 209389,
                improvedArdentDefender    = 393114,
                blessingOfSpellwarding    = 204018,
                lightOfTheTitans          = 378405,
                strengthInAdversity       = 393071,
                crusadersResolve          = 380188,
                tyrsEnforcer              = 378285,
                relentlessInquisitor      = 383388,
                aveningWrathMight         = 31884,
                sentinel                  = 389539,
                handOTheProtector         = 315924,
                strengthOfConviction      = 379008,
                resoluteDefender          = 385422,
                bastionOfLight            = 378974,
                guardianOfAncientKings    = 86659,
                crusadersJudgement        = 204023,
                uthersCounsel             = 378425,
                focusedEnmity             = 378845,
                soaringShield             = 378457,
                giftOfTheGoldenValkyr     = 378279,
                eyeOfTyr                  = 387174,
                righteousProtector        = 204074,
                faithInTheLight           = 379043,
                ferrenMarcussFervor       = 378762,
                faithsArmor               = 379017,
                finalStand                = 204077,
                divineToll                = 375576,
                momentOfGlory             = 327193,
                bulwarkOfTheRighteousFury = 386653,
                divineResonance           = 386738,
                quickenedInvocations      = 379391,
            },
            traits    = {
                bulwarkOfLight = 272976,
            },
        },
        -- Retribution
        [70] = {
            abilities = {
                divineProtection = 403876,
                templarSlash     = 406647,
                templarStrike    = 407480,
                templarsVerdict  = 85256,
            },
            artifacts = {

            },
            buffs     = {
                crusade        = 231895,
                divineArbiter  = 406975,
                divinePurpose  = 223819,
                divineRight    = 278523,
                empyreanLegacy = 387178,
                empyreanPower  = 326733, --286393,
                finalVerdict   = 414949,
                selflessHealer = 114250,
                templarStrikes = 406648,
            },
            debuffs   = {
                executionSentence = 267798,
                expurgation       = 383346,
                finalReckoning    = 343721,
            },
            glyphs    = {
                glyphOfWingedVengeance = 57979,
            },
            talents   = {
                abjudication             = 406157, --
                aegisOfProtection        = 403654, --
                artOfWar                 = 406064, --
                avengingWrathMight       = 31884,  --
                bladeOfJustice           = 184575, --
                bladeOfVengeance         = 403826, --
                bladesOfLight            = 403664, --
                blessedChampion          = 403010, --
                boundlessJudgment        = 405278, --
                burningCrusade           = 405289, --
                consecratedBlade         = 404834, --
                consecratedGround        = 204054, --
                crusade                  = 231895, --
                crusadingStrikes         = 404542, --
                divineArbiter            = 404306, --
                divineAuxiliary          = 406158, --
                divineHammer             = 198034, --
                divineStorm              = 53385,  --
                divineWrath              = 406872, --
                empyreanLegacy           = 387170, --
                empyreanPower            = 326732, --
                executionSentence        = 343527, --
                executionersWill         = 406940, --
                expurgation              = 383344, --
                finalReckoning           = 343721, --
                finalVerdict             = 383328, --
                guidedPrayer             = 404357, --
                heartOfTheCrusader       = 406154, --
                highlordsJudgment        = 404512, --
                holyBlade                = 383342, --
                improvedBladeOfJustice   = 403745, --
                improvedJudgment         = 405461, --
                inquisitorsIre           = 403975, --
                judgeJuryAndExecutioner  = 405607, --
                judgmentOfJustice        = 403495, --
                jurisdiction             = 402971, --
                justicarsVengeance       = 215661, --
                lightOfJustice           = 404436, --
                lightsCelerity           = 403698, --
                penitence                = 403026, --
                righteousCause           = 402912, --
                rushOfLight              = 407067, --
                sanctify                 = 382536, --
                searingLight             = 404540, --
                seethingFlames           = 405355, --
                shieldOfVengeance        = 184662, --
                swiftJustice             = 383228, --
                tempestOfTheLightbringer = 383396, --
                templarStrikes           = 406646, --
                truthsWake               = 403696, --
                vanguardOfJustice        = 406545, --
                vanguardsMomentum        = 383314, --
                wakeOfAshes              = 255937, --
                zealotsFervor            = 403509, --
            },
            traits    = {
                divineRight = 278523,
            },
        },
        -- All
        Shared = {
            abilities  = {
                arcaneTorrent        = 155145, --
                consecration         = 26573,  --
                crusaderAura         = 32223,  --
                crusaderStrike       = 35395,  --
                divineShield         = 642,    --
                flashOfLight         = 19750,  --
                hammerOfJustice      = 853,    --
                handOfReckoning      = 62124,  --
                intercession         = 391054, --
                judgment             = 20271,  --
                redemption           = 7328,   --
                retributionAura      = 183435, --
                senseUndead          = 5502,   --
                shieldOfTheRighteous = 53600,  --
                wordOfGlory          = 85673,  --
            },
            artifacts  = {

            },
            buffs      = {
                avengingWrath        = 31884,
                consecration         = 26573,
                concentrationAura    = 317920,
                crusaderAura         = 32223,
                devotionAura         = 465,
                divineResonance      = 384029,
                divineShield         = 642,
                divineSteed          = 221883,
                echoesOfWrath        = 423590,
                blessingOfProtection = 1022,
                holyAvenger          = 105809,
                retributionAura      = 183435,
                seraphim             = 152262,
                vanquishersHammer    = 328204,
            },
            conduits   = {
                expurgation         = 339371,
                templarsVindication = 339531,
            },
            covenants  = {
                --ashenHallow                 = 316958,
                --blessingOfTheSeasons        = 328278,
                --blessingOfAutumn            = 388010,
                --blessingOfSpring            = 388013,
                --blessingOfSummer            = 388007,
                --blessingOfWinter            = 388011,
                --vanquishersHammer           = 328204,
            },
            debuffs    = {
                blindingLight   = 105421,
                forbearance     = 25771,
                hammerOfJustice = 853,
                judgment        = 197277,
                turnEvil        = 10326,
                handOfReckoning = 62124,
            },
            glyphs     = {
                glyphOfFireFromHeavens    = 57954,
                glyphOfPillarOfLight      = 146959,
                glyphOfTheLuminousCharger = 89401,
                glyphOfTheQueen           = 212642,
            },
            talents    = {
                afterimage                   = 385414, --
                aurasOfSwiftVengeance        = 385639, --
                aurasOfTheResolute           = 385633, --
                avengingWrath                = 31884,  --
                blessingOfFreedom            = 1044,   --
                blessingOfProtection         = 1022,   --
                blessingOfSacrifice          = 6940,   --
                blindingLight                = 115750, --
                cavalier                     = 230332, --
                cleanseToxins                = 213644, --
                crusadersReprieve            = 403042, --
                divinePurpose                = 408459, --
                divineResonance              = 384027, --
                divineSteed                  = 190784, --
                divineToll                   = 375576, --
                fadingLight                  = 405768, --
                faithsArmor                  = 406101, --
                fistOfJustice                = 234299, --
                goldenPath                   = 377128, --
                greaterJudgment              = 231663, --
                hammerOfWrath                = 24275,  --
                healingHands                 = 326734, --
                holyAegis                    = 385515, --
                improvedBlessingOfProtection = 384909, --
                incandescence                = 385464, --
                judgmentOfLight              = 183778, --
                justification                = 377043, --
                layOnHands                   = 633,    --
                lightforgedBlessing          = 403479, --
                obduracy                     = 385427, --
                ofDuskAndDawn                = 385125, --
                punishment                   = 403530, --
                quickenedInvocation          = 379391, --
                rebuke                       = 96231,  --
                recompense                   = 384914, --
                repentance                   = 20066,  --
                sacrificeOfTheJust           = 384820, --
                sanctifiedPlates             = 402964, --
                sealOfAlacrity               = 385425, --
                sealOfMercy                  = 384897, --
                sealOfMight                  = 385450, --
                sealOfOrder                  = 385129, --
                sealOfTheCrusader            = 385728, --
                seasonedWarhorse             = 376996, --
                strengthOfConviction         = 379008, --
                touchOfLight                 = 385349, --
                turnEvil                     = 10326,  --
                unboundFreedom               = 305394, --
                unbreakableSpirit            = 114154, --
                vengefulWrath                = 406835, --
            },
            runeforges = {
                finalVerdict           = 337247,
                theMadParagon          = 337594,
                theMagistratesJudgment = 337681,
                vanguardsMomentum      = 337638,
            }
        },
    },
    PRIEST = {
        -- Discipline
        [256] = {
            abilities = {
                angelicFeather    = 121536,
                --clarityOfWill               = 152118,
                divineStar        = 110744,
                desperatePrayer   = 19236,
                evangelism        = 246287,
                flashHeal         = 2061,
                halo              = 120517,
                holyNova          = 132157,
                leapOfFaith       = 73325,
                mindbender        = 123040,
                mindBlast         = 8092,
                mindControl       = 205364,
                mindSear          = 48045,
                mindSoothe        = 453,
                mindVision        = 2096,
                painSuppression   = 33206,
                penance           = 47540,
                --plea                        = 200829,
                powerInfusion     = 10060,
                powerWordBarrier  = 62618,
                powerWordRadiance = 194509,
                powerWordShield   = 17,
                powerWordSolace   = 129250,
                psychicScream     = 8122,
                purgeTheWicked    = 204197,
                purify            = 527,
                rapture           = 47536,
                schism            = 214621,
                shadowfiend       = 34433,
                shadowMend        = 186263,
                shiningForce      = 204263,
                sinsOfTheMany     = 198076,
                spiritShell       = 109964,
                smite             = 585,
            },
            artifacts = {
                --sinsOfTheMany               = 198074,
            },
            buffs     = {
                angelicFeather      = 121557,
                atonement           = 194384,
                bodyAndSoul         = 65081,
                borrowedTime        = 197763,
                depthOfTheShadows   = 275544,
                --clarityOfWill               = 152118,
                innervate           = 29166,
                overloadedWithLight = 223166,
                penitent            = 246519,
                --powerInfusion               = 10060,
                powerOfTheDarkSide  = 198069,
                powerWordShield     = 17,
                rapture             = 47536,
                speedOfThePious     = 197767,
                spiritShell         = 109964,
                symbolOfHope        = 64901,
            },
            debuffs   = {
                weakenedSoul   = 6788,
                purgeTheWicked = 204213,
                schism         = 214621,
                smite          = 585,
            },
            glyphs    = {

            },
            talents   = {
                angelicFeather   = 121536,
                bodyAndSoul      = 64129,
                castigation      = 193134,
                --clarityOfWill               = 152118,
                contrition       = 197419,
                divineStar       = 110744,
                dominantMind     = 205367,
                evangelism       = 246287,
                --grace                       = 200309,
                halo             = 120517,
                lenience         = 238063,
                masochism        = 193063,
                mindbender       = 123040,
                --powerInfusion               = 10060,
                powerWordSolace  = 129250,
                purgeTheWicked   = 204197,
                psychicVoice     = 196704,
                schism           = 214621,
                shadowCovenant   = 314867,
                shieldDiscipline = 197045,
                spiritShell      = 109964,
                sinsOfTheMany    = 280391,
                shiningForce     = 204263,
                --thePenitent                 = 200347,
                twistOfFate      = 265259,
            },
            traits    = {
                giftOfForgiveness = 277680,
            },
        },
        -- Holy
        [257] = {
            abilities  = {
                angelicFeather    = 121536,
                bodyAndMind       = 214121,
                circleOfHealing   = 204883,
                desperatePrayer   = 19236,
                divineHymn        = 64843,
                divineStar        = 110744,
                flashHeal         = 2061,
                guardianSpirit    = 47788,
                holyFire          = 14914,
                holyNova          = 132157,
                holyWordChastise  = 88625,
                holyWordSanctify  = 34861,
                holyWordSerenity  = 2050,
                holyWordSalvation = 265202,
                heal              = 2060,
                leapOfFaith       = 73325,
                lightOfTuure      = 33076,
                prayerOfHealing   = 596,
                prayerOfMending   = 33076,
                purify            = 527,
                renew             = 139,
                smite             = 585,
                symbolOfHope      = 64901,
            },
            artifacts  = {
                --    lightOfTuure                = 208065,
            },
            buffs      = {
                angelicFeather     = 121557,
                blessingOfTuure    = 196578,
                divinity           = 197031,
                echoOfLight        = 77489,
                flashConcentration = 336267,
                powerOfTheNaaru    = 196489,
                prayerOfMending    = 41635,
                renew              = 139,
                surgeOfLight       = 114255,
                spiritOfRedemption = 27827,
            },
            debuffs    = {


            },
            glyphs     = {

            },
            runeforges = {
                flashConcentration = 336266,
            },
            talents    = {
                angelicFeather = 121536,
                apotheosis     = 200183,
                bodyAndSoul    = 64129,
                --bodyAndMind                 = 214121,
                divineStar     = 110744,
                --divinity                    = 197031,
                halo           = 120517,
                --piety                       = 197034,
                shiningForce   = 204263,
                surgeOfLight   = 109186,
                --symbolOfHope                = 64901,
            },
        },
        -- Shadow
        [258] = {
            abilities  = {
                damnation          = 341374,
                darkAscension      = 280711,
                dispersion         = 47585,
                devouringPlague    = 335467,
                mindBlast          = 8092,
                mindBomb           = 205369,
                mindbender         = 200174,
                mindFlay           = 15407,
                mindSear           = 48045,
                mindVision         = 2096,
                powerInfusion      = 10060,
                powerWordShield    = 17,
                psychicHorror      = 64044,
                psychicScream      = 8122,
                purifyDisease      = 213634,
                shadowMend         = 186263,
                shadowWordVoid     = 205351,
                shadowfiend        = 34433,
                shadowform         = 232698,
                silence            = 15487,
                surrenderToMadness = 193223,
                vampiricEmbrace    = 15286,
                vampiricTouch      = 34914,
                voidBolt           = 205448,
                devoidBolt         = 343355,
                voidEruption       = 228260,
                voidForm           = 228264,
            },
            artifacts  = {
                lashOfInsanity    = 238137,
                massHysteria      = 194378,
                sphereOfInsanity  = 194179,
                toThePain         = 193644,
                touchOfDarkness   = 194007,
                unleashTheShadows = 194093,
                voidCorruption    = 194016,
                voidTorrent       = 205065,
            },
            buffs      = {
                chorusOfInsanity   = 279572,
                darkThoughts       = 341207,
                dispersion         = 47585,
                dissonantEchoes    = 343144,
                harvestedThoughts  = 288343,
                lingeringInsanity  = 199849,
                powerWordShield    = 17,
                powerInfusion      = 10060,
                shadowyInsight     = 124430,
                shadowform         = 232698,
                surrenderedSoul    = 212570,
                surrenderToMadness = 193223,
                thoughtsHarvester  = 288340,
                unfurlingDarkness  = 341282,
                void               = 211657,
                voidForm           = 194249,
                voidTorrent        = 205065,
                zeksExterminatus   = 236546, -- Legendary Cloak proc
            },
            debuffs    = {
                devouringPlague = 335467,
                hungeringVoid   = 345218,
                mindFlay        = 15407,
                vampiricTouch   = 34914,
                weakenedSoul    = 6788,
            },
            glyphs     = {

            },
            runeforges = {
                shadowflamePrism = 336143,
            },
            talents    = {
                fortressOfTheMind  = 193195,
                deathAndMadness    = 321291,
                unfurlingDarkness  = 341273,
                bodyAndSoul        = 64129,
                sanlayn            = 199855,
                twistOfFate        = 109142,
                misery             = 238558,
                searingNightmare   = 341385,
                mindBomb           = 205369,
                psychicHorror      = 64044,
                auspiciousSpirits  = 155271,
                psychicLink        = 199484,
                shadowCrash        = 205385,
                damnation          = 341374,
                mindbender         = 200174,
                voidTorrent        = 263165,
                ancientMadness     = 341240,
                hungeringVoid      = 345218,
                surrenderToMadness = 319952,
            },
            traits     = {
                chorusOfInsanity    = 278661,
                deathThroes         = 278659,
                searingDialogue     = 272788,
                spitefulApparitions = 277682,
                thoughtHarvester    = 288340,
                whispersOfTheDamned = 275722,
            },
        },
        -- All
        Shared = {
            abilities = {
                ascendedBlast      = 325283,
                ascendedNova       = 325020,
                boonOfTheAscended  = 325013,
                desperatePrayer    = 19236,
                dispelMagic        = 528,
                fade               = 586,
                faeGuardians       = 327661,
                flashHeal          = 2061,
                leapOfFaith        = 73325,
                levitate           = 1706,
                massDispel         = 32375,
                massResurrection   = 212036,
                mindBlast          = 8092,
                mindControl        = 605,
                mindgames          = 323673,
                mindSoothe         = 453,
                mindVision         = 2096,
                powerInfusion      = 10060,
                powerWordFortitude = 21562,
                powerWordShield    = 17,
                psychicScream      = 8122,
                resurrection       = 2006,
                shadowWordDeath    = 32379,
                shackleUndead      = 9484,
                shadowWordPain     = 589,
                smite              = 585,
            },
            artifacts = {

            },
            buffs     = {
                classHallSpeed     = 224098,
                boonOfTheAscended  = 325013,
                faeGuardians       = 327661,
                levitate           = 111759,
                powerWordFortitude = 21562,
                powerWordShield    = 17,

            },
            conduits  = {
                dissonantEchoes = 338342,
            },
            covenants = {
                boonOfTheAscended = 325013,
                ascendedBlast     = 325315,
                ascendedEruption  = 325326,
                ascendedNova      = 325020,
                faeGuardians      = 327661,
                mindgames         = 323673,
                unholyNova        = 324724,
            },
            debuffs   = {
                shadowWordPain = 589,
                weakenedSoul   = 6788,
                wrathfulFaerie = 327703,

            },
            glyphs    = {

            },
            talents   = {

            },
        },
    },
    ROGUE = {
        -- Assassination
        [259] = {
            abilities  = {
                -- ambush         = 8676,
                -- crimsonTempest = 121411,
                -- deadlyPoison   = 315584,
                -- envenom        = 32645,
                -- eviscerate     = 196819,
                -- exsanguinate   = 200806,
                -- fanOfKnives    = 51723,
                -- garrote        = 703,
                -- mutilate       = 1329,
                -- poisonedKnife  = 185565,
                -- rupture        = 1943,
                -- shadowstep     = 36554,
                -- sinisterStrike = 1752,
                -- vendetta       = 79140,
            },
            artifacts  = {

            },
            buffs      = {
                blindside           = 121153,
                deadlyPoison        = 2823,
                elaboratePlanning   = 193641,
                envenom             = 32645,
                leechingPoison      = 108211,
                sharpenedBlades     = 272916,
                masterAssassin      = 256735,
                subterfuge          = 115192,
                theDreadlordsDeceit = 208692,
            },
            debuffs    = {
                crimsonTempest   = 121411,
                deadlyPoison     = 2818,
                garrote          = 703,
                internalBleeding = 154953,
                rupture          = 1943,
                surgeOfToxins    = 192425,
                toxicBlade       = 245389,
                vendetta         = 79140,
            },
            glyphs     = {

            },
            talents    = {
                blindside         = 328085,
                crimsonTempest    = 121411,
                elaboratePlanning = 193640,
                elusiveness       = 79008,
                exsanguinate      = 200806,
                hiddenBlades      = 270061,
                internalBleeding  = 154904,
                ironWire          = 196861,
                leechingPoison    = 280716,
                masterAssassin    = 255989,
                masterPoisoner    = 196864,
                nightstalker      = 14062,
                poisonBomb        = 255544,
                subterfuge        = 108208,
                venomRush         = 152152,
            },
            traits     = {
                doubleDose          = 273007,
                echoingBlades       = 287649,
                sharpenedBlades     = 272911,
                shroudedSuffocation = 278666,
                twistTheKnife       = 273488,
            },
            runeforges = {
                dashingScoundrel = 340081,
                doomblade        = 340082,
                zoldyckInsignia  = 340083,
                duskwalkersPatch = 340084,
            },
        },
        -- Outlaw
        [260] = {
            abilities  = {
                adrenalineRush        = 13750,
                ambush                = 8676,
                betweenTheEyes        = 315341,
                bladeFlurry           = 13877,
                bladeRush             = 271877,
                blind                 = 2094,
                curseOfTheDreadblades = 202665,
                dispatch              = 2098,
                ghostlyStrike         = 196937,
                gouge                 = 1776,
                grapplingHook         = 195457,
                killingSpree          = 51690,
                masteryMainGauche     = 76806,
                pistolShot            = 185763,
                riposte               = 199754,
                rollTheBones          = 315508,
                sinisterStrike        = 193315,
                dreadblades           = 343142,
            },
            artifacts  = {
                blackPowder           = 216230,
                bladeDancer           = 202507,
                bladeMaster           = 202628,
                blunderbuss           = 202897,
                blurredTime           = 202769,
                cannonballBarrage     = 185767,
                curseOfTheDreadblades = 202665,
                cursedEdge            = 202463,
                cursedSteel           = 214929,
                deception             = 202755,
                fatesThirst           = 202514,
                fatebringer           = 202524,
                fortuneStrikes        = 202530,
                fortunesBoon          = 202907,
                fortunesStrike        = 202521,
                ghostlyShell          = 202533,
                greed                 = 202820,
                gunslinger            = 202522,
                hiddenBlade           = 202573,
                killingSpree          = 51690,
                loadedDice            = 238139,
            },
            buffs      = {
                adrenalineRush                  = 13750,
                alacrity                        = 193538,
                bladeFlurry                     = 13877,
                blunderbuss                     = 202895,
                broadside                       = 193356,
                buriedTreasure                  = 199600,
                deadShot                        = 272940,
                grandMelee                      = 193358,
                greenskinsWaterloggedWristcuffs = 209420,
                hiddenBlade                     = 202754,
                jollyRoger                      = 199603,
                loadedDice                      = 256171,
                opportunity                     = 195627,
                ruthlessPrecision               = 193357,
                rollTheBones                    = {
                    broadside          = 193356,
                    buriedTreasure     = 199600,
                    grandMelee         = 193358,
                    ruthlessPrecision  = 193357,
                    skullAndCrossbones = 199603,
                    trueBearing        = 193359,
                },
                sharkInfestedWaters             = 193357,
                skullAndCrossbones              = 199603,
                snakeeeyes                      = 275863, --typo, leaving in not to break stuff
                snakeeyes                       = 275863,
                swordplay                       = 211669,
                trueBearing                     = 193359,
                wits                            = 288988,
            },
            debuffs    = {
                ghostlyStrike  = 196937,
                gouge          = 1776,
                betweenTheEyes = 199804,
                preyOnTheWeak  = 255909,
                blind          = 2094,
            },
            glyphs     = {

            },
            talents    = {
                acrobaticStikes  = 196924, -- typo, leaving in to not break old profiles
                acrobaticStrikes = 196924,
                dirtyTricks      = 108216,
                bladeRush        = 271877,
                ghostlyStrike    = 196937,
                grapplingHook    = 256188,
                hitAndRun        = 196922,
                ironStomach      = 193546,
                killingSpree     = 51690,
                weaponmaster     = 200733,
                quickDraw        = 196938,
                blindingPowder   = 256165,
                loadedDice       = 256170,
                dancingSteel     = 272026,
                dreadblades      = 343142,
            },
            traits     = {
                deadshot             = 272935,
                aceupyoursleeve      = 278676,
                snakeeyes            = 275846,
                keepYourWitsAboutYou = 288979,

            },
            runeforges = {
                greenskinsWickers    = 340085,
                guileCharm           = 340086,
                celerity             = 340087,
                concealedBlunderbuss = 340088,
            },
            conduits   = {
                countTheOdds = 341546,
            },
        },
        -- Subtlety
        [261] = {
            abilities  = {
                backstab       = 53,
                blackPowder    = 319175,
                rupture        = 1943,
                shadowstrike   = 185438,
                shurikenStorm  = 197835,
                shurikenToss   = 114014,
                symbolsOfDeath = 212283,
            },
            artifacts  = {

            },
            buffs      = {
                danseMacabre        = 393969,
                deeperDaggers       = 383405,
                finalityRupture     = 385951,
                flagellation        = 384631,
                flagellationPersist = 394758,
                lingeringShadow     = 385960,
                masterAssassin      = 256735,
                masterOfShadows     = 196980,
                nightsVengeance     = 273424,
                perforatedVeins     = 341572,
                premeditation       = 343160,
                shadowBlades        = 121471,
                shadowDance         = 185422,
                sharpenedBlades     = 272916,
                shurikenCombo       = 245640,
                shurikenTornado     = 277925,
                subterfuge          = 115192,
                symbolsOfDeath      = 212283,
                symbolsOfDeathCrit  = 227151,
                shotInTheDark       = 257506,
                theDreadlordsDeceit = 228224,
                theRotten           = 394203,
            },
            debuffs    = {
                rupture      = 1943,
                findWeakness = 91021,
                nightblade   = 195452,
                shadowsGrasp = 206760,
            },
            glyphs     = {

            },
            talents    = {
                cloakedInShadows         = 382515, --
                danseMacabre             = 382528, --
                darkBrew                 = 382504, --
                darkShadow               = 245687, --
                deepeningShadows         = 185314, --
                deeperDaggers            = 382517, --
                ephemeralBond            = 426563, --
                exhilaratingExecution    = 428486, --
                fadeToNothing            = 382514, --
                finality                 = 382525, --
                findWeakness             = 91023,  --
                flagellation             = 384631, --
                gloomblade               = 200758, --
                goremawsBite             = 426591, --
                improvedBackstab         = 319949, --
                improvedShadowDance      = 393972, --
                improvedShadowTechniques = 394023, --
                improvedShurikenStorm    = 319951, --
                inevitability            = 382512, --
                invigoratingShadowdust   = 382523, --
                lingeringShadow          = 382524, --
                masterOfShadows          = 196976, --
                nightTerrors             = 277953, --
                perforatedVeins          = 382518, --
                plannedExecution         = 382508, --
                premeditation            = 343160, --
                quickDecisions           = 382503, --
                relentlessStrikes        = 58423,  --
                replicatingShadows       = 382506, --
                secretStratagem          = 394320, --
                secretTechnique          = 280719, --
                sepsis                   = 385408, --
                shadowBlades             = 121471, --
                shadowFocus              = 108209, --
                shadowcraft              = 426594, --
                shadowedFinishers        = 382511, --
                shotInTheDark            = 257505, --
                shroudedInDarkness       = 382507, --
                shurikenTornado          = 277925, --
                silentStorm              = 385722, --
                swiftDeath               = 394309, --
                terrifyingPace           = 428387, --
                theFirstDance            = 382505, --
                theRotten                = 382015, --
                veiltouched              = 382017, --
                warningSigns             = 426555, --
                weaponmaster             = 193537, --
                withoutATrace            = 382513, --
            },
            traits     = {
                bladeInTheShadows  = 275896,
                nightsVengeance    = 273418,
                replicatingShadows = 286121,
                sharpenedBlades    = 272911,
                theFirstDance      = 278681,
                perforate          = 277720,
                inevitability      = 278683,
            },
            runeforges = {
                finality            = 340089,
                akaarisSoulFragment = 340090,
            },
            conduits   = {
                deeperDaggers    = 341549,
                perforatedVeins  = 341567,
                plannedExecution = 341556,
                stilettoStaccato = 341559,
            },
        },
        -- All
        Shared = {
            abilities  = {
                ambush = 8676,
                cheapShot = 1833,
                crimsonVial = 185311,
                cripplingPoison = 3408,
                distract = 1725,
                eviscerate = 196819,
                feint = 1966,
                instantPoison = 315584,
                kick = 1766,
                kidneyShot = 408,
                pickLock = 1804,
                pickPocket = 921,
                sap = 6770,
                shadowDance = 185313,
                shroudOfConcealment = 114018,
                sinisterStrike = 1752,
                sliceAndDice = 315496,
                sprint = 2983,
                stealth = 1784,
                vanish = 1856,
                woundPoison = 8679,
            },
            artifacts  = {

            },
            buffs      = {
                chaosBane           = 356043,
                cloakOfShadows      = 31224,
                coldBlood           = 213981,
                cripplingPoison     = 3408,
                deathFromAbove      = 152150,
                deathlyShadows      = 341202,
                feint               = 1966,
                flagellation        = 345569,
                flagellationPersist = 394758,
                instantPoison       = 315584,
                leadByExample       = 342156,
                masterAssassinsMark = 340094,
                numbingPoison       = 5761,
                sepsis              = 328305,
                shroudOfConcealment = 114018,
                sliceAndDice        = 315496,
                sprint              = 2983,
                stealth             = 1784,
                stealthSepsis       = 347037,
                theRotten           = 341134,
                tricksOfTheTrade    = 57934,
                vanish              = 1856,
                woundPoison         = 8679,
                echoingReprimand    = 323558,
                thistleTea          = 381623,
            },
            conduits   = {
                lashingScars     = 341310,
                plannedExecution = 341556,
                reverberation    = 341264,
                septicShock      = 341309,
            },
            covenants  = {
                echoingReprimand    = 323547,
                flagellation        = 323654,
                flagellationCleanse = 346975,
                sepsis              = 328305,
                serratedBoneSpike   = 328547,
            },
            debuffs    = {
                cheapShot            = 1833,
                cripplingPoison      = 3408,
                flagellation         = 323654,
                instantPoison        = 315584,
                kidneyShot           = 408,
                numbingPoison        = 5761,
                sap                  = 6770,
                sepsis               = 328305,
                serratedBoneSpike    = 328547,
                serratedBoneSpikeDot = 324073,
                shiv                 = 319504,
                woundPoison          = 8679,
            },
            glyphs     = {
                glyphOfBlackout  = 219693,
                glyphOfBurnout   = 220279,
                glyphOfDisguise  = 63268,
                glyphOfFlashBang = 219678,
            },
            talents    = {
                acrobaticStrikes    = 196924, --
                airbourneIrritant   = 200733, --
                alacrity            = 193539, --
                atrophicPoison      = 381637, --
                blackjack           = 379005, --
                blind               = 2094,   --
                cheatDeath          = 31230,  --
                cloakOfShadows      = 31224,  --
                coldBlood           = 382245, --
                deadenedNerves      = 231719, --
                deadlyPrecision     = 381542, --
                deeperStratagem     = 193531, --
                echoingReprimand    = 385616, --
                elusiveness         = 79008,  --
                evasion             = 5277,   --
                featherfoot         = 423683, --
                fleetFooted         = 378813, --
                gouge               = 1776,   --
                gracefulGuile       = 423647, --
                improvedAmbush      = 381620, --
                improvedSprint      = 231691, --
                improvedWoundPoison = 319066, --
                ironStomach         = 193546, --
                lethality           = 382238, --
                leechingPoison      = 280716, --
                masterPoisoner      = 378436, --
                nightstalker        = 14062,  --
                nimbleFingers       = 378427, --
                numbingPoison       = 5761,   --
                recuperator         = 378996, --
                resoundingClarity   = 381622, --
                reverberation       = 394332, --
                rushedSetup         = 378803, --
                soothingDarkness    = 393970, --
                shadowDance         = 185313, --
                shadowrunner        = 378807, --
                shadowstep          = 36554,  --
                shiv                = 5938,   --
                stillshroud         = 423662, --
                subterfuge          = 108208, --
                superiorMixture     = 423701, --
                thistleTea          = 381623, --
                tightSpender        = 381621, --
                tricksOfTheTrade    = 57934,  --
                unbreakableStride   = 400804, --
                vigor               = 14983,  --
                virulentPoisons     = 381543, --
            },
            runeforges = {
                deathlyShadows          = 340092,
                essenceOfBloodfang      = 340079,
                invigoratingShadowdust  = 340080,
                markOfTheMasterAssassin = 340076,
                obedience               = 354703,
                tinyToxicBlade          = 340078,
                theRotten               = 340091,
            },
        },
    },
    SHAMAN = {
        -- Elemental
        [262] = {
            abilities = {
                earthquake    = 61882,
                earthShock    = 8042,
                eyeOfTheStorm = 157375,
                fireBlast     = 57984,
                fireElemental = 198067,
                hardenSkin    = 118337,
                immolate      = 118297,
                lavaBeam      = 114074,
                meteor        = 117588,
                pulverize     = 118345,
                windGust      = 157331,
            },
            artifacts = {
            },
            conduits  = {
                callOfFlame = 338303,
            },
            buffs     = {
                ascendance          = 114050,
                bloodlust           = 2825,
                echoingShock        = 320125,
                elementalFocus      = 16164,
                elementalMastery    = 16166,
                emberTotem          = 210658,
                hardenSkin          = 118337,
                heroism             = 32182,
                iceFury             = 210714,
                lavaSurge           = 77762,
                masterOfTheElements = 260734,
                powerOfTheMaelstrom = 191877,
                resonanceTotem      = 202192,
                stormKeeper         = 191634,
                stormTotem          = 210652,
                surgeOfPower        = 285514,
                tailwindTotem       = 210659,
                tectonicThunder     = 286949,
                windGust            = 263806,
            },
            debuffs   = {
                flameShock   = 188389,
                immolate     = 118297,
                lightningRod = 197209,
            },
            glyphs    = {

            },
            talents   = {
                aftershock          = 273221,
                ancestralGuidance   = 108281,
                ascendance          = 114050,
                earthenRage         = 170374,
                echoingShock        = 320125,
                echoOfTheElements   = 333919,
                elementalBlast      = 117014,
                iceFury             = 210714,
                liquidMagmaTotem    = 192222,
                masterOfTheElements = 16166,
                primalElementalist  = 117013,
                staticDischarge     = 342243,
                stormElemental      = 192249,
                stormKeeper         = 191634,
                surgeOfPower        = 262303,
                unlimitedPower      = 260895,

            },
            traits    = {
                naturalHarmony  = 278697,
                tectonicThunder = 286949,
            },
        },
        -- Enhancement
        [263] = {
            abilities = {
				tempest    = 454015,
                feralLunge = 196884,
                --windfuryTotem = 8512,
                windstrike = 115356, --17364,
            },
            artifacts = {

            },
            buffs     = {
                ascendance            = 114051,
                ashenCatalyst         = 390371,
				awakeningStorms       = 462131,
                cracklingSurge        = 224127,
                crashLightning        = 187878,
                clCrashLightning      = 333964,
                -- convergingStorms            = 198300,
                doomWinds             = 384352,
                earthenWeapon         = 392375,
                feralSpirit           = 333957,
                hailstorm             = 334196,
                hotHand               = 215785,
                icyEdge               = 224126,
                legacyOfTheFrostWitch = 384451,
                maelstromOfElements   = 394677,
                moltenWeapon          = 224125,
                primordialWave        = 327164,
                splinteredElements    = 354648,
				tempest               = 454015,
                -- stormkeeper                 = 320137,
                -- stormbringer                = 201845,
            },
            debuffs   = {
                -- doomWinds                   = 335904,
                lashingFlames = 334168,
            },
            glyphs    = {

            },
            talents   = {
                alphaWolf               = 198434,
                ancestralWolfAffinity   = 382197,
                ascendance              = 114051,
                ashenCatalyst           = 390370,
                convergingStorms        = 384363,
                crashLightning          = 187874,
                crashingStorms          = 334308,
                deeplyRootedElements    = 378270,
                doomWinds               = 384352,
                elementalAssault        = 210853,
                elementalBlast          = 117014,
                elementalSpirits        = 262624,
                elementalWeapons        = 384355,
                feralSpirit             = 51533,
                fireNova                = 333974,
                forcefulWinds           = 262647,
                hailstorm               = 334195,
                hotHand                 = 201900,
                iceStrike               = 342240,
                improvedMaelstromWeapon = 383303,
                lashingFlames           = 334046,
                lavaLash                = 60103,
                legacyOfTheFrostWitch   = 384450,
                moltenAssault           = 334033,
                overflowingMaelstrom    = 384149,
                primalMaelstrom         = 384405,
                primordialWave          = 375982,
                ragingMaelstrom         = 384143,
                refreshingWaters        = 378211,
                splinteredElements      = 382042,
                staticAccumulation      = 384411,
                stormblast              = 319930,
                stormflurry             = 344357,
                stormstrike             = 17364,
                stormsWrath             = 392352,
                sundering               = 197214,
                swirlingMaelstrom       = 384359,
				tempest                 = 454009,
                tempestStrikes          = 428071,
                thorimsInvocation       = 384444,
                unrulyWinds             = 390288,
                windfuryWeapon          = 33757,
                witchDoctorsAncestry    = 384447,
            },
            traits    = {
                lightningConduit   = 275389,
                naturalHarmony     = 278697,
                primalPrimer       = 272992,
                strengthOfTheEarth = 273461,
            },
        },
        -- Restoration
        [264] = {
            abilities = {
                ancestralVision       = 212048,
                waterShield           = 52127,
                healingRain           = 73920,
                healingTideTotem      = 108280,
                healingWave           = 77472,
                manaTideTotem         = 16191,
                purifySpirit          = 77130,
                riptide               = 61295,
                spiritLinkTotem       = 98008,
                recallCloudburstTotem = 201764,
            },
            artifacts = {
                --   giftOfTheQueen              = 207778,
            },
            buffs     = {
                ascendance       = 114052,
                cloudburstTotem  = 157504,
                waterShield      = 52127,
                healingRain      = 73920,
                heavyRainfall    = 338344,
                jonatsFocus      = 210607,
                lavaSurge        = 77762,
                riptide          = 61295,
                tidalWaves       = 53390,
                unleashLife      = 73685,
                undulation       = 216251,
                swirlingCurrents = 338340,
            },
            conduits  = {
                heavyRainfall = 338343,
            },
            debuffs   = {
                flameShock = 188389,
            },
            glyphs    = {
            },
            talents   = {
                ancestralVigor           = 207401,
                ancestralProtectionTotem = 207399,
                ascendance               = 114052,
                cloudburstTotem          = 157153,
                deluge                   = 200076,
                downpour                 = 207778,
                earthenWallTotem         = 198838,
                echoOfTheElements        = 108283,
                flashFlood               = 280614,
                highTide                 = 157154,
                sugeofEarth              = 320746,
                torrent                  = 200072,
                undulation               = 200071,
                unleashLife              = 73685,
                wellspring               = 197995,
            },
        },
        -- All
        Shared = {
            abilities     = {
                ancestralSpirit   = 2008,
                astralRecall      = 556,
                bloodlust         = 2825,
                earthbindTotem    = 2484,
                farSight          = 6196,
                flameShock        = 188389,
                flametongueWeapon = 318038,
                ghostWolf         = 2645,
                healingSurge      = 8004,
                heroism           = 32182,
                lightningBolt     = 188196,
                lightningShield   = 192106,
                primalStrike      = 73899,
                waterWalking      = 546,
                skyfury           = 462854,
            },
            artifacts     = {

            },
            buffs         = {
                astralShift        = 108271,
                earthShield        = 974,
                ghostWolf          = 2645,
                maelstromWeapon    = 344179,
                lightningShield    = 192106,
                skyfury            = 462854,
                spiritwalkersGrace = 79206,
                waterWalking       = 546,
            },
            conduits      = {
                astralProtection = 337964,
            },
            covenants     = {
                -- chainHarvest                = 320674,
                -- faeTransfusion              = 328923,
                -- primordialWave              = 326059,
                -- vesperTotem                 = 324386,
            },
            debuffs       = {
                flameShock = 188389,
                frostShock = 196840,
                hex        = 51514,
            },
            glyphs        = {

            },
            runeforges    = {
                chainsOfDevastation        = 336735,
                doomWinds                  = 335902,
                elementalEquilibrium       = 336730,
                primalLavaActuators        = 335895,
                echoesOfGreatSundering     = 336215,
                seedsOfRampantGrowth       = 356218,
                skybreakersFieryDemise     = 336734,
                spiritwalkersTidalTotem    = 335891,
                deeptremorStone            = 336739,
                windspeakersLavaResurgence = 336063,
                deeplyRootedElements       = 336738,
            },
            talents       = {
                ascendingAir         = 462791,
                ancestralGuidance    = 108281,
                arcticSnowstorm      = 462764,
                astralBulwark        = 377933,
                astralShift          = 108271,
                brimmingWithLife     = 381689,
                callOfTheElements    = 383011,
                capacitorTotem       = 192058,
                chainHeal            = 1064,
                chainLightning       = 188443,
                cleanseSpirit        = 51886,
                creationCore         = 383012,
                earthElemental       = 198103,
                earthgrabTotem       = 51485,
                earthShield          = 974,
                elementalOrbit       = 383010,
                elementalResistance  = 462368,
                elementalWarding     = 381650,
                encasingCold         = 462762,
                enhancedImbues       = 462796,
                fireAndIce           = 382886,
                flurry               = 382888,
                frostShock           = 196840,
                gracefulSpirit       = 192088,
                greaterPurge         = 378773,
                guardiansCudgel      = 381819,
                gustOfWind           = 192063,
                healingStreamTotem   = 5394,
                hex                  = 51514,
                jetStream            = 462817,
                lavaBurst            = 51505,
                lightningLasso       = 305483,
                manaSpring           = 381930,
                naturesFury          = 381655,
                naturesGuardian      = 30884,
                naturesSwiftness     = 378081,
                planesTraveler       = 381647,
                poisonCleansingTotem = 383013,
                purge                = 370,
                primordialBond       = 381764,
                seasonedWinds        = 355630,
                spiritWalk           = 58875,
                spiritwalkersAegis   = 378077,
                spiritwalkersGrace   = 79206,
                spiritWolf           = 260878,
                staticCharge         = 265046,
                stoneBulwarkTotem    = 108270,
                thunderousPaws       = 378075,
                thundershock         = 378779,
                thunderstorm         = 51490,
                totemicFocus         = 382201,
                totemicProjection    = 108287,
                totemicRecall        = 108285,
                totemicSurge         = 381867,
                travelingStorms      = 204403,
                tremorTotem          = 8143,
                voodooMastery        = 204268,
                windsOfAlakir        = 382215,
                windRushTotem        = 192077,
                windShear            = 57994,
                windsOfAlAkir        = 382215,
            },
            talentsHeroic = {
                -- Enhance / Elemental  Stormbringer
                unlimitedPower        = 454391,
                supercharge           = 455110,
                voltaicSurge          = 454919,
                awakeningStorms       = 455129,
                stormcaller           = 454021,
                stormSwell            = 455088,
                arcDischarge          = 455096,
                conductiveEnergy      = 455123,
                shockingGrasp         = 454022,
                rollingThunder        = 454026,
                naturesProtection     = 454027,
                surgingCurrents       = 454372,
                -- Enhance / Restoration Totemic
                surgingTotem          = 444995,
                totemicRebound        = 445025,
                oversizedTotems       = 445026,
                swiftRecall           = 445027,
                imbuementMastery      = 445028,
                whirlingElements      = 445024,
                amplificationCore     = 445029,
                oversurge             = 445030,
                windBarrier           = 445031,
                pulseCapacitor        = 445032,
                supportiveImbuements  = 445033,
                livelyTotems          = 445034,
                reactivity            = 445035,
                totemicCoordination   = 445036,
                earthsurge            = 455590,
                -- Elemental / Restoration Farseer
                callOfTheAncestors    = 443450,
                latentWisdom          = 443449,
                ancientFellowship     = 443423,
                offeringFromBeyond    = 443451,
                naturalHarmony        = 443442,
                earthenCommunion      = 443441,
                ancestralSwiftness    = 443454,
                heedMyCall            = 443444,
                routineCommunication  = 443445,
                primordialCapacity    = 443448,
                maelstromSupremacy    = 443447,
                elementalReverb       = 443418,
                spiritwalkersMomentum = 443425,
                finalCalling          = 443446,


            },
        },
    },
    WARLOCK = {
        -- Affliction
        [265] = {
            abilities = {
                agony               = 980,
                commanddemon        = 119898,
                corruption          = 172,
                darkSoul            = 113860,
                deathbolt           = 264106,
                demonicGateway      = 311699,
                drainLife           = 234153,
                drainSoul           = 198590,
                felDomination       = 333889,
                grimoireOfSacrifice = 108503,
                haunt               = 48181,
                maleficRapture      = 324536,
                mortalCoil          = 6789,
                phantomSingularity  = 205179,
                reapSouls           = 216698,
                seedOfCorruption    = 27243,
                shadowBolt          = 232670,
                shadowBolt2         = 686,
                shadowLock          = 171138,
                siphonLife          = 63106,
                spellLock           = 19647,
                spellLockgrimoire   = 132409,
                soulEffigy          = 205178,
                soulRot             = 325640,
                soulSwap            = 386951,
                soulTap             = 387073,
                summonDarkglare     = 205180,
                unstableAffliction  = 30108,
                vileTaint           = 278350,
            },
            artifacts = {
            },
            buffs     = {
                cascadingCalamity  = 275378,
                compoundingHorror  = 199281,
                darkSoul           = 113860,
                deadwindHarvester  = 216708,
                demonicPower       = 196099,
                empoweredLifeTap   = 235156,
                felDomination      = 333889,
                nightfall          = 264571,
                tormentedSouls     = 216695,
                wrathOfConsumption = 199646,
                inevitableDemise   = 273525,
            },
            debuffs   = {
                agony               = 980,
                corruption          = 146739,
                haunt               = 48181,
                phantomSingularity  = 205179,
                seedOfCorruption    = 27243,
                siphonLife          = 63106,
                shadowEmbrace       = 32390,
                unstableAffliction  = 316099,
                unstableAffliction2 = 233496,
                unstableAffliction3 = 233497,
                unstableAffliction4 = 233498,
                unstableAffliction5 = 233499,
                vileTaint           = 278350,
            },
            glyphs    = {

            },
            talents   = {
                absoluteCorruption  = 196103,
                creepingDeath       = 264000,
                darkCaller          = 334183,
                darkfury            = 264874,
                seedOfCorruption    = 196226,
                darkSoul            = 113860,
                demonicSacrifice    = 108503,
                drainSoul           = 198590,
                grimoireOfSacrifice = 108503,
                haunt               = 48181,
                howlOfTerror        = 5484,
                inevitableDemise    = 334319,
                nightfall           = 108558,
                phantomSingularity  = 205179,
                siphonLife          = 63106,
                soulConduit         = 215941,
                sowTheSeeds         = 196226,
                vileTaint           = 278350,
                writheInAgony       = 196102,
            },
            traits    = {
                cascadingCalamity  = 275372,
                dreadfulCalling    = 278727,
                inevitableDemise   = 273521,
                pandemicInvocation = 289364,
            }
        },
        -- Demonology
        [266] = {
            abilities = {
                axeToss              = 89766,
                bilescourgeBombers   = 267211,
                callDreadstalkers    = 104316,
                commandDemon         = 119898,
                corruption           = 172,
                demonbolt            = 264178,
                demonicEmpowerment   = 193396,
                demonicStrength      = 267171,
                demonwrath           = 193440,
                doom                 = 603,
                drainLife            = 234153,
                felFirebolt          = 104318,
                felstorm             = 89751,
                grimoireFelguard     = 111898,
                guillotine           = 386833,
                handOfGuldan         = 105174,
                implosion            = 196277,
                netherPortal         = 267217,
                powerSiphon          = 264130,
                shadowBolt           = 686,
                shadowflame          = 205181,
                shadowLock           = 171138,
                shadowsBite          = 387322,
                spellLock            = 19647,
                summonDarkglare      = 205180,
                summonDemonicTyrant  = 265187,
                summonVilefiend      = 264119,
                thalkielsConsumption = 211714,
            },
            artifacts = {
                thalkielsAscendance  = 238145,
                thalkielsConsumption = 211714,
            },
            buffs     = {
                demonicCalling     = 205146,
                demonicCore        = 267102,
                demonicEmpowerment = 193396,
                demonicPower       = 265273,
                demonwrath         = 193440,
                explosivePotential = 275398,
                forbiddenKnowledge = 278738,
                netherPortal       = 267218,
                shadowsBite        = 272945,
                shadowyInspiration = 196269,
            },
            debuffs   = {
                doom        = 603,
                shadowflame = 205181,
                corruption  = 172,
            },
            glyphs    = {

            },
            talents   = {
                bilescourgeBombers = 267211,
                darkfury           = 264874,
                demonicStrength    = 267171,
                demonicCalling     = 205145,
                doom               = 603,
                dreadlash          = 264078,
                fromTheShadows     = 267170,
                grimoireFelguard   = 111898,
                howlOfTerror       = 5484,
                innerDemons        = 267216,
                netherPortal       = 267217,
                powerSiphon        = 264130,
                sacrificedSouls    = 267214,
                summonVilefiend    = 264119,
                soulConduit        = 215941,

            },
            traits    = {
                balefulInvocation  = 287059,
                explosivePotential = 275395,
                shadowsBite        = 272944,
            }
        },
        -- Destruction
        [267] = {
            abilities = {
                cataclysm           = 152108,
                channelDemonfire    = 196447,
                chaosBolt           = 116858,
                conflagrate         = 17962,
                corruption          = 172,
                commandDemon        = 119898,
                darkSoul            = 113858,
                devourMagic         = 19505,
                dimensionalRift     = 196586,
                drainLife           = 234153,
                felDomination       = 333889,
                grimoireOfSacrifice = 108503,
                havoc               = 80240,
                immolate            = 348,
                incinerate          = 29722,
                rainOfFire          = 5740,
                shadowBolt          = 686,
                shadowburn          = 17877,
                shadowLock          = 171138,
                singeMagic          = 119905,
                singeMagicGrimoire  = 132411,
                soulFire            = 6353,
                spellLock           = 19647,
                spellLockgrimoire   = 132409,
                summonInfernal      = 1122,
            },
            artifacts = {

            },
            buffs     = {
                backdraft           = 117828, --196406,
                crashingChaos       = 277706,
                darkSoul            = 113858,
                darkSoulInstability = 113858,
                demonicPower        = 196099,
                empoweredLifeTap    = 235156,
                felDomination       = 333889,
                lessonsOfSpaceTime  = 236174,
                lordOfFlames        = 224103,
            },
            debuffs   = {
                conflagrate = 265931,
                eradication = 196414,
                immolate    = 157736,
                havoc       = 80240,
            },
            glyphs    = {

            },
            talents   = {
                cataclysm           = 152108,
                channelDemonfire    = 196447,
                darkFury            = 264874,
                darkSoul            = 113858,
                darkSoulInstability = 113858,
                eradication         = 196412,
                flashover           = 267115,
                fireAndBrimstone    = 196408,
                grimoireOfSacrifice = 108503,
                grimoireOfSupremacy = 266086,
                howlOfTerror        = 5484,
                inferno             = 270545,
                internalCombustion  = 266134,
                reverseEntropy      = 205148,
                roaringBlaze        = 205184,
                shadowburn          = 17877,
                soulFire            = 6353,
                soulConduit         = 215941,
            },
            traits    = {
                crashingChaos = 277644
            }
        },
        -- Inital Warlock (1-10)
        [1454] = {
            abilities = {
                controlDemon    = 93375,
                corruption      = 172,
                curseOfWeakness = 702,
                drainLife       = 234153,
                shadowBolt      = 686,
            },
            buffs     = {

            },
            debuffs   = {
                corruption      = 146739,
                curseOfWeakness = 702,
                drainLife       = 234153,
            },
        },
        -- All
        Shared = {
            abilities = {
                amplifyCurse       = 328774,
                banish             = 710,
                burningRush        = 111400,
                curseOfExhaustion  = 334275,
                curseOfTongues     = 1714,
                curseOfWeakness    = 702,
                createHealthstone  = 6201,
                createSoulwell     = 29893,
                commandDemon       = 119898,
                corruption         = 172,
                darkPact           = 108416,
                demonicGateway     = 111771,
                demonicCircle      = 48018,
                demonicTeleport    = 48020,
                devourMagic        = 19505,
                eyeOfKilrogg       = 126,
                felDomination      = 333889,
                fear               = 5782,
                grimoireFelhunter  = 111897,
                grimoireImp        = 111859,
                grimoireOfService  = 108501,
                grimoireSuccubus   = 111896,
                grimoireVoidwalker = 111895,
                healthFunnel       = 755,
                inquisitorsGaze    = 386344,
                howlOfTerror       = 5484,
                lifeTap            = 1454,
                mortalCoil         = 6789,
                ritualOfDoom       = 342601,
                ritualOfSummoning  = 698,
                shadowflame        = 384069,
                shadowfury         = 30283,
                shadowBulwark      = 119907,
                spellLock          = 19647,
                seduction          = 6358,
                singeMagic         = 89808,
                soulburn           = 385899,
                soulHarvest        = 196098,
                soulstone          = 20707,
                summonSoulkeeper   = 386256,
                --summonDoomguard             = 18540,
                subjugateDemon     = 1098,
                summonFelguard     = 30146,
                summonFelhunter    = 691,
                summonFelImp       = 688,
                summonImp          = 688,
                summonInfernal     = 1122,
                summonSuccubus     = 366222,
                summonVoidwalker   = 697,
                summonWrathguard   = 112870,
                unendingBreath     = 5697,
                unendingResolve    = 104773,
                unstableaffliction = 316099,

            },
            artifacts = {

            },
            buffs     = {
                burningRush         = 111400,
                demonicCircle       = 48018,
                demonicSynergy      = 171982,
                felDomination       = 333889,
                healthFunnel        = 755,
                grimoireOfSacrifice = 196099,
                sindoreiSpite       = 208871,
                soulHarvest         = 196098,
                soulstone           = 20707,
                unendingBreath      = 5697,
                unendingResolve     = 104773,
            },
            conduits  = {
                corruptingLeer = 339455,

            },
            covenants = {
                decimatingBolt       = 325289,
                impendingCatastrophe = 321792,
                scouringTithe        = 312321,
            },
            debuffs   = {
                decimatingBolt       = 325289,
                impendingCatastrophe = 321792,
                scouringTithe        = 312321,
                soulRot              = 325640,
                fear                 = 5782,
                curseOfExhaustion    = 334275,
                curseOfTongues       = 1714,
                curseOfWeakness      = 702,
            },
            glyphs    = {
                glyphOfTheFelImp = 219424,
            },
            talents   = {
                burningRush = 111400,
                darkPact    = 108416,
                demonSkin   = 219272,
                mortalCoil  = 6789,

            },
        },
    },
    WARRIOR = {
        -- Arms
        [71] = {
            abilities = {
                bladestorm      = 227847,
                cleave          = 845,
                colossusSmash   = 167105,
                commandingShout = 97462,
                deadlyCalm      = 262228,
                defensiveStance = 197690,
                dieByTheSword   = 118038,
                execute         = 163201,
                hamstring       = 1715,
                mortalStrike    = 12294,
                overpower       = 7384,
                piercingHowl    = 12323,
                ravager         = 152277,
                rend            = 772,
                slam            = 1464,
                sweepingStrikes = 260708,
                warbreaker      = 262161,
                whirlwind       = 1680,
            },
            artifacts = {

            },
            buffs     = {
                ashenJuggernaut = 335234,
                battlelord      = 346369,
                crushingAssault = 278826,
                deadlyCalm      = 262228,
                defensiveStance = 197690,
                exploiter       = 335452,
                inForTheKill    = 215550,
                overpower       = 60503,
                stoneHeart      = 225947,
                suddenDeath     = 52437,
                sweepingStrikes = 260708,
                testOfMight     = 275540,
            },
            conduits  = {
                ashenJuggernaut = 335232,
            },
            covenants = {
                condemn         = 317349,
                condemnMassacre = 330334,
            },
            debuffs   = {
                colossusSmash         = 208086,
                deepWounds            = 262115,
                executionersPrecision = 272870,
                hamstring             = 1715,
                rend                  = 772,
            },
            glyphs    = {
                glyphOfThunderStrike = 68164,
            },
            talents   = {
                avatar          = 107574,
                cleave          = 845,
                deadlyCalm      = 262228,
                defensiveStance = 197690,
                doubleTime      = 103827,
                dreadnaught     = 262150,
                fervorOfBattle  = 202316,
                inForTheKill    = 248621,
                massacre        = 281001,
                ravager         = 152277,
                rend            = 772,
                secondWind      = 29838,
                skullsplitter   = 260643,
                suddenDeath     = 29725,
                warMachine      = 262231,
                warbreaker      = 262161,
            },
            traits    = {
                seismicWave = 277639,
                testOfMight = 275529,
            }
        },
        -- Fury
        [72] = {
            abilities = {
                avatar              = 107574,
                bloodbath           = 335096,
                ravager             = 228920,
                bloodthirst         = 23881,
                crushingBlow        = 335098,
                deathWish           = 199261,
                enragedRegeneration = 184364,
                execute             = 5308,
                executeMassacre     = 280735,
                onslaught           = 315720,
                piercingHowl        = 12323,
                ragingBlow          = 85288,
                rampage             = 184367,
                recklessness        = 1719,
                thunderousRoar      = 384318,
                odynsFury           = 385059,
                whirlwind           = 190411,
            },
            artifacts = {

            },
            buffs     = {
                enragedRegeneration  = 184364,
                deathWish            = 199261,
                avatar               = 107574,
                enrage               = 184362,
                frenzy               = 335082,
                meatCleaver          = 85739,
                mercilessBonegrinder = 346574,
                recklessness         = 1719,
                suddenDeath          = 280776,
                whirlwind            = 85739,
            },
            conduits  = {

            },
            covenants = {
                condemn         = 317485,
                condemnMassacre = 330325,
            },
            debuffs   = {
            },
            glyphs    = {

            },
            talents   = {
                warMachine        = 346002,
                annihilator       = 383916,
                suddenDeath       = 280721,
                freshMeat         = 215568,
                impendingVictory  = 202168,
                stormBolt         = 107570,
                massacre          = 206315,
                frenzy            = 335077,
                onslaught         = 315720,
                boundingStride    = 202163,
                warpaint          = 208154,
                frothingBerserker = 215571,
                cruelty           = 392931,
                meatCleaver       = 280392,
                angerManagement   = 152278,
                recklessAbandon   = 396749,
            },
            traits    = {
                coldSteelHotBlood = 288080
            }
        },
        -- Protection
        [73] = {
            abilities = {
                demoralizingShout = 1160,
                devastate         = 20243,
                focusedRage       = 204488,
                impendingVictory  = 202168,
                intercept         = 198304,
                lastStand         = 12975,
                ravager           = 228920,
                revenge           = 6572,
                shieldBlock       = 2565,
                shieldSlam        = 23922,
                shieldWall        = 871,
                shockwave         = 46968,
                thunderClap       = 6343,
            },
            artifacts = {

            },
            buffs     = {
                avatar               = 107574,
                defensiveStance      = 71,
                lastStand            = 12975,
                revenge              = 5302,
                shieldBlock          = 132404,
                shieldWall           = 871,
                vengeanceFocusedRage = 202573,
                vengeanceIgnorePain  = 202574,
                vengeanceRevenge     = 202573,
                victorious           = 32216,
            },
            conduits  = {

            },
            covenants = {
                condemn = 317349,
            },
            debuffs   = {
                deepwoundsProt    = 115767,
                demoralizingShout = 1160,
                thunderClap       = 6343,
            },
            glyphs    = {

            },
            talents   = {
                bestServedCold     = 202560,
                warMachine         = 316733,
                bolster            = 280001,
                boomingVoice       = 202743,
                cracklingThunder   = 203201,
                devastator         = 236279,
                dragonRoar         = 118000,
                heavyRepercussions = 203177,
                indomitable        = 202095,
                intoTheFray        = 202603,
                menace             = 275338,
                neverSurrender     = 202561,
                punish             = 275334,
                ravager            = 228920,
                rumblingEarth      = 275339,
                unstoppableForce   = 275336,
            },
        },
        -- All
        Shared = {
            abilities  = {
                avatar            = 107574,
                battleShout       = 6673,
                berserkerRage     = 18499,
                charge            = 100,
                execute           = 163201,
                hamstring         = 1715,
                heroicLeap        = 6544,
                heroicThrow       = 57755,
                intimidatingShout = 5246,
                pummel            = 6552,
                rallyingCry       = 97462,
                shieldSlam        = 23922,
                slam              = 1464,
                shieldBlock       = 2565,
                stormBolt         = 107570,
                taunt             = 355,
                victoryRush       = 34428,
                ignorePain        = 190456,
                shatteringThrow   = 64382,
                spellReflection   = 23920,
                challengingShout  = 1161,
                intervene         = 3411,
                whirlwind         = 1680,
            },
            animas     = {
                bloodstainedWhetstone       = 322036,
                hurricaneHeart              = 329122,
                championsDecree             = 322054,
                periaptOfFuror              = 322049,
                pleonexianCommand           = 329165,
                rageMote                    = 322046,
                weatheredRunestone          = 349916,
                singingStones               = 329489,
                singingStonesOfIntimidation = 329484,
                singingStonesOfUnnerving    = 329488,
                tarnishedMedallion          = 348483,
                thunderingRoar              = 322093,
                zovaalsWarbanner            = 322027,
                bladedBulwark               = 322026,
                fanOfLongswords             = 322029,
                misshapenMirror             = 329268,
                shriekingFlagon             = 329275,
                voraciousCullingBlade       = 329213,
                kyrianWarhelm               = 314290,
                scratchedKnife              = 322039,
                signetOfTormentedKings      = 329345,
                smolderingInertia           = 322032,
                umbralEarTrumpet            = 329283,
                warlordsResolve             = 322051,
            },
            artifacts  = {

            },
            buffs      = {
                battleShout       = 6673,
                ignorePain        = 190456,
                spellReflection   = 23920,
                berserkerRage     = 18499,
                firstStrike       = 325381,
                fujiedasFury      = 207776,
                outburst          = 364010,
                seeingRed         = 364006,
                smolderingInertia = 322032,
                victorious        = 32216,
            },
            conduits   = {
                viciousContempt           = 337302,
                destructiveReverberations = 339939,
            },
            covenants  = {
                ancientAftershock = 325886,
                conquerorsBanner  = 324143,
                fleshcraft        = 324631,
                spearOfBastion    = 307865,
            },
            debuffs    = {
                markOfFyralath = 414532,
            },
            glyphs     = {

            },
            runeforges = {
                battlelord             = 335274,
                cadenceOfFujieda       = 335555,
                deathmaker             = 335567,
                elysianMight           = 357996,
                enduringBlow           = 335458,
                exploiter              = 335451,
                leaper                 = 335214,
                misshapenMirror        = 335253,
                recklessDefence        = 335582,
                reprisal               = 335718,
                seismicReverberation   = 335758,
                signetOfTormentedKings = 335266,
                sinfulSurge            = 354131,
                theWall                = 335239,
                thunderlord            = 335229,
                unhinged               = 335282,
                willOfTheBerserker     = 335594,
                unbreakableWill        = 335629,
            },
            talents    = {
                angerManagement  = 152278,
                doubleTime       = 103827,
                boundingStride   = 202163,
                impendingVictory = 202168,
                stormBolt        = 107570,
            },
        },
    },
    -- Global
    Shared = {
        Shared = {
            abilities        = {
                autoAttack     = 6603,
                autoShot       = 75,
                giftOfTheNaaru = br.getRacial("Draenei"), --select(7, GetSpellInfo(GetSpellInfo(28880))),
                global         = 61304,
                latentArcana   = 296971,
                lightsJudgment = 255647,
                quakingPalm    = 107079,
                racial         = br.getRacial(),
                shadowmeld     = 58984,
            },
            animas           = {
                scrollOfElchaver = 305006,
            },
            artifacts        = {
                artificialDamage           = 226829,
                artificialStamina          = 211309,
                concordanceOfTheLegionfall = 239042,
            },
            buffs            = {
                ancientHysteria                = 90355,
                battlePotionOfAgility          = 279152,
                battlePotionOfIntellect        = 279151,
                battlePotionOfStrength         = 279153,
                superiorBattlePotionOfAgility  = 298146,
                potionOfUnbridledFury          = 300714,
                blessingOfSacrifice            = 6940,
                greaterBlessingOfKings         = 203538,
                greaterBlessingOfWisdom        = 203539,
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
                racial                         = br.getRacial(),
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
            itemEnchantments = {
                --Dragonflight weapon Imbue's from inscription enchantments
                --Quality of aura should always be GOLD,SILVER,COPPER
                buzzingRune  = { 6514, 6513, 6512 },
                chirpingRune = { 6695, 6694, 6515 },
                howlingRune  = { 6518, 6517, 6516 },
                hissingRune  = { 6839, 6837, 6838 },
            },
            conduits         = {

            },
            covenants        = {
                covenantAbility = 313347,
                doorOfShadows   = 300728,
                fleshcraft      = 324631,
                soulshape       = 310143,
                flicker         = 324701,
                summonSteward   = 324739,
            },
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
            },
            essences         = {
            },
        },
    },
}
