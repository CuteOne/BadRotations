---
-- Buff is the table located at br.player.buff
-- These functions are accessible via `local buff = br.player.buff`
-- `spell` in the usage examples represent the name in the buffs list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- @module br.player.buff
local _, br = ...
if br.api == nil then br.api = {} end


br.api.buffs = function(buff,v)

    --- Cancel a buff.
    -- @function br.player.spell.cancel
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @usage buff.spell.cancel("player")
    buff.cancel = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if br.UnitBuffID(thisUnit,v,sourceUnit) ~= nil then
            br._G.RunMacroText("/cancelaura "..br._G.GetSpellInfo(v))
        end
    end

    --- Get the count of a buff.
    -- @function br.player.spell.count
    -- @treturn number
    -- @usage buff.spell.count()
    buff.count = function()
        return tonumber(br.getBuffCount(v))
    end

    --- Get the duration of a buff.
    -- @function br.player.spell.duration
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn number
    -- @usage buff.spell.duration("player")
    buff.duration = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return br.getBuffDuration(thisUnit,v,sourceUnit)
    end

    --- Check if a buff exists.
    -- @function br.player.spell.exists
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn bool
    -- @usage buff.spell.exists("player")
    buff.exists = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return br.UnitBuffID(thisUnit,v,sourceUnit) ~= nil
    end

    --- Check if a buff can be reacted to.
    -- @function br.player.spell.react
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn bool
    -- @usage buff.spell.react("player")
    buff.react = function(thisUnit, sourceUnit)
        thisUnit = thisUnit or "player"
        sourceUnit = sourceUnit or "player"
        return br.getBuffReact(thisUnit, v, sourceUnit)
    end

    --- Get the remaining time of a buff.
    -- @function br.player.spell.remain
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn number
    -- @usage buff.spell.remain("player")
    buff.remain = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return math.abs(br.getBuffRemain(thisUnit,v,sourceUnit))
    end

    --- Get the remaining time of a buff. (Duplicate of br.player.buff.spell.remain)
    -- @function br.player.spell.remains
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn number
    -- @usage buff.spell.remain("player")
    buff.remains = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return math.abs(br.getBuffRemain(thisUnit,v,sourceUnit))
    end

    --- Check if a buff should be refreshed.
    -- @function br.player.spell.refresh
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn bool
    -- @usage buff.spell.refresh("player")
    buff.refresh = function(thisUnit,sourceUnit)
        return buff.remain(thisUnit,sourceUnit) <= buff.duration(thisUnit,sourceUnit) * 0.3
    end

    --- Get the stack count of a buff.
    -- @function br.player.spell.stack
    -- @string[opt="player"] thisUnit The unit to check.
    -- @string[opt="player"] sourceUnit The source of the buff.
    -- @treturn number
    -- @usage buff.spell.stack("player")
    buff.stack = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return br.getBuffStacks(thisUnit,v,sourceUnit)
    end
end
