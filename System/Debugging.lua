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

----------------------------------------------------------------------------------------------------
-- /br target: the enemy BR focuses on and why (br.engines.targeting:explain), in chat and Target.log
----------------------------------------------------------------------------------------------------
br.debug.target = br.debug.target or {}
local targetLine = br.log:file("Target.log")
local TARGET_REPORT_UNITS = 6

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

-- Auto attack starts (2026-10-28): BR sent StartAttack twice, 0.3-0.5 s apart, whenever it went out with
-- a cast nearly done, as PLAYER_ENTER_COMBAT hadn't come a round trip after the cast's end. Each start BR
-- sends (15 a session) writes, once the game says auto attack is on or 2 s after the cast's end, how much
-- cast was left at the send, when the game answered and any resends: whether a start sent during a cast
-- is dropped follows from it.
local ATTACK_START_LINES, ATTACK_START_WAIT = 15, 2
local attackStart, attackStartLines = nil, 0 -- { sentAt, castLeft, resends = { seconds after the first } }

local function attackStartLine(answeredAt)
    local a = attackStart
    attackStart = nil
    attackStartLines = attackStartLines + 1
    local resends = {}
    for i, after in ipairs(a.resends) do resends[i] = ("%.2fs"):format(after) end
    local answer = ("no answer in %ds"):format(ATTACK_START_WAIT)
    if answeredAt then
        answer = ("game said on %.2fs after the first send"):format(answeredAt - a.sentAt)
        if a.castLeft > 0 then answer = answer .. (", %.2fs after the cast's end"):format(answeredAt - a.sentAt - a.castLeft) end
    end
    meleeLine(("AUTO ATTACK START sent %s | %s | resent %s"):format(
        a.castLeft > 0 and ("with %.2fs of a cast left"):format(a.castLeft) or "with no cast", answer,
        #resends > 0 and (table.concat(resends, ", ") .. " after the first") or "never"))
end

-- unit:startAttack sent StartAttack. castLeft: seconds left on the player's cast or channel (0 for none).
function br.debug.melee:noteAttackSent(castLeft)
    if attackStartLines >= ATTACK_START_LINES then return end
    local now = br.game.GetTime()
    if attackStart then
        attackStart.resends[#attackStart.resends + 1] = now - attackStart.sentAt
    else
        attackStart = { sentAt = now, castLeft = castLeft, resends = {} }
    end
end

-- PLAYER_ENTER_COMBAT: the game says auto attack is on
function br.debug.melee:noteAttackOn()
    if attackStart then attackStartLine(br.game.GetTime()) end
end

local function watchAttackStart(now)
    if attackStart and now - attackStart.sentAt - attackStart.castLeft > ATTACK_START_WAIT then attackStartLine(nil) end
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
    if idleLogged or now - lastActionAt < IDLE_AFTER then return end
    if #br.engines.enemiesEngineFunctions:getEnemies("player", 8) == 0 then return end
    -- swinging at a target in melee isn't idle
    local targetDist = br.game.UnitExists("target") and br.functions.range:getDistance("target") or 99
    if br.functions.unit:isAutoAttacking() and targetDist < 5 then return end
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
            idleLine(("    %s %.1fyd: %.1f = %s"):format(unitName(list[i].unit), plainNumber(list[i].distance or 0),
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
    lastSend = { name = printable(br.functions.spell:getName(spellID)), at = now, behind = behind, remain = remain,
        window = br.functions.cast:getQueueWindow(), gcd = br.functions.spell:getGlobalCD() or 0, pushbacks = pushbacks }
    if behind then
        castWrite(("pre-cast %s behind %s: %.2fs left, window %.2fs, GCD %.2fs, pushbacks %d, latency %dms | previous send %s"):format(
            lastSend.name, behind, remain or -1, lastSend.window, lastSend.gcd, pushbacks,
            plainNumber(br.functions.misc:getHomeLatency() or 0) * 1000, describeSend(previousSend, now)))
    end
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
    castWrite(("NOT BEHIND %s → %s: BR's check said %s | its target %s, unit flags %s | you stand %s off its facing (%s), centres %s apart, edge %.1fyd%s | it moving %s yd/s%s | it is %s off your facing"):format(
        printable(br.functions.spell:getName(spellID)), unitName(unit),
        facing == false and "behind" or facing == true and "in front" or "unknown",
        targetsYou and "you" or (victim == nil and "none" or "not you"),
        type(flags) == "number" and ("0x%08X"):format(plainNumber(flags)) or "?",
        degrees(angle), fromTarget and "towards its target" or "as the client has it", centres and ("%.2fyd"):format(plainNumber(centres)) or "?",
        plainNumber(br.functions.range:getEdgeDistance("player", unit) or 0),
        br.game.ObjectIsFacing ~= nil and ", unlocker facing check" or "",
        speed and ("%.1f"):format(plainNumber(speed)) or "?",
        clientAngle and (", the client's facing puts you %s off"):format(degrees(clientAngle)) or "",
        degrees(yourAngle)))
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
