if br.lists == nil then br.lists = {} end
br.lists.dummies = {
-- Misc/Unknown
	[79987]  = "Training Dummy", 	          -- Location Unknown
	[92169]  = "Raider's Training Dummy",     -- Tanking (Eastern Plaguelands)
	[96442]  = "Training Dummy", 			  -- Damage (Location Unknown)
	[109595] = "Training Dummy",              -- Location Unknown
	[113963] = "Raider's Training Dummy", 	  -- Damage (Location Unknown)
	[131985] = "Dungeoneer's Training Dummy", -- Damage (Zuldazar)
	[131990] = "Raider's Training Dummy",     -- Tanking (Zuldazar)
	[132976] = "Training Dummy", 			  -- Morale Booster (Zuldazar)
-- Level 1
	[17578]  = "Hellfire Training Dummy",     -- Lvl 1 (The Shattered Halls)
	[60197]  = "Training Dummy",              -- Lvl 1 (Scarlet Monastery)
	[64446]  = "Training Dummy",              -- Lvl 1 (Scarlet Monastery)
	[144077] = "Training Dummy",              -- Lvl 1 (Dazar'alor) - Morale Booster
-- Level 3
	[44171]  = "Training Dummy",              -- Lvl 3 (New Tinkertown, Dun Morogh)
	[44389]  = "Training Dummy",              -- Lvl 3 (Coldridge Valley)
	[44848]  = "Training Dummy", 			  -- Lvl 3 (Camp Narache, Mulgore)
	[44548]  = "Training Dummy",              -- Lvl 3 (Elwynn Forest)
	[44614]  = "Training Dummy",              -- Lvl 3 (Teldrassil, Shadowglen)
	[44703]  = "Training Dummy", 			  -- Lvl 3 (Ammen Vale)
	[44794]  = "Training Dummy", 			  -- Lvl 3 (Dethknell, Tirisfal Glades)
	[44820]  = "Training Dummy",              -- Lvl 3 (Valley of Trials, Durotar)
	[44937]  = "Training Dummy",              -- Lvl 3 (Eversong Woods, Sunstrider Isle)
	[48304]  = "Training Dummy",              -- Lvl 3 (Kezan)
-- Level 55
	[32541]  = "Initiate's Training Dummy",   -- Lvl 55 (Plaguelands: The Scarlet Enclave)
	[32545]  = "Initiate's Training Dummy",   -- Lvl 55 (Eastern Plaguelands)
-- Level 60
	[32666]  = "Training Dummy",              -- Lvl 60 (Siege of Orgrimmar, Darnassus, Ironforge, ...)
-- Level 65
	[32542]  = "Disciple's Training Dummy",   -- Lvl 65 (Eastern Plaguelands)
-- Level 70
	[32667]  = "Training Dummy",              -- Lvl 70 (Orgrimmar, Darnassus, Silvermoon City, ...)
-- Level 75
	[32543]  = "Veteran's Training Dummy",    -- Lvl 75 (Eastern Plaguelands)
-- Level 80
	[31144]  = "Training Dummy",              -- Lvl 80 (Orgrimmar, Darnassus, Ironforge, ...)
	[32546]  = "Ebon Knight's Training Dummy",-- Lvl 80 (Eastern Plaguelands)
-- Level 85
	[46647]  = "Training Dummy",              -- Lvl 85 (Orgrimmar, Stormwind City)
-- Level 90
	[67127]  = "Training Dummy",              -- Lvl 90 (Vale of Eternal Blossoms)
-- Level 95
	[79414]  = "Training Dummy",              -- Lvl 95 (Broken Shore, Talador)
-- Level 100
	[87317]  = "Training Dummy",              -- Lvl 100 (Lunarfall, Frostwall) - Damage
	[87321]  = "Training Dummy",              -- Lvl 100 (Stormshield) - Healing
	[87760]  = "Training Dummy",              -- Lvl 100 (Frostwall) - Damage
	[88289]  = "Training Dummy",              -- Lvl 100 (Frostwall) - Healing
	[88316]  = "Training Dummy",              -- Lvl 100 (Lunarfall) - Healing
	[88835]  = "Training Dummy",              -- Lvl 100 (Warspear) - Healing
	[88906]  = "Combat Dummy",                -- Lvl 100 (Nagrand)
	[88967]  = "Training Dummy",              -- Lvl 100 (Lunarfall, Frostwall)
	[89078]  = "Training Dummy",              -- Lvl 100 (Frostwall, Lunarfall)
-- Levl 100 - 110
	[92164]  = "Training Dummy", 			  -- Lvl 100 - 110 (Dalaran) - Damage
	[92165]  = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (Eastern Plaguelands) - Damage
	[92167]  = "Training Dummy",              -- Lvl 100 - 110 (The Maelstrom, Eastern Plaguelands, The Wandering Isle)
	[92168]  = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (The Wandering Isles, Easter Plaguelands)
	[100440] = "Training Bag", 				  -- Lvl 100 - 110 (The Wandering Isles)
	[100441] = "Dungeoneer's Training Bag",   -- Lvl 100 - 110 (The Wandering Isles)
	[102045] = "Rebellious Wrathguard",       -- Lvl 100 - 110 (Dreadscar Rift) - Dungeoneer
	[102048] = "Rebellious Felguard",         -- Lvl 100 - 110 (Dreadscar Rift)
	[102052] = "Rebellious Imp", 			  -- Lvl 100 - 110 (Dreadscar Rift) - AoE
	[103402] = "Lesser Bulwark Construct",    -- Lvl 100 - 110 (Hall of the Guardian)
	[103404] = "Bulwark Construct",           -- Lvl 100 - 110 (Hall of the Guardian) - Dungeoneer
	[107483] = "Lesser Sparring Partner",     -- Lvl 100 - 110 (Skyhold)
	[107555] = "Bound Void Wraith",           -- Lvl 100 - 110 (Netherlight Temple)
	[107557] = "Training Dummy",              -- Lvl 100 - 110 (Netherlight Temple) - Healing
	[108420] = "Training Dummy",              -- Lvl 100 - 110 (Stormwind City, Durotar)
	[111824] = "Training Dummy", 			  -- Lvl 100 - 110 (Azsuna)
	[113674] = "Imprisoned Centurion",        -- Lvl 100 - 110 (Mardum, the Shattered Abyss) - Dungeoneer
	[113676] = "Imprisoned Weaver", 	      -- Lvl 100 - 110 (Mardum, the Shattered Abyss)
	[113687] = "Imprisoned Imp",              -- Lvl 100 - 110 (Mardum, the Shattered Abyss) - Swarm
	[113858] = "Training Dummy",              -- Lvl 100 - 110 (Trueshot Lodge) - Damage
	[113859] = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (Trueshot Lodge) - Damage
	[113862] = "Training Dummy",              -- Lvl 100 - 110 (Trueshot Lodge) - Damage
	[113863] = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (Trueshot Lodge) - Damage
	[113871] = "Bombardier's Training Dummy", -- Lvl 100 - 110 (Trueshot Lodge) - Damage
	[113966] = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 - Damage
	[113967] = "Training Dummy",              -- Lvl 100 - 110 (The Dreamgrove) - Healing
	[114832] = "PvP Training Dummy",          -- Lvl 100 - 110 (Stormwind City)
	[114840] = "PvP Training Dummy",          -- Lvl 100 - 110 (Orgrimmar)
-- Level 102
	[87318]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall) - Damage
	[87322]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Stormshield) - Tank
	[87761]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Frostwall) - Damage
	[88288]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Frostwall) - Tank
	[88314]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall) - Tank
	[88836]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Warspear) - Tank
	[93828]  = "Training Dummy",              -- Lvl 102 (Hellfire Citadel)
	[97668]  = "Boxer's Trianing Dummy",      -- Lvl 102 (Highmountain)
	[98581]  = "Prepfoot Training Dummy",     -- Lvl 102 (Highmountain)
-- Level 110 - 120
	[126781] = "Training Dummy", 			  -- Lvl 110 - 120 (Boralus) - Damage
	[131989] = "Training Dummy", 			  -- Lvl 110 - 120 (Boralus) - Damage
	[131994] = "Training Dummy", 			  -- Lvl 110 - 120 (Boralus) - Healing
	[144082] = "Training Dummy",              -- Lvl 110 - 120 (Dazar'alor) - PVP Damage
	[144085] = "Training Dummy", 			  -- Lvl 110 - 120 (Dazar'alor) - Damage
	[144081] = "Training Dummy",              -- Lvl 110 - 120 (Dazar'alor) - Damage
	[153285] = "Training Dummy", 			  -- Lvl 110 - 120 (Ogrimmar) - Damage
	[153292] = "Training Dummy", 			  -- Lvl 110 - 120 (Stormwind) - Damage
-- Level 111 - 120
	[131997] = "Training Dummy", 			  -- Lvl 111 - 120 (Boralus, Zuldazar) - PVP Damage
	[131998] = "Training Dummy",              -- Lvl 111 - 120 (Boralus, Zuldazar) - PVP Healing
-- Level 112 - 120
	[144074] = "Training Dummy", 			  -- Lvl 112 - 120 (Dazar'alor) - PVP Healing
-- Level 112 - 122
	[131992] = "Dungeoneer's Training Dummy",  -- Lvl 112 - 122 (Boralus) - Tanking
-- Level 113 - 120 
	[132036] = "Training Dummy", 			  -- Lvl 113 - 120 (Boralus) - Healing
-- Level 113 - 122
	[144078] = "Dungeoneer's Training Dummy", -- Lvl 113 - 122 (Dazar'alor) - Tanking
-- Level 114 - 120
	[144075] = "Training Dummy", 			  -- Lvl 114 - 120 (Dazar'alor) - Healing
-- Level 60 
	[174569] = "Training Dummy",			  -- Lvl 60 (Ardenweald)
	[174570] = "Swarm Training Dummy",		  -- Lvl 60 (Ardenweald)
	[174571] = "Cleave Training Dummy",		  -- Lvl 60 (Ardenweald)
	[174487] = "Competent Veteran", 		  -- Lvl 60 (Location Unknown)
	[173942] = "Training Dummy",			  -- Lvl 60 (Revendreth)
	[175456] = "Swarm Training Dummy",		  -- Lvl 60 (Revendreth)
	[175455] = "Cleave Training Dummy",		  -- Lvl 60 (Revendreth)
-- Level 62
	[174484] = "Immovable Champion", 		  -- Lvl 62 (Location Unknown)
	[175449] = "Dungeoneer's Training Dummy", -- Lvl 62 (Revendreth)
	[173957] = "Necrolord's Resolve",		  -- Lvl 62 (Oribos)
	[173955] = "Pride's Resolve",		 	  -- Lvl 62 (Oribos)
	[173954] = "Nature's Resolve",		 	  -- Lvl 62 (Oribos)
	[173919] = "Valiant's Resolve",		 	  -- Lvl 62 (Oribos)
-- Level ??
	[24792]  = "Advanced Training Dummy",     -- Lvl ?? Boss (Location Unknown)
	[30527]  = "Training Dummy", 		      -- Lvl ?? Boss (Location Unknown)
	[31146]  = "Raider's Training Dummy",     -- Lvl ?? (Orgrimmar, Stormwind City, Ironforge, ...)
	[87320]  = "Raider's Training Dummy",     -- Lvl ?? (Lunarfall, Stormshield) - Damage
	[87329]  = "Raider's Training Dummy",     -- Lvl ?? (Stormshield) - Tank
	[87762]  = "Raider's Training Dummy",     -- Lvl ?? (Frostwall, Warspear) - Damage
	[88837]  = "Raider's Training Dummy",     -- Lvl ?? (Warspear) - Tank
	[92166]  = "Raider's Training Dummy",     -- Lvl ?? (The Maelstrom, Dalaran, Eastern Plaguelands, ...) - Damage
	[101956] = "Rebellious Fel Lord",         -- lvl ?? (Dreadscar Rift) - Raider
	[103397] = "Greater Bulwark Construct",   -- Lvl ?? (Hall of the Guardian) - Raider
	[107202] = "Reanimated Monstrosity", 	  -- Lvl ?? (Broken Shore) - Raider
	[107484] = "Greater Sparring Partner",    -- Lvl ?? (Skyhold)
	[107556] = "Bound Void Walker",           -- Lvl ?? (Netherlight Temple) - Raider
	[113636] = "Imprisoned Forgefiend",       -- Lvl ?? (Mardum, the Shattered Abyss) - Raider
	[113860] = "Raider's Training Dummy",     -- Lvl ?? (Trueshot Lodge) - Damage
	[113864] = "Raider's Training Dummy",     -- Lvl ?? (Trueshot Lodge) - Damage
	[70245]  = "Training Dummy",              -- Lvl ?? (Throne of Thunder)
	[113964] = "Raider's Training Dummy",     -- Lvl ?? (The Dreamgrove) - Tanking
	[131983] = "Raider's Training Dummy",     -- Lvl ?? (Boralus) - Damage
	[144086] = "Raider's Training Dummy",     -- Lvl ?? (Dazal'alor) - Damage
	[174565] = "Raider's Training Dummy",	  -- Lvl ?? (Ardenweald) 
	[174566] = "Dungeoneer's Tanking Dummy",  -- Lvl ?? (Ardenweald) 
	[174567] = "Raider's Training Dummy",	  -- Lvl ?? (Ardenweald) 
	[174568] = "Dungeoneer's Tanking Dummy",  -- Lvl ?? (Ardenweald) 
	[174491] = "Iron Tester", 				  -- Lvl ?? (Location Unknown)
	[174488] = "Unbreakable Defender", 		  -- Lvl ?? (Location Unknown)
	-- [174489] = "Necromantic Guide", 		  -- Lvl ?? (Location Unknown)
	[174489] = "Raider's Training Dummy",	  -- Lvl ?? (Revendreth)
	[175452] = "Raider's Training Dummy",	  -- Lvl ?? (Location Unknown)
	[175451] = "Dungeoneer's Tanking Dummy",  -- Lvl ?? (Revendreth)
	[154580] = "Reinforced Guardian", 		  -- Elysian Hold
	[154583] = "Stalward Guardian", 		  -- Elysian Hold
	[154585] = "Valiant's Resolve",			  -- Elysian Hold
	[154586] = "Stalward Phalanx", 			  -- Elysian Hold
	


}