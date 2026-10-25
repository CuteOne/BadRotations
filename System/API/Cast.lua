---
-- These functions help in casting spells and retrieving information about casts.
-- Cast functions are stored in br.player.cast and can be utilized by `local cast = br.player.cast` in your profile.
-- `spell` in the function represent the name in the actions list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- @module br.player.cast
local _, br = ...

if br.api == nil then br.api = {} end

-- cast.<spell>() runs every check itself, so a profile needs no cast.able.<spell>() before it;
-- cast.able only asks whether the spell could go out now, without casting it.
-- Callable spells. cast.<spell>, cast.able.<spell> and cast.opener.<spell> are called like
-- functions with the full argument list (unit, castType, minUnits, effectRng, predict, predictPad,
-- enemies), and also offer short forms for the cast types, with the arguments that type needs:
--   cast.demoralizingRoar.aoe(10)          an AoE around you, 10 yards
--   cast.swipe.aoe(8, 3)                   3+ enemies within 8 yards
--   cast.flamestrike.ground(8, 3)          on the ground where it covers 3+ enemies
-- Area forms take range, minimum units (default 1), then the unit (default per type). .rank(n)
-- gives the spell at a rank (or the highest known below it), with the same forms:
--   cast.healingTouch.rank(3)("player")    cast.consecration.rank(1).aoe(8, 3)
local CALL, RANK_CALL = {}, {} -- private keys: the spell's full call, and its call at a rank

local FORMS = {
    aoe       = function(call, range, minUnits, unit) return call(unit or "player", "aoe", minUnits or 1, range) end,
    cone      = function(call, range, minUnits) return call("player", "cone", minUnits or 1, range) end,
    rect      = function(call, range, minUnits) return call("player", "rect", minUnits or 1, range) end,
    -- Without a unit: the spot covering the most units ("best"); with one: centred on that unit
    ground    = function(call, range, minUnits, unit, predict, predictPad)
        return call(unit or "best", "ground", minUnits or 1, range, predict, predictPad)
    end,
    targetAOE = function(call, range, minUnits, unit) return call(unit or "target", "targetAOE", minUnits or 1, range) end,
    pet       = function(call, unit) return call(unit, "pet") end,
    dead      = function(call, unit) return call(unit, "dead") end,
}

local makeCaller
local callerMeta = {
    __call = function(self, ...) return self[CALL](...) end,
    -- Forms and .rank are made the first time a profile uses them
    __index = function(self, key)
        local fn
        if FORMS[key] ~= nil then
            local form, call = FORMS[key], rawget(self, CALL)
            fn = function(...) return form(call, ...) end
        elseif key == "rank" and rawget(self, RANK_CALL) ~= nil then
            local callAtRank, rank = rawget(self, RANK_CALL), 1
            local ranked = makeCaller(function(...) return callAtRank(rank, ...) end)
            fn = function(n) rank = n; return ranked end
        else
            return nil
        end
        rawset(self, key, fn)
        return fn
    end,
}

-- call(thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies); callAtRank(rank, ...) or nil
makeCaller = function(call, callAtRank)
    return setmetatable({ [CALL] = call, [RANK_CALL] = callAtRank }, callerMeta)
end

-- br.api.cast runs once per spell in the spell list. Per-spell functions (cast.<spell>, cast.able.<spell>,
-- ...) are made every time; generic ones (cast.id, cast.name, cast.form, ...) only the first time.
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
    if cast.noControl == nil then cast.noControl = {} end
    if cast.pool == nil then cast.pool = {} end
    if cast.range == nil then cast.range = {} end
    if cast.regen == nil then cast.regen = {} end
    if cast.safe == nil then cast.safe = {} end
    if cast.time == nil then cast.time = {} end
    if cast.timeSinceLast == nil then cast.timeSinceLast = {} end
    -- The spell's current rank, looked up when a helper runs (cached until the spellbook changes),
    -- so a rank learned at a trainer counts straight away; it used to be fixed when this was built
    local function currentRank() return br.functions.spell:currentRank(id) end

    -- ===========================
    -- SPELL RANK SYSTEM (CLASSIC)
    -- ===========================

    --- Get the highest known rank number for this spell.
    -- @function cast.maxRank.spell
    -- @treturn number The highest rank number the player knows (1-based), or 0 if none
    -- @usage
    -- local knownRank = cast.maxRank.healingTouch()
    -- if knownRank >= 5 then
    --     -- Player knows at least Rank 5
    -- end
    cast.maxRank = cast.maxRank or {}

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
    if cast.able.id == nil then
        cast.able.id = function(spellID, thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
            return br.functions.cast:createCastFunction(thisUnit, castType, minUnits, effectRng, spellID, tostring(spellID), predict,
                predictPad, enemies, true)
        end
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
    if cast.able.name == nil then
        cast.able.name = function(spellName, thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
            local spellID = br.functions.spell:getSpellID(spellName)
            return br.functions.cast:createCastFunction(thisUnit, castType, minUnits, effectRng, spellID, spellName, predict,
                predictPad, enemies, true)
        end
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
    -- Also cast.able.spell.aoe(range, minUnits, unit), .rank(n) and the other forms (see the top of this file).
    cast.able[spell] = makeCaller(
        function(thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
            return br.functions.cast:createCastFunction(thisUnit, castType, minUnits, effectRng, id, spell, predict, predictPad,
                enemies, true)
        end,
        function(rank, thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
            return br.functions.cast:createCastFunction(thisUnit, castType, minUnits, effectRng,
                br.functions.spell:getSpellRank(id, rank), spell, predict, predictPad, enemies, true)
        end)

    --- Checks if the spell is the one currently being cast.
    -- @function cast.active.spell
    -- @string thisUnit The unit to check if it's casting the spell. Can be standard WoW units or dynamic units.
    -- @treturn boolean
    cast.active[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.cast:isCastingSpell(currentRank(), thisUnit)
    end

    --- Checks if the spell is set to auto-repeat or if it's the current spell being cast.
    -- @function cast.auto.spell
    -- @treturn boolean
    cast.auto[spell] = function()
        -- Auto attack: the game's own on/off events, since the Attack spell stops being "current"
        -- while Maul / Heroic Strike is queued (profiles then restarted attacking mid-fight)
        if spell == "autoAttack" and br.functions.unit:isAutoAttacking() then return true end
        return br.functions.spell:isActive(currentRank())
    end

    --- Cancels the current spell being cast if it matches the specified spell.
    -- @function cast.cancel.spell
    -- @treturn boolean
    cast.cancel[spell] = function()
        if self.cast.current[spell]() then
            br.functions.cast:stopCasting()
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
            return select(2, br.functions.power:getSpellCost(currentRank()))
        else
            return select(1, br.functions.power:getSpellCost(currentRank()))
        end
    end

    --- Gets the spell id of the current (or previously) cast spell by the API.
    -- @function cast.current.id
    -- @treturn number
    if cast.current.id == nil then
        cast.current.id = function()
            return br.botSpell
        end
    end

    --- Gets the currently cast spell for the target (Alternate to br.player.cast.active.spell()).
    -- @function cast.current.spell
    -- @string thisUnit Acceptable parameters: nil (defaults to "player"), standard WoW units, or dynamic units.
    -- @treturn boolean
    cast.current[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.cast:isCastingSpell(currentRank(), thisUnit)
    end

    --- Checks if the spell is capable of dispelling the target.
    -- @function cast.dispel.spell
    -- @string thisUnit Acceptable parameters: nil (defaults to "target"), standard WoW units, or dynamic units.
    -- @treturn boolean
    cast.dispel[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.aura:canDispel(thisUnit, currentRank()) or false
    end

    --- Gets current empowered rank of the spell or 0 if not empowered.
    -- @function cast.empowered.spell
    -- @treturn number
    cast.empowered[spell] = function()
        return br.functions.spell:getEmpoweredRank(currentRank())
    end

    --- Casts the form corresponding to the provided formIndex number.
    -- @function cast.form
    -- @number formIndex Index of the form to be casted. If not provided, defaults to 0.
    if cast.form == nil then
        cast.form = function(formIndex)
            if formIndex == nil then formIndex = 0 end
            return br.functions.cast:shapeshift(formIndex)
        end
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
    if cast.id == nil then
        cast.id = function(spellID, thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
            if type(spellID) == "table" then spellID = (br.functions.spell and br.functions.spell.getHighestKnownRank and br.functions.spell:getHighestKnownRank(spellID)) or spellID[1] end
            return br.functions.cast:createCastFunction(thisUnit, castType, minUnits, effectRng, spellID, tostring(spellID), predict,
                predictPad, enemies)
        end
    end

    --- Checks if the spell is currently in flight to the target.
    -- @function cast.inFlight.spell
    -- @string thisUnit Acceptable parameters: nil (defaults to "target"), standard WoW units, or dynamic units.
    -- @treturn boolean
    cast.inFlight[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.InFlight:Check(currentRank(), thisUnit)
    end

    --- Gets time remaining on a spell in flight to the target.
    -- @function cast.inFlightRemain.spell
    -- @string thisUnit The target unit to check for the spell in flight.
    -- @treturn number
    cast.inFlightRemain[spell] = function(thisUnit)
        return br.functions.InFlight:Remain(currentRank(), thisUnit)
    end

    --- Checks if the spell was the last one cast or not.
    -- @function cast.last.spell
    -- @number index Number of last cast spell up to 10 previous spells, default value is 1 if not provided.
    -- @treturn boolean
    cast.last[spell] = function(index)
        local tracker = br.functions.lastCast.lastCastTable.tracker
        index = index or 1
        return tracker[index] and tracker[index] == currentRank()
    end

    --- Gets the GetTime() value the last cast of this spell occurred, or 0 if it hasn't been cast.
    -- @function cast.last.time.spell
    -- @treturn number
    cast.last.time[spell] = function()
        return br.functions.lastCast.lastCastTable.castTime[currentRank()] or 0
    end

    --- Runs the macro text passed to it. Optionally integrates with the cast gate's
    -- throttle infrastructure when an associated spell ID is supplied.
    -- @function cast.macro
    -- @string macroText The macro text to be run.
    -- @int[opt] associatedSpellID Spell ID representing the intent of this macro. When
    --   passed, the cast gate writes castTimers + castIntentLocks for this spell ID so
    --   the next tick's gateDoubleCast / gateCooldownTimer blocks immediate re-fires
    --   through the same mechanism createCastFunction uses. Callers that don't pass
    --   this argument retain the original unprotected behavior (backward-compatible).
    -- @number[opt=0.5] lockDuration Throttle window in seconds. Defaults to 0.5s
    --   (matches the createCastFunction success-path convention).
    -- @treturn boolean Always true.
    if cast.macro == nil then
        cast.macro = function(macroText, associatedSpellID, lockDuration)
            br.functions.cast:runMacro(macroText)
            if associatedSpellID then
                local duration = lockDuration or 0.5
                br.functions.cast:setCastTimer(associatedSpellID, duration)
                br.functions.cast:setCastIntentLock(associatedSpellID, duration)
            end
            return true
        end
    end

    cast.maxRank[spell] = function()
        if not br.client.rules.hasSpellRanks then return 1 end
        return br.functions.spell:getKnownRank(id)
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
    if cast.name == nil then
        cast.name = function(spellName, thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
            local spellID = br.functions.spell:getSpellID(spellName)
            return br.functions.cast:createCastFunction(thisUnit, castType, minUnits, effectRng, spellID, spellName, predict,
                predictPad, enemies)
        end
    end

    --- Checks if the spell can free you of a "no control" effect.
    -- @function cast.noControl.spell
    -- @treturn boolean
    cast.noControl[spell] = function()
        return br.functions.combat:hasNoControl(currentRank())
    end

    --- Casts a spell as one step of an opener: same arguments and result as cast.spell (true when
    -- the cast is sent). Write the opener as ordinary priority lines; the steps go in the order
    -- they're called in. A step that's done or skipped lets the next line run; the current step
    -- casts when it can, and while it waits every cast after it in the rotation is refused, so
    -- nothing jumps in (lines above the opener still run); later steps wait their turn. A step is
    -- done when the game confirms the cast, and skipped when the spell isn't known, its cooldown
    -- won't be up in time, or it can't be cast for about two GCDs. A step whose condition is false
    -- is passed over. The opener resets out of combat without a target, or on a new target.
    -- @function cast.opener.spell
    -- @treturn boolean
    -- @usage
    -- if not debuff.rake.exists("target") then
    --     if cast.opener.rake() then ui.debug("Casting Rake [Opener]") return true end
    -- end
    if cast.opener == nil then
        cast.opener = {}
        --- True once the opener has run all its steps (until it resets).
        -- @function cast.opener.done
        -- @treturn boolean
        cast.opener.done = function() return br.functions.cast:isOpenerDone() end
        --- True while an opener is under way: started and not finished.
        -- @function cast.opener.active
        -- @treturn boolean
        cast.opener.active = function() return br.functions.cast:isOpenerActive() end
    end
    cast.opener[spell] = makeCaller(
        function(thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
            return br.functions.cast:openerStep(spell, id, cast[spell], thisUnit, castType, minUnits, effectRng, predict,
                predictPad, enemies)
        end,
        function(rank, thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
            return br.functions.cast:openerStep(spell, id, cast[spell].rank(rank), thisUnit, castType, minUnits, effectRng,
                predict, predictPad, enemies)
        end)

    --- Checks if specified power requirements are not met.
    -- @function cast.pool.spell
    -- @param altPower boolean Set to "true" to return alternate power cost. Defaults to false if not provided.
    -- @param specificAmt number Set to specified power amount. Defaults to 0 if not provided.
    -- @param multiplier number Set to specified power multiplier. Defaults to 1 if not provided.
    -- @return boolean
    cast.pool[spell] = function(altPower, specificAmt, multiplier)
        local powerType = br.functions.power:getPowerTypeName("player")
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
        return br.functions.spell:getSpellRange(currentRank())
    end

    --- Gets the amount of power spell will generate when cast.
    -- @function cast.regen.spell
    -- @treturn number
    cast.regen[spell] = function()
        return br.functions.spell:getCastingRegen(currentRank())
    end

    --- Checks if safe to cast specified aoe spell on unit given the aoe dimensions.
    -- @function cast.safe.spell
    -- @string thisUnit The target unit to check for safety. Defaults to "target" if not provided.
    -- @string aoeType The type of AoE to check for safety. Can be "rect", "cone", "ground", or "aoe".
    -- @number minUnits Specify minimal number of units needed to be hit by AoE spell before it will use.
    -- @number effectRng Specify the AoE's effect range to determine units hit by it.
    -- @treturn boolean
    cast.safe[spell] = function(thisUnit, aoeType, minUnits, effectRng)
        return br.functions.range:isSafeToAoE(currentRank(), thisUnit, effectRng, minUnits, aoeType)
    end

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
    -- @usage
    -- cast.wrath()                                  -- best target, best rank
    -- cast.demoralizingRoar.aoe(10)                 -- around you, 10 yards (aoe/cone/rect/ground/targetAOE:
    -- cast.swipe.aoe(8, 3)                          --   range, minUnits = 1, unit), pet(unit), dead(unit)
    -- cast.blizzard.ground(8, 3)                    -- on the ground where it covers 3+ enemies
    -- cast.healingTouch.rank(3)("player")           -- rank 3, or the highest known below it
    -- cast.consecration.rank(1).aoe(8, 3)           -- the forms work at a rank, and on cast.able / cast.opener
    cast[spell] = makeCaller(
        function(thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
            return br.functions.cast:createCastFunction(thisUnit, castType, minUnits, effectRng, id, spell, predict, predictPad,
                enemies)
        end,
        function(rank, thisUnit, castType, minUnits, effectRng, predict, predictPad, enemies)
            return br.functions.cast:createCastFunction(thisUnit, castType, minUnits, effectRng,
                br.functions.spell:getSpellRank(id, rank), spell, predict, predictPad, enemies)
        end)

    --- Gets the cast time of player's spell. If the spell has no cast time, it returns the global cooldown.
    -- @function cast.time.spell
    -- @treturn number
    cast.time[spell] = function()
        local castTime = br.functions.cast:getCastTime(currentRank())
        return castTime > 0 and castTime or br.functions.spell:getGlobalCD(true)
    end

    --- Gets the cast time remaining on player's cast or supplied target.
    -- @function cast.timeRemain
    -- @tparam string thisUnit The unit to check cast time remaining. Defaults to "player" if not provided.
    -- @treturn number
    if cast.timeRemain == nil then
        cast.timeRemain = function(thisUnit)
            if thisUnit == nil then thisUnit = "player" end
            return br.functions.cast:getCastTimeRemain(thisUnit)
        end
    end

    --- Gets the time since the last cast of this spell occurred (very large if it hasn't been cast).
    -- @function cast.timeSinceLast.spell
    -- @treturn number
    cast.timeSinceLast[spell] = function()
        return br.functions.misc:getTime() - (br.functions.lastCast.lastCastTable.castTime[currentRank()] or 0)
    end

    --- Checks if the provided condition is true else it waits for 0.1sec.
    -- @function cast.wait
    -- @param condition The condition to check.
    -- @treturn boolean
    if cast.wait == nil then
        cast.wait = function(condition, callback)
            if condition then
                br.functions.misc:after(0.1, callback)
            else
                return true
            end
        end
    end
end