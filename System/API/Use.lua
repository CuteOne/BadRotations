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
            if br.functions.item:canUseItem(id) then return br.functions.item:useItem(id,thisUnit) else return end
        else
            if br.functions.item:canUseItem(slotID) then return br.functions.item:useItem(slotID,thisUnit) else return end
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
            if br.functions.item:canUseItem(itemID) then
                return br.functions.item:useItem(itemID,thisUnit)
            else
                return
            end
        end
    end
    
    if use.bestItem == nil then
        --- Uses the best possible item in a list of items.
        -- in the items.lua usage precedence will be the order the items appear in the array from first to last.
        -- typically for using higher quality items first, such as gold items over silver, etc.
        -- example, howlingRuneQualities = {194820,194819,194817} would attempt to use 194820 (gold qual) first, then 194819 (silver qaul) second, etc.
        -- @function use.bestItem()
        -- @array itemIDs The array of variable quality items.
        -- @string[opt="target"] thisUnit The unit to use the item on.
        -- @treturn boolean
        use.bestItem = function(itemIDs,thisUnit)
            if itemIDs == nil then return false end
            if thisUnit == nil then thisUnit = "player" end
            for i=1,#itemIDs do
               if br.functions.item:canUseItem(itemIDs[i])  then
                    return br.functions.item:useItem(itemIDs[i],thisUnit)
               end
            end
        end
    end

    if use.isOneOfUsable == nil then
        --- iterates through a list of items and returns true if they are usable
        -- typically for using higher quality items first, such as gold items over silver, etc.
        -- example, howlingRuneQualities = {194820,194819,194817} would attempt to use 194820 (gold qual) first, then 194819 (silver qaul) second, etc.
        -- @function use.isOneOfUsable()
        -- @array itemIDs The array of variable quality items.
        -- @treturn boolean
        use.isOneOfUsable = function(itemIDs)
            if itemIDs == nil then return false end
            for i=1, #itemIDs do
                if br.functions.item:canUseItem(itemIDs[i]) then return true end
            end
            return false
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
            if br.functions.item:canUseItem(slotID) then return br.functions.item:useItem(slotID,thisUnit) else return end
        end
    end

    if use.able == nil then use.able = {} end
    --- Checks if item is usable or not.
    -- Note: `item` here refers to the name in the item list defined in System/List/Items.lua
    -- @function use.able.item
    -- @number[opt] slotID The ID of the equipment slot to check.
    -- @treturn boolean
    use.able[item] = function(slotID)
        if slotID == nil then return br.functions.item:canUseItem(id) else return br.functions.item:canUseItem(slotID) end
    end

    if use.able.item == nil then
        --- Checks if item is usable or not.
        -- Note: `item` here is literally item, you pass the itemID to specify the item
        -- @function use.able.item
        -- @number itemID The ID of the item check.
        -- @treturn boolean
        use.able.item = function(itemID)
            if itemID == nil then return false end
            return br.functions.item:canUseItem(itemID)
        end
    end

    if use.able.slot == nil then
        --- Checks if item in the specified equipment slot is usable or not.
        -- @function use.able.slot
        -- @number slotID The ID of the equipment slot to check.
        -- @treturn boolean
        use.able.slot = function(slotID)
            return br.functions.item:canUseItem(slotID)
        end
    end
end