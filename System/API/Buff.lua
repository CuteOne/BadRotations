module('br.player.buff')
local _, br = ...
if br.api == nil then br.api = {} end

--- Buff is the table located at br.player.buff.
-- These functions are accessible via `local buff = br.player.buff`
-- @section Buff

--- V is the spellID passed from the builder which cycles all the collected buff spells from the spell list for the spec.
-- @param buff table The br.player.buff table.
-- @param v number The spell ID.
-- @usage spell in the examples represent the name in the buffs list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua

br.api.buffs = function(buff,v)

    --- Cancel a buff.
    -- @tparam[opt="player"] string thisUnit The unit to check.
    -- @tparam[opt="player"] string sourceUnit The source of the buff.
    -- @usage local buff = br.player.buff
    -- buff.spell.cancel("player")  -- Cancels the buff from the player.
    buff.cancel = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if br.UnitBuffID(thisUnit,v,sourceUnit) ~= nil then
            br._G.RunMacroText("/cancelaura "..br._G.GetSpellInfo(v))
        end
    end

    --- Get the count of a buff.
    -- @treturn number The count of the buff.
    -- @usage local count = br.player.buff.spell.count()  -- Gets the count of the buff.
    buff.count = function()
        return tonumber(br.getBuffCount(v))
    end

    --- Get the duration of a buff.
    -- @tparam[opt="player"] string thisUnit The unit to check.
    -- @tparam[opt="player"] string sourceUnit The source of the buff.
    -- @treturn number The duration of the buff in seconds.
    -- @usage local duration = br.player.buff
    -- buff.spell.duration("player")  -- Gets the duration of the buff on the player.
    buff.duration = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return br.getBuffDuration(thisUnit,v,sourceUnit)
    end

    --- Check if a buff exists.
    -- @tparam[opt="player"] string thisUnit The unit to check.
    -- @tparam[opt="player"] string sourceUnit The source of the buff.
    -- @treturn boolean True if the buff exists, false otherwise.
    -- @usage local exists = br.player.buff
    -- buff.spell.exists("player")  -- Checks if the buff exists on the player.
    buff.exists = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return br.UnitBuffID(thisUnit,v,sourceUnit) ~= nil
    end

    --- Check the reaction delay of a buff.
    -- @tparam[opt="player"] string thisUnit The unit to check.
    -- @tparam[opt="player"] string sourceUnit The source of the buff.
    -- @treturn boolean True if the buff has a reaction delay, false otherwise.
    -- @usage local react = br.player.buff
    -- buff.spell.react("player")  -- Checks the reaction delay of the buff on the player.
    buff.react = function(thisUnit, sourceUnit)
        thisUnit = thisUnit or "player"
        sourceUnit = sourceUnit or "player"
        return br.getBuffReact(thisUnit, v, sourceUnit)
    end

    --- Get the remaining time of a buff.
    -- @tparam[opt="player"] string thisUnit The unit to check.
    -- @tparam[opt="player"] string sourceUnit The source of the buff.
    -- @treturn number The remaining time of the buff in seconds.
    -- @usage local remain = br.player.buff
    -- buff.spell.remain("player")  -- Gets the remaining time of the buff on the player.
    buff.remain = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return math.abs(br.getBuffRemain(thisUnit,v,sourceUnit))
    end

    --- Get the remaining time of a buff. (Duplicate of buff.remain)
    -- @tparam[opt="player"] string thisUnit The unit to check.
    -- @tparam[opt="player"] string sourceUnit The source of the buff.
    -- @treturn number The remaining time of the buff in seconds.
    -- @usage local remain = br.player.buff
    -- buff.spell.remain("player")  -- Gets the remaining time of the buff on the player.
    buff.remains = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return math.abs(br.getBuffRemain(thisUnit,v,sourceUnit))
    end

    --- Check if a buff should be refreshed.
    -- @tparam[opt="player"] string thisUnit The unit to check.
    -- @tparam[opt="player"] string sourceUnit The source of the buff.
    -- @treturn boolean True if the buff should be refreshed, false otherwise.
    -- @usage local shouldRefresh = br.player.buff
    -- buff.spell.refresh("player")  -- Checks if the buff on the player should be refreshed.
    buff.refresh = function(thisUnit,sourceUnit)
        return buff.remain(thisUnit,sourceUnit) <= buff.duration(thisUnit,sourceUnit) * 0.3
    end

    --- Get the stack count of a buff.
    -- @tparam[opt="player"] string thisUnit The unit to check.
    -- @tparam[opt="player"] string sourceUnit The source of the buff.
    -- @treturn number The stack count of the buff.
    -- @usage local stacks = br.player.buff
    -- buff.spell.stack("player")  -- Gets the stack count of the buff on the player.
    buff.stack = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return br.getBuffStacks(thisUnit,v,sourceUnit)
    end
end
