local _, br = ...
br.ui.colors = br.ui.colors or {}
local colors = br.ui.colors

-- [[ Class Colors Definition ]] --
-- The colors Duke, the colors!
local classColors = {
	[1] = { class = "Warrior", B = 0.43, G = 0.61, R = 0.78, hex = "c79c6e" },
	[2] = { class = "Paladin", B = 0.73, G = 0.55, R = 0.96, hex = "f58cba" },
	[3] = { class = "Hunter", B = 0.45, G = 0.83, R = 0.67, hex = "abd473" },
	[4] = { class = "Rogue", B = 0.41, G = 0.96, R = 1, hex = "fff569" },
	[5] = { class = "Priest", B = 1, G = 1, R = 1, hex = "ffffff" },
	[6] = { class = "Deathknight", B = 0.23, G = 0.12, R = 0.77, hex = "c41f3b" },
	[7] = { class = "Shaman", B = 0.87, G = 0.44, R = 0, hex = "0070de" },
	[8] = { class = "Mage", B = 0.94, G = 0.8, R = 0.41, hex = "69ccf0" },
	[9] = { class = "Warlock", B = 0.79, G = 0.51, R = 0.58, hex = "9482c9" },
	[10] = { class = "Monk", B = 0.59, G = 1, R = 0, hex = "00ff96" },
	[11] = { class = "Druid", B = 0.04, G = 0.49, R = 1, hex = "ff7d0a" },
	[12] = { class = "Demonhunter", B = 0.79, G = 0.19, R = 0.64, hex = "a330c9" },
	[13] = { class = "Evoker", B = 0.50, G = 0.58, R = 0.20, hex = "33937f" }
}

colors.quality = {
	blue = "0070dd",
	green = "1eff00",
	white = "ffffff",
	grey = "9d9d9d"
}

function colors:getColor(unit)
    if unit == nil then unit = "player" end
    return classColors[select(3, br._G.UnitClass(unit))] or { class = "Unknown", B = 1, G = 1, R = 1, hex = "ffffff" }
end
colors.class = tostring("|cff" .. colors:getColor("player").hex)