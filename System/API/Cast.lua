---
-- These functions help in casting spells and retrieving information about casts.
-- Cast functions are stored in br.player.cast and can be utilized by `local cast = br.player.cast` in your profile.
-- `spell` in the function represent the name in the actions list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- @module br.player.cast
local _, br = ...

if br.api == nil then br.api = {} end

br.api.cast = function(self, spell, id)
    if self.cast == nil then self.cast = {} end
    local cast = self.cast
    if cast.able == nil then cast.able = {} end
    if cast.active == nil then cast.active = {} end
    if cast.auto == nil then cast.auto = {} end
    if cast.cancel == nil then cast.cancel = {} end
    if cast.cost == nil then cast.cost = {} end
    if cast.current == nil then cast.current = {} end
    if cast.dispel == nil then cast.dispel = {} end
    if cast.empowered == nil then cast.empowered = {} end
    if cast.inFlight == nil then cast.inFlight = {} end
    if cast.inFlightRemain == nil then cast.inFlightRemain = {} end
    if cast.last == nil then cast.last = {} end
    if cast.last.time == nil then cast.last.time = {} end
    if cast.macro == nil then cast.macro = {} end
    if cast.noControl == nil then cast.noControl = {} end
    if cast.pool == nil then cast.pool = {} end
    if cast.range == nil then cast.range = {} end
    if cast.regen == nil then cast.regen = {} end
    if cast.safe == nil then cast.safe = {} end
    if cast.time == nil then cast.time = {} end
    if cast.timeSinceLast == nil then cast.timeSinceLast = {} end

    --- Cast a spell based on various parameters.
    -- The function name is dynamically generated based on the spell name.
    -- For example, for a spell named "thisSpell", the function would be `cast.thisSpell()`.
    -- @function cast.spell
    -- @string thisUnit The target unit for the spell. Can be standard WoW units, dynamic units, or special parameters like "best", "playerGround", etc.
    -- @string castType Defines the type of AoE or special cast conditions.
    -- @number minUnits Minimum number of units needed to be hit by AoE spell.
    -- @number effectRng The AoE's effect range.
    -- @bool predict If true, will attempt to predict enemy movements for ground location AoE spells.
    -- @bool predictPad Pads the prediction cast time. 'predict' must be true.
    -- @tab enemies A table of enemy units that the spell should be cast on.
    -- @treturn boolean
    cast[spell] = function(thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
        return br.createCastFunction(thisUnit, castType, minUnits, effectRng, id, spell, predict, predictPad, enemies)
    end

    --- Cast a spell by its ID based on various parameters.
    -- @function cast.id
    -- @number spellID The ID of the spell to cast.
    -- @string thisUnit The target unit for the spell. Can be standard WoW units, dynamic units, or special parameters.
    -- @string castType Defines the type of AoE or special cast conditions.
    -- @number minUnits Minimum number of units needed to be hit by AoE spell.
    -- @number effectRng The AoE's effect range.
    -- @bool predict If true, will attempt to predict enemy movements for ground location AoE spells.
    -- @bool predictPad Pads the prediction cast time. 'predict' must be true.
    -- @tab enemies A table of enemy units that the spell should be cast on.
    -- @treturn boolean
    cast.id = function(spellID, thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
        return br.createCastFunction(thisUnit, castType, minUnits, effectRng, spellID, spell, predict, predictPad,
            enemies)
    end

    --- Cast a spell by its Name based on various parameters.
    -- @function cast.name
    -- @string spellName The name of the spell to cast.
    -- @string thisUnit The target unit for the spell. Can be standard WoW units, dynamic units, or special parameters.
    -- @string castType Defines the type of AoE or special cast conditions.
    -- @number minUnits Minimum number of units needed to be hit by AoE spell.
    -- @number effectRng The AoE's effect range.
    -- @bool predict If true, will attempt to predict enemy movements for ground location AoE spells.
    -- @bool predictPad Pads the prediction cast time. 'predict' must be true.
    -- @tab enemies A table of enemy units that the spell should be cast on.
    -- @treturn boolean
    cast.name = function(spellName, thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
        local _, _, _, _, _, _, spellID = br._G.GetSpellInfo(spellName)
        return br.createCastFunction(thisUnit, castType, minUnits, effectRng, spellID, spell, predict, predictPad,
            enemies)
    end


    --- Checks if a spell can be cast based on various parameters.
    -- The function name is dynamically generated based on the spell name.
    -- @function cast.able.spell
    -- @string thisUnit The target unit for the spell. Can be standard WoW units, dynamic units, or special parameters.
    -- @string castType Defines the type of AoE or special cast conditions.
    -- @number minUnits Minimum number of units needed to be hit by AoE spell.
    -- @number effectRng The AoE's effect range.
    -- @bool predict If true, will attempt to predict enemy movements for ground location AoE spells.
    -- @bool predictPad Pads the prediction cast time. 'predict' must be true.
    -- @tab enemies A table of enemy units that the spell should be cast on.
    -- @treturn boolean
    cast.able[spell] = function(thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
        return br.createCastFunction(thisUnit, castType, minUnits, effectRng, id, spell, predict, predictPad, enemies,
            true)
    end

    --- Checks if a spell can be cast by its ID based on various parameters.
    -- @function cast.able.id
    -- @number spellID The ID of the spell to check.
    -- @string thisUnit The target unit for the spell. Can be standard WoW units, dynamic units, or special parameters.
    -- @string castType Defines the type of AoE or special cast conditions.
    -- @number minUnits Minimum number of units needed to be hit by AoE spell.
    -- @number effectRng The AoE's effect range.
    -- @bool predict If true, will attempt to predict enemy movements for ground location AoE spells.
    -- @bool predictPad Pads the prediction cast time. 'predict' must be true.
    -- @tab enemies A table of enemy units that the spell should be cast on.
    -- @treturn boolean
    cast.able.id = function(spellID, thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
        return br.createCastFunction(thisUnit, castType, minUnits, effectRng, spellID, spell, predict, predictPad,
            enemies, true)
    end

    --- Checks if a spell can be cast by its Name based on various parameters.
    -- @function cast.able.name
    -- @string spellName The Name of the spell to check.
    -- @string thisUnit The target unit for the spell. Can be standard WoW units, dynamic units, or special parameters.
    -- @string castType Defines the type of AoE or special cast conditions.
    -- @number minUnits Minimum number of units needed to be hit by AoE spell.
    -- @number effectRng The AoE's effect range.
    -- @bool predict If true, will attempt to predict enemy movements for ground location AoE spells.
    -- @bool predictPad Pads the prediction cast time. 'predict' must be true.
    -- @tab enemies A table of enemy units that the spell should be cast on.
    -- @treturn boolean
    cast.able.name = function(spellName, thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
        local _, _, _, _, _, _, spellID = br._G.GetSpellInfo(spellName)
        return br.createCastFunction(thisUnit, castType, minUnits, effectRng, spellID, spell, predict, predictPad,
            enemies, true)
    end

    --- Checks if the spell is the one currently being cast.
    -- @function cast.active.spell
    -- @string thisUnit The unit to check if it's casting the spell. Can be standard WoW units or dynamic units.
    -- @treturn boolean
    cast.active[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.isCastingSpell(id, thisUnit)
    end

    --- Checks if the spell is set to auto-repeat or if it's the current spell being cast.
    -- @function cast.auto.spell
    -- @treturn boolean
    cast.auto[spell] = function()
        return br._G.C_Spell.IsAutoRepeatSpell(br._G.GetSpellInfo(id)) or br._G.C_Spell.IsCurrentSpell(id)
    end

    --- Cancels the current spell being cast if it matches the specified spell.
    -- @function cast.cancel.spell
    -- @treturn boolean
    cast.cancel[spell] = function()
        local SpellStopCasting = br._G["SpellStopCasting"]
        if self.cast.current[spell]() then
            SpellStopCasting()
            return true
        end
        return false
    end

    --- Gets the cost of the spell.
    -- @function cast.cost.spell
    -- @bool altPower Set to "true" to return alternate power cost.
    -- @treturn number
    cast.cost[spell] = function(altPower)
        if altPower == nil then altPower = false end
        if altPower then
            return select(2, br.getSpellCost(id))
        else
            return select(1, br.getSpellCost(id))
        end
    end

    --- Gets the currently cast spell for the target (Alternate to br.player.cast.active.spell()).
    -- @function cast.current.spell
    -- @string thisUnit Acceptable parameters: nil (defaults to "player"), standard WoW units, or dynamic units.
    -- @treturn boolean
    cast.current[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.isCastingSpell(id, thisUnit)
    end

    --- Gets the spell id of the current (or previously) cast spell by the API.
    -- @function cast.current.id
    -- @treturn number
    cast.current.id = function()
        return br.botSpell
    end

    --- Checks if the spell is capable of dispelling the target.
    -- @function cast.dispel.spell
    -- @string thisUnit Acceptable parameters: nil (defaults to "target"), standard WoW units, or dynamic units.
    -- @treturn boolean
    cast.dispel[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.canDispel(thisUnit, id) or false
    end

    --- Gets current empowered rank of the spell or 0 if not empowered.
    -- @function cast.empowered.spell
    -- @treturn number
    cast.empowered[spell] = function()
        return br.getEmpoweredRank(id)
    end

    --- Casts the form corresponding to the provided formIndex number.
    -- @function cast.form
    -- @number formIndex Index of the form to be casted. If not provided, defaults to 0.
    cast.form = function(formIndex)
        local CastShapeshiftForm = br._G["CastShapeshiftForm"]
        if formIndex == nil then formIndex = 0 end
        return CastShapeshiftForm(formIndex)
    end

    --- Checks if the spell is currently in flight to the target.
    -- @function cast.inFlight.spell
    -- @string thisUnit Acceptable parameters: nil (defaults to "target"), standard WoW units, or dynamic units.
    -- @treturn boolean
    cast.inFlight[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.InFlight.Check(id, thisUnit)
    end

    --- Gets time remaining on a spell in flight to the target.
    -- @function cast.inFlightRemain.spell
    -- @string thisUnit The target unit to check for the spell in flight.
    -- @treturn number
    cast.inFlightRemain[spell] = function(thisUnit)
        return br.InFlight.Remain(id, thisUnit)
    end

    --- Checks if the spell was the last one cast or not.
    -- @function cast.last.spell
    -- @number index Number of last cast spell up to 10 previous spells, default value is 1 if not provided.
    -- @treturn boolean
    cast.last[spell] = function(index)
        local tracker = br.lastCastTable.tracker
        index = index or 1
        return tracker[index] and tracker[index] == id
    end

    --- Gets the GetTime() value the last cast of this spell occurred.
    -- @function cast.last.time.spell
    -- @treturn number
    cast.last.time[spell] = function()
        if br.lastCastTable.castTime[id] == nil then br.lastCastTable.castTime[id] = br._G.GetTime() end
        return br.lastCastTable.castTime[id]
    end

    --- Runs the macro text passed to it.
    -- @function cast.macro
    -- @string macroText The macro text to be run.
    -- @treturn boolean
    cast.macro = function(macroText)
        br._G.RunMacroText(macroText)
        return true
    end

    --- Checks if the spell can free you of a "no control" effect.
    -- @function cast.noControl.spell
    -- @treturn boolean
    cast.noControl[spell] = function()
        local hasNoControl = br.hasNoControl
        return hasNoControl(id)
    end

    --- Casts special opener condition spell.
    -- @function cast.opener
    -- @number thisSpell The spell to be cast as the opener.
    -- @string thisTracker The tracker for the opener.
    -- @number thisCount The count for the opener.
    -- @treturn boolean
    cast.opener = function(thisSpell, thisTracker, thisCount)
        local castOpener = br._G["castOpener"]
        return castOpener(thisSpell, thisTracker, thisCount)
    end

    --- Resets cast special opener condition if failed to cast.
    -- @function cast.openerFail
    -- @number thisSpell The spell that failed to cast.
    -- @string thisTracker The tracker for the opener.
    -- @number thisCount The count for the opener.
    -- @treturn boolean
    cast.openerFail = function(thisSpell, thisTracker, thisCount)
        local castOpenerFail = br.castOpenerFail
        return castOpenerFail(thisSpell, thisTracker, thisCount)
    end

    --- Checks if specified power requirements are not met.
    -- @function cast.pool.spell
    -- @boolean altPower Set to "true" to return alternate power cost. Defaults to false if not provided.
    -- @number specificAmt Set to specified power amount. Defaults to 0 if not provided.
    -- @number multiplier Set to specified power multiplier. Defaults to 1 if not provided.
    -- @treturn boolean
    cast.pool[spell] = function(altPower, specificAmt, multiplier)
        local powerType = select(2, br._G.UnitPowerType("player")):lower()
        local power = br.player.power
        specificAmt = specificAmt or 0
        multiplier = multiplier or 1
        if altPower == nil then altPower = false end
        return power[powerType]() < cast.cost[spell](altPower) * multiplier or
            power[powerType]() < specificAmt
    end

    --- Gets the spell's range, if it has one.
    -- @function cast.range.spell
    -- @treturn number
    cast.range[spell] = function()
        return br.getSpellRange(id)
    end

    --- Gets the amount of power spell will generate when cast.
    -- @function cast.regen.spell
    -- @treturn number
    cast.regen[spell] = function()
        return br.getCastingRegen(id)
    end

    --- Checks if safe to cast specified aoe spell on unit given the aoe dimensions.
    -- @function cast.safe.spell
    -- @string thisUnit The target unit to check for safety. Defaults to "target" if not provided.
    -- @string aoeType The type of AoE to check for safety. Can be "rect", "cone", "ground", or "aoe".
    -- @number minUnits Specify minimal number of units needed to be hit by AoE spell before it will use.
    -- @number effectRng Specify the AoE's effect range to determine units hit by it.
    -- @treturn boolean
    cast.safe[spell] = function(thisUnit, aoeType, minUnits, effectRng)
        return br.isSafeToAoE(id, thisUnit, effectRng, minUnits, aoeType)
    end

    --- Gets the cast time of player's spell. If the spell has no cast time, it returns the global cooldown.
    -- @function cast.time.spell
    -- @treturn number
    cast.time[spell] = function()
        local castTime = br.getCastTime(id)
        return castTime > 0 and castTime or br.getGlobalCD(true)
    end

    --- Gets the cast time remaining on player's cast or supplied target.
    -- @function cast.timeRemain
    -- @tparam string thisUnit The unit to check cast time remaining. Defaults to "player" if not provided.
    -- @treturn number
    cast.timeRemain = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.getCastTimeRemain(thisUnit)
    end

    --- Gets the time since the last cast of this spell occurred.
    -- @function cast.timeSinceLast.spell
    -- @treturn number
    cast.timeSinceLast[spell] = function()
        if br.lastCastTable.castTime[id] == nil then br.lastCastTable.castTime[id] = br._G.GetTime() end
        return br._G.GetTime() - br.lastCastTable.castTime[id]
    end

    --- Checks if the provided condition is true else it waits for 0.1sec.
    -- @function cast.wait
    -- @param condition The condition to check.
    -- @treturn boolean
    cast.wait = function(condition, callback)
        if condition then
            br._G.C_Timer.After(0.1, callback)
        else
            return true
        end
    end
end
