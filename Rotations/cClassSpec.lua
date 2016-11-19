
function cFileBuild(cFileName,self)
    -- Make tables if not existing
    if self.artifact        == nil then self.artifact           = {} end        -- Artifact Trait Info
    if self.artifact.rank   == nil then self.artifact.rank      = {} end        -- Artifact Trait Rank
    if self.buff.exists     == nil then self.buff.exists        = {} end        -- Buff Exists
    if self.buff.duration   == nil then self.buff.duration      = {} end        -- Buff Durations
    if self.buff.remain     == nil then self.buff.remain        = {} end        -- Buff Time Remaining
    if self.buff.refresh    == nil then self.buff.refresh       = {} end        -- Buff Refreshable
    if self.buff.stack      == nil then self.buff.stack         = {} end        -- Buff Stack Count
    if self.buff.pet        == nil then self.buff.pet           = {} end        -- Buffs on Pets
    if self.cast            == nil then self.cast               = {} end        -- Cast Spell Functions
    if self.cast.debug      == nil then self.cast.debug         = {} end        -- Cast Spell Debugging
    if self.charges.frac    == nil then self.charges.frac       = {} end        -- Charges Fractional
    if self.charges.max     == nil then self.charges.max        = {} end        -- Charges Maximum 

    -- Update Power
    self.mana           = UnitPower("player", 0)
    self.rage           = UnitPower("player", 1)
    self.focus          = UnitPower("player", 2)
    self.energy         = UnitPower("player", 3)
    self.comboPoints    = UnitPower("player", 4)
    self.runes          = UnitPower("player", 5)
    self.runicPower     = UnitPower("player", 6)
    self.soulShards     = UnitPower("player", 7)
    self.lunarPower     = UnitPower("player", 8)
    self.holyPower      = UnitPower("player", 9)
    self.altPower       = UnitPower("player",10)
    self.maelstrom      = UnitPower("player",11)
    self.chi            = UnitPower("player",12)
    self.insanity       = UnitPower("player",13)
    self.obsolete       = UnitPower("player",14)
    self.obsolete2      = UnitPower("player",15)
    self.arcaneCharges  = UnitPower("player",16)
    self.fury           = UnitPower("player",17)
    self.pain           = UnitPower("player",18)
    self.powerRegen     = getRegen("player")
    self.timeToMax      = getTimeToMax("player")


    -- Build Best Unit per Range
        -- Single
    self.units.dyn8     = dynamicTarget(8,  true)
    self.units.dyn10    = dynamicTarget(10, true)
    self.units.dyn12    = dynamicTarget(12, true)
    self.units.dyn13    = dynamicTarget(13, true)
    self.units.dyn15    = dynamicTarget(15, true)
    self.units.dyn20    = dynamicTarget(20, true)
    self.units.dyn30    = dynamicTarget(30, true)
        -- AoE
    self.units.dyn8AoE  = dynamicTarget(8,  false)
    self.units.dyn20AoE = dynamicTarget(20, false)
    self.units.dyn30AoE = dynamicTarget(30, false)
    self.units.dyn35AoE = dynamicTarget(35, false)

    -- Build Enemies Tables per Range
    self.enemies.yards5     = getEnemies("player", 5)
    self.enemies.yards8     = getEnemies("player", 8)
    self.enemies.yards8t    = getEnemies("target", 8)
    self.enemies.yards10    = getEnemies("player", 10)
    self.enemies.yards10t   = getEnemies("target", 10)
    self.enemies.yards13    = getEnemies("player", 13)
    self.enemies.yards15    = getEnemies("player", 15)
    self.enemies.yards20    = getEnemies("player", 20)
    self.enemies.yards30    = getEnemies("player", 30)
    self.enemies.yards40    = getEnemies("player", 40)

    -- Select class/spec Spell List
    if cFileName == "class" then
        ctype = self.spell.class
    end
    if cFileName == "spec" then
        ctype = self.spell.spec
    end

    if not UnitAffectingCombat("player") then
        -- Build Artifact Info
        for k,v in pairs(ctype.artifacts) do
            self.artifact[k] = hasPerk(v) or false
            self.artifact.rank[k] = getPerkRank(v) or 0
        end

        -- Build Talent Info
        for k,v in pairs(ctype.talents) do
            for r = 1, 7 do --search each talent row
                for c = 1, 3 do -- search each talent column
                    local talentID = select(6,GetTalentInfo(r,c,GetActiveSpecGroup())) -- ID of Talent at current Row and Column
                    if v == talentID then
                        self.talent[k] = getTalent(r,c)
                    end
                end
            end
        end
    end

    -- Build Buff Info
    for k,v in pairs(ctype.buffs) do
        -- Build Buff Table for all friendly units
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            -- Setup debuff table per unit and per debuff
            if thisUnit == "player" then
                self.buff.exists[k]     = UnitBuffID("player",v) ~= nil
                self.buff.duration[k]   = getBuffDuration("player",v) or 0
                self.buff.remain[k]     = getBuffRemain("player",v) or 0
                self.buff.refresh[k]    = self.buff.remain[k] <= self.buff.duration[k] * 0.3
                self.buff.stack[k]      = getBuffStacks("player",v) or 0
            else
                if self.buff[k] == nil then self.buff[k] = {} end
                if self.buff[k][thisUnit] == nil then self.buff[k][thisUnit] = {} end
                self.buff[k][thisUnit].exists     = UnitBuffID(thisUnit,v) ~= nil
                self.buff[k][thisUnit].duration   = getBuffDuration(thisUnit,v) or 0
                self.buff[k][thisUnit].remain     = getBuffRemain(thisUnit,v) or 0
                self.buff[k][thisUnit].refresh    = self.buff[k][thisUnit].remain <= self.buff[k][thisUnit].duration * 0.3
                self.buff[k][thisUnit].stack      = getBuffStacks(thisUnit,v) or 0
            end
        end
    end

    -- Build Debuff Info
    function self.getSnapshotValue(dot)
        -- Feral Bleeds
        if GetSpecializationInfo(GetSpecialization()) == 103 then
            local multiplier        = 1.00
            local Bloodtalons       = 1.30
            local SavageRoar        = 1.40
            local TigersFury        = 1.15
            local RakeMultiplier    = 1
            -- Bloodtalons
            if self.buff.exists.bloodtalons then multiplier = multiplier*Bloodtalons end
            -- Savage Roar
            if self.buff.exists.savageRoar then multiplier = multiplier*SavageRoar end
            -- Tigers Fury
            if self.buff.exists.tigersFury then multiplier = multiplier*TigersFury end
            -- rip
            if dot == ctype.debuffs.rip then
                -- -- Versatility
                -- multiplier = multiplier*(1+Versatility*0.1)
                -- return rip
                return 5*multiplier
            end
            -- rake
            if dot == ctype.debuffs.rake then
                -- Incarnation/Prowl
                if self.buff.exists.incarnationKingOfTheJungle or self.buff.exists.prowl then
                    RakeMultiplier = 2
                end
                -- return rake
                return multiplier*RakeMultiplier
            end
        end
        return 0
    end
    for k,v in pairs(ctype.debuffs) do
        -- Build Debuff Table for all enemy units
        if self.debuff[k] == nil then self.debuff[k] = {} end
        -- Setup Debuffs to "target" default
        if ObjectExists("target") then
            if self.debuff[k]["target"]         == nil then self.debuff[k]["target"]            = {} end
            if self.debuff[k]["target"].applied == nil then self.debuff[k]["target"].applied    = 0 end
            self.debuff[k]["target"].exists         = UnitDebuffID("target",v,"player") ~= nil
            self.debuff[k]["target"].duration       = getDebuffDuration("target",v,"player")
            self.debuff[k]["target"].remain         = getDebuffRemain("target",v,"player")
            self.debuff[k]["target"].refresh        = self.debuff[k]["target"].remain <= self.debuff[k]["target"].duration * 0.3
            self.debuff[k]["target"].stack          = getDebuffStacks("target",v,"player")
            self.debuff[k]["target"].calc           = self.getSnapshotValue(v)
        else
            if self.debuff[k]["target"] ~= nil then self.debuff[k]["target"] = nil end
        end
        -- Setup debuff table per valid unit and per debuff
        for i = 1, #self.enemies.yards40 do
            local thisUnit = self.enemies.yards40[i]
            if hasThreat(thisUnit) or (not hasThreat(thisUnit) and getHP(thisUnit) < 100 and UnitIsUnit(thisUnit,"target")) or isDummy(thisUnit) then
                if self.debuff[k][thisUnit]         == nil then self.debuff[k][thisUnit]            = {} end
                if self.debuff[k][thisUnit].applied == nil then self.debuff[k][thisUnit].applied    = 0 end
                self.debuff[k][thisUnit].exists         = UnitDebuffID(thisUnit,v,"player") ~= nil
                self.debuff[k][thisUnit].duration       = getDebuffDuration(thisUnit,v,"player")
                self.debuff[k][thisUnit].remain         = getDebuffRemain(thisUnit,v,"player")
                self.debuff[k][thisUnit].refresh        = self.debuff[k][thisUnit].remain <= self.debuff[k][thisUnit].duration * 0.3
                self.debuff[k][thisUnit].stack          = getDebuffStacks(thisUnit,v,"player")
                self.debuff[k][thisUnit].calc           = self.getSnapshotValue(v)
            else
               if self.debuff[k][thisUnit] ~= nil then self.debuff[k][thisUnit] = nil end 
            end
        end
    end
    -- for k,v in pairs(ctype.debuffs) do
    --     -- Build Debuff Table for all units in 40yrds
    --     if self.debuff[k] == nil then self.debuff[k] = {} end
    --     for i = 1, #self.enemies.yards40 do
    --         local thisUnit = self.enemies.yards40[i]
    --         -- Setup debuff table per unit and per debuff
    --         if self.debuff[k][thisUnit]         == nil then self.debuff[k][thisUnit]            = {} end
    --         if self.debuff[k][thisUnit].applied == nil then self.debuff[k][thisUnit].applied    = 0 end
    --         if br.tracker.query(UnitGUID(thisUnit),v) ~= false then
    --             local spell = br.tracker.query(UnitGUID(thisUnit),v)
    --             -- Get the Debuff Info
    --             self.debuff[k][thisUnit].exists         = true
    --             self.debuff[k][thisUnit].duration       = spell.duration
    --             self.debuff[k][thisUnit].remain         = spell.remain
    --             self.debuff[k][thisUnit].refresh        = spell.refresh
    --             self.debuff[k][thisUnit].stack          = spell.stacks
    --             self.debuff[k][thisUnit].calc           = self.getSnapshotValue(v)
    --             -- self.debuff[k][thisUnit].applied        = 0
    --         else
    --             -- Zero Out the Debuff Info
    --             self.debuff[k][thisUnit].exists         = false
    --             self.debuff[k][thisUnit].duration       = 0
    --             self.debuff[k][thisUnit].remain         = 0
    --             self.debuff[k][thisUnit].refresh        = true
    --             self.debuff[k][thisUnit].stack          = 0
    --             self.debuff[k][thisUnit].calc           = self.getSnapshotValue(v)
    --             self.debuff[k][thisUnit].applied        = 0
    --         end
    --     end
    -- end

    -- Cycle through Abilities List
    for k,v in pairs(ctype.abilities) do
        local spellCast = v
        local spellName = GetSpellInfo(v)

        -- Build Spell Charges
        self.charges[k]     = getCharges(v)
        self.charges.frac[k]= getChargesFrac(v)
        self.charges.max[k] = getChargesFrac(v,true)
        self.recharge[k]    = getRecharge(v)

        -- Build Spell Cooldown
        self.cd[k] = getSpellCD(v)

        -- Build Cast Funcitons
        self.cast[k] = function(thisUnit,debug,minUnits,effectRng)
            if thisUnit == nil then
                if IsHarmfulSpell(spellName) then thisUnit = "target" end
                if IsHelpfulSpell(spellName) then thisUnit = "player" end
            end
            if SpellHasRange(spellName) then
                if IsSpellInRange(spellName,thisUnit) == 0 then
                    amIinRange = false 
                else
                    amIinRange = true
                end
            else
                amIinRange = true
            end
            local minRange = select(5,GetSpellInfo(spellName))
            local maxRange = select(6,GetSpellInfo(spellName))
            if minUnits == nil then minUnits = 1 end
            if effectRng == nil then effectRng = 8 end
            if IsUsableSpell(v) and getSpellCD(v) == 0 and isKnown(v) and amIinRange then
                if debug == "debug" then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    if thisUnit == "best" then
                        return castGroundAtBestLocation(spellCast,effectRng,minUnits,maxRange,minRange,debug)
                    elseif debug == "ground" then
                        if getLineOfSight(thisUnit) then 
                           return castGround(thisUnit,spellCast,maxRange,minRange)
                        end
                    elseif debug == "dead" then
                        if thisUnit == nil then thisUnit = "player" end
                        return castSpell(thisUnit,spellCast,false,false,false,false,true)
                    else
                        if thisUnit == nil then thisUnit = "player" end
                        return castSpell(thisUnit,spellCast,false,false,false)
                    end
                end
            elseif debug == "debug" then
                return false
            end
        end
        -- Build Cast Debug
        if IsHarmfulSpell(spellName) then
            self.cast.debug[k] = self.cast[k]("target","debug")
        else
            self.cast.debug[k] = self.cast[k]("player","debug")
        end
    end
end