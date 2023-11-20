---
-- These functions help in retrieving information about debuffs.
-- Debuff functions are stored in br.player.debuff and can be utilized
-- by `local debuff = br.player.debuff` in your profile.
-- `spell` in the function represent the name in the
-- debuffs list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- @module br.player.debuff
local _, br = ...

if br.api == nil then br.api = {} end

-- Local function needed to facilitate debuff.calc
local function getSnapshotValue(dot)
    -- Feral Bleeds
    if br._G.GetSpecializationInfo(br._G.GetSpecialization()) == 103 then
        local multiplier        = 1.00
        local Bloodtalons       = 1.30
        -- local SavageRoar        = 1.40
        local TigersFury        = 1.15
        local RakeMultiplier    = 1
        -- Tigers Fury
        if br.player.buff.tigersFury.exists() then multiplier = multiplier*TigersFury end
        -- moonfire feral
        if dot == br.player.spell.debuffs.moonfireFeral then
            -- return moonfire
            return multiplier
        end
        -- Bloodtalons
        if br.player.buff.bloodtalons.exists() and dot == br.player.spell.debuffs.rip then multiplier = multiplier*Bloodtalons end
        -- Savage Roar
        -- if self.buff.savageRoar.exists() then multiplier = multiplier*SavageRoar end
        -- rip
        if dot == br.player.spell.debuffs.rip then
            -- -- Versatility
            -- multiplier = multiplier*(1+Versatility*0.1)
            -- return rip
            return 5*multiplier
        end
        -- rake
        if dot == br.player.spell.debuffs.rake then
            -- Incarnation/Prowl/Sudden Ambush
            if br.player.buff.berserk.exists() or br.player.buff.incarnationAvatarOfAshamane.exists() or br.player.buff.prowl.exists()
                or br.player.buff.shadowmeld.exists() or br.player.buff.suddenAmbush.exists()
            then
                RakeMultiplier = 1.6
            end
            -- return rake
            return multiplier*RakeMultiplier
        end
    end
    -- Assassination Bleeds
    if br._G.GetSpecializationInfo(br._G.GetSpecialization()) == 259 then
        local multiplier = 1
        if br.player.buff.stealth.exists() and br.player.talent.nightstalker and (dot == br.player.spell.debuffs.rupture
            or dot == br.player.spell.debuffs.garrote) then multiplier = 1.5
        end
        if (br.player.buff.stealth.exists() or br.player.buff.vanish.exists()
            or (br.player.buff.subterfuge.exists() and br.player.buff.subterfuge.remain() >= 0.1
            and br.player.buff.subterfuge.remain() >= br.getSpellCD(61304)))
            and dot == br.player.spell.debuffs.garrote and br.player.talent.subterfuge
        then
            multiplier = 1.8
        end
        return multiplier
    end
    return 0
end

br.api.debuffs = function(debuff,k,v)
    local spec = br._G.GetSpecializationInfo(br._G.GetSpecialization())

    --- Checks if a debuff exists on a unit.
    -- @function debuff.spell.exists
    -- @string[opt="target"] thisUnit The unit to check the debuff on.
    -- @string[opt="player"] sourceUnit The unit that applied the debuff.
    -- @treturn boolean
    debuff.exists = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return br.UnitDebuffID(thisUnit,v,sourceUnit) ~= nil
    end

    --- Gets the duration of a debuff on a unit.
    -- @function debuff.spell.duration
    -- @string[opt="target"] thisUnit The unit to check the debuff duration on.
    -- @string[opt="player"] sourceUnit The unit that applied the debuff.
    -- @treturn number
    debuff.duration = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return br.getDebuffDuration(thisUnit,v,sourceUnit) or 0
    end

    --- Gets the remaining time of a debuff on a unit.
    -- @function debuff.spell.remain
    -- @string[opt="target"] thisUnit The unit to check the debuff remaining time on.
    -- @string[opt="player"] sourceUnit The unit that applied the debuff.
    -- @treturn number
    debuff.remain = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return math.abs(br.getDebuffRemain(thisUnit,v,sourceUnit))
    end

    --- Gets the remaining time of a debuff on a unit. (Duplicate of debuff.spell.remain)
    -- @function debuff.spell.remains
    -- @string[opt="target"] thisUnit The unit to check the debuff remaining time on.
    -- @string[opt="player"] sourceUnit The unit that applied the debuff.
    -- @treturn number
    debuff.remains = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return math.abs(br.getDebuffRemain(thisUnit,v,sourceUnit))
    end

    --- Gets the stack count of a debuff on a unit.
    -- @function debuff.spell.stack
    -- @string[opt="target"] thisUnit The unit to check the debuff stack count on.
    -- @string[opt="player"] sourceUnit The unit that applied the debuff.
    -- @treturn number
    debuff.stack = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if br.getDebuffStacks(thisUnit,v,sourceUnit) == 0 and br.UnitDebuffID(thisUnit,v,sourceUnit) ~= nil then
            return 1
        else
            return br.getDebuffStacks(thisUnit,v,sourceUnit)
        end
    end

    --- Gets the pandemic threshold for refreshing a debuff.
    -- @function debuff.spell.pandemic
    -- @string[opt="target"] thisUnit The unit to check the pandemic threshold on.
    -- @string[opt="player"] sourceUnit The unit that applied the debuff.
    -- @treturn number
    debuff.pandemic = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if thisUnit == 'target' then thisUnit = br._G.UnitGUID("target") end
        local pandemic = debuff.duration(thisUnit,sourceUnit)
        if br.player.pandemic[thisUnit] ~= nil and br.player.pandemic[thisUnit][k] ~= nil then
            pandemic = br.player.pandemic[thisUnit][k]
        end
        return pandemic
    end

    --- Gets the multiplier for the debuff based on its remaining time and duration.
    -- @function debuff.spell.pmultiplier
    -- @string[opt="target"] thisUnit The unit to check the debuff multiplier on.
    -- @string[opt="player"] sourceUnit The unit that applied the debuff.
    -- @treturn number
    debuff.pmultiplier = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if thisUnit == 'target' then thisUnit = br._G.UnitGUID("target") end
        local multiplier = 0
        local duration = br.getDebuffDuration(thisUnit,v,sourceUnit) or 0
        if duration > 0 then
            multiplier = math.abs(br.getDebuffRemain(thisUnit,v,sourceUnit)) / duration
        end
        return multiplier
    end

    --- Checks if a debuff should be refreshed based on its remaining time and pandemic threshold.
    -- @function debuff.spell.refresh
    -- @string[opt="target"] thisUnit The unit to check if the debuff should be refreshed on.
    -- @string[opt="player"] sourceUnit The unit that applied the debuff.
    -- @treturn boolean
    debuff.refresh = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        local remain = debuff.remain(thisUnit,sourceUnit)
        return remain == 0 or remain <= (debuff.pandemic(thisUnit,sourceUnit) * 0.3) - 0.5
    end

    --- Gets the count of a specific debuff across all units.
    -- @function debuff.spell.count
    -- @treturn number
    debuff.count = function()
        return tonumber(br.getDebuffCount(v))
    end

    --- Gets the count of units with a debuff remaining time less than a specified value.
    -- @function debuff.spell.remainCount
    -- @number remain The remaining time to check against.
    -- @treturn number
    debuff.remainCount = function(remain)
        return tonumber(br.getDebuffRemainCount(v,remain))
    end

    --- Gets the count of units that should have their debuff refreshed.
    -- @function debuff.spell.refreshCount
    -- @number[opt=40] range The range to check units within.
    -- @treturn number
    debuff.refreshCount = function(range)
        local counter = 0
        for l, _ in pairs(br.enemy) do
            local thisUnit = br.enemy[l].unit
            if range == nil then range = 40 end
            local distance = br.getDistance(thisUnit,"player")
            -- check if unit is valid
            if br.GetObjectExists(thisUnit) and distance <= range then
                -- increase counter for each occurences
                if not debuff.refresh(thisUnit,"player") then
                    counter = counter + 1
                end
            end
        end
        return tonumber(counter)
    end

    --- Gets the unit with the lowest remaining time for a debuff within a specified range.
    -- @function debuff.spell.lowest
    -- @number[opt=40] range The range to check units within.
    -- @string[opt="remain"] debuffType The type of debuff check to perform (e.g., "remain").
    -- @treturn string
    debuff.lowest = function(range,debuffType,source)
        if range == nil then range = 40 end
        if debuffType == nil then debuffType = "remain" end
        return br.getDebuffMinMax(k, range, debuffType, "min", source)
    end

    --- Gets the unit with the lowest remaining time for a debuff within a specified range, considering only pets.
    -- @function debuff.spell.lowestPet
    -- @number[opt=8] range The range to check units within.
    -- @string[opt="remain"] debuffType The type of debuff check to perform (e.g., "remain").
    -- @treturn string
    debuff.lowestPet = function(range,debuffType)
        if range == nil then range = 8 end
        if debuffType == nil then debuffType = "remain" end
        return br.getDebuffMinMaxButForPetsThisTime(k, range, debuffType, "min")
    end

    --- Gets the unit with the highest remaining time for a debuff within a specified range.
    -- @function debuff.spell.max
    -- @number[opt=40] range The range to check units within.
    -- @string[opt="remain"] debuffType The type of debuff check to perform (e.g., "remain").
    -- @treturn string
    debuff.max = function(range,debuffType)
        if range == nil then range = 40 end
        if debuffType == nil then debuffType = "remain" end
        return br.getDebuffMinMax(k, range, debuffType, "max")
    end

    --- Checks if a debuff is exsanguinated.
    -- @function debuff.spell.exsang
    -- @string[opt="target"] thisUnit The unit to check the debuff on.
    -- @treturn boolean
    debuff.exsang = function(thisUnit)
            return spec == 259 and debuff.exsa[thisUnit] or false
    end

    --- Calculates the snapshot value of a debuff.
    -- @function debuff.spell.calc
    -- @treturn number
    debuff.calc = function()
        return (spec == 103 or spec == 259) and getSnapshotValue(v) or 0
    end

    --- Gets the value of the debuff when it was applied.
    -- @function debuff.spell.applied
    -- @string[opt="target"] thisUnit The unit to check the debuff applied value on.
    -- @treturn number
    debuff.applied = function(thisUnit)
        return (spec == 103 or spec == 259) and debuff.bleed[thisUnit] or 0
    end
end
