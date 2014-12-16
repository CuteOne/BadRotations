if select(3, UnitClass("player")) == 11 then

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
function SwiftMender(lowestUnit,lowestHP)
    if isChecked("Swiftmend") and getSpellCD(18562) < 1 then
        if lowestHP <= getValue("Swiftmend") then
            if (getBuffRemain(lowestUnit,774,"player") > 1 or getBuffRemain(lowestUnit,8936,"player") > 1) then
                CastSpellByName(GetSpellInfo(18562),lowestUnit)
                return true
            end
        end
    end
end

function findShroom()
    if shroomsTable[1].x == nil then
        local myShroom = shroomsTable[1].guid
        for i = 1, ObjectCount() do
            if UnitExists(ObjectWithIndex(i)) == true then
                --print(UnitGUID(ObjectWithIndex(i)))
                if shroomsTable[1].guid == UnitGUID(ObjectWithIndex(i)) then
                    X, Y, Z = ObjectPosition(ObjectWithIndex(i))
                   -- print("lol")
                    shroomsTable[1] = { x = X, y = Y, z = Z, guid = myShroom }
                    return true
                end
            end
        end
    else
        return true
    end
    return false
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
	if Unit == nil then
        Unit = "player"
    end
	if UnitCastingInfo(Unit) ~= nil or UnitChannelInfo(Unit) ~= nil
	  or (GetSpellCooldown(61304) ~= nil and GetSpellCooldown(61304) > 0.001) then
	  	return true
    else
        return false
	end
end

function castMushFocus()
    if UnitExists("focus") and UnitAffectingCombat("focus") and UnitExists("focustarget")
      and UnitAffectingCombat("focus") and getDistance("focus","focustarget") < 5 then
        if castSpell("focus",145205,true,false) then
            return
        end
    end
end


end