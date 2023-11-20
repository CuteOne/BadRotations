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
    if self.cd[spell] == nil then self.cd[spell] = {} end
    local cd = self.cd

    --- Checks if spell is on cooldown or not.
    -- @function cd.spell.exists
    -- @treturn boolean
    cd[spell].exists = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD > 0
    end

    --- Gets the time remaining on spell cooldown or 0 if not.
    -- @function cd.spell.remain
    -- @treturn number
    cd[spell].remain = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD
    end

    --- Gets the time remaining on spell cooldown or 0 if not (alternate to cd.spell.remain() incase of typo).
    -- @function cd.spell.remains
    -- @treturn number
    cd[spell].remains = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD
    end

    --- Gets the total time of the spell cooldown
    -- @function cd.spell.duration
    -- @treturn number
    cd[spell].duration = function()
        local _, CD = br._G.GetSpellCooldown(id)
        return CD
    end

    --- Checks if the spell is not on cooldown or is (opposite of cd.spell.exists()).
    -- @function cd.spell.ready
    -- @treturn boolean
    cd[spell].ready = function()
        local level = br._G.UnitLevel("player")
        local spellLevel = br._G.GetSpellLevelLearned(id)
        local spellCD = level >= spellLevel and br.getSpellCD(id) or 99
        return spellCD == 0
    end

    --- Gets the duration of the spells Global Cooldown.
    -- @function cd.spell.prevgcd
    -- @treturn number
    cd[spell].prevgcd = function()
        return select(2, br._G.GetSpellBaseCooldown(id))
    end
end

br.api.itemCD = function(self,item,id)
    if self[item] == nil then self[item] = {} end
    local cd = self

    --- Checks if item is on cooldown or not.
    -- @function cd.item.exists
    -- @number[opt] itemID The ID of the item to check.
    -- @treturn boolean
    cd[item].exists = function(itemID)
        if itemID == nil then itemID = id end
        return br._G.GetItemCooldown(itemID) > 0
    end

    --- Gets the time remaining on item cooldown or 0 if not.
    -- @function cd.item.remain
    -- @number[opt] itemID The ID of the item to check.
    -- @treturn number
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
    cd[item].duration = function(itemID)
        if itemID == nil then itemID = id end
        return br._G.GetSpellBaseCooldown(select(2,br._G.GetItemSpell(itemID))) / 1000
    end

    --- Gets the time remaining on the equipment slot item cooldown or 0 if not.
    -- @function cd.slot.remain
    -- @number[opt] slotID The ID of the equipment slot to check.
    -- @treturn number
    cd.slot = cd.slot or {}
    cd.slot.remain = function(slotID)
        if slotID == nil then slotID = id end
        if br._G.GetInventoryItemCooldown("player", slotID) ~= 0 then
            return (br._G.GetInventoryItemCooldown("player", slotID) + select(2,br._G.GetInventoryItemCooldown("player", slotID)) - br._G.GetTime())
        end
        return 0
    end
end
