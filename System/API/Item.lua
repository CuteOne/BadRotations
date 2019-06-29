if br.api == nil then br.api = {} end

br.api.items = function(item,k,v,subtable)
    if item[k] == nil then item[k] = {} end
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
    end 
    if subtable == "has" then 
        local has = item
        -- br.player.has.item()
        has[k] = function()
            return hasItem(v)
        end
    end
    if subtable == "use" then 
        local use = item
        -- br.player.use.item()
        use[k] = function(slotID)
            if slotID == nil then
                if canUseItem(v) then return useItem(v) else return end
            else
                if canUseItem(slotID) then return useItem(slotID) else return end
            end
        end
        if use.able == nil then use.able = {} end
        -- br.player.use.able.item()
        use.able[k] = function(slotID)
            if slotID == nil then return canUseItem(v) else return canUseItem(slotID) end
        end
        -- br.player.use.able.slot()
        use.able.slot = function(slotID)
            return canUseItem(slotID)
        end
        -- br.player.use.slot()
        use.slot = function(slotID)
            if canUseItem(slotID) then return useItem(slotID) else return end
        end
    end
end