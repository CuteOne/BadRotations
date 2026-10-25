local _, br = ...
---@class br.functions.custom
br.functions.custom = br.functions.custom or {}
local custom = br.functions.custom

-- Functions from coders for public use
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
-- local x, y, z, count = br.functions.custom:findGroundLocation(br.rotation.spells.hurricane, 8, 3)
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

br.functions.DBM = {}

--- Return: All current DBM Timer
function br.functions.DBM:getBars()
    if br.game.DBM then
        if not br.functions.DBM.Timer then
            br.functions.DBM.Timer = {}
        else
            br.game.wipe(br.functions.DBM.Timer)
        end
        if br.game.DBM.Bars ~= nil then
            for bar in pairs(br.game.DBM.Bars.bars) do
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
        if br.game.C_AddOns.IsAddOnLoaded('DBM-Core') then
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
        elseif br.game.C_AddOns.IsAddOnLoaded("BigWigs") then
            local hasTimer = false
            local isBelowTime = false
            local currentTimer = 0
            local specificID = specificID or "Pull"
            for i = 1, #br.functions.DBM.Timer do
                -- Check if timer with spell id is present
                if br.functions.DBM.Timer[i] ~= nil and br.functions.DBM.Timer[i].id == specificID then
                    hasTimer = true
                    currentTimer = br.functions.DBM.Timer[i].exptime - br.game.GetTime()
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
        if br.game.C_AddOns.IsAddOnLoaded('DBM-Core') then
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
        elseif br.game.C_AddOns.IsAddOnLoaded("BigWigs") then
            local hasTimer = false
            local isBelowTime = false
            local currentTimer = 0
            for i = 1, #br.functions.DBM.Timer do
                -- Check if timer with spell id is present
                if br.functions.DBM.Timer[i] ~= nil and br.functions.DBM.Timer[i].id == spellID then
                    hasTimer = true
                    currentTimer = br.functions.DBM.Timer[i].exptime - br.game.GetTime()
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

function custom:BWCheck()
    if #br.functions.DBM.Timer > 0 then
        for i = 1, #br.functions.DBM.Timer do
            if br.functions.DBM.Timer[i] ~= nil then
                if br.functions.DBM.Timer[i].exptime < br.game.GetTime() then
                    br.functions.DBM.Timer[i] = nil
                end
            else
            end
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
                    br.functions.DBM.Timer[i].exptime = br.game.GetTime() + duration
                    break
                end
            end
            if not clone then
                local timer = {}
                timer.id = spellId
                timer.exptime = br.game.GetTime() + duration
                br.game.tinsert(br.functions.DBM.Timer, timer)
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
    if br.game.BigWigsLoader then
        BigWigs.callback = {}
        br.game.BigWigsLoader.RegisterMessage(callback, "BigWigs_StartBar", BigWigs.BigwigsCallback);
        br.game.BigWigsLoader.RegisterMessage(callback, "BigWigs_StopBars", BigWigs.BigwigsCallback);
        br.game.BigWigsLoader.RegisterMessage(callback, "BigWigs_OnBossDisable", BigWigs.BigwigsCallback);
        br.game.BigWigsLoader.RegisterMessage(callback, "BigWigs_OnPluginDisable", BigWigs.BigwigsCallback);
    end
end

-- Casts a ground AoE at the best spot findGroundLocation finds (helpful: covers allies instead).
function custom:castGroundAtBestLocation(spellID, radius, minUnits, maxRange, minRange, helpful)
    local x, y, z = custom:findGroundLocation(spellID, radius, minUnits, maxRange, minRange, helpful)
    if x == nil then return false end
    return br.functions.cast:castAtPosition(x, y, z, spellID)
end

function custom:castGroundAtUnit(spellID, radius, minUnits, maxRange, minRange, spellType, unit)
    local info = br.game.C_Spell.GetSpellInfo(spellID)
    local spellMinRange, spellMaxRange = info and info.minRange, info and info.maxRange
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

function custom:findGroundLocation(spellID, radius, minUnits, maxRange, minRange, helpful)
    local info = br.game.C_Spell.GetSpellInfo(spellID)
    local spellMinRange, spellMaxRange = info and info.minRange, info and info.maxRange
    minRange = minRange or spellMinRange or 0
    maxRange = maxRange or spellMaxRange or 5
    radius = radius or maxRange
    minUnits = minUnits or 1
    local now = br.game.GetTime()
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

-- get threat situation on player and return the number
function custom:getThreat(mobUnit)
    local status = br.game.UnitThreatSituation("player", mobUnit)
    if status ~= nil then return status end
    -- 0 - Unit has less than 100% raw threat (default UI shows no indicator)
    -- 1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
    -- 2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
    -- 3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
    return 0
end

--[[                                                                                                ]]
--[[ Defmaster                                                                                      ]]
--[[                                                                                                ]]

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

--- Inserts table values into a table
--  No nested table (table in a table)
function custom:insertTableIntoTable(originalTable, insertTable)
    for i = 1, #insertTable do
        table.insert(originalTable, insertTable[i])
    end
end

--[[ DBM Timer ]] --

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

-- Boss mod timers (br.functions.DBM): which boss mod is loaded ("DBM", "BigWigs" or false) is checked
-- once, then again whenever an addon loads
local bossMod
local bossModFrame = br.game.CreateFrame("Frame")
bossModFrame:RegisterEvent("ADDON_LOADED")
bossModFrame:SetScript("OnEvent", function() bossMod = nil end)
br.lifecycle:onTick(80, "boss mod timers", function()
	if bossMod == nil then
		local loaded = br.game.C_AddOns.IsAddOnLoaded
		bossMod = loaded("DBM-Core") and "DBM" or loaded("BigWigs") and "BigWigs" or false
	end
	if bossMod == "DBM" then
		br.functions.DBM:getBars()
	elseif bossMod == "BigWigs" then
		if not br.functions.DBM.BigWigs then custom:BWInit() else custom:BWCheck() end
	end
end)
