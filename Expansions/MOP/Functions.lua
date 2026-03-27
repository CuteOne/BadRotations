-- Mists of Pandaria Classic API Compatibility Layer
-- Handles API differences in MoP Classic
local _, br = ...

if not br.isMOP then return end

-- Capability flags for MoP Classic
br.api.expansion = "MOP"

local api = br.api.wow

-- IsPassiveSpell, GetSpellInfo, HookTooltipSet*, UnitInPhase, GetNumQuestLogEntries,
-- GetQuestLogTitle, FindBaseSpellByID, GCDSpells/GetGCDSpellID, and C_Spell shims are
-- all provided by shared.lua. Only MoP-specific implementations follow.

-- Talent System - MoP/Classic uses tier/column system
api.getTalentInfo = function(spec, spellTalents)
    local talents = {}

    -- Initial profiles (spec > 1400) don't have talents
    if spec > 1400 then return talents end

    local activeSpecGroup = _G.C_SpecializationInfo and _G.C_SpecializationInfo.GetActiveSpecGroup and _G.C_SpecializationInfo.GetActiveSpecGroup()
    if not activeSpecGroup then return talents end

    -- MoP/Classic talents: 7 tiers x 3 columns
    for tier = 1, 7 do
        for column = 1, 3 do
            local info = _G.C_SpecializationInfo and _G.C_SpecializationInfo.GetTalentInfo and
                         _G.C_SpecializationInfo.GetTalentInfo({ tier = tier, column = column, specializationIndex = activeSpecGroup })
            if info and info.spellID then
                talents[info.spellID] = {
                    active = info.selected and true or false,
                    rank = 0, -- Classic talents don't expose rank
                    tier = tier,
                    column = column,
                }
            end
        end
    end

    return talents
end


-- Print version info on load
if br.api.compat.getVersionInfo then
    local versionInfo = br.api.compat:getVersionInfo()
    print("|cffA330C9BadRotations|r |cffFFFFFFAPI:|r MoP Classic compatibility layer loaded (Build: " .. versionInfo.build .. ")")
end
