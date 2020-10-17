if br.api == nil then br.api = {} end
-- buff is the table located at br.player.buff
-- v is the spellID passed from the builder which cycles all the collected buff spells from the spell list for the spec
-- spell in the examples represent the name in the buffs list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
br.api.buffs = function(buff,v)
    -- br.player.buff.spell.cancel()
    buff.cancel = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if UnitBuffID(thisUnit,v,sourceUnit) ~= nil then
            RunMacroText("/cancelaura "..GetSpellInfo(v))
            -- CancelUnitBuff(thisUnit,v,sourceUnit)
        end
    end
    -- br.player.buff.spell.count()
    buff.count = function()
        return tonumber(getBuffCount(v))
    end
    -- br.player.buff.spell.duration()
    buff.duration = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return getBuffDuration(thisUnit,v,sourceUnit)
    end
    -- br.player.buff.spell.exists()
    buff.exists = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return UnitBuffID(thisUnit,v,sourceUnit) ~= nil
    end
    -- br.player.buff.spell.react(), buff detection with small reaction delay
    buff.react = function(thisUnit, sourceUnit)
        thisUnit = thisUnit or "player"
        sourceUnit = sourceUnit or "player"
        return getBuffReact(thisUnit, v, sourceUnit)
    end
    -- br.player.buff.spell.remain()
    buff.remain = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end 
        return math.abs(getBuffRemain(thisUnit,v,sourceUnit))
    end
    -- br.player.buff.spell.remains()
    buff.remains = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return math.abs(getBuffRemain(thisUnit,v,sourceUnit))
    end
    -- br.player.buff.spell.refresh()
    buff.refresh = function(thisUnit,sourceUnit)
        return buff.remain(thisUnit,sourceUnit) <= buff.duration(thisUnit,sourceUnit) * 0.3
    end
    -- br.player.buff.spell.stack()
    buff.stack = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'player' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return getBuffStacks(thisUnit,v,sourceUnit)
    end
end