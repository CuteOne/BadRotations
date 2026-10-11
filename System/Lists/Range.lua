local _, br = ...
br.lists.range = br.lists.range or {}
local range = br.lists.range

range.rangeOrMelee = {
	[250] = "melee",
	[251] = "melee",
	[252] = "melee",
	[577] = "melee",
	[581] = "melee",
	[102] = "ranged",
	[103] = "melee",
	[104] = "melee",
	[105] = "ranged",
	[253] = "ranged",
	[254] = "ranged",
	[255] = "melee",
	[62] = "ranged",
	[63] = "ranged",
	[64] = "ranged",
	[268] = "melee",
	[269] = "melee",
	[270] = "ranged",
	[65] = "ranged",
	[66] = "melee",
	[70] = "melee",
	[256] = "ranged",
	[257] = "ranged",
	[258] = "ranged",
	[259] = "melee",
	[260] = "melee",
	[261] = "melee",
	[262] = "ranged",
	[263] = "melee",
	[264] = "ranged",
	[265] = "ranged",
	[266] = "ranged",
	[267] = "ranged",
	[71] = "melee",
	[72] = "melee",
    [73] = "melee",
}

-- Spells that tell whether a unit is in melee range (C_Spell.IsSpellInRange), as spell list keys per
-- class (Druids by form): the first one the player knows is used, so each client gets its own IDs.
-- A class listed here also gets the melee-by-position check on clients without specializations.
range.meleeSpells = {
	WARRIOR     = { "pummel" },
	PALADIN     = { "crusaderStrike" },
	ROGUE       = { "kick" },
	DEATHKNIGHT = { "deathStrike" },
	MONK        = { "tigerPalm" },
	SHAMAN      = { "primalStrike", "stormstrike" },
	HUNTER      = { "raptorStrike", "wingClip", "growl" },
	DEMONHUNTER = { "chaosStrike", "soulCleave" },
	DRUID_CAT   = { "shred", "claw", "mangle" },
	DRUID_BEAR  = { "maul", "mangle" },
}
