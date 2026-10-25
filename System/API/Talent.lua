---
-- Talent handling functions for BadRotations.
-- These calls help in retrieving information about talent based checks.
-- talent is the profile API table `talent` (br.api.profile.talent).
--
-- @module talent
--
-- @usage
-- -- Check if a talent is active
-- if talent.talentName then
--     -- Do something
-- end
--
-- -- Get the rank of a talent
-- local rank = talent.rank.talentName
-- if rank > 1 then
--     -- Do something
-- end

local _, br = ...
----------------------
--- ABOUT THIS API ---
----------------------

-- These calls help in retrieving information about talent based checks.
-- talent is the profile API table `talent` (br.api.profile.talent).

br.api.build.talent = function(talent, name, id, allTalents, spellList)
    if talent == nil then talent = {} end
    if talent[name] == nil then talent[name] = false end
    if talent.rank == nil then talent.rank = {} end
    if talent.rank[name] == nil then talent.rank[name] = 0 end
    if allTalents == nil then return end

    -- Check if ID is a talent and if active spell add to abilities and spell table if not preset.
    local talentFound = false
    if br.functions.spell:isPlayerSpell(id) or allTalents[id] then
        talentFound = true
        if not br.functions.spell:isPassive(id) and spellList['abilities'][name] == nil then
            spellList['abilities'][name] = id
            spellList[name] = id
        end
    end
    -- No matching talent for listed talent id, report to dev (only for actual specs, not Initial profiles)
    if (not talentFound or allTalents[id] == nil) then
        -- Only for actual specs (Initial profiles and class-level specs are 1400 and up)
        if (br.loader.selectedSpecID or 0) < 1400 then
            br.log:warning("No talent found for " .. br.log.highlight(name .. " (" .. id .. ")")
                .. " in the talent spell list, please notify the profile developer to remove it from the list.")
        end
        return nil
    end
    ------------------
    --- Talent API ---
    ------------------

    ---
    -- Sets talent information in the provided talent table:
    --
    -- - talent[name] = boolean indicating if the talent is active
    -- - talent.rank[name] = number indicating the talent rank

    -- Active
    talent[name] = allTalents[id].active
    -- Rank
    talent.rank[name] = allTalents[id].rank
end
