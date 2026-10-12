local _, br = ...
if br.lists == nil then br.lists = {} end

-- Profession Helper (System/Misc/ProfessionHelper) data the game has no signal for.
br.lists.professions = {
	-- Crafted items Disenchant may destroy. Only these: picking by quality or soulbound could take gear
	-- the player wants. Mists of Pandaria crafts (MoP Classic, Retail), then Legion and BfA (Retail).
	disenchant = {
		[82402]  = true, -- Windwool Bracers
		[82426]  = true, -- Contender's Silk Cuffs
		[82434]  = true, -- Contender's Satin Cuffs
		[83793]  = true, -- Ornate Band
		[83794]  = true, -- Shadowfire Necklace
		[90904]  = true, -- Ornate Band
		[90905]  = true, -- Shadowfire Necklace
		[128883] = true, -- Warhide Bindings
		[128899] = true, -- Battlebound Armbands
		[130223] = true, -- Deep Amber Loop
		[130224] = true, -- Skystone Loop
		[130225] = true, -- Azsunite Loop
		[130226] = true, -- Deep Amber Pendant
		[130227] = true, -- Skystone Pendant
		[130228] = true, -- Azsunite Pendant
		[130229] = true, -- Prophetic Band
		[130230] = true, -- Maelstrom Band
		[130231] = true, -- Dawnlight Band
		[136711] = true, -- Queen's Opal Loop
		[136712] = true, -- Queen's Opal Pendant
		[136713] = true, -- Shadowruby Band
		[154692] = true, -- Tidespray Linen Bracers
	},
}
