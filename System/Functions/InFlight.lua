br.InFlight = {}
local InFlight = br.InFlight
InFlight.Tracker = {}

local projectileSpeed = {
    [116] = 35, --Frostbolt
    [133] = 45, --Fireball
    [11366] = 35, --Pyroblast
    [31707] = 16, --Waterbolt
    [214634] = 30, --Ebonbolt
}

function InFlight.Hit(spellID, destinationGUID, sourceGUID)
    local target, source
    local function distance(unit1, unit2)
        local x1, y1, z1 = ObjectPosition(unit1)
        local x2, y2, z2 = ObjectPosition(unit2)
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
        source = GetObjectWithGUID(sourceGUID)
    end
    target = GetObjectWithGUID(destinationGUID)
    return (distance(source, target) / projectileSpeed[spellID])
end

function InFlight.Check(spellID, destination)
    if InFlight.Tracker[spellID] and InFlight.Tracker[spellID].HitTime > GetTime() and (not destination or not InFlight.Tracker[spellID].Target or GetUnitIsUnit(InFlight.Tracker[spellID].Target, destination)) then
        return true
    end
    return false
end

function InFlight.Remain(spellID, destination)
    if InFlight.Check(spellID, destination) then
        return InFlight.Tracker[spellID].HitTime - GetTime()
    end
    return 0
end

function InFlight.Add(spellID, destinationGUID, sourceGUID)
    if InFlight.Tracker[spellID] == nil then
        InFlight.Tracker[spellID] = {}
    end
    InFlight.Tracker[spellID].CastTime = GetTime()
    InFlight.Tracker[spellID].HitTime = GetTime() + InFlight.Hit(spellID, destinationGUID, sourceGUID)
    if destinationGUID == nil then
        return
    end
    InFlight.Tracker[spellID].Target = GetObjectWithGUID(destinationGUID)
end
