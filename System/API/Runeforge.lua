local br = _G["br"]
if br.api == nil then br.api = {} end
br.api.runeforge = function(runeforge,k,v)
    runeforge[k].equiped = false

    local itemLeggoSlots = {
        [1] = 1, -- Head
        [2] = 2, -- Neck
        [3] = 3, -- Shoulder
        [4] = 5, -- Chest
        [5] = 6, -- Waist
        [6] = 7, -- Legs
        [7] = 8, -- Feet
        [8] = 9, -- Wrists
        [9] = 10, -- Hands
        [10] = 11, -- Finger1
        [11] = 12, -- Finger2
        [12] = 15, -- Back
    }
    local slotPowers = {}

    local function findPowerBySlot(slotID)
        local powers = slotPowers[slotID]
        if (powers ~= nil) then
            local powerInfo = C_LegendaryCrafting.GetRuneforgePowerInfo(powers)
            local spellID = powerInfo.descriptionSpellID
            local spellName = GetSpellInfo(spellID)
            local vName = GetSpellInfo(v)
            if spellID == v and spellName == vName then
                return true
            end
        end
        return false
    end
    for i = 1, #itemLeggoSlots do
        local thisSlot = itemLeggoSlots[i]
        local itemID = GetInventoryItemID("player",thisSlot)
        if GetInventoryItemID("player",thisSlot) ~= nil then
            -- From: https://wow.gamepedia.com/ItemLocationMixin
            local item = ItemLocation:CreateFromEquipmentSlot(thisSlot)
            if item:IsValid() then
                if C_LegendaryCrafting.IsRuneforgeLegendary(item) then
                    slotPowers = C_LegendaryCrafting.GetRuneforgePowers(item,1)
                    runeforge[k].equiped = findPowerBySlot(1) or findPowerBySlot(2)
                end
            end
        end
    end
end