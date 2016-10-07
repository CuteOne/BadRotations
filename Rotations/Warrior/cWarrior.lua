-- Inherit from: ../cCharacter.lua
-- All Warrior specs inherit from this file
if select(2, UnitClass("player")) == "WARRIOR" then
    cWarrior = {}
    -- Creates Warrior with given specialisation
    function cWarrior:new(spec)
        local self = cCharacter:new("Warrior")

        local player = "player" -- if someone forgets ""

    -----------------
    --- VARIABLES ---
    -----------------

        self.profile         = spec
        self.artifact        = {}
        self.artifact.rank   = {}
        self.buff.duration   = {}       -- Buff Durations
        self.buff.remain     = {}       -- Buff Time Remaining
        self.cast            = {}        -- Cast Spell Functions
        self.cast.debug      = {}
        self.debuff.duration = {}       -- Debuff Durations
        self.debuff.remain   = {}       -- Debuff Time Remaining
        self.debuff.refresh             = {}       -- Debuff Refreshable
        self.spell.class                = {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      = {
            avatar                      = 107574,
            battleCry                   = 1719,
            berserkerRage               = 18499,
            charge                      = 100,
            giftOfTheNaaru              = 28880,
            heroicLeap                  = 6544,
            heroicThrow                 = 57755,
            pummel                      = 6552,
            shockwave                   = 46968,
            stormBolt                   = 107570,
        }
        self.spell.class.artifacts      = {        -- Artifact Traits Available To All Specs in Class
            artificialStamina           = 211309,
        }
        self.spell.class.buffs          = {        -- Buffs Available To All Specs in Class
            avatar                      = 107574,
            battleCry                   = 1719,
            berserkerRage               = 18499,
        }
        self.spell.class.debuffs        = {        -- Debuffs Available To All Specs in Class

        }
        self.spell.class.glyphs         = {        -- Glyphs Available To All Specs in Class

        }
        self.spell.class.talents        = {        -- Talents Available To All Specs in Class
            avatar                      = 107574,
            shockwave                   = 46968,
        }

    ------------------
    --- OOC UPDATE ---
    ------------------

        function self.classUpdateOOC()
            -- Call baseUpdateOOC()
            self.baseUpdateOOC()
            self.getClassArtifacts()
            self.getClassArtifactRanks()
            self.getClassGlyphs()
            self.getClassTalents()
            self.getClassPerks()
        end

    --------------
    --- UPDATE ---
    --------------

        function self.classUpdate()
            -- Call baseUpdate()
            self.baseUpdate()
            self.getClassDynamicUnits()
            self.getClassBuffs()
            self.getClassCharges()
            self.getClassCooldowns()
            self.getClassDebuffs()
            self.getClassCastable()

            -- Update Energy Regeneration
            self.powerRegen  = getRegen("player")
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getClassDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dny10 = dynamicTarget(10, true) -- Shockwave
            self.units.dyn15 = dynamicTarget(15,true)

            -- AoE
            self.units.dyn35AoE = dynamicTarget(35, false)
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getClassArtifacts()
            local isKnown = isKnown

            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact[k] = hasPerk(v) or false
            end
        end

        function self.getClassArtifactRanks()

        end

    -------------
    --- BUFFS ---
    -------------
    
        function self.getClassBuffs()
            local UnitBuffID = UnitBuffID
            local getBuffDuration = getBuffDuration
            local getBuffRemain = getBuffRemain

            for k,v in pairs(self.spell.class.buffs) do
                self.buff[k]            = UnitBuffID("player",v) ~= nil
                self.buff.duration[k]   = getBuffDuration("player",v) or 0
                self.buff.remain[k]     = getBuffRemain("player",v) or 0
            end
        end

    ---------------
    --- CHARGES ---
    ---------------

        function self.getClassCharges()
            local getCharges = getCharges

            for k,v in pairs(self.spell.class.abilities) do
                self.charges[k]     = getCharges(v)
                self.recharge[k]    = getRecharge(v)
            end
        end

    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getClassCooldowns()
            local getSpellCD = getSpellCD

            for k,v in pairs(self.spell.class.abilities) do
                if getSpellCD(v) ~= nil then
                    self.cd[k] = getSpellCD(v)
                end
            end
        end

    ---------------
    --- DEBUFFS ---
    ---------------

        function self.getClassDebuffs()
            local UnitDebuffID = UnitDebuffID
            local getDebuffDuration = getDebuffDuration
            local getDebuffRemain = getDebuffRemain

            for k,v in pairs(self.spell.class.debuffs) do
                self.debuff[k]          = UnitDebuffID(self.units.dyn5,v,"player") ~= nil
                self.debuff.duration[k] = getDebuffDuration(self.units.dyn5,v,"player") or 0
                self.debuff.remain[k]   = getDebuffRemain(self.units.dyn5,v,"player") or 0
            end
        end

    --------------
    --- GLYPHS ---
    --------------

        function self.getClassGlyphs()
            local hasGlyph = hasGlyph

        end

    ----------------
    --- TAALENTS ---
    ----------------

        function self.getClassTalents()
            local getTalent = getTalent

            for r = 1, 7 do --search each talent row
                for c = 1, 3 do -- search each talent column
                    local talentID = select(6,GetTalentInfo(r,c,GetActiveSpecGroup())) -- ID of Talent at current Row and Column
                    for k,v in pairs(self.spell.class.talents) do
                        if v == talentID then
                            self.talent[k] = getTalent(r,c)
                        end
                    end
                end
            end
        end
            
    -------------
    --- PERKS ---
    -------------

        function self.getClassPerks()
            local isKnown = isKnown

        end

    ---------------
    --- OPTIONS ---
    ---------------

        -- Class options
        -- Options which every Warrior should have
        function self.createClassOptions()
            -- Class Wrap
            local section = bb.ui:createSection(bb.ui.window.profile,  "Class Options", "Nothing")
            bb.ui:checkSectionState(section)
        end

    --------------
    --- SPELLS ---
    --------------

        function self.getClassCastable()
            self.cast.debug.avatar        = self.cast.avatar("player",true)
            self.cast.debug.battleCry     = self.cast.battleCry("player",true)
            self.cast.debug.berserkerRage = self.cast.berserkerRage("player",true)
            self.cast.debug.charge        = self.cast.charge("target",true)
            self.cast.debug.giftOfTheNaaru= self.cast.giftOfTheNaaru("player",true)
            self.cast.debug.heroicLeap    = self.cast.heroicLeap("player",true)
            self.cast.debug.heroicThrow   = self.cast.heroicThrow("target",true)
            self.cast.debug.pummel        = self.cast.pummel("target",true)
            self.cast.debug.shockwave     = self.cast.shockwave("target",true)
            self.cast.debug.stormBolt     = self.cast.stormBolt("target",true)
        end

        -- Avatar
        function self.cast.avatar(thisUnit,debug)
            local spellCast = self.spell.avatar
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.avatar and self.cd.avatar == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Battle Cry
        function self.cast.battleCry(thisUnit,debug)
            local spellCast = self.spell.battleCry
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 60 and self.cd.battleCry == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Berserker Rage
        function self.cast.berserkerRage(thisUnit,debug)
            local spellCast = self.spell.berserkerRage
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 40 and self.cd.berserkerRage == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Charge
        function self.cast.charge(thisUnit,debug)
            local spellCast = self.spell.charge
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn25 end
            if debug == nil then debug = false end

            if self.level >= 3 and self.cd.charge == 0 and self.charges.charge > 0 and getDistance(thisUnit) >= 8 and getDistance(thisUnit) < 25 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Gift of the Naaru
        function self.cast.giftOfTheNaaru(thisUnit,debug)
            local spellCast = self.spell.giftOfTheNaaru
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 1 and self.cd.giftOfTheNaaru == 0 and self.race == "Draenei" then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Heroic Leap
        function self.cast.heroicLeap(thisUnit,debug)
            local spellCast = self.spell.heroicLeap
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 26 and self.cd.heroicLeap == 0 and self.charges.heroicLeap > 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    if thisUnit == "target" then
                        return castGround("target",spellCast,40,8)
                    else
                        return castGround(thisUnit,spellCast,40,8)
                    end
                end
            elseif debug then
                return false
            end
        end
        -- Heroic Throw
        function self.cast.heroicThrow(thisUnit,debug)
            local spellCast = self.spell.heroicThrow
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.level >= 22 and self.cd.heroicThrow == 0 and getDistance(thisUnit) >= 8 and getDistance(thisUnit) < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Pummel
        function self.cast.pummel(thisUnit,debug)
            local spellCast = self.spell.pummel
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 24 and self.cd.pummel == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Shockwave
        function self.cast.shockwave(thisUnit,debug)
            local spellCast = self.spell.shockwave
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn10 end
            if debug == nil then debug = false end

            if self.talent.shockwave and self.cd.shockwave == 0 and getDistance(thisUnit) < 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Storm Bolt
        function self.cast.stormBolt(thisUnit,debug)
            local spellCast = self.spell.stormBolt
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn20 end
            if debug == nil then debug = false end

            if self.talent.stormBolt and self.cd.stormBolt == 0 and getDistance(thisUnit) < 20 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

        function useAoE()
            local rotation = self.mode.rotation
            if (rotation == 1 and #getEnemies("player",8) >= 3) or rotation == 2 then
                return true
            else
                return false
            end
        end

        function useCDs()
            local cooldown = self.mode.cooldown
            if (cooldown == 1 and isBoss()) or cooldown == 2 then
                return true
            else
                return false
            end
        end

        function useDefensive()
            if self.mode.defensive == 1 then
                return true
            else
                return false
            end
        end

        function useInterrupts()
            if self.mode.interrupt == 1 then
                return true
            else
                return false
            end
        end

        function useMover()
            if self.mode.mover == 1 then
                return true
            else
                return false
            end
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------
        -- Return
        return self
    end --End function cWarrior:new(spec)
end -- End Select 