---
-- These functions help in retrieving information about spell and item charges.
-- Charge functions are the profile API table `charges` (br.api.profile.charges); profiles use it by name.
-- For spell charges, `spell` in the function represent the name in the actions list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- For item charges, `item` in the function represent the name in the item list defined in System/List/Items.lua
-- @module charges
local _, br = ...

br.api.build.charges = function(api, spell, id)
    if api[spell] == nil then api[spell] = {} end
    local charges = api[spell]

    --- Gets the number of charges remaining on spell.
    -- @function charges.spell.count
    -- @return number
    charges.count = function()
        local spellID = br.functions.spell:currentRank(id)
        return br.functions.spell:getCharges(spellID)
    end

    --- Checks if spell has charges or not.
    -- @function charges.spell.exists
    -- @return boolean
    charges.exists = function()
        local spellID = br.functions.spell:currentRank(id)
        return br.functions.spell:getCharges(spellID) >= 1
    end

    --- Gets the number of charges remaining on spell as a fraction. (e.g. 1.5 charges remaining)
    -- @function charges.spell.frac
    -- @return number
    charges.frac = function()
        local spellID = br.functions.spell:currentRank(id)
        return br.functions.spell:getChargesFrac(spellID)
    end

    --- Gets the maximum number of charges the spell can have.
    -- @function charges.spell.max
    -- @return number
    charges.max = function()
        local spellID = br.functions.spell:currentRank(id)
        return br.functions.spell:getChargesFrac(spellID, true)
    end

    --- Gets the time remaining on until next charge is available.
    -- @function charges.spell.remain
    -- @bool[opt] chargeMax If true, returns the time remaining until all charges are available.
    -- @return number
    charges.recharge = function(chargeMax)
        local spellID = br.functions.spell:currentRank(id)
        if chargeMax then
            return br.functions.spell:getRecharge(spellID, true)
        else
            return br.functions.spell:getRecharge(spellID)
        end
    end

    charges.spellCount = function()
        local spellID = br.functions.spell:currentRank(id)
        return br.functions.spell:getCastCount(spellID)
    end

    --- Gets the total time remaining until all charges are available.
    -- @function charges.spell.timeTillFull
    -- @return number
    charges.timeTillFull = function()
        local spellID = br.functions.spell:currentRank(id)
        return br.functions.spell:getFullRechargeTime(spellID)
    end
end

br.api.build.itemCharges = function(api, item, id)
    if api[item] == nil then api[item] = {} end
    local charges = api[item]

    --- Gets the number of charges remaining on item.
    -- @function charges.item.count
    -- @return number
    charges.count = function()
        return br.functions.item.itemCharges(id)
    end

    --- Checks if item has charges or not.
    -- @function charges.item.exists
    -- @return boolean
    charges.exists = function()
        return br.functions.item.itemCharges(id) > 0
    end
end
