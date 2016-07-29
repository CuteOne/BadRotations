if select(3,UnitClass("player")) == 9 then
	 function useAoEDestro()
    if bb.data['AoE'] == 2 then
      return true
    else
      return false
    end
  end

  function useSTDestro()
    if bb.data['ST'] == 2 then
      return true
    else
      return false
    end
  end

  function useCDsDestro()
    if (bb.data['Cooldowns'] == 3 and isBoss() and not UnitIsDeadOrGhost("target") and UnitCanAttack("player","target")) or bb.data['Cooldowns'] == 2 then
      return true
    else
      return false
    end
  end

  function useDefensiveDestro()
    if bb.data['Defensive'] == 2 then
      return true
    else
      return false
    end
  end

  function useInterruptsDestro()
    if bb.data['Interrupts'] == 2 then
      return true
    else
      return false
    end
  end
end
