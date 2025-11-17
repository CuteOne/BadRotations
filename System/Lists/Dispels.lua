local _, br = ...
if br.lists == nil then
	br.lists = {}
end
-- Crowd Control Units = list of units to stun, either always or udner certain condition such as having a buff or wirldwinding etc
br.lists.dispell = {
	--[[===========================]]
	--[[  CLASSIC / VANILLA (60)   ]]
	--[[===========================]]

	-- Stratholme
	[16798] = "Magic", -- Fear (Hearthsinger Forresten)
	[17405] = "Magic", -- Domination mind control

	-- Scholomance (Vanilla)
	[16097] = "Magic", -- Hex
	[16799] = "Magic", -- Mind Flay

	-- Blackrock Depths
	[15063] = "Magic", -- Mind Control
	[14875] = "Magic", -- Curse of Tongues

	-- Upper Blackrock Spire
	[15284] = "Enrage", -- Mortal Strike (bleed/enrage combo)
	[15732] = "Magic", -- Conflagration DoT

	-- Sunken Temple
	[12480] = "Magic", -- Heal
	[12542] = "Magic", -- Fear

	-- Maraudon
	[21869] = "Magic", -- Flame Shock / Fear
	[21909] = "Magic", -- Toxic Volley

	-- Zul'Farrak
	[11641] = "Enrage", -- Hex
	[11642] = "Magic", -- Heal

	-- Uldaman
	[6524] = "Magic", -- Ground Tremor

	-- Molten Core
	[19136] = "Magic", -- Stormbolt (Garr adds)

	-- Blackwing Lair
	[23339] = "Magic", -- Wing Buffet (Broodlord)
	[24573] = "Enrage", -- Mortal Strike (Death Talon Captain)

	-- Ahn'Qiraj
	[26580] = "Magic", -- Fear (Twin Emperors)

	--[[===========================]]
	--[[  BURNING CRUSADE (70)     ]]
	--[[===========================]]

	-- Shadow Labyrinth
	[33676] = "Magic", -- Incite Chaos mind control
	[33787] = "Magic", -- Whirlwind effect

	-- Shattered Halls
	[30636] = "Magic", -- Rend (bleed)
	[31901] = "Magic", -- Shield Wall

	-- Botanica
	[34639] = "Magic", -- Unstable Chemicals
	[34649] = "Magic", -- Bloodwarder Heal

	-- Magisters' Terrace
	[46757] = "Magic", -- Glyph of Power
	[46035] = "Magic", -- Frostbolt slow

	-- Mana-Tombs
	[32860] = "Magic", -- Auchenai Soulpriest reverse healing
	[32361] = "Magic", -- Inhibit Magic

	-- Auchenai Crypts
	[32424] = "Magic", -- Avatar of the Martyred

	-- Sethekk Halls
	[32690] = "Magic", -- Avian Ripper bleed
	[32129] = "Magic", -- Arcane Lightning

	-- Black Morass
	[31473] = "Magic", -- Magnetic Pull
	[33860] = "Magic", -- Heal (from Chronomancer)

	-- Mechanar
	[35159] = "Magic", -- Reflective Damage Shield

	-- Blood Furnace
	[30923] = "Magic", -- Domination mind control

	-- Slave Pens
	[31946] = "Magic", -- Corrupted Nova

	-- Hellfire Ramparts
	[30474] = "Magic", -- Burning Maul

	-- Karazhan
	[29321] = "Magic", -- Fear (Moroes adds)

	-- Black Temple
	[41338] = "Magic", -- Love Tap (Sister of Pleasure)

	--[[===========================]]
	--[[  WRATH OF THE LICH KING (80) ]]
	--[[===========================]]

	-- Violet Hold
	[58471] = "Magic", -- Brutal Strike DoT

	-- Halls of Lightning
	[52719] = "Magic", -- Whirlwind effect
	[52770] = "Magic", -- Defensive Stance buff

	-- Culling of Stratholme
	[52854] = "Magic", -- Banish
	[52942] = "Magic", -- Temporal Rift slow

	-- Pit of Saron
	[69579] = "Magic", -- Puncture Wound bleed
	[69603] = "Magic", -- Banish

	-- Halls of Reflection
	[72333] = "Magic", -- Deadly Poison
	[72198] = "Magic", -- Remorseless Winter

	-- Naxxramas
	[28732] = "Magic", -- Curse of the Plaguebringer
	[56153] = "Magic", -- Guardian Aura (Ahn'kahet) - Makes mobs invulnerable

	-- Ulduar
	[64320] = "Magic", -- Devouring Flame

	-- Icecrown Citadel
	[70447] = "Magic", -- Mana Barrier (Lady Deathwhisper)
	[72257] = "Magic", -- Mark of the Fallen Champion

	--[[===========================]]
	--[[  CATACLYSM (85)           ]]
	--[[===========================]]

	-- Throne of the Tides
	[76622] = "Magic", -- Poisoned Spear
	[76047] = "Magic", -- Water Shield

	-- Vortex Pinnacle
	[88194] = "Magic", -- Wind Blast
	[87761] = "Magic", -- Cyclone Shield

	-- Stonecore
	[81008] = "Magic", -- Quake
	[81637] = "Magic", -- Spinning Slash bleed

	-- Grim Batol
	[76711] = "Magic", -- Deceitful Blast
	[76121] = "Magic", -- Warped Twilight

	-- Zul'Aman (Heroic)
	[43140] = "Magic", -- Flame Breath
	[42471] = "Magic", -- Electrical Storm

	-- Zul'Gurub (Heroic)
	[96689] = "Magic", -- Voodoo Bolt
	[96776] = "Magic", -- Pursuit DoT

	-- Hour of Twilight
	[103633] = "Magic", -- Backstab poison
	[103641] = "Magic", -- Shadow Bolt

	-- Firelands
	[99516] = "Magic", -- Blazing Power
	[99432] = "Magic", -- Fieroblast

	-- Dragon Soul
	[105479] = "Magic", -- Searing Plasma

	--[[===========================]]
	--[[  MISTS OF PANDARIA CLASSIC ]]
	--[[===========================]]

	-- Temple of the Jade Serpent
	[106797] = "Magic", -- Hydrolance (Corrupt Living Water)

	-- Stormstout Brewery
	[114646] = "Magic", -- Haunting Gaze (Haunting Sha)
	[106563] = "Magic", -- Carbonation (Ook-Ook)

	-- Mogu'shan Palace
	[118903] = "Magic", -- Undying Shadows
	[119626] = "Enrage", -- Reckless Inspiration (Gekkan)

	-- Shado-Pan Monastery
	[106872] = "Magic", -- Smoke Bomb (silence)
	[115002] = "Magic", -- Rising Hate

	-- Gate of the Setting Sun
	[115458] = "Enrage", -- Adrenaline Rush
	[119857] = "Magic", -- Poisoned Mind

	-- Siege of Niuzao Temple
	[119365] = "Enrage", -- Enraged (Sik'thik mobs)

	-- Scarlet Halls
	[113641] = "Magic", -- Burning Hands

	-- Scarlet Monastery
	[115140] = "Enrage", -- Blazing Fists

	-- Scholomance
	[113134] = "Magic", -- Explosive Pain
	[111631] = "Magic", -- Fixate (Books)

	-- Mogu'shan Vaults (Raid)
	[116829] = "Magic", -- Solid Stone

	-- Heart of Fear (Raid)
	[123474] = "Enrage", -- Overwhelming Assault

	-- Throne of Thunder (Raid)
	[136954] = "Enrage", -- Dino Form
	[134378] = "Magic", -- Fixate (Ji-Kun)

	-- Siege of Orgrimmar (Raid)
	[143593] = "Magic", -- Borer Drill
	[145071] = "Magic", -- Genetic Alteration

	--[[===========================]]
	--[[  LATER EXPANSIONS (KEEP)  ]]
	--[[===========================]]

	--[164257] = "Enrage", -- ogres gorgrond
	-- Auchindon
	[160312] = "Magic",-- Void Shell
	-- UBRS
	[153909] = "Enrage",-- Frenzy
	[161203] = "Magic",-- Rejuvenating Serum
	[81173] = "Enrage",-- Frenzy
	--61574,-- Banner of the horde (dummy buff just to test)
	-- lib dispel
	[8599] = "Enrage",[12880] = "Enrage",[15061] = "Enrage",[15716] = "Enrage",[18499] = "Enrage",
	[18501] = "Enrage",[19451] = "Enrage",[19812] = "Enrage",[22428] = "Enrage",[23128] = "Enrage",
	[23257] = "Enrage",[23342] = "Enrage",[24689] = "Enrage",[26041] = "Enrage",[26051] = "Enrage",
	[28371] = "Enrage",[30485] = "Enrage",[31540] = "Enrage",[31915] = "Enrage",[32714] = "Enrage",
	[33958] = "Enrage",[34670] = "Enrage",[37605] = "Enrage",[37648] = "Enrage",[37975] = "Enrage",
	[38046] = "Enrage",[38166] = "Enrage",[38664] = "Enrage",[39031] = "Enrage",[39575] = "Enrage",
	[40076] = "Enrage",[41254] = "Enrage",[41447] = "Enrage",[42705] = "Enrage",[42745] = "Enrage",
	[43139] = "Enrage",[47399] = "Enrage",[48138] = "Enrage",[48142] = "Enrage",[48193] = "Enrage",
	[50420] = "Enrage",[51513] = "Enrage",[52262] = "Enrage",[52470] = "Enrage",[54427] = "Enrage",
	[55285] = "Enrage",[56646] = "Enrage",[57733] = "Enrage",[58942] = "Enrage",[59465] = "Enrage",
	[59697] = "Enrage",[59707] = "Enrage",[59828] = "Enrage",[60075] = "Enrage",[61369] = "Enrage",
	[63227] = "Enrage",[66092] = "Enrage",[68541] = "Enrage",[70371] = "Enrage",[72143] = "Enrage",
	[75998] = "Enrage",[76100] = "Enrage",[76862] = "Enrage",[77238] = "Enrage",[78722] = "Enrage",
	[78943] = "Enrage",[80084] = "Enrage",[80467] = "Enrage",[86736] = "Enrage",[102134] = "Enrage",
	[102989] = "Enrage",[106925] = "Enrage",[108169] = "Enrage",[109889] = "Enrage",[111220] = "Enrage",
	[115430] = "Enrage",[117837] = "Enrage",[119629] = "Enrage",[123936] = "Enrage",[124019] = "Enrage",
	[124309] = "Enrage",[126370] = "Enrage",[127823] = "Enrage",[127955] = "Enrage",[128231] = "Enrage",
	[129016] = "Enrage",[129874] = "Enrage",[130196] = "Enrage",[130202] = "Enrage",[131150] = "Enrage",
	[135524] = "Enrage",[135548] = "Enrage",[142760] = "Enrage",[148295] = "Enrage",[151553] = "Enrage",
	[154017] = "Enrage",[155620] = "Enrage",[164324] = "Enrage",[164835] = "Enrage",[175743] = "Enrage",
	[144351] = "Magic",[333227] = "Undying Rage",[326450] = "Loyal Beasts",[320012] = "Unholy Frenzy",
	[333241] = "Raging Tantrum"
}