local _, br = ...
br.lists.spells.DRUID = br.lists.spells.DRUID or {}
br.lists.spells.DRUID.Shared = {
            abilities     = {
                -- Bear Form
                bash                = {5211, 6798, 8983}, -- Ranks 1-3
                demoralizingRoar    = 99,
                enrage              = 5229,
                -- mangleBear          = 33878, -- TBC only
                maul                = {6807, 6808, 6809, 8972, 9745, 9880, 9881}, -- Ranks 1-7
                swipe               = {779, 780, 769, 9754}, -- Ranks 1-4
                -- Cat Form
                claw                = {1082, 3029, 5201, 9849, 9850, 9851}, -- Ranks 1-6
                faerieFireFeral     = 16857,
                ferociousBite       = {22568, 22827, 22828, 22829}, -- Ranks 1-4
                pounce              = 9005,
                prowl               = 5215,
                rake                = {1822, 1823, 1824, 9904, 9845}, -- Ranks 1-5
                ravage              = 6785,
                rip                 = {1079, 9492, 9493, 9752, 9894, 9896}, -- Ranks 1-6
                shred               = {5221, 6800, 8992, 9829, 9830}, -- Ranks 1-5
                tigersFury          = 5217,
                -- Caster Form
                barkskin            = 22812,
                entanglingRoots     = 339,
                faerieFire          = 770,
                healingTouch        = {5185, 5186, 5187, 5188, 5189, 6778, 8903, 9758, 9888, 9889}, -- Ranks 1-10
                innervate           = 29166,
                markOfTheWild       = {1126, 5232, 6756, 5234, 8907, 9884, 9885}, -- Ranks 1-7
                moonfire            = {8921, 8924, 8925, 8926, 8927, 8928, 8929, 9833, 9834, 9835}, -- Ranks 1-10
                naturesGrasp        = 16689,
                omenOfClarity       = 16864,
                regrowth            = {8936, 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858}, -- Ranks 1-9
                rejuvenation        = {774, 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841}, -- Ranks 1-10
                starfire            = {2912, 8949, 8950, 8951, 9875, 9876}, -- Ranks 1-6
                thorns              = {467, 782, 1075, 8914, 9756, 9910}, -- Ranks 1-6
                wrath               = {5176, 5177, 5178, 5179, 5180, 6780, 8905, 9912}, -- Ranks 1-8
                -- Dispels
                abolishPoison       = 2893,
                curePoison          = 8946,
                removeCurse         = 2782,
                -- General
                autoAttack          = 6603,
                -- Shapeshifting
                aquaticForm         = 1066,
                bearForm            = 5487,
                catForm             = 768,
                direBearForm        = 9634,
                moonkinForm         = 24858,
                travelForm          = 783,
            },
            buffs         = {
                -- Buffs
                abolishPoison       = 2893,
                barkskin            = 22812,
                clearcasting        = 16870,
                enrage              = 5229,
                markOfTheWild       = {1126, 5232, 6756, 5234, 8907, 9884, 9885},
                naturesGrasp        = 16689,
                omenOfClarity       = 16864,
                prowl               = 5215,
                regrowth            = {8936, 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858},
                rejuvenation        = {774, 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841},
                shadowmeld          = 20580,
                thorns              = {467, 782, 1075, 8914, 9756, 9910},
                tigersFury          = 5217,
                -- Forms
                aquaticForm         = 1066,
                bearForm            = 5487,
                catForm             = 768,
                direBearForm        = 9634,
                moonkinForm         = 24858,
                travelForm          = 783,
            },
            debuffs       = {
                demoralizingRoar    = 99,
                entanglingRoots     = 339,
                faerieFire          = {770, 778, 9749, 9907},
                faerieFireFeral     = {16857, 17390, 17391, 17392},
                moonfire            = {8921, 8924, 8925, 8926, 8927, 8928, 8929, 9833, 9834, 9835},
                rake                = {1822, 1823, 1824, 9904},
                rip                 = {1079, 9492, 9493, 9752, 9894, 9896},
            },
            glyphs        = {
                -- glyphOfTheCheetah        = 131113,
                -- glyphOfTheDoe            = 224122,
                -- glyphOfTheFeralChameleon = 210333,
                -- glyphOfTheOrca           = 114333,
                -- glyphOfTheSentinel       = 219062,
                -- glyphOfTheUrsolChameleon = 107059,
            },
            talents       = {
            },
            talentsHeroic = {
                -- bloomingInfusion     = 429433,
                -- bounteousBloom       = 429215,
                -- burstingGrowth       = 440120,
                -- cenariusMight        = 455797,
                -- controlOfTheDream    = 434249,
                -- dreamSurge           = 433831,
                -- durabilityOfNature   = 429227,
                -- earlySpring          = 428937,
                -- expansiveness        = 429399,
                -- grovesInspiration    = 429402,
                -- harmonyOfTheGrove    = 428731,
                -- potentEnchantments   = 429420,
                -- powerOfNature        = 428859,
                -- powerOfTheDream      = 434220,
                -- protectiveGrowth     = 433748,
                -- resilientFlourishing = 439880,
                -- rootNetwork          = 439882,
                -- treantsOfTheMoon     = 428544,
            },
        }
