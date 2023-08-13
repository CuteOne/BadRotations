local _, br = ...
br.lastCastTable = {}
br.lastCastTable.tracker = {}
br.lastCastTable.castTime = {}
local tracker = br.lastCastTable.tracker
local castTime = br.lastCastTable.castTime
local waitForSuccess
local lastCastFrame = br._G.CreateFrame("Frame")

local ignoreList = {
    [2139] = "Counterspell",
    [11426] = "Ice Barrier",
    [212653] = "Shimmer",
}

local function addSpell(spellID)
    for _, v in pairs(br.player.spell.abilities) do
        if v == spellID then
            br._G.tinsert(tracker, 1, spellID)
            if #tracker == 10 then
                tracker[10] = nil
            end
            br.lastCast = spellID -- legacy support for some rotations reading this in locals
        end
    end
end

local function addCastTime(spellID)
    for _, v in pairs(br.player.spell.abilities) do
        if v == spellID then
            castTime[v] = br._G.GetTime()
        end
    end
end

local function eventTracker(_, event, ...)
    local sourceUnit = select(1, ...)
    local spellID = select(3, ...)
    if sourceUnit == "player" and br.player and not ignoreList[spellID] then
        if event == "UNIT_SPELLCAST_START" then
            waitForSuccess = spellID
            addSpell(spellID)
            addCastTime(spellID)
        elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
            if waitForSuccess == spellID then
                waitForSuccess = nil
            else
                addSpell(spellID)
                addCastTime(spellID)
            end
        elseif event == "UNIT_SPELLCAST_STOP" then
            if waitForSuccess == spellID then
                br._G.tremove(tracker,1)
                waitForSuccess = nil
                br.lastCast = tracker[1]
            end
        end
    end
end

lastCastFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_START")
lastCastFrame:SetScript("OnEvent", eventTracker)