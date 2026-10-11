local _, br = ...
---@class br.functions.item
br.functions.item = br.functions.item or {}
local item = br.functions.item

-- if br.functions.item:canUseItem(1710) then
function item:canUseItem(itemID)
	if type(itemID) == "table" then itemID = self:getHighestHeldRank(itemID) end
	if itemID == nil then return false end
	if itemID == 0 or br.functions.unit:getHP("player") == 0 then
		return false
	end
	if itemID <= 19 then
		local slotItemID = br._G.GetInventoryItemID("player", itemID)
		if slotItemID == nil or slotItemID == 0 then
			return false
		end
		if br._G.GetItemSpell(slotItemID) ~= nil then
			if br._G.C_Container.GetItemCooldown(slotItemID) == 0 and br._G.IsUsableItem(slotItemID) then
				return true
			end
		end
	elseif (br._G.GetItemCount(itemID, false, false) > 0 or br._G.PlayerHasToy(itemID)) and
		((br._G.IsEquippableItem(itemID) and br._G.IsEquippedItem(itemID)) or (not br._G.IsEquippableItem(itemID) and item:hasItem(itemID)))
	then
		if itemID > 19 and br._G.C_Container.GetItemCooldown(itemID) == 0 and (br._G.IsUsableItem(itemID) or br._G.C_Spell.IsSpellUsable(select(2, br._G.GetItemSpell(itemID)))) then
			return true
		end
	end
	return false
end

-- Best usable potion in the bags whose name contains both nameMatch and "Potion" (e.g. "Heal", "Mana").
-- Matches the Consumable item class and the name, since localized subtype strings differ between flavors.
-- local potion = br.functions.item:getBestPotion("Heal")
function item:getBestPotion(nameMatch)
	local candidates = {}
	for bag = 0, 4 do
		for slot = 1, br._G.C_Container.GetContainerNumSlots(bag) do
			local itemID = br._G.C_Container.GetContainerItemID(bag, slot)
			if itemID ~= nil then
				local itemName, _, _, itemLevel = br._G.C_Item.GetItemInfo(itemID)
				local classID = select(6, br._G.C_Item.GetItemInfoInstant(itemID))
				if itemName and classID == 0 and itemName:find("Potion", 1, true) and itemName:find(nameMatch, 1, true) then
					candidates[#candidates + 1] = { itemID = itemID, itemLevel = itemLevel or 0 }
				end
			end
		end
	end
	table.sort(candidates, function(a, b) return a.itemLevel > b.itemLevel end)
	for i = 1, #candidates do
		if item:canUseItem(candidates[i].itemID) then return candidates[i].itemID end
	end
	return nil
end

function item:getHeirloomNeck()
    if not br.lists or not br.lists.items then return 0 end
    local items = br.lists.items
    local neckKeys = {
        "eternalAmuletOfTheRedeemed",
        "eternalEmberfuryTalisman",
        "eternalHorizonChoker",
        "eternalTalismanOfEvasion",
        "eternalWillOfTheMartyr",
        "eternalWovenIvyNecklace",
        "manariTrainingAmulet",
    }
    for _, k in ipairs(neckKeys) do
        local id = items[k]
        if id and br.functions.item:hasEquiped(id, 2) then return id end
    end
    return 0
end

-- Get the best (highest rank) item the player has from a ranked table.
-- Mirrors br.functions.spell:getHighestKnownRank for items.
-- @param itemIDTable - A table of item IDs {rank1, rank2, ..., rankN} ordered lowest to highest rank.
-- @return itemID - The highest rank item ID the player currently has in their bags, or nil if none.
function item:getHighestHeldRank(itemIDTable)
    if type(itemIDTable) ~= "table" then
        return itemIDTable
    end
    for i = #itemIDTable, 1, -1 do
        if self:hasItem(itemIDTable[i]) then
            return itemIDTable[i]
        end
    end
    return nil
end

-- Look up an item ID from br.lists.items by key name.
-- If the found value is a ranked table, returns the highest rank the player currently holds.
-- @param key - The item name key as it appears in the item list (e.g. "abyssalHealingPotion")
-- @return number|nil - The item ID, or nil if the list is not loaded or the key is not found.
function item:getHighestItemID(key)
    if not br.lists or not br.lists.items then return nil end
    local v = br.lists.items[key]
    if v == nil then return nil end
    if type(v) == "table" then
        return br.functions.item:getHighestHeldRank(v)
    end
    return v
end

-- True if the item has matchStat (a GetItemStats key), or any DPS stat when matchStat is nil.
-- if br.functions.item:hasDPSStats(itemLink, "ITEM_MOD_AGILITY_SHORT") then
function item:hasDPSStats(itemLink, matchStat)
	local stats = br._G.GetItemStats(itemLink) or {}

	-- Define the stats that contribute to DPS.
	local dpsStats = {"ITEM_MOD_AGILITY_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_INTELLECT_SHORT",
						"ITEM_MOD_CRIT_RATING_SHORT", "ITEM_MOD_HASTE_RATING_SHORT",
						"ITEM_MOD_MASTERY_RATING_SHORT", "ITEM_MOD_VERSATILITY"}

	-- If a desired stat is specified, check if the item has that stat.
	if matchStat then return stats[matchStat] end

	-- If no desired stat is specified, check if the item has any DPS stats.
	for _, stat in ipairs(dpsStats) do
		if stats[stat] then return true end
	end

	return false
end

function item:hasEquiped(ItemID, Slot)
	if ItemID == nil then return false end
	if br._G.PlayerHasToy(ItemID) then
		return true
	end
	--Scan Armor Slots to see if specified item was equiped
	local foundItem = false
	for i = 1, 19 do
		-- if there is an item in that slot
		if br._G.GetInventoryItemID("player", i) ~= nil then
			-- check if it matches
			if br._G.GetInventoryItemID("player", i) == ItemID then
				if i == Slot or Slot == nil then
					foundItem = true
					break
				end
			end
		end
	end
	return foundItem
end

-- if br.functions.item:hasItem(1234) == true then
function item:hasItem(itemID)
	if type(itemID) == "table" then itemID = self:getHighestHeldRank(itemID) end
	if itemID == nil then return false end
	if br._G.PlayerHasToy(itemID) then
		return true
	end
	local itemFound = false
	for i = 0, 4 do          --Let's look at each bag
		local numBagSlots = br._G.C_Container.GetContainerNumSlots(i)
		if numBagSlots > 0 then -- Only look for slots if bag present
			for x = 1, numBagSlots do --Let's look at each bag slot
				local bagItemID = br._G.C_Container.GetContainerItemID(i, x)
				if tostring(bagItemID) == tostring(itemID) then
					itemFound = true
				end
			end
		end
	end
	return itemFound
end

-- item charges
function item:itemCharges(itemID)
	local charges = br._G.GetItemCount(itemID, false, true)
	if charges == nil then
		return 0
	end
	return charges
end

-- if TierScan("T17")>=2 then
function item:TierScan(thisTier)
	local equippedItems = 0
	local myClass = select(2, br._G.UnitClass("player"))
	thisTier = string.upper(thisTier)
	local sets = br.lists.tier
	if sets[thisTier] == nil or sets[thisTier][myClass] == nil then return 0 end
	local tierList = sets[thisTier][myClass]
	if not tierList then
		br._G.print("No tier info found for this class! Please let devs know!")
		return 0
	end
	if #tierList > 0 then
		for i = 1, #tierList do
			if br._G.IsEquippedItem(tierList[i]) then
				equippedItems = equippedItems + 1
			end
		end
	end
	return equippedItems
end

-- br.functions.item:useItem(12345)
function item:useItem(itemID, thisUnit)
	if type(itemID) == "table" then itemID = self:getHighestHeldRank(itemID) end
	if itemID == nil then return false end
	br.itemSpamDelay = br.itemSpamDelay or 0
	if itemID <= 19 then
		if br._G.GetItemSpell(br._G.GetInventoryItemID("player", itemID)) ~= nil then
			local slotItemID = br._G.GetInventoryItemID("player", itemID)
			if br._G.C_Container.GetItemCooldown(slotItemID) == 0 then
				if not br.itemSpamDelay or br._G.GetTime() > br.itemSpamDelay then
					-- br._G.RunMacroText("/use " .. select(1, GetItemInfo(slotItemID)))
					br._G.UseItemByName(select(1, br._G.GetItemInfo(slotItemID)), thisUnit);
					br.itemSpamDelay = br._G.GetTime() + 1
					return true
				end
			end
		end
	elseif itemID > 19 and (br._G.GetItemCount(itemID) > 0 or br._G.PlayerHasToy(itemID)) then
		if br._G.C_Container.GetItemCooldown(itemID) == 0 then
			if not br.itemSpamDelay or br._G.GetTime() > br.itemSpamDelay then
				-- br._G.RunMacroText("/use " .. select(1, GetItemInfo(itemID)))
				br._G.UseItemByName(select(1, br._G.GetItemInfo(itemID)), thisUnit);
				br.itemSpamDelay = br._G.GetTime() + 1
				return true
			end
		end
	end
	return false
end
