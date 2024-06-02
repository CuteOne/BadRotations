---
-- These functions help in retrieving information about spell and item cooldowns.
-- CD functions are stored in br.player.cd and can be utilized by `local cd = br.player.cd` in your profile.
-- For spell CDs, `spell` in the function represent the name in the actions list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- For item CDs, `item` in the function represent the name in the item list defined in System/List/Items.lua
-- For slot CDs, `slot` in the function represents equipement slots, pass the ID matching the equipement slot id you wish to check.
-- @module br.player.cd
local _, br = ...

if br.api == nil then br.api = {} end

br.api.cd = function(self, spell, id)
    self.cd = self.cd or {}
    local cd = self.cd

    --- Spell Cooldown Functions - [spell] denotes placeholder for name of spell listed in System/Lists/Spells.lua
    -- @section cd[spell]
    cd[spell] = cd[spell] or {}

    --- Checks if spell is on cooldown or not.
    -- @function cd.spell.exists
    -- @return boolean
    -- @within cd.spell
    cd[spell].exists = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD > 0
    end

    --- Gets the time remaining on spell cooldown or 0 if not.
    -- @function cd.spell.remain
    -- @return number
    -- @within cd.spell
    cd[spell].remain = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD
    end

    --- Gets the time remaining on spell cooldown or 0 if not (alternate to cd.spell.remain() incase of typo).
    -- @function cd.spell.remains
    -- @return number
    -- @within cd.spell
    cd[spell].remains = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD
    end

    --- Gets the total time of the spell cooldown
    -- @function cd.spell.duration
    -- @return number
    -- @within cd.spell
    cd[spell].duration = function()
        local _, CD = br._G.GetSpellCooldown(id)
        return CD
    end

    --- Checks if the spell is not on cooldown or is (opposite of cd.spell.exists()).
    -- @function cd.spell.ready
    -- @return boolean
    -- @within cd.spell
    cd[spell].ready = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD == 0
    end

    --- Gets the duration of the spells Global Cooldown.
    -- @function cd.spell.prevgcd
    -- @return number
    -- @within cd.spell
    cd[spell].prevgcd = function()
        return select(2, br._G.GetSpellBaseCooldown(id))
    end
end

br.api.itemCD = function(self, item, id)
    --if self[item] == nil then self[item] = {} end
    local cd = self

    --- Item Cooldown Functions - [item] denotes placeholder for name of item listed in System/Lists/Items.lua
    -- @section cd[item]
    cd[item] = cd[item] or {}

    --- Checks if item is on cooldown or not.
    -- @function cd.item.exists
    -- @return boolean
    -- @within cd.item
    cd[item].exists = function()
        return br._G.GetItemCooldown(id) > 0
    end

    --- Gets the time remaining on item cooldown or 0 if not.
    -- @function cd.item.remain
    -- @return number
    -- @within cd.item
    cd[item].remain = function()
        if br._G.GetItemCooldown(id) ~= 0 then
            return (br._G.GetItemCooldown(id) + select(2, br._G.GetItemCooldown(id)) - br._G.GetTime())
        end
        return 0
    end

    --- Gets the total cooldown time of the item in seconds.
    -- @function cd.item.duration
    -- @return number
    -- @within cd.item
    cd[item].duration = function()
        return br._G.GetSpellBaseCooldown(select(2, br._G.GetItemSpell(id))) / 1000
    end

    --- Equipment Slot Cooldown Functions
    -- @section cd.slot
    cd.slot = cd.slot or {}

    --- This function gets the base cooldown of a given item spell from an inventory slot, specific to the player character in game.
    -- @param slotID - The ID of the inventory slot.
    -- @return number - The base cooldown of the item spell divided by 1000.
    -- This division is done to convert the time from milliseconds to seconds.
    -- @within cd.slot
    cd.slot.duration = function(slotID)
        if slotID == nil then return nil end
        local _, duration = br._G.GetInventoryItemCooldown("player", slotID)
        return duration
    end

    --- This function returnsif the item slot is on cooldown or note
    -- @para, slotID - The ID of the inventory slot.
    -- @retrn boolean - Inventory slot is on cooldown or not.
    -- @within cd.slot
    cd.slot.exists = function(slotID)
        if slotID == nil then return false end
        return cd.slot.remain(slotID) > 0
    end

    --- Gets the time remaining on the equipment slot item cooldown or 0 if not.
    -- @function cd.slot.remain
    -- @param slotID - The ID of the equipment slot to check.
    -- @return number
    -- @within cd.slot
    cd.slot.remain = function(slotID)
        if slotID == nil then return nil end
        local start, duration, enable = br._G.GetInventoryItemCooldown("player", slotID)
        if enable == 0 or duration == 0 then
            return 0 -- No cooldown is active, or the item has no cooldown
        else
            local currentTime = br._G.GetTime()
            local endTime = start + duration
            local timeRemaining = endTime - currentTime
            if timeRemaining < 0 then
                timeRemaining = 0 -- To avoid negative values if checked right as cooldown ends
            end
            return timeRemaining
        end
    end

    --- Gets the time remaining on the equipment slot item cooldown or 0 if not.
    -- @function cd.slot.remains
    -- @param slotID - The ID of the equipment slot to check.
    -- @return number
    -- @within cd.slot
    -- @see cd.slot.remain
    cd.slot.remains = function(slotID)
        return cd.slot.remain(slotID)
    end

    --- Returns if the item slot is off CD or not
    -- @function cd.slot.ready
    -- @param slotID - The ID of the equipment slot to check.
    -- @return number
    -- @within cd.slot
    cd.slot.ready = function(slotID)
        return cd.slot.remain(slotID) == 0
    end
end
