local _, br = ...
br.functions.InFlight = br.functions.InFlight or {}
local InFlight = br.functions.InFlight
InFlight.Tracker = {}

local projectileSpeed = {
    [116] = 35, --Frostbolt
    [133] = 45, --Fireball
    [11366] = 35, --Pyroblast
    [31707] = 16, --Waterbolt
    [214634] = 30, --Ebonbolt
}

function InFlight:Hit(spellID, destinationGUID, sourceGUID)
    local target, source
    local function distance(unit1, unit2)
        local x1, y1, z1 = br._G.ObjectPosition(unit1)
        local x2, y2, z2 = br._G.ObjectPosition(unit2)
        return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
    end
    if spellID == 44614 then --override for flurry
        return 1
    end
    if spellID == 153561 then --override for meteor
        return 3
    end
    if destinationGUID == nil or projectileSpeed[spellID] == nil then
        return 0
    end
    if sourceGUID == nil then
        source = "player"
    else
        source = br._G.GetObjectWithGUID(sourceGUID)
    end
    target = br._G.GetObjectWithGUID(destinationGUID)
    return (distance(source, target) / projectileSpeed[spellID])
end

function InFlight:Check(spellID, destination)
    if InFlight.Tracker[spellID] and InFlight.Tracker[spellID].HitTime > br._G.GetTime() and (not destination or not InFlight.Tracker[spellID].Target or br.functions.unit:GetUnitIsUnit(InFlight.Tracker[spellID].Target, destination)) then
        return true
    end
    return false
end

function InFlight:Remain(spellID, destination)
    if InFlight.Check(spellID, destination) then
        return InFlight.Tracker[spellID].HitTime - br._G.GetTime()
    end
    return 0
end

function InFlight:Add(spellID, destinationGUID, sourceGUID)
    if InFlight.Tracker[spellID] == nil then
        InFlight.Tracker[spellID] = {}
    end
    InFlight.Tracker[spellID].CastTime = br._G.GetTime()
    InFlight.Tracker[spellID].HitTime = br._G.GetTime() + InFlight.Hit(spellID, destinationGUID, sourceGUID)
    if destinationGUID == nil then
        return
    end
    InFlight.Tracker[spellID].Target = br._G.GetObjectWithGUID(destinationGUID)
end
