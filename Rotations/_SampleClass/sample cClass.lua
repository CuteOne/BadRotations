-- Inherit from: ../cCharacter.lua
-- All Warrior specs inherit from this file
if select(2, UnitClass("player")) == "WARRIOR" then -- Change "WARRIOR" to name of class in all caps.
    cWarrior = {} -- Change cWarrior to name of class (IE: cFire)
    -- Creates Warrior with given specialisation
    function cWarrior:new(spec) -- Change cWarrior to name of class (IE: cFire)
        local self = cCharacter:new("Warrior") -- Change "Warrior" to name of class

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
            sampleSpell                 = 00000,
        }
        self.spell.class.artifacts      = {        -- Artifact Traits Available To All Specs in Class

        }
        self.spell.class.buffs          = {        -- Buffs Available To All Specs in Class

        }
        self.spell.class.debuffs        = {        -- Debuffs Available To All Specs in Class

        }
        self.spell.class.glyphs         = {        -- Glyphs Available To All Specs in Class

        }
        self.spell.class.talents        = {        -- Talents Available To All Specs in Class

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

            -- Update Power Regeneration
            self.powerRegen  = getRegen("player")
        end

    ---------------------
    --- DYNAMIC UNITS --- -- Define dynamic targetting for specific range limits here
    ---------------------

        function self.getClassDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn15 = dynamicTarget(15,true) -- Typhoon

            -- AoE
            self.units.dyn35AoE = dynamicTarget(35, false) -- Entangling Roots
        end

    -----------------
    --- ARTIFACTS --- -- Should not need editing
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
    --- BUFFS --- -- Should not need editing
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
    --- CHARGES --- -- Should not need editing
    ---------------

        function self.getClassCharges()
            local getCharges = getCharges

            for k,v in pairs(self.spell.class.abilities) do
                self.charges[k]     = getCharges(v)
                self.recharge[k]    = getRecharge(v)
            end
        end

    -----------------
    --- COOLDOWNS --- -- Should not need editing
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
    --- DEBUFFS --- -- Should not need editing
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
    --- GLYPHS --- -- Should not need editing
    --------------

        function self.getClassGlyphs()
            local hasGlyph = hasGlyph

        end

    ----------------
    --- TAALENTS --- -- Should not need editing
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
    --- PERKS --- -- Should not need editing
    -------------

        function self.getClassPerks()
            local isKnown = isKnown

        end

    ---------------
    --- OPTIONS ---
    ---------------

        -- Class options
        -- Options which every Warrior should have
        -- Options listed here will show on every profile for this class 
        function self.createClassOptions()
            -- Class Wrap
            local section = br.ui:createSection(br.ui.window.profile,  "Class Options", "Nothing")
            br.ui:checkSectionState(section)
        end

    --------------
    --- SPELLS ---
    --------------

        function self.getClassCastable()
            self.cast.debug.sampleSpell        = self.cast.sampleSpell("target",true)
        end

        -- Sample Spell
        function self.cast.sampleSpell(thisUnit,debug)
            local spellCast = self.spell.sampleSpell
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

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------
        -- Return
        return self
    end --End function cWarrior:new(spec)
end -- End Select 