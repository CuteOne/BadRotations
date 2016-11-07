
function cFileBuild(cFileName,self)
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
    if self.debuff.duration == nil then self.debuff.duration    = {} end        -- Debuff Durations
    if self.debuff.remain   == nil then self.debuff.remain      = {} end        -- Debuff Time Remaining
    if self.debuff.refresh  == nil then self.debuff.refresh     = {} end        -- Debuff Refreshable
    if self.debuff.stack    == nil then self.debuff.stack       = {} end        -- Debuff Stacks
    self.shards = getPowerAlt("player") 

    -- Select class/spec Spell List
    if cFileName == "class" then
        ctype = self.spell.class
    end
    if cFileName == "spec" then
        ctype = self.spell.spec
    end

    -- Build Best Unit per Range
    self.units.dyn8     = dynamicTarget(8, true)
    self.units.dyn10    = dynamicTarget(10, true)
    self.units.dyn15    = dynamicTarget(15, true)
    self.units.dyn20    = dynamicTarget(20, false)
    self.units.dyn8AoE  = dynamicTarget(8, false)

    -- Build Enemies Tables per Range
    self.enemies.yards5     = getEnemies("player", 5)
    self.enemies.yards8     = getEnemies("player", 8)
    self.enemies.yards10    = getEnemies("target", 10)
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
    for k,v in pairs(ctype.debuffs) do
        if k ~= "bleeds" then
            self.debuff[k]          = UnitDebuffID("target",v,"player") ~= nil
            self.debuff.duration[k] = getDebuffDuration("target",v,"player") or 0
            self.debuff.remain[k]   = getDebuffRemain("target",v,"player") or 0
            self.debuff.refresh[k]  = self.debuff.remain[k] <= self.debuff.duration[k] * 0.3
            self.debuff.stack[k]    = getDebuffStacks("target",v,"player") or 0
        end
    end

    -- -- Build Cast Debug
    -- for k,v in pairs(self.spell[ctype].abilities) do
    --     local spellCast = v
    --     local spellName = GetSpellInfo(v)
    --     if IsHarmfulSpell(spellName) then
    --         self.cast.debug[k] = self.cast[k]("target",true)
    --     else
    --         self.cast.debug[k] = self.cast[k]("player",true)
    --     end
    -- end
    for k,v in pairs(ctype.abilities) do
        local spellCast = v
        local spellName = GetSpellInfo(v)

        -- Build Spell Charges
        self.charges[k]     = getCharges(v)
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