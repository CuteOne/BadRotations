if select(3,UnitClass("player")) == 7 then

  function getMWC()
    mwstack = select(4,UnitBuffID("player",53817))
    if UnitLevel("player") >= 50 then
      if mwstack == nil then
        return 0
      else
        return mwstack
      end
    else
      return 5
    end
  end
  function hasFire()
    if GetTotemTimeLeft(1) > 0 then
      return true
    else
      return false
    end
  end
  function hasSearing()
    if select(2, GetTotemInfo(1)) == GetSpellInfo(_SearingTotem) then
      return true
    else
      return false
    end
  end
  function hasMagma()
    if select(2, GetTotemInfo(1)) == GetSpellInfo(_MagmaTotem) then
      return true
    else
      return false
    end
  end
  function hasFireElemental()
    if select(2, GetTotemInfo(1)) == GetSpellInfo(_FireElementalTotem) then
      return true
    else
      return false
    end
  end
  function hasWater()
    if GetTotemTimeLeft(3) > 0 then
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
  function useAoE()
    if (BadBoy_data['AoE'] == 1 and getNumEnemies("player", 12) > 1) or BadBoy_data['AoE'] == 2 then
      return true
    else
      return false
    end
  end
  function hasHST()
    if select(2, GetTotemInfo(3)) == GetSpellInfo(5394) then
      return true
    else
      return false
    end
  end
  function hasTotem()
    if UnitLevel("player") >= 30 and (GetTotemTimeLeft(1) > 0 or GetTotemTimeLeft(2) > 0 or GetTotemTimeLeft(3) > 0 or GetTotemTimeLeft(4) > 0) then
      return true
    else
      return false
    end
  end
  function getSearingCount()
    sfstack = select(4,UnitBuffID("player",_SearingFlames))
    if UnitLevel("player") >= 34 then
      if sfstack == nil then
        return 0
      else
        return sfstack
      end
    else
      return 5
    end
  end
  function shouldBolt()
    local lightning = 0
    local lowestCD = 0
    if useAoE() then
      if getSpellCD(_ChainLightning)==0 and UnitLevel("player")>=28 then
        if UnitBuffID("player",_AncestralSwiftness) and (select(7,GetSpellInfo(_ChainLightning))/1000)<10 then
          lightning = 0
        else
          lightning = select(7,GetSpellInfo(_ChainLightning))/1000
        end
      else
        if UnitBuffID("player",_AncestralSwiftness) and (select(7,GetSpellInfo(_LightningBolt))/1000)<10 then
          lightning = 0
        else
          lightning = select(7,GetSpellInfo(_LightningBolt))/1000
        end
      end
    else
      if UnitBuffID("player",_AncestralSwiftness) and (select(7,GetSpellInfo(_LightningBolt))/1000)<10 then
        lightning = 0
      else
        lightning = select(7,GetSpellInfo(_LightningBolt))/1000
      end
    end
    if UnitLevel("player") < 3 then
      lowestCD = lightning+1
    elseif UnitLevel("player") < 10 then
      lowestCD = min(getSpellCD(_PrimalStrike))
    elseif UnitLevel("player") < 12 then
      lowestCD = min(getSpellCD(_PrimalStrike),getSpellCD(_LavaLash))
    elseif UnitLevel("player") < 26 then
      lowestCD = min(getSpellCD(_PrimalStrike),getSpellCD(_LavaLash),getSpellCD(_FlameShock))
    elseif UnitLevel("player") < 81 then
      lowestCD = min(getSpellCD(_StormStrike),getSpellCD(_LavaLash),getSpellCD(_FlameShock))
    elseif UnitLevel("player") < 87 then
      lowestCD = min(getSpellCD(_Stormstrike),getSpellCD(_FlameShock),getSpellCD(_LavaLash),getSpellCD(_UnleashElements))
    elseif UnitLevel("player") >= 87 then
      if getBuffRemain("player",_AscendanceEnhancement) > 0 then
        lowestCD = min(getSpellCD(_Stormblast),getSpellCD(_FlameShock),getSpellCD(_LavaLash),getSpellCD(_UnleashElements))
      else
        lowestCD = min(getSpellCD(_Stormstrike),getSpellCD(_FlameShock),getSpellCD(_LavaLash),getSpellCD(_UnleashElements))
      end
    end
    if lightning <= lowestCD and getTimeToDie("target") >= lightning then
      return true
    elseif castingUnit("player") and (isCastingSpell(_LightningBolt) or isCastingSpell(_ChainLightning)) and lightning > lowestCD then
      StopCasting()
      return false
    else
      return false
    end
  end
end

