local _, br = ...
---@class br.functions.lastCast
br.functions.lastCast = br.functions.lastCast or {}
local lastCast = br.functions.lastCast
lastCast.lastCastTable = {}

lastCast.lastCastTable.tracker = {}

lastCast.lastCastTable.castTime = {}

lastCast.lastCastTable.failedTime = {}

lastCast.lastCastTable.lastFailedReason = {}

local tracker = lastCast.lastCastTable.tracker

local castTime = lastCast.lastCastTable.castTime

local failedTime = lastCast.lastCastTable.failedTime

local waitForSuccess

-- Spells (spell list keys) whose casts aren't tracked at all
local IGNORED = { "counterspell", "iceBarrier", "shimmer" }

-- Every spell ID of the profile's abilities, each rank of a rank list included. Ranked
-- abilities are lists ({rank1, rank2, ...}), so comparing the cast's ID with each entry missed
-- them all: on ranked clients their casts were never recorded (cast.last.time, timeSinceLast and
-- the double-cast guard saw them as never cast). Built once the lists exist; cleared on spellbook,
-- talent, level and spec changes (Readers/common.lua).
local abilityIDs, ignoredIDs

local function buildAbilityIDs()
    local abilities = br.runner and br.runner.spells and br.runner.spells.abilities
    if abilities == nil then return false end
    abilityIDs, ignoredIDs = {}, {}
    for _, v in pairs(abilities) do
        if type(v) == "table" then
            for _, rankID in ipairs(v) do abilityIDs[rankID] = true end
        elseif v then
            abilityIDs[v] = true
        end
    end
    for _, key in ipairs(IGNORED) do
        local v = abilities[key]
        if type(v) == "table" then
            for _, rankID in ipairs(v) do ignoredIDs[rankID] = true end
        elseif v then
            ignoredIDs[v] = true
        end
    end
    return true
end

local function isAbility(spellID)
    if abilityIDs == nil and not buildAbilityIDs() then return false end
    return abilityIDs[spellID] == true
end

local function isIgnored(spellID)
    if ignoredIDs == nil and not buildAbilityIDs() then return false end
    return ignoredIDs[spellID] == true
end

local function addSpell(spellID)
    if not isAbility(spellID) then return end
    br.game.tinsert(tracker, 1, spellID)
    if #tracker == 10 then
        tracker[10] = nil
    end
    lastCast.lastCast = spellID -- legacy support for some rotations reading this in locals
end

local function addCastTime(spellID)
    if isAbility(spellID) then
        castTime[spellID] = br.game.GetTime()
    end
end

local function eventTracker(_, event, ...)
    local sourceUnit = select(1, ...)
    local spellID = event == "UNIT_SPELLCAST_SENT" and select(4, ...) or select(3, ...)
    if sourceUnit == "player" and spellID ~= nil and br.runner and not isIgnored(spellID) then
        if event == "UNIT_SPELLCAST_SENT" or event == "UNIT_SPELLCAST_START"
            or event == "UNIT_SPELLCAST_CHANNEL_START" --or event == "UNIT_SPELLCAST_EMPOWER_START"
        then
            -- if event == "UNIT_SPELLCAST_SENT" then br.game.print("Sent Cast Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_START" then br.game.print("Start Cast Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_CHANNEL_START" then br.game.print("Start Channel Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_EMPOWER_START" then br.game.print("Sent Empower Spell: " .. spellName) end
            waitForSuccess = spellID
            -- Only add to tracker on SENT event to avoid duplicates
            if event == "UNIT_SPELLCAST_SENT" then
                addSpell(spellID)
            end
            -- addCastTime(spellID) -- Don't add cast time on SENT event, as the cast may not actually start (could be interrupted/failed before START event)
        end
        if event == "UNIT_SPELLCAST_SUCCEEDED" then
            -- Record the actual completion time for the spell (useful for timeSinceLast)
            addCastTime(spellID)
            if waitForSuccess == spellID then
                waitForSuccess = nil
            else
                -- Instant cast spell (no SENT/START event, only SUCCESS)
                -- OR spell that completed after being interrupted/failed
                addSpell(spellID)
                addCastTime(spellID)
            end
        end
        if event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" --or event == "UNIT_SPELLCAST_EMPOWER_STOP"
            or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_FAILED_QUIET" or event == "UNIT_SPELLCAST_INTERRUPTED"
        then
            -- if event == "UNIT_SPELLCAST_STOP" then br.game.print("Stop Cast Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_CHANNEL_STOP" then br.game.print("Stop Channel Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_EMPOWER_STOP" then br.game.print("Stop Empower Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_FAILED" then br.game.print("Failed Cast Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_FAILED_QUIET" then br.game.print("Failed Quiet Cast Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_INTERRUPTED" then br.game.print("Interrupted Cast Spell: " .. spellName) end
            if waitForSuccess == spellID then
                br.game.tremove(tracker, 1)
                waitForSuccess = nil
                lastCast.lastCast= tracker[1]
            end
            if event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_FAILED_QUIET" or event == "UNIT_SPELLCAST_INTERRUPTED" then
                failedTime[spellID] = br.game.GetTime()
                lastCast.lastCastTable.lastFailedSpellID = spellID
                lastCast.lastCastTable.lastFailedAt = failedTime[spellID]
                lastCast.lastCastTable.lastFailedEvent = event
            end
        end
    end
end

-- The player's cast events, from the cast engine: SENT (any attempt), START and CHANNEL_START (a cast or channel
-- begins), STOP, CHANNEL_STOP, FAILED, FAILED_QUIET and INTERRUPTED (it ended without going off), SUCCEEDED
br.engines.cast:onPlayerCast({ "UNIT_SPELLCAST_SENT", "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_CHANNEL_START",
    "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_CHANNEL_STOP", "UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_FAILED_QUIET",
    "UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_SUCCEEDED" }, function(event, ...) eventTracker(nil, event, ...) end)

--- True when spellID is one of the rotation's abilities (any rank of a rank list)
-- if br.functions.lastCast:isAbility(spellID) then
function lastCast:isAbility(spellID)
    return isAbility(spellID)
end

function lastCast:clearAbilityIDs()
    abilityIDs, ignoredIDs = nil, nil
end
