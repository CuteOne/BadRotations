if select(3,UnitClass("player")) == 6 then
    local playerSpec = GetSpecialization()
    if playerSpec == 3 then
-----------------------
--- Bloodlust check ---
-----------------------
function hasLust()
    if UnitBuffID("player",2825)        -- Bloodlust
    or UnitBuffID("player",80353)       -- Timewarp
    or UnitBuffID("player",32182)       -- Heroism
    or UnitBuffID("player",90355) then  -- Ancient Hysteria
        return true
    else
        return false
    end
end
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

    function getRuneInfo()
        local bCount = 0
        local uCount = 0
        local fCount = 0
        local dCount = 0
        local bPercent = 0
        local uPercent = 0
        local fPercent = 0
        local dPercent = 0
        if not runeTable then
            runeTable = {}
        else
            table.wipe(runeTable)
        end
        for i = 1,6 do
            local CDstart = select(1,GetRuneCooldown(i))
            local CDduration = select(2,GetRuneCooldown(i))
            local CDready = select(3,GetRuneCooldown(i))
            local CDrune = CDduration-(GetTime()-CDstart)
            local CDpercent = CDpercent
            local runePercent = 0
            local runeCount = 0
            local runeCooldown = 0
            if CDrune > CDduration then
                CDpercent = 1-(CDrune/(CDduration*2))
            else
                CDpercent = 1-CDrune/CDduration
            end
            if not CDready then
                runePercent = CDpercent
                runeCount = 0
                runeCooldown = CDrune
            else
                runePercent = 1
                runeCount = 1
                runeCooldown = 0
            end
            if GetRuneType(i) == 4 then
                dPercent = runePercent
                dCount = runeCount
                dCooldown = runeCooldown
                table.insert( runeTable,{ Type = "death", Index = i, Count = dCount, Percent = dPercent, Cooldown = dCooldown})
            end
            if GetRuneType(i) == 1 then
                bPercent = runePercent
                bCount = runeCount
                bCooldown = runeCooldown
                table.insert( runeTable,{ Type = "blood", Index = i, Count = bCount, Percent = bPercent, Cooldown = bCooldown})
            end
            if GetRuneType(i) == 2 then
                uPercent = runePercent
                uCount = runeCount
                uCooldown = runeCooldown
                table.insert( runeTable,{ Type = "unholy", Index = i, Count = uCount, Percent = uPercent, Cooldown = uCooldown})
            end
            if GetRuneType(i) == 3 then
                fPercent = runePercent
                fCount = runeCount
                fCooldown = runeCooldown
                table.insert( runeTable,{ Type = "frost", Index = i, Count = fCount, Percent = fPercent, Cooldown = fCooldown})
            end
        end
    end

    function getRunes(Type)
        Type = string.lower(Type)
        local runeCount = 0
        local runeTable = runeTable
        for i = 1, 6 do
            if runeTable[i].Type == Type then
                runeCount = runeCount + runeTable[i].Count
            end
        end
        return runeCount
    end

    function getRunePercent(Type)
        Type = string.lower(Type)
        local runePercent = 0
        local runeCooldown = 0
        local runeTable = runeTable
        for i = 1, 6 do
            if runeTable[i].Type == Type and runeTable[i].Cooldown > runeCooldown then
                runePercent = runeTable[i].Percent
                runeCooldown = runeTable[i].Cooldown
            end
        end
        if getRunes(Type)==2 then
            return 2
        elseif getRunes(Type)==1 then
            return runePercent+1
        else
            return runePercent
        end
    end

    function useAoE()
        if (BadBoy_data['AoE'] == 1 and #getEnemies("player",8) >= 2) or BadBoy_data['AoE'] == 2 then
        -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
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

    function useDefile()
        if BadBoy_data['Defile']==1 then
            return true
        else
            return false
        end
    end

    SLASH_DEFILE1 = '/defile';
    function SlashCmdList.DEFILE(msg, editbox)
        RunMacroText('/run _G["buttonDefile"]:Click()');
    end


    function getDisease(range,aoe,mod)
        if mod == nil then mod = "min" end
        if range == nil then range = 5 end
        local range = tonumber(range)
        local mod = tostring(mod)
        if aoe == nil then aoe = false end
        local dynTar = dynamicTarget(range,true)
        local dynTarAoE = dynamicTarget(range,false)
        local dist = getDistance("player",dynTar)
        local distAoE = getDistance("player",dynTarAoE)
        local ff = getDebuffRemain(dynTar,_FrostFever,"player")
        local ffAoE = getDebuffRemain(dynTarAoE,_FrostFever,"player")
        local bp = getDebuffRemain(dynTar,_BloodPlague,"player")
        local bpAoE = getDebuffRemain(dynTarAoE,_BloodPlague,"player")
        local np = getDebuffRemain(dynTar,_NecroticPlague,"player")
        local npAoE = getDebuffRemain(dynTarAoE,_NecroticPlague,"player")
        if mod == "min" then
            if aoe == false then
                if dist < range then
                    if getTalent(7,1) then
                        return np
                    elseif ff <= bp then
                        return ff
                    else
                        return bp
                    end
                else
                    return 99
                end
            elseif aoe == true then
                if distAoE < range then
                    if getTalent(7,1) then
                        return npAoE
                    elseif ffAoE <= bpAoE then
                        return ffAoE
                    else
                        return bpAoE
                    end
                else
                    return 99
                end
            end
        elseif mod == "max" then
            if aoe == false then
                if dist < range then
                    if getTalent(7,1) then
                        return np
                    elseif ff <= bp then
                        return bp
                    else
                        return ff
                    end
                else
                    return 0
                end
            elseif aoe == true then
                if distAoE < range then
                    if getTalent(7,1) then
                        return npAoE
                    elseif ffAoE <= bpAoE then
                        return bpAoE
                    else
                        return ffAoE
                    end
                else
                    return 90
                end
            end
        end
    end









end
end