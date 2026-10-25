local _, br = ...
local LibDraw = br._G.LibStub("LibDraw-BR")
br.engines.tracker = br.engines.tracker or {}
local tracker = br.engines.tracker

-- The tracker is three loosely coupled pieces that run on different clocks:
--   scan()    every SCAN_INTERVAL: walks the object manager, keeps one entry per object (keyed by
--             what the unlocker calls the object), classifies new entries, and builds `tracked`.
--   classify  once per entry per generation. Quest/rare/custom verdicts are cached on the entry and
--             only recomputed when the quest log, the options or the zone change (invalidate()).
--   render()  every frame: projects the few tracked entries to the screen and moves pooled
--             markers. No classification and no allocations, so it can run every frame without cost.

local SCAN_INTERVAL = 0.4  -- seconds between object manager walks
local MAX_DISTANCE = 200   -- yards; tracked objects beyond this are ignored
local MAX_DRAWN = 40       -- nearest N tracked objects get a marker
local Z_FAR = 50           -- height difference at which a marker turns red
local INTERACT_RANGE = 7 -- yards, game objects only

local entries = {}    -- [object] = entry
local tracked = {}    -- entries to draw this frame, nearest first
local generation = 1  -- bump to reclassify every entry
local scanStamp = 0
local scanElapsed = SCAN_INTERVAL
local active = false
local opts = { terms = {} }
local optsKey
local pool = {}       -- marker pool: { marker, label, line, on, colorKey, text }
local shown = 0

local KIND_COLOR = {
    quest  = { 1.0, 0.82, 0.0 },
    rare   = { 0.55, 0.8, 1.0 },
    custom = { 0.2, 1.0, 0.2 },
}
local Z_FAR_COLOR = { 1, 0.15, 0.15 }

----------------------------------------------------------------------------------------------------
-- Interaction helpers
----------------------------------------------------------------------------------------------------
local interactTime
local lastInteractTime = 0
local nextInteractDelay = 0

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

local function tryInteract(e)
    if not opts.autoInteract or not e.interact or e.unit then return end
    if e.dist > INTERACT_RANGE then return end
    local misc = br.functions.misc
    if br.functions.cast:isUnitCasting("player") or misc:isMoving("player") or isInteracting("player") then return end
    local now = br._G.GetTime()
    -- Human-like delay: only interact if enough time has passed since last interaction
    if now >= lastInteractTime + nextInteractDelay then
        br._G.ObjectInteract(e.obj)
        lastInteractTime = now
        -- 0.5 to 1.0 seconds between interactions
        nextInteractDelay = 0.5 + (br._G.math.random() * 0.5)
    end
end

----------------------------------------------------------------------------------------------------
-- Options
----------------------------------------------------------------------------------------------------
local function trim(text)
    return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- Reads the tracker options once per scan. A change in anything that affects classification
-- bumps the generation so entries get reclassified.
local function readOptions()
    local misc = br.functions.misc
    opts.enabled = misc:isChecked("Enable Tracker")
    if not opts.enabled then
        active = false
        return false
    end
    opts.rare = misc:isChecked("Rare Tracker")
    opts.quest = misc:isChecked("Quest Tracker")
    opts.questMode = misc:getOptionValue("Quest Tracker") or 3 -- 1 units, 2 objects, 3 both
    opts.lines = misc:isChecked("Draw Lines to Tracked Objects")
    opts.extra = misc:isChecked("Display Extra Info")
    opts.autoInteract = misc:isChecked("Auto Interact with Any Tracked Object")

    local custom = ""
    if misc:isChecked("Custom Tracker") then
        custom = tostring(misc:getOptionValue("Custom Tracker") or "")
        if #custom < 3 then custom = "" end
    end
    local key = (opts.rare and "r" or "-") .. (opts.quest and ("q" .. opts.questMode) or "-") .. "|" .. custom
    if key ~= optsKey then
        optsKey = key
        generation = generation + 1
        br._G.wipe(opts.terms)
        for k in string.gmatch(custom, "([^,]+)") do
            local term = trim(k)
            if #term >= 3 then opts.terms[#opts.terms + 1] = br._G.strupper(term) end
        end
    end
    active = opts.rare or opts.quest or #opts.terms > 0
    return active
end

----------------------------------------------------------------------------------------------------
-- Entries and classification
----------------------------------------------------------------------------------------------------
-- Returns an entry (ignore = true for things we never track), or nil when the object isn't readable yet.
local function newEntry(obj)
    local isUnit = br._G.ObjectIsUnit(obj)
    if isUnit then
        if br._G.UnitIsPlayer(obj) then return { ignore = true, gen = 0 } end
    elseif not br._G.ObjectIsGameObject(obj) then
        return { ignore = true, gen = 0 } -- players, corpses, dynamic objects...
    end
    local name = isUnit and br._G.UnitName(obj) or br._G.ObjectName(obj)
    if not name or name == "" then
        -- Units without a name aren't readable yet. Game objects can stay nameless (Forever's unlocker
        -- returns none), and can still be quest objects by their server flag.
        if isUnit then return nil end
        name = ""
    end
    local x, y, z = br._G.ObjectPosition(obj)
    if not x then return nil end
    return {
        obj = obj,
        unit = isUnit and true or false,
        name = name,
        id = br._G.ObjectID(obj) or 0,
        guid = br._G.UnitGUID(obj) or obj,
        x = x, y = y, z = z,
        -- the arrow spans the selection circle, whose size follows the model's bounding radius
        radius = math.max(isUnit and (br._G.UnitBoundingRadius(obj) or br._G.UnitCombatReach(obj) or 0) or 0, 0.3),
        gen = 0,
        interact = true,
    }
end

local function classify(e, inInstance)
    e.gen = generation
    e.kind = nil
    e.interact = true
    if e.ignore then return end
    local obj = e.obj

    if opts.quest and not inInstance then
        local mode = opts.questMode
        local quest = br.engines.questTracker
        if e.unit then
            if (mode == 1 or mode == 3) and quest:isQuestUnit(obj) then e.kind = "quest" return end
        elseif mode == 2 or mode == 3 then
            if quest:isQuestObject(obj) then e.kind = "quest" return end
        end
    end

    if opts.rare and e.unit then
        local class = br._G.UnitClassification(obj)
        if class == "rare" or class == "rareelite" then
            e.kind = "rare"
            e.interact = false
            return
        end
    end

    if #opts.terms > 0 then
        local upperName = br._G.strupper(e.name)
        for i = 1, #opts.terms do
            if upperName:find(opts.terms[i], 1, true) then
                e.kind = "custom"
                return
            end
        end
    end
end

-- Things that change without the quest log changing
local function stillValid(e)
    if not e.unit then return true end
    if e.kind == "quest" then
        if br._G.UnitIsTapDenied(e.obj) then return false end
        if br.functions.unit:GetUnitIsDeadOrGhost(e.obj) and not br.functions.unit:GetUnitIsFriend("player", e.obj) then
            return false
        end
    elseif e.kind == "rare" then
        if br.functions.unit:GetUnitIsDeadOrGhost(e.obj) then return false end
    end
    return true
end

local function byDistance(a, b) return a.dist < b.dist end

local function scan()
    if not readOptions() then
        br._G.wipe(tracked)
        return
    end
    local pX, pY, pZ = br._G.ObjectPosition("player")
    if not pX then return end

    local inCombat = br.functions.misc:isInCombat("player")
    local inInstance = br._G.IsInInstance()
    local GetObjectWithIndex = br._G.GetObjectWithIndex
    local ObjectPosition = br._G.ObjectPosition
    local sqrt, floor = math.sqrt, math.floor
    scanStamp = scanStamp + 1
    br._G.wipe(tracked)

    local count = br._G.GetObjectCount() or 0
    for i = 1, count do
        local obj = GetObjectWithIndex(i)
        if obj then
            local e = entries[obj]
            if not e then
                e = newEntry(obj)
                entries[obj] = e
            end
            if e then
                e.seen = scanStamp
                if e.gen ~= generation then classify(e, inInstance) end
                local kind = e.kind
                -- quest markers are for out-of-combat, open-world use
                if kind and not (kind == "quest" and (inCombat or inInstance)) and stillValid(e) then
                    if e.unit then
                        local x, y, z = ObjectPosition(obj)
                        if x then e.x, e.y, e.z = x, y, z end
                    end
                    local dx, dy, dz = e.x - pX, e.y - pY, e.z - pZ
                    local dist = sqrt(dx * dx + dy * dy + dz * dz)
                    if dist <= MAX_DISTANCE then
                        e.dist = dist
                        e.zFar = dz > Z_FAR or dz < -Z_FAR
                        e.colorKey = kind .. (e.zFar and "z" or "")
                        e.dz = dz
                        tracked[#tracked + 1] = e
                    end
                end
            end
        end
    end

    -- Forget objects that left the object manager
    for obj, e in pairs(entries) do
        if e.seen ~= scanStamp then entries[obj] = nil end
    end

    table.sort(tracked, byDistance)
    for i = #tracked, MAX_DRAWN + 1, -1 do tracked[i] = nil end

    -- Labels only for the markers that get drawn
    for i = 1, #tracked do
        local e = tracked[i]
        local shownName = e.name ~= "" and e.name or (e.kind == "quest" and "Quest object" or "Object")
        if opts.extra then
            e.label = shownName .. "  [" .. e.id .. "] \n" .. e.guid .. "  [ZDiff: " .. floor(e.dz) .. "]  " .. floor(e.dist) .. "y"
        else
            e.label = shownName .. "  [" .. floor(e.dist) .. "y]"
        end
    end

    -- Auto-interact is for game objects (chests, herbs, quest items), never NPCs: take the nearest one
    if not inCombat and opts.autoInteract then
        for i = 1, #tracked do
            if not tracked[i].unit then
                tryInteract(tracked[i])
                break
            end
        end
    end
end

----------------------------------------------------------------------------------------------------
-- Rendering
----------------------------------------------------------------------------------------------------
-- Each unit is an arrow along its facing, as long as its selection circle is wide, centred on the
-- unit, with a short line across it at the centre. Game objects have no facing, so they get a plain
-- cross. All lines: 1 shaft, 2 cross-line, 3-4 arrow head.
local LINES = 4
local CROSS = 6                       -- cross half-size in screen units
local TICK = 5                        -- half-length of the line across an arrow
local HEAD_ANGLE = math.rad(25)
local HEAD_COS, HEAD_SIN = math.cos(HEAD_ANGLE), math.sin(HEAD_ANGLE)
local sqrt, cos, sin = math.sqrt, math.cos, math.sin

local function getItem(i, host)
    local item = pool[i]
    if not item then
        item = { lines = {} }
        for n = 1, LINES do
            local line = host:CreateLine(nil, "BACKGROUND")
            line:SetThickness(2)
            item.lines[n] = line
        end
        local label = host:CreateFontString(nil, "BACKGROUND")
        label:SetFontObject("GameFontNormalSmall")
        item.label = label
        item.playerLine = host:CreateLine(nil, "BACKGROUND")
        item.playerLine:SetThickness(1)
        pool[i] = item
    end
    return item
end

local function showLines(item, first, last, on)
    for n = first, last do
        if on then item.lines[n]:Show() else item.lines[n]:Hide() end
    end
end

local function setVisible(item, on)
    if item.on == on then return end
    item.on = on
    if on then
        showLines(item, 1, 2, true)
    else
        item.label:Hide()
        item.labelOn = false
        showLines(item, 1, LINES, false)
        item.playerLine:Hide()
        item.arrow = false
    end
end

local function setArrow(item, on)
    if item.arrow == on then return end
    item.arrow = on
    showLines(item, 3, LINES, on)
end

local function hideFrom(first)
    for i = first, shown do
        local item = pool[i]
        if item then setVisible(item, false) end
    end
    shown = first - 1
end

local function project(x, y, z)
    local sx, sy = br._G.WorldToScreen(x, y, z)
    if not sx or sx == 0 then return nil end
    return sx, sy
end

local function line(l, host, x1, y1, x2, y2)
    l:SetStartPoint("TOPLEFT", host, x1, y1)
    l:SetEndPoint("TOPLEFT", host, x2, y2)
end

local function render()
    local host = LibDraw.canvas
    local n = #tracked
    if n == 0 or not host then
        hideFrom(1)
        return
    end
    local px, py, pz = br._G.ObjectPosition("player")
    if not px then
        hideFrom(1)
        return
    end
    local width, height = host:GetWidth(), host:GetHeight()
    local psx, psy
    if opts.lines then psx, psy = project(px, py, pz) end
    local ObjectPosition, UnitFacing = br._G.ObjectPosition, br._G.UnitFacing

    local used = 0
    for i = 1, n do
        local e = tracked[i]
        local facing
        if e.unit then
            local x, y, z = ObjectPosition(e.obj)
            if x then e.x, e.y, e.z = x, y, z end
            facing = UnitFacing(e.obj)
            if facing then facing = facing + tracker.facingOffset end
        end
        local sx, sy = project(e.x, e.y, e.z)
        if sx and sx > -50 and sx < width + 50 and sy < 50 and sy > -height - 50 then
            used = used + 1
            local item = getItem(used, host)
            if item.colorKey ~= e.colorKey then
                item.colorKey = e.colorKey
                local c = e.zFar and Z_FAR_COLOR or KIND_COLOR[e.kind]
                for k = 1, LINES do item.lines[k]:SetColorTexture(c[1], c[2], c[3], 0.95) end
                item.label:SetTextColor(c[1], c[2], c[3], 1)
                item.playerLine:SetColorTexture(c[1], c[2], c[3], 0.35)
            end
            setVisible(item, true)

            local drawn = false
            if facing then
                local r, fx, fy = tracker.ringBase + e.radius * tracker.ringScale, cos(facing), sin(facing)
                local tx, ty = project(e.x + fx * r, e.y + fy * r, e.z)
                local ax, ay = project(e.x - fx * r, e.y - fy * r, e.z)
                if tx and ax then
                    local dx, dy = tx - ax, ty - ay
                    local len = sqrt(dx * dx + dy * dy)
                    if len > 6 then
                        drawn = true
                        line(item.lines[1], host, ax, ay, tx, ty)
                        -- short line across the arrow at the object's centre
                        local nx, ny = -dy / len, dx / len
                        line(item.lines[2], host, sx - nx * TICK, sy - ny * TICK, sx + nx * TICK, sy + ny * TICK)
                        -- head: back along the shaft, rotated either way
                        local bx, by = -dx / len, -dy / len
                        local wl = len * 0.2
                        if wl > 14 then wl = 14 elseif wl < 4 then wl = 4 end
                        line(item.lines[3], host, tx, ty,
                            tx + (bx * HEAD_COS - by * HEAD_SIN) * wl, ty + (bx * HEAD_SIN + by * HEAD_COS) * wl)
                        line(item.lines[4], host, tx, ty,
                            tx + (bx * HEAD_COS + by * HEAD_SIN) * wl, ty + (-bx * HEAD_SIN + by * HEAD_COS) * wl)
                    end
                end
            end
            if not drawn then
                -- objects, or a unit too small/far for an arrow: plain cross
                line(item.lines[1], host, sx - CROSS, sy, sx + CROSS, sy)
                line(item.lines[2], host, sx, sy - CROSS, sx, sy + CROSS)
            end

            if item.text ~= e.label then
                item.text = e.label
                item.label:SetText(e.label)
            end
            item.label:SetPoint("BOTTOM", host, "TOPLEFT", sx, sy + CROSS + 3)
            if not item.labelOn then item.labelOn = true item.label:Show() end
            setArrow(item, drawn)

            if psx then
                line(item.playerLine, host, psx, psy, sx, sy)
                item.playerLine:Show()
            else
                item.playerLine:Hide()
            end
        end
    end
    hideFrom(used + 1)
    shown = used
end

----------------------------------------------------------------------------------------------------
-- Public API
----------------------------------------------------------------------------------------------------
tracker.tracked = tracked
-- Added to every unit's reported facing. /brtrack flip toggles 0 / pi to test whether this
-- client's unit facing is 180 degrees off.
tracker.facingOffset = tracker.facingOffset or 0
-- Arrow half-length = ringBase + bounding radius * ringScale, to match the game's green selection
-- circle. The circle grows more slowly than the model, so a straight multiple is too long on big mobs.
-- Fitted to two creatures (radius 0.31 -> 0.68 yd, radius 5.07 -> ~4.2 yd); /brtrack ring <scale> [base]
-- tunes it for the session.
tracker.ringBase = tracker.ringBase or 0.45
tracker.ringScale = tracker.ringScale or 0.74

-- Called every frame by the engine in Core.lua
function tracker:update(elapsed)
    scanElapsed = scanElapsed + elapsed
    if scanElapsed >= SCAN_INTERVAL then
        scanElapsed = 0
        scan()
    end
    if active then
        render()
    elseif shown > 0 then
        hideFrom(1)
    end
end

-- BR is off or paused: stop drawing, scan again as soon as it resumes
function tracker:suspend()
    if shown > 0 then hideFrom(1) end
    br._G.wipe(tracked)
    scanElapsed = SCAN_INTERVAL
end

-- Reclassify everything on the next scan (quest log or zone changed)
function tracker:invalidate()
    generation = generation + 1
    scanElapsed = SCAN_INTERVAL
end

function tracker:dump()
    local total, kinds = 0, {}
    for _, e in pairs(entries) do
        total = total + 1
        if e.kind then kinds[e.kind] = (kinds[e.kind] or 0) + 1 end
    end
    local say = br._G.print
    say(("Tracker: %d objects known, %d drawn, generation %d"):format(total, #tracked, generation))
    say(("  facing offset %.2f, ring base %.2f scale %.2f"):format(tracker.facingOffset, tracker.ringBase, tracker.ringScale))
    local px, py, pz = br._G.ObjectPosition("player")
    say(("  player %.2f %.2f %.2f facing %s"):format(px or 0, py or 0, pz or 0, tostring(br._G.UnitFacing("player"))))
    for kind, n in pairs(kinds) do say("  " .. kind .. ": " .. n) end
    for _, e in ipairs(tracked) do
        local x, y, z = br._G.ObjectPosition(e.obj)
        say(("  %s [%s] %s %.1fy  pos %.2f %.2f %.2f  facing %s  radius %.2f (combat reach %s, height %s)"):format(
            e.kind, e.id, e.name, e.dist, x or 0, y or 0, z or 0,
            e.unit and tostring(br._G.UnitFacing(e.obj)) or "-", e.radius,
            e.unit and tostring(br._G.UnitCombatReach(e.obj)) or "-",
            br._G.ObjectHeight and tostring(br._G.ObjectHeight(e.obj)) or "n/a"))
        say("    guid " .. tostring(e.guid))
    end
end

SLASH_BRTRACK1 = "/brtrack"
br._G.SlashCmdList["BRTRACK"] = function(msg)
    if msg and msg:lower():find("flip") then
        tracker.facingOffset = tracker.facingOffset == 0 and math.pi or 0
        br._G.print("Tracker facing offset: " .. (tracker.facingOffset == 0 and "0" or "180 degrees"))
        return
    end
    local scale, base = nil, nil
    if msg then
        local a, b = msg:lower():match("ring%s+([%d%.]+)%s*([%d%.]*)")
        scale, base = tonumber(a), tonumber(b)
    end
    if scale then
        tracker.ringScale = scale
        if base then tracker.ringBase = base end
        br._G.print(("Tracker ring: base %.2f + radius * %.2f"):format(tracker.ringBase, tracker.ringScale))
        return
    end
    tracker:dump()
end

-- Every frame: the tracker scans on its own interval but must re-project its markers each frame or
-- they lag behind the camera
br.lifecycle:onFrame(20, "object tracker", function(elapsed, active)
    if active then tracker:update(elapsed) else tracker:suspend() end
end)
br.lifecycle:onPowerOff(30, "drawings", function() LibDraw.clearCanvas() end)
