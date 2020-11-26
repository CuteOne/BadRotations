local br = _G["br"]
if br.api == nil then br.api = {} end
br.api.conduit = function(conduit,k,v)
    conduit.enabled = function()
        return self.spells.known[k]
    end
end