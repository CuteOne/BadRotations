function PokeCollections()
  --[[                                       Collections                                             ]]

  -- Collections
  if not LoadAllLists then
    LoadAllLists = true

    --Remove Debuffs/Buffs
    --667, Aged Yolk
    --763, Sear Magic
    --835, Eggnog
    --941, High Fiber

    --Only works if at least one ally is dead
    --665, Consume Corpse

    -- AoE Attacks to be used only while there are 3 Enemies.
    AoEPunchList = {
      299, -- Arcane Explosion
      319, -- Magma Wave
      387, -- Tympanic Tantrum
      404, -- Sunlight
      419, -- Tidal Wave
      668, -- Dreadfull Breath
      644, -- Quake
      649, -- BONESTORM
      741, -- Whirlwind
      768, -- Omnislash
      774, -- Rapid Fire
      923, -- Flux
    }

    -- Roots and other buffs. These debuff on us will disable Pet Swap.
    BuffNoSwap  = {
      248, -- Rooted
      294, -- Charging Rocket
      302, -- Planted
      338, -- Webbed
      370, -- Sticky Goo
    }

    -- Abilities that give immunity on the next spell
    CantDieList = {
      284, -- Survival
    }

    -- Attacks that are stronger if the ennemi have more life than us.
    ComebackList = {
      253, -- Comeback
      405, -- Early Advantage
    }

    -- Damage Buffs that we want to cast on us.
    DamageBuffList = {
      188, -- Accuracy
      197, -- Adrenal Glands
      216, -- Inner Vision
      223, -- Focus Chi
      252, -- Uncanny Luck
      263, -- Crystal Overload
      279, -- Heartbroken
      347, -- Roar
      375, -- Trumpet Strike
      426, -- Focus
      488, -- Amplify Magic
      521, -- Hawk Eye
      536, -- Prowl
      589, -- Arcane Storm
      614, -- Competitive Spirit
      740, -- Frenzyheart Brew
      791, -- Stimpack
      809, -- Roll
      936, -- Caw

    }

    -- Debuff to cast on ennemy. This list will check for Abilit-1 debuffs.
    DeBuffList = {
      --650, -- Bone Prison (Roots)
      152, -- Poison Fang
      155, -- Hiss
      167, -- Nut Barrage
      176, -- Volcano
      178, -- Immolate
      179, -- Conflagrate
      204, -- Call Lightning
      206, -- Call Blizzard
      212, -- Siphon Life
      248, -- Rooted
      249, -- Grasp
      305, -- Exposed Wounds
      314, -- Mangle
      339, -- Sticky Web
      352, -- Banana Barrage
      359, -- Sting
      369, -- Acidic Goo
      371, -- Sticky Goo
      380, -- Poison Spit
      382, -- Brittle Webbing
      398, -- Poison Lash
      411, -- Woodchipper
      447, -- Corrosion
      463, -- Flash
      497, -- Soothe
      501, -- Flame Breath
      515, -- Flyby
      524, -- Squawk
      527, -- Stench
      592, -- Wild Magic
      628, -- Rock Barrage
      630, -- Poisoned Branch
      631, -- Super Sticky Goo
      642, -- Egg Barrage
      743, -- Creeping Fungus
      756, -- Acid Touch
      784, -- Shriek
      786, -- Blistering Cold
      803, -- Rip
      811, -- Magma Trap
      909, -- Paralyzing Shock
      919, -- Black Claw
      932, -- Croak
      964, -- Autumn Breeze
    }

    SpecialDebuffsList = {
      { 	Ability = 270, 	Debuff = 271 	}, -- Glowing Toxin
      {	Ability = 362,  Debuff = 542	}, -- Howl
      { 	Ability = 448, 	Debuff = 781 	}, -- Creeping Ooze
      {	Ability = 468,  Debuff = 469	}, -- Agony
      {	Ability = 522,  Debuff = 738	}, -- Nevermore
      {	Ability = 580,  Debuff = 498    }, -- Food Coma/ Asleep
      { 	Ability = 632, 	Debuff = 633 	}, -- Confusing Sting
      { 	Ability = 657, 	Debuff = 658 	}, -- Plagued Blood
      { 	Ability = 784, 	Debuff = 494 	}, -- Shriek/ Attack Reduction
      {	Ability = 869,  Debuff = 153	}, -- Darkmoon Curse/ Attack Reduction
      {	Ability = 486,  Debuff = 153	}, -- Drain Power/ Attack Reduction
      {	Ability = 940,  Debuff = 939    }, -- Touch of the Animus
    }

    -- Abilities used to Deflect
    DeflectorList = {
      312, -- Dodge
      440, -- Evanescence
      490, -- Deflection
      764, -- Phase Shift
    }

    ExecuteList = {
      538, -- Devour
      802, -- Ravage
      917, -- Bloodfang
    }

    -- Apocalypse.
    FifteenTurnList = {
      519, -- Apocalypse
    }
    MeteorStrikeList = {
      518, -- Apocalypse
      519, -- Apocalypse
    }

    KamikazeList = {
      282, -- Explode
      321, -- Unholy Ascension
      568, -- Feign Death
      652, -- Haunt
      663, -- Corpse Explosion
    }

    -- Abilities to be cast to heal ouself instantly.
    HealingList = {
      123, -- Healing Wave
      168, -- Healing Flame
      173, -- Cautherize
      230, -- Cleansing Rain
      247, -- Hibernate
      273, -- Wish
      278, -- Repair
      298, -- Inspiring Song
      383, -- Leech Life
      533, -- Rebuild
      539, -- Bleat
      573, -- Nature's Touch
      576, -- Perk Up
      578, -- Buried Treasure
      598, -- Emerald Dream
      611, -- Ancient Blessing
      745, -- Leech Seed
      770, -- Restoration
      776, -- Love Potion
      922, -- Healing Stream
      -- Leech
      121, -- Death Coil
      160, -- Consume
      449, -- Absorb
      937, -- Siphon Anima
    }

    HighDamageIfBuffedList = {
      {	Ability = 221,  Debuff = 927	}, -- Takedown if Stunned
      {	Ability = 221,  Debuff = 174	}, -- Takedown if Stunned (second stun ID)
      {	Ability = 250,  Debuff = 338	}, -- Spiderling Swarm if Webbed
      { 	Ability = 423, 	Debuff = 491 	}, -- Blood in the Water if Bleeding.
      {	Ability = 461,  Debuff = 462	}, -- Light if Blinded
      {	Ability = 461,  Debuff = 954	}, -- Light if Blinded (second ID)
      { 	Ability = 345, 	Debuff = 491 	}, -- Maul if Bleeding.
    }
    HighDMGList = {
      908, -- Jolt

      120, -- Howling Blast
      170, -- Lift-Off
      172, -- Scorched Earth
      179, -- Conflagrate
      158, -- Counterstrike
      186, -- Reckless Strike
      204, -- Call Lightning
      209, -- Ion Cannon
      226, -- Fury of 1,000 Fists
      256, -- Call Darkness
      258, -- Starfall
      330, -- Sons of the Flame
      345, -- Maul
      348, -- Maul (Stun)
      376, -- Headbutt
      400, -- Entangling Roots
      402, -- Stun Seed
      414, -- Frost Nova
      442, -- Spectral Strike
      450, -- Expunge
      453, -- SandStorm
      456, -- Clean-Up
      457, -- Sweep
      460, -- Illuminate
      466, -- Nether Gate
      481, -- Deep Freeze
      493, -- Hoof
      506, -- Cocoon Strike
      508, -- Mosth Dust
      517, -- Nocturnal Strike
      518, -- Predatory Strike
      532, -- Body Slam
      541, -- Chew
      572, -- MudSlide
      586, -- Gift of Winter's Veil
      593, -- Surge of Power
      595, -- Moonfire
      607, -- Cataclysm
      609, -- Instability
      612, -- Proto-Strike
      621, -- Stone Rush
      645, -- Launch
      646, -- Shock and Awe
      649, -- Bone Storm
      669, -- Backflip
      746, -- Spore Shrooms
      752, -- Soulrush
      753, -- Solar Beam
      761, -- Heroic Leap
      762, -- Haymaker
      767, -- Holy Charge
      769, -- Surge of Light
      773, -- Shot Through The Heart
      777, -- Missile
      779, -- Thunderbolt
      788, -- Gauss Rifle
      792, -- Darkflame
      812, -- Sulfuras Smash
      814, -- Rupture
      912, -- QuickSand
      913, -- Spectral Spine
      916, -- Haywire
      942, -- Frying Pan

    }

    -- Buffs that heal us.
    HoTBuffList = {
      267, -- Phytosynthesis
      303, -- Plant
      574, -- Nature's Ward

    }
    -- Buffs that heal us.
    HoTList = {
      160, -- Consume
      230, -- Cleansing Waters
      268, -- Phytosynthesis
      302, -- Planted
      820, -- Nature's Ward
    }

    ImmunityList = {
      311, -- Dodge
      331, -- Submerged
      341, -- Flying
      340, -- Burrowed
      505, -- Cocoon Strike
      830, -- Dive
      839, -- Leaping
      852, -- Flying (Launch)
      926, -- Soothe
    }

    LastStandList = {
      283, -- Survival
      568, -- Feign Death
      576, -- Perk Up
      611, -- Ancient Blessing
      794, -- Dark Rebirth
    }

    LifeExchangeList = {
      277, -- Life Exchange
    }

    -- Attack that will damage next turn.
    OneTurnList = {
      159, -- Burrow
      407, -- Meteor Strike
      564, -- Dive
      606, -- Elementium Bolt
      645, -- Launch
      828, -- Sons of the Root
    }

    -- Attacks to be used for Pet Leveling
    PetLevelingList = {
      -- High Priority

      -- Low Priority
      155, -- Hiss
      492, -- Rake
    }

    -- Basic attacks
    PunchList = {
      -- High Priority
      156, -- Vicious Fang
      169, -- Deep Breath
      233, -- Frog Kiss
      293, -- Launch Rocket
      297, -- Pump
      301, -- Lock-On
      323, -- Gravity
      354, -- Barrel Toss
      377, -- Trample
      411, -- Woodchipper
      413, -- Ice Lance
      437, -- Onyx Bite
      459, -- Wind-Up
      471, -- Weakness
      476, -- Dark Simulacrum
      507, -- Moth Balls
      508, -- Moth Dust
      509, -- Surge
      529, -- Belly Slide
      563, -- Quick Attack
      566, -- Powerball
      594, -- Sleeping Gas
      616, -- Blinkstrike
      754, -- Screeching Gears
      765, -- Holy Sword
      775, -- Perfumed Arrow
      778, -- Charge
      849, -- Huge, Sharp Teeth!
      921, -- Hunting Party
      930, -- Huge Fang
      943, -- Chop
      958, -- Trihorn Charge
      -- Normal Priority
      110, -- Bite
      111, -- Punch
      112, -- Peck
      113, -- Burn
      114, -- Beam
      115, -- Breath
      116, -- Zap
      117, -- Infected Claw
      118, -- Water Jet
      119, -- Scratch
      121, -- Death Coil (Heal)
      122, -- Tail Sweep
      163, -- Stampede
      184, -- Quills
      193, -- Flank
      202, -- Trash
      210, -- Shadow Slash
      219, -- Jab
      276, -- Swallow You Whole
      347, -- Roar
      349, -- Smash
      355, -- Triple Snap
      356, -- Snap
      360, -- Flurry
      367, -- Chomp
      378, -- Strike
      384, -- Metal Fist
      390, -- Demolish
      393, -- Shadowflame
      406, -- Crush
      420, -- Slicing Wind
      421, -- Arcane Blast
      422, -- Shadow Shock
      424, -- Tail Slap
      429, -- Claw
      432, -- Jade Claw
      445, -- Ooze Touch
      449, -- Absorb
      452, -- Broom
      455, -- Batter
      472, -- Blast of Hatred
      473, -- Focused Beams
      474, -- Interupting Gaze
      477, -- Snowball
      478, -- Magic Hat
      482, -- Laser
      483, -- Psychic Blast
      484, -- Feedback
      492, -- Rake
      499, -- Diseased Bite
      514, -- Wild Winds
      525, -- Emerald Bite
      528, -- Frost Spit
      608, -- Nether Blast
      617, -- Spark
      626, -- Skitter
      630, -- Poisoned Branch
      648, -- Bone Bite
      668, -- Dreadfull Breath
      712, -- Railgun
      713, -- Blitz
      771, -- Bow Shot
      782, -- Frost Breath
      789, -- U-238 Rounds
      800, -- Impale
      801, -- Stone Shot
      826, -- Weakening Blow
      901, -- Fel Immolate
      910,  -- Sand Bolt
      -- Low Priority
      167, -- Nut Barrage
      253, -- Comeback
      307, -- Kick
      383, -- Leech Life
      389, -- Overtune
      501, -- Flame Breath
      504, -- Alpha Strike
      509, -- Surge
      -- Three Turns
      124, -- Rampage
      163, -- Stampede
      198, -- Zergling Rush
      581, -- Flock
      666, -- Rabid Bite
      668, -- Dreadful Breath
      706, -- Swarm
      870, -- Murder
    }

    -- Attacks that are stronger if we are quicker.
    QuickList = {
      184, -- Quills
      202, -- Thrash
      228, -- Tongue Lash
      307, -- Kick
      360, -- Flurry
      394, -- Lash
      412, -- Gnaw
      441, -- Rend
      455, -- Batter
      474, -- Interrupting Gaze
      504, -- Alpha Strike
      535, -- Pounce
      571, -- Horn Attack
      617, -- Spark
      789, -- U-238 Rounds
      938, -- Interrupting Jolt
    }

    -- List of Buffs that we want to cast on us.
    SelfBuffList = {
      259, -- Invisibility
      318, -- Thorns
      315, -- Spiked Skin
      325, -- Beaver Dam
      366, -- Dazzling Dance
      409, -- Immolation
      426, -- Focus
      444, -- Prismatic Barrier
      479, -- Ice Barrier
      486, -- Drain Power
      488, -- Amplify Magic
      757, -- Lucky Dance
      905, -- Cute Face
      906, -- Lightning Shield
      914, -- Spirit Spikes
      944, -- Heat Up
      962, -- Ironbark
      -- Damage
      188, -- Accuracy
      197, -- Adrenal Glands
      208, -- Supercharge
      216, -- Inner Vision
      263, -- Crystal Overload
      279, -- Heartbroken
      347, -- Roar
      375, -- Trumpet Strike
      488, -- Amplify Magic
      520, -- Hawk Eye
      589, -- Arcane Storm
      791, -- Stimpack
    }

    SpecialSelfBuffList = {
      { 	Ability = 597, 	Buff = 823 	}, -- Emerald Presence
      {	Ability = 851,  Buff = 544	}, -- Vicious Streak
      {	Ability = 364,  Buff = 544	}, -- Leap
      {	Ability = 567,  Buff = 544	}, -- Rush
      {	Ability = 579,  Buff = 735	}, -- Gobble Strike
      {	Ability = 957,  Buff = 485	}, -- Evolution
    }

    ShieldBuffList = {
      165, -- Crouch
      225, -- Staggered Steps
      310, -- Shell Shield
      334, -- Decoy
      392, -- Extra Plating
      431, -- Jadeskin
      436, -- Stoneskin
      465, -- Illusionary Barrier
      751, -- Soul Ward
      760, -- Shield Block
      934, -- Bubble
      960, -- Trihorn Shield
    }

    SlowPunchList = {
      228, -- Tongue Lash
      233, -- Frog Kiss
      360, -- Flurry
      377, -- Trample
      390, -- Demolish
      394, -- Lash
      455, -- Batter
      475, -- Eyesurge
      529, -- Belly Slide
    }

    SootheList = {
      497, -- Soothe
    }

    SpeedBuffList = {
      162, -- Adrenaline Rush
      194, -- Metabolic Boost
      389, -- Overtune
      838, -- Centrifugal Hooks
    }

    SpeedDeBuffList = {
      357, -- Screech - 25%
      416, -- Frost Shock - 25%
      475, -- Eyeblast
      929, -- Slither
    }

    -- Pass Turn
    StunnedDebuffs = {
      499,
      823,
      926, -- Soothe
      928,
    }

    StunList = {
      227, -- Blackout Kick
      348, -- Bash
      350, -- Clobber
      569, -- Crystal Prison
      654, -- Ghostly Bite
      670, -- Snap Trap
      766, -- Holy Justice
      772, -- LoveStruck
      780, -- Death Grip
    }

    SuicideList = {
      282, -- Explode
      321, -- Unholy Ascension
      836, -- Baneling Burst
      652, -- Haunt
      663, -- Corpse Explosion
    }

    SwapoutDebuffList  = {
      358, --
      379, -- Poison Spit
      822, -- Frog Kiss
    }

    TeamDebuffList = {
      167, -- Nut Barrage
      190, -- Cyclone
      214, -- Death and Decay
      232, -- Swarm of Flies
      503, -- Flamethrower
      575, -- Slippery Ice
      640, -- Toxic Smoke
      642, -- Egg Barrage
      644, -- Rock Barrage
      860, -- Flamethrower
      920, -- Primal Cry
    }

    -- Attack that will damage in three turns.
    ThreeTurnList = {
      386, -- XE-321 Boombot
      513, -- Whirlpool
      634, -- Minefield
      418, -- Geyser
      606, -- Elementium Bolt
      647, -- Bombing Run
    }

    ThreeTurnHighDamageList = {
      124, -- Rampage
      218, -- Curse of Doom
      489, -- Mana Surge
      624, -- Ice Tomb
      636, -- Sticky Grenade
      917, -- Bloodfang
    }

    -- Attacks to Deflect.
    ToDeflectList = {
      296, -- Pumped Up
      331, -- Submerged
      340, -- Burrow
      353, -- Barrel Ready
      341, -- Lift-Off
      830, -- Dive
      839, -- Leaping

    }

    TeamHealBuffsAbilities = {
      511, -- Renewing Mists
      539, -- Bleat
      254, -- Tranquility
    }

    TeamHealBuffsList = {
      510, -- Renewing Mists
      255, -- Tranquility
    }

    TurretsList = {
      710, -- Build Turret
    }


    -- List of Pets to chase.
    MopList = {
      "Adder",
      "Alpine Chipmunk",
      "Alpine Foxling",
      "Alpine Foxling Kit",
      "Alpine Hare",
      "Amber Moth",
      "Amethyst Spiderling",
      "Anodized Robo Cub",
      "Arctic Fox Kit",
      "Ash Lizard",
      "Ash Viper",
      "Baby Ape",
      "Bandicoon",
      "Bandicoon Kit",
      "Bat",
      "Beetle",
      "Biletoad",
      "Black Lamb",
      "Black Rat",
      "Blighted Squirrel",
      "Blighthawk",
      "Borean Marmot",
      "Bucktooth Flapper",
      "Cat",
      "Cheetah Cub",
      "Chicken",
      "Clefthoof Runt",
      "Clouded Hedgehog",
      "Cockroach",
      "Cogblade Raptor",
      "Coral Adder",
      "Coral Snake",
      "Crested Owl",
      "Crimson Geode",
      "Crimson Shale Hatchling",
      "Crystal Beetle",
      "Crystal Spider",
      "Dancing Water Skimmer",
      "Darkshore Cub",
      "Death's Head Cockroach",
      "Desert Spider",
      "Dragonbone Hatchling",
      "Dung Beetle",
      "Effervescent Glowfly",
      "Elder Python",
      "Electrified Razortooth",
      "Elfin Rabbit",
      "Emerald Boa",
      "Emerald Proto-Whelp",
      "Emerald Shale Hatchling",
      "Emerald Turtle",
      "Emperor Crab",
      "Eternal Strider",
      "Fawn",
      "Fel Flame",
      "Festering Maggot",
      "Fire Beetle",
      "Fire-Proof Roach",
      "Fledgling Nether Ray",
      "Fjord Rat",
      "Fjord Worg Pup",
      "Forest Moth",
      "Fluxfire Feline",
      "Frog",
      "Fungal Moth",
      "Gazelle Fawn",
      "Gilded Moth",
      "Giraffe Calf",
      "Gold Beetle",
      "Golden Civet",
      "Golden Civet Kitten",
      "Grasslands Cottontail",
      "Grassland Hopper",
      "Grasslands Cottontail",
      "Grey Moth",
      "Grizzly Squirrel",
      --"Grove Viper",
      "Hare",
      "Harpy Youngling",
      "Highlands Mouse",
      "Highlands Skunk",
      "Highlands Turkey",
      "Horned Lizard",
      "Horny Toad",
      "Huge Toad",
      "Imperial Eagle Chick",
      "Infected Fawn",
      "Infected Squirrel",
      "Infinite Whelping",
      "Irradiated Roach",
      --"Jumping Spider",
      "Jungle Darter",
      "Jungle Grub",
      "King Snake",
      "Kuitan Mongoose",
      "Kun-Lai Runt",
      "Larva",
      "Lava Crab",
      "Leopard Scorpid",
      "Leopard Tree Frog",
      "Little Black Ram",
      "Locust",
      "Lofty Libram",
      "Lost of Lordaeron",
      "Luyu Moth",
      "Mac Frog",
      "Maggot",
      "Malayan Quillrat",
      "Malayan Quillrat Pup",
      "Marsh Fiddler",
      "Masked Tanuki",
      "Masked Tanuki Pup",
      "Mei Li Sparkler",
      "Mirror Strider",
      "Minfernal",
      "Molten Hatchling",
      "Mongoose Pup",
      "Mountain Skunk",
      "Nether Faerie Dragon",
      "Nether Roach",
      "Nexus Whelpling",
      "Nordrassil Wisp",
      "Oasis Moth",
      "Oily Slimeling",
      "Parrot",
      "Plains Monitor",
      "Prairie Dog",
      "Prairie Mouse",
      "Qiraji Guardling",
      "Rabbit",
      "Rabid Nut Varmint 5000",
      "Rapana Whelk",
      "Rat",
      "Rattlesnake",
      "Ravager Hatchling",
      "Red-Tailed Chipmunk",
      "Resilient Roach",
      "Roach",
      "Robo-Chick",
      "Rock Viper",
      "Ruby Sapling",
      "Rusty Snail",
      "Sand Kitten",
      "Sandy Petrel",
      "Savory Beetle",
      "Scarab Hatchling",
      "Scorpid",
      "Scorpling",
      "Scourged Whelpling",
      "Sea Gull",
      "Sidewinder",
      "Shimmershell Snail",
      "Shrine Fly",
      "Shore Crab",
      "Shy Bandicoon",
      "Sifang Otter",
      "Silent Hedgehog",
      "Silithid Hatchling",
      "Silky Moth",
      "Small Frog",
      "Snake",
      "Snow Cub",
      "Snowy Owl",
      "Softshell Snapling",
      "Spawn of Onyxia",
      "Spiky Lizard",
      "Spiny Lizard",
      "Spiny Terrapin",
      "Spirit Crab",
      "Sporeling Sprout",
      "Spotted Bell Frog",
      "Squirrel",
      "Stinkbug",
      "Stormwind Rat",
      "Stripe-Tailed Scorpid",
      "Stunded Shardhorn",
      "Stunted Yeti",
      "Summit Kid",
      "Sumprush Rodent",
      "Swamp Croaker",
      "Tainted Cockroach",
      "Tainted Moth",
      "Tainted Rat",
      "Thundertail Flapper",
      "Tiny Bog Beast",
      "Tiny Harvester",
      "Tiny Twister",
      "Toad",
      "Tolai Hare",
      "Tol'vir Scarab",
      "Topaz Shale Hatchling",
      "Tree Python",
      "Tundra Penguin",
      "Turkey",
      "Turquoise Turtle",
      "Twilight Beetle",
      "Twilight Fiendling",
      "Unborn Val'kyr",
      "Venomspitter Hatchling",
      "Warpstalker Hatchling",
      "Water Snake",
      "Water Waveling",
      "Wild Crimson Hatchling",
      "Wild Golden Hatchling",
      "Wild Jade Hatchling",
      "Yakrat",
      "Yellow-Bellied Marmot",
      "Zooey Snake",
    }
  end
end
