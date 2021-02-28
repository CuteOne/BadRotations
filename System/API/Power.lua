local _, br = ...
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
    local isDKRunes = select(2,br._G.UnitClass("player")) == "DEATHKNIGHT" and v == 5
    local isDestruction = _G.GetSpecializationInfo(_G.GetSpecialization()) == 267 and v == 7
    -- br.player.power.spell.amount() - Returns current amount of the specified power
    power.amount = function()
        if isDKRunes then
            local runeCount = 0
            for i = 1, 6 do
                runeCount = runeCount + _G.GetRuneCount(i)
            end
            return runeCount
        else
            return br.getPower("player",v)
        end
    end
    -- br.player.power.spell.deficit() - Returns amount of specified power until max is reached
    power.deficit = function()
        return br.getPowerMax("player",v) - br.getPower("player",v)
    end
    -- br.player.power.spell.frac() - Used by DKs to return fractional counts of their available runes
    power.frac = function()
        -- Death Knights
        if isDKRunes then
            local runeCount = 0
            for i = 1, 6 do
                runeCount = runeCount + _G.GetRuneCount(i)
            end
            return runeCount + math.max(br.runeCDPercent(1),br.runeCDPercent(2),br.runeCDPercent(3),br.runeCDPercent(4),br.runeCDPercent(5),br.runeCDPercent(6))
        end
        -- Destruction Warlocks
        if isDestruction then
            local shardPower = br._G.UnitPower("player", _G.Enum.PowerType.SoulShards, true)
            local shardModifier = _G.UnitPowerDisplayMod(_G.Enum.PowerType.SoulShards)
            local fragmentCount = (shardModifier ~= 0) and (shardPower / shardModifier) or 0
            return (shardPower + fragmentCount)/10
        end
        return br.getPower("player",v)
    end
    -- br.player.power.spell.max() - Returns maximum amount of the specified power
    power.max = function()
        return br.getPowerMax("player",v)
    end
    -- br.player.power.spell.percent() -- Returns current amount of specified power as a percentage
    power.percent = function()
        if br.getPowerMax("player",v) == 0 then
            return 0
        else
            return ((br.getPower("player",v) / br.getPowerMax("player",v)) * 100)
        end
    end
    -- br.player.power.spell.regen() -- Returns the current rate of regeneration for the specified power
    power.regen = function()
        return br.getRegen("player")
    end
    -- br.player.power.spell.ttm() -- Returns the time in seconds until the specified power is maxed
    power.ttm = function(amount)
        if isDKRunes then
            if amount == nil then amount = 6 end
            return br.runeTimeTill(amount)
        else
            return br.getTimeToMax("player",amount)
        end
    end
end