---
-- These functions help in retrieving information about player power.
-- Power functions are stored in br.player.power and can be utilized by `local power = br.player.power` in your profile.
-- power is the table located at br.player.power
-- powerType is the name of the power passed from the builder which cycles all the collected power from the power list
-- powerIndex is the powerID passed from the builder which cycles all the collected power from the power list
-- @module br.player.power
local _, br = ...
if br.api == nil then br.api = {} end

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

br.api.power = function(power,powerType,powerIndex)
    local isDKRunes = select(2,br._G.UnitClass("player")) == "DEATHKNIGHT" and powerIndex == 5
    local isDestruction = br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization()) == 267 and powerIndex == 7

    --- Gets the amount of specified power until max is reached
    -- @function power.powerType.deficit
    -- @return number
    power[powerType].deficit = function()
        return br.functions.power:getPowerMax("player",powerIndex) - br.functions.power:getPower("player",powerIndex)
    end

    --- Gets the fractional counts of their available runes - Used by DKs
    -- @function power.powerType.frac
    -- @return number
    power[powerType].frac = function()
        -- Death Knights
        if isDKRunes then
            local runeCount = 0
            local runeInfo = br.functions.power:getRuneInfo()
            for i = 1, 6 do
                runeCount = runeCount + (runeInfo[i] and runeInfo[i].Count or 0)
            end
            return runeCount + math.max(br.functions.power:runeCDPercent(1),br.functions.power:runeCDPercent(2),br.functions.power:runeCDPercent(3),br.functions.power:runeCDPercent(4),br.functions.power:runeCDPercent(5),br.functions.power:runeCDPercent(6))
        end
        -- Destruction Warlocks
        if isDestruction then
            local shardPower = br._G.UnitPower("player", br._G.Enum.PowerType.SoulShards, true)
            local shardModifier = br._G.UnitPowerDisplayMod(br._G.Enum.PowerType.SoulShards)
            local fragmentCount = (shardModifier ~= 0) and (shardPower / shardModifier) or 0
            return (shardPower + fragmentCount)/10
        end
        return br.functions.power:getPower("player",powerIndex)
    end

    --- Gets the maximum aount of the specified power
    -- @function power.powerType.max
    -- @return number
    power[powerType].max = function()
        return br.functions.power:getPowerMax("player",powerIndex)
    end

    --- Gets the current amount of specified power as a percentage
    -- @function power.powerType.percent
    -- @return number
    power[powerType].percent = function()
        if br.functions.power:getPowerMax("player",powerIndex) == 0 then
            return 0
        else
            return ((br.functions.power:getPower("player",powerIndex) / br.functions.power:getPowerMax("player",powerIndex)) * 100)
        end
    end

    --- Gets the current rate of regeneration for the specified power
    -- @function power.powerType.regen
    -- @return number
    power[powerType].regen = function()
        return br.functions.power:getRegen("player")
    end

    --- Gets the time in seconds until the specified power is maxed
    -- @function power.powerType.ttm
    -- @return number
    power[powerType].ttm = function(amount)
        if isDKRunes then
            if amount == nil then amount = 6 end
            return br.functions.power:runeTimeTill(amount)
        else
            return br.functions.power:getTimeToMax("player",amount)
        end
    end

    -- --- Function to calculate or fetch power based on `isDKRunes`.
    -- -- This function serves a dual purpose. When `isDKRunes` is true,
    -- -- it counts the total number of 'runes' by executing a loop 6 times
    -- -- and adding the result of `br._G.GetRuneCount(i)` to `runeCount` in each iteration.
    -- -- If `isDKRunes` is false, it simply retrieves the power of the player using `br.functions.power:getPower()`.
    -- -- @global
    -- -- @name power[powerType]
    -- -- @class function
    -- -- @return runeCount if `isDKRunes` is true, otherwise it returns the result of `br.functions.power:getPower("player",powerIndex)`
    -- -- power[powerType] = function()
    -- --     if isDKRunes then
    -- --         local runeCount = 0
    -- --         for i = 1, 6 do
    -- --             runeCount = runeCount + br._G.GetRuneCount(i)
    -- --         end
    -- --         return runeCount
    -- --     else
    -- --         return br.functions.power:getPower("player",powerIndex)
    -- --     end
    -- -- end

    -- -- Define the metatable
    local powerMetaTable = {
        --- Gets the current amount of the specified power.
        -- @function power.powerType
        -- @return number
        __call = function(tbl, ...)
            if isDKRunes then
                local runeCount = 0
                local runeInfo = br.functions.power:getRuneInfo()
                for i = 1, 6 do
                    runeCount = runeCount + (runeInfo[i] and runeInfo[i].Count or 0)
                end
                return runeCount
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
        power[powerType].runes.count = function(rtype)
            return br.functions.power:getRuneCount(rtype)
        end
        power[powerType].runes.percent = function(rtype)
            return br.functions.power:getRunePercent(rtype)
        end
        power[powerType].runes.info = function()
            return br.functions.power:getRuneInfo()
        end
        power[powerType].runes.recharge = function(index)
            return br.functions.power:runeRecharge(index)
        end
        power[powerType].runes.cdPercent = function(index)
            return br.functions.power:runeCDPercent(index)
        end
        power[powerType].runes.timeTill = function(n)
            return br.functions.power:runeTimeTill(n)
        end
        power[powerType].runes.frost = function() return power[powerType].runes.count("frost") end
        power[powerType].runes.unholy = function() return power[powerType].runes.count("unholy") end
        power[powerType].runes.blood = function() return power[powerType].runes.count("blood") end
        power[powerType].runes.death = function() return power[powerType].runes.count("death") end
        power[powerType].runes.frostPercent = function() return power[powerType].runes.percent("frost") end
        power[powerType].runes.unholyPercent = function() return power[powerType].runes.percent("unholy") end
        power[powerType].runes.bloodPercent = function() return power[powerType].runes.percent("blood") end
        power[powerType].runes.deathPercent = function() return power[powerType].runes.percent("death") end
        -- Top-level aliases so callers can use br.player.power.runes.<type>() directly
        power[powerType].frost = function() return power[powerType].runes.frost() end
        power[powerType].unholy = function() return power[powerType].runes.unholy() end
        power[powerType].blood = function() return power[powerType].runes.blood() end
        power[powerType].death = function() return power[powerType].runes.death() end
        power[powerType].frostPercent = function() return power[powerType].runes.frostPercent() end
        power[powerType].unholyPercent = function() return power[powerType].runes.unholyPercent() end
        power[powerType].bloodPercent = function() return power[powerType].runes.bloodPercent() end
        power[powerType].deathPercent = function() return power[powerType].runes.deathPercent() end
    end
end
