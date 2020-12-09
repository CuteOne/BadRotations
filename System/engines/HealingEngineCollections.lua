novaEngineTables = { }
-- This is for the Dispel Check, all Debuffs we want dispelled go here
-- valid arguments: stacks = num range = num
novaEngineTables.DispelID = {
	[143579] = {stacks = 3 }, -- Immersius
	[143434] = {stacks = 3 }, -- Fallen Protectors
	[144514] = {stacks = 0 }, -- Norushen
	[144351] = {stacks = 0 }, -- Sha of Pride
	[146902] = {stacks = 0 }, -- Galakras(Korga Poisons)
	[143432] = {stacks = 0 }, -- General Nazgrim
	[142913] = {stacks = 0, range = 10}, -- Malkorok(Displaced Energy)
	[115181] = {stacks = 0 }, -- Spoils of Pandaria(Breath of Fire)
	[143791] = {stacks = 0 }, -- Thok(Corrosive Blood)
	[145206] = {stacks = 0 }, -- Aqua Bomb(Proving Grounds)
	[138733] = {stacks = 0 , range = 8}, -- Jin'rokh the Breaker (Ionization)
	-- Ko'ragh
	[142913] = {stacks = 0, range = 5}, -- http://www.wowhead.com/spell=162185/expel-magic-fire
	[185066] = {stacks = 0}, -- Mark of Necromancer red level
	-- Xavius
	[206651] = {stacks = 3}, -- Xavius Darkening Soul
	[209158] = {stacks = 3}, -- Xavius Blackening Soul
	-- Belac
	[233983] = {stacks = 0, range = 8}, -- Echoing Anguish http://www.wowhead.com/spell=233983/echoing-anguish
	-- Antoran High Command (Antorus)
	[257974] = {stacks = 9}, -- http://www.wowhead.com/spell=257974/chaos-pulse
	-- Imonar the Soulhunter
	[247552] = {stacks = 0, range = 15}, -- http://www.wowhead.com/spell=247552/sleep-canister
	-- Jadefire Masters
	[286988] = {stacks = 0}, -- https://www.wowhead.com/spell=286988/searing-embers
	-- Opulence
	[284470] = {stacks = 0}, -- https://www.wowhead.com/spell=284470/hex-of-lethargy
	-- Conclave of the Chosen
	--[282135] = {stacks = 0, range = 12}, -- https://www.wowhead.com/spell=282135/crawling-hex
	[285879] = {stacks = 0}, --https://www.wowhead.com/spell=285879/mind-wipe
	-- Mekkatorque
	[287167] = {stacks = 0}, -- https://www.wowhead.com/spell=287167/discombobulation
	-- Jaina Proudmoore
	[287626] = {stacks = 0}, -- https://www.wowhead.com/spell=287626/grasp-of-frost
	-- Siege of Boralis
	[275014] = { stacks = 0, range = 7 }, --https://www.wowhead.com/spell=274991/putrid-waters
	[257168] = { stacks = 0 }, --https://www.wowhead.com/spell=257168/cursed-slash
	[272571] = { stacks = 0 }, --https://www.wowhead.com/spell=272571/choking-waters
	[275835] = { stacks = 0 }, --https://www.wowhead.com/spell=275835/stinging-venom-coating
	-- Waycrest Manor
	[261440] = { stacks = 0, range = 8 }, --https://www.wowhead.com/spell=261439/virulent-pathogen
	[261439] = { stacks = 0, range = 8 }, --https://www.wowhead.com/spell=261439/virulent-pathogen
	[264378] = { stacks = 0 }, --https://www.wowhead.com/spell=264378/fragment-soul
	[263891] = { stacks = 0 }, --https://www.wowhead.com/spell=263891/grasping-thorns
	[265352] = { stacks = 0 }, --https://www.wowhead.com/spell=265352/toad-blight
	-- Temple of Sethraliss
	[268008] = { stacks = 0 }, --https://www.wowhead.com/spell=268008/snake-charm
	[268013] = { stacks = 0 }, --https://www.wowhead.com/spell=268013/flame-shock
	[268013] = { stacks = 0 }, --https://www.wowhead.com/spell=268013/flame-shock
	[273563] = { stacks = 0 }, --https://www.wowhead.com/spell=273563/neurotoxin
	[272657] = { stacks = 0 }, --https://www.wowhead.com/spell=272657/noxious-breath
	[267027] = { stacks = 0 }, --https://www.wowhead.com/spell=267027/cytotoxin
	[272699] = { stacks = 0 }, --https://www.wowhead.com/spell=272699/venomous-spit

	-- Tol Dagor
	[258128] = { stacks = 0 }, --https://www.wowhead.com/spell=258128/debilitating-shout
	[265889] = { stacks = 0 }, --https://www.wowhead.com/spell=265889/torch-strike
	[258864] = { stacks = 0 }, --https://www.wowhead.com/spell=258864/suppression-fire
	[257028] = { stacks = 0 }, --https://www.wowhead.com/spell=257028/fuselighter
	[257777] = { stacks = 0 }, --https://www.wowhead.com/spell=257777/crippling-shiv
	-- The Motherloads
	[280605] = { stacks = 0 }, --https://www.wowhead.com/spell=280605/brain-freeze
	[262268] = { stacks = 0 }, --https://www.wowhead.com/spell=262268/caustic-compound
	[268797] = { stacks = 0 }, --https://www.wowhead.com/spell=268797/transmute-enemy-to-goo
	[259853] = { stacks = 0 }, --https://www.wowhead.com/spell=259853/chemical-burn
	[269298] = { stacks = 0 }, --https://www.wowhead.com/spell=269298/widowmaker-toxin
	-- Atal'Dazar
	[252781] = { stacks = 0, range = 9 }, -- https://www.wowhead.com/spell=252781/unstable-hex
	[250096] = { stacks = 0 }, -- https://www.wowhead.com/spell=250096/wracking-pain
	[253562] = { stacks = 0 }, -- https://www.wowhead.com/spell=253562/wildfire
	[255582] = { stacks = 0 }, -- https://www.wowhead.com/spell=255582/molten-gold
	[255041] = { stacks = 0 }, -- https://www.wowhead.com/spell=255041/terrifying-screech
	[255371] = { stacks = 0 }, -- https://www.wowhead.com/spell=255371/terrifying-visage
	[255371] = { stacks = 2 }, --https://www.wowhead.com/spell=250372/lingering-nausea
	-- Freehold
	[257908] = { stacks = 0 }, -- https://www.wowhead.com/spell=257908/oiled-blade
	[257436] = { stacks = 0 }, -- https://www.wowhead.com/spell=257436/poisoning-strike
	-- Shrine of the storm
	[264560] = { stacks = 0 }, -- https://www.wowhead.com/spell=264560/choking-brine
	[268233] = { stacks = 0 }, -- https://www.wowhead.com/spell=268233/electrifying-shock
	[268322] = { stacks = 0 }, -- https://www.wowhead.com/spell=268322/touch-of-the-drowned
	[268391] = { stacks = 0 }, -- https://www.wowhead.com/spell=268391/mental-assault
	[268896] = { stacks = 0 }, -- https://www.wowhead.com/spell=268896/mind-rend
	[269104] = { stacks = 0 }, --https://www.wowhead.com/spell=269104/explosive-void
	-- Kings Rest
	[276031] = { stacks = 0 }, -- https://www.wowhead.com/spell=276031/pit-of-despair
	[270492] = { stacks = 0 }, -- https://www.wowhead.com/spell=270492/hex
	[270499] = { stacks = 0 }, -- https://www.wowhead.com/spell=270499/frost-shock
	[270865] = { stacks = 0 }, --https://www.wowhead.com/spell=270865/hidden-blade
	[271563] = { stacks = 0 }, -- https://www.wowhead.com/spell=271563/embalming-fluid
	[270507] = { stacks = 0 }, -- https://www.wowhead.com/spell=270507/poison-barrage
	-- Underrot
	[276031] = { stacks = 2 }, -- https://www.wowhead.com/spell=265468/withering-curse
	[266209] = { stacks = 0 }, -- https://www.wowhead.com/spell=266209/wicked-frenzy
	[272180] = { stacks = 0 }, -- https://www.wowhead.com/spell=272180/death-bolt
	[272609] = { stacks = 0 }, -- https://www.wowhead.com/spell=272609/maddening-gaze
	[269301] = { stacks = 3 }, -- https://www.wowhead.com/spell=269301/putrid-blood
	-- Eternal Palace
	[296737] = { stacks = 0, range = 10}, -- https://www.wowhead.com/spell=296737/arcane-bomb
	[295327] = { stacks = 0}, --https://www.wowhead.com/spell=295327/shattered-psyche
	-- Mechagon
	[300659] = {stacks = 0}, --https://www.wowhead.com/spell=300659/consuming-slime
	[298124] = {stacks = 0}, --https://www.wowhead.com/spell=298124/gooped
	[300414] = {stacks = 0}, --https://www.wowhead.com/spell=300414/enrage
	[294929] = {stacks = 0}, --https://www.wowhead.com/spell=294929/blazing-chomp
	[294195] = {stacks = 0}, --https://www.wowhead.com/spell=294195/arcing-zap
	[284219] = {stacks = 0}, --https://www.wowhead.com/spell=284219/shrink
	-- Trash (Ny'alotha)
	[310224] = {stacks = 10}, --https://www.wowhead.com/spell=307421/annihilation
	-- Maut
	[314993] = {stacks = 0, range = 10}, --https://www.wowhead.com/spell=314992/drain-essence
	-- Nalthor the Rimebinder (Necrotic Wake)
	[320788] = {stacks = 0, range = 18}, --https://www.wowhead.com/spell=320788/frozen-binds




}
-- List of buffs to purge
novaEngineTables.PurgeID = {
	[282098] = true, -- Gift of Wind (Conclave)
	[283619] = true, -- Wave of Light (Champion of Light)
	[289623] = true, -- Guardian Spirit (BoD Trash)
	[254974] = true, -- Gathered Souls (Atal'Dazar)
	[255579] = true, -- Gilded Claws (Atal'Dazar)
	[257397] = true, -- Healing Balm (Freehold)
	[257476] = true, -- Bestial Wrath (Freehold)
	[269935] = true, -- Bound by Shadow (King's Rest)
	[270901] = true, -- Induce Regeneration (King's Rest)
	[269976] = true, -- Ancestral Fury (King's Rest)
	[267256] = true, -- Earthwall (King's Rest)
	[267977] = true, -- Tidal Surge (Shrine of Storms)
	[276266] = true, -- Spirit's Swiftness (Shrine of Storms)
	[268030] = true, -- Mending Rapids (Shrine of Storms)
	[274210] = true, -- Reanimated Bones (Shrine of Storms)
	[268375] = true, -- Detect Thoughts (Shrine of Storms)
	[276767] = true, -- Consuming Void (Shrine of Storms)
	[256957] = true, -- Watertight Shell (Siege of Boralus)
	[275826] = true, -- Bolstering Shout (Siege of Boralus)
	[265912] = true, -- Accumulate Charge (Temple of Sethraliss)
	[272659] = true, -- Electrified Scales (Temple of Sethraliss)
	[269896] = true, -- Embryonic Vigor (Temple of Sethraliss)
	[262947] = true, -- Azerite Injection (Motherlode)
	[268709] = true, -- Earth Shield (Motherlode)
	[263215] = true, -- Tectonic Barrier (Motherlode)
	[262540] = true, -- Overcharge (Motherlode)
	[258153] = true, -- Watery Dome (Tol Dagor)
	[258133] = true, -- Darkstep (Tol Dagor)
	[257956] = true, -- Motivated (Tol Dagor)
	[265091] = true, -- Gift of G'huun (Underrot)
	[266201] = true, -- Bone Shield (Underrot)
	[265081] = true, -- Warcry (Underrot)
	[266209] = true, -- Wicked Frenzy (Underrot)
	[278567] = true, -- Soul Fetish (Waycrest Manor)
	[299584] = true, -- Coral Growth (Coral Ancients)
	[299428] = true, -- Defensive Countermeasure (Sentries)
	-- Mechagon
	[297133] = true, -- Defensive Countermeasure (Defense Bot Mk III)
}
-- List of debuffs that we should never dispell
novaEngineTables.DoNotDispellList = {
	-- Midnight (Attumen the Huntsman)
	{ id = 227404 }, -- Intangible Presence
	{ id = 285000 }, -- https://www.wowhead.com/spell=285000/kelp-wrapped
	--{ id = 284663}, --Bwonsamdi's Wrath
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
	--Battle of Dazar'alor
	[285213] = "Caress of Death", -- Caress of Death (Rastakhan)
	[288415] = "Caress of Death", -- Caress of Death (Rastakhan)
	[284663] = "Bwonsamdi's Wrath", --Bwonsamdi's Wrath (mythic conclave)
	--Crucible of storms
	[284733] = "Embrace of the Void", -- Embrace of the Void (The Restless Cabal)
	[282738] = "Embrace of the Void", -- Embrace of the Void (The Restless Cabal)
	[285652] = "Insatiable Torment", --insatiable-torment (Uu'nat)
	-- The Eternal Palace
	[292127] = "Darkest Depths", -- Blackwater Behemoth
	[297586] = "Suffering", -- Queen's Court
	-- Ny'alotha
   -- [316065] = "Corrupted Existence", -- Ra-den
   -- Castle Nathria
    [329298] = "Hungering Miasma", --Hungering Destroyer
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
	--[123456, value = 20, stacks = 1 }, -- Exemple.
	--[123456, value = -100, stacks = 3 }, -- Exemple
	-- Twin Ogrons
	[158241] = {value = 20 }, -- http://www.wowhead.com/spell=158241/blaze
	[155569] = {value = 20 }, -- http://www.wowhead.com/spell=155569/injured
	[163374] = {value = 20 }, -- http://www.wowhead.com/spell=163374/arcane-volatility
	-- Imperator
	[157763] = {value = 20 }, -- http://www.wowhead.com/spell=157763/fixate
	[156225] = {value = 40 , stacks = 8 }, --http://www.wowhead.com/spell=156225/branded
	[156225] = {value = 35 , stacks = 7 }, --http://www.wowhead.com/spell=156225/branded
	[156225] = {value = 30 , stacks = 6 }, --http://www.wowhead.com/spell=156225/branded
	[156225] = {value = 25 , stacks = 5 }, --http://www.wowhead.com/spell=156225/branded
	[156225] = {value = 20 , stacks = 4 }, --http://www.wowhead.com/spell=156225/branded
	[156225] = {value = 15 , stacks = 3 }, --http://www.wowhead.com/spell=156225/branded
	[156225] = {value = 10 , stacks = 2 }, --http://www.wowhead.com/spell=156225/branded
	[156225] = {value = 5 , stacks = 1 }, --http://www.wowhead.com/spell=156225/branded
	--Kargath
	[159113] = {value = 20 }, --http://www.wowhead.com/spell=159113/impale
	[159386] = {value = 20 }, --http://www.wowhead.com/spell=159386/iron-bomb
	[159413] = {value = 30 }, --http://www.wowhead.com/spell=159413/mauling-brew
	--Brackenspore
	[163241] = {value = 40 , stacks = 4 }, --http://www.wowhead.com/spell=163241/rot
	[163241] = {value = 30 , stacks = 3 }, --http://www.wowhead.com/spell=163241/rot
	[163241] = {value = 20 , stacks = 2 }, --http://www.wowhead.com/spell=163241/rot
	[163241] = {value = 20 ,stacks = 1 }, --http://www.wowhead.com/spell=163241/rot
	-- Gruul
	[155506] = {value = 30 }, --http://www.wowhead.com/spell=155506/petrified
	[173192] = {value = 30 }, --http://www.wowhead.com/spell=173192/cave-in
	[145263] = {value = 20 }, -- Proving Grounds Healer Debuff.
	-- Blast Furnace
	[155196] = {value = 30 }, --http://www.wowhead.com/spell=155196/fixate
	[155242] = {value = 30 }, --http://www.wowhead.com/spell=155242/heat
	[156934] = {value = 15 }, --http://www.wowhead.com/spell=156934/rupture
	[176121] = {value = 15 }, --http://www.wowhead.com/spell=176121/volatile-fire
	--Flame Bender
	[155277] = {value = 30 }, --http://www.wowhead.com/spell=155277/blazing-radiance
	--BeastMaster
	[162283] = {value = 30 }, --http://www.wowhead.com/spell=162283/rend-and-tear
	-- Iron Maidens
	[158078] = {value = 30 }, --http://www.wowhead.com/spell=158078/blood-ritual
	[156112] = {value = 30 }, --http://www.wowhead.com/spell=156112/convulsive-shadows
	[158315] = {value = 15 }, --http://www.wowhead.com/spell=158315/dark-hunt
	--Trains
	[165195] = {value = 30 }, --http://www.wowhead.com/spell=165195/prototype-pulse-grenade
	-- Tyrant Velhari
	[180116] = {value = 30 }, --http://www.wowhead.com/spell=180166/touch-of-harm
	-- Chronomatic Anomaly (M)
	[206609] = {value = 30 }, --http://www.wowhead.com/spell=206609/time-release
	-- Gul'dan
	[221891] = {value = 30 }, --http://www.wowhead.com/spell=221891/soul-siphon
	-- Sisters of the Moon (ToS)
	[233263] = {value = 30 }, --http://www.wowhead.com/spell=233263/embrace-of-the-eclipse
	-- Fallen Avater (ToS)
	[240728] = {value = -100, stacks = 8 }, --http://www.wowhead.com/spell=240728/tainted-essence
	-- Rastakhan (BoD)
	[284781] = {value = 50}, --https://www.wowhead.com/spell=284781/grievous-axe
	[286779] = {value = 30}, --https://www.wowhead.com/spell=286779/focused-demise

	[260741] = {value = 30}, --https://www.wowhead.com/spell=260741/jagged-nettles
	-- King's Rest
	[266231] = {value = 30}, --https://www.wowhead.com/spell=266231/severing-axe
	[265773] = {value = 30}, --https://www.wowhead.com/spell=265773/spit-gold
	-- Ra-Den (Ny'alotha)
	[306184] = {value = 30}, --https://www.wowhead.com/spell=306184/unleashed-void
	[316065] = {value = -70}, --https://www.wowhead.com/spell=316065/corrupted-existence


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
	["Primal Earth Elemental"] = {role = "TANK", class = "Warrior"}
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
