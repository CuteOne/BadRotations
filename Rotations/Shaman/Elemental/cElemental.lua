--- Elemental Class
-- Inherit from: ../cCharacter.lua and ../cShaman.lua
cElemental = {}
cElemental.rotations = {}

-- Creates Elemental Shaman
function cElemental:new()
    if GetSpecializationInfo(GetSpecialization()) == 262 then
        local self = cShaman:new("Elemental")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cElemental.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------

        self.charges.frac               = {}        -- Fractional Charge
        self.charges.max                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            ascendance                  = 114050,
            chainLightning              = 188443,
            earthElemental              = 198103,
            earthquakeTotem             = 61882,
            earthShock                  = 8042,
            elementalBlast              = 117014,
            elementalMastery            = 16166,
            fireElemental               = 198067,
            flameShock                  = 188389,
            frostShock                  = 196840,
            healingSurge                = 8004,
            icefury                     = 210714,
            lavaBeam                    = 114074,
            lavaBurst                   = 51505,
            lightningBolt               = 188196,
            liquidMagmaTotem            = 192222,
            stormElemental              = 192249,
            stormkeeper                 = 205495,
            thunderstorm                = 51490,
            totemMastery                = 210643,
        }
        self.spell.spec.artifacts       = {
            stormkeeper                 = 205495,
        }
        self.spell.spec.buffs           = {
            ascendance                  = 114050,
            bloodlust                   = 2825,
            elementalMastery            = 16166,
            emberTotem                  = 210657,
            heroism                     = 32182,
            icefury                     = 210714,
            lavaSurge                   = 77762,
            resonanceTotem              = 202188,
            stormkeeper                 = 205495,
            stormTotem                  = 210651,
            tailwindTotem               = 210660,
        }
        self.spell.spec.debuffs         = {
            flameShock                  = 188389,
            frostShock                  = 196840,
            lightningRod                = 197209,
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            ascendance                  = 114050,
            elementalBlast              = 117014,
            elementalMastery            = 16166,
            icefury                     = 210714,
            liquidMagmaTotem            = 192222,
            stormElemental              = 192249,
            totemMastery                = 210643,
        }
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

            self.units.dyn10 = dynamicTarget(10, true)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5  = getEnemies("player", 5)
            self.enemies.yards8  = getEnemies("target", 8)
            self.enemies.yards10 = getEnemies("player", 10)
            self.enemies.yards40 = getEnemies("player", 40)
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getArtifacts()
            local isKnown = isKnown

            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact[k] = isKnown(v) or false
            end
        end

        function self.getArtifactRanks()

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
                self.buff.stack[k]      = getBuffStacks("player",v) or 0
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

            for r = 1, 7 do --search each talent row
                for c = 1, 3 do -- search each talent column
                    local talentID = select(6,GetTalentInfo(r,c,GetActiveSpecGroup())) -- ID of Talent at current Row and Column
                    for k,v in pairs(self.spell.spec.talents) do
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

        function self.getPerks()
            local isKnown = isKnown

        end

    ---------------
    --- TOGGLES ---
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
    --- OPTIONS ---
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

            self.cast.debug.ascendance      = self.cast.ascendance("player",true)
            self.cast.debug.chainLightning  = self.cast.chainLightning("target",true)
            self.cast.debug.earthElemental  = self.cast.earthElemental("player",true)
            self.cast.debug.earthquakeTotem = self.cast.earthquakeTotem("player",true)
            self.cast.debug.earthShock      = self.cast.earthShock("target",true)
            self.cast.debug.elementalBlast  = self.cast.elementalBlast("target",true)
            self.cast.debug.elementalMastery= self.cast.elementalMastery("player",true)
            self.cast.debug.fireElemental   = self.cast.fireElemental("player",true)
            self.cast.debug.flameShock      = self.cast.flameShock("target",true)
            self.cast.debug.frostShock      = self.cast.frostShock("target",true)
            self.cast.debug.healingSurge    = self.cast.healingSurge("player",true)
            self.cast.debug.icefury         = self.cast.icefury("target",true)
            self.cast.debug.lavaBeam        = self.cast.lavaBeam("target",true)
            self.cast.debug.lavaBurst       = self.cast.lavaBurst("target",true)
            self.cast.debug.lightningBolt   = self.cast.lightningBolt("target",true)
            self.cast.debug.liquidMagmaTotem= self.cast.liquidMagmaTotem("player",true) 
            self.cast.debug.stormElemental  = self.cast.stormElemental("player",true)
            self.cast.debug.stormkeeper     = self.cast.stormkeeper("player",true)
            self.cast.debug.thunderstorm    = self.cast.thunderstorm("player",true)
            self.cast.debug.totemMastery    = self.cast.totemMastery("player",true)
        end

        -- Ascendance
        function self.cast.ascendance(thisUnit,debug)
            local spellCast = self.spell.ascendance
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.ascendance and self.cd.ascendance == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Chain Lightning
        function self.cast.chainLightning(thisUnit,debug)
            local spellCast = self.spell.chainLightning
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 28 and self.cd.chainLightning == 0 --[[and not self.buff.ascendance ]]and not isCastingSpell(self.spell.chainLightning,"player") and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false) 
                end
            elseif debug then
                return false
            end
        end
        -- Earth Elemental
        function self.cast.earthElemental(thisUnit,debug)
            local spellCast = self.spell.earthElemental
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 72 and self.cd.earthElemental == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Earthquake Totem
        function self.cast.earthquakeTotem(numUnits,debug)
            local spellCast = self.spell.earthquakeTotem
            local numUnits = numUnits
            if numUnits == nil then numUnits = 1 end
            if debug == nil then debug = false end

            if self.level >= 52 and self.cd.earthquakeTotem == 0 and self.power > 50 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castGroundAtBestLocation(spellCast,8,numUnits,35)
                end
            elseif debug then
                return false
            end
        end
        -- Earth Shock
        function self.cast.earthShock(thisUnit,debug)
            local spellCast = self.spell.earthShock
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 3 and self.cd.earthShock == 0 and self.power > 10 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false) 
                end
            elseif debug then
                return false
            end
        end
        -- Elemental Blast
        function self.cast.elementalBlast(thisUnit,debug)
            local spellCast = self.spell.elementalBlast
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.elementalBlast and self.cd.elementalBlast == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Elemental Mastery
        function self.cast.elementalMastery(thisUnit,debug)
            local spellCast = self.spell.elementalMastery
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.elementalMastery and self.cd.elementalMastery == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Fire Elemental
        function self.cast.fireElemental(thisUnit,debug)
            local spellCast = self.spell.fireElemental
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 48 and self.cd.fireElemental == 0 and not self.talent.stormElemental then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Flame Shock
        function self.cast.flameShock(thisUnit,debug)
            local spellCast = self.spell.flameShock
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 5 and self.cd.flameShock == 0 and self.power > 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Frost Shock
        function self.cast.frostShock(thisUnit,debug)
            local spellCast = self.spell.frostShock
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 26 and self.cd.frostShock == 0 and self.power > 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Healing Surge
        function self.cast.healingSurge(thisUnit,debug)
            local spellCast = self.spell.healingSurge
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 7 and self.cd.healingSurge == 0 and self.powerPercentMana > 20 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Icefury
        function self.cast.icefury(thisUnit,debug)
            local spellCast = self.spell.icefury
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.icefury and self.cd.icefury == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Lava Beam
        function self.cast.lavaBeam(thisUnit,debug)
            local spellCast = self.spell.lavaBeam
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 28 and self.cd.lavaBeam == 0 and self.buff.ascendance and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Lava Burst
        function self.cast.lavaBurst(thisUnit,debug)
            local spellCast = self.spell.lavaBurst
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 12 and self.powerPercentMana > 6 and self.cd.lavaBurst == 0 and self.charges.lavaBurst > 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Lightning Bolt
        function self.cast.lightningBolt(thisUnit,debug)
            local spellCast = self.spell.lightningBolt
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 1 and self.cd.lightningBolt == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Liquid Magma Totem
        function self.cast.liquidMagmaTotem(thisUnit,debug)
            local spellCast = self.spell.liquidMagmaTotem
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.liquidMagmaTotem and self.cd.liquidMagmaTotem == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    --return castSpell(thisUnit,spellCast,false,false,false)
                    -- return castGroundAtBestLocation(spellCast,8,numUnits,35)
                    return castGround(thisUnit,spellCast,40)
                end
            elseif debug then
                return false
            end
        end
        -- Storm Elemental
        function self.cast.stormElemental(thisUnit,debug)
            local spellCast = self.spell.stormElemental
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.stormElemental and self.cd.stormElemental == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Stormkeeper
        function self.cast.stormkeeper(thisUnit,debug)
            local spellCast = self.spell.stormkeeper
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.artifact.stormkeeper and self.cd.stormkeeper == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Thunderstorm
        function self.cast.thunderstorm(thisUnit,debug)
            local spellCast = self.spell.thunderstorm
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 16 and self.cd.thunderstorm == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Totem Mastery
        function self.cast.totemMastery(thisUnit,debug)
            local spellCast = self.spell.totemMastery
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.totemMastery and self.cd.totemMastery == 0 then
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
    end-- cElemental
end-- select Shaman