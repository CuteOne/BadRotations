local _, br = ...
-- Functions from coders for public use
local sqrt, cos, sin = math.sqrt, math.cos, math.sin
--[[                                                                                                ]]
--[[ ragnar                                                                                         ]]
--[[                                                                                                ]]
function br.unitLookup(Unit,returnType)
    for k, _ in pairs(br.enemy) do
        if br.enemy[k].guid == Unit or br.enemy[k].unit == Unit then
            if returnType == "guid" then
                return br.enemy[k].guid
            elseif returnType == "table" then
                return br.enemy[k]
            else
                return br.enemy[k].unit
            end
        end
    end
end

function br.getUnitCount(ID, maxRange, tapped)
    local counter = 0
    for _, enemy in pairs(br.enemy) do
        local thisUnit = enemy.unit
        if enemy.id == ID and br.getDistance(thisUnit) < maxRange then
            local unitTapped = not br._G.UnitIsTapDenied(thisUnit)
            if (tapped == true and unitTapped) or not tapped then
                counter = counter + 1
            end
        end
    end
    return counter
end


function br.isCCed(Unit)
    local CCTable = {84868, 3355, 19386, 118, 28272, 28271, 61305, 61721, 161372, 61780, 161355, 126819, 161354, 115078,
        20066, 9484, 6770, 1776, 51514, 107079, 10326, 8122, 154359, 2094, 5246, 5782, 5484, 6358, 115268, 339};
    for i=1, #CCTable do
        if br.UnitDebuffID(Unit,CCTable[i]) then
            return true
        end
    end
    return false
end

--cast spell on position x,y,z
function br.castAtPosition(X,Y,Z, SpellID)
    local i = -100
    local mouselookActive = false
    if br._G.IsMouselooking() then
        mouselookActive = true
        br._G.MouselookStop()
    end
    br._G.CastSpellByName(br._G.GetSpellInfo(SpellID),"player")
    while br._G["IsAoEPending"]() and i <= 100 do
        br._G["ClickPosition"](X,Y,Z)
        br.castPosition.x = X
        br.castPosition.y = Y
        br.castPosition.z = Z
        Z = i
        i = i + 1
    end
    if mouselookActive then
        br._G.MouselookStart()
    end
    if i >= 100 and br._G["IsAoEPending"]() then return false end
    return true
end

--get number of units around 1 unit
function br.getUnits(thisUnit, allUnitsInRange, radius)
    local unitsAroundThisUnit = {}
    for j=1,#allUnitsInRange do
        local checkUnit = allUnitsInRange[j]
        if br.getDistance(thisUnit,checkUnit) < radius then
            table.insert(unitsAroundThisUnit,checkUnit)
        end
    end
    return #unitsAroundThisUnit
end

-- check if unit is blacklisted
function br.isNotBlacklisted(checkUnit)
    local blacklistUnitID = {}
    if checkUnit == nil then return false end
    for i = 1, #blacklistUnitID do
        if br.GetObjectID(checkUnit) == blacklistUnitID[i] then return false end
    end
    return true
end

function br.castGroundAtUnit(spellID, radius, minUnits, maxRange, minRange, spellType, unit)
    local _, _, _, _, spellMinRange, spellMaxRange = br._G.GetSpellInfo(spellID)
    minRange = minRange or spellMinRange or 0
    maxRange = maxRange or spellMaxRange or 5
    radius   = radius or maxRange

    local allUnitsInRange
    if spellType == "heal" then
        allUnitsInRange = br.getAllies("player",40)
    else
        allUnitsInRange = br.getEnemies("player",maxRange,true) - br.getEnemies("player",minRange,true)
    end

    local enemiesInRadius   = #br.getEnemies(unit,radius)
    local visibleEnemiesInRadius = #br.getEnemies(unit,radius,true)

    if br.getUnits(unit,allUnitsInRange, radius - 3) >= minUnits and enemiesInRadius >= visibleEnemiesInRadius then
        local X1,Y1,Z1 = br.GetObjectPosition(unit)
        return br.castAtPosition(X1,Y1,Z1, spellID)
    end
end

function br.castGroundAtBestLocation(spellID, radius, minUnits, maxRange, minRange, spellType, castTime)

    local _, _, _, _, spellMinRange, spellMaxRange = br._G.GetSpellInfo(spellID)
    minRange = minRange or spellMinRange or 0
    maxRange = maxRange or spellMaxRange or 5
    radius   = radius or maxRange
    -- return table with combinations of every r units from arr
    -- Return table with combinations of every r units
    local function getAllCombinationsOfASet(arr, r)
        if r <= 0 or r > #arr then
            return {}
        end

        local resultTable = {}
        local n = #arr

        local function generateCombinations(start, r, currentCombination)
            if r == 0 then
                table.insert(resultTable, currentCombination)
                return
            end

            for i = start, n do
                local newCombination = {}
                for _, v in ipairs(currentCombination) do
                    table.insert(newCombination, v)
                end
                table.insert(newCombination, arr[i])

                generateCombinations(i + 1, r - 1, newCombination)
            end
        end

        generateCombinations(1, r, {})

        return resultTable
    end




    --check if unit is inside of a circle
    local function unitInCircle(unit, cx, cy)
        local uX, uY
        if castTime == nil or castTime == 0 then
          uX, uY = br.GetObjectPosition(unit)
        else
          uX, uY = br.GetFuturePostion(unit, castTime)
        end
        local rUnit = br._G.UnitBoundingRadius(unit)
        local distanceSquared = (uX - cx)^2 + (uY - cy)^2
        local circleRadiusSquared = (rUnit + radius)^2

        return distanceSquared <= circleRadiusSquared
    end

    --distance from center to unit
    local function unitDistanceCenter(unit, cx, cy)
        local uX, uY
        if castTime == nil or castTime == 0 then
            uX, uY = br.GetObjectPosition(unit)
        else
            uX, uY = br.GetFuturePostion(unit, castTime)
        end
        -- local rUnit = br._G.UnitBoundingRadius(unit)
        return sqrt(((uX-cx)^2) + ((uY-cy)^2))
    end

    if minRange == nil then minRange = 0 end
    local allUnitsInRange
    if spellType == "heal" then
        allUnitsInRange = br.getAllies("player",maxRange)
    else
        allUnitsInRange = br.getEnemies("player",maxRange,false)
    end


    local testCircles = {}

    if #allUnitsInRange >= 2 then
        local combs = getAllCombinationsOfASet(allUnitsInRange, 2)

        for _, val in pairs(combs) do
            local temp = {}
            local t1, t2 = val[1], val[2]

            local tX1, tY1, tZ1 = br.GetFuturePosition(t1, castTime)
            local tX2, tY2, tZ2 = br.GetFuturePosition(t2, castTime)

            -- Calculate distance
            local q = math.sqrt((tX2 - tX1)^2 + (tY2 - tY1)^2)

            -- Check if calculation result is valid
            local calc = radius^2 - (q/2)^2

            if calc > 0 then
                -- Calculate circle centers
                local x3 = (tX1 + tX2) / 2
                local y3 = (tY1 + tY2) / 2
                local sqrt_calc = math.sqrt(calc)

                -- First circle center
                temp.xfc = x3 + sqrt_calc * ((tY1 - tY2) / q)
                temp.yfc = y3 + sqrt_calc * ((tX2 - tX1) / q)

                -- Second circle center
                temp.xsc = x3 - sqrt_calc * ((tY1 - tY2) / q)
                temp.ysc = y3 - sqrt_calc * ((tX2 - tX1) / q)

                temp.z = tZ2

                br._G.tinsert(testCircles, temp)
            end
        end
    end


    local bestCircle = {x = 0, y = 0, z = 0, q = 0, nro = 0}

    for i = 1, #testCircles do
        local thisCircle = testCircles[i]

        local distanceToFirst = br.getDistanceToLocation("player", thisCircle.xfc, thisCircle.yfc, thisCircle.z)
        local distanceToSecond = br.getDistanceToLocation("player", thisCircle.xsc, thisCircle.ysc, thisCircle.z)

        if distanceToFirst > minRange or distanceToSecond > minRange then
            local tempData = {
                {count = 0, units = {}, x = thisCircle.xfc, y = thisCircle.yfc},
                {count = 0, units = {}, x = thisCircle.xsc, y = thisCircle.ysc}
            }

            for j = 1, #allUnitsInRange do
                local unitSource = spellType == "heal" and allUnitsInRange[j].unit or allUnitsInRange[j]

                for _, temp in ipairs(tempData) do
                    if unitInCircle(unitSource, temp.x, temp.y) then
                        temp.count = temp.count + 1
                        br._G.tinsert(temp.units, allUnitsInRange[j])
                    end
                end
            end

            for _, temp in ipairs(tempData) do
                if temp.count > bestCircle.nro then
                    bestCircle.x, bestCircle.y, bestCircle.z = temp.x, temp.y, thisCircle.z
                    bestCircle.nro = temp.count
                    bestCircle.units = {}

                    for p = 1, #temp.units do
                        br._G.tinsert(bestCircle.units, temp.units[p])
                    end
                end
            end
        end
    end

    --check with minUnits
    if minUnits == 1 and bestCircle.nro == 0 and br.GetUnitExists("target") and br.getDistance("player","target") > minRange then
        if br.castGround("target",spellID,maxRange,minRange,radius,castTime) then return true else return false end
    end
    if bestCircle.nro < minUnits then return false end

    if bestCircle.x ~= 0 and bestCircle.y ~= 0 and bestCircle.z ~= 0 then
        --Calculate x/y position with shortest dist to units
        local shortestDistance = 999
        local newBestCircleX, newBestCircleY = 0,0
        for x = bestCircle.x - radius, bestCircle.x + radius do
            for y = bestCircle.y - radius, bestCircle.y + radius do
                local totalDistance = 0
                for i = 1, #bestCircle.units do
                    totalDistance = totalDistance + unitDistanceCenter(bestCircle.units[i], x, y)
                end
                if totalDistance < shortestDistance then
                    shortestDistance = totalDistance
                    newBestCircleX, newBestCircleY = x, y
                end
            end
        end
        bestCircle.x, bestCircle.y = (newBestCircleX + math.random() * 2), (newBestCircleY + math.random() * 2)
        if br.castAtPosition(bestCircle.x,bestCircle.y,bestCircle.z, spellID) then return true else return false end
    end
end


function br.isUnitThere(unitNameOrID,distance)
    -- description:
    -- check if Unit with ID or name is around

    -- return:
    -- true/nil

    -- example:
    -- isUnitThere("Shadowfel Warden")

    if type(unitNameOrID)=="number" then
        for k, _ in pairs(br.enemy) do
            local thisUnit = br.enemy[k].unit
            if br.GetObjectID(thisUnit) then
                if distance==nil or br.getDistance("player",thisUnit) < distance then
                    return true
                end
            end
        end
    end
    if type(unitNameOrID)=="string" then
        for k, _ in pairs(br.enemy) do
            local thisUnit = br.enemy[k].unit
            if br._G.UnitName(thisUnit)==unitNameOrID then
                if distance==nil or br.getDistance("player",thisUnit) < distance then
                    return true
                end
            end
        end
    end
end

function br.getTooltipSize(SpellID)
    -- description
    -- get the dmg or heal value from a tooltip

    -- return:
    -- number

    -- example:
    -- getTooltipSize(2061)

    local _, _, n1, n2 = br._G.GetSpellDescription(SpellID):find("(%d+),(%d%d%d)")
    return tonumber(n1..n2)
end

function br.castBossButton(target)
    if target==nil then
        br._G.RunMacroText("/click ExtraActionButton1")
        return true
    else
        br._G.TargetUnit(target)
        br._G.RunMacroText("/click ExtraActionButton1")
        return true
    end
end

-- get threat situation on player and return the number
function br.getThreat()
    if br._G.UnitThreatSituation("player") ~= nil then
        return br._G.UnitThreatSituation("player")
    end
    -- 0 - Unit has less than 100% raw threat (default UI shows no indicator)
    -- 1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
    -- 2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
    -- 3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
    return 0
end

function br.RaidBuff(BuffSlot,myBuffSpellID)
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

    if BuffSlot==nil or myBuffSpellID==nil then return false end

    local id = BuffSlot
    local SpellID = myBuffSpellID
    local bufftable = {
        stats = {1126,115921,116781,20217,160206,159988,160017,90363,160077},
        stamina = {21562,166928,469,160199,50256,160003,90364},
        attackPower = {57330,19506,6673},
        spellPower = {1459,61316,109773,160205,128433,90364,126309},
        mastery = {155522,24907,19740,116956,160198,93435,160039,128997,160073},
        haste = {55610,49868,113742,116956,160203,128432,160003,135670,160074},
        crit = {17007,1459,61316,116781,160200,90309,126373,160052,90363,126309,24604},
        multistrike = {166916,49868,113742,109773,172968,50519,57386,58604,54889,24844},
        versatility = {55610,1126,167187,167188,172967,159735,35290,57386,160045,50518,173035,160007}
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


    if br._G.GetNumGroupMembers()==0 then
        if not br._G.UnitIsDeadOrGhost("player") then
            if not br._G.GetRaidBuffTrayAuraInfo(id) then
                if br.castSpell("player",SpellID) then return true end
            end
        end
    else
        if br._G.UnitIsDeadOrGhost("player") then
            return false
        else
            for index=1,br._G.GetNumGroupMembers() do
                local _, _, _, _, _, _, _, online, isDead, _, _ = br._G.GetRaidRosterInfo(index)
                if online and not isDead and 1==br._G.IsSpellInRange(select(1,br._G.GetSpellInfo(SpellID)), "raid"..index) then
                    -- local playerBuffed=false
                    for auraIndex=1,#chosenTable do
                        if br.getBuffRemain("raid"..index,chosenTable[auraIndex])>0 then break end
                        if br.getBuffRemain("raid"..index,chosenTable[auraIndex])<=0 then
                            if br.castSpell("player",SpellID,true,false) then return true end
                        end
                    end
                end
            end
        end
    end
end

function br.getUnitCluster(minUnits,maxRange,radius)
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

    for k, _ in pairs(br.enemy) do
        local thisUnit = br.enemy[k].unit
        local thisEnemies = br.getNumEnemies(thisUnit,radius)
        if br.getLineOfSight(thisUnit) == true then
            if br.getDistance(thisUnit) < maxRange then
                if thisEnemies >= minUnits and thisEnemies > enemiesInRange then
                    theReturnUnit = thisUnit
                end
            end
        end
    end
    return select(1,theReturnUnit)
end

function br.getBiggestUnitCluster(maxRange,radius,minCount)
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

    for k, _ in pairs(br.enemy) do
        local thisUnit = br.enemy[k].unit
        local thisRange = br.getDistance(thisUnit) or 99
        if br.getLineOfSight(thisUnit) == true then
            if thisRange < maxRange then
                local enemyCount = br.getNumEnemies(thisUnit,radius)
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
function br.mergeTables(a, b)
    if a == nil then a = {} end
    if type(a) == 'table' and type(b) == 'table' then
        for k,v in pairs(b) do
            if type(v)=='table' and type(a[k] or false)=='table' then
                br.mergeTables(a[k],v)
            else
                a[k]=v
            end
        end
    end
    return a
end

-- Used by new Class Framework to put all seperat Spell-Tables into new spell table
function br.mergeSpellTables(tSpell, tCharacter, tClass, tSpec)
    tSpell = br.mergeTables(tSpell, tCharacter)
    tSpell = br.mergeTables(tSpell, tClass)
    tSpell = br.mergeTables(tSpell, tSpec)
    return tSpell
end
function br.mergeIdTables(idTable)
    local class = select(2,br._G.UnitClass("player"))
    local spec = br._G.GetSpecializationInfo(br._G.GetSpecialization())
    if idTable ~= nil then idTable = {} end
    if br.lists.spells.Shared ~= nil then
        idTable = br.mergeTables(idTable, br.lists.spells.Shared)
    end
    if br.lists.spells[class] ~= nil then
        if br.lists.spells[class].Shared ~= nil then
            idTable = br.mergeTables(idTable, br.lists.spells[class].Shared)
            if br.lists.spells[class].Shared.abilities ~= nil then
                idTable = br.mergeTables(idTable, br.lists.spells[class].Shared.abilities)
            end
        end
        if br.lists.spells[class][spec] ~= nil then
            idTable = br.mergeTables(idTable, br.lists.spells[class][spec])
            if br.lists.spells[class][spec].abilities ~= nil then
                idTable = br.mergeTables(idTable, br.lists.spells[class][spec].abilities)
            end
        end
    end
    return idTable
end

--- Checks if a table contains given value
-- local myTable = {"hello", "world"}
-- inTable(myTable, "hello") == true
-- inTable(myTable, "WHAT?") == false
-- check if tContains() does the same wow api
function br.inTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return key end
    end
    return false
end

--- Inserts table values into a table
--  No nested table (table in a table)
function br.insertTableIntoTable(originalTable, insertTable)
    for i = 1,#insertTable do
        table.insert(originalTable, insertTable[i])
    end
end

--- Returns if specified trinket is equipped in either slot
-- if isTrinketEquipped(124518) then trinket = "Libram of Vindication" end
function br.isTrinketEquipped(trinket)
    if (br._G.GetInventoryItemID("player", 13) == trinket or br._G.GetInventoryItemID("player", 14) == trinket) then
        return true
    else
        return false
    end
end

--- Return true if player has buff X
-- Parameter: ID
-- hasBuff(12345)
function br.hasBuff(spellID)
    local buffs, i = { }, 1
    local buff = br._G.UnitBuff("player", i)
    while buff do
        buffs[#buffs + 1] = buff
        i = i + 1
        buff = select(10,br._G.UnitBuff("player", i))
        if buff ~= nil then
            if buff == spellID then return true end
        end
    end
    return false
end

--- Cancel the giving BuffID
-- Parameter: ID
-- cancelBuff(12345)
function br.cancelBuff(spellID)
    local buffs, i = { }, 1
    local buff = br._G.UnitBuff("player", i)
    while buff do
        buffs[#buffs + 1] = buff
        i = i + 1
        buff = select(10,br._G.UnitBuff("player", i))
        if buff ~= nil then
            if buff == spellID then
                br._G.CancelUnitBuff("player", i,"")
                return true
            end
        end
    end
    return false
end

--[[ DBM Timer ]]--

br.DBM = {}

--- Return: All current DBM Timer
function br.DBM:getBars()
    if br._G.DBM then
        if not br.DBM.Timer then
            br.DBM.Timer = {}
        else
            br._G.wipe(br.DBM.Timer)
        end
        if br._G.DBM.Bars ~= nil then
            for bar in pairs(br._G.DBM.Bars.bars) do
                local number = string.match(bar.id ,"%d+")
                table.insert(br.DBM.Timer, {id = bar.id,timer = bar.timer,spellid = number})
            end
        end
    end
end

--- Usage:
-- 1 - br.DBM:getPulltimer() -> return (number) pulltimer count
-- 2 - br.DBM:getPulltimer(5) -> return (boolean) if pulltimer is below given time TRUE else FALSE
-- specificID can be set if Pulltimer is NOT "Pull in"
function br.DBM:getPulltimer(time, specificID)
    if br.DBM.Timer then
        if br._G.C_AddOns.IsAddOnLoaded('DBM-Core') then
            local specificID = specificID or "Pull in"
            local hasPullTimer = false
            local isBelowTime = false
            local pullTimer = 0
            for i = 1, #br.DBM.Timer do
                -- Check if a Pulltimer is present
                --Print("get pull timer id="..br.DBM.Timer[i].id)
                --Print("time="..br.DBM.Timer[i].timer)

                --if br.DBM.Timer[i].id == specificID then
                local is_find , _ = string.find(br.DBM.Timer[i].id , tostring(specificID))
                if is_find ~= nil then
                    hasPullTimer = true
                    pullTimer = br.DBM.Timer[i].timer
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
            for i = 1, #br.DBM.Timer do
                -- Check if timer with spell id is present
                if br.DBM.Timer[i] ~= nil and br.DBM.Timer[i].id == specificID then
                    hasTimer = true
                    currentTimer = br.DBM.Timer[i].exptime - br._G.GetTime()
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

--- Usage:
-- 1 - br.DBM:getTimer(spellID) -> return (number) the count of given spell ID timer
-- 2 - br.DBM:getTimer(spellID, time) -> return (boolean) TRUE if spellid is below given time else FALSE
    function br.DBM:getTimer(spellID, time)
        if br.DBM.Timer then
            if br._G.C_AddOns.IsAddOnLoaded('DBM-Core') then
                local hasTimer = false
                local isBelowTime = false
                local currentTimer = 0
                for i = 1, #br.DBM.Timer do
                    -- Check if timer with spell id is present
                    if tonumber(br.DBM.Timer[i].spellid) == spellID then
                        hasTimer = true
                        currentTimer = br.DBM.Timer[i].timer
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
                for i = 1, #br.DBM.Timer do
                    -- Check if timer with spell id is present
                    if br.DBM.Timer[i] ~= nil and br.DBM.Timer[i].id == spellID then
                        hasTimer = true
                        currentTimer = br.DBM.Timer[i].exptime - br._G.GetTime()
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
function br.GetFuturePosition(unit, castTime)
    local function getUnitPosition(target)
        return br.GetObjectPosition(target)
    end

    local function getUnitSpeed(target)
        return br._G.GetUnitSpeed(target)
    end

    local function calculateNewPosition(x, y, angle, distance)
        local newX = x + cos(angle) * distance
        local newY = y + sin(angle) * distance
        return newX, newY
    end

    local function calculateAngle(x1, y1, x2, y2)
        return br._G.rad(br._G.atan2(y2 - y1, x2 - x1))
    end

    local distance = getUnitSpeed(unit) * castTime
    if distance > 0 then
        local x, y, z = getUnitPosition(unit)
        local angle = br.GetObjectFacing(unit)

        local unitTarget = br._G.UnitTarget(unit)
        if unitTarget then
            local tX, tY, tZ = getUnitPosition(unitTarget)
            local unitTargetSpeed = getUnitSpeed(unitTarget)

            if unitTargetSpeed > 0 then
                local tDistance = unitTargetSpeed * castTime
                local tAngle = br.GetObjectFacing(unitTarget)

                tX, tY = calculateNewPosition(tX, tY, tAngle, tDistance)

                local unitTargetDist = br.getDistance(unitTarget, unit, "dist") - ((br._G.UnitCombatReach(unit) or 0) + (br._G.UnitCombatReach(unitTarget) or 0))
                if unitTargetDist < distance then
                    distance = unitTargetDist
                end

                angle = calculateAngle(x, y, tX, tY)
            end
        end

        x, y = calculateNewPosition(x, y, angle, distance)

        return x, y, z
    end

    return br.GetObjectPosition(unit)
end


function br.PullTimerRemain(returnBool)
    if returnBool == nil then returnBool = false end
    if br.DBM:getPulltimer() == 999 then
        if returnBool == false then
            return 999
        else
            return false
        end
    else
        if returnBool == false then
            return br.DBM:getPulltimer()
        else
            return true
        end
    end
end

function br.BWInit()
    if not br.DBM.Timer then
        br.DBM.Timer = {}
    end
    if br.DBM.BigWigs ~= nil then return end
    br.DBM.BigWigs = {}
    local BigWigs = br.DBM.BigWigs
    BigWigs.callback = {}
    local callback = BigWigs.callback
    BigWigs.BigwigsCallback = function(event, ...)
        if event == "BigWigs_StartBar" then
            local _, spellId, _, duration, icon = ...
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
            for i = 1, #br.DBM.Timer do
                if br.DBM.Timer[i] ~= nil and br.DBM.Timer[i].id == spellId then
                    clone = true
                    br.DBM.Timer[i].exptime = br._G.GetTime() + duration
                    break
                end
            end
            if not clone then
                local timer = {}
                timer.id = spellId
                timer.exptime = br._G.GetTime() + duration
                br._G.tinsert(br.DBM.Timer, timer)
                clone = false
            end
        elseif (event == "BigWigs_StopBars"
            or event == "BigWigs_OnBossDisable"
        or event == "BigWigs_OnPluginDisable") then
            if #br.DBM.Timer > 0 then
                local count = #br.DBM.Timer
                for i = 0, count do
                   br.DBM.Timer[i] = nil
                end
            end
        else
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

function br.BWCheck()
    if #br.DBM.Timer > 0 then
        for i = 1, #br.DBM.Timer do
            if br.DBM.Timer[i] ~= nil then
                if br.DBM.Timer[i].exptime < br._G.GetTime() then
                    br.DBM.Timer[i] = nil
                end
            else
            end
        end
    end
end

-- Check Instance IDs from https://wow.gamepedia.com/InstanceID
function br.getCurrentZoneId()
    return select(8, br._G.GetInstanceInfo())
end

