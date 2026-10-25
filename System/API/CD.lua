---
-- These functions help in retrieving information about spell and item cooldowns.
-- CD functions are the profile API table `cd` (br.api.profile.cd); profiles use it by name.
-- For spell CDs, `spell` in the function represent the name in the actions list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- For item CDs, `item` in the function represent the name in the item list defined in System/List/Items.lua
-- For slot CDs, `slot` in the function represents equipement slots, pass the ID matching the equipement slot id you wish to check.
-- @module cd
local _, br = ...


-- The spell a cooldown is read from (the global cooldown's spell for "global"), and whether the player's
-- level has reached the level it's learned at
local function cooldownSpell(spell, id)
    local spellID = spell == "global" and br.functions.spell:getGCDSpellID() or br.functions.spell:currentRank(id)
    return spellID, br.functions.spell:isLevelReached(spellID)
end

br.api.build.cd = function(api, spell, id)
    local cd = api.cd

    --- Spell Cooldown Functions
    -- @section cd.spell
    cd[spell] = cd[spell] or {}

    --- Gets the total time of the spell cooldown
    -- @function cd.spell.duration
    -- @return number
    -- @within cd.spell
    cd[spell].duration = function()
        local spellID, learned = cooldownSpell(spell, id)
        if not learned then return 0 end
        return br.functions.spell:getCooldownDuration(spellID)
    end

    --- Checks if spell is on cooldown or not.
    -- @function cd.spell.exists
    -- @return boolean
    -- @within cd.spell
    cd[spell].exists = function()
        local spellID, learned = cooldownSpell(spell, id)
        if not learned then return false end
        local spellCD = br.functions.spell:getSpellCD(spellID)
        return spellCD > 0
    end

    --- Gets the duration of the spells Global Cooldown.
    -- @function cd.spell.prevgcd
    -- @return number
    -- @within cd.spell
    cd[spell].prevgcd = function()
        local spellID = br.functions.spell:currentRank(id)
        return select(2, br.functions.spell:getBaseCooldown(spellID))
    end

    --- Checks if the spell is not on cooldown or is (opposite of cd.spell.exists()).
    -- @function cd.spell.ready
    -- @return boolean
    -- @within cd.spell
    cd[spell].ready = function()
        local spellID, learned = cooldownSpell(spell, id)
        if not learned then return false end
        return br.functions.spell:getSpellCD(spellID) == 0
    end

    --- Gets the time remaining on spell cooldown or 0 if not.
    -- @function cd.spell.remain
    -- @return number
    -- @within cd.spell
    cd[spell].remain = function()
        local spellID, learned = cooldownSpell(spell, id)
        if not learned then return 99 end
        return br.functions.spell:getSpellCD(spellID)
    end

    --- Gets the time remaining on spell cooldown or 0 if not (alternate to cd.spell.remain() incase of typo).
    -- @function cd.spell.remains
    -- @return number
    -- @within cd.spell
    cd[spell].remains = function()
        local spellID, learned = cooldownSpell(spell, id)
        if not learned then return 99 end
        return br.functions.spell:getSpellCD(spellID)
    end
end

br.api.build.itemCD = function(api, item, id)
    --if api[item] == nil then api[item] = {} end
    local cd = api

    --- Item Cooldown Functions
    -- @section cd.item
    cd[item] = cd[item] or {}

    --- Equipment Slot Cooldown Functions
    -- @section cd.slot
    cd.slot = cd.slot or {}

    --- Gets the total cooldown time of the item in seconds.
    -- @function cd.item.duration
    -- @return number
    -- @within cd.item
    cd[item].duration = function()
        return br.functions.item:getBaseCooldown(id)
    end

    --- Checks if item is on cooldown or not.
    -- @function cd.item.exists
    -- @return boolean
    -- @within cd.item
    cd[item].exists = function()
        return (br.functions.item:getCooldown(id)) > 0
    end

    --- Gets the time remaining on item cooldown or 0 if not.
    -- @function cd.item.remain
    -- @return number
    -- @within cd.item
    cd[item].remain = function()
        local start, duration = br.functions.item:getCooldown(id)
        if start ~= 0 then
            return start + duration - br.functions.misc:getTime()
        end
        return 0
    end

    --- Gets the base cooldown of a given item spell from an inventory slot (in seconds).
    -- @function cd.slot.duration
    -- @param slotID number The ID of the inventory slot.
    -- @return number The base cooldown of the item spell divided by 1000.
    -- @within cd.slot
    cd.slot.duration = function(slotID)
        if slotID == nil then return nil end
        local _, duration = br.functions.item:getSlotCooldown(slotID)
        return duration
    end

    --- Checks if the item slot is on cooldown or not.
    -- @function cd.slot.exists
    -- @param slotID number The ID of the inventory slot.
    -- @return boolean Inventory slot is on cooldown or not.
    -- @within cd.slot
    cd.slot.exists = function(slotID)
        if slotID == nil then return false end
        return cd.slot.remain(slotID) > 0
    end

    --- Checks if the item slot is off cooldown or not.
    -- @function cd.slot.ready
    -- @param slotID number The ID of the equipment slot to check.
    -- @return boolean True if the slot is ready (not on cooldown).
    -- @within cd.slot
    cd.slot.ready = function(slotID)
        return cd.slot.remain(slotID) == 0
    end

    --- Gets the time remaining on the equipment slot item cooldown or 0 if not.
    -- @function cd.slot.remain
    -- @param slotID number The ID of the equipment slot to check.
    -- @return number
    -- @within cd.slot
    cd.slot.remain = function(slotID)
        if slotID == nil then return nil end
        local start, duration, enable = br.functions.item:getSlotCooldown(slotID)
        if enable == 0 or duration == 0 then
            return 0 -- No cooldown is active, or the item has no cooldown
        else
            local currentTime = br.functions.misc:getTime()
            local endTime = start + duration
            local timeRemaining = endTime - currentTime
            if timeRemaining < 0 then
                timeRemaining = 0 -- To avoid negative values if checked right as cooldown ends
            end
            return timeRemaining
        end
    end

    --- Gets the time remaining on the equipment slot item cooldown or 0 if not (alias for cd.slot.remain).
    -- @function cd.slot.remains
    -- @param slotID number The ID of the equipment slot to check.
    -- @return number
    -- @within cd.slot
    -- @see cd.slot.remain
    cd.slot.remains = function(slotID)
        return cd.slot.remain(slotID)
    end
end
