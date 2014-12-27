if select(3, UnitClass("player")) == 11 then
    
    ------Member Check------
    function CalculateHP(unit)
      incomingheals = UnitGetIncomingHeals(unit) or 0
      return 100 * ( UnitHealth(unit) + incomingheals ) / UnitHealthMax(unit)
    end

    function GroupInfo()
        members, group = { { Unit = "player", HP = CalculateHP("player") } }, { low = 0, tanks = { } }
        group.type = IsInRaid() and "raid" or "party"
        group.number = GetNumGroupMembers()
        if group.number > 0 then
            for i=1,group.number do
                if canHeal(group.type..i) then
                    local unit, hp = group.type..i, CalculateHP(group.type..i)
                    table.insert( members,{ Unit = unit, HP = hp } )
                    if hp < 90 then group.low = group.low + 1 end
                    if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(group.tanks,unit) end
                end
            end
            if group.type == "raid" and #members > 1 then table.remove(members,1) end
            table.sort(members, function(x,y) return x.HP < y.HP end)
        end
    end

    function WA_calcStats_feral()
        local DamageMult = 1

        local CP = GetComboPoints("player", "target")
        if CP == 0 then CP = 5 end

        if UnitBuffID("player",tf) then
            DamageMult = DamageMult * 1.15
        end

        if UnitBuffID("player",svr) then
            DamageMult = DamageMult * 1.4
        end

        WA_stats_BTactive = WA_stats_BTactive or  0
        if UnitBuffID("player",bt) then
            WA_stats_BTactive = GetTime()
            DamageMult = DamageMult * 1.3
        elseif GetTime() - WA_stats_BTactive < .2 then
            DamageMult = DamageMult * 1.3
        end

        local RakeMult = 1
        WA_stats_prowlactive = WA_stats_prowlactive or  0
        if UnitBuffID("player",inc) then
            RakeMult = 2
        elseif UnitBuffID("player",prl) or UnitBuffID("player",sm) then
            WA_stats_prowlactive = GetTime()
            RakeMult = 2
        elseif GetTime() - WA_stats_prowlactive < .2 then
            RakeMult = 2
        end

        WA_stats_RipTick = CP*DamageMult
        WA_stats_RipTick5 = 5*DamageMult
        WA_stats_RakeTick = DamageMult*RakeMult
        WA_stats_ThrashTick = DamageMult
    end

    --Calculated Rake Dot Damage
    function CRKD()
        WA_calcStats_feral()
        local calcRake = WA_stats_RakeTick
        return calcRake
    end

    --Applied Rake Dot Damage
    function RKD(unit)
        if Rake_sDamage==nil then
            return 0.5
        elseif UnitExists(unit) then
            if getDebuffRemain(unit,rk,"player")==0 then
                rakeDot = 0.5
            else
                rakeDot = Rake_sDamage[UnitGUID(unit)]
            end
        end
        if rakeDot~=nil then
            return rakeDot
        else
            return 0.5
        end
    end

    --Rake Dot Damage Percent
    function RKP(unit)
        local RatioPercent = floor(CRKD()/RKD(unit)*100+0.5)
        return RatioPercent
    end

    --Calculated Rip Dot Damage
    function CRPD()
        WA_calcStats_feral()
        local calcRip = WA_stats_RipTick5
        return calcRip
    end

    --Applied Rip Dot Damage
    function RPD(unit)
        if Rip_sDamage==nil then
            return 0.5
        elseif UnitExists(unit) then
            if getDebuffRemain(unit,rp,"player")==0 then
                ripDot = 0.5
            else
                ripDot = Rip_sDamage[UnitGUID(unit)]
            end
        end
        if ripDot~=nil then
            return ripDot
        else
            return 0.5
        end
    end

    --Rip Dot Damage Percent
    function RPP()
        local RatioPercent = floor(CRPD()/RPD(unit)*100+0.5)
        return RatioPercent
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
        if BadBoy_data['Cleave']==1 and BadBoy_data['AoE'] ~= 3 then
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

    function getDistance2(Unit1,Unit2)
        if Unit2 == nil then Unit2 = "player"; end
        if UnitExists(Unit1) and UnitExists(Unit2) then
            local X1,Y1,Z1 = ObjectPosition(Unit1);
            local X2,Y2,Z2 = ObjectPosition(Unit2);
            local unitSize = 0;
            if UnitGUID(Unit1) ~= UnitGUID("player") and UnitCanAttack(Unit1,"player") then
                unitSize = UnitCombatReach(Unit1);
            elseif UnitGUID(Unit2) ~= UnitGUID("player") and UnitCanAttack(Unit2,"player") then
                unitSize = UnitCombatReach(Unit2);
            end
            local distance = math.sqrt(((X2-X1)^2)+((Y2-Y1)^2))
            if distance < max(5, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 4/3) then
                return 4.9999
            elseif distance < max(8, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 6.5) then
                if distance-unitSize <= 5 then
                    return 5
                else
                    return distance-unitSize
                end
            elseif distance-(unitSize+UnitCombatReach("player")) <= 8 then
                return 8
            else
                return distance-(unitSize+UnitCombatReach("player"))
            end
        else
            return 1000;
        end
    end
end