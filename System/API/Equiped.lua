---
-- These functions help in retrieving information about equiped items.
-- Equiped Item functions are the profile API table `equiped` (br.api.profile.equiped); profiles use it by name.
-- `item` in the function represent the name in the item list defined in System/List/Items.lua
-- @module equiped

local _, br = ...

br.api.build.equiped = function(api, item, id)
    if api[item] == nil then api[item] = {} end
    local equiped = api

    --- Checks if item is equiped or not.
    -- @function equiped.<item>
    -- @number[opt] slotID The equipment slot number to check.
    -- @treturn boolean
    equiped[item] = function(slotID)
        if slotID == nil then
            return br.functions.item:hasEquiped(id)
        else
            return br.functions.item:hasEquiped(id, slotID)
        end
    end

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
        if slotID == nil then
            return br.functions.item:hasEquiped(itemID)
        else
            return br.functions.item:hasEquiped(itemID, slotID)
        end
    end

    --- Checks if the specified `gemID` is equiped in the item's socket or not.
    -- @function equiped.socket.<item>
    -- @number gemID The ID of the gem to check for.
    -- @treturn boolean
    equiped.socket[item] = function(gemID)
        local socketSpell = br.functions.item:getSpellName(id)
        local checkSpell = br.functions.item:getName(gemID)
        return socketSpell == checkSpell
    end

    --- Gets the number of equiped items for the specified `tierLevel`.
    -- @function equiped.tier
    -- @param tierLevel string|number The tier level to check for. (e.g. "T20" or 20)
    -- @treturn number
    equiped.tier = function(tierLevel, numEquiped)
        if type(tierLevel) == "number" then tierLevel = "T" .. tierLevel end
        if numEquiped == nil then return br.functions.item:TierScan(tierLevel) end
        return br.functions.item:TierScan(tierLevel) >= numEquiped
    end

    if equiped.type == nil then
        --- Checks if you have the specified `itemType` equiped or not.
        -- @function equiped.type
        -- @string itemType The type of item to check for. (e.g. "Weapon" or "Trinket")
        -- @treturn boolean
        equiped.type = function(itemType)
            if itemType == nil then return false end
            return br.functions.item:isEquippedType(itemType)
        end
    end
end
