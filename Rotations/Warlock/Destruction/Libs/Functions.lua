if select(3,UnitClass("player")) == 9 then
	 function useAoEDestro()
    if BadBoy_data['AoE'] == 2 then
      return true
    else
      return false
    end
  end

  function useSTDestro()
    if BadBoy_data['ST'] == 2 then
      return true
    else
      return false
    end
  end

  function useCDsDestro()
    if (BadBoy_data['Cooldowns'] == 3 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
      return true
    else
      return false
    end
  end

  function useDefensiveDestro()
    if BadBoy_data['Defensive'] == 2 then
      return true
    else
      return false
    end
  end

  function useInterruptsDestro()
    if BadBoy_data['Interrupts'] == 2 then
      return true
    else
      return false
    end
  end
end
