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
        return br.getPowerMax("player",powerIndex) - br.getPower("player",powerIndex)
    end

    --- Gets the fractional counts of their available runes - Used by DKs
    -- @function power.powerType.frac
    -- @return number
    power[powerType].frac = function()
        -- Death Knights
        if isDKRunes then
            local runeCount = 0
            for i = 1, 6 do
                runeCount = runeCount + br._G.GetRuneCount(i)
            end
            return runeCount + math.max(br.runeCDPercent(1),br.runeCDPercent(2),br.runeCDPercent(3),br.runeCDPercent(4),br.runeCDPercent(5),br.runeCDPercent(6))
        end
        -- Destruction Warlocks
        if isDestruction then
            local shardPower = br._G.UnitPower("player", br._G.Enum.PowerType.SoulShards, true)
            local shardModifier = br._G.UnitPowerDisplayMod(br._G.Enum.PowerType.SoulShards)
            local fragmentCount = (shardModifier ~= 0) and (shardPower / shardModifier) or 0
            return (shardPower + fragmentCount)/10
        end
        return br.getPower("player",powerIndex)
    end

    --- Gets the maximum aount of the specified power
    -- @function power.powerType.max
    -- @return number
    power[powerType].max = function()
        return br.getPowerMax("player",powerIndex)
    end

    --- Gets the current amount of specified power as a percentage
    -- @function power.powerType.percent
    -- @return number
    power[powerType].percent = function()
        if br.getPowerMax("player",powerIndex) == 0 then
            return 0
        else
            return ((br.getPower("player",powerIndex) / br.getPowerMax("player",powerIndex)) * 100)
        end
    end

    --- Gets the current rate of regeneration for the specified power
    -- @function power.powerType.regen
    -- @return number
    power[powerType].regen = function()
        return br.getRegen("player")
    end

    --- Gets the time in seconds until the specified power is maxed
    -- @function power.powerType.ttm
    -- @return number
    power[powerType].ttm = function(amount)
        if isDKRunes then
            if amount == nil then amount = 6 end
            return br.runeTimeTill(amount)
        else
            return br.getTimeToMax("player",amount)
        end
    end

    -- --- Function to calculate or fetch power based on `isDKRunes`.
    -- -- This function serves a dual purpose. When `isDKRunes` is true,
    -- -- it counts the total number of 'runes' by executing a loop 6 times
    -- -- and adding the result of `br._G.GetRuneCount(i)` to `runeCount` in each iteration.
    -- -- If `isDKRunes` is false, it simply retrieves the power of the player using `br.getPower()`.
    -- -- @global
    -- -- @name power[powerType]
    -- -- @class function
    -- -- @return runeCount if `isDKRunes` is true, otherwise it returns the result of `br.getPower("player",powerIndex)`
    -- -- power[powerType] = function()
    -- --     if isDKRunes then
    -- --         local runeCount = 0
    -- --         for i = 1, 6 do
    -- --             runeCount = runeCount + br._G.GetRuneCount(i)
    -- --         end
    -- --         return runeCount
    -- --     else
    -- --         return br.getPower("player",powerIndex)
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
                for i = 1, 6 do
                    runeCount = runeCount + br._G.GetRuneCount(i)
                end
                return runeCount
            else
                return br.getPower("player",powerIndex)
            end
        end,

        -- Define the __index metamethod
        __index = function(tbl, key)
            -- Defer to the original table for existing methods
            if tbl[key] then
                return tbl[key]
            end
            -- Handle any additional properties here if needed
        end
    }

    -- Apply the metatable to your power object
    setmetatable(power[powerType], powerMetaTable)
end
