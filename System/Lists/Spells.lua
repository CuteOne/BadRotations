local function flipRace()
    local race = select(2,UnitRace("player"))
    local class = select(3,UnitClass("player"))
    if UnitBuffID("player",193863) then
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
    elseif UnitBuffID("player", 193864) then
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
    local forTheAlliance = UnitBuffID("player",193863) or false
    local forTheHorde = UnitBuffID("player", 193864) or false
    local race = select(2,UnitRace("player"))
    if forTheAlliance or forTheHorde then
        race = flipRace()
    end
    local BloodElfRacial
    local DraeneiRacial
    local OrcRacial

    if race == "BloodElf" or race == thisRace then
        BloodElfRacial = select(7, GetSpellInfo(GetSpellInfo(69179)))
    end
    if race == "Draenei" or race == thisRace then
        DraeneiRacial = select(7, GetSpellInfo(GetSpellInfo(28880)))
    end
    if race == "Orc" or race == thisRace then
        OrcRacial = select(7, GetSpellInfo(GetSpellInfo(33702)))
    end
    local racialSpells = {
        -- Alliance
        Dwarf    = 20594,           -- Stoneform
        Gnome    = 20589,           -- Escape Artist
        Draenei  = DraeneiRacial,   -- Gift of the Naaru
        Human    = 59752,           -- Every Man for Himself
        NightElf = 58984,           -- Shadowmeld
        Worgen   = 68992,           -- Darkflight
        -- Horde
        BloodElf = BloodElfRacial,  -- Arcane Torrent
        Goblin   = 69041,           -- Rocket Barrage
        Orc      = OrcRacial,       -- Blood Fury
        Tauren   = 20549,           -- War Stomp
        Troll    = 26297,           -- Berserking
        Scourge  = 7744,            -- Will of the Forsaken
        -- Both
        Pandaren = 107079,          -- Quaking Palm
        -- Allied Races
        HighmountainTauren  = 255654, -- Bull Rush
        LightforgedDraenei  = 255647, -- Light's Judgment
        Nightborne          = 260364, -- Arcane Pulse
        VoidElf             = 256948, -- Spatial Rift
        DarkIronDwarf       = 265221, -- Fireblood
        MagharOrc           = 274738, -- Ancestral Call
        ZandalariTroll      = 291944, -- Regeneratin'
        KulTiran            = 287712, -- Haymaker
		Vulpera				= 312411, -- Bag of Tricks
		Mechagnome 			= 312924, -- Hyper Organic Light Originator
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
            abilities                       = {
                asphyxiate                  = 221562,
                bloodBoil                   = 50842,
                dancingRuneWeapon           = 49028,
                deathsCaress                = 195292,
                gorefiendsGrasp             = 108199,
                heartStrike                 = 206930,
                marrowrend                  = 195182,
                runeTap                     = 194679,
                vampiricBlood               = 55233,
            },
            artifacts                       = {
                allConsumingRot             = 192464,
                bloodFeast                  = 192548,
                bonebreaker                 = 192538,
                coagulopathy                = 192460,
                consumption                 = 205223,
                danceOfDarkness             = 192514,
                grimPerseverance            = 192447,
                ironHeart                   = 192450,
                meatShield                  = 192453,
                mouthOfHell                 = 192570,
                rattlingBones               = 192557,
                sanguinaryAffinity          = 221775,
                skeletalShattering          = 192558,
                theHungeringMaw             = 214903,
                umbilicusEternus            = 193213,
                unendingThirst              = 192567,
                veinrender                  = 192457,
            },
            buffs                           = {
                boneShield                  = 195181,
                bloodShield                 = 77535,
                crimsonScourge              = 81136,
                dancingRuneWeapon           = 81256,
                runeTap                     = 194679,
                hemostasis                  = 273947,
                ossuary			    = 219786,
                tombstone                   = 219809,
                vampiricBlood               = 55233,
            },
            debuffs                         = {
                asphyxiate                  = 221562,
                blooddrinker                = 206931,
                heartStrike                 = 206930,
                markOfBlood                 = 206940,
            },
            glyphs                          = {

            },
            talents                         = {
                antimagicBarrier            = 205727,
                blooddrinker                = 206931,
                bloodTap                    = 221699,
                bloodworms                  = 195679,
                bonestorm                   = 194844,
                consumption                 = 274156,
                foulBulwark                 = 206974,
                markOfBlood                 = 206940,
                purgatory                   = 114556,
                rapidDecomposition          = 194662,
                redThirst                   = 205723,
                tighteningGrasp             = 206970,
                tombstone                   = 219809,
                voracious                   = 273953,
                wraithWalk                  = 212552,
                willOfTheNecropolis         = 206967,
            },
        },
        -- Frost
        [251] = {
            abilities                       = {
                empowerRuneWeapon           = 47568,
                frostStrike                 = 49143,
                frostwyrmsFury              = 279302,
                howlingBlast                = 49184,
                obliterate                  = 49020,
                pillarOfFrost               = 51271,
                remorselessWinter           = 196770,
            },
            artifacts                       = {

            },
            buffs                           = {
                breathOfSindragosa          = 155166,
                coldHeart                   = 281210,
                darkSuccor                  = 101568,
                empowerRuneWeapon           = 47568,
                eradicatingBlow             = 337936,
                frozenPulse                 = 195750,
                icyCitadel                  = 272723,
                icyTalons                   = 194879,
                killingMachine              = 51124,
                pillarOfFrost               = 51271,
                remorselessWinter           = 196770,
                rime                        = 59052,
                unleashedFrenzy             = 338501,
            },
            conduits                        = {
                eradicatingBlow             = 337934,
                everfrost                   = 337988,
                unleashedFrenzy             = 338492,
            },
            debuffs                         = {
                breathOfSindragosa          = 155166,
                remorselessWinter           = 196771,
            },
            glyphs                          = {

            },
            talents                         = {
                asphyxiate                  = 108194,
                avalanche                   = 207142,
                blindingSleet               = 207167,
                breathOfSindragosa          = 152279,
                coldHeart                   = 281208,
                deathsReach                 = 276079,
                frostscythe                 = 207230,
                frozenPulse                 = 194909,
                gatheringStorm              = 194912,
                glacialAdvance              = 194913,
                hornOfWinter                = 57330,
                hypothermicPresence         = 321995,
                icecap                      = 207126,
                icyTalons                   = 194878,
                inexorableAssault           = 253593,
                murderousEffeciency         = 207061,
                obliteration                = 281238,
                permafrost                  = 207200,
                runicAttenuation            = 207104,
            },
            traits                          = {
                frozenTempest               = 278487,
                icyCitadel                  = 272718,
            }
        },
        -- Unholy
        [252] = {
            abilities                       = {
                apocalypse                  = 275699,
                armyOfTheDead               = 42650,
                darkTransformation          = 63560,
                epidemic                    = 207317,
                festeringStrike             = 85948,
                outbreak                    = 77575,
                scourgeStrike               = 55090,
                -- Pet Abilities
                claw                        = 47468,
                gnaw                        = 47481,
                huddle                      = 47484,
                hook                        = 212468,
                leap                        = 47482,
            },
            artifacts                       = {

            },
            buffs                           = {
                corpseShield                = 207319,
                darkSuccor                  = 101568,
                darkTransformation          = 63560,
                festermight                 = 274373,
                huddle                      = 91838,
                necrosis                    = 207346,
                soulReaper                  = 215711,
                suddenDoom                  = 49530,
                runicCorruption             = 51460,
                unholyAssault               = 207289,
		        unholyBlight 		        = 115989,
            },
            conduits                        = {
                convocationOfTheDead        = 338553,
            },
            debuffs                         = {
                festeringWound              = 194310,
                soulReaper                  = 343294,
                unholyBlight                = 115994,
                virulentPlague              = 191587,
            },
            glyphs                          = {

            },
            talents                         = {
                allWillServe                = 194916,
                armyOfTheDamned             = 276837,
                asphyxiate                  = 108194,
                burstingSores               = 207264,
                clawingShadows              = 207311,
                deathsReach                 = 276079,
                defile                      = 152280,
                ebonFever                   = 207269,
                gripOfTheDead               = 273952,
                harbingerOfDoom             = 276023,
                infectedClaws               = 207272,
                pestilence                  = 277234,
                pestilentPustules           = 194917,
                soulReaper                  = 343294,
                spellEater                  = 207321,
                summonGargoyle              = 49206,
                unholyAssault               = 207289,
                unholyBlight                = 115989,
                unholyPact                  = 319230,
                wraithWalk                  = 212552
            },
            traits                          = {
                magusOfTheDead              = 288417,
            },
        },
        -- All
        Shared = {
            abilities                       = {
                antiMagicShell              = 48707,
                antiMagicZone               = 51052,
                chainsOfIce                 = 45524,
                consumption                 = 205224,
                controlUndead               = 111673,
                corpseExploder              = 127344,
                darkCommand                 = 56222,
                deathAndDecay               = 43265,
                deathCoil                   = 47541,
                deathGate                   = 50977,
                deathGrip                   = 49576,
                deathStrike                 = 49998,
                deathsAdvance               = 48265,
                iceboundFortitude           = 48792,
                lichborne                   = 49039,
                mindFreeze                  = 47528,
                pathOfFrost                 = 3714,
                raiseAlly                   = 61999,
                raiseDead                   = 46585,
                runeStrike                  = 316239,
                runeforging                 = 53428,
                sacraficialPact             = 327574,
            },
            artifacts                       = {

            },
            buffs                           = {
                antiMagicShell              = 48707,
                coldHeartItem               = 235599,
                deathAndDecay               = 188290,
                deathsDue                   = 324164,
                iceboundFortitude           = 48792,
                pathOfFrost                 = 3714,
                unholyStrength              = 53365,
                wraithWalk                  = 212552,
            },
            covenants                       = {
                abominationLimb             = 315443,
                deathsDue                   = 324128,
                shackleTheUnworthy          = 312202,
                swarmingMist                = 311648,
            },
            debuffs                         = {
                bloodPlague                 = 55078,
                chainsOfIce                 = 45524,
                controlUndead               = 111673,
                darkCommand                 = 56222,
                frostBreath                 = 190780,
                frostFever                  = 55095,
                razorice                    = 51714,
            },
            glyphs                          = {

            },
            runeforges                      = {
                bitingCold                  = 334678,
                deadliestCoil               = 334949,
                phearomones                 = 335177,
                superstrain                 = 334974,
            },
            talents                         = {
                deathPact                   = 48743,
                wraithWalk                  = 212552,
            },
        },
    },
    DEMONHUNTER = {
        -- Havoc
        [577] = {
            abilities                       = {
                annihilation                = 201427,
                bladeDance                  = 188499,
                blur                        = 198589,
                chaosNova                   = 179057,
                chaosStrike                 = 162794,
                darkness                    = 196718,
                deathSweep                  = 210152,
                demonsBite                  = 162243,
                eyeBeam                     = 198013,
                felRush                     = 195072,
                metamorphosis               = 191427,
                netherwalk                  = 196555,
                throwGlaive                 = 185123,
                vengefulRetreat             = 198793,
            },
            artifacts                       = {

            },
            buffs                           = {
                furiousGaze                 = 343312,
                innerDemon                  = 337313,
                metamorphosis               = 162264,
                momentum                    = 208628,
                prepared                    = 203650,
                unboundChaos                = 234059,
            },
            conduits                        = {
                serratedGlaive              = 339230,
            },
            debuffs                         = {
                essenceBreak                = 320338,
                exposedWound                = 339229,
            },
            glyphs                          = {

            },
            talents                         = {
                blindFury                   = 203550,
                burningHatred               = 320374,
                cycleOfHatred               = 258887,
                demonBlades                 = 203555,
                demonic                     = 213410,
                demonicAppetite             = 206478,
                desperateInstincts          = 205411,
                essenceBreak                = 258860,
                felBarrage                  = 258925,
                felEruption                 = 211881,
                firstBlood                  = 206416,
                glaiveTempest               = 342817,
                insatiableHunger            = 258876,
                masterOfTheGlaive           = 203556,
                momentum                    = 206476,
                netherwalk                  = 196555,
                soulRending                 = 204909,
                trailOfRuin                 = 258881,
                unboundChaos                = 347461,
                unleashedPower              = 206477,
            },
            traits                          = {
                chaoticTransformation       = 288754,
                eyesOfRage                  = 278500,
                furiousGaze                 = 273231,
                revolvingBlades             = 279581,
                unboundChaos                = 275144,
            },
        },
        -- Vengeance
        [581] = {
            abilities                       = {
                demonSpikes                 = 203720,
                felDevastation              = 212084,
                fieryBrand                  = 204021,
                infernalStrike              = 189110,
                metamorphosis               = 187827,
                shear                       = 203782,
                sigilOfChains               = 202138,
                sigilOfFlame                = 204596,
                sigilOfMisery               = 207684,
                sigilOfSilence              = 202137,
                soulCleave                  = 228477,
                throwGlaive                 = 204157,
            },
            artifacts                       = {

            },
            buffs                           = {
                bladeTurning                = 247254,
                demonSpikes                 = 203819,
                empowerWards                = 218256,
                feastofSouls                = 207693,
                felBombardment              = 337775,
                metamorphosis               = 187827,
                soulFragments               = 203981,
                siphonedPower               = 218561,
            },
            debuffs                         = {
                fieryBrand                  = 207744,
                frailty                     = 247456,
                sigilOfFlame                = 204598,
            },
            glyphs                          = {

            },
            talents                         = {
                abyssalStrike               = 207550,
                agonizingFlames             = 207548,
                bulkExtraction              = 320341,
                burningAlive                = 207739,
                charredFlesh                = 336639, --264002,
                concentratedSigils          = 207666,
                demonic                     = 321453,
                fallout                     = 227174,
                feastofSouls                = 207697,
                feedTheDemon                = 218612,
                fracture                    = 263642,
                infernalArmor               = 320331,
                lastResort                  = 209258,
                quickenedSigils             = 209281,
                ruinousBulwark              = 326853,
                sigilOfChains               = 202138,
                soulBarrier                 = 263648,
                soulRending                 = 217996,
                spiritBomb                  = 247454,
                voidReaver                  = 268175,
            },
        },
        -- Initial Demon Hunter 8-10
        [1456] = {
            abilities                       = {
                chaosStrike                 = 162794,
                demonsBite                  = 162243,
                felRush                     = 195072,
            },
            buffs                           = {

            },
            debuffs                         = {

            },
        },
        -- All
        Shared = {
            abilities                       = {
                consumeMagic                = 278326,
                disrupt                     = 183752,
                glide                       = 131347,
                immolationAura              = 258920,
                imprison                    = 217832,
                spectralSight               = 188501,
                throwGlaive                 = 185123,
                torment                     = 185245,
            },
            artifacts                       = {

            },
            buffs                           = {
                chaosTheory                 = 337567,
                felBombardment              = 337849,
                felCrystalInfusion          = 193547,
                gazeOfTheLegion             = 193456,
                glide                       = 131347,
                immolationAura              = 258920,
            },
            covenants                       = {
                elysianDecree               = 306830,
                fodderToTheFlame            = 329554,
                sinfulBrand                 = 317009,
                theHunt                     = 323639,
            },
            debuffs                         = {
                burningWound                = 346278,
                sinfulBrand                 = 317009,
            },
            glyphs                          = {
                glyphOfCracklingFlames      = 219831,
                glyphOfFallowWings          = 220083,
                glyphOfFearsomeMetamorphosis= 220831,
                glyphOfFelTouchedSouls      = 219713,
                glyphOfFelWings             = 220228,
                glyphOfFelEnemies           = 220240,
                glyphOfManaTouchedSouls     = 219744,
                glyphOfShadowEnemies        = 220244,
                glyphOfTatteredWings        = 220226,
            },
            runeforges                      = {
                burningWound                = 346279,
                chaosTheory                 = 337551,
                felBombardment              = 337775,
                razelikhsDefilement         = 337544,
            },
            talents                         = {
                felblade                    = 232893,
            },
        },
    },
    DRUID = {
        -- Balance
        [102] = {
            abilities                       = {
                celestialAlignment          = 194223,
                fullMoon                    = 274283,
                furyOfElune                 = 202770,
                halfMoon                    = 274282,
                innervate                   = 29166,
                starfire                    = 194153,
                newMoon                     = 274281,
                removeCorruption            = 2782,
                solarBeam                   = 78675,
                typhoon                     = 132469,
                wrath                       = 190984,
                starfall                    = 191034,
                starsurge                   = 78674,
                sunfire                     = 93402,
                stellarFlare                = 202347,
            },
            artifacts                       = {

            },
            buffs                           = {
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
                starLord                    = 279709,   --backwards compatible
                starlord                    = 279709,
                livelySpirit                = 279279,
                arcanicPulsar               = 287790,
                kindredEmpowerment          = 327022,
                onethsClearVision           = 338661,
                ravenousFrenzy              = 323546,
                PrimordialArcanicPulsar     = 338668,

            },
            conduits                        = {

            },
            covenants                       = {
                loneEmpowerment             = 338142,
            },
            debuffs                         = {
                stellarFlare                = 202347,
                moonfire                    = 164812,
                sunfire                     = 164815,
                stellarEmpowerment          = 197637,
            },
            glyphs                          = {

            },
            talents                         = {
                feralAffinity               = 202157,
                forceOfNature               = 205636,
                furyOfElune                 = 202770,
                guardianAffinity            = 197491,
                incarnationChoseOfElune     = 102560,
                naturesBalance              = 202430,
                newMoon                     = 274281,
                renewal                     = 108238,
                restorationAffinity         = 197492,
  --              shootingStars               = 202342,
                solstice                    = 343647,
                soulOfTheForest             = 114107,
                starlord                    = 202345,
                stellarDrift                = 202354,
                stellarFlare                = 202347,
                twinMoons                   = 279620,
                warriorOfElune              = 202425,

            },
            traits                          = {
                arcanicPulsar               = 287773,
                dawningSun                  = 276152,
                highNoon                    = 278505,
                lunarShrapnel               = 278507,
                powerOfTheMoon              = 273367,
                streakingStars              = 272871,
                sunblaze                    = 274397,
            }
        },
        -- Feral
        [103] = {
            abilities                       = {
                berserk                     = 106951,
                incapacitatingRoar          = 99, -- Guardian Affinity
                maim                        = 22570,
                moonfireFeral               = 155625,
                moonkinForm                 = 197625, -- Balance Affinity
                removeCorruption            = 2782,
                skullBash                   = 106839,
                stampedingRoar              = 77764,
                survivalInstincts           = 61336,
                swipe                       = 213764,
                thrashBear                  = 106832,
                tigersFury                  = 5217,
                typhoon                     = 132469, -- Balance Affinity
                ursolsVortex                = 102793, -- Restoration Affinity
                wildCharge                  = 49376,
            },
            artifacts                       = {

            },
            buffs                           = {
                apexPredator                = 255984,
                apexPredatorsCraving        = 339140,
                berserk                     = 106951,
                bloodtalons                 = 145152,
                clearcasting                = 135700,
                elunesGuidance              = 202060,
                fieryRedMaimers             = 236757,
                incarnationKingOfTheJungle  = 102543,
                ironJaws                    = 276021,
                jungleStalker               = 252071,
                predatorySwiftness          = 69369,
                savageRoar                  = 52610,
                scentOfBlood                = 285646,
                survivalInstincts           = 61336,
                tigersFury                  = 5217,
            },
            conduits                        = {

            },
            covenants                       = {
                empowerBond                 = 326446,
                loneEmpowerment             = 338142,
            },
            debuffs                         = {
                feralFrenzy                 = 274838,
                moonfireFeral               = 155625,
                rakeStun                    = 163505,
            },
            glyphs                          = {

            },
            talents                         = {
                balanceAffinity             = 197488,
                bloodtalons                 = 319439,
                brutalSlash                 = 202028,
                feralFrenzy                 = 274837,
                guardianAffinity            = 217615,
                incarnationKingOfTheJungle  = 102543,
                lunarInspiration            = 155580,
                momentOfClarity             = 236068,
                predator                    = 202021,
                primalWrath                 = 285381,
                renewal                     = 108238,
                restorationAffinity         = 197492,
                sabertooth                  = 202031,
                savageRoar                  = 52610,
                scentOfBlood                = 285564,
                soulOfTheForest             = 158476,
            },
            traits                          = {
                bloodMist                   = 279524,
                jungleFury                  = 274424,
                ironJaws                    = 276021,
                twistedClaws                = 275906,
                wildFleshrending            = 279527,
            }
        },
        -- Guardian
        [104] = {
            abilities                       = {
                berserk                     = 50334,
                incapacitatingRoar          = 99,
                incarnationGuardianOfUrsoc  = 102558,
                maul                        = 6807,
                removeCorruption            = 2782,
                skullBash                   = 106839,
                stampedingRoar              = 106898,
                survivalInstincts           = 61336,
            },
            artifacts                       = {

            },
            buffs                           = {
                berserk                     = 50334,
                galacticGuardian            = 213708,
                goryFur                     = 201671,
                incarnationGuardianOfUrsoc  = 102558,
                gore    					= 93622,
                pulverize                   = 158792,
                savageCombatant             = 340613,
                survivalInstincts           = 61336,
                toothAndClaw                = 135286,
            },
            conduits                        = {
                savageCombatant             = 340609,

            },
            covenants                       = {
                loneProtection              = 338018,
            },
            debuffs                         = {
                moonfireGuardian            = 164812,
                toothAndClaw                = 135601,
            },
            glyphs                          = {

            },
            talents                         = {
                balanceAffinity             = 197488,
                bloodFrenzy                 = 203962,
                brambles                    = 203953,
                bristlingFur                = 155835,
                earthwarden                 = 203974,
                feralAffinity               = 202155,
                galacticGuardian            = 203964,
                guardianOfElune             = 155578,
                incarnationGuardianOfUrsoc  = 102558,
                --lunarBeam                   = 204066,
                toothAndClaw                = 135288,
                renewal                     = 108238,
                pulverize                   = 80313,
                rendAndTear                 = 204053,
                restorationAffinity         = 197492,
                soulOfTheForest             = 158477,
                survivalOfTheFittest        = 203965,
            },
            traits                          = {
                layeredMane                 = 279552,
                twistedClaws                = 275906,
            },
        },
        -- Restoration
        [105] = {
            abilities                       = {
                efflorescence               = 145205,
                innervate                   = 29166,
                ironbark                    = 102342,
                lifebloom                   = 33763,
                naturesCure                 = 88423,
                nourish                     = 50464,
                revitalize                  = 212040,
                wrath                       = 5176,
                starfire                    = 197628,
                starsurge                   = 197626,
                sunfire                     = 93402,
                tranquility                 = 740,
                yserasGift                  = 145108,
                swipeResto                  = 213764,
                naturesSwiftness            = 132158,
            },
            artifacts                       = {

            },
            buffs                           = {
                abundance                   = 207640,
                cenarionWard                = 102352,
                clearcasting                = 16870,
                incarnationTreeOfLife       = 33891,
                innervate                   = 29166,
                groveTending                = 279793,
                rejuvenationGermination     = 155777,
                lifebloom                   = 33763,
                eclipse_lunar               = 48518,
                eclipse_solar               = 48517,
                --lunarEmpowerment            = 164547,
                regrowth                    = 8936,
                --solarEmpowerment            = 164545,
                soulOfTheForest             = 114108,
                cultivat                    = 200389,
                tranquility                 = 157982,
                springblossom               = 207386,
                symbolOfHope                = 64901,
                fullbloom                   = 290213,
                heartOfTheWild              = 108291,
            },
            conduits                        = {
                loneMeditation              = 338035,
            },
            debuffs                         = {
                moonfire                    = 164812,
                sunfire                     = 164815,
            },
            glyphs                          = {

            },
            runeforges                      = {
                theDarkTitansLesson         = 338831,

            },
            talents                         = {
                abundance                   = 207383,
                balanceAffinity             = 197632,
                cenarionWard                = 102351,
                cultivation                 = 200390,
                feralAffinity               = 197490,
                flourish                    = 197721,
                germination                 = 155675,
                guardianAffinity            = 197491,
                incarnationTreeOfLife       = 33891,
                innerPeace                  = 197073,
                nourish                     = 50464,
                overgrowth                  = 203651,
                photosynthesis              = 274902,
                --                prosperity                  = 200383,
                renewal                     = 108238,
                soulOfTheForest             = 158478,
                springBlossoms              = 207385,
                --                stonebark                   = 197061,

            },
            traits                          = {
                dawningSun                  = 276152,
                highNoon                    = 278505,
            }
        },
        -- All
        Shared = {
            abilities                       = {
                barkskin                    = 22812,
                bearForm                    = 5487,
                catForm                     = 768,
                charmWoodlandCreature       = 127757, -- Tome of the Wilds
                cyclone                     = 33786,
                dash                        = 1850,
                dreamwalk                   = 193753,
                entanglingRoots             = 339,
                ferociousBite               = 22568,
                flap                        = 164862,
                frenziedRegeneration        = 22842,
                growl                       = 6795,
                hibernate                   = 2637,
                ironfur                     = 192081,
                lunarStrikeAff              = 197628,
                mangle                      = 33917,
                moonfire                    = 8921,
                moonkinForm                 = 24858,
                mountForm                   = 210053,
                naturesControl              = 175682, -- It's still in the spellbook, for some reason.
                prowl                       = 5215,
                rake                        = 1822,
                rebirth                     = 20484,
                regrowth                    = 8936,
                rejuvenation                = 774,
                revive                      = 50769,
                rip                         = 1079,
                shadowmeld                  = 58984,
                shred                       = 5221,
                solarWrathMoonkin           = 197629,
                soothe                      = 2908,
                stampedingRoar              = 106898,
                starsurgeAff                = 197626,
                sunfireMoonkin              = 197630,
                swiftmend                   = 18562,
                swipeBear                   = 213771,
                swipeCat                    = 106785,
                teleportMoonglade           = 18960,
                thrashBear                  = 77758,
                thrashCat                   = 106830,
                travelForm                  = 783,
                treantForm                  = 114282,
                ursolsVortex                = 102793,
                wildGrowth                  = 48438,
                wrath                       = 5176,
            },
            artifacts                       = {

            },
            buffs                           = {
                barkskin                    = 22812,
                bearForm                    = 5487,
                burningEssence              = 138927,
                catForm                     = 768,
                dash                        = 1850,
                tigerDash                   = 252216,
                flightForm                  = 165962,
                frenziedRegeneration        = 22842,
                ironfur                     = 192081,
                kindredEmpowerment          = 327139,
                kindredSpirits              = 326434,
                loneSpirit                  = 338041,
                moonkinForm                 = 197625,
                prowl                       = 5215,
                rejuvenation                = 774,
                regrowth                    = 8936,
                shadowmeld                  = 58984,
                soulshape                   = 310143,
                stagForm                    = 210053,
                stampedingRoar              = 77764,
                suddenAmbush                = 340698,
                travelForm                  = 783,
                treantForm                  = 114282,
                wildGrowth                  = 48438,
            },
            conduits                        = {
                deepAllegiance              = 341378,
                tasteForBlood               = 340682,
            },
            covenants                       = {
                adaptiveSwarm               = 325727,
                convokeTheSpirits           = 323764,
                kindredSpirits              = 326434,
                ravenousFrenzy              = 323546,
            },
            debuffs                         = {
                adaptiveSwarm               = 325733,
                cyclone                     = 33786,
                entanglingRoots             = 339,
                growl                       = 6795,
                hibernate                   = 2637,
                moonfire                    = 8921,
                rake                        = 155722,
                rip                         = 1079,
                thrashBear                  = 192090,
                thrashCat                   = 106830,
                massEntanglement            = 102359,
            },
            glyphs                          = {
                glyphOfTheCheetah           = 131113,
                glyphOfTheDoe               = 224122,
                glyphOfTheFeralChameleon    = 210333,
                glyphOfTheOrca              = 114333,
                glyphOfTheSentinel          = 219062,
                glyphOfTheUrsolChameleon    = 107059,
            },
            runeforges                      = {
                apexPredatorsCraving        = 339139,
                eyeOfFearfullSymmetry       = 339141,
                frenzyband                  = 340053,
            },
            talents                         = {
                massEntanglement            = 102359,
                heartOfTheWild              = 319454,
                mightyBash                  = 5211,
                tigerDash                   = 252216,
                wildCharge                  = 102401,
            },
            traits                          = {
                livelySpirit                = 279642,
            },
        },
    },
    HUNTER = {
        -- BeastMastery
        [253] = {
            abilities                       = {
                aspectOfTheWild             = 193530,
                barbedShot                  = 217200,
                bestialWrath                = 19574,
                cobraShot                   = 193455,
                concussiveShot              = 5116,
                counterShot                 = 147362,
                intimidation                = 19577,
                killCommand                 = 34026,
                killShot                    = 53351,
                multishot                   = 2643,
            },
            artifacts                       = {

            },
            buffs                           = {
                aspectOfTheWild             = 193530,
                beastCleave                 = 118455,
                berserking                  = 26297,
                bestialWrath                = 19574,
                danceOfDeath                = 274443,
                direBeast                   = 120694,
                frenzy                      = 272790,
                parselsTongue               = 248084,
                spittingCobra               = 194407,
                volley                      = 194386
            },
            debuffs                         = {
                barbedShot                  = 217200,
            },
            glyphs                          = {

            },
            talents                         = {
                animalCompanion             = 267116,
                aspectOfTheBeast            = 191384,
                barrage                     = 120360,
                bindingShot                 = 109248,
                bloodshed                   = 321530,
                chimaeraShot                = 53209,
                direBeast                   = 120679,
                killerCobra                 = 199532,
                killerInstinct              = 273887,
                oneWithThePack              = 199528,
                scentOfBlood                = 193532,
                spittingCobra               = 257891,
                stampede                    = 201430,
                stomp                       = 199530,
                thrillOfTheHunt             = 257944,
            },
            traits                          = {
                danceOfDeath                = 274441,
                primalInstincts             = 279806,
                rapidReload                 = 278530,
            },
        },
        -- Marksmanship
        [254] = {
            abilities                       = {
                aimedShot                   = 19434,
                bindingShot                 = 109248, -- This is just an ability for marks (talent for BM/Surv)
                burstingShot                = 186387,
                concussiveShot              = 5116,
                counterShot                 = 147362,
                killShot                    = 53351,
                multishot                   = 257620,
                rapidFire                   = 257044,
                trueshot                    = 288613,
            },
            artifacts                       = {
            },
            buffs                           = {
                deadEye                     = 321461,
                doubleTap                   = 260402,
                feignDeath                  = 5384,
                inTheRhythm                 = 272733,
                lethalShots                 = 260395,
                lockAndLoad                 = 194594,
                masterMarksman              = 269576,
                preciseShots                = 260242,
                steadyFocus                 = 193534,
                trickShots                  = 257622,
                trueshot                    = 288613,
                unerringVision              = 274447,

            },
            debuffs                         = {
                aMurderOfCrows              = 131894,
                huntersMark                 = 257284,
                serpentSting                = 271788,
            },
            glyphs                          = {

            },
            talents                         = {
                barrage                     = 120360,--
                bindingShackles             = 321468,--
                callingTheShots             = 260404,--
                carefulAim                  = 260228,--
                chimaeraShot                = 342049,--
                deadEye                     = 321460,--
                doubleTap                   = 260402,--
                explosiveShot               = 212431,--
                lethalShots                 = 260393,--
                lockAndLoad                 = 194595,--
                masterMarksman              = 260309,--
                serpentSting                = 271788,--
                steadyFocus                 = 193533,--
                streamline                  = 260367,--
                volley                      = 260243,--
            },
            traits                          = {
                focusedFire                 = 278531,
                inTheRhythm                 = 264198,
                rapidReload                 = 278530,
                steadyAim                   = 277651,
                surgingShots                = 287707,
                unerringVision              = 274444,
            },
        },
        -- Survival
        [255] = {
            abilities                       = {
                aspectOfTheEagle            = 186289,
                carve                       = 187708,
                coordinatedAssault          = 266779,
                harpoon                     = 190925,
                intimidation                = 19577,
                killCommand                 = 259489,
                killShot                    = 320976,
                muzzle                      = 187707,
                pheromoneBomb               = 270323, -- Wildfire Infusion
                raptorStrike                = 186270,
                serpentSting                = 259491,
                shrapnelBomb                = 270335, -- Wildfire Infusion
                volatileBomb                = 271045, -- Wildfire Infusion
                wakeUp                      = 210000,
                wildfireBomb                = 259495,
            },
            artifacts                       = {

            },
            buffs                           = {
                aspectOfTheEagle            = 186289,
                blurOfTalons                = 277969,
                coordinatedAssault          = 266779,
                exposedFlank                = 252094, -- Tier 21
                mongooseFury                = 259388,
                tipOfTheSpear               = 260286,
                vipersVenom                 = 268552,
            },
            debuffs                         = {
                bloodseeker                 = 259277,
                internalBleeding            = 270343,
                latentPoison                = 273286,
                serpentSting                = 259491,
                shrapnelBomb                = 270339,
                wildfireBomb                = 269747,
            },
            glyphs                          = {

            },
            talents                         = {
                alphaPredator               = 269737,
                bindingShot                 = 109248,
                birdsOfPrey                 = 260331,
                bloodseeker                 = 260248,
                butchery                    = 212436,
                chakrams                    = 259391,
                flankingStrike              = 269751,
                guerrillaTactics            = 264332,
                hydrasBite                  = 260241,
                mongooseBite                = 259387,
                steelTrap                   = 162488,
                termsOfEngagement           = 265895,
                tipOfTheSpear               = 260285,
                vipersVenom                 = 268501,
                wildfireInfusion            = 271014,
            },
            traits                          = {
                blurOfTalons                = 277653,
                latentPoison                = 273283,
                primevalIntuition           = 288570,
                upCloseAndPersonal          = 278533,
                venomousFangs               = 274590,
                wildernessSurvival          = 279589,
            }
        },
        -- All
        Shared = {
            abilities                       = {
                -- Hunter Abilities
                arcaneShot                  = 185358,
                aspectOfTheChameleon        = 61648,
                aspectOfTheCheetah          = 186257,
                aspectOfTheTurtle           = 186265,
                chakrams                    = 259398,
                disengage                   = 781,
                eagleEye                    = 6197,
                exhilaration                = 109304,
                eyeOfTheBeast               = 321297,
                feignDeath                  = 5384,
                fireworks                   = 127933,
                flare                       = 1543,
                freezingTrap                = 187650,
                huntersMark                 = 257284,
                killShot                    = 53351,
                misdirection                = 34477,
                scareBeast                  = 1513,
                steadyShot                  = 56641,
                steelTrap                   = 162487,
                tarTrap                     = 187698,
                trackBeasts                 = 1494,
                trackDemons                 = 19878,
                trackDragonkin              = 19879,
                trackElementals             = 19880,
                trackGiants                 = 19882,
                trackHidden                 = 19885,
                trackHumanoids              = 19883,
                trackMechanicals            = 229533,
                trackUndead                 = 19884,
                tranquilizingShot           = 19801,
                wingClip                    = 195645,
                -- Pet Management
                beastLore                   = 1462,
                callPet                     = 9,
                callPet1                    = 883,
                callPet2                    = 83242,
                callPet3                    = 83243,
                callPet4                    = 83244,
                callPet5                    = 83245,
                commandPet                  = 272651,
                dismissPet                  = 2641,
                feedPet                     = 6991,
                fetch                       = 125050,
                mendPet                     = 136,
                playDead                    = 209997,
                revivePet                   = 982,
                tameBeast                   = 1515,
                wakeUp                      = 210000,
                ----------------------------
                -- Pet - Basic Abilities ---
                ----------------------------
                bite                        = 17253, -- Basalisk, Bat, Beetle, Blood Beast, Boar, Carapid, Carrion Bird, Chimera, Core Hound, Crocolisk, Devilsaur, Direhorn, Dragonhawk, Feathermane, Fox, Hound, Hydra, Hyena, Lizard, Mechanical, Pterrordax, Ravager, Ray, Riverbeast, Serpent, Shale Beast, Spider, Stone Hound, Turtle, Warp Stalker, Water Strider, Wind Serpent, Wolf, Worm
                claw                        = 16827, -- Aqiri, Bear, Bird of Prey, Cat, Crab, Raptor, Rodent, Scorpid, Spirit Beast, Tallstrider
                dash                        = 61684, -- Speed Increase (ALL PETS)
                smack                       = 49966, -- Camel, Clefthoof, Courser, Crane, Gorilla, Gruffhorn, Mammoth, Monkey, Moth, Oxen, Scalehide, Sporebat, Stag, Toad, Wasp
                growl                       = 2649, -- Taunt (ALL PETS)
                ---------------------------
                -- Pet - Spec Abilities ---
                ---------------------------
                primalRage                  = 264667, -- Ferocity Dmg Cd
                survivalOfTheFittest        = 264735, -- Tenacity Def Cd
                mastersCall                 = 53271, -- Cunning Freedom
                ------------------------------
                -- Pet - Special Abilities ---
                ------------------------------
                -- AOE
                burrowAttack                = 93433, -- Worm
                froststormBreath            = 92380, -- Chimera - Channeled Cone AOE
                -- Defense/Dodge
                agileReflexes               = 160011, -- Fox - Dodge
                bristle                     = 263869, -- Boar - Defensive
                bulwark                     = 279410, -- Carapid - Defensive
                catlikeReflexes             = 263892, -- Cat - Dodge
                defenseMatrix               = 263868, -- Mechanical - Defensive
                dragonsGuile                = 263887, -- Dragonhawk - Dodge
                featherFlurry               = 263916, -- Feathermane - Dodge
                fleethoof                   = 341117, -- Courser - Dodge
                hardenCarapace              = 90339, -- Beetle - Defensive
                obsidianSkin                = 263867, -- Core Hound - Defensive
                primalAgility               = 160044, -- Monkey - Dodge
                scaleShield                 = 263865, -- Scalehide - Defensive
                serpentSwiftness            = 263904, -- Serpent - Dodge
                shellShield                 = 26064, -- Turtle - Defensive
                solidShell                  = 160063, -- Shale Beast - Defensive
                swarmOfFlies                = 279336, -- Toad - Dodge
                wingedAgility               = 264360, -- Wind Serpent - Dodge
                -- Dispel
                chiJiTranq                  = 344350, -- Crane
                naturesGrace                = 344352, -- Stag
                netherEnergy                = 344349, -- Ray -- netherEnergy
                serenityDust                = 344353, -- Moth
                sonicScreech                = 344348, -- Bat -- sonicScreech
                soothingWater               = 344346, -- Water Strider
                spiritPulse                 = 344351, -- Spirit Beast -- spiritPulse
                sporeCloud                  = 344347, -- Sporebat
                -- Heal
                eternalGuardian             = 267922, -- Stone Hound - Ressurect
                feast                       = 159953, -- Devilsaur - Heal (req dead humanoid/beast nearby)
                spiritmend                  = 90361, -- Spirit Beast - Heal
                -- Mortal Wounds Debuff
                acidBite                    = 263863, -- Hydra - Mortal Wounds Debuff
                bloodyScreech               = 24423, -- Carrion Bird - Mortal Wounds Debuff
                deadlySting                 = 160060, -- Scorpid - Mortal Wounds Debuff
                gnaw                        = 263856, -- Rodent - Mortal Wounds Debuff
                gore                        = 263861, -- Direhorn - Mortal Wounds Debuff
                grievousBite                = 279362, -- Lizard - Mortal Wounds Debuff
                gruesomeBite                = 160018, -- Riverbeast - Mortal Wounds Debuff
                infectedBite                = 263853, -- Hyena - Mortal Wounds Debuff
                monsterousBite              = 54680, -- Devilsaur - Mortal Wounds Debuff
                ravage                      = 263857, -- Ravager - Mortal Wounds Debuff
                savageRend                  = 263854, -- Savage Rend - Mortal Wounds Debuff
                toxicSting                  = 263858, -- Wasp - Mortal Wounds Debuff
                -- Slow
                acidSpit                    = 263446, -- Worm - Slow
                ankleCrack                  = 50433, -- Crocolisk - Slow
                bloodBolt                   = 288962, -- Blood Beast - Slow
                dustCloud                   = 50285, -- Tallstrider - Slow
                frostBreath                 = 54644, -- Chimera - Slow
                furiousBite                 = 263840, -- Wolf - Slow
                lockJaw                     = 263423, -- Hound - Slow
                petrifyingGaze              = 263841, -- Basilisk - Slow
                pin                         = 50245, -- Crab - Slow
                talonRend                   = 263852, -- Bird of Prey - Slow
                tendonRip                   = 160065, -- Aqiri - Slow
                trample                     = 341118, -- Mammoth - Slow
                warpTime                    = 35346, -- Warp Stalker - Slow
                webSpray                    = 160067, -- Spider - Slow
                -- Slow Fall
                updraft                     = 160007, -- Feathermane/Pterrordax - Slow Fall
                -- Stealth
                prowl                       = 24450, -- Stealth
                spiritWalk                  = 90328, -- Spirit Beast - Stealth
                -- Tricks / Play / Rest
                play                        = 90347, -- Fox
                restBear                    = 94019, -- Bear
                restRodent                  = 126364, -- Rodent
                trickCrane                  = 126259, -- Crane
                trickBirdOfPrey             = 94022, -- Bird of Prey
                -- Water Walking
                surfaceTrot                 = 126311, -- Water Strider - Water Walking
            },
            artifacts                       = {

            },
            buffs                           = {
                aspectOfTheTurtle           = 186265,
                feignDeath                  = 5384,
                flayersMark                 = 324156, -- Covenant
                mendPet                     = 136,
                nesingwarysTrappingApparatus= 336744,
                playDead                    = 209997,
                prowl                       = 24450,
                spiritWalk                  = 90328,
                surfaceTrot                 = 126311, -- Water Strider - Water Walking
                updraft                     = 160007, -- Feathermane/Pterrordax - Slow Fall
                volley                      = 260243,
            },
            conduits                        = {

            },
            covenants                       = {
                deathChakram                = 325028,
                flayedShot                  = 324149,
                resonatingArrow             = 308491,
                wildSpirits                 = 328231,
            },
            debuffs                         = {
                bestialFerocity             = 191413,
                freezingTrap                = 3355,
                huntersMark                 = 257284,
                intimidation                = 24934,
                mortalWounds                = 115804, -- Pet Ability Debuff
                resonatingArrow             = 308498, -- Covenant
                soulforgeEmbers             = 331269, -- Covenant
                tarTrap                     = 135299,
                wildMark                    = 328275, -- Covenant
            },
            glyphs                          = {

            },
            runeforges                      = {
                eagletalonsTrueFocus        = 336849,
                nesingwarysTrappingApparatus= 336743,
                serpentstalkersTrickery     = 336870,
                soulforgeEmbers             = 336745,
                surgingShots                = 336867,
                qaplaEredunWarOrder         = 336830,
            },
            talents                         = {
                aMurderOfCrows              = 131894,
                bornToBeWild                = 266921,
                camouflage                  = 199483,
                naturalMending              = 270581,
                posthaste                   = 109215,
                trailblazer                 = 199921,
            },
        },
    },
    MAGE = {
        -- Arcane
        [62] = {
            abilities                       = {
                alterTime                   = 342245,
                arcaneBarrage               = 44425,
                arcaneBlast                 = 30451,
                arcaneFamiliar              = 205022,
                arcaneMissiles              = 5143,
                arcaneOrb                   = 153626,
                arcanePower                 = 12042,
                chargedUp                   = 205032,
                conjuremanaGem              = 759,
                displacement                = 212801,
                erosion                     = 205039,
                evocation                   = 12051,
              --  fireblast                   = 519836,
                greaterInvisibility         = 110959,
                markOfAluneth               = 224968,
                netherTempest               = 114923,
                presenceofMind              = 205025,
                prismaticBarrier            = 235450,
                runeofPower                 = 116011,
                slow                        = 31589,
                supernova                   = 157980,
                touchOfTheMagi              = 321507,
            },
            artifacts                       = {
                aegwynnsAscendance          = 187680,
                aegwynnsFury                = 187287,
                aegwynnsInperative          = 187264,
                aegwynnsIntensity           = 238054,
                aegwynnsWrath               = 187321,
                alunethsAvarice             = 238090,
                ancientPower                = 214917,
                arcanePurification          = 187313,
                arcaneRebound               = 188006,
                blastingRod                 = 187258,
                cracklingEnergy             = 187310,
                etherealSensitivity         = 187276,
                everywhereAtOnce            = 187301,
                forceBarrier                = 210716,
                intensityOfTheTirisgarde    = 241121,
                markOfAluneth               = 224968,
                mightOfTheGuardians         = 187318,
                ruleOfThrees                = 215463,
                sloooowDown                 = 210730,
                timeAndSpace                = 238126,
                torrentialBarrage           = 187304,
                touchOfTheMagi              = 210725,
            },
            buffs                           = {
              arcaneCharge                  = 36032,
              arcaneFamiliar                = 210126,
              arcanePower                   = 12042,
              -- arcaneCharge                  = 36032,
              evocation                     = 12051,
              expandedPotential             = 327495,
              arcaneMissles                 = 79683,
              presenceOfMind                = 205025,
              prismaticBarrier              = 235450,
              rhoninsAssaultingArmwraps     = 208081,
              runeofPower                   = 116011,
              ruleOfThrees                  = 264774,
              brainStorm                    = 273330,
              clearcasting                  = 263725,
            },
            debuffs                         = {
              arcaneCharge                  = 36032,
              netherTempest                 = 114923,
              touchoftheMagi                = 210824,


            },
            glyphs                          = {

            },
            talents                         = {
                arcaneEcho                  = 342231,
                amplification               = 236628,
                arcaneFamiliar              = 205022,
                arcaneOrb                   = 153626,
                chronoShift                 = 235711,
                mastersOfTime               = 342249,
                --erosion                     = 205039,
                netherTempest               = 114923,
                overpowered                 = 155147,
                resonance                   = 205028,
                reverberate                 = 281482,
                rulesOfThrees               = 264354,
                slipstream                  = 236457,
                supernova                   = 157980,
                timeAnomaly                 = 210805
                --temporalFlux                = 234302,
                --wordsOfPower                = 205035,
            },
            traits                         = {
                anomalousImpact             = 279867,
                arcanePressure              = 274594,
                arcanePummeling             = 270669,
                brainStorm                  = 273326,
                explosiveEcho               = 278537,
                galvanizingSpark            = 278536,
            },
        },
        -- Fire
        [63] = {
            abilities                       = {
                alterTime                   = 108978,
                blazingBarrier              = 235313,
                blastWave                   = 157981,
                cinderstorm                 = 198929,
                combustion                  = 190319,
                dragonsBreath               = 31661,
                fireball                    = 133,
                fireBlast                   = 108853,
                fireBlast2                  = 319836,
                flameOn                     = 205029,
                flamestrike                 = 2120,
                livingBomb                  = 44457,
                meteor                      = 153561,
                phoenixFlames              = 257541,
                pyroblast                   = 11366,
                scorch                      = 2948,
            },
            artifacts                       = {
                aftershocks                 = 194431,
                phoenixReborn               = 215773,
            },
            buffs                           = {
                blazingBarrier              = 235313,
                blasterMaster               = 274598,
                combustion                  = 190319,
                heatingUp                   = 48107,
                hotStreak                   = 48108,
                iceFloes                    = 108839,
                kaelthasUltimateAbility     = 209455,
                preheat                     = 273333,
                pyroclasm                   = 269651,
            },
            debuffs                         = {
                meteorBurn                  = 155158,
                cauterized                  = 87024,

            },
            glyphs                          = {

            },
            talents                         = {
                alexstraszasFury            = 235870,
                blastWave                   = 157981,
                blazingSoul                 = 235365,
                --cinderstorm                 = 198929,
                conflagration               = 205023,
                --controlledBurn              = 205033,
                freneticSpeed               = 236058,
                firestarter                 = 205026,
                flameOn                     = 205029,
                flamePatch                  = 205037,
                kindling                    = 155148,
                livingBomb                  = 44457,
                meteor                      = 153561,
                focusMagic                  = 321358,
                fromTheAshes                = 342344,
                pyromaniac                  = 205020,
                pyroclasm                   = 269650,
                searingTouch                = 269644,
            },
            traits                          = {
                preheat                     = 273332,
                blasterMaster               = 274596,
            }
        },
        -- Frost
        [64] = {
            abilities                       = {
                alterTime                   = 108978,
                blizzard                    = 190356,
                coldSnap                    = 235219,
                coneOfCold                  = 120,
                fireBlast                   = 108853,
                flurry                      = 44614,
                freeze                      = 231596,
                frostbolt                   = 116,
                frostBomb                   = 112948,
                frozenOrb                   = 84714,
                frozenTouch                 = 205030,
                fireBlast                   = 319836,
                iceBarrier                  = 11426,
                iceFloes                    = 108839,
                iceForm                     = 198144,
                iceLance                    = 30455,
                iceNova                     = 157997,
                icyVeins                    = 12472,
                petFreeze                   = 33395,
                rayOfFrost                  = 205021,
                runeofPower                 = 116011,
                removeCurse                 = 475,
                summonWaterElemental        = 31687,
                waterbolt                   = 31707,
            },
            artifacts                       = {
               -- icyHand                     = 220817,
            },
            buffs                           = {
                brainFreeze                 = 190446,
                concentratedCoolness        = 198148,
                freezingRain                = 270232,
                frostBomb                   = 112948,
                fingersOfFrost              = 44544,
                icyVeins                    = 12472,
                chainReaction               = 195418,
                zannesuJourney              = 226852,
                timeWarp                    = 80353,
                iceFloes                    = 108839,
                iceForm                     = 198144,
                iceBarrier                  = 11426,
                icicles                     = 205473,
                frozenMass                  = 242253,
            },
            debuffs                         = {
                chainsOfIce                 = 65173,
                chilled                     = 205708,
                frostBomb                   = 112948,
                frostNova                   = 122,
                iceNova                     = 157997,
                wintersChill                = 228358,
            },
            glyphs                          = {

            },
            talents                         = {
                --articGale                   = 205038,
                boneChilling                = 205027,
                cometStorm                  = 153595,
                chainReaction               = 278309,
                ebonbolt                    = 257537,
                --frostBomb                   = 112948,
                frozenTouch                 = 205030,
                frigidWinds                 = 235224,
                freezingRain                = 270233,
                focusMagic                  = 321358,
                glacialSpike                = 199786,
                glacialInsulation           = 235297,
                iceNova                     = 157997,
                iceFloes                    = 108839,
                lonelyWinter                = 205024,
                rayOfFrost                  = 205021,
                splittingIce                = 56377,
                thermalVoid                 = 155149,
            },
        },
        -- All
        Shared = {
            abilities                       = {
                fireBlast                   = 319836,
                frostbolt                   = 116,
                arcaneIntellect             = 1459,
                arcaneExplosion             = 1449,
                blink                       = 1953,
                counterspell                = 2139,
                conjureRefreshment          = 190336,
              --  fireBlast                   = 319836,
                frostBolt                   = 116,
                frostNova                   = 122,
                iceBlock                    = 45438,
                invisibility                = 66,
                mirrorImage                 = 55342,
                polymorph                   = 118,
                removeCurse                 = 475,
                ringOfFrost                 = 113724,
                runeOfPower                 = 116011,
                --shimmer                     = 212653,
                slowFall                    = 130,
                spellsteal                  = 30449,
                teleportExodar              = 32271,
                timeWarp                    = 80353,
                waterJet                    = 135029,
            },
            artifacts                       = {

            },
            buffs                           = {
                arcaneIntellect             = 1459,
                focusMagic                  = 321358,
                iceBlock                    = 45438,
                incantersFlow               = 1463,
         		slowFall	                = 130,
                runeOfPower                 = 116014,
            },
            conduits                        = {

            },
            covenants                       = {
                deathborne                  = 324220,
                mirrorsOfTorment            = 314793,
                radiantSpark                = 307443,
                shiftingPower               = 314791,
            },
            debuffs                         = {
                frostNova                   = 122,
            },
            glyphs                          = {

            },
            talents                         = {
                incantersFlow               = 1463,
                iceWard                     = 205036,
                focusMagic                  = 321358,
                ringOfFrost                 = 113724,
                runeOfPower                 = 116011,
                shimmer                     = 212653,
                --unstableMagic               = 157976,
            },
        },
    },
    MONK = {
        -- Brewmaster
        [268] = {
            abilities                       = {
                blackoutKick                = 205523,
                breathOfFire                = 115181,
                celestialBrew               = 322507,
                clash                       = 324312,
                invokeNiuzao                = 132578,
                kegSmash                    = 121253,
                purifyingBrew               = 119582,
                spearHandStrike             = 116705,
                spinningCraneKick           = 322729,
                zenMeditation               = 115176,
            },
            artifacts                       = {

            },
            buffs                           = {
                eyeOfTheTiger               = 196608,
                ironskinBrew                = 215479,
                blackoutCombo               = 228563,
                purifiedChi                 = 325092,
                rushingJadeWind             = 116847,
                zenMeditation               = 115176,
            },
            debuffs                         = {
                breathOfFire                = 146222,
                moderateStagger             = 124274,
                heavyStagger                = 124273,
                kegSmash                    = 121253,

            },
            glyphs                          = {

            },
            talents                         = {
                blackoutCombo               = 196736,
                blackOxBrew                 = 115399,
                blackOxStatue               = 115399,
                bobAndWeave                 = 280515,
                celestialFlame              = 325177,
                explodingKeg                = 325153,
                eyeOfTheTiger               = 196607,
                healingElixir               = 122281,
                highTolerance               = 196737,
                lightBrewing                = 325093,
                rushingJadeWind             = 116847,
                specialDelivery             = 196730,
                spitfire                    = 242580,
                summonBlackOxStatue         = 115315,
            },
        },
        -- Mistweaver
        [270] = {
            abilities                       = {
                detox                       = 115450,
                envelopingMist              = 124682,
                essenceFont                 = 191837,
                invokeYulon                 = 322118,
                lifeCocoon                  = 116849,
                reawaken                    = 212051,
                renewingMist                = 115151,
                revival                     = 115310,
                risingSunKick               = 107428,
                soothingMist                = 115175,
                thunderFocusTea             = 116680,
                invokeYulonTheJadeSerpent   = 322118,
                fortifyingBrew              = 243435,
            },
            artifacts                       = {
            },
            buffs                           = {
                soothingMist                = 115175,
                renewingMist                = 119611,
                envelopingMist              = 124682,
                thunderFocusTea             = 116680,
                lifeCyclesEnvelopingMist    = 197919,
                lifeCyclesVivify            = 197916,
                surgeOfMist                 = 246328,
                danceOfMist                 = 247891,
                upliftTrance                = 197206,
                refreshingJadeWind          = 196725,
                lifeCocoon                  = 116849,
                transcendence               = 101643,
                tigersLust                  = 116841,
                teachingsOfTheMonastery     = 202090,
                diffuseMagic                = 122783,
                dempenHarm                  = 122278,
                innervate                   = 29166,
                symbolOfHope                = 64901,
                manaTea                     = 197908,
                wayOfTheCrane               = 216113,
                essenceFont                 = 191840,
                risingMist                  = 22170,
                soothingMistJadeStatue      = 198533,
                envelopingBreath            = 3205209
            },
            debuffs                         = {
                mysticTouch                 = 8647,
            },
            glyphs                          = {
            },
            talents                         = {
                diffuseMagic                = 122783,
                focusedThunder              = 197895,
                healingElixir               = 122281,
                invokeChiJiTheRedCrane      = 325197,
                lifecycles                  = 197915,
                manaTea                     = 197908,
                mistWrap                    = 197900,
                refreshingJadeWind          = 196725,
                risingMist                  = 274909,
                songOfChiJi                 = 198898,
                spiritOfTheCrane            = 210802,
                summonJadeSerpentStatue     = 115313,
                upwelling                   = 274963,

            },
        },
        -- Windwalker
        [269] = {
            abilities                       = {
                disable                     = 116095,
                fistsOfFury                 = 113656,
                flyingSerpentKick           = 101545,
                flyingSerpentKickEnd        = 115057,
                fortifyingBrew              = 243435,
                invokeXuenTheWhiteTiger     = 123904,
                risingSunKick               = 107428,
                spearHandStrike             = 116705,
                stormEarthAndFire           = 137639,
                stormEarthAndFireFixate     = 221771,
                touchOfKarma                = 122470,
            },
            artifacts                       = {

            },
            buffs                           = {
                blackoutKick                = 116868,
                chiEnergy                   = 337571,
                danceOfChiJi                = 325202,
                hitCombo                    = 196741,
                pressurePoint               = 247255,
                rushingJadeWind             = 116847,
                serenity                    = 152173,
                stormEarthAndFire           = 137639,
                swiftRoundhouse             = 278710,
                theEmperorsCapacitor        = 235054,
                touchOfKarma                = 122470,
                transferThePower            = 195321,
                whirlingDragonPunch         = 152175,
            },
            debuffs                         = {
                disable                     = 116095,
                disableRoot                 = 116706,
                markOfTheCrane              = 228287,
                risingFist                  = 242259,
            },
            glyphs                          = {
                glyphOfRisingTigerKick      = 125151,
            },
            talents                         = {
                ascension                   = 115396,
                danceOfChiJi                = 325201,
                diffuseMagic                = 122783,
                energizingElixir            = 115288,
                eyeOfTheTiger               = 196607,
                fistOfTheWhiteTiger         = 261947,
                goodKarma                   = 280195,
                hitCombo                    = 196740,
                innerStrength               = 261767,
                rushingJadeWind             = 116847,
                serenity                    = 152173,
                spiritualFocus              = 280197,
                whirlingDragonPunch         = 152175,
            },
            traits                          = {
                gloryOfTheDawn              = 288634,
                openPalmStrikes             = 279918,
                swiftRoundhouse             = 277669,
            }
        },
        -- All
        Shared = {
            abilities                       = {
                blackoutKick                = 100784,
                cracklingJadeLightning      = 117952,
                detox                       = 218164,
                disablingTechnique          = 175697, -- Exists for some reason
                expelHarm                   = 322101,
                fortifyingBrew              = 115203,
                legSweep                    = 119381,
                paralysis                   = 115078,
                provoke                     = 115546,
                resuscitate                 = 115178,
                roll                        = 109132,
                spinningCraneKick           = 101546,
                tigerPalm                   = 100780,
                touchOfDeath                = 322109,
                transcendence               = 101643,
                transcendanceTransfer       = 119996,
                vivify                      = 116670,
                zenFlight                   = 125883,
                zenPilgrimage               = 126892,
            },
            artifacts                       = {

            },
            buffs                           = {
                theEmperorsCapacitor        = 235054,
                transcendence               = 101643,
                weaponsOfOrder              = 328908, --310454,
                weaponsOfOrderWW            = 310454, --311054,
            },
            conduits                        = {
                calculatedStrikes           = 336526,                    
            },
            covenants                       = {
                bonedustBrew                = 325216,
                faelineStomp                = 327104,
                fallenOrder                 = 326860,
                weaponsOfOrder              = 310454,
            },
            debuffs                         = {
                bonedustBrew                = 325216,
            },
            glyphs                          = {

            },
            talents                         = {
                celerity                    = 115173,
                chiBurst                    = 123986,
                chiTorpedo                  = 115008,
                chiWave                     = 115098,
                dampenHarm                  = 122278,
                ringOfPeace                 = 116844,
                tigerTailSweep              = 264348,
                tigersLust                  = 116841,
            },
        },
    },
    PALADIN = {
        -- Holy
        [65] = {
            abilities                       = {
                absolution                  = 212056,
                auraMastery                 = 31821,
                beaconOfLight               = 53563,
                cleanse                     = 4987,
                divineProtection            = 498,
                holyLight                   = 82326,
                holyShock                   = 20473,
                judgment                    = 275773,
                lightOfDawn                 = 85222,
                lightOfTheMartyr            = 183998,
            },
            artifacts                       = {

            },
            buffs                           = {
                auraMastery                 = 31821,
                avengingWrath               = 31884,
                avengingWrathCrit           = 294027,
                beaconOfLight               = 53563,
                beaconOfFaith               = 156910,
                blessingOfSacrifice         = 6940,
                beaconOfVirtue              = 200025,
                bestowFaith                 = 223306,
                glimmerOfLight              = 287280,
                divineProtection            = 498,
                divinePurpose               = 223819,
                ferventMartyr               = 223316,
                infusionOfLight             = 54149,
                ruleOfLaw                   = 214202,
                theLightSaves               = 200423,
                vindicator                  = 200376,
                avengingCrusader            = 216331,
                symbolOfHope                = 64901,
                divineSteed                 = 254474,
            },
            debuffs                         = {
                judgement                   = 214222,
                judgmentOfLight             = 196941,
                glimmerOfLight              = 287280,
                consecration                = 204242,

            },
            glyphs                          = {

            },
            talents                         = {
                avengingCrusader            = 216331,
                awakening                   = 248033,
                beaconOfFaith               = 156910,
                beaconOfVirtue              = 200025,
                bestowFaith                 = 223306,
                crusadersMight              = 196926,
                glimmerOfLight              = 325966,
                holyPrism                   = 114165,
                judgmentOfLight             = 183778,
                lightsHammer                = 114158,
                ruleOfLaw                   = 214202,
                sanctifiedWrath             = 53376,
                savedByTheLight             = 157047,
            },
            traits                          = {
                breakingDawn                = 278594,
                graceoftheJusticar          = 278593,
                indomitableJustice          = 275496,
            },
            runeforges                      = {
                shadowbreaker               = 337812,
            }
        },
        -- Protection
        [66] = {
            abilities                       = {
                ardentDefender              = 31850,
                avengersShield              = 31935,
                blessedHammer               = 229976,
                cleanseToxins               = 213644,
                divineProtection            = 498,
                guardianOfAncientKings      = 86659,
                hammerOfTheRighteous        = 53595,
                judgment                    = 275779,
                judgmentsOfTheWise          = 105424,
                rebuke                      = 96231,
                righteousFury               = 25780,
            },
            artifacts                       = {

            },
            buffs                           = {
                ardentDefender              = 31850,
                avengingWrath               = 31884,
                bulwarkOfOrder              = 209388,
                consecration                = 188370,
                divineShield                = 642,
                divinePurpose               = 223819,
                guardianOfAncientKings      = 86659,
                shieldOfTheRighteous        = 132403,
                shiningLight                = 327510,
                avengersValor               = 197561,
                divineSteed                 = 254474,
                royalDecree                 = 340147,
            },
            debuffs                         = {
                blessedHammer               = 204301,
                judgmentOfLight             = 196941,
                judgment                    = 197277,
            },
            glyphs                          = {

            },
            talents                         = {
                blessedHammer               = 204019,
                blessingOfSpellwarding      = 204018,
                consecratedGround           = 204054,
                crusadersJudgment           = 204023,
                finalStand                  = 204077,
                firstAvenger                = 203776,
                handOfTheProtector          = 315924,
                holyShield                  = 152261,
                judgmentOfLight             = 183778,
                momentOfGlory               = 327193,
                redoubt                     = 280373,
                righteousProtector          = 204074,
                sanctifiedWrath             = 171648,
            },
            traits                          = {
                bulwarkOfLight              = 272976,
            },
        },
        -- Retribution
        [70] = {
            abilities                       = {
                bladeOfJustice              = 184575,
                cleanseToxins               = 213644,
                divineStorm                 = 53385,
                handOfHindrance             = 183218,
                rebuke                      = 96231,
                shieldOfVengeance           = 184662,
                templarsVerdict             = 85256,
                wakeOfAshes                 = 255937,
            },
            artifacts                       = {

            },
            buffs                           = {
                crusade                     = 231895,
                divinePurpose               = 223819,
                divineRight                 = 278523,
                empyreanPower               = 326733, --286393,
                selflessHealer              = 114250,
                divineSteed                 = 221883,
            },
            debuffs                         = {
                executionSentence           = 267798,
                finalReckoning              = 343721,
                judgment                    = 197277,
            },
            glyphs                          = {
                glyphOfWingedVengeance      = 57979,
            },
            talents                         = {
                bladeOfWrath                = 231832,
                crusade                     = 231895,
                empyreanPower               = 326732,
                executionSentence           = 343527,
                eyeForAnEye                 = 205191,
                finalReckoning              = 343721,
                firesOfJustice              = 203316,
                healingHands                = 326734,
                justicarsVengeance          = 215661,
                righteousVerdict            = 267610,
                sanctifiedWrath             = 317866,
                selflessHealer              = 85804,
                zeal                        = 269569,
            },
            traits                          = {
                divineRight                 = 278523,
            },
        },
        -- All
        Shared = {
            abilities                       = {
                avengingWrath               = 31884,
                blessingOfFreedom           = 1044,
                blessingOfProtection        = 1022,
                blessingOfSacrifice         = 6940,
                concentrationAura           = 317920,
                consecration                = 26573,
                crusaderAura                = 32223,
                crusaderStrike              = 35395,
                devotionAura                = 465,
                divineShield                = 642,
                divineSteed                 = 190784,
                flashOfLight                = 19750,
                hammerOfJustice             = 853,
                hammerOfWrath               = 24275,
                handOfReckoning             = 62124,
                judgment                    = 20271,
                layOnHands                  = 633,
                redemption                  = 7328,
                retributionAura             = 183435,
                senseUndead                 = 5502,
                shieldOfTheRighteous        = 53600,
                turnEvil                    = 10326,
                wordOfGlory                 = 85673,
				contemplation               = 121183,
            },
            artifacts                       = {

            },
            buffs                           = {
                avengingWrath               = 31884,
                consecration                = 26573,
                concentrationAura           = 317920,
                crusaderAura                = 32223,
                devotionAura                = 465,
                divineShield                = 642,
                blessingOfProtection        = 1022,
                holyAvenger                 = 105809,
                retributionAura             = 183435,
                seraphim                    = 152262,
            },
            conduits                        = {

            },
            covenants                       = {
                ashenHallow                 = 316958,
                blessingOfTheSeasons        = 328278,
                blessingOfAutumn            = 328622,
                blessingOfSpring            = 328282,
                blessingOfSummer            = 328620,
                blessingOfWinter            = 328281,
                divineToll                  = 304971,
                vanquishersHammer           = 328204,
            },
            debuffs                         = {
                blindingLight               = 105421,
                forbearance                 = 25771,
                hammerOfJustice             = 853,
                turnEvil                    = 10326,
                handOfReckoning             = 62124,
            },
            glyphs                          = {
                glyphOfFireFromHeavens      = 57954,
                glyphOfPillarOfLight        = 146959,
                glyphOfTheLuminousCharger   = 89401,
                glyphOfTheQueen             = 212642,
            },
            talents                         = {
                blindingLight               = 115750,
                cavalier                    = 230332,
                divinePurpose               = 223817,
                fistOfJustice               = 234299,
                holyAvenger                 = 105809,
                repentance                  = 20066,
                seraphim                    = 152262,
                unbreakableSpirit           = 114154,
            },
        },
    },
    PRIEST = {
        -- Discipline
        [256] = {
            abilities                       = {
                angelicFeather              = 121536,
              --clarityOfWill               = 152118,
                divineStar                  = 110744,
                desperatePrayer             = 19236,
                evangelism                  = 246287,
                flashHeal                   = 2061,
                halo                        = 120517,
                holyNova                    = 132157,
                leapOfFaith                 = 73325,
                mindbender                  = 123040,
                mindBlast                   = 8092,
                mindControl                 = 205364,
                mindSear                    = 48045,
                mindSoothe                  = 453,
                mindVision                  = 2096,
                painSuppression             = 33206,
                penance                     = 47540,
              --plea                        = 200829,
                powerInfusion               = 10060,
                powerWordBarrier            = 62618,
                powerWordRadiance           = 194509,
                powerWordShield             = 17,
                powerWordSolace             = 129250,
                psychicScream               = 8122,
                purgeTheWicked              = 204197,
                purify                      = 527,
                rapture                     = 47536,
                schism                      = 214621,
                shadowfiend                 = 34433,
                shadowMend                  = 186263,
                shiningForce                = 204263,
                sinsOfTheMany               = 198076,
                smite                       = 585,
            },
            artifacts                       = {
              --sinsOfTheMany               = 198074,
            },
            buffs                           = {
                angelicFeather              = 121557,
                atonement                   = 194384,
                bodyAndSoul                 = 65081,
                borrowedTime                = 197763,
                depthOfTheShadows           = 275544,
              --clarityOfWill               = 152118,
                innervate                   = 29166,
                overloadedWithLight         = 223166,
                penitent                    = 246519,
              --powerInfusion               = 10060,
                powerOfTheDarkSide          = 198069,
                powerWordShield             = 17,
                rapture                     = 47536,
                speedOfThePious             = 197767,
                symbolOfHope                = 64901,
            },
            debuffs                         = {
                weakenedSoul                = 6788,
                purgeTheWicked              = 204213,
                schism                      = 214621,
                smite                       = 585,
            },
            glyphs                          = {

            },
            talents                         = {
                angelicFeather              = 121536,
                bodyAndSoul                 = 64129,
                castigation                 = 193134,
              --clarityOfWill               = 152118,
                contrition                  = 197419,
                divineStar                  = 110744,
                dominantMind                = 205367,
                evangelism                  = 246287,
              --grace                       = 200309,
                halo                        = 120517,
                lenience                    = 238063,
                masochism                   = 193063,
                mindbender                  = 123040,
               --powerInfusion               = 10060,
                powerWordSolace             = 129250,
                purgeTheWicked              = 204197,
                psychicVoice                = 196704,
                schism                      = 214621,
                shadowCovenant              = 314867,
                shieldDiscipline            = 197045,
                spiritShell                 = 109964,
                sinsOfTheMany               = 280391,
                shiningForce                = 204263,
              --thePenitent                 = 200347,
                twistOfFate                 = 265259,
            },
            traits                          = {
                giftOfForgiveness           = 277680,
            },
        },
        -- Holy
        [257] = {
            abilities                       = {
                angelicFeather              = 121536,
                bodyAndMind                 = 214121,
                circleOfHealing             = 204883,
                desperatePrayer             = 19236,
                divineHymn                  = 64843,
                divineStar                  = 110744,
                flashHeal                   = 2061,
                guardianSpirit              = 47788,
                holyFire                    = 14914,
                holyNova                    = 132157,
                holyWordChastise            = 88625,
                holyWordSanctify            = 34861,
                holyWordSerenity            = 2050,
                holyWordSalvation           = 265202,
                heal                        = 2060,
                leapOfFaith                 = 73325,
                lightOfTuure                = 33076,
                prayerOfHealing             = 596,
                prayerOfMending             = 33076,
                purify                      = 527,
                renew                       = 139,
                smite                       = 585,
                symbolOfHope                = 64901,
            },
            artifacts                       = {
--                lightOfTuure                = 208065,
            },
            buffs                           = {
                angelicFeather              = 121557,
                blessingOfTuure             = 196578,
                divinity                    = 197031,
                echoOfLight                 = 77489,
                powerOfTheNaaru             = 196489,
                prayerOfMending             = 41635,
                renew                       = 139,
                surgeOfLight                = 109186,
                spiritOfRedemption          = 27827,
            },
            debuffs                         = {


            },
            glyphs                          = {

            },
            talents                         = {
                angelicFeather              = 121536,
                apotheosis                  = 200183,
                bindingHeal                 = 32546,
                --bodyAndMind                 = 214121,
                divineStar                  = 110744,
                --divinity                    = 197031,
                halo                        = 120517,
                --piety                       = 197034,
                shiningForce                = 204263,
                surgeOfLight                = 109186,
                --symbolOfHope                = 64901,
            },
        },
        -- Shadow
        [258] = {
            abilities                       = {
                darkAscension               = 280711,
                dispersion                  = 47585,
                devouringPlague             = 335467,
                mindBlast                   = 8092,
                mindBomb                    = 205369,
                mindbender                  = 200174,
                mindFlay                    = 15407,
                mindSear                    = 48045,
                mindVision                  = 2096,
                powerInfusion               = 10060,
                powerWordShield             = 17,
                psychicHorror               = 64044,
                psychicScream               = 8122,
                purifyDisease               = 213634,
                shadowMend                  = 186263,
                shadowWordVoid              = 205351,
                shadowfiend                 = 34433,
                shadowform                  = 232698,
                silence                     = 15487,
                surrenderToMadness          = 193223,
                vampiricEmbrace             = 15286,
                vampiricTouch               = 34914,
                voidBolt                    = 205448,
                devoidBolt                  = 343355,
                voidEruption                = 228260,
                voidForm                    = 228264,
            },
            artifacts                       = {
                lashOfInsanity              = 238137,
                massHysteria                = 194378,
                sphereOfInsanity            = 194179,
                toThePain                   = 193644,
                touchOfDarkness             = 194007,
                unleashTheShadows           = 194093,
                voidCorruption              = 194016,
                voidTorrent                 = 205065,
            },
            buffs                           = {
                chorusOfInsanity            = 279572,
                darkThoughts                = 341207,
                dispersion                  = 47585,
                dissonantEchoes             = 343144,
                harvestedThoughts           = 288343,
                lingeringInsanity           = 199849,
                powerWordShield             = 17,
                powerInfusion               = 10060,
                shadowyInsight              = 124430,
                shadowform                  = 232698,
                surrenderedSoul             = 212570,
                surrenderToMadness          = 193223,
                thoughtsHarvester           = 288340,
                unfurlingDarkness           = 341282,
                void                        = 211657,
                voidForm                    = 194249,
                voidTorrent                 = 205065,
                zeksExterminatus            = 236546, -- Legendary Cloak proc
            },
            debuffs                         = {
                devouringPlague             = 335467,
                mindFlay                    = 15407,
                vampiricTouch               = 34914,
                weakenedSoul                = 6788,

            },
            glyphs                          = {

            },
            talents                         = {
                auspiciousSpirits           = 155271,
                bodyAndSoul                 = 64129,
                fortressOfTheMind           = 193195,
                --mania                       = 193173,
                --masochism                   = 193063,
                mindBomb                    = 205369,
                mindbender                  = 200174,
                misery                      = 238558,
                --powerInfusion               = 10060,
                psychicHorror               = 64044,
                --psychicVoice                = 196704,
                --reaperOfSouls               = 199853,
                sanlayn                     = 199855,
                searingNightmare            = 341385,
                shadowCrash                 = 205385,
                surrenderToMadness          = 319952,
                twistOfFate                 = 109142,
                --voidRay                     = 205371,
                voidTorrent                 = 263165,
            },
            traits                          = {
                chorusOfInsanity            = 278661,
                deathThroes                 = 278659,
                searingDialogue             = 272788,
                spitefulApparitions         = 277682,
                thoughtHarvester            = 288340,
                whispersOfTheDamned         = 275722,
            },
        },
        -- All
        Shared = {
            abilities                       = {
                ascendedBlast               = 325283,
                ascendedNova                = 325020,
                boonOfTheAscended           = 325013,
                desperatePrayer             = 19236,
                dispelMagic                 = 528,
                fade                        = 586,
                flashHeal                   = 2061,
                leapOfFaith                 = 73325,
                levitate                    = 1706,
                massDispel                  = 32375,
                massResurrection            = 212036,
                mindBlast                   = 8092,
                mindControl                 = 605,
                mindgames                   = 323673,
                mindSoothe                  = 453,
                mindVision                  = 2096,
                powerInfusion               = 10060,
                powerWordFortitude          = 21562,
                powerWordShield             = 17,
                psychicScream               = 8122,
                resurrection                = 2006,
                shadowWordDeath             = 32379,
                shadowWordPain              = 589,
                shackleUndead               = 9484,
                shadowWordPain              = 589,
                smite                       = 585,
            },
            artifacts                       = {

            },
            buffs                           = {
                classHallSpeed              = 224098,
                boonOfTheAscended           = 325013,
                faeGuardians                = 327661,
                levitate                    = 111759,
                powerWordFortitude          = 21562,
                powerWordShield             = 17,

            },
            conduits                        = {
                dissonantEchoes             = 338342,
            },
            covenants                       = {
                boonOfTheAscended           = 325013,
                ascendedBlast               = 325315,
                ascendedEruption            = 325326,
                ascendedNova                = 325020,
                faeGuardians                = 327661,
                mindgames                   = 323673,
                unholyNova                  = 324724,
            },
            debuffs                         = {
                shadowWordPain              = 589,
                weakenedSoul                = 6788,
                wrathfulFaerie              = 327703,

            },
            glyphs                          = {

            },
            talents                         = {

            },
        },
    },
    ROGUE = {
        -- Assassination
        [259] = {
            abilities                       = {
                blindside                   = 111240,
                ambush                      = 8676,
                crimsonTempest              = 121411,
                deadlyPoison                = 2823,
                envenom                     = 32645,
                eviscerate                  = 196819,
                exsanguinate                = 200806,
                fanOfKnives                 = 51723,
                garrote                     = 703,
                mutilate                    = 1329,
                poisonedKnife               = 185565,
                rupture                     = 1943,
                shadowstep                  = 36554,
                sinisterStrike              = 1752,
                toxicBlade                  = 245388,
                vendetta                    = 79140,
            },
            artifacts                       = {

            },
            buffs                           = {
                blindside                   = 111240,
                deadlyPoison                = 2823,
                elaboratePlanning           = 193641,
                envenom                     = 32645,
                hiddenBlades                = 270070,
                leechingPoison              = 108211,
                sharpenedBlades             = 272916,
                masterAssassin              = 256735,
                subterfuge                  = 115192,
                theDreadlordsDeceit         = 208692,
            },
            debuffs                         = {
                crimsonTempest              = 121411,
                deadlyPoison                = 2818,
                garrote                     = 703,
                internalBleeding            = 154953,
                rupture                     = 1943,
                surgeOfToxins               = 192425,
                toxicBlade                  = 245389,
                vendetta                    = 79140,
            },
            glyphs                          = {

            },
            talents                         = {
                blindside                   = 111240,
                crimsonTempest              = 121411,
                elaboratePlanning           = 193640,
                elusiveness                 = 79008,
                exsanguinate                = 200806,
                hiddenBlades                = 270061,
                internalBleeding            = 154904,
                ironWire                    = 196861,
                leechingPoison              = 280716,
                masterAssassin              = 255989,
                masterPoisoner              = 196864,
                nightstalker                = 14062,
                poisonBomb                  = 255544,
                subterfuge                  = 108208,
                toxicBlade                  = 245388,
                venomRush                   = 152152,
            },
            traits                          = {
                doubleDose                  = 273007,
                echoingBlades               = 287649,
                sharpenedBlades             = 272911,
                shroudedSuffocation         = 278666,
		        twistTheKnife               = 273488,
            },
            runeforge                         = {
                dashingScoundrel            = 340081,
                doomblade                   = 340082,
                zoldyckInsignia             = 340083,
                duskwalkersPatch            = 340084,
            },
        },
        -- Outlaw
        [260] = {
            abilities                       = {
                adrenalineRush              = 13750,
                ambush                      = 8676,
                betweenTheEyes              = 315341,
                bladeFlurry                 = 13877,
                bladeRush                   = 271877,
                blind                       = 2094,
                curseOfTheDreadblades       = 202665,
                dispatch                    = 2098,
                ghostlyStrike               = 196937,
                gouge                       = 1776,
                grapplingHook               = 195457,
                killingSpree                = 51690,
                masteryMainGauche           = 76806,
                pistolShot                  = 185763,
                riposte                     = 199754,
                rollTheBones                = 315508,
                sinisterStrike              = 193315,
                dreadblades                 = 343142,
            },
            artifacts                       = {
                blackPowder                 = 216230,
                bladeDancer                 = 202507,
                bladeMaster                 = 202628,
                blunderbuss                 = 202897,
                blurredTime                 = 202769,
                cannonballBarrage           = 185767,
                curseOfTheDreadblades       = 202665,
                cursedEdge                  = 202463,
                cursedSteel                 = 214929,
                deception                   = 202755,
                fatesThirst                 = 202514,
                fatebringer                 = 202524,
                fortuneStrikes              = 202530,
                fortunesBoon                = 202907,
                fortunesStrike              = 202521,
                ghostlyShell                = 202533,
                greed                       = 202820,
                gunslinger                  = 202522,
                hiddenBlade                 = 202573,
                killingSpree                = 51690,
                loadedDice                  = 238139,
            },
            buffs                           = {
                adrenalineRush              = 13750,
                alacrity                    = 193538,
                bladeFlurry                 = 13877,
                blunderbuss                 = 202895,
                broadside                   = 193356,
                buriedTreasure              = 199600,
                deadShot                    = 272940,
                grandMelee                  = 193358,
                greenskinsWaterloggedWristcuffs = 209420,
                hiddenBlade                 = 202754,
                jollyRoger                  = 199603,
                loadedDice                  = 256171,
                opportunity                 = 195627,
                ruthlessPrecision           = 193357,
                rollTheBones                = {
                    broadside                   = 193356,
                    buriedTreasure              = 199600,
                    grandMelee                  = 193358,
                    ruthlessPrecision           = 193357,
                    skullAndCrossbones          = 199603,
                    trueBearing                 = 193359,
                },
                sharkInfestedWaters         = 193357,
                skullAndCrossbones          = 199603,
                snakeeeyes                  = 275863, --typo, leaving in not to break stuff
                snakeeyes                   = 275863,
                swordplay                   = 211669,
                trueBearing                 = 193359,
                wits                        = 288988,
            },
            debuffs                         = {
                ghostlyStrike               = 196937,
                gouge                       = 1776,
                betweenTheEyes              = 199804,
                preyOnTheWeak               = 255909,
                blind                       = 2094,
            },
            glyphs                          = {

            },
            talents                         = {
                acrobaticStikes             = 196924, -- typo, leaving in to not break old profiles
                acrobaticStrikes            = 196924,
                dirtyTricks                 = 108216,
                bladeRush                   = 271877,
                ghostlyStrike               = 196937,
                grapplingHook               = 256188,
                hitAndRun                   = 196922,
                ironStomach                 = 193546,
                killingSpree                = 51690,
                weaponmaster                = 200733,
                quickDraw                   = 196938,
                blindingPowder              = 256165,
                loadedDice                  = 256170,
                alacrity                    = 193539,
                dancingSteel                = 272026,
                dreadblades                 = 343142,
            },
             traits                          = {
                deadshot                    = 272935,
                aceupyoursleeve             = 278676,
                snakeeyes                   = 275846,
                keepYourWitsAboutYou        = 288979,

            },
            runeforge                         = {
                greenskinsWickers           = 340085,
                guileCharm                  = 340086,
                celerity                    = 340087,
                concealedBlunderbuss        = 340088,
            },
            conduits                        = {
                countTheOdds                = 341546,
            },
        },
        -- Subtlety
        [261] = {
            abilities                       = {
                backstab                    = 53,
                rupture                     = 1943,
                secretTechnique             = 280719,
                eviscerate                  = 196819,
                gloomblade                  = 200758,
                shadowBlades                = 121471,
                shadowDance                 = 185313,
                shadowstep                  = 36554,
                shadowstrike                = 185438,
                shurikenStorm               = 197835,
                shurikenToss                = 114014,
                symbolsOfDeath              = 212283,
                sinisterStrike              = 1752,
                blackPowder                 = 319175,
                coldBlood                   = 213981,
            },
            artifacts                       = {

            },
            buffs                           = {
                premeditation               = 343160,
                masterOfShadows             = 196980,
                nightsVengeance             = 273424,
                shadowBlades                = 121471,
                shadowDance                 = 185422,
                sharpenedBlades             = 272916,
                shurikenCombo               = 245640,
                shurikenTornado             = 277925,
                subterfuge                  = 115192,
                symbolsOfDeath              = 212283,
                symbolsOfDeathCrit          = 227151,
                theDreadlordsDeceit         = 228224,
                theRotten                   = 341134,
                deathlyShadows              = 341202,
                perforatedVeins             = 341572,
                masterAssassin              = 256735,
                coldBlood                   = 213981,
                perforatedVeins             = 341572,
                shotInTheDark               = 257506,
            },
            debuffs                         = {
                rupture                     = 1943,
                findWeakness                = 91021,
                nightblade                  = 195452,
                shadowsGrasp                = 206760,
            },
            glyphs                          = {

            },
            talents                         = {
                alacrity                    = 193539,
                darkShadow                  = 245687,
                envelopingShadows           = 238104,
                --findWeakness                = 91023,
                gloomblade                  = 200758,
                masterOfShadows             = 196976,
                nightTerrors                = 277953,
                nightstalker                = 14062,
                secretTechnique             = 280719,
                shadowFocus                 = 108209,
                shotInTheDark               = 257505,
                shurikenTornado             = 277925,
                soothingDarkness            = 200759,
                subterfuge                  = 108208,
                weaponmaster                = 193537,
                premeditation               = 343160,
            },
            traits                          = {
                bladeInTheShadows           = 275896,
                nightsVengeance             = 273418,
                replicatingShadows          = 286121,
                sharpenedBlades             = 272911,
                theFirstDance               = 278681,
                perforate                   = 277720,
                inevitability               = 278683,
            },
            runeforges                      = {
                finality                    = 340089,
                akaarisSoulFragment         = 340090,
                theRotten                   = 340091,
                deathlyShadows              = 340092,
            },
            conduits                        = {
                deeperDaggers               = 341549,
                perforatedVeins             = 341567,
                plannedExecution            = 341556,
                stilettoStaccato            = 341559,
            },
        },
        -- All
        Shared = {
            abilities                       = {
                eviscerate                  = 196819,
                sinisterStrike              = 1752,
                cripplingPoison             = 3408,
                numbingPoison               = 5761,
                instantPoison               = 315584,
                woundPoison                 = 8679,
                blind                       = 2094,
                cheapShot                   = 1833,
                cloakOfShadows              = 31224,
                crimsonVial                 = 185311,
                detection                   = 56814 or 210108,
                distract                    = 1725,
                feint                       = 1966,
                kick                        = 1766,
                kidneyShot                  = 408,
                markedForDeath              = 137619,
                pickLock                    = 1804,
                pickPocket                  = 921,
                sap                         = 6770,
                shadowmeld                  = 58984,
                shiv                        = 5938,
                sprint                      = 2983,
                stealth                     = 115191,
                tricksOfTheTrade            = 57934,
                vanish                      = 1856,
                evasion                     = 5277,
                shroudOfConcealment         = 114018,
                sliceAndDice                = 315496,
                stealth                     = 1784,
                poisons                     = 66,
                serratedBoneSpike           = 328547,
                sepsis                      = 328305,
            },
            artifacts                       = {

            },
            buffs                           = {
                sliceAndDice                = 315496,
                numbingPoison               = 5761,
                cripplingPoison             = 3408,
                instantPoison               = 315584,
                woundPoison                 = 8679,
                cloakOfShadows              = 31224,
                deathFromAbove              = 152150,
                feint                       = 1966,
                tricksOfTheTrade            = 57934,
                masterAssassinsMark         = 340094,
                sprint                      = 2983,
                stealth                     = 1784,
                vanish                      = 11327 or 115193,
                shroudOfConcealment         = 114018,
                flagellation                = 345569,
                sepsis                      = 328305,
                theRotten                   = 341134,
            },
            conduits                        = {
                lashingScars                = 341310,
                plannedExecution            = 341556,
                reverberation               = 341264,
                septicShock                 = 341309,
            },
            covenants                       = {
                echoingReprimand            = 323547,
                flagellation                = 323654,
                flagellationCleanse         = 346975,
                sepsis                      = 328305,
                serratedBoneSpike           = 328547,
            },
            debuffs                         = {
                instantPoison               = 315584,
                woundPoison                 = 8679,
                numbingPoison               = 5761,
                cripplingPoison             = 3408,
                shiv                        = 115196,
                kidneyShot                  = 408,
                cheapShot                   = 1833,
                markedForDeath              = 137619,
                sap                         = 6770,
                serratedBoneSpikeDot        = 324073,
                flagellation                = 323654,
            },
            glyphs                          = {
                glyphOfBlackout             = 219693,
                glyphOfBurnout              = 220279,
                glyphOfDisguise             = 63268,
                glyphOfFlashBang            = 219678,
            },
            talents                         = {
                cheatDeath                  = 31230,
                deeperStratagem             = 193531,
                elusiveness                 = 79008,
                markedForDeath              = 137619,
                preyOnTheWeak               = 131511,
                vigor                       = 14983,
              --  blindingPowder              = 256165,   commented it out as it created errors
            },
            runeforges                      = {
                markOfTheMasterAssassin     = 340076,
                essenceOfBloodfang          = 340079,
                invigoratingShadowdust      = 340080,
                tinyToxicBlade              = 340078,
            },
        },
    },
 SHAMAN = {
        -- Elemental
        [262] = {
            abilities                       = {
                cleanseSpirit               = 51886,
                earthquake                  = 61882,
                earthShock                  = 8042,
                eyeOfTheStorm               = 157375,
                fireBlast                   = 57984,
                fireElemental               = 198067,
                hardenSkin                  = 118337,
                immolate                    = 118297,
                lavaBeam                    = 114074,
                lavaBurst                   = 51505,
                meteor                      = 117588,
                pulverize                   = 118345,
                spiritwalkersGrace          = 79206,
                thunderstorm                = 51490,
                windGust                    = 157331,
            },
            artifacts                       = {
            },
            buffs                           = {
                ascendance                  = 114050,
                bloodlust                   = 2825,
                earthShield                 = 974,
                echoingShock                = 320125,
                elementalFocus              = 16164,
                elementalMastery            = 16166,
                emberTotem                  = 210658,
                hardenSkin                  = 118337,
                heroism                     = 32182,
                iceFury                     = 210714,
                lavaSurge                   = 77762,
                masterOfTheElements         = 260734,
                powerOfTheMaelstrom         = 191877,
                resonanceTotem              = 202192,
                spiritwalkersGrace          = 79206,
                stormKeeper                 = 191634,
                stormTotem                  = 210652,
                surgeOfPower                = 285514,
                tailwindTotem               = 210659,
                tectonicThunder             = 286949,
                windGust                    = 263806,
            },
            debuffs                         = {
                flameShock                  = 188389,
                frostShock                  = 196840,
                immolate                    = 118297,
                lightningRod                = 197209,
            },
            glyphs                          = {

            },
            talents                         = {
                aftershock                  = 273221,
                ancestralGuidance           = 108281,
                ascendance                  = 114050,
                earthenRage                 = 170374,
                earthShield                 = 974,
                echoingShock                = 320125,
                echoOfTheElements           = 333919,
                elementalBlast              = 117014,
                iceFury                     = 210714,
                liquidMagmaTotem            = 192222,
                masterOfTheElements         = 16166,
                primalElementalist          = 117013,
                staticDischarge             = 342243,
                stormElemental              = 192249,
                stormKeeper                 = 191634,
                surgeOfPower                = 262303,
                unlimitedPower              = 260895,

            },
            traits                          = {
                naturalHarmony              = 278697,
                tectonicThunder             = 286949,
            },
        },
        -- Enhancement
        [263] = {
            abilities                       = {
                cleanseSpirit               = 51886,
                crashLightning              = 187874,
                feralSpirit                 = 51533,
                lavaLash                    = 60103,
                spiritWalk                  = 58875,
                stormstrike                 = 17364,
                sundering                   = 197214,
                windfuryWeapon              = 33757,
                windstrike                  = 115356, --17364,
                windfuryTotem               = 8512,
            },
            artifacts                       = {

            },
            buffs                           = {
                ascendance                  = 114051,
                crashLightning              = 187878,
                earthShield                 = 974,
                hailstorm                   = 334196,
                hotHand                     = 215785,
                maelstromWeapon             = 344179,
                stormkeeper                 = 320137,
                windfuryTotem               = 327942,
            },
            debuffs                         = {
                doomWinds                   = 335904,
                lashingFlames               = 334168,
            },
            glyphs                          = {

            },
            talents                         = {
                ascendance                  = 114051,
                crashingStorm               = 192246,
		        earthShield                 = 974,
                earthenSpike                = 188089,
                elementalAssault            = 210853,
                elementalBlast              = 117014,
                elementalSpirits            = 262624,
                feralLunge                  = 196884,
                fireNova                    = 333974,
                forcefulWinds               = 262647,
                hailstorm                   = 334195,
                hotHand                     = 201900,
                iceStrike                   = 342240,
                lashingFlames               = 334046,
                stormflurry                 = 344357,
                stormkeeper                 = 320137,
                sundering                   = 197214,
            },
            traits                          = {
                lightningConduit            = 275389,
                naturalHarmony              = 278697,
                primalPrimer                = 272992,
                strengthOfTheEarth          = 273461,
            },
        },
       -- Restoration
        [264] = {
            abilities                       = {
                ancestralVision             = 212048,
                earthShield                 = 974,
		        waterShield                 = 52127,
                healingRain                 = 73920,
                healingTideTotem            = 108280,
                healingWave                 = 77472,
                lavaBurst                   = 51505,
                manaTideTotem               = 16191,
                purifySpirit                = 77130,
                riptide                     = 61295,
                spiritLinkTotem             = 98008,
                spiritwalkersGrace          = 79206,
            },
            artifacts                       = {
             --   giftOfTheQueen              = 207778,
            },
            buffs                           = {
                ascendance                  = 114052,
                cloudburstTotem             = 157504,
                earthShield                 = 974,
		        waterShield                 = 52127,
                healingRain                 = 73920,
                heavyRainfall               = 338344,
                jonatsFocus                 = 210607,
                lavaSurge                   = 77762,
                riptide                     = 61295,
                tidalWaves                  = 53390,
                unleashLife                 = 73685,
                undulation                  = 216251,
                spiritwalkersGrace          = 79206,
                swirlingCurrents            = 338340,
            },
            conduits                        = {
                heavyRainfall               = 338343,
            },
            debuffs                         = {
                flameShock                  = 188389,
            },
            glyphs                          = {
            },
            talents                         = {
                ancestralVigor              = 207401,
                ancestralProtectionTotem    = 207399,
                ascendance                  = 114052,
                cloudburstTotem             = 157153,
                deluge                      = 200076,
                downpour                    = 207778,
                earthenWallTotem            = 198838,
                earthgrabTotem              = 51485,
                echoOfTheElements           = 108283,
                flashFlood                  = 280614,
                gracefulSpirit              = 192088,
                highTide                    = 157154,
                sugeofEarth                 = 320746,
                torrent                     = 200072,
                undulation                  = 200071,
                unleashLife                 = 73685,
                wellspring                  = 197995,
            },
        },
        -- All
        Shared = {
            abilities                       = {
                ancestralSpirit             = 2008,
                astralRecall                = 556,
                astralShift                 = 108271,
                bloodlust                   = 2825,
                capacitorTotem              = 192058,
                chainHeal                   = 1064,
                chainLightning              = 188443,
                earthElemental              = 198103,
                earthbindTotem              = 2484,
                farSight                    = 6196,
                flameShock                  = 188389,
                flametongueWeapon           = 318038,
                frostShock                  = 196840,
                ghostWolf                   = 2645,
                healingStreamTotem          = 5394,
                healingSurge                = 8004,
                heroism                     = 32182,
                hex                         = 51514,
                lightningBolt               = 188196,
                lightningShield             = 192106,
                primalStrike                = 73899,
                purge                       = 370,
                tremorTotem                 = 8143,
                waterWalking                = 546,
                windShear                   = 57994,
            },
            artifacts                       = {

            },
            buffs                           = {
                astralShift                 = 108271,
                chainsOfDevastationHeal     = 336737,
                doomWinds                   = 335903,
                echoesOfGreatSundering      = 336217,
                elementalEquilibrium        = 337348,
                faeTransfusionRecast        = 328933,
                ghostWolf                   = 2645,
                lightningShield             = 192106,
                primalLavaActuators         = 347819,
                primordialWave              = 327164,
                spiritwalkersTidalTotem     = 335892,
                waterWalking                = 546,
            },
            conduits                        = {
                astralProtection            = 337964,
            },
            covenants                       = {
                chainHarvest                = 320674,
                faeTransfusion              = 328923,
                primordialWave              = 326059,
                vesperTotem                 = 324386,
            },
            debuffs                         = {
                flameShock                  = 188389,
                frostShock                  = 196840,
                hex                         = 51514,
            },
            glyphs                          = {

            },
            runeforges                      = {
                chainsOfDevastation         = 336735,
                doomWinds                   = 335902,
                elementalEquilibrium        = 336730,
                primalLavaActuators         = 335895,
                echoesOfGreatSundering       = 336215,
                skybreakersFieryDemise       = 336734,
                spiritwalkersTidalTotem      = 335891,
                deeptremorStone              = 336739,  
            },
            talents                         = {
                naturesGuardian             = 30884,
                spiritWolf                  = 260878,
                staticCharge                = 265046,
                windRushTotem               = 192077,
            },
        },
    },
    WARLOCK = {
        -- Affliction
        [265] = {
            abilities                       = {
                agony                       = 980,
                commanddemon                = 119898,
                corruption                  = 172,
                darkSoul                    = 113860,
                deathbolt                   = 264106,
                demonicGateway              = 311699,
                drainLife                   = 234153,
                drainSoul                   = 198590,
                felDomination               = 333889,
                grimoireOfSacrifice         = 108503,
                haunt                       = 48181,
                maleficRapture              = 324536,
		        mortalCoil                  = 6789,
                phantomSingularity          = 205179,
                reapSouls                   = 216698,
                seedOfCorruption            = 27243,
                shadowBolt                  = 232670,
                shadowBolt2                 = 686,
                shadowLock                  = 171138,
                siphonLife                  = 63106,
                spellLock                   = 19647,
                spellLockgrimoire           = 132409,
                soulEffigy                  = 205178,
                summonDarkglare             = 205180,
                unstableAffliction          = 30108,
                vileTaint                   = 278350,
            },
            artifacts                       = {
            },
            buffs                           = {
                cascadingCalamity           = 275378,
                compoundingHorror           = 199281,
                darkSoul                    = 113860,
                deadwindHarvester           = 216708,
                demonicPower                = 196099,
                empoweredLifeTap            = 235156,
                felDomination               = 333889,
                nightfall                   = 264571,
                tormentedSouls              = 216695,
                wrathOfConsumption          = 199646,
                inevitableDemise            = 273525,
            },
            debuffs                         = {
                agony                       = 980,
                corruption                  = 146739,
                haunt                       = 48181,
                phantomSingularity          = 205179,
                seedOfCorruption            = 27243,
                siphonLife                  = 63106,
                shadowEmbrace               = 32390,
                unstableAffliction          = 316099,
                unstableAffliction2         = 233496,
                unstableAffliction3         = 233497,
                unstableAffliction4         = 233498,
                unstableAffliction5         = 233499,
                vileTaint                   = 278350,
            },
            glyphs                          = {

            },
            talents                         = {
                absoluteCorruption          = 196103,
                creepingDeath               = 264000,
                darkCaller                  = 334183,
                darkfury                    = 264874,
                seedOfCorruption            = 196226,
                darkSoul                    = 113860,
                demonicSacrifice            = 108503,
                drainSoul                   = 198590,
                grimoireOfSacrifice         = 108503,
                haunt                       = 48181,
                howlOfTerror                = 5484,
                inevitableDemise            = 334319,
                nightfall                   = 108558,
                phantomSingularity          = 205179,
                siphonLife                  = 63106,
                soulConduit                 = 215941,
                sowTheSeeds                 = 196226,
                vileTaint                   = 278350,
                writheInAgony               = 196102,
            },
            traits                          = {
                cascadingCalamity           = 275372,
                dreadfulCalling             = 278727,
                inevitableDemise            = 273521,
                pandemicInvocation          = 289364,
            }
        },
        -- Demonology
        [266] = {
            abilities                       = {
		axeToss                     = 89766,
                bilescourgeBombers          = 267211,
                callDreadstalkers           = 104316,
                commandDemon                = 119898,
                corruption                  = 172,
                demonbolt                   = 264178,
                demonicEmpowerment          = 193396,
                demonicStrength             = 267171,
                demonwrath                  = 193440,
                doom                        = 603,
                drainLife                   = 234153,
                felFirebolt                 = 104318,
                felstorm                    = 89751,
                grimoireFelguard            = 111898,
                handOfGuldan                = 105174,
                implosion                   = 196277,
                netherPortal                = 267217,
                powerSiphon                 = 264130,
                shadowBolt                  = 686,
                shadowflame                 = 205181,
                shadowLock                  = 171138,
                soulStrike                  = 264057,
                spellLock                   = 19647,
                summonDarkglare             = 205180,
                summonDemonicTyrant         = 265187,
                summonVilefiend             = 264119,
                thalkielsConsumption        = 211714,
            },
            artifacts                       = {
                thalkielsAscendance         = 238145,
                thalkielsConsumption        = 211714,
            },
            buffs                           = {
                demonicCalling              = 205146,
                demonicCore                 = 267102,
                demonicEmpowerment          = 193396,
                demonicPower                = 265273,
                demonwrath                  = 193440,
                explosivePotential          = 275398,
                forbiddenKnowledge          = 278738,
                netherPortal                = 267218,
                shadowsBite                 = 272945,
                shadowyInspiration          = 196269,
            },
            debuffs                         = {
                doom                        = 603,
                shadowflame                 = 205181,
            },
            glyphs                          = {

            },
            talents                         = {
                bilescourgeBombers          = 267211,
                darkfury                    = 264874,
                demonicConsumption          = 267215,
                demonicStrength             = 267171,
                demonicCalling              = 205145,
                doom                        = 603,
                dreadlash                   = 264078,
                fromTheShadows              = 267170,
                grimoireFelguard            = 111898,
                howlOfTerror                = 5484,
                innerDemons                 = 267216,
                netherPortal                = 267217,
                powerSiphon                 = 264130,
                sacrificedSouls             = 267214,
                soulStrike                  = 264057,
                summonVilefiend             = 264119,
                soulConduit                 = 215941,

            },
            traits                          = {
                balefulInvocation           = 287059,
                explosivePotential          = 275395,
                shadowsBite                 = 272944,
            }
        },
        -- Destruction
        [267] = {
            abilities                       = {
                cataclysm                   = 152108,
                channelDemonfire            = 196447,
                chaosBolt                   = 116858,
                conflagrate                 = 17962,
                corruption                  = 172,
                commandDemon                = 119898,
                darkSoul                    = 113858,
                devourMagic                 = 19505,
                dimensionalRift             = 196586,
                drainLife                   = 234153,
                felDomination               = 333889,
                grimoireOfSacrifice         = 108503,
                havoc                       = 80240,
                immolate                    = 348,
                incinerate                  = 29722,
                rainOfFire                  = 5740,
                shadowBolt                  = 686,
                shadowburn                  = 17877,
                shadowLock                  = 171138,
                singeMagic                  = 119905,
                singeMagicGrimoire          = 132411,
                soulFire                    = 6353,
                spellLock                   = 19647,
                spellLockgrimoire           = 132409,
            },
            artifacts                       = {

            },
            buffs                           = {
                backdraft                   = 117828, --196406,
                crashingChaos               = 277706,
                darkSoul                    = 113858,
                darkSoulInstability         = 113858,
                demonicPower                = 196099,
                empoweredLifeTap            = 235156,
                felDomination               = 333889,
                lessonsOfSpaceTime          = 236174,
                lordOfFlames                = 224103,
            },
            debuffs                         = {
                conflagrate                 = 265931,
                eradication                 = 196414,
                immolate                    = 157736,
                havoc                       = 80240,
            },
            glyphs                          = {

            },
            talents                         = {
                cataclysm                   = 152108,
                channelDemonfire            = 196447,
                darkFury                    = 264874,
                darkSoul                    = 113858,
                darkSoulInstability         = 113858,
                eradication                 = 196412,
                flashover                   = 267115,
                fireAndBrimstone            = 196408,
                grimoireOfSacrifice         = 108503,
                grimoireOfSupremacy         = 266086,
                howlOfTerror                = 5484,
                inferno                     = 270545,
                internalCombustion          = 266134,
                reverseEntropy              = 205148,
                roaringBlaze                = 205184,
                shadowburn                  = 17877,
                soulFire                    = 6353,
                soulConduit                 = 215941,
            },
            traits =                        {
                crashingChaos               = 277644
            }
        },
        -- Inital Warlock (1-10)
        [1454] = {
            abilities                       = {
                controlDemon                = 93375,
                corruption                  = 172,
                curseOfWeakness             = 702,
                drainLife                   = 234153,
                shadowBolt                  = 686,
            },
            buffs                           = {

            },
            debuffs                         = {
                corruption                  = 146739,
                curseOfWeakness             = 702,
                drainLife                   = 234153,
            },
        },
        -- All
        Shared = {
            abilities                       = {
                banish                      = 710,
                burningRush                 = 111400,
                curseOfExhaustion           = 334275,
                curseOfTongues              = 1714,
                curseOfWeakness             = 702,
                createHealthstone           = 6201,
                createSoulwell              = 29893,
                commandDemon                = 119898,
                corruption                  = 172,
                darkPact                    = 108416,
                demonicGateway              = 111771,
                demonicCircle               = 48018,
                demonicTeleport             = 48020,
                devourMagic                 = 19505,
                eyeOfKilrogg                = 126,
                felDomination               = 333889,
                fear                        = 5782,
                grimoireFelhunter           = 111897,
                grimoireImp                 = 111859,
                grimoireOfService           = 108501,
                grimoireSuccubus            = 111896,
                grimoireVoidwalker          = 111895,
                healthFunnel                = 755,
                lifeTap                     = 1454,
                mortalCoil                  = 6789,
                ritualOfDoom                = 342601,
                ritualOfSummoning           = 698,
                shadowfury                  = 30283,
                shadowBulwark               = 119907,
                spellLock                   = 19647,
                seduction                   = 6358,
                singeMagic                  = 89808,
                soulHarvest                 = 196098,
                soulstone                   = 20707,
                --summonDoomguard             = 18540,
                subjugateDemon              = 1098,
                summonFelguard              = 30146,
                summonFelhunter             = 691,
                summonFelImp                = 688,
                summonImp                   = 688,
                summonInfernal              = 1122,
                summonSuccubus              = 712,
                summonVoidwalker            = 697,
                summonWrathguard            = 112870,
                unendingBreath              = 5697,
                unendingResolve             = 104773,
                unstableaffliction          = 316099,

            },
            artifacts                       = {

            },
            buffs                           = {
                burningRush                 = 111400,
                demonicCircle               = 48018,
                demonicSynergy              = 171982,
                felDomination               = 333889,
                healthFunnel                = 755,
                grimoireOfSacrifice         = 196099,
                sindoreiSpite               = 208871,
                soulHarvest                 = 196098,
                soulstone                   = 20707,
                unendingBreath              = 5697,
                unendingResolve             = 104773,
            },
            conduits                        = {

            },
            covenants                       = {
                decimatingBolt              = 325289,
                impendingCatastrophe        = 321792,
                scouringTithe               = 312321,
                soulRot                     = 325640,
            },
            debuffs                         = {
		decimatingBolt              = 325289,
                impendingCatastrophe        = 321792,
                scouringTithe               = 312321,
                soulRot                     = 325640,
                fear                        = 5782,
                curseOfExhaustion           = 334275,
                curseOfTongues              = 1714,
                curseOfWeakness             = 702,
            },
            glyphs                          = {
                glyphOfTheFelImp            = 219424,
            },
            talents                         = {
                burningRush                 = 111400,
                darkPact                    = 108416,
                demonSkin                   = 219272,
                mortalCoil                  = 6789,

            },
        },
    },
    WARRIOR = {
        -- Arms
        [71] = {
            abilities                       = {
                bladestorm                  = 227847,
                cleave                      = 845,
                colossusSmash               = 167105,
                commandingShout             = 97462,
                deadlyCalm                  = 262228,
                defensiveStance             = 197690,
                dieByTheSword               = 118038,
                execute                     = 163201,
                hamstring                   = 1715,
                mortalStrike                = 12294,
                overpower                   = 7384,
                piercingHowl                = 12323,
                ravager                     = 152277,
                rend                        = 772,
                slam                        = 1464,
                sweepingStrikes             = 260708,
                warbreaker                  = 262161,
                whirlwind                   = 1680,
            },
            artifacts                       = {

            },
            buffs                           = {
                crushingAssault             = 278826,
                deadlyCalm                  = 262228,
                defensiveStance             = 197690,
                inForTheKill                = 215550,
                overpower                   = 60503,
                stoneHeart                  = 225947,
                suddenDeath                 = 52437,
                sweepingStrikes             = 260708,
                testOfMight                 = 275540,
            },
            conduits                        = {

            },
            covenants                       = {
                condemn                     = 317349,
				condemnMassacre				= 330334,
            },
            debuffs                         = {
                colossusSmash               = 208086,
                deepWounds                  = 262115,
                executionersPrecision       = 272870,
                hamstring                   = 1715,
                rend                        = 772,
            },
            glyphs                          = {
                glyphOfThunderStrike        = 68164,
            },
            talents                         = {
                avatar                      = 107574,
                cleave                      = 845,
                deadlyCalm                  = 262228,
                defensiveStance             = 197690,
                doubleTime                  = 103827,
                dreadnaught                 = 262150,
                fervorOfBattle              = 202316,
                inForTheKill                = 248621,
                massacre                    = 281001,
                ravager                     = 152277,
                rend                        = 772,
                secondWind                  = 29838,
                skullsplitter               = 260643,
                suddenDeath                 = 29725,
                warMachine                  = 262231,
                warbreaker                  = 262161,
            },
            traits                          = {
                seismicWave                 = 277639,
                testOfMight                 = 275529,
            }
        },
        -- Fury
        [72] = {
            abilities                       = {
                bladestorm                  = 46924,
                bloodthirst                 = 23881,
                dragonRoar                  = 118000,
                deathWish                   = 199261,
                enragedRegeneration         = 184364,
                execute                     = 5308,
                onslaught                   = 315720,
                piercingHowl                = 12323,
                ragingBlow                  = 85288,
                rampage                     = 184367,
                recklessness                = 1719,
                siegebreaker                = 280772,
                whirlwind                   = 190411,
            },
            artifacts                       = {

            },
            buffs                           = {
                deathWish                   = 199261,
                enrage                      = 184362,
                meatCleaver                 = 85739,
                recklessness                = 1719,
                suddenDeath                 = 280776,
                whirlwind                   = 85739,
            },
            conduits                        = {

            },
            covenants                       = {
                condemn                     = 317349,
				condemnMassacre				= 330334,
            },
            debuffs                         = {
                siegebreaker                = 280773,
            },
            glyphs                          = {

            },
            talents                         = {
                warMachine                  = 346002,
                suddenDeath                 = 280721,
                freshMeat                   = 215568,
                impendingVictory            = 202168,
                stormBolt                   = 107570,
                massacre                    = 206315,
                frenzy                      = 335077,
                onslaught                   = 315720,
                furiousCharge               = 202224,
                boundingStride              = 202163,
                warpaint                    = 208154,
                seethe                      = 335091,
                frothingBerserker           = 215571,
                cruelty                     = 335070,
                meatCleaver                 = 280392,
                dragonRoar                  = 118000,
                bladestorm                  = 46924,
                angerManagement             = 152278,
                recklessAbandon             = 202751,
                siegebreaker                = 280772,
            },
            traits                          = {
                coldSteelHotBlood           = 288080
            }
        },
        -- Protection
        [73] = {
            abilities                       = {
                demoralizingShout           = 1160,
                devastate                   = 20243,
                focusedRage                 = 204488,
                impendingVictory            = 202168,
                intercept                   = 198304,
                lastStand                   = 12975,
                ravager                     = 228920,
                revenge                     = 6572,
                shieldBlock                 = 2565,
                shieldSlam                  = 23922,
                shieldWall                  = 871,
                shockwave                   = 46968,
                thunderClap                 = 6343,
            },
            artifacts                       = {

            },
            buffs                           = {
                avatar                      = 107574,
                defensiveStance             = 71,
                lastStand                   = 12975,
                revenge                     = 5302,
                shieldBlock                 = 132404,
                shieldWall                  = 871,
                vengeanceFocusedRage        = 202573,
                vengeanceIgnorePain         = 202574,
                vengeanceRevenge            = 202573,
                victorious                  = 32216,
            },
            conduits                        = {

            },
            covenants                       = {
                condemn                     = 317349,
            },
            debuffs                         = {
                deepwoundsProt              = 115767,
                demoralizingShout           = 1160,
                thunderClap                 = 6343,
            },
            glyphs                          = {

            },
            talents                         = {
                bestServedCold              = 202560,
                warMachine                  = 316733,
                bolster                     = 280001,
                boomingVoice                = 202743,
                cracklingThunder            = 203201,
                devastator                  = 236279,
                dragonRoar                  = 118000,
                heavyRepercussions          = 203177,
                indomitable                 = 202095,
                intoTheFray                 = 202603,
                menace                      = 275338,
                neverSurrender              = 202561,
                punish                      = 275334,
                ravager                     = 228920,
                rumblingEarth               = 275339,
                unstoppableForce            = 275336,
            },
        },
        -- All
        Shared = {
            abilities                       = {
                avatar                      = 107574,
                battleShout                 = 6673,
                berserkerRage               = 18499,
                charge                      = 100,
                execute                     = 163201,
                hamstring                   = 1715,
                heroicLeap                  = 6544,
                heroicThrow                 = 57755,
                intimidatingShout           = 5246,
                pummel                      = 6552,
                rallyingCry                 = 97462,
                shieldSlam                  = 23922,
                slam                        = 1464,
                shieldBlock                 = 2565,
                stormBolt                   = 107570,
                taunt                       = 355,
                victoryRush                 = 34428,
                ignorePain                  = 190456,
                shatteringThrow             = 64382,
                spellReflection             = 23920,
                challengingShout            = 1161,
                intervene                   = 3411,
                whirlwind                   = 1680,
            },
            artifacts                       = {

            },
            buffs                           = {
                battleShout                 = 6673,
                ignorePain                  = 190456,
                spellReflection             = 23920,
                berserkerRage               = 18499,
                fujiedasFury                = 207776,
                victorious                  = 32216,
            },
            conduits                        = {
                viciousContempt             = 337302,
            },
            covenants                       = {
                ancientAftershock           = 325886,
                conquerorsBanner            = 324143,
                spearOfBastion              = 307865,
            },
            debuffs                         = {

            },
            glyphs                          = {

            },
            talents                         = {
                angerManagement             = 152278,
                doubleTime                  = 103827,
                boundingStride              = 202163,
                impendingVictory            = 202168,
                stormBolt                   = 107570,
            },
        },
    },
    -- Global
    Shared = {
        Shared = {
            abilities                           = {
                autoAttack                      = 6603,
                giftOfTheNaaru                  = br.getRacial("Draenei"),--select(7, GetSpellInfo(GetSpellInfo(28880))),
                global                          = 61304,
                latentArcana                    = 296971,
                lightsJudgment                  = 247427,
                quakingPalm                     = 107079,
                racial                          = br.getRacial(),
                shadowmeld                      = 58984,
            },
            artifacts                           = {
                artificialDamage                = 226829,
                artificialStamina               = 211309,
                concordanceOfTheLegionfall      = 239042,
            },
            buffs                               = {
                ancientHysteria                 = 90355,
                battlePotionOfAgility           = 279152,
                battlePotionOfIntellect         = 279151,
                battlePotionOfStrength          = 279153,
                superiorBattlePotionOfAgility   = 298146,
                potionOfUnbridledFury           = 300714,
                blessingOfSacrifice 	        = 6940,
                greaterBlessingOfKings 	        = 203538,
                greaterBlessingOfWisdom	        = 203539,
                battleScarredAugmentation       = 270058, -- BfA Augment Rune Buff
                blessingOfFreedom     	        = 1044,
                blessingOfProtection            = 1022,
                bloodLust                       = {
                    ancientHysteria             = 90355,
		            bloodlust                   = 2825,
		            drumsOfRage                 = 146555,
                    drumsOfTheMaelstrom         = 256740,
                    drumsOfTheMountain          = 230935,
		            heroism                     = 32182,
		            netherwinds                 = 160452,
		            primalRage                  = 264667,
                    timewarp                    = 80353,
                },
                concordanceOfTheLegionfall      = 239042,
                defiledAugmentation             = 224001, -- Lightforged Augment Rune buff
                felFocus                        = 242551,
                flaskOfTenThousandScars         = 188035,
                flaskOfTheCountlessArmies       = 188034,
                flaskOfTheSeventhDemon          = 188033,
                flaskOfTheWhisperedPact         = 188031,
                flaskOfTheCurrents              = 251836,
                flaskOfEndlessFathoms           = 251837,
                flaskOfTheVastHorizon           = 251838,
                flaskOfTheUndertow              = 251839,
                fruitfulMachinatins             = 242623, -- Absorb Shield from Deceiver's Grand Design
                mistcallerOcarina               = 330067, -- SL Trinket with group buff
                greaterFlaskOfEndlessFathoms    = 298837,
                greaterFlaskOfTheCurrents       = 298836,
                greaterFlaskOfTheUndertow       = 298841,
                greaterFlaskOfTheVastHorizon    = 298839,
                guidingHand                     = 242622, -- from The Deceiver's Grand Design
                heroism                         = 32182,
                ineffableTruth                  = 316801,
                latentArcana                    = 296962,
                netherwinds                     = 160452,
                norgannonsForesight             = 236373,
                overchargeMana                  = 299624,
                potionOfBurstingBlood           = 265514,
                potionOfFocusedResolve          = 298317,
                prolongedPower                  = 229206,
                racial                          = br.getRacial(),
                razorCoral                      = 303570, -- Crit Buff from Ashvane's Razor Coral
                sephuz1                         = 208051, -- the fulltime 10% movement, 2% haste buff
                sephuz2                         = 208052, -- the proc, 70% movement, 25% haste buff
                sephuzCooldown                  = 226262, -- CD (30 seconds) for the proc
                shadowmeld                      = 58984,
                symbolOfHope                    = 64901,
                timeWarp                        = 80353,
                whispersOfInsanity              = 176151,
                cracklingTourmaline             = 290372,
                saphireofBrilliance             = 290365,
                vigorEngaged                    = 287916,
                -- Essences
                concentratedFlame               = 295378,
                guardianOfAzeroth               = 295855,
                guardianShell                   = 310425,
                lifeblood                       = 295137,
                memoryOfLucidDreams             = 298357,
                recklessForce                   = 302932,
                recklessForceCounter            = 298452,
                seethingRage                    = 297126,
                vigilantProtector               = 310592,
                reapingFlames					= 311202,
                worldveinResonance              = 313310,
                soulshape                       = 310143,
            },
            conduits                            = {

            },
            covenants                           = {
                covenantAbility                 = 313347,
                doorOfShadows                   = 300728,
                fleshcraft                      = 324631,
                soulshape                       = 310143,
                summonSteward                   = 324739,
            },
            debuffs                             = {
                bloodOfTheEnemy                 = 297108,
                concentratedFlame               = 295368,
                conductiveInk                   = 302565,
                dampening                       = 110310,
                eyeOfLeotheras                  = 206649,
                razorCoral                      = 303568, --304877,
                repeatPerformance               = 304409,
                shiverVenom                     = 301624,
                temptation                      = 234143,
                eyeOfCorruption                 = 315161,
                grandDelusions                  = 319695,
                graspingTendrils                = 315176,
                creepingMadness                 = 313255,
                fixate				            = 318078,
                thirstForBlood                  = 266107,
                mightyBash                      = 5211,
                defiledGround                   = 314565,
                vileCorruption                  = 314392,
                cascadingTerror                 = 314478,
            },
            essences                            = {
                aegisOfTheDeep                  = 298168,
                animaOfDeath                    = 294926,
                azerothsUndyingGift             = 298081,
                bloodOfTheEnemy                 = 297108,
                concentratedFlame               = 295373,
                condensedLifeForce              = 299357,
                empoweredNullBarrier            = 295746,
                focusedAzeriteBeam              = 295258,
                guardianOfAzeroth               = 299355,
                guardianShell                   = 296036, --added in 8.3
                heartEssence                    = 296208,
                lifeBindersInvocation           = 293032,
                memoryOfLucidDreams             = 298357,
                overchargeMana                  = 296072,
                purifyingBlast                  = 299345,
                reapingFlames                   = 310690, -- Added in 8.3
                refreshment                     = 296197,
                replicaOfKnowledge              = 312725, --added in 8.3
                rippleInSpace                   = 302731,
                spiritOfPreservation            = 297375, -- added in 8.3
                standstill                      = 299882,
                suppressingPulse                = 300009,
                theUnboundForce                 = 299376,
                vigilantProtector               = 310592,
                visionOfPerfection              = 299370,
                vitalityConduit                 = 299958,
                conflict                        = 303823,
                worldveinResonance              = 295186
            },
        },
    },
    ClassTemplate = {
        SpecTemplate = {
            abilities                       = {

            },
            artifacts                       = {

            },
            buffs                           = {

            },
            debuffs                         = {

            },
            glyphs                          = {

            },
            talents                         = {

            },
        },
        SpecTemplate = {
            abilities                       = {

            },
            artifacts                       = {

            },
            buffs                           = {

            },
            debuffs                         = {

            },
            glyphs                          = {

            },
            talents                         = {

            },
        },
        SpecTemplate = {
            abilities                       = {

            },
            artifacts                       = {

            },
            buffs                           = {

            },
            debuffs                         = {

            },
            glyphs                          = {

            },
            talents                         = {

            },
        },
        Shared = {
            abilities                       = {

            },
            artifacts                       = {

            },
            buffs                           = {

            },
            debuffs                         = {

            },
            glyphs                          = {

            },
            talents                         = {

            },
        },
    },
}
