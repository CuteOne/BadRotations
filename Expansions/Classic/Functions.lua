-- Classic API Compatibility Layer
-- Handles API differences in Classic
local _, br = ...

if not br.isClassic then return end

-- Capability flags for Classic
br.api.hasSpellRanks = true        -- spells have rank-specific IDs
br.api.hasSubSpecs   = false       -- no talent specialization subfolders
br.api.comboPointsOnTarget = true  -- combo points are stored on the target, lost on switch
br.api.expansion = "Classic"

local api = br.api.wow

-- IsPassiveSpell, HookTooltipSet*, UnitInPhase, GetNumQuestLogEntries, GetQuestLogTitle,
-- FindBaseSpellByID, GCDSpells/GetGCDSpellID, and C_Spell shims are all provided by
-- shared.lua. GetSpellInfo is overridden below to fix the Classic field swap.
-- GetSpellInfo wrapper
-- Classic: C_Spell.GetSpellInfo returns a table (like Retail)
-- Returns: name, rank, iconID, castTime, minRange, maxRange, spellID, originalIconID
-- NOTE: Classic API has minRange/maxRange swapped in the table!
api.GetSpellInfo = function(spellIdentifier)
    if not spellIdentifier then return nil end

    -- GetSpellInfo doesn't accept tables, only numbers or strings
    if type(spellIdentifier) == "table" then return nil end

    -- Try C_Spell first (Classic has this like Retail)
    if _G.C_Spell and _G.C_Spell.GetSpellInfo then
        local spellInfo = _G.C_Spell.GetSpellInfo(spellIdentifier)
        if spellInfo and type(spellInfo) == "table" then
            -- CLASSIC BUG FIX: minRange and maxRange are swapped in the Classic API
            -- spellInfo.minRange actually contains maxRange, and vice versa
            return spellInfo.name,
                   nil,
                   spellInfo.iconID,
                   spellInfo.castTime,
                   spellInfo.maxRange,  -- Swapped: use maxRange field for minRange
                   spellInfo.minRange,  -- Swapped: use minRange field for maxRange
                   spellInfo.spellID,
                   spellInfo.originalIconID
        end
    end

    -- Fallback to global GetSpellInfo if C_Spell not available
    if _G.GetSpellInfo then
        return _G.GetSpellInfo(spellIdentifier)
    end

    return nil
end

-- Talent System - Classic uses tier/column system
api.getTalentInfo = function(spec, spellTalents)
    local talents = {}

    -- -- Initial profiles (spec > 1400) don't have talents
    -- if spec > 1400 then return talents end

    -- local activeSpecGroup = _G.C_SpecializationInfo and _G.C_SpecializationInfo.GetActiveSpecGroup and _G.C_SpecializationInfo.GetActiveSpecGroup()
    -- if not activeSpecGroup then return talents end

    -- -- Classic talents: 7 tiers x 3 columns
    -- for tier = 1, 7 do
    --     for column = 1, 3 do
    --         local info = _G.C_SpecializationInfo and _G.C_SpecializationInfo.GetTalentInfo and
    --                      _G.C_SpecializationInfo.GetTalentInfo({ tier = tier, column = column, specializationIndex = activeSpecGroup })
    --         if info and info.spellID then
    --             talents[info.spellID] = {
    --                 active = info.selected and true or false,
    --                 rank = 0, -- Classic talents don't expose rank
    --                 tier = tier,
    --                 column = column,
    --             }
    --         end
    --     end
    -- end

    return talents
end

-- Print version info on load
if br.api.compat.getVersionInfo then
    local versionInfo = br.api.compat:getVersionInfo()
    print("|cffA330C9BadRotations|r |cffFFFFFFAPI:|r Classic compatibility layer loaded (Build: " .. versionInfo.build .. ")")
end
