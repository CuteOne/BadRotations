if select(3,UnitClass("player")) == 6 then
  function getmeleeEnemies()
    if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
    meleeEnemies, ScanTimer = getNumEnemies("player",8), GetTime();
   -- print("MeleeEnemies:"..meleeEnemies);
    end
    return meleeEnemies;
  end

  function useAoE()
    if BadBoy_data['AoE'] == 1 and getmeleeEnemies() >= 3 then
    -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
        return true
    else
        return false
    end
  end

  function useCDs()
    if (BadBoy_data['Cooldowns'] == 1 and (isBoss("target") or isDummy("target"))) or BadBoy_data['Cooldowns'] == 2 then
        return true
    else
        return false
    end
  end

  function useDefCDs()
    if BadBoy_data['Defensive'] == 1 then
        return true
    else
        return false
    end
  end

-----------------------
--- Bloodlust check ---
-----------------------
function hasLust()
    if UnitBuffID("player",2825)        -- Bloodlust
    or UnitBuffID("player",80353)       -- Timewarp
    or UnitBuffID("player",32182)       -- Heroism
    or UnitBuffID("player",90355) then  -- Ancient Hysteria
        return true
    else
        return false
    end
end

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
                table.insert( members,{ Unit = unit, HP = hp } )
                if hp < 90 then group.low = group.low + 1 end
                if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(group.tanks,unit) end
            end
        end
        if group.type == "raid" and #members > 1 then table.remove(members,1) end
        table.sort(members, function(x,y) return x.HP < y.HP end)
        --local customtarget = canHeal("target") and "target" -- or CanHeal("mouseover") and GetMouseFocus() ~= WorldFrame and "mouseover"
        --if customtarget then table.sort(members, function(x) return UnitIsUnit(customtarget,x.Unit) end) end
    end
end

end