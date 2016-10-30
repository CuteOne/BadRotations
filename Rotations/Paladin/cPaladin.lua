-- Inherit from: ../cCharacter.lua
-- All Paladin specs inherit from this file
if select(2, UnitClass("player")) == "PALADIN" then
    cPaladin = {}
    -- Creates Paladin with given specialisation
    function cPaladin:new(spec)
        local self = cCharacter:new("Paladin")

        local player = "player" -- if someone forgets ""

    -----------------
    --- VARIABLES ---
    -----------------

        self.profile                    = spec
        self.holyPower                  = UnitPower("player",9)
        self.holyPowerMax               = UnitPowerMax("player",9)
        self.buff.duration              = {}       -- Buff Durations
        self.buff.remain                = {}       -- Buff Time Remaining
        self.cast                       = {}       -- Cast Spell Functions
        self.cast.debug                 = {}       -- Cast Spell Functions Debug
        self.debuff.duration            = {}       -- Debuff Durations
        self.debuff.remain              = {}       -- Debuff Time Remaining
        self.debuff.refresh             = {}       -- Debuff Refreshable
        self.spell.class                = {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      = {
            blessingOfFreedom           = 1044,
            blessingOfProtection        = 1022,
            blindingLight               = 115750,
            contemplation               = 121183,
            crusaderStrike              = 35395,
            divineShield                = 642,
            flashOfLight                = 19750,
            hammerOfJustice             = 853,
            handOfReckoning             = 62124,
            judgment                    = 20271,
            layOnHands                  = 633,
            redemption                  = 7328,
            repentance                  = 20066,
            tyrsDeliverance             = 200654,
        }
        self.spell.class.artifacts      = {        -- Artifact Traits Available To All Specs in Class
            artificialStamina           = 211309,
        }
        self.spell.class.buffs          = {        -- Buffs Available To All Specs in Class

        }
        self.spell.class.debuffs        = {        -- Debuffs Available To All Specs in Class
            judgment                    = 197277,
        }
        self.spell.class.glyphs         = {        -- Glyphs Available To All Specs in Class
            glyphOfFireFromHeavens      = 57954,
            glyphOfPillarOfLight        = 146959,
            glyphOfTheLuminousCharger   = 89401,
            glyphOfTheQueen             = 212642,
        }
        self.spell.class.talents        = {        -- Talents Available To All Specs in Class
            blindingLight               = 115750,
            repentance                  = 20066,
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
            self.getClassEnemies()
            self.getClassBuffs()
            self.getClassCharges()
            self.getClassCooldowns()
            self.getClassDebuffs()
            self.getClassToggleModes()
            self.getClassCastable()
            

            -- Update Combo Points
            self.holyPower    = UnitPower("player",9)
            self.holyPowerMax = UnitPowerMax("player",9)

            -- Update Energy Regeneration
            self.powerRegen     = getRegen("player")
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getClassDynamicUnits()
            local dynamicTarget = dynamicTarget

            self.units.dyn10 = dynamicTarget(10,true) -- Hammer of Justice
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getClassEnemies()
            local getEnemies = getEnemies

            self.enemies.yards8     = getEnemies("player", 8) -- AoE
            self.enemies.yards10    = getEnemies("player", 10) -- Hammer of Justice
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getClassArtifacts()
            local isKnown = isKnown

            for k,v in pairs(self.spell.class.artifacts) do
                self.artifact[k] = isKnown(v) or false
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
                self.charges.frac[k]= getChargesFrac(v)
                self.charges.max[k] = getChargesFrac(v,true)
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
            self.debuff["forbearance"]  = UnitDebuffID("player",25771) ~= nil
        end

    --------------
    --- GLYPHS ---
    --------------

        function self.getClassGlyphs()
            local hasGlyph = hasGlyph

        end

    ----------------
    --- TALENTS ---
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
    --- TOGGLES ---
    ---------------

        function self.getClassToggleModes()

            self.mode.rotation      = bb.data["Rotation"]
            self.mode.cooldown      = bb.data["Cooldown"]
            self.mode.defensive     = bb.data["Defensive"]
            self.mode.interrupt     = bb.data["Interrupt"]
        end

        -- Create the toggle defined within rotation files
        function self.createClassToggles()
            GarbageButtons()
            if self.rotations[bb.selectedProfile] ~= nil then
                self.rotations[bb.selectedProfile].toggles()
            else
                return
            end
        end

    ---------------
    --- OPTIONS ---
    ---------------

        -- Class options
        -- Options which every Rogue should have
        function self.createClassOptions()
            -- Class Wrap
            local section = bb.ui:createSection(bb.ui.window.profile,  "Class Options", "Nothing")
            bb.ui:checkSectionState(section)
        end

    --------------
    --- SPELLS ---
    --------------

        function self.getClassCastable()
            self.cast.debug.blessingOfFreedom       = self.cast.blessingOfFreedom("player",true)
            self.cast.debug.blessingOfProtection    = self.cast.blessingOfProtection("player",true)
            self.cast.debug.crusaderStrike          = self.cast.crusaderStrike("target",true)
            self.cast.debug.divineShield            = self.cast.divineShield("player",true)
            self.cast.debug.flashOfLight            = self.cast.flashOfLight("player",true)
            self.cast.debug.hammerOfJustice         = self.cast.hammerOfJustice("target",true)
            self.cast.debug.judgment                = self.cast.judgment("target",true)
            self.cast.debug.layOnHands              = self.cast.layOnHands("player",true)
            self.cast.debug.redemption              = self.cast.redemption("target",true)
            self.cast.debug.repentance              = self.cast.repentance("target",true)
        end

        function self.cast.blessingOfFreedom(thisUnit,debug)
            local spellCast = self.spell.blessingOfFreedom
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 52 and self.powerPercentMana > 15 and self.cd.blessingOfFreedom == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.blessingOfProtection(thisUnit,debug)
            local spellCast = self.spell.blessingOfProtection
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 52 and self.powerPercentMana > 15 and self.cd.blessingOfProtection == 0 and self.charges.blessingOfProtection > 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.crusaderStrike(thisUnit,debug)
            local spellCast = self.spell.crusaderStrike
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 1 and self.charges.crusaderStrike > 0 and getDistance(thisUnit) < 5 and not self.talent.zeal then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.divineShield(thisUnit,debug)
            local spellCast = self.spell.divineShield
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 18 and self.cd.divineShield == 0 and not self.debuff.forbearance and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.flashOfLight(thisUnit,debug)
            local spellCast = self.spell.flashOfLight
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 8 and self.powerPercent > 16 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.hammerOfJustice(thisUnit,debug)
            local spellCast = self.spell.hammerOfJustice
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn10 end
            if debug == nil then debug = false end

            if self.level >= 5 and self.powerPercent > 3.5 and self.cd.hammerOfJustice == 0 and getDistance(thisUnit) < 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.judgment(thisUnit,debug)
            local spellCast = self.spell.judgment
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.level >= 3 and self.powerPercent > 3 and self.cd.judgment == 0 and getDistance(thisUnit) < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.layOnHands(thisUnit,debug)
            local spellCast = self.spell.layOnHands
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 22 and self.cd.layOnHands == 0 and not self.debuff.forbearance and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.redemption(thisUnit,debug)
            local spellCast = self.spell.redemption
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.level >= 14 and self.powerPercentMana > 4 
                and ObjectExists(thisUnit) and UnitIsPlayer(thisUnit) and UnitIsFriend(thisUnit,"player") and UnitIsDeadOrGhost(thisUnit) and getDistance(thisUnit) < 40 
            then
                 if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false,false,true)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.repentance(thisUnit,debug)
            local spellCast = self.spell.repentance
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.talent.repentance and self.powerPercentMana > 10 and self.cd.repentance == 0 and getDistance(thisUnit) < 30 then
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
    end --End function cRogue:new(spec)
end -- End Select 