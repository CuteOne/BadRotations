if br.lists == nil then
    br.lists = {}
end
-- Crowd Control Units = list of units to stun, either always or under certain condition such as having a buff or whirlwind etc
-- example
br.lists.ccUnits = {
    -- Raid
    [167566] = { name = "Return to Stone", spell = 333145 }, -- Sun King's Salvation
    [165762] = { name = "Soul Infuser" }, -- Sun King's Salvation
    -- SL Dungeons
    [174773] = { name = "All-Consuming Spite"}, -- M+ Affix


    [164562] = { name = "Loyal Beasts", spell = 326450 }, -- Halls of Atonement
    [170480] = { name = "Bladestorm", spell = 332671 }, -- De Other Side
    [165251] = { name = "Illusionary Vulpin" }, -- https://www.wowhead.com/npc=165251/illusionary-vulpin

    -- Necrotic Wake
    [164702] = { name = "Carrion Worm" }, -- Necrotic Wake
    [163619] = { name = "Zolramus Bonecarver", spell = 321807 }, -- Zolramus Bonecarver casting Boneflay
    [173016] = { name = "Corpse Collector", spell = 334748 },
    [166302] = { name = "Corpse Collector", spell = 334748 },
    [173044] = { name = "Stitching Assistant", spell = 334748 },
    [165872] = { name = "Stitching Assistant", spell = 327130 },
    [165911] = { name = "Loyal Creation", spell = 327240 },
    [165872] = { name = "Flesh Crafter", spell = 327130 },

    --Theater of Pain
    [164510] = { name = "Shambling Arbalest" }, -- Nasty dot - needs to be cc'ed

    -- Plaguefall
    [171887] = { name = "Slimy Smorgasbord" }, -- Plaguefall Dungeon
    [164737] = { name = "Enveloping Webbing", spell = 328475 }, -- Plaguefall Dungeon
    [168572] = { name = "Fungistorm", spell = 330423 }, -- big AOE, can be stunned
    [168572] = { name = "Fungistorm", spell = 328177 }, -- -- big AOE, can be stunned
    [163862] = { name = "Bulwark of Maldraxxus", spell = 336451 }, -- Prevent the shield from going on



    -- Thorghast
    [150959] = { name = "Critical Shot", spell = 294171 }, -- Torghast Mawsworn Interceptor
    [168107] = { name = "Critical Shot", spell = 164737 }, -- Critical shot, Thorghast

    -- Test unit outside Boralus
    --[123231] = { name = "Sharptail Beaver" },
    -- Visions of Ogrimmar
    [155657] = { name = "Huffer" }, -- Rexxar's pets
    [155952] = { name = "Suffer" }, -- Rexxar's pets
    [155951] = { name = "Ruffer" }, -- Rexxar's pets
    [155953] = { name = "C'Thuffer" }, -- Rexxar's pets
    -- Shadowmoon Burial Grounds
    [75966] = { name = "Defiled Spirit" }, -- need to be cc and snared and is not allowed to reach boss.
    [76446] = { name = "Shadowmoon Enslavers" },
    [75899] = { name = "Possessed Soul" }, -- only for melee i guess
    [79510] = { name = "Crackling Pyromaniacs" },
    -- Grimrail Depot
    [81236] = { name = "Grimrail Technicians", spell = 163966 }, -- channeling Activating
    [80937] = { name = "Gromkar Gunner" },
    -- UBRS
    [76157] = { name = "Black Iron Leadbelcher" }, -- Activates canon, should be when/if moving
    -- Proving Ground
    [71415] = { name = "Banana Tosser", buff = 142639 }, -- Small
    [71414] = { name = "Banana Tosser", buff = 142639 }, -- Large
    -- BFA Dungeons
    [134024] = { name = "Infest", spell = 278444 }, -- Waycrest Manor
    [142587] = { name = "Infest", spell = 278444 }, -- Waycrest Manor
    [133593] = { name = "Repair", spell = 262554 }, -- Motherload
    [152033] = { name = "inconspicuous-plant" }, -- plant boss in workshop
    [152703] = { name = "walkie-shockie-x1" }, --Last boss in Mech Junkyard
    [134331] = { name = "Channel Lightning", spell = 270889 }, -- Motherload
    [129640] = { name = "Clamping Jaws", spell = 256897 }, -- Seige of Boralus
    [131009] = { name = "Spirit of Gold" }, -- AD
    [134388] = { name = "A Knot of Snakes" }, -- temple, snakes!
    [129758] = { name = "Irontide Grenadier" }, --FH last boss
    [129559] = { name = "Duelist Dash", spell = 274400 }, --FREEHOLD Cutwater Duelist
    [130404] = { name = "Rat Traps", spell = 274383 }, --FREEHOLD - VERMIN TRAPPER
    [129527] = { name = "Goin' Bananas", spell = 257756 }, --FREEHOLD - BILGE RAT BUCCANEER
    [139799] = { name = "Whirling Slam", spell = 276292 }, --SHRINE OF THE STORM - IRONHULL APPRENTICE
    [134338] = { name = "Deep Smash", spell = 268273 }, --SHRINE OF THE STORM - TIDESAGE ENFORCER
    [129640] = { name = "Clamping Jaws", spell = 256897 }, -- SIEGE OF BORALUS - SNARLING DOCKHOUND
    [128967] = { name = "Ricochet", spell = 272542 }, -- SIEGE OF BORALUS - ASHVANE SNIPER
    [144170] = { name = "Ricochet", spell = 272542 }, -- SIEGE OF BORALUS - ASHVANE SNIPER
    [137517] = { name = "Ferocity", spell = 272888 }, -- SIEGE OF BORALUS - ASHVANE DESTROYER
    [144168] = { name = "Ferocity", spell = 272888 }, -- SIEGE OF BORALUS - ASHVANE DESTROYER
    [129928] = { name = "Molten Slug", spell = 257641 }, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [129989] = { name = "Molten Slug", spell = 257641 }, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [137521] = { name = "Molten Slug", spell = 257641 }, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [138254] = { name = "Molten Slug", spell = 257641 }, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [138254] = { name = "Molten Slug", spell = 257641 }, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [132491] = { name = "Molten Slug", spell = 257641 }, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [132532] = { name = "Molten Slug", spell = 257641 }, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [141285] = { name = "Molten Slug", spell = 257641 }, -- SIEGE OF BORALUS - Molten Slug (lots of mobs)
    [137614] = { name = "Slam", spell = 269266 }, -- SIEGE OF BORALUS - DEMOLISHING TERROR
    [137625] = { name = "Slam", spell = 269266 }, -- SIEGE OF BORALUS - DEMOLISHING TERROR
    [137626] = { name = "Slam", spell = 269266 }, -- SIEGE OF BORALUS - DEMOLISHING TERROR
    [140447] = { name = "Slam", spell = 269266 }, -- SIEGE OF BORALUS - DEMOLISHING TERROR
    [135699] = { name = "Riot Shield", spell = 258317 }, -- TOL DAGOR - ASHVANE JAILER
    [127486] = { name = "Riot Shield", spell = 258317 }, -- TOL DAGOR - ASHVANE OFFICER
    [130027] = { name = "Suppression Fire", spell = 258864 }, -- TOL DAGOR - ASHVANE MARINE
    [136735] = { name = "Suppression Fire", spell = 258864 }, -- TOL DAGOR - ASHVANE MARINE
    [136665] = { name = "Suppression Fire", spell = 258864 }, -- TOL DAGOR - ASHVANE SPOTTER
    [127497] = { name = "Lockdown", spell = 259711 }, -- TOL DAGOR - ASHVANE WARDEN
    [131445] = { name = "Lockdown", spell = 259711 }, -- TOL DAGOR - BLOCK WARDEN
    [130028] = { name = "Righteous Flames", spell = 258917 }, -- TOL DAGOR - ASHVANE PRIEST
    [131666] = { name = "Uproot", spell = 264038 }, -- WAYCREST MANOR - COVEN THRONSHAPER
    [122971] = { name = "Bwonsamdi's Mantle", spell = 253544 }, -- ATAL'DAZAR - Dazar'ai Confessor
    [122973] = { name = "Merciless Assault", spell = 253239 }, -- ATAL'DAZAR - DAZAR'AI JUGGERNAUT
    [134157] = { name = "Gust Slash", spell = 269931 }, -- KING'S REST - SHADOW-BRONE WARRIOR
    [137473] = { name = "Axe Barrage", spell = 270084 }, -- KING'S REST - GUARD CAPTAIN ATU
    [135167] = { name = "Blooded Leap", spell = 270482 }, -- KING'S REST - SPECTRAL BERSERKER
    [135167] = { name = "Severing Blade", spell = 270487 }, -- KING'S REST - SPECTRAL BERSERKER --https://www.wowhead.com/spell=270487/severing-blade
    [135235] = { name = "Deadeye Shot", spell = 270506 }, -- KING'S REST - SPECTRAL BEASTMASTER
    [135235] = { name = "Poison Barrage", spell = 270507 }, -- KING'S REST - SPECTRAL BEASTMASTER
    -- [130488] = { name = "Activate Mech", spell = 267433 }, -- THE MOTHERLODE!! - MECH JOCKEY
    [134232] = { name = "Hail of Flechettes", spell = 267354 }, -- THE MOTHERLODE!! - HIRED ASSASSIN
    [130635] = { name = "Furious Quake", spell = 268702 }, -- THE MOTHERLODE!! - STONEFURY
    [136934] = { name = "Echo Blade", spell = 268846 }, -- THE MOTHERLODE!! - WEAPONS TESTER
    [136934] = { name = "Force Cannon", spell = 268865 }, -- THE MOTHERLODE!! - WEAPONS TESTER
    [134602] = { name = "Blade Flurry", spell = 258908 }, -- TEMPLE OF SETHRALISS - SHROUDED FANG
    [134600] = { name = "Power Shot", spell = 264574 }, -- TEMPLE OF SETHRALISS - SANDSWEPT MARKSMAN
    [134629] = { name = "Electrified Scales", spell = 272659 }, -- TEMPLE OF SETHRALISS - SCALED KROLUSK RAIDER
    [139422] = { name = "Electrified Scales", spell = 272659 }, -- TEMPLE OF SETHRALISS - SCALED KROLUSK TAMER
    [134686] = { name = "Scouring Sand", spell = 272655 }, -- TEMPLE OF SETHRALISS - MATURE KROLUSK
    [134364] = { name = "Drain", spell = 267237 }, -- TEMPLE OF SETHRALISS - FAITHLESS TENDER
    [133685] = { name = "Dark Omen", spell = 265568 }, --THE UNDERROT - BEFOULED SPIRIT
    [130909] = { name = "Rotten Bile", spell = 265540 }, -- THE UNDERROT - FETID MAGGOT
    [130909] = { name = "Rotten Bile", spell = 265542 }, -- THE UNDERROT - FETID MAGGOT
    [161895] = { name = "Thing from Beyond" } --corruption

}
