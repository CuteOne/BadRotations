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
	if lM:emptySlots() then
		if UnitCastingInfo("player") == nil and UnitChannelInfo("player") == nil and DontMoveStartTime and GetTime() - DontMoveStartTime > 0 then
			-- if we have a unit to loot, check if its time to
			-- if lM.canLootUnit and lM.canLootTimer and lM.canLootTimer <= GetTime() - getOptionValue("Auto Loot") then
			if br.timer:useTimer("debugLoot", getOptionValue("Auto Loot")) then
				if GetObjectExists(lM.canLootUnit) and looted == 0 then
					-- make sure the user have the auto loot selected, if its not ,we will enable it when we need it
					if GetCVar("autoLootDefault") == "0" then
						SetCVar("autoLootDefault", "1")
						InteractUnit(lM.canLootUnit)
						lM.canLootTimer = GetTime() + 1.5
						lM:debug("Interact with "..lM.canLootUnit)
						-- Print("Interact with "..lM.canLootUnit)
						SetCVar("autoLootDefault", "0")
						looted = 1
						if FireHack then ClearTarget() end
						return
					else
						InteractUnit(lM.canLootUnit)
						lM.canLootTimer = GetTime() + 1.5
						lM:debug("Interact with "..lM.canLootUnit)
						-- Print("Interact with "..lM.canLootUnit)
						looted = 1
						if FireHack then ClearTarget() end
					end
					-- no matter what happened, we clear all values
					lM.canLootUnit = nil
					lM:debug("Clear Loot Timer and Unit")
				end
				-- find an unit to loot
			else--if lM.canLootUnit == nil or (not lM.canLootTimer or lM.canLootTimer < GetTime()) then

			end
		else
			-- if we were casting, we reset the delay
			lM.canLootTimer = GetTime()
		end
	else
		ChatOverlay("Bags are full, nothing will be looted!")
	end
end

function lootManager:findLoot()
	lM:debug("Find Unit")
	for i = 1, GetObjectCountBR() do
		if bit.band(GetObjectIndex(i), ObjectTypes.Unit) == 8 then
			local thisUnit = GetObjectIndex(i)
			local hasLoot,canLoot = CanLootUnit(UnitGUID(thisUnit))
			local inRange = getDistance("player",thisUnit) < 2
			-- if we can loot thisUnit we set it as unit to be looted
			if hasLoot and canLoot and inRange then
				looted = 0
				lM.canLootTimer = GetTime()
				lM.canLootUnit = thisUnit
				lM:debug("Should loot "..UnitName(thisUnit))
				-- Print("Should loot "..UnitName(thisUnit))
				lM:getLoot()
			end
		end
	end
end
-- Frame
local Frame = CreateFrame('Frame')
Frame:RegisterEvent("LOOT_SLOT_CLEARED")
Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
-- loot slot cleared
local function lootEvents(self,event,...)
	if event == "LOOT_SLOT_CLEARED" then
		lM.debug("Looted")
		lM.canLootTimer = GetTime() + 1
		lM.lootedTimer = GetTime()
	elseif event == "PLAYER_REGEN_ENABLED" then
		-- start loot manager
		if lM then
			if not IsMounted("player") then
				lM.shouldLoot = true
				lM.looted = 0
			end
		end
	end
end
Frame:SetScript("OnEvent",lootEvents)
-- pulses always
local function pulse()
	if getOptionCheck("Auto Loot") then
		if not isInCombat("player") then
			-- if we should find a loot
			if lM.shouldLoot == true then
				lM:getLoot()
			end
			-- -- it we seen a loot in reader
			-- if lM.lootedTimer and lM.lootedTimer < GetTime() - getOptionValue("Auto Loot") then
			-- 	if FireHack then ClearTarget() end
			-- 	-- lM.lootedTimer = nil
			-- 	-- lM.shouldLoot = false
			-- 	lM:debug("Clear Target")
			-- end
		end
	end
end
Frame:SetScript("OnUpdate",pulse)
function autoLoot()
	if getOptionCheck("Auto Loot") then
		if not isInCombat("player") then
			-- start loot manager
			if lM then
				if not IsMounted("player") then
					if not lM.canLootUnit then
						lM:findLoot()
					else
						lM.canLootUnit = nil
					end
				end
			end	
		end
	end
end