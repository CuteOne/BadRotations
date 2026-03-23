local _, br = ...
if br.lists == nil then
    br.lists = {}
end
-- burnUnits = List of UnitID/Names we should have highest prio on.
br.lists.burnUnits = {
    --[[===========================]]
    --[[  CLASSIC / VANILLA (60)   ]]
    --[[===========================]]
    
    -- Stratholme
    [10558] = { coef = 150, name = "Hearthsinger Forresten", id = 10558 }, -- Fears party
    [10516] = { coef = 100, name = "The Unforgiven", id = 10516 }, -- High damage
    
    -- Scholomance (Vanilla)
    [10433] = { coef = 150, name = "Marduk Blackpool", id = 10433 }, -- Heals other mobs
    [10498] = { coef = 100, name = "Spectral Tutor", id = 10498 }, -- AoE damage
    
    -- Blackrock Depths
    [9041] = { coef = 100, name = "Warder Stilgiss", id = 9041 }, -- Summons adds
    [9018] = { coef = 150, name = "High Interrogator Gerstahn", id = 9018 }, -- Mind control
    
    -- Lower Blackrock Spire
    [9268] = { coef = 100, name = "Smolderweb Hatchling", id = 9268 }, -- Swarms
    [10316] = { coef = 150, name = "Blackhand Incarcerator", id = 10316 }, -- High damage
    
    -- Upper Blackrock Spire
    [10742] = { coef = 150, name = "Blackhand Elite", id = 10742 }, -- Mortal Strike
    [10814] = { coef = 100, name = "Chromatic Elite Guard", id = 10814 }, -- Shield other mobs
    
    -- Dire Maul
    [11480] = { coef = 100, name = "Arcane Aberration", id = 11480 }, -- Mana burn
    [11483] = { coef = 150, name = "Mana Remnant", id = 11483 }, -- Explodes
    
    -- Sunken Temple (Temple of Atal'Hakkar)
    [5710] = { coef = 150, name = "Jammal'an the Prophet", id = 5710 }, -- Heals boss
    [5717] = { coef = 100, name = "Mijan", id = 5717 }, -- Troll mini-boss
    
    -- Maraudon
    [13738] = { coef = 150, name = "Cavindra", id = 13738 }, -- High damage caster
    [13741] = { coef = 100, name = "Gelk", id = 13741 }, -- AoE fear
    
    -- Zul'Farrak
    [7797] = { coef = 150, name = "Ruuzlu", id = 7797 }, -- Healer troll
    [7795] = { coef = 100, name = "Hydromancer Velratha", id = 7795 }, -- Frost nova spam
    
    -- Uldaman
    [4854] = { coef = 150, name = "Grimlok", id = 4854 }, -- High damage
    [6906] = { coef = 100, name = "Baelog", id = 6906 }, -- Dwarf trio
    
    -- Molten Core
    [11662] = { coef = 100, name = "Flamewaker Priest", id = 11662 }, -- Heals other adds
    [11663] = { coef = 150, name = "Flamewaker Healer", id = 11663 }, -- Heals Lucifron/Gehennas
    
    -- Blackwing Lair
    [12053] = { coef = 200, name = "Blackwing Spellbinder", id = 12053 }, -- Greater Polymorph on tank
    [12468] = { coef = 100, name = "Death Talon Hatcher", id = 12468 }, -- Spawns whelps
    
    -- Ahn'Qiraj 40
    [15316] = { coef = 150, name = "Obsidian Nullifier", id = 15316 }, -- Mana burn on healers
    [15338] = { coef = 200, name = "Anubisath Sentinel", id = 15338 }, -- Transfers buffs to nearby allies
    [15334] = { coef = 100, name = "Vekniss Hatchling", id = 15334 }, -- Swarms tank
    
    -- Naxxramas (Classic)
    [16803] = { coef = 100, name = "Deathknight Understudy", id = 16803 }, -- Heals Instructor Razuvious
    [16146] = { coef = 150, name = "Death Knight", id = 16146 }, -- High damage
    [16244] = { coef = 200, name = "Infectious Ghoul", id = 16244 }, -- Plague zone, spreads disease
    
    --[[===========================]]
    --[[  BURNING CRUSADE (70)     ]]
    --[[===========================]]
    
    -- Shadow Labyrinth
    [18642] = { coef = 150, name = "Fel Guardhound", id = 18642 }, -- Charge stun
    [18663] = { coef = 100, name = "Maiden of Discipline", id = 18663 }, -- Whirlwind
    
    -- Shattered Halls
    [20923] = { coef = 150, name = "Blood Guard Porung", id = 20923 }, -- Shield Wall
    [17670] = { coef = 100, name = "Shattered Hand Warhound", id = 17670 }, -- Debuff bleed
    
    -- Steamvault
    [17954] = { coef = 100, name = "Coilfang Soothsayer", id = 17954 }, -- Heals
    [17721] = { coef = 150, name = "Murloc Lurker", id = 17721 }, -- Swarm
    
    -- Botanica
    [19486] = { coef = 150, name = "Sunseeker Chemist", id = 19486 }, -- Unstable Chemicals explosion
    [21579] = { coef = 100, name = "Summoned Bloodwarder Mender", id = 21579 }, -- Heals
    
    -- Arcatraz
    [20869] = { coef = 150, name = "Arcatraz Sentinel", id = 20869 }, -- High armor
    [20886] = { coef = 100, name = "Wrath-Scryer Soccothrates", id = 20886 }, -- Fear
    
    -- Magisters' Terrace
    [24683] = { coef = 200, name = "Sunblade Mage Guard", id = 24683 }, -- Glyph of Power buff
    [24685] = { coef = 150, name = "Sunblade Magister", id = 24685 }, -- Frostbolt spam
    
    -- Slave Pens
    [17816] = { coef = 150, name = "Bogstrok", id = 17816 }, -- High damage
    [21338] = { coef = 100, name = "Coilfang Leper", id = 21338 }, -- Disease spreader
    
    -- Underbog
    [17827] = { coef = 150, name = "Claw", id = 17827 }, -- Bog Lord pet, high damage
    [17826] = { coef = 100, name = "Swamplord Musel'ek", id = 17826 }, -- Hunter boss
    
    -- Mana-Tombs
    [18493] = { coef = 200, name = "Auchenai Soulpriest", id = 18493 }, -- Turns heals into damage
    [18371] = { coef = 150, name = "Shirrak the Dead Watcher", id = 18371 }, -- Inhibit Magic
    
    -- Auchenai Crypts
    [18524] = { coef = 150, name = "Angered Skeleton", id = 18524 }, -- Enrage
    [18472] = { coef = 100, name = "Auchenai Monk", id = 18472 }, -- Shadow Mend
    
    -- Sethekk Halls
    [18322] = { coef = 200, name = "Sethekk Ravenguard", id = 18322 }, -- Bloodthirst
    [18473] = { coef = 150, name = "Sethekk Oracle", id = 18473 }, -- Arcane Lightning
    
    -- Old Hillsbrad Foothills
    [17848] = { coef = 150, name = "Lieutenant Drake", id = 17848 }, -- Event mob
    [18092] = { coef = 100, name = "Tarren Mill Guardsman", id = 18092 }, -- Swarm adds
    
    -- Black Morass
    [17880] = { coef = 200, name = "Infinite Assassin", id = 17880 }, -- Must kill before portal closes
    [17835] = { coef = 150, name = "Infinite Chronomancer", id = 17835 }, -- Heals other adds
    
    -- Mechanar
    [19710] = { coef = 150, name = "Bloodwarder Physician", id = 19710 }, -- Healer
    [20059] = { coef = 100, name = "Sunseeker Astromage", id = 20059 }, -- Fireball
    
    -- Blood Furnace
    [17491] = { coef = 150, name = "Laughing Skull Rogue", id = 17491 }, -- Hemorrhage bleed
    [17653] = { coef = 100, name = "Shadowmoon Channeler", id = 17653 }, -- Shadow Bolt Volley
    
    -- Hellfire Ramparts
    [17264] = { coef = 150, name = "Bonechewer Ravener", id = 17264 }, -- Enrage
    [17270] = { coef = 100, name = "Bleeding Hollow Darkcaster", id = 17270 }, -- Shadow Bolt
    
    -- Karazhan
    [17007] = { coef = 150, name = "Concubine", id = 17007 }, -- Prince Malchezaar adds
    [16809] = { coef = 100, name = "Wanton Hostess", id = 16809 }, -- Moroes adds
    
    -- Black Temple
    [22964] = { coef = 200, name = "Sister of Pleasure", id = 22964 }, -- Mother Shahraz adds, heal
    [23047] = { coef = 150, name = "Parasitic Shadowfiend", id = 23047 }, -- Teron Gorefiend constructs
    
    -- Sunwell Plateau
    [25367] = { coef = 200, name = "Enslaved Servant", id = 25367 }, -- Kalecgos demon phase add
    [25840] = { coef = 150, name = "Entropius", id = 25840 }, -- M'uru dark phase
    
    --[[===========================]]
    --[[  WRATH OF THE LICH KING (80) ]]
    --[[===========================]]
    
    -- Utgarde Keep
    [23970] = { coef = 100, name = "Vrykul Skeleton", id = 23970 }, -- High damage
    [24201] = { coef = 150, name = "Proto-Drake Handler", id = 24201 }, -- Summons drakes
    
    -- Nexus
    [26763] = { coef = 150, name = "Anomalus Chaotic Rift", id = 26763 }, -- Rift spawner
    [26716] = { coef = 100, name = "Crazed Mana-Wraith", id = 26716 }, -- Frenzy
    
    -- Azjol-Nerub
    [28995] = { coef = 100, name = "Anub'ar Champion", id = 28995 }, -- Pound
    [29217] = { coef = 150, name = "Watcher Gashra", id = 29217 }, -- Curse
    
    -- Ahn'kahet: The Old Kingdom
    [30285] = { coef = 150, name = "Forgotten One", id = 30285 }, -- High damage
    [29310] = { coef = 100, name = "Ahn'kahar Spell Flinger", id = 29310 }, -- Shadow Bolt Volley
    
    -- Drak'Tharon Keep
    [26627] = { coef = 150, name = "Crystal Handler", id = 26627 }, -- Shatters to spawn adds
    [27598] = { coef = 100, name = "Fetid Troll Corpse", id = 27598 }, -- Explodes
    
    -- Violet Hold
    [29315] = { coef = 200, name = "Portal Guardian", id = 29315 }, -- Must kill to close portal
    [30695] = { coef = 150, name = "Azure Invader", id = 30695 }, -- Portal adds
    
    -- Gundrak
    [29573] = { coef = 100, name = "Drakkari Bat", id = 29573 }, -- Swarm
    [29920] = { coef = 150, name = "Drakkari Colossus", id = 29920 }, -- High armor
    
    -- Halls of Stone
    [27977] = { coef = 200, name = "Tribunal of Ages", id = 27977 }, -- Event waves
    [28070] = { coef = 100, name = "Dark Rune Protector", id = 28070 }, -- Cleave
    
    -- Halls of Lightning
    [28579] = { coef = 150, name = "Dark Rune Champion", id = 28579 }, -- Whirlwind
    [28965] = { coef = 100, name = "Volkhan Golem", id = 28965 }, -- Shatter explosion
    
    -- Oculus
    [27755] = { coef = 150, name = "Centrifuge Construct", id = 27755 }, -- Empowering Blows
    [27447] = { coef = 100, name = "Mage-Lord Urom", id = 27447 }, -- Time Bomb
    
    -- Culling of Stratholme
    [28199] = { coef = 150, name = "Chrono-Lord Epoch", id = 28199 }, -- Time Warp
    [28167] = { coef = 100, name = "Infinite Adversary", id = 28167 }, -- Banish healer
    
    -- Utgarde Pinnacle
    [26687] = { coef = 150, name = "Gortok Palehoof", id = 26687 }, -- High damage
    [27281] = { coef = 100, name = "Scourge Hulk", id = 27281 }, -- Volatile Infection
    
    -- Trial of the Champion
    [35314] = { coef = 200, name = "Eressea Dawnsinger", id = 35314 }, -- Heals
    [35328] = { coef = 150, name = "Argent Lightwielder", id = 35328 }, -- Divine Storm
    
    -- Pit of Saron
    [36494] = { coef = 150, name = "Wrathbone Laborer", id = 36494 }, -- Puncture Wound bleed
    [36661] = { coef = 100, name = "Ymirjar Deathbringer", id = 36661 }, -- Banish
    
    -- Forge of Souls
    [36516] = { coef = 150, name = "Soul Horror", id = 36516 }, -- Soul Strike
    [36522] = { coef = 100, name = "Soulguard Animator", id = 36522 }, -- Summons adds
    
    -- Halls of Reflection
    [38177] = { coef = 200, name = "Shadowy Mercenary", id = 38177 }, -- High damage, event waves
    [38176] = { coef = 150, name = "Tortured Rifleman", id = 38176 }, -- Shoot spam
    
    -- Naxxramas (Wrath) / Ahn'kahet
    [30176] = { coef = 100, name = "Ahn'kahar Guardian", id = 30176 }, -- Gives immunity buff to boss (Ahn'kahet)
    [29701] = { coef = 150, name = "Crypt Guard", id = 29701 }, -- High armor, priority
    
    -- Ulduar
    [33524] = { coef = 200, name = "Dark Rune Guardian", id = 33524 }, -- Runic Barrier buff
    [33722] = { coef = 150, name = "Rubble", id = 33722 }, -- Kologarn adds
    [33526] = { coef = 100, name = "Dark Rune Sentinel", id = 33526 }, -- Whirlwind
    
    -- Trial of the Crusader
    [34496] = { coef = 200, name = "Mistress of Pain", id = 34496 }, -- Jaraxxus add
    [34451] = { coef = 150, name = "Burning Treant", id = 34451 }, -- Freya's Gift add
    
    -- Icecrown Citadel
    [37890] = { coef = 200, name = "Cult Adherent", id = 37890 }, -- Lady Deathwhisper, shields boss
    [37934] = { coef = 150, name = "Cult Fanatic", id = 37934 }, -- Lady Deathwhisper
    [36672] = { coef = 200, name = "Kor'kron Axethrower", id = 36672 }, -- Gunship, sabotage
    [37098] = { coef = 150, name = "Val'kyr Shadowguard", id = 37098 }, -- Lich King phase transition
    [36701] = { coef = 100, name = "Raging Spirit", id = 36701 }, -- Deathbringer Saurfang
    
    -- Ruby Sanctum
    [39751] = { coef = 150, name = "Baltharus the Warborn Clone", id = 39751 }, -- Split mechanic
    
    --[[===========================]]
    --[[  CATACLYSM (85)           ]]
    --[[===========================]]
    
    -- Throne of the Tides
    [40788] = { coef = 150, name = "Gilgoblin Hunter", id = 40788 }, -- Poisoned Spear
    [40825] = { coef = 100, name = "Unstable Corruption", id = 40825 }, -- Explodes
    
    -- Blackrock Caverns
    [39392] = { coef = 150, name = "Defiled Earth Rager", id = 39392 }, -- Chains of Woe
    [39294] = { coef = 100, name = "Twilight Flame Caller", id = 39294 }, -- Blast Wave
    
    -- Vortex Pinnacle
    [45912] = { coef = 200, name = "Wild Vortex", id = 45912 }, -- Cyclone spawn
    [45477] = { coef = 100, name = "Gust Soldier", id = 45477 }, -- Wind Blast
    
    -- Stonecore
    [43438] = { coef = 150, name = "Crystalspawn Giant", id = 43438 }, -- Quake stomp
    [42691] = { coef = 100, name = "Stonecore Berserker", id = 42691 }, -- Spinning Slash
    
    -- Lost City of the Tol'vir
    [44926] = { coef = 150, name = "Frenzied Crocolisk", id = 44926 }, -- Vicious Bite
    [45124] = { coef = 100, name = "Oathsworn Tamer", id = 45124 }, -- Summons adds
    
    -- Halls of Origination
    [39378] = { coef = 200, name = "Sun-Touched Servant", id = 39378 }, -- Blessing of the Sun immunity
    [39366] = { coef = 100, name = "Spatial Anomaly", id = 39366 }, -- Wormhole spawn
    
    -- Grim Batol
    [39625] = { coef = 150, name = "Twilight Beguiler", id = 39625 }, -- Deceitful Blast
    [39956] = { coef = 100, name = "Azureborne Seer", id = 39956 }, -- AoE heal
    
    -- Deadmines (Heroic)
    [48231] = { coef = 150, name = "Defias Enforcer", id = 48231 }, -- Bloodbath
    [48417] = { coef = 100, name = "Defias Blood Wizard", id = 48417 }, -- Ragezone
    
    -- Shadowfang Keep (Heroic)
    [3865] = { coef = 150, name = "Shadow Charger", id = 3865 }, -- High mobility
    [3872] = { coef = 100, name = "Deathsworn Captain", id = 3872 }, -- Raise Dead
    
    -- Zul'Aman (Heroic)
    [23596] = { coef = 200, name = "Amani'shi Flame Caster", id = 23596 }, -- Fire damage
    [24549] = { coef = 150, name = "Amani'shi Medicine Man", id = 24549 }, -- Heals
    
    -- Zul'Gurub (Heroic)
    [52053] = { coef = 200, name = "Tiki Lord Mu'Loa", id = 52053 }, -- Voodoo Bolt
    [52157] = { coef = 150, name = "Gurubashi Shadow Hunter", id = 52157 }, -- Shadowy Protector
    
    -- End Time
    [54431] = { coef = 150, name = "Echo of Baine", id = 54431 }, -- Pulverize
    [54442] = { coef = 100, name = "Echo of Tyrande", id = 54442 }, -- Stardust spawn
    
    -- Well of Eternity
    [55085] = { coef = 150, name = "Dreadlord Defender", id = 55085 }, -- Carrion Swarm
    [55503] = { coef = 100, name = "Enchanted Highborne", id = 55503 }, -- Frost Bolt Volley
    
    -- Hour of Twilight
    [54590] = { coef = 200, name = "Twilight Assassin", id = 54590 }, -- Backstab spam
    [54634] = { coef = 150, name = "Twilight Shadow Walker", id = 54634 }, -- Shadow Bolt
    
    -- Blackwing Descent
    [41440] = { coef = 200, name = "Aberration", id = 41440 }, -- Maloriak adds, must burn
    [41545] = { coef = 150, name = "Golem Sentry", id = 41545 }, -- Magmaw spike adds
    
    -- Bastion of Twilight
    [46147] = { coef = 200, name = "Twilight Sentry", id = 46147 }, -- Portals phase
    [44653] = { coef = 150, name = "Chogall Adherent", id = 44653 }, -- Heal/damage adds
    
    -- Throne of the Four Winds
    [46753] = { coef = 200, name = "Al'Akir Stormling", id = 46753 }, -- Phase 1 adds
    
    -- Firelands
    [53695] = { coef = 200, name = "Molten Flare", id = 53695 }, -- Alysrazor air phase
    [53216] = { coef = 150, name = "Blazing Talon Initiate", id = 53216 }, -- Alysrazor ground adds
    [53494] = { coef = 100, name = "Harbinger of Flame", id = 53494 }, -- Rhyolith adds
    
    -- Dragon Soul
    [55265] = { coef = 200, name = "Unstable Corruption", id = 55265 }, -- Spine of Deathwing
    [55266] = { coef = 150, name = "Corrupted Blood", id = 55266 }, -- Spine of Deathwing
    [56471] = { coef = 200, name = "Blistering Tentacle", id = 56471 }, -- Madness of Deathwing
    [56846] = { coef = 150, name = "Elementium Bolt", id = 56846 }, -- Spine mechanics
    
    --[[===========================]]
    --[[  MISTS OF PANDARIA CLASSIC ]]
    --[[===========================]]
    
    -- Stormstout Brewery
    [59545] = { coef = 100, name = "Hozen Bouncer", id = 59545 },
    [56637] = { coef = 150, name = "Ook-Ook", buff = 106807 }, -- When Going Bananas cast
    [59579] = { coef = 100, name = "Sodden Hozen Brawler", id = 59579 },
    
    -- Mogu'shan Palace
    [61340] = { coef = 100, name = "Undying Flame", id = 61340 }, -- Xin the Weaponmaster adds
    [61339] = { coef = 100, name = "Animated Staff", id = 61339 },
    
    -- Shado-Pan Monastery
    [56747] = { coef = 150, name = "Gu Cloudstrike", buff = 110945 }, -- While Charging Soul
    [56884] = { coef = 100, name = "Consuming Sha", id = 56884 },
    [59051] = { coef = 100, name = "Corrupt Living Water", id = 59051 },
    [59764] = { coef = 150, name = "Sha Manifestation", id = 59764 },
    
    -- Gate of the Setting Sun
    [56906] = { coef = 100, name = "Volatile Munitions", id = 56906 }, -- Bombs
    [56877] = { coef = 150, name = "Saboteur Kip'tilak", cast = 107268 }, -- Interrupt or burn
    
    -- Siege of Niuzao Temple
    [61699] = { coef = 100, name = "Sap Puddle", id = 61699 },
    [61634] = { coef = 100, name = "Amber-Trapped Kunchong", id = 61634 },
    [61398] = { coef = 150, name = "Sik'thik Amber-Sapper", id = 61398 },
    
    -- Scarlet Halls
    [59191] = { coef = 100, name = "Reinforced Archery Target", id = 59191 },
    [59190] = { coef = 100, name = "Starving Hound", buff = 111853 }, -- While Obedience buff active
    
    -- Scarlet Monastery
    [59223] = { coef = 150, name = "Empowering Spirit", id = 59223 }, -- Heals boss
    [59150] = { coef = 100, name = "Scarlet Judicator", cast = 113436 }, -- Burn or interrupt
    
    -- Scholomance
    [58823] = { coef = 150, name = "Bored Student", buff = 114062 }, -- If Rising Anger is up
    [59184] = { coef = 100, name = "Boneguard Lieutenant", id = 59184 },
    [59100] = { coef = 200, name = "Expired Test Subject", id = 59100 }, -- Explodes on death
    
    -- Mogu'shan Vaults (Raid)
    [60447] = { coef = 100, name = "Petrifying Stone Guard", id = 60447 },
    [60043] = { coef = 100, name = "Sorcerer-King Mogu", id = 60043 },
    [60399] = { coef = 150, name = "Ancient Mogu Machine", id = 60399 },
    
    -- Heart of Fear (Raid)
    [62511] = { coef = 200, name = "Overwhelming Assault", id = 62511 }, -- Blade Lord Ta'yak
    [63591] = { coef = 150, name = "Corrupted Quickening", id = 63591 },
    [62968] = { coef = 100, name = "Wind Lord Mel'jarak Adds", id = 62968 },
    
    -- Terrace of Endless Spring (Raid)
    [62358] = { coef = 100, name = "Haunting Sha", id = 62358 },
    [62919] = { coef = 150, name = "Reflection", id = 62919 }, -- Lei Shi encounter
    [60999] = { coef = 100, name = "Sha of Fear Adds", id = 60999 },
    
    -- Throne of Thunder (Raid)
    [69427] = { coef = 100, name = "Waterspout", id = 69427 }, -- Council of Elders
    [69649] = { coef = 150, name = "Living Sand", id = 69649 }, -- Horridon adds
    [69134] = { coef = 200, name = "Dire Troll", id = 69134 }, -- Council of Elders
    [69633] = { coef = 100, name = "Sul Lithuz Stonegazer", id = 69633 },
    [68220] = { coef = 100, name = "Spirit Flayer", id = 68220 }, -- Primordius adds
    [70249] = { coef = 200, name = "Crimsonscale Firestorm", id = 70249 }, -- Ji-Kun fight
    [70216] = { coef = 100, name = "Nest Guardian", id = 70216 },
    [69680] = { coef = 150, name = "Zandalari Dinomancer", id = 69680 }, -- Horridon
    [69692] = { coef = 100, name = "Zandalari Warlord", id = 69692 },
    
    -- Siege of Orgrimmar (Raid)
    [71984] = { coef = 200, name = "Minion of Y'Shaarj", id = 71984 }, -- Sha of Pride adds
    [71152] = { coef = 150, name = "Embodied Gloom", id = 71152 },
    [71159] = { coef = 100, name = "Embodied Anguish", id = 71159 },
    [71068] = { coef = 100, name = "Embodied Doubt", id = 71068 },
    [71858] = { coef = 200, name = "Sniper", id = 71858 }, -- Malkorok encounter
    [71995] = { coef = 150, name = "Kor'kron Demolisher", id = 71995 },
    [72272] = { coef = 100, name = "Dread Spawn", id = 72272 }, -- Dark Shaman
    [73223] = { coef = 200, name = "Amber Parasite", id = 73223 }, -- Paragons encounter
    [71934] = { coef = 100, name = "Kor'kron Assassin", id = 71934 },
    [71953] = { coef = 100, name = "Korkron Reaper", id = 71953 },
    
    --[[===========================]]
    --[[  LATER EXPANSIONS (KEEP)  ]]
    --[[===========================]]
    
    --Vault of the Incarnates
    [199353] = { coef = 100, name = "Batak", id = 199353 },
    [192934] = { coef = 100, name = "Volatile Infuser", id = 192934 },
    [187638] = { coef = 100, name = "Flamescale Tarasek", id = 187638 },
    --Castle Narthia
    [175992] = { coef = 150, name = "Dutiful Attendant", id = 175992 }, -- gives immunity to boss
    [172858] = { coef = 200, name = "Stone Legion Goliath", id = 172858 },
    [174335] = { coef = 100, name = "Stone Legion Skirmisher", id = 174335 },
    [173162] = { coef = 200, name = "Lord Evershade", id = 173162 },
    [173163] = { coef = 200, name = "Baron Duskhollow", id = 173163 },
    --Dragonflight dungeons
    --Algeth'ar Academy
    [196045] = { coef = 100, name = "Corrupted Manafiend", id = 196045 },
    [196576] = { coef = 100, name = "Spellbound Scepter", id = 196576 },
    [196202] = { coef = 100, name = "Spectral Invoker", id = 196202 },
    [196203] = { coef = 100, name = "Ethereal Restorer", id = 196203 },
    [197398] = { coef = 100, name = "Hungry Lasher", id = 197398 },
    [196548] = { coef = 100, name = "Ancient Branch", id = 196548 },
    [192333] = { coef = 100, name = "Alpha Eagle", id = 192333 },
    [196044] = { coef = 150, name = "Unruly Textbook", id = 196044 },
    --The Nokhud Offensive
    [192800] = { coef = 100, name = "Nokhud Lancemaster", id = 192800 },
    [191847] = { coef = 100, name = "Nokhud Plainstomper", id = 191847 },
    [192796] = { coef = 100, name = "Nokhud Hornsounder", id = 192796 },
    [194317] = { coef = 100, name = "Stormcaller Boroo", id = 194317 },
    [194896] = { coef = 100, name = "Primal Stormshield", id = 194896 },
    [194315] = { coef = 100, name = "Stormcaller Solongo", id = 194315 },
    [194894] = { coef = 100, name = "Primalist Stormspeaker", id = 194894 },
    [194316] = { coef = 100, name = "Stormcaller Zarii", id = 194316 },
    [195929] = { coef = 100, name = "Soulharvester Tumen", id = 195929 },
    [195851] = { coef = 100, name = "Ukhel Deathspeaker", id = 195851 },
    [195877] = { coef = 100, name = "Risen Mystic", id = 195877 },
    [195930] = { coef = 100, name = "Soulharvester Mandakh", id = 195930 },
    [195927] = { coef = 100, name = "Soulharvester Galtmaa", id = 195927 },
    [195842] = { coef = 100, name = "Ukhel Corruptor", id = 195842 },
    [195723] = { coef = 100, name = "Teera", id = 195723 },
    [193462] = { coef = 100, name = "Batak", id = 193462 },
    [190294] = { coef = 100, name = "Nokhud Stormcaster", id = 190294 },
    --Temple of the Jade Serpent
    [200126] = { coef = 100, name = "Fallen Waterspeaker", id = 200126 },
    [59555] = { coef = 100, name = "Haunting Sha", id = 59555 },
    [200131] = { coef = 100, name = "Sha-Touched Guardian", id = 200131 },
    [200137] = { coef = 100, name = "Depraved Mistweaver", id = 200137 },
    [59546] = { coef = 100, name = "The Talking Fish", id = 59546 },
    [59553] = { coef = 100, name = "The Songbird Queen", id = 59553 },
    [59552] = { coef = 100, name = "The Crybaby Hozen", id = 59552 },
    [57109] = { coef = 100, name = "Minion of Doubt", id = 57109 },
    [56792] = { coef = 100, name = "Figment of Doubt", id = 56792 },
    --Halls of Valor
    [95842] = { coef = 100, name = "Valarjar Thundercaller", id = 95842 },
    [95834] = { coef = 100, name = "Valarjar Mystic", id = 95834 },
    [97197] = { coef = 100, name = "Valarjar Purifier", id = 97197 },
    [96664] = { coef = 100, name = "Valarjar Runecarver", id = 96664 },
    [96611] = { coef = 100, name = "Angerhoof Bull", id = 96611 },
    [101637] = { coef = 150, name = "Valarjar Aspirant", id = 101637 },
    [102019] = { coef = 100, name = "Stormforged Obliterator", id = 102019 },
    -- m+ stuff
    [343502] = { coef = 50, name = "Inspiring - M+ Affix", id = 343502 },
    [173729] = { coef = 150, name = "Manifestation of Pride", id = 173729 },
    --Plaguefall
    [164362] = { coef = 50, name = "Slimy Morsel", id = 164362 }, -- Plaguefall Dungeon - if they reach boss the heal him
    [169498] = { coef = 150, name = "Plague Bomb", id = 169498 }, -- kill before it explodes
    [164707] = { coef = 50, name = "Congealed Slime", buff = 333737, id = 164707 }, -- 75% damage reduction to boss
    [165430] = { coef = 50, name = "Malignant Spawn", id = 165430 }, -- kill add before it explodes
    --Necrotic Wake
    [164702] = { coef = 100, name = "Carrion Worm", id = 164702 }, --kill before it gets 3 mele hits to explode
    [164427] = { coef = 100, name = "Reanimated Warrior", id = 164427 },
    [164414] = { coef = 100, name = "Reanimated Mage", id = 164414 },
    [168246] = { coef = 100, name = "Reanimated Crossbowman", id = 168246 },
    -- Sanguine Depth
    [168882] = { coef = 100, name = "Fleeting Manifestation", id = 168882 }, --  168882/fleeting-manifestation - must kill fast

    -- WoD Dungeons
    [71603] = { coef = 100, name = "Immerseus Oozes", id = 71603 }, -- kill on sight
    -- Shadowmoon Burial Grounds
    [75966] = { coef = 100, name = "Defiled Spirit", id = 75966 }, -- need to be cc and snared and is not allowed to reach boss.
    [75899] = { coef = 100, name = "Possessed Soul", id = 75899 },
    [76518] = { coef = 100, unitMarker = 8 }, -- Ritual of Bones, marked one will be prioritized
    -- Auchindon
    [77812] = { coef = 150, name = "Sargerei Souldbinder", id = 77812 }, -- casts a Mind Control
    -- Grimrail Depot
    [80937] = { coef = 100, id = 80937 },
    -- UBRS
    [76222] = { coef = 100, id = 76222 },
    [163061] = { coef = 100, id = 163061 }, -- Windfury Totem
    -- Proving Grounds
    [71070] = { coef = 150, name = "Illusion Banshee", id = 71070 }, -- proving ground (will explode if not burned)
    [71075] = { coef = 150, name = "Illusion Banshee", id = 71075 }, -- proving ground (will explode if not burned)
    [71076] = { coef = 25, id = 71076 }, -- Proving ground healer
    -- Legion
    [117264] = { coef = 200, name = "Maiden of Valor", buff = 241008, id = 117264 }, -- burn Maiden of Valor if buff is present
    [120651] = { coef = 150, name = "Explosives", id = 120651 }, -- M+ Affix
    -- [115642] = { coef = 100}, -- Umbral Imps - Challenge mode
    -- [115638] = { coef = 175, buff = 243113},
    -- [115641] = { coef = 150}, -- Smoldering Imps
    -- [115640] = { coef = 125}, -- Fuming Imps
    -- [115719] = { coef = 200}, -- Imp Servents
    -- BFA
    [141851] = { coef = 150, name = "Spawn of G'huun", id = 141851 },
    [131823] = { coef = 150, name = "Sister Malady", buff = 260805, id = 131823 }, -- Sister Malady (No Focusing Iris)
    [131824] = { coef = 150, name = "Sister Solena", buff = 260805, id = 131824 }, -- Sister Solena (No Focusing Iris)
    [131825] = { coef = 150, name = "Sister Briar", buff = -260805, id = 131825 }, -- Sister Briar (No Focusing Iris)
    -- Uldir
    [135016] = { coef = 200, name = "Plague Amalgam", id = 135016 },
}
