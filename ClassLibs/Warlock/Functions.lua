if select(3,UnitClass("player")) == 9 then



function useCDs()
    if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
        return true
    else
        return false
    end
end
function useAoE()
    if (BadBoy_data['AoE'] == 1 and getNumEnemies("player",10) >= 3) or BadBoy_data['AoE'] == 2 then
        return true
    else
        return false
    end
end



end

