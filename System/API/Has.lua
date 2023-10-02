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
end