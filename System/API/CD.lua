---
-- These calls help in retrieving information about spell cooldowns.
-- CD functions are stored in br.player.cd and can be utilized by `local cd = br.player.cd` in your profile.
-- `spell` in the function represent the name in the actions list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- @module br.player.cd
local _, br = ...
if br.api == nil then br.api = {} end

br.api.cd = function(self,spell,id)
    if self.cd == nil then self.cd = {} end
    if self.cd[spell] == nil then self.cd[spell] = {} end
    local cd = self.cd

    --- Checks if spell is on cooldown or not.
    -- @function br.player.cd.spell.exists
    -- @treturn boolean
    cd[spell].exists = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD > 0
    end

    --- Gets the time remaining on spell cooldown or 0 if not.
    -- @function br.player.cd.spell.remain
    -- @treturn number
    cd[spell].remain = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD
    end

    --- Gets the time remaining on spell cooldown or 0 if not (alternate to cd.spell.remain() incase of typo).
    -- @function br.player.cd.spell.remains
    -- @treturn number
    cd[spell].remains = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD
    end

    --- Gets the total time of the spell cooldown
    -- @function br.player.cd.spell.duration
    -- @treturn number
    cd[spell].duration = function()
        local _, CD = br._G.GetSpellCooldown(id)
        return CD
    end

    --- Checks if the spell is not on cooldown or is (opposite of cd.spell.exists()).
    -- @function br.player.cd.spell.ready
    -- @treturn boolean
    cd[spell].ready = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD == 0
    end

    --- Gets the duration of the spells Global Cooldown.
    -- @function br.player.cd.spell.prevgcd
    -- @treturn number
    cd[spell].prevgcd = function()
        return select(2, br._G.GetSpellBaseCooldown(id))
    end
end