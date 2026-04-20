local _, br = ...
br.lists.spells.HUNTER = br.lists.spells.HUNTER or {}
br.lists.spells.HUNTER.Shared = {
    abilities = {
        -- Core Ranged
        autoShot          = 75,
        steadyShot        = 34120,                                                          -- TBC only; single rank, level 62
        multiShot         = {2643, 14288, 14289, 14290, 25294, 27021},                     -- R1-R6 (lv18/30/42/54/60/67)
        arcaneShot        = {3044, 14281, 14282, 14283, 14284, 14285, 14286, 14287, 27019}, -- R1-R9 (lv6-69)
        aimedShot         = {19434, 20900, 20901, 20902, 20903, 20904, 20905, 27065},      -- R1-R8 (lv20-70); MM talent
        killCommand       = 34026,                                                          -- Single rank; activated on pet crit, off GCD
        -- Major Cooldowns
        rapidFire         = 3045,
        bestialWrath      = 19574,   -- BM talent (single rank)
        intimidation      = 19577,   -- BM talent; stuns pet's target (single rank)
        -- Utility / Threat
        misdirection      = 34477,   -- TBC new (single rank)
        huntersMark       = {1130, 14323, 14324, 14325},                                   -- R1-R4 (lv1/10/20/30)
        distractingShot   = 27020,   -- High-threat shot; used for tank support on pull
        concussiveShot    = 5116,    -- Slows target; CC/utility (single rank)
        -- Melee
        raptorStrike      = {2973, 14260, 14261, 14262, 14263, 14264, 14265, 27014},       -- R1-R8 (lv1-66)
        wingClip          = {2974, 14268},                                               -- R1-R2 (lv10/30); R3 not present in TBC
        mongooseBite      = {1495, 14269, 14270, 14271, 14272, 36916},                    -- R1-R6 (lv16-66); usable after dodging
        counterattack     = {19306, 20909, 27067},                                         -- R1-R3 (lv20/30/40); SV talent, usable after parrying
        -- Survival / Defensive
        feignDeath        = 5384,
        disengage         = 781,    -- Drops combat/threat; escape and re-range tool (single rank, lv6)
        -- AoE
        volley            = {1510, 14294, 14295, 27022},                                   -- R1-R4 (lv40/50/58/67)
        -- Stings
        serpentSting      = {1978, 13549, 13550, 13551, 13552, 13553, 13554, 13555, 25295, 27016}, -- R1-R10 (lv4-67)
        scorpidSting      = 3043,    -- Reduces target AP; utility (keep max rank only)
        viperSting        = 3034,    -- Drains mana; PvP/utility (keep max rank only)
        -- Traps
        explosiveTrap     = {13813, 14316, 14317, 27025},                                  -- R1-R4 (lv34/44/54/61)
        immolationTrap    = {13795, 14302, 14303, 14304, 27023},                           -- R1-R5 (lv16/26/36/46/60)
        freezingTrap      = {1499, 14310, 14311},                                          -- R1-R3 (lv20/38/56)
        frostTrap         = 13809,   -- AoE slow field (single rank)
        flare             = 1543,    -- Reveals stealth/traps (single rank)
        -- Aspects
        aspectOfTheHawk   = {13165, 14318, 14319, 14320, 14321, 14322, 25296, 27044},      -- R1-R8 (lv10/18/28/38/48/58/60/68)
        aspectOfTheViper  = 34074,   -- TBC new; mana regen (single rank)
        aspectOfTheCheetah = 5118,   -- Movement speed solo (single rank)
        aspectOfThePack   = 13159,   -- Group movement speed (single rank)
        -- Pet Management (player-cast)
        callPet           = 883,
        revivePet         = 982,
        dismissPet        = 2641,
        mendPet           = {136, 3111, 3661, 3662, 13542, 13543, 13544, 27046},           -- R1-R8 (lv12/20/28/36/44/52/60/68)
        feedPet           = 6991,
        -- Pet Abilities (cast from pet action bar / by bot targeting pet)
        bite              = {17253, 17254, 17255, 17256, 17257, 17258, 17259, 17260, 27050},     -- R1-R9 (lv1/8/16/24/32/40/48/56/62); universal
        claw              = {16827, 16828, 16829, 16830, 16831, 16832, 27049},                   -- R1-R6+R9 (R7-R8 IDs unconfirmed); Cat/Bear/Raptor/Scorpid/Crab
        dash              = {23099, 23109, 23110},                                               -- R1-R3 (lv30/40/50); Wolf/Cat/Boar/others
        growl             = {2649, 14916, 14917, 14918, 14919, 14920, 14921, 27047},            -- R1-R8 (lv1/10/20/30/40/50/60/70); all pets
        lightningBreath   = {24844, 25008, 25009, 25010, 25011, 25012},                         -- R1-R6 (lv1/12/24/36/48/60); Wind Serpent
        -- Pet Family Special Abilities (TBC)
        -- Wolf: party +physical damage buff on ~10s CD — strongest DPS pet utility
        furiousHowl       = {24604, 24605, 24603, 24597},                                       -- R1-R4 (lv10/24/40/56); Wolf only
        -- Carrion Bird / Bat / Owl: AoE melee-AP debuff (NOT Sporebat)
        screech           = {24423, 24577, 24578, 24579, 27051},                                -- R1-R5 (lv8/24/48/56/64); Carrion Bird/Bat/Owl
        -- Carrion Bird / Bat / Owl: gap-closing speed burst (aerial equivalent of Dash)
        dive              = {23145, 23147, 23148},                                              -- R1-R3 (lv30/40/50); Carrion Bird/Bat/Owl
        -- Gorilla: AoE Nature damage + threat (NO Pummel in TBC — only Thunderstomp)
        thunderstomp      = {26090, 26187, 26188, 27063},                                       -- R1-R4 (lv30/40/50/60); Gorilla only
        -- Dragonhawk: ranged fire damage (TBC-exclusive pet family; only 2 ranks)
        fireBreath        = {34889, 35323},                                                     -- R1-R2 (lv1/60); Dragonhawk only
        -- Turtle: single-rank 50% damage-reduction defensive CD
        shellShield       = 26064,                                                              -- R1 only (lv20); Turtle only
        -- Boar only: gap-closing charge w/ immobilize (Crab has NO abilities in TBC)
        charge            = {26177, 26178, 26179, 27685},                                       -- R2-R4+R6 (R1/R5 IDs unconfirmed); Boar only
        -- Boar / Ravager: stacking bleed on cooldown; sequential IDs R1-R9
        gore              = {35290, 35291, 35292, 35293, 35294, 35295, 35296, 35297, 35298},    -- R1-R9 (lv1/8/16/24/32/40/48/56/63); Boar/Ravager
        -- Scorpid: stacking nature damage poison that reduces AP
        scorpidPoison     = {24640, 24583, 24586, 24587, 27060},                                -- R1-R5 (lv8/24/40/56/64); Scorpid only
        -- Marksmanship talents
        trueShotAura      = 19506,                              -- +125 RAP party aura (single rank)
        silencingShot     = {34490, 34489},                    -- R1-R2 (lv28/38); 3s school silence
        scatterShot       = 19503,                             -- 4s disorient (single rank, lv21)
        -- Survival talents
        wyvernSting       = {19386, 24131, 24132, 27068},      -- R1-R4 (lv20+); sleep + DoT
        -- Additional aspects
        aspectOfTheMonkey = 13163,                             -- Dodge aura; early-level fallback
        aspectOfTheWild   = {20043, 20190, 27045},             -- R1-R3 (lv46/56/68); +Nature resist
    },
    buffs = {
        aspectOfTheHawk    = {13165, 14318, 14319, 14320, 14321, 14322, 25296, 27044},
        aspectOfTheViper   = 34074,
        aspectOfTheCheetah = 5118,
        aspectOfThePack    = 13159,
        aspectOfTheMonkey  = 13163,
        aspectOfTheWild    = {20043, 20190, 27045},
        trueShotAura       = 19506,
        rapidFire          = 3045,
        bestialWrath       = 19574,
        theBeastWithin     = 34471,  -- Player buff granted alongside Bestial Wrath (BM talent)
        feignDeath         = 5384,
        mendPet            = {136, 3111, 3661, 3662, 13542, 13543, 13544, 27046},
        -- Pet buffs
        dash               = {23099, 23109, 23110},           -- Pet Dash (speed boost on pet)
        dive               = {23145, 23147, 23148},           -- Bat/Owl/Carrion Bird Dive (speed boost on pet)
        shellShield        = 26064,                           -- Turtle defensive CD (on-pet buff)
        furiousHowl        = {24604, 24605, 24603, 24597},   -- Wolf Furious Howl; detected on allied units
    },
    debuffs = {
        huntersMark   = {1130, 14323, 14324, 14325},
        serpentSting  = {1978, 13549, 13550, 13551, 13552, 13553, 13554, 13555, 25295, 27016},
        scorpidSting  = 3043,
        viperSting    = 3034,
        concussiveShot = 5116,
        wyvernSting   = {19386, 24131, 24132, 27068},
        screech       = {24423, 24577, 24578, 24579, 27051}, -- Carrion Bird/Bat/Owl melee-AP debuff (any rank)
        scorpidPoison = {24640, 24583, 24586, 24587, 27060},  -- Scorpid AP-reducing poison (any rank)
    },
    glyphs     = {},
    interrupts = {
        silencingShot = {34490, 34489},
    },
    talents = {}, -- TBC has no talent-spell API (hasSubSpecs = false); cast.able.* handles talent gates
}
