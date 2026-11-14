local _, br = ...
br.lists.spells.WARRIOR = br.lists.spells.WARRIOR or {}
-- WoW Forever (1.60) Warrior. IDs and ranks from wowsims/forever's spell data (generated from the
-- Forever client's tables, sim/warrior/spell_data_auto_gen.go), every ID's name and learn level
-- checked against Wowhead's Forever tooltips (2026-11-14). Not yet checked against a live Warrior's
-- spellbook: Logs/Spells.log lists anything the game has that these lists miss. Talents are listed
-- with the abilities and checked with spell.<key>.known().
br.lists.spells.WARRIOR.Shared = {
            abilities     = {
                -- Battle Stance
                charge              = {100, 6178, 11578}, -- Ranks 1-3 (out of combat)
                mockingBlow         = {694, 7400, 7402, 20559, 20560}, -- Ranks 1-5
                overpower           = {7384, 7887, 11584, 11585}, -- Ranks 1-4 (after a dodge, or a Bloodthrill proc)
                retaliation         = 20230,
                spearingStrike      = 1310222, -- Talent: 75% weapon damage, double against Giants, Dragonkin and mounted targets
                sweepingStrikes     = 12292, -- Talent
                thunderClap         = {6343, 8198, 8204, 8205, 11580, 11581}, -- Ranks 1-6
                -- Defensive Stance
                disarm              = 676,
                revenge             = {6572, 6574, 7379, 11600, 11601, 25288}, -- Ranks 1-6 (after a block, dodge or parry)
                shieldBlock         = 2565,
                shieldWall          = 871,
                taunt               = 355,
                -- Berserker Stance
                berserkerRage       = 18499,
                intercept           = {20252, 20616, 20617}, -- Ranks 1-3
                pummel              = {6552, 6554}, -- Ranks 1-2
                recklessness        = 1719,
                whirlwind           = 1680,
                -- Any stance
                battleShout         = {6673, 5242, 6192, 11549, 11550, 11551, 25289}, -- Ranks 1-7
                bloodrage           = 2687,
                challengingShout    = 1161,
                cleave              = {845, 7369, 11608, 11609, 20569}, -- Ranks 1-5
                demoralizingShout   = {1160, 6190, 11554, 11555, 11556}, -- Ranks 1-5
                execute             = {5308, 20658, 20660, 20661, 20662}, -- Ranks 1-5
                hamstring           = {1715, 7372, 7373}, -- Ranks 1-3
                heroicStrike        = {78, 284, 285, 1608, 11564, 11565, 11566, 11567, 25286}, -- Ranks 1-9
                intimidatingShout   = 5246,
                rend                = {772, 6546, 6547, 6548, 11572, 11573, 11574}, -- Ranks 1-7
                shieldBash          = {72, 1671, 1672}, -- Ranks 1-3
                slam                = {1240193, 1464, 8820, 11604, 11605}, -- Ranks 1-5 (Rank 1 is Forever's own, level 20)
                sunderArmor         = {7386, 7405, 8380, 11596, 11597}, -- Ranks 1-5
                victoryRush         = 402927, -- After a killing blow (the Victorious buff)
                -- Talents
                bloodthirst         = {23881, 23892, 23893, 23894}, -- Talent, Ranks 1-4
                concussionBlow      = 12809, -- Talent
                deathWish           = 12328, -- Talent
                lastStand           = 12975, -- Talent
                mortalStrike        = {12294, 21551, 21552, 21553}, -- Talent, Ranks 1-4
                piercingHowl        = 12323, -- Talent
                recklessSwings      = 1329555, -- Talent: next 4 melee attacks generate 5 more Rage, costs 25% of base health
                shieldSlam          = {23922, 23923, 23924, 23925}, -- Talent, Ranks 1-4
                -- Passives and talents
                angerManagement     = 12296, -- Talent
                bloodthrill         = 1289682, -- Talent: main-hand hits on your Rend's target can allow Overpower
                deepWounds          = 12834, -- Talent
                enrage              = 12317, -- Talent (the buff is 12880)
                flurry              = 12319, -- Talent
                goreDrinker         = 1323967, -- Talent: rage abilities make the next 3 hits heal
                improvedSlam        = 12862, -- Talent
                improvedTacticalMastery = 12295, -- Talent: more Rage kept on a stance change
                tacticalMastery     = 1310185, -- Level 14: Rage kept on a stance change
                -- Ranged
                shootBow            = 2480,
                shootCrossbow       = 7919,
                shootGun            = 7918,
                throw               = 2764,
                -- Stances
                battleStance        = 2457,
                berserkerStance     = 2458, -- Level 30
                defensiveStance     = 71, -- Level 10
            },
            buffs         = {
                battleShout         = {6673, 5242, 6192, 11549, 11550, 11551, 25289},
                berserkerRage       = 18499,
                bloodrage           = 29131, -- The Rage over 10 sec
                deathWish           = 12328,
                defensiveState      = 5302, -- After a block, dodge or parry: Revenge usable
                enrage              = 12880,
                flurry              = 12966,
                goreDrinker         = 1323969,
                lastStand           = 12976,
                overpower           = 1282733, -- After a dodge or a Bloodthrill proc: Overpower usable
                recklessSwings      = 1329555,
                recklessness        = 1719,
                retaliation         = 20230,
                shieldBlock         = 2565,
                shieldWall          = 871,
                sweepingStrikes     = 12292,
                victorious          = 402975, -- After a killing blow: Victory Rush usable
                -- Stances
                battleStance        = 2457,
                berserkerStance     = 2458,
                defensiveStance     = 71,
            },
            debuffs       = {
                chargeStun          = 7922,
                concussionBlow      = 12809,
                deepWounds          = {412609, 12162}, -- 412609 is the bleed wowsims models; 12162 the talent's trigger
                demoralizingShout   = {1160, 6190, 11554, 11555, 11556},
                disarm              = 676,
                hamstring           = {1715, 7372, 7373},
                improvedHamstring   = 23694, -- The talent's root
                interceptStun       = {20253, 20614, 20615},
                intimidatingShout   = {5246, 20511},
                longDaze            = 12705, -- Improved Pummel's daze
                mockingBlow         = {694, 7400, 7402, 20559, 20560},
                mortalStrike        = {12294, 21551, 21552, 21553},
                piercingHowl        = 12323,
                rend                = {772, 6546, 6547, 6548, 11572, 11573, 11574},
                shieldBashSilence   = 18498, -- Improved Shield Bash's silence
                sunderArmor         = {7386, 7405, 8380, 11596, 11597},
                thunderClap         = {6343, 8198, 8204, 8205, 11580, 11581},
            },
            glyphs        = {
            },
            talents       = {
            },
            talentsHeroic = {
            },
        }

-- Bleeds: the ability key -> the debuff key it puts on the target (unit:isBleedImmune learns from them)
br.lists.bleeds = br.lists.bleeds or {}
br.lists.bleeds.WARRIOR = { rend = "rend" }
