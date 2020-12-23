if br.api == nil then br.api = {} end

----------------------
--- ABOUT THIS API ---
----------------------

-- These calls help in retrieving information about spell cooldowns.
-- cd is the table located at br.player.cd, call this in profile to use.
-- id is the spellID passed from the builder which cycles all the collected ability spells from the spell list for the spec
-- spell in the examples represent the name in the ability list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua

br.api.cd = function(self,spell,id)
    if self.cd == nil then self.cd = {} end
    if self.cd[spell] == nil then self.cd[spell] = {} end
    local cd = self.cd


    ----------------
    --- CD API ---
    ----------------
    
    -- cd.spell.exists() - returns if spell is on cooldown or not
    cd[spell].exists = function()
        local level = UnitLevel("player")
        local spellLevel = GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and getSpellCD(id) or 99
        return spellCD > 0
    end
    -- cd.spell.remain() - return the time remaining on spell cooldown or 0 if not
    cd[spell].remain = function()
        local level = UnitLevel("player")
        local spellLevel = GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and getSpellCD(id) or 99
        return spellCD
    end
    -- cd.spell.remains() - return the time remaining on spell cooldown or 0 if not (alternate to cd.spell.remain() incase of typo)
    cd[spell].remains = function()
        local level = UnitLevel("player")
        local spellLevel = GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and getSpellCD(id) or 99
        return spellCD
    end
    -- cd.spell.duration() - returns the total time of the spell cooldown
    cd[spell].duration = function()
        local _, CD = GetSpellCooldown(id)
        return CD
    end
    -- cd.spell.ready() - returns if the spell is not on cooldown or is (opposite of cd.spell.exists())
    cd[spell].ready = function()
        local level = UnitLevel("player")
        local spellLevel = GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and getSpellCD(id) or 99
        return spellCD == 0
    end
end