if select(3,UnitClass("player")) == 10 then

  function useCDsMist()
    if BadBoy_data['Cooldowns'] == 2 then
      return true
    else
      return false
    end
  end

  function useDefensiveMist()
    if BadBoy_data['Defensive'] == 2 then
      return true
    else
      return false
    end
  end

  function useInterruptsMist()
    if BadBoy_data['Interrupts'] == 2 then
      return true
    else
      return false
    end
  end
  function useHealing()
    if BadBoy_data['Healing'] == 2 then
      return true
    else
      return false
    end
  end
end
