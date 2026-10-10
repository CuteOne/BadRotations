local _, br = ...
if br.lists == nil then br.lists = {} end

-- Spell 99 is Retail's Incapacitating Roar in the shared long-CC list, but here it's
-- Demoralizing Roar (Rank 1). Left in, every mob a bear Roars reads as crowd
-- controlled, and "Don't break CCs" drops it as a target for the rest of the fight.
if br.lists.longCC then br.lists.longCC[99] = nil end

-- The shared long-CC list only carries Rank 1 IDs, so "Don't break CCs" missed every
-- higher rank. Each ID below was checked against Wowhead's Classic database (2026-10-05).
if br.lists.longCC then
    for _, id in ipairs({
        1062, 5195, 5196, 9852, 9853,   -- Entangling Roots (Rank 2-6)
        18657, 18658,                   -- Hibernate (Rank 2-3)
        14308, 14309,                   -- Freezing Trap Effect (Rank 2-3)
        24132, 24133,                   -- Wyvern Sting (Rank 2-3)
        19503,                          -- Scatter Shot
        12824, 12825, 12826,            -- Polymorph (Rank 2-4)
        8124, 10888, 10890,             -- Psychic Scream (Rank 2-4)
        9485, 10955,                    -- Shackle Undead (Rank 2-3)
        1777, 8629, 11285, 11286,       -- Gouge (Rank 2-5)
        2070, 11297,                    -- Sap (Rank 2-3)
        5782, 6213, 6215,               -- Fear (Rank 1-3)
        17928,                          -- Howl of Terror (Rank 2)
        18647,                          -- Banish (Rank 2)
    }) do
        br.lists.longCC[id] = true
    end
end

-- Forever reworked the racials and added new ones, plus a new race, the Skyborne (High
-- Order for the Alliance, Windshaper for the Horde). There are no Blood Elves or Draenei.
-- IDs and effects checked against Wowhead's Forever database (2026-10-05).
local playerClass = select(2, br._G.UnitClass("player"))
-- Gnome's Eureka! is a different spell for each class that can be a Gnome.
local eurekaByClass = { ROGUE = 1259812, WARRIOR = 1259813, MAGE = 1259817, WARLOCK = 1259821, PRIEST = 1259823 }

-- cast.racial() is the race's damage racial, so a profile can use it SimC-style ("use
-- racial on cooldown for DPS") without checking race. Races with no damage racial
-- (Human, Dwarf, Undead, Tauren, Skyborne, and Gnomes without Eureka!) are left out: their
-- racial resolves to 0, which BR treats as "nothing to cast". Every racial, damage or
-- not, also has its own key in the abilities table below.
br.lists.racials = {
    NightElf = 1259799, -- Elune's Light (+10% crit)
    Gnome    = eurekaByClass[playerClass], -- Eureka! (nil for classes without one)
    Orc      = 20572,   -- Blood Fury (+10% attack and spell power)
    Troll    = 20554,   -- Berserking (+10% casting and attack speed)
}

br.lists.spells = {}
br.lists.spells.Shared = {
        Shared = {
            abilities        = {
                autoAttack     = 6603,
                autoShot       = 75,
                global         = 5176, -- Classic uses class-specific GCD spells, but we use a default here
                racial         = br.functions.spell:getRacial(),
                -- Each Forever racial by name, for profiles that want a specific one.
                -- Only the player's own race (and class, for Eureka!) will be known.
                berserking        = 20554,   -- Troll
                bloodFury         = 20572,   -- Orc
                cannibalize       = 20577,   -- Undead
                elunesLight       = 1259799, -- Night Elf
                escapeArtist      = 20589,   -- Gnome
                eureka            = eurekaByClass[playerClass], -- Gnome (nil for other classes)
                perception        = 20600,   -- Human
                readLeyLine       = 1259705, -- High Order Skyborne (Alliance)
                shadowmeld        = 20580,   -- Night Elf Rogue
                shatterCurse      = 1299026, -- Orc
                skysight          = 1259686, -- Windshaper Skyborne (Horde)
                stoneform         = 20594,   -- Dwarf
                walkOnAir         = 1259416, -- Skyborne
                warStomp          = 20549,   -- Tauren
                willOfTheForsaken = 7744,    -- Undead
                willToSurvive     = 1259718, -- Human
            },
            buffs            = {
                -- ancientHysteria                = 90355,
                -- battlePotionOfAgility          = 279152,
                -- battlePotionOfIntellect        = 279151,
                -- battlePotionOfStrength         = 279153,
                -- superiorBattlePotionOfAgility  = 298146,
                -- potionOfUnbridledFury          = 300714,
                -- blessingOfSacrifice            = 6940,
                -- greaterBlessingOfKings         = 203538,
                -- greaterBlessingOfWisdom        = 203539,
                -- battleScarredAugmentation      = 270058, -- BfA Augment Rune Buff
                -- blessingOfFreedom              = 1044,
                -- blessingOfProtection           = 1022,
                -- bloodLust                      = {
                --     ancientHysteria     = 90355,
                --     bloodlust           = 2825,
                --     drumsOfRage         = 146555,
                --     -- drumsOfTheMaelstrom = 256740,
                --     -- drumsOfTheMountain  = 230935,
                --     heroism             = 32182,
                --     -- netherwinds         = 160452,
                --     -- primalRage          = 264667,
                --     timewarp            = 80353,
                -- },
                -- concordanceOfTheLegionfall     = 239042,
                -- defiledAugmentation            = 224001, -- Lightforged Augment Rune buff
                -- felFocus                       = 242551,
                -- flashOfSpringBlossoms       = 105689,
                -- flaskOfTenThousandScars        = 188035,
                -- flaskOfTheCountlessArmies      = 188034,
                -- flaskOfTheSeventhDemon         = 188033,
                -- flaskOfTheWhisperedPact        = 188031,
                -- flaskOfTheCurrents             = 251836,
                -- flaskOfEndlessFathoms          = 251837,
                -- flaskOfTheVastHorizon          = 251838,
                -- flaskOfTheUndertow             = 251839,
                -- flayedWingToxin                = 345546,
                -- fruitfulMachinatins            = 242623, -- Absorb Shield from Deceiver's Grand Design
                -- mistcallerOcarina              = 330067, -- SL Trinket with group buff
                -- greaterFlaskOfEndlessFathoms   = 298837,
                -- greaterFlaskOfTheCurrents      = 298836,
                -- greaterFlaskOfTheUndertow      = 298841,
                -- greaterFlaskOfTheVastHorizon   = 298839,
                -- guidingHand                    = 242622, -- from The Deceiver's Grand Design
                -- heroism                        = 32182,
                -- ineffableTruth                 = 316801,
                -- latentArcana                   = 296962,
                -- netherwinds                    = 160452,
                -- norgannonsForesight            = 236373,
                -- overchargeMana                 = 299624,
                -- potionOfBurstingBlood          = 265514,
                -- potionOfFocusedResolve         = 298317,
                -- prolongedPower                 = 229206,
                racial                         = br.functions.spell:getRacial(),
                -- razorCoral                     = 303570, -- Crit Buff from Ashvane's Razor Coral
                -- sephuz1                        = 208051, -- the fulltime 10% movement, 2% haste buff
                -- sephuz2                        = 208052, -- the proc, 70% movement, 25% haste buff
                -- sephuzCooldown                 = 226262, -- CD (30 seconds) for the proc
                -- shadowmeld                     = 20580,
                -- symbolOfHope                   = 64901,
                -- timeWarp                       = 80353,
                -- whispersOfInsanity             = 176151,
                -- cracklingTourmaline            = 290372,
                -- saphireofBrilliance            = 290365,
                -- vigorEngaged                   = 287916,
                -- soulshape                      = 310143,
                -- soulIgnition                   = 345251,
                -- spectralFlaskOfPower           = 307185,
                -- elementalPotionOfPower         = 371024,
                -- elementalPotionOfUltimatePower = 371028,
                -- phialOfGlacialFury             = 373257,
                -- phialOfTepidVersatility        = 371172,
                -- icedPhialOfCorruptingRage      = 374000,
                -- domineeringArrogance           = 411661,
                -- runeOfReorigination              = 139120,
                -- vicious                          = 148903,
                -- virmensBite                      = 105697,
            },
            --TODO Add to API
            itemEnchantments = {
                --Dragonflight weapon Imbue's from inscription enchantments
                --Quality of aura should always be GOLD,SILVER,COPPER
                -- buzzingRune  = { 6514, 6513, 6512 },
                -- chirpingRune = { 6695, 6694, 6515 },
                -- howlingRune  = { 6518, 6517, 6516 },
                -- hissingRune  = { 6839, 6837, 6838 },
            },
            debuffs          = {
                -- bloodOfTheEnemy   = 297108,
                -- concentratedFlame = 295368,
                -- conductiveInk     = 302565,
                -- convert           = 122740,
                -- dampening         = 110310,
                -- eyeOfLeotheras    = 206649,
                -- necroticWound     = 209858,
                -- razorCoral        = 303568, --304877,
                -- repeatPerformance = 304409,
                -- shiverVenom       = 301624,
                -- temptation        = 234143,
                -- eyeOfCorruption   = 315161,
                -- grandDelusions    = 319695,
                -- graspingTendrils  = 315176,
                -- creepingMadness   = 313255,
                -- fixate            = 318078,
                -- thirstForBlood    = 266107,
                -- mightyBash        = 5211,
                -- defiledGround     = 314565,
                -- vileCorruption    = 314392,
                -- timeToFeed        = 162415, -- Oshir Iron Docks
                -- cascadingTerror   = 314478,
            },
            essences         = {
            },
        },
    }
