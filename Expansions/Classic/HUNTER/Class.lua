local _, br = ...
br.lists.spells.HUNTER = br.lists.spells.HUNTER or {}
br.lists.spells.HUNTER.Shared = {
    abilities = {
        -- Core Ranged
        autoShot          = 75,
        tranquilizingShot = 19801,
        multiShot         = {2643, 14288, 14289, 14290, 25294}, -- Ranks 1-5
        arcaneShot        = {3044, 14281, 14282, 14283, 14284, 14285, 14286, 14287}, -- Ranks 1-8
        aimedShot         = {19434, 20900, 20901, 20902, 20903, 20904}, -- Ranks 1-6
        -- Major Cooldowns
        rapidFire         = 3045,
        bestialWrath      = 19574,
        intimidation      = 19577,
        -- Utility / Threat
        huntersMark       = {1130, 14323, 14324, 14325}, -- Ranks 1-4
        distractingShot   = {20736, 14274, 15629, 15630, 15631, 15632}, -- High-threat shot; used for tank support on pull
        concussiveShot    = 5116,
        -- Melee
        raptorStrike      = {2973, 14260, 14261, 14262, 14263, 14264, 14265, 14266}, -- Ranks 1-8
        wingClip          = {2974, 14267, 14268}, -- Ranks 1-3
        mongooseBite      = {1495, 14269, 14270, 14271}, -- Ranks 1-4
        counterattack     = {19306, 20909, 20910}, -- Ranks 1-3
        -- Survival / Defensive
        feignDeath        = 5384,
        disengage         = {781, 14272, 14273}, -- Ranks 1-3
        -- AoE
        volley            = {1510, 14294, 14295}, -- Ranks 1-3
        -- Stings
        serpentSting      = {1978, 13549, 13550, 13551, 13552, 13553, 13554, 13555, 25295}, -- Ranks 1-9
        scorpidSting      = {3043, 14275, 14276, 14277},
        viperSting        = {3034, 14279, 14280}, -- Ranks 1-3
        -- Traps
        explosiveTrap     = {13813, 14316, 14317}, -- Ranks 1-3
        immolationTrap    = {13795, 14302, 14303, 14304, 14305}, -- Ranks 1-5
        freezingTrap      = {1499, 14310, 14311}, -- Ranks 1-3
        frostTrap         = 13809,
        flare             = 1543,
        eagleEye          = 6197,
        -- Tracking
        trackBeasts       = 1494,
        trackDemons       = 19878,
        trackDragonkin    = 19879,
        trackElementals   = 19880,
        trackGiants       = 19882,
        trackHidden       = 19885,
        trackHumanoids    = 19883,
        trackUndead       = 19884,
        -- Aspects
        aspectOfTheHawk   = {13165, 14318, 14319, 14320, 14321, 14322, 25296}, -- Ranks 1-7
        aspectOfTheCheetah = 5118,
        aspectOfThePack   = 13159,
        -- Pet Management (player-cast)
        callPet           = 883,
        revivePet         = 982,
        dismissPet        = 2641,
        mendPet           = {136, 3111, 3661, 3662, 13542, 13543, 13544}, -- Ranks 1-7
        feedPet           = 6991,
        tameBeast         = 1515,
        beastLore         = 1462,
        scareBeast        = {1513, 14326, 14327}, -- Ranks 1-3
        -- Pet Abilities (cast from pet action bar / by bot targeting pet)
        bite              = {17253, 17255, 17256, 17257, 17258, 17259, 17260, 17261}, -- Ranks 1-8
        claw              = {16827, 16828, 16829, 16830, 16831, 16832}, -- Ranks 1-6
        dash              = {23099, 23109, 23110}, -- Ranks 1-3
        growl             = {2649, 14916, 14917, 14918, 14919, 14920, 14921}, -- Ranks 1-7
        lightningBreath   = {24844, 25008, 25009, 25010, 25011, 25012}, -- Ranks 1-6
        -- Pet Family Special Abilities
        -- Wolf: party +physical damage buff on ~10s CD — strongest DPS pet utility
        furiousHowl       = {24604, 24605, 24603, 24597}, -- Ranks 1-4
        -- Carrion Bird / Bat / Owl: AoE melee-AP debuff (NOT Sporebat)
        screech           = {24423, 24577, 24578, 24579}, -- Ranks 1-4
        -- Carrion Bird / Bat / Owl: gap-closing speed burst (aerial equivalent of Dash)
        dive              = {23145, 23147, 23148}, -- Ranks 1-3
        -- Gorilla: AoE Nature damage + threat
        thunderstomp      = {26090, 26187, 26188}, -- Ranks 1-3
        -- Turtle: single-rank 50% damage-reduction defensive CD
        shellShield       = 26064,
        -- Boar: gap-closing charge w/ immobilize
        charge            = {26177, 26178, 26179, 27685}, -- Ranks 1-4
        -- Scorpid: stacking nature damage poison that reduces AP
        scorpidPoison     = {24640, 24583, 24586, 24587}, -- Ranks 1-4
        -- Marksmanship talents
        trueShotAura      = 19506,
        scatterShot       = 19503,
        -- Survival talents
        wyvernSting       = {19386, 24132, 24133}, -- Ranks 1-3
        -- Additional aspects
        aspectOfTheMonkey = 13163, -- Dodge aura; early-level fallback
        aspectOfTheWild   = {20043, 20190}, -- Ranks 1-2
    },
    buffs = {
        aspectOfTheHawk    = {13165, 14318, 14319, 14320, 14321, 14322, 25296}, -- Ranks 1-7
        aspectOfTheCheetah = 5118,
        aspectOfThePack    = 13159,
        aspectOfTheMonkey  = 13163,
        aspectOfTheWild    = {20043, 20190}, -- Ranks 1-2
        trueShotAura       = 19506,
        rapidFire          = 3045,
        bestialWrath       = 19574,
        feignDeath         = 5384,
        mendPet            = {136, 3111, 3661, 3662, 13542, 13543, 13544}, -- Ranks 1-7
        -- Pet buffs
        dash               = {23099, 23109, 23110}, -- Pet Dash (speed boost on pet)
        dive               = {23145, 23147, 23148}, -- Bat/Owl/Carrion Bird Dive (speed boost on pet)
        shellShield        = 26064, -- Turtle defensive CD (on-pet buff)
        furiousHowl        = {24604, 24605, 24603, 24597}, -- Wolf Furious Howl; detected on allied units
    },
    debuffs = {
        huntersMark   = {1130, 14323, 14324, 14325}, -- Ranks 1-4
        serpentSting  = {1978, 13549, 13550, 13551, 13552, 13553, 13554, 13555, 25295}, -- Ranks 1-9
        scorpidSting  = {3043, 14275, 14276, 14277},
        viperSting    = {3034, 14279, 14280}, -- Ranks 1-3
        concussiveShot = 5116,
        wyvernSting   = {19386, 24132, 24133}, -- the sleep (the DoT after it is another aura)
        screech       = {24423, 24577, 24578, 24579}, -- Ranks 1-4
        scorpidPoison = {24640, 24583, 24586, 24587}, -- Ranks 1-4
        aimedShot     = {19434, 20900, 20901, 20902, 20903, 20904}, -- Ranks 1-6
        freezingTrap  = 3355, -- Freezing Trap Effect
    },
    interrupts = {
    },
    glyphs     = {},
    talents    = {},
}
