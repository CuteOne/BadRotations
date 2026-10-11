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
        local spellID = br.functions.spell:currentRank(v)
        local _, _, _, castTime = br.api.wow.GetSpellInfo(spellID)
        return castTime or 0
    end

    --- Returns the spell's ID.
    -- @function spell.k.id
    -- @return number
    spell[k].id = function()
        local spellID = br.functions.spell:currentRank(v)
        local _, _, _, _, _, _, realID = br.api.wow.GetSpellInfo(spellID)
        return realID or 0
    end

    --- For a combo point finisher (Ferocious Bite, Eviscerate, ...): true when it's sure to kill the unit
    -- at your current combo points and Energy, from the damage the tooltip lists. Never true on dummies.
    -- @function spell.k.kills
    -- @param[opt="target"] thisUnit The unit to finish
    -- @return boolean
    -- @usage if spell.ferociousBite.kills(units.dyn5) and cast.able.ferociousBite(units.dyn5) then
    spell[k].kills = function(thisUnit)
        return br.functions.spell:finisherKills(br.functions.spell:currentRank(v), thisUnit)
    end

    --- Checks if the spell is known.
    -- @function spell.k.known
    -- @return boolean
    spell[k].known = function()
        return br.functions.spell:isKnown(v)
    end

    --- Returns the spell's max range.
    -- @function spell.k.maxRange
    -- @return number
    spell[k].maxRange = function()
        local spellID = br.functions.spell:currentRank(v)
        local _, _, _, _, _, maxRange = br.api.wow.GetSpellInfo(spellID)
        return maxRange or 0
    end

    --- Returns the spell's min range.
    -- @function spell.k.minRange
    -- @return number
    spell[k].minRange = function()
        local spellID = br.functions.spell:currentRank(v)
        local _, _, _, _, minRange = br.api.wow.GetSpellInfo(spellID)
        return minRange or 0
    end

    --- Returns the spell's name (localized).
    -- @function spell.k.name
    -- @return string
    spell[k].name = function()
        local spellID = br.functions.spell:currentRank(v)
        local name = br.api.wow.GetSpellInfo(spellID)
        return name or ""
    end

    --- Returns the spell's rank.
    -- @function spell.k.rank
    -- @return number
    spell[k].rank = function()
        local spellID = br.functions.spell:currentRank(v)
        local _, rank = br.api.wow.GetSpellInfo(spellID)
        return rank or 0
    end

    --- Returns the spell's icon texture.
    -- @function spell.k.texture
    -- @return number
    spell[k].texture = function()
        local spellID = br.functions.spell:currentRank(v)
        return br._G.C_Spell.GetSpellTexture(spellID)
    end
end
