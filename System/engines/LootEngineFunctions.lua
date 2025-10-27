local _, br = ...
local lootEngine = br.engines.lootEngine

-----------------------------------------Loot Engine Functions--------------------------------------

-- Sell all grey quality items to vendor
function lootEngine:sellGreys()
	for bag = 0, 4 do
		for slot = 1, br._G.C_Container.GetContainerNumSlots(bag) do
			local item = br._G.C_Container.GetContainerItemLink(bag, slot)
			if item then
				-- Check if it's grey quality item
				if string.find(item, br.ui.colors.quality.grey) ~= nil then
					local containerItemInfo = br._G.C_Container.GetContainerItemInfo(bag, slot)
					local greyPrice = select(11, br._G.GetItemInfo(item)) * containerItemInfo.stackCount
					if greyPrice > 0 then
						br._G.C_Container.PickupContainerItem(bag, slot)
						br._G.PickupMerchantItem()
					end
				end
			end
		end
	end
	br.ui.chatOverlay:Show("Sold Greys.")
end

-- Delete lowest value grey items (keeps higher value greys)
function lootEngine:dumpGreys(numToDump)
	local greyTable = {}

	-- Collect all grey items with their prices
	for bag = 0, 4 do
		for slot = 1, br._G.C_Container.GetContainerNumSlots(bag) do
			local item = br._G.C_Container.GetContainerItemLink(bag, slot)
			if item then
				-- Check if it's grey quality item
				if string.find(item, br.ui.colors.quality.grey) ~= nil then
					local containerItemInfo = br._G.C_Container.GetContainerItemInfo(bag, slot)
					local greyPrice = select(11, br._G.GetItemInfo(item)) * containerItemInfo.stackCount
					if greyPrice > 0 then
						br._G.tinsert(greyTable, {
							Bag = bag,
							Slot = slot,
							Price = greyPrice,
							Item = item
						})
					end
				end
			end
		end
	end

	-- Sort by price (lowest first)
	table.sort(greyTable, function(x, y)
		if x.Price and y.Price then
			return x.Price < y.Price
		elseif x.Price then
			return false
		else
			return true
		end
	end)

	-- Delete the cheapest items
	for i = 1, numToDump do
		if greyTable[i] ~= nil then
			br._G.C_Container.PickupContainerItem(greyTable[i].Bag, greyTable[i].Slot)
			br._G.DeleteCursorItem()
			br._G.print("|cffFF0000Removed Grey Item: " .. greyTable[i].Item)
		end
	end
end

-- Slash Commands Registration
-- Sell Greys Commands
SLASH_Greys1 = "/grey"
SLASH_Greys2 = "/greys"
function br._G.SlashCmdList.Greys(msg, editbox)
	br.engines.lootEngine:sellGreys()
end

-- Dump Greys Commands
SLASH_DumpGrey1 = "/dumpgreys"
SLASH_DumpGrey2 = "/dg"
function br._G.SlashCmdList.DumpGrey(msg, editbox)
	br.engines.lootEngine:dumpGreys(1)
end

-- Loot Stats Command
SLASH_LootStats1 = "/lootstats"
SLASH_LootStats2 = "/ls"
function br._G.SlashCmdList.LootStats(msg, editbox)
	if not br.engines.lootEngine or not br.engines.lootEngine.getStats then
		br._G.print("|cffFF0000Loot Engine not initialized!")
		return
	end

	local stats = br.engines.lootEngine:getStats()
	br._G.print("|cff00FF00=== Loot Engine Stats ===")
	br._G.print("|cffFFFFFFLootable Units: " .. (stats.lootableCount or 0))
	br._G.print("|cffFFFFFFFree Bag Slots: " .. (stats.freeSlots or 0))
	br._G.print("|cffFFFFFFCurrent Target: " .. (stats.currentTarget or "None"))
	br._G.print("|cffFFFFFFTracked Attempts: " .. (stats.attemptsTracked or 0))
	br._G.print("|cffFFFFFFIs Looting: " .. tostring(br.engines.lootEngine.isLooting or false))
	br._G.print("|cffFFFFFFLoot Window Open: " .. tostring(br.engines.lootEngine.lootWindowOpen or false))

	-- List all lootable units
	if stats.lootableCount > 0 then
		br._G.print("|cff00FF00Lootable Units:")
		for k, v in pairs(br.engines.enemiesEngine.lootable) do
			if v and v.unit and v.name then
				local distance = br.functions.range:getDistance(v.unit) or 999
				br._G.print("  - " .. v.name .. " (" .. k .. ") at " .. math.floor(distance) .. " yards")
			end
		end
	end
end
