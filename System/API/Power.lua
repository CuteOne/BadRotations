local _, br = ...
if br.api == nil then br.api = {} end
-- power is the table located at br.player.power
-- powerType is the name of the power passed from the builder which cycles all the collected power from the power list
-- powerIndex is the powerID passed from the builder which cycles all the collected power from the power list
-- Power List options - spell in examples signifies one of these
    -- 0 = mana
    -- 1 = rage
    -- 2 = focus
    -- 3 = energy
    -- 4 = comboPoints
    -- 5 = runes
    -- 6 = runicPower
    -- 7 = soulShards
    -- 8 = astralPower
    -- 9 = holyPower
    -- 10 = altPower
    -- 11 = maelstrom
    -- 12 = chi
    -- 13 = insanity
    -- 16 = arcaneCharges
    -- 17 = fury
    -- 18 = pain
    -- 19 = essence
br.api.power = function(power,powerType,powerIndex)
    local isDKRunes = select(2,br._G.UnitClass("player")) == "DEATHKNIGHT" and powerIndex == 5
    local isDestruction = br._G.GetSpecializationInfo(br._G.GetSpecialization()) == 267 and powerIndex == 7

    -- br.player.power.spell.deficit() - Returns amount of specified power until max is reached
    power[powerType].deficit = function()
        return br.getPowerMax("player",powerIndex) - br.getPower("player",powerIndex)
    end
    -- br.player.power.spell.frac() - Used by DKs to return fractional counts of their available runes
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
    -- br.player.power.spell.max() - Returns maximum amount of the specified power
    power[powerType].max = function()
        return br.getPowerMax("player",powerIndex)
    end
    -- br.player.power.spell.percent() -- Returns current amount of specified power as a percentage
    power[powerType].percent = function()
        if br.getPowerMax("player",powerIndex) == 0 then
            return 0
        else
            return ((br.getPower("player",powerIndex) / br.getPowerMax("player",powerIndex)) * 100)
        end
    end
    -- br.player.power.spell.regen() -- Returns the current rate of regeneration for the specified power
    power[powerType].regen = function()
        return br.getRegen("player")
    end
    -- br.player.power.spell.ttm() -- Returns the time in seconds until the specified power is maxed
    power[powerType].ttm = function(amount)
        if isDKRunes then
            if amount == nil then amount = 6 end
            return br.runeTimeTill(amount)
        else
            return br.getTimeToMax("player",amount)
        end
    end

    --- Function to calculate or fetch power based on `isDKRunes`.
    -- This function serves a dual purpose. When `isDKRunes` is true,
    -- it counts the total number of 'runes' by executing a loop 6 times
    -- and adding the result of `br._G.GetRuneCount(i)` to `runeCount` in each iteration.
    -- If `isDKRunes` is false, it simply retrieves the power of the player using `br.getPower()`.
    -- @global
    -- @name power[powerType]
    -- @class function
    -- @return runeCount if `isDKRunes` is true, otherwise it returns the result of `br.getPower("player",powerIndex)`
    -- power[powerType] = function()
    --     if isDKRunes then
    --         local runeCount = 0
    --         for i = 1, 6 do
    --             runeCount = runeCount + br._G.GetRuneCount(i)
    --         end
    --         return runeCount
    --     else
    --         return br.getPower("player",powerIndex)
    --     end
    -- end
    -- Define the metatable
    local powerMetaTable = {
        -- Define the __call metamethod
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
