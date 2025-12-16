local _, br = ...
local LibDraw = br._G.LibStub("LibDraw-BR")
br.engines.tracker = br.engines.tracker or {}
local tracker = br.engines.tracker
local tracking = false
local interactTime
local lastInteractTime = 0
local nextInteractDelay = 0
-- Performance tunables
tracker._updateInterval = tracker._updateInterval or 0.08 -- seconds between redraws
tracker._lastUpdate = tracker._lastUpdate or 0
tracker._maxDrawDistance = tracker._maxDrawDistance or 200 -- max distance to draw objects
tracker._cache = tracker._cache or {}
tracker._moveThreshold = tracker._moveThreshold or 0.25 -- meters to consider movement
tracker._lastCount = tracker._lastCount or 0


local function getCastTime(unit)
    if br._G.UnitCastingInfo(unit) ~= nil then
        return select(5, br._G.UnitCastingInfo(unit)) / 1000 - br._G.GetTime()
    elseif br._G.UnitChannelInfo(unit) ~= nil then
        return select(5, br._G.UnitChannelInfo(unit)) / 1000 - br._G.GetTime()
    else
        return 0
    end
end

local function isInteracting(unit)
    local time = br._G.GetTime()
    if interactTime == nil then interactTime = 0 end
    local castTime = getCastTime(unit)
    if castTime > 0 and interactTime == 0 then
        interactTime = time + castTime + 1
    end
    if castTime == 0 and interactTime < time then interactTime = 0 end
    return interactTime > time
end

local function trackObject(object, isUnit, name, objectid, objectguid, interact, pX, pY, pZ)
    if not br._G.ObjectExists(object) then return end
    -- Allow caller to pass player position to avoid repeated lookups
    if not pX then pX, pY, pZ = br._G.ObjectPosition("player") end
    local xOb, yOb, zOb = br._G.ObjectPosition(object)
    if zOb == nil then zOb = pZ end
    if zOb == nil then return end
    if interact == nil then
        interact = true
    end
    -- local playerDistance = br._G.GetDistanceBetweenPositions(pX, pY, pZ, xOb, yOb, zOb)
    local zDifference = math.floor(zOb - pZ)
    if xOb ~= nil then
        -- Cull distant objects early to avoid expensive draw calls
        local distance = br._G.GetDistanceBetweenPositions(pX, pY, pZ, xOb, yOb, zOb)
        if distance > tracker._maxDrawDistance then return end
        if math.abs(zDifference) > 50 then
            LibDraw.SetColor(255, 0, 0, 100)
        else
            LibDraw.SetColor(0, 255, 0, 100)
        end
        local Cr = br._G.UnitCombatReach(object)
        if not Cr or Cr == 0 then Cr = 1.5 end
        LibDraw.Circle(xOb, yOb, zOb, Cr)
        if isUnit then
            LibDraw.Arrow(xOb, yOb, zOb, br._G.UnitFacing(object) --[[+ math.pi * 2]], Cr / 2)
        else
            LibDraw.Arrow(xOb, yOb, zOb, br._G.UnitFacing("player") --[[+ math.pi * 2]], Cr / 2)
        end
        -- if name == "" or name == "Unknown" then
        --     name = isUnit and br._G.UnitName(object) or nil
        -- end
        if br.functions.misc:isChecked("Display Extra Info") then
            name = name .. "  [" .. objectid .. "] " .. "\n" .. objectguid .. "  [ZDiff: " .. zDifference .. "]"
        end
        LibDraw.Text(name, "GameFontNormal", xOb, yOb, zOb + 3)
        if br.functions.misc:isChecked("Draw Lines to Tracked Objects") then
            if math.abs(zDifference) > 50 then
                LibDraw.SetColor(255, 0, 0, 80)
            else
                LibDraw.SetColor(0, 255, 0, 80)
            end
            LibDraw.Line(pX, pY, pZ, xOb, yOb, zOb)
        end
        -- local hasLoot = br._G.CanLootUnit(objectguid)
        -- local interacting = isInteracting("player")
        if br.functions.misc:isChecked("Auto Interact with Any Tracked Object") and interact and not br.player.inCombat
            and distance <= 7 and
            not br.functions.cast:isUnitCasting("player") and not br.functions.misc:isMoving("player")
            and not isInteracting("player") -- Only interact if not already interacting
        then
            local currentTime = br._G.GetTime()
            -- Human-like delay: only interact if enough time has passed since last interaction
            if currentTime >= (lastInteractTime + nextInteractDelay) then
                br._G.ObjectInteract(object)
                lastInteractTime = currentTime
                -- Set next delay with variance: 0.3 to 0.8 seconds (random human-like timing)
                nextInteractDelay = 0.3 + (br._G.math.random() * 0.5)
            end
        end
        tracking = true
    end
end

br._G.string.trim = function(string)
    local from = string:match "^%s*()"
    return from > #string and "" or string:match(".*%S", from)
end

br.engines.tracker.tracking = {}
function tracker:objectTracker()
    if br.functions.misc:isChecked("Enable Tracker") then
        local now = br._G.GetTime()
        if now - (tracker._lastUpdate or 0) < tracker._updateInterval then return end
        tracker._lastUpdate = now
        -- Cache commonly used objects; call methods with colon to preserve self
        local misc = br.functions.misc
        local showCustom = misc:isChecked("Custom Tracker")
        local customValue = tostring(misc:getOptionValue("Custom Tracker") or "")
        local showRare = misc:isChecked("Rare Tracker")
        local showQuest = misc:isChecked("Quest Tracker")
        local inCombatPlayer = misc:isInCombat("player")
        local inInstance = br._G.IsInInstance()

        -- Only proceed if any tracker mode is active
        if (showCustom and customValue ~= "" and string.len(customValue) >= 3) or showRare or showQuest then
            local pX, pY, pZ = br._G.ObjectPosition("player")
            local t = br.engines.tracker.tracking
            local n = #t
            local newCache = {}
            local redrawNeeded = false

            -- First pass: collect positions and decide if redraw is needed
            for i = 1, n do
                local entry = t[i]
                local object = entry.object
                local objUnit = entry.unit
                local name = entry.name
                local objectid = entry.id
                local objectguid = entry.guid
                local interact = nil
                local track = false
                if object and name and objectid and objectguid then
                    if showRare and not track then
                        local class = br._G.UnitClassification(object)
                        if class == "rare" then
                            track = true
                            interact = false
                        elseif class == "rareelite" then
                            track = true
                            interact = false
                        end
                    end
                    if showCustom and not track then
                        for k in string.gmatch(customValue, "([^,]+)") do
                            local searchTerm = br._G.string.trim(k)
                            if string.len(searchTerm) >= 3 then
                                local upperName = br._G.strupper(name)
                                local upperSearch = br._G.strupper(searchTerm)
                                if upperName:find(upperSearch, 1, true) then
                                    track = true
                                    break
                                end
                            end
                        end
                    end
                    if showQuest and not inCombatPlayer and not inInstance then
                        if (misc:getOptionValue("Quest Tracker") == 1 or misc:getOptionValue("Quest Tracker") == 3)
                            and object ~= nil and objUnit and br.engines.questTracker:isQuestUnit(object) and not br._G.UnitIsTapDenied(object)
                        then
                            if object and br.functions.unit:GetObjectExists(object) then
                                interact = true
                                track = true
                            end
                        end
                        if (misc:getOptionValue("Quest Tracker") == 2 or misc:getOptionValue("Quest Tracker") == 3)
                            and not objUnit and br.engines.questTracker:isQuestObject(object)
                        then
                            interact = true
                            track = true
                        end
                    end
                    if track then
                        -- get position once for movement detection and culling
                        if br._G.ObjectExists(object) then
                            local xOb, yOb, zOb = br._G.ObjectPosition(object)
                            if xOb then
                                local distance = br._G.GetDistanceBetweenPositions(pX, pY, pZ, xOb, yOb, zOb)
                                if distance <= tracker._maxDrawDistance then
                                    newCache[object] = { x = xOb, y = yOb, z = zOb, entry = entry, distance = distance }
                                    local old = tracker._cache[object]
                                    if not old then
                                        redrawNeeded = true
                                    else
                                        local dx = old.x - xOb
                                        local dy = old.y - yOb
                                        local dz = old.z - zOb
                                        if (dx * dx + dy * dy + dz * dz) >= (tracker._moveThreshold * tracker._moveThreshold) then
                                            redrawNeeded = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- If count changed, force redraw
            if n ~= tracker._lastCount then redrawNeeded = true end

            -- Second pass: redraw only if needed
            if redrawNeeded then
                LibDraw:clearCanvas()
                for object, data in pairs(newCache) do
                    local e = data.entry
                    -- reuse existing trackObject drawing logic; pass player pos
                    trackObject(object, e.unit, e.name, e.id, e.guid, nil, pX, pY, pZ)
                end
                tracker._cache = newCache
                tracker._lastCount = n
            end
        end
    elseif tracking then
        LibDraw:clearCanvas()
        tracking = false
    end
end
