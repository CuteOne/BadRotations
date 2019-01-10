novaEngineTables = { }
-- This is for the Dispel Check, all Debuffs we want dispelled go here
-- valid arguments: stacks = num range = num
novaEngineTables.DispelID = {
	{ id = 143579, stacks = 3 }, -- Immersius
	{ id = 143434, stacks = 3 }, -- Fallen Protectors
	{ id = 144514, stacks = 0 }, -- Norushen
	{ id = 144351, stacks = 0 }, -- Sha of Pride
	{ id = 146902, stacks = 0 }, -- Galakras(Korga Poisons)
	{ id = 143432, stacks = 0 }, -- General Nazgrim
	{ id = 142913, stacks = 0, range = 10}, -- Malkorok(Displaced Energy)
	{ id = 115181, stacks = 0 }, -- Spoils of Pandaria(Breath of Fire)
	{ id = 143791, stacks = 0 }, -- Thok(Corrosive Blood)
	{ id = 145206, stacks = 0 }, -- Aqua Bomb(Proving Grounds)
	-- Ko'ragh
	{ id = 142913, stacks = 0, range = 5}, -- http://www.wowhead.com/spell=162185/expel-magic-fire
	{ id = 185066, stacks = 0}, -- Mark of Necromancer red level
	-- Xavius
	{ id = 206651, stacks = 3}, -- Xavius Darkening Soul
	{ id = 209158, stacks = 3}, -- Xavius Blackening Soul
	-- Belac
	{ id = 233983, stacks = 0, range = 8}, -- Echoing Anguish http://www.wowhead.com/spell=233983/echoing-anguish
	-- Antoran High Command (Antorus)
	{ id = 257974, stacks = 9}, -- http://www.wowhead.com/spell=257974/chaos-pulse
	-- Imonar the Soulhunter
	{ id = 247552, stacks = 0, range = 15} -- http://www.wowhead.com/spell=247552/sleep-canister
}
-- List of debuffs that we should never dispell
novaEngineTables.DoNotDispellList = {
	-- Midnight (Attumen the Huntsman)
	{ id = 227404 }, -- Intangible Presence
}
-- This is where we house the Debuffs that are bad for our users, and should not be healed when they have it
novaEngineTables.BadDebuffList= {
	[104451] = "Ice Tomb",
	[76577] = "Smoke Bomb",
	[121949] = "Parasistic Growth",
	[122784] = "Reshape Life",
	[122370] = "Reshape Life 2",
	[123184] = "Dissonance Field",
	[123255] = "Dissonance Field 2",
	[123596] = "Dissonance Field 3",
	[128353] = "Dissonance Field 4",
	[145832] = "Empowered Touch of Y'Shaarj", --(mind control garrosh)
	[145171] = "Empowered Touch of Y'Shaarj", --(mind control garrosh)
	[145065] = "Empowered Touch of Y'Shaarj", --(mind control garrosh)
	[145071] = "Empowered Touch of Y'Shaarj", --(mind control garrosh)
	--Brackenspore
	[159220] = "Necrotic Breath",  --A debuff that removes 99% of healing so no point healing them
	[184587] = "Touch of Mortality", --  Prevents all healing for 9 seconds
	[236550] = "Discorporate", --Decreases all Healing by 75%
	[243961] = "Misery", --Immune to all healing effects.
	[274148] = "Taint", --Avatar of Sethraliss Debuff
}
-- list of special units we want to heal, these npc will go directly into healing engine(Special Heal must be checked)
novaEngineTables.SpecialHealUnitList = {
	[71604] = "Contaminated Puddle",
	[6459] = "Boss#3 SoO",
	[6460] = "Boss#3 SoO",
	[6464] = "Boss#3 SoO",
	[90388] ="Tortured Essence",
	[133392] = "Avatar of Sethraliss"
};
-- set dot that need to be healed to max(needs to be topped) to very low values so that engine will prioritize them
-- the value used here will be substract from current health, we could use negative values to add back health instead
-- these are checked debuff on allies ie br.friend[i].unit wear 145263 and its hp is 70, engine will use 50 instead
novaEngineTables.SpecificHPDebuffs = {
	--{ debuff = 123456, value = 20, stacks = 1 }, -- Exemple.
	--{ debuff = 123456, value = -100, stacks = 3 }, -- Exemple
	-- Twin Ogrons
	{ debuff = 158241 , value = 20 }, -- http://www.wowhead.com/spell=158241/blaze
	{ debuff = 155569 , value = 20 }, -- http://www.wowhead.com/spell=155569/injured
	{ debuff = 163374 , value = 20 }, -- http://www.wowhead.com/spell=163374/arcane-volatility
	-- Imperator
	{ debuff = 157763 , value = 20 }, -- http://www.wowhead.com/spell=157763/fixate
	{ debuff = 156225 , value = 40 , stacks = 8 }, --http://www.wowhead.com/spell=156225/branded
	{ debuff = 156225 , value = 35 , stacks = 7 }, --http://www.wowhead.com/spell=156225/branded
	{ debuff = 156225 , value = 30 , stacks = 6 }, --http://www.wowhead.com/spell=156225/branded
	{ debuff = 156225 , value = 25 , stacks = 5 }, --http://www.wowhead.com/spell=156225/branded
	{ debuff = 156225 , value = 20 , stacks = 4 }, --http://www.wowhead.com/spell=156225/branded
	{ debuff = 156225 , value = 15 , stacks = 3 }, --http://www.wowhead.com/spell=156225/branded
	{ debuff = 156225 , value = 10 , stacks = 2 }, --http://www.wowhead.com/spell=156225/branded
	{ debuff = 156225 , value = 5  , stacks = 1 }, --http://www.wowhead.com/spell=156225/branded
	--Kargath
	{ debuff = 159113 , value = 20 }, --http://www.wowhead.com/spell=159113/impale
	{ debuff = 159386 , value = 20 }, --http://www.wowhead.com/spell=159386/iron-bomb
	{ debuff = 159413 , value = 30 }, --http://www.wowhead.com/spell=159413/mauling-brew
	--Brackenspore
	{ debuff = 163241 , value = 40 , stacks = 4 }, --http://www.wowhead.com/spell=163241/rot
	{ debuff = 163241 , value = 30 , stacks = 3 }, --http://www.wowhead.com/spell=163241/rot
	{ debuff = 163241 , value = 20 , stacks = 2 }, --http://www.wowhead.com/spell=163241/rot
	{ debuff = 163241 , value = 20 , stacks = 1 }, --http://www.wowhead.com/spell=163241/rot
	-- Gruul
	{ debuff = 155506 , value = 30 }, --http://www.wowhead.com/spell=155506/petrified
	{ debuff = 173192 , value = 30 }, --http://www.wowhead.com/spell=173192/cave-in
	{ debuff = 145263 , value = 20 }, -- Proving Grounds Healer Debuff.
	-- Blast Furnace
	{ debuff = 155196 , value = 30 }, --http://www.wowhead.com/spell=155196/fixate
	{ debuff = 155242 , value = 30 }, --http://www.wowhead.com/spell=155242/heat
	{ debuff = 156934 , value = 15 }, --http://www.wowhead.com/spell=156934/rupture
	{ debuff = 176121 , value = 15 }, --http://www.wowhead.com/spell=176121/volatile-fire
	--Flame Bender
	{ debuff = 155277 , value = 30 }, --http://www.wowhead.com/spell=155277/blazing-radiance
	--BeastMaster
	{ debuff = 162283 , value = 30 }, --http://www.wowhead.com/spell=162283/rend-and-tear
	-- Iron Maidens
	{ debuff = 158078 , value = 30 }, --http://www.wowhead.com/spell=158078/blood-ritual
	{ debuff = 156112 , value = 30 }, --http://www.wowhead.com/spell=156112/convulsive-shadows
	{ debuff = 158315 , value = 15 }, --http://www.wowhead.com/spell=158315/dark-hunt
	--Trains
	{ debuff = 165195 , value = 30 }, --http://www.wowhead.com/spell=165195/prototype-pulse-grenade
	-- Tyrant Velhari
	{ debuff = 180116 , value = 30 }, --http://www.wowhead.com/spell=180166/touch-of-harm
	-- Chronomatic Anomaly (M)
	{ debuff = 206609 , value = 30 }, --http://www.wowhead.com/spell=206609/time-release
	-- Gul'dan 
	{ debuff = 221891 , value = 30 }, --http://www.wowhead.com/spell=221891/soul-siphon
	-- Sisters of the Moon (ToS)
	--{ debuff = 233263 , value = 30 }, --http://www.wowhead.com/spell=233263/embrace-of-the-eclipse
	-- Fallen Avater (ToS)
	{ debuff = 240728 , value = -100, stacks = 8 }, --http://www.wowhead.com/spell=240728/tainted-essence
}
-- this table will assign role to any unit wearing the unit name
novaEngineTables.roleTable = {
	["Oto the Protector"] = { role = "TANK", class = "Warrior" }, -- proving grounds tank
	["Sooli the Survivalist"] = { role = "DPS", class = "Hunter" }, -- proving grounds dps
	["Ki the Assassin"] = { role = "DPS", class = "Rogue" }, -- proving grounds dps
	["Kavan the Arcanist"] = { role = "DPS", class = "Mage" }, -- proving grounds dps
	["Commander Jarod Shadowsong"] = { role = "TANK", class = "Warrior"},
	["Granny Marl"] = {role = "DPS", class = "Hunter"},
	["Callie Carrington"] = {role = "DPS", class = "Rogue"},
}
-- special targets to include when we want to heal npcs
novaEngineTables.SavedSpecialTargets = {
	["target"] = nil,
	["mouseover"] = nil,
	["focus"] = nil,
}
-- ToDo: we need a powerful DoT handler to handle stuff such as hand of purity/heal over time
novaEngineTables.BadlyDeBuffed = {
	--High Maul
		--Kargath
		159386,    --http://www.wowhead.com/spell=159386/iron-bomb
		--Twin Ogron
		158241,    --http://www.wowhead.com/spell=158241/blaze
		155569,    --http://www.wowhead.com/spell=155569/injured
		163374,    --http://www.wowhead.com/spell=163374/arcane-volatility
		-- Ko'ragh
		161442,     --http://www.wowhead.com/spell=161242/caustic-energy
		--Imperator Margok
		157763,    --http://www.wowhead.com/spell=157763/fixate
	--Black Rock Foundry
		--Iron Maidens
		156112, --http://www.wowhead.com/spell=156112/convulsive-shadows
		158315, --http://www.wowhead.com/spell=158315/dark-hunt
		--Trains
		165195,--http://www.wowhead.com/spell=165195/prototype-pulse-grenade
		--Engine of Souls
		235933, -- Spear of Anguish debuff
		238442, -- Spear of Anguish debuff
		242796, -- Spear of Anguish debuff
		236135, -- Wither (Soul Queen Dejahna of Desolate Host encounter)

}
-- Table for NPCs we do not want to add to table (eg. Hymdal/Odyn after they become friendly)
novaEngineTables.skipNPC = {
        "95676", -- Odyn
        "94960", -- Hynmdall
        "100482", -- Senegos
};
