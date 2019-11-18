if br.api == nil then br.api = {} end
-- cd is the table located at br.player.cd
-- charges is the table located at br.player.charges
-- cast is the table located at br.player.cast
-- v is the spellID passed from the builder which cycles all the collected ability spells from the spell list for the spec
-- spell in the examples represent the name in the ability list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
br.api.spells = function(spells,k,v,subtable)
    if subtable == "cd" then
        if spells[k] == nil then spells[k] = {} end
        local cd = spells[k]
        cd.exists = function()
            return getSpellCD(v) > 0
        end
        cd.remain = function()
            return getSpellCD(v)
        end
        cd.remains = function()
            return getSpellCD(v)
        end
        cd.duration = function()
            local _, CD = GetSpellCooldown(v)
            return CD
        end
        cd.ready = function()
            return getSpellCD(v) == 0
        end
    end
    if subtable == "charges" then
        if spells[k] == nil then spells[k] = {} end
        local charges = spells[k]
        charges.exists = function()
            return getCharges(v) >= 1
        end
        charges.count = function()
            return getCharges(v)
        end
        charges.frac = function()
            return getChargesFrac(v)
        end
        charges.max = function()
            return getChargesFrac(v,true)
        end
        charges.recharge = function(chargeMax)
            if chargeMax then
                return getRecharge(v,true)
            else
                return getRecharge(v)
            end
        end
        charges.timeTillFull = function()
            return getFullRechargeTime(v)
        end
    end
    if subtable == "cast" then
        local cast = spells
        cast[k] = function(thisUnit,debug,minUnits,effectRng,predict,predictPad)
            return createCastFunction(thisUnit,debug,minUnits,effectRng,v,k,predict,predictPad)
        end

        if cast.able == nil then cast.able = {} end
        cast.able[k] = function(thisUnit,debug,minUnits,effectRng,predict,predictPad)
            return createCastFunction(thisUnit,"debug",minUnits,effectRng,v,k,predict,predictPad)
            -- return self.cast[v](nil,"debug")
        end

        if cast.active == nil then cast.active = {} end
        cast.active[k] = function(unit)
            if unit == nil then unit = "player" end
            return isCastingSpell(v,unit)
        end

        if cast.cost == nil then cast.cost = {} end
        cast.cost[k] = function(altPower)
            if altPower == nil then altPower = false end
            if altPower then
                return select(2,getSpellCost(v))
            else
                return select(1,getSpellCost(v))
            end
        end

        if cast.current == nil then cast.current = {} end
        cast.current[k] = function(spellID,unit)
            if spellID == nil then spellID = v end
            if unit == nil then unit = "player" end
            return isCastingSpell(spellID,unit)
        end

        -- if cast.dispellabe == nil then cast.dispellable = {} end
        -- cast.dispellable[k] = function(thisUnit)
        --     if thisUnit == nil then thisUnit = "target" end
        --     return canDispel(thisUnit,v)
        -- end

        if cast.inFlight == nil then cast.inFlight = {} end
        cast.inFlight[k] = function(unit)
            return br.InFlight.Check(v, unit)
        end

        if cast.last == nil then cast.last = {} end
        cast.last[k] = function(index)
            local tracker = br.lastCast.tracker
            index = index or 1
            return tracker[index] and tracker[index] == v
        end

        if cast.last.time == nil then cast.last.time = {} end
        cast.last.time[k] = function()
            local castTime = br.lastCast.castTime[v] or 0
            return castTime
        end

        if cast.timeSinceLast == nil then cast.timeSinceLast = {} end
        cast.timeSinceLast[k] = function()
            local castTime = br.lastCast.castTime[v] or 0
            return GetTime() - castTime
        end

        if cast.pool == nil then cast.pool = {} end
        cast.pool[k] = function(altPower, specificAmt, multiplier)
            local powerType = select(2, UnitPowerType("player")):lower()
            local power = br.player.power
            specificAmt = specificAmt or 0
            multiplier = multiplier or 1
            if altPower == nil then altPower = false end
            return power[powerType].amount() < cast.cost[k](altPower) * multiplier or
                power[powerType].amount() < specificAmt
        end

        if cast.range == nil then cast.range = {} end
        cast.range[k] = function()
            return getSpellRange(v)
        end

        if cast.regen == nil then cast.regen = {} end
        cast.regen[k] = function()
            return getCastingRegen(v)
        end

        if cast.safe == nil then cast.safe = {} end
        cast.safe[k] = function(unit,effectRng,minUnits,aoeType)
            return isSafeToAoE(v,unit,effectRng,minUnits,aoeType)
        end

        if cast.time == nil then cast.time = {} end
        cast.time[k] = function()
            return getCastTime(v)
        end

        if cast.timeRemain == nil then cast.timeRemain = {} end
        cast.timeRemain[k] = function(Unit)
            if Unit == nil then Unit = "player" end
            return getCastTimeRemain(Unit)
        end
    end
end