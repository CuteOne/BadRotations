---
-- Totem handling functions for BadRotations.
-- Totem functions are stored in br.player.totem and can be utilized by `local totem = br.player.totem` in your profile.
--
-- This module provides a hierarchical API for totem checks:
-- - totem.active(candidate)       -> checks if any totem matching candidate is active
-- - totem.fire.active()           -> checks if any fire totem is active in slot 1
-- - totem.fire.searingTotem.active() -> checks if searing totem specifically is active
--
-- Slot indices: 1 = Fire, 2 = Earth, 3 = Water, 4 = Air.
-- @module br.player.totem
local _, br = ...
if br.api == nil then br.api = {} end

local TOTEM_SLOT = {
    fire = 1,
    earth = 2,
    water = 3,
    air = 4,
}

br.api.totem = function(self)
    self.totem = self.totem or {}
    local totem = self.totem

    local totemFn = br.functions and br.functions.totem

    -- Export slot constants for rotations that want numeric slots.
    totem.slot = TOTEM_SLOT

    ---
    -- Build a specific totem subtable (e.g., totem.fire.searingTotem)
    -- @local
    local function buildSpecificTotem(element, slot, totemKey)
        local specific = {}

        --- Check if this specific totem is active.
        -- @function totem.element.totemName.active
        -- @treturn boolean
        specific.active = function()
            if not totemFn then return false end
            return totemFn:slotMatchesAny(slot, totemKey)
        end

        --- Alias for active.
        -- @function totem.element.totemName.exists
        -- @treturn boolean
        specific.exists = specific.active

        --- Get remaining time for this specific totem.
        -- @function totem.element.totemName.remain
        -- @treturn number
        specific.remain = function()
            if not specific.active() then return 0 end
            if not totemFn then return 0 end
            return totemFn:slotRemains(slot)
        end

        --- Get duration for this specific totem.
        -- @function totem.element.totemName.duration
        -- @treturn number
        specific.duration = function()
            if not specific.active() then return 0 end
            if not totemFn then return 0 end
            local haveTotem, _, _, duration = totemFn:getSlotInfo(slot)
            return haveTotem and duration or 0
        end

        --- Get distance to this specific totem.
        -- @function totem.element.totemName.distance
        -- @treturn number
        specific.distance = function()
            if not specific.active() then return 999 end
            if not totemFn or not totemFn.slotDistance then return 999 end
            return totemFn:slotDistance(slot)
        end

        --- Get the name of this totem if active.
        -- @function totem.element.totemName.name
        -- @treturn string|nil
        specific.name = function()
            if not specific.active() then return nil end
            if not totemFn then return nil end
            local haveTotem, name = totemFn:getSlotInfo(slot)
            return haveTotem and name or nil
        end

        return specific
    end

    ---
    -- Build an element subtable (e.g., totem.fire)
    -- @local
    local function buildElementSubtable(elementKey, slot)
        local element = {}
        element.slot = slot

        --- Check if any totem in this element slot is active.
        -- @function totem.element.active
        -- @treturn boolean
        element.active = function()
            if not totemFn then return false end
            local haveTotem = totemFn:getSlotInfo(slot)
            return haveTotem == true
        end

        --- Alias for active.
        -- @function totem.element.exists
        -- @treturn boolean
        element.exists = element.active

        --- Get the name of the active totem in this slot.
        -- @function totem.element.name
        -- @treturn string|nil
        element.name = function()
            if not totemFn then return nil end
            local haveTotem, name = totemFn:getSlotInfo(slot)
            return haveTotem and name or nil
        end

        --- Get remaining time for the active totem in this slot.
        -- @function totem.element.remain
        -- @treturn number
        element.remain = function()
            if not totemFn then return 0 end
            return totemFn:slotRemains(slot)
        end

        --- Get duration for the active totem in this slot.
        -- @function totem.element.duration
        -- @treturn number
        element.duration = function()
            if not totemFn then return 0 end
            local haveTotem, _, _, duration = totemFn:getSlotInfo(slot)
            return haveTotem and duration or 0
        end

        --- Get distance to the active totem in this slot.
        -- @function totem.element.distance
        -- @treturn number
        element.distance = function()
            if not totemFn or not totemFn.slotDistance then return 999 end
            return totemFn:slotDistance(slot)
        end

        --- Check if the active totem matches any of the provided candidates.
        -- @function totem.element.is
        -- @tparam ... candidates
        -- @treturn boolean
        element.is = function(...)
            if not totemFn then return false end
            return totemFn:slotMatchesAny(slot, ...)
        end

        -- Build specific totem subtables for this element from spell list
        if self.spells and self.spells.totem and self.spells.totem[elementKey] then
            for totemKey, _ in pairs(self.spells.totem[elementKey]) do
                -- Convert totemKey to camelCase if needed (e.g., searingTotem -> searing)
                -- Extract the totem name without "Totem" suffix for cleaner API
                local shortName = totemKey:gsub("Totem$", "")
                shortName = shortName:sub(1,1):lower() .. shortName:sub(2)
                element[shortName] = buildSpecificTotem(elementKey, slot, totemKey)
            end
        end

        return element
    end

    -- ========================================
    -- Generic Totem Functions (any slot)
    -- ========================================

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
        if not totemFn then return false, nil, 0, 0, nil end
        return totemFn:getSlotInfo(slot)
    end

    ---
    -- Returns remaining time for a slot (seconds), or 0.
    -- @function totem.remain
    -- @tparam number slot Totem slot (1-4)
    -- @treturn number
    totem.remain = function(slot)
        if not totemFn then return 0 end
        return totemFn:slotRemains(slot)
    end

    ---
    -- Returns distance from player to the active totem in a slot.
    -- Returns 999 if no totem is active or the object can't be located.
    -- @function totem.distance
    -- @tparam number|string slotOrCandidate Totem slot (1-4) or totem spell key/id/name
    -- @treturn number
    totem.distance = function(slotOrCandidate)
        if not totemFn then return 999 end

        -- If it's a number, treat as slot
        if type(slotOrCandidate) == "number" then
            if not totemFn.slotDistance then return 999 end
            return totemFn:slotDistance(slotOrCandidate)
        end

        -- Otherwise, treat as totem candidate
        if not totemFn.distanceTo then return 999 end
        return totemFn:distanceTo(slotOrCandidate)
    end

    ---
    -- Returns true if the specified slot currently matches any provided totem.
    -- Candidates can be spell IDs (number), spell keys from br.player.spells (string), or literal localized names (string).
    -- @function totem.is
    -- @tparam number slot Totem slot (1-4)
    -- @tparam ... candidates
    -- @treturn boolean
    totem.is = function(slot, ...)
        if not totemFn then return false end
        return totemFn:slotMatchesAny(slot, ...)
    end

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

        if not totemFn then return false end
        return totemFn:anySlotMatchesAny(candidate)
    end

    ---
    -- Alias for active.
    -- @function totem.exists
    -- @tparam string|number candidate
    -- @treturn boolean
    totem.exists = function(candidate)
        return totem.active(candidate)
    end

    -- ========================================
    -- Element-specific Totem Tables
    -- ========================================

    totem.fire = buildElementSubtable("fire", TOTEM_SLOT.fire)
    totem.earth = buildElementSubtable("earth", TOTEM_SLOT.earth)
    totem.water = buildElementSubtable("water", TOTEM_SLOT.water)
    totem.air = buildElementSubtable("air", TOTEM_SLOT.air)
end
