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

--chumii useAoE / no idea, but cutes didnt work for me oO
function chumiigetmeleeEnemies()
    if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
    meleeEnemies, ScanTimer = getNumEnemies("player",8), GetTime();
   -- print("MeleeEnemies:"..meleeEnemies);
    end
    return meleeEnemies;
end

function chumiiuseAoE()
    if BadBoy_data['AoE'] == 1 and chumiigetmeleeEnemies() >= 3 then
    -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
        return true
    else
        return false
    end
end

-- Check for dead raidmember
function DeadRaidMember()
    for i = 1, #nNova do
        if isPlayer(nNova[i].unit) == true and UnitIsDeadOrGhost(nNova[i].unit) then
            return true;
        else
            return false;
        end
    end
end

--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]
--[[]]     --[[]]   --[[]]              --[[]]                   --[[ ]]        --[[]]     --[[]]
--[[           ]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[]]     --[[]]
--[[        ]]      --[[]]                         --[[]]        --[[ ]]        --[[]]     --[[]]
--[[]]    --[[]]    --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]
--[[]]     --[[]]   --[[           ]]   --[[           ]]        --[[ ]]        --[[           ]]


-- SwiftMender
function SwiftMender()
    if isChecked("Swiftmend") then
        if lowestHP <= getValue("Swiftmend") then
            if (getBuffRemain(lowestUnit,774,"player") > 1 or getBuffRemain(lowestUnit,8936,"player") > 1) and getSpellCD(18562) < 1 then
                CastSpellByName(GetSpellInfo(18562),lowestUnit) return true
            end
        end
    end
end

function findShroom()
    if shroomsTable[1].x == nil then
        for i = 1, ObjectCount() do
            if UnitExists(ObjectWithIndex(i)) == true then
                local myShroom = shroomsTable[1].guid
                --print(UnitGUID(ObjectWithIndex(i)))
                if shroomsTable[1].guid == UnitGUID(ObjectWithIndex(i)) then
                    X, Y, Z = ObjectPosition(ObjectWithIndex(i));
                   -- print("lol")
                    shroomsTable[1] = { x = X, y = Y, z = Z, guid = myShroom };
                    return true
                end
            end
        end
    else
        return true
    end
    return false;
end

function MultiMoon()
    if canCast(_Moonfire,false,false) and isChecked("Multidotting") then
        -- begin loop
        if enemiesTable ~= nil then
            for i = 1, #enemiesTable do
                -- now that we know the unit is valid, we can use it to check whatever we want.. let's call it thisUnit
                local thisUnit = enemiesTable[i].unit
                -- Here I do my specific spell checks
                if ((UnitAffectingCombat(thisUnit) == true) or isDummy(thisUnit)) and getDebuffRemain(thisUnit,_Moonfire) < (18*0.3) then
                    -- All is good, let's cast.
                    if castSpell(thisUnit,_Moonfire,false,false) then
                        return
                    end
                end
            end
        end
    end
end

-- select(2,DruidCastTime()) > 2
function DruidCastTime()
    local castDuration = 0
    local castTimeRemain = 0

    if select(6,UnitCastingInfo("player"))  then
        castStartTime = select(5,UnitCastingInfo("player"))
        castEndTime = select(6,UnitCastingInfo("player"))
      else
        castStartTime = 0
        castEndTime = 0
    end
    if castEndTime > 0 and castStartTime > 0 then
        castDuration = (castEndTime - castStartTime)/1000
        castTimeRemain = ((castEndTime/1000) - GetTime())
    else
        castDuration = 0
        castTimeRemain = 0
    end
    if castDuration and castTimeRemain  then
       return castDuration,castTimeRemain
	end
end

function isCastingDruid(Unit)
	if Unit == nil then Unit = "player" end
	if UnitCastingInfo(Unit) ~= nil
	  or UnitChannelInfo(Unit) ~= nil
	  or (GetSpellCooldown(61304) ~= nil and GetSpellCooldown(61304) > 0.001) then
	  	return true; else return false
	end
end


end