-- Mists of Pandaria Classic API Compatibility Layer
-- Handles API differences in MoP Classic
local _, br = ...

if not br.isMOP then return end

-- The unlocker's version of a game name, else the client's (Expansions/wowapi.lua)
local base = br.api.base

-- Talent System - MoP/Classic uses tier/column system
br.api.getTalentInfo = function(spec, spellTalents)
    local talents = {}

    -- Initial profiles (spec > 1400) don't have talents
    if spec > 1400 then return talents end

    local activeSpecGroup = base.C_SpecializationInfo and base.C_SpecializationInfo.GetActiveSpecGroup and base.C_SpecializationInfo.GetActiveSpecGroup()
    if not activeSpecGroup then return talents end

    -- MoP/Classic talents: 7 tiers x 3 columns
    for tier = 1, 7 do
        for column = 1, 3 do
            local info = base.C_SpecializationInfo and base.C_SpecializationInfo.GetTalentInfo and
                         base.C_SpecializationInfo.GetTalentInfo({ tier = tier, column = column, specializationIndex = activeSpecGroup })
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
