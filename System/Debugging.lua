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
    preCheck = false,
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
