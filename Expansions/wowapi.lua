-- WoW API Compatibility Layer
-- Loads the appropriate API wrapper based on WoW version
local _, br = ...

-- Initialize API compatibility table
br.api = br.api or {}
br.api.compat = {}

-- Detect WoW version
br.isRetail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
br.isMOP = (WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC)
br.isCata = (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC)  -- detected but no expansion file; unsupported
br.isWrath = (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC)    -- detected but no expansion file; unsupported
br.isBC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
br.isClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)

-- Expansion name is set by each file in Expansions/<name>/Functions.lua after it detects its client.
-- Defaults to "Unknown" for unsupported clients (Cata, Wrath, etc.).
br.api.expansionName = "Unknown"

-- Version info for debugging
function br.api.compat:getVersionInfo()
    local version, build, date, tocVersion = GetBuildInfo()
    return {
        version       = version,
        build         = build,
        date          = date,
        tocVersion    = tocVersion,
        projectID     = WOW_PROJECT_ID,
        expansionName = br.api.expansionName,
    }
end

-- This will be populated by the expansion-specific file
br.api.wow = {}

-- Capability flags — describe what the current expansion supports.
-- Defaults assume a modern expansion; Classic/TBC expansion files override as needed.
br.api.hasSpellRanks        = false  -- true on Classic/TBC: spell IDs are rank-specific tables
br.api.hasSubSpecs          = true   -- false on Classic/TBC: no talent specialization subfolders
br.api.hasHeroTalentTrees   = false  -- true only on Retail (War Within+)
br.api.spellListName        = nil    -- set by each expansion file; nil = unsupported/not yet implemented

-- Namespace proxy tables for br._G.C_Spell.X / C_Container.X / C_SpellBook.X calls.
-- br._G.__index returns br.api.wow[name] when a key is not rawset on br._G, so these
-- proxies intercept every br._G.C_Spell.* call and check for an expansion shim first,
-- then fall through to the real WoW global. Expansion files assign into br.api.wow.C_Spell
-- (etc.) to polyfill methods that are missing or differ on their client version.
-- The NN unlocker writes br._G.C_Spell = nnProxy directly (rawset), which takes priority
-- over this proxy via rawget and bypasses __index entirely.
br.api.wow.C_Spell     = setmetatable({}, { __index = _G.C_Spell     or {} })
br.api.wow.C_Container = setmetatable({}, { __index = _G.C_Container or {} })
br.api.wow.C_SpellBook = setmetatable({}, { __index = _G.C_SpellBook or {} })
