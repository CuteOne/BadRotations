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
    local isDestruction = br.loader.selectedSpecID == 267 and powerIndex == 7

    --- Gets the amount of specified power until max is reached
    -- @function power.<powerType>.deficit
    -- @return number
    power[powerType].deficit = function()
        return br.functions.power:getPowerMax("player",powerIndex) - br.functions.power:getPower("player",powerIndex)
    end

    --- Gets the fractional counts of their available runes - Used by DKs
    -- @function power.<powerType>.frac
    -- @return number
    power[powerType].frac = function()
        -- Death Knights
        if isDKRunes then
            return br.functions.power:getRuneFrac()
        end
        -- Destruction Warlocks
        if isDestruction then
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

    -- --- Function to calculate or fetch power based on `isDKRunes`.
    -- -- This function serves a dual purpose. When `isDKRunes` is true,
    -- -- it counts the total number of 'runes' by executing a loop 6 times
    -- -- and adding the result of `br.game.GetRuneCount(i)` to `runeCount` in each iteration.
    -- -- If `isDKRunes` is false, it simply retrieves the power of the player using `br.functions.power:getPower()`.
    -- -- @global
    -- -- @name power[powerType]
    -- -- @class function
    -- -- @return runeCount if `isDKRunes` is true, otherwise it returns the result of `br.functions.power:getPower("player",powerIndex)`
    -- -- power[powerType] = function()
    -- --     if isDKRunes then
    -- --         local runeCount = 0
    -- --         for i = 1, 6 do
    -- --             runeCount = runeCount + br.game.GetRuneCount(i)
    -- --         end
    -- --         return runeCount
    -- --     else
    -- --         return br.functions.power:getPower("player",powerIndex)
    -- --     end
    -- -- end

    -- -- Define the metatable
    local powerMetaTable = {
        --- Gets the current amount of the specified power.
        -- @function power.<powerType>
        -- @return number
        __call = function(tbl, ...)
            if isDKRunes then
                return br.functions.power:getTotalReadyRunes()
            else
                local unit = powerIndex == 4 and "target" or "player"
                return br.functions.power:getPower(unit,powerIndex)
            end
        end,

        -- Define the __index metamethod
        __index = function(tbl, key)
            -- Use rawget to avoid triggering __index recursively
            local val = rawget(tbl, key)
            if val ~= nil then
                return val
            end
            -- No value found; return nil (or handle computed properties here)
            return nil
        end
    }

    -- Apply the metatable to your power object
    setmetatable(power[powerType], powerMetaTable)
    -- Convenience rune helpers for Death Knight (rune-type specific)
    if isDKRunes then
        power[powerType].runes = power[powerType].runes or {}

        --- Death Knight: ready Blood runes (runes.blood)
        -- @function power.runes.blood
        -- @treturn number
        power[powerType].blood = function() return power[powerType].runes.blood() end

        --- Death Knight: Blood runes ready, as a percent of all Blood runes
        -- @function power.runes.bloodPercent
        -- @treturn number
        power[powerType].bloodPercent = function() return power[powerType].runes.bloodPercent() end

        --- Death Knight: ready Death runes
        -- @function power.runes.death
        -- @treturn number
        power[powerType].death = function() return power[powerType].runes.death() end

        --- Death Knight: Death runes ready, as a percent
        -- @function power.runes.deathPercent
        -- @treturn number
        power[powerType].deathPercent = function() return power[powerType].runes.deathPercent() end

        -- Top-level aliases so callers can use power.runes.<type>() directly
        --- Death Knight: ready Frost runes
        -- @function power.runes.frost
        -- @treturn number
        power[powerType].frost = function() return power[powerType].runes.frost() end

        --- Death Knight: Frost runes ready, as a percent
        -- @function power.runes.frostPercent
        -- @treturn number
        power[powerType].frostPercent = function() return power[powerType].runes.frostPercent() end

        --- Ready Blood runes
        -- @function power.runes.runes.blood
        -- @treturn number
        power[powerType].runes.blood = function() return power[powerType].runes.count("blood") end

        --- Blood runes ready, as a percent
        -- @function power.runes.runes.bloodPercent
        -- @treturn number
        power[powerType].runes.bloodPercent = function() return power[powerType].runes.percent("blood") end

        --- How far a rune is through its cooldown, as a percent
        -- @function power.runes.runes.cdPercent
        -- @number index The rune (1-6)
        -- @treturn number
        power[powerType].runes.cdPercent = function(index)
            return br.functions.power:runeCDPercent(index)
        end

        --- Ready runes of a type
        -- @function power.runes.runes.count
        -- @string rtype "blood", "frost", "unholy" or "death"
        -- @treturn number
        power[powerType].runes.count = function(rtype)
            return br.functions.power:getRuneCount(rtype)
        end

        --- Ready Death runes
        -- @function power.runes.runes.death
        -- @treturn number
        power[powerType].runes.death = function() return power[powerType].runes.count("death") end

        --- Death runes ready, as a percent
        -- @function power.runes.runes.deathPercent
        -- @treturn number
        power[powerType].runes.deathPercent = function() return power[powerType].runes.percent("death") end

        --- Ready Frost runes
        -- @function power.runes.runes.frost
        -- @treturn number
        power[powerType].runes.frost = function() return power[powerType].runes.count("frost") end

        --- Frost runes ready, as a percent
        -- @function power.runes.runes.frostPercent
        -- @treturn number
        power[powerType].runes.frostPercent = function() return power[powerType].runes.percent("frost") end

        --- Every rune: its type, whether it is ready and its cooldown
        -- @function power.runes.runes.info
        -- @treturn table
        power[powerType].runes.info = function()
            return br.functions.power:getRuneObjects()
        end

        --- Runes of a type ready, as a percent
        -- @function power.runes.runes.percent
        -- @string rtype "blood", "frost", "unholy" or "death"
        -- @treturn number
        power[powerType].runes.percent = function(rtype)
            return br.functions.power:getRunePercent(rtype)
        end

        --- Seconds until a rune is ready
        -- @function power.runes.runes.recharge
        -- @number index The rune (1-6)
        -- @treturn number
        power[powerType].runes.recharge = function(index)
            return br.functions.power:runeRecharge(index)
        end

        --- Seconds until n runes are ready
        -- @function power.runes.runes.timeTill
        -- @number n How many runes
        -- @treturn number
        power[powerType].runes.timeTill = function(n)
            return br.functions.power:runeTimeTill(n)
        end

        --- Ready Unholy runes
        -- @function power.runes.runes.unholy
        -- @treturn number
        power[powerType].runes.unholy = function() return power[powerType].runes.count("unholy") end

        --- Unholy runes ready, as a percent
        -- @function power.runes.runes.unholyPercent
        -- @treturn number
        power[powerType].runes.unholyPercent = function() return power[powerType].runes.percent("unholy") end

        --- Death Knight: ready Unholy runes
        -- @function power.runes.unholy
        -- @treturn number
        power[powerType].unholy = function() return power[powerType].runes.unholy() end

        --- Death Knight: Unholy runes ready, as a percent
        -- @function power.runes.unholyPercent
        -- @treturn number
        power[powerType].unholyPercent = function() return power[powerType].runes.unholyPercent() end
    end
end
