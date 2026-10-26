---
-- These functions help in retrieving information if you can use an item or not.
-- Use functions are the profile API table `use` (br.api.profile.use); profiles use it by name.
-- For item use, `item` in the function represent the name in the items list defined in System/List/Items.lua
-- An item list entry may be a table of ranks: the best one held is used.
-- @module use
local _, br = ...

-- Uses an item (ID, rank list or equipment slot) when it can be used
local function useWhenAble(itemOrSlot, thisUnit)
    if itemOrSlot == nil or not br.functions.item:canUseItem(itemOrSlot) then return false end
    return br.functions.item:useItem(itemOrSlot, thisUnit or "target")
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
    use.item = function(itemID, thisUnit)
        return useWhenAble(itemID, thisUnit)
    end

    --- Uses the item in the specified equipment slot.
    -- @function use.slot
    -- @number slotID The ID of the equipment slot to use the item from.
    -- @string[opt="target"] thisUnit The unit to use the item on.
    -- @treturn boolean
    use.slot = function(slotID, thisUnit)
        return useWhenAble(slotID, thisUnit)
    end
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
    use[item] = function(slotID, thisUnit)
        return useWhenAble(slotID or id, thisUnit)
    end
end
