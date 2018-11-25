if br.lists == nil then
	br.lists = {}
end
-- burnUnits = List of UnitID/Names we should have highest prio on.
br.lists.burnUnits = {
	-- old content stuff
	[71603] = {coef = 100, name = "Immerseus Oozes"}, -- kill on sight
	-- Shadowmoon Burial Grounds
	[75966] = {coef = 100, name = "Defiled Spirit"}, -- need to be cc and snared and is not allowed to reach boss.
	[75899] = {coef = 100, name = "Possessed Soul"},
	[76518] = {coef = 100, unitMarker = 8}, -- Ritual of Bones, marked one will be prioritized
	-- Auchindon
	[77812] = {coef = 150, name = "Sargerei Souldbinder"}, -- casts a Mind Control
	-- Grimrail Depot
	[80937] = {coef = 100},
	-- UBRS
	[76222] = {coef = 100},
	[163061] = {coef = 100}, -- Windfury Totem
	-- Proving Grounds
	[71070] = {coef = 150, name = "Illusion Banshee"}, -- proving ground (will explode if not burned)
	[71075] = {coef = 150, name = "Illusion Banshee"}, -- proving ground (will explode if not burned)
	[71076] = {coef = 25}, -- Proving ground healer
	-- Legion
	[117264] = {coef = 200, name = "Maiden of Valor", buff = 241008}, -- burn Maiden of Valor if buff is present
	[120651] = {coef = 150, name = "Explosives"}, -- M+ Affix
	-- [115642] = { coef = 100}, -- Umbral Imps - Challenge mode
	-- [115638] = { coef = 175, buff = 243113},
	-- [115641] = { coef = 150}, -- Smoldering Imps
	-- [115640] = { coef = 125}, -- Fuming Imps
	-- [115719] = { coef = 200}, -- Imp Servents
	-- BFA
	[141851] = {coef = 150, name = "Spawn of G'huun"},
	-- Uldir
	[135016] = {coef = 200, name = "Plague Amalgam"}
}
