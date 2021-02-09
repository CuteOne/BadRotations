local _, br = ...
-- item charges
function br.itemCharges(itemID)
	local charges = _G.GetItemCount(itemID, false, true)
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
		local slotItemID = _G.GetInventoryItemID("player", itemID)
		if _G.GetItemSpell(slotItemID) ~= nil then
			if _G.GetItemCooldown(slotItemID) == 0 and _G.IsUsableItem(slotItemID) then
				return true
			end
		end
	elseif (_G.GetItemCount(itemID, false, false) > 0 or _G.PlayerHasToy(itemID)) and
		((_G.IsEquippableItem(itemID) and _G.IsEquippedItem(itemID)) or (not _G.IsEquippableItem(itemID) and br.hasItem(itemID)))
	then
		if itemID > 19 and _G.GetItemCooldown(itemID) == 0 and (_G.IsUsableItem(itemID) or _G.IsUsableSpell(select(2,_G.GetItemSpell(itemID)))) then
			return true
			end
		end
	return false
end
-- if canTrinket(13) then
function br.canTrinket(trinketSlot)
	if trinketSlot == 13 or trinketSlot == 14 then
		if trinketSlot == 13 and select(3,_G.GetInventoryItemCooldown("player",13)) == 1 and _G.GetInventoryItemCooldown("player", 13) <= br.player.gcdMax then
			return true
		end
		if trinketSlot == 14 and select(3,_G.GetInventoryItemCooldown("player",14)) == 1 and _G.GetInventoryItemCooldown("player", 14) <= br.player.gcdMax then
			return true
		end
	else
		return false
	end
end
-- if br.hasItem(1234) == true then
function br.hasItem(itemID)
	if _G.PlayerHasToy(itemID) then
		return true
	end
	local itemFound = false
	for i = 0, 4 do --Let's look at each bag
		local numBagSlots = _G.GetContainerNumSlots(i)
		if numBagSlots > 0 then -- Only look for slots if bag present
			for x = 1, numBagSlots do --Let's look at each bag slot
				local bagItemID = _G.GetContainerItemID(i, x)
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
		if _G.GetItemSpell(_G.GetInventoryItemID("player", itemID)) ~= nil then
			local slotItemID = _G.GetInventoryItemID("player", itemID)
			if _G.GetItemCooldown(slotItemID) == 0 then
				if not br.itemSpamDelay or _G.GetTime() > br.itemSpamDelay then
					-- RunMacroText("/use " .. select(1, GetItemInfo(slotItemID)))
					br._G.UseItemByName(select(1,_G.GetItemInfo(slotItemID)),thisUnit);
					br.itemSpamDelay = _G.GetTime() + 1
					return true
				end
			end
		end
	elseif itemID > 19 and (_G.GetItemCount(itemID) > 0 or _G.PlayerHasToy(itemID)) then
		if _G.GetItemCooldown(itemID) == 0 then
			if not br.itemSpamDelay or _G.GetTime() > br.itemSpamDelay then
				-- RunMacroText("/use " .. select(1, GetItemInfo(itemID)))
				br._G.UseItemByName(select(1,_G.GetItemInfo(itemID)),thisUnit);
				br.itemSpamDelay = _G.GetTime() + 1
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
	local locale = _G.GetLocale()
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
	local locale = _G.GetLocale()
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
			if _G.IsEquippedItem(tierList[i]) then
				equippedItems = equippedItems + 1
			end
		end
	end
	return equippedItems
end

function br.hasEquiped(ItemID, Slot)
	if _G.PlayerHasToy(ItemID) then
		return true
	end
	--Scan Armor Slots to see if specified item was equiped
	local foundItem = false
	for i = 1, 19 do
		-- if there is an item in that slot
		if _G.GetInventoryItemID("player", i) ~= nil then
			-- check if it matches
			if _G.GetInventoryItemID("player", i) == ItemID then
				if i == Slot or Slot == nil then
					foundItem = true
					break
				end
			end
		end
	end
	return foundItem
end
