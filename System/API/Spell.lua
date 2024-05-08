---
-- These functions help in retrieving information about spells.
-- Spell functions are stored in br.player.spell and can be utilized by `local spell = br.player.spell in your profile.
-- `k` in the function represent the name in the actions list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- @module br.player.spell
local _, br = ...
if br.api == nil then br.api = {} end

br.api.spell = function(self, k, v)
    self.spell = self.spell or {}
    local spell = self.spell

    -- Spell Functions - [k] denotes placeholder for name of spell listed in System/Lists/Spells.lua
    -- @section spell[k]
    spell[k] = spell[k] or {}

    --- Returns the spell's cast time.
    -- @function spell.k.castTime
    -- @return number
    spell[k].castTime = function()
        local _, _, _, castTime = GetSpellInfo(v)
        return castTime or 0
    end

    --- Returns the spell's ID.
    -- @function spell.k.id
    -- @return number
    spell[k].id = function()
        local _, _, _, _, _, _, spellID = GetSpellInfo(v)
        return spellID or 0
    end

    --- Checks if the spell is known.
    -- @function spell.k.known
    -- @return boolean
    spell[k].known = function()
        return br.isKnown(v)
    end

    --- Returns the spell's max range.
    -- @function spell.k.maxRange
    -- @return number
    spell[k].maxRange = function()
        local _, _, _, _, _, maxRange = GetSpellInfo(v)
        return maxRange or 0
    end

    --- Returns the spell's min range.
    -- @function spell.k.minRange
    -- @return number
    spell[k].minRange = function()
        local _, _, _, _, minRange = GetSpellInfo(v)
        return minRange or 0
    end

    --- Returns the spell's name (localized).
    -- @function spell.k.name
    -- @return string
    spell[k].name = function()
        local name = GetSpellInfo(v)
        return name or ""
    end

    --- Returns the spell's rank.
    -- @function spell.k.rank
    -- @return number
    spell[k].rank = function()
        local _, rank = GetSpellInfo(v)
        return rank or 0
    end

    --- Returns the spell's icon texture.
    -- @function spell.k.texture
    -- @return number
    spell[k].texture = function()
        return br._G.GetSpellTexture(v)
    end
end
