local br = _G["br"]
if br.api == nil then br.api = {} end
----------------------
--- ABOUT THIS API ---
----------------------

-- These calls help in retrieving information about spell casts.
-- cast is the table located at br.player.cast, call this in profile to use.
-- id is the spellID passed from the builder which cycles all the collected ability spells from the spell list for the spec
-- spell in the examples represent the name in the ability list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua

br.api.cast = function(self,spell,id)
    if self.cast == nil then self.cast = {} end
    local cast = self.cast

    ----------------
    --- Cast API ---
    ----------------

    -- br.player.cast.spell()
    --[[ Args:
        thisUnit - Acceptable parameters listed below
                nil - BR will attempt to determine best unit.
                standard WoW units - see: http://wowprogramming.com/docs/api_types.html#unitID
                dynamic units - see: System/API/Dynamic.lua
                "best" - BR will attempt to cast ground AoE at a determined best localtion given castType, minUnits, effectRng parameters.
                "playerGround" - BR will cast ground AoE at player's location given minUnits, effectRng parameters.
                "targetGround" - BR will cast ground AoE at target's location given minUnits, effectRng parameters.
                "petTarget" - BR will cast at pet's target.
        castType - Acceptable parameters listed below
                nil - Only specify if using minUnits, effectRng, predict, predictPad and no other castType parameter used, leave blank otherwise.
                "rect" - BR will cast if enemies are in the defined rectangle AoE (and if all units are safe to be attacked with option Safe Damage Check) given minUnits, effectRng parameters.
                "cone" - BR will cast if enemies are in the defined cone AoE (and if all units are safe to be attacked with option Safe Damage Check) given minUnits, effectRng parameters.
                "ground" - BR will cast at thisUnit's ground location if enemies are in the defined AoE (and if all units are safe to be attacked with option Safe Damage Check) given minUnits, effectRng parameters.
                "aoe" - BR will cast if enemies are in the defined AoE (and if all units are safe to be attacked with option Safe Damage Check) given minUnits, effectRng parameters.
                "dead" - BR will cast on a dead target.
                "pet" - BR will cast pet spell. (Hunters / Warlocks)
        minUnits - Specify minimal number of units needed to be hit by AoE spell (used with thisUnt or castType) before it will use.
        effectRng - Specify the AoE's effect range (used with thisUnit or castType) to determine units hit by it.
        predict - If passed "true" will attempt to predict enemmy movements on ground location AoE spells.
        predictPad - Pad the prediction cast time, predict must be "true".
    ]]
    cast[spell] = function(thisUnit,castType,minUnits,effectRng,predict,predictPad)
        return createCastFunction(thisUnit,castType,minUnits,effectRng,id,spell,predict,predictPad)
    end

    -- br.player.cast.able.spell() - same as above but instead of casting returns True/False
    if cast.able == nil then cast.able = {} end
    cast.able[spell] = function(thisUnit,debug,minUnits,effectRng,predict,predictPad)
        return createCastFunction(thisUnit,"debug",minUnits,effectRng,id,spell,predict,predictPad)
    end

    -- br.player.cast.active.spell() - Returns if the spell is the one currently being cast.
    --[[Args:
        thisUnit - Acceptable parameters listed below
                nil - BR will default to "player".
                standard WoW units - see: http://wowprogramming.com/docs/api_types.html#unitID
                dynamic units - see: System/API/Dynamic.lua
    ]]
    if cast.active == nil then cast.active = {} end
    cast.active[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return isCastingSpell(id,thisUnit)
    end

    if cast.cancel == nil then cast.cancel = {} end
    cast.cancel[spell] = function()
        local SpellStopCasting = _G["SpellStopCasting"]
        if self.cast.current[spell]() then
            SpellStopCasting()
            return true
        end
        return false
    end

    -- br.player.cast.cost.spell() - Returns the cost of the spell
    --[[Args: 
        altPower = Set to "true" to return alternate power cost.
    ]]
    if cast.cost == nil then cast.cost = {} end
    cast.cost[spell] = function(altPower)
        if altPower == nil then altPower = false end
        if altPower then
            return select(2,getSpellCost(id))
        else
            return select(1,getSpellCost(id))
        end
    end

    -- br.player.cast.current.spell() - Returns if the spell is the currently cast spell for the target (Alternate to br.player.cast.active.spell())
    --[[Args:
        thisUnit - Acceptable parameters listed below
                nil - BR will default to "player".
                standard WoW units - see: http://wowprogramming.com/docs/api_types.html#unitID
                dynamic units - see: System/API/Dynamic.lua
    ]]
    if cast.current == nil then cast.current = {} end
    cast.current[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return isCastingSpell(id,thisUnit)
    end
    
    -- br.player.cast.dispel.spell() - Returns if the spell if capable of dispelling the target.
    --[[Args:
        thisUnit - Acceptable parameters listed below
                nil - BR will default to "target".
                standard WoW units - see: http://wowprogramming.com/docs/api_types.html#unitID
                dynamic units - see: System/API/Dynamic.lua
    ]]
    if cast.dispel == nil then cast.dispel = {} end
    cast.dispel[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return canDispel(thisUnit,id) or false
    end

    -- br.player.cast.form(formIndex) - Casts the form corresponding to the provided formIndex number
    if cast.form == nil then 
        cast.form = function(formIndex)
            local CastShapeshiftForm = _G["CastShapeshiftForm"]
            if formIndex == nil then formIndex = 0 end
            return CastShapeshiftForm(formIndex)
        end
    end

    -- br.player.cast.inFlight.spell() - Returns if the spell is currently in flight to the target.
    --[[Args:
        thisUnit - Acceptable parameters listed below
                nil - BR will default to "target".
                standard WoW units - see: http://wowprogramming.com/docs/api_types.html#unitID
                dynamic units - see: System/API/Dynamic.lua
    ]]
    if cast.inFlight == nil then cast.inFlight = {} end
    cast.inFlight[spell] = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.InFlight.Check(id, thisUnit)
    end

    -- br.player.cast.inFlightRemain.spell() - Returns time remaining on a spell in flight to the target.
    --[[Args:
        thisUnit - Acceptable parameters listed below
                nil - BR will default to "target".
                standard WoW units - see: http://wowprogramming.com/docs/api_types.html#unitID
                dynamic units - see: System/API/Dynamic.lua
    ]]
    if cast.inFlightRemain == nil then cast.inFlightRemain = {} end
    cast.inFlightRemain[spell] = function(unit)
        return br.InFlight.Remain(id, unit)
    end

    -- br.player.cast.last.spell() - Returns if the spell was the last one cast or not.
    --[[Args:
        index - Number of last cast spell up to 10 previous spells, default value is 1 if not provided.
    ]]
    if cast.last == nil then cast.last = {} end
    cast.last[spell] = function(index)
        local tracker = br.lastCast.tracker
        index = index or 1
        return tracker[index] and tracker[index] == id
    end

    -- br.player.cast.last.time.spell() - Returns the GetTime() value the last cast of this spell occured.
    if cast.last.time == nil then cast.last.time = {} end
    cast.last.time[spell] = function()
        if br.lastCast.castTime[id] == nil then br.lastCast.castTime[id] = GetTime() end
        return br.lastCast.castTime[id]
    end

    -- br.player.cast.noControl.spell() - Returns true if the spell can free you of a "no control" effect.
    if cast.noControl == nil then cast.noControl = {} end
    cast.noControl[spell] = function(thisUnit)
        local hasNoControl = _G["hasNoControl"]
        if thisUnit == nil then thisUnit = "player" end
        return hasNoControl(id,thisUnit)
    end

    -- br.player.cast.opener("rip","RIP1",opener.count) -- Attempts to cast special opener condition spell
    if cast.opener == nil then
        cast.opener = function(thisSpell,thisTracker,thisCount)
            local castOpener = _G["castOpener"]
            return castOpener(thisSpell,thisTracker,thisCount)
        end
    end

    -- br.player.cast.openerFail("rip","RIP1",opener.count) -- Resets cast special opener condition if failed to cast
    if cast.openerFail == nil then 
        cast.openerFail = function(thisSpell,thisTracker,thisCount)
            local castOpenerFail = _G["castOpenerFail"]
            return castOpenerFail(thisSpell,thisTracker,thisCount)
        end
    end

    -- br.player.cast.pool.spell() - Returns true if specified power requirements are not met.
    --[[Args:
        altPower = Set to "true" to return alternate power cost.
        specificAmt = Set to specified power amount, defaults to 0 if not provided.
        multiplier = Set to specified power multiplier, defaults to 1 if not provided.
    ]]
    if cast.pool == nil then cast.pool = {} end
    cast.pool[spell] = function(altPower, specificAmt, multiplier)
        local powerType = select(2, UnitPowerType("player")):lower()
        local power = br.player.power
        specificAmt = specificAmt or 0
        multiplier = multiplier or 1
        if altPower == nil then altPower = false end
        return power[powerType].amount() < cast.cost[spell](altPower) * multiplier or
            power[powerType].amount() < specificAmt
    end

    -- br.player.cast.range.spell() - Returns the spells range, if it has one.
    if cast.range == nil then cast.range = {} end
    cast.range[spell] = function()
        return getSpellRange(id)
    end

    -- br.player.cast.regen.spell() - Returns the amount of power spell will generate when cast.
    if cast.regen == nil then cast.regen = {} end
    cast.regen[spell] = function()
        return getCastingRegen(id)
    end

    -- br.player.cast.safe.spell() - Return if safe to cast specified aoe spell on unit given the aoe dimensions.
    --[[ Args:
        thisUnit - Acceptable parameters listed below
                nil - BR will attempt to determine best unit.
                standard WoW units - see: http://wowprogramming.com/docs/api_types.html#unitID
                dynamic units - see: System/API/Dynamic.lua
                "best" - BR will attempt to cast ground AoE at a determined best localtion given castType, minUnits, effectRng parameters.
                "playerGround" - BR will cast ground AoE at player's location given minUnits, effectRng parameters.
                "targetGround" - BR will cast ground AoE at target's location given minUnits, effectRng parameters.
                "petTarget" - BR will cast at pet's target.
        effectRng - Specify the AoE's effect range (used with thisUnit or castType) to determine units hit by it.
        minUnits - Specify minimal number of units needed to be hit by AoE spell (used with thisUnt or castType) before it will use.
        aoeType - Acceptable parameters listed below
                "rect" - BR will cast if enemies are in the defined rectangle AoE (and if all units are safe to be attacked with option Safe Damage Check) given minUnits, effectRng parameters.
                "cone" - BR will cast if enemies are in the defined cone AoE (and if all units are safe to be attacked with option Safe Damage Check) given minUnits, effectRng parameters.
                "ground" - BR will cast at thisUnit's ground location if enemies are in the defined AoE (and if all units are safe to be attacked with option Safe Damage Check) given minUnits, effectRng parameters.
                "aoe" - BR will cast if enemies are in the defined AoE (and if all units are safe to be attacked with option Safe Damage Check) given minUnits, effectRng parameters.
    ]]
    if cast.safe == nil then cast.safe = {} end
    cast.safe[spell] = function(thisUnit,aoeType,minUnits,effectRng)
        return isSafeToAoE(id,thisUnit,effectRng,minUnits,aoeType)
    end

    -- br.player.cast.time.spell() - Return cast time of player's spell, spell is the name of the spell from the spell list.
    if cast.time == nil then cast.time = {} end
    cast.time[spell] = function()
        local castTime = getCastTime(id)
        return castTime > 0 and castTime or getGlobalCD(true)
    end

    -- br.player.cast.timeRemain() -- Return cast time remain on player's cast or supplied target, spell is the name of the spell from spell list.
    --[[Args:
        thisUnit - Acceptable parameters listed below
                nil - BR will default to "player".
                standard WoW units - see: http://wowprogramming.com/docs/api_types.html#unitID
                dynamic units - see: System/API/Dynamic.lua
    ]]
    if cast.timeRemain == nil then cast.timeRemain = {} end
    cast.timeRemain = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return getCastTimeRemain(thisUnit)
    end

    -- br.player.cast.timeSinceLast.spell() - Returns the time since the last cast of this spell occured.
    if cast.timeSinceLast == nil then cast.timeSinceLast = {} end
    cast.timeSinceLast[spell] = function()
        if br.lastCast.castTime[id] == nil then br.lastCast.castTime[id] = GetTime() end
        return GetTime() - br.lastCast.castTime[id]
    end
end