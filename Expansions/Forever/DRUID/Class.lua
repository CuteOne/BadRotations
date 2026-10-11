local _, br = ...
br.lists.spells.DRUID = br.lists.spells.DRUID or {}
-- WoW Forever (1.60) Druid. IDs and ranks from Wowhead's Forever database (class spell list and
-- tooltips, 2026-10-11). Talents are listed with the abilities and checked with spell.<key>.known().
br.lists.spells.DRUID.Shared = {
            abilities     = {
                -- Bear Form
                bash                = {5211, 6798, 8983}, -- Ranks 1-3
                challengingRoar     = 5209,
                demoralizingRoar    = {99, 1735, 9490, 9747, 9898}, -- Ranks 1-5
                enrage              = 5229,
                feralChargeBear     = 16979,
                frenziedRegeneration = 22842,
                growl               = 6795,
                lacerate            = {414644, 1235826, 1235827}, -- Ranks 1-3 (42/50/58)
                maul                = {6807, 6808, 6809, 8972, 9745, 9880, 9881}, -- Ranks 1-7
                primalBite          = {407995, 1238069, 1238070, 1238073}, -- Talent, Ranks 1-4
                swipe               = {779, 780, 769, 9754, 9908}, -- Ranks 1-5
                -- Cat Form
                claw                = {1082, 3029, 5201, 9849, 9850}, -- Ranks 1-5
                cower               = {8998, 9000, 9892}, -- Ranks 1-3
                dash                = {1850, 9821}, -- Ranks 1-2
                ferociousBite       = {22568, 22827, 22828, 22829, 31018}, -- Ranks 1-5
                pounce              = {9005, 9823, 9827}, -- Ranks 1-3
                prowl               = {5215, 6783, 9913}, -- Ranks 1-3
                rake                = {1822, 1823, 1824, 9904}, -- Ranks 1-4
                ravage              = {6785, 6787, 9866, 9867}, -- Ranks 1-4
                rip                 = {1079, 9492, 9493, 9752, 9894, 9896}, -- Ranks 1-6
                shiftingPower       = 1322605, -- Talent (ID confirmed in game)
                shred               = {5221, 6800, 8992, 9829, 9830}, -- Ranks 1-5
                swipeCat            = 411128,
                tigersFury          = 5217,
                -- Cat or Bear Form
                berserk             = 417141, -- Talent
                feralCharge         = 1238122, -- Talent: charge in Bear Form, leap behind the target in Cat Form
                -- Caster Form
                barkskin            = 22812,
                entanglingRoots     = {339, 1062, 5195, 5196, 9852, 9853}, -- Ranks 1-6
                faerieFire          = {770, 778, 9749, 9907}, -- Ranks 1-4
                hibernate           = {2637, 18657, 18658}, -- Ranks 1-3
                hurricane           = {16914, 17401, 17402}, -- Ranks 1-3
                innervate           = 29166,
                insectSwarm         = {5570, 24974, 24975, 24976, 24977}, -- Talent, Ranks 1-5
                moonfire            = {8921, 8924, 8925, 8926, 8927, 8928, 8929, 9833, 9834, 9835}, -- Ranks 1-10
                naturesGrasp        = {16689, 16810, 16811, 16812, 16813, 17329}, -- Ranks 1-6
                naturesSwiftness    = 17116, -- Talent
                sootheAnimal        = {2908, 8955, 9901}, -- Ranks 1-3
                starfire            = {2912, 8949, 8950, 8951, 9875, 9876, 25298}, -- Ranks 1-7
                wrath               = {5176, 5177, 5178, 5179, 5180, 6780, 8905, 9912}, -- Ranks 1-8
                -- Healing
                healingTouch        = {5185, 5186, 5187, 5188, 5189, 6778, 8903, 9758, 9888, 9889, 25297}, -- Ranks 1-11
                rebirth             = {20484, 20739, 20742, 20747, 20748}, -- Ranks 1-5
                regrowth            = {8936, 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858}, -- Ranks 1-9
                rejuvenation        = {774, 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841, 25299}, -- Ranks 1-11
                revive              = {437138, 1237948, 1237949, 1237950, 1237951}, -- Ranks 1-5 (out of combat)
                swiftmend           = 18562, -- Talent
                tranquility         = {740, 8918, 9862, 9863}, -- Ranks 1-4
                wildGrowth          = {408120, 1238214, 1238215}, -- Talent, Ranks 1-3
                -- Buffs
                giftOfTheWild       = {21849, 21850}, -- Ranks 1-2
                markOfTheWild       = {1126, 5232, 6756, 5234, 8907, 9884, 9885}, -- Ranks 1-7
                thorns              = {467, 782, 1075, 8914, 9756, 9910}, -- Ranks 1-6
                -- Dispels
                abolishPoison       = 2893,
                curePoison          = 8946,
                removeCurse         = 2782,
                -- Passives and talents
                eclipse             = 408248, -- Talent: Wrath speeds up the next Starfires
                omenOfClarity       = 16864,
                rendAndTear         = 1223246, -- Talent: +20% melee damage on bleeding targets
                -- General
                autoAttack          = 6603,
                -- Shapeshifting
                aquaticForm         = 1066,
                bearForm            = {5487, 9634}, -- Rank 2 is Dire Bear Form
                catForm             = 768,
                direBearForm        = 9634,
                moonkinForm         = 24858, -- Talent
                travelForm          = 783,
            },
            buffs         = {
                -- Buffs
                abolishPoison       = 2893,
                barkskin            = 22812,
                berserk             = 417141,
                clearcasting        = 16870,
                dash                = {1850, 9821},
                eclipse             = 408255, -- Next Starfire 0.5 sec faster, per stack
                enrage              = 5229,
                frenziedRegeneration = 22842,
                giftOfTheWild       = {21849, 21850},
                markOfTheWild       = {1126, 5232, 6756, 5234, 8907, 9884, 9885},
                naturesGrasp        = {16689, 16810, 16811, 16812, 16813, 17329},
                naturesSwiftness    = 17116,
                omenOfClarity       = 16864,
                prowl               = {5215, 6783, 9913},
                regrowth            = {8936, 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858},
                rejuvenation        = {774, 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841, 25299},
                shadowmeld          = 20580,
                thorns              = {467, 782, 1075, 8914, 9756, 9910},
                tigersFury          = 5217,
                -- Forms
                aquaticForm         = 1066,
                bearForm            = {5487, 9634}, -- Rank 2 is Dire Bear Form
                catForm             = 768,
                direBearForm        = 9634,
                moonkinForm         = 24858,
                travelForm          = 783,
            },
            debuffs       = {
                demoralizingRoar    = {99, 1735, 9490, 9747, 9898},
                entanglingRoots     = {339, 1062, 5195, 5196, 9852, 9853},
                faerieFire          = {770, 778, 9749, 9907},
                hibernate           = {2637, 18657, 18658},
                insectSwarm         = {5570, 24974, 24975, 24976, 24977},
                lacerate            = {414644, 1235826, 1235827},
                moonfire            = {8921, 8924, 8925, 8926, 8927, 8928, 8929, 9833, 9834, 9835},
                pounceBleed         = {9007, 9824, 9826},
                rake                = {1822, 1823, 1824, 9904},
                rip                 = {1079, 9492, 9493, 9752, 9894, 9896},
            },
            glyphs        = {
            },
            talents       = {
            },
            talentsHeroic = {
            },
        }
