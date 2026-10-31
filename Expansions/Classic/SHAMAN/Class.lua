local _, br = ...
br.lists.spells.SHAMAN = br.lists.spells.SHAMAN or {}
br.lists.spells.SHAMAN.Shared = {
            abilities     = {
                ancestralSpirit         = {2008, 20609, 20610, 20776, 20777}, -- Ranks 1-5
                astralRecall            = 556,
                chainHeal               = {1064, 10622, 10623}, -- Ranks 1-3
                chainLightning          = {421, 930, 2860, 10605}, -- Ranks 1-4
                cureDisease             = 2870,
                curePoison              = 526,
                diseaseCleansingTotem   = 8170,
                earthShock              = {8042, 8044, 8045, 8046, 10412, 10413, 10414}, -- Ranks 1-7
                earthbindTotem          = 2484,
                elementalMastery        = 16166,
                farSight                = 6196,
                fireNovaTotem           = {1535, 8498, 8499, 11314, 11315}, -- Ranks 1-5
                fireResistanceTotem     = {8184, 10537, 10538}, -- Ranks 1-3
                flameShock              = {8050, 8052, 8053, 10447, 10448, 29228}, -- Ranks 1-6
                flametongueTotem        = {8227, 8249, 10526, 16387}, -- Ranks 1-4
                flametongueWeapon       = {8024, 8027, 8030, 16339, 16341, 16342}, -- Ranks 1-6
                frostResistanceTotem    = {8181, 10478, 10479}, -- Ranks 1-3
                frostShock              = {8056, 8058, 10472, 10473}, -- Ranks 1-4
                frostbrandWeapon        = {8033, 8038, 10456, 16355, 16356}, -- Ranks 1-5
                ghostWolf               = 2645,
                graceOfAirTotem         = {8835, 10627, 25359}, -- Ranks 1-3
                groundingTotem          = 8177,
                healingStreamTotem      = {5394, 6375, 6377, 10462, 10463}, -- Ranks 1-5
                healingWave             = {331, 332, 547, 913, 939, 959, 8005, 10395, 10396, 25357}, -- Ranks 1-10
                lesserHealingWave       = {8004, 8008, 8010, 10466, 10467, 10468}, -- Ranks 1-6
                lightningBolt           = {403, 529, 548, 915, 943, 6041, 10391, 10392, 15207, 15208}, -- Ranks 1-10
                lightningShield         = {324, 325, 905, 945, 8134, 10431, 10432}, -- Ranks 1-7
                magmaTotem              = {8190, 10585, 10586, 10587}, -- Ranks 1-4
                manaSpringTotem         = {5675, 10495, 10496, 10497}, -- Ranks 1-4
                manaTideTotem           = {16190, 17354, 17359}, -- talent, Ranks 1-3
                naturesSwiftness        = 16188,
                natureResistanceTotem   = {10595, 10600, 10601}, -- Ranks 1-3
                poisonCleansingTotem    = 8166,
                purge                   = {370, 8012}, -- Ranks 1-2
                reincarnation           = 20608,
                rockbiterWeapon         = {8017, 8018, 8019, 10399, 16314, 16315, 16316}, -- Ranks 1-7
                searingTotem            = {3599, 6363, 6364, 6365, 10437, 10438}, -- Ranks 1-6
                sentryTotem             = 6495,
                stoneclawTotem          = {5730, 6390, 6391, 6392, 10427, 10428}, -- Ranks 1-6
                stoneskinTotem          = {8071, 8154, 8155, 10406, 10407, 10408}, -- Ranks 1-6
                strengthOfEarthTotem    = {8075, 8160, 8161, 10442, 25361}, -- Ranks 1-5
                stormstrike             = 17364,
                tranquilAirTotem        = 25908,
                tremorTotem             = 8143,
                waterBreathing          = 131,
                waterWalking            = 546,
                windfuryTotem           = {8512, 10613, 10614}, -- Ranks 1-3
                windfuryWeapon          = {8232, 8235, 10486, 16362}, -- Ranks 1-4
                windwallTotem           = {15107, 15111, 15112}, -- Ranks 1-3
            },
            imbues        = {
                windfuryWeapon    = {283, 284, 525, 1669,              -- r1-r4 enchant IDs (lvl 30-60)
                                     spells = {8232, 8235, 10486, 16362},},   -- r1-r4 spell IDs
                flametongueWeapon = {5, 4, 3, 523, 1665, 1666,        -- r1-r6 enchant IDs (lvl 10-60)
                                     spells = {8024, 8027, 8030, 16339, 16341, 16342}},
                frostbrandWeapon  = {2, 12, 524, 1667, 1668,          -- r1-r5 enchant IDs (lvl 20-60)
                                     spells = {8033, 8038, 10456, 16355, 16356}},
                rockbiterWeapon   = {29, 6, 1, 503, 1663, 683, 1664,  -- r1-r7 enchant IDs (lvl 1-60)
                                     spells = {8017, 8018, 8019, 10399, 16314, 16315, 16316},},
            },
            buffs         = {
                clearcasting        = 16246, -- Elemental Focus proc
                elementalMastery    = 16166,
                flurry              = {16257, 16277, 16278, 16279, 16280}, -- Ranks 1-5
                ghostWolf           = 2645,
                lightningShield     = {324, 325, 905, 945, 8134, 10431, 10432}, -- Ranks 1-7
                naturesSwiftness    = 16188,
                waterBreathing      = 131,
                waterWalking        = 546,
            },
            debuffs       = {
                earthbind               = 3600,
                flameShock              = {8050, 8052, 8053, 10447, 10448, 29228}, -- Ranks 1-6
                frostShock              = {8056, 8058, 10472, 10473}, -- Ranks 1-4
                stormstrike             = 17364,
            },
            glyphs        = {

            },
            talents       = {
            },
            totem = {
                air = {
                    graceOfAirTotem  = {8835, 10627, 25359}, -- Ranks 1-3
                    groundingTotem   = 8177,
                    natureResistanceTotem = {10595, 10600, 10601}, -- Ranks 1-3
                    sentryTotem      = 6495,
                    tranquilAirTotem = 25908,
                    windfuryTotem    = {8512, 10613, 10614}, -- Ranks 1-3
                    windwallTotem    = {15107, 15111, 15112}, -- Ranks 1-3
                },
                earth = {
                    earthbindTotem = 2484,
                    stoneskinTotem = {8071, 8154, 8155, 10406, 10407, 10408}, -- Ranks 1-6
                    stoneclawTotem = {5730, 6390, 6391, 6392, 10427, 10428}, -- Ranks 1-6
                    strengthOfEarthTotem = {8075, 8160, 8161, 10442, 25361}, -- Ranks 1-5
                    tremorTotem = 8143,
                },
                fire = {
                    fireNovaTotem = {1535, 8498, 8499, 11314, 11315}, -- Ranks 1-5
                    flametongueTotem = {8227, 8249, 10526, 16387}, -- Ranks 1-4
                    frostResistanceTotem = {8181, 10478, 10479}, -- Ranks 1-3
                    magmaTotem    = {8190, 10585, 10586, 10587}, -- Ranks 1-4
                    searingTotem  = {3599, 6363, 6364, 6365, 10437, 10438}, -- Ranks 1-6
                },
                water = {
                    diseaseCleansingTotem = 8170,
                    fireResistanceTotem = {8184, 10537, 10538}, -- Ranks 1-3
                    healingStreamTotem = {5394, 6375, 6377, 10462, 10463}, -- Ranks 1-5
                    manaSpringTotem    = {5675, 10495, 10496, 10497}, -- Ranks 1-4
                    manaTideTotem      = {16190, 17354, 17359}, -- Ranks 1-3
                    poisonCleansingTotem = 8166,
                },
            }
        }
