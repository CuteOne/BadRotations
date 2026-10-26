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

br.api.build.talent = function(talent, name, state)
    if talent.rank == nil then talent.rank = {} end
    ------------------
    --- Talent API ---
    ------------------

    ---
    -- Sets talent information in the provided talent table:
    --
    -- - talent[name] = boolean indicating if the talent is active
    -- - talent.rank[name] = number indicating the talent rank
    talent[name] = state ~= nil and state.active or false
    talent.rank[name] = state ~= nil and state.rank or 0
end
