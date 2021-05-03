local _, br = ...
if br.api == nil then br.api = {} end
local MAW_BUFF_MAX_DISPLAY = 44;
br.api.animas = function(anima,v)
    anima.exists = function()
        for i=1, MAW_BUFF_MAX_DISPLAY do
            local spellName, spellIcon, count, _, _, _, _, _, _, spellID = br._G.UnitAura("player", i, "MAW");
            if spellID == v then
                return true
            end
        end
        return false
    end
end