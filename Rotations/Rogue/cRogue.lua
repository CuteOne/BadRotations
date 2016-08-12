-- Inherit from: ../cCharacter.lua
-- All Rogue specs inherit from this file
if select(2, UnitClass("player")) == "ROGUE" then
    cRogue = {}
    -- Creates Rogue with given specialisation
    function cRogue:new(spec)
        local self = cCharacter:new("Rogue")

        local player = "player" -- if someone forgets ""

    -----------------
    --- VARIABLES ---
    -----------------

        self.profile         = spec
        self.comboPoints     = UnitPower("player",4)
        self.comboPointMax   = UnitPowerMax("player",4) 
        self.stealth         = false
        self.artifact        = {}
        self.artifact.perks  = {}
        self.buff.duration   = {}       -- Buff Durations
        self.buff.remain     = {}       -- Buff Time Remaining
        self.castable        = {}        -- Cast Spell Functions
        self.debuff.duration = {}       -- Debuff Durations
        self.debuff.remain   = {}       -- Debuff Time Remaining
        self.debuff.refresh  = {}       -- Debuff Refreshable
        self.rogueAbilities  = {        -- Abilities Available To All Rogues
            cloakOfShadows              = 31224,
            crimsonVial                 = 185311,
            feint                       = 1966,
            goremawsBite                = 209783, --809784
            kick                        = 1766,
            kingsbane                   = 192760, --222062
            shadowmeld                  = 58984,
            tricksOfTheTrade            = 57934,
        }
        self.rogueArtifacts  = {        -- Artifact Traits Available To All Rogues
            artificialStamina           = 211309,
        }
        self.rogueBuffs      = {        -- Buffs Available To All Rogues
            shadowmeldBuff              = 58984,
            stealthBuff                 = 1784,
        }
        self.rogueDebuffs    = {        -- Debuffs Available To All Rogues
            sapDebuff                   = 6770,
        }
        self.rogueGlyphs     = {        -- Glyphs Available To All Rogues
            glyphOfBlackout             = 219693,
            glyphOfBurnout              = 220279,
            glyphOfDisguise             = 63268,
            glyphOfFlashBang            = 219678,
        }
        self.rogueSpecials   = {        -- Specializations Available To All Rogues
            cheapShot                   = 1833,
            distract                    = 1725,
            pickLock                    = 1804,
            pickPocket                  = 921,
            sap                         = 6770,
            stealth                     = 1784,
            vanish                      = 1856,
        }
        self.rogueTalents    = {        -- Talents Available To All Rogues
            alacrity                    = 193539,
            anticipation                = 114015,
            cheatDeath                  = 31230,
            deathFromAbove              = 152150,
            deeperStratagem             = 193531,
            elusiveness                 = 79008,
            markedForDeath              = 137619,
            preyOnTheWeak               = 131511,
            vigor                       = 14983,
        }
        -- Merge all spell tables into self.rogueSpell
        self.rogueSpell = {} 
        self.rogueSpell = mergeTables(self.rogueSpell,self.rogueAbilities)
        self.rogueSpell = mergeTables(self.rogueSpell,self.rogueArtifacts)
        self.rogueSpell = mergeTables(self.rogueSpell,self.rogueBuffs)
        self.rogueSpell = mergeTables(self.rogueSpell,self.rogueDebuffs)
        self.rogueSpell = mergeTables(self.rogueSpell,self.rogueGlyphs)
        self.rogueSpell = mergeTables(self.rogueSpell,self.rogueSpecials)
        self.rogueSpell = mergeTables(self.rogueSpell,self.rogueTalents) 

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
            self.getClassBuffsRemain()
            self.getClassBuffsDuration()
            self.getClassCastable()
            self.getClassCharges()
            self.getClassCooldowns()
            self.getClassDebuffs()
            self.getClassDebuffsRemain()
            self.getClassDebuffsDuration()
            self.getClassToggleModes()
            

            -- Update Combo Points
            self.comboPoints = UnitPower("player",4)
            self.comboPointsMax = UnitPowerMax("player",4)

            -- Update Energy Regeneration
            self.powerRegen  = getRegen("player")
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getClassDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn10 = dynamicTarget(10,true) -- Sap

            -- AoE
            self.units.dyn35AoE = dynamicTarget(35, false) -- Entangling Roots
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getClassArtifacts()
            local isKnown = isKnown

            -- self.artifact.artificialStamina = isKnown(self.spell.artificialStamina)
        end

        function self.getClassArtifactRanks()

        end

    -------------
    --- BUFFS ---
    -------------
    
        function self.getClassBuffs()
            local UnitBuffID = UnitBuffID

            self.buff.shadowmeld    = UnitBuffID("player",self.spell.shadowmeldBuff) ~= nil or false
            self.buff.stealth       = UnitBuffID("player",self.spell.stealthBuff) ~= nil or false
        end

        function self.getClassBuffsDuration()
            local getBuffDuration = getBuffDuration

            -- self.buff.duration.stealth = getBuffDuration("player",self.spell.stealth) or 0
        end

        function self.getClassBuffsRemain()
            local getBuffRemain = getBuffRemain

            -- self.buff.remain.dash                   = getBuffRemain("player",self.spell.dash) or 0
        end

    ---------------
    --- CHARGES ---
    ---------------
        function self.getClassCharges()
            local getCharges = getCharges

            -- self.charges.survivalInstincts = getCharges(self.spell.survivalInstincts)
        end

    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getClassCooldowns()
            local getSpellCD = getSpellCD

            self.cd.crimsonVial = getSpellCD(self.spell.crimsonVial)
            self.cd.kick        = getSpellCD(self.spell.kick)
            self.cd.pickPocket  = getSpellCD(self.spell.pickPocket)
            self.cd.shadowmeld  = getSpellCD(self.spell.shadowmeld) 
            self.cd.stealth     = getSpellCD(self.spell.stealth)
        end

    ---------------
    --- DEBUFFS ---
    ---------------

        function self.getClassDebuffs()
            local UnitDebuffID = UnitDebuffID

            self.debuff.sap = UnitDebuffID(self.units.dyn10,self.spell.sapDebuff,"player") ~= nil or false
        end

        function self.getClassDebuffsDuration()
            local getDebuffDuration = getDebuffDuration

            self.debuff.duration.sap = getDebuffRemain(self.units.dyn10,self.spell.sapDebuff,"player") or 0
        end

        function self.getClassDebuffsRemain()
            local getDebuffRemain = getDebuffRemain

            self.debuff.remain.sap = getDebuffRemain(self.units.dyn10,self.spell.sapDebuff,"player") or 0
        end

    --------------
    --- GLYPHS ---
    --------------

        function self.getClassGlyphs()
            local hasGlyph = hasGlyph

            -- self.glyph.cheetah           = hasGlyph(self.spell.glyphOfTheCheetah)
        end

    ----------------
    --- TAALENTS ---
    ----------------

        function self.getClassTalents()
            local getTalent = getTalent

            self.talent.deeperStratagem = getTalent(3,1)
            self.talent.anticipation    = getTalent(3,2)
            self.talent.vigor           = getTalent(3,3)
            self.talent.elusiveness     = getTalent(4,2)
            self.talent.cheatDeath      = getTalent(4,3)
            self.talent.preyOnTheWeak   = getTalent(5,2)
            self.talent.alacrity        = getTalent(6,2)
            self.talent.markedForDeath  = getTalent(7,2)
            self.talent.deathFromAbove  = getTalent(7,3)
        end
            
    -------------
    --- PERKS ---
    -------------

        function self.getClassPerks()
            local isKnown = isKnown

            -- self.perk.enhancedRebirth = isKnown(self.spell.enhancedRebirth)
        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getClassToggleModes()

            self.mode.rotation      = bb.data["Rotation"]
            self.mode.cooldown      = bb.data["Cooldown"]
            self.mode.defensive     = bb.data["Defensive"]
            self.mode.interrupt     = bb.data["Interrupt"]
            self.mode.pickPocket    = bb.data["Picker"]
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

        end

        function self.castCrimsonVial(thisUnit,debug)
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end
            local spellCast = self.spell.crimsonVial

            if self.level >= 14 and self.power > 30 and self.cd.crimsonVial == 0 then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    if castSpell("player",spellCast,false,false,false) then return end
                end
            end
        end
        function self.castKick(thisUnit,debug)
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end
            local spellCast = self.spell.kick

            if self.level >= 18 and self.cd.kick == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    if castSpell(thisUnit,spellCast,false,false,false) then return end
                end
            end
        end
        function self.castPickPocket(thisUnit,debug)
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end
            local spellCast = self.spell.pickPocket

            if self.level >= 16 and self.cd.pickPocket == 0 and self.buff.stealth and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    if castSpell(thisUnit,spellCast,false,false,false) then return end
                end
            end
        end
        function self.castSap(thisUnit,debug)
            if thisUnit == nil then thisUnit = self.units.dyn10 end
            if debug == nil then debug = false end
            local spellCast = self.spell.sap

            if self.level >= 12 and self.power > 30 and self.buff.stealth and getDistance(thisUnit) < 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    if castSpell(thisUnit,spellCast,false,false,false) then return end
                end
            end
        end
        function self.castShadowmeld(thisUnit,debug)
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end
            local spellCast = self.spell.shadowmeld

            if self.level >= 1 and self.cd.shadowmeld == 0 and not isMoving("player") then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    if castSpell("player",spellCast,false,false,false) then return end
                end
            end
        end
        function self.castStealth(thisUnit,debug)
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end
            local spellCast = self.spell.stealth

            if self.level >= 5 and self.cd.stealth == 0 and not self.buff.stealth then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    if castSpell("player",spellCast,false,false,false) then return end
                end
            end
        end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------
        function useCDs()
            local cooldown = self.mode.cooldown
            if (cooldown == 1 and isBoss()) or cooldown == 2 then
                return true
            else
                return false
            end
        end

        function useAoE()
            local rotation = self.mode.rotation
            if (rotation == 1 and #getEnemies("player",8) >= 3) or rotation == 2 then
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

        function usePickPocket()
            if self.mode.pickPocket == 1 or self.mode.pickPocket == 2 then
                return true
            else
                return false
            end
        end

        function isPicked(thisUnit)   --  Pick Pocket Testing
            if thisUnit == nil then thisUnit = "target" end
            if GetObjectExists(thisUnit) then
                if myTarget ~= UnitGUID(thisUnit) then
                    canPickpocket = true
                    myTarget = UnitGUID(thisUnit)
                end
            end
            if (canPickpocket == false or self.mode.pickPocket == 3 or GetNumLootItems()>0) then
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