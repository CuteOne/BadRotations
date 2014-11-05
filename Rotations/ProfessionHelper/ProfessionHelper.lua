function ProfessionHelper()
  if not isChecked("useProfessionHelper") then return false; end

  local lootDelay = getValue("LootDelay");

  if not isInCombat("player") and not (IsMounted() or IsFlying()) then
    ------------------------------------------------------------------------------------------------------
    -- Milling -------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if isChecked("MillWoDHerbs") then
      -- Talador Orchid
      if IsSpellKnown(51005) and GetItemCount(109129,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(109129)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Nagrand Arrowbloom
      if IsSpellKnown(51005) and GetItemCount(109128,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(109128)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Starflower
      if IsSpellKnown(51005) and GetItemCount(109127,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(109127)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Gorgrond Flytrap
      if IsSpellKnown(51005) and GetItemCount(109126,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(109126)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Fireweed
      if IsSpellKnown(51005) and GetItemCount(109125,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(109125)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Frostweed
      if IsSpellKnown(51005) and GetItemCount(109124,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(109124)
            lootTimer = GetTime()
            return;
          end
        end
      end
    end -- Mill WoD Herbs end
    if isChecked("MillMoPHerbs") then
      -- Fool's Cap
      if IsSpellKnown(51005) and GetItemCount(79011,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(79011)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Snow Lily
      if IsSpellKnown(51005) and GetItemCount(79010,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(79010)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Silkweed
      if IsSpellKnown(51005) and GetItemCount(72235,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(72235)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Rain Poppy
      if IsSpellKnown(51005) and GetItemCount(72237,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(72237)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Green Tea Leaf
      if IsSpellKnown(51005) and GetItemCount(72234,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(72234)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Desecrated Herb
      if IsSpellKnown(51005) and GetItemCount(89639,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(89639)
            lootTimer = GetTime()
            return;
          end
        end
      end
    end -- Mill MoP Herbs end
    if isChecked("MillCataHerbs") then
      -- Heartblossom
      if IsSpellKnown(51005) and GetItemCount(52986,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(52986)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Twilight Jasmine
      if IsSpellKnown(51005) and GetItemCount(52987,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(52987)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Azshara's Veil
      if IsSpellKnown(51005) and GetItemCount(52985,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(52985)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Cinderbloom
      if IsSpellKnown(51005) and GetItemCount(52983,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(52983)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Stormvine
      if IsSpellKnown(51005) and GetItemCount(52984,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 51005, true) then
            UseItemByName(52984)
            lootTimer = GetTime()
            return;
          end
        end
      end
    end -- Mill Cata Herbs end
    ------------------------------------------------------------------------------------------------------
    -- Prospecting ---------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if isChecked("ProspectWoDOre") then
      -- True Iron Ore
      if IsSpellKnown(31252) and GetItemCount(109119,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 31252, true) then
            UseItemByName(109119)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Blackrock Ore
      if IsSpellKnown(31252) and GetItemCount(109118,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 31252, true) then
            UseItemByName(109118)
            lootTimer = GetTime()
            return;
          end
        end
      end
    end -- Prospect WoD end
    if isChecked("ProspectMoPOre") then
      -- Ghost Iron Ore
      if IsSpellKnown(31252) and GetItemCount(72092,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 31252, true) then
            UseItemByName(72092)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Kyparite
      if IsSpellKnown(31252) and GetItemCount(72093,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 31252, true) then
            UseItemByName(72093)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Black Trillium Ore
      if IsSpellKnown(31252) and GetItemCount(72094,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 31252, true) then
            UseItemByName(72094)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- White Trillium Ore
      if IsSpellKnown(31252) and GetItemCount(7210372103,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 31252, true) then
            UseItemByName(72103)
            lootTimer = GetTime()
            return;
          end
        end
      end
    end -- Prospect MoP end
    if isChecked("ProspectCataOre") then
      -- Pyrite Ore
      if IsSpellKnown(31252) and GetItemCount(52183,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 31252, true) then
            UseItemByName(52183)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Elementium Ore
      if IsSpellKnown(31252) and GetItemCount(52185,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 31252, true) then
            UseItemByName(52185)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Obsidium Ore
      if IsSpellKnown(31252) and GetItemCount(53038,false,false) >= 5 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 31252, true) then
            UseItemByName(53038)
            lootTimer = GetTime()
            return;
          end
        end
      end
    end -- Prospect Cata end
    ------------------------------------------------------------------------------------------------------
    -- Disenchant ----------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if isChecked("DisenchantMoPBluesJC") then
      -- JC Blue Neck ilvl 415
      if IsSpellKnown(13262) and GetItemCount(90905,false,false) >= 1 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 13262, true) then
            UseItemByName(90905)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- JC Blue Ring ilvl 415
      if IsSpellKnown(13262) and GetItemCount(90904,false,false) >= 1 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 13262, true) then
            UseItemByName(90904)
            lootTimer = GetTime()
            return;
          end
        end
      end
    end -- Disenchant JC Blues 415 end
    if isChecked("DisenchantMoPGreensJC") then
      -- JC Green Neck ilvl 384
      if IsSpellKnown(13262) and GetItemCount(83794,false,false) >= 1 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 13262, true) then
            UseItemByName(83794)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- JC Green Ring ilvl 384
      if IsSpellKnown(13262) and GetItemCount(83793,false,false) >= 1 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 13262, true) then
            UseItemByName(83793)
            lootTimer = GetTime()
            return;
          end
        end
      end
    end -- Disenchant JC Green 415 end
    if isChecked("DisenchantMoPBluesT") then
      -- Contender's Satin Cuffs (ilvl 450)
      if IsSpellKnown(13262) and GetItemCount(82434,false,false) >= 1 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 13262, true) then
            UseItemByName(82434)
            lootTimer = GetTime()
            return;
          end
        end
      end
      -- Contender's Silk Cuffs (ilvl 450)
      if IsSpellKnown(13262) and GetItemCount(82426,false,false) >= 1 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 13262, true) then
            UseItemByName(82426)
            lootTimer = GetTime()
            return;
          end
        end
      end
    end -- Disenchant Tailor Blue 450 end
    if isChecked("DisenchantMoPGreensT") then
      -- Windwool Bracers (ilvl 384)
      if IsSpellKnown(13262) and GetItemCount(82402,false,false) >= 1 then
        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
          if castSpell("player", 13262, true) then
            UseItemByName(82402)
            lootTimer = GetTime()
            return;
          end
        end
      end
    end -- Disenchant Tailor Greens 384 end
  end -- ooc check end
end -- ProfessionHelper end


--WoD Ore
--[[

]]