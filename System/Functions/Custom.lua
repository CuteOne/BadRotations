-- Functions from coders for public use
local sqrt, cos, sin = math.sqrt, math.cos, math.sin
--[[                                                                                                ]]
--[[ ragnar                                                                                         ]]
--[[                                                                                                ]]
function unitLookup(Unit,returnType)
    for k, v in pairs(br.enemy) do
        if br.enemy[k].guid == Unit or br.enemy[k].unit == Unit then
            if returnType == "guid" then
                return br.enemy[k].guid
            elseif returnType == "table" then
                return i
            else
                return br.enemy[k].unit
            end
        end
    end
end

function getUnitCount(ID,maxRange,tapped)
    local counter = 0
    for k, v in pairs(br.enemy) do
        local thisUnit = br.enemy[k].unit
        local thisUnitID = br.enemy[k].id
        if thisUnitID == ID then
            if getDistance(thisUnit) < maxRange then
                if (tapped == true and UnitIsTappedByPlayer(thisUnit)) or tapped == nil or tapped == false then
                    counter = counter + 1
                end
            end
        end
    end
    return counter
end

function isCCed(Unit)
    local CCTable = {84868, 3355, 19386, 118, 28272, 28271, 61305, 61721, 161372, 61780, 161355, 126819, 161354, 115078, 20066, 9484, 6770, 1776, 51514, 107079, 10326, 8122, 154359, 2094, 5246, 5782, 5484, 6358, 115268, 339};
    for i=1, #CCTable do
        if UnitDebuffID(Unit,CCTable[i]) then
            return true
        end
    end
    return false
end

--cast spell on position x,y,z
function castAtPosition(X,Y,Z, SpellID)
    local i = -100
    local mouselookActive = false
    if IsMouselooking() then
        mouselookActive = true
        MouselookStop()
    end
    CastSpellByName(GetSpellInfo(SpellID))
    while IsAoEPending() and i <= 100 do
        ClickPosition(X,Y,Z)
        Z = i
        i = i + 1
    end
    if mouselookActive then
        MouselookStart()
    end
    if i >= 100 and IsAoEPending() then return false end
    return true
end

--get number of units around 1 unit
function getUnits(thisUnit, allUnitsInRange, radius)
    local unitsAroundThisUnit = {}
    for j=1,#allUnitsInRange do
        local checkUnit = allUnitsInRange[j]
        if getDistance(thisUnit,checkUnit) < radius then
            table.insert(unitsAroundThisUnit,checkUnit)
        end
    end
    return #unitsAroundThisUnit
end

-- check if unit is blacklisted
function isNotBlacklisted(checkUnit)
    local blacklistUnitID = {}
    if checkUnit == nil then return false end
    for i = 1, #blacklistUnitID do
        if GetObjectID(checkUnit) == blacklistUnitID[i] then return false end
    end
    return true
end


function castGroundAtUnit(spellID, radius, minUnits, maxRange, minRange, spellType, unit)
    local spellName = GetSpellInfo(spellID)
    if radius == nil then radius = maxRange end
    if minRange == nil then minRange = 0 end
    local allUnitsInRange = {}
    if spellType == "heal" then allUnitsInRange = getAllies("player",40) else allUnitsInRange = getEnemies("player",maxRange,true) end

    if getUnits(unit,allUnitsInRange, radius - 3) >= minUnits and #getEnemies(unit,radius) >= #getEnemies(unit,radius,true) then
        local X1,Y1,Z1 = GetObjectPosition(unit)
        if castAtPosition(X1,Y1,Z1, spellID) then return true else return false end
    end


end

function castGroundAtBestLocation(spellID, radius, minUnits, maxRange, minRange, spellType, castTime)
    if radius == nil then radius = maxRange end
    if maxRange == nil then maxRange = radius end
    -- return table with combination of every 2 units
    local function getAllCombinationsOfASet(arr, r)
        if(r > #arr) then
            return {}
        end
        if(r == 0) then
            return {}
        end
        if(r == 1) then
            local return_table = {}
            for i=1,#arr do
                table.insert(return_table, {arr[i]})
            end
            return return_table
        else
            local return_table = {}
            local arr_new = {}
            for i=2,#arr do
                table.insert(arr_new, arr[i])
            end
            for i, val in pairs(getAllCombinationsOfASet(arr_new, r-1)) do
                local curr_result = {}
                table.insert(curr_result, arr[1]);
                for j,curr_val in pairs(val) do
                    table.insert(curr_result, curr_val)
                end
                table.insert(return_table, curr_result)
            end
            for i, val in pairs(getAllCombinationsOfASet(arr_new, r)) do
                table.insert(return_table, val)
            end
            return return_table
        end
    end

    --check if unit is inside of a circle
    local function unitInCircle(unit, cx, cy, radius, castTime)
        local uX, uY = 0, 0
        if castTime == nil or castTime == 0 then
          uX, uY = GetObjectPosition(unit)
        else
          uX, uY = GetFuturePostion(unit, castTime)
        end
        local rUnit = UnitBoundingRadius(unit)
        return math.abs((uX - cx) * (uX - cx) + (uY - cy) * (uY - cy)) <= (rUnit + radius) * (rUnit + radius);
    end

    --distance from center to unit
    local function unitDistanceCenter(unit, cx, cy, castTime)
        local uX, uY = 0, 0
        if castTime == nil or castTime == 0 then
            uX, uY = GetObjectPosition(unit)
        else
            uX, uY = GetFuturePostion(unit, castTime)
        end
        local rUnit = UnitBoundingRadius(unit)
        return sqrt(((uX-cx)^2) + ((uY-cy)^2))
    end

    if minRange == nil then minRange = 0 end
    local allUnitsInRange = {}
    if spellType == "heal" then allUnitsInRange = getAllies("player",maxRange) else allUnitsInRange = getEnemies("player",maxRange,false) end

    local testCircles = {}
    --for every combination of units make 2 circles, and put in testCircles
    if #allUnitsInRange >= 2 then
        local combs = getAllCombinationsOfASet(allUnitsInRange, 2)
        for i, val in pairs(combs) do
            local temp = {}
            for j, combination in pairs(val) do
                local tX, tY, tZ = 0,0,0
                if castTime == nil or castTime == 0 then
                  tX, tY, tZ = GetObjectPosition(combination)
                else
                  tX, tY, tZ = GetFuturePostion(combination, castTime)
                end
                if(j==#val) and temp.xi ~= nil then
                    temp.xii = tX;
                    temp.yii = tY;
                    temp.zii = tZ;
                    --distance
                    temp.q = sqrt((temp.xii-temp.xi)^2 + (temp.yii-temp.yi)^2)
                    --check to calculation. if result < 0 math.sqrt will give error
                    local calc = ((radius^2)-((temp.q/2)^2))
                    if calc <=0 then break end
                    --x3
                    temp.xiii = (temp.xi+temp.xii)/2
                    --y3
                    temp.yiii = (temp.yi+temp.yii)/2
                    --first circle
                    temp.xfc = temp.xiii + sqrt(calc)*((temp.yi-temp.yii)/temp.q)
                    temp.yfc = temp.yiii + sqrt(calc)*((temp.xii-temp.xi)/temp.q)
                    --second circle
                    temp.xsc = temp.xiii - sqrt(calc)*((temp.yi-temp.yii)/temp.q)
                    temp.ysc = temp.yiii - sqrt(calc)*((temp.xii-temp.xi)/temp.q)
                    --
                    temp.z = tZ
                    tinsert(testCircles, temp)
                else
                    temp.xi = tX;
                    temp.yi = tY;
                    temp.zi = tZ;
                end
            end
        end
    end

    local bestCircle = {}
    bestCircle.x = 0
    bestCircle.y = 0
    bestCircle.z = 0
    bestCircle.q = 0
    bestCircle.nro = 0
    --for every circle in testCircles, get units inside this circle, and return the circle with most units inside
    for i=1, #testCircles do
        local thisCircle = testCircles[i]
        local temp1 = 0
        local temp2 = 0
        local temp1Units = { }
        local temp2Units = { }
        for j=1, #allUnitsInRange do
            if spellType == "heal" then
                if unitInCircle(allUnitsInRange[j].unit,thisCircle.xfc,thisCircle.yfc, radius, castTime) then
                    temp1 = temp1 + 1
                    tinsert(temp1Units,allUnitsInRange[j])
                end
                if unitInCircle(allUnitsInRange[j].unit,thisCircle.xsc,thisCircle.ysc, radius, castTime) then
                    temp2 = temp2 + 1
                    tinsert(temp2Units,allUnitsInRange[j])
                end
            else
                if unitInCircle(allUnitsInRange[j],thisCircle.xfc,thisCircle.yfc, radius, castTime) then
                    temp1 = temp1 + 1
                    tinsert(temp1Units,allUnitsInRange[j])
                end
                if unitInCircle(allUnitsInRange[j],thisCircle.xsc,thisCircle.ysc, radius, castTime) then
                    temp2 = temp2 + 1
                    tinsert(temp2Units,allUnitsInRange[j])
                end
            end
        end
        if temp1 > temp2 and temp1 > bestCircle.nro then
            bestCircle.x = thisCircle.xfc
            bestCircle.y = thisCircle.yfc
            bestCircle.z = thisCircle.z
            bestCircle.nro = temp1
            bestCircle.units = {}
            for p = 1, #temp1Units do tinsert(bestCircle.units,temp1Units[p]) end
        elseif temp2 > temp1  and temp2 > bestCircle.nro then
            bestCircle.x = thisCircle.xsc
            bestCircle.y = thisCircle.ysc
            bestCircle.z = thisCircle.z
            bestCircle.nro = temp2
            bestCircle.units = {}
            for p = 1, #temp2Units do tinsert(bestCircle.units,temp2Units[p]) end
        elseif temp2 == temp1 and temp2 > bestCircle.nro then
            bestCircle.x = thisCircle.xsc
            bestCircle.y = thisCircle.ysc
            bestCircle.z = thisCircle.z
            bestCircle.nro = temp2
            bestCircle.units = {}
            for p = 1, #temp2Units do tinsert(bestCircle.units,temp2Units[p]) end
        end
    end
    --print(#bestCircle.units)

    -- check if units of the best circle is equal of circle of unit, if it is, then cast on this unit
    -- for i=1,#allUnitsInRange do
    --     local thisUnit = allUnitsInRange[i]
    --     nmro = getUnits(thisUnit,allUnitsInRange, radius - 3)
    --     if nmro >= bestCircle.nro and nmro >= minUnits then
    --         if castGround(thisUnit,spellID,maxRange,minRange,radius,castTime) then return true else return false end
    --     end
    -- end

    --check with minUnits
    if minUnits == 1 and bestCircle.nro == 0 and GetUnitExists("target") then
        if castGround("target",spellID,maxRange,minRange,radius,castTime) then return true else return false end
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
                    totalDistance = totalDistance + unitDistanceCenter(bestCircle.units[i], x, y, castTime)
                end
                if totalDistance < shortestDistance then
                    shortestDistance = totalDistance
                    newBestCircleX, newBestCircleY = x, y
                end
            end
        end
        bestCircle.x, bestCircle.y = (newBestCircleX + math.random() * 2), (newBestCircleY + math.random() * 2)
        if castAtPosition(bestCircle.x,bestCircle.y,bestCircle.z, spellID) then return true else return false end
    end
end


function isUnitThere(unitNameOrID,distance)
    -- description:
    -- check if Unit with ID or name is around

    -- return:
    -- true/nil

    -- example:
    -- isUnitThere("Shadowfel Warden")

    if type(unitNameOrID)=="number" then
        for k, v in pairs(br.enemy) do
            local thisUnit = br.enemy[k].unit
            if GetObjectID(thisUnit) then
                if distance==nil or getDistance("player",thisUnit) < distance then
                    return true
                end
            end
        end
    end
    if type(unitNameOrID)=="string" then
        for k, v in pairs(br.enemy) do
            local thisUnit = br.enemy[k].unit
            if UnitName(thisUnit)==unitNameOrID then
                if distance==nil or getDistance("player",thisUnit) < distance then
                    return true
                end
            end
        end
    end
end

function getTooltipSize(SpellID)
    -- description
    -- get the dmg or heal value from a tooltip

    -- return:
    -- number

    -- example:
    -- getTooltipSize(2061)

    _, _, n1, n2 = GetSpellDescription(SpellID):find("(%d+),(%d%d%d)")
    return tonumber(n1..n2)
end

function castBossButton(target)
    if target==nil then
        RunMacroText("/click ExtraActionButton1")
        return true
    else
        TargetUnit(target)
        RunMacroText("/click ExtraActionButton1")
        return true
    end
end

-- get threat situation on player and return the number
function getThreat()
    if UnitThreatSituation("player") ~= nil then
        return UnitThreatSituation("player")
    end
    -- 0 - Unit has less than 100% raw threat (default UI shows no indicator)
    -- 1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
    -- 2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
    -- 3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
    return 0
end

function RaidBuff(BuffSlot,myBuffSpellID)
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


    if GetNumGroupMembers()==0 then
        if not UnitIsDeadOrGhost("player") then
            if not GetRaidBuffTrayAuraInfo(id) then
                if castSpell("player",SpellID) then return true end
            end
        end
    else
        if UnitIsDeadOrGhost("player") then
            return false
        else
            for index=1,GetNumGroupMembers() do
                local name, _, subgroup, _, _, _, zone, online, isDead, _, _ = GetRaidRosterInfo(index)
                if online and not isDead and 1==IsSpellInRange(select(1,GetSpellInfo(SpellID)), "raid"..index) then
                    local playerBuffed=false
                    for auraIndex=1,#chosenTable do
                        if getBuffRemain("raid"..index,chosenTable[auraIndex])>0 then break end
                        if getBuffRemain("raid"..index,chosenTable[auraIndex])<=0 then
                            if castSpell("player",spellID,true,false) then return true end
                        end
                    end
                end
            end
        end
    end
end

function getUnitCluster(minUnits,maxRange,radius)
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

    for k, v in pairs(br.enemy) do
        local thisUnit = br.enemy[k].unit
        local thisEnemies = getNumEnemies(thisUnit,radius)
        if getLineOfSight(thisUnit) == true then
            if getDistance(thisUnit) < maxRange then
                if thisEnemies >= minUnits and thisEnemies > enemiesInRange then
                    theReturnUnit = thisUnit
                end
            end
        end
    end
    return select(1,theReturnUnit)
end

function getBiggestUnitCluster(maxRange,radius,minCount)
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
    local foundCluster = false

    for k, v in pairs(br.enemy) do
        local thisUnit = br.enemy[k].unit
        local thisRange = getDistance(thisUnit) or 99
        if getLineOfSight(thisUnit) == true then
            if thisRange < maxRange then
                local enemyCount = getNumEnemies(thisUnit,radius)
                if enemyCount >= enemiesInRange then
                    theReturnUnit = thisUnit
                    foundCluster = true
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

function SalvageHelper()
    -- Description:
    -- salvage your boxes from garrision mission
    -- only when in 'Salvage Yard'
    -- abort if empytSlots in inventory < 3
    -- salvageWaiting = wait x sec before starting again

    -- Returns:
    -- nothing

    if isChecked("Salvage") and GetMinimapZoneText() == "Salvage Yard" then

        local salvageWaiting = getValue("Salvage")

        if (salvageTimer == nil or (GetTime() - salvageTimer > salvageWaiting)) and not castingUnit() then
            local freeSlots = 0

            for i=1,5 do
                freeSlots = freeSlots + GetContainerNumFreeSlots(i-1)
            end

            if freeSlots > 3 then
                -- Bag of Salvaged Goods
                if GetItemCount(114116, false, false) > 0 then
                    UseItemByName(114116)
                    -- Crate of Salvage
                elseif GetItemCount(114119, false, false) > 0 then
                    UseItemByName(114119)
                    -- Big Crate of Salvage
                elseif GetItemCount(114120, false, false) > 0 then
                    UseItemByName(114120)
                end
            else
                salvageTimer = GetTime() -- if no more free slots, start timer
                -- TEMP ! Trys to sell to close merchant (needs addon which sells items when opening merchant window)
                CloseMerchant()
                for i=1,GetObjectCountBR() do
                    -- Locals
                    local thisObject = GetObjectWithIndex(i)
                    if ObjectIsUnit(thisObject) then
                        -- Locals
                        local guid = UnitGUID(thisObject)
                        local objectName = ObjectName(thisObject)
                        local objectType, _, _, _, _, objectID, _ = strsplit("-", guid)
                        objectID = tonumber(objectID)

                        if objectID == 77378 and GetDistanceBetweenObjects("player", thisObject) < 6 then
                            ObjectInteract(thisObject)
                            return
                        end
                    end
                end
                -- TEMP !
            end -- freeSlots
        end -- gettime()
    end -- isChecked()
end -- salvage()

-- Used to merge two tables
function mergeTables(a, b)
    if a == nil then a = {} end
    if type(a) == 'table' and type(b) == 'table' then
        for k,v in pairs(b) do
            if type(v)=='table' and type(a[k] or false)=='table' then
                mergeTables(a[k],v)
            else
                a[k]=v
            end
        end
    end
    return a
end

-- Used by new Class Framework to put all seperat Spell-Tables into new spell table
function mergeSpellTables(tSpell, tCharacter, tClass, tSpec)
    tSpell = mergeTables(tSpell, tCharacter)
    tSpell = mergeTables(tSpell, tClass)
    tSpell = mergeTables(tSpell, tSpec)
    return tSpell
end
function mergeIdTables(idTable)
    local class = select(2,UnitClass("player"))
    local spec = GetSpecializationInfo(GetSpecialization())
    if idTable ~= nil then idTable = {} end
    if br.lists.spells.Shared ~= nil then
        idTable = mergeTables(idTable, br.lists.spells.Shared)
    end
    if br.lists.spells[class] ~= nil then
        if br.lists.spells[class].Shared ~= nil then
            idTable = mergeTables(idTable, br.lists.spells[class].Shared)
            if br.lists.spells[class].Shared.abilities ~= nil then
                idTable = mergeTables(idTable, br.lists.spells[class].Shared.abilities)
            end
        end
        if br.lists.spells[class][spec] ~= nil then
            idTable = mergeTables(idTable, br.lists.spells[class][spec])
            if br.lists.spells[class][spec].abilities ~= nil then
                idTable = mergeTables(idTable, br.lists.spells[class][spec].abilities)
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
function inTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return key end
    end
    return false
end

--- Inserts table values into a table
--  No nested table (table in a table)
function insertTableIntoTable(originalTable, insertTable)
    for i = 1,#insertTable do
        table.insert(originalTable, insertTable[i])
    end
end

--- Returns if specified trinket is equipped in either slot
-- if isTrinketEquipped(124518) then trinket = "Libram of Vindication" end
function isTrinketEquipped(trinket)
    if (GetInventoryItemID("player", 13) == trinket or GetInventoryItemID("player", 14) == trinket) then
        return true
    else
        return false
    end
end

--- Return true if player has buff X
-- Parameter: ID
-- hasBuff(12345)
function hasBuff(spellID)
    local buffs, i = { }, 1
    local buff = UnitBuff("player", i)
    while buff do
        buffs[#buffs + 1] = buff
        i = i + 1
        buff = select(10,UnitBuff("player", i))
        if buff ~= nil then
            if buff == spellID then return true end
        end
    end
    return false
end

--- Cancel the giving BuffID
-- Parameter: ID
-- cancelBuff(12345)
function cancelBuff(spellID)
    local buffs, i = { }, 1
    local buff = UnitBuff("player", i)
    while buff do
        buffs[#buffs + 1] = buff
        i = i + 1
        buff = select(10,UnitBuff("player", i))
        if buff ~= nil then
            if buff == spellID then
                CancelUnitBuff("player", i)
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
    if DBM then
        if not br.DBM.Timer then
            br.DBM.Timer = {}
        else
            wipe(br.DBM.Timer)
        end

        for bar in pairs(DBM.Bars.bars) do
            local number = string.match(bar.id ,"%d+")
            table.insert(br.DBM.Timer, {id = bar.id,timer = bar.timer,spellid = number})
        end
    end
end

--- Usage:
-- 1 - br.DBM:getPulltimer() -> return (number) pulltimer count
-- 2 - br.DBM:getPulltimer(5) -> return (boolean) if pulltimer is below given time TRUE else FALSE
-- specificID can be set if Pulltimer is NOT "Pull in"
function br.DBM:getPulltimer(time, specificID)
    if br.DBM.Timer then
        if IsAddOnLoaded('DBM-Core') then
            local specificID = specificID or "Pull in"
            local hasPullTimer = false
            local isBelowTime = false
            local pullTimer = 0
            for i = 1, #br.DBM.Timer do
                -- Check if a Pulltimer is present
                --Print("get pull timer id="..br.DBM.Timer[i].id)
                --Print("time="..br.DBM.Timer[i].timer)

                --if br.DBM.Timer[i].id == specificID then
                is_find , _ = string.find(br.DBM.Timer[i].id , tostring(specificID))
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
        elseif IsAddOnLoaded("BigWigs") then
            local hasTimer = false
            local isBelowTime = false
            local currentTimer = 0
            local specificID = specificID or "Pull"
            for i = 1, #br.DBM.Timer do
                -- Check if timer with spell id is present
                if br.DBM.Timer[i] ~= nil and br.DBM.Timer[i].id == specificID then
                    hasTimer = true
                    currentTimer = br.DBM.Timer[i].exptime - GetTime()
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
-- function br.DBM:getPulltimer(time, specificID)
--     if br.DBM.Timer then
--         specificID = specificID or "Pull in"
--         local hasPulltimer = false
--         local isBelowTime = false
--         local pullTimer = 0
--         for i = 1, #br.DBM.Timer do
--             -- Check if a Pulltimer is present
--             --Print("get pull timer id="..br.DBM.Timer[i].id)
--             --Print("time="..br.DBM.Timer[i].timer)

--             --if br.DBM.Timer[i].id == specificID then
--             is_find , _ = string.find(br.DBM.Timer[i].id , tostring(specificID))
--             if is_find ~= nil then
--                 hasPulltimer = true
--                 pullTimer = br.DBM.Timer[i].timer

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
-- 1 - br.DBM:getTimer(spellID) -> return (number) the count of given spell ID timer
-- 2 - br.DBM:getTimer(spellID, time) -> return (boolean) TRUE if spellid is below given time else FALSE
    function br.DBM:getTimer(spellID, time)
        if br.DBM.Timer then
            if IsAddOnLoaded('DBM-Core') then
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
            elseif IsAddOnLoaded("BigWigs") then
                local hasTimer = false
                local isBelowTime = false
                local currentTimer = 0
                for i = 1, #br.DBM.Timer do
                    -- Check if timer with spell id is present
                    if br.DBM.Timer[i] ~= nil and br.DBM.Timer[i].id == spellID then
                        hasTimer = true
                        currentTimer = br.DBM.Timer[i].exptime - GetTime()
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
function GetFuturePostion(unit, castTime)
    local distance = GetUnitSpeed(unit) * castTime
    if distance > 0 then
        local x,y,z = GetObjectPosition(unit)
        local angle = ObjectFacing(unit)
        --If Unit have a target, let's make sure they don't collide
        local unitTarget = UnitTarget(unit)
        local unitTargetDist = 0
        if unitTarget ~= nil then
            local tX, tY, tZ = GetObjectPosition(unitTarget)
            --Lets get predicted position of unit target aswell
            if GetUnitSpeed(unitTarget) > 0 then
                local tDistance = GetUnitSpeed(unitTarget) * castTime
                local tAngle = ObjectFacing(unitTarget)
                tX = tX + cos(tAngle) * tDistance
                tY = tY + sin(tAngle) * tDistance
                unitTargetDist = sqrt(((tX-x)^2) + ((tY-y)^2) + ((tZ-z)^2)) - ((UnitCombatReach(unit) or 0) + (UnitCombatReach(unitTarget) or 0))
                if unitTargetDist < distance then distance = unitTargetDist end
            else
                unitTargetDist = getDistance(unitTarget, unit, "dist")
                if unitTargetDist < distance then distance = unitTargetDist end
            end
            -- calculate angle based on target position/future position
            angle = rad(atan2(tY - y, tX - x))
            if angle < 0 then
                angle = rad(360 + atan2(tY - y, tX - x))
            end
        end
        x = x + cos(angle) * distance
        y = y + sin(angle) * distance
        return x, y, z
    end
    return GetObjectPosition(unit)
end

function PullTimerRemain(returnBool)
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

function BWInit()
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
            local module, spellId, msg, duration, icon = ...
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
                    br.DBM.Timer[i].exptime = GetTime() + duration
                    break
                end
            end
            if not clone then
                local timer = {}
                timer.id = spellId
                timer.exptime = GetTime() + duration
                tinsert(br.DBM.Timer, timer)
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
            -- print("lalala")
        end
    end
    if BigWigsLoader then
        BigWigs.callback = {}
        BigWigsLoader.RegisterMessage(callback, "BigWigs_StartBar", BigWigs.BigwigsCallback);
        BigWigsLoader.RegisterMessage(callback, "BigWigs_StopBars", BigWigs.BigwigsCallback);
        BigWigsLoader.RegisterMessage(callback, "BigWigs_OnBossDisable", BigWigs.BigwigsCallback);
        BigWigsLoader.RegisterMessage(callback, "BigWigs_OnPluginDisable", BigWigs.BigwigsCallback);
    end
end

function BWCheck()
    if #br.DBM.Timer > 0 then
        for i = 1, #br.DBM.Timer do
            if br.DBM.Timer[i] ~= nil then
                if br.DBM.Timer[i].exptime < GetTime() then
                    br.DBM.Timer[i] = nil
                end
            else
            end
        end
    end
end
