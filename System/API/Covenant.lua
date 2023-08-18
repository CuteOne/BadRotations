---
-- This table provides information about covenants *Shadowlands*.
-- Covenant data is stored in br.player.covenant and can be utilized by `local covenant = br.player.covenant` in your profile.
-- br.player.covenant has checks to determine if you are a part of the specified covenant or not.
-- br.player.covenant.kyrian.active - Indicates if Kyrian is the active covenant.
-- br.player.covenant.venthyr.active - Indicates if Venthyr is the active covenant.
-- br.player.covenant.nightFae.active - Indicates if Night Fae is the active covenant.
-- br.player.covenant.necrolord.active - Indicates if Necrolord is the active covenant.
-- br.player.covenant.none.active - Indicates if there are no active covenants.
-- @module br.player.covenant

local _, br = ...
if br.api == nil then br.api = {} end

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