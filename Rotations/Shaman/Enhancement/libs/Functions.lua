if select(3,UnitClass("player")) == 7 then
  function useCDs(spellid)
    if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
      return true
    else
      return false
    end
  end
  function useAoE()
    if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
      return true
    else
      return false
    end
  end
  function useSingle()
    if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 3 then
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
  function useDefensive()
    if BadBoy_data['Defensive'] == 1 then
      return true
    else
      return false
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
      lowestCD = min(getSpellCD(_Stormstrike),getSpellCD(_LavaLash),getSpellCD(_FlameShock))
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

