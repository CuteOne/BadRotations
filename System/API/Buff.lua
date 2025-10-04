---
-- These functions help in retrieving information about buffs.
-- Buff functions are stored in br.player.buff and can be utilized by `local buff = br.player.buff` in your profile.
-- `spell` in the function represent the name in the buffs list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- @module br.player.buff
local _, br = ...
if br.api == nil then br.api = {} end

br.api.buffs = function(buff, k, v)
    local buff = buff[k]
    --- Cancel a buff.
    -- @function buff.spell.cancel
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    buff.cancel = function(thisUnit, sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return end
        end
        if br.functions.aura:UnitBuffID(thisUnit, v, sourceUnit) ~= nil then
            br._G.RunMacroText("/cancelaura " .. br._G.GetSpellInfo(v))
        end
    end

    --- Get the count of a buff.
    -- @function buff.spell.count
    -- @treturn number
    buff.count = function()
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return 0 end
        end
        return tonumber(br.functions.aura:getBuffCount(v))
    end

    --- Get the duration of a buff.
    -- @function buff.spell.duration
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn number
    buff.duration = function(thisUnit, sourceUnit)
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
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn boolean
    buff.exists = function(thisUnit, sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return false end
        end
        return br.functions.aura:UnitBuffID(thisUnit, v, sourceUnit) ~= nil
    end

    --- Check if a buff does NOT exists -- added for readablity into SIMC converted rotations
    -- @function buff.spell.down
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn boolean
    buff.down = function(thisUnit, sourceUnit)
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return true end
        end
        return not buff.exists(thisUnit, sourceUnit)
    end

    --- Check if a buff can be reacted to.
    -- @function buff.spell.react
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn boolean
    buff.react = function(thisUnit, sourceUnit)
        thisUnit = thisUnit or "player"
        sourceUnit = sourceUnit or "player"
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return false end
        end
        return br.functions.aura:getBuffReact(thisUnit, v, sourceUnit)
    end

    --- Get the remaining time of a buff.
    -- @function buff.spell.remain
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn number
    buff.remain = function(thisUnit, sourceUnit)
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
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn number
    buff.remains = function(thisUnit, sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return 0 end
        end
        return math.abs(br.functions.aura:getBuffRemain(thisUnit, v, sourceUnit))
    end

    --- Check if a buff should be refreshed.
    -- @function buff.spell.refresh
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn boolean
    buff.refresh = function(thisUnit, sourceUnit)
        if k == "bloodLust" then
            v = br.functions.aura:getLustID()
            if v == 0 then return false end
        end
        return buff.remain(thisUnit, sourceUnit) <= buff.duration(thisUnit, sourceUnit) * 0.3
    end

    --- Get the stack count of a buff.
    -- @function buff.spell.stack
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn number
    buff.stack = function(thisUnit, sourceUnit)
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
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn number
    buff.stackMax = function(thisUnit, sourceUnit)
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
