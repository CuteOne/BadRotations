if select(3,UnitClass("player")) == 7 then
  function useCDs(spellid)
    if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
      return true
    else
      return false
    end
  end
  function useAuto()
    if BadBoy_data['AoE'] == 1 then
      return true
    else
      return false
    end
  end
  function useAoE()
    if BadBoy_data['AoE'] == 2 then
      return true
    else
      return false
    end
  end
  function useSingle()
    if BadBoy_data['AoE'] == 3 then
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
    local self = enhancementShaman
    local lightning = 0
    local lowestCD = 0
    if useAoE() then
      if self.cd.chainLightning==0 and self.level>=28 then
        if self.buff.ancestralSwiftness and (select(7,GetSpellInfo(self.spell.chainLightning))/1000)<10 then
          lightning = 0
        else
          lightning = select(7,GetSpellInfo(self.spell.chainLightning))/1000
        end
      else
        if self.buff.ancestralSwiftness and select(7,GetSpellInfo(self.spell.lightningBolt)/1000)<10 then
          lightning = 0
        else
          lightning = select(7,GetSpellInfo(self.spell.lightningBolt))/1000
        end
      end
    else
      if self.buff.ancestralSwiftness and select(7,GetSpellInfo(self.spell.lightningBolt)/1000)<10 then
        lightning = 0
      else
        lightning = select(7,GetSpellInfo(self.spell.lightningBolt))/1000
      end
    end
    if self.level < 3 then
      lowestCD = lightning+1
    elseif self.level < 10 then
      lowestCD = min(self.cd.primalStrike)
    elseif self.level < 12 then
      lowestCD = min(self.cd.primalStrike,self.cd.lavaLash)
    elseif self.level < 26 then
      lowestCD = min(self.cd.primalStrike,self.cd.lavaLash,self.cd.flameShock)
    elseif self.level < 81 then
      lowestCD = min(self.cd.stormstrike,self.cd.lavaLash,self.cd.flameShock)
    elseif self.level < 87 then
      lowestCD = min(self.cd.stormstrike,self.cd.lavaLash,self.cd.flameShock,self.cd.unleashElements)
    elseif self.level >= 87 then
      if self.buff.remain.ascendance > 0 then
        lowestCD = min(self.cd.windstrike,self.cd.lavaLash,self.cd.flameShock,self.cd.unleashElements)
      else
        lowestCD = min(self.cd.stormstrike,self.cd.lavaLash,self.cd.flameShock,self.cd.unleashElements)
      end
    end
    if (lightning <= lowestCD or lightning <= self.gcd) and getTimeToDie("target") >= lightning then
      return true
    elseif castingUnit("player") and (isCastingSpell(_LightningBolt) or isCastingSpell(_ChainLightning)) and lightning > lowestCD then
      StopCasting()
      return false
    else
      return false
    end
  end
end

