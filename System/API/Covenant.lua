local br = _G["br"]
if br.api == nil then br.api = {} end
br.api.covenant = function(covenant,k)
    if covenant.kyrian.active == nil then
        local activeID = C_Covenants.GetActiveCovenantID()
        covenant.kyrian.active = activeID == 1
        covenant.venthyr.active = activeID == 2
        covenant.nightFae.active = activeID == 3
        covenant.necrolord.active = activeID == 4
    end
    covenant[k].enabled = function()
        return self.spells.known[k]
    end
end