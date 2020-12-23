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
            return isKnown(v)
        end
    end
    if subtable == "cd" then -- Moved to own file API\CD.lua
        -- if spells[k] == nil then spells[k] = {} end
        -- local cd = spells[k]
        -- cd.exists = function()
        --     return getSpellCD(v) > 0
        -- end
        -- cd.remain = function()
        --     return getSpellCD(v)
        -- end
        -- cd.remains = function()
        --     return getSpellCD(v)
        -- end
        -- cd.duration = function()
        --     local _, CD = GetSpellCooldown(v)
        --     return CD
        -- end
        -- cd.ready = function()
        --     return getSpellCD(v) == 0
        -- end
    end
    if subtable == "charges" then
        if spells[k] == nil then spells[k] = {} end
        local charges = spells[k]
        charges.exists = function()
            return getCharges(v) >= 1
        end
        charges.count = function()
            return getCharges(v)
        end
        charges.frac = function()
            return getChargesFrac(v)
        end
        charges.max = function()
            return getChargesFrac(v,true)
        end
        charges.recharge = function(chargeMax)
            if chargeMax then
                return getRecharge(v,true)
            else
                return getRecharge(v)
            end
        end
        charges.timeTillFull = function()
            return getFullRechargeTime(v)
        end
    end
end