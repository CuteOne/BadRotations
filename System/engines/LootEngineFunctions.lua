local _, br = ...
local lootEngine = br.engines.lootEngine

-----------------------------------------Loot Engine Functions--------------------------------------

-- Grey items in the bags worth something to a vendor: { Bag, Slot, Price (whole stack), Item (link) }.
-- An item the client hasn't cached yet has no price and is left for next time.
local function greyItems()
	local greys = {}
	for bag = 0, 4 do
		for slot = 1, br._G.C_Container.GetContainerNumSlots(bag) do
			local item = br._G.C_Container.GetContainerItemLink(bag, slot)
			-- Grey quality items show in the grey link colour
			if item and string.find(item, br.ui.colors.quality.grey) ~= nil then
				local price = select(11, br._G.C_Item.GetItemInfo(item))
				local containerItemInfo = br._G.C_Container.GetContainerItemInfo(bag, slot)
				if price and containerItemInfo and price * containerItemInfo.stackCount > 0 then
					greys[#greys + 1] = { Bag = bag, Slot = slot, Price = price * containerItemInfo.stackCount, Item = item }
				end
			end
		end
	end
	return greys
end

-- Sell all grey quality items to vendor
function lootEngine:sellGreys()
	for _, grey in ipairs(greyItems()) do
		br._G.C_Container.PickupContainerItem(grey.Bag, grey.Slot)
		br._G.PickupMerchantItem()
	end
	br.ui.chatOverlay:Show("Sold Greys.")
end

-- Delete lowest value grey items (keeps higher value greys)
function lootEngine:dumpGreys(numToDump)
	local greyTable = greyItems()
	-- Cheapest first
	table.sort(greyTable, function(x, y) return x.Price < y.Price end)
	for i = 1, numToDump do
		if greyTable[i] ~= nil then
			br._G.C_Container.PickupContainerItem(greyTable[i].Bag, greyTable[i].Slot)
			br._G.DeleteCursorItem()
			br.log:say("Loot", "Removed grey item " .. greyTable[i].Item)
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
		br.log:error("Loot Engine not initialized!")
		return
	end

	local stats = br.engines.lootEngine:getStats()
	local say = function(text) br.log:say("Loot", text) end
	say("Lootable units " .. (stats.lootableCount or 0) .. " | free bag slots " .. (stats.freeSlots or 0)
		.. " | current target " .. tostring(stats.currentTarget or "none") .. " | tracked attempts " .. (stats.attemptsTracked or 0))
	say("Looting " .. tostring(br.engines.lootEngine.isLooting or false) .. " | loot window open "
		.. tostring(br.engines.lootEngine.lootWindowOpen or false))

	-- List all lootable units
	if stats.lootableCount > 0 then
		say("Lootable units:")
		for k, v in pairs(br.engines.enemiesEngine.lootable) do
			if v and v.unit and v.name then
				local distance = br.functions.range:getDistance(v.unit) or 999
				say("  - " .. v.name .. " (" .. k .. ") at " .. math.floor(distance) .. " yards")
			end
		end
	end
end
