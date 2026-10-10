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
    { "Object scan (updateOM)",        function() return br.engines.enemiesEngineFunctions end, "updateOM" },
    { "Enemy unit updates",            function() return br.engines.enemiesEngine end,          "Update" },
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
        br._G.print(("|cffFFDD11[BadRotations]|r CPU over %d s | FPS avg %.0f | objects %d | scanned units %d | candidates %d | enemies %d"):format(
            seconds, fpsSamples > 0 and fpsTotal / fpsSamples or 0, br._G.GetObjectCount and br._G.GetObjectCount() or 0,
            #(engine.om or {}), count(engine.units), count(engine.enemy)))
        for _, stats in ipairs(results) do
            if stats.calls > 0 then
                br._G.print(("  %-30s %7.2f ms/s  %6.0f calls/s  %6.3f ms/call"):format(
                    stats.label, stats.time / seconds, stats.calls / seconds, stats.time / stats.calls))
            end
        end
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
