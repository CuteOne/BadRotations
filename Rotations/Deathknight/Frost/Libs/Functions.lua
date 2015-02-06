if select(3,UnitClass("player")) == 6 then

  ------Member Check------
  function CalculateHP(unit)
    incomingheals = UnitGetIncomingHeals(unit) or 0
    return 100 * ( UnitHealth(unit) + incomingheals ) / UnitHealthMax(unit)
  end

  function GroupInfo()
    members, group = { { Unit = "player", HP = CalculateHP("player") } }, { low = 0, tanks = { } }
    group.type = IsInRaid() and "raid" or "party"
    group.number = GetNumGroupMembers()
    if group.number > 0 then
      for i=1,group.number do
        if canHeal(group.type..i) then
          local unit, hp = group.type..i, CalculateHP(group.type..i)
          members[#members+1] = { Unit = unit, HP = hp }
          if hp < 90 then group.low = group.low + 1 end
          if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(group.tanks,unit) end
        end
      end
      if group.type == "raid" and #members > 1 then table.remove(members,1) end
      table.sort(members, function(x,y) return x.HP < y.HP end)
    end
  end

  function hasThreat()
    local dynTar = dynamicTarget(40,true)
    if select(1,UnitDetailedThreatSituation("player", "target")) == nil then
      return false
    elseif select(1,UnitDetailedThreatSituation("player", "target"))==true then
      return true
    end
  end

  function getRuneInfo()
    local bCount = 0
    local uCount = 0
    local fCount = 0
    local dCount = 0
    local bPercent = 0
    local uPercent = 0
    local fPercent = 0
    local dPercent = 0
    if not runeTable then
      runeTable = {}
    else
      table.wipe(runeTable)
    end
    for i = 1,6 do
      local CDstart = select(1,GetRuneCooldown(i))
      local CDduration = select(2,GetRuneCooldown(i))
      local CDready = select(3,GetRuneCooldown(i))
      local CDrune = CDduration-(GetTime()-CDstart)
      local CDpercent = CDpercent
      local runePercent = 0
      local runeCount = 0
      local runeCooldown = 0
      if CDrune > CDduration then
        CDpercent = 1-(CDrune/(CDduration*2))
      else
        CDpercent = 1-CDrune/CDduration
      end
      if not CDready then
        runePercent = CDpercent
        runeCount = 0
        runeCooldown = CDrune
      else
        runePercent = 1
        runeCount = 1
        runeCooldown = 0
      end
      if GetRuneType(i) == 4 then
        dPercent = runePercent
        dCount = runeCount
        dCooldown = runeCooldown
        runeTable[#runeTable+1] = { Type = "death", Index = i, Count = dCount, Percent = dPercent, Cooldown = dCooldown}
      end
      if GetRuneType(i) == 1 then
        bPercent = runePercent
        bCount = runeCount
        bCooldown = runeCooldown
        runeTable[#runeTable+1] = { Type = "blood", Index = i, Count = bCount, Percent = bPercent, Cooldown = bCooldown}
      end
      if GetRuneType(i) == 2 then
        uPercent = runePercent
        uCount = runeCount
        uCooldown = runeCooldown
        runeTable[#runeTable+1] = { Type = "unholy", Index = i, Count = uCount, Percent = uPercent, Cooldown = uCooldown}
      end
      if GetRuneType(i) == 3 then
        fPercent = runePercent
        fCount = runeCount
        fCooldown = runeCooldown
        runeTable[#runeTable+1] = { Type = "frost", Index = i, Count = fCount, Percent = fPercent, Cooldown = fCooldown}
      end
    end
  end

  function getRunes(Type)
    Type = string.lower(Type)
    local runeCount = 0
    local runeTable = runeTable
    for i = 1, 6 do
      if runeTable[i].Type == Type then
        runeCount = runeCount + runeTable[i].Count
      end
    end
    return runeCount
  end

  function getRunePercent(Type)
    Type = string.lower(Type)
    local runePercent = 0
    local runeCooldown = 0
    local runeTable = runeTable
    for i = 1, 6 do
      if runeTable[i].Type == Type and runeTable[i].Cooldown > runeCooldown then
        runePercent = runeTable[i].Percent
        runeCooldown = runeTable[i].Cooldown
      end
    end
    if getRunes(Type)==2 then
      return 2
    elseif getRunes(Type)==1 then
      return runePercent+1
    else
      return runePercent
    end
  end

  function useAoE()
    if (BadBoy_data['AoE'] == 1 and #getEnemies("player",8) >= 3) or BadBoy_data['AoE'] == 2 then
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

  function getDisease(range,aoe,mod)
    if mod == nil then mod = "min" end
    if range == nil then range = 5 end
    local range = tonumber(range)
    local mod = tostring(mod)
    if aoe == nil then aoe = false end
    local dynTar = dynamicTarget(range,true)
    local dynTarAoE = dynamicTarget(range,false)
    local dist = getDistance("player",dynTar)
    local distAoE = getDistance("player",dynTarAoE)
    local ff = getDebuffRemain(dynTar,_FrostFever,"player")
    local ffAoE = getDebuffRemain(dynTarAoE,_FrostFever,"player")
    local bp = getDebuffRemain(dynTar,_BloodPlague,"player")
    local bpAoE = getDebuffRemain(dynTarAoE,_BloodPlague,"player")
    local np = getDebuffRemain(dynTar,_NecroticPlague,"player")
    local npAoE = getDebuffRemain(dynTarAoE,_NecroticPlague,"player")
    if mod == "min" then
      if aoe == false then
        if dist < range then
          if getTalent(7,1) then
            return np
          elseif ff <= bp then
            return ff
          else
            return bp
          end
        else
          return 99
        end
      elseif aoe == true then
        if distAoE < range then
          if getTalent(7,1) then
            return npAoE
          elseif ffAoE <= bpAoE then
            return ffAoE
          else
            return bpAoE
          end
        else
          return 99
        end
      end
    elseif mod == "max" then
      if aoe == false then
        if dist < range then
          if getTalent(7,1) then
            return np
          elseif ff <= bp then
            return bp
          else
            return ff
          end
        else
          return 0
        end
      elseif aoe == true then
        if distAoE < range then
          if getTalent(7,1) then
            return npAoE
          elseif ffAoE <= bpAoE then
            return bpAoE
          else
            return ffAoE
          end
        else
          return 90
        end
      end
    end
  end
end
