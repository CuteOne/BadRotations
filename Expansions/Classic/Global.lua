local _, br = ...
if br.lists == nil then br.lists = {} end

br.lists.racials = {
    NightElf     = 20580, -- Shadowmeld
    -- Dynamic lookup base IDs
    _draeneiBase = 28880, -- Gift of the Naaru
}

br.lists.spells = {}
br.lists.spells.Shared = {
        Shared = {
            abilities        = {
                autoAttack     = 6603,
                autoShot       = 75,
                giftOfTheNaaru = br.functions.spell:getRacial("Draenei"), --select(7, GetSpellInfo(GetSpellInfo(28880))),
                global         = 5176, -- Classic uses class-specific GCD spells, but we use a default here
                -- latentArcana   = 296971,
                -- lightsJudgment = 255647,
                quakingPalm    = br.functions.spell:getRacial("Pandaren"),
                racial         = br.functions.spell:getRacial(),
                shadowmeld     = br.functions.spell:getRacial("NightElf"),
                -- twoForms      = 68996,
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
