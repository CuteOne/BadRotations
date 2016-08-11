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
            tricksOfTheTrade            = 57934,

        }
        self.rogueArtifacts  = {        -- Artifact Traits Available To All Rogues
            artificialStamina           = 211309,
        }
        self.rogueBuffs      = {        -- Buffs Available To All Rogues
            stealthBuff                 = 1784,
        }
        self.rogueDebuffs    = {        -- Debuffs Available To All Rogues

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
            self.getClassCharges()
            self.getClassCooldowns()
            self.getClassDebuffs()
            self.getClassDebuffsRemain()
            self.getClassDebuffsDuration()
            self.getClassCastable()

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
            self.units.dyn15 = dynamicTarget(15,true) -- Typhoon

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

            self.buff.stealth = UnitBuffID("player",self.spell.stealthBuff) ~= nil or false
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

            self.cd.stealth = getSpellCD(self.spell.stealth)
        end

    ---------------
    --- DEBUFFS ---
    ---------------

        function self.getClassDebuffs()
            local UnitDebuffID = UnitDebuffID

            -- self.debuff.entanglingRoots     = UnitDebuffID(self.units.dyn35AoE,self.spell.entanglingRootsDebuff,"player")~=nil or false
        end

        function self.getClassDebuffsDuration()
            local getDebuffDuration = getDebuffDuration

            -- self.debuff.duration.entanglingRoots    = getDebuffRemain(self.units.dyn35AoE,self.spell.entanglingRootsDebuff,"player") or 0
        end

        function self.getClassDebuffsRemain()
            local getDebuffRemain = getDebuffRemain

            -- self.debuff.remain.entanglingRoots          = getDebuffRemain(self.units.dyn35AoE,self.spell.entanglingRootsDebuff,"player") or 0
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

            -- self.talent.displacerBeast      = getTalent(2,2)
        end
            
    -------------
    --- PERKS ---
    -------------

        function self.getClassPerks()
            local isKnown = isKnown

            -- self.perk.enhancedRebirth = isKnown(self.spell.enhancedRebirth)
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

        function self.castStealth(debug)
            if debug == nil then debug = false end

            if self.level > 4 and self.cd.stealth == 0 and not self.buff.stealth then
                if debug then
                    return castSpell("player",self.spell.stealth,false,false,false,false,false,false,false,true)
                else
                    if castSpell("player",self.spell.stealth,false,false,false) then return end
                end
            end
        end


        -- Return
        return self
    end --End function cRogue:new(spec)
end -- End Select 