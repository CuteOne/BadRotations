local _, br = ...
if br.lists == nil then
    br.lists = {}
end
-- Crowd Control Units = list of units to stun, either always or under certain condition such as having a buff or whirlwind etc
-- example
br.lists.ccUnits = {
    --[[===========================]]
    --[[  CLASSIC / VANILLA (60)   ]]
    --[[===========================]]
    
    -- Stratholme
    [10558] = {{ name = "Hearthsinger Forresten", spell = 16798 }}, -- Fear
    [10813] = {{ name = "Balnazzar", spell = 17405 }}, -- Domination mind control
    
    -- Scholomance (Vanilla)
    [10433] = {{ name = "Marduk Blackpool", spell = 16097 }}, -- Hex
    [10499] = {{ name = "Spectral Researcher", spell = 16799 }}, -- Mind Flay
    
    -- Blackrock Depths
    [9018] = {{ name = "High Interrogator Gerstahn", spell = 15063 }}, -- Mind Control
    [9024] = {{ name = "Pyromancer Loregrain", spell = 15744 }}, -- Blast Wave
    
    -- Upper Blackrock Spire
    [10742] = {{ name = "Blackhand Elite", spell = 15284 }}, -- Mortal Strike (high damage)
    [9693] = {{ name = "Burning Felguard", spell = 15532 }}, -- Frost Nova
    
    -- Sunken Temple
    [5710] = {{ name = "Jammal'an the Prophet", spell = 12480 }}, -- Heal
    [5717] = {{ name = "Mijan", spell = 11428 }}, -- Knockdown
    
    -- Maraudon
    [13738] = {{ name = "Cavindra", spell = 21869 }}, -- Flame Shock
    [13741] = {{ name = "Gelk", spell = 21869 }}, -- Fear
    
    -- Zul'Farrak
    [7797] = {{ name = "Ruuzlu", spell = 11642 }}, -- Heal
    [7796] = {{ name = "Nekrum Gutchewer", spell = 8600 }}, -- Fevered Plague
    
    -- Uldaman
    [6906] = {{ name = "Baelog", spell = 6524 }}, -- Ground Tremor
    [4854] = {{ name = "Grimlok", spell = 8148 }}, -- Demoralizing Shout
    
    -- Molten Core
    [11662] = {{ name = "Flamewaker Priest", spell = 19776 }}, -- Shadow Word: Pain spam
    
    -- Blackwing Lair
    [12053] = {{ name = "Blackwing Spellbinder", spell = 16793 }}, -- Greater Polymorph on tanks
    
    -- Naxxramas
    [16244] = {{ name = "Infectious Ghoul" }}, -- Plague spreader, CC priority
    [16146] = {{ name = "Deathknight", spell = 19643 }}, -- High damage Mortal Strike
    
    --[[===========================]]
    --[[  BURNING CRUSADE (70)     ]]
    --[[===========================]]
    
    -- Shadow Labyrinth
    [18667] = {{ name = "Blackheart the Inciter", spell = 33676 }}, -- Incite Chaos mind control
    [18663] = {{ name = "Maiden of Discipline", spell = 33787 }}, -- Whirlwind
    
    -- Shattered Halls
    [17670] = {{ name = "Shattered Hand Warhound", spell = 30636 }}, -- Rend (bleed)
    [20923] = {{ name = "Blood Guard Porung", spell = 31901 }}, -- Shield Wall
    
    -- Botanica
    [19486] = {{ name = "Sunseeker Chemist", spell = 34639 }}, -- Unstable Chemicals
    [21579] = {{ name = "Bloodwarder Mender", spell = 34649 }}, -- Heal
    
    -- Magisters' Terrace
    [24683] = {{ name = "Sunblade Mage Guard", buff = 46757 }}, -- Glyph of Power buff
    [24685] = {{ name = "Sunblade Magister", spell = 46035 }}, -- Frostbolt
    
    -- Mana-Tombs
    [18493] = {{ name = "Auchenai Soulpriest", spell = 32860 }}, -- Turns heals into damage
    [18371] = {{ name = "Shirrak the Dead Watcher", spell = 32361 }}, -- Inhibit Magic
    
    -- Sethekk Halls
    [18322] = {{ name = "Sethekk Ravenguard", spell = 32674 }}, -- Bloodthirst
    [18473] = {{ name = "Sethekk Oracle", spell = 32129 }}, -- Arcane Lightning
    
    -- Old Hillsbrad Foothills
    [17848] = {{ name = "Lieutenant Drake", spell = 33834 }}, -- Exploding Shot
    
    -- Black Morass
    [17880] = {{ name = "Infinite Assassin", spell = 33865 }}, -- Backstab
    [17835] = {{ name = "Infinite Chronomancer", spell = 33860 }}, -- Heal
    
    -- Slave Pens / Underbog
    [17827] = {{ name = "Claw", spell = 31429 }}, -- Claw Rage
    [21337] = {{ name = "Coilfang Tempest", spell = 37159 }}, -- Lightning Bolt
    
    -- Blood Furnace
    [17491] = {{ name = "Laughing Skull Rogue", spell = 30992 }}, -- Hemorrhage
    
    -- Hellfire Ramparts
    [17264] = {{ name = "Bonechewer Ravener", spell = 8599 }}, -- Enrage
    
    -- Karazhan
    [16809] = {{ name = "Wanton Hostess", spell = 29321 }}, -- Fear on tank
    
    -- Black Temple
    [22964] = {{ name = "Sister of Pleasure", spell = 41338 }}, -- Heal
    
    --[[===========================]]
    --[[  WRATH OF THE LICH KING (80) ]]
    --[[===========================]]
    
    -- Violet Hold
    [29315] = {{ name = "Portal Guardian" }}, -- Must CC/kill to close portals
    [30695] = {{ name = "Azure Invader", spell = 58471 }}, -- Brutal Strike
    
    -- Halls of Lightning
    [28579] = {{ name = "Dark Rune Champion", spell = 52719 }}, -- Whirlwind
    [28965] = {{ name = "Volkhan Golem", spell = 52237 }}, -- Shatter (explodes)
    
    -- Culling of Stratholme
    [28167] = {{ name = "Infinite Adversary", spell = 52854 }}, -- Banish
    [28169] = {{ name = "Infinite Agent", spell = 52942 }}, -- Temporal Rift
    
    -- Trial of the Champion
    [35314] = {{ name = "Eressea Dawnsinger", spell = 66099 }}, -- Holy Smite spam
    [35328] = {{ name = "Argent Lightwielder", spell = 66920 }}, -- Divine Storm
    
    -- Pit of Saron
    [36494] = {{ name = "Wrathbone Laborer", spell = 69579 }}, -- Puncture Wound
    [36661] = {{ name = "Ymirjar Deathbringer", spell = 69603 }}, -- Banish
    
    -- Halls of Reflection
    [38177] = {{ name = "Shadowy Mercenary", spell = 72333 }}, -- Deadly Poison
    [38176] = {{ name = "Tortured Rifleman", spell = 72340 }}, -- Shoot
    
    -- Naxxramas
    [16803] = {{ name = "Deathknight Understudy" }}, -- Always CC to prevent healing Razuvious
    
    -- Ulduar
    [33722] = {{ name = "Rubble", spell = 63849 }}, -- Stone Grip
    
    -- Icecrown Citadel
    [37890] = {{ name = "Cult Adherent", spell = 70842 }}, -- Dark Martyrdom (shields boss)
    [37934] = {{ name = "Cult Fanatic", spell = 70645 }}, -- Dark Transformation
    
    --[[===========================]]
    --[[  CATACLYSM (85)           ]]
    --[[===========================]]
    
    -- Throne of the Tides
    [40788] = {{ name = "Gilgoblin Hunter", spell = 76622 }}, -- Poisoned Spear
    [40825] = {{ name = "Unstable Corruption" }}, -- Must CC before it explodes
    
    -- Vortex Pinnacle
    [45912] = {{ name = "Wild Vortex" }}, -- Cyclone, must CC/kill
    [45477] = {{ name = "Gust Soldier", spell = 88194 }}, -- Wind Blast
    
    -- Stonecore
    [43438] = {{ name = "Crystalspawn Giant", spell = 81008 }}, -- Quake stomp
    [42691] = {{ name = "Stonecore Berserker", spell = 81637 }}, -- Spinning Slash
    
    -- Grim Batol
    [39625] = {{ name = "Twilight Beguiler", spell = 76711 }}, -- Deceitful Blast
    [39854] = {{ name = "Azureborne Seer", spell = 76121 }}, -- Warped Twilight
    
    -- Zul'Aman (Heroic)
    [23596] = {{ name = "Amani'shi Flame Caster", spell = 43140 }}, -- Flame Breath
    [24549] = {{ name = "Amani'shi Medicine Man", spell = 43432 }}, -- Heal
    
    -- Zul'Gurub (Heroic)
    [52053] = {{ name = "Tiki Lord Mu'Loa", spell = 96689 }}, -- Voodoo Bolt
    [52157] = {{ name = "Gurubashi Shadow Hunter", spell = 96684 }}, -- Shadowy Protector
    
    -- Hour of Twilight
    [54590] = {{ name = "Twilight Assassin", spell = 103633 }}, -- Backstab
    [54634] = {{ name = "Twilight Shadow Walker", spell = 103641 }}, -- Shadow Bolt
    
    -- Blackwing Descent
    [41440] = {{ name = "Aberration" }}, -- Must CC/burn, phase mechanic
    
    -- Firelands
    [53216] = {{ name = "Blazing Talon Initiate", spell = 99432 }}, -- Fieroblast
    
    --[[===========================]]
    --[[  MISTS OF PANDARIA CLASSIC ]]
    --[[===========================]]
    
    -- Temple of the Jade Serpent
    [59546] = {{ name = "Figment of Doubt", spell = 106113 }}, -- When casting Doubt
    [56762] = {{ name = "Corrupt Living Water", spell = 106797 }}, -- When casting Hydrolance
    
    -- Stormstout Brewery
    [59555] = {{ name = "Haunting Sha", spell = 114646 }}, -- When Haunting Gaze channels
    [59797] = {{ name = "Yeasty Alemental", spell = 116027 }}, -- Brew Bolt
    
    -- Mogu'shan Palace
    [61340] = {{ name = "Undying Flame" }}, -- Always CC to prevent overwhelming adds
    [61399] = {{ name = "Whirling Dervish", spell = 119981 }}, -- Mogu Whirlwind
    
    -- Shado-Pan Monastery
    [59547] = {{ name = "Shado-Pan Novice", buff = 115010 }}, -- When Charging Soul is active
    [59544] = {{ name = "Fragment of Hatred", spell = 115002 }}, -- During Rising Hate cast
    [59545] = {{ name = "Gripping Hatred", spell = 115002 }}, -- During Rising Hate cast
    [56541] = {{ name = "Sha Manifestation", spell = 111585 }}, -- Consuming Bite
    
    -- Gate of the Setting Sun
    [56906] = {{ name = "Volatile Munitions" }}, -- Always CC or interrupt before explosion
    [56589] = {{ name = "Sik'thik Guardian", spell = 107120 }}, -- When Impaling Strike
    
    -- Siege of Niuzao Temple
    [61449] = {{ name = "Sik'thik Soldier", spell = 121282 }}, -- When Devastating Arc channels
    [62693] = {{ name = "Sik'thik Demolisher", spell = 119610 }}, -- Bombard cast
    
    -- Scarlet Halls
    [59150] = {{ name = "Scarlet Judicator", spell = 113436 }}, -- Heroic Defense cast (damage reduction)
    [59240] = {{ name = "Scarlet Treasurer", spell = 113959 }}, -- When channeling heal
    
    -- Scarlet Monastery
    [59300] = {{ name = "Scarlet Myrmidon", spell = 115143 }}, -- Dragon Strike windup
    [59746] = {{ name = "Fuel Barrel" }}, -- CC to prevent explosions
    
    -- Scholomance
    [58823] = {{ name = "Bored Student", buff = 114062 }}, -- When Rising Anger is up
    [58757] = {{ name = "Failed Student", spell = 113134 }}, -- Explosive Pain cast
    [58822] = {{ name = "Instructor Chillheart", spell = 113131 }}, -- Ice Wrath
    
    -- Mogu'shan Vaults (Raid)
    [60447] = {{ name = "Stone Guard", spell = 116529 }}, -- When overloading
    [60397] = {{ name = "Quillen Guardian", spell = 117570 }}, -- Devastating Arc
    
    -- Heart of Fear (Raid)
    [62837] = {{ name = "Blade Lord Ta'yak", spell = 123474 }}, -- When casting Overwhelming Assault windup
    [63591] = {{ name = "Manticore", spell = 123816 }}, -- Fear cast
    
    -- Throne of Thunder (Raid)
    [69633] = {{ name = "Sul Lithuz Stonegazer", spell = 137261 }}, -- Stone Gaze channel
    [69680] = {{ name = "Zandalari Dinomancer", spell = 136954 }}, -- Dino Form buff (heal/damage increase)
    [70216] = {{ name = "Nest Guardian", spell = 138923 }}, -- Talon Rake windup
    
    -- Siege of Orgrimmar (Raid)
    [71152] = {{ name = "Embodied Gloom", spell = 144579 }}, -- When channeling Black Cleave
    [71995] = {{ name = "Kor'kron Demolisher", spell = 143639 }}, -- Explosive Tar cast
    [72272] = {{ name = "Dread Spawn", spell = 144548 }}, -- During Dread Screech
    
    --[[===========================]]
    --[[  LATER EXPANSIONS (KEEP)  ]]
    --[[===========================]]
    
    -- Raid
    [167566] = {{ name = "Return to Stone", spell = 333145 }}, -- Sun King's Salvation
    [165762] = {{ name = "Soul Infuser" }}, -- Sun King's Salvation
    -- SL Dungeons
    --[174773] = {{ name = "All-Consuming Spite"}}, -- M+ Affix

    -- HoA
    [164562] = {{ name = "Loyal Beasts", spell = 326450 }}, -- Halls of Atonement

    -- DoS
    [170480] = {{ name = "Bladestorm", spell = 332671 }}, -- De Other Side
    [167963] = {{ name = "Spinning Up", spell = 332156 }},
    [171341] = {{ name = "Frightened Cries", spell = 334664 }}, -- https://www.wowhead.com/spell=334664/frightened-cries

    -- Mists
    --[165251] = {{ name = "Illusionary Vulpin" }, -- https://www.wowhead.com/npc=165251/illusionary-vulpin
    [166301] = {{ name = "Mistveil Bite", spell = 324987 }, -- https://www.wowhead.com/spell=324987/mistveil-bite
                { name = "Mistveil Tear", spell = 325021 }}, -- https://www.wowhead.com/spell=325021/mistveil-tear
    [167113] = {{ name = "Volatile Acid", spell = 325418 }}, -- https://www.wowhead.com/spell=325418/volatile-acid
    --[166276] = {{ name = "Bucking Rampage", spell = 331743 }}, -- https://www.wowhead.com/spell=331743/bucking-rampage

    -- SD
    [166396] = {{ name = "Animate Weapon", spell = 324609 }},

    -- Necrotic Wake
    [163619] = {{ name = "BoneFlay", spell = 321807 }}, -- Zolramus Bonecarver casting Boneflay
    [173016] = {{ name = "Drain Fluids", spell = 334748 }},
    [166302] = {{ name = "Drain Fluids", spell = 334748 }},
    [173044] = {{ name = "Drain Fluids", spell = 334748 }},
    [165911] = {{ name = "Spine Crush", spell = 327240 }},
    [165872] = {{ name = "Repair Flesh", spell = 327130 }},
    [165222] = {{ name = "Final Bargain", spell = 320822 }},
    [163618] = {{ name = "Animate Dead", spell = 321780 }, -- Zolramus Necromancer
                { name = "Animate Dead", spell = 323954 }, -- Zolramus Necromancer
                { name = "Animate Dead", spell = 324022 }, -- Zolramus Necromancer
                { name = "Animate Dead", spell = 324024 }}, -- Zolramus Necromancer

    --Theater of Pain
    [164510] = {{ name = "Shambling Arbalest", spell = 330532 }}, -- Nasty dot - needs to be cc'ed
    [169927] = {{ name = "Devour Flesh", spell = 330586 }}, -- Big heal from Putrid Butcher

    -- Plaguefall
    [171887] = {{ name = "Slimy Smorgasbord" }}, -- Plaguefall Dungeon
    [168572] = {{ name = "Fungistorm", spell = 330423 }, -- big AOE, can be stunned
                { name = "Fungistorm", spell = 328177 }}, -- -- big AOE, can be stunned
    [163862] = {{ name = "Bulwark of Maldraxxus", spell = 336451 }}, -- Prevent the shield from going on
    [163892] = {{ name = "Corroded Claws", spell = 320512 }}, -- Prevent the shield from going on
    [164737] = {{ name = "Stealthlings", spell = 328400 }}, -- https://www.wowhead.com/spell=328400/stealthlings
    [168907] = {{ name = "Crushing Embrace", spell = 328429 },
                { name = "Crushing Embrace", spell = 328432 },
                { name = "Crushing Embrace", spell = 345429 }},
    [168022] = {{ name = "Crushing Embrace", spell = 328429 },
                { name = "Crushing Embrace", spell = 328432 },
                { name = "Crushing Embrace", spell = 345429 }},

    -- Thorghast
    [150959] = {{ name = "Critical Shot", spell = 294171 }}, -- Torghast Mawsworn Interceptor
    [168107] = {{ name = "Critical Shot", spell = 164737 }}, -- Critical shot, Thorghast

    -- Test unit outside Boralus
    --[123231] = { name = "Sharptail Beaver" }},
    -- Visions of Ogrimmar
    [155657] = {{ name = "Huffer" }}, -- Rexxar's pets
    [155952] = {{ name = "Suffer" }}, -- Rexxar's pets
    [155951] = {{ name = "Ruffer" }}, -- Rexxar's pets
    [155953] = {{ name = "C'Thuffer" }}, -- Rexxar's pets
    -- Shadowmoon Burial Grounds
    [75966] = {{ name = "Defiled Spirit" }}, -- need to be cc and snared and is not allowed to reach boss.
    [76446] = {{ name = "Shadowmoon Enslavers" }},
    [75899] = {{ name = "Possessed Soul" }}, -- only for melee i guess
    [79510] = {{ name = "Crackling Pyromaniacs" }},
    -- Grimrail Depot
    [81236] = {{ name = "Grimrail Technicians", spell = 163966 }}, -- channeling Activating
    [80937] = {{ name = "Gromkar Gunner" }},
    -- UBRS
    [76157] = {{ name = "Black Iron Leadbelcher" }}, -- Activates canon, should be when/if moving
    -- Proving Ground
    [71415] = {{ name = "Banana Tosser", buff = 142639 }}, -- Small
    [71414] = {{ name = "Banana Tosser", buff = 142639 }}, -- Large
    -- BFA Dungeons
    [134024] = {{ name = "Infest", spell = 278444 }}, -- Waycrest Manor
    [142587] = {{ name = "Infest", spell = 278444 }}, -- Waycrest Manor
    [133593] = {{ name = "Repair", spell = 262554 }}, -- Motherload
    [152033] = {{ name = "inconspicuous-plant" }}, -- plant boss in workshop
    [152703] = {{ name = "walkie-shockie-x1" }}, --Last boss in Mech Junkyard
    [134331] = {{ name = "Channel Lightning", spell = 270889 }}, -- Motherload
    [131009] = {{ name = "Spirit of Gold" }}, -- AD
    [134388] = {{ name = "A Knot of Snakes" }}, -- temple, snakes!
    [129758] = {{ name = "Irontide Grenadier" }}, --FH last boss
    [129559] = {{ name = "Duelist Dash", spell = 274400 }}, --FREEHOLD Cutwater Duelist
    [130404] = {{ name = "Rat Traps", spell = 274383 }}, --FREEHOLD - VERMIN TRAPPER
    [129527] = {{ name = "Goin' Bananas", spell = 257756 }}, --FREEHOLD - BILGE RAT BUCCANEER
    [139799] = {{ name = "Whirling Slam", spell = 276292 }}, --SHRINE OF THE STORM - IRONHULL APPRENTICE
    [134338] = {{ name = "Deep Smash", spell = 268273 }}, --SHRINE OF THE STORM - TIDESAGE ENFORCER
    [129640] = {{ name = "Clamping Jaws", spell = 256897 }}, -- SIEGE OF BORALUS - SNARLING DOCKHOUND
    [128967] = {{ name = "Ricochet", spell = 272542 }}, -- SIEGE OF BORALUS - ASHVANE SNIPER
    [144170] = {{ name = "Ricochet", spell = 272542 }}, -- SIEGE OF BORALUS - ASHVANE SNIPER
    [137517] = {{ name = "Ferocity", spell = 272888 }}, -- SIEGE OF BORALUS - ASHVANE DESTROYER
    [144168] = {{ name = "Ferocity", spell = 272888 }}, -- SIEGE OF BORALUS - ASHVANE DESTROYER
    [129928] = {{ name = "Molten Slug", spell = 257641 }}, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [129989] = {{ name = "Molten Slug", spell = 257641 }}, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [137521] = {{ name = "Molten Slug", spell = 257641 }}, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [138254] = {{ name = "Molten Slug", spell = 257641 }}, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [132491] = {{ name = "Molten Slug", spell = 257641 }}, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [132532] = {{ name = "Molten Slug", spell = 257641 }}, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [141285] = {{ name = "Molten Slug", spell = 257641 }}, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [137614] = {{ name = "Slam", spell = 269266 }}, -- SIEGE OF BORALUS - DEMOLISHING TERROR
    [137625] = {{ name = "Slam", spell = 269266 }}, -- SIEGE OF BORALUS - DEMOLISHING TERROR
    [137626] = {{ name = "Slam", spell = 269266 }}, -- SIEGE OF BORALUS - DEMOLISHING TERROR
    [140447] = {{ name = "Slam", spell = 269266 }}, -- SIEGE OF BORALUS - DEMOLISHING TERROR
    [135699] = {{ name = "Riot Shield", spell = 258317 }}, -- TOL DAGOR - ASHVANE JAILER
    [127486] = {{ name = "Riot Shield", spell = 258317 }}, -- TOL DAGOR - ASHVANE OFFICER
    [130027] = {{ name = "Suppression Fire", spell = 258864 }}, -- TOL DAGOR - ASHVANE MARINE
    [136735] = {{ name = "Suppression Fire", spell = 258864 }}, -- TOL DAGOR - ASHVANE MARINE
    [136665] = {{ name = "Suppression Fire", spell = 258864 }}, -- TOL DAGOR - ASHVANE SPOTTER
    [127497] = {{ name = "Lockdown", spell = 259711 }}, -- TOL DAGOR - ASHVANE WARDEN
    [131445] = {{ name = "Lockdown", spell = 259711 }}, -- TOL DAGOR - BLOCK WARDEN
    [130028] = {{ name = "Righteous Flames", spell = 258917 }}, -- TOL DAGOR - ASHVANE PRIEST
    [131666] = {{ name = "Uproot", spell = 264038 }}, -- WAYCREST MANOR - COVEN THRONSHAPER
    [122971] = {{ name = "Bwonsamdi's Mantle", spell = 253544 }}, -- ATAL'DAZAR - Dazar'ai Confessor
    [122973] = {{ name = "Merciless Assault", spell = 253239 }}, -- ATAL'DAZAR - DAZAR'AI JUGGERNAUT
    [134157] = {{ name = "Gust Slash", spell = 269931 }}, -- KING'S REST - SHADOW-BRONE WARRIOR
    [137473] = {{ name = "Axe Barrage", spell = 270084 }}, -- KING'S REST - GUARD CAPTAIN ATU
    [135167] = {{ name = "Blooded Leap", spell = 270482 }, -- KING'S REST - SPECTRAL BERSERKER
                { name = "Severing Blade", spell = 270487 }}, -- KING'S REST - SPECTRAL BERSERKER --https://www.wowhead.com/spell=270487/severing-blade
    [135235] = {{ name = "Deadeye Shot", spell = 270506 }, -- KING'S REST - SPECTRAL BEASTMASTER
                { name = "Poison Barrage", spell = 270507 }}, -- KING'S REST - SPECTRAL BEASTMASTER
    -- [130488] = {{ name = "Activate Mech", spell = 267433 }, -- THE MOTHERLODE!! - MECH JOCKEY
    [134232] = {{ name = "Hail of Flechettes", spell = 267354 }}, -- THE MOTHERLODE!! - HIRED ASSASSIN
    [130635] = {{ name = "Furious Quake", spell = 268702 }}, -- THE MOTHERLODE!! - STONEFURY
    [136934] = {{ name = "Echo Blade", spell = 268846 }, -- THE MOTHERLODE!! - WEAPONS TESTER
                { name = "Force Cannon", spell = 268865 }}, -- THE MOTHERLODE!! - WEAPONS TESTER
    [134602] = {{ name = "Blade Flurry", spell = 258908 }}, -- TEMPLE OF SETHRALISS - SHROUDED FANG
    [134600] = {{ name = "Power Shot", spell = 264574 }}, -- TEMPLE OF SETHRALISS - SANDSWEPT MARKSMAN
    [134629] = {{ name = "Electrified Scales", spell = 272659 }}, -- TEMPLE OF SETHRALISS - SCALED KROLUSK RAIDER
    [139422] = {{ name = "Electrified Scales", spell = 272659 }}, -- TEMPLE OF SETHRALISS - SCALED KROLUSK TAMER
    [134686] = {{ name = "Scouring Sand", spell = 272655 }}, -- TEMPLE OF SETHRALISS - MATURE KROLUSK
    [134364] = {{ name = "Drain", spell = 267237 }}, -- TEMPLE OF SETHRALISS - FAITHLESS TENDER
    [133685] = {{ name = "Dark Omen", spell = 265568 }}, --THE UNDERROT - BEFOULED SPIRIT
    [130909] = {{ name = "Rotten Bile", spell = 265540 }, -- THE UNDERROT - FETID MAGGOT
                { name = "Rotten Bile", spell = 265542 }}, -- THE UNDERROT - FETID MAGGOT
    [161895] = {{ name = "Thing from Beyond" }} --corruption

}
