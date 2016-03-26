-- Provides functions to help debugging and profiling

bb.debug.cpu = {}
bb.debug.cpu.healingEngine = {
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
    absorbANDhp = 0,
}
bb.debug.cpu.enemiesEngine = {
    makeEnemiesTable = 0,
    makeEnemiesTableCount = 0,
    makeEnemiesTableCurrent = 0,
    makeEnemiesTableAverage = 0,
    sanityTargets = 0,
    unitTargets = 0,
}
-- just for testing
function bb.debug.cpu:getHealingEngine()
    local usage, calls

    usage, calls = GetFunctionCPUUsage(nNova.Update, true)
    bb.debug.cpu.healingEngine["nNova_Update"] = {usage = usage, calls = calls }

    usage, calls = GetFunctionCPUUsage(nNova.UpdateUnit, true)
    bb.debug.cpu.healingEngine["nNova_UpdateUnit"] = {usage = usage, calls = calls }

    --local tmpUsage, tmpCalls
    --for i=1, #nNova do
    --    usage, calls = GetFunctionCPUUsage(nNova[i].UpdateUnit, true)
    --    tmpUsage = tmpUsage + usage
    --    tmpCalls = tmpCalls + calls
    --    bb.debug.cpu.healingEngine["nNova_UpdateUnit"] = {usage = usage, calls = calls }
    --    nNova[i]:UpdateUnit()
    --end
    -- usage, calls = GetFunctionCPUUsage(, true)
end

--- Get Execution Speed
--  Prints the time needed to run a function X times
function bb.debug.getEXspeed(cycles, func)
    local startTime = debugprofilestop()

    for i = 1, cycles do
        func()
    end

    local duration = debugprofilestop()-startTime
    local average = duration/cycles
    print(format("Function %i times executed in %f ms (%f average)", cycles, duration, average))
end