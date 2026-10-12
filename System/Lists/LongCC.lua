local _, br = ...
if br.lists == nil then
	br.lists = {}
end
-- Crowd control that takes a mob out of the fight (polymorph, sap, trap, fear...): "Don't break
-- CCs" leaves these units alone. Roots and stuns aren't here: they hold a mob in the fight, and
-- attacking it is the point.
br.lists.longCC = {
	[207167] = true, -- Death Knight -- Blinding Sleet
	[217832] = true, -- Demon Hunter -- Imprison
	[99] = true, -- Druid - Incapacitating Roar
	[2637] = true, -- Druid - Hibernate
	[209790] = true, -- Hunter - Freezing Arrow
	[3355] = true, -- Hunter - Freezing Trap
	[213691] = true, -- Hunter - Scatter Shot
	[19386] = true, -- Hunter - Wyvern Sting
	[31661] = true, -- Mage - Dragon's Breath
	--[122] = true, -- Mage - Frost Nova
	--[199786] = true, -- Mage - Glacial Spike
	[61305] = true, -- Mage - Polymorph (Cat)
	[161354] = true, -- Mage - Polymorph (Monkey)
	[161355] = true, -- Mage - Polymorph (Penguin)
	[28272] = true, -- Mage - Polymorph (Pig)
	[161353] = true, -- Mage - Polymorph (Polar Bear)
	[126819] = true, -- Mage - Polymorph (Porcupine)
	[61721] = true, -- Mage - Polymorph (Rabbit)
	[118] = true, -- Mage - Polymorph (Sheep)
	[61780] = true, -- Mage - Polymorph (Turkey)
	[28271] = true, -- Mage - Polymorph (Turtle)
	[115078] = true, -- Monk - Paralysis
	[20066] = true, -- Paladin - Repentance
	[8122] = true, -- Priest - Psychic Scream
	[9484] = true, -- Priest - Shackle Undead
	[199743] = true, -- Rogue - Parley
	[2094] = true, -- Rogue - Blind
	[1776] = true, -- Rogue - Gouge
	[6770] = true, -- Rogue - Sap
	[211015] = true, -- Shaman - Hex (Cockroach)
	[210873] = true, -- Shaman - Hex (Compy)
	[51514] = true, -- Shaman - Hex (Frog)
	[211010] = true, -- Shaman - Hex (Snake)
	[211004] = true, -- Shaman - Hex (Spider)
	[196942] = true, -- Shaman - Voodoo Totem: Hex
	[118699] = true, -- Warlock - Fear
	[5484] = true, -- Warlock - Howl of Terror
	[710] = true, -- Warlock - Banish
	[82579] = true -- Various - Chloroform (Red Ridge: Keeshan Questline)
}
