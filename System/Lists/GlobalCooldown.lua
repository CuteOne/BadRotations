local _, br = ...
if br.lists == nil then br.lists = {} end
-- The spell whose cooldown is the global cooldown (spell:getGCDSpellID). Clients that have the GCD
-- spell (from Wrath of the Lich King on) use it; older ones use a spell every member of the class
-- knows from level 1 and that shares the GCD in every form (a Druid's Wrath works in Cat and Bear
-- Form too).
br.lists.globalCooldown = {
	spell = 61304,
	byClass = {
		DRUID   = 5176, -- Wrath
		HUNTER  = 1978, -- Serpent Sting
		MAGE    = 133,  -- Fireball
		PALADIN = 635,  -- Holy Light
		PRIEST  = 2050, -- Holy Smite
		ROGUE   = 1752, -- Sinister Strike
		SHAMAN  = 403,  -- Lightning Bolt
		WARLOCK = 686,  -- Shadow Bolt
		WARRIOR = 772,  -- Rend
	},
}
