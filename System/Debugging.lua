local _, br = ...
-- Provides functions to help debugging and profiling

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
    local endTime = br.game.debugprofilestop()
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

    usage, calls = br.game.GetFunctionCPUUsage(br.engines.healingEngine.friend.Update, true)
    br.debug.cpu.healingEngine["br.engines.healingEngine.friend_Update"] = {usage = usage, calls = calls}

    usage, calls = br.game.GetFunctionCPUUsage(br.engines.healingEngine.friend.UpdateUnit, true)
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
    local startTime = br.game.debugprofilestop()

    for i = 1, cycles do
        func()
    end

    local duration = br.game.debugprofilestop() - startTime
    local average = duration / cycles
    br.game.print(br.game.format("Function %i times executed in %f ms (%f average)", cycles, duration, average))
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
    { "Profile pulse (rotation:update)", function() return br.runner end,                       "update" },
}
local profiling = false

--- Deep profile run ("/br cpu all [seconds]")
-- Wraps every function in BR's System modules (br.functions.<module>, br.engines.<engine>) and every game function
-- BR holds in br.game (the unlocker adapter's wrappers among them) for a few seconds, then writes to Logs/Cpu.log the
-- functions by their own time (minus what they called that was also wrapped) and by total time, with calls per
-- second. Code that copied a function into a local before the run isn't counted. The wrappers add a little to every
-- call; the report says how many calls there were.
-- Why (2026-11-06, Forever on Veil): /br cpu out of combat with nothing near gave the profile pulse 4 ms a tick, and
-- the functions /br cpu wraps didn't account for it.
local DEEP_SKIP = { debugprofilestop = true, GetTime = true, GetTimePreciseSec = true, print = true }
local cpuLine
function br.debug.cpu:profileAll(seconds)
    if profiling then
        br.log:say("CPU", "A profile run is already going.")
        return
    end
    seconds = tonumber(seconds) or 30
    cpuLine = cpuLine or br.log:file("Cpu.log", 400)
    local clock = br.game.debugprofilestop
    local stats, restore, wrapped = {}, {}, {}
    local childTime, depth = {}, 0
    local function wrap(owner, key, label)
        local original = rawget(owner, key)
        if type(original) ~= "function" or wrapped[original] then return end
        local s = { label = label, self = 0, total = 0, calls = 0 }
        stats[#stats + 1] = s
        local function finish(myDepth, started, ...)
            local spent = clock() - started
            local inner = childTime[myDepth] or 0
            depth = myDepth - 1
            if depth > 0 then childTime[depth] = (childTime[depth] or 0) + spent end
            s.self, s.total, s.calls = s.self + spent - inner, s.total + spent, s.calls + 1
            return ...
        end
        local wrapper = function(...)
            local myDepth = depth + 1
            depth = myDepth
            childTime[myDepth] = 0
            return finish(myDepth, clock(), original(...))
        end
        wrapped[original], wrapped[wrapper] = true, true
        restore[#restore + 1] = { owner, key, original, wrapper }
        owner[key] = wrapper
    end
    local function wrapModules(root, prefix)
        for name, module in pairs(root) do
            if type(module) == "table" and type(name) == "string" then
                for key in pairs(module) do
                    if type(key) == "string" then wrap(module, key, prefix .. name .. ":" .. key) end
                end
            end
        end
    end
    wrapModules(br.functions, "")
    wrapModules(br.engines, "")
    for key in pairs(br.game) do
        if type(key) == "string" and not DEEP_SKIP[key] then wrap(br.game, key, "game." .. key) end
    end
    profiling = true
    local frames = 0
    local counter = br.game.CreateFrame("Frame")
    counter:SetScript("OnUpdate", function() frames = frames + 1 end)
    br.log:say("CPU", ("Deep profile of %d functions for %d s (Logs\\Cpu.log)..."):format(#stats, seconds))
    br.game.C_Timer.After(seconds, function()
        -- put back only what still holds the wrapper: code that set a new function meanwhile keeps it
        for i = #restore, 1, -1 do local r = restore[i]; if rawget(r[1], r[2]) == r[4] then r[1][r[2]] = r[3] end end
        counter:SetScript("OnUpdate", nil)
        profiling = false
        local calls, gameCalls, gameTime = 0, 0, 0
        for _, s in ipairs(stats) do
            calls = calls + s.calls
            if s.label:sub(1, 5) == "game." then gameCalls, gameTime = gameCalls + s.calls, gameTime + s.self end
        end
        local function report(title, field, count)
            table.sort(stats, function(a, b) return a[field] > b[field] end)
            cpuLine(title)
            for i = 1, math.min(count, #stats) do
                local s = stats[i]
                if s.calls == 0 then break end
                cpuLine(("  %-52s %7.2f ms/s  %7.0f calls/s  %7.1f us/call (total %.2f ms/s)"):format(s.label,
                    s[field] / seconds, s.calls / seconds, s[field] * 1000 / s.calls, s.total / seconds))
            end
        end
        cpuLine(("=== deep profile %d s | FPS %.0f | combat %s | %d functions wrapped | %.0f calls/s | game calls %.0f/s, their own time %.2f ms/s"):format(
            seconds, frames / seconds, br.game.UnitAffectingCombat("player") and "yes" or "no", #stats,
            calls / seconds, gameCalls / seconds, gameTime / seconds))
        report("-- by own time", "self", 40)
        report("-- by total time (includes what they call)", "total", 25)
        br.log:flush()
        br.log:say("CPU", ("Deep profile done: %.0f calls/s, %.0f of them game calls (%.2f ms/s); details in Logs\\Cpu.log"):format(
            calls / seconds, gameCalls / seconds, gameTime / seconds))
    end)
end

function br.debug.cpu:profile(seconds)
    if profiling then
        br.log:say("CPU", "A profile run is already going.")
        return
    end
    seconds = tonumber(seconds) or 30
    local clock = br.game.debugprofilestop
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
        fpsTotal = fpsTotal + (br.game.GetFramerate() or 0)
        fpsSamples = fpsSamples + 1
        br.game.C_Timer.After(1, sampleFPS)
    end
    sampleFPS()
    br.log:say("CPU", ("Profiling for %d s..."):format(seconds))
    br.game.C_Timer.After(seconds, function()
        for _, r in ipairs(restore) do r[1][r[2]] = r[3] end
        profiling = false
        local function count(t) local n = 0 for _ in pairs(t or {}) do n = n + 1 end return n end
        local engine = br.engines.enemiesEngine
        br.log:say("CPU", ("over %d s | FPS avg %.0f | objects %d | tracked units %d | candidates %d | enemies %d"):format(
            seconds, fpsSamples > 0 and fpsTotal / fpsSamples or 0, br.game.GetObjectCount and br.game.GetObjectCount() or 0,
            #(engine.recordList or {}), count(engine.units), count(engine.enemy)))
        local costs = br.core.tickCost
        if costs then
            br.log:more(("  BR tick cost (running average): rotation %.2f ms + enemies engine %.2f ms -> %.2f s between ticks%s"):format(
                costs.rotation, costs.enemies, br.core:getUpdateRate(),
                br.functions.misc:isChecked("Auto Delay") and " (Auto Delay)" or ""))
        end
        for _, stats in ipairs(results) do
            if stats.calls > 0 then
                br.log:more(("  %-30s %7.2f ms/s  %6.0f calls/s  %6.3f ms/call"):format(
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
    local abilities = br.runner and br.runner.spells.abilities
    if abilities == nil then return nil end
    local keys = {}
    for key in pairs(abilities) do keys[#keys + 1] = key end
    table.sort(keys)
    for _, key in ipairs(keys) do
        local spellID = br.functions.spell:currentRank(abilities[key])
        if type(spellID) == "number" and br.functions.spell:isKnown(spellID) then
            local info = br.game.C_Spell.GetSpellInfo(spellID)
            local name, maxRange = info and info.name, info and info.maxRange
            if name and maxRange and maxRange >= 20 and maxRange <= 45 and br.functions.spell:getSpellType(name) == "Harmful" then
                return name, maxRange
            end
        end
    end
    return nil
end

-- Flagged values (see misc:plainNumber in System/Functions/Misc/Debug.lua)
local function isFlagged(value) return br.functions.misc:isFlagged(value) end
local function plainInteger(value, max) return br.functions.misc:plainInteger(value, max) end
local function plainNumber(value) return br.functions.misc:plainNumber(value) end

local function printable(value)
    if value == nil then return "?" end
    return br.log.printable(value)
end

-- A unit's name for a log file; a player's becomes a stand-in there (System/Logging.lua: Privacy)
local function unitName(unit)
    br.log:notePlayer(unit)
    return printable(br.game.UnitName(unit))
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
    if not br.game.UnitExists("target") then return nil end
    local m, flagged = {}, {}
    local function keep(name, value)
        if value ~= nil and isFlagged(value) then flagged[#flagged + 1] = name end
        m[name] = type(value) == "number" and plainNumber(value) or value
    end
    local centre, flat, dz = range:getCenterDistance("player", "target")
    if centre == nil then return nil end
    keep("centre", centre); keep("flat", flat); keep("dz", dz)
    keep("reachPlayer", range:getCombatReach("player")); keep("reachTarget", range:getCombatReach("target"))
    keep("speedPlayer", br.game.GetUnitSpeed("player")); keep("speedTarget", br.game.GetUnitSpeed("target"))
    keep("edge", range:getEdgeDistance("player", "target")); keep("leeway", range:getLeeway("player", "target"))
    keep("meleeReach", range:getMeleeReach("player", "target")); keep("aoe", range:getAoEDistance("player", "target"))
    keep("old", range:getDistance("player", "target"))
    m.meleeBR = centre <= range:getMeleeReach("player", "target")
    local meleeSpell, listKey = range:getMeleeSpellName()
    keep("meleeSpell", meleeSpell)
    m.listKey = listKey or "no melee list"
    if m.meleeSpell then keep("meleeGame", br.game.C_Spell.IsSpellInRange(m.meleeSpell, "target")) end
    -- Auto Attack's range is the melee check itself, in any form
    local autoAttack = br.functions.spell:getHighestSpellID("autoAttack")
    if autoAttack then keep("autoGame", br.game.C_Spell.IsSpellInRange(autoAttack, "target")) end
    m.spell, m.spellRange = rangedTestSpell()
    if m.spell then
        m.spellBR = range:getEdgeDistance("player", "target") <= m.spellRange
        keep("spellGame", br.game.C_Spell.IsSpellInRange(m.spell, "target"))
    end
    m.flagged = flagged
    return m
end

-- The recorders below write to log files in BR's Logs folder (System/Logging.lua), read between
-- sessions. Every line /br range prints also goes to Range.log.
local rangeLine = br.log:file("Range.log")
local function say(text)
    br.log:say("Range", text)
    rangeLine(text)
end

local function snapshot()
    local m = measure()
    if m == nil then return say("Target something first.") end
    say("Target: " .. unitName("target") .. (m.leeway > 0 and "  (both running: +2.67 melee leeway)" or ""))
    if #m.flagged > 0 then say("  flagged secret by the game (still usable): " .. table.concat(m.flagged, ", ")) end
    say(("  speed: you %.2f, target %.2f yd/s"):format(m.speedPlayer or 0, m.speedTarget or 0))
    say(("  centre %.2f yd (2D %.2f, height %.2f) | combat reach: you %.2f, target %.2f"):format(m.centre, m.flat, m.dz, m.reachPlayer, m.reachTarget))
    say(("  edge-to-edge %.2f yd | current getDistance %.2f"):format(m.edge, m.old))
    say(("  melee [%s]: within %.2f yd of centre -> BR %s | game: Auto Attack %s, %s %s"):format(m.listKey, m.meleeReach, inOut(m.meleeBR),
        inOut(m.autoGame), printable(m.meleeSpell), inOut(m.meleeGame)))
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
    if arg ~= "watch" then return br.game.C_Timer.After(0, snapshot) end
    if rangeWatch then rangeWatch:Cancel() end
    local last, stopAt = nil, br.game.GetTime() + 120
    say("Watching the target for 2 minutes (/br range stop to end). Walk in and out of range.")
    rangeWatch = br.game.C_Timer.NewTicker(0.1, function()
        if br.game.GetTime() > stopAt then
            if rangeWatch then rangeWatch:Cancel() end
            rangeWatch = nil
            return say("Stopped (2 minutes).")
        end
        local m = measure()
        if m == nil then return end
        local key = m.listKey .. inOut(m.meleeBR) .. inOut(m.autoGame) .. inOut(m.meleeGame) .. inOut(m.spellBR) .. inOut(m.spellGame)
        if key == last then return end
        last = key
        local agree = (m.autoGame == nil or m.meleeBR == m.autoGame) and (m.meleeGame == nil or m.meleeBR == m.meleeGame)
            and (m.spellGame == nil or m.spellBR == m.spellGame)
        say(("%s [%s] melee BR %s/game: Auto Attack %s, %s %s | %s BR %s/game %s | centre %.2f edge %.2f reach %.2f%s"):format(
            agree and "|cff00FF00ok|r" or "|cffFF4040DIFFER|r", m.listKey, inOut(m.meleeBR), inOut(m.autoGame), printable(m.meleeSpell),
            inOut(m.meleeGame), printable(m.spell), inOut(m.spellBR), inOut(m.spellGame), m.centre, m.edge, m.reachTarget,
            m.leeway > 0 and " (running)" or ""))
    end)
end

-- Range flips (2026-11-01, TBC: Lightning Bolt in range by the game at a mob BR measured about 32 yd away):
-- every time the game's range answer for a ranged spell at a unit changes, BR's own sum at that moment, so
-- the edge the game uses can be read off. Called by the cast gate (Cast/Dispatch.lua E.checkRange) with the
-- answer it asked for anyway. One line per change, at most RANGE_FLIP_LINES a session.
local RANGE_FLIP_LINES = 60
local rangeFlips, rangeFlipLines, rangeFlipKeys = {}, 0, 0 -- "spellID|guid" -> the game's last answer
function br.debug.range:noteGameAnswer(spellID, spellName, maxRange, unit, inRange)
    if type(inRange) ~= "boolean" or type(maxRange) ~= "number" or maxRange <= 5 then return end
    local guid = br.game.UnitGUID(unit)
    if guid == nil then return end
    local key = spellID .. "|" .. guid
    local last = rangeFlips[key]
    if last == nil then
        if rangeFlipLines >= RANGE_FLIP_LINES then return end -- capped: no new units kept
        -- a long session meets many units: start over now and then rather than keep them all
        rangeFlipKeys = rangeFlipKeys + 1
        if rangeFlipKeys > 300 then rangeFlips, rangeFlipKeys = {}, 1 end
    end
    rangeFlips[key] = inRange
    if last == nil or last == inRange or rangeFlipLines >= RANGE_FLIP_LINES then return end
    rangeFlipLines = rangeFlipLines + 1
    local range = br.functions.range
    local centre, flat, dz = range:getCenterDistance("player", unit)
    if centre == nil then return end
    centre, flat, dz = plainNumber(centre), plainNumber(flat), plainNumber(dz)
    local reachYou, reachIt = plainNumber(range:getCombatReach("player")), plainNumber(range:getCombatReach(unit))
    local bounding = br.game.UnitBoundingRadius
    local edge = plainNumber(range:getEdgeDistance("player", unit) or -1)
    rangeLine(("RANGE FLIP %s (%d yd) at %s: game %s -> %s, BR's edge %.2f says %s | centre %.2f (flat %.2f, height %+.2f) | reach you %.2f, it %.2f%s | at a flip the game's limit is here: it adds %.2f to the range (3D) or %.2f (flat), BR adds %.2f | moving: you %.1f, it %.1f yd/s"):format(
        printable(spellName), maxRange, unitName(unit), inOut(last), inOut(inRange), edge, inOut(edge <= maxRange),
        centre, flat, dz, reachYou, reachIt,
        bounding and (" | bounding you %.2f, it %.2f"):format(plainNumber(bounding("player") or 0), plainNumber(bounding(unit) or 0)) or "",
        centre - maxRange, flat - maxRange, reachYou + reachIt,
        plainNumber(br.game.GetUnitSpeed("player") or 0), plainNumber(br.game.GetUnitSpeed(unit) or 0)))
end

----------------------------------------------------------------------------------------------------
-- /br target: the enemy BR focuses on and why (br.engines.targeting:explain), in chat and Target.log
----------------------------------------------------------------------------------------------------
br.debug.target = br.debug.target or {}
local targetLine = br.log:file("Target.log")
local TARGET_REPORT_UNITS = 6

-- Why your target isn't one of BR's candidates: each check targeting's candidate filter
-- (Targeting.lua attackable, over getEnemies) and isValidUnit make that it fails. 2026-11-08 21:08 on
-- Forever a fleeing target dropped off the list with nothing in the logs to say why.
local function targetLeftOut()
    local unitFns, misc, cast = br.functions.unit, br.functions.misc, br.functions.cast
    local why = {}
    if unitFns:GetUnitIsDeadOrGhost("target") then why[#why + 1] = "dead" end
    local valid, invalidWhy = misc:isValidUnit("target")
    if not valid then why[#why + 1] = "not valid (" .. printable(invalidWhy or "no reason given") .. ")" end
    if not cast:isUnitVisible("target") then
        why[#why + 1] = cast:isRejected("los", nil, "target") and "out of sight (a cast's sight refusal)" or "out of sight"
    end
    if unitFns:isEvading("target") then why[#why + 1] = "evading" end
    if unitFns:isHeldBack("target") then why[#why + 1] = "held back (unit rules)" end
    if unitFns:isDummy("target") then why[#why + 1] = "a dummy" end
    if misc:getOptionCheck("Don't break CCs") and misc:isCCProtected("target") then why[#why + 1] = "CC protected (Don't break CCs)" end
    if misc:getOptionCheck("Safe Damage Check") and not br.engines.enemiesEngineFunctions:isSafeToAttack("target") then
        why[#why + 1] = "not safe (Safe Damage Check)"
    end
    local distance = plainNumber(br.functions.range:getDistance("target") or 99)
    if distance >= 50 then why[#why + 1] = "50 yd or more" end
    if #why == 0 then why[1] = "passes every check (not in the enemies list this tick)" end
    return ("Your target isn't a candidate: %s | %.1fyd, fleeing %s"):format(table.concat(why, ", "), distance,
        tostring(unitFns:isFleeing("target")))
end

-- reason (optional): why an automatic report was made (written to the log only, not chat); units:
-- how many candidates to list
function br.debug.target:report(reason, units)
    units = units or TARGET_REPORT_UNITS
    local function say(text)
        if reason == nil then br.log:say("Target", text) end
        targetLine(text)
    end
    if reason then say("--- " .. reason .. " ---") end
    if not (br.engines.targeting and br.engines.targeting.explain) then return say("Targeting isn't loaded.") end
    local misc = br.functions.misc
    local focus, list = br.engines.targeting:explain()
    say(("Targeting Mode %s (1 Off, 2 Assist, 3 Full) | your target: %s"):format(tostring(misc:getValue("Targeting Mode")),
        br.game.UnitExists("target") and unitName("target") or "none"))
    if br.game.UnitExists("target") and br.game.UnitCanAttack("player", "target") then
        local listed = false
        for i = 1, #list do
            if br.functions.unit:GetUnitIsUnit(list[i].unit, "target") then listed = true; break end
        end
        if not listed then say(targetLeftOut()) end
    end
    if #list == 0 then return say("No enemy BR may attack.") end
    say("Focus: " .. (focus and unitName(focus) or "none"))
    for i = 1, math.min(units, #list) do
        local entry = list[i]
        local parts = {}
        for _, part in ipairs(entry.parts) do parts[#parts + 1] = ("%s %.1f"):format(part[1], plainNumber(part[2])) end
        say(("%d. %s %.1fyd: %.1f = %s"):format(i, unitName(entry.unit), plainNumber(entry.distance or 0),
            plainNumber(entry.score), #parts > 0 and table.concat(parts, ", ") or "nothing"))
    end
    if #list > units then say(("... %d more"):format(#list - units)) end
end

-- An evading mob marked or lifted (Functions/Unit.lua): its GUID's tail, name, what happened
function br.debug.target:noteEvade(guid, name, what)
    targetLine(("EVADE %s #%s: %s"):format(name and printable(name) or "", tostring(guid):sub(-6), what))
end

-- Automatic reports in combat, so nothing depends on running /br target at the right moment: when BR's
-- focus changes, the target changes, or BR changes the target. At most one per AUTO_GAP seconds and
-- AUTO_PER_COMBAT per fight. Called by Player:startRotation after the rotation.
local AUTO_GAP, AUTO_PER_COMBAT = 3, 30
local autoLast, autoCount, lastFocus, lastTargetGUID = 0, 0, nil, nil
function br.debug.target:watch()
    if not br.game.UnitAffectingCombat("player") or not br.engines.targeting then
        autoCount, lastFocus, lastTargetGUID = 0, nil, nil
        return
    end
    local now = br.game.GetTime()
    local focus = br.engines.targeting:getFocus()
    local guid = br.game.UnitGUID("target")
    local reason
    if focus ~= lastFocus then reason = "BR's focus changed" end
    if guid ~= lastTargetGUID then
        reason = br.engines.enemiesEngineFunctions.lastRetargetAt == now and "BR changed your target" or "your target changed"
    end
    lastFocus, lastTargetGUID = focus, guid
    if reason and now - autoLast >= AUTO_GAP and autoCount < AUTO_PER_COMBAT then
        autoLast, autoCount = now, autoCount + 1
        self:report(reason, 3)
    end
end

----------------------------------------------------------------------------------------------------
-- Melee recorder (diagnostic, temporary): in combat, when the target is out of melee while another
-- enemy is in melee, writes what BR saw and did to Melee.log, with nothing to switch on. Called by
-- Player:startRotation after the rotation runs. Looks into the 2026-10-12 report of standing idle when
-- the target fled while a second mob stayed in melee.
----------------------------------------------------------------------------------------------------
br.debug.melee = br.debug.melee or {}
local meleeLine = br.log:file("Melee.log")
local MELEE_EPISODE_LINES = 40 -- lines kept per episode
local episode                   -- { started, lastSeen, lastSnap, lines, events }

local function meleeWrite(text)
    if episode then
        if episode.lines >= MELEE_EPISODE_LINES then return end
        episode.lines = episode.lines + 1
    end
    meleeLine(text)
end

-- "Name 6.2yd in front" for a unit
local function meleeUnit(u)
    if u == nil then return "none" end
    local unitFns = br.functions.unit
    local d = br.functions.range:getDistance(u)
    local text = ("%s %.1fyd %s"):format(unitName(u), plainNumber(d or 99),
        unitFns:getFacing("player", u) and "in front" or "not in front")
    if unitFns:GetUnitIsUnit(u, "target") then text = text .. " (target)" end
    return text
end

-- Game messages during an episode (spell failures, red error text)
local meleeEvents = br.game.CreateFrame("Frame")
meleeEvents:RegisterEvent("UI_ERROR_MESSAGE")
meleeEvents:RegisterEvent("UNIT_SPELLCAST_FAILED")
meleeEvents:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
meleeEvents:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
-- UI_ERROR_MESSAGE: errorType, message; UNIT_SPELLCAST_*: unit, castGUID, spellID
meleeEvents:SetScript("OnEvent", function(_, event, a, b, c, ...)
    -- Monster emotes in combat, episode or not: the flee emote's wording in this client's language
    -- (br.lists.fleeEmotes) and whether BR can read it
    if event == "CHAT_MSG_MONSTER_EMOTE" then
        if not br.game.UnitAffectingCombat("player") then return end
        local guid = select(9, ...) -- payload 12
        local ok, entry = pcall(function() return br.lists.fleeEmotes[a] end)
        local known = ok and entry and true or false
        local fromTarget = guid ~= nil and guid == br.game.UnitGUID("target")
        meleeWrite("emote: \"" .. printable(a) .. "\" from " .. printable(b) .. (fromTarget and " (target)" or "")
            .. " | flee text known: " .. tostring(known) .. " | guid " .. (guid and "yes" or "none")
            .. " | args " .. (3 + select("#", ...)) .. " | target fleeing now " .. tostring(br.functions.unit:isFleeing("target")))
        return
    end
    if not episode then return end
    local text
    if event == "UI_ERROR_MESSAGE" then
        text = "error: " .. printable(b)
    elseif a == "player" then
        local name = br.functions.spell:getName(c)
        text = (event == "UNIT_SPELLCAST_FAILED" and "failed: " or "cast: ") .. printable(name or c)
    end
    if text and #episode.events < 20 then episode.events[#episode.events + 1] = text end
end)

local function meleeState()
    local dyn5 = br.engines.enemiesEngineFunctions.dynamicPicks.dyn5
    local parts = {
        "target " .. meleeUnit("target"),
        "BR melee pick (dyn5) " .. (dyn5 and meleeUnit(dyn5) or "none"),
        "auto attack " .. (br.functions.unit:isAutoAttacking() and "on" or "off"),
        "target fleeing " .. tostring(br.functions.unit:isFleeing("target")),
    }
    -- The target's unit flags where the unlocker reads them (to confirm the fleeing bit, 0x00800000
    -- on TrinityCore-era servers, before br.client.fleeingUnitFlag is set)
    if br.game.UnitFlags then
        local ok, flags = pcall(br.game.UnitFlags, "target")
        if ok and type(flags) == "number" then
            if isFlagged(flags) then flags = plainInteger(flags, 4294967295) end
            parts[#parts + 1] = ("target flags 0x%08X"):format(flags)
        end
    end
    return table.concat(parts, " | ")
end

local meleeEnvironmentLogged = false
-- Swing around a cast (2026-10-26): does a cast-time spell reset the melee swing timer at its end,
-- pause it for the cast, or leave it alone? Each such cast while auto-attacking (15 a session) writes,
-- once the next main-hand swing lands, when that swing came against what each answer predicts. The
-- swing reader (unit.swing) and weave timing in profiles follow from the answer.
local SWING_CAST_LINES, SWING_MATCH = 15, 0.25
local swingCast, swingCastLines = nil, 0 -- { name, start, finished, due, speed, lastAtStart }
local swingCastEvents = br.game.CreateFrame("Frame")
swingCastEvents:RegisterEvent("UNIT_SPELLCAST_START")
swingCastEvents:RegisterEvent("UNIT_SPELLCAST_STOP")
swingCastEvents:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
swingCastEvents:SetScript("OnEvent", function(_, event, unitToken, _, spellID)
    if unitToken ~= "player" or swingCastLines >= SWING_CAST_LINES then return end
    local mh = br.readers.combatLog.swing.mh
    local now = br.game.GetTime()
    if event == "UNIT_SPELLCAST_START" then
        if not br.functions.unit:isAutoAttacking() or (mh.speed or 0) <= 0 or (mh.next or 0) <= 0 then return end
        swingCast = { name = printable(br.functions.spell:getName(spellID)), start = now, due = mh.next, speed = mh.speed,
            lastAtStart = mh.last }
    elseif swingCast and not swingCast.finished then
        swingCast.finished = now
        swingCast.interrupted = event == "UNIT_SPELLCAST_INTERRUPTED"
    end
end)

local function watchSwingAroundCast()
    local c = swingCast
    if c == nil then return end
    local mh = br.readers.combatLog.swing.mh
    local now = br.game.GetTime()
    if mh.last == c.lastAtStart then
        if now - c.start > 10 then swingCast = nil end -- no swing came (combat ended, auto attack off)
        return
    end
    local swungAt = mh.last
    swingCast = nil
    swingCastLines = swingCastLines + 1
    local finished = c.finished or swungAt
    local castFor = finished - c.start
    local resetAt, pauseAt = finished + c.speed, c.due + castFor
    local verdict
    if not c.finished or swungAt < finished then verdict = "swung during the cast"
    elseif math.abs(resetAt - pauseAt) < SWING_MATCH and math.abs(swungAt - resetAt) < SWING_MATCH then
        -- a cast started just after a swing: both answers predict the same time
        verdict = "reset or pause (the cast started just after a swing: can't tell)"
    elseif math.abs(swungAt - resetAt) < SWING_MATCH then verdict = "reset at the cast's end"
    elseif math.abs(swungAt - pauseAt) < SWING_MATCH then verdict = "paused for the cast"
    elseif math.abs(swungAt - c.due) < SWING_MATCH then verdict = "not affected"
    else verdict = "unclear" end
    meleeLine(("SWING AROUND CAST %s%s: swing due %.2fs after the cast started (speed %.2fs), cast %.2fs, swing came %.2fs after the cast ended | reset predicts %.2f, pause %.2f, none %.2f -> %s"):format(
        c.name, c.interrupted and " (interrupted)" or "", c.due - c.start, c.speed, castFor, swungAt - finished,
        c.speed, c.due + castFor - finished, c.due - finished, verdict))
end

-- Auto attack starts (2026-10-28): each start BR sends (15 a session) writes, once the game says auto
-- attack is on or 2 s after the send, where the unit was, when the game answered and any resends.
-- 2026-10-31 it showed starts sent during a cast or with a spell send on its way go unanswered, so
-- unit:startAttack no longer sends then; a start that still waits for a resend would show here.
local ATTACK_START_LINES, ATTACK_START_WAIT = 15, 2
local attackStart, attackStartLines = nil, 0 -- { sentAt, at, resends = { seconds after the first } }

-- The unit at a start's send: is it in melee by BR's reading, and was a GCD (a queued spell firing) on?
-- 2026-10-31: a start sent with no cast, right as a queued totem fired and the target stood at BR's
-- 5.0 yd melee edge, had no answer until the resend 1.1 s later.
local function attackTargetState(thisUnit)
    if thisUnit == nil or not br.game.UnitExists(thisUnit) then return "no unit" end
    local rangeFns = br.functions.range
    local distance = plainNumber(rangeFns:getDistance(thisUnit) or -1)
    local _, flat, dz = rangeFns:getCenterDistance("player", thisUnit)
    return ("%s at BR distance %.2fyd (%s), edge %.2fyd, centre flat %s, height %s, GCD %.2fs"):format(
        unitName(thisUnit), distance, distance < 5 and "in melee" or "out of melee",
        plainNumber(rangeFns:getEdgeDistance("player", thisUnit) or -1),
        flat and ("%.2fyd"):format(plainNumber(flat)) or "?", dz and ("%+.1fyd"):format(plainNumber(dz)) or "?",
        plainNumber(br.functions.spell:getGlobalCD() or 0))
end

local function attackStartLine(answeredAt)
    local a = attackStart
    attackStart = nil
    attackStartLines = attackStartLines + 1
    local resends = {}
    for i, after in ipairs(a.resends) do resends[i] = ("%.2fs"):format(after) end
    local answer = ("no answer in %ds"):format(ATTACK_START_WAIT)
    if answeredAt then
        answer = ("game said on %.2fs after the first send"):format(answeredAt - a.sentAt)
    end
    meleeLine(("AUTO ATTACK START sent at %s | %s | resent %s"):format(a.at, answer,
        #resends > 0 and (table.concat(resends, ", ") .. " after the first") or "never"))
end

-- unit:startAttack sent StartAttack at thisUnit
function br.debug.melee:noteAttackSent(thisUnit)
    if attackStartLines >= ATTACK_START_LINES then return end
    local now = br.game.GetTime()
    if attackStart then
        attackStart.resends[#attackStart.resends + 1] = now - attackStart.sentAt
    else
        attackStart = { sentAt = now, at = attackTargetState(thisUnit), resends = {} }
    end
end

-- PLAYER_ENTER_COMBAT: the game says auto attack is on
function br.debug.melee:noteAttackOn()
    if attackStart then attackStartLine(br.game.GetTime()) end
end

-- Target changes and auto attack stops in combat (2026-11-05: auto attack went off within half a second, six
-- times, each after the fleeing target's attacker took BR's focus; who changed the target, and in which order,
-- wasn't logged). Melee.log gets each target change (from, to, by BR's dynamic targeting or not, auto attack
-- then) and each auto attack stop (the target, how long after the last target change and who made it).
local TARGET_LINES = 60 -- per session
local targetLines = 0
local lastTarget = { text = "none", at = -math.huge, byBR = false }

local function targetWrite(text)
    if targetLines >= TARGET_LINES then return end
    targetLines = targetLines + 1
    meleeLine(text)
end

local function targetText()
    return br.functions.unit:GetUnitExists("target") and meleeUnit("target") or "none"
end

-- PLAYER_TARGET_CHANGED (Readers/common.lua)
function br.debug.melee:noteTargetChanged()
    local now = br.game.GetTime()
    local retargetAt = br.engines.enemiesEngineFunctions and br.engines.enemiesEngineFunctions.lastRetargetAt
    local byBR = retargetAt ~= nil and now - retargetAt <= 0.5
    local to = targetText()
    if br.game.UnitAffectingCombat("player") then
        targetWrite(("TARGET CHANGED %s -> %s, by %s | auto attack %s"):format(lastTarget.text, to,
            byBR and "BR (dynamic targeting)" or "not BR (you, or the game)",
            br.functions.unit:isAutoAttacking() and "on" or "off"))
    end
    lastTarget.text, lastTarget.at, lastTarget.byBR = to, now, byBR
end

-- PLAYER_LEAVE_COMBAT: the game says auto attack is off (Functions/Unit.lua setAutoAttacking)
function br.debug.melee:noteAttackOff()
    if not br.game.UnitAffectingCombat("player") then return end
    local since = br.game.GetTime() - lastTarget.at
    targetWrite(("AUTO ATTACK STOPPED: target %s | %s"):format(targetText(), since < 60
        and ("%.2fs after the target changed (by %s)"):format(since, lastTarget.byBR and "BR" or "not BR")
        or "the target hasn't changed for a minute or more"))
end

local function watchAttackStart(now)
    if attackStart and now - attackStart.sentAt > ATTACK_START_WAIT then attackStartLine(nil) end
end

function br.debug.melee:watch()
    local now = br.game.GetTime()
    watchSwingAroundCast()
    watchAttackStart(now)
    -- Once a session: client facts the fleeing and eating checks depend on
    if not meleeEnvironmentLogged then
        meleeEnvironmentLogged = true
        meleeWrite("client: locale " .. tostring(br.game.GetLocale and br.game.GetLocale())
            .. " | AuraUtil.UnpackAuraData " .. tostring(_G.AuraUtil ~= nil and _G.AuraUtil.UnpackAuraData ~= nil)
            .. " | unlocker UnitFlags " .. tostring(br.game.UnitFlags ~= nil)
            .. " | protected call " .. tostring(br.unlockers.protect ~= nil))
        -- Names in the unlocker's own API that could read unit flags (so an adapter can map
        -- br.game.UnitFlags) or run code protected / handle secret values (br.unlockers.protect)
        local raw = br.unlockers.raw
        if type(raw) == "table" then
            local names = {}
            pcall(function()
                for name in pairs(raw) do
                    if type(name) == "string" and (name:find("[Ff]lag") or name:find("[Ff]ield") or name:find("[Dd]escriptor")
                        or name:find("[Pp]rotect") or name:find("[Ss]ecure") or name:find("[Ss]ecret") or name:find("[Uu]nwrap")) then
                        names[#names + 1] = name
                    end
                end
            end)
            table.sort(names)
            meleeWrite("unlocker " .. tostring(br.unlockers.selected) .. " API: " .. (#names > 0 and table.concat(names, ", ") or "no flag/field/protect names listed"))
        end
    end
    local active = false
    local inMelee
    if br.game.UnitAffectingCombat("player") and br.game.UnitExists("target") then
        local targetDist = br.functions.range:getDistance("target")
        if targetDist == nil or targetDist >= 5 then
            inMelee = br.engines.enemiesEngineFunctions:getEnemies("player", 5)
            active = #inMelee > 0
        end
    end

    if active then
        if not episode then
            episode = { started = now, lastSeen = now, lastSnap = now, lines = 0, events = {} }
            local misc = br.functions.misc
            local valid, reason = misc:isValidUnit("target")
            local form = br.functions.unit:getFormSpellID()
            -- getEnemies counts by the AoE rule; a unit listed here can still be out of melee reach
            meleeWrite("=== Target out of melee, " .. #inMelee .. " enemy within 5 yd (AoE rule) ===")
            meleeWrite("  form " .. (form and printable(br.functions.spell:getName(form)) or "none")
                .. " | target fleeing " .. tostring(br.functions.unit:isFleeing("target") and true or false)
                .. " | target valid " .. tostring(valid and true or false) .. (reason and (" (" .. reason .. ")") or ""))
            for i = 1, math.min(3, #inMelee) do meleeWrite("  within 5 yd: " .. meleeUnit(inMelee[i])) end
            meleeWrite("  settings: Targeting Mode " .. tostring(misc:getValue("Targeting Mode"))
                .. " (1 Off, 2 Assist, 3 Full), Only In Combat " .. tostring(misc:isChecked("Targeting Only In Combat"))
                .. ", Don't break CCs " .. tostring(misc:isChecked("Don't break CCs")))
            meleeWrite("  " .. meleeState())
        end
        episode.lastSeen = now
        if now - episode.lastSnap >= 1 then
            local decisions = {}
            br.functions.cast:eachDecisionSince(episode.lastSnap, function(name, reason)
                if #decisions < 8 then decisions[#decisions + 1] = printable(name) .. (reason and (" refused " .. reason) or " passed") end
            end)
            episode.lastSnap = now
            meleeWrite(("  +%.1fs %s"):format(now - episode.started, meleeState()))
            if #decisions > 0 then meleeWrite("    BR: " .. table.concat(decisions, ", ")) end
            if #episode.events > 0 then
                meleeWrite("    game: " .. table.concat(episode.events, ", "))
                br.game.wipe(episode.events)
            end
        end
    elseif episode and now - episode.lastSeen > 1.5 then
        local how
        if not br.game.UnitAffectingCombat("player") then how = "combat ended"
        elseif not br.game.UnitExists("target") then how = "no target"
        else how = "target back in melee, or no enemy in melee" end
        local lasted = episode.lastSeen - episode.started
        episode.lines = 0
        meleeWrite(("=== ended after %.1fs: %s ==="):format(lasted, how))
        episode = nil
    end
end

----------------------------------------------------------------------------------------------------
-- Idle recorder (diagnostic): in combat with an enemy within 8 yd, when the player has cast nothing
-- and isn't auto-attacking anything in melee for IDLE_AFTER seconds, writes one snapshot of the moment
-- to Idle.log: target, BR's picks and scores, what the cast engine passed or refused, game errors.
-- Called by Player:startRotation after the rotation.
----------------------------------------------------------------------------------------------------
br.debug.idle = br.debug.idle or {}
local idleLine = br.log:file("Idle.log")
local IDLE_AFTER = 4
local lastActionAt, idleLogged, idleInCombat = 0, false, false
local idleRuns = 0 -- ticks the rotation ran (not paused) since the last action
local idleErrors = {}

local idleEvents = br.game.CreateFrame("Frame")
idleEvents:RegisterEvent("UNIT_SPELLCAST_START")
idleEvents:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
idleEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
idleEvents:RegisterEvent("UI_ERROR_MESSAGE")
idleEvents:SetScript("OnEvent", function(_, event, a, b)
    if event == "UI_ERROR_MESSAGE" then
        if #idleErrors < 10 then idleErrors[#idleErrors + 1] = printable(b) end
    elseif a == "player" then
        lastActionAt, idleLogged, idleRuns = br.game.GetTime(), false, 0
        br.game.wipe(idleErrors)
    end
end)

function br.debug.idle:watch(paused)
    local now = br.game.GetTime()
    if not br.game.UnitAffectingCombat("player") then
        idleInCombat = false
        return
    end
    -- the clock starts when the fight does (also after a /reload mid-fight), and again when a
    -- pause or crowd control ends: a paused or feared/stunned player isn't idle (2026-10-26, Gruul's
    -- Lair: Maulgar's fear and Gruul's Stoned logged as 13 s and 11 s idle)
    if not idleInCombat or paused or br.functions.combat:hasHardControl() then
        idleInCombat, lastActionAt, idleLogged, idleRuns = true, now, false, 0
        return
    end
    idleRuns = idleRuns + 1
    -- swinging at a target in melee isn't idle: it restarts the clock, as an action does (2026-11-01: 10 s of
    -- swings were logged as idle the moment the target died)
    if br.functions.unit:isAutoAttacking() and br.game.UnitExists("target") and br.functions.range:getDistance("target") < 5 then
        lastActionAt = now
        return
    end
    -- nothing within 8 yd yet: the clock starts when an enemy gets there (2026-11-09: 3 of 10 snapshots were a
    -- mob pulled from 25-30 yd, logged as 4 s idle the moment it ran up to you)
    if #br.engines.enemiesEngineFunctions:getEnemies("player", 8) == 0 then
        lastActionAt = now
        return
    end
    if idleLogged or now - lastActionAt < IDLE_AFTER then return end
    local targetDist = br.game.UnitExists("target") and br.functions.range:getDistance("target") or 99
    idleLogged = true
    local dyn5 = br.engines.enemiesEngineFunctions.dynamicPicks.dyn5
    local spec = br.data and br.data.settings and br.data.settings[br.loader.selectedSpec]
    idleLine(("=== idle %.1fs in combat ==="):format(now - lastActionAt))
    idleLine("  target " .. (br.game.UnitExists("target") and (unitName("target") .. (" %.1fyd"):format(plainNumber(targetDist))) or "none")
        .. " | dyn5 " .. (dyn5 and unitName(dyn5) or "none")
        .. " | auto attack " .. (br.functions.unit:isAutoAttacking() and "on" or "off")
        .. " | paused toggle " .. tostring(spec and spec.toggles and spec.toggles["Pause"]))
    local decisions = {}
    if br.functions.cast.eachDecisionSince then br.functions.cast:eachDecisionSince(lastActionAt, function(name, reason, detail)
        if #decisions < 15 then
            decisions[#decisions + 1] = printable(name) .. (reason and (" refused " .. reason .. (detail and (" (" .. printable(tostring(detail)):sub(1, 40) .. ")") or "")) or " passed")
        end
    end) end
    idleLine("  BR since the last action: " .. (#decisions > 0 and table.concat(decisions, ", ") or "nothing tried"))
    -- Debug Level developer: the same in one chat line
    if br.functions.misc:debugAt("developer") then
        br.log:systemDebug(("[IDLE] %.1fs in combat doing nothing: target %s, auto attack %s; %s (Logs\\Idle.log)"):format(
            now - lastActionAt,
            br.game.UnitExists("target") and (unitName("target") .. (" %.1fyd"):format(plainNumber(targetDist))) or "none",
            br.functions.unit:isAutoAttacking() and "on" or "off",
            #decisions > 0 and ("BR tried " .. table.concat(decisions, ", ", 1, math.min(3, #decisions))) or "the profile asked for nothing"))
    end
    if #idleErrors > 0 then idleLine("  game errors: " .. table.concat(idleErrors, ", ")) end
    -- "nothing tried" with runs > 0: the profile ran but stopped itself (its own halt, a toggle) or
    -- reached no cast line
    local toggleParts = {}
    if spec and type(spec.toggles) == "table" then
        for name, value in pairs(spec.toggles) do toggleParts[#toggleParts + 1] = printable(name) .. " " .. tostring(value) end
        table.sort(toggleParts)
    end
    local form = br.functions.unit:getFormSpellID()
    idleLine(("  rotation ran %d ticks | form %s | health %d%% | mana %d | rage %d | energy %d"):format(idleRuns,
        form and printable(br.functions.spell:getName(form)) or "none", plainNumber(br.functions.unit:getHP("player") or 0),
        plainNumber(br.game.UnitPower("player", 0) or 0), plainNumber(br.game.UnitPower("player", 1) or 0),
        plainNumber(br.game.UnitPower("player", 3) or 0)))
    idleLine("  toggles: " .. (#toggleParts > 0 and table.concat(toggleParts, ", ") or "none"))
    if br.engines.targeting then
        local focus, list = br.engines.targeting:explain()
        idleLine("  focus " .. (focus and unitName(focus) or "none") .. ", candidates:")
        for i = 1, math.min(3, #list) do
            local parts = {}
            for _, part in ipairs(list[i].parts) do parts[#parts + 1] = ("%s %.1f"):format(part[1], plainNumber(part[2])) end
            -- in front of you or not: BR's facing picks (units.get(range)) skip a unit behind you (2026-11-01)
            local angle = br.functions.unit:getFacingAngle("player", list[i].unit)
            idleLine(("    %s %.1fyd %s: %.1f = %s"):format(unitName(list[i].unit), plainNumber(list[i].distance or 0),
                angle and ("%d° off your facing"):format(plainNumber(angle)) or "facing unknown",
                plainNumber(list[i].score), table.concat(parts, ", ")))
        end
    end
end

----------------------------------------------------------------------------------------------------
-- Spells learned but unused (Debug Level developer, 2026-10-26): a spell the character learns during
-- the session (a level, a trainer, a talent) that the profile hasn't asked for in UNUSED_FIGHTS fights
-- of UNUSED_MIN_FIGHT seconds or more gets one chat line, so a profile that plays at every level shows
-- where it misses a new spell. Every cast.<spell>() and cast.able.<spell>() counts as asking, whatever
-- the answer. Spells known before the first fight don't count: there's no list of what a profile
-- leaves out on purpose.
----------------------------------------------------------------------------------------------------
br.debug.unused = br.debug.unused or {}
local UNUSED_FIGHTS, UNUSED_MIN_FIGHT = 3, 5
local knownNames, knownFor -- name -> true: the known, castable abilities at the last fight start; for which runner
local watchedNames = {}    -- name -> fights it went unasked
local askedNames = {}      -- name -> true: asked this fight

-- The names of the character's known, castable abilities in the profile's spell lists
local function knownAbilityNames()
    local names = {}
    local abilities = br.runner and br.runner.spells and br.runner.spells.abilities
    if abilities == nil then return names end
    local spellFns = br.functions.spell
    for _, ref in pairs(abilities) do
        local id = spellFns:resolveRank(ref)
        if type(id) == "number" and id > 0 and spellFns:isKnown(id) and not spellFns:isPassive(id) then
            local name = spellFns:getName(id)
            if name then names[name] = true end
        end
    end
    return names
end

--- The profile asked for a spell (cast:createCastFunction)
function br.debug.unused:asked(spellID)
    if next(watchedNames) == nil then return end
    local name = br.functions.spell:getName(spellID)
    if name then askedNames[name] = true end
end

br.log.rotation:onFight(function(phase, fight)
    if phase == "start" then
        local now = knownAbilityNames()
        if knownFor ~= br.runner then
            br.game.wipe(watchedNames) -- a new spec or profile starts over
        elseif knownNames then
            for name in pairs(now) do
                if not knownNames[name] and watchedNames[name] == nil then watchedNames[name] = 0 end
            end
        end
        knownNames, knownFor = now, br.runner
        br.game.wipe(askedNames)
        return
    end
    if phase ~= "close" or (fight.duration or 0) < UNUSED_MIN_FIGHT then return end
    for name, fights in pairs(watchedNames) do
        if askedNames[name] then
            watchedNames[name] = nil
        elseif fights + 1 >= UNUSED_FIGHTS then
            watchedNames[name] = nil
            if br.functions.misc:debugAt("developer") then
                br.log:systemDebug(("[UNUSED] %s: learned this session, and %s hasn't asked for it in %d fights."):format(
                    printable(name), printable(tostring(br.loader.selectedProfileName)), UNUSED_FIGHTS))
            end
        else
            watchedNames[name] = fights + 1
        end
    end
end)

----------------------------------------------------------------------------------------------------
-- Combo point probe (diagnostic): are combo points kept on the target (Classic) or on the player
-- (Retail since 6.0.2)? Forever's tooltips list them as a cost like Retail's, unconfirmed. When the
-- target changes while the player has combo points, Melee.log gets the points before and after,
-- read both ways (GetComboPoints on the target, and the player's ComboPoints power, type 4).
-- br.client.rules.comboPointsOnTarget (Expansions/<Name>) follows the answer.
----------------------------------------------------------------------------------------------------
local comboBefore, comboPowerBefore = 0, 0
local comboLogged = 0
local function readCombo()
    local onTarget = br.game.GetComboPoints and tonumber(br.game.GetComboPoints("player", "target")) or 0
    local power = br.game.UnitPower and tonumber(br.game.UnitPower("player", 4)) or 0
    return plainNumber(onTarget or 0), plainNumber(power or 0)
end
local comboFrame = br.game.CreateFrame("Frame")
comboFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
comboFrame:SetScript("OnEvent", function()
    if comboLogged >= 20 or (comboBefore <= 0 and comboPowerBefore <= 0) then return end
    comboLogged = comboLogged + 1
    local onTarget, power = readCombo()
    meleeWrite(("combo points on a target switch: before %d on the target / %d as power -> after %d on the new target / %d as power (on-target flag %s)"):format(
        comboBefore, comboPowerBefore, onTarget, power, tostring(br.client.rules.comboPointsOnTarget)))
end)

-- Called each tick (Player:startRotation): the points before any switch
function br.debug.melee:readComboPoints()
    comboBefore, comboPowerBefore = readCombo()
end


----------------------------------------------------------------------------------------------------
-- Cast queue recorder (diagnostic): the server refused heals sent during another heal with "Another
-- action is in progress" (2026-10-12). BRCast.log gets a line for every spell BR sends while the
-- player is casting or channelling (a pre-cast), and one for every such refusal, with what BR saw
-- when it sent: the cast it went behind, time left on it, the queue window, the GCD, pushbacks and
-- BR's previous send. Called by the cast dispatcher (noteSend) just before each send.
----------------------------------------------------------------------------------------------------
br.debug.cast = br.debug.cast or {}
local castWrite = br.log:file("Cast.log", 150)
local lastSend, previousSend -- { name, at, behind, remain, window, gcd, pushbacks }
local pushbacks = 0          -- UNIT_SPELLCAST_DELAYED on the player's current cast

-- The player's cast or channel: name, seconds left
local function currentCast(now)
    local name, _, _, _, endMS = br.game.UnitCastingInfo("player")
    if name == nil then name, _, _, _, endMS = br.game.UnitChannelInfo("player") end
    if name == nil then return nil end
    return printable(name), endMS and (plainNumber(endMS) / 1000 - now) or nil
end

local function describeSend(send, now)
    if send == nil then return "none" end
    return ("%s %.2fs ago%s"):format(send.name, now - send.at,
        send.behind and (" behind %s with %.2fs left"):format(send.behind, send.remain or -1) or "")
end

-- Where the player and the unit were at each send, for an "Out of range" refusal of it (noteOutOfRange)
local function rangeState(unit)
    local rangeFns = br.functions.range
    return ("edge %.2fyd, BR distance %.2fyd, you moving %.1f yd/s, it moving %.1f yd/s"):format(
        plainNumber(rangeFns:getEdgeDistance("player", unit) or -1), plainNumber(rangeFns:getDistance(unit) or -1),
        plainNumber(br.game.GetUnitSpeed("player") or 0), plainNumber(br.game.GetUnitSpeed(unit) or 0))
end
local sentRange -- { guid, at, state }: the last send at a unit other than the player

function br.debug.cast:noteSend(spellID, thisUnit)
    local now = br.game.GetTime()
    if thisUnit ~= nil and thisUnit ~= "player" and br.game.UnitExists(thisUnit) then
        sentRange = { guid = br.game.UnitGUID(thisUnit), at = now, state = rangeState(thisUnit) }
    end
    local behind, remain = currentCast(now)
    previousSend = lastSend
    lastSend = { spellID = spellID, name = printable(br.functions.spell:getName(spellID)), at = now, behind = behind,
        remain = remain, window = br.functions.cast:getQueueWindow(), gcd = br.functions.spell:getGlobalCD() or 0,
        cd = br.functions.spell:getSpellCD(spellID) or 0, pushbacks = pushbacks }
    if behind then
        castWrite(("pre-cast %s behind %s: %.2fs left, window %.2fs, GCD %.2fs, pushbacks %d, latency %dms | previous send %s"):format(
            lastSend.name, behind, remain or -1, lastSend.window, lastSend.gcd, pushbacks,
            plainNumber(br.functions.misc:getHomeLatency() or 0) * 1000, describeSend(previousSend, now)))
    end
end

-- Heals on their way (diagnostic, 2026-11-01 TBC): a Healing Potion went out 0.16-0.18 s before a pushed-back
-- Healing Wave landed, at 35% health with ~40% of health on its way, so that heal wasn't counted. Either its
-- amount was unknown (no rank seen this session, tooltip unread) or the cast didn't show yet at the send
-- (its promise then lasts one round trip). HEAL SENT says which; HEAL ITEM what the potion saw.
local HEAL_LINES = 30
local healLines = 0
local function healthState(unit)
    local unitFns = br.functions.unit
    return ("health %.0f%%, after heals %.0f%% (%d on their way)"):format(plainNumber(unitFns:getHP(unit) or -1),
        plainNumber(unitFns:getHPAfterHeals(unit) or -1), plainNumber(br.functions.cast:getHealsOnTheirWay(unit) or 0))
end

-- A spell sent (cast dispatcher): written when BR counts it as a heal, or its description speaks of healing
-- A bleed BR sent and what showed after it (unit:isBleedImmune's learning, Functions/Unit.lua)
function br.debug.cast:noteBleed(unitName, npcID, spellName, what)
    castWrite(("BLEED %s → %s (NPC %s): %s"):format(printable(spellName), printable(unitName or "?"), tostring(npcID), what))
end

function br.debug.cast:noteHealSent(spellID, thisUnit, castShowing)
    if healLines >= HEAL_LINES then return end
    local spellFns, C = br.functions.spell, br.game.C_Spell
    local amount = spellFns:getHealAmount(spellID)
    local desc = printable(C.GetSpellDescription and C.GetSpellDescription(spellID) or "<no GetSpellDescription>")
    if amount == nil and not desc:lower():find("heal", 1, true) then return end
    healLines = healLines + 1
    local _, left = currentCast(br.game.GetTime())
    castWrite(("HEAL SENT %s %d → %s: amount %s (rank amount %s, helpful %s, harmful %s, description \"%s\") | cast showing at the send %s%s | %s"):format(
        printable(spellFns:getName(spellID)), spellID, printable(br.game.UnitName(thisUnit) or thisUnit),
        amount and ("%.0f"):format(amount) or "none", tostring(spellFns:getRankAmount(spellID)),
        tostring(C.IsSpellHelpful(spellID)), tostring(C.IsSpellHarmful(spellID)), desc:sub(1, 70),
        castShowing and "yes" or "no", left and (" (%.2fs left)"):format(left) or "", healthState(thisUnit)))
end

-- A healing item used (cast:noteHealingItemUsed, the Healthstone/Potion module), before its own heal is counted
function br.debug.cast:noteHealItem(itemID, thisUnit)
    if healLines >= HEAL_LINES then return end
    healLines = healLines + 1
    local casting, left = currentCast(br.game.GetTime())
    castWrite(("HEAL ITEM %s at %s: %s | casting %s%s"):format(printable(br.game.C_Item.GetItemInfo(itemID) or itemID),
        printable(br.game.UnitName(thisUnit) or thisUnit), healthState(thisUnit), casting or "nothing",
        left and (" (%.2fs left)"):format(left) or ""))
end

-- A cast by name or ID the game refused with a Lua error (cast:castByName, cast:castByID). The error report's stack is
-- secret on Forever, so the call site and arguments are written here instead: the first few per
-- call site, then a count every 100th. "flagged" and "usable" tell whether the game marked the
-- argument secret and whether BR may use it (2026-10-12: every cast by name was refused for a
-- fight with arguments that print as plain "Swipe", "target"; were they flagged?).
local sendErrors = {}
local function argumentState(value)
    if value == nil then return "-" end
    local misc = br.functions.misc
    return ("%s/%s"):format(misc:isFlagged(value) and "flagged" or "plain", misc:canUseValue(value) and "usable" or "unusable")
end

function br.debug.cast:noteSendError(name, unit, err)
    local site = printable(br.game.debugstack and br.game.debugstack(4, 1, 0) or "?"):gsub("%s+$", "")
    local seen = (sendErrors[site] or 0) + 1
    sendErrors[site] = seen
    if seen > 3 and seen % 100 ~= 0 then return end
    local usable = br.functions.misc:canUseValue(unit)
    castWrite(("SEND ERROR #%d from %s: name %s (%s, %s), unit %s (%s, %s), exists %s, combat %s | %s"):format(
        seen, site, printable(name), type(name), argumentState(name), printable(unit), type(unit), argumentState(unit),
        tostring(unit ~= nil and usable and br.game.UnitExists(unit) or nil), tostring(br.game.InCombatLockdown()),
        printable(err)))
end

-- A send by ID (or by name with rank, after a silent one) the game never answered
-- (cast:castByID, System/Functions/Cast/Helpers.lua): what BR saw of the spell, so the cause can be
-- read. nextText: how that rank is sent from now on.
function br.debug.cast:noteNoAnswer(entry, nextText)
    local id, C = entry.spellID, br.game.C_Spell
    local usable, noPower = C.IsSpellUsable(id)
    local cd = C.GetSpellCooldown and C.GetSpellCooldown(id)
    if type(cd) ~= "table" then cd = nil end
    local casting = currentCast(br.game.GetTime())
    castWrite(("NO ANSWER %s: %s %d → %s (%s)%s | IsPlayerSpell %s, IsSpellKnown %s, usable %s%s, cooldown %s, GCD %.2fs, casting %s, form %s, combat %s"):format(
        entry.how, printable(entry.name), id, printable(entry.target), printable(entry.site),
        nextText and (" | next sends: " .. printable(nextText)) or "",
        tostring(br.game.IsPlayerSpell(id)), tostring(br.game.IsSpellKnown(id)), tostring(usable and true or false),
        noPower and " (power)" or "", cd and ("%.1f/%.1f"):format(plainNumber(cd.startTime or 0), plainNumber(cd.duration or 0)) or "?",
        br.functions.spell:getGlobalCD() or 0, casting or "nothing", tostring(br.game.GetShapeshiftForm()),
        tostring(br.game.InCombatLockdown())))
end

-- The game refused a BR cast with "Out of range" (2026-10-19: Ravage from Prowl refused in 4 of 6
-- openers while moving in, sent again 0.5 s later and accepted): where both were at the send and now.
function br.debug.cast:noteOutOfRange(spellID, guid)
    local unit = guid and br.game.GetObjectWithGUID and br.game.GetObjectWithGUID(guid)
    if unit == nil then return end
    local sent = sentRange and sentRange.guid == guid and sentRange or nil
    castWrite(("OUT OF RANGE %s → %s: at the send%s %s | now %s"):format(
        printable(br.functions.spell:getName(spellID)), unitName(unit),
        sent and (" (%.2fs before)"):format(br.game.GetTime() - sent.at) or "", sent and sent.state or "?",
        rangeState(unit)))
end

-- The game refused a BR cast with "You must be behind your target" (2026-10-19, TBC Anniversary: Shred
-- refused 6 times with the mob at 0.0 yd, both facing each other, while BR's check said behind).
-- What BR's behind check saw at that moment: how far the player stands off the unit's facing,
-- the centre and edge distances, and whether the unlocker's facing check decided.
function br.debug.cast:noteNotBehind(spellID, guid)
    local unit = guid and br.game.GetObjectWithGUID and br.game.GetObjectWithGUID(guid)
    if unit == nil then return end
    local unitFns = br.functions.unit
    local facing = unitFns:getFacing(unit, "player")
    local angle, centres = unitFns:getFacingAngle(unit, "player")
    local _, fromTarget = unitFns:getServerFacing(unit)
    -- A mob fighting you turns to face you unless it can't (stunned, confused): is its target you, and
    -- its unit flags (stunned 0x40000, confused 0x400000, fleeing 0x800000). UnitTarget comes back as
    -- a pointer, GUID or token depending on the unlocker, so it's compared with UnitIsUnit.
    local victim = br.game.UnitTarget and br.game.UnitTarget(unit)
    local targetsYou = victim ~= nil and br.game.UnitIsUnit(victim, "player")
    local flags = br.game.UnitFlags and br.game.UnitFlags(unit)
    -- 2026-10-26 (Gruul's Lair): refused at 110-128° off the facing towards its target while it moved and
    -- targeted someone else, where the server (CMaNGOS TBC) takes anything past 90°: how fast it moved,
    -- where the client's own facing puts you, and whether you faced it (the server needs that too)
    local clientAngle = fromTarget and unitFns:getFacingAngle(unit, "player", true)
    local yourAngle = unitFns:getFacingAngle("player", unit, true)
    local speed = br.game.GetUnitSpeed and br.game.GetUnitSpeed(unit)
    local function degrees(a) return a and ("%d°"):format(plainNumber(a)) or "?" end
    castWrite(("NOT BEHIND %s → %s: BR's check said %s | its target %s, unit flags %s | you stand %s off its facing (%s), centres %s apart, edge %.1fyd | it moving %s yd/s%s | it is %s off your facing"):format(
        printable(br.functions.spell:getName(spellID)), unitName(unit),
        facing == false and "behind" or facing == true and "in front" or "unknown",
        targetsYou and "you" or (victim == nil and "none" or "not you"),
        type(flags) == "number" and ("0x%08X"):format(plainNumber(flags)) or "?",
        degrees(angle), fromTarget and "towards its target" or "as the client has it", centres and ("%.2fyd"):format(plainNumber(centres)) or "?",
        plainNumber(br.functions.range:getEdgeDistance("player", unit) or 0),
        speed and ("%.1f"):format(plainNumber(speed)) or "?",
        clientAngle and (", the client's facing puts you %s off"):format(degrees(clientAngle)) or "",
        degrees(yourAngle)))
end

-- The game refused a BR cast with "Spell is not ready yet" (2026-10-31, TBC: Searing Totem sent about
-- 0.06 s after the client's GCD from Strength of Earth Totem ended; 2026-10-12, Forever: Faerie Fire
-- twice in one fight). The GCD and the spell's own cooldown BR saw at the send and now, the send
-- before it and the latency: a GCD only just over at the send points at the server's GCD ending later.
-- A buff's rank upgrade that didn't take (Functions/Cast/Tracking.lua cast:rankUpgradeWanted): what BR sent, what
-- the game calls the spell by name, what each "known" check says per rank, and the aura there
function br.debug.cast:noteUpgradeStuck(thisUnit, auraID, rankID, sentID, ago, ranks)
    local G, spellFns = br.game, br.functions.spell
    local name = spellFns:getName(rankID)
    local byName = spellFns:getSpellID(name)
    local parts, auraRank = {}, "?"
    for i, id in ipairs(type(ranks) == "table" and ranks or { ranks }) do
        if id == auraID then auraRank = tostring(i) end
        local function yes(v) return v and "y" or "n" end
        parts[#parts + 1] = ("r%d %d %s%s%s%s"):format(i, id, yes(G.IsPlayerSpell(id)), yes(G.IsSpellKnown and G.IsSpellKnown(id)),
            yes(spellFns:isSpellInSpellbook(id, "spell")), yes(spellFns:isKnown(id)))
    end
    castWrite(("RANK UPGRADE didn't take: %s on %s: rank %s (%d) still there %.1fs after BR sent %d (%s); the buff check wanted %d"
        .. " | the game by name: %s | per rank IsPlayerSpell/IsSpellKnown/spellbook/BR known: %s"):format(
        printable(name), unitName(thisUnit), auraRank, auraID, plainNumber(ago), sentID,
        byName == sentID and "by name" or "by ID", rankID, tostring(byName), table.concat(parts, ", ")))
end

-- yours: the player's own key press, not a spell BR sent (Functions/Cast/Tracking.lua)
function br.debug.cast:noteNotReady(spellID, yours)
    local now = br.game.GetTime()
    local spellFns = br.functions.spell
    local sent = lastSend and lastSend.spellID == spellID and lastSend or nil
    castWrite(("NOT READY %s%s: at the send%s GCD %s, its cooldown %s | now GCD %.2fs, its cooldown %.2fs | send before %s | latency %dms"):format(
        printable(spellFns:getName(spellID)), yours and " (your cast)" or "",
        sent and (" (%.2fs before)"):format(now - sent.at) or " (not BR's last send)",
        sent and ("%.2fs"):format(plainNumber(sent.gcd)) or "?", sent and ("%.2fs"):format(plainNumber(sent.cd)) or "?",
        plainNumber(spellFns:getGlobalCD() or 0), plainNumber(spellFns:getSpellCD(spellID) or 0),
        describeSend(sent and previousSend or lastSend, now), plainNumber(br.functions.misc:getHomeLatency() or 0) * 1000))
end

local inProgressText = br.game.SPELL_FAILED_SPELL_IN_PROGRESS or "Another action is in progress"
local castEvents = br.game.CreateFrame("Frame")
castEvents:RegisterEvent("UNIT_SPELLCAST_START")
castEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
castEvents:RegisterEvent("UNIT_SPELLCAST_DELAYED")
castEvents:RegisterEvent("UI_ERROR_MESSAGE")
castEvents:SetScript("OnEvent", function(_, event, a, b)
    if event == "UI_ERROR_MESSAGE" then
        if printable(b) ~= inProgressText then return end
        local now = br.game.GetTime()
        local casting, remain = currentCast(now)
        castWrite(("REFUSED (%s): casting %s | BR's last send %s, GCD then %.2fs, window %.2fs | send before that %s"):format(
            printable(b), casting and ("%s, %.2fs left"):format(casting, remain or -1) or "nothing",
            describeSend(lastSend, now), lastSend and lastSend.gcd or -1, lastSend and lastSend.window or -1,
            describeSend(previousSend, now)))
    elseif a == "player" then
        if event == "UNIT_SPELLCAST_DELAYED" then pushbacks = pushbacks + 1 else pushbacks = 0 end
    end
end)

----------------------------------------------------------------------------------------------------
-- Form recorder (diagnostic, 2026-10-15): before cast.<spell>() leaves a shapeshift form by itself,
-- the game's own signal that a form is what blocks a spell has to be confirmed. Form.log gets, once
-- per spell and form: a spell IsSpellUsable calls unusable in a form while power isn't the reason,
-- with whether it was usable out of form earlier this session (and a line when it is seen usable
-- out of form later); and each red error within 1 s of a BR send while in a form, with its error
-- type and whether its text is the game's SPELL_FAILED_NOT_SHAPESHIFT.
----------------------------------------------------------------------------------------------------
br.debug.form = br.debug.form or {}
local formWrite = br.log:file("Form.log", 300)
local usableOutOfForm = {} -- spell ID -> true: seen usable out of any form this session
local blockedInForm = {}   -- spell ID -> true: noted unusable in a form
local formNoted = {}       -- what has a line already

local function formName(form)
    if form == nil or form == 0 then return "no form" end
    local _, _, _, formSpellID = br.game.GetShapeshiftFormInfo(form)
    return ("%s (form %d)"):format(printable(formSpellID and br.functions.spell:getName(formSpellID)), form)
end

local function formContext()
    return ("flying %s, stealthed %s, combat %s"):format(tostring(br.game.IsFlying() and true or false),
        tostring(br.game.IsStealthed() and true or false), tostring(br.game.InCombatLockdown() and true or false))
end

-- Gates.lua, each time a spell's usability is read
function br.debug.form:noteUsable(spellID, isUsable, insufficientPower)
    local form = br.game.GetShapeshiftForm() or 0
    if form == 0 then
        if isUsable and not usableOutOfForm[spellID] then
            usableOutOfForm[spellID] = true
            if blockedInForm[spellID] then
                formWrite(("now usable out of form: %s %d"):format(printable(br.functions.spell:getName(spellID)), spellID))
            end
        end
        return
    end
    if isUsable ~= false or insufficientPower then return end
    -- crowd controlled, every spell is unusable whatever the form (2026-10-26: a fear listed 17)
    if br.functions.combat:hasHardControl() then return end
    local key = spellID .. ":" .. form
    if formNoted[key] then return end
    formNoted[key], blockedInForm[spellID] = true, true
    formWrite(("in %s: %s %d unusable, power fine | usable out of form earlier: %s | %s"):format(formName(form),
        printable(br.functions.spell:getName(spellID)), spellID, usableOutOfForm[spellID] and "yes" or "no", formContext()))
end

-- A form left for a spell (unit.cancelFormFor) that isn't what BR sends next (2026-10-19: Cat Form
-- left for Abolish Poison, then Cat Form cast again without it): what BR knew of that spell when
-- something else went out instead. Profile conditions (the poison still there, ...) aren't visible here.
local leftFormFor -- { spellID, at, form }
function br.debug.form:noteLeftFormFor(spellID)
    if spellID == nil then return end
    leftFormFor = { spellID = spellID, at = br.game.GetTime(), form = formName(br.game.GetShapeshiftForm()) }
end

-- A form left for a spell, then nothing sent at all (2026-11-07, Forever: Bear Form left for Healing Touch as a
-- fight ended, no Healing Touch, caster form for 18 s): once, LEFT_FORM_WAIT after leaving, what became of that
-- spell since (the profile didn't ask for it, BR refused it and why, or it passed), and the player's state.
local LEFT_FORM_WAIT = 3
local LEFT_FORM_FORGET = 30
function br.debug.form:watch()
    local left = leftFormFor
    if left == nil or left.waitNoted then return end
    local after = br.game.GetTime() - left.at
    if after > LEFT_FORM_FORGET then leftFormFor = nil return end
    if after < LEFT_FORM_WAIT then return end
    left.waitNoted = true
    local name = br.functions.spell:getName(left.spellID)
    local record = name and br.functions.cast:getRefusal(name)
    local fate
    if record and record.refusedAt and record.refusedAt >= left.at then
        fate = ("refused %s %s, %.1fs ago"):format(tostring(record.reason), printable(record.detail or ""),
            br.game.GetTime() - record.refusedAt)
    elseif record and record.passedAt and record.passedAt >= left.at then
        fate = ("passed BR's checks %.1fs ago, not sent"):format(br.game.GetTime() - record.passedAt)
    else
        fate = "the profile hasn't asked for it since"
    end
    formWrite(("left %s for %s, nothing sent %.1fs later | %s: %s | health %d%%, speed %.1f, combat %s, form %s, mana %d, GCD %.2fs"):format(
        left.form, printable(name), after, printable(name), fate, plainNumber(br.functions.unit:getHP("player") or 0),
        plainNumber(br.game.GetUnitSpeed("player") or 0), tostring(br.game.UnitAffectingCombat("player") and true or false),
        formName(br.game.GetShapeshiftForm()), plainNumber(br.game.UnitPower("player", 0) or 0),
        br.functions.spell:getGlobalCD() or 0))
end

-- Dispatch, just before each send
function br.debug.form:noteSendAfterLeaving(spellID)
    local left = leftFormFor
    if left == nil then return end
    leftFormFor = nil
    local spellFns = br.functions.spell
    local name = spellFns:getName(left.spellID)
    local after = br.game.GetTime() - left.at
    if after > 5 or name == nil or name == spellFns:getName(spellID) then return end
    local usable, noPower = br.game.C_Spell.IsSpellUsable(left.spellID)
    local cd = br.game.C_Spell.GetSpellCooldown and br.game.C_Spell.GetSpellCooldown(left.spellID)
    if type(cd) ~= "table" then cd = nil end
    local refusal = br.functions.cast:getRefusal(name)
    formWrite(("left %s for %s, then BR sent %s %.2fs later instead | %s then: usable %s%s, cooldown %s, GCD %.2fs, mana %d, form %s, last refusal %s"):format(
        left.form, printable(name), printable(spellFns:getName(spellID)), after, printable(name),
        tostring(usable and true or false), noPower and " (power)" or "",
        cd and ("%.1f/%.1f"):format(plainNumber(cd.startTime or 0), plainNumber(cd.duration or 0)) or "?",
        spellFns:getGlobalCD() or 0, plainNumber(br.game.UnitPower("player", 0) or 0), formName(br.game.GetShapeshiftForm()),
        refusal and ("%s %s, %.1fs ago"):format(tostring(refusal.reason), printable(refusal.detail or ""),
            br.game.GetTime() - (refusal.refusedAt or 0)) or "none"))
end

local notShapeshiftText = br.game.SPELL_FAILED_NOT_SHAPESHIFT
local formEvents = br.game.CreateFrame("Frame")
formEvents:RegisterEvent("UI_ERROR_MESSAGE")
formEvents:SetScript("OnEvent", function(_, _, errorType, message)
    local form = br.game.GetShapeshiftForm() or 0
    if form == 0 or lastSend == nil then return end
    local since = br.game.GetTime() - lastSend.at
    if since > 1 then return end
    local text = printable(message)
    local key = "error:" .. tostring(errorType) .. ":" .. lastSend.name .. ":" .. form
    if formNoted[key] then return end
    formNoted[key] = true
    formWrite(("error in %s %.2fs after BR sent %s: type %s, \"%s\" (%s SPELL_FAILED_NOT_SHAPESHIFT \"%s\") | %s"):format(
        formName(form), since, lastSend.name, printable(errorType), text,
        notShapeshiftText ~= nil and text == notShapeshiftText and "is" or "is not", printable(notShapeshiftText), formContext()))
end)

----------------------------------------------------------------------------------------------------
-- Loot recorder (diagnostic): the loot engine's lines, also in Loot.log, so a corpse looted twice
-- or a window BR didn't open can be read without Addon Debug Messages or a chat paste (2026-10-12:
-- "Looting Moonstalker" again 5 s after it was removed, with two Moonstalker corpses about).
-- br.debug.loot:tag(guid) gives the short corpse tag the lines use.
----------------------------------------------------------------------------------------------------
br.debug.loot = br.debug.loot or {}
local lootLine = br.log:file("Loot.log")

function br.debug.loot:line(text)
    lootLine(text)
end

-- "#" and the end of the GUID's spawn part: different corpses of the same mob get different tags
function br.debug.loot:tag(guid)
    if guid == nil then return "#?" end
    return "#" .. (printable(guid):match("(%x%x%x%x%x%x)$") or "?")
end

----------------------------------------------------------------------------------------------------
-- Imbue recorder (diagnostic, 2026-10-25): unit.weaponImbue.exists accepts any temporary enchant
-- on the hand when none of the imbue's listed enchant IDs match, so a wrong ID in a list can't
-- make BR reapply the imbue forever. Imbue.log gets, once per hand and enchant ID, each time that
-- fallback is used: the enchant the weapon has and the IDs the list gave, to correct the lists.
----------------------------------------------------------------------------------------------------
br.debug.imbue = br.debug.imbue or {}
local imbueWrite = br.log:file("Imbue.log", 100)
local imbueNoted = {}

-- Functions/Item.lua: an imbue BR cast showed up on a hand with this enchant ID (learned for the session)
function br.debug.imbue:noteLanded(key, hand, enchantID, listed)
    imbueWrite(("%s landed on the %s as enchant %s (%s)"):format(
        printable(br.functions.spell:getKeyName(key) or key), hand, tostring(enchantID),
        listed and "in the list: confirmed in game" or "not in the list: the list can take this ID"))
end

-- Functions/Item.lua: an imbue BR cast showed on neither hand: that weapon doesn't hold it
function br.debug.imbue:noteWontTake(key, itemID)
    imbueWrite(("%s showed on no weapon; item %s doesn't hold it (not cast on it again this session)"):format(
        printable(br.functions.spell:getKeyName(key) or key), tostring(itemID)))
end

-- API/Unit.lua, when the presence-only fallback answers
function br.debug.imbue:noteUnlisted(offHand, enchantID, listed)
    local hand = offHand and "off hand" or "main hand"
    local key = hand .. ":" .. tostring(enchantID)
    if imbueNoted[key] then return end
    imbueNoted[key] = true
    local ids = {}
    for i = 1, #listed do ids[i] = tostring(listed[i]) end
    local spells = {}
    for i = 1, #(listed.spells or {}) do spells[i] = tostring(listed.spells[i]) end
    imbueWrite(("%s enchant %s is not in the list {%s} (spells {%s}); counted as the imbue"):format(hand,
        tostring(enchantID), table.concat(ids, ","), table.concat(spells, ",")))
end

----------------------------------------------------------------------------------------------------
-- Aggro recorder (2026-11-08): what radius Forever's mobs really aggro at, to tune unit:getAggroRange
-- (18 yd +/- level, centre to centre, from the Classic emulators). When you enter combat, every enemy
-- within 45 yd is measured at once; half a second later, the ones attacking you go to Aggro.log with that
-- distance, the level gap and how long since you last cast or started a swing. A pull with nothing of yours
-- just before it (no cast, no swing, not stealthed) is a proximity aggro: its distance is the radius.
----------------------------------------------------------------------------------------------------
local aggroLine = br.log:file("Aggro.log", 400)
local AGGRO_SCAN, AGGRO_ANSWER = 45, 0.5
local lastOwnAction, lastOwnWhat = 0, "nothing"
local aggroEvents = br.game.CreateFrame("Frame")
aggroEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
aggroEvents:RegisterEvent("UNIT_SPELLCAST_SENT")
aggroEvents:RegisterEvent("PLAYER_ENTER_COMBAT")
aggroEvents:SetScript("OnEvent", function(_, event, a, _, _, d)
    local now = br.game.GetTime()
    if event == "UNIT_SPELLCAST_SENT" then
        -- the payload can be secret on Forever: a secret compare throws, so pcall, and count it as a cast anyway
        local okSent, isPlayer = pcall(function() return a == "player" end)
        if not okSent or isPlayer then
            local spellID = okSent and plainNumber(d) or nil
            lastOwnAction, lastOwnWhat = now, printable(spellID and br.functions.spell:getName(spellID) or "a cast")
        end
        return
    end
    if event == "PLAYER_ENTER_COMBAT" then
        lastOwnAction, lastOwnWhat = now, "auto attack"
        return
    end
    local ok, err = pcall(function()
        local unitFns, rangeFns = br.functions.unit, br.functions.range
        local sinceOwn = now - lastOwnAction
        local own = lastOwnWhat
        local stealthed = br.game.IsStealthed and br.game.IsStealthed() and true or false
        local playerLevel = plainNumber(br.game.UnitLevel("player")) or 0
        local seen = {}
        local nearby = br.engines.enemiesEngineFunctions:getEnemies("player", AGGRO_SCAN, true)
        for i = 1, #nearby do
            local u = nearby[i]
            local centre, flat, dz = rangeFns:getCenterDistance("player", u)
            if centre then
                seen[#seen + 1] = { unit = u, centre = centre, flat = flat, dz = dz or 0,
                    edge = rangeFns:getEdgeDistance("player", u) or centre,
                    level = plainNumber(br.game.UnitLevel(u)) or 0,
                    reaction = plainNumber(unitFns:GetUnitReaction(u, "player")) or 0,
                    facesYou = unitFns:getFacing(u, "player") and true or false,
                    radius = unitFns:getAggroRange(u) }
            end
        end
        br.game.C_Timer.After(AGGRO_ANSWER, function()
            pcall(function()
                for _, m in ipairs(seen) do
                    local itsTarget = unitFns:GetObjectExists(m.unit) and unitFns:getTarget(m.unit)
                    if itsTarget and unitFns:GetUnitIsUnit(itsTarget, "player") then
                        local likelyProximity = sinceOwn > 2 and not stealthed
                        aggroLine(("%s %s lvl %d (you %d, gap %+d) %s: centre %.1f yd (flat %.1f, height %+.1f), edge %.1f, BR radius %d | your last action: %s %.1f s before%s%s"):format(
                            likelyProximity and "PROXIMITY?" or "pulled   ", unitName(m.unit), m.level, playerLevel,
                            m.level - playerLevel, m.reaction == 4 and "neutral" or (m.reaction < 4 and "hostile" or "other"),
                            m.centre, m.flat, m.dz, m.edge, m.radius, own, sinceOwn,
                            stealthed and " | you were stealthed" or "",
                            m.facesYou and " | it faced you" or " | it faced away"))
                    end
                end
            end)
        end)
    end)
    if not ok then aggroLine("aggro snapshot failed: " .. printable(err)) end
end)
