---
-- These functions help in retrieving information if you can use an item or not.
-- Use functions are the profile API table `use` (br.api.profile.use); profiles use it by name.
-- For item use, `item` in the function represent the name in the items list defined in System/List/Items.lua
-- An item list entry may be a table of ranks: the best one held is used.
-- use.able.<item>() says whether the item is ready. use.<item>() also waits while the player casts or
-- channels, like cast.<spell>(); use.<item>.whileCasting() (and use.slot.whileCasting(13), ...) uses it
-- anyway, for items the game allows during a cast.
-- @module use
local _, br = ...

-- Uses an item (ID, rank list or equipment slot) when it can be used and the player's own cast or
-- channel doesn't hold it (misc:ownCastHold; .whileCasting lifts that)
local function useWhenAble(itemOrSlot, thisUnit)
    if itemOrSlot == nil or not br.functions.item:canUseItem(itemOrSlot) then return false end
    if not br.functions.cast.allowWhileCasting and br.functions.misc:ownCastHold() ~= nil then return false end
    return br.functions.item:useItem(itemOrSlot, thisUnit or "target")
end

-- A use function that is also callable as .whileCasting(...)
local function withWhileCasting(use)
    return setmetatable({ whileCasting = function(...) return br.functions.cast:callWhileCasting(use, ...) end },
        { __call = function(_, ...) return use(...) end })
end

-- The functions that take an item ID or slot, built once per spec
br.api.build.use = function(api)
    local use = api.use
    use.able = use.able or {}

    --- Checks if item is usable or not.
    -- Note: `item` here is literally item, you pass the itemID to specify the item
    -- @function use.able.item
    -- @number itemID The ID of the item check.
    -- @treturn boolean
    use.able.item = function(itemID)
        if itemID == nil then return false end
        return br.functions.item:canUseItem(itemID)
    end

    --- Checks if item in the specified equipment slot is usable or not.
    -- @function use.able.slot
    -- @number slotID The ID of the equipment slot to check.
    -- @treturn boolean
    use.able.slot = function(slotID)
        return br.functions.item:canUseItem(slotID)
    end

    --- Uses the item.
    -- Note: `item` here is literally item, you pass the itemID to specify the item
    -- @function use.item
    -- @number itemID The ID of the item to use.
    -- @string[opt="target"] thisUnit The unit to use the item on.
    -- @treturn boolean
    use.item = withWhileCasting(function(itemID, thisUnit)
        return useWhenAble(itemID, thisUnit)
    end)

    --- Uses the item in the specified equipment slot.
    -- @function use.slot
    -- @number slotID The ID of the equipment slot to use the item from.
    -- @string[opt="target"] thisUnit The unit to use the item on.
    -- @treturn boolean
    use.slot = withWhileCasting(function(slotID, thisUnit)
        return useWhenAble(slotID, thisUnit)
    end)
end

-- use.<item> and use.able.<item>, for each item in the item list
br.api.build.useItem = function(use, item, id)
    --- Checks if item is usable or not.
    -- Note: `item` here refers to the name in the item list defined in System/List/Items.lua
    -- @function use.able.<item>
    -- @number[opt] slotID The ID of the equipment slot to check.
    -- @treturn boolean
    use.able[item] = function(slotID)
        return br.functions.item:canUseItem(slotID or id)
    end

    --- Uses the item.
    -- @function use.<item>
    -- @number[opt] slotID The equipment slot number to use the item from.
    -- @string[opt="target"] thisUnit The unit to use the item on.
    -- @treturn boolean
    use[item] = withWhileCasting(function(slotID, thisUnit)
        return useWhenAble(slotID or id, thisUnit)
    end)
end
