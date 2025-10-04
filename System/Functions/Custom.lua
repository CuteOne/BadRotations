local _, br = ...
br.functions.custom = br.functions.custom or {}
local custom = br.functions.custom

-- Functions from coders for public use
local sqrt, cos, sin = math.sqrt, math.cos, math.sin
--[[                                                                                                ]]
--[[ ragnar                                                                                         ]]
--[[                                                                                                ]]
function custom:unitLookup(Unit, returnType)
    for k, _ in pairs(br.engines.enemiesEngine.enemy) do
        local enemy = br.engines.enemiesEngine.enemy[k]
        if enemy.guid == Unit or enemy.unit == Unit then
            if returnType == "guid" then
                return enemy.guid
            elseif returnType == "table" then
                return enemy
            else
                return enemy.unit
            end
        end
    end
end

function custom:getUnitCount(ID, maxRange, tapped)
    local counter = 0
    for _, enemy in pairs(br.engines.enemiesEngine.enemy) do
        local thisUnit = enemy.unit
        if enemy.id == ID and br.functions.range:getDistance(thisUnit) < maxRange then
            local unitTapped = not br._G.UnitIsTapDenied(thisUnit)
            if (tapped == true and unitTapped) or not tapped then
                counter = counter + 1
            end
        end
    end
    return counter
end

function custom:isCCed(Unit)
    local CCTable = { 84868, 3355, 19386, 118, 28272, 28271, 61305, 61721, 161372, 61780, 161355, 126819, 161354, 115078,
        20066, 9484, 6770, 1776, 51514, 107079, 10326, 8122, 154359, 2094, 5246, 5782, 5484, 6358, 115268, 339 };
    for i = 1, #CCTable do
        if br.functions.aura:UnitDebuffID(Unit, CCTable[i]) then
            return true
        end
    end
    return false
end

--get number of units around 1 unit
function custom:getUnits(thisUnit, allUnitsInRange, radius)
    local unitsAroundThisUnit = {}
    for j = 1, #allUnitsInRange do
        local checkUnit = allUnitsInRange[j]
        if br.functions.range:getDistance(thisUnit, checkUnit) < radius then
            table.insert(unitsAroundThisUnit, checkUnit)
        end
    end
    return #unitsAroundThisUnit
end

-- check if unit is blacklisted
function custom:isNotBlacklisted(checkUnit)
    local blacklistUnitID = {}
    if checkUnit == nil then return false end
    for i = 1, #blacklistUnitID do
        if br.functions.unit:GetObjectID(checkUnit) == blacklistUnitID[i] then return false end
    end
    return true
end

function custom:castGroundAtUnit(spellID, radius, minUnits, maxRange, minRange, spellType, unit)
    local _, _, _, _, spellMinRange, spellMaxRange = br._G.GetSpellInfo(spellID)
    minRange                                       = minRange or spellMinRange or 0
    maxRange                                       = maxRange or spellMaxRange or 5
    radius                                         = radius or maxRange

    local allUnitsInRange
    if spellType == "heal" then
        allUnitsInRange = br.engines.healingEngineFunctions:getAllies("player", 40)
    else
        allUnitsInRange = {}
        local maxEnemies = br.engines.enemiesEngineFunctions:getEnemies("player", maxRange, true)
        local minEnemies = br.engines.enemiesEngineFunctions:getEnemies("player", minRange, true)
        for _, maxUnit in pairs(maxEnemies) do
            local minUnitInMaxEnemies = false
            for _, minUnit in pairs(minEnemies) do
                if minUnit == maxUnit then
                    minUnitInMaxEnemies = true
                    return
                end
            end
            if not minUnitInMaxEnemies then
                table.insert(allUnitsInRange, maxUnit)
            end
        end
    end

    local enemiesInRadius        = #br.engines.enemiesEngineFunctions:getEnemies(unit, radius)
    local visibleEnemiesInRadius = #br.engines.enemiesEngineFunctions:getEnemies(unit, radius, true)

    if br.functions.custom:getUnits(unit, allUnitsInRange, radius - 3) >= minUnits and enemiesInRadius >= visibleEnemiesInRadius then
        local X1, Y1, Z1 = br.functions.unit:GetObjectPosition(unit)
        return br.functions.cast:castAtPosition(X1, Y1, Z1, spellID)
    end
end

-- function custom:castGroundAtBestLocation(spellID, radius, minUnits, maxRange, minRange, spellType, castTime)
--     local _, _, _, _, spellMinRange, spellMaxRange = br._G.GetSpellInfo(spellID)
--     minRange = minRange or spellMinRange or 0
--     maxRange = maxRange or spellMaxRange or 5
--     radius   = radius or maxRange
--     -- return table with combination of every 2 units
--     local function getAllCombinationsOfASet(arr, r)
--         if(r > #arr) then
--             return {}
--         end
--         if(r == 0) then
--             return {}
--         end
--         if(r == 1) then
--             local return_table = {}
--             for i=1,#arr do
--                 table.insert(return_table, {arr[i]})
--             end
--             return return_table
--         else
--             local return_table = {}
--             local arr_new = {}
--             for i=2,#arr do
--                 table.insert(arr_new, arr[i])
--             end
--             for _, val in pairs(getAllCombinationsOfASet(arr_new, r-1)) do
--                 local curr_result = {}
--                 table.insert(curr_result, arr[1]);
--                 for _,curr_val in pairs(val) do
--                     table.insert(curr_result, curr_val)
--                 end
--                 table.insert(return_table, curr_result)
--             end
--             for _, val in pairs(getAllCombinationsOfASet(arr_new, r)) do
--                 table.insert(return_table, val)
--             end
--             return return_table
--         end
--     end

--     --check if unit is inside of a circle
--     local function unitInCircle(unit, cx, cy)
--         local uX, uY
--         if castTime == nil or castTime == 0 then
--           uX, uY = br.functions.unit:GetObjectPosition(unit)
--         else
--           uX, uY = br.functions.custom:(unit, castTime)
--         end
--         local rUnit = br._G["UnitBoundingRadius"](unit)
--         return math.abs((uX - cx) * (uX - cx) + (uY - cy) * (uY - cy)) <= (rUnit + radius) * (rUnit + radius);
--     end

--     --distance from center to unit
--     local function unitDistanceCenter(unit, cx, cy)
--         local uX, uY
--         if castTime == nil or castTime == 0 then
--             uX, uY = br.functions.unit:GetObjectPosition(unit)
--         else
--             uX, uY = br.functions.custom:(unit, castTime)
--         end
--         -- local rUnit = br._G.UnitBoundingRadius(unit)
--         return sqrt(((uX-cx)^2) + ((uY-cy)^2))
--     end

--     if minRange == nil then minRange = 0 end
--     local allUnitsInRange
--     if spellType == "heal" then
--         allUnitsInRange = br.engines.healingEngineFunctions:getAllies("player",maxRange)
--     else
--         allUnitsInRange = br.engines.enemiesEngineFunctions:getEnemies("player",maxRange,false)
--     end

--     local testCircles = {}
--     if #allUnitsInRange >= 2 then
--         local combs = getAllCombinationsOfASet(allUnitsInRange, 2)
--         for _, val in pairs(combs) do
--             local temp = {}
--             local tX1, tY1, tZ1 = (castTime == nil or castTime == 0) and br.functions.unit:GetObjectPosition(val[1]) or 0,0,0
--                 or br.functions.custom:(val[1], castTime)
--             local tX2, tY2, tZ2 = (castTime == nil or castTime == 0) and br.functions.unit:GetObjectPosition(val[2]) or 0,0,0
--                 or br.functions.custom:(val[2], castTime)

--             --distance
--             local q = sqrt((tX2-tX1)^2 + (tY2-tY1)^2)
--             --check to calculation. if result < 0 math.sqrt will give error
--             local calc = ((radius^2)-((q/2)^2))

--             if calc > 0 then
--                 --x3, y3
--                 local x3 = (tX1+tX2)/2
--                 local y3 = (tY1+tY2)/2
--                 local sqrt_calc = sqrt(calc)

--                 temp.xfc = x3 + sqrt_calc*((tY1-tY2)/q)
--                 temp.yfc = y3 + sqrt_calc*((tX2-tX1)/q)

--                 temp.xsc = x3 - sqrt_calc*((tY1-tY2)/q)
--                 temp.ysc = y3 - sqrt_calc*((tX2-tX1)/q)
--                 temp.z = tZ2

--                 br._G.tinsert(testCircles, temp)
--             end
--         end
--     end

--     local bestCircle = {x = 0, y = 0, z = 0, q = 0, nro = 0}
--     for i=1, #testCircles do
--         local thisCircle = testCircles[i]
--         if br.functions.range:getDistanceToLocation("player",thisCircle.xfc,thisCircle.yfc,thisCircle.z) > minRange
--             or br.functions.range:getDistanceToLocation("player",thisCircle.xsc,thisCircle.ysc,thisCircle.z) > minRange
--         then
--             local tempData = { {count=0, units={}, x=thisCircle.xfc, y=thisCircle.yfc},
--                             {count=0, units={}, x=thisCircle.xsc, y=thisCircle.ysc} }
--             for j=1, #allUnitsInRange do
--                 local unitSource = spellType == "heal" and allUnitsInRange[j].unit or allUnitsInRange[j]
--                 for _,temp in ipairs(tempData) do
--                     if unitInCircle(unitSource,temp.x,temp.y) then
--                         temp.count = temp.count + 1
--                         br._G.tinsert(temp.units, allUnitsInRange[j])
--                     end
--                 end
--             end
--             for _,temp in ipairs(tempData) do
--                 if temp.count > bestCircle.nro then
--                     bestCircle.x = temp.x
--                     bestCircle.y = temp.y
--                     bestCircle.z = thisCircle.z
--                     bestCircle.nro = temp.count
--                     bestCircle.units = {}

--                     for p = 1, #temp.units do br._G.tinsert(bestCircle.units,temp.units[p]) end
--                 end
--             end
--         end
--     end
--     --print(#bestCircle.units)

--     -- check if units of the best circle is equal of circle of unit, if it is, then cast on this unit
--     -- for i=1,#allUnitsInRange do
--     --     local thisUnit = allUnitsInRange[i]
--     --     nmro = getUnits(thisUnit,allUnitsInRange, radius - 3)
--     --     if nmro >= bestCircle.nro and nmro >= minUnits then
--     --         if castGround(thisUnit,spellID,maxRange,minRange,radius,castTime) then return true else return false end
--     --     end
--     -- end

--     --check with minUnits
--     if minUnits == 1 and bestCircle.nro == 0 and br.functions.unit:GetUnitExists("target") and br.functions.range:getDistance("player","target") > minRange then
--         if br.functions.cast:castGround("target",spellID,maxRange,minRange,radius,castTime) then return true else return false end
--     end
--     if bestCircle.nro < minUnits then return false end

--     if bestCircle.x ~= 0 and bestCircle.y ~= 0 and bestCircle.z ~= 0 then
--         --Calculate x/y position with shortest dist to units
--         local shortestDistance = 999
--         local newBestCircleX, newBestCircleY = 0,0
--         for x = bestCircle.x - radius, bestCircle.x + radius do
--             for y = bestCircle.y - radius, bestCircle.y + radius do
--                 local totalDistance = 0
--                 for i = 1, #bestCircle.units do
--                     totalDistance = totalDistance + unitDistanceCenter(bestCircle.units[i], x, y)
--                 end
--                 if totalDistance < shortestDistance then
--                     shortestDistance = totalDistance
--                     newBestCircleX, newBestCircleY = x, y
--                 end
--             end
--         end
--         bestCircle.x, bestCircle.y = (newBestCircleX + math.random() * 2), (newBestCircleY + math.random() * 2)
--         if br.functions.cast:castAtPosition(bestCircle.x,bestCircle.y,bestCircle.z, spellID) then return true else return false end
--     end
-- end

function custom:castGroundAtBestLocation(spellID, radius, minUnits, maxRange, minRange, spellType, castTime)
    local allUnitsInRange = (spellType == "heal") and br.engines.healingEngineFunctions:getAllies("player", maxRange) or
        br.engines.enemiesEngineFunctions:getEnemies("player", maxRange, false)

    local bestLocation = nil
    local maxHitCount = 0
    local playerX, playerY, playerZ = br.functions.unit:GetObjectPosition("player")

    local function GetUnitMovementDirectionAndSpeed(unit)
        -- Placeholder function: In practice, this would require complex calculations
        -- and might not be entirely accurate due to unpredictable player behavior.
        local direction = 0 -- Direction the unit is moving in radians
        local speed = 0     -- Speed of the unit

        -- You would need to calculate the actual direction and speed based on the unit's movement.
        -- World of Warcraft's API may not provide direct methods to get these values accurately.

        return direction, speed
    end

    local function GetFuturePosition(unit, castTime)
        -- Get the current position of the unit
        local currentX, currentY, currentZ = br.functions.unit:GetObjectPosition(unit)

        -- Estimate the unit's current movement direction and speed
        -- This is a simplified example. In practice, this can be quite complex.
        local direction, speed = GetUnitMovementDirectionAndSpeed(unit)

        -- Calculate the future position based on current position, direction, speed, and castTime
        local futureX = currentX + speed * castTime * math.cos(direction)
        local futureY = currentY + speed * castTime * math.sin(direction)
        local futureZ = currentZ -- Assuming no vertical movement for simplicity

        return futureX, futureY, futureZ
    end

    local function IsWithinRadiusFuture(center, target, radius, castTime)
        local futureCenterX, futureCenterY = GetFuturePosition(center, castTime)
        local futureTargetX, futureTargetY = GetFuturePosition(target, castTime)
        local dx, dy = futureCenterX - futureTargetX, futureCenterY - futureTargetY
        return (dx * dx + dy * dy) <= (radius * radius)
    end

    local function CalculateFutureClusterCenter(cluster, castTime)
        local sumX, sumY, sumZ = 0, 0, 0
        for _, unit in ipairs(cluster) do
            local x, y, z = GetFuturePosition(unit, castTime)
            sumX = sumX + x
            sumY = sumY + y
            sumZ = sumZ + z
        end
        return {
            x = sumX / #cluster,
            y = sumY / #cluster,
            z = sumZ / #cluster
        }
    end

    local function GetDistance(x1, y1, x2, y2)
        return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
    end

    for _, potentialCenter in ipairs(allUnitsInRange) do
        local hitCount = 0
        local cluster = {}

        for _, target in ipairs(allUnitsInRange) do
            if IsWithinRadiusFuture(potentialCenter, target, radius, castTime) then
                hitCount = hitCount + 1
                table.insert(cluster, target)
            end
        end

        local clusterCenter = CalculateFutureClusterCenter(cluster, castTime)
        local distanceFromPlayer = GetDistance(playerX, playerY, clusterCenter.x, clusterCenter.y)

        if hitCount >= minUnits and hitCount > maxHitCount and distanceFromPlayer >= minRange then
            bestLocation = clusterCenter
            maxHitCount = hitCount
        end
    end

    if bestLocation and maxHitCount >= minUnits then
        -- Cast the spell at the bestLocation
        return br.functions.cast:castAtPosition(bestLocation.x, bestLocation.y, bestLocation.z, spellID)
    end

    return false
end

function custom:isUnitThere(unitNameOrID, distance)
    -- description:
    -- check if Unit with ID or name is around

    -- return:
    -- true/nil

    -- example:
    -- isUnitThere("Shadowfel Warden")

    if type(unitNameOrID) == "number" then
        for k, _ in pairs(br.engines.enemiesEngine.enemy) do
            local thisUnit = br.engines.enemiesEngine.enemy[k].unit
            if br.functions.unit:GetObjectID(thisUnit) then
                if distance == nil or br.functions.range:getDistance("player", thisUnit) < distance then
                    return true
                end
            end
        end
    end
    if type(unitNameOrID) == "string" then
        for k, _ in pairs(br.engines.enemiesEngine.enemy) do
            local thisUnit = br.engines.enemiesEngine.enemy[k].unit
            if br._G.UnitName(thisUnit) == unitNameOrID then
                if distance == nil or br.functions.range:getDistance("player", thisUnit) < distance then
                    return true
                end
            end
        end
    end
end

function custom:getTooltipSize(SpellID)
    -- description
    -- get the dmg or heal value from a tooltip

    -- return:
    -- number

    -- example:
    -- getTooltipSize(2061)

    local _, _, n1, n2 = br._G.C_Spell.GetSpellDescription(SpellID):find("(%d+),(%d%d%d)")
    return tonumber(n1 .. n2)
end

function custom:castBossButton(target)
    if target == nil then
        br._G.RunMacroText("/click ExtraActionButton1")
        return true
    else
        br._G.TargetUnit(target)
        br._G.RunMacroText("/click ExtraActionButton1")
        return true
    end
end

-- get threat situation on player and return the number
function custom:getThreat()
    if br._G.UnitThreatSituation("player") ~= nil then
        return br._G.UnitThreatSituation("player")
    end
    -- 0 - Unit has less than 100% raw threat (default UI shows no indicator)
    -- 1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
    -- 2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
    -- 3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
    return 0
end

function custom:RaidBuff(BuffSlot, myBuffSpellID)
    -- description:
    -- check for raidbuff and cast if missing

    -- returns:
    -- true:    someone was without buff and spell casted
    -- false:   "BuffSlot" or "myBuffSpellID" is missing
    -- nil:     all raidmembers in range are buffed

    -- example:
    -- Check for Stamina as Priest:
    -- Buffslot Stamina: 2
    -- Power Word: Fortitude Spell ID: 21562
    -- RaidBuff(2,21562)
    -- Buffslots:
    -- 1 Stats
    -- 2 Stamina
    -- 3 Attack Power
    -- 4 Haste
    -- 5 Spell Power
    -- 6 Critical Strike
    -- 7 Mastery
    -- 8 Multistrike
    -- 9 Versatility

    if BuffSlot == nil or myBuffSpellID == nil then return false end

    local id = BuffSlot
    local SpellID = myBuffSpellID
    local bufftable = {
        stats = { 1126, 115921, 116781, 20217, 160206, 159988, 160017, 90363, 160077 },
        stamina = { 21562, 166928, 469, 160199, 50256, 160003, 90364 },
        attackPower = { 57330, 19506, 6673 },
        spellPower = { 1459, 61316, 109773, 160205, 128433, 90364, 126309 },
        mastery = { 155522, 24907, 19740, 116956, 160198, 93435, 160039, 128997, 160073 },
        haste = { 55610, 49868, 113742, 116956, 160203, 128432, 160003, 135670, 160074 },
        crit = { 17007, 1459, 61316, 116781, 160200, 90309, 126373, 160052, 90363, 126309, 24604 },
        multistrike = { 166916, 49868, 113742, 109773, 172968, 50519, 57386, 58604, 54889, 24844 },
        versatility = { 55610, 1126, 167187, 167188, 172967, 159735, 35290, 57386, 160045, 50518, 173035, 160007 }
    }
    local chosenTable
    if id == 1 then
        chosenTable = bufftable.stats
    elseif id == 2 then
        chosenTable = bufftable.stamina
    elseif id == 3 then
        chosenTable = bufftable.attackPower
    elseif id == 4 then
        chosenTable = bufftable.spellPower
    elseif id == 5 then
        chosenTable = bufftable.mastery
    elseif id == 6 then
        chosenTable = bufftable.haste
    elseif id == 7 then
        chosenTable = bufftable.crit
    elseif id == 8 then
        chosenTable = bufftable.multistrike
    elseif id == 9 then
        chosenTable = bufftable.versatility
    end


    if br._G.GetNumGroupMembers() == 0 then
        if not br._G.UnitIsDeadOrGhost("player") then
            if not br._G.GetRaidBuffTrayAuraInfo(id) then
                if br.functions.cast:castSpell("player", SpellID) then return true end
            end
        end
    else
        if br._G.UnitIsDeadOrGhost("player") then
            return false
        else
            for index = 1, br._G.GetNumGroupMembers() do
                local _, _, _, _, _, _, _, online, isDead, _, _ = br._G.GetRaidRosterInfo(index)
                if online and not isDead and 1 == br._G.C_Spell.IsSpellInRange(select(1, br._G.GetSpellInfo(SpellID)), "raid" .. index) then
                    -- local playerBuffed=false
                    for auraIndex = 1, #chosenTable do
                        if br.functions.aura:getBuffRemain("raid" .. index, chosenTable[auraIndex]) > 0 then break end
                        if br.functions.aura:getBuffRemain("raid" .. index, chosenTable[auraIndex]) <= 0 then
                            if br.functions.cast:castSpell("player", SpellID, true, false) then return true end
                        end
                    end
                end
            end
        end
    end
end

function custom:getUnitCluster(minUnits, maxRange, radius)
    -- Description:
    -- returns the enemy with minUnits around in maxRange

    -- rerturns:
    -- "0x0000000110E4F09C"

    -- how to use:
    -- castSpell(getUnitCluster(2,10),SpellID,...,...)
    -- use "getUnitCluster(minUnits,maxRange)" instead of "target"

    if type(minUnits) ~= "number" then return nil end
    if type(maxRange) ~= "number" then return nil end
    if type(radius) ~= "number" then return nil end

    local enemiesInRange = 0
    local theReturnUnit

    for k, _ in pairs(br.engines.enemiesEngine.enemy) do
        local thisUnit = br.engines.enemiesEngine.enemy[k].unit
        local thisEnemies = br.functions.combat:getNumEnemies(thisUnit, radius)
        if br.functions.misc:getLineOfSight(thisUnit) == true then
            if br.functions.range:getDistance(thisUnit) < maxRange then
                if thisEnemies >= minUnits and thisEnemies > enemiesInRange then
                    theReturnUnit = thisUnit
                end
            end
        end
    end
    return select(1, theReturnUnit)
end

function custom:getBiggestUnitCluster(maxRange, radius, minCount)
    -- Description:
    -- returns the enemy with most enemies in radius in maxRange from player

    -- rerturns:
    -- "0x0000000110E4F09C"

    -- how to use:
    -- castSpell(getBiggestUnitCluster(40,10),SpellID,...,...)
    -- use "getBiggestUnitCluster(maxRange,radius)" instead of "target"

    if type(maxRange) ~= "number" then return nil end
    if type(radius) ~= "number" then return nil end
    if type(minCount) ~= "number" then minCount = 0 end

    local enemiesInRange = minCount or 0
    local theReturnUnit
    -- local foundCluster = false

    for k, _ in pairs(br.engines.enemiesEngine.enemy) do
        local thisUnit = br.engines.enemiesEngine.enemy[k].unit
        local thisRange = br.functions.range:getDistance(thisUnit) or 99
        if br.functions.misc:getLineOfSight(thisUnit) == true then
            if thisRange < maxRange then
                local enemyCount = br.functions.combat:getNumEnemies(thisUnit, radius)
                if enemyCount >= enemiesInRange then
                    theReturnUnit = thisUnit
                    -- foundCluster = true
                    enemiesInRange = enemyCount
                end
            end
        end
    end
    return theReturnUnit
end

--[[                                                                                                ]]
--[[ Defmaster                                                                                      ]]
--[[                                                                                                ]]

-- Used to merge two tables
function custom:mergeTables(a, b)
    if a == nil then a = {} end
    if type(a) == 'table' and type(b) == 'table' then
        for k, v in pairs(b) do
            if type(v) == 'table' and type(a[k] or false) == 'table' then
                br.functions.custom:mergeTables(a[k], v)
            else
                a[k] = v
            end
        end
    end
    return a
end

-- Used by new Class Framework to put all seperat Spell-Tables into new spell table
function custom:mergeSpellTables(tSpell, tCharacter, tClass, tSpec)
    tSpell = br.functions.custom:mergeTables(tSpell, tCharacter)
    tSpell = br.functions.custom:mergeTables(tSpell, tClass)
    tSpell = br.functions.custom:mergeTables(tSpell, tSpec)
    return tSpell
end

function custom:mergeIdTables(idTable)
    local class = select(2, br._G.UnitClass("player"))
    local spec = br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
    if idTable ~= nil then idTable = {} end
    if br.lists.spells.Shared ~= nil then
        idTable = br.functions.custom:mergeTables(idTable, br.lists.spells.Shared)
    end
    if br.lists.spells[class] ~= nil then
        if br.lists.spells[class].Shared ~= nil then
            idTable = br.functions.custom:mergeTables(idTable, br.lists.spells[class].Shared)
            if br.lists.spells[class].Shared.abilities ~= nil then
                idTable = br.functions.custom:mergeTables(idTable, br.lists.spells[class].Shared.abilities)
            end
        end
        if br.lists.spells[class][spec] ~= nil then
            idTable = br.functions.custom:mergeTables(idTable, br.lists.spells[class][spec])
            if br.lists.spells[class][spec].abilities ~= nil then
                idTable = br.functions.custom:mergeTables(idTable, br.lists.spells[class][spec].abilities)
            end
        end
    end
    return idTable
end

-- takes a given time duration and returns a string representing the hours, minutes, and seconds
-- examply br.functions.custom:formattedTime(time,format))
-- format 1 = short time: HH:MM:SS
-- format 2 = long time:  2hrs 24m 15s
function custom:formattedTime(inTime, format)
    if format == nil then format = 1 end
    inTime = inTime / 1000
    local hours = math.floor(inTime / 3600)
    local remains = inTime % 3600
    local minutes = math.floor(remains / 60)
    remains = math.floor(remains % 60)
    return tostring(hours .. ":" .. minutes .. ":" .. remains)
end

--- Checks if a table contains given value
-- local myTable = {"hello", "world"}
-- inTable(myTable, "hello") == true
-- inTable(myTable, "WHAT?") == false
-- check if tContains() does the same wow api
function custom:inTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return key end
    end
    return false
end

--- Inserts table values into a table
--  No nested table (table in a table)
function custom:insertTableIntoTable(originalTable, insertTable)
    for i = 1, #insertTable do
        table.insert(originalTable, insertTable[i])
    end
end

--- Returns if specified trinket is equipped in either slot
-- if isTrinketEquipped(124518) then trinket = "Libram of Vindication" end
function custom:isTrinketEquipped(trinket)
    if (br._G.GetInventoryItemID("player", 13) == trinket or br._G.GetInventoryItemID("player", 14) == trinket) then
        return true
    else
        return false
    end
end

--- Return true if player has buff X
-- Parameter: ID
-- hasBuff(12345)
function custom:hasBuff(spellID)
    local buffs, i = {}, 1
    local buff = br.functions.aura:UnitBuff("player", i)
    while buff do
        buffs[#buffs + 1] = buff
        i = i + 1
        buff = select(10, br.functions.aura:UnitBuff("player", i))
        if buff ~= nil then
            if buff == spellID then return true end
        end
    end
    return false
end

--- Cancel the giving BuffID
-- Parameter: ID
-- cancelBuff(12345)
function custom:cancelBuff(spellID)
    local buffs, i = {}, 1
    local buff = br.functions.aura:UnitBuff("player", i)
    while buff do
        buffs[#buffs + 1] = buff
        i = i + 1
        buff = select(10, br.functions.aura:UnitBuff("player", i))
        if buff ~= nil then
            if buff == spellID then
                br._G.CancelUnitBuff("player", i, "")
                return true
            end
        end
    end
    return false
end

--[[ DBM Timer ]] --

br.functions.DBM = {}

--- Return: All current DBM Timer
function br.functions.DBM:getBars()
    if br._G.DBM then
        if not br.functions.DBM.Timer then
            br.functions.DBM.Timer = {}
        else
            br._G.wipe(br.functions.DBM.Timer)
        end
        if br._G.DBM.Bars ~= nil then
            for bar in pairs(br._G.DBM.Bars.bars) do
                local number = string.match(bar.id, "%d+")
                table.insert(br.functions.DBM.Timer, { id = bar.id, timer = bar.timer, spellid = number })
            end
        end
    end
end

--- Usage:
-- 1 - br.functions.DBM:getPulltimer() -> return (number) pulltimer count
-- 2 - br.functions.DBM:getPulltimer(5) -> return (boolean) if pulltimer is below given time TRUE else FALSE
-- specificID can be set if Pulltimer is NOT "Pull in"
function br.functions.DBM:getPulltimer(time, specificID)
    if br.functions.DBM.Timer then
        if br._G.C_AddOns.IsAddOnLoaded('DBM-Core') then
            local specificID = specificID or "Pull in"
            local hasPullTimer = false
            local isBelowTime = false
            local pullTimer = 0
            for i = 1, #br.functions.DBM.Timer do
                -- Check if a Pulltimer is present
                --Print("get pull timer id="..br.functions.DBM.Timer[i].id)
                --Print("time="..br.functions.DBM.Timer[i].timer)

                --if br.functions.DBM.Timer[i].id == specificID then
                local is_find, _ = string.find(br.functions.DBM.Timer[i].id, tostring(specificID))
                if is_find ~= nil then
                    hasPullTimer = true
                    pullTimer = br.functions.DBM.Timer[i].timer
                    -- if a time is given set var to true
                    if time then
                        if pullTimer <= time then
                            isBelowTime = true
                        end
                        if hasPullTimer and isBelowTime then
                            return true
                        else
                            return false
                        end
                    else
                        if hasPullTimer then
                            return pullTimer
                        end
                    end
                end
            end
        elseif br._G.C_AddOns.IsAddOnLoaded("BigWigs") then
            local hasTimer = false
            local isBelowTime = false
            local currentTimer = 0
            local specificID = specificID or "Pull"
            for i = 1, #br.functions.DBM.Timer do
                -- Check if timer with spell id is present
                if br.functions.DBM.Timer[i] ~= nil and br.functions.DBM.Timer[i].id == specificID then
                    hasTimer = true
                    currentTimer = br.functions.DBM.Timer[i].exptime - br._G.GetTime()
                    -- if a time is given set var to true
                    if time then
                        if currentTimer <= time then
                            isBelowTime = true
                        end
                        if hasTimer and isBelowTime then
                            return true
                        else
                            return false
                        end
                    else
                        if hasTimer then
                            return currentTimer
                        end
                    end
                end
            end
        end
    end
    -- if a time is given return true if timer and below given time
    -- else return time

    return 999 -- return number to avoid conflicts but to high so it should never trigger
end

-- function br.functions.DBM:getPulltimer(time, specificID)
--     if br.functions.DBM.Timer then
--         specificID = specificID or "Pull in"
--         local hasPulltimer = false
--         local isBelowTime = false
--         local pullTimer = 0
--         for i = 1, #br.functions.DBM.Timer do
--             -- Check if a Pulltimer is present
--             --Print("get pull timer id="..br.functions.DBM.Timer[i].id)
--             --Print("time="..br.functions.DBM.Timer[i].timer)

--             --if br.functions.DBM.Timer[i].id == specificID then
--             is_find , _ = string.find(br.functions.DBM.Timer[i].id , tostring(specificID))
--             if is_find ~= nil then
--                 hasPulltimer = true
--                 pullTimer = br.functions.DBM.Timer[i].timer

--                 -- if a time is given set var to true
--                 if time then
--                     if pullTimer <= time then
--                         isBelowTime = true
--                     end
--                 end
--             end
--         end

--         -- if a time is given return true if pulltimer and below given time
--         -- else return time
--         if time ~= nil then
--             if hasPulltimer and isBelowTime then
--                 return true
--             else
--                 return false
--             end
--         else
--             if hasPulltimer then
--                 return pullTimer
--             end
--         end
--     end
--     return 999 -- return number to avoid conflicts but to high so it should never trigger
-- end


--- Usage:
-- 1 - br.functions.DBM:getTimer(spellID) -> return (number) the count of given spell ID timer
-- 2 - br.functions.DBM:getTimer(spellID, time) -> return (boolean) TRUE if spellid is below given time else FALSE
function br.functions.DBM:getTimer(spellID, time)
    if br.functions.DBM.Timer then
        if br._G.C_AddOns.IsAddOnLoaded('DBM-Core') then
            local hasTimer = false
            local isBelowTime = false
            local currentTimer = 0
            for i = 1, #br.functions.DBM.Timer do
                -- Check if timer with spell id is present
                if tonumber(br.functions.DBM.Timer[i].spellid) == spellID then
                    hasTimer = true
                    currentTimer = br.functions.DBM.Timer[i].timer
                    -- if a time is given set var to true
                    if time then
                        if currentTimer <= time then
                            isBelowTime = true
                        end
                        if hasTimer and isBelowTime then
                            return true
                        else
                            return false
                        end
                    else
                        if hasTimer then
                            return currentTimer
                        end
                    end
                end
            end
        elseif br._G.C_AddOns.IsAddOnLoaded("BigWigs") then
            local hasTimer = false
            local isBelowTime = false
            local currentTimer = 0
            for i = 1, #br.functions.DBM.Timer do
                -- Check if timer with spell id is present
                if br.functions.DBM.Timer[i] ~= nil and br.functions.DBM.Timer[i].id == spellID then
                    hasTimer = true
                    currentTimer = br.functions.DBM.Timer[i].exptime - br._G.GetTime()
                    -- if a time is given set var to true
                    if time then
                        if currentTimer <= time then
                            isBelowTime = true
                        end
                        if hasTimer and isBelowTime then
                            return true
                        else
                            return false
                        end
                    else
                        if hasTimer then
                            return currentTimer
                        end
                    end
                end
            end
        end
    end
    -- if a time is given return true if timer and below given time
    -- else return time

    return 999 -- return number to avoid conflicts but to high so it should never trigger
end

-- Future position
function custom:GetFuturePostion(unit, castTime)
    local distance = br._G.GetUnitSpeed(unit) * castTime
    if distance > 0 then
        local x, y, z = br.functions.unit:GetObjectPosition(unit)
        local angle = br.functions.unit:GetObjectFacing(unit)
        --If Unit have a target, let's make sure they don't collide
        local unitTarget = br._G.UnitTarget(unit)
        local unitTargetDist = 0
        if unitTarget ~= nil then
            local tX, tY, tZ = br.functions.unit:GetObjectPosition(unitTarget)
            --Lets get predicted position of unit target aswell
            if br._G.GetUnitSpeed(unitTarget) > 0 then
                local tDistance = br._G.GetUnitSpeed(unitTarget) * castTime
                local tAngle = br.functions.unit:GetObjectFacing(unitTarget)
                tX = tX + cos(tAngle) * tDistance
                tY = tY + sin(tAngle) * tDistance
                unitTargetDist = sqrt(((tX - x) ^ 2) + ((tY - y) ^ 2) + ((tZ - z) ^ 2)) -
                    ((br._G.UnitCombatReach(unit) or 0) + (br._G.UnitCombatReach(unitTarget) or 0))
                if unitTargetDist < distance then distance = unitTargetDist end
            else
                unitTargetDist = br.functions.range:getDistance(unitTarget, unit, "dist")
                if unitTargetDist < distance then distance = unitTargetDist end
            end
            -- calculate angle based on target position/future position
            angle = br._G.rad(br._G.atan2(tY - y, tX - x))
            if angle < 0 then
                angle = br._G.rad(360 + br._G.atan2(tY - y, tX - x))
            end
        end
        x = x + cos(angle) * distance
        y = y + sin(angle) * distance
        return x, y, z
    end
    return br.functions.unit:GetObjectPosition(unit)
end

function custom:PullTimerRemain(returnBool)
    if returnBool == nil then returnBool = false end
    if br.functions.DBM:getPulltimer() == 999 then
        if returnBool == false then
            return 999
        else
            return false
        end
    else
        if returnBool == false then
            return br.functions.DBM:getPulltimer()
        else
            return true
        end
    end
end

function custom:BWInit()
    if not br.functions.DBM.Timer then
        br.functions.DBM.Timer = {}
    end
    if br.functions.DBM.BigWigs ~= nil then return end
    br.functions.DBM.BigWigs = {}
    local BigWigs = br.functions.DBM.BigWigs
    BigWigs.callback = {}
    local callback = BigWigs.callback
    BigWigs.BigwigsCallback = function(event, ...)
        if event == "BigWigs_StartBar" then
            local _, spellId, message, duration, icon = ...
            local clone = false
            if spellId == nil then
                if tostring(icon) == "134062" then
                    -- print("break")
                    spellId = "Break"
                elseif tostring(icon) == "132337" then
                    -- print("pull")
                    spellId = "Pull"
                else
                    return
                end
            end
            for i = 1, #br.functions.DBM.Timer do
                if br.functions.DBM.Timer[i] ~= nil and br.functions.DBM.Timer[i].id == spellId then
                    clone = true
                    br.functions.DBM.Timer[i].exptime = br._G.GetTime() + duration
                    break
                end
            end
            if not clone then
                local timer = {}
                timer.id = spellId
                timer.exptime = br._G.GetTime() + duration
                br._G.tinsert(br.functions.DBM.Timer, timer)
                clone = false
            end
        elseif (event == "BigWigs_StopBars"
                or event == "BigWigs_OnBossDisable"
                or event == "BigWigs_OnPluginDisable") then
            if #br.functions.DBM.Timer > 0 then
                local count = #br.functions.DBM.Timer
                for i = 0, count do
                    br.functions.DBM.Timer[i] = nil
                end
            end
        else
            -- print("lalala")
        end
    end
    if br._G.BigWigsLoader then
        BigWigs.callback = {}
        br._G.BigWigsLoader.RegisterMessage(callback, "BigWigs_StartBar", BigWigs.BigwigsCallback);
        br._G.BigWigsLoader.RegisterMessage(callback, "BigWigs_StopBars", BigWigs.BigwigsCallback);
        br._G.BigWigsLoader.RegisterMessage(callback, "BigWigs_OnBossDisable", BigWigs.BigwigsCallback);
        br._G.BigWigsLoader.RegisterMessage(callback, "BigWigs_OnPluginDisable", BigWigs.BigwigsCallback);
    end
end

function custom:BWCheck()
    if #br.functions.DBM.Timer > 0 then
        for i = 1, #br.functions.DBM.Timer do
            if br.functions.DBM.Timer[i] ~= nil then
                if br.functions.DBM.Timer[i].exptime < br._G.GetTime() then
                    br.functions.DBM.Timer[i] = nil
                end
            else
            end
        end
    end
end

-- Check Instance IDs from https://wow.gamepedia.com/InstanceID
function custom:getCurrentZoneId()
    return select(8, br._G.GetInstanceInfo())
end
