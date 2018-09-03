function ProfessionHelper()
  if isChecked("Profession Helper") then
    if not isInCombat("player") and not (IsMounted() or IsFlying()) then
      local lootDelay = getValue("Profession Helper")
      

      local function processThatTable(thisTable,spell)
          for i = 1,#thisTable do
            local thisItem = thisTable[i]
            if GetItemCount(thisItem,false,false) >= 5  then
              if lootTimer == nil or lootTimer <= GetTime() - lootDelay and not LootFrame:IsShown() then
                CastSpellByName(GetSpellInfo(spell), "player") 
                UseItemByName(tostring(select(1, GetItemInfo(thisTable[i]))))
                lootTimer = GetTime()
                return
              end
            elseif LootFrame:IsShown() then
              for l=1, GetNumLootItems() do
                if LootSlotHasItem(l) then
                  LootSlot(l)
                end
              end
              CloseLoot()
            end
          end 
      end
      ------------------------------------------------------------------------------------------------------
      -- Milling -------------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if isChecked("Mill Herbs") and IsSpellKnown(51005) then
        local millMode = getValue("Mill Herbs")
        if millMode == 5 or millMode == 1 then
          local tableMillLegion = {
            124105, -- Starlight Rose
            124104, -- Fjarnskaggl
            124103, -- Foxflower
            124102, -- Dreamleaf
            124101 -- Aethril
          }
          processThatTable(tableMillLegion,51005)
        end
        if millMode == 5 or millMode == 2 then
          local tableMillWoD = {
            109124, -- Frostweed
            109125, -- Fireweed
            109126,-- Gorgrond Flytrap
            109127, -- Starflower
            109128, -- Nagrand Arrowbloom
            109129 -- Talador Orchid
          }
          processThatTable(tableMillWoD,51005)
        end
        if millMode == 5 or millMode == 3 then
          local tableMillMoP = {
            72234, -- Green Tea Leaf
            72237, -- Rain Poppy
            72235, -- Silkweed
            79010, -- Snow Lily
            79011, -- Fool's Cap
            89639 -- Desecrated Herb
          }
          processThatTable(tableMillMoP,51005)
        end
        if millMode == 5 or millMode == 4 then
          tableMillCata = {
            52986, -- Heartblossom
            52984, -- Stormvine
            52983, -- Cinderbloom
            52985, -- Azshara's Veil
            52987, -- Twilight Jasmine
          --  22785  -- Felweed
          }
          processThatTable(tableMillCata,51005)
        end
      end
      ------------------------------------------------------------------------------------------------------
      -- Prospecting ---------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if isChecked("Prospect Ores") and IsSpellKnown(31252) then
        local prospectMode = getValue("Prospect Ores")
        if prospectMode == 6 or prospectMode == 1 then
          local tableProspectBFA = {
            152512, -- Monelite Ore
            152513, -- Platinum Ore
            152579, -- Storm Silver Ore
          }
          processThatTable(tableProspectBFA, 31252)
        end
        if prospectMode == 6 or prospectMode == 2 then
        }
          local tableProspectLegion = {
            123918, -- Leystone Ore
            123919 -- Felslate Ore
          }
          processThatTable(tableProspectLegion,31252)
        end
        if prospectMode == 6 or prospectMode == 3 then
          local tableProspectWoD = {
            109119, -- True Iron Ore
            109118 -- Blackrock Ore
          }
          processThatTable(tableProspectWoD,31252)
        end
        if prospectMode == 6 or prospectMode == 4 then
          local tableProspectMoP = {
            72092, -- Ghost Iron Ore
            72093, -- Kyparite
            72094, -- Black Trillium Ore
            72103, -- White Trillium Ore
            2770
          }
          processThatTable(tableProspectMoP,31252)
        end
        if prospectMode == 6 or prospectMode == 5 then
          local tableProspectCata = {
            52183, -- Pyrite Ore
            52185, -- Elementium Ore
            53038, -- Obsidium Ore
          }
          processThatTable(tableProspectCata,31252)
        end
      end
      ------------------------------------------------------------------------------------------------------
      -- Disenchant ----------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if isChecked("Disenchant") and IsSpellKnown(13262) then
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
        }
        processThatTable(tableDisenchant,13262)
      end
      ------------------------------------------------------------------------------------------------------
      -- Leather Scraps-------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if isChecked("Leather Scraps") then
        -- Raw Beast Hide Scraps
        if GetItemCount(110610,false,false) >= 10 then
          if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
            if IsUsableItem(110610) then
              UseItemByName(110610)
              lootTimer = GetTime()
            end
          end
        end
      end
      ------------------------------------------------------------------------------------------------------
      -- Lockboxes -----------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if isChecked("Lockboxes") then
        local tableLockBox = {
          121331, -- Leystone Lockbox
        }
        for i = 1,#tableLockBox do
          local thisItem = tableLockBox[i]
          if GetItemCount(thisItem,false,false) >= 1  then
            if lootTimer == nil or lootTimer <= GetTime() - lootDelay and not LootFrame:IsShown() then
              CastSpellByName(GetSpellInfo(1804), "player") 
              UseItemByName(tostring(select(1, GetItemInfo(thisItem))))
              C_Timer.After(1.5, function() UseItemByName(tostring(select(1, GetItemInfo(thisItem)))) end)
              lootTimer = GetTime()
              return
            end
          elseif LootFrame:IsShown() then
            for l=1, GetNumLootItems() do
              if LootSlotHasItem(l) then
                LootSlot(l)
              end
            end
              CloseLoot()
          end
        end     
      end
    end
  end
end
