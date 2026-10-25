-- br._G and its layers
-- Loaded before any file reads the game (BadRotations.lua, which only makes tables, comes first): everything
-- after it reads the game through br._G. Needs nothing from the client.
local _, br = ...

br.api = br.api or {}

-- br._G: the game's names as BR sees them. A name resolves through four layers, first match wins:
--   br.api.overrides  BR's own versions of game names (its tagged print, WriteFile's append)
--   br.api.wow        polyfills: the modern API where the client lacks it (shared.lua, <name>/Functions.lua)
--   br.unlockers.api  what the unlocker adapter installs: Unlockers/*.lua write into br._G, which lands here
--   the client's own globals
-- br.api.base is the two lower layers (the unlocker's version, else the client's). Polyfills read
-- through it, so they wrap the unlocker's function or namespace instead of replacing it.
local game = _G
br.unlockers = br.unlockers or {}
br.unlockers.api = br.unlockers.api or setmetatable({}, { __index = game })
br.api.base = br.unlockers.api
br.api.overrides = br.api.overrides or {}
br.api.wow = br.api.wow or {}
do
    local overrides, polyfills, unlocked = br.api.overrides, br.api.wow, br.unlockers.api
    br._G = setmetatable({}, {
        __index = function(_, name)
            local value = overrides[name]
            if value ~= nil then return value end
            value = polyfills[name]
            if value ~= nil then return value end
            return unlocked[name]
        end,
        __newindex = function(_, name, value) unlocked[name] = value end,
    })
end

-- Namespaces BR polyfills methods in: br._G.C_Spell (etc.) is this proxy. A method set on it (shared.lua,
-- <name>/Functions.lua) is the polyfill; any other method comes from the base namespace, the unlocker's
-- (NN's C_Spell) or else the client's, looked up when called, so an unlocker installed later is seen.
for _, name in ipairs({ "C_Spell", "C_UnitAuras", "C_Container", "C_SpellBook", "C_AddOns", "C_SpecializationInfo", "C_Item", "C_Map" }) do
    br.api.wow[name] = setmetatable({}, { __index = function(_, method)
        local namespace = br.api.base[name]
        return namespace and namespace[method]
    end })
end
