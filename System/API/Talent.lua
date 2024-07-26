---
-- These calls help in retrieving information about talent based checks.
-- talent is the table located at br.player.talent, call this in profile to use.
-- name in the examples represent the name in the talent list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
--
-- `br.player.talent` has the following checks:
--
-- br.player.talent.name - Indicates if the talent is active.
--
-- br.player.talent.rank.name - Returns the rank of the specified talent.
--
-- @module br.player.talent

local _, br = ...
if br.api == nil then br.api = {} end
----------------------
--- ABOUT THIS API ---
----------------------

-- These calls help in retrieving information about talent based checks.
-- talent is the table located at br.player.talent, call this in profile to use.

br.api.talent = function(talent, name, id, allTalents, spellList)
    if talent == nil then talent = {} end
    if talent[name] == nil then talent[name] = false end
    if talent.rank == nil then talent.rank = {} end
    if talent.rank[name] == nil then talent.rank[name] = 0 end
    if allTalents == nil then return end

    -- Check if ID is a talent and if active spell add to abilities and spell table if not preset.
    local talentFound = false
    if br._G.IsPlayerSpell(id) or allTalents[id] then
        talentFound = true
        if not br._G.C_Spell.IsSpellPassive(id) and spellList['abilities'][name] == nil then
            spellList['abilities'][name] = id
            spellList[name] = id
        end
    end
    -- No matching talent for listed talent id, report to dev
    if not talentFound or allTalents[id] == nil then
        br._G.print("|cffff0000No talent found for: |r" ..
            name ..
            " (" ..
            id .. ") |cffff0000in the talent spell list, please notify profile developer to remove from the list.")
        return
    end
    ------------------
    --- Talent API ---
    ------------------
    -- Active
    talent[name] = allTalents[id].active
    -- Rank
    talent.rank[name] = allTalents[id].rank
end
