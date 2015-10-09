if select(3, UnitClass("player")) == 11 then    

    --Target HP
    function thp(unit)
        return getHP(unit)
    end

    --Target Time to Die
    function ttd(unit)
        return getTimeToDie(unit)
    end

    --Target Distance
    function tarDist(unit)
        return getDistance(unit)
    end

    function useCDs()
        if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
            return true
        else
            return false
        end
    end

    function useAoE()
        if (BadBoy_data['AoE'] == 1 and #getEnemies("player",8) >= 3) or BadBoy_data['AoE'] == 2 then
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

    function useCleave()
        if BadBoy_data['Cleave']==1 and BadBoy_data['AoE'] < 3 then
            return true
        else
            return false
        end
    end

    function useProwl()
        if BadBoy_data['Prowl']==1 then
            return true
        else
            return false
        end
    end

    function outOfWater()
        if swimTime == nil then swimTime = 0 end
        if outTime == nil then outTime = 0 end
        if IsSwimming() then
            swimTime = GetTime()
            outTime = 0
        end
        if not IsSwimming() then
            outTime = swimTime
            swimTime = 0
        end
        if outTime ~= 0 and swimTime == 0 then
            return true
        end
        if outTime ~= 0 and IsFlying() then
            outTime = 0
            return false
        end
    end
end