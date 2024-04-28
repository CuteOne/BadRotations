---
-- These functions help in retrieving information about spell and item cooldowns.
-- CD functions are stored in br.player.cd and can be utilized by `local cd = br.player.cd` in your profile.
-- For spell CDs, `spell` in the function represent the name in the actions list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- For item CDs, `item` in the function represent the name in the item list defined in System/List/Items.lua
-- @module br.player.cd
local _, br = ...

if br.api == nil then br.api = {} end

br.api.cd = function(self,spell,id)
    if self.cd == nil then self.cd = {} end
    -- if self.cd[spell] == nil then self.cd[spell] = {} end
    local cd = self.cd

    cd[spell] = cd[spell] or {}

    --- Checks if spell is on cooldown or not.
    -- @function cd.spell.exists
    -- @treturn boolean
    -- @within cd.spell
    cd[spell].exists = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD > 0
    end

    --- Gets the time remaining on spell cooldown or 0 if not.
    -- @function cd.spell.remain
    -- @treturn number
    -- @within cd.spell
    cd[spell].remain = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD
    end

    --- Gets the time remaining on spell cooldown or 0 if not (alternate to cd.spell.remain() incase of typo).
    -- @function cd.spell.remains
    -- @treturn number
    -- @within cd.spell
    cd[spell].remains = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD
    end

    --- Gets the total time of the spell cooldown
    -- @function cd.spell.duration
    -- @treturn number
    -- @within cd.spell
    cd[spell].duration = function()
        local _, CD = br._G.GetSpellCooldown(id)
        return CD
    end

    --- Checks if the spell is not on cooldown or is (opposite of cd.spell.exists()).
    -- @function cd.spell.ready
    -- @treturn boolean
    -- @within cd.spell
    cd[spell].ready = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD == 0
    end

    --- Gets the duration of the spells Global Cooldown.
    -- @function cd.spell.prevgcd
    -- @treturn number
    -- @within cd.spell
    cd[spell].prevgcd = function()
        return select(2, br._G.GetSpellBaseCooldown(id))
    end
end

br.api.itemCD = function(self,item,id)
    --if self[item] == nil then self[item] = {} end
    local cd = self

    cd[item] = cd[item] or {}

    --- Checks if item is on cooldown or not.
    -- @function cd.item.exists
    -- @number[opt] itemID The ID of the item to check.
    -- @treturn boolean
    -- @within cd.item
    cd[item].exists = function(itemID)
        if itemID == nil then itemID = id end
        return br._G.GetItemCooldown(itemID) > 0
    end

    --- Gets the time remaining on item cooldown or 0 if not.
    -- @function cd.item.remain
    -- @number[opt] itemID The ID of the item to check.
    -- @treturn number
    -- @within cd.item
    cd[item].remain = function(itemID)
        if itemID == nil then itemID = id end
        if br._G.GetItemCooldown(itemID) ~= 0 then
            return (br._G.GetItemCooldown(itemID) + select(2,br._G.GetItemCooldown(itemID)) - br._G.GetTime())
        end
        return 0
    end

    --- Gets the total cooldown time of the item in seconds.
    -- @function cd.item.duration
    -- @number[opt] itemID The ID of the item to check.
    -- @treturn number
    -- @within cd.item
    cd[item].duration = function(itemID)
        if itemID == nil then itemID = id end
        return br._G.GetSpellBaseCooldown(select(2,br._G.GetItemSpell(itemID))) / 1000
    end

    cd.slot = cd.slot or {}

    --- This function gets the base cooldown of a given item spell
    -- from an inventory slot, specific to the player character in game.
    -- @usage cd.slot.duration() or cd.slot.duration(slotID)
    -- @tparam[opt=id] number slotID The ID of the inventory slot. If not provided, the default is 'id'.
    -- @treturn number The base cooldown of the item spell divided by 1000.
    -- This division is done to convert the time from milliseconds to seconds.
    -- @within cd.slot
    cd.slot.duration = function(slotID)
        if slotID == nil then slotID = id end
        local _, duration = br._G.GetInventoryItemCooldown("player", slotID)
        return duration
    end

    --- Gets the time remaining on the equipment slot item cooldown or 0 if not.
    -- @function cd.slot.remain
    -- @number[opt] slotID The ID of the equipment slot to check.
    -- @treturn number
    cd.slot.remain = function(slotID)
        if slotID == nil then slotID = id end
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
end
