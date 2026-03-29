local _, br = ...
br.lists.spells.ROGUE = br.lists.spells.ROGUE or {}
br.lists.spells.ROGUE[261] = {
            abilities  = {
                ambush           = 8676,
                backstab         = 53,
                crimsonTempest   = 121411,
                eviscerate       = 2098,
                fanOfKnives      = 51723,
                hemorrhage       = 16511,
                preparation      = 14185,
                premeditation    = 14183,
                rupture          = 1943,
                shadowBlades     = 121471,
                shadowDance      = 121471,  -- MoP Classic uses same ID as Shadow Blades
                shadowstep       = 36554,
                shurikenToss     = 114014,
                sliceAndDice     = 5171,
                vanish           = 1856,
            },
            buffs      = {
                anticipation       = 115189, -- Talent buff for extra combo points
                masterOfSubtlety   = 31665,  -- Shadow Dance / Stealth buff
                shadowBlades       = 121471,
                shadowDance        = 121471,  -- MoP Classic uses same ID as Shadow Blades
                shadowmeld         = 58984,  -- Night Elf racial
                sliceAndDice       = 5171,
                sleightOfHand      = 145211, -- Proc from Ambush
                stealth            = 1784,
                subterfuge         = 115192, -- Talent - Stealth linger
                vanish             = 1856,
            },
            debuffs    = {
                crimsonTempest = 122233,
                findWeakness   = 91023, -- Shadow Dance debuff
                hemorrhage     = 16511,
                rupture        = 1943,
            },
            glyphs     = {
                glyphOfAmbush           = 56813,
                glyphOfBackstab         = 63254,
                glyphOfHemorrhage       = 56807,
                glyphOfPreparation      = 63249,
                glyphOfShadowDance      = 63253,
                glyphOfSliceAndDice     = 146638,
                glyphOfVanish           = 56814,
            },
            talents    = {
                -- Tier 1 (Level 15)
                nightstalker      = 14062,
                subterfuge        = 108208,
                shadowFocus       = 108209,
                -- Tier 2 (Level 30) - Shared
                deadlyThrow       = 26679,
                combatReadiness   = 74001,
                -- Tier 3 (Level 45)
                cheatDeath        = 31230,
                leechingPoison    = 108211,
                elusiveness       = 79008,
                -- Tier 4 (Level 60)
                cloakAndDagger    = 138106,
                shadowstep        = 36554,
                burstOfSpeed      = 108212,
                -- Tier 5 (Level 75)
                preyOnTheWeak     = 131511,
                paralyticPoison   = 108215,
                dirtyTricks       = 108216,
                -- Tier 6 (Level 90)
                shurikenToss      = 114014,
                markedForDeath    = 137619,
                anticipation      = 114015,
            },
        }
