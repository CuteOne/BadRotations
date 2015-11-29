if select(3,UnitClass("player")) == 6 then

  -- ------Member Check------
  -- function CalculateHP(unit)
  --   incomingheals = UnitGetIncomingHeals(unit) or 0
  --   return 100 * ( UnitHealth(unit) + incomingheals ) / UnitHealthMax(unit)
  -- end

  -- function GroupInfo()
  --   members, group = { { Unit = "player", HP = CalculateHP("player") } }, { low = 0, tanks = { } }
  --   group.type = IsInRaid() and "raid" or "party"
  --   group.number = GetNumGroupMembers()
  --   if group.number > 0 then
  --     for i=1,group.number do
  --       if canHeal(group.type..i) then
  --         local unit, hp = group.type..i, CalculateHP(group.type..i)
  --         members[#members+1] = { Unit = unit, HP = hp }
  --         if hp < 90 then group.low = group.low + 1 end
  --         if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(group.tanks,unit) end
  --       end
  --     end
  --     if group.type == "raid" and #members > 1 then table.remove(members,1) end
  --     table.sort(members, function(x,y) return x.HP < y.HP end)
  --   end
  -- end

  function useAoE()
    local enemies = #getEnemies("player",10)
    local oneHand, twoHand  = IsEquippedItemType("One-Hand"), IsEquippedItemType("Two-Hand")
    if (BadBoy_data['AoE'] == 1 and ((enemies>=3 and oneHand) or (enemies>=4 and twoHand))) or BadBoy_data['AoE'] == 2 then
      -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
      return true
    else
      return false
    end
  end

  function useCDs()
    if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
      return true
    else
      return false
    end
  end

  function useDefensive()
    if BadBoy_data['Defensive'] == 1 then
      return true
    else
      return false
    end
  end

  function useInterrupts()
    if BadBoy_data['Interrupts'] == 1 then
      return true
    else
      return false
    end
  end

  function useCleave()
    if BadBoy_data['Cleave']==1 and BadBoy_data['AoE'] ~= 3 then
      return true
    else
      return false
    end
  end

  simList = {
    -- Highmaul
    {spell = 161630, spelltype = "Damage",}, --Bladespire Sorcerer - Molten Bomb
    {spell = 161634, spelltype = "Damage",}, --Bladespire Sorcerer - Molten Bomb
    {spell = 175610, spelltype = "Damage",}, --Night-Twisted Shadowsworn - Chaos Blast
    {spell = 175614, spelltype = "Damage",}, --Night-Twisted Shadowsworn - Chaos Blast
    {spell = 175899, spelltype = "Damage",}, --Gorian Runemaster - Rune of Unmaking
    {spell = 172066, spelltype = "Damage",}, --Oro - Radiating Poison
    -- Auchindoun
    {spell = 176518, spelltype = "Damage",}, --Sargerei Soulpriest - Shadow Word: Pain
    {spell = 154477, spelltype = "Damage",}, --Soulbinder Nyami - Shadow Word: Pain
    {spell = 167092, spelltype = "Damage",}, --Cackling Pyromaniac - Felblast
    {spell = 178837, spelltype = "Damage",}, --Cackling Pyromaniac - Felblast
    {spell = 154221, spelltype = "Damage",}, --Cackling Pyromaniac - Felblast
    {spell = 157053, spelltype = "Damage",}, --Durag the Dominator - Shadow Bolt
    {spell = 156954, spelltype = "Damage",}, --Gul'kosh - Unstable Affliction
    {spell = 157049, spelltype = "Damage",}, --Grom'tash the Destructor - Immolate
    {spell = 156842, spelltype = "Damage",}, --Teron'gor - Corruption
    {spell = 156925, spelltype = "Damage",}, --Teron'gor - Agony
    {spell = 156829, spelltype = "Damage",}, --Teron'gor - Shadow Bolt
    {spell = 156975, spelltype = "Damage",}, --Teron'gor - Chaos Bolt
    {spell = 156964, spelltype = "Damage",}, --Teron'gor - Immolate
    {spell = 156965, spelltype = "Damage",}, --Teron'gor - Doom
    -- Bloodmaul Slag Mines
    {spell = 151558, spelltype = "Damage",}, --Bloodmaul Ogre Mage - Lava Burst
    {spell = 152427, spelltype = "Damage",}, --Magma Lord - Fireball
    {spell = 150290, spelltype = "Damage",}, --Calamity - Scorch
    {spell = 164615, spelltype = "Damage",}, --Bloodmaul Flamespeaker - Channel Flames
    {spell = 164616, spelltype = "Damage",}, --Bloodmaul Flamespeaker - Channel Flames
    {spell = 150677, spelltype = "Damage",}, --Gug'rokk - Molten Blast
    -- Grimrail Depot
    -- Iron Docks
    {spell = 165122, spelltype = "Damage",}, --Ahri'ok Dugru - Blood Bolt
    -- Shadowmoon Burial Grounds
    {spell = 152819, spelltype = "Damage",}, --Shadowmoon Bone-Mender - Shadow Word: Frailty
    {spell = 156776, spelltype = "Damage",}, --Shadowmoon Enslaver - Rending Voidlash
    {spell = 156722, spelltype = "Damage",}, --Shadowmoon Exhumer - Void Bolt
    {spell = 156717, spelltype = "Damage",}, --Monstrous Corpse Spider - Death Venom
    {spell = 153524, spelltype = "Damage",}, --Plagued Bat - Plague Spit
    -- Skyreach
    {spell = 152894, spelltype = "Non-Damage",}, --Adept of the Dawn - Flash Heal
    {spell = 154396, spelltype = "Damage",}, --High Sage Viryx - Solar Burst
    -- The Everbloom
    {spell = 165213, spelltype = "Non-Damage",}, --Everbloom Tender - Enraged Growth
    {spell = 167966, spelltype = "Damage",}, --Earthshaper Telu - Bramble Patch
    {spell = 169843, spelltype = "Damage",}, --Putrid Pyromancer - Dragon's Breath
    {spell = 169844, spelltype = "Damage",}, --Putrid Pyromancer - Dragon's Breath
    -- Upper Blackrock Spire
    {spell = 155588, spelltype = "Damage",}, --Black Iron Dreadweaver - Shadow Bolt Volley
    {spell = 155587, spelltype = "Damage",}, --Black Iron Dreadweaver - Shadow Bolt
    {spell = 155590, spelltype = "Damage",}, --Black Iron Summoner - Fireball
    {spell = 163057, spelltype = "Damage",}, --Black Iron Flame Reaver - Flame Shock
  }

  function isSimSpell()
    local simSpell = _DarkSimulacrum
    for i=1, #enemiesTable do
      if enemiesTable[i].distance<40 then
        local thisUnit = enemiesTable[i].unit
        if castingUnit(thisUnit) then
          for f=1, #simList do
            local simListSpell = simList[f].spell
            if isCastingSpell(simListSpell,thisUnit) then
              simSpell = simListSpell
              simUnit = thisUnit
              break
            else
              simSpell = _DarkSimulacrum
              simUnit = "target"
            end
          end
        end
      end
    end
    if simSpell~=_DarkSimulacrum then
      return true
    else
      return false
    end
  end
end
