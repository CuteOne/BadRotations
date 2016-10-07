--- Shadow Class
-- Inherit from: ../cCharacter.lua and ../cWarrior.lua
cShadow = {}
cShadow.rotations = {}

-- Creates Shadow Warrior
function cShadow:new()
    if GetSpecializationInfo(GetSpecialization()) == 258 then
        local self = cPriest:new("Shadow")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cShadow.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
        self.charges.frac               = {}        -- Fractional Charge
        self.charges.max                = {}        -- Max Charges
        self.spell.spec                 = {} 
        self.spell.spec.abilities       = { 
            dispelMagic = 528,
            dispersion = 47585,
            fade = 586,
            levitate = 1706,
            massDispel = 32375,
            mindBender = 200174,
            mindBlast = 8092,
            mindBomb = 205369,
            mindfiend = 34433,
            mindFlay = 15407,
            mindSear = 48045,
            mindSpike = 73510,
            mindVision = 2096,
            powerInfusion = 10060,
            powerWordShield = 17,
            purifyDisease = 213634,
            resurrection = 2006,
            shackleUndead = 9484,
            shadowMend = 186263,
            shadowWordDeath = 32379,
            shadowWordPain = 589,
            shadowfiend = 34433,
            silence = 15487,
            vampiricEmbrace = 15286,
            vampiricTouch = 34914,
            voidBolt = 205448,
            voidEruption = 228260
        }
        self.spell.spec.artifacts       = {

        }
        self.spell.spec.buffs           = {
            shadowyInsight = 124430,
            voidForm = 194249 
        }
        self.spell.spec.debuffs         = {
            shadowWordPain = 589,
            vampiricTouch = 34914,
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {}
        -- Merge all spell ability tables into self.spell
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.spell.class.abilities, self.spell.spec.abilities)
        
    ------------------
    --- OOC UPDATE ---
    ------------------

        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()
            self.getArtifacts()
            self.getArtifactRanks()
            self.getGlyphs()
            self.getTalents()
            self.getPerks() --Removed in Legion
        end

    --------------
    --- UPDATE ---
    --------------

        function self.update()

            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            self.getDynamicUnits()
            self.getEnemies()
            self.getBuffs()
            self.getCharge()
            self.getCooldowns()
            self.getDebuffs()
            self.getToggleModes()
            self.getCastable()

            -- Start selected rotation
            self:startRotation()
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            self.units.dyn40 = dynamicTarget(40, true)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards40  = getEnemies("player", 40)
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getArtifacts()
            local hasPerk = hasPerk

            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact[k] = hasPerk(v) or false
            end
        end

        function self.getArtifactRanks()
            local getPerkRank = getPerkRank
            
            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact.rank[k] = getPerkRank(v) or 0
            end
        end
        
    -------------
    --- BUFFS ---
    -------------

        function self.getBuffs()
            local UnitBuffID = UnitBuffID

            for k,v in pairs(self.spell.spec.buffs) do
                self.buff[k]            = UnitBuffID("player",v) ~= nil
                self.buff.duration[k]   = getBuffDuration("player",v) or 0
                self.buff.remain[k]     = getBuffRemain("player",v) or 0
            end
        end

    ---------------
    --- CHARGES ---
    ---------------

        function self.getCharge()
            local getCharges = getCharges
            local getChargesFrac = getChargesFrac
            local getBuffStacks = getBuffStacks
            local getRecharge = getRecharge

            for k,v in pairs(self.spell.spec.abilities) do
                self.charges[k]     = getCharges(v)
                self.charges.frac[k]= getChargesFrac(v)
                self.charges.max[k] = getChargesFrac(v,true)
                self.recharge[k]    = getRecharge(v)
            end
        end

    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            for k,v in pairs(self.spell.spec.abilities) do
                if getSpellCD(v) ~= nil then
                    self.cd[k] = getSpellCD(v)
                end
            end
        end

    ---------------
    --- DEBUFFS ---
    ---------------
        function self.getDebuffs()
            local UnitDebuffID = UnitDebuffID
            local getDebuffDuration = getDebuffDuration
            local getDebuffRemain = getDebuffRemain

            for k,v in pairs(self.spell.spec.debuffs) do
                if k ~= "bleeds" then
                    self.debuff[k]          = UnitDebuffID("target",v,"player") ~= nil
                    self.debuff.duration[k] = getDebuffDuration("target",v,"player") or 0
                    self.debuff.remain[k]   = getDebuffRemain("target",v,"player") or 0
                    self.debuff.refresh[k]  = (self.debuff.remain[k] < self.debuff.duration[k] * 0.3) or self.debuff.remain[k] == 0
                end
            end
        end

        function self.getDebuffsCount()
            local UnitDebuffID = UnitDebuffID
            local vampiricTouchCount = 0
            local shadowWordPainCount = 0

            if vampiricTouchCount>0 and not inCombat then vampiricTouchCount = 0 end
            if shadowWordPainCount>0 and not inCombat then shadowWordPainCount = 0 end

            for i=1,#getEnemies("player", 40) do
                local thisUnit = getEnemies("player", 40)[i]
                if UnitDebuffID(thisUnit,self.spell.vampiricTouch,"player") then
                    vampiricTouchCount = vampiricTouchCount+1
                end
                if UnitDebuffID(thisUnit,self.spell.shadowWordPain,"player") then
                    shadowWordPainCount = shadowWordPainCount+1
                end
            end
            self.debuff.count.vampiricTouch     = vampiricTouchCount or 0
            self.debuff.count.shadowWordPain    = shadowWordPainCount or 0
        end        

    --------------
    --- GLYPHS ---
    --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

        end

    ---------------
    --- TALENTS ---
    ---------------

        function self.getTalents()
            local getTalent = getTalent

            self.talent.twistOfFate                 = getTalent(1,1)
            self.talent.fortressOfTheMind           = getTalent(1,2)
            self.talent.shadowWordVoid              = getTalent(1,3)
            self.talent.mania                       = getTalent(2,1)
            self.talent.bodyAndSoul                 = getTalent(2,2)
            self.talent.masochism                   = getTalent(2,3)
            self.talent.mindBomb                    = getTalent(3,1)
            self.talent.psychicVoices               = getTalent(3,2)
            self.talent.dominateMind                = getTalent(3,3)
            self.talent.voidLord                    = getTalent(4,1)
            self.talent.reaperOfSouls               = getTalent(4,2)
            self.talent.voidRay                     = getTalent(4,3)
            self.talent.sanlaryn                    = getTalent(5,1)
            self.talent.auspiciousSpirits           = getTalent(5,2)
            self.talent.shadowyInsight              = getTalent(5,3)
            self.talent.powerInfusion               = getTalent(6,1)
            self.talent.shadowCrash                 = getTalent(6,2)
            self.talent.mindBender                  = getTalent(6,3)
            self.talent.legacyOfTheVoid             = getTalent(7,1)
            self.talent.mindSpike                   = getTalent(7,2)
            self.talent.surrenderToMadness          = getTalent(7,3)
        end

    -------------
    --- PERKS ---
    -------------

        function self.getPerks()
            local isKnown = isKnown

        end

    ---------------
    --- TOGGLES --- -- Do Not Edit this Section
    ---------------

        function self.getToggleModes() 

            self.mode.rotation  = bb.data["Rotation"]
            self.mode.cooldown  = bb.data["Cooldown"]
            self.mode.defensive = bb.data["Defensive"]
            self.mode.interrupt = bb.data["Interrupt"]
        end

        -- Create the toggle defined within rotation files
        function self.createToggles()
            GarbageButtons()
            if self.rotations[bb.selectedProfile] ~= nil then
                self.rotations[bb.selectedProfile].toggles()
            else
                return
            end
        end

    ---------------
    --- OPTIONS --- -- Do Not Edit this Section
    ---------------
        
        -- Creates the option/profile window
        function self.createOptions()
            bb.ui.window.profile = bb.ui:createProfileWindow(self.profile)

            -- Get the names of all profiles and create rotation dropdown
            local names = {}
            for i=1,#self.rotations do
                tinsert(names, self.rotations[i].name)
            end
            bb.ui:createRotationDropdown(bb.ui.window.profile.parent, names)

            -- Create Base and Class option table
            local optionTable = {
                {
                    [1] = "Base Options",
                    [2] = self.createBaseOptions,
                },
                {
                    [1] = "Class Options",
                    [2] = self.createClassOptions,
                },
            }

            -- Get profile defined options
            local profileTable = profileTable
            if self.rotations[bb.selectedProfile] ~= nil then
                profileTable = self.rotations[bb.selectedProfile].options()
            else
                return
            end

            -- Only add profile pages if they are found
            if profileTable then
                insertTableIntoTable(optionTable, profileTable)
            end

            -- Create pages dropdown
            bb.ui:createPagesDropdown(bb.ui.window.profile, optionTable)
            bb:checkProfileWindowStatus()
        end

    --------------
    --- SPELLS ---
    --------------

        function self.getCastable()

            -- self.cast.debug.ascendance      = self.cast.ascendance("player", true)
        end


        -- Dispersion
        function self.cast.dispersion(thisUnit,debug)
            local spellCast = self.spell.dispersion
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.dispersion == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false)
                end
            elseif debug then
                return false
            end
        end

        -- Mind Bender
        function self.cast.mindBender(thisUnit,debug)
            local spellCast = self.spell.mindBender
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.mindBender == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,true)
                end
            elseif debug then
                return false
            end
        end

        -- Mind Blast
        function self.cast.mindBlast(thisUnit,debug)
            local spellCast = self.spell.mindBlast
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.mindBlast == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,true)
                end
            elseif debug then
                return false
            end
        end

        -- Mindfiend
        function self.cast.mindfiend(thisUnit,debug)
            local spellCast = self.spell.mindfiend
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.mindfiend == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,true)
                end
            elseif debug then
                return false
            end
        end

        -- Mind Flay
        function self.cast.mindFlay(thisUnit,debug)
            local spellCast = self.spell.mindFlay
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.mindFlay == 0 and not UnitChannelInfo("player") then
                if debug then
                    return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,true)
                end
            elseif debug then
                return false
            end
        end
        
        -- Mind Shear
        function self.cast.mindSear(thisUnit,debug)
            local spellCast = self.spell.mindSear
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.mindSear == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,true,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,true)
                end
            elseif debug then
                return false
            end
        end

        -- Mind Spike
        function self.cast.mindSpike(thisUnit,debug)
            local spellCast = self.spell.mindSpike
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.mindSpike == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,true)
                end
            elseif debug then
                return false
            end
        end

        -- Shadow Word: Death
        function self.cast.shadowWordDeath(thisUnit,debug)
            local spellCast = self.spell.shadowWordDeath
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.shadowWordDeath == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false)
                end
            elseif debug then
                return false
            end
        end

        -- Shadow Word: Pain
        function self.cast.shadowWordPain(thisUnit,debug)
            local spellCast = self.spell.shadowWordPain
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.shadowWordPain == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false)
                end
            elseif debug then
                return false
            end
        end

         -- Shadowfiend
        function self.cast.shadowfiend(thisUnit,debug)
            local spellCast = self.spell.shadowfiend
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.shadowfiend == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false)
                end
            elseif debug then
                return false
            end
        end

        -- Silence
        function self.cast.silence(thisUnit,debug)
            local spellCast = self.spell.silence
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.silence == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false)
                end
            elseif debug then
                return false
            end
        end

        -- Vampiric Embrace
        function self.cast.vampiricEmbrace(thisUnit,debug)
            local spellCast = self.spell.vampiricEmbrace
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.vampiricEmbrace == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false)
                end
            elseif debug then
                return false
            end
        end

        -- vampiricTouch
        function self.cast.vampiricTouch(thisUnit,debug)
            local spellCast = self.spell.vampiricTouch
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.vampiricTouch == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,true,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,true)
                end
            elseif debug then
                return false
            end
        end

        -- voidEruption
        function self.cast.voidEruption(thisUnit,debug)
            local spellCast = self.spell.voidEruption
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.voidEruption == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,true)
                end
            elseif debug then
                return false
            end
        end

        -- voidBolt
        function self.cast.voidBolt(thisUnit,debug)
            local spellCast = self.spell.voidEruption
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.voidBolt == 0 then
                if debug then
                    return castSpellMacro(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpellMacro(thisUnit,spellCast,false,false)
                end
            elseif debug then
                return false
            end
        end






    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------
        --Target HP
        function thp(unit)
            return getHP(unit)
        end

        --Target Time to Die
        function ttd(unit)
            return getTimeToDie(unit)
        end

        --Target Distance
        function tarDist(unit)
            return getDistance(unit)
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cProtection
end-- select Warrior