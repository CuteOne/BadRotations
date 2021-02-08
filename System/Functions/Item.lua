local addonName, br = ...
-- item charges
function itemCharges(itemID)
	local charges = GetItemCount(itemID, false, true)
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
		if GetItemSpell(slotItemID) ~= nil then
			if GetItemCooldown(slotItemID) == 0 and IsUsableItem(slotItemID) then
				return true
			end
		end
	elseif (GetItemCount(itemID, false, false) > 0 or PlayerHasToy(itemID)) and
		((IsEquippableItem(itemID) and IsEquippedItem(itemID)) or (not IsEquippableItem(itemID) and br.hasItem(itemID)))
	then 
		if itemID > 19 and GetItemCooldown(itemID) == 0 and (IsUsableItem(itemID) or IsUsableSpell(select(2,GetItemSpell(itemID)))) then
			return true
			end
		end
	return false
end
-- if canTrinket(13) then
function canTrinket(trinketSlot)
	if trinketSlot == 13 or trinketSlot == 14 then
		if trinketSlot == 13 and select(3,GetInventoryItemCooldown("player",13)) == 1 and GetInventoryItemCooldown("player", 13) <= br.player.gcdMax then
			return true
		end
		if trinketSlot == 14 and select(3,GetInventoryItemCooldown("player",14)) == 1 and GetInventoryItemCooldown("player", 14) <= br.player.gcdMax then
			return true
		end
	else
		return false
	end
end
-- if br.hasItem(1234) == true then
function br.hasItem(itemID)
	if PlayerHasToy(itemID) then
		return true
	end
	local itemFound = false
	for i = 0, 4 do --Let's look at each bag
		local numBagSlots = GetContainerNumSlots(i)
		if numBagSlots > 0 then -- Only look for slots if bag present
			for x = 1, numBagSlots do --Let's look at each bag slot
				local bagItemID = GetContainerItemID(i, x)
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
		if GetItemSpell(_G.GetInventoryItemID("player", itemID)) ~= nil then
			local slotItemID = _G.GetInventoryItemID("player", itemID)
			if GetItemCooldown(slotItemID) == 0 then
				if not br.itemSpamDelay or GetTime() > br.itemSpamDelay then
					-- RunMacroText("/use " .. select(1, GetItemInfo(slotItemID)))
					br._G.UseItemByName(select(1,GetItemInfo(slotItemID)),thisUnit);
					br.itemSpamDelay = GetTime() + 1
					return true
				end
			end
		end
	elseif itemID > 19 and (GetItemCount(itemID) > 0 or PlayerHasToy(itemID)) then
		if GetItemCooldown(itemID) == 0 then
			if not br.itemSpamDelay or GetTime() > br.itemSpamDelay then
				-- RunMacroText("/use " .. select(1, GetItemInfo(itemID)))
				UseItemByName(select(1,GetItemInfo(itemID)),thisUnit);
				br.itemSpamDelay = GetTime() + 1
				return true
			end
		end
	end
	return false
end
function useItemGround(Unit, itemID, maxDistance, minDistance, radius)
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
		ClickPosition(X, Y, Z) --distanceToGround
		return true
	end
	return false
end
function hasHealthPot()
	local locale = GetLocale()
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
function getHealthPot()
	local locale = GetLocale()
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
function TierScan(thisTier)
	local equippedItems = 0
	local myClass = select(2, UnitClass("player"))
	thisTier = string.upper(thisTier)
	local sets = br.lists.tier
	local tierList = sets[thisTier][myClass]
	if #tierList > 0 then
		for i = 1, #tierList do
			if IsEquippedItem(tierList[i]) then
				equippedItems = equippedItems + 1
			end
		end
	end
	return equippedItems
end

function hasEquiped(ItemID, Slot)
	if PlayerHasToy(ItemID) then
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
