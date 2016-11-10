
function cFileBuild(cFileName,self)
    -- Make tables if not existing
    if self.artifact        == nil then self.artifact           = {} end        -- Artifact Trait Info
    if self.artifact.rank   == nil then self.artifact.rank      = {} end        -- Artifact Trait Rank
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
    self.eclipse        = UnitPower("player", 8)
    self.holyPower      = UnitPower("player", 9)
    self.altPower       = UnitPower("player",10)
    self.darkForce      = UnitPower("player",11)
    self.lightForce     = UnitPower("player",12)
    self.shadowOrbs     = UnitPower("player",13)
    self.burningEmbers  = UnitPower("player",14)
    self.demonicFury    = UnitPower("player",15)
    self.mystery        = UnitPower("player",16)
    self.energy2        = UnitPower("player",17)
    self.powerRegen     = getRegen("player")

    -- Select class/spec Spell List
    if cFileName == "class" then
        ctype = self.spell.class
    end
    if cFileName == "spec" then
        ctype = self.spell.spec
    end

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
        self.buff[k]            = UnitBuffID("player",v) ~= nil
        self.buff.duration[k]   = getBuffDuration("player",v) or 0
        self.buff.remain[k]     = getBuffRemain("player",v) or 0
        self.buff.refresh[k]    = self.buff.remain[k] <= self.buff.duration[k] * 0.3
        self.buff.stack[k]      = getBuffStacks("player",v) or 0
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
            if self.buff.bloodtalons then multiplier = multiplier*Bloodtalons end
            -- Savage Roar
            if self.buff.savageRoar then multiplier = multiplier*SavageRoar end
            -- Tigers Fury
            if self.buff.tigersFury then multiplier = multiplier*TigersFury end
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
                if self.buff.incarnationKingOfTheJungle or self.buff.prowl then
                    RakeMultiplier = 2
                end
                -- return rake
                return multiplier*RakeMultiplier
            end
        end
        return 0
    end
    for k,v in pairs(ctype.debuffs) do
        -- Build Debuff Table for all units in 40yrds
        if self.debuff[k] == nil then self.debuff[k] = {} end
        for i = 1, #self.enemies.yards40 do
            local thisUnit = self.enemies.yards40[i]
            -- Setup debuff table per unit and per debuff
            if self.debuff[k][thisUnit]         == nil then self.debuff[k][thisUnit]            = {} end
            if self.debuff[k][thisUnit].applied == nil then self.debuff[k][thisUnit].applied    = 0 end
            -- Get the Debuff Info
            if k == "judgment" and self.level < 42 then
                self.debuff[k][thisUnit].exists     = true
            else
                self.debuff[k][thisUnit].exists     = UnitDebuffID(thisUnit,v,"player") ~= nil
            end
            self.debuff[k][thisUnit].duration       = getDebuffDuration(thisUnit,v,"player") or 0
            self.debuff[k][thisUnit].remain         = getDebuffRemain(thisUnit,v,"player") or 0
            self.debuff[k][thisUnit].refresh        = self.debuff[k][thisUnit].remain <= self.debuff[k][thisUnit].duration * 0.3
            self.debuff[k][thisUnit].stack          = getDebuffStacks(thisUnit,v,"player") or 0
            self.debuff[k][thisUnit].calc           = self.getSnapshotValue(v)
        end
        -- Default "target" if no enemies present
        if self.debuff[k]["target"]         == nil then self.debuff[k]["target"]            = {} end
        if self.debuff[k]["target"].applied == nil then self.debuff[k]["target"].applied    = 0 end
        if k == "judgment" and self.level < 42 then
            self.debuff[k]["target"].exists     = true
        else
            self.debuff[k]["target"].exists     = UnitDebuffID("target",v,"player") ~= nil
        end
        self.debuff[k]["target"].duration       = getDebuffDuration("target",v,"player") or 0
        self.debuff[k]["target"].remain         = getDebuffRemain("target",v,"player") or 0
        self.debuff[k]["target"].refresh        = self.debuff[k]["target"].remain <= self.debuff[k]["target"].duration * 0.3
        self.debuff[k]["target"].stack          = getDebuffStacks("target",v,"player") or 0
        self.debuff[k]["target"].calc           = self.getSnapshotValue(v)
    end

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
            -- local spellCast = v
            -- local spellName = GetSpellInfo(v)
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
            if debug == nil then debug = false end
            if IsUsableSpell(v) and getSpellCD(v) == 0 and isKnown(v) and amIinRange then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    if thisUnit == "player" or IsHarmfulSpell(spellName) or IsHelpfulSpell(spellName) or thisUnit == nil then
                        if thisUnit == nil then thisUnit = "player" end
                        if getLineOfSight(thisUnit) then
                            return castSpell(thisUnit,spellCast,false,false,false)
                        end
                    elseif thisUnit == "ground" then
                        return castGroundAtBestLocation(spellCast,effectRng,minUnits,maxRange,minRange)
                    else
                        if getLineOfSight(thisUnit) then
                            return castGround(thisUnit,spellCast,maxRange,minRange)
                        end
                    end
                end
            elseif debug then
                return false
            end
        end
        -- Build Cast Debug
        if IsHarmfulSpell(spellName) then
            self.cast.debug[k] = self.cast[k]("target",true)
        else
            self.cast.debug[k] = self.cast[k]("player",true)
        end
    end
end