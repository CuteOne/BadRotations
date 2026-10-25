local _, br = ...
---@class br.functions.item
br.functions.item = br.functions.item or {}
local item = br.functions.item

-- Potions found in the bags, per name match ("Heal", "Mana"), best first; rebuilt after the bags change
local potionCandidates = {}
-- The bags' filled slots and the count per itemID (item:getBagItems); nil until read after a change
local bagItems, bagTotals
do
	local bagWatch = br.game.CreateFrame("Frame")
	local watching = pcall(bagWatch.RegisterEvent, bagWatch, "BAG_UPDATE_DELAYED")
	if watching then
		bagWatch:SetScript("OnEvent", function()
			br.game.wipe(potionCandidates)
			bagItems, bagTotals = nil, nil
		end)
	end
	item.watchingBags = watching
end

local function readBags()
	local items, totals = {}, {}
	local lastBag = (br.game.NUM_BAG_SLOTS or 4) + (br.game.NUM_REAGENTBAG_SLOTS or 0)
	for bag = 0, lastBag do
		for slot = 1, br.game.C_Container.GetContainerNumSlots(bag) do
			local info = br.game.C_Container.GetContainerItemInfo(bag, slot)
			if info and info.itemID then
				local count = info.stackCount or 1
				items[#items + 1] = { bag = bag, slot = slot, itemID = info.itemID, count = count }
				totals[info.itemID] = (totals[info.itemID] or 0) + count
			end
		end
	end
	return items, totals
end

-- Every filled bag slot, { bag, slot, itemID, count } in bag order, and the total count per itemID.
-- Read once per bag change (BAG_UPDATE_DELAYED); on a client without that event, on every call.
-- local slots, totals = br.functions.item:getBagItems()
function item:getBagItems()
	if bagItems == nil or not item.watchingBags then bagItems, bagTotals = readBags() end
	return bagItems, bagTotals
end

-- Hidden tooltip, for clients without C_TooltipInfo
local scanTooltip
local function tooltipLines(bag, slot)
	if br.game.C_TooltipInfo and br.game.C_TooltipInfo.GetBagItem then
		local data = br.game.C_TooltipInfo.GetBagItem(bag, slot)
		local lines, texts = data and data.lines or {}, {}
		for i = 1, #lines do texts[i] = lines[i].leftText end
		return texts
	end
	if scanTooltip == nil then
		scanTooltip = br.game.CreateFrame("GameTooltip", "BRBagScanTooltip", nil, "GameTooltipTemplate")
	end
	scanTooltip:SetOwner(br.game.WorldFrame, "ANCHOR_NONE")
	scanTooltip:SetBagItem(bag, slot)
	local texts = {}
	for i = 1, scanTooltip:NumLines() do
		local line = br.game["BRBagScanTooltipTextLeft" .. i]
		texts[i] = line and line:GetText()
	end
	scanTooltip:Hide()
	return texts
end

-- Whether the tooltip of the item in a bag slot has a line that reads text. Pass the game's own
-- string (ITEM_MILLABLE, LOCKED, ...) so it works in every locale; false when text is nil (a client
-- without that string), nil when the tooltip couldn't be read (item data not loaded yet, or text the
-- game won't let BR compare: on Forever it can be flagged secret, so it's read under pcall).
-- if br.functions.item:bagTooltipHas(0, 1, br.game.ITEM_MILLABLE) then
function item:bagTooltipHas(bag, slot, text)
	if text == nil then return false end
	local ok, found = pcall(function()
		local texts = tooltipLines(bag, slot)
		if #texts == 0 then return nil end
		for i = 1, #texts do
			if texts[i] == text then return true end
		end
		return false
	end)
	if not ok then return nil end
	return found
end

-- if br.functions.item:canUseItem(1710) then
function item:canUseItem(itemID)
	if type(itemID) == "table" then itemID = self:getHighestHeldRank(itemID) end
	if itemID == nil then return false end
	if itemID == 0 or br.functions.unit:getHP("player") == 0 then
		return false
	end
	if itemID <= 19 then
		local slotItemID = br.game.GetInventoryItemID("player", itemID)
		if slotItemID == nil or slotItemID == 0 then
			return false
		end
		if br.game.C_Item.GetItemSpell(slotItemID) ~= nil then
			if br.game.C_Container.GetItemCooldown(slotItemID) == 0 and br.game.C_Item.IsUsableItem(slotItemID) then
				return true
			end
		end
	elseif (br.game.C_Item.GetItemCount(itemID, false, false) > 0 or br.game.PlayerHasToy(itemID)) and
		((br.game.C_Item.IsEquippableItem(itemID) and br.game.C_Item.IsEquippedItem(itemID)) or (not br.game.C_Item.IsEquippableItem(itemID) and item:hasItem(itemID)))
	then
		if itemID > 19 and br.game.C_Container.GetItemCooldown(itemID) == 0 and (br.game.C_Item.IsUsableItem(itemID) or br.game.C_Spell.IsSpellUsable(select(2, br.game.C_Item.GetItemSpell(itemID)))) then
			return true
		end
	end
	return false
end

-- Best usable potion in the bags whose name contains both nameMatch and "Potion" (e.g. "Heal", "Mana").
-- Matches the Consumable item class and the name, since localized subtype strings differ between flavors.
-- local potion = br.functions.item:getBestPotion("Heal")
-- The best usable potion in the bags whose name contains nameMatch ("Heal", "Mana"), or nil. The bags
-- are read once per change (BAG_UPDATE_DELAYED); whether a potion can be used is asked each time.
-- local itemID = br.functions.item:getBestPotion("Heal")
function item:getBestPotion(nameMatch)
	local candidates = item.watchingBags and potionCandidates[nameMatch] or nil
	if candidates == nil then
		candidates = {}
		local complete = true -- false when an item's info isn't loaded yet: scan again next time
		local slots = item:getBagItems()
		for i = 1, #slots do
			local itemID = slots[i].itemID
			local itemName, _, _, itemLevel = br.game.C_Item.GetItemInfo(itemID)
			if itemName == nil then complete = false end
			local classID = select(6, br.game.C_Item.GetItemInfoInstant(itemID))
			if itemName and classID == 0 and itemName:find("Potion", 1, true) and itemName:find(nameMatch, 1, true) then
				candidates[#candidates + 1] = { itemID = itemID, itemLevel = itemLevel or 0 }
			end
		end
		table.sort(candidates, function(a, b) return a.itemLevel > b.itemLevel end)
		if complete then potionCandidates[nameMatch] = candidates end
	end
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
	local stats = br.game.C_Item.GetItemStats(itemLink) or {}

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
	if br.game.PlayerHasToy(ItemID) then
		return true
	end
	--Scan Armor Slots to see if specified item was equiped
	local foundItem = false
	for i = 1, 19 do
		-- if there is an item in that slot
		if br.game.GetInventoryItemID("player", i) ~= nil then
			-- check if it matches
			if br.game.GetInventoryItemID("player", i) == ItemID then
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
	if br.game.PlayerHasToy(itemID) then
		return true
	end
	local itemFound = false
	for i = 0, 4 do          --Let's look at each bag
		local numBagSlots = br.game.C_Container.GetContainerNumSlots(i)
		if numBagSlots > 0 then -- Only look for slots if bag present
			for x = 1, numBagSlots do --Let's look at each bag slot
				local bagItemID = br.game.C_Container.GetContainerItemID(i, x)
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
	local charges = br.game.C_Item.GetItemCount(itemID, false, true)
	if charges == nil then
		return 0
	end
	return charges
end

-- if TierScan("T17")>=2 then
function item:TierScan(thisTier)
	local equippedItems = 0
	local myClass = select(2, br.game.UnitClass("player"))
	thisTier = string.upper(thisTier)
	local sets = br.lists.tier
	if sets[thisTier] == nil or sets[thisTier][myClass] == nil then return 0 end
	local tierList = sets[thisTier][myClass]
	if not tierList then
		br.game.print("No tier info found for this class! Please let devs know!")
		return 0
	end
	if #tierList > 0 then
		for i = 1, #tierList do
			if br.game.C_Item.IsEquippedItem(tierList[i]) then
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
		if br.game.C_Item.GetItemSpell(br.game.GetInventoryItemID("player", itemID)) ~= nil then
			local slotItemID = br.game.GetInventoryItemID("player", itemID)
			if br.game.C_Container.GetItemCooldown(slotItemID) == 0 then
				if not br.itemSpamDelay or br.game.GetTime() > br.itemSpamDelay then
					-- br.game.RunMacroText("/use " .. select(1, GetItemInfo(slotItemID)))
					br.game.UseItemByName(select(1, br.game.C_Item.GetItemInfo(slotItemID)), thisUnit);
					br.itemSpamDelay = br.game.GetTime() + 1
					return true
				end
			end
		end
	elseif itemID > 19 and (br.game.C_Item.GetItemCount(itemID) > 0 or br.game.PlayerHasToy(itemID)) then
		if br.game.C_Container.GetItemCooldown(itemID) == 0 then
			if not br.itemSpamDelay or br.game.GetTime() > br.itemSpamDelay then
				-- br.game.RunMacroText("/use " .. select(1, GetItemInfo(itemID)))
				br.game.UseItemByName(select(1, br.game.C_Item.GetItemInfo(itemID)), thisUnit);
				br.itemSpamDelay = br.game.GetTime() + 1
				return true
			end
		end
	end
	return false
end
