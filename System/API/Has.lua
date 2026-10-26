---
-- These functions help in retrieving information if you have an item or not.
-- Has functions are the profile API table `has` (br.api.profile.has); profiles use it by name.
-- For item has, `item` in the function represent the name in the items list defined in System/List/Items.lua
-- @module has
local _, br = ...

-- The functions that take an item ID or slot, built once per spec
br.api.build.has = function(api)
    local has = api.has
    has.stats = has.stats or {}

    --- Checks if the specified `itemID` is in your bags or not.
    -- Note: `item` here is literally item, you pass the itemID to specify the item
    -- @function has.item
    -- @number itemID The ID of the item to check for.
    -- @treturn boolean
    has.item = function(itemID)
        if itemID == nil then return false end
        return br.functions.item:hasItem(itemID)
    end

    --- Checks if an inventory item has any of chosen DPS stats.
    -- @function has.stats.dps
    -- @number itemSlot The slot number in the player's inventory where the item is located.
    -- @string desiredStat A string representing the desired stat to check. It can be one of:
    -- 'agility', 'strength', 'intellect', 'crit', 'haste', 'mastery', 'versatility', or 'anyDps'.
    -- 'anyDps' checks for any DPS-related stat. If `desiredStat` is not recognized, it defaults to 'anyDps'.
    -- @treturn boolean True if the item has the chosen DPS stat, False otherwise.
    has.stats.dps = function(itemSlot, desiredStat)
        local itemLink = br.functions.item:getSlotLink(itemSlot)
        if not itemLink then return false end
        return br.functions.item:hasDPSStats(itemLink, desiredStat)
    end
end

-- has.<item>, for each item in the item list
br.api.build.hasItem = function(has, item, id)
    --- Checks if item is in your bags or not.
    -- Note: `item` here refers to the name in the item list defined in System/List/Items.lua
    -- @function has.<item>
    -- @return boolean
    has[item] = function()
        if type(id) == "table" then
            return br.functions.item:getHighestHeldRank(id) ~= nil
        end
        return br.functions.item:hasItem(id)
    end
end
