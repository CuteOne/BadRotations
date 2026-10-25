-- Classic API Compatibility Layer
-- Handles API differences in Classic
local _, br = ...

if not br.isClassic then return end

br.api.expansion = "Classic"
br.api.hasSpellRanks          = true   -- spells have rank-specific IDs
br.api.hasSubSpecs            = false  -- no talent specialization subfolders
br.api.comboPointsOnTarget    = true   -- combo points are stored on the target, lost on switch
br.api.spellRangeSwapped      = true   -- C_Spell.GetSpellInfo has minRange and maxRange swapped

-- Print version info on load
br.api.printCompatLoaded()
