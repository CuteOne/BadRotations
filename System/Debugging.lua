local _, br = ...
-- Provides functions to help debugging and profiling

-- Custom Debug Print
function br.debug:print(message)
	if br.data.settings[br.loader.selectedSpec].toggles["isDebugging"] == true then
		br._G.print(message)
	end
end

-- CPU Debug
br.debug.cpu = {}
br.debug.cpu.healingEngine = {
    UnitName = 0,
    nGUID = 0,
    GetRole = 0,
    getUnitGroupNumber = 0,
    Dispel = 0,
    getUnitDistance = 0,
    UnitThreatSituation = 0,
    UnitHealth = 0,
    hpMissing = 0,
    CalcHP = 0,
    absorb = 0,
    GetClass = 0,
    UnitIsPlayer = 0,
    GetPosition = 0,
    absorbANDhp = 0
}
-- Debug Timing - add local startTime = debugprofilestop() to start of function and call this at the end, pass a unique table name and the startTime variable.
function br.debug.cpu:updateDebug(startTime, table)
    local startTime = startTime
    local endTime = br._G.debugprofilestop()
    if br.debug.cpu[table] == nil then
        br.debug.cpu[table] = {
            totalIterations = 0,
            currentTime = 0,
            elapsedTime = 0,
            averageTime = 0
        }
    end
    if br.functions.misc:isChecked("Debug Timers") then
        br.debug.cpu[table].totalIterations = br.debug.cpu[table].totalIterations + 1
        br.debug.cpu[table].currentTime = endTime - startTime
        br.debug.cpu[table].elapsedTime = br.debug.cpu[table].elapsedTime + br.debug.cpu[table].currentTime
        br.debug.cpu[table].averageTime = br.debug.cpu[table].elapsedTime / br.debug.cpu[table].totalIterations
    else
        br.debug.cpu[table].totalIterations = 0
        br.debug.cpu[table].currentTime = 0
        br.debug.cpu[table].elapsedTime = 0
        br.debug.cpu[table].averageTime = 0
    end
end
-- just for testing
function br.debug.cpu:getHealingEngine()
    local usage, calls

    usage, calls = br._G.GetFunctionCPUUsage(br.engines.healingEngine.friend.Update, true)
    br.debug.cpu.healingEngine["br.engines.healingEngine.friend_Update"] = {usage = usage, calls = calls}

    usage, calls = br._G.GetFunctionCPUUsage(br.engines.healingEngine.friend.UpdateUnit, true)
    br.debug.cpu.healingEngine["br.engines.healingEngine.friend_UpdateUnit"] = {usage = usage, calls = calls}

    --local tmpUsage, tmpCalls
    --for i=1, #br.engines.healingEngine.friend do
    --    usage, calls = GetFunctionCPUUsage(br.engines.healingEngine.friend[i].UpdateUnit, true)
    --    tmpUsage = tmpUsage + usage
    --    tmpCalls = tmpCalls + calls
    --    br.debug.cpu.healingEngine["br.engines.healingEngine.friend_UpdateUnit"] = {usage = usage, calls = calls }
    --    br.engines.healingEngine.friend[i]:UpdateUnit()
    --end
    -- usage, calls = GetFunctionCPUUsage(, true)
end

--- Get Execution Speed
--  Prints the time needed to run a function X times
function br.debug:getEXspeed(cycles, func)
    local startTime = br._G.debugprofilestop()

    for i = 1, cycles do
        func()
    end

    local duration = br._G.debugprofilestop() - startTime
    local average = duration / cycles
    br._G.print(br._G.format("Function %i times executed in %f ms (%f average)", cycles, duration, average))
end

--- Profile run ("/br cpu [seconds]")
-- Wraps BR's main per-pulse functions for a few seconds, measures how long they take, then puts the
-- originals back and prints milliseconds per second of play for each, with unit counts and FPS.
-- Times include everything a function calls (profile time includes the getEnemies calls it makes).
local PROFILE_TARGETS = {
    -- label, table getter, function name
    { "Enemies engine pulse",          function() return br.engines.enemiesEngine end,          "Update" },
    { "  object scan",                 function() return br.engines.enemiesEngine end,          "scan" },
    { "getEnemies",                    function() return br.engines.enemiesEngineFunctions end, "getEnemies" },
    { "Enemies in cone",               function() return br.engines.enemiesEngineFunctions end, "getEnemiesInCone" },
    { "Enemies in rect",               function() return br.engines.enemiesEngineFunctions end, "getEnemiesInRect" },
    { "Dynamic target",                function() return br.engines.enemiesEngineFunctions end, "dynamicTarget" },
    { "isValidUnit",                   function() return br.functions.misc end,                 "isValidUnit" },
    { "enemyListCheck",                function() return br.functions.misc end,                 "enemyListCheck" },
    { "Healing engine",                function() return br.engines.healingEngine.friend end,   "Update" },
    { "Casts (cast.x / cast.able.x)",  function() return br.functions.cast end,                 "createCastFunction" },
    { "Profile pulse (player:update)", function() return br.player end,                         "update" },
}
local profiling = false

function br.debug.cpu:profile(seconds)
    if profiling then
        br._G.print("|cffFFDD11[BadRotations]|r A profile run is already going.")
        return
    end
    seconds = tonumber(seconds) or 30
    local clock = br._G.debugprofilestop
    local results, restore = {}, {}
    for _, target in ipairs(PROFILE_TARGETS) do
        local owner = target[2]()
        local original = owner and owner[target[3]]
        if type(original) == "function" then
            local stats = { label = target[1], time = 0, calls = 0 }
            results[#results + 1] = stats
            restore[#restore + 1] = { owner, target[3], original }
            local function finish(started, ...)
                stats.time = stats.time + (clock() - started)
                stats.calls = stats.calls + 1
                return ...
            end
            owner[target[3]] = function(...)
                return finish(clock(), original(...))
            end
        end
    end
    profiling = true
    local fpsTotal, fpsSamples = 0, 0
    local function sampleFPS()
        if not profiling then return end
        fpsTotal = fpsTotal + (br._G.GetFramerate() or 0)
        fpsSamples = fpsSamples + 1
        br._G.C_Timer.After(1, sampleFPS)
    end
    sampleFPS()
    br._G.print(("|cffFFDD11[BadRotations]|r Profiling for %d s..."):format(seconds))
    br._G.C_Timer.After(seconds, function()
        for _, r in ipairs(restore) do r[1][r[2]] = r[3] end
        profiling = false
        local function count(t) local n = 0 for _ in pairs(t or {}) do n = n + 1 end return n end
        local engine = br.engines.enemiesEngine
        br._G.print(("|cffFFDD11[BadRotations]|r CPU over %d s | FPS avg %.0f | objects %d | tracked units %d | candidates %d | enemies %d"):format(
            seconds, fpsSamples > 0 and fpsTotal / fpsSamples or 0, br._G.GetObjectCount and br._G.GetObjectCount() or 0,
            #(engine.recordList or {}), count(engine.units), count(engine.enemy)))
        local costs = br.engines.tickCost
        if costs then
            br._G.print(("  BR tick cost (running average): rotation %.2f ms + enemies engine %.2f ms -> %.2f s between ticks%s"):format(
                costs.rotation, costs.enemies, br.engines:getUpdateRate(),
                br.functions.misc:isChecked("Auto Delay") and " (Auto Delay)" or ""))
        end
        for _, stats in ipairs(results) do
            if stats.calls > 0 then
                br._G.print(("  %-30s %7.2f ms/s  %6.0f calls/s  %6.3f ms/call"):format(
                    stats.label, stats.time / seconds, stats.calls / seconds, stats.time / stats.calls))
            end
        end
    end)
end

-- /br range [watch|stop]: checks BR's range rules (System/Functions/Range.lua) against the game's own answers
-- for the target. A snapshot prints the measurements; watch prints a line each time the game's or BR's
-- melee / spell range answer changes, so walking in and out of range shows whether they flip together.
br.debug.range = {}
local rangeWatch = nil

-- A known harmful spell with a 20-45 yd range from the player's spells, to compare spell range with.
local function rangedTestSpell()
    local abilities = br.player and br.player.spells and br.player.spells.abilities
    if abilities == nil then return nil end
    local keys = {}
    for key in pairs(abilities) do keys[#keys + 1] = key end
    table.sort(keys)
    for _, key in ipairs(keys) do
        local spellID = br.functions.spell:currentRank(abilities[key])
        if type(spellID) == "number" and br.functions.spell:isKnown(spellID) then
            local name, _, _, _, _, maxRange = br.api.wow.GetSpellInfo(spellID)
            if name and maxRange and maxRange >= 20 and maxRange <= 45 and br.functions.spell:getSpellType(name) == "Harmful" then
                return name, maxRange
            end
        end
    end
    return nil
end

local function isFlagged(value) return br._G.issecretvalue ~= nil and br._G.issecretvalue(value) end

-- On Forever, values BR may use can still be flagged secret, and any text built from one prints as
-- <SECRET>. Text can't be cleaned, so it shows as "?".
local function printable(value)
    if value == nil or isFlagged(value) then return "?" end
    return tostring(value)
end

-- A flagged number rebuilt from comparisons (which BR may make), to the nearest 0.01.
local function plainNumber(value)
    if not isFlagged(value) then return value end
    local sign = 1
    if value < 0 then sign, value = -1, -value end
    local low, high = 0, 10000000
    while low < high do
        local mid = math.floor((low + high + 1) / 2)
        if value * 100 >= mid then low = mid else high = mid - 1 end
    end
    return sign * low / 100
end

-- Branching on a flagged boolean gives plain strings
local function inOut(value)
    if value == nil then return "--" end
    if value then return "IN" end
    return "OUT"
end

-- Everything one check needs, for the target. m.flagged names the values the game flagged secret.
local function measure()
    local range = br.functions.range
    if not br._G.UnitExists("target") then return nil end
    local m, flagged = {}, {}
    local function keep(name, value)
        if value ~= nil and isFlagged(value) then flagged[#flagged + 1] = name end
        m[name] = type(value) == "number" and plainNumber(value) or value
    end
    local centre, flat, dz = range:getCenterDistance("player", "target")
    if centre == nil then return nil end
    keep("centre", centre); keep("flat", flat); keep("dz", dz)
    keep("reachPlayer", range:getCombatReach("player")); keep("reachTarget", range:getCombatReach("target"))
    keep("speedPlayer", br._G.GetUnitSpeed("player")); keep("speedTarget", br._G.GetUnitSpeed("target"))
    keep("edge", range:getEdgeDistance("player", "target")); keep("leeway", range:getLeeway("player", "target"))
    keep("meleeReach", range:getMeleeReach("player", "target")); keep("aoe", range:getAoEDistance("player", "target"))
    keep("old", range:getDistance("player", "target"))
    m.meleeBR = centre <= range:getMeleeReach("player", "target")
    keep("meleeSpell", range:getMeleeSpellName())
    if m.meleeSpell then keep("meleeGame", br._G.C_Spell.IsSpellInRange(m.meleeSpell, "target")) end
    m.spell, m.spellRange = rangedTestSpell()
    if m.spell then
        m.spellBR = range:getEdgeDistance("player", "target") <= m.spellRange
        keep("spellGame", br._G.C_Spell.IsSpellInRange(m.spell, "target"))
    end
    m.flagged = flagged
    return m
end

-- Every line also goes to BRRange.log in the unlocker's folder (GetWoWDirectory), since chat copy
-- windows show <SECRET> on Forever.
local rangeLog = {}
local function say(text)
    br._G.print("|cffFFDD11[BR range]|r " .. text)
    if br._G.WriteFile == nil or br._G.GetWoWDirectory == nil or isFlagged(text) then return end
    rangeLog[#rangeLog + 1] = ("%.1f "):format(br._G.GetTime()) .. text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    if #rangeLog > 500 then table.remove(rangeLog, 1) end
    pcall(br._G.WriteFile, br._G.GetWoWDirectory() .. "\\BRRange.log", table.concat(rangeLog, "\n") .. "\n", false)
end

local function snapshot()
    local m = measure()
    if m == nil then return say("Target something first.") end
    say("Target: " .. printable(br._G.UnitName("target")) .. (m.leeway > 0 and "  (both running: +2.67 melee leeway)" or ""))
    if #m.flagged > 0 then say("  flagged secret by the game (still usable): " .. table.concat(m.flagged, ", ")) end
    say(("  speed: you %.2f, target %.2f yd/s"):format(m.speedPlayer or 0, m.speedTarget or 0))
    say(("  centre %.2f yd (2D %.2f, height %.2f) | combat reach: you %.2f, target %.2f"):format(m.centre, m.flat, m.dz, m.reachPlayer, m.reachTarget))
    say(("  edge-to-edge %.2f yd | current getDistance %.2f"):format(m.edge, m.old))
    say(("  melee: within %.2f yd of centre -> BR %s | game (%s) %s"):format(m.meleeReach, inOut(m.meleeBR), printable(m.meleeSpell), inOut(m.meleeGame)))
    if m.spell then
        say(("  %s (%d yd): BR %s | game %s"):format(m.spell, m.spellRange, inOut(m.spellBR), inOut(m.spellGame)))
    end
    say(("  AoE: target's edge %.2f yd from you (2D) -> an 8 yd AoE would hit: %s"):format(m.aoe, (m.aoe <= 8 and math.abs(m.dz) <= 8) and "yes" or "no"))
end

function br.debug.range:probe(arg)
    arg = arg and arg:lower()
    if arg == "stop" then
        if rangeWatch then rangeWatch:Cancel(); rangeWatch = nil end
        return say("Stopped.")
    end
    -- Slash commands run outside BR's protected scripts; timer callbacks run inside them (Forever)
    if arg ~= "watch" then return br._G.C_Timer.After(0, snapshot) end
    if rangeWatch then rangeWatch:Cancel() end
    local last, stopAt = nil, br._G.GetTime() + 120
    say("Watching the target for 2 minutes (/br range stop to end). Walk in and out of range.")
    rangeWatch = br._G.C_Timer.NewTicker(0.1, function()
        if br._G.GetTime() > stopAt then rangeWatch:Cancel(); rangeWatch = nil; return say("Stopped (2 minutes).") end
        local m = measure()
        if m == nil then return end
        local key = inOut(m.meleeBR) .. inOut(m.meleeGame) .. inOut(m.spellBR) .. inOut(m.spellGame)
        if key == last then return end
        last = key
        local agree = (m.meleeGame == nil or m.meleeBR == m.meleeGame) and (m.spellGame == nil or m.spellBR == m.spellGame)
        say(("%s melee BR %s/game (%s) %s | %s BR %s/game %s | centre %.2f edge %.2f%s"):format(agree and "|cff00FF00ok|r" or "|cffFF4040DIFFER|r",
            inOut(m.meleeBR), printable(m.meleeSpell), inOut(m.meleeGame), printable(m.spell), inOut(m.spellBR), inOut(m.spellGame), m.centre, m.edge,
            m.leeway > 0 and " (running)" or ""))
    end)
end

-- INTO TIMER LUA

br.debug.timer = {}
function br.debug.timer:useTimer(timerName, interval)
    if self[timerName] == nil then
        self[timerName] = 0
    end
    if br._G.GetTime() - self[timerName] >= interval then
        self[timerName] = br._G.GetTime()
        return true
    else
        return false
    end
end

--[[br.debug.timer = {}
function br.debug.timer:useTimer(timerName, interval, randomPercent)
    local randomPercent = randomPercent or 0
    if randomPercent > 0 then
        local randomRange = interval * randomPercent / 100
        interval = interval - randomRange + math.random(0, randomRange * 2)
    end
    if self[timerName] == nil then self[timerName] = 0 end
    if GetTime()-self[timerName] >= interval then
        self[timerName] = GetTime()
        return true
    else
        return false
    end
end--]]
