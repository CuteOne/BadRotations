local _, br = ...

br.functions.glyph = br.functions.glyph or {}
local glyph = br.functions.glyph

-- Defensive wrapper: retail clients may not support classic glyph APIs.
function glyph:isAvailable()
    return type(br._G.GetGlyphSocketInfo) == "function"
end

function glyph:getSocketCount()
    if type(br._G.GetNumGlyphSockets) == "function" then
        local n = br._G.GetNumGlyphSockets()
        if type(n) == "number" and n > 0 then
            return n
        end
    end
    -- Legacy: historically 6 glyph sockets.
    return 6
end

-- Returns true if a glyph (by glyphSpellId) is currently socketed.
function glyph:hasGlyph(glyphSpellId)
    if type(glyphSpellId) ~= "number" or glyphSpellId <= 0 then return false end
    if not self:isAvailable() then return false end

    local socketCount = self:getSocketCount()
    for i = 1, socketCount do
        -- Historically, socket info includes the current glyph spell ID in either the 4th or 6th return value.
        local _, _, _, glyphId1, _, glyphId2 = br._G.GetGlyphSocketInfo(i)
        if glyphId1 == glyphSpellId or glyphId2 == glyphSpellId then
            return true
        end
    end

    return false
end
