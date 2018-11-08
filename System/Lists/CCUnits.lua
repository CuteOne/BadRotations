if br.lists == nil then br.lists = {} end
-- Crowd Control Units = list of units to stun, either always or udner certain condition such as having a buff or wirldwinding etc
br.lists.ccUnits = {
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
	[76935] = { name = "Black Iron Drake-Keeper", fleeing = true }, -- Hhould be stunned/cc when running towards whelps
	-- Proving Ground
	[71415] = { name = "Banana Tosser(Small)", buff = 142639 },
	[71414] = { name = "Banana Tosser(Large)", buff = 142639 },
	-- BFA Dungeons
	[142587] = { name = "Infest)", spell = 278444 }, -- Waycrest Manor 
	[133593] = { name = "Repair)", spell = 262554 }, -- Motherload
	[134331] = { name = "Channel Lightning)", spell = 270889 }, -- Motherload
	[129640] = { name = "Clamping Jaws)", spell = 256897 }, -- Seige of Boralus
	[144168] = { name = "Ferocity)", spell = 272888 }, -- Seige of Boralus A
	[137517] = { name = "Ferocity)", spell = 272888 } -- Seige of Boralus A-H
}
}
