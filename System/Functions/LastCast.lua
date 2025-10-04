local _, br = ...
br.functions.lastCast = br.functions.lastCast or {}
local lastCast = br.functions.lastCast

lastCast.lastCastTable = {}
lastCast.lastCastTable.tracker = {}
lastCast.lastCastTable.castTime = {}
local tracker = lastCast.lastCastTable.tracker
local castTime = lastCast.lastCastTable.castTime
local waitForSuccess
local lastCastFrame = br._G.CreateFrame("Frame")

local ignoreList = {
    [2139] = "Counterspell",
    [11426] = "Ice Barrier",
    [212653] = "Shimmer",
}

local function addSpell(spellID)
    for _, v in pairs(br.player.spells.abilities) do
        if v == spellID then
            br._G.tinsert(tracker, 1, spellID)
            if #tracker == 10 then
                tracker[10] = nil
            end
            lastCast.lastCast= spellID -- legacy support for some rotations reading this in locals
        end
    end
end

local function addCastTime(spellID)
    for _, v in pairs(br.player.spells.abilities) do
        if v == spellID then
            castTime[v] = br._G.GetTime()
        end
    end
end

local function eventTracker(_, event, ...)
    local sourceUnit = select(1, ...)
    local spellID = event == "UNIT_SPELLCAST_SENT" and select(4, ...) or select(3, ...)
    local spellName = br._G.GetSpellInfo(spellID)
    if sourceUnit == "player" and br.player and not ignoreList[spellID] then
        if event == "UNIT_SPELLCAST_SENT" or event == "UNIT_SPELLCAST_START"
            or event == "UNIT_SPELLCAST_CHANNEL_START" --or event == "UNIT_SPELLCAST_EMPOWER_START"
        then
            -- if event == "UNIT_SPELLCAST_SENT" then br._G.print("Sent Cast Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_START" then br._G.print("Start Cast Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_CHANNEL_START" then br._G.print("Start Channel Spell: " .. spellName) end
            -- if event == "UNIT_SPELLCAST_EMPOWER_START" then br._G.print("Sent Empower Spell: " .. spellName) end
            waitForSuccess = spellID
            addSpell(spellID)
            addCastTime(spellID)
        end
        if event == "UNIT_SPELLCAST_SUCCEEDED" then
            -- if event == "UNIT_SPELLCAST_SUCCEEDED" then br._G.print("Success Cast Spell: " .. spellName) end
            if waitForSuccess == spellID then
                waitForSuccess = nil
            else
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
