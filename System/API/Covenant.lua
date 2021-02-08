local _, br = ...
if br.api == nil then br.api = {} end
br.api.covenant = function(covenant)
    local activeID = _G.C_Covenants.GetActiveCovenantID()
    if _G.C_Covenants.GetActiveCovenantID() ~= nil then
        covenant.kyrian.active = activeID == 1
        covenant.venthyr.active = activeID == 2
        covenant.nightFae.active = activeID == 3
        covenant.necrolord.active = activeID == 4
        covenant.none.active = activeID == 0
    end
end