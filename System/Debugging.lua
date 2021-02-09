-- Provides functions to help debugging and profiling

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
    local endTime = debugprofilestop()
    if br.debug.cpu[table] == nil then
        br.debug.cpu[table] = {
            totalIterations = 0,
            currentTime = 0,
            elapsedTime = 0,
            averageTime = 0
        }
    end
    if isChecked("Debug Timers") then
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

    usage, calls = GetFunctionCPUUsage(br.friend.Update, true)
    br.debug.cpu.healingEngine["br.friend_Update"] = {usage = usage, calls = calls}

    usage, calls = GetFunctionCPUUsage(br.friend.UpdateUnit, true)
    br.debug.cpu.healingEngine["br.friend_UpdateUnit"] = {usage = usage, calls = calls}

    --local tmpUsage, tmpCalls
    --for i=1, #br.friend do
    --    usage, calls = GetFunctionCPUUsage(br.friend[i].UpdateUnit, true)
    --    tmpUsage = tmpUsage + usage
    --    tmpCalls = tmpCalls + calls
    --    br.debug.cpu.healingEngine["br.friend_UpdateUnit"] = {usage = usage, calls = calls }
    --    br.friend[i]:UpdateUnit()
    --end
    -- usage, calls = GetFunctionCPUUsage(, true)
end

--- Get Execution Speed
--  Prints the time needed to run a function X times
function br.debug.getEXspeed(cycles, func)
    local startTime = debugprofilestop()

    for i = 1, cycles do
        func()
    end

    local duration = debugprofilestop() - startTime
    local average = duration / cycles
    Print(format("Function %i times executed in %f ms (%f average)", cycles, duration, average))
end

-- INTO TIMER LUA

br.timer = {}
function br.timer:useTimer(timerName, interval)
    if self[timerName] == nil then
        self[timerName] =  0
    end
    if GetTime() - self[timerName] >= interval then
        self[timerName] = GetTime()
        return true
    else
        return false
    end
end

--[[br.timer = {}
function br.timer:useTimer(timerName, interval, randomPercent)
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
