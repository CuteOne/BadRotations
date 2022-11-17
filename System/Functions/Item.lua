local _, br = ...
-- item charges
function br.itemCharges(itemID)
	local charges = br._G.GetItemCount(itemID, false, true)
	if charges == nil then
		return 0
	end
	return charges
end
-- if br.canUseItem(1710) then
function br.canUseItem(itemID)
	if itemID == 0 or br.getHP("player") == 0 then
		return false
	end
	if itemID <= 19 then
		local slotItemID = br._G.GetInventoryItemID("player", itemID)
		if br._G.GetItemSpell(slotItemID) ~= nil then
			if br._G.GetItemCooldown(slotItemID) == 0 and br._G.IsUsableItem(slotItemID) then
				return true
			end
		end
	elseif (br._G.GetItemCount(itemID, false, false) > 0 or br._G.PlayerHasToy(itemID)) and
		((br._G.IsEquippableItem(itemID) and br._G.IsEquippedItem(itemID)) or (not br._G.IsEquippableItem(itemID) and br.hasItem(itemID)))
	then
		if itemID > 19 and br._G.GetItemCooldown(itemID) == 0 and (br._G.IsUsableItem(itemID) or br._G.IsUsableSpell(select(2,br._G.GetItemSpell(itemID)))) then
			return true
			end
		end
	return false
end
-- if canTrinket(13) then
function br.canTrinket(trinketSlot)
	if trinketSlot == 13 or trinketSlot == 14 then
		if trinketSlot == 13 and select(3,br._G.GetInventoryItemCooldown("player",13)) == 1 and br._G.GetInventoryItemCooldown("player", 13) <= br.player.gcdMax then
			return true
		end
		if trinketSlot == 14 and select(3,br._G.GetInventoryItemCooldown("player",14)) == 1 and br._G.GetInventoryItemCooldown("player", 14) <= br.player.gcdMax then
			return true
		end
	else
		return false
	end
end
-- if br.hasItem(1234) == true then
function br.hasItem(itemID)
	if br._G.PlayerHasToy(itemID) then
		return true
	end
	local itemFound = false
	for i = 0, 4 do --Let's look at each bag
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
-- br.useItem(12345)
function br.useItem(itemID,thisUnit)
	br.itemSpamDelay = br.itemSpamDelay or 0
	if itemID <= 19 then
		if br._G.GetItemSpell(br._G.GetInventoryItemID("player", itemID)) ~= nil then
			local slotItemID = br._G.GetInventoryItemID("player", itemID)
			if br._G.GetItemCooldown(slotItemID) == 0 then
				if not br.itemSpamDelay or br._G.GetTime() > br.itemSpamDelay then
					-- br._G.RunMacroText("/use " .. select(1, GetItemInfo(slotItemID)))
					br._G.UseItemByName(select(1,br._G.GetItemInfo(slotItemID)),thisUnit);
					br.itemSpamDelay = br._G.GetTime() + 1
					return true
				end
			end
		end
	elseif itemID > 19 and (br._G.GetItemCount(itemID) > 0 or br._G.PlayerHasToy(itemID)) then
		if br._G.GetItemCooldown(itemID) == 0 then
			if not br.itemSpamDelay or br._G.GetTime() > br.itemSpamDelay then
				-- br._G.RunMacroText("/use " .. select(1, GetItemInfo(itemID)))
				br._G.UseItemByName(select(1,br._G.GetItemInfo(itemID)),thisUnit);
				br.itemSpamDelay = br._G.GetTime() + 1
				return true
			end
		end
	end
	return false
end
function br.useItemGround(Unit, itemID, maxDistance, minDistance, radius)
	if radius == nil then
		radius = maxDistance
	end
	if minDistance == nil then
		minDistance = 0
	end
	if br.GetUnitExists(Unit) and br.getLineOfSight("player", Unit) and br.getDistance("player", Unit) < maxDistance and
		br.getDistance("player", Unit) >= minDistance and
		#br.getEnemies(Unit, radius) >= #br.getEnemies(Unit, radius, true)
	 then
		br.useItem(itemID)
		local X, Y, Z = br.GetObjectPosition(Unit)
		--local distanceToGround = getGroundDistance(Unit) or 0
		br._G.ClickPosition(X, Y, Z) --distanceToGround
		return true
	end
	return false
end
function br.hasHealthPot()
	local locale = br._G.GetLocale()
	if locale ~= "enUS" and locale ~= "enGB" then
		if br.hasItem(169451) then
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
function br.getHealthPot()
	local locale = br._G.GetLocale()
	if locale ~= "enUS" and locale ~= "enGB" then
		if br.hasItem(171267) then
			return 171267
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
function br.TierScan(thisTier)
	local equippedItems = 0
	local myClass = select(2, br._G.UnitClass("player"))
	thisTier = string.upper(thisTier)
	local sets = br.lists.tier
	local tierList = sets[thisTier][myClass]
	if #tierList > 0 then
		for i = 1, #tierList do
			if br._G.IsEquippedItem(tierList[i]) then
				equippedItems = equippedItems + 1
			end
		end
	end
	return equippedItems
end

function br.hasEquiped(ItemID, Slot)
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
