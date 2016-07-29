if select(3,UnitClass("player")) == 7 then

  function EarthShield()
    -- We look if someone in Nova have our shield
    local foundShield, shieldRole = false, "none"
    for i = 1, #bb.friend do
      if getBuffStacks(bb.friend[i].unit,_EarthShield,"player") > 2 then
        if bb.friend[i].role == "TANK" or UnitIsUnit("focus",bb.friend[i].unit) then
          shieldRole = "tank or focus"
        end
        foundShield = true
        break
      end
    end

    -- if no valid shield found
    if foundShield == false or shieldRole == "none" then
      -- if we have focus, check if this unit have shield, if it's not ours, find another target.
      if UnitExists("focus") == true then
        if not UnitBuffID("focus", _WaterShield) and not UnitBuffID("focus", _EarthShield) and not UnitBuffID("focus", _LightningShield) then
          if castSpell("focus",_EarthShield,true,false) then print("recast focus")return end
        end
      else
        -- if focus was already buffed or is invalid then we chek bb.friend roles for tank.
        for i = 1, #bb.friend do
          if not UnitBuffID(bb.friend[i].unit, _WaterShield) and not UnitBuffID(bb.friend[i].unit, _EarthShield) and not UnitBuffID(bb.friend[i].unit, _LightningShield) and bb.friend[i].role == "TANK" and bb.friend[i].hp < 100 then
            if castSpell(bb.friend[i].unit,_EarthShield,true,false) then return end
          end
        end
      end
      if shieldRole == "none" and shieldFound == false then
        -- if no tank was found we are gonna cast on the lowest unit and wait for it to be under 2 stack or we have a tank before recasting.
        for i = 1, # bb.friend do
          if not UnitBuffID("focus", _WaterShield) and not UnitBuffID("focus", _EarthShield) and not UnitBuffID("focus", _LightningShield) and bb.friend[i].hp < 100 and castSpell(bb.friend[i].unit,_EarthShield,true,false) then return end
        end
      end
    end
  end

  function useCDsResto()
    if bb.data['Cooldowns'] == 2 then
      return true
    else
      return false
    end
  end

  function useDefensiveResto()
    if bb.data['Defensive'] == 2 then
      return true
    else
      return false
    end
  end

  function useInterruptsResto()
    if bb.data['Interrupts'] == 2 then
      return true
    else
      return false
    end
  end
  function useHealing()
    if bb.data['Healing'] == 2 then
      return true
    else
      return false
    end
  end
  function useDamageResto()
    if bb.data['Damage'] == 2 then
      return true
    else
      return false
    end
  end
end

