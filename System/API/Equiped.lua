---
-- These functions help in retrieving information about equiped items.
-- Equiped Item functions are the profile API table `equiped` (br.api.profile.equiped); profiles use it by name.
-- `item` in the function represent the name in the item list defined in System/List/Items.lua
-- @module equiped

local _, br = ...

-- The functions that take an item ID, tier or type, built once per spec
br.api.build.equiped = function(api)
    local equiped = api.equiped

    --- This function checks if the specified itemID is equipped or not.
    -- It can also check a specific slotID.
    -- If no slotID is provided, it checks all slots for that item.
    -- @function equiped.item
    -- @number itemID the ID of the item you want to check if it's equipped
    -- @number[opt] slotID If specified, the ID of the slot you want to check for the given item.
    -- @treturn boolean whether the item is equipped (in the slot, if given)
    -- @usage equiped.item(12345) -- true if item 12345 is equipped anywhere
    -- @usage equiped.item(12345, 1) -- true if item 12345 is equipped in slot 1
    equiped.item = function(itemID, slotID)
        return br.functions.item:hasEquiped(itemID, slotID)
    end

    --- Gets the number of equiped items for the specified `tierLevel`, or with numEquiped whether
    -- at least that many are equiped.
    -- @function equiped.tier
    -- @param tierLevel string|number The tier level to check for. (e.g. "T20" or 20)
    -- @number[opt] numEquiped How many pieces to require
    -- @treturn number|boolean
    equiped.tier = function(tierLevel, numEquiped)
        if type(tierLevel) == "number" then tierLevel = "T" .. tierLevel end
        if numEquiped == nil then return br.functions.item:TierScan(tierLevel) end
        return br.functions.item:TierScan(tierLevel) >= numEquiped
    end

    --- Checks if you have the specified `itemType` equiped or not.
    -- @function equiped.type
    -- @string itemType The type of item to check for. (e.g. "Weapon" or "Trinket")
    -- @treturn boolean
    equiped.type = function(itemType)
        if itemType == nil then return false end
        return br.functions.item:isEquippedType(itemType)
    end
end

-- equiped.<item>, for each item in the item list
br.api.build.equipedItem = function(equiped, item, id)
    --- Checks if item is equiped or not.
    -- @function equiped.<item>
    -- @number[opt] slotID The equipment slot number to check.
    -- @treturn boolean
    equiped[item] = function(slotID)
        return br.functions.item:hasEquiped(id, slotID)
    end
end
