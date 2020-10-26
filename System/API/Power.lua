if br.api == nil then br.api = {} end
-- power is the table located at br.player.power
-- v is the powerID passed from the builder which cycles all the collected power from the power list
-- Power List options - spell in examples signifies one of these
    -- mana
    -- rage
    -- focus
    -- energy
    -- comboPoints
    -- runes
    -- runicPower
    -- soulShards
    -- astralPower
    -- holyPower
    -- altPower
    -- maelstrom
    -- chi
    -- insanity
    -- obsolete
    -- obsolete2
    -- arcaneCharges
    -- fury
    -- pain
br.api.power = function(power,v)
    local isDKRunes = select(2,UnitClass("player")) == "DEATHKNIGHT" and v == 5
    local isDestruction = GetSpecializationInfo(GetSpecialization()) == 267 and v == 7
    -- br.player.power.spell.amount() - Returns current amount of the specified power
    power.amount = function()
        if isDKRunes then
            local runeCount = 0
            for i = 1, 6 do
                runeCount = runeCount + GetRuneCount(i)
            end
            return runeCount
        else
            return getPower("player",v)
        end
    end
    -- br.player.power.spell.deficit() - Returns amount of specified power until max is reached
    power.deficit = function()
        return getPowerMax("player",v) - getPower("player",v)
    end
    -- br.player.power.spell.frac() - Used by DKs to return fractional counts of their available runes
    power.frac = function()
        -- Death Knights
        if isDKRunes then
            local runeCount = 0
            for i = 1, 6 do
                runeCount = runeCount + GetRuneCount(i)
            end
            return runeCount + math.max(runeCDPercent(1),runeCDPercent(2),runeCDPercent(3),runeCDPercent(4),runeCDPercent(5),runeCDPercent(6))
        end
        -- Destruction Warlocks
        if isDestruction then
            local shardPower = UnitPower("player", Enum.PowerType.SoulShards, true)
            local shardModifier = UnitPowerDisplayMod(Enum.PowerType.SoulShards)
            local fragmentCount = (shardModifier ~= 0) and (shardPower / shardModifier) or 0
            return (shardPower + fragmentCount)/10
        end
        return getPower("player",v)
    end
    -- br.player.power.spell.max() - Returns maximum amount of the specified power
    power.max = function()
        return getPowerMax("player",v)
    end
    -- br.player.power.spell.percent() -- Returns current amount of specified power as a percentage
    power.percent = function()
        if getPowerMax("player",v) == 0 then
            return 0
        else
            return ((getPower("player",v) / getPowerMax("player",v)) * 100)
        end
    end
    -- br.player.power.spell.regen() -- Returns the current rate of regeneration for the specified power
    power.regen = function()
        return getRegen("player")
    end
    -- br.player.power.spell.ttm() -- Returns the time in seconds until the specified power is maxed
    power.ttm = function(amount)
        if isDKRunes then
            if amount == nil then amount = 6 end
            return runeTimeTill(amount)
        else
            return getTimeToMax("player",amount)
        end
    end
end