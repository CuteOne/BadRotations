br.lastCast = {}
br.lastCast.tracker = {}
br.lastCast.castTime = {}
local tracker = br.lastCast.tracker
local castTime = br.lastCast.castTime
local waitForSuccess
local lastCastFrame = CreateFrame("Frame")

local ignoreList = {
    [2139] = "Counterspell",
    [11426] = "Ice Barrier",
    [212653] = "Shimmer",
}

local function addSpell(spellID)
    for k, v in pairs(br.player.spell.abilities) do
        if v == spellID then
            tinsert(tracker, 1, spellID)
            if #tracker == 10 then
                tracker[10] = nil
            end
            lastCast = spellID -- legacy support for some rotations reading this in locals
        end
    end
end

local function addCastTime(spellID)
    for k, v in pairs(br.player.spell.abilities) do
        if v == spellID then
            castTime[v] = GetTime()
        end
    end
end

local function eventTracker(self, event, ...)
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
                tremove(tracker,1)
                waitForSuccess = nil
                lastCast = tracker[1]
            end
        end
    end
end

lastCastFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
lastCastFrame:RegisterEvent("UNIT_SPELLCAST_START")
lastCastFrame:SetScript("OnEvent", eventTracker)