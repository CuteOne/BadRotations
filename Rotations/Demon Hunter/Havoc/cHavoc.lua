--- Havoc Class
-- Inherit from: ../cCharacter.lua and ../cDemonHunter.lua
cHavoc = {}
cHavoc.rotations = {}

-- Creates Havoc DemonHunter
function cHavoc:new()
    if GetSpecializationInfo(GetSpecialization()) == 577 then
		local self = cDemonHunter:new("Havoc")

		local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cHavoc.rotations
		
    -----------------
    --- VARIABLES ---
    -----------------

        self.charges.frac               = {}        -- Fractional Charge
        self.charges.max                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            annihilation                = 201427,
            bladeDance                  = 188499,
            blur                        = 198589,
            chaosBlades                 = 211048,
            chaosNova                   = 179057,
            chaosStrike                 = 162794,
            darkness                    = 196718,
            deathSweep                  = 210152,  
            demonsBite                  = 162243,
            eyeBeam                     = 198013,
            felBarrage                  = 211053,
            felblade                    = 213241,
            felEruption                 = 211881,
            felRush                     = 195072,
            furyOfTheIllidari           = 201467,
            metamorphosis               = 191427,
            netherwalk                  = 196555,
            nemesis                     = 206491,
            throwGlaive                 = 185123,
            vengefulRetreat             = 198793,
        }
        self.spell.spec.artifacts       = {
            anguishOfTheDeceiver        = 201473,
            demonSpeed                  = 201469,
            furyOfTheIllidari           = 201467,
            warglaivesOfChaos           = 214795,
        }
        self.spell.spec.buffs           = {
            chaosBlades                 = 211797,
            metamorphosis               = 162264,
            momentum                    = 208628,
            prepared                    = 203650,
        }
        self.spell.spec.debuffs         = {
            nemesis                     = 206491,
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            blindFury                   = 203550,
            bloodlet                    = 206473,
            chaosBlades                 = 211048,
            chaosCleave                 = 206475,
            demonBlades                 = 203555,
            demonic                     = 213410,
            demonicAppetite             = 206478,
            demonReborn                 = 193897,
            desperateInstincts          = 205411,
            felBarrage                  = 211053,
            felMastery                  = 192939,
            firstBlood                  = 206416,
            mastersOfTheGlaive          = 203556,
            momentum                    = 206476,
            nemesis                     = 206491,
            netherwalk                  = 196555,
            prepared                    = 203551,
            soulRending                 = 204909,
            unleashedPower              = 206477,
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

            self.units.dyn8 = dynamicTarget(8, false)
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

            self.cast.debug.annihilation        = self.cast.annihilation("target",true)
            self.cast.debug.bladeDance          = self.cast.bladeDance("player",true)
            self.cast.debug.blur                = self.cast.blur("player",true)
            self.cast.debug.chaosBlades         = self.cast.chaosBlades("player",true)
            self.cast.debug.chaosNova           = self.cast.chaosNova("player",true)
            self.cast.debug.chaosStrike         = self.cast.chaosStrike("target",true)
            self.cast.debug.darkness            = self.cast.darkness("player",true)
            self.cast.debug.deathSweep          = self.cast.deathSweep("player",true)
            self.cast.debug.demonsBite          = self.cast.demonsBite("target",true)
            self.cast.debug.eyeBeam             = self.cast.eyeBeam("player",true)
            self.cast.debug.felBarrage          = self.cast.felBarrage("target",true)
            self.cast.debug.felblade            = self.cast.felblade("target",true)
            self.cast.debug.felEruption         = self.cast.felEruption("target",true)
            self.cast.debug.felRush             = self.cast.felRush("player",true)
            self.cast.debug.furyOfTheIllidari   = self.cast.furyOfTheIllidari("player",true)
            self.cast.debug.metamorphosis       = self.cast.metamorphosis("player",true)
            self.cast.debug.nemesis             = self.cast.nemesis("target",true)
            self.cast.debug.throwGlaive         = self.cast.throwGlaive("target",true)
            self.cast.debug.vengefulRetreat     = self.cast.vengefulRetreat("player",true)
        end

        -- Annihilation
        function self.cast.annihilation(thisUnit,debug)
            local spellCast = self.spell.annihilation
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 98 and self.power > 40 and self.cd.annihilation == 0 and self.buff.metamorphosis and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,true,false,false,true,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false,true,false,false,true)
                end
            elseif debug then
                return false
            end
        end
        -- Blade Dance
        function self.cast.bladeDance(thisUnit,debug)
            local spellCast = self.spell.bladeDance
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end
            if self.buff.metamorphosis then spellCast = self.spell.deathSweep end

            if self.level >= 98 and self.power > 40 and self.cd.bladeDance == 0 and not self.buff.metamorphosis and getDistance(self.units.dyn5) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Blur
        function self.cast.blur(thisUnit,debug)
            local spellCast = self.spell.blur
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 100 and isKnown(spellCast) and self.cd.blur == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Chaos Blades
        function self.cast.chaosBlades(thisUnit,debug)
            local spellCast = self.spell.chaosBlades
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.chaosBlades and self.cd.chaosBlades == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Chaos Nova
        function self.cast.chaosNova(thisUnit,debug)
            local spellCast = self.spell.chaosNova
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 100 and isKnown(spellCast) and self.power > 30 and self.cd.chaosNova == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Chaos Strike
        function self.cast.chaosStrike(thisUnit,debug)
            local spellCast = self.spell.chaosStrike
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 98 and self.power > 40 and self.cd.chaosStrike == 0 and not self.buff.metamorphosis and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Darkness
        function self.cast.darkness(thisUnit,debug)
            local spellCast = self.spell.darkness
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 100 and isKnown(spellCast) and self.cd.darkness == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Death Sweep
        function self.cast.deathSweep(thisUnit,debug)
            local spellCast = self.spell.deathSweep
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 98 and self.power > 40 and self.cd.deathSweep == 0 and self.buff.metamorphosis and getDistance(self.units.dyn5) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,true,false,false,true,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false,true,false,false,true)
                end
            elseif debug then
                return false
            end
        end
        -- Demon's Bite
        function self.cast.demonsBite(thisUnit,debug)
            local spellCast = self.spell.demonsBite
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if not self.talent.demonBlades and self.level >= 98 and self.power <= 70 and self.cd.demonsBite == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Eye Beam
        function self.cast.eyeBeam(thisUnit,debug)
            local spellCast = self.spell.eyeBeam
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 98 and isKnown(spellCast) and self.cd.eyeBeam == 0 and self.power > 50 and getDistance(self.units.dyn8) < 8 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Fel Barrage
        function self.cast.felBarrage(thisUnit,debug)
            local spellCast = self.spell.felBarrage
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.talent.felBarrage and self.cd.felBarrage == 0 and self.charges.felBarrage > 0 and getDistance(thisUnit) < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Felblade
        function self.cast.felblade(thisUnit,debug)
            local spellCast = self.spell.felblade
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn15 end
            if debug == nil then debug = false end

            if self.talent.felblade and self.cd.felblade == 0 and getDistance(thisUnit) < 15 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Fel Eruption
        function self.cast.felEruption(thisUnit,debug)
            local spellCast = self.spell.felEruption
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn20 end
            if debug == nil then debug = false end

            if self.talent.felEruption and self.cd.felEruption == 0 and self.power > 20 and getDistance(thisUnit) < 20 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Fel Rush
        function self.cast.felRush(thisUnit,debug)
            local spellCast = self.spell.felRush
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 98 and self.charges.felRush > 0 and self.cd.felRush == 0  then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)                    
                end
            elseif debug then
                return false
            end
        end
        -- Fel Rush Animation Cancel
        function self.cast.felRushAnimationCancel(thisUnit,debug)
            local spellCast = self.spell.felRush
            local thisUnit = thisUnit
            local returnVar
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 98 and self.charges.felRush > 0 and self.cd.felRush == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    MoveBackwardStart()
                    if bb.timer:useTimer("felRushCancelAnimation", 0.04) then
                        JumpOrAscendStart()
                        castSpell(thisUnit,spellCast,false,false,false)
                    end
                    MoveBackwardStop()
                    return
                end
            elseif debug then
                return false
            end
        end

        -- Fury of the Illidari
        function self.cast.furyOfTheIllidari(thisUnit,debug)
            local spellCast = self.spell.furyOfTheIllidari
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.artifact.furyOfTheIllidari and self.cd.furyOfTheIllidari == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Metamorphosis
        function self.cast.metamorphosis(thisUnit,debug)
            local spellCast = self.spell.metamorphosis
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn8AoE end
            if debug == nil then debug = false end

            if self.level >= 99 and self.cd.metamorphosis == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castGround(thisUnit,spellCast,8)
                end
            elseif debug then
                return false
            end
        end
        -- Nemesis
        function self.cast.nemesis(thisUnit,debug)
            local spellCast = self.spell.nemesis
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.nemesis and self.cd.nemesis == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Throw Glaive
        function self.cast.throwGlaive(thisUnit,debug)
            local spellCast = self.spell.throwGlaive
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.level >= 99 and isKnown(spellCast) and self.charges.throwGlaive > 0 and self.cd.throwGlaive == 0 and getDistance(thisUnit) < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Vengeful Retreat
        function self.cast.vengefulRetreat(thisUnit,debug)
            local spellCast = self.spell.vengefulRetreat
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 100 and isKnown(spellCast) and self.cd.vengefulRetreat == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    if self.mode.mover == 1 then
                        SetHackEnabled("NoKnockback", true)
                    end
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
        function worthUsing()
            local demons_bite_per_dance = 35 / 25
            local demons_bite_per_chaos_strike = ( 40 - 20 * (GetCritChance("player")/100) ) / 25
            local mhDamage = ((select(2,UnitDamage("player"))+select(1,UnitDamage("player"))) / 2)
            local ohDamage = ((select(4,UnitDamage("player"))+select(3,UnitDamage("player"))) / 2)
            local totDamage = (mhDamage + UnitAttackPower("player") / 3.5 * 2.4) + (ohDamage + UnitAttackPower("player") / 3.5 * 2.4) 
            local demons_bite_damage = 2.6 * totDamage
            local blade_dance_damage = ((1 * totDamage) + (2 * (0.96 * totDamage)) + (2.88 * totDamage))
            local chaos_strike_damage = 2.75 * totDamage
            if ( blade_dance_damage + demons_bite_per_dance * demons_bite_damage ) / ( 1 + demons_bite_per_dance ) > ( chaos_strike_damage + demons_bite_per_chaos_strike * demons_bite_damage ) / ( 1 + demons_bite_per_chaos_strike ) then
                return true
            else
                return false
            end
        end

        -- Return
        return self
    end-- cHavoc
end-- select Demonhunter