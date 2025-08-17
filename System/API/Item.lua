-- ---
-- -- These functions help in retrieving information about items.
-- -- Item functions are stored in br.player.item and can be utilized by `local item = br.player.item` in your profile.
-- -- `item` in the function represent the name in the item list defined in System/List/Items.lua
-- -- @module br.player.item

local _, br = ...
if br.api == nil then br.api = {} end

br.api.items = function(item,k,v,subtable)
    if item[k] == nil then item[k] = {} end

    if subtable == "cd" then
        -- local cd = item
        -- --- ### Item Cooldown Functions

        -- --- Checks if item is on cooldown or not.
        -- -- @function cd.item.exists
        -- -- @number[opt] itemID The ID of the item to check.
        -- -- @treturn boolean
        -- cd[k].exists = function(itemID)
        --     if itemID == nil then itemID = v end
        --     return br._G.C_Container.GetItemCooldown(itemID) > 0
        -- end

        -- --- Gets the time remaining on item cooldown or 0 if not.
        -- -- @function cd.item.remain
        -- -- @number[opt] itemID The ID of the item to check.
        -- -- @treturn number
        -- cd[k].remain = function(itemID)
        --     if itemID == nil then itemID = v end
        --     if br._G.C_Container.GetItemCooldown(itemID) ~= 0 then
        --         return (br._G.C_Container.GetItemCooldown(itemID) + select(2,br._G.C_Container.GetItemCooldown(itemID)) - br._G.GetTime())
        --     end
        --     return 0
        -- end

        -- --- Gets the total cooldown time of the item in seconds.
        -- -- @function cd.item.duration
        -- -- @number[opt] itemID The ID of the item to check.
        -- -- @treturn number
        -- cd[k].duration = function(itemID)
        --     if itemID == nil then itemID = v end
        --     return br._G.GetSpellBaseCooldown(select(2,br._G.GetItemSpell(itemID))) / 1000
        -- end
    end

    -- if subtable == "charges" then
        -- local charges = item
        --- ### Item Charges Functions

        -- --- Checks if item has charges or not.
        -- -- @function charges.item.exists
        -- -- @treturn boolean
        -- charges[k].exists = function()
        --     return br.itemCharges(v) > 0
        -- end

        -- --- Gets the number of charges remaining on item.
        -- -- @function charges.item.count
        -- -- @treturn number
        -- charges[k].count = function()
        --     return br.itemCharges(v)
        -- end
    -- end

    -- if subtable == "equiped" then
    --     local equiped = item
    --     --- ### Item Equiped Functions

    --     --- Checks if item is equiped or not.
    --     -- @function equiped.item.exists
    --     -- @number[opt] slotID The equipment slot number to check.
    --     -- @treturn boolean
    --     equiped[k] = function(slotID)
    --         if slotID == nil then
    --             return br.hasEquiped(v)
    --         else
    --             return br.hasEquiped(v,slotID)
    --         end
    --     end

    --     --- Checks if the specified `gemID` is equiped in the item's socket or not.
    --     -- @function equiped.item.socket
    --     -- @number gemID The ID of the gem to check for.
    --     -- @treturn boolean
    --     equiped.socket[k] = function(gemID)
    --         local socketSpell = br._G.GetItemSpell(v)
    --         local checkSpell = br._G.GetItemInfo(gemID)
    --         return socketSpell == checkSpell
    --     end

    --     --- Gets the number of equiped items for the specified `tierLevel`.
    --     -- @function equiped.tier
    --     -- @param tierLevel string|number The tier level to check for. (e.g. "T20" or 20)
    --     -- @treturn number
    --     equiped.tier = function(tierLevel)
    --         if type(tierLevel) == "number" then tierLevel = "T"..tierLevel end
    --         return br.TierScan(tierLevel)
    --     end

    --     if equiped.type == nil then
    --         --- Checks if you have the specified `itemType` equiped or not.
    --         -- @function equiped.type
    --         -- @string itemType The type of item to check for. (e.g. "Weapon" or "Trinket")
    --         -- @treturn boolean
    --         equiped.type = function(itemType)
    --             local IsEquippedItemType = br._G["IsEquippedItemType"]
    --             if itemType == nil then return false end
    --             return IsEquippedItemType(itemType)
    --         end
    --     end
    -- end

    if subtable == "has" then
        -- local has = item
        -- --- ### Item Has Functions

        -- --- Checks if item is in your bags or not.
        -- -- Note: `item` here refers to the name in the item list defined in System/List/Items.lua
        -- -- @function has.item
        -- -- @treturn boolean
        -- has[k] = function()
        --     return br.hasItem(v)
        -- end

        -- if has.item == nil then
        --     --- Checks if the specified `itemID` is in your bags or not.
        --     -- Note: `item` here is literally item, you pass the itemID to specify the item
        --     -- @function has.item
        --     -- @number itemID The ID of the item to check for.
        --     -- @treturn boolean
        --     has.item = function(itemID)
        --         if itemID == nil then return end
        --         return br.hasItem(itemID)
        --     end
        -- end
    end

    if subtable == "use" then
        -- local use = item
        -- --- ### Item Use Functions

        -- --- Uses the item.
        -- -- @function use.item
        -- -- @number[opt] slotID The equipment slot number to use the item from.
        -- -- @string[opt="target"] thisUnit The unit to use the item on.
        -- -- @treturn boolean
        -- use[k] = function(slotID,thisUnit)
        --     if thisUnit == nil then thisUnit = "target" end
        --     if slotID == nil then
        --         if br.canUseItem(v) then return br.useItem(v,thisUnit) else return end
        --     else
        --         if br.canUseItem(slotID) then return br.useItem(slotID,thisUnit) else return end
        --     end
        -- end

        -- if use.item == nil then
        --     --- Uses the item.
        --     -- Note: `item` here is literally item, you pass the itemID to specify the item
        --     -- @function use.item
        --     -- @number itemID The ID of the item to use.
        --     -- @string[opt="target"] thisUnit The unit to use the item on.
        --     -- @treturn boolean
        --     use.item = function(itemID,thisUnit)
        --         if itemID == nil then return false end
        --         if thisUnit == nil then thisUnit = "target" end
        --         if br.canUseItem(itemID) then
        --             return br.useItem(itemID,thisUnit)
        --         else
        --             return
        --         end
        --     end
        -- end

        -- if use.slot == nil then
        --     --- Uses the item in the specified equipment slot.
        --     -- @function use.slot
        --     -- @number slotID The ID of the equipment slot to use the item from.
        --     -- @string[opt="target"] thisUnit The unit to use the item on.
        --     -- @treturn boolean
        --     use.slot = function(slotID,thisUnit)
        --         if thisUnit == nil then thisUnit = "target" end
        --         if br.canUseItem(slotID) then return br.useItem(slotID,thisUnit) else return end
        --     end
        -- end

        -- if use.able == nil then use.able = {} end
        -- --- Checks if item is usable or not.
        -- -- Note: `item` here refers to the name in the item list defined in System/List/Items.lua
        -- -- @function use.able.item
        -- -- @number[opt] slotID The ID of the equipment slot to check.
        -- -- @treturn boolean
        -- use.able[k] = function(slotID)
        --     if slotID == nil then return br.canUseItem(v) else return br.canUseItem(slotID) end
        -- end

        -- if use.able.item == nil then
        --     --- Checks if item is usable or not.
        --     -- Note: `item` here is literally item, you pass the itemID to specify the item
        --     -- @function use.able.item
        --     -- @number itemID The ID of the item check.
        --     -- @treturn boolean
        --     use.able.item = function(itemID)
        --         if itemID == nil then return false end
        --         return br.canUseItem(itemID)
        --     end
        -- end

        -- if use.able.slot == nil then
        --     --- Checks if item in the specified equipment slot is usable or not.
        --     -- @function use.able.slot
        --     -- @number slotID The ID of the equipment slot to check.
        --     -- @treturn boolean
        --     use.able.slot = function(slotID)
        --         return br.canUseItem(slotID)
        --     end
        -- end
    end
end
