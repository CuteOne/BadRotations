local _, br = ...
--- Core: BR's rotating body
-- One frame loop. It runs the startup stages (System/Bootstrap.lua) every frame; once an unlocker is
-- found it runs the frame steps every frame, and once the player is built it runs the tick steps at
-- the Bot Update Rate. Core decides only whether BR may run; what each step does belongs to the module
-- that registered it (br.lifecycle, BadRotations.lua).
--   frame steps   fn(elapsed, active): active is false while Power is off or values are hidden
--                 10 enemies engine (Engines/EnemiesEngine.lua)  20 object tracker (Engines/Tracker.lua)
--   tick steps    run only while Power is on and values are readable; a step returning true ends
--                 the tick there
--                 1 dev mode (Misc/Debug.lua)  5 expansion work (Expansions/Retail: quaking, bait)
--                 10 queued casts (Cast/CastFunction.lua)  15 smart queue (SmartQueue.lua)
--                 20 healing engine (HealingEngine.lua)  50 the player and its rotation (Loader/Player.lua)
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
    local now = br._G.GetTime()
    if updateRateAt == now then return updateRateValue end
    local updateRate = br.functions.misc:getOptionValue("Bot Update Rate") or 0.1
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
function core:isSettling() return br._G.GetTime() < settledAt end

local loadingScreen = br._G.CreateFrame("Frame")
loadingScreen:RegisterEvent("LOADING_SCREEN_ENABLED")
loadingScreen:RegisterEvent("LOADING_SCREEN_DISABLED")
loadingScreen:SetScript("OnEvent", function(_, event)
    core.loading = event == "LOADING_SCREEN_ENABLED"
    if not core.loading then settledAt = br._G.GetTime() + SETTLE_SECONDS end
end)

local powerWasOn = false
local function update(_, elapsed)
    local started = br._G.debugprofilestop()
    if core.loading then return end
    local bootstrap = br.bootstrap
    bootstrap:advance()
    if not br.unlocked then return end
    -- Paused while the game hides values from BR (secret values, System/Secrets.lua)
    local readable = br.api.canPulse == nil or br.api.canPulse()
    br.lifecycle:run("frame", elapsed or 0, core:isPowerOn() and readable)
    if bootstrap:isPlayerReady() then
        if core:isPowerOff() then
            if powerWasOn then br.lifecycle:run("powerOff") end
            powerWasOn = false
        else
            powerWasOn = true
            if readable and br.debug.timer:useTimer("playerUpdate", core:getUpdateRate()) then
                local tickStarted = br._G.debugprofilestop()
                br.lifecycle:run("tick")
                core:recordTickCost("rotation", br._G.debugprofilestop() - tickStarted)
            end
        end
    end
    br.debug.cpu:updateDebug(started, "pulse")
end

-- The frame loop, from when the player first enters the world
br.lifecycle:onStart(30, "core frame", function()
    if core.frame then return end
    core.frame = br._G.CreateFrame("Frame", nil, br._G.UIParent)
    core.frame:SetScript("OnUpdate", update)
    core.frame:Show()
end)
