local _, br = ...
--- Core: BR's rotating body
-- One frame loop. It runs the startup stages (System/Bootstrap.lua) every frame; once an unlocker is
-- found it runs the frame steps every frame, and once the rotation is built it runs the tick steps at
-- the Bot Update Rate. Core decides only whether BR may run; what each step does belongs to the module
-- that registered it (br.lifecycle, BadRotations.lua).
--   frame steps   fn(elapsed, active): active is false while Power is off or values are hidden
--                 10 enemies engine (Engines/EnemiesEngine.lua)  20 object tracker (Engines/Tracker.lua)
--   tick steps    run only while Power is on and values are readable; a step returning true ends
--                 the tick there
--                 1 dev mode (Misc/Debug.lua)  5 expansion work (Expansions/Retail: quaking, bait)
--                 10 queued casts (Cast/CastFunction.lua)  15 smart queue (SmartQueue.lua)
--                 20 healing engine (HealingEngine.lua)  50 the rotation (Loader/Rotation.lua)
--                 60 auto loot (LootEngine.lua)  70 main button (UI/Toggles/Toggles.lua)
--                 75 healer line of sight (HealingEngineFunctions.lua)  80 boss mod timers (Custom.lua)
--                 85 dungeon queues (Misc/Player.lua)  90 profession helper (Misc/ProfessionHelper)
--   powerOff      once when the player switches Power off: 10 queued casts  20 BR's windows (UI/ui.lua)
--                 30 drawings (Engines/Tracker.lua)
br.core = br.core or {}
local core = br.core

-- Auto Delay keeps BR's own work to a share of real time: when a tick (the rotation plus the
-- enemies engine, which run at this rate) gets expensive, ticks are spaced out just enough to stay
-- within the share. A cheap BR keeps the Bot Update Rate even when the scene drags FPS down; an
-- expensive one backs off in proportion. (It used to slow BR by FPS alone, (60 - FPS) / 60, which
-- made BR slowest in busy fights whatever its own share of the frame.)
local AUTO_DELAY_SHARE = 0.10 -- at most 10% of real time spent in BR
local AUTO_DELAY_MAX   = 0.5  -- never more than this between ticks
core.tickCost = { rotation = 0, enemies = 0 } -- running averages, milliseconds per tick

--- Folds one measured tick (milliseconds) of a part ("rotation", "enemies") into its running average.
function core:recordTickCost(part, ms)
    local costs = self.tickCost
    costs[part] = costs[part] * 0.8 + ms * 0.2
end

-- Worked out once per frame: the frame steps ask every frame
local updateRateAt, updateRateValue
--- Seconds between ticks: the Bot Update Rate, stretched by Auto Delay.
function core:getUpdateRate()
    local now = br.game.GetTime()
    if updateRateAt == now then return updateRateValue end
    local updateRate = br.functions.misc:getValue("Bot Update Rate") or 0.1
    if br.functions.misc:isChecked("Auto Delay") then
        local costSeconds = (self.tickCost.rotation + self.tickCost.enemies) / 1000
        updateRate = math.max(updateRate, math.min(AUTO_DELAY_MAX, costSeconds / AUTO_DELAY_SHARE))
    end
    updateRateAt, updateRateValue = now, updateRate
    return updateRate
end

-- The Power toggle of the current spec (nil until the toggle bar exists)
local function powerToggle()
    local settings = br.data.settings[br.loader.selectedSpec]
    return settings and settings.toggles and settings.toggles["Power"]
end

--- True when the player has Power on.
function core:isPowerOn() return powerToggle() == 1 end

--- True when the player has switched Power off (not before the toggle bar exists).
function core:isPowerOff()
    local power = powerToggle()
    return power ~= nil and power ~= 1
end

-- Loading screens: nothing runs during one, and the rotation waits a moment after it so aura data
-- has arrived (core:isSettling, Loader/Player.lua)
local SETTLE_SECONDS = 3
core.loading = false
local settledAt = 0
--- True for a moment after a loading screen.
function core:isSettling() return br.game.GetTime() < settledAt end

local loadingScreen = br.game.CreateFrame("Frame")
loadingScreen:RegisterEvent("LOADING_SCREEN_ENABLED")
loadingScreen:RegisterEvent("LOADING_SCREEN_DISABLED")
loadingScreen:SetScript("OnEvent", function(_, event)
    core.loading = event == "LOADING_SCREEN_ENABLED"
    if not core.loading then settledAt = br.game.GetTime() + SETTLE_SECONDS end
end)

-- Perf.log: whether BR is behind a stutter (user report 2026-11-06, on Veil). Always on and cheap (two clock reads
-- per frame step). Lines:
--   HITCH   a gap of HITCH_SECONDS or more between two frames, with what BR did in the frame before it and whether
--           the log files were written in that gap: a hitch with little BR time in it isn't BR's
--   SPIKE   BR's own work in one frame took SPIKE_MS or more, by step
--   FLUSH   writing the log files took FLUSH_MS or more (they're written once a second, System/Logging.lua)
--   minute  once a minute: FPS, BR's milliseconds per frame (average, worst, share of real time), spikes, hitches,
--           log writes
local HITCH_SECONDS, SPIKE_MS, FLUSH_MS, SUMMARY_SECONDS = 0.1, 10, 5, 60
local perfWrite
local function perfLine(text)
    perfWrite = perfWrite or (br.log and br.log.file and br.log:file("Perf.log", 400))
    if perfWrite then perfWrite(text) end
end
local perf = { timing = {}, lastTiming = {}, lastTotal = 0, flushAt = 0 }
local function perfReset(now)
    perf.since, perf.frames, perf.brTotal, perf.brMax, perf.spikes, perf.hitches, perf.hitchMax = now, 0, 0, 0, 0, 0, 0
    perf.flushes, perf.flushTotal, perf.flushMax = 0, 0, 0
end
-- The steps that took at least 0.5 ms, longest first, and the rest of BR's time in that frame ("other")
local function perfSteps(timing, total)
    local list, counted = {}, 0
    for key, ms in pairs(timing) do
        counted = counted + ms
        if ms >= 0.5 then list[#list + 1] = { key, ms } end
    end
    table.sort(list, function(a, b) return a[2] > b[2] end)
    local parts = {}
    for i = 1, math.min(#list, 6) do parts[i] = ("%s %.1f"):format(list[i][1], list[i][2]) end
    if total - counted >= 0.5 then parts[#parts + 1] = ("other %.1f"):format(total - counted) end
    return #parts > 0 and table.concat(parts, ", ") or "nothing over 0.5 ms"
end
local function perfContext()
    local objects = br.game.GetObjectCount and br.game.GetObjectCount()
    return ("combat %s, power %s, objects %s"):format(br.game.UnitAffectingCombat("player") and "yes" or "no",
        core:isPowerOff() and "off" or "on", tostring(objects or "?"))
end
local function perfFrame(elapsed, total)
    local now = br.game.GetTime()
    if perf.since == nil then perfReset(now) end
    -- the log files, when they were written since the last frame
    local flush = br.log and br.log.lastFlush
    local flushed = flush and flush.at ~= perf.flushAt
    if flushed then
        perf.flushAt = flush.at
        perf.flushes, perf.flushTotal = perf.flushes + 1, perf.flushTotal + flush.ms
        if flush.ms > perf.flushMax then perf.flushMax = flush.ms end
        if flush.ms >= FLUSH_MS then
            perfLine(("FLUSH %.1f ms: %d files, %.1f KB"):format(flush.ms, flush.files, flush.bytes / 1024))
        end
    end
    if elapsed and elapsed >= HITCH_SECONDS and not core:isSettling() then
        perf.hitches = perf.hitches + 1
        if elapsed > perf.hitchMax then perf.hitchMax = elapsed end
        perfLine(("HITCH %.0f ms between frames | BR in the frame before: %.1f ms (%s) | log write in the gap: %s | %s")
            :format(elapsed * 1000, perf.lastTotal, perfSteps(perf.lastTiming, perf.lastTotal),
                flushed and ("%.1f ms"):format(flush.ms) or "no", perfContext()))
    end
    if total >= SPIKE_MS then
        perf.spikes = perf.spikes + 1
        perfLine(("SPIKE BR %.1f ms in one frame: %s | %s"):format(total, perfSteps(perf.timing, total), perfContext()))
    end
    perf.frames, perf.brTotal = perf.frames + 1, perf.brTotal + total
    if total > perf.brMax then perf.brMax = total end
    perf.timing, perf.lastTiming, perf.lastTotal = perf.lastTiming, perf.timing, total
    local seconds = now - perf.since
    if seconds >= SUMMARY_SECONDS then
        perfLine(("minute: FPS %.0f | BR %.2f ms/frame avg, %.1f worst, %.1f%% of real time | spikes %d, hitches %d (worst %.0f ms) | log writes %d, %.1f ms avg, %.1f worst | %s")
            :format(perf.frames / seconds, perf.brTotal / perf.frames, perf.brMax, perf.brTotal / (seconds * 10),
                perf.spikes, perf.hitches, perf.hitchMax * 1000, perf.flushes,
                perf.flushes > 0 and perf.flushTotal / perf.flushes or 0, perf.flushMax, perfContext()))
        perfReset(now)
    end
end

local powerWasOn = false
local function pulse(elapsed)
    local bootstrap = br.bootstrap
    bootstrap:advance()
    if not br.unlocked then return end
    -- Paused while the game hides values from BR (secret values, System/Secrets.lua)
    local readable = br.secrets.canPulse == nil or br.secrets.canPulse()
    br.lifecycle:run("frame", elapsed or 0, core:isPowerOn() and readable)
    if bootstrap:isRotationReady() then
        if core:isPowerOff() then
            if powerWasOn then br.lifecycle:run("powerOff") end
            powerWasOn = false
        else
            powerWasOn = true
            if readable and br.functions.misc:useTimer("playerUpdate", core:getUpdateRate()) then
                local tickStarted = br.game.debugprofilestop()
                br.lifecycle:run("tick")
                core:recordTickCost("rotation", br.game.debugprofilestop() - tickStarted)
            end
        end
    end
end
local function update(_, elapsed)
    if core.loading then return end
    local clock = br.game.debugprofilestop
    local started = clock()
    local timing = perf.timing
    for key in pairs(timing) do timing[key] = nil end
    br.lifecycle.timing = timing
    pulse(elapsed)
    br.lifecycle.timing = nil
    br.debug.cpu:updateDebug(started, "pulse")
    perfFrame(elapsed, clock() - started)
end

-- The frame loop, from when the player first enters the world
br.lifecycle:onStart(30, "core frame", function()
    if core.frame then return end
    core.frame = br.game.CreateFrame("Frame", nil, br.game.UIParent)
    core.frame:SetScript("OnUpdate", update)
    core.frame:Show()
end)
