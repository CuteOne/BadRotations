local _, br = ...
br.misc.ProfessionHelper = br.misc.ProfessionHelper or {}
local ProfessionHelper = br.misc.ProfessionHelper

-- When the helper last used an item. A loot window that opens within OWN_LOOT seconds of that is the
-- helper's (milling, prospecting, a lockbox) and it empties it; any other window is left alone.
local lastAction
local OWN_LOOT = 5

local function ready(delay)
	return (lastAction == nil or lastAction <= br._G.GetTime() - delay) and not br._G.LootFrame:IsShown()
end

function ProfessionHelper:ProfessionHelper()
	if br.functions.misc:isChecked("Profession Helper") then
		if not br.functions.misc:isInCombat("player") and not (br._G.IsMounted() or br._G.IsFlying()) then
			local lootDelay = br.functions.misc:getValue("Profession Helper")
			if br._G.LootFrame:IsShown() then
				if lastAction and br._G.GetTime() - lastAction < OWN_LOOT then
					br.engines.lootEngine:manuallyLootAll()
				end
				return
			end
			-- Uses the first listed item found in the bags, at most one per tick
			local function processThatTable(thisTable, spell)
				if not ready(lootDelay) then return end
				for i = 1, #thisTable do
					local thisItem = thisTable[i]
					if br._G.GetItemCount(thisItem, false, false) >= 5 or spell == 13262 then
						for bagID = 0, br._G["NUM_BAG_SLOTS"] do
							for slotID = 1, br._G.C_Container.GetContainerNumSlots(bagID) do
								local itemID
								if br._G.C_Container.GetContainerItemID then
									itemID = br._G.C_Container.GetContainerItemID(bagID, slotID)
								else
									local info = br._G.C_Container.GetContainerItemInfo(bagID, slotID)
									itemID = info and info.itemID
								end
								if itemID == thisItem then
									br._G.RunMacroText("/cast " .. br.api.wow.GetSpellInfo(spell))
									br._G.RunMacroText("/use item:" .. itemID)
									lastAction = br._G.GetTime()
									return
								end
							end
						end
					end
				end
			end
			------------------------------------------------------------------------------------------------------
			-- Milling -------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			if br.functions.misc:isChecked("Mill Herbs") and br._G.IsSpellKnown(51005) then
				local millMode = br.functions.misc:getValue("Mill Herbs")
				if millMode == 7 or millMode == 1 then
					local tableMillSL = {
						168586, -- Rising Glory
						168589, -- Marrowroot
						170554, -- Vigil's Torch
						168583, -- Widowbloom
						169701, -- Death Blossom
						171315 -- Nightshade
					}
					processThatTable(tableMillSL, 51005)
				end
				if millMode == 7 or millMode == 2 then
					local tableMillBFA = {
						152505, -- Riverbud
						152511, -- Sea Stalk
						152506, -- Star Moss
						152507, -- Akunda's Bite
						152508, -- Winter's Kiss
						152510, -- Anchor Weed
						168487 -- Zin'anthid
					}
					processThatTable(tableMillBFA, 51005)
				end
				if millMode == 7 or millMode == 3 then
					local tableMillLegion = {
						124105, -- Starlight Rose
						124104, -- Fjarnskaggl
						124103, -- Foxflower
						124102, -- Dreamleaf
						124101 -- Aethril
					}
					processThatTable(tableMillLegion, 51005)
				end
				if millMode == 7 or millMode == 4 then
					local tableMillWoD = {
						109124, -- Frostweed
						109125, -- Fireweed
						109126, -- Gorgrond Flytrap
						109127, -- Starflower
						109128, -- Nagrand Arrowbloom
						109129 -- Talador Orchid
					}
					processThatTable(tableMillWoD, 51005)
				end
				if millMode == 7 or millMode == 5 then
					local tableMillMoP = {
						72234, -- Green Tea Leaf
						72237, -- Rain Poppy
						72235, -- Silkweed
						79010, -- Snow Lily
						79011, -- Fool's Cap
						89639 -- Desecrated Herb
					}
					processThatTable(tableMillMoP, 51005)
				end
				if millMode == 7 or millMode == 6 then
					local tableMillCata = {
						52986, -- Heartblossom
						52984, -- Stormvine
						52983, -- Cinderbloom
						52985, -- Azshara's Veil
						52987 -- Twilight Jasmine
					}
					processThatTable(tableMillCata, 51005)
				end
			end
			------------------------------------------------------------------------------------------------------
			-- Prospecting ---------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			if br.functions.misc:isChecked("Prospect Ores") and br._G.IsSpellKnown(31252) then
				local prospectMode = br.functions.misc:getValue("Prospect Ores")
				if prospectMode == 7 or prospectMode == 1 then
					local tableProspectSL = {
						171828, -- Laestrite Ore
						171833, -- Elethium Ore
						171829, -- Solenium Ore
						171830, -- Oxxein Ore
						171831, -- Phaedrum Ore
						171832 -- Sinvyr Ore
					}
					processThatTable(tableProspectSL, 31252)
				end
				if prospectMode == 7 or prospectMode == 2 then
					local tableProspectBFA = {
						152512, -- Monelite Ore
						152513, -- Platinum Ore
						152579 -- Storm Silver Ore
					}
					processThatTable(tableProspectBFA, 31252)
				end
				if prospectMode == 7 or prospectMode == 3 then
					local tableProspectLegion = {
						123918, -- Leystone Ore
						123919 -- Felslate Ore
					}
					processThatTable(tableProspectLegion, 31252)
				end
				if prospectMode == 7 or prospectMode == 4 then
					local tableProspectWoD = {
						109119, -- True Iron Ore
						109118 -- Blackrock Ore
					}
					processThatTable(tableProspectWoD, 31252)
				end
				if prospectMode == 7 or prospectMode == 5 then
					local tableProspectMoP = {
						72092, -- Ghost Iron Ore
						72093, -- Kyparite
						72094, -- Black Trillium Ore
						72103 -- White Trillium Ore
					}
					processThatTable(tableProspectMoP, 31252)
				end
				if prospectMode == 7 or prospectMode == 6 then
					local tableProspectCata = {
						52183, -- Pyrite Ore
						52185, -- Elementium Ore
						53038 -- Obsidium Ore
					}
					processThatTable(tableProspectCata, 31252)
				end
			end
			------------------------------------------------------------------------------------------------------
			-- Disenchant ----------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			if br.functions.misc:isChecked("Disenchant") and br._G.IsSpellKnown(13262) then
				-- list of items to me DE
				local tableDisenchant = {
					90905, -- JC Blue Neck ilvl 415
					90904, -- JC Blue Ring ilvl 415
					83794, -- JC Green Neck ilvl 384
					83793, -- JC Green Ring ilvl 384
					82434, -- Contender's Satin Cuffs (ilvl 450)
					82426, -- Contender's Silk Cuffs (ilvl 450)
					82402, -- Windwool Bracers (ilvl 384)
					130223, -- Deep Amber Loop (ilvl 715)
					130224, -- Skystone Loop (ilvl 715)
					130225, -- Azsunite Loop (ilvl 715)
					130226, -- Deep Amber Pendant (ilvl 765)
					130227, -- Skystone Pendant (ilvl 765)
					130228, -- Azsunite Pendant (ilvl 765)
					130229, -- Prophetic Band (ilvl 835)
					130230, -- Maelstrom Band (ilvl 835)
					130231, -- Dawnlight Band (ilvl 835)
					136711, -- Queen's Opal Loop (ilvl 715)
					136712, -- Queen's Opal Pendant (ilvl 765)
					136713, -- Shadowruby Band (ilvl 835)
					128899, -- Battlebound Armbands
					128883, -- Warhide Bindings
					154692, -- Tidespray Linen Bracers
				}
				processThatTable(tableDisenchant, 13262)
			end
			------------------------------------------------------------------------------------------------------
			-- Leather Scraps-------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			if br.functions.misc:isChecked("Leather Scraps") then
				-- Raw Beast Hide Scraps
				if br._G.GetItemCount(110610, false, false) >= 10 then
					if ready(lootDelay) then
						if br._G.IsUsableItem(110610) then
							br._G.UseItemByName(110610)
							lastAction = br._G.GetTime()
						end
					end
				end
			end
			------------------------------------------------------------------------------------------------------
			-- Lockboxes -----------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			local pickLock = br.functions.spell:getHighestSpellID("pickLock")
			if br.functions.misc:isChecked("Lockboxes") and br.functions.spell:isKnown(pickLock) then
				local tableLockBox = {
					121331 -- Leystone Lockbox
				}
				for i = 1, #tableLockBox do
					local thisItem = tableLockBox[i]
					if br._G.GetItemCount(thisItem, false, false) >= 1 and ready(lootDelay) then
						br.functions.cast:castByName(br.functions.spell:getName(pickLock), "player")
						br._G.UseItemByName(tostring(select(1, br._G.GetItemInfo(thisItem))))
						br._G.C_Timer.After(1.5,
							function() br._G.UseItemByName(tostring(select(1, br._G.GetItemInfo(thisItem)))) end)
						lastAction = br._G.GetTime()
						return
					end
				end
			end
			------------------------------------------------------------------------------------------------------
			-- Fish Oil ------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			if br.functions.misc:isChecked("Fish Oil") then
				local tableFish = {
					152545, -- Frenzied Fangtooth
					152547, -- Great Sea Catfish
					152546, -- Lane Snapper
					152549, -- Redtail Loach
					152543, -- Sand Shifter
					152544, -- Slimy Mackerel
					152548, -- Tiragarde Perch
					168646 -- Mauve Stinger
				}
				for i = 1, #tableFish do
					local thisItem = tableFish[i]
					if br._G.GetItemCount(thisItem, false, false) >= 1 then
						if ready(lootDelay) then
							if br._G.IsUsableItem(thisItem) then
								br._G.UseItemByName(thisItem)
								lastAction = br._G.GetTime()
							end
						end
					end
				end
			end
		end
	end
end

function ProfessionHelper:bait()
	if br.functions.misc:isChecked("Bait") then
		local bait = br.functions.misc:getValue("Bait")
		if bait == 1 then -- Lost Sole Bait
			if br.functions.item:hasItem(173038) and br.functions.aura:getBuffRemain("player", 331688) == 0 then
				if br.functions.item:canUseItem(173038) then
					br.functions.item:useItem(173038)
				end
			end
		end
		if bait == 2 then -- Silvergill Pike Bait
			if br.functions.item:hasItem(173040) and br.functions.aura:getBuffRemain("player", 331690) == 0 then
				if br.functions.item:canUseItem(173040) then
					br.functions.item:useItem(173040)
				end
			end
		end
		if bait == 3 then -- Pocked Bonefish Bait
			if br.functions.item:hasItem(173041) and br.functions.aura:getBuffRemain("player", 331695) == 0 then
				if br.functions.item:canUseItem(173041) then
					br.functions.item:useItem(173041)
				end
			end
		end
		if bait == 4 then -- Iridescent Amberjack Bait
			if br.functions.item:hasItem(173039) and br.functions.aura:getBuffRemain("player", 331692) == 0 then
				if br.functions.item:canUseItem(173039) then
					br.functions.item:useItem(173039)
				end
			end
		end
		if bait == 5 then -- Spinefin Piranha Bait
			if br.functions.item:hasItem(173042) and br.functions.aura:getBuffRemain("player", 331699) == 0 then
				if br.functions.item:canUseItem(173042) then
					br.functions.item:useItem(173042)
				end
			end
		end
		if bait == 6 then -- Elysian Thade Bait
			if br.functions.item:hasItem(173043) and br.functions.aura:getBuffRemain("player", 331698) == 0 then
				if br.functions.item:canUseItem(173043) then
					br.functions.item:useItem(173043)
				end
			end
		end
	end
end
