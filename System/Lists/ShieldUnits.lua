local _, br = ...
if br.lists == nil then
	br.lists = {}
end
-- Shield Units: "soft shields" that REDUCE incoming damage.
-- These should DEPRIORITIZE targets (via coefficient penalty) when "Avoid Shields" is enabled.
-- Do NOT use this list for invulnerability/phase/reflect mechanics that should hard-block targeting.
-- Hard "do not attack" mechanics belong in NoTouchUnits.lua (and are enforced by isSafeToAttack()).
br.lists.shieldUnits = {
	--[[===========================]]
	--[[  LATER EXPANSIONS (KEEP)  ]]
	--[[===========================]]

	-- Proving Grounds
	[71072] = {coef = -90, buff = 142427}, -- Proving ground Sha shielded (will unshield later so better wait)
	[71064] = {coef = -100, buff = 142174, frontal = true}, -- when shielded and we are in front of unit, dont attack
	[71079] = {coef = -100, buff = 142174, frontal = true}, -- when shielded and we are in front of unit, dont attack
	-- Agatha Challenge Skin
	[115638] = {coef = -200, buff = 243027}, -- Shadow Shield
	-- BFA dungeons
	[134158] = {coef = -100, spell = 269928, frontal = true},
	-- Timewalking
	[29309] = {coef = -100, buff = 56153}, -- Elder Nadox: Ahn'kahet The Old Kingdom (Invulnerable buff from Ahn'kahar Guardian)
	[30178] = {coef = -100, buff = 56153}, -- Ahn'kahar Swarmer: Ahn'kahet The Old Kingdom (Invulnerable buff from Ahn'kahar Guardian)
	-- Castle Nathria
	[165318] = {coef = -100, buff = 329636}, -- Stone Legion Generals (Kaal) - Takes 95% reduced damage during Hardened Stone Forms
	[170323] = {coef = -100, buff = 329636}, -- Stone Legion Generals (Grashaal) - Takes 95% reduced damage during Hardened Stone Forms
}
