local _, br = ...
if br.lists == nil then
	br.lists = {}
end
br.lists.spec = {
	DEATHKNIGHT = {
		Blood = 250,
		Frost = 251,
		Unholy = 252,
		Initial = 1455,
	},
	DEMONHUNTER = {
		Havoc = 577,
		Vengeance = 581,
		Initial = 1456,
	},
	DRUID = {
		Balance = 102,
		Feral = 103,
		Guardian = 104,
		Restoration = 105,
		Initial = 1447,
	},
	EVOKER = {
		Augmentation = 1473,
		Devastation = 1467,
		Preservation = 1468,
		Initial = 1465,
	},
	HUNTER = {
		BeastMastery = 253,
		Marksmanship = 254,
		Survival = 255,
		Initial = 1448,
	},
	MAGE = {
		Arcane = 62,
		Fire = 63,
		Frost = 64,
		Initial = 1449,
	},
	MONK = {
		Brewmaster = 268,
		Windwalker = 269,
		Mistweaver = 270,
		Initial = 1450,
	},
	PALADIN = {
		Holy = 65,
		Protection = 66,
		Retribution = 70,
		Initial = 1451,
	},
	PRIEST = {
		Discipline = 256,
		Holy = 257,
		Shadow = 258,
		Initial = 1452,
	},
	ROGUE = {
		Assassination = 259,
		Outlaw = 260,
		Subtlety = 261,
		Initial = 1453,
	},
	SHAMAN = {
		Elemental = 262,
		Enhancement = 263,
		Restoration = 264,
		Initial = 1444,
	},
	WARLOCK = {
		Affliction = 265,
		Demonology = 266,
		Destruction = 267,
		Initial = 1454,
	},
	WARRIOR = {
		Arms = 71,
		Fury = 72,
		Protection = 73,
		Initial = 1446,
	}
}
br.lists.heroSpec = {
	DEATHKNIGHT = {
		sanlayn = 31,
		riderOfTheApocalypse = 32,
		deathbringer = 33
	},
    DEMONHUNTER = {
        felScarred = 34,
        aldrachiReaver = 35
    },
    DRUID = {
        druidOfTheClaw = 21,
        wildstalker = 22,
        keeperOfTheGrove = 23,
        elunesChosen = 24
    },
    EVOKER = {
        scalecommander = 36,
        flameshaper = 37,
        chronowarden = 38
    },
    HUNTER = {
        sentinel = 42,
        packLeader = 43,
        darkRanger = 44
    },
    MAGE = {
        sunfury = 39,
        spellslinger = 40,
        frostfire = 41
    },
    MONK = {
        conduitOfTheCelestials = 64,
        shadopan = 65,
        masterOfHarmony = 66
    },
    PALADIN = {
        templar = 48,
        lightsmith = 49,
        heraldOfTheSun = 50
    },
    PRIEST = {
        voidweaver = 18,
        archon = 19,
        oracle = 20
    },
    ROGUE = {
        trickster = 51,
        fatebound = 52,
        deathstalker = 53
    },
    SHAMAN = {
        totemic = 54,
        stormbringer = 55,
        farseer = 56
    },
    WARLOCK = {
        soulHarvester = 57,
        hellcaller = 58,
        diabolist = 59
    },
    WARRIOR = {
        slayer = 60,
        mountainThane = 61,
        colossus = 62
    }
}
