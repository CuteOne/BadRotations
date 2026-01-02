local _, br = ...

br.functions.totem = br.functions.totem or {}
local totem = br.functions.totem

local spellNameCache = {}

local function resolveCandidateName(candidate)
    if not candidate then return nil end

    if type(candidate) == "number" then
        return br._G.GetSpellInfo(candidate)
    end

    if type(candidate) == "string" then
        local idFromKey = br.player and br.player.spells and br.player.spells[candidate]
        if type(idFromKey) == "number" then
            return br._G.GetSpellInfo(idFromKey)
        end
        return candidate
    end

    return nil
end

function totem:spellName(spellId)
    if not spellId then return nil end
    if spellNameCache[spellId] == nil then
        spellNameCache[spellId] = br._G.GetSpellInfo(spellId)
    end
    return spellNameCache[spellId]
end

function totem:getSlotInfo(slot)
    if not slot then return false, nil, 0, 0, nil end
    local haveTotem, name, startTime, duration, icon = br._G.GetTotemInfo(slot)
    if not haveTotem then
        return false, nil, 0, 0, nil
    end
    return true, name, startTime or 0, duration or 0, icon
end

function totem:slotRemains(slot)
    local haveTotem, _, startTime, duration = self:getSlotInfo(slot)
    if not haveTotem or duration <= 0 or startTime <= 0 then return 0 end
    local remaining = (startTime + duration) - br._G.GetTime()
    return remaining > 0 and remaining or 0
end

-- Candidates can be:
-- - spell IDs (number)
-- - spell keys from br.player.spells (string)
-- - literal localized names (string)
function totem:slotMatchesAny(slot, ...)
    local haveTotem, activeName = self:getSlotInfo(slot)
    if not haveTotem or not activeName or activeName == "" then return false end

    for i = 1, select('#', ...) do
        local candidate = select(i, ...)
        local candidateName

        candidateName = resolveCandidateName(candidate)

        if candidateName and candidateName ~= "" and activeName == candidateName then
            return true
        end
    end

    return false
end

function totem:anySlotMatchesAny(...)
    for slot = 1, 4 do
        if self:slotMatchesAny(slot, ...) then
            return true
        end
    end
    return false
end

-- Returns the closest world object that matches the active totem name in this slot.
-- @treturn any|nil object
-- @treturn number|nil distance Player->totem distance in yards (raw 3D), if found
-- @treturn string|nil name Active totem name for the slot
function totem:getActiveObject(slot)
    local haveTotem, name = self:getSlotInfo(slot)
    if not haveTotem or not name or name == "" then return nil, nil, nil end
    if not br.unlocked or not br._G.GetObjectCount or not br._G.GetObjectWithIndex then
        return nil, nil, name
    end

    local pX, pY, pZ = br.functions.unit:GetObjectPosition("player")
    if not pX or not pY or not pZ then return nil, nil, name end

    local bestObj, bestDist
    for i = 1, br._G.GetObjectCount() do
        local obj = br._G.GetObjectWithIndex(i)
        if obj and br.functions.unit:GetObjectExists(obj) then
            local objName = br._G.UnitName(obj)
            if objName == name then
                local creator = br._G.UnitCreator and br._G.UnitCreator(obj) or nil
                local isMine = creator == "player" or creator == "Player"
                if not isMine and creator and br._G.UnitIsUnit then
                    isMine = br._G.UnitIsUnit(creator, "player")
                end

                if isMine then
                    local x, y, z = br.functions.unit:GetObjectPosition(obj)
                    if x and y and z then
                        local dx, dy, dz = x - pX, y - pY, z - pZ
                        local dist = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
                        if not bestDist or dist < bestDist then
                            bestObj, bestDist = obj, dist
                        end
                    end
                end
            end
        end
    end

    return bestObj, bestDist, name
end

-- Returns player distance to the active totem in this slot.
-- Returns 0 when no totem exists, or its object can't be located.
function totem:slotDistance(slot)
    local haveTotem = self:getSlotInfo(slot)
    if not haveTotem then return 0 end
    local _, dist = self:getActiveObject(slot)
    return dist or 0
end

-- Returns the closest world object with the given localized name created by the player.
function totem:getObjectByName(name)
    if not name or name == "" then return nil, nil end
    if not br.unlocked or not br._G.GetObjectCount or not br._G.GetObjectWithIndex then
        return nil, nil
    end

    local pX, pY, pZ = br.functions.unit:GetObjectPosition("player")
    if not pX or not pY or not pZ then return nil, nil end

    local bestObj, bestDist
    for i = 1, br._G.GetObjectCount() do
        local obj = br._G.GetObjectWithIndex(i)
        if obj and br.functions.unit:GetObjectExists(obj) and br._G.UnitName(obj) == name then
            local creator = br._G.UnitCreator and br._G.UnitCreator(obj) or nil
            local isMine = creator == "player" or creator == "Player"
            if not isMine and creator and br._G.UnitIsUnit then
                isMine = br._G.UnitIsUnit(creator, "player")
            end

            if isMine then
                local x, y, z = br.functions.unit:GetObjectPosition(obj)
                if x and y and z then
                    local dx, dy, dz = x - pX, y - pY, z - pZ
                    local dist = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
                    if not bestDist or dist < bestDist then
                        bestObj, bestDist = obj, dist
                    end
                end
            end
        end
    end

    return bestObj, bestDist
end

-- Returns distance from player to a specific totem type (spell key/id/name).
-- Returns 0 if the totem isn't active (any slot) or can't be located.
function totem:distanceTo(candidate)
    local name = resolveCandidateName(candidate)
    if not name or name == "" then return 0 end
    if not self:anySlotMatchesAny(candidate) then return 0 end
    local _, dist = self:getObjectByName(name)
    return dist or 0
end
