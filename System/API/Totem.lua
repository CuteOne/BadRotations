---
-- Totem handling functions for BadRotations.
-- Totem functions are the profile API table `totem` (br.api.profile.totem); profiles use it by name.
--
-- This module provides a hierarchical API for totem checks:
-- - totem.active(candidate)       -> checks if any totem matching candidate is active
-- - totem.fire.active()           -> checks if any fire totem is active in slot 1
-- - totem.fire.searingTotem.active() -> checks if searing totem specifically is active
--
-- Slot indices: 1 = Fire, 2 = Earth, 3 = Water, 4 = Air.
-- @module totem
local _, br = ...

local TOTEM_SLOT = {
    fire = 1,
    earth = 2,
    water = 3,
    air = 4,
}

br.api.build.totem = function(api)
    local totem = api.totem

    local totemFn = br.functions.totem

    -- Export slot constants for rotations that want numeric slots.
    totem.slot = TOTEM_SLOT

    -- ========================================
    -- Generic Totem Functions (any slot)
    -- ========================================

    ---
    -- Returns true if the specified totem is currently active in any slot.
    -- Candidate can be a spell key, spell ID, or localized name.
    -- @function totem.active
    -- @tparam string|number candidate
    -- @treturn boolean
    totem.active = function(candidate)
        if not candidate then
            -- No candidate provided, check if ANY totem is active
            return totem.fire.active() or totem.earth.active() or totem.water.active() or totem.air.active()
        end

        return totemFn:anySlotMatchesAny(candidate)
    end

    ---
    -- Returns distance from player to the active totem in a slot.
    -- Returns 0 if no totem is active or the object can't be located (check active() first).
    -- @function totem.distance
    -- @tparam number|string slotOrCandidate Totem slot (1-4) or totem spell key/id/name
    -- @treturn number
    totem.distance = function(slotOrCandidate)
        -- If it's a number, treat as slot
        if type(slotOrCandidate) == "number" then
            return totemFn:slotDistance(slotOrCandidate)
        end

        -- Otherwise, treat as totem candidate
        return totemFn:distanceTo(slotOrCandidate)
    end

    ---
    -- Alias for active.
    -- @function totem.exists
    -- @tparam string|number candidate
    -- @treturn boolean
    totem.exists = function(candidate)
        return totem.active(candidate)
    end

    ---
    -- Returns raw slot info as reported by GetTotemInfo.
    -- @function totem.get
    -- @tparam number slot Totem slot (1-4)
    -- @treturn boolean haveTotem
    -- @treturn string|nil name
    -- @treturn number startTime
    -- @treturn number duration
    -- @treturn number|nil icon
    totem.get = function(slot)
        return totemFn:getSlotInfo(slot)
    end

    ---
    -- Returns true if the specified slot currently matches any provided totem.
    -- Candidates can be spell IDs (number), spell keys from br.runner.spells (string), or literal localized names (string).
    -- @function totem.is
    -- @tparam number slot Totem slot (1-4)
    -- @tparam ... candidates
    -- @treturn boolean
    totem.is = function(slot, ...)
        return totemFn:slotMatchesAny(slot, ...)
    end

    ---
    -- Returns remaining time for a slot (seconds), or 0.
    -- @function totem.remain
    -- @tparam number slot Totem slot (1-4)
    -- @treturn number
    totem.remain = function(slot)
        return totemFn:slotRemains(slot)
    end

    -- ========================================
    -- Element-specific Totem Tables
    -- ========================================

    totem.fire = br.api.build.totemElement(api, "fire", TOTEM_SLOT.fire)
    totem.earth = br.api.build.totemElement(api, "earth", TOTEM_SLOT.earth)
    totem.water = br.api.build.totemElement(api, "water", TOTEM_SLOT.water)
    totem.air = br.api.build.totemElement(api, "air", TOTEM_SLOT.air)
end

---
-- Builds an element subtable (e.g., totem.fire) for br.api.build.totem.
br.api.build.totemElement = function(api, elementKey, slot)
    local totemFn = br.functions.totem
    local element = {}
    element.slot = slot

    --- Check if any totem in this element slot is active.
    -- @function totem.<element>.active
    -- @treturn boolean
    element.active = function()
        local haveTotem = totemFn:getSlotInfo(slot)
        return haveTotem == true
    end
    --- Alias for active.
    -- @function totem.<element>.exists
    -- @treturn boolean
    element.exists = element.active

    --- Get distance to the active totem in this slot (0 when there is none, or it can't be located).
    -- @function totem.<element>.distance
    -- @treturn number
    element.distance = function()
        return totemFn:slotDistance(slot)
    end

    --- Get duration for the active totem in this slot.
    -- @function totem.<element>.duration
    -- @treturn number
    element.duration = function()
        local haveTotem, _, _, duration = totemFn:getSlotInfo(slot)
        return haveTotem and duration or 0
    end

    --- Check if the active totem matches any of the provided candidates.
    -- @function totem.<element>.is
    -- @tparam ... candidates
    -- @treturn boolean
    element.is = function(...)
        return totemFn:slotMatchesAny(slot, ...)
    end

    --- Get the name of the active totem in this slot.
    -- @function totem.<element>.name
    -- @treturn string|nil
    element.name = function()
        local haveTotem, name = totemFn:getSlotInfo(slot)
        return haveTotem and name or nil
    end

    --- Get remaining time for the active totem in this slot.
    -- @function totem.<element>.remain
    -- @treturn number
    element.remain = function()
        return totemFn:slotRemains(slot)
    end

    -- Build specific totem subtables for this element from spell list
    if br.runner.spells and br.runner.spells.totem and br.runner.spells.totem[elementKey] then
        for totemKey, _ in pairs(br.runner.spells.totem[elementKey]) do
            -- Convert totemKey to camelCase if needed (e.g., searingTotem -> searing)
            -- Extract the totem name without "Totem" suffix for cleaner API
            local shortName = totemKey:gsub("Totem$", "")
            shortName = shortName:sub(1,1):lower() .. shortName:sub(2)
            element[shortName] = br.api.build.totemSpecific(slot, totemKey)
        end
    end

    return element
end

---
-- Builds a specific totem subtable (e.g., totem.fire.searing) for br.api.build.totemElement.
br.api.build.totemSpecific = function(slot, totemKey)
    local totemFn = br.functions.totem
    local specific = {}

    --- Check if this specific totem is active.
    -- @function totem.<element>.<totemName>.active
    -- @treturn boolean
    specific.active = function()
        return totemFn:slotMatchesAny(slot, totemKey)
    end
    --- Alias for active.
    -- @function totem.<element>.<totemName>.exists
    -- @treturn boolean
    specific.exists = specific.active

    --- Get distance to this specific totem (0 when it isn't up, or it can't be located).
    -- @function totem.<element>.<totemName>.distance
    -- @treturn number
    specific.distance = function()
        if not specific.active() then return 0 end
        return totemFn:slotDistance(slot)
    end

    --- Get duration for this specific totem.
    -- @function totem.<element>.<totemName>.duration
    -- @treturn number
    specific.duration = function()
        if not specific.active() then return 0 end
        local haveTotem, _, _, duration = totemFn:getSlotInfo(slot)
        return haveTotem and duration or 0
    end

    --- Get the name of this totem if active.
    -- @function totem.<element>.<totemName>.name
    -- @treturn string|nil
    specific.name = function()
        if not specific.active() then return nil end
        local haveTotem, name = totemFn:getSlotInfo(slot)
        return haveTotem and name or nil
    end

    --- Get remaining time for this specific totem.
    -- @function totem.<element>.<totemName>.remain
    -- @treturn number
    specific.remain = function()
        if not specific.active() then return 0 end
        return totemFn:slotRemains(slot)
    end

    return specific
end
