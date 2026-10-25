-- br.game and its layers
-- Loaded before any file reads the game (BadRotations.lua, which only makes tables, comes first): everything
-- after it reads the game through br.game. Needs nothing from the client.
local _, br = ...

br.client = br.client or {}

-- br.game: the game's names as BR sees them. A name resolves through four layers, first match wins:
--   br.client.overrides  BR's own versions of game names (its tagged print, WriteFile's append)
--   br.client.polyfills        polyfills: the modern API where the client lacks it (Polyfills.lua, <name>/Functions.lua)
--   br.unlockers.functions  what the unlocker adapter installs: Unlockers/*.lua write into br.game, which lands here
--   the client's own globals
-- br.client.base is the two lower layers (the unlocker's version, else the client's). Polyfills read
-- through it, so they wrap the unlocker's function or namespace instead of replacing it.
local game = _G
br.unlockers = br.unlockers or {}
br.unlockers.functions = br.unlockers.functions or setmetatable({}, { __index = game })
br.client.base = br.unlockers.functions
br.client.overrides = br.client.overrides or {}
br.client.polyfills = br.client.polyfills or {}
do
    local overrides, polyfills, unlocked = br.client.overrides, br.client.polyfills, br.unlockers.functions
    br.game = setmetatable({}, {
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

-- Namespaces BR polyfills methods in: br.game.C_Spell (etc.) is this proxy. A method set on it (Polyfills.lua,
-- <name>/Functions.lua) is the polyfill; any other method comes from the base namespace, the unlocker's
-- (NN's C_Spell) or else the client's, looked up when called, so an unlocker installed later is seen.
for _, name in ipairs({ "C_Spell", "C_UnitAuras", "C_QuestLog", "C_Container", "C_SpellBook", "C_AddOns", "C_SpecializationInfo", "C_Item", "C_Map" }) do
    br.client.polyfills[name] = setmetatable({}, { __index = function(_, method)
        local namespace = br.client.base[name]
        return namespace and namespace[method]
    end })
end
