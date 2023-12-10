---
-- These functions help in retrieving information if you have an item or not.
-- Has functions are stored in br.player.has and can be utilized by `local has = br.player.has` in your profile.
-- For item has, `item` in the function represent the name in the items list defined in System/List/Items.lua
-- @module br.player.has
local _, br = ...
if br.api == nil then br.api = {} end

br.api.has = function(self,item,id)
    if self[item] == nil then self[item] = {} end
    local has = self

    --- ### Item Has Functions

    --- Checks if item is in your bags or not.
    -- Note: `item` here refers to the name in the item list defined in System/List/Items.lua
    -- @function has.item
    -- @treturn boolean
    has[item] = function()
        return br.hasItem(id)
    end

    if has.item == nil then
        --- Checks if the specified `itemID` is in your bags or not.
        -- Note: `item` here is literally item, you pass the itemID to specify the item
        -- @function has.item
        -- @number itemID The ID of the item to check for.
        -- @treturn boolean
        has.item = function(itemID)
            if itemID == nil then return end
            return br.hasItem(itemID)
        end
    end

    if has.stats == nil then has.stats = {} end

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

        local function hasDPSStats(itemLink, matchStat)
            local stats = br._G.GetItemStats(itemLink) or {}

            -- Define the stats that contribute to DPS.
            local dpsStats = {"ITEM_MOD_AGILITY_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_INTELLECT_SHORT",
                                "ITEM_MOD_CRIT_RATING_SHORT", "ITEM_MOD_HASTE_RATING_SHORT",
                                "ITEM_MOD_MASTERY_RATING_SHORT", "ITEM_MOD_VERSATILITY"}

            -- If a desired stat is specified, check if the item has that stat.
            if matchStat then return stats[matchStat] end

            -- If no desired stat is specified, check if the item has any DPS stats.
            for _, stat in ipairs(dpsStats) do
                if stats[stat] then return true end
            end

            return false
        end

        local itemLink = br._G.GetInventoryItemLink("player", itemSlot)
        if itemLink then
            local statStr = statMap[desiredStat]

            if statStr or desiredStat == "anyDps" then
                return hasDPSStats(itemLink, statStr)
            else
                -- If desiredStat isn't found in the map, check for any DPS stat.
                return hasDPSStats(itemLink)
            end
        end

        return false
    end

end