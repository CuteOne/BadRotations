---
-- These functions help in retrieving information about equiped items.
-- Equiped Item functions are stored in br.player.equiped and can be utilized by `local equiped = br.player.equiped` in your profile.
-- `item` in the function represent the name in the item list defined in System/List/Items.lua
-- @module br.player.equiped

local _, br = ...
if br.api == nil then br.api = {} end

br.api.equiped = function(self,item,id)
    if self[item] == nil then self[item] = {} end
    local equiped = self

    --- Checks if item is equiped or not.
    -- @function equiped.item.exists
    -- @number[opt] slotID The equipment slot number to check.
    -- @treturn boolean
    equiped[item] = function(slotID)
        if slotID == nil then
            return br.hasEquiped(id)
        else
            return br.hasEquiped(id,slotID)
        end
    end

    --- This function checks if the specified itemID is equipped or not.
    -- It can also check a specific slotID.
    -- If no slotID is provided, it checks all slots for that item.
    -- @param itemID the ID of the item you want to check if it's equipped
    -- @param slotID optional parameter. If specified, it represents the ID
    -- of the slot you want to check for the existence of the given item.
    -- @return boolean value indicating whether the item with specific ID is equipped in the specified slot (if provided)
    -- @usage equipes.item(12345) -- will return true if item with ID 12345 is equipped anywhere
    -- @usage equipes.item(12345, 1) -- will return true if item with ID 12345 is equipped in slot 1
    equiped.item = function(itemID,slotID)
        if slotID == nil then
            return br.hasEquiped(itemID)
        else
            return br.hasEquiped(itemID,slotID)
        end
    end

    --- Checks if the specified `gemID` is equiped in the item's socket or not.
    -- @function equiped.item.socket
    -- @number gemID The ID of the gem to check for.
    -- @treturn boolean
    equiped.socket[item] = function(gemID)
        local socketSpell = br._G.GetItemSpell(id)
        local checkSpell = br._G.GetItemInfo(gemID)
        return socketSpell == checkSpell
    end

    --- Gets the number of equiped items for the specified `tierLevel`.
    -- @function equiped.tier
    -- @param tierLevel string|number The tier level to check for. (e.g. "T20" or 20)
    -- @treturn number
    equiped.tier = function(tierLevel,numEquiped)
        if type(tierLevel) == "number" then tierLevel = "T"..tierLevel end
        return br.TierScan(tierLevel) >= numEquiped
    end

    if equiped.type == nil then
        --- Checks if you have the specified `itemType` equiped or not.
        -- @function equiped.type
        -- @string itemType The type of item to check for. (e.g. "Weapon" or "Trinket")
        -- @treturn boolean
        equiped.type = function(itemType)
            local IsEquippedItemType = br._G["IsEquippedItemType"]
            if itemType == nil then return false end
            return IsEquippedItemType(itemType)
        end
    end
end