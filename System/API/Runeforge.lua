local br = _G["br"]
if br.api == nil then br.api = {} end
br.api.runeforge = function(runeforge,k,v)
    runeforge[k].equiped = false
    
    local item
    local isLeggo = false
    local itemLeggoSlots = {
        [1] = 1,
        [2] = 2,
        [3] = 3,
        [4] = 5,
        [5] = 6,
        [6] = 7,
        [7] = 8,
        [8] = 9,
        [9] = 10,
        [10] = 11,
        [11] = 12,
        [12] = 15,
    }
    local slotPowers = {}

    local function findPowerBySlot(slotID)
        local powers = slotPowers[slotID]
        if (powers ~= nil) then
            local powerInfo = C_LegendaryCrafting.GetRuneforgePowerInfo(powers)
            local spellID = powerInfo.descriptionSpellID
            if spellID == v then
                return true
            end
        end
        return false
    end
    --if UnitLevel("player") >= 50 then
        for i = 1, #itemLeggoSlots do
            if GetInventoryItemID("player",i) ~= nil then
                item = ItemLocation:CreateFromEquipmentSlot(itemLeggoSlots[i])
                isLeggo = C_LegendaryCrafting.IsRuneforgeLegendary(item)
                if isLeggo then
                    slotPowers = C_LegendaryCrafting.GetRuneforgePowers(item,1)
                    runeforge[k].equiped = findPowerBySlot(1) or findPowerBySlot(2)
                end
            end
            if runeforge[k].equiped then break end
        end
    --end
end