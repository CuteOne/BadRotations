local _, br = ...
br.functions.item = br.functions.item or {}
local item = br.functions.item

-- item charges
function item:itemCharges(itemID)
	local charges = br._G.GetItemCount(itemID, false, true)
	if charges == nil then
		return 0
	end
	return charges
end

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

-- if canTrinket(13) then
function item:canTrinket(trinketSlot)
	if trinketSlot == 13 or trinketSlot == 14 then
		if trinketSlot == 13 and select(3, br._G.GetInventoryItemCooldown("player", 13)) == 1 and br._G.GetInventoryItemCooldown("player", 13) <= br.player.gcdMax then
			return true
		end
		if trinketSlot == 14 and select(3, br._G.GetInventoryItemCooldown("player", 14)) == 1 and br._G.GetInventoryItemCooldown("player", 14) <= br.player.gcdMax then
			return true
		end
	else
		return false
	end
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
		local numBagSlots = C_Container.GetContainerNumSlots(i)
		if numBagSlots > 0 then -- Only look for slots if bag present
			for x = 1, numBagSlots do --Let's look at each bag slot
				local bagItemID = C_Container.GetContainerItemID(i, x)
				if tostring(bagItemID) == tostring(itemID) then
					itemFound = true
				end
			end
		end
	end
	return itemFound
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

function item:useItemGround(Unit, itemID, maxDistance, minDistance, radius)
	if radius == nil then
		radius = maxDistance
	end
	if minDistance == nil then
		minDistance = 0
	end
	if br.functions.unit:GetUnitExists(Unit) and br.functions.misc:getLineOfSight("player", Unit) and br.functions.range:getDistance("player", Unit) < maxDistance and
		br.functions.range:getDistance("player", Unit) >= minDistance and
		#br.engines.enemiesEngineFunctions:getEnemies(Unit, radius) >= #br.engines.enemiesEngineFunctions:getEnemies(Unit, radius, true)
	then
		br.functions.item:useItem(itemID)
		local X, Y, Z = br.functions.unit:GetObjectPosition(Unit)
		--local distanceToGround = getGroundDistance(Unit) or 0
		br._G.ClickPosition(X, Y, Z) --distanceToGround
		return true
	end
	return false
end

function item:hasHealthPot()
	local locale = br._G.GetLocale()
	if locale ~= "enUS" and locale ~= "enGB" then
		local abyssalHealingPotion = br.functions.item:getHighestItemID("abyssalHealingPotion") or 169451
		if br.functions.item:hasItem(abyssalHealingPotion) then
			return true
		end
	end
	local potion = br.player.potion
	if potion.health == nil then
		return false
	end
	if potion.health[1] == nil and potion.rejuve[1] == nil then
		return false
	else
		return true
	end
end

function item:getHealthPot()
	local locale = br._G.GetLocale()
	if locale ~= "enUS" and locale ~= "enGB" then
		local coastalHealingPotion = br.functions.item:getHighestItemID("coastalHealingPotion") or 171267
		if br.functions.item:hasItem(coastalHealingPotion) then
			return coastalHealingPotion
		end
	end
	local potion = br.player.potion
	if potion ~= nil then
		if potion.health ~= nil then
			if potion.health[1] ~= nil then
				return potion.health[1].itemID
			elseif potion.rejuve[1] ~= nil then
				return potion.rejuve[1].itemID
			else
				return 0
			end
		else
			return 0
		end
	else
		return 0
	end
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