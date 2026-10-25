---
-- These functions help in retrieving information if you have an item or not.
-- Has functions are the profile API table `has` (br.api.profile.has); profiles use it by name.
-- For item has, `item` in the function represent the name in the items list defined in System/List/Items.lua
-- @module has
local _, br = ...

br.api.build.has = function(api,item,id)
    if api[item] == nil then api[item] = {} end
    local has = api

    --- ### Item Has Functions

    if has.stats == nil then has.stats = {} end

    --- Checks if item is in your bags or not.
    -- Note: `item` here refers to the name in the item list defined in System/List/Items.lua
    -- @function has.item
    -- @return boolean
    has[item] = function()
        if type(id) == "table" then
            return br.functions.item:getHighestHeldRank(id) ~= nil
        end
        return br.functions.item:hasItem(id)
    end

    if has.item == nil then
        --- Checks if the specified `itemID` is in your bags or not.
        -- Note: `item` here is literally item, you pass the itemID to specify the item
        -- @function has.item
        -- @number itemID The ID of the item to check for.
        -- @treturn boolean
        has.item = function(itemID)
            if itemID == nil then return end
            return br.functions.item:hasItem(itemID)
        end
    end

    --- Checks if an inventory item has any of chosen DPS stats.
    -- @function has.stats.dps
    -- @tparam itemSlot The slot number in the player's inventory where the item is located.
    -- @tparam desiredStat A string representing the desired stat to check. It can be one of:
    -- 'agility', 'strength', 'intellect', 'crit', 'haste', 'mastery', 'versatility', or 'anyDps'.
    -- 'anyDps' checks for any DPS-related stat. If `desiredStat` is not recognized, it defaults to 'anyDps'.
    -- @treturn bool True if the item has the chosen DPS stat, False otherwise.
    has.stats.dps = function(itemSlot, desiredStat)
        local statMap = {
            agility = "ITEM_MOD_AGILITY_SHORT",
            strength = "ITEM_MOD_STRENGTH_SHORT",
            intellect = "ITEM_MOD_INTELLECT_SHORT",
            crit = "ITEM_MOD_CRIT_RATING_SHORT",
            haste = "ITEM_MOD_HASTE_RATING_SHORT",
            mastery = "ITEM_MOD_MASTERY_RATING_SHORT",
            versatility = "ITEM_MOD_VERSATILITY"
        }

        local itemLink = br.functions.item:getSlotLink(itemSlot)
        if itemLink then
            local statStr = statMap[desiredStat]

            if statStr or desiredStat == "anyDps" then
                return br.functions.item:hasDPSStats(itemLink, statStr)
            else
                -- If desiredStat isn't found in the map, check for any DPS stat.
                return br.functions.item:hasDPSStats(itemLink)
            end
        end

        return false
    end
end