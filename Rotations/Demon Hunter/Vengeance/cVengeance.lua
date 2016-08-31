--- Vengeance Class
-- Inherit from: ../cCharacter.lua and ../cDemonHunter.lua
cVengeance = {}
cVengeance.rotations = {}

-- Creates Vengeance DemonHunter
function cVengeance:new()
    if GetSpecializationInfo(GetSpecialization()) == 581 then
        local self = cDemonHunter:new("Vengeance")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cVengeance.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------

        self.charges.frac               = {}        -- Fractional Charge
        self.charges.max                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            soulCarver                  = 207407,
            infernalStrike              = 189110,
            shear                       = 203782,
            soulCleave                  = 228477,
            immolationAura              = 178740,
            metamorphosis               = 187827,
            demonSpikes                 = 203720,
            sigilofFlame                = 204596,
            fieryBrand                  = 204021,
            throwGlaive                 = 204157,
            felblade                    = 213241,
        }
        self.spell.spec.artifacts       = {

        }
        self.spell.spec.buffs           = {
            demonSpikes                 = 203819,
            soulFragments               = 203981,
            metamorphosis               = 187827,
            feastofSouls                = 207693,
        }
        self.spell.spec.debuffs         = {

        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            abyssalStrike               = 207550,
            agonizingFlames             = 207548,
            razorSpikes                 = 209400,
            feastofSouls                = 207697,
            fallout                     = 227174,
            burningAlive                = 207739,
            felblade                    = 213241,
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

        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

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
            local Unit3BuffID = UnitBuffID

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
                    self.debuff[k]          = UnitDebuffID(self.units.dyn5,v,"player") ~= nil
                    self.debuff.duration[k] = getDebuffDuration(self.units.dyn5,v,"player") or 0
                    self.debuff.remain[k]   = getDebuffRemain(self.units.dyn5,v,"player") or 0
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
            self.mode.mover     = bb.data["Mover"]
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
            self.cast.debug.infernalStrike      = self.cast.infernalStrike("player", true);
            self.cast.debug.shear               = self.cast.shear("target", true);
            self.cast.debug.soulCleave          = self.cast.soulCleave("target", true);
            self.cast.debug.immolationAura      = self.cast.immolationAura("player", true);
            self.cast.debug.metamorphosis       = self.cast.metamorphosis("player", true);
            self.cast.debug.demonSpikes         = self.cast.demonSpikes("player", true);
            self.cast.debug.throwGlaive         = self.cast.throwGlaive("target", true);
            self.cast.debug.sigilofFlame         = self.cast.sigilofFlame("target", true);
   --       self.cast.debug.soulCarver          = self.cast.soulCarver 
        end

        -- soulCarver                  = 214743,
        function self.cast.soulCarver(thisUnit,debug)
            local spellCast = self.spell.soulCarver
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 100 and getDistance(thisUnit) <= 5 and self.cd.soulCarver == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- infernalStrike              = 189110,
        function self.cast.infernalStrike(thisUnit,debug)
            local spellCast = self.spell.infernalStrike
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 98 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castGround(thisUnit,spellCast,8)
                end
            elseif debug then
                return false
            end
        end
        -- shear                       = 203782,
        function self.cast.shear(thisUnit,debug)
            local spellCast = self.spell.shear
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 98 and getDistance(thisUnit) <= 5 and self.cd.shear == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- soulCleave                  = 228477,
        function self.cast.soulCleave(thisUnit,debug)
            local spellCast = self.spell.soulCleave
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 98 and self.power >= 30 and getDistance(thisUnit) < 5 and self.cd.soulCleave == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- immolationAura              = 178740,
        function self.cast.immolationAura(thisUnit,debug)
            local spellCast = self.spell.immolationAura
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn8 end
            if debug == nil then debug = false end

            if self.level >= 98 and getDistance(thisUnit) < 8 and self.cd.immolationAura == 0 then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell("player",spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- metamorphosis               = 187827,
        function self.cast.metamorphosis(thisUnit,debug)
            local spellCast = self.spell.metamorphosis
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn8 end
            if debug == nil then debug = false end

            if self.level >= 98 and getDistance(thisUnit) < 5 and self.cd.metamorphosis == 0 then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell("player",spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- demonSpikes                 = 203720,
        function self.cast.demonSpikes(thisUnit,debug)
            local spellCast = self.spell.demonSpikes
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn8 end
            if debug == nil then debug = false end

            if self.level >= 98 and self.power >= 20 and self.charges.demonSpikes >= 1 and not self.buff.demonSpikes and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell("player",spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- sigilofFlame                = 204596,
        function self.cast.sigilofFlame(thisUnit,debug)
            local spellCast = self.spell.sigilofFlame
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 98 and getDistance(thisUnit) < 10 and self.cd.sigilofFlame == 0 then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    return castGround(thisUnit,spellCast,10)
                end
            elseif debug then
                return false
            end
        end
        -- fieryBrand                  = 204021,
        -- throwGlaive                 = 204157,
        function self.cast.throwGlaive(thisUnit,debug)
            local spellCast = self.spell.throwGlaive
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.level >= 98 and getDistance(thisUnit) < 30 and self.cd.throwGlaive == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end

        function self.cast.felblade(thisUnit,debug)
            local spellCast = self.spell.felblade
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end
            if self.level >= 102 and self.talent.felblade and getDistance(thisUnit) <= 15 and self.cd.felblade == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Annihilation
        -- function self.cast.annihilation(thisUnit,debug)
        --     local spellCast = self.spell.annihilation
        --     local thisUnit = thisUnit
        --     if thisUnit == nil then thisUnit = self.units.dyn5 end
        --     if debug == nil then debug = false end

        --     if self.level >= 98 and self.power > 40 and self.cd.annihilation == 0 and self.buff.metamorphosis and getDistance(thisUnit) < 5 then
        --         if debug then
        --             return castSpell(thisUnit,spellCast,true,false,false,true,false,false,true,true)
        --         else
        --             return castSpell(thisUnit,spellCast,true,false,false,true,false,false,true)
        --         end
        --     elseif debug then
        --         return false
        --     end
        -- end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

        function soulAmount()
            return getBuffStacks("player",self.spell.spec.buffs.soulFragments) or 0
        end

        function spikesCD()
            return select(4,GetSpellCharges(self.spell.demonSpikes))
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cHavoc
end-- select Demonhunter