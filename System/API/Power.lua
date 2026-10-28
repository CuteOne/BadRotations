---
-- These functions help in retrieving information about player power.
-- Power functions are the profile API table `power` (br.api.profile.power); profiles use it by name.
-- powerType is the name of the power passed from the builder which cycles all the collected power from the power list
-- powerIndex is the powerID passed from the builder which cycles all the collected power from the power list
-- @module power
local _, br = ...

--- Reference for powerIndex and powerType variables.
-- @table powerList
-- @field 0 = mana
-- @field 1 = rage
-- @field 2 = focus
-- @field 3 = energy
-- @field 4 = comboPoints
-- @field 5 = runes
-- @field 6 = runicPower
-- @field 7 = soulShards
-- @field 8 = astralPower
-- @field 9 = holyPower
-- @field 10 = altPower
-- @field 11 = maelstrom
-- @field 12 = chi
-- @field 13 = insanity
-- @field 16 = arcaneCharges
-- @field 17 = fury
-- @field 18 = pain
-- @field 19 = essence

br.api.build.power = function(power,powerType,powerIndex)
    local isDKRunes = br.functions.unit:getClass("player") == "DEATHKNIGHT" and powerIndex == 5
    local isSoulShards = powerIndex == 7

    --- True when the player can pay cost and still have keep left, counting what earlier casts are
    -- promised and the game hasn't charged yet (a bolt queued behind the current cast, Maul waiting on a
    -- swing): power.<powerType>() alone doesn't know those
    -- @function power.<powerType>.affordable
    -- @number cost What the spell costs (cast.cost.<spell>())
    -- @number[opt=0] keep How much to keep back (a heal's cost, the mana to shift back into a form)
    -- @return boolean
    -- @usage if power.mana.affordable(cast.cost.lightningBolt(), cast.cost.healingWave()) then
    power[powerType].affordable = function(cost, keep)
        return br.functions.power:isAffordable(powerIndex, cost, keep)
    end

    --- Gets the amount of specified power until max is reached
    -- @function power.<powerType>.deficit
    -- @return number
    power[powerType].deficit = function()
        return br.functions.power:getPowerMax("player",powerIndex) - br.functions.power:getPower("player",powerIndex)
    end

    --- Gets the amount with its fraction: Death Knight runes counting the next rune's recharge,
    -- soul shards with fragments (Destruction); other powers as power.<powerType>()
    -- @function power.<powerType>.frac
    -- @return number
    power[powerType].frac = function()
        -- Death Knights
        if isDKRunes then
            return br.functions.power:getRuneFrac()
        end
        -- Warlocks
        if isSoulShards then
            return br.functions.power:getSoulShardFrac()
        end
        return br.functions.power:getPower("player",powerIndex)
    end

    --- Gets the maximum aount of the specified power
    -- @function power.<powerType>.max
    -- @return number
    power[powerType].max = function()
        return br.functions.power:getPowerMax("player",powerIndex)
    end

    --- Gets the current amount of specified power as a percentage
    -- @function power.<powerType>.percent
    -- @return number
    power[powerType].percent = function()
        if br.functions.power:getPowerMax("player",powerIndex) == 0 then
            return 0
        else
            return ((br.functions.power:getPower("player",powerIndex) / br.functions.power:getPowerMax("player",powerIndex)) * 100)
        end
    end

    --- Gets the current rate of regeneration for the specified power, per second (in combat)
    -- @function power.<powerType>.regen
    -- @return number
    power[powerType].regen = function()
        return br.functions.power:getRegen(powerIndex)
    end

    --- Gets the time in seconds until the specified power is maxed (999 if it doesn't regenerate)
    -- @function power.<powerType>.ttm
    -- @number[opt] amount Time until this amount instead of the maximum (Death Knight runes: how many runes, default 6)
    -- @return number
    power[powerType].ttm = function(amount)
        if isDKRunes then
            if amount == nil then amount = 6 end
            return br.functions.power:runeTimeTill(amount)
        else
            return br.functions.power:getTimeToMax(powerIndex, amount)
        end
    end

    -- power.<powerType>() is the current amount
    local powerMetaTable = {
        --- Gets the current amount of the specified power.
        -- @function power.<powerType>
        -- @return number
        __call = function()
            if isDKRunes then
                return br.functions.power:getTotalReadyRunes()
            else
                local unit = powerIndex == 4 and "target" or "player"
                return br.functions.power:getPower(unit,powerIndex)
            end
        end,
    }

    -- Apply the metatable to your power object
    setmetatable(power[powerType], powerMetaTable)
    -- Death Knight rune helpers: power.runes.<name>
    if isDKRunes then
        local runes = power[powerType]

        --- Death Knight: ready Blood runes
        -- @function power.runes.blood
        -- @treturn number
        runes.blood = function() return runes.typeCount("blood") end

        --- Death Knight: Blood runes ready, as a percent of all Blood runes
        -- @function power.runes.bloodPercent
        -- @treturn number
        runes.bloodPercent = function() return runes.typePercent("blood") end

        --- Death Knight: how far a rune is through its cooldown, as a percent
        -- @function power.runes.cdPercent
        -- @number index The rune (1-6)
        -- @treturn number
        runes.cdPercent = function(index) return br.functions.power:runeCDPercent(index) end

        --- Death Knight: ready runes of a type
        -- @function power.runes.typeCount
        -- @string rtype "blood", "frost", "unholy" or "death"
        -- @treturn number
        runes.typeCount = function(rtype) return br.functions.power:getRuneCount(rtype) end

        --- Death Knight: ready Death runes
        -- @function power.runes.death
        -- @treturn number
        runes.death = function() return runes.typeCount("death") end

        --- Death Knight: Death runes ready, as a percent
        -- @function power.runes.deathPercent
        -- @treturn number
        runes.deathPercent = function() return runes.typePercent("death") end

        --- Death Knight: ready Frost runes
        -- @function power.runes.frost
        -- @treturn number
        runes.frost = function() return runes.typeCount("frost") end

        --- Death Knight: Frost runes ready, as a percent
        -- @function power.runes.frostPercent
        -- @treturn number
        runes.frostPercent = function() return runes.typePercent("frost") end

        --- Death Knight: every rune's type, whether it is ready and its cooldown
        -- @function power.runes.info
        -- @treturn table
        runes.info = function() return br.functions.power:getRuneObjects() end

        --- Death Knight: runes of a type ready, as a percent (power.runes.percent() is all runes')
        -- @function power.runes.typePercent
        -- @string rtype "blood", "frost", "unholy" or "death"
        -- @treturn number
        runes.typePercent = function(rtype) return br.functions.power:getRunePercent(rtype) end

        --- Death Knight: seconds until a rune is ready
        -- @function power.runes.recharge
        -- @number index The rune (1-6)
        -- @treturn number
        runes.recharge = function(index) return br.functions.power:runeRecharge(index) end

        --- Death Knight: seconds until n runes are ready
        -- @function power.runes.timeTill
        -- @number n How many runes
        -- @treturn number
        runes.timeTill = function(n) return br.functions.power:runeTimeTill(n) end

        --- Death Knight: ready Unholy runes
        -- @function power.runes.unholy
        -- @treturn number
        runes.unholy = function() return runes.typeCount("unholy") end

        --- Death Knight: Unholy runes ready, as a percent
        -- @function power.runes.unholyPercent
        -- @treturn number
        runes.unholyPercent = function() return runes.typePercent("unholy") end
    end
end
