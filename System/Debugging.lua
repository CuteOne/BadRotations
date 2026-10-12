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
-- <SECRET> (and can't be written to a file). BR may compare them, so they're rebuilt from comparisons.

-- The whole number 0..max that value (scaled) rounds down to, found by halving
local function plainInteger(value, max)
    local low, high = 0, max
    while low < high do
        local mid = math.floor((low + high + 1) / 2)
        if value >= mid then low = mid else high = mid - 1 end
    end
    return low
end

-- A flagged number, to the nearest 0.01
local function plainNumber(value)
    if not isFlagged(value) then return value end
    if value < 0 then return -plainInteger(-value * 100, 10000000) / 100 end
    return plainInteger(value * 100, 10000000) / 100
end

-- Flagged text, byte by byte
local function plainText(text)
    if not isFlagged(text) then return text end
    local bytes = {}
    for i = 1, plainInteger(#text, 4096) do bytes[i] = string.char(plainInteger(text:byte(i), 255)) end
    return table.concat(bytes)
end

local function printable(value)
    if value == nil then return "?" end
    if type(value) == "string" then return plainText(value) end
    return tostring(value)
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
    local meleeSpell, listKey = range:getMeleeSpellName()
    keep("meleeSpell", meleeSpell)
    m.listKey = listKey or "no melee list"
    if m.meleeSpell then keep("meleeGame", br._G.C_Spell.IsSpellInRange(m.meleeSpell, "target")) end
    -- Auto Attack's range is the melee check itself, in any form
    local autoAttack = br.functions.spell:getHighestSpellID("autoAttack")
    if autoAttack then keep("autoGame", br._G.C_Spell.IsSpellInRange(autoAttack, "target")) end
    m.spell, m.spellRange = rangedTestSpell()
    if m.spell then
        m.spellBR = range:getEdgeDistance("player", "target") <= m.spellRange
        keep("spellGame", br._G.C_Spell.IsSpellInRange(m.spell, "target"))
    end
    m.flagged = flagged
    return m
end

-- Logs in the unlocker's folder (GetWoWDirectory), e.g. BRMelee.log: written for Claude to read
-- between sessions, since chat copy windows show <SECRET> on Forever. A line is added to what the
-- file holds now (read afresh each time, so lines removed from the file while the game runs stay
-- removed; unlockers' WriteFile can't append), and the file keeps its newest LOG_MAX_BYTES.
-- Each session's first line in a file is a dated header. Returns the function that adds a line.
local LOG_MAX_BYTES = 262144
local function fileLog(fileName)
    local sessionStarted = false
    return function(text)
        if br._G.WriteFile == nil or br._G.ReadFile == nil or br._G.GetWoWDirectory == nil then return end
        local path = br._G.GetWoWDirectory() .. "\\" .. fileName
        local line = ("%.1f "):format(br._G.GetTime()) .. plainText(text):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        if not sessionStarted then
            sessionStarted = true
            line = "=== session " .. (br._G.date and br._G.date("%Y-%m-%d %H:%M") or "?") .. " ===\n" .. line
        end
        local ok, current = pcall(br._G.ReadFile, path)
        if not ok or type(current) ~= "string" then current = "" end
        local content = current .. line .. "\n"
        if #content > LOG_MAX_BYTES then
            local cut = content:find("\n", #content - LOG_MAX_BYTES / 2, true)
            content = content:sub((cut or 0) + 1)
        end
        pcall(br._G.WriteFile, path, content, false)
    end
end

-- Every line also goes to BRRange.log
local rangeLine = fileLog("BRRange.log")
local function say(text)
    br._G.print("|cffFFDD11[BR range]|r " .. text)
    rangeLine(text)
end

local function snapshot()
    local m = measure()
    if m == nil then return say("Target something first.") end
    say("Target: " .. printable(br._G.UnitName("target")) .. (m.leeway > 0 and "  (both running: +2.67 melee leeway)" or ""))
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
    if arg ~= "watch" then return br._G.C_Timer.After(0, snapshot) end
    if rangeWatch then rangeWatch:Cancel() end
    local last, stopAt = nil, br._G.GetTime() + 120
    say("Watching the target for 2 minutes (/br range stop to end). Walk in and out of range.")
    rangeWatch = br._G.C_Timer.NewTicker(0.1, function()
        if br._G.GetTime() > stopAt then rangeWatch:Cancel(); rangeWatch = nil; return say("Stopped (2 minutes).") end
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

----------------------------------------------------------------------------------------------------
-- /br target: the enemy BR focuses on and why (br.engines.targeting:explain), in chat and BRTarget.log
----------------------------------------------------------------------------------------------------
br.debug.target = br.debug.target or {}
local targetLine = fileLog("BRTarget.log")
local TARGET_REPORT_UNITS = 6

-- reason (optional): why an automatic report was made (written to the log only, not chat); units:
-- how many candidates to list
function br.debug.target:report(reason, units)
    units = units or TARGET_REPORT_UNITS
    local function say(text)
        if reason == nil then br._G.print("|cffFFDD11[BR target]|r " .. text) end
        targetLine(text)
    end
    if reason then say("--- " .. reason .. " ---") end
    if not (br.engines.targeting and br.engines.targeting.explain) then return say("Targeting isn't loaded.") end
    local misc = br.functions.misc
    local focus, list = br.engines.targeting:explain()
    say(("Targeting Mode %s (1 Off, 2 Assist, 3 Full) | your target: %s"):format(tostring(misc:getValue("Targeting Mode")),
        br._G.UnitExists("target") and printable(br._G.UnitName("target")) or "none"))
    if #list == 0 then return say("No enemy BR may attack.") end
    say("Focus: " .. (focus and printable(br._G.UnitName(focus)) or "none"))
    for i = 1, math.min(units, #list) do
        local entry = list[i]
        local parts = {}
        for _, part in ipairs(entry.parts) do parts[#parts + 1] = ("%s %.1f"):format(part[1], plainNumber(part[2])) end
        say(("%d. %s %.1fyd: %.1f = %s"):format(i, printable(br._G.UnitName(entry.unit)), plainNumber(entry.distance or 0),
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
    if not br._G.UnitAffectingCombat("player") or not br.engines.targeting then
        autoCount, lastFocus, lastTargetGUID = 0, nil, nil
        return
    end
    local now = br._G.GetTime()
    local focus = br.engines.targeting:getFocus()
    local guid = br._G.UnitGUID("target")
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
-- enemy is in melee, writes what BR saw and did to BRMelee.log, with nothing to switch on. Called by
-- Player:startRotation after the rotation runs. Looks into the 2026-10-12 report of standing idle when
-- the target fled while a second mob stayed in melee.
----------------------------------------------------------------------------------------------------
br.debug.melee = br.debug.melee or {}
local meleeLine = fileLog("BRMelee.log")
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
    local text = ("%s %.1fyd %s"):format(printable(br._G.UnitName(u)), plainNumber(d or 99),
        unitFns:getFacing("player", u) and "in front" or "not in front")
    if unitFns:GetUnitIsUnit(u, "target") then text = text .. " (target)" end
    return text
end

-- Game messages during an episode (spell failures, red error text)
local meleeEvents = br._G.CreateFrame("Frame")
meleeEvents:RegisterEvent("UI_ERROR_MESSAGE")
meleeEvents:RegisterEvent("UNIT_SPELLCAST_FAILED")
meleeEvents:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
meleeEvents:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
-- UI_ERROR_MESSAGE: errorType, message; UNIT_SPELLCAST_*: unit, castGUID, spellID
meleeEvents:SetScript("OnEvent", function(_, event, a, b, c, ...)
    -- Monster emotes in combat, episode or not: the flee emote's wording in this client's language
    -- (br.lists.fleeEmotes) and whether BR can read it
    if event == "CHAT_MSG_MONSTER_EMOTE" then
        if not br._G.UnitAffectingCombat("player") then return end
        local guid = select(9, ...) -- payload 12
        local ok, entry = pcall(function() return br.lists.fleeEmotes[a] end)
        local known = ok and entry and true or false
        local fromTarget = guid ~= nil and guid == br._G.UnitGUID("target")
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

local function meleeState(player)
    local units = player and player.units
    local parts = {
        "target " .. meleeUnit("target"),
        "BR melee pick (dyn5) " .. (units and units.dyn5 and meleeUnit(units.dyn5) or "none"),
        "auto attack " .. (br.functions.unit:isAutoAttacking() and "on" or "off"),
        "target fleeing " .. tostring(br.functions.unit:isFleeing("target")),
    }
    -- The target's unit flags where the unlocker reads them (to confirm the fleeing bit, 0x00800000
    -- on TrinityCore-era servers, before br.api.fleeingUnitFlag is set)
    if br._G.UnitFlags then
        local ok, flags = pcall(br._G.UnitFlags, "target")
        if ok and type(flags) == "number" then
            if isFlagged(flags) then flags = plainInteger(flags, 4294967295) end
            parts[#parts + 1] = ("target flags 0x%08X"):format(flags)
        end
    end
    return table.concat(parts, " | ")
end

local meleeEnvironmentLogged = false
function br.debug.melee:watch(player)
    local now = br._G.GetTime()
    -- Once a session: client facts the fleeing and eating checks depend on
    if not meleeEnvironmentLogged then
        meleeEnvironmentLogged = true
        meleeWrite("client: locale " .. tostring(br._G.GetLocale and br._G.GetLocale())
            .. " | AuraUtil.UnpackAuraData " .. tostring(_G.AuraUtil ~= nil and _G.AuraUtil.UnpackAuraData ~= nil)
            .. " | unlocker UnitFlags " .. tostring(br._G.UnitFlags ~= nil))
        -- Names in the unlocker's own API that could read unit flags, so an adapter can map
        -- br._G.UnitFlags
        local raw = br.unlockers.raw
        if type(raw) == "table" then
            local names = {}
            pcall(function()
                for name in pairs(raw) do
                    if type(name) == "string" and (name:find("[Ff]lag") or name:find("[Ff]ield") or name:find("[Dd]escriptor")) then
                        names[#names + 1] = name
                    end
                end
            end)
            table.sort(names)
            meleeWrite("unlocker " .. tostring(br.unlockers.selected) .. " API: " .. (#names > 0 and table.concat(names, ", ") or "no flag/field names listed"))
        end
    end
    local active = false
    local inMelee
    if br._G.UnitAffectingCombat("player") and br._G.UnitExists("target") then
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
            meleeWrite("  " .. meleeState(player))
        end
        episode.lastSeen = now
        if now - episode.lastSnap >= 1 then
            local decisions = {}
            br.functions.cast:eachDecisionSince(episode.lastSnap, function(name, reason)
                if #decisions < 8 then decisions[#decisions + 1] = printable(name) .. (reason and (" refused " .. reason) or " passed") end
            end)
            episode.lastSnap = now
            meleeWrite(("  +%.1fs %s"):format(now - episode.started, meleeState(player)))
            if #decisions > 0 then meleeWrite("    BR: " .. table.concat(decisions, ", ")) end
            if #episode.events > 0 then
                meleeWrite("    game: " .. table.concat(episode.events, ", "))
                br._G.wipe(episode.events)
            end
        end
    elseif episode and now - episode.lastSeen > 1.5 then
        local how
        if not br._G.UnitAffectingCombat("player") then how = "combat ended"
        elseif not br._G.UnitExists("target") then how = "no target"
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
-- to BRIdle.log: target, BR's picks and scores, what the cast engine passed or refused, game errors.
-- Called by Player:startRotation after the rotation.
----------------------------------------------------------------------------------------------------
br.debug.idle = br.debug.idle or {}
local idleLine = fileLog("BRIdle.log")
local IDLE_AFTER = 4
local lastActionAt, idleLogged, idleInCombat = 0, false, false
local idleRuns = 0 -- ticks the rotation ran (not paused) since the last action
local idleErrors = {}

local idleEvents = br._G.CreateFrame("Frame")
idleEvents:RegisterEvent("UNIT_SPELLCAST_START")
idleEvents:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
idleEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
idleEvents:RegisterEvent("UI_ERROR_MESSAGE")
idleEvents:SetScript("OnEvent", function(_, event, a, b)
    if event == "UI_ERROR_MESSAGE" then
        if #idleErrors < 10 then idleErrors[#idleErrors + 1] = printable(b) end
    elseif a == "player" then
        lastActionAt, idleLogged, idleRuns = br._G.GetTime(), false, 0
        br._G.wipe(idleErrors)
    end
end)

function br.debug.idle:watch(player, paused)
    local now = br._G.GetTime()
    if not br._G.UnitAffectingCombat("player") then
        idleInCombat = false
        return
    end
    -- the clock starts when the fight does (also after a /reload mid-fight), and again when a
    -- pause ends: a paused rotation isn't idle
    if not idleInCombat or paused then
        idleInCombat, lastActionAt, idleLogged, idleRuns = true, now, false, 0
        return
    end
    idleRuns = idleRuns + 1
    if idleLogged or now - lastActionAt < IDLE_AFTER then return end
    if #br.engines.enemiesEngineFunctions:getEnemies("player", 8) == 0 then return end
    -- swinging at a target in melee isn't idle
    local targetDist = br._G.UnitExists("target") and br.functions.range:getDistance("target") or 99
    if br.functions.unit:isAutoAttacking() and targetDist < 5 then return end
    idleLogged = true
    local units = player and player.units
    local spec = br.data and br.data.settings and br.data.settings[br.loader.selectedSpec]
    idleLine(("=== idle %.1fs in combat ==="):format(now - lastActionAt))
    idleLine("  target " .. (br._G.UnitExists("target") and (printable(br._G.UnitName("target")) .. (" %.1fyd"):format(plainNumber(targetDist))) or "none")
        .. " | dyn5 " .. (units and units.dyn5 and printable(br._G.UnitName(units.dyn5)) or "none")
        .. " | auto attack " .. (br.functions.unit:isAutoAttacking() and "on" or "off")
        .. " | paused toggle " .. tostring(spec and spec.toggles and spec.toggles["Pause"]))
    local decisions = {}
    if br.functions.cast.eachDecisionSince then br.functions.cast:eachDecisionSince(lastActionAt, function(name, reason, detail)
        if #decisions < 15 then
            decisions[#decisions + 1] = printable(name) .. (reason and (" refused " .. reason .. (detail and (" (" .. printable(tostring(detail)):sub(1, 40) .. ")") or "")) or " passed")
        end
    end) end
    idleLine("  BR since the last action: " .. (#decisions > 0 and table.concat(decisions, ", ") or "nothing tried"))
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
        plainNumber(br._G.UnitPower("player", 0) or 0), plainNumber(br._G.UnitPower("player", 1) or 0),
        plainNumber(br._G.UnitPower("player", 3) or 0)))
    idleLine("  toggles: " .. (#toggleParts > 0 and table.concat(toggleParts, ", ") or "none"))
    if br.engines.targeting then
        local focus, list = br.engines.targeting:explain()
        idleLine("  focus " .. (focus and printable(br._G.UnitName(focus)) or "none") .. ", candidates:")
        for i = 1, math.min(3, #list) do
            local parts = {}
            for _, part in ipairs(list[i].parts) do parts[#parts + 1] = ("%s %.1f"):format(part[1], plainNumber(part[2])) end
            idleLine(("    %s %.1fyd: %.1f = %s"):format(printable(br._G.UnitName(list[i].unit)), plainNumber(list[i].distance or 0),
                plainNumber(list[i].score), table.concat(parts, ", ")))
        end
    end
end

----------------------------------------------------------------------------------------------------
-- Combo point probe (diagnostic): are combo points kept on the target (Classic) or on the player
-- (Retail since 6.0.2)? Forever's tooltips list them as a cost like Retail's, unconfirmed. When the
-- target changes while the player has combo points, BRMelee.log gets the points before and after,
-- read both ways (GetComboPoints on the target, and the player's ComboPoints power, type 4).
-- br.api.comboPointsOnTarget (Expansions/<Name>) follows the answer.
----------------------------------------------------------------------------------------------------
local comboBefore, comboPowerBefore = 0, 0
local comboLogged = 0
local function readCombo()
    local onTarget = br._G.GetComboPoints and tonumber(br._G.GetComboPoints("player", "target")) or 0
    local power = br._G.UnitPower and tonumber(br._G.UnitPower("player", 4)) or 0
    return plainNumber(onTarget or 0), plainNumber(power or 0)
end
local comboFrame = br._G.CreateFrame("Frame")
comboFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
comboFrame:SetScript("OnEvent", function()
    if comboLogged >= 20 or (comboBefore <= 0 and comboPowerBefore <= 0) then return end
    comboLogged = comboLogged + 1
    local onTarget, power = readCombo()
    meleeWrite(("combo points on a target switch: before %d on the target / %d as power -> after %d on the new target / %d as power (on-target flag %s)"):format(
        comboBefore, comboPowerBefore, onTarget, power, tostring(br.api.comboPointsOnTarget)))
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
local castLine = fileLog("BRCast.log")
local CAST_LOG_CAP = 150 -- lines per session
local castLogged = 0
local lastSend, previousSend -- { name, at, behind, remain, window, gcd, pushbacks }
local pushbacks = 0          -- UNIT_SPELLCAST_DELAYED on the player's current cast

local function castWrite(text)
    if castLogged >= CAST_LOG_CAP then return end
    castLogged = castLogged + 1
    castLine(text)
end

-- The player's cast or channel: name, seconds left
local function currentCast(now)
    local name, _, _, _, endMS = br._G.UnitCastingInfo("player")
    if name == nil then name, _, _, _, endMS = br._G.UnitChannelInfo("player") end
    if name == nil then return nil end
    return printable(name), endMS and (plainNumber(endMS) / 1000 - now) or nil
end

local function describeSend(send, now)
    if send == nil then return "none" end
    return ("%s %.2fs ago%s"):format(send.name, now - send.at,
        send.behind and (" behind %s with %.2fs left"):format(send.behind, send.remain or -1) or "")
end

function br.debug.cast:noteSend(spellID)
    local now = br._G.GetTime()
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

-- A cast by name the game refused with a Lua error (cast:castByName). The error report's stack is
-- secret on Forever, so the call site and arguments are written here instead: the first few per
-- call site, then a count every 100th.
local sendErrors = {}
function br.debug.cast:noteSendError(name, unit, err)
    local site = printable(br._G.debugstack and br._G.debugstack(3, 1, 0) or "?"):gsub("%s+$", "")
    local seen = (sendErrors[site] or 0) + 1
    sendErrors[site] = seen
    if seen > 3 and seen % 100 ~= 0 then return end
    castWrite(("SEND ERROR #%d from %s: name %s (%s), unit %s (%s), exists %s | %s"):format(
        seen, site, printable(name), type(name), printable(unit), type(unit),
        tostring(unit ~= nil and br._G.UnitExists(unit) or nil), printable(err)))
end

local inProgressText = br._G.SPELL_FAILED_SPELL_IN_PROGRESS or "Another action is in progress"
local castEvents = br._G.CreateFrame("Frame")
castEvents:RegisterEvent("UNIT_SPELLCAST_START")
castEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
castEvents:RegisterEvent("UNIT_SPELLCAST_DELAYED")
castEvents:RegisterEvent("UI_ERROR_MESSAGE")
castEvents:SetScript("OnEvent", function(_, event, a, b)
    if event == "UI_ERROR_MESSAGE" then
        if printable(b) ~= inProgressText then return end
        local now = br._G.GetTime()
        local casting, remain = currentCast(now)
        castWrite(("REFUSED (%s): casting %s | BR's last send %s, GCD then %.2fs, window %.2fs | send before that %s"):format(
            printable(b), casting and ("%s, %.2fs left"):format(casting, remain or -1) or "nothing",
            describeSend(lastSend, now), lastSend and lastSend.gcd or -1, lastSend and lastSend.window or -1,
            describeSend(previousSend, now)))
    elseif a == "player" then
        if event == "UNIT_SPELLCAST_DELAYED" then pushbacks = pushbacks + 1 else pushbacks = 0 end
    end
end)
