local _, br = ...
if br.api == nil then br.api = {} end
-- cd is the table located at br.player.cd
-- charges is the table located at br.player.charges
-- cast is the table located at br.player.cast
-- v is the spellID passed from the builder which cycles all the collected ability spells from the spell list for the spec
-- spell in the examples represent the name in the ability list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
br.api.spells = function(spells,k,v,subtable)
    if subtable == "known" then
        if spells.known == nil then spells.known = {} end
        local known = spells.known
        known[k] = function()
            return br.isKnown(v)
        end
    end
    if subtable == "charges" then
        -- if spells[k] == nil then spells[k] = {} end
        -- local charges = spells[k]
        -- charges.exists = function()
        --     return br.getCharges(v) >= 1
        -- end
        -- charges.count = function()
        --     return br.getCharges(v)
        -- end
        -- charges.frac = function()
        --     return br.getChargesFrac(v)
        -- end
        -- charges.max = function()
        --     return br.getChargesFrac(v,true)
        -- end
        -- charges.recharge = function(chargeMax)
        --     if chargeMax then
        --         return br.getRecharge(v,true)
        --     else
        --         return br.getRecharge(v)
        --     end
        -- end
        -- charges.timeTillFull = function()
        --     return br.getFullRechargeTime(v)
        -- end
    end
    if spells.info == nil then spells.info = {} end
    local info = spells.info
    if info[k] == nil then info[k] = {} end
    info[k].texture = function()
        return br._G.GetSpellTexture(v)
    end
end