local _, br = ...
br.lists.spells.HUNTER = br.lists.spells.HUNTER or {}
br.lists.spells.HUNTER.Shared = {
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
        }
