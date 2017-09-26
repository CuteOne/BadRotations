-- Sell Greys Macros
SLASH_Greys1 = "/grey"
SLASH_Greys2 = "/greys"
function SlashCmdList.Greys(msg, editbox)
	SellGreys()
end
function SellGreys()
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local item = GetContainerItemLink(bag,slot)
			if item then
				-- Is it grey quality item?
				if string.find(item, qualityColors.grey) ~= nil then
					greyPrice = select(11, GetItemInfo(item)) * select(2, GetContainerItemInfo(bag, slot))
					if greyPrice > 0 then
						PickupContainerItem(bag, slot)
						PickupMerchantItem()
					end
				end
			end
		end
	end
	RepairAllItems(1)
	RepairAllItems(0)
	ChatOverlay("Sold Greys.")
end
-- Dump Greys Macros
SLASH_DumpGrey1 = "/dumpgreys"
SLASH_DumpGrey2 = "/dg"
function SlashCmdList.DumpGrey(msg, editbox)
	DumpGreys(1)
end
function DumpGreys(Num)
	local greyTable = {}
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local item = GetContainerItemLink(bag,slot)
			if item then
				-- Is it grey quality item?
				if string.find(item, qualityColors.grey) ~= nil then
					greyPrice = select(11, GetItemInfo(item)) * select(2, GetContainerItemInfo(bag, slot))
					if greyPrice > 0 then
						tinsert(greyTable, { Bag = bag, Slot = slot, Price = greyPrice, Item = item})
					end
				end
			end
		end
	end
	table.sort(greyTable, function(x,y)
		if x.Price and y.Price then return x.Price < y.Price end
	end)
	for i = 1, Num do
		if greyTable[i]~= nil then
			PickupContainerItem(greyTable[i].Bag, greyTable[i].Slot)
			DeleteCursorItem()
			Print("|cffFF0000Removed Grey Item:"..greyTable[i].Item)
		end
	end
end
------------------
-- Loot Manager --
------------------
local lootManager = { }
local looted = looted or false
local lootFound = lootFound or false
lM = lootManager
-- Debug
function lootManager:debug(message)
	if lM.showDebug then
		if message and lM.oldMessage ~= message then
			Print("<lootManager> "..(math.floor(GetTime()*1000)/1000).. " "..message)
			lM.oldMessage = message
		end
	end
end
-- Check if availables bag slots, return true if at least 1 free bag space
function lootManager:emptySlots()
	local openSlots = 0
	for i = 0, 4 do --Let's look at each bag
		local numBagSlots = GetContainerNumSlots(i)
		if numBagSlots>0 then -- Only look for slots if bag present
			openSlots = openSlots + select(1,GetContainerNumFreeSlots(i))
		end
	end
	return openSlots
end
function lootManager:getLoot()
	if looted == nil then looted = 0 end
	if lootFound == nil then lootFound = false end
	if lM:emptySlots() ~= 0 then
		if UnitCastingInfo("player") == nil and UnitChannelInfo("player") == nil and DontMoveStartTime and GetTime() - DontMoveStartTime > 0 then
			-- if we have a unit to loot, check if its time to
			if br.timer:useTimer("getLoot", getOptionValue("Auto Loot")) and lootFound then
				if GetObjectExists(lM.canLootUnit) and looted == 0 then
					InteractUnit(lM.canLootUnit)
					lM:debug("Interact with "..lM.canLootUnit)
					-- Print("Interact with "..lM.canLootUnit)
					looted = 1
					lootFound = false
					if LootFrame:IsShown() then
					    for l=1, GetNumLootItems() do
					       	if LootSlotHasItem(l) then
					        	LootSlot(l)
					   		end
					   	end
					    CloseLoot()
					end
				    ClearTarget()
					return
					-- make sure the user have the auto loot selected, if its not ,we will enable it when we need it
					-- if GetCVar("autoLootDefault") == "0" then
					-- 	SetCVar("autoLootDefault", "1")
					-- 	InteractUnit(lM.canLootUnit)
					-- 	lM:debug("Interact with "..lM.canLootUnit)
					-- 	-- Print("Interact with "..lM.canLootUnit)
					-- 	SetCVar("autoLootDefault", "0")
					-- 	looted = 1
					-- 	lootFound = false
					-- 	CloseLoot()
					-- 	ClearTarget()
					-- 	return
					-- else
					-- 	InteractUnit(lM.canLootUnit)
					-- 	lM:debug("Interact with "..lM.canLootUnit)
					-- 	-- Print("Interact with "..lM.canLootUnit)
					-- 	looted = 1
					-- 	lootFound = false
					-- 	CloseLoot()
					-- 	ClearTarget()
					-- 	return
					-- end
				end
			end
		end
	else
		ChatOverlay("Bags are full, nothing will be looted!")
	end
end
function lootManager:findLoot()
	if br.timer:useTimer("findLoot", getOptionValue("Auto Loot")) then
		lM:debug("Find Unit")
		-- local objectCount = GetObjectCount() or 0
		for i = 1,GetObjectCount() do
			local thisUnit = GetObjectIndex(i)
			if ObjectIsType(thisUnit, ObjectTypes.Unit)  then
				local inRange = getDistance("player",thisUnit) < 2
				local hasLoot,canLoot = CanLootUnit(UnitGUID(thisUnit))
				if inRange then
					-- if we can loot thisUnit we set it as unit to be looted
					if hasLoot and canLoot then
						looted = 0
						lootFound = true
						lM.canLootUnit = thisUnit
						lM:debug("Should loot "..UnitName(thisUnit))
						-- Print("Should loot "..UnitName(thisUnit))
						break
					end
				end
			end
		end
	end
end
function autoLoot()
	if getOptionCheck("Auto Loot") then
		if not isInCombat("player") then
			-- start loot manager
			if lM then
				if not IsMounted("player") then
					if not lootFound then lM:findLoot() else lM:getLoot() end
				end
			end	
		end
	end
end