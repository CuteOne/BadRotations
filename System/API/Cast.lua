module('br.player.cast')
local _, br = ...
if br.api == nil then br.api = {} end

---
-- @description This API provides functions to retrieve information about spell casts.
-- The 'cast' table is located at br.player.cast. Use this in your profile to access the functions.
-- 'id' is the spellID passed from the builder, which cycles through all the collected ability spells from the spell list for the spec.
-- 'spell' in the examples represents the name in the ability list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua.

br.api.cast = function(self,spell,id)
    if self.cast == nil then self.cast = {} end
    local cast = self.cast

    ---
    -- @section CastAPIFunctions

    ---
    -- @function br.player.cast.functionForSpell
    -- @description Creates a function that can be used to cast a spell based on various parameters. The function name is dynamically generated based on the spell name.
    -- For example, for a spell named "thisSpell", the function would be `cast.thisSpell()`.
    -- @tparam string thisUnit The target unit for the spell. Can be standard WoW units, dynamic units, or special parameters like "best", "playerGround", etc.
    -- @tparam string castType Defines the type of AoE or special cast conditions.
    -- @tparam number minUnits Minimum number of units needed to be hit by AoE spell.
    -- @tparam number effectRng The AoE's effect range.
    -- @tparam number id The spell ID to cast.
    -- @tparam string spell The spell name to cast. This parameter is ignored if id is provided.
    -- @tparam boolean predict If true, will attempt to predict enemy movements for ground location AoE spells.
    -- @tparam boolean predictPad Pads the prediction cast time. 'predict' must be true.
    -- @tparam table enemies A table of enemy units that the spell should be cast on.
    -- @return True/False
    cast[spell] = function(thisUnit,castType,minUnits,effectRng,predict,predictPad,enemies)
        return br.createCastFunction(thisUnit,castType,minUnits,effectRng,id,spell,predict,predictPad,enemies)
    end

    ---
    -- @function br.player.cast.id
    -- @description Attempts to cast a spell by its ID based on various parameters.
    -- @tparam number spellID The ID of the spell to cast.
    -- @tparam string thisUnit The target unit for the spell. Can be standard WoW units, dynamic units, or special parameters.
    -- @tparam string castType Defines the type of AoE or special cast conditions.
    -- @tparam number minUnits Minimum number of units needed to be hit by AoE spell.
    -- @tparam number effectRng The AoE's effect range.
    -- @tparam boolean predict If true, will attempt to predict enemy movements for ground location AoE spells.
    -- @tparam boolean predictPad Pads the prediction cast time. 'predict' must be true.
    -- @tparam table enemies A table of enemy units that the spell should be cast on.
    -- @return True/False
    if cast.id == nil then
        cast.id = function(spellID,thisUnit,castType,minUnits,effectRng,predict,predictPad,enemies)
            return br.createCastFunction(thisUnit,castType,minUnits,effectRng,spellID,spell,predict,predictPad,enemies)
        end
    end

    ---
    -- @function br.player.cast.able.functionForSpell
    -- @description Checks if a spell can be cast based on various parameters and returns True/False.
    -- @tparam string thisUnit The target unit for the spell. Can be standard WoW units, dynamic units, or special parameters.
    -- @tparam string castType Defines the type of AoE or special cast conditions.
    -- @tparam number minUnits Minimum number of units needed to be hit by AoE spell.
    -- @tparam number effectRng The AoE's effect range.
    -- @tparam boolean predict If true, will attempt to predict enemy movements for ground location AoE spells.
    -- @tparam boolean predictPad Pads the prediction cast time. 'predict' must be true.
    -- @tparam table enemies A table of enemy units that the spell should be cast on.
    -- @return True/False
    if cast.able == nil then cast.able = {} end
    cast.able[spell] = function(thisUnit,castType,minUnits,effectRng,predict,predictPad,enemies)
        return br.createCastFunction(thisUnit,castType,minUnits,effectRng,id,spell,predict,predictPad,enemies,true)
    end

    ---
    -- @function br.player.cast.able.id
    -- @description Checks if a spell by its ID can be cast based on various parameters and returns True/False.
    -- @tparam number spellID The ID of the spell to check.
    -- @tparam string thisUnit The target unit for the spell. Can be standard WoW units, dynamic units, or special parameters.
    -- @tparam string castType Defines the type of AoE or special cast conditions.
    -- @tparam number minUnits Minimum number of units needed to be hit by AoE spell.
    -- @tparam number effectRng The AoE's effect range.
    -- @tparam boolean predict If true, will attempt to predict enemy movements for ground location AoE spells.
    -- @tparam boolean predictPad Pads the prediction cast time. 'predict' must be true.
    -- @tparam table enemies A table of enemy units that the spell should be cast on.
    -- @return True/False
    if cast.able.id == nil then
        cast.able.id = function(spellID,thisUnit,castType,minUnits,effectRng,predict,predictPad,enemies)
            return br.createCastFunction(thisUnit,castType,minUnits,effectRng,spellID,spell,predict,predictPad,enemies,true)
        end
    end

    ---
    -- @function br.player.cast.active.functionForSpell
    -- @description Returns if the spell is the one currently being cast.
    -- @tparam string thisUnit The unit to check if it's casting the spell. Can be standard WoW units or dynamic units.
    -- @return True/False
    if cast.active == nil then cast.active = {} end
    cast.active[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.isCastingSpell(id,thisUnit)
    end

    ---
    -- @function br.player.cast.auto.functionForSpell
    -- @description Checks if the spell is set to auto-repeat or if it's the current spell being cast.
    -- @return True/False
    if cast.auto == nil then cast.auto = {} end
    cast.auto[spell] = function()
        return br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(id)) or br._G.IsCurrentSpell(id)
    end

    ---
    -- @function br.player.cast.cancel.functionForSpell
    -- @description Cancels the current spell being cast if it matches the specified spell.
    -- @return True/False
    if cast.cancel == nil then cast.cancel = {} end
    cast.cancel[spell] = function()
        local SpellStopCasting = br._G["SpellStopCasting"]
        if self.cast.current[spell]() then
            SpellStopCasting()
            return true
        end
        return false
    end

    ---
    -- @function br.player.cast.cost.functionForSpell
    -- @description Returns the cost of the spell.
    -- @tparam boolean altPower Set to "true" to return alternate power cost.
    -- @return The cost of the spell.
    if cast.cost == nil then cast.cost = {} end
    cast.cost[spell] = function(altPower)
        if altPower == nil then altPower = false end
        if altPower then
            return select(2,br.getSpellCost(id))
        else
            return select(1,br.getSpellCost(id))
        end
    end

    ---
    -- @function br.player.cast.current.functionForSpell
    -- @description Returns if the spell is the currently cast spell for the target (Alternate to br.player.cast.active.spell()).
    -- @tparam string thisUnit Acceptable parameters: nil (defaults to "player"), standard WoW units, or dynamic units.
    -- @return True/False
    if cast.current == nil then cast.current = {} end
    cast.current[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.isCastingSpell(id,thisUnit)
    end

    ---
    -- @function br.player.cast.current.id
    -- @description Returns the spell id of the current (or previously) cast spell by the API.
    -- @return The current spell id
    if cast.current.id == nil then
        cast.current.id = function()
            return br.botSpell
        end
    end

    ---
    -- @function br.player.cast.dispel.functionForSpell
    -- @description Returns if the spell if capable of dispelling the target.
    -- @tparam string thisUnit Acceptable parameters: nil (defaults to "target"), standard WoW units, or dynamic units.
    -- @return True/False
    if cast.dispel == nil then cast.dispel = {} end
    cast.dispel[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.canDispel(thisUnit,id) or false
    end

    ---
    -- @function br.player.cast.empowered.functionForSpell
    -- @description Returns current empowered rank of the spell or 0 if not empowered.
    -- @return The current empowered rank of the spell.
    if cast.empowered == nil then cast.empowered = {} end
    cast.empowered[spell] = function()
        return br.getEmpoweredRank(id)
    end

    ---
    -- @function br.player.cast.form
    -- @description Casts the form corresponding to the provided formIndex number.
    -- @tparam number formIndex Index of the form to be casted. If not provided, defaults to 0.
    -- @return True/False
    if cast.form == nil then
        cast.form = function(formIndex)
            local CastShapeshiftForm = br._G["CastShapeshiftForm"]
            if formIndex == nil then formIndex = 0 end
            return CastShapeshiftForm(formIndex)
        end
    end

    ---
    -- @function br.player.cast.inFlight.functionForSpell
    -- @description Returns if the spell is currently in flight to the target.
    -- @tparam string thisUnit Acceptable parameters: nil (defaults to "target"), standard WoW units, or dynamic units.
    -- @return True/False
    if cast.inFlight == nil then cast.inFlight = {} end
    cast.inFlight[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.InFlight.Check(id, thisUnit)
    end

    ---
    -- @function br.player.cast.inFlightRemain.functionForSpell
    -- @description Returns time remaining on a spell in flight to the target.
    -- @tparam string thisUnit The target unit to check for the spell in flight.
    -- @return Time remaining on the spell in flight.
    if cast.inFlightRemain == nil then cast.inFlightRemain = {} end
    cast.inFlightRemain[spell] = function(thisUnit)
        return br.InFlight.Remain(id, thisUnit)
    end

    ---
    -- @function br.player.cast.last.functionForSpell
    -- @description Returns if the spell was the last one cast or not.
    -- @tparam number index Number of last cast spell up to 10 previous spells, default value is 1 if not provided.
    -- @return True/False
    if cast.last == nil then cast.last = {} end
    cast.last[spell] = function(index)
        local tracker = br.lastCastTable.tracker
        index = index or 1
        return tracker[index] and tracker[index] == id
    end

    ---
    -- @function br.player.cast.last.time.functionForSpell
    -- @description Returns the GetTime() value the last cast of this spell occurred.
    -- @return The last time the spell was cast.
    if cast.last.time == nil then cast.last.time = {} end
    cast.last.time[spell] = function()
        if br.lastCastTable.castTime[id] == nil then br.lastCastTable.castTime[id] = br._G.GetTime() end
        return br.lastCastTable.castTime[id]
    end

    ---
    -- @function br.player.cast.noControl.functionForSpell
    -- @description Returns true if the spell can free you of a "no control" effect.
    -- @tparam string thisUnit The target unit to check for the "no control" effect. Defaults to "player" if not provided.
    -- @return True/False
    if cast.noControl == nil then cast.noControl = {} end
    cast.noControl[spell] = function(thisUnit)
        local hasNoControl = br["hasNoControl"]
        if thisUnit == nil then thisUnit = "player" end
        return hasNoControl(id,thisUnit)
    end

    ---
    -- @function br.player.cast.opener
    -- @description Attempts to cast special opener condition spell.
    -- @tparam number thisSpell The spell to be cast as the opener.
    -- @tparam string thisTracker The tracker for the opener.
    -- @tparam number thisCount The count for the opener.
    -- @return True/False
    if cast.opener == nil then
        cast.opener = function(thisSpell,thisTracker,thisCount)
            local castOpener = br._G["castOpener"]
            return castOpener(thisSpell,thisTracker,thisCount)
        end
    end

    ---
    -- @function br.player.cast.openerFail
    -- @description Resets cast special opener condition if failed to cast.
    -- @tparam number thisSpell The spell that failed to cast.
    -- @tparam string thisTracker The tracker for the opener.
    -- @tparam number thisCount The count for the opener.
    -- @return True/False
    if cast.openerFail == nil then
        cast.openerFail = function(thisSpell,thisTracker,thisCount)
            local castOpenerFail = br.castOpenerFail
            return castOpenerFail(thisSpell,thisTracker,thisCount)
        end
    end

    ---
    -- @function br.player.cast.pool.functionForSpell
    -- @description Returns true if specified power requirements are not met.
    -- @tparam boolean altPower Set to "true" to return alternate power cost. Defaults to false if not provided.
    -- @tparam number specificAmt Set to specified power amount. Defaults to 0 if not provided.
    -- @tparam number multiplier Set to specified power multiplier. Defaults to 1 if not provided.
    -- @return True/False
    if cast.pool == nil then cast.pool = {} end
    cast.pool[spell] = function(altPower, specificAmt, multiplier)
        local powerType = select(2, br._G.UnitPowerType("player")):lower()
        local power = br.player.power
        specificAmt = specificAmt or 0
        multiplier = multiplier or 1
        if altPower == nil then altPower = false end
        return power[powerType].amount() < cast.cost[spell](altPower) * multiplier or
            power[powerType].amount() < specificAmt
    end

    ---
    -- @function br.player.cast.range.functionForSpell
    -- @description Returns the spell's range, if it has one.
    -- @return The spell's range.
    if cast.range == nil then cast.range = {} end
    cast.range[spell] = function()
        return br.getSpellRange(id)
    end

    ---
    -- @function br.player.cast.regen.functionForSpell
    -- @description Returns the amount of power spell will generate when cast.
    -- @return The amount of power spell will generate.
    if cast.regen == nil then cast.regen = {} end
    cast.regen[spell] = function()
        return br.getCastingRegen(id)
    end

    ---
    -- @function br.player.cast.safe.functionForSpell
    -- @description Return if safe to cast specified aoe spell on unit given the aoe dimensions.
    -- @tparam string thisUnit The target unit to check for safety. Defaults to "target" if not provided.
    -- @tparam string aoeType The type of AoE to check for safety. Can be "rect", "cone", "ground", or "aoe".
    -- @tparam number minUnits Specify minimal number of units needed to be hit by AoE spell before it will use.
    -- @tparam number effectRng Specify the AoE's effect range to determine units hit by it.
    -- @return True/False
    if cast.safe == nil then cast.safe = {} end
    cast.safe[spell] = function(thisUnit,aoeType,minUnits,effectRng)
        return br.isSafeToAoE(id,thisUnit,effectRng,minUnits,aoeType)
    end

    ---
    -- @function br.player.cast.time.functionForSpell
    -- @description Return cast time of player's spell. If the spell has no cast time, it returns the global cooldown.
    -- @return The cast time of the spell.
    if cast.time == nil then cast.time = {} end
    cast.time[spell] = function()
        local castTime = br.getCastTime(id)
        return castTime > 0 and castTime or br.getGlobalCD(true)
    end

    ---
    -- @function br.player.cast.timeRemain
    -- @description Return cast time remaining on player's cast or supplied target.
    -- @tparam string thisUnit The unit to check cast time remaining. Defaults to "player" if not provided.
    -- @return The cast time remaining.
    if cast.timeRemain == nil then cast.timeRemain = {} end
    cast.timeRemain = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.getCastTimeRemain(thisUnit)
    end

    ---
    -- @function br.player.cast.timeSinceLast.functionForSpell
    -- @description Returns the time since the last cast of this spell occurred.
    -- @return The time since the last cast of this spell occurred.
    if cast.timeSinceLast == nil then cast.timeSinceLast = {} end
    cast.timeSinceLast[spell] = function()
        if br.lastCastTable.castTime[id] == nil then br.lastCastTable.castTime[id] = br._G.GetTime() end
        return br._G.GetTime() - br.lastCastTable.castTime[id]
    end
end