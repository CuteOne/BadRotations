-- WoW API Compatibility Layer
-- Loads the appropriate API wrapper based on WoW version
local _, br = ...

-- Initialize API compatibility table
br.api = br.api or {}
br.api.compat = {}

-- Detect WoW version
br.isRetail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
---@diagnostic disable-next-line: undefined-global
br.isMOP = (WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC)
br.isCata = (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC)
br.isWrath = (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC)
br.isBC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
br.isClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)

-- Set Expansion Name
br.api.expansionName = br.isRetail and "Retail" or
                       br.isMOP and "MoP Classic" or
                       br.isCata and "Cataclysm Classic" or
                       br.isWrath and "Wrath Classic" or
                       br.isBC and "Burning Crusade Classic" or
                       br.isClassic and "Classic" or
                       "Unknown"

-- Version info for debugging
function br.api.compat:getVersionInfo()
    local version, build, date, tocVersion = GetBuildInfo()
    return {
        version = version,
        build = build,
        date = date,
        tocVersion = tocVersion,
        isRetail = br.isRetail,
        isMOP = br.isMOP,
        isCata = br.isCata,
        isWrath = br.isWrath,
        isBC = br.isBC,
        isClassic = br.isClassic,
        projectID = WOW_PROJECT_ID,
        expansionName = br.api.expansionName
    }
end

-- This will be populated by the expansion-specific file
br.api.wow = {}
