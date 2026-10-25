local _, br = ...
---@class br.functions.InFlight
br.functions.InFlight = br.functions.InFlight or {}
local InFlight = br.functions.InFlight
InFlight.Tracker = {}

-- Seconds until spellID, cast by the source (the player when nil), reaches the destination: a fixed
-- travel time, or the distance over its speed (br.lists.range); 0 for spells that aren't listed.
local function listedFor(list, spellID)
    for key, value in pairs(list) do
        if br.functions.spell:getHighestSpellID(key) == spellID then return value end
    end
    return nil
end

function InFlight:Add(spellID, destinationGUID, sourceGUID)
    if InFlight.Tracker[spellID] == nil then
        InFlight.Tracker[spellID] = {}
    end
    InFlight.Tracker[spellID].CastTime = br.game.GetTime()
    InFlight.Tracker[spellID].HitTime = br.game.GetTime() + InFlight:Hit(spellID, destinationGUID, sourceGUID)
    if destinationGUID == nil then
        return
    end
    InFlight.Tracker[spellID].Target = br.game.GetObjectWithGUID(destinationGUID)
end

function InFlight:Check(spellID, destination)
    if InFlight.Tracker[spellID] and InFlight.Tracker[spellID].HitTime > br.game.GetTime() and (not destination or not InFlight.Tracker[spellID].Target or br.functions.unit:GetUnitIsUnit(InFlight.Tracker[spellID].Target, destination)) then
        return true
    end
    return false
end

function InFlight:Hit(spellID, destinationGUID, sourceGUID)
    local travelTime = listedFor(br.lists.range.projectileTravelTime, spellID)
    if travelTime then return travelTime end
    local speed = listedFor(br.lists.range.projectileSpeed, spellID)
    if destinationGUID == nil or speed == nil then return 0 end
    local source = sourceGUID and br.game.GetObjectWithGUID(sourceGUID) or "player"
    local target = br.game.GetObjectWithGUID(destinationGUID)
    local x1, y1, z1 = br.game.ObjectPosition(source)
    local x2, y2, z2 = br.game.ObjectPosition(target)
    if x1 == nil or x2 == nil then return 0 end
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2) / speed
end

function InFlight:Remain(spellID, destination)
    if InFlight:Check(spellID, destination) then
        return InFlight.Tracker[spellID].HitTime - br.game.GetTime()
    end
    return 0
end
