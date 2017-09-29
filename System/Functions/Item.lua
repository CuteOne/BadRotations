-- item charges
function itemCharges(itemID)
	local charges = GetItemCount(itemID,false,true)
	if charges == nil then return 0 end
	return charges
end
-- if canUse(1710) then
function canUse(itemID)
	if itemID==0 or getHP("player") == 0 then return false end
	if (GetItemCount(itemID,false,false) > 0 or PlayerHasToy(itemID) or itemID<19) then
		if itemID<=19 then
			if GetItemSpell(GetInventoryItemID("player",itemID))~=nil then
				local slotItemID = GetInventoryItemID("player",itemID)
				if GetItemCooldown(slotItemID)==0 then
					return true
				end
			else
				return false
			end
		elseif itemID>19 and GetItemCooldown(itemID)==0 then
			return true
		else
			return false
		end
	else
		return false
	end
end
-- if canTrinket(13) then
function canTrinket(trinketSlot)
	if trinketSlot == 13 or trinketSlot == 14 then
		if trinketSlot == 13 and GetInventoryItemCooldown("player",13)==0 then
			return true
		end
		if trinketSlot == 14 and GetInventoryItemCooldown("player",14)==0 then
			return true
		end
	else
		return false
	end
end
-- if hasItem(1234) == true then
function hasItem(itemID)
	local itemFound = false
	for i = 0, 4 do --Let's look at each bag
		local numBagSlots = GetContainerNumSlots(i)
		if numBagSlots>0 then -- Only look for slots if bag present
			for x = 1, numBagSlots do --Let's look at each bag slot
				local bagItemID = GetContainerItemID(i,x)
				if tostring(bagItemID)==tostring(itemID) then
					itemFound = true
				end
			end
		end
	end
	return itemFound
end
-- useItem(12345)
function useItem(itemID)
	br.itemSpamDelay = br.itemSpamDelay or 0
	if itemID<=19 then
		if GetItemSpell(GetInventoryItemID("player",itemID))~=nil then
			local slotItemID = GetInventoryItemID("player",itemID)
			if GetItemCooldown(slotItemID)==0 then
				if not br.itemSpamDelay or GetTime() > br.itemSpamDelay then
					-- RunMacroText("/use "..select(1,GetItemInfo(slotItemID)))
					UseItemByName((select(1,GetItemInfo(slotItemID))));
					br.itemSpamDelay = GetTime() + 1;
					return true
				end
			end
		else
			return false
		end
	elseif itemID>19 and (GetItemCount(itemID) > 0 or PlayerHasToy(itemID)) then
		if GetItemCooldown(itemID)==0 then
			if not br.itemSpamDelay or GetTime() > br.itemSpamDelay then
				-- RunMacroText("/use "..select(1,GetItemInfo(itemID)))
				UseItemByName((select(1,GetItemInfo(itemID))));
				br.itemSpamDelay = GetTime() + 1;
				return true
			end
		end
	end
	return false
end
function hasHealthPot()
	local potion = br.player.potion
	if potion.health == nil then return false end
	if potion.health[1]==nil and potion.rejuve[1]==nil then
		return false
	else
		return true
	end
end
function getHealthPot()
	local potion = br.player.potion
	if potion ~= nil then
		if potion.health ~= nil then
			if potion.health[1]~=nil then
				return potion.health[1].itemID
			elseif potion.rejuve[1]~=nil then
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
	local equippedItems = 0;
	local myClass = select(2,UnitClass("player"));
	local thisTier = string.upper(thisTier);
	local sets = {
		["T17"] = {
			["DRUID"] = {
				115540, -- chest
				115541, -- hands
				115542, -- head
				115543, -- legs
				115544, -- shoulder
			},
			["DEATHKNIGHT"] = {
				115535, -- legs
				115536, -- shoulder
				115537, -- chest
				115538, -- hands
				115539, -- head
			},
			["DEMONHUNTER"] = {

			},
			["HUNTER"] = {
				115545, -- head
				115546, -- legs
				115547, -- shoulder
				115548, -- chest
				115549, -- hands
			},
			["MAGE"] = {
				115550, -- chest
				115551, -- shoulder
				155552, -- hands
				155553, -- head
				155554, -- legs
			},
			["MONK"] = {
				115555, -- hands
				115556, -- head
				115557, -- legs
				115558, -- chest
				115559, -- shoulder
			},
			["PALADIN"] = {
				115565, -- shoulder
				115566, -- chest
				115567, -- hands
				115568, -- head
				115569, -- legs
			},
			["PRIEST"] = {
				115560, -- chest
				115561, -- shoulder
				115562, -- hands
				115563, -- head
				115564, -- legs
			},
			["ROGUE"] = {
				115570, -- chest
				115571, -- hands
				115572, -- head
				115573, -- legs
				115574, -- shoulder
			},
			["SHAMAN"] = {
				115575, -- legs
				115576, -- shoulder
				115577, -- chest
				115578, -- hands
				115579, -- head
			},
			["WARLOCK"] = {
				115585, -- hands
				115586, -- head
				115587, -- legs
				115588, -- chest
				115589, -- shoulder
			},
			["WARRIOR"] = {
				115580, -- legs
				115581, -- shoulder
				115582, -- chest
				115583, -- hands
				115584, -- head
			},
		},
		["T18"] = {
			["DRUID"] = {
				124246, -- chest
				124255, -- hands
				124261, -- head
				124267, -- legs
				124272, -- shoulder
			},
			["DEATHKNIGHT"] = {
				124317, -- chest
				124327, -- hands
				124332, -- head
				124338, -- legs
				124344, -- shoulder
			},
			["DEMONHUNTER"] = {

			},
			["HUNTER"] = {
				124284, -- chest
				124292, -- hands
				124296, -- head
				124301, -- legs
				124307, -- shoulder
			},
			["MAGE"] = {
				124171, -- chest
				124154, -- hands
				124160, -- head
				124165, -- legs
				124177, -- shoulder
			},
			["MONK"] = {
				124247, -- chest
				124256, -- hands
				124262, -- head
				124268, -- legs
				124273, -- shoulder
			},
			["PALADIN"] = {
				124318, -- chest
				124328, -- hands
				124333, -- head
				124339, -- legs
				124345, -- shoulder
			},
			["PRIEST"] = {
				124172, -- chest
				124155, -- hands
				124161, -- head
				124166, -- legs
				124178, -- shoulder
			},
			["ROGUE"] = {
				124248, -- chest
				124257, -- hands
				124263, -- head
				124269, -- legs
				124274, -- shoulder
			},
			["SHAMAN"] = {
				124303, -- chest
				124293, -- hands
				124297, -- head
				124302, -- legs
				124308, -- shoulder
			},
			["WARLOCK"] = {
				124173, -- chest
				124156, -- hands
				124162, -- head
				124167, -- legs
				124179, -- shoulder
			},
			["WARRIOR"] = {
				124319, -- chest
				124329, -- hands
				124334, -- head
				124340, -- legs
				124346, -- shoulder
			},
		},
		["T19"] = {
			["DEATHKNIGHT"] = {
				138355, -- head
				138349, -- chest
				138361, -- shoulder
				138352, -- hands
				138358, -- legs
				138364, -- back
			},
			["DEMONHUNTER"] = {
				138378, -- head
				138376, -- chest
				138380, -- shoulder
				138377, -- hands
				138379, -- legs
				138375, -- back
			},
			["DRUID"] = {
				138330, -- head
				138324, -- chest
				138336, -- shoulder
				138327, -- hands
				138333, -- legs
				138366, -- back
			},
			["HUNTER"] = {
				138342, -- head
				138339, -- chest
				138347, -- shoulder
				138340, -- hands
				138344, -- legs
				138368, -- back
			},
			["MAGE"] = {
				138312, -- head
				138318, -- chest
				138321, -- shoulder
				138309, -- hands
				138315, -- legs
				138365, -- back
			},
			["MONK"] = {
				138331, -- head
				138325, -- chest
				138337, -- shoulder
				138328, -- hands
				138334, -- legs
				138367, -- back
			},
			["PALADIN"] = {
				138356, -- head
				138350, -- chest
				138362, -- shoulder
				138353, -- hands
				138359, -- legs
				138369, -- back
			},
			["PRIEST"] = {
				138313, -- head
				138319, -- chest
				138322, -- shoulder
				138310, -- hands
				138316, -- legs
				138370, -- back
			},
			["ROGUE"] = {
				138332, -- head
				138326, -- chest
				138338, -- shoulder
				138329, -- hands
				138335, -- legs
				138371, -- back
			},
			["SHAMAN"] = {
				138343, -- head
				138346, -- chest
				138348, -- shoulder
				138341, -- hands
				138345, -- legs
				138372, -- back
			},
			["WARLOCK"] = {
				138314, -- head
				138320, -- chest
				138323, -- shoulder
				138311, -- hands
				138317, -- legs
				138373, -- back
			},
			["WARRIOR"] = {
				138357, -- head
				138351, -- chest
				138363, -- shoulder
				138354, -- hands
				138360, -- legs
				138374, -- back
			},
		},
		["T20"] = {
			["DEATHKNIGHT"] = {
				147124, -- head
				147121, -- chest
				147126, -- shoulder
				147123, -- hands
				147125, -- legs
				147122, -- back
			},
			["DEMONHUNTER"] = {
				147130, -- head
				147127, -- chest
				147132, -- shoulder
				147129, -- hands
				147131, -- legs
				147128, -- back
			},
			["DRUID"] = {
				147136, -- head
				147133, -- chest
				147138, -- shoulder
				147135, -- hands
				147137, -- legs
				147134, -- back
			},
			["HUNTER"] = {
				147142, -- head
				147139, -- chest
				147144, -- shoulder
				147141, -- hands
				147143, -- legs
				147140, -- back
			},
			["MAGE"] = {
				147147, -- head
				147149, -- chest
				147150, -- shoulder
				147146, -- hands
				147148, -- legs
				147145, -- back
			},
			["MONK"] = {
				147154, -- head
				147151, -- chest
				147156, -- shoulder
				147153, -- hands
				147155, -- legs
				147152, -- back
			},
			["PALADIN"] = {
				147160, -- head
				147157, -- chest
				147162, -- shoulder
				147159, -- hands
				147161, -- legs
				147158, -- back
			},
			["PRIEST"] = {
				147165, -- head
				147167, -- chest
				147168, -- shoulder
				147164, -- hands
				147166, -- legs
				147163, -- back
			},
			["ROGUE"] = {
				147172, -- head
				147169, -- chest
				147174, -- shoulder
				147171, -- hands
				147173, -- legs
				147170, -- back
			},
			["SHAMAN"] = {
				147178, -- head
				147175, -- chest
				147180, -- shoulder
				147177, -- hands
				147179, -- legs
				147176, -- back
			},
			["WARLOCK"] = {
				147183, -- head
				147185, -- chest
				147186, -- shoulder
				147182, -- hands
				147184, -- legs
				147181, -- back
			},
			["WARRIOR"] = {
				147190, -- head
				147187, -- chest
				147192, -- shoulder
				147189, -- hands
				147191, -- legs
				147188, -- back
			},
		},
	}
	-- scan every items
	for i=1, 19 do
		-- if there is an item in that slot
		if GetInventoryItemID("player", i) ~= nil then
			-- compare to items in our items list
			for j = 1, #sets[thisTier][myClass] do
				if sets[thisTier][myClass][j] ~= nil then
					--Print(sets[thisTier][myClass][j])
					if GetItemInfo(GetInventoryItemID("player", i)) == GetItemInfo(sets[thisTier][myClass][j]) then
						equippedItems = equippedItems + 1;
					end
				end
			end
		end
	end
	return equippedItems;
end

function hasEquiped(ItemID, Slot)
	--Scan Armor Slots to see if specified item was equiped
	local foundItem = false
	for i=1, 19 do
		-- if there is an item in that slot
        if GetInventoryItemID("player", i) ~= nil then
        	-- check if it matches
            if GetInventoryItemID("player", i) == ItemID then
                if i == Slot or Slot == nil then
                    foundItem = true
                    break
                end
            end
        end
    end
	return foundItem;
end