local _, br = ...
if br.lists == nil then
    br.lists = {}
end
-- No Touch Units = List of units that we should not attack for any reason
br.lists.noTouchUnits = {
    --[[===========================]]
    --[[  CLASSIC / VANILLA (60)   ]]
    --[[===========================]]

    -- Stratholme
    { unitID = 10811, buff = 17086 }, -- Archimondethe Dreadlord Carrion Swarm immunity
    { unitID = 10558, buff = 16798 }, -- Hearthsinger Forresten Fear immunity

    -- Blackrock Depths
    { unitID = 9019, buff = 13704 }, -- Emperor Dagran Thaurissan Avatar of Flame

    -- Upper Blackrock Spire
    { unitID = 10363, buff = 15732 }, -- General Drakkisath Conflagration immunity

    -- Sunken Temple
    { unitID = 5721, buff = 12480 }, -- Dreamscythe with healing immunity phase

    -- Maraudon
    { unitID = 13282, buff = 21909 }, -- Noxxion with Toxic Volley immunity
    { unitID = 12201, buff = 21869 }, -- Princess Theradras with Dust Field

    -- Zul'Farrak
    { unitID = 7273, buff = 11641 }, -- Gahz'rilla with Frenzy

    -- Molten Core
    { unitID = 12018, buff = 19595 }, -- Majordomo Executus with Shield of Flame

    -- Blackwing Lair
    { unitID = 11583, buff = 23414 }, -- Nefarian with Shadow Flame immunity

    -- Ahn'Qiraj 40
    { unitID = 15589, buff = 26525 }, -- Twin Emperors with Twin Teleport immunity
    { unitID = 15587, buff = 26580 }, -- Twin Emperors physical immunity

    -- Naxxramas (Classic)
    { unitID = 15990, buff = 28732 }, -- Kel'Thuzad with Frost Blast (don't break early)
    { unitID = 16061, buff = 28776 }, -- Four Horsemen Immune

    --[[===========================]]
    --[[  BURNING CRUSADE (70)     ]]
    --[[===========================]]

    -- Shadow Labyrinth
    { unitID = 18667, buff = 33676 }, -- Blackheart the Inciter Incite Chaos

    -- Shattered Halls
    { unitID = 20923, buff = 31901 }, -- Blood Guard Porung Shield Wall

    -- Botanica
    { unitID = 17976, buff = 34670 }, -- Commander Sarannis Arcane Resonance

    -- Magisters' Terrace
    { unitID = 24723, buff = 46757 }, -- Selin Fireheart Fel Crystal immunity

    -- Mana-Tombs
    { unitID = 18341, buff = 32361 }, -- Pandemonius with Void Blast

    -- Auchenai Crypts
    { unitID = 18373, buff = 32424 }, -- Exarch Maladaar with Avatar of the Martyred

    -- Sethekk Halls
    { unitID = 18473, buff = 32690 }, -- Talon King Ikiss with Blink immunity

    -- Black Morass
    { unitID = 17879, buff = 31473 }, -- Chrono Lord Deja with Magnetic Pull immunity

    -- Mechanar
    { unitID = 19219, buff = 35159 }, -- Mechano-Lord Capacitus with Reflective Damage Shield

    -- Blood Furnace
    { unitID = 17381, buff = 30923 }, -- The Maker with Domination mind control

    -- Slave Pens
    { unitID = 17941, buff = 31946 }, -- Mennu the Betrayer with Corrupted Nova

    -- Karazhan
    { unitID = 15688, buff = 29506 }, -- Prince Malchezaar Enfeeble immunity

    -- Black Temple
    { unitID = 22917, buff = 41252 }, -- Illidan Stormrage Demon Form transition
    { unitID = 22948, buff = 41083 }, -- Reliquary of Souls Deaden immunity

    -- Sunwell Plateau
    { unitID = 25315, buff = 45996 }, -- Kil'jaeden with Shield Orb immunity
    { unitID = 25840, buff = 46102 }, -- M'uru Entropius transformation

    --[[===========================]]
    --[[  WRATH OF THE LICH KING (80) ]]
    --[[===========================]]

    -- Ahn'kahet: The Old Kingdom
    { unitID = 29309, buff = 56153 }, -- Elder Nadox Guardian Aura immunity (from Ahn'kahar Guardian)

    -- Violet Hold
    { unitID = 31134, buff = 58040 }, -- Cyanigosa Arcane Vacuum immunity

    -- Halls of Lightning
    { unitID = 28586, buff = 52770 }, -- General Bjarngrim Defensive Stance
    { unitID = 28923, buff = 52770 }, -- Loken Lightning Nova immunity

    -- Culling of Stratholme
    { unitID = 26532, buff = 52550 }, -- Chrono-Lord Epoch Time Warp immunity
    { unitID = 32273, buff = 58817 }, -- Infinite Corruptor Dark Channeling

    -- Pit of Saron
    { unitID = 36494, buff = 70292 }, -- Forgemaster Garfrost Permafrost immunity
    { unitID = 36658, buff = 69167 }, -- Scourgelord Tyrannus Unholy Power

    -- Halls of Reflection
    { unitID = 38112, buff = 72198 }, -- Lich King Remorseless Winter immunity

    -- Naxxramas (Wrath)
    { unitID = 15990, buff = 28732 }, -- Kel'Thuzad Frost Blast immunity
    { unitID = 16061, buff = 28776 }, -- Four Horsemen immunity shield

    -- Ulduar
    { unitID = 33186, buff = 64320 }, -- Razorscale Devouring Flame
    { unitID = 33993, buff = 64474 }, -- Yogg-Saron Weakened immunity phase
    { unitID = 33271, buff = 63276 }, -- General Vezax Shadow Crash immunity

    -- Trial of the Crusader
    { unitID = 34497, buff = 66237 }, -- Faction Champions Bladestorm immunity
    { unitID = 34564, buff = 68154 }, -- Anub'arak Submerge immunity

    -- Icecrown Citadel
    { unitID = 36855, buff = 70447 }, -- Lady Deathwhisper Mana Barrier (phase 1)
    { unitID = 37813, buff = 69762 }, -- Deathbringer Saurfang Rune of Blood immunity
    { unitID = 36626, buff = 70126 }, -- Festergut Gastric Bloat immunity
    { unitID = 37025, buff = 72257 }, -- Blood Prince Council Invocation of Blood immunity
    { unitID = 36853, buff = 72350 }, -- Sindragosa Frost Beacon (don't break early)
    { unitID = 36597, buff = 70541 }, -- The Lich King Remorseless Winter immunity

    --[[===========================]]
    --[[  CATACLYSM (85)           ]]
    --[[===========================]]

    -- Throne of the Tides
    { unitID = 40586, buff = 76047 }, -- Lady Naz'jar Water Shield
    { unitID = 40765, buff = 76815 }, -- Commander Ulthok Dark Fissure immunity

    -- Vortex Pinnacle
    { unitID = 43878, buff = 87761 }, -- Grand Vizier Ertan Cyclone Shield
    { unitID = 43875, buff = 88282 }, -- Asaad Supremacy of the Storm

    -- Stonecore
    { unitID = 43438, buff = 92633 }, -- High Priestess Azil Gravity Well immunity
    { unitID = 43214, buff = 86855 }, -- Slabhide Lava Fissure immunity

    -- Grim Batol
    { unitID = 40177, buff = 76634 }, -- Forgemaster Throngus Disorienting Roar
    { unitID = 40319, buff = 75890 }, -- Drahga Shadowburner Burning Shadowbolt immunity

    -- Blackrock Caverns
    { unitID = 39679, buff = 75850 }, -- Corla Herald of Twilight Evolution shield

    -- Lost City of Tol'vir
    { unitID = 44819, buff = 83790 }, -- Siamat Gathered Storm immunity

    -- Halls of Origination
    { unitID = 39732, buff = 76394 }, -- Setesh Shield of the Ancestors immunity

    -- Deadmines (Heroic)
    { unitID = 49671, buff = 92620 }, -- Vanessa VanCleef Nightmares immunity phase

    -- Shadowfang Keep (Heroic)
    { unitID = 4278, buff = 93685 }, -- Commander Springvale Shield of the Perfidious

    -- End Time
    { unitID = 54432, buff = 102149 }, -- Echo of Tyrande Tears of Elune immunity

    -- Well of Eternity
    { unitID = 55085, buff = 105496 }, -- Peroth'arn Fel Flames immunity

    -- Zul'Aman (Heroic)
    { unitID = 23574, buff = 42471 }, -- Akil'zon Electrical Storm immunity
    { unitID = 24239, buff = 43303 }, -- Hex Lord Malacrass Spirit Bolts immunity

    -- Zul'Gurub (Heroic)
    { unitID = 52258, buff = 96776 }, -- Gri'lek Pursuit immunity
    { unitID = 52271, buff = 96914 }, -- Hazza'rah Chain Lightning immunity

    -- Hour of Twilight
    { unitID = 54968, buff = 103151 }, -- Archbishop Benedictus Purifying Light immunity
    { unitID = 54432, buff = 103414 }, -- Benedictus Twilight Shear immunity

    -- Blackwing Descent
    { unitID = 41570, buff = 79339 }, -- Magmaw Lava Pillar immunity
    { unitID = 41442, buff = 77679 }, -- Atramedes Sonar Bomb shield
    { unitID = 43687, buff = 88835 }, -- Maloriak Phase transition shield

    -- Bastion of Twilight
    { unitID = 45993, buff = 83718 }, -- Halfus Dragon immunity shield
    { unitID = 45992, buff = 92173 }, -- Valiona Blackout immunity

    -- Throne of the Four Winds
    { unitID = 46753, buff = 89668 }, -- Al'Akir Wind Burst immunity

    -- Firelands
    { unitID = 52498, buff = 100456 }, -- Beth'tilac Widow's Kiss (on ceiling)
    { unitID = 53691, buff = 101410 }, -- Shannox Frenzy immunity
    { unitID = 52530, buff = 99516 }, -- Alysrazor Blazing Power immunity

    -- Dragon Soul
    { unitID = 55294, buff = 109476 }, -- Ultraxion Hour of Twilight immunity
    { unitID = 56427, buff = 106794 }, -- Warmaster Blackhorn Deck Fire immunity
    { unitID = 56846, buff = 105479 }, -- Spine of Deathwing Armor immunity

    --[[===========================]]
    --[[  MISTS OF PANDARIA CLASSIC ]]
    --[[===========================]]

    -- Temple of the Jade Serpent
    { unitID = 56448, buff = 106062 }, -- Wise Mari with Water Shield bubble
    { unitID = 56765, buff = 106113 }, -- Sha of Doubt phase transition

    -- Stormstout Brewery
    { unitID = 56637, buff = 114548 }, -- Ook-Ook Going Bananas immunity
    { unitID = 59479, buff = 115003 }, -- Yan-Zhu Wall of Suds

    -- Mogu'shan Palace
    { unitID = 61567, buff = 120201 }, -- Xin the Weaponmaster Blade Trap
    { unitID = 61398, buff = 119946 }, -- Gekkan Reckless Inspiration

    -- Shado-Pan Monastery
    { unitID = 56747, buff = 110945 }, -- Gu Cloudstrike with Charging Soul
    { unitID = 56747, buff = 110852 }, -- Gu Cloudstrike phase immunity
    { unitID = 56541, buff = 106062 }, -- Master Snowdrift Fists of Fury

    -- Gate of the Setting Sun
    { unitID = 56636, buff = 107120 }, -- Commander Ri'mok Viscous Fluid
    { unitID = 56877, buff = 107268 }, -- Saboteur Kip'tilak Sabotage phase

    -- Siege of Niuzao Temple
    { unitID = 61567, buff = 121282 }, -- Vizier Jin'bak Detonate
    { unitID = 62205, buff = 119073 }, -- Wing Leader Ner'onok Gusting Winds

    -- Scarlet Halls
    { unitID = 59303, buff = 113395 }, -- Armsmaster Harlan Bladestorm

    -- Scarlet Monastery
    { unitID = 3976, buff = 116266 }, -- Commander Mograine Divine Shield
    { unitID = 60033, buff = 115458 }, -- Thalnos the Soulrender Spirit Gale

    -- Scholomance
    { unitID = 59153, buff = 111610 }, -- Instructor Chillheart Phylactery
    { unitID = 58791, buff = 111606 }, -- Rattlegore Rusting shield

    -- Mogu'shan Vaults (Raid)
    { unitID = 60047, buff = 116829 }, -- Stone Guards Solid Stone
    { unitID = 60009, buff = 116778 }, -- Feng the Accursed Epicenter

    -- Heart of Fear (Raid)
    { unitID = 62980, buff = 123081 }, -- Imperial Vizier Zor'lok Attenuation
    { unitID = 62837, buff = 123600 }, -- Blade Lord Ta'yak Intensify
    { unitID = 62543, buff = 123707 }, -- Empress Shek'zeer Dissonance Field

    -- Terrace of Endless Spring (Raid)
    { unitID = 62919, buff = 123244 }, -- Lei Shi Hide (vanish phase)
    { unitID = 60410, buff = 119626 }, -- Tsulong day phase immunity

    -- Throne of Thunder (Raid)
    { unitID = 68476, buff = 136413 }, -- Horridon Dinomancy Shield
    { unitID = 68397, buff = 134691 }, -- Council of Elders Blessed Loa Spirit
    { unitID = 69427, buff = 137654 }, -- Tortos Spinning Shell
    { unitID = 68036, buff = 134378 }, -- Ji-Kun Daedelian Wings (flight)
    { unitID = 69712, buff = 140014 }, -- Durumu Light Spectrum
    { unitID = 68078, buff = 136216 }, -- Lei Shen Static Shock

    -- Siege of Orgrimmar (Raid)
    { unitID = 71734, buff = 144351 }, -- Sha of Pride Corrupted Prison
    { unitID = 71515, buff = 143574 }, -- Norushen Test realm
    { unitID = 71479, buff = 143480 }, -- Malkorok Ancient Barrier
    { unitID = 71466, buff = 143593 }, -- Iron Juggernaut Borer Drill
    { unitID = 71858, buff = 142864 }, -- Thok Deafening Screech
    { unitID = 71543, buff = 143502 }, -- Siegecrafter Blackfuse Protective Frenzy
    { unitID = 71152, buff = 145071 }, -- Paragons Genetic Alteration
    { unitID = 71865, buff = 144945 }, -- Garrosh Hellscream Iron Star phase

    --[[===========================]]
    --[[  LATER EXPANSIONS (KEEP)  ]]
    --[[===========================]]

    -- Iron Docks
    { unitID = 87451, buff = 164504, spell = 164426 }, --Fleshrender Nok'gar, do not attack during defensive stance buff, Todo: Should stop when he cast 164504
    { unitID = 1, buff = 163689 }, -- Never attack Sanguine Sphere
    { unitID = 105906, buff = 209915 }, -- Don't attack The Eye of Il'gynoth when it has Stuff of Nightmares buff
    { unitID = 95887, buff = 194323 }, -- Don't attack Glazer when he casts Focusing
    { unitID = 95888, buff = 205004 }, -- Don't attack Cordana Felsong when she casts Vengeance
    { unitID = 95888, buff = 197422 }, -- Don't attack Cordana Felsong when she casts Creeping Doom
    { unitID = 112956, buff = 225840 }, -- Don't attack Shimmering Manaspine
    { unitID = 104154, buff = 206516 }, -- Don't attack Gul'dan when he is in The Eye of Aman'Thul cage
    -- Nighthold: Mythic Spellblade - Fel Soul
    { unitID = 115905 },
    -- Tomb of Sargeras
    { unitID = 116689, buff = 233441 }, -- Don't attack Atrigan while Bonesaw
    { unitID = 116691, buff = 235230 }, -- Don't attack Belac while Fel Squall
    { unitID = 117264, buff = -241008 }, -- Don't attack Maiden of Valor unless Buff is Present *** negative buff value denotes not present ***
    -- BfA
    -- Uldir
    { unitID = 137119, buff = 271965 }, -- Don't attack Taloc while Powered Down
    { unitID = 131227, buff = 260189 }, -- Motherlode last boss flight
    { unitID = 136383, buff = 274230 }, -- Mythrax immunity
    -- Battle of Dazar'alor
    { unitID = 144683, buff = 284436 }, -- Champion of the Light (A), Ra'wani Kanae, Seal of Reckoning
    { unitID = 144680, buff = 284436 }, -- Champion of the Light (H), Frida Ironbellows, Seal of Reckoning
    { unitID = 144942, buff = 289644 }, -- Spark Bot,High Tinker Mekkatorque, Mythic
    { unitID = 145644, buff = 284377 }, -- Bwonsamdi with Unliving buff
    -- The Motherlode!
    { unitID = 129232, buff = 260189 }, -- Mogul Razdunk with Configuration: Drill buff
    -- The Shrine
    { unitID = 135903 }, -- Little exploding adds on last boss
    -- Underrot
    { unitID = 137458 }, -- Rotting Spore
    -- Siege of Boralus
    { unitID = 128652 }, -- Viq'Goth
    -- Atal'Dazar
    { unitID = 129399, buff = 250192 }, -- Vol'kaal with Bad Voodoo buff
    -- Temple of Sethraliss
    { unitID = 133379, buff = 263246 }, -- Adderis with Lightning Shield
    { unitID = 133944, buff = 263246 }, -- Aspix with Lightning Shield
    -- Tol Dagor
    { unitID = 133972 }, -- Heavy Cannon
    -- Mechagon
    { unitID = 152703 }, -- Walkie Shockie X1
    -- Eternal Palace
    { unitID = 152364, buff = 295916 }, -- Radiance of Azshara
    { unitID = 155434, buff = 302415 }, -- Emissary of Tides Teleporting Home
    { unitID = 155432, buff = 302415 }, -- Enchanted Emissary Teleporting Home
    { unitID = 155433, buff = 302415 }, -- Void Touched Emissary Teleporting Home
    -- Mythic Za'qul
    { unitID = 150859, buff = 301117 }, -- Dark Shield
    -- Eternal Palace
    { unitID = 155126, buff = 300620 }, -- Crystalline Shield
    -- Horrific Visions
    { unitID = 158315 }, -- Eye of Chaos
    --Prophey Skitra
    { unitID = 160904, buff = 313208 }, -- Image of Absolution with Intangible Illusion buff
    -- N'zoth
    { unitID = 158041, buff = 310126 }, -- Psychic Shell
    -- Tol Dagor
    { unitID = 133972 }, -- Cannon in Tol Dagor
    { unitID = 160652 }, -- Void Tentacle

    -- Shadowlands
  --  { unitID = 174773}, -- Spiteful Shade
    -- Dungeons
    -- The Necrotic Wake
    { unitID = 162689, buff = 326629 }, -- Surgeon Stitchflesh with Noxious Fog buff
    { unitID = 166079, buff = 321576 }, -- can't kill them with this aura up
    { unitID = 163126, buff = 321576 }, -- can't kill them with this aura up
    { unitID = 163122, buff = 321576 }, -- can't kill them with this aura up
    -- Hall of Atonement
    { unitID = 165913 }, -- https://www.wowhead.com/npc=165913/ghastly-parishioner
    -- De Other Side
    { unitID = 167966 }, -- https://www.wowhead.com/npc=167966/experimental-sludge
    { unitID = 170483 }, -- https://www.wowhead.com/npc=170483/atalai-deathwalkers-spirit
    -- Mists Of Tirna Scithe
    { unitID = 165251 }, -- https://www.wowhead.com/npc=165251/illusionary-vulpin
    { unitID = 164501, buff = 336499 }, -- Mistcaller takes 100% less damage while playing Guessing Game

    -- Castle Nathria
    { unitID = 164406, buff = 328921 }, -- Don't attack Shriekwing when it casts Blood Shroud
    { unitID = 1, buff = 346694 }, -- https://www.wowhead.com/spell=346694/unyielding-shield
    { unitID = 1, buff = 329636 }, -- General Kaal with Hardened Stone Form
    { unitID = 1, buff = 329636 }, -- General Grashaal with Hardened Stone Form
    { unitID = 1, buff = 346694 }, -- General Grashaal with Hardened Stone Form
    { unitID = 168962}, -- Sun King's Reborn Phoenix
}
