if br.api == nil then br.api = {} end

br.api.items = function(item,k,v,subtable)
    if item[k] == nil then item[k] = {} end
    if subtable == "cd" then
        local cd = item
        cd[k].exists = function(slotID)
            if slotID == nil then slotID = v end
            return GetItemCooldown(slotID) > 0
        end
        cd[k].remain = function(slotID)
            if slotID == nil then slotID = v end
            return GetItemCooldown(slotID)
        end
    end
    if subtable == "charges" then
        local charges = item
        -- br.player.charges.item.exists()
        charges[k].exists = function()
            return itemCharges(v) > 0
        end
        -- br.player.charges.item.count()
        charges[k].count = function()
            return itemCharges(v)
        end
    end
    if subtable == "equiped" then
        local equiped = item
        -- br.player.equiped.item()
        equiped[k] = function(slotID)
            if slotID == nil then
                return hasEquiped(v)
            else
                return hasEquiped(v,slotID)
            end
        end
        equiped.socket[k] = function(gemID, socketIndex)
            if socketIndex == nil then socketIndex = 1 end
            local socketName = GetItemGem(GetItemInfo(v),socketIndex)
            local socketSpell = GetItemSpell(v)
            local checkSpell = GetItemInfo(gemID) 
            return socketSpell == checkSpell
        end
        if equiped.type == nil then
            equiped.type = function(itemType)
                local IsEquippedItemType = _G["IsEquippedItemType"]
                if itemType == nil then return false end
                return IsEquippedItemType(itemType)
            end
        end
    end 
    if subtable == "has" then 
        local has = item
        -- br.player.has.item()
        has[k] = function()
            return hasItem(v)
        end
        if has.item == nil then
            has.item = function(itemID)
                if itemID == nil then return end
                return hasItem(itemID)
            end
        end
    end
    if subtable == "use" then 
        local use = item
        -- br.player.use.item()
        use[k] = function(slotID,thisUnit)
            if thisUnit == nil then thisUnit = "target" end
            if slotID == nil then
                if canUseItem(v) then return useItem(v,thisUnit) else return end
            else
                if canUseItem(slotID) then return useItem(slotID,thisUnit) else return end
            end
        end
        if use.able == nil then use.able = {} end
        -- br.player.use.able.item()
        use.able[k] = function(slotID)
            if slotID == nil then return canUseItem(v) else return canUseItem(slotID) end
        end
        if use.able.item == nil then
            use.able.item = function(itemID)
                if itemID == nil then return false end
                return canUseItem(itemID)
            end
        end
        -- br.player.use.able.slot()
        if use.able.slot == nil then
            use.able.slot = function(slotID)
                return canUseItem(slotID)
            end
        end
        if use.item == nil then
            use.item = function(itemID,thisUnit)
                if itemID == nil then return false end
                if thisUnit == nil then thisUnit = "target" end
                if canUseItem(itemID) then
                    return useItem(itemID,thisUnit)
                else
                    return
                end
            end
        end
        -- br.player.use.slot()
        if use.slot == nil then 
            use.slot = function(slotID,thisUnit)
                if thisUnit == nil then thisUnit = "target" end
                if canUseItem(slotID) then return useItem(slotID,thisUnit) else return end
            end
        end
    end
end
