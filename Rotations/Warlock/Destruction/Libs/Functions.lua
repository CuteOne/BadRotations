if select(3,UnitClass("player")) == 9 then
	 function useAoE()
    if ((BadBoy_data['AoE'] == 1 and #getEnemies("player",8) >= 3) or BadBoy_data['AoE'] == 2) and UnitLevel("player")>=46 then
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













end
