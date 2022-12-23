local _, br = ...
-- Sell Greys Macros
SLASH_Greys1 = "/grey"
SLASH_Greys2 = "/greys"
function br._G.SlashCmdList.Greys(msg, editbox)
	br.SellGreys()
end
function br.SellGreys()
	for bag = 0, 4 do
		for slot = 1, br._G.C_Container.GetContainerNumSlots(bag) do
			local item = br._G.C_Container.GetContainerItemLink(bag, slot)
			if item then
				-- Is it grey quality item?
				if string.find(item, br.qualityColors.grey) ~= nil then
					local greyPrice = select(11, br._G.GetItemInfo(item)) * select(2, br._G.C_Container.GetContainerItemInfo(bag, slot))
					if greyPrice > 0 then
						br._G.C_Container.PickupContainerItem(bag, slot)
						br._G.PickupMerchantItem()
					end
				end
			end
		end
	end
	br._G.RepairAllItems(1)
	br._G.RepairAllItems(0)
	br.ChatOverlay("Sold Greys.")
end
-- Dump Greys Macros
SLASH_DumpGrey1 = "/dumpgreys"
SLASH_DumpGrey2 = "/dg"
function br._G.SlashCmdList.DumpGrey(msg, editbox)
	br.DumpGreys(1)
end
function br.DumpGreys(Num)
	local greyTable = {}
	for bag = 0, 4 do
		for slot = 1, br._G.C_Container.GetContainerNumSlots(bag) do
			local item = br._G.C_Container.GetContainerItemLink(bag, slot)
			if item then
				-- Is it grey quality item?
				if string.find(item, br.qualityColors.grey) ~= nil then
					local greyPrice = select(11, br._G.GetItemInfo(item)) * select(2, br._G.C_Container.GetContainerItemInfo(bag, slot))
					if greyPrice > 0 then
						br._G.tinsert(greyTable, {Bag = bag, Slot = slot, Price = greyPrice, Item = item})
					end
				end
			end
		end
	end
	table.sort(
		greyTable,
		function(x, y)
			if x.Price and y.Price then
				return x.Price < y.Price
			end
		end
	)
	for i = 1, Num do
		if greyTable[i] ~= nil then
			br._G.C_Container.PickupContainerItem(greyTable[i].Bag, greyTable[i].Slot)
			br._G.DeleteCursorItem()
			br._G.print("|cffFF0000Removed Grey Item:" .. greyTable[i].Item)
		end
	end
end
------------------
-- Loot Manager --
------------------
br.lootManager = {}
br.lM = br.lootManager
-- Debug
function br.lootManager:debug(message)
	if message and br.lM.oldMessage ~= message then
		br.addonDebug("<lootManager> " .. (math.floor(br._G.GetTime() * 1000) / 1000) .. " " .. message, true)
		br.lM.oldMessage = message
	end
end
-- Check if availables bag slots, return true if at least 1 free bag space
function br.lootManager:emptySlots()
	local openSlots = 0
	for i = 0, 4 do --Let's look at each bag
		local numBagSlots = br._G.C_Container.GetContainerNumSlots(i)
		if numBagSlots > 0 then -- Only look for slots if bag present
			openSlots = openSlots + select(1, br._G.C_Container.GetContainerNumFreeSlots(i))
		end
	end
	return openSlots
end

local looting = false
function br.lootManager:getLoot(lootUnit)
	-- if we have a unit to loot, check if its time to
	if br.timer:useTimer("getLoot", br.getOptionValue("Auto Loot")) then
		if br.getDistance(lootUnit) < 7 then
			if not looting then
				looting = true
				br.lM:debug("Looting " .. br._G.UnitName(lootUnit))
				br._G.InteractUnit(lootUnit)
				-- Manually loot if Auto Loot Interface Option not set
				if br._G.GetCVar("AutoLootDefault") == "0" then
					if br._G.LootFrame:IsShown() then
						for l = 1, br._G.GetNumLootItems() do
							if br._G.LootSlotHasItem(l) then
								br._G.LootSlot(l)
							end
						end
						br._G.CloseLoot()
					end
				end
			end
		end
		if not br.isInCombat("player") and looting then
			br._G.ClearTarget()
		end
		looting = false
		br.lM.lootUnit = nil
		br.lootable = {}
		return
	end
end
-- function br.lootManager:getLoot(lootUnit)
-- 	local looting = false
-- 	-- if we have a unit to loot, check if its time to
-- 	if br.timer:useTimer("getLoot", br.getOptionValue("Auto Loot")) then
-- 		if not looting then
-- 			looting = true
-- 			--Print("Looting "..UnitName(lootUnit))
-- 			lM:debug("Looting " .. UnitName(lootUnit))
-- 			InteractUnit(lootUnit)
-- 			-- Manually loot if Auto Loot Interface Option not set
-- 			if GetCVar("AutoLootDefault") == "0" then
-- 				if LootFrame:IsShown() then
-- 					for l = 1, GetNumLootItems() do
-- 						if LootSlotHasItem(l) then
-- 							LootSlot(l)
-- 						end
-- 					end
-- 					CloseLoot()
-- 				end
-- 			end
-- 			-- Clean Up
-- 			ClearTarget()
-- 			looting = false
-- 			lM.lootUnit = nil
-- 			br.lootable = {}
-- 			return
-- 		end
-- 	end
-- end
-- function br.lootManager:findLoot()
-- 	if br.timer:useTimer("findLoot", br.getOptionValue("Auto Loot")) then
-- 		lM:debug("Find Unit")
-- 		for k, v in pairs(br.lootable) do
-- 			local thisUnit = br.lootable[k].unit
-- 			local hasLoot, canLoot = CanLootUnit(thisUnit)
-- 			if br.GetObjectExists(thisUnit) and canLoot then
-- 				--Print("Should loot "..UnitName(thisUnit))
-- 				lM:debug("Should loot " .. UnitName(thisUnit))
-- 				lM:getLoot(thisUnit)
-- 				break
-- 			end
-- 		end
-- 	end
-- end
function br.lootManager:lootCount()
	local lootCount = 0
	br.lM.lootUnit = nil
	for k, _ in pairs(br.lootable) do
		if br.lootable[k] ~= nil then
			local thisUnit = br.lootable[k].unit
			local hasLoot = br._G.CanLootUnit(br.lootable[k].guid)
			if br.GetObjectExists(thisUnit) and hasLoot then
				lootCount = lootCount + 1
				br.lM.lootUnit = br.lootable[k].unit
				break
			end
		end
	end
	return lootCount
end
function br.autoLoot()
	if br.getOptionCheck("Auto Loot") then
		--br.player.enemies.get(40)
		if (not br.isInCombat("player") or br.player.enemies.get(10)[1] == nil) then
			-- start loot manager
			if br.lM and br.lM:lootCount() > 0 then
				if br.lM:emptySlots() ~= 0 then
					if br._G.UnitCastingInfo("player") == nil and br._G.UnitChannelInfo("player") == nil
						and not br._G.IsMounted("player") and br._G.GetUnitSpeed("player") == 0
						and br.timer:useTimer("lootTimer", 1) and not br._G.UnitIsDeadOrGhost("player")
					 then
						-- Print("Getting Loot")
						br.lM:getLoot(br.lM.lootUnit)
					end
				else
					br.ChatOverlay("Bags are full, nothing will be looted!")
				end
			end
		end
	end
end
