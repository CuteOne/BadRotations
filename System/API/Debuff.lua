if br.api == nil then br.api = {} end
-- debuff is the table located at br.player.debuff
-- v is the spellID passed from the builder which cycles all the collected debuff spells from the spell list for the spec
-- spell in the examples represent the name in the debuffs list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
--Local function needed to facilitate debuff.calc
local function getSnapshotValue(dot)
    local self = br.player
    -- Feral Bleeds
    if GetSpecializationInfo(GetSpecialization()) == 103 then
        local multiplier        = 1.00
        local Bloodtalons       = 1.30
        -- local SavageRoar        = 1.40
        local TigersFury        = 1.15
        local RakeMultiplier    = 1
        -- Bloodtalons
        if self.buff.bloodtalons.exists() then multiplier = multiplier*Bloodtalons end
        -- Savage Roar
        -- if self.buff.savageRoar.exists() then multiplier = multiplier*SavageRoar end
        -- Tigers Fury
        if self.buff.tigersFury.exists() then multiplier = multiplier*TigersFury end
        -- rip
        if dot == self.spell.debuffs.rip then
            -- -- Versatility
            -- multiplier = multiplier*(1+Versatility*0.1)
            -- return rip
            return 5*multiplier
        end
        -- rake
        if dot == self.spell.debuffs.rake then
            -- Incarnation/Prowl/Sudden Ambush
            if self.buff.incarnationKingOfTheJungle.exists() or self.buff.prowl.exists() or self.buff.shadowmeld.exists() or self.buff.suddenAmbush.exists() then
                RakeMultiplier = 2
            end
            -- return rake
            return multiplier*RakeMultiplier
        end

    end
    -- Assassination Bleeds
    if GetSpecializationInfo(GetSpecialization()) == 259 then
        local multiplier = 1
        if self.buff.stealth.exists() and self.talent.nightstalker and (dot == self.spell.debuffs.rupture or dot == self.spell.debuffs.garrote) then multiplier = 1.5 end
        if (self.buff.stealth.exists() or self.buff.vanish.exists() 
            or (self.buff.subterfuge.exists() and self.buff.subterfuge.remain() >= 0.1 and self.buff.subterfuge.remain() >= getSpellCD(61304))) 
            and dot == self.spell.debuffs.garrote and self.talent.subterfuge 
        then 
            multiplier = 1.8 
        end
        return multiplier
    end
    return 0
end

br.api.debuffs = function(debuff,k,v)
    local spec = GetSpecializationInfo(GetSpecialization()) 
    debuff.exists = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return UnitDebuffID(thisUnit,v,sourceUnit) ~= nil
    end
    debuff.duration = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return getDebuffDuration(thisUnit,v,sourceUnit) or 0
    end
    debuff.remain = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return math.abs(getDebuffRemain(thisUnit,v,sourceUnit))
    end
    debuff.remains = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return math.abs(getDebuffRemain(thisUnit,v,sourceUnit))
    end
    debuff.stack = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if getDebuffStacks(thisUnit,v,sourceUnit) == 0 and UnitDebuffID(thisUnit,v,sourceUnit) ~= nil then
            return 1
        else
            return getDebuffStacks(thisUnit,v,sourceUnit)
        end
    end
    debuff.pandemic = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        if thisUnit == 'target' then thisUnit = GetObjectWithGUID(UnitGUID("target")) end 
        local pandemic = debuff.duration(thisUnit,sourceUnit)
        if br.player.pandemic[thisUnit] ~= nil and br.player.pandemic[thisUnit][k] ~= nil then 
            pandemic = br.player.pandemic[thisUnit][k] 
        end
        return pandemic
    end
    debuff.refresh = function(thisUnit,sourceUnit)
        if thisUnit == nil then thisUnit = 'target' end
        if sourceUnit == nil then sourceUnit = 'player' end
        return debuff.remain(thisUnit,sourceUnit) <= debuff.pandemic(thisUnit,sourceUnit) * 0.3
    end
    debuff.count = function()
        return tonumber(getDebuffCount(v))
    end
    debuff.remainCount = function(remain)
        return tonumber(getDebuffRemainCount(v,remain))
    end
    debuff.lowest = function(range,debuffType,source)
        if range == nil then range = 40 end
        if debuffType == nil then debuffType = "remain" end
        return getDebuffMinMax(k, range, debuffType, "min", source)
    end
    debuff.lowestPet = function(range,debuffType)
        if range == nil then range = 8 end
        if debuffType == nil then debuffType = "remain" end
        return getDebuffMinMaxButForPetsThisTime(k, range, debuffType, "min")
    end
    debuff.max = function(range,debuffType)
        if range == nil then range = 40 end
        if debuffType == nil then debuffType = "remain" end
        return getDebuffMinMax(k, range, debuffType, "max")
    end
    debuff.exsang = function(thisUnit)
            return spec == 259 and debuff.exsa[thisUnit] or false
    end
    debuff.calc = function()
        return (spec == 103 or spec == 259) and getSnapshotValue(v) or 0
    end
    debuff.applied = function(thisUnit)
        return (spec == 103 or spec == 259) and debuff.bleed[thisUnit] or 0
    end
end