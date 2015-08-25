if select(3, UnitClass("player")) == 4 then

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

  --Rupture Debuff Time Remaining
  function ruptureRemain(unit)
      return getDebuffRemain(unit,rogueAssassination.spell.ruptureDebuff,"player")
  end

  --Rupture Debuff Total Time
  function ruptureDuration(unit)
      return getDebuffDuration(unit,rogueAssassination.spell.ruptureDebuff,"player")
  end

  --Deadly Poison Remain
  function deadlyRemain(unit)
    return getDebuffRemain(unit,rogueAssassination.spell.deadlyPoisonDebuff,"player")
  end

  --Envenom Remain
  function envenomRemain(unit)
    return getBuffRemain("player",rogueAssassination.spell.envenomBuff)
  end

  --Target HP
  function thp(unit)
      return getHP(unit)
  end

  --Target Time to Die
  function ttd(unit)
      return getTimeToDie(unit)
  end

  function useCDs()
    if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
      return true
    else
      return false
    end
  end

  function useAoE()
    if (BadBoy_data['AoE'] == 1 and #getEnemies("player",8) > 1) or BadBoy_data['AoE'] == 2 then
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
    if BadBoy_data['Cleave']==1 and BadBoy_data['AoE'] < 3 then
      return true
    else
      return false
    end
  end

  function canPP() --Pick Pocket Toggle State
    if BadBoy_data['Picker'] == 1 or BadBoy_data['Picker'] == 2 then
      return true
    else
      return false
    end
  end

  function noattack() --Pick Pocket Toggle State
    if BadBoy_data['Picker'] == 2 then
      return true
    else
      return false
    end
  end

  function isPicked()	--	Pick Pocket Testing
    if GetObjectExists("target") then
      if myTarget ~= UnitGUID("target") then
        canPickpocket = true
        myTarget = UnitGUID("target")
      end
    end
    if (canPickpocket == false or BadBoy_data['Picker'] == 3 or GetNumLootItems()>0) then
      return true
    else
      return false
    end
  end

  function getDistance2(Unit1,Unit2)
    if Unit2 == nil then Unit2 = "player"; end
    if GetObjectExists(Unit1) and GetObjectExists(Unit2) then
      local X1,Y1,Z1 = GetObjectPosition(Unit1);
      local X2,Y2,Z2 = GetObjectPosition(Unit2);
      local unitSize = 0;
      if UnitGUID(Unit1) ~= UnitGUID("player") and UnitCanAttack(Unit1,"player") then
        unitSize = UnitCombatReach(Unit1);
      elseif UnitGUID(Unit2) ~= UnitGUID("player") and UnitCanAttack(Unit2,"player") then
        unitSize = UnitCombatReach(Unit2);
      end
      local distance = math.sqrt(((X2-X1)^2)+((Y2-Y1)^2))
      if distance < max(5, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 4/3) then
        return 4.9999
      elseif distance < max(8, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 6.5) then
        if distance-unitSize <= 5 then
          return 5
        else
          return distance-unitSize
        end
      elseif distance-(unitSize+UnitCombatReach("player")) <= 8 then
        return 8
      else
        return distance-(unitSize+UnitCombatReach("player"))
      end
    else
      return 1000;
    end
  end

  function poisonAssData()
    if getOptionValue("Lethal")==1 then
      _LethalPoison = _DeadlyPoison
    end
    if getOptionValue("Lethal")==2 then
      _LethalPoison = _WoundPoison
    end
    if getOptionValue("Non-Lethal")==1 then
      _NonLethalPoison = _CripplingPoison
    end
    if getOptionValue("Non-Lethal")==2 then
      _NonLethalPoison = _LeechingPoison
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
end
