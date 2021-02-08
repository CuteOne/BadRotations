local _, br = ...
if br.api == nil then br.api = {} end

br.api.items = function(item,k,v,subtable)
    if item[k] == nil then item[k] = {} end
    if subtable == "cd" then
        local cd = item
        cd[k].exists = function(itemID)
            if itemID == nil then itemID = v end
            return _G.GetItemCooldown(itemID) > 0
        end
        cd[k].remain = function(itemID)
            if itemID == nil then itemID = v end
            if _G.GetItemCooldown(itemID) ~= 0 then
                return (_G.GetItemCooldown(itemID) + select(2, _G.GetItemCooldown(itemID)) - _G.GetTime())
            end
            return 0
        end
        cd[k].duration = function(itemID)
            if itemID == nil then itemID = v end
            return _G.GetSpellBaseCooldown(select(2,_G.GetItemSpell(itemID))) / 1000
        end
    end
    if subtable == "charges" then
        local charges = item
        -- br.player.charges.item.exists()
        charges[k].exists = function()
            return br.itemCharges(v) > 0
        end
        -- br.player.charges.item.count()
        charges[k].count = function()
            return br.itemCharges(v)
        end
    end
    if subtable == "equiped" then
        local equiped = item
        -- br.player.equiped.item()
        equiped[k] = function(slotID)
            if slotID == nil then
                return br.hasEquiped(v)
            else
                return br.hasEquiped(v,slotID)
            end
        end
        equiped.socket[k] = function(gemID)
            local socketSpell = _G.GetItemSpell(v)
            local checkSpell = _G.GetItemInfo(gemID)
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
            return br.hasItem(v)
        end
        if has.item == nil then
            has.item = function(itemID)
                if itemID == nil then return end
                return br.hasItem(itemID)
            end
        end
    end
    if subtable == "use" then
        local use = item
        -- br.player.use.item()
        use[k] = function(slotID,thisUnit)
            if thisUnit == nil then thisUnit = "target" end
            if slotID == nil then
                if br.canUseItem(v) then return br.useItem(v,thisUnit) else return end
            else
                if br.canUseItem(slotID) then return br.useItem(slotID,thisUnit) else return end
            end
        end
        if use.able == nil then use.able = {} end
        -- br.player.use.able.item()
        use.able[k] = function(slotID)
            if slotID == nil then return br.canUseItem(v) else return br.canUseItem(slotID) end
        end
        if use.able.item == nil then
            use.able.item = function(itemID)
                if itemID == nil then return false end
                return br.canUseItem(itemID)
            end
        end
        -- br.player.use.able.slot()
        if use.able.slot == nil then
            use.able.slot = function(slotID)
                return br.canUseItem(slotID)
            end
        end
        if use.item == nil then
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
        -- br.player.use.slot()
        if use.slot == nil then
            use.slot = function(slotID,thisUnit)
                if thisUnit == nil then thisUnit = "target" end
                if br.canUseItem(slotID) then return br.useItem(slotID,thisUnit) else return end
            end
        end
    end
end
