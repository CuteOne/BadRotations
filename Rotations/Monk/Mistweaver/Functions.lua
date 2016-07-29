if select(3,UnitClass("player")) == 10 then

  function useCDsMist()
    if bb.data['Cooldowns'] == 2 then
      return true
    else
      return false
    end
  end

  function useDefensiveMist()
    if bb.data['Defensive'] == 2 then
      return true
    else
      return false
    end
  end

  function useInterruptsMist()
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
end
