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
