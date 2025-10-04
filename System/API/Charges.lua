---
-- These functions help in retrieving information about spell and item charges.
-- Charge functions are stored in br.player.charges and can be utilized by `local charges = br.player.charges` in your profile.
-- For spell charges, `spell` in the function represent the name in the actions list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- For item charges, `item` in the function represent the name in the item list defined in System/List/Items.lua
-- @module br.player.charges
local _, br = ...
if br.api == nil then br.api = {} end

br.api.charges = function(self, spell, id)
    if self[spell] == nil then self[spell] = {} end
    local charges = self[spell]

    --- Checks if spell has charges or not.
    -- @function charges.spell.exists
    -- @return boolean
    charges.exists = function()
        return br.functions.spell:getCharges(id) >= 1
    end

    --- Gets the number of charges remaining on spell.
    -- @function charges.spell.count
    -- @return number
    charges.count = function()
        return br.functions.spell:getCharges(id)
    end

    charges.spellCount = function()
        return br._G.C_Spell.GetSpellCastCount(id)
    end

    --- Gets the number of charges remaining on spell as a fraction. (e.g. 1.5 charges remaining)
    -- @function charges.spell.frac
    -- @return number
    charges.frac = function()
        return br.functions.spell:getChargesFrac(id)
    end

    --- Gets the maximum number of charges the spell can have.
    -- @function charges.spell.max
    -- @return number
    charges.max = function()
        return br.functions.spell:getChargesFrac(id, true)
    end

    --- Gets the time remaining on until next charge is available.
    -- @function charges.spell.remain
    -- @bool[opt] chargeMax If true, returns the time remaining until all charges are available.
    -- @return number
    charges.recharge = function(chargeMax)
        if chargeMax then
            return br.functions.spell:getRecharge(id, true)
        else
            return br.functions.spell:getRecharge(id)
        end
    end

    --- Gets the total time remaining until all charges are available.
    -- @function charges.spell.timeTillFull
    -- @return number
    charges.timeTillFull = function()
        return br.functions.spell:getFullRechargeTime(id)
    end
end

br.api.itemCharges = function(self, item, id)
    if self[item] == nil then self[item] = {} end
    local charges = self[item]

    --- Checks if item has charges or not.
    -- @function charges.item.exists
    -- @return boolean
    charges.exists = function()
        return br.functions.item.itemCharges(id) > 0
    end

    --- Gets the number of charges remaining on item.
    -- @function charges.item.count
    -- @return number
    charges.count = function()
        return br.functions.item.itemCharges(id)
    end
end
