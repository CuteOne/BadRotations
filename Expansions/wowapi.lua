-- WoW API Compatibility Layer
-- Loads the appropriate API wrapper based on WoW version
local _, br = ...

-- Initialize API compatibility table
br.api = br.api or {}
br.api.compat = {}

-- Detect WoW version
br.isForever = (WOW_PROJECT_ID == WOW_PROJECT_CAMELOT)
br.isRetail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
br.isMOP = (WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC)
br.isCata = (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC)  -- detected but no expansion file; unsupported
br.isWrath = (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC)    -- detected but no expansion file; unsupported
br.isBC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
br.isClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)

-- Whether this client hands out secret values (Retail since Midnight, Forever). Other clients
-- built on the same engine (Anniversary build 70006) carry issecretvalue/canaccessvalue too but
-- never produce a secret, so the functions existing doesn't mean the client uses them.
br.hasSecretValues = (issecretvalue ~= nil or canaccessvalue ~= nil) and (br.isRetail or br.isForever)

-- br.api.expansion is set by each Expansions/<name>/Functions.lua to its short key ("Retail", "MOP", "TBC", "Classic", "Forever").
-- Defaults to "Unknown" for unsupported clients (Cata, Wrath, etc.).
br.api.expansion = "Unknown"

-- Version info for debugging
function br.api.compat:getVersionInfo()
    local version, build, date, tocVersion = GetBuildInfo()
    return {
        version       = version,
        build         = build,
        date          = date,
        tocVersion    = tocVersion,
        projectID     = WOW_PROJECT_ID,
        expansion     = br.api.expansion,
    }
end

-- This will be populated by the expansion-specific file
br.api.wow = {}

-- Capability flags: what the current client supports. These are the defaults; each
-- Expansions/<name>/Functions.lua sets only the ones that differ on its client.
br.api.hasSpellRanks         = false  -- spells have rank-specific IDs (Classic, TBC, Forever)
br.api.hasSubSpecs           = true   -- talent specialization subfolders (false on Classic, TBC, Forever)
br.api.hasHeroTalentTrees    = false  -- hero talent trees (Retail)
br.api.hasCharmBreakTracking = false  -- C_LossOfControl lets charm-break spells fire while charmed (Retail)
br.api.hasBFAItemChannels    = false  -- BFA trinket/essence channels need a follow-up channel lock (Retail)
br.api.comboPointsOnTarget   = false  -- combo points are kept on the target and lost on a switch (before 6.0.2)
br.api.spellRangeSwapped     = false  -- C_Spell.GetSpellInfo gives minRange and maxRange the other way round
br.api.questObjectFlag       = nil    -- game object dynamic flag the server sets for an active quest, where known
-- The server's fleeing unit flag (UNIT_FLAG_FLEEING, the same bit in every version). unit:isFleeing reads
-- it where the unlocker provides UnitFlags; without it the flee emote is used. Confirmed in play on
-- Forever 2026-10-12: fleeing mobs read 0x00880800 against 0x00080800.
br.api.fleeingUnitFlag       = 0x00800000

-- Namespace proxy tables for br._G.C_Spell.X / C_Container.X / C_SpellBook.X / C_AddOns.X / C_SpecializationInfo.X / C_Item.X / C_Map.X calls.
-- shared.lua adds the methods a client lacks to these proxies.
-- br._G.__index returns br.api.wow[name] when a key is not rawset on br._G, so these
-- proxies intercept every br._G.C_Spell.* call and check for an expansion shim first,
-- then fall through to the real WoW global. Expansion files assign into br.api.wow.C_Spell
-- (etc.) to polyfill methods that are missing or differ on their client version.
-- The NN unlocker writes br._G.C_Spell = nnProxy directly (rawset), which takes priority
-- over this proxy via rawget and bypasses __index entirely.
br.api.wow.C_Spell              = setmetatable({}, { __index = _G.C_Spell              or {} })
br.api.wow.C_Container          = setmetatable({}, { __index = _G.C_Container          or {} })
br.api.wow.C_SpellBook          = setmetatable({}, { __index = _G.C_SpellBook          or {} })
br.api.wow.C_AddOns             = setmetatable({}, { __index = _G.C_AddOns             or {} })
br.api.wow.C_SpecializationInfo = setmetatable({}, { __index = _G.C_SpecializationInfo or {} })
br.api.wow.C_Item               = setmetatable({}, { __index = _G.C_Item               or {} })
br.api.wow.C_Map                = setmetatable({}, { __index = _G.C_Map                or {} })
