---
-- These functions help in retrieving information about debuffs.
-- Debuff functions are the profile API table `debuff` (br.api.profile.debuff); profiles use it by name.
-- `spell` in the function represent the name in the
-- debuffs list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- @module debuff
local _, br = ...


br.api.build.debuffs = function(debuff, k, v)
    local spec = br.loader.selectedSpecID
    -- The spell list entry (a rank list on ranked clients); v is set to its current rank at the
    -- start of every function, so a newly learned rank counts straight away
    local ref = v
    local function currentRank() return br.functions.spell:currentRank(ref) end
    v = currentRank()

    --- Gets the value of the debuff when it was applied.
    -- @function debuff.spell.applied
    -- @string[opt="target"] thisUnit The unit to check the debuff applied value on.
    -- @treturn number
    debuff.applied = function(thisUnit)
        v = currentRank()
        local thisUnit = br.functions.unit:getObjectFromGUID(thisUnit) or thisUnit or "target"
        local bleed = br.readers.combatLog.bleed[k]
        return (spec == 103 or spec == 259) and bleed and bleed[thisUnit] or 0
    end

    --- Calculates the snapshot value of a debuff.
    -- @function debuff.spell.calc
    -- @treturn number
    debuff.calc = function()
        v = currentRank()
        return (spec == 103 or spec == 259) and br.functions.aura:getSnapshotValue(v) or 0
    end

    --- Gets the count of a specific debuff across all units.
    -- @function debuff.spell.count
    -- @treturn number
    debuff.count = function()
        v = currentRank()
        return tonumber(br.functions.aura:getDebuffCount(v))
    end

    --- Gets the duration of a debuff on a unit.
    -- @function debuff.spell.duration
    -- @string[opt="target"] thisUnit The unit to check the debuff duration on.
    -- @string[opt="player"] sourceUnit "player": applied by you; "any": by anyone
    -- @treturn number
    debuff.duration = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return br.functions.aura:getDebuffDuration(thisUnit, v, sourceUnit) or 0
    end

    --- Checks if a debuff exists on a unit.
    -- @function debuff.spell.exists
    -- @string[opt="target"] thisUnit The unit to check the debuff on.
    -- @string[opt="player"] sourceUnit "player": applied by you; "any": by anyone
    -- @treturn boolean
    debuff.exists = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return br.functions.aura:UnitDebuffID(thisUnit, v, sourceUnit) ~= nil
    end

    --- Checks if a debuff is exsanguinated.
    -- @function debuff.spell.exsang
    -- @string[opt="target"] thisUnit The unit to check the debuff on.
    -- @treturn boolean
    debuff.exsang = function(thisUnit)
        v = currentRank()
        local exsa = br.readers.combatLog.exsa[k]
        return spec == 259 and exsa and exsa[thisUnit] or false
    end

    --- Gets the unit with the lowest remaining time for a debuff within a specified range.
    -- @function debuff.spell.lowest
    -- @number[opt=40] range The range to check units within.
    -- @string[opt="remain"] debuffType The type of debuff check to perform (e.g., "remain").
    -- @treturn string
    debuff.lowest = function(range, debuffType, source)
        v = currentRank()
        if range == nil then range = 40 end
        if debuffType == nil then debuffType = "remain" end
        return br.functions.aura:getDebuffMinMax(function(u) return debuff[debuffType](u) end, range, "min", source) or "target"
    end

    --- Gets the unit with the lowest remaining time for a debuff within a specified range, considering only pets.
    -- @function debuff.spell.lowestPet
    -- @number[opt=8] range The range to check units within.
    -- @string[opt="remain"] debuffType The type of debuff check to perform (e.g., "remain").
    -- @treturn string
    debuff.lowestPet = function(range, debuffType)
        v = currentRank()
        if range == nil then range = 8 end
        if debuffType == nil then debuffType = "remain" end
        return br.functions.aura:getDebuffMinMaxButForPetsThisTime(function(u) return debuff[debuffType](u) end, range, "min") or "target"
    end

    --- Gets the unit with the highest remaining time for a debuff within a specified range.
    -- @function debuff.spell.max
    -- @number[opt=40] range The range to check units within.
    -- @string[opt="remain"] debuffType The type of debuff check to perform (e.g., "remain").
    -- @treturn string
    debuff.max = function(range, debuffType)
        v = currentRank()
        if range == nil then range = 40 end
        if debuffType == nil then debuffType = "remain" end
        return br.functions.aura:getDebuffMinMax(function(u) return debuff[debuffType](u) end, range, "max") or "target"
    end

    --- The duration the refresh window is worked out from: the debuff's current duration on the unit
    -- (debuff.spell.refresh refreshes in its last 30%).
    -- @function debuff.spell.pandemic
    -- @string[opt="target"] thisUnit The unit to check the pandemic threshold on.
    -- @string[opt="player"] sourceUnit "player": applied by you; "any": by anyone
    -- @treturn number
    debuff.pandemic = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if thisUnit == 'target' then thisUnit = br.functions.unit:getUnitGUID("target") end
        return debuff.duration(thisUnit, sourceUnit)
    end

    --- Gets the multiplier for the debuff based on its remaining time and duration.
    -- @function debuff.spell.pmultiplier
    -- @string[opt="target"] thisUnit The unit to check the debuff multiplier on.
    -- @string[opt="player"] sourceUnit "player": applied by you; "any": by anyone
    -- @treturn number
    debuff.pmultiplier = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if thisUnit == 'target' then thisUnit = br.functions.unit:getUnitGUID("target") end
        local multiplier = 0
        local duration = br.functions.aura:getDebuffDuration(thisUnit, v, sourceUnit) or 0
        if duration > 0 then
            multiplier = math.abs(br.functions.aura:getDebuffRemain(thisUnit, v, sourceUnit)) / duration
        end
        return multiplier
    end

    --- Checks if a debuff should be refreshed based on its remaining time and pandemic threshold.
    -- @function debuff.spell.refresh
    -- @string[opt="target"] thisUnit The unit to check if the debuff should be refreshed on.
    -- @string[opt="player"] sourceUnit "player": applied by you; "any": by anyone
    -- @treturn boolean
    debuff.refresh = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        local remain = debuff.remain(thisUnit, sourceUnit)
        return remain == 0 or remain <= (debuff.pandemic(thisUnit, sourceUnit) * 0.3) - 0.5
    end

    --- Gets the count of units that should have their debuff refreshed.
    -- @function debuff.spell.refreshCount
    -- @number[opt=40] range The range to check units within.
    -- @treturn number
    debuff.refreshCount = function(range)
        v = currentRank()
        local counter = 0
        for l, _ in pairs(br.engines.enemiesEngine.enemy) do
            local thisUnit = br.engines.enemiesEngine.enemy[l].unit
            if range == nil then range = 40 end
            local distance = br.functions.range:getDistance(thisUnit, "player")
            -- check if unit is valid
            if br.functions.unit:GetObjectExists(thisUnit) and distance <= range then
                -- increase counter for each occurences
                if debuff.refresh(thisUnit, "player") then
                    counter = counter + 1
                end
            end
        end
        return tonumber(counter)
    end

    --- Gets the remaining time of a debuff on a unit.
    -- @function debuff.spell.remain
    -- @string[opt="target"] thisUnit The unit to check the debuff remaining time on.
    -- @string[opt="player"] sourceUnit "player": applied by you; "any": by anyone
    -- @treturn number
    debuff.remain = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return math.abs(br.functions.aura:getDebuffRemain(thisUnit, v, sourceUnit))
    end

    --- Gets the count of units with a debuff remaining time less than a specified value.
    -- @function debuff.spell.remainCount
    -- @number remain The remaining time to check against.
    -- @treturn number
    debuff.remainCount = function(remain)
        v = currentRank()
        return tonumber(br.functions.aura:getDebuffRemainCount(v, remain))
    end

    --- Gets the remaining time of a debuff on a unit. (Duplicate of debuff.spell.remain)
    -- @function debuff.spell.remains
    -- @string[opt="target"] thisUnit The unit to check the debuff remaining time on.
    -- @string[opt="player"] sourceUnit "player": applied by you; "any": by anyone
    -- @treturn number
    debuff.remains = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return math.abs(br.functions.aura:getDebuffRemain(thisUnit, v, sourceUnit))
    end

    --- Gets the stack count of a debuff on a unit.
    -- @function debuff.spell.stack
    -- @string[opt="target"] thisUnit The unit to check the debuff stack count on.
    -- @string[opt="player"] sourceUnit "player": applied by you; "any": by anyone
    -- @treturn number
    debuff.stack = function(thisUnit, sourceUnit)
        v = currentRank()
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        -- A debuff that's on but doesn't stack reports 0 applications: count it as 1
        local auraInfo = br.functions.aura:UnitDebuffID(thisUnit, v, sourceUnit)
        if auraInfo == nil then return 0 end
        local stacks = auraInfo.applications or 0
        return stacks == 0 and 1 or stacks
    end

    --- Gets the number of debuff ticks that will be gained by reapplying the debuff to the specified unit.
    -- @function debuff.spell.ticksGainedOnRefresh
    -- @param thisUnit string|nil The unit to check the ticks gained by reapplying the debuff on (optional, default "target").
    -- @return number
    debuff.ticksGainedOnRefresh = function(thisUnit)
        v = currentRank()
        local haste = br.functions.misc:getSpellHaste()
        local hasteMultiplier = 1 + (haste / 100)
        local baseTickTime = br.functions.aura:getBaseTickTime(v)
        local hastedTickTime = baseTickTime / hasteMultiplier
        if thisUnit == nil then thisUnit = "target" end
        local auraInfo = br.functions.aura:UnitDebuffID(thisUnit, v, "player") -- your own DoT only
        if auraInfo then
            local expirationTime = auraInfo.expirationTime
            local duration = auraInfo.duration
            local remainingDuration = expirationTime - br.functions.misc:getTime()
            local remainingTicks = math.floor(remainingDuration / hastedTickTime)

            -- Calculate the additional ticks (pandemic mechanic)
            local pandemicThreshold = duration * 0.3
            local extraDuration = math.min(remainingDuration, pandemicThreshold)
            local totalDuration = duration + extraDuration
            local totalTicks = math.floor(totalDuration / hastedTickTime)

            return totalTicks - remainingTicks -- The additional ticks gained by refreshing
        else
            -- Duration amount here shouldn't matter, since no DoT exists
            return math.floor(99 / hastedTickTime) -- Return the max possible ticks for a fresh DoT
        end
    end

    --- Gets the number of debuff ticks remaining until it expires on the specified unit.
    -- @function debuff.spell.ticksRemain
    -- @param thisUnit string|nil The unit to check the remaining ticks on (optional, default "target").
    -- @return number
    debuff.ticksRemain = function(thisUnit)
        v = currentRank()
        local haste = br.functions.misc:getSpellHaste()
        local hasteMultiplier = 1 + (haste / 100)
        local baseTickTime = br.functions.aura:getBaseTickTime(v)
        local hastedTickTime = baseTickTime / hasteMultiplier
        if thisUnit == nil then thisUnit = "target" end
        local auraInfo = br.functions.aura:UnitDebuffID(thisUnit, v, "player") -- your own DoT only
        if auraInfo then
            local expirationTime = auraInfo.expirationTime
            -- local duration = auraInfo.duration
            local remainingDuration = expirationTime - br.functions.misc:getTime()
            local remainingTicks = math.floor(remainingDuration / hastedTickTime)

            return remainingTicks -- The additional ticks gained by refreshing
        else
            -- Duration amount here shouldn't matter, since no DoT exists
            return math.floor(99 / hastedTickTime) -- Return the max possible ticks for a fresh DoT
        end
    end
end
