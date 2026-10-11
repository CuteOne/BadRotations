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
    local _, _, _, _, spellMinRange, spellMaxRange = br.api.wow.GetSpellInfo(spellID)
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
                    break
                end
            end
            if not minUnitInMaxEnemies then
                table.insert(allUnitsInRange, maxUnit)
            end
        end
    end

    local enemiesInRadius        = #br.engines.enemiesEngineFunctions:getEnemies(unit, radius)
    local visibleEnemiesInRadius = #br.engines.enemiesEngineFunctions:getEnemies(unit, radius, true)

    if br.functions.custom:getUnits(unit, allUnitsInRange, radius - 3) >= minUnits and enemiesInRadius >= visibleEnemiesInRadius
        and br.functions.cast:isUnitVisible(unit)
    then
        local X1, Y1, Z1 = br.functions.unit:GetObjectPosition(unit)
        return br.functions.cast:castAtPosition(X1, Y1, Z1, spellID)
    end
end

-- Ground AoE placement: where a circle of `radius` yards, centred within the spell's range, covers the
-- most units it should hit, and none it shouldn't.
--   * Units: enemies in combat (allies for a helpful spell) out to range + radius, since a circle at the
--     edge of the range reaches that far.
--   * Spots tried: every unit's position, and for each pair of units the two centres that put both on
--     the circle's edge (the best circle always has one of these) plus the pair's midpoint; spots past
--     the range are pulled in to its edge, spots inside a minimum range pushed out to it.
--   * A spot is refused when its circle reaches a unit the AoE safety check wouldn't hit ("Safe Damage
--     Check": enemies not in combat, neutral or crowd-controlled ones).
--   * Only units at about the same height count, so a pack on the floor below isn't "covered".
--   * The best spots are traced for line of sight in order; the first visible one is used. Spots close
--     to one already found hidden are skipped, so the traces look at different places.
-- Returns x, y, z and the number of units covered, or nil when no spot covers minUnits.
-- local x, y, z, count = br.functions.custom:findGroundLocation(br.player.spells.hurricane, 8, 3)
local GROUND_HEIGHT_TOLERANCE = 6 -- yards up or down a unit can be from the spot and still count
local GROUND_MAX_UNITS = 30       -- nearest units considered (the search grows with the cube of this)
local GROUND_MAX_TRACES = 8       -- line-of-sight traces per search
local GROUND_HIDDEN_AREA = 3      -- yards around a hidden spot that aren't traced again
local groundSearchCache = {}      -- [key] = { at = frame time, x, y, z, count }: once per frame per spell

local function unitPoints(list, isAlly)
    local points = {}
    for i = 1, #list do
        local thisUnit = isAlly and list[i].unit or list[i]
        local x, y, z = br.functions.unit:GetObjectPosition(thisUnit)
        if x and y and z then points[#points + 1] = { unit = thisUnit, x = x, y = y, z = z } end
    end
    return points
end

function custom:findGroundLocation(spellID, radius, minUnits, maxRange, minRange, helpful)
    local _, _, _, _, spellMinRange, spellMaxRange = br.api.wow.GetSpellInfo(spellID)
    minRange = minRange or spellMinRange or 0
    maxRange = maxRange or spellMaxRange or 5
    radius = radius or maxRange
    minUnits = minUnits or 1
    local now = br._G.GetTime()
    local key = tostring(spellID) .. ":" .. radius .. ":" .. minUnits .. ":" .. maxRange .. ":" .. tostring(helpful)
    local cached = groundSearchCache[key]
    if cached and cached.at == now then
        if cached.count == nil then return nil end
        return cached.x, cached.y, cached.z, cached.count
    end
    local result = { at = now }
    groundSearchCache[key] = result

    local px, py = br.functions.unit:GetObjectPosition("player")
    if not px then return nil end
    local reach = maxRange + radius

    -- Units to cover, and units the circle mustn't reach
    local points, avoid = {}, {}
    if helpful then
        points = unitPoints(br.engines.healingEngineFunctions:getAllies("player", reach), true)
    else
        local valid = br.engines.enemiesEngineFunctions:getEnemies("player", reach)
        points = unitPoints(valid, false)
        if br.functions.misc:isChecked("Safe Damage Check") then
            local isValid = {}
            for i = 1, #valid do isValid[valid[i]] = true end
            local all = br.engines.enemiesEngineFunctions:getEnemies("player", reach, true)
            local others = {}
            for i = 1, #all do if not isValid[all[i]] then others[#others + 1] = all[i] end end
            avoid = unitPoints(others, false)
        end
    end
    if #points == 0 then return nil end
    if #points > GROUND_MAX_UNITS then
        table.sort(points, function(a, b)
            return (a.x - px) ^ 2 + (a.y - py) ^ 2 < (b.x - px) ^ 2 + (b.y - py) ^ 2
        end)
        for i = #points, GROUND_MAX_UNITS + 1, -1 do points[i] = nil end
    end

    local r2 = radius * radius
    local function covers(cx, cy, cz, p)
        local dx, dy = p.x - cx, p.y - cy
        return dx * dx + dy * dy <= r2 and math.abs(p.z - cz) <= GROUND_HEIGHT_TOLERANCE
    end
    -- Keep a spot inside the castable ring: pulled in from past the range, out from inside the minimum
    local function intoRange(cx, cy, cz)
        local dx, dy = cx - px, cy - py
        local d = math.sqrt(dx * dx + dy * dy)
        if d > maxRange then
            return px + dx / d * maxRange, py + dy / d * maxRange, cz
        elseif d < minRange then
            if d == 0 then return nil end
            return px + dx / d * minRange, py + dy / d * minRange, cz
        end
        return cx, cy, cz
    end

    -- Score every candidate spot
    local scored = {}
    local function consider(cx, cy, cz)
        cx, cy, cz = intoRange(cx, cy, cz)
        if cx == nil then return end
        for i = 1, #avoid do
            if covers(cx, cy, cz, avoid[i]) then return end
        end
        local count, spread = 0, 0
        for i = 1, #points do
            local p = points[i]
            if covers(cx, cy, cz, p) then
                count = count + 1
                local d2 = (p.x - cx) ^ 2 + (p.y - cy) ^ 2
                if d2 > spread then spread = d2 end
            end
        end
        if count >= minUnits then
            scored[#scored + 1] = { x = cx, y = cy, z = cz, count = count, spread = spread,
                fromPlayer = (cx - px) ^ 2 + (cy - py) ^ 2 }
        end
    end
    for i = 1, #points do consider(points[i].x, points[i].y, points[i].z) end
    local maxPair2 = 4 * r2
    for i = 1, #points - 1 do
        local p1 = points[i]
        for j = i + 1, #points do
            local p2 = points[j]
            local dx, dy = p2.x - p1.x, p2.y - p1.y
            local d2 = dx * dx + dy * dy
            if d2 > 0 and d2 <= maxPair2 and math.abs(p1.z - p2.z) <= 2 * GROUND_HEIGHT_TOLERANCE then
                local d = math.sqrt(d2)
                local h = math.sqrt(math.max(0, r2 - d2 / 4))
                local mx, my, mz = (p1.x + p2.x) / 2, (p1.y + p2.y) / 2, (p1.z + p2.z) / 2
                local ox, oy = -dy / d * h, dx / d * h
                consider(mx + ox, my + oy, mz)
                consider(mx - ox, my - oy, mz)
                consider(mx, my, mz)
            end
        end
    end
    if #scored == 0 then return nil end
    -- Most units first; then the tightest fit (the farthest covered unit closest to the centre, so
    -- units at the edge don't walk out); then the spot nearest you
    table.sort(scored, function(a, b)
        if a.count ~= b.count then return a.count > b.count end
        if a.spread ~= b.spread then return a.spread < b.spread end
        return a.fromPlayer < b.fromPlayer
    end)
    local misc = br.functions.misc
    local hidden, traces = {}, 0
    local hiddenArea2 = GROUND_HIDDEN_AREA * GROUND_HIDDEN_AREA
    for i = 1, #scored do
        local c = scored[i]
        local nearHidden = false
        for j = 1, #hidden do
            if (c.x - hidden[j].x) ^ 2 + (c.y - hidden[j].y) ^ 2 <= hiddenArea2 then nearHidden = true break end
        end
        if not nearHidden then
            if misc:canSeePosition(c.x, c.y, c.z) then
                result.x, result.y, result.z, result.count = c.x, c.y, c.z, c.count
                return c.x, c.y, c.z, c.count
            end
            hidden[#hidden + 1] = c
            traces = traces + 1
            if traces >= GROUND_MAX_TRACES then break end
        end
    end
    return nil
end

-- Casts a ground AoE at the best spot findGroundLocation finds (helpful: covers allies instead).
function custom:castGroundAtBestLocation(spellID, radius, minUnits, maxRange, minRange, helpful)
    local x, y, z = custom:findGroundLocation(spellID, radius, minUnits, maxRange, minRange, helpful)
    if x == nil then return false end
    return br.functions.cast:castAtPosition(x, y, z, spellID)
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
        -- br._G.TargetUnit(target)
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
    local spec = br.loader.selectedSpecID
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
