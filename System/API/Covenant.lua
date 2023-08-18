---
-- This table provides information about covenants *Shadowlands*.
-- Covenant data is stored in br.player.covenant and can be utilized by `local covenant = br.player.covenant` in your profile.
-- @module br.player.covenant
local _, br = ...
if br.api == nil then br.api = {} end

--- Checks if you are a part of the specified covenant or not.
-- @field kyrian.active A boolean indicating if Kyrian is the active covenant.
-- @field venthyr.active A boolean indicating if Venthyr is the active covenant.
-- @field nightFae.active A boolean indicating if Night Fae is the active covenant.
-- @field necrolord.active A boolean indicating if Necrolord is the active covenant.
-- @field none.active A boolean indicating if there is no active covenant.
-- @table covenant
br.api.covenant = function(covenant)
    local activeID = br._G.C_Covenants.GetActiveCovenantID()
    if br._G.C_Covenants.GetActiveCovenantID() ~= nil then
        covenant.kyrian.active = activeID == 1
        covenant.venthyr.active = activeID == 2
        covenant.nightFae.active = activeID == 3
        covenant.necrolord.active = activeID == 4
        covenant.none.active = activeID == 0
    end
end