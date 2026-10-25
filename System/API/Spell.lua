---
-- These functions help in retrieving information about spells.
-- Spell functions are the profile API table `spell` (br.api.profile.spell); profiles use it by name.
-- `k` in the function represent the name in the actions list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- @module spell
local _, br = ...

br.api.build.spell = function(api, k, v)
    local spell = api.spell

    -- Spell Functions - [k] denotes placeholder for name of spell listed in System/Lists/Spells.lua
    -- @section spell[k]
    spell[k] = spell[k] or {}

    --- Returns the spell's cast time.
    -- @function spell.k.castTime
    -- @return number
    spell[k].castTime = function()
        local spellID = br.functions.spell:currentRank(v)
        local info = br.functions.spell:getInfo(spellID)
        return info and info.castTime or 0
    end

    --- Returns the spell's ID.
    -- @function spell.k.id
    -- @return number
    spell[k].id = function()
        local spellID = br.functions.spell:currentRank(v)
        return br.functions.spell:getSpellID(spellID) or 0
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
        local info = br.functions.spell:getInfo(spellID)
        return info and info.maxRange or 0
    end

    --- Returns the spell's min range.
    -- @function spell.k.minRange
    -- @return number
    spell[k].minRange = function()
        local spellID = br.functions.spell:currentRank(v)
        local info = br.functions.spell:getInfo(spellID)
        return info and info.minRange or 0
    end

    --- Returns the spell's name (localized).
    -- @function spell.k.name
    -- @return string
    spell[k].name = function()
        local spellID = br.functions.spell:currentRank(v)
        return br.functions.spell:getName(spellID) or ""
    end

    --- Returns the highest rank of the spell the player knows (0 when it isn't known; 1 on clients
    -- without ranks).
    -- @function spell.k.rank
    -- @return number
    spell[k].rank = function()
        return br.functions.spell:getKnownRank(v)
    end

    --- Returns the spell's icon texture.
    -- @function spell.k.texture
    -- @return number
    spell[k].texture = function()
        local spellID = br.functions.spell:currentRank(v)
        return br.functions.spell:getTexture(spellID)
    end
end
