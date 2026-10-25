---
-- These functions help in retrieving information about buffs.
-- Buff functions are stored in br.player.buff and can be utilized by `local buff = br.player.buff` in your profile.
-- `spell` in the function represent the name in the buffs list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- @module br.player.buff
local _, br = ...
if br.api == nil then br.api = {} end

br.api.buffs = function(buff, k, v)
    local buff = buff[k]
    -- The spell list entry (a rank list on ranked clients); v is set to its current rank at the
    -- start of every function, so a newly learned rank counts straight away
    local ref = v
    local function currentRank() return br.functions.spell:currentRank(ref) end
    v = currentRank()

    --- Cancel a buff.
    -- @function buff.spell.cancel
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit "player": your own (on the player, a copy anyone cast on
    --   you counts, so a buff isn't recast over someone else's); "any": from anyone
    buff.cancel = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return end
        end
        if br.functions.aura:UnitBuffID(thisUnit, v, sourceUnit) ~= nil then
            br.game.RunMacroText("/cancelaura " .. br.functions.spell:getName(v))
        end
    end

    --- Get the count of a buff.
    -- @function buff.spell.count
    -- @treturn number
    buff.count = function()
        v = currentRank()
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return 0 end
        end
        return tonumber(br.functions.aura:getBuffCount(v))
    end

    --- Check if a buff does NOT exists -- added for readablity into SIMC converted rotations
    -- @function buff.spell.down
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit "player": your own (on the player, a copy anyone cast on
    --   you counts, so a buff isn't recast over someone else's); "any": from anyone
    -- @treturn boolean
    buff.down = function(thisUnit, sourceUnit)
        v = currentRank()
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return true end
        end
        return not buff.exists(thisUnit, sourceUnit)
    end

    --- Get the duration of a buff.
    -- @function buff.spell.duration
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit "player": your own (on the player, a copy anyone cast on
    --   you counts, so a buff isn't recast over someone else's); "any": from anyone
    -- @treturn number
    buff.duration = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return 0 end
        end
        return br.functions.aura:getBuffDuration(thisUnit, v, sourceUnit)
    end

    --- Check if a buff exists.
    -- @function buff.spell.exists
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit "player": your own (on the player, a copy anyone cast on
    --   you counts, so a buff isn't recast over someone else's); "any": from anyone
    -- @treturn boolean
    buff.exists = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return false end
        end
        return br.functions.aura:UnitBuffID(thisUnit, v, sourceUnit) ~= nil
    end

    --- Check if a buff can be reacted to.
    -- @function buff.spell.react
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit "player": your own (on the player, a copy anyone cast on
    --   you counts, so a buff isn't recast over someone else's); "any": from anyone
    -- @treturn boolean
    buff.react = function(thisUnit, sourceUnit)
        v = currentRank()
        thisUnit = thisUnit or "player"
        sourceUnit = sourceUnit or "player"
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return false end
        end
        return br.functions.aura:getBuffReact(thisUnit, v, sourceUnit)
    end

    --- Check if a buff should be refreshed.
    -- @function buff.spell.refresh
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit "player": your own (on the player, a copy anyone cast on
    --   you counts, so a buff isn't recast over someone else's); "any": from anyone
    -- @treturn boolean
    buff.refresh = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'player' end
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return false end
        end
        -- A stronger aura already holds this slot, so the game refuses a recast.
        if br.functions.cast:isAuraBounced(v, thisUnit) then return false end

        -- Classic: when sourceUnit is omitted, treat refresh checks as "any source".
        -- A higher rank already on the unit (same name, higher spellId) is left alone; a lower rank,
        -- from anyone, is upgraded straight away. (If a rank ID ever misleads, the game refuses the
        -- cast and the aura-bounce memory holds it until that aura ends.)
        if (br.client.rules.hasSpellRanks and sourceUnit == nil) then
            local auraInfo = br.functions.aura:UnitBuffID(thisUnit, v)
            if auraInfo and auraInfo.spellId and auraInfo.spellId > v then
                return false
            end
            if auraInfo and auraInfo.spellId and auraInfo.spellId < v then
                return true
            end
            local remain = math.abs(br.functions.aura:getBuffRemain(thisUnit, v))
            local duration = br.functions.aura:getBuffDuration(thisUnit, v)
            return remain <= duration * 0.3
        end

        return buff.remain(thisUnit, sourceUnit) <= buff.duration(thisUnit, sourceUnit) * 0.3
    end

    --- Get the remaining time of a buff.
    -- @function buff.spell.remain
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit "player": your own (on the player, a copy anyone cast on
    --   you counts, so a buff isn't recast over someone else's); "any": from anyone
    -- @treturn number
    buff.remain = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return 0 end
        end
        return math.abs(br.functions.aura:getBuffRemain(thisUnit, v, sourceUnit))
    end

    --- Get the remaining time of a buff. (Duplicate of br.player.buff.spell.remain)
    -- @function buff.spell.remains
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit "player": your own (on the player, a copy anyone cast on
    --   you counts, so a buff isn't recast over someone else's); "any": from anyone
    -- @treturn number
    buff.remains = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return 0 end
        end
        return math.abs(br.functions.aura:getBuffRemain(thisUnit, v, sourceUnit))
    end

    --- Get the stack count of a buff.
    -- @function buff.spell.stack
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit "player": your own (on the player, a copy anyone cast on
    --   you counts, so a buff isn't recast over someone else's); "any": from anyone
    -- @treturn number
    buff.stack = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return 0 end
        end
        return br.functions.aura:getBuffStacks(thisUnit, v, sourceUnit)
    end

    --- Get the maximum stack count of a buff.
    -- @function buff.spell.stackMax
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit "player": your own (on the player, a copy anyone cast on
    --   you counts, so a buff isn't recast over someone else's); "any": from anyone
    -- @treturn number
    buff.stackMax = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return 0 end
        end
        if not br.readers.common.auraMaxStacks then return 0 end
        return br.readers.common.auraMaxStacks[v] and (br.readers.common.auraMaxStacks[v][thisUnit] or 0) or 0
    end
end
