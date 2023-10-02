---
-- These functions help in retrieving information if you can use an item or not.
-- Use functions are stored in br.player.use and can be utilized by `local use = br.player.use` in your profile.
-- For item use, `item` in the function represent the name in the items list defined in System/List/Items.lua
-- @module br.player.use
local _, br = ...
if br.api == nil then br.api = {} end

br.api.use = function(self,item,id)
    local use = self

    --- ### Item Use Functions

    --- Uses the item.
    -- @function use.item
    -- @number[opt] slotID The equipment slot number to use the item from.
    -- @string[opt="target"] thisUnit The unit to use the item on.
    -- @treturn boolean
    use[item] = function(slotID,thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        if slotID == nil then
            if br.canUseItem(id) then return br.useItem(id,thisUnit) else return end
        else
            if br.canUseItem(slotID) then return br.useItem(slotID,thisUnit) else return end
        end
    end

    if use.item == nil then
        --- Uses the item.
        -- Note: `item` here is literally item, you pass the itemID to specify the item
        -- @function use.item
        -- @number itemID The ID of the item to use.
        -- @string[opt="target"] thisUnit The unit to use the item on.
        -- @treturn boolean
        use.item = function(itemID,thisUnit)
            if itemID == nil then return false end
            if thisUnit == nil then thisUnit = "target" end
            if br.canUseItem(itemID) then
                return br.useItem(itemID,thisUnit)
            else
                return
            end
        end
    end

    if use.slot == nil then
        --- Uses the item in the specified equipment slot.
        -- @function use.slot
        -- @number slotID The ID of the equipment slot to use the item from.
        -- @string[opt="target"] thisUnit The unit to use the item on.
        -- @treturn boolean
        use.slot = function(slotID,thisUnit)
            if thisUnit == nil then thisUnit = "target" end
            if br.canUseItem(slotID) then return br.useItem(slotID,thisUnit) else return end
        end
    end

    if use.able == nil then use.able = {} end
    --- Checks if item is usable or not.
    -- Note: `item` here refers to the name in the item list defined in System/List/Items.lua
    -- @function use.able.item
    -- @number[opt] slotID The ID of the equipment slot to check.
    -- @treturn boolean
    use.able[item] = function(slotID)
        if slotID == nil then return br.canUseItem(id) else return br.canUseItem(slotID) end
    end

    if use.able.item == nil then
        --- Checks if item is usable or not.
        -- Note: `item` here is literally item, you pass the itemID to specify the item
        -- @function use.able.item
        -- @number itemID The ID of the item check.
        -- @treturn boolean
        use.able.item = function(itemID)
            if itemID == nil then return false end
            return br.canUseItem(itemID)
        end
    end

    if use.able.slot == nil then
        --- Checks if item in the specified equipment slot is usable or not.
        -- @function use.able.slot
        -- @number slotID The ID of the equipment slot to check.
        -- @treturn boolean
        use.able.slot = function(slotID)
            return br.canUseItem(slotID)
        end
    end
end