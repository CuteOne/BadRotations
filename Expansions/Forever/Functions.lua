-- Forever API Compatibility Layer
-- WoW Forever (interface 1.6x) runs on a Retail-based client with its own project ID
-- (WOW_PROJECT_CAMELOT), but plays Classic content: spell ranks and one class-level spec
-- (e.g. Druid reports spec ID 1484 with no Feral/Balance/etc. split). shared.lua's defaults
-- already pick this client's Retail-style APIs (C_Item, C_QuestLog, C_Spell.IsCurrentSpell,
-- TooltipDataProcessor, UnitPhaseReason); C_Spell.GetSpellInfo gives the ranges in the right
-- order (verified in game: Wrath 5176 -> minRange=0, maxRange=30).
local _, br = ...

if not br.isForever then return end

br.api.expansion = "Forever"
br.api.hasSpellRanks          = true   -- Classic content: spells have rank-specific IDs
br.api.hasSubSpecs            = false  -- one class-level spec, no specialization subfolders
br.api.comboPointsOnTarget    = true   -- unverified, the safe choice: Forever's tooltips list combo points as a cost like Retail's
                                        -- (player-held); the combo point probe in System/Debugging.lua records a switch to settle it
-- hasCharmBreakTracking stays off: C_LossOfControl is on this client (API reference, build 70338),
-- but whether charm-break spells can fire while charmed is unverified.
-- Game object dynamic flag the server sets on objects for an active quest (0x20, "sparkle"; 0x04 is
-- "activate"). Verified with /qprobe on 2026-10-11: the Trial of the Lake Bauble Container reads 0xC024,
-- a plain object nearby 0x8000. The quest tracker uses it; game object names come back empty here.
br.api.questObjectFlag        = 0x20

-- Print version info on load
br.api.printCompatLoaded()
