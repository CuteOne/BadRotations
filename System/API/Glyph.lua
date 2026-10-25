---
-- Glyph handling functions for BadRotations.
-- Glyph functions are the profile API table `glyph` (br.api.profile.glyph); profiles use it by name.
--
-- NOTE: On modern retail clients the classic glyph socket API may not exist; in that case glyph checks return false.
-- @module glyph
local _, br = ...

-- Base glyph API (table-level helpers)
br.api.build.glyph = function(api)
    local g = api.glyph

    local glyphFn = br.functions and br.functions.glyph

    --- Returns whether glyph API is available on this client.
    -- @function glyph.available
    -- @treturn boolean
    g.available = function()
        return glyphFn and glyphFn:isAvailable() or false
    end

    --- Returns true if the given glyph spellId is socketed.
    -- @function glyph.has
    -- @tparam number glyphSpellId
    -- @treturn boolean
    g.has = function(glyphSpellId)
        return glyphFn and glyphFn:hasGlyph(glyphSpellId) or false
    end
    -- Alias for readability.
    g.enabled = g.has

    --- Returns how many glyph sockets we can scan.
    -- @function glyph.socketCount
    -- @treturn number
    g.socketCount = function()
        return glyphFn and glyphFn:getSocketCount() or 0
    end
end

-- Per-glyph entry API
br.api.build.glyphs = function(glyphTable, k, v)
    local entry = glyphTable[k] or {}
    glyphTable[k] = entry

    local glyphFn = br.functions and br.functions.glyph

    --- Returns true if this glyph is NOT socketed.
    -- @function glyph.<k>.down
    -- @treturn boolean
    entry.down = function()
        return not entry.enabled()
    end

    --- Returns true if this glyph is socketed.
    -- @function glyph.<k>.enabled
    -- @treturn boolean
    entry.enabled = function()
        return glyphFn and glyphFn:hasGlyph(v) or false
    end
    -- Aliases commonly used in converted APLs.
    entry.exists = entry.enabled
    entry.up = entry.enabled

    --- Returns the glyph spellId.
    -- @function glyph.<k>.id
    -- @treturn number
    entry.id = function()
        return v
    end
end
