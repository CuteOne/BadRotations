local _, br = ...
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
local lastCastFrame = br._G.CreateFrame("Frame")

local ignoreList = {
    [2139] = "Counterspell",
    [11426] = "Ice Barrier",
    [212653] = "Shimmer",
}

-- Every spell ID of the profile's abilities, each rank of a rank list included. Ranked
-- abilities are lists ({rank1, rank2, ...}), so comparing the cast's ID with each entry missed
-- them all: on ranked clients their casts were never recorded (cast.last.time, timeSinceLast and
-- the double-cast guard saw them as never cast). Built once the lists exist; cleared on spellbook,
-- talent, level and spec changes (readers/common.lua).
local abilityIDs
local function isAbility(spellID)
    if abilityIDs == nil then
        local abilities = br.player and br.player.spells and br.player.spells.abilities
        if abilities == nil then return false end
        abilityIDs = {}
        for _, v in pairs(abilities) do
            if type(v) == "table" then
                for _, rankID in ipairs(v) do abilityIDs[rankID] = true end
            elseif v then
                abilityIDs[v] = true
            end
        end
    end
    return abilityIDs[spellID] == true
end

function lastCast:clearAbilityIDs()
    abilityIDs = nil
end

local function addSpell(spellID)
    if not isAbility(spellID) then return end
    br._G.tinsert(tracker, 1, spellID)
    if #tracker == 10 then
        tracker[10] = nil
    end
    lastCast.lastCast = spellID -- legacy support for some rotations reading this in locals
end

local function addCastTime(spellID)
    if isAbility(spellID) then
        castTime[spellID] = br._G.GetTime()
    end
end

local function eventTracker(_, event, ...)
    local sourceUnit = select(1, ...)
    local spellID = event == "UNIT_SPELLCAST_SENT" and select(4, ...) or select(3, ...)
    if sourceUnit == "player" and br.player and not ignoreList[spellID] then
        if event == "UNIT_SPELLCAST_SENT" or event == "UNIT_SPELLCAST_START"
            or event == "UNIT_SPELLCAST_CHANNEL_START" --or event == "UNIT_SPELLCAST_EMPOWER_START"
        then
            -- if event == "UNIT_SPELLCAST_SENT" then br._G.print("Sent Cast Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_START" then br._G.print("Start Cast Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_CHANNEL_START" then br._G.print("Start Channel Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_EMPOWER_START" then br._G.print("Sent Empower Spell: " .. spellName) end
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
            -- if event == "UNIT_SPELLCAST_STOP" then br._G.print("Stop Cast Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_CHANNEL_STOP" then br._G.print("Stop Channel Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_EMPOWER_STOP" then br._G.print("Stop Empower Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_FAILED" then br._G.print("Failed Cast Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_FAILED_QUIET" then br._G.print("Failed Quiet Cast Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_INTERRUPTED" then br._G.print("Interrupted Cast Spell: " .. spellName) end
            if waitForSuccess == spellID then
                br._G.tremove(tracker, 1)
                waitForSuccess = nil
                lastCast.lastCast= tracker[1]
            end
            if event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_FAILED_QUIET" or event == "UNIT_SPELLCAST_INTERRUPTED" then
                failedTime[spellID] = br._G.GetTime()
                lastCast.lastCastTable.lastFailedSpellID = spellID
                lastCast.lastCastTable.lastFailedAt = failedTime[spellID]
                lastCast.lastCastTable.lastFailedEvent = event
            end
        end
    end
end

-- Begin Cast Events
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_SENT")          -- Fired when a unit attempts to cast a spell regardless of the success of the cast.
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_START")         -- Fired when a unit begins casting a non-instant cast spell.
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START") -- Fired when a unit begins channeling in the course of casting a spell.
-- lastCastFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
-- Stop Cast Events
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_STOP")         -- Fired when a unit stops casting.
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP") -- Fired when a unit stops channeling.
-- lastCastFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")       -- Fired when a unit's spellcast fails.
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")  -- Fired when a unit's spellcast is interrupted
-- Complete Cast Events
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")    -- Fired when a spell is cast successfully.
lastCastFrame:SetScript("OnEvent", eventTracker)
