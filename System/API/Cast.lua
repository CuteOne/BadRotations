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
                "best" - BR will attempt to cast ground AoE at a determined best localtion given debug, minUnits, effectRng parameters.
                "playerGround" - BR will cast ground AoE at player's location given minUnits, effectRng parameters.
                "targetGround" - BR will cast ground AoE at target's location given minUnits, effectRng parameters.
                "petTarget" - BR will cast at pet's target.
        debug - Acceptable parameters listed below
                nil - Only specify if using minUnits, effectRng, predict, predictPad and no other debug parameter used, leave blank otherwise.
                "rect" - BR will cast if enemies are in the defined rectangle AoE (and if all units are safe to be attacked with option Safe Damage Check) given minUnits, effectRng parameters.
                "cone" - BR will cast if enemies are in the defined cone AoE (and if all units are safe to be attacked with option Safe Damage Check) given minUnits, effectRng parameters.
                "ground" - BR will cast at thisUnit's ground location if enemies are in the defined AoE (and if all units are safe to be attacked with option Safe Damage Check) given minUnits, effectRng parameters.
                "aoe" - BR will cast if enemies are in the defined AoE (and if all units are safe to be attacked with option Safe Damage Check) given minUnits, effectRng parameters.
                "dead" - BR will cast on a dead target.
                "pet" - BR will cast pet spell. (Hunters / Warlocks)
        minUnits - Specify minimal number of units needed to be hit by AoE spell (used with thisUnt or debug) before it will use.
        effectRng - Specify the AoE's effect range (used with thisUnit or debug) to determine units hit by it.
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

    -- br.player.cast.cost.spell() - Returns the cost of the spell
    if cast.cost == nil then cast.cost = {} end
    cast.cost[spell] = function(altPower)
        if altPower == nil then altPower = false end
        if altPower then
            return select(2,getSpellCost(id))
        else
            return select(1,getSpellCost(id))
        end
    end

    -- br.player.cast.current() -- 
    if cast.current == nil then cast.current = {} end
    cast.current[spell] = function(spellID,thisUnit)
        if spellID == nil then spellID = id end
        if thisUnit == nil then thisUnit = "player" end
        return isCastingSpell(spellID,thisUnit)
    end

    if cast.dispel == nil then cast.dispel = {} end
    cast.dispel[spell] = function(unit)
        if unit == nil then unit = "target" end
        return canDispel(unit,id) or false
    end

    if cast.id == nil then 
        cast.id = function(spellID,thisUnit,debug,minUnits,effectRng,predict,predictPad)
            if spellID == nil then return end
            for j,w in pairs(br.player.spell.abilities) do
                if spellID == w then cast[j](thisUnit,debug,minUnits,effectRng,predict,predictPad) return end
            end
            Print("No cast function found for spellID: "..spellID)
            return
        end
    end

    if cast.inFlight == nil then cast.inFlight = {} end
    cast.inFlight[spell] = function(unit)
        return br.InFlight.Check(id, unit)
    end

    if cast.inFlightRemain == nil then cast.inFlightRemain = {} end
    cast.inFlightRemain[spell] = function(unit)
        return br.InFlight.Remain(id, unit)
    end

    if cast.last == nil then cast.last = {} end
    cast.last[spell] = function(index)
        local tracker = br.lastCast.tracker
        index = index or 1
        return tracker[index] and tracker[index] == id
    end

    if cast.last.time == nil then cast.last.time = {} end
    cast.last.time[spell] = function()
        if br.lastCast.castTime[id] == nil then br.lastCast.castTime[id] = GetTime() end
        return br.lastCast.castTime[id]
    end

    if cast.timeSinceLast == nil then cast.timeSinceLast = {} end
    cast.timeSinceLast[spell] = function()
        if br.lastCast.castTime[id] == nil then br.lastCast.castTime[id] = GetTime() end
        return GetTime() - br.lastCast.castTime[id]
    end

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

    if cast.range == nil then cast.range = {} end
    cast.range[spell] = function()
        return getSpellRange(id)
    end

    if cast.regen == nil then cast.regen = {} end
    cast.regen[spell] = function()
        return getCastingRegen(id)
    end

    -- cast.safe.spell("target",8,1,"cone"), -- Return if safe to cast specified aoe spell on unit given the aoe dimensions.
    if cast.safe == nil then cast.safe = {} end
    cast.safe[spell] = function(unit,effectRng,minUnits,aoeType)
        return isSafeToAoE(id,unit,effectRng,minUnits,aoeType)
    end

    -- cast.time.spell() -- Return cast time of player's spell, spell is the name of the spell from the spell list.
    if cast.time == nil then cast.time = {} end
    cast.time[spell] = function()
        return getCastTime(id)
    end

    -- cast.timeRemain.spell(opTarget) -- Return cast time remain on player's cast or supplied target, spell is the name of the spell from spell list.
    if cast.timeRemain == nil then cast.timeRemain = {} end
    cast.timeRemain[spell] = function(Unit)
        if Unit == nil then Unit = "player" end
        return getCastTimeRemain(Unit)
    end
end