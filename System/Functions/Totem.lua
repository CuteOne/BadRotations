local _, br = ...

---@class br.functions.totem
br.functions.totem = br.functions.totem or {}
local totem = br.functions.totem
-- A candidate's spell name: a spell ID, a spell list key (a ranked key resolves through its first
-- rank, since every rank shares the name) or a localized name as given.
local function resolveCandidateName(candidate)
    if not candidate then return nil end

    if type(candidate) == "number" then
        return br.functions.spell:getName(candidate)
    end

    if type(candidate) == "string" then
        return br.functions.spell:getKeyName(candidate) or candidate
    end

    return nil
end

-- True when a totem's name is the spell's name, with or without a rank numeral after it
-- ("Searing Totem VII" for Searing Totem on clients with spell ranks).
local function isTotemNamed(totemName, spellName)
    if not totemName or not spellName or spellName == "" then return false end
    if totemName == spellName then return true end
    return totemName:sub(1, #spellName + 1) == spellName .. " "
        and totemName:sub(#spellName + 2):match("^[IVXL]+$") ~= nil
end

function totem:anySlotMatchesAny(...)
    for slot = 1, 4 do
        if self:slotMatchesAny(slot, ...) then
            return true
        end
    end
    return false
end

-- Destroys the player's totem in a slot (what right-clicking its icon does), on clients where the
-- player can do that themselves (br.client.rules.canDestroyTotems: not before Wrath; BR does only what a
-- player could). True when it was asked; false otherwise, with no totem there, or a destroy asked under
-- a second ago (the game may ignore it, and a profile asks every tick).
local destroyAskedAt = {}
function totem:destroy(slot)
	if not br.client.rules.canDestroyTotems or not br.game.DestroyTotem or not self:getSlotInfo(slot) then return false end
	local now = br.game.GetTime()
	if destroyAskedAt[slot] and now - destroyAskedAt[slot] < 1 then return false end
	destroyAskedAt[slot] = now
	br.game.DestroyTotem(slot)
	return true
end

-- Returns distance from player to a specific totem type (spell key/id/name).
-- Returns 0 if the totem isn't active (any slot) or can't be located.
function totem:distanceTo(candidate)
    for slot = 1, 4 do
        if self:slotMatchesAny(slot, candidate) then return self:slotDistance(slot) end
    end
    return 0
end

-- Returns the closest world object that matches the active totem name in this slot.
-- @treturn any|nil object
-- @treturn number|nil distance Player->totem distance in yards (raw 3D), if found
-- @treturn string|nil name Active totem name for the slot
function totem:getActiveObject(slot)
    local haveTotem, name = self:getSlotInfo(slot)
    if not haveTotem or not name or name == "" then return nil, nil, nil end
    if not br.unlocked or not br.game.GetObjectCount or not br.game.GetObjectWithIndex then
        return nil, nil, name
    end

    local pX, pY, pZ = br.functions.unit:GetObjectPosition("player")
    if not pX or not pY or not pZ then return nil, nil, name end

    local bestObj, bestDist
    for i = 1, br.game.GetObjectCount() do
        local obj = br.game.GetObjectWithIndex(i)
        if obj and br.functions.unit:GetObjectExists(obj) then
            local objName = br.game.UnitName(obj)
            if isTotemNamed(objName, name) or isTotemNamed(name, objName) then
                local creator = br.game.UnitCreator and br.game.UnitCreator(obj) or nil
                local isMine = creator == "player" or creator == "Player"
                if not isMine and creator and br.game.UnitIsUnit then
                    isMine = br.game.UnitIsUnit(creator, "player")
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

function totem:getSlotInfo(slot)
    if not slot then return false, nil, 0, 0, nil end
    local haveTotem, name, startTime, duration, icon = br.game.GetTotemInfo(slot)
    if not haveTotem then
        return false, nil, 0, 0, nil
    end
    return true, name, startTime or 0, duration or 0, icon
end

-- Returns player distance to the active totem in this slot.
-- Returns 0 when no totem exists, or its object can't be located.
function totem:slotDistance(slot)
    local haveTotem = self:getSlotInfo(slot)
    if not haveTotem then return 0 end
    local _, dist = self:getActiveObject(slot)
    return dist or 0
end

-- Candidates can be:
-- - spell IDs (number)
-- - spell keys from br.runner.spells (string)
-- - literal localized names (string)
function totem:slotMatchesAny(slot, ...)
    local haveTotem, activeName = self:getSlotInfo(slot)
    if not haveTotem or not activeName or activeName == "" then return false end

    for i = 1, select('#', ...) do
        local candidate = select(i, ...)
        local candidateName

        candidateName = resolveCandidateName(candidate)

        if isTotemNamed(activeName, candidateName) then
            return true
        end
    end

    return false
end

function totem:slotRemains(slot)
    local haveTotem, _, startTime, duration = self:getSlotInfo(slot)
    if not haveTotem or duration <= 0 or startTime <= 0 then return 0 end
    local remaining = (startTime + duration) - br.game.GetTime()
    return remaining > 0 and remaining or 0
end
