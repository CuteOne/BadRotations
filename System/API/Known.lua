---
-- These functions help in retrieving information about spell knowledge.
-- Known functions are stored in br.player.known and can be utilized by `local known = br.player.known` in your profile.
-- For spell known, `spell` in the function represent the name in the actions list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- @module br.player.known
local _, br = ...
if br.api == nil then br.api = {} end

br.api.known = function(self,spell,id)
    if self[spell] == nil then self[spell] = {} end
    local known = self

    --- ### Spell Known Functions

    --- Checks if spell is known or not.
    -- @function known.spell
    -- @treturn boolean
    known[spell] = function()
        return br.isKnown(id)
    end
end