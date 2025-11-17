local _, br = ...
if br.lists == nil then
	br.lists = {}
end
br.lists.los = {
	--[[===========================]]
	--[[  CLASSIC / VANILLA (60)   ]]
	--[[===========================]]
	
	-- Stratholme
	[10811] = true, -- Archimondethe Dreadlord (elevated platform)
	[10558] = true, -- Hearthsinger Forresten (zigzag corridors)
	
	-- Scholomance (Vanilla)
	[10506] = true, -- Kirtonos the Herald (corner room)
	[10433] = true, -- Marduk Blackpool (pillars)
	
	-- Blackrock Depths
	[9019] = true, -- Emperor Dagran Thaurissan (throne elevation)
	[9025] = true, -- Lord Roccor (pillar room)
	
	-- Upper Blackrock Spire
	[10363] = true, -- General Drakkisath (elevated throne)
	[10429] = true, -- Warchief Rend Blackhand (ledges)
	
	-- Sunken Temple
	[5721] = true, -- Dreamscythe (dragon pit)
	[8443] = true, -- Avatar of Hakkar (room corners)
	
	-- Maraudon
	[13282] = true, -- Noxxion (gas clouds block LoS)
	[12201] = true, -- Princess Theradras (waterfall cave)
	
	-- Zul'Farrak
	[7267] = true, -- Chief Ukorz Sandscalp (pyramid top)
	[7273] = true, -- Gahz'rilla (water pool)
	
	-- Uldaman
	[6906] = true, -- Baelog (dwarf trio room)
	[2748] = true, -- Archaedas (titan vault, pillars)
	
	-- Molten Core
	[11982] = true, -- Magmadar (pillars in room)
	
	-- Blackwing Lair
	[14020] = true, -- Chromaggus (winding tunnel)
	[11583] = true, -- Nefarian (elevated platform)
	
	-- Ahn'Qiraj 40
	[15263] = true, -- Prophet Skeram (clones teleport)
	[15510] = true, -- Fankriss the Unyielding (tunnel segments)
	
	--[[===========================]]
	--[[  BURNING CRUSADE (70)     ]]
	--[[===========================]]
	
	-- Shadow Labyrinth
	[18667] = true, -- Blackheart the Inciter (circular room)
	[18708] = true, -- Murmur (sound waves around pillars)
	
	-- Shattered Halls
	[17711] = true, -- Warbringer O'mrogg (two-headed, moves erratically)
	
	-- Botanica
	[17976] = true, -- Commander Sarannis (tree platform)
	[18422] = true, -- High Botanist Freywinn (garden maze)
	
	-- Magisters' Terrace
	[24723] = true, -- Selin Fireheart (crystal pillars)
	[24560] = true, -- Priestess Delrissa (chaotic arena)
	
	-- Mana-Tombs
	[18341] = true, -- Pandemonius (void zones)
	[22930] = true, -- Yor (ethereal platform)
	
	-- Auchenai Crypts
	[18373] = true, -- Exarch Maladaar (sarcophagus room)
	
	-- Sethekk Halls
	[18473] = true, -- Talon King Ikiss (bird room, blinks)
	[23035] = true, -- Anzu (Raven God, summon boss)
	
	-- Old Hillsbrad Foothills
	[17848] = true, -- Lieutenant Drake (town buildings)
	[18096] = true, -- Epoch Hunter (caves)
	
	-- Black Morass
	[17879] = true, -- Chrono Lord Deja (portal room)
	[17881] = true, -- Aeonus (shield generators)
	
	-- Mechanar
	[19219] = true, -- Mechano-Lord Capacitus (machinery)
	[19221] = true, -- Nethermancer Sepethrea (elevated platforms)
	
	-- Blood Furnace
	[17381] = true, -- The Maker (torture chamber)
	[17380] = true, -- Broggok (poison cloud room)
	
	-- Hellfire Ramparts
	[17306] = true, -- Watchkeeper Gargolmar (gauntlet)
	[17537] = true, -- Vazruden the Herald (flying wyvern)
	
	-- Slave Pens
	[17941] = true, -- Mennu the Betrayer (bog water)
	[17991] = true, -- Rokmar the Crackler (bog lord)
	
	-- Underbog
	[17770] = true, -- Hungarfen (mushroom forest)
	[17826] = true, -- Swamplord Musel'ek (pet mechanics)
	
	-- Steamvault
	[17797] = true, -- Hydromancer Thespia (water rises)
	[17882] = true, -- Warlord Kalithresh (water mechanics)
	
	-- Karazhan
	[15688] = true, -- Prince Malchezaar (balcony height issues)
	
	-- Black Temple
	[22841] = true, -- Shade of Akama (phasing issues)
	[22917] = true, -- Illidan Stormrage (elevation changes)
	
	--[[===========================]]
	--[[  WRATH OF THE LICH KING (80) ]]
	--[[===========================]]
	
	-- Utgarde Keep
	[23953] = true, -- Prince Keleseth (frost tomb pillars)
	[24201] = true, -- Skarvald and Dalronn (two bosses, elevation)
	
	-- Nexus
	[26731] = true, -- Grand Magus Telestra (splits, teleports)
	[26723] = true, -- Keristrasza (crystals in room)
	
	-- Azjol-Nerub
	[28684] = true, -- Krik'thir the Gatewatcher (web bridges)
	[29120] = true, -- Anub'arak (spikes and ground phases)
	
	-- Drak'Tharon Keep
	[26630] = true, -- Trollgore (corner room, corpse piles)
	[27483] = true, -- King Dred (raptor den corners)
	
	-- Violet Hold
	[29313] = true, -- Ichoron (water form, hard to see)
	[31134] = true, -- Cyanigosa (portal spawn)
	
	-- Gundrak
	[29305] = true, -- Slad'ran (snake form, coils)
	[29932] = true, -- Eck the Ferocious (corner room)
	
	-- Halls of Stone
	[27975] = true, -- Sjonnir the Ironshaper (central forge)
	[27977] = true, -- Tribunal of Ages event (arena with pillars)
	
	-- Halls of Lightning
	[28586] = true, -- General Bjarngrim (elevated platform)
	[28923] = true, -- Loken (circular room, lightning nova)
	
	-- Oculus
	[27447] = true, -- Mage-Lord Urom (teleports between platforms)
	[27656] = true, -- Ley-Guardian Eregos (flying ring platforms)
	
	-- Culling of Stratholme
	[26532] = true, -- Chrono-Lord Epoch (time rift phases)
	[32273] = true, -- Infinite Corruptor (gauntlet event)
	
	-- Utgarde Pinnacle
	[26687] = true, -- Gortok Palehoof (animal transformations)
	[26861] = true, -- King Ymiron (boat room, stances)
	
	-- Trial of the Champion
	[35451] = true, -- The Black Knight (mounted phases)
	[35617] = true, -- Faction Champions (arena chaos)
	
	-- Pit of Saron
	[36494] = true, -- Forgemaster Garfrost (icy corridor)
	[36658] = true, -- Scourgelord Tyrannus (mounted, flying overlook)
	
	-- Forge of Souls
	[36502] = true, -- Devourer of Souls (phantom form)
	[36497] = true, -- Bronjahm (soul fragments)
	
	-- Halls of Reflection
	[38112] = true, -- The Lich King (gauntlet chase, pillars)
	[37226] = true, -- Falric (corner spawns)
	
	-- Naxxramas
	[15990] = true, -- Kel'Thuzad (elevated throne)
	
	-- Ulduar
	[33186] = true, -- Razorscale (flying/grounded transitions)
	[33515] = true, -- Auriaya (Sanctum stairs)
	[33993] = true, -- Yogg-Saron (brain room portals)
	
	-- Icecrown Citadel
	[36855] = true, -- Lady Deathwhisper (stairs elevation)
	[37813] = true, -- Deathbringer Saurfang (platform center vs edges)
	[36789] = true, -- Valithria Dreamwalker (portals)
	[36853] = true, -- Sindragosa (blocks of ice LoS)
	[36597] = true, -- The Lich King (platform transitions)
	
	--[[===========================]]
	--[[  CATACLYSM (85)           ]]
	--[[===========================]]
	
	-- Throne of the Tides
	[40586] = true, -- Lady Naz'jar (waterspout phases)
	[40765] = true, -- Commander Ulthok (tentacles and fissures)
	[40792] = true, -- Neptulon (water elementals, tidal surge)
	
	-- Blackrock Caverns
	[39679] = true, -- Corla, Herald of Twilight (beams and pillars)
	[39625] = true, -- General Umbriss (ground ruptures)
	[39698] = true, -- Karsh Steelbender (lava pillars)
	
	-- Vortex Pinnacle
	[43878] = true, -- Grand Vizier Ertan (cyclone platforms)
	[43873] = true, -- Altairus (wind changes, elevation)
	[43875] = true, -- Asaad (static cling, triangle platforms)
	
	-- Stonecore
	[43438] = true, -- Corborus (burrow mechanic, underground)
	[43214] = true, -- Slabhide (stalactite falls, pillars)
	[43391] = true, -- High Priestess Azil (gravity wells, pillar room)
	
	-- Lost City of the Tol'vir
	[44577] = true, -- General Husam (land mines, square arena)
	[44819] = true, -- Siamat (servant of Asaad, wind phase)
	[45007] = true, -- Lockmaw (chain breakage)
	
	-- Halls of Origination
	[39428] = true, -- Temple Guardian Anhuur (snake pit drop)
	[39587] = true, -- Isiset (astral rain, sphere room)
	[39788] = true, -- Anraphet (omega stance, H-shaped room)
	[39731] = true, -- Rajh (solar winds, sun platform)
	
	-- Grim Batol
	[40177] = true, -- Forgemaster Throngus (dwarf forge, anvils)
	[40319] = true, -- Drahga Shadowburner (dragon ride)
	[40484] = true, -- Erudax (faceless spawns, shadow gale)
	
	-- Deadmines (Heroic)
	[47162] = true, -- Glubtok (lightning rod room)
	[47296] = true, -- Helix Gearbreaker (gnome bomb room)
	[47739] = true, -- "Captain" Cookie (cauldron room)
	
	-- Shadowfang Keep (Heroic)
	[46962] = true, -- Baron Ashbury (multi-level room)
	[46963] = true, -- Baron Silverlaine (staircase fights)
	[4278] = true, -- Commander Springvale (courtyard)
	
	-- Zul'Aman (Heroic)
	[23574] = true, -- Akil'zon (eagle platform, storms)
	[23576] = true, -- Nalorakk (bear/troll form, columns)
	[23578] = true, -- Jan'alai (bird boss, fire bombs)
	[24239] = true, -- Hex Lord Malacrass (spirit bolts)
	
	-- Zul'Gurub (Heroic)
	[52258] = true, -- Gri'lek (raptor boss, pursuit)
	[52271] = true, -- Hazza'rah (cobra boss, totems)
	[52269] = true, -- Renataki (tiger boss, ambush)
	[52286] = true, -- Wushoolay (panther boss, lightning)
	
	-- End Time
	[54431] = true, -- Echo of Baine (totem ring)
	[54445] = true, -- Echo of Jaina (frost pillars)
	[54544] = true, -- Echo of Sylvanas (platform jumps)
	
	-- Well of Eternity
	[54853] = true, -- Peroth'arn (invisible phases)
	[54968] = true, -- Queen Azshara (puppet strings, large arena)
	[54969] = true, -- Mannoroth (portal platform, infernal spawns)
	
	-- Hour of Twilight
	[54590] = true, -- Arcurion (ice tomb, crystals)
	[54938] = true, -- Asira Dawnslayer (smoke bomb vanish)
	[54432] = true, -- Archbishop Benedictus (holy/shadow split, pillars)
	
	-- Blackwing Descent
	[41570] = true, -- Magmaw (head up/down)
	[43296] = true, -- Chimaeron (frenzy movement)
	
	-- Bastion of Twilight
	[43735] = true, -- Elementium Monstrosity (Sinestra add, elevated spawn)
	
	-- Firelands
	[52498] = true, -- Beth'tilac (ceiling/ground transitions)
	[52530] = true, -- Alysrazor (flying rings)
	
	-- Dragon Soul
	[55294] = true, -- Ultraxion (deck transitions)
	[56427] = true, -- Warmaster Blackhorn (ship deck height)
	[53879] = true, -- Spine of Deathwing (rolling barrel mechanic)
	
	--[[===========================]]
	--[[  MISTS OF PANDARIA CLASSIC ]]
	--[[===========================]]
	
	-- Shado-Pan Monastery
	[56754] = true, -- Azure Serpent
	[59802] = true, -- Master Snowdrift (phase transitions often have LoS issues)
	
	-- Gate of the Setting Sun
	[56895] = true, -- Weak Spot - Raigonn
	[59544] = true, -- Commander Ri'mok
	
	-- Temple of the Jade Serpent
	[59051] = true, -- Corrupt Living Water (frequently behind pillars)
	
	-- Mogu'shan Palace
	[61398] = true, -- Gekkan (arena fight with LoS issues)
	
	-- Throne of Thunder (Raid)
	[69427] = true, -- Waterspout (Council of Elders, water adds)
	[68078] = true, -- Lei Shen (elevated platform)
	[68476] = true, -- Horridon (gate mechanics)
	
	-- Siege of Orgrimmar (Raid)
	[71734] = true, -- Sha of Pride (phase transitions)
	[71466] = true, -- Iron Juggernaut (drill phase LoS)
	[71865] = true, -- Garrosh Hellscream (platform transitions)
	
	--[[===========================]]
	--[[  LATER EXPANSIONS (KEEP)  ]]
	--[[===========================]]
	
	[76585] = true, -- Ragewing
	[77692] = true, -- Kromog
	[77182] = true, -- Oregorger
	-- 86644, 	-- Ore Crate from Oregorger boss
	[96759] = true, -- Helya
	[100360] = true, -- Grasping Tentacle (Helya fight)
	[100354] = true, -- Grasping Tentacle (Helya fight)
	[100362] = true, -- Grasping Tentacle (Helya fight)
	[98363] = true, -- Grasping Tentacle (Helya fight)
	[99803] = true, -- Destructor Tentacle (Helya fight)
	[99801] = true, -- Destructor Tentacle (Helya fight)
	[98696] = true, -- Illysanna Ravencrest (Black Rook Hold)
	[114900] = true, -- Grasping Tentacle (Trials of Valor)
	[114901] = true, -- Gripping Tentacle (Trials of Valor)
	[116195] = true, -- Bilewater Slime (Trials of Valor)
	[120436] = true, -- Fallen Avatar (Tomb of Sargeras)
	[116939] = true, -- Fallen Avatar (Tomb of Sargeras)
	[118462] = true, -- Soul Queen Dejahna (Tomb of Sargeras)
	[119072] = true, -- Desolate Host (Tomb of Sargeras)
	[118460] = true, -- Engine of Souls (Tomb of Sargeras)
	[122450] = true, -- Garothi Worldbreaker (Antorus the Burning Throne - Confirmed in game)
	[123371] = true, -- Garothi Worldbreaker (Antorus the Burning Throne)
	[122778] = true, -- Annihilator - Garothi Worldbreaker (Antorus the Burning Throne)
	[122773] = true, -- Decimator - Garothi Worldbreaker (Antorus the Burning Throne)
	[122578] = true, -- Kin'garoth (Antorus the Burning Throne - Confirmed in game)
	[125050] = true, -- Kin'garoth (Antorus the Burning Throne)
	[131863] = true, -- Raal the Gluttonous (Waycrest Manor)
	[134691] = true, -- Static-charged Dervish (Temple of Sethraliss)
	[137405] = true, -- Gripping Terror (Siege of Boralus)
	[140447] = true, -- Demolishing Terror (Siege of Boralus)
	[137119] = true, -- Taloc (Uldir1)
	[137578] = true, -- Blood shtorm (Uldir - Taloc's fight)
	[138959] = true, -- Coalesced Blood (Uldir - Taloc's fight)
	[138017] = true, -- Cudgel of Gore (Uldir - Taloc's fight)
	[130217] = true, -- Nazmani Weevil (Uldir - Taloc's fight)
	[140286] = true, -- Uldir Defensive Beam *Uldir)
	[138530] = true, -- Volatile Droplet (Uldir - Taloc's fight)
    [133392] = true, -- Sethraliss
	[146256] = true, -- Laminaria
	[150773] = true, -- Blackwater Behemoth Mob
	[152364] = true, -- Radiance of Azshara
	[152671] = true, -- Wekemara
	[157602] = true, -- Drest'agath - Ny'alotha
	[158343] = true, -- Organ of Corruption - Ny'alotha
	[166608] = true, -- Mueh'zala - De Other Side
    [166618] = true, -- Other Side Adds
    [169769] = true, -- Other Side Adds
    [171665] = true, -- Other Side Adds
    [168326] = true, -- Other Side Adds
	[164407] = true, -- Sludgefist - Castle Nathria
	[165759] = true, -- Kaelthas
	[181399] = true, -- Kin'tessa - Lords of Dread
	[181398] = true, -- Mal'Ganis - Lords of Dread
	[183138] = true, -- Shadowboi add in Lords of Dread
}
