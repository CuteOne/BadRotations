--- Holy Class
-- Inherit from: ../cCharacter.lua and ../cPaladin.lua
cHoly = {}
cHoly.rotations = {}

-- Creates Holy Paladin
function cHoly:new()
    if GetSpecializationInfo(GetSpecialization()) == 65 then
        local self = cPaladin:new("Holy")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cHoly.rotations
    -----------------
    --- VARIABLES ---
    -----------------
        self.charges.frac               = {}        -- Fractional Charge
        self.charges.max                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            absolution                  = 212056,
            auraMastery                 = 31821,
            avengingWrath               = 31842,
            beaconOfFaith               = 156910,
            beaconOfLight               = 53563,
            beaconOfVirtue              = 200025,
            bestowFaith                 = 223306,
            blessingOfSacrifice         = 6940,
            cleanse                     = 4987,
            consecration                = 26573,
            divineProtection            = 498,
            holyAvenger                 = 105809,
            holyLight                   = 82326,
            holyPrism                   = 114165,
            holyShock                   = 20473,
            lightOfDawn                 = 85222,
            lightOfTheMartyr            = 183998,
            lightsHammer                = 114158,
            ruleOfLaw                   = 214202,
            tyrsDeliverance             = 200652,
        }
        self.spell.spec.artifacts       = {
            tyrsDeliverance             = 200652,
        }
        self.spell.spec.buffs           = {

        }
        self.spell.spec.debuffs         = {

        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            auraOfMercy                 = 183415,
            auraOfSacrifice             = 183416,
            beaconOfFaith               = 156910,
            beaconOfTheLightbringer     = 197446,
            beaconOfVirtue              = 200025,
            bestowFaith                 = 223306,
            crusadersMight              = 196926,
            devotionAura                = 183425,
            devinePurpose               = 197646,
            ferventMartyr               = 196923,
            holyAvenger                 = 105809,
            holyPrism                   = 114165,
            judgementOfLight            = 183778,
            lightsHammer                = 114158,
            ruleOfLaw                   = 214202,
            sanctifiedWrath             = 53376,
            unbreakableSpirit           = 114154,
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

            -- self.units.dyn10 = dynamicTarget(10, true)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            -- self.enemies.yards5  = getEnemies("player", 5)
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

            self.cast.debug.absolution          = self.cast.absolution("player",true)
            self.cast.debug.auraMastery         = self.cast.auraMastery("player",true)
            self.cast.debug.avengingWrath       = self.cast.avengingWrath("player",true)
            self.cast.debug.beaconOfFaith       = self.cast.beaconOfFaith("player",true)
            self.cast.debug.beaconOfLight       = self.cast.beaconOfLight("player",true)
            self.cast.debug.beaconOfVirtue      = self.cast.beaconOfVirtue("player",true)
            self.cast.debug.bestowFaith         = self.cast.bestowFaith("player",true)
            self.cast.debug.blessingOfSacrifice = self.cast.blessingOfSacrifice("player",true)
            self.cast.debug.cleanse             = self.cast.cleanse("player",true)
            self.cast.debug.consecration        = self.cast.consecration("player",true)
            self.cast.debug.divineProtection    = self.cast.divineProtection("player",true)
            self.cast.debug.holyAvenger         = self.cast.holyAvenger("player",true)
            self.cast.debug.holyLight           = self.cast.holyLight("player",true)
            self.cast.debug.holyPrism           = self.cast.holyPrism("player",true)
            self.cast.debug.holyShock           = self.cast.holyShock("player",true)
            self.cast.debug.lightOfDawn         = self.cast.lightOfDawn("player",true)
            self.cast.debug.lightOfTheMartyr    = self.cast.lightOfTheMartyr("target",true)
            self.cast.debug.lightsHammer        = self.cast.lightsHammer("target",true)
            self.cast.debug.ruleOfLaw           = self.cast.ruleOfLaw("player",true)
            self.cast.debug.tyrsDeliverance     = self.cast.tyrsDeliverance("player",true)
        end

        -- Absolution
        function self.cast.absolution(thisUnit,debug)
            local spellCast = self.spell.absolution
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 44 and self.cd.absolution == 0 and self.powerPercentMana > 4 and not self.inCombat then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Aura Mastery
        function self.cast.auraMastery(thisUnit,debug)
            local spellCast = self.spell.auraMastery
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 65 and self.cd.auraMastery == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Avenging Wrath
        function self.cast.avengingWrath(thisUnit,debug)
            local spellCast = self.spell.avengingWrath
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 72 and self.cd.avengingWrath == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Beacon of Faith
        function self.cast.beaconOfFaith(thisUnit,debug)
            local spellCast = self.spell.beaconOfFaith
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.beaconOfFaith and self.cd.beaconOfFaith == 0 and self.powerPercentMana > 3.125 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Beacon of Light
        function self.cast.beaconOfLight(thisUnit,debug)
            local spellCast = self.spell.beaconOfLight
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 36 and self.cd.beaconOfLight == 0 and self.powerPercentMana > 2.5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Beacon of Virtue
        function self.cast.beaconOfVirtue(thisUnit,debug)
            local spellCast = self.spell.beaconOfVirtue
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.beaconOfVirtue and self.cd.beaconOfVirtue == 0 and self.powerPercentMana > 15 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Bestow Faith
        function self.cast.bestowFaith(thisUnit,debug)
            local spellCast = self.spell.bestowFaith
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.bestowFaith and self.cd.bestowFaith == 0 and self.powerPercentMana > 6 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Blessing of Sacrifice
        function self.cast.blessingOfSacrifice(thisUnit,debug)
            local spellCast = self.spell.blessingOfSacrifice
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 56 and self.cd.blessingOfSacrifice == 0 and self.powerPercentMana > 7 and self.charges.blessingOfSacrifice >= 1 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Cleanse
        function self.cast.cleanse(thisUnit,debug)
            local spellCast = self.spell.cleanse
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 21 and self.cd.cleanse == 0 and self.powerPercentMana > 13 and self.charges.cleanse >= 1 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Consecration
        function self.cast.consecration(thisUnit,debug)
            local spellCast = self.spell.consecration
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 32 and self.cd.consecration == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Divine Protection
        function self.cast.divineProtection(thisUnit,debug)
            local spellCast = self.spell.divineProtection
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 26 and self.cd.divineProtection == 0 and self.powerPercentMana > 3.5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Holy Avenger
        function self.cast.holyAvenger(thisUnit,debug)
            local spellCast = self.spell.holyAvenger
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.holyAvenger and self.cd.holyAvenger == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Holy Light
        function self.cast.holyLight(thisUnit,debug)
            local spellCast = self.spell.holyLight
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level > 54 and self.cd.holyLight == 0 and self.powerPercentMana > 12 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Holy Prism
        function self.cast.holyPrism(thisUnit,debug)
            local spellCast = self.spell.holyPrism
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.holyPrism and self.cd.holyPrism == 0 and self.powerPercentMana > 17 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Holy Shock
        function self.cast.holyShock(thisUnit,debug)
            local spellCast = self.spell.holyShock
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 10 and self.cd.holyShock == 0 and self.powerPercentMana > 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Light of Dawn
        function self.cast.lightOfDawn(thisUnit,debug)
            local spellCast = self.spell.lightOfDawn
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 58 and self.cd.lightOfDawn == 0 and self.powerPercentMana > 14 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Light of the Martyr
        function self.cast.lightOfTheMartyr(thisUnit,debug)
            local spellCast = self.spell.lightOfDawn
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 42 and self.cd.lightOfTheMartyr == 0 and self.powerPercentMana > 7.5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Light's Hammer
        function self.cast.lightsHammer(thisUnit,debug)
            local spellCast = self.spell.lightsHammer
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.lightsHammer and self.cd.lightsHammer == 0 and self.powerPercentMana > 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Rule of Law
        function self.cast.ruleOfLaw(thisUnit,debug)
            local spellCast = self.spell.ruleOfLaw
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.ruleOfLaw and self.cd.ruleOfLaw == 0 and self.charges.ruleOfLaw >= 1 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Tyr's Deliverance
        function self.cast.tyrsDeliverance(thisUnit,debug)
            local spellCast = self.spell.tyrsDeliverance
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.artifact.tyrsDeliverance and self.cd.tyrsDeliverance == 0 then
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


    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cHoly
end-- select Paladin