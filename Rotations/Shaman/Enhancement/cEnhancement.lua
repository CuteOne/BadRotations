--- Enhancement Class
-- Inherit from: ../cCharacter.lua and ../cShaman.lua
cEnhancement = {}
cEnhancement.rotations = {}

-- Creates Enhancement Shaman
function cEnhancement:new()
    if GetSpecializationInfo(GetSpecialization()) == 263 then
        local self = cShaman:new("Enhancement")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cEnhancement.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
        self.charges.frac               = {}        -- Fractional Charge
        self.charges.max                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            ascendance                  = 114051,
            boulderfist                 = 201897,
            cleanseSpirit               = 51886,
            crashLightning              = 187874,
            doomWinds                   = 204945,
            earthenSpike                = 188089,
            feralLunge                  = 196884,
            feralSpirit                 = 51533,
            flametongue                 = 193796,
            frostbrand                  = 196834,
            furyOfAir                   = 197211,
            healingSurge                = 188070,
            lavaLash                    = 60103,
            lightningBolt               = 187837,
            lightningShield             = 192106,
            rainfall                    = 215864,
            rockbiter                   = 193786,
            spiritWalk                  = 58875,
            stormstrike                 = 17364,
            sundering                   = 197214,
            windRushTotem               = 192077,
            windsong                    = 201898,
            windstrike                  = 115356,
        }
        self.spell.spec.artifacts       = {
            alphaWolf                   = 198434,
            doomWinds                   = 204945,
            gatheringStorms             = 198299,
        }
        self.spell.spec.buffs           = {
            ascendance                  = 114051,
            boulderfist                 = 218825,
            crashLightning              = 187874,
            doomWinds                   = 204945,
            flametongue                 = 194084,
            frostbrand                  = 196834,
            furyOfAir                   = 197211,
            gatheringStorms             = 198300,
            hailstorm                   = 210853,
            hotHand                     = 215785,
            landslide                   = 202004,
            lightningShield             = 192106,
            prolongedPower              = 229206,
            stormbringer                = 201846,
            temptation                  = 234143,
        }
        self.spell.spec.debuffs         = {
            frostbrand                  = 147732,
            stormTempests               = 214265,
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            ancestralSwiftness          = 192087,
            ascendance                  = 114051,
            boulderfist                 = 201897,
            crashingStorm               = 192246,
            earthenSpike                = 188089,
            empoweredStormLash          = 210731,
            feralLunge                  = 196884,
            furyOfAir                   = 197211,
            hailstorm                   = 210853,
            hotHand                     = 201900,
            landslide                   = 197992,
            lightningShield             = 192106,
            overcharge                  = 210727,
            rainfall                    = 215864,
            sundering                   = 197214,
            windRushTotem               = 192077,
            windsong                    = 201898,
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

            self.units.dyn8  = dynamicTarget(8, true)
            self.units.dyn10 = dynamicTarget(10, true)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5  = getEnemies("player", 5)
            self.enemies.yards8  = getEnemies("player", 8)
            self.enemies.yards10 = getEnemies("player", 10)
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

            self.cast.debug.ascendance      = self.cast.ascendance("player", true)
            self.cast.debug.boulderfist     = self.cast.boulderfist("target",true)
            self.cast.debug.cleanseSpirit   = self.cast.cleanseSpirit("target",true)
            self.cast.debug.crashLightning  = self.cast.crashLightning("target",true)
            self.cast.debug.doomWinds       = self.cast.doomWinds("player",true)
            self.cast.debug.earthenSpike    = self.cast.earthenSpike("target",true)
            self.cast.debug.feralLunge      = self.cast.feralLunge("target",true)
            self.cast.debug.feralSpirit     = self.cast.feralSpirit("player",true)
            self.cast.debug.flametongue     = self.cast.flametongue("target",true)
            self.cast.debug.frostbrand      = self.cast.frostbrand("target",true)
            self.cast.debug.furyOfAir       = self.cast.furyOfAir("player",true)
            self.cast.debug.healingSurge    = self.cast.healingSurge("player",true)
            self.cast.debug.lavaLash        = self.cast.lavaLash("target",true)
            self.cast.debug.lightningBolt   = self.cast.lightningBolt("target",true)
            self.cast.debug.lightningShield = self.cast.lightningShield("player",true)
            self.cast.debug.rainfall        = self.cast.rainfall("player",true)
            self.cast.debug.rockbiter       = self.cast.rockbiter("target",true)
            self.cast.debug.spiritWalk      = self.cast.spiritWalk("player",true)
            self.cast.debug.stormstrike     = self.cast.stormstrike("target",true)
            self.cast.debug.sundering       = self.cast.sundering("target",true)
            self.cast.debug.windstrike      = self.cast.windstrike("target",true)
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
        -- Boulderfist
        function self.cast.boulderfist(thisUnit,debug)
            local spellCast = self.spell.boulderfist
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn10 end
            if debug == nil then debug = false end

            if self.talent.boulderfist and self.cd.boulderfist == 0 and self.charges.boulderfist > 0 and getDistance(thisUnit) < 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Crash Lightning
        function self.cast.crashLightning(thisUnit,debug)
            local spellCast = self.spell.crashLightning
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 28 and self.cd.crashLightning == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Cleanse Spirit
        function self.cast.cleanseSpirit(thisUnit,debug)
            local spellCast = self.spell.cleanseSpirit
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40AoE end
            if debug == nil then debug = false end

            if self.level >= 18 and self.powerPercentMana > 13 and self.cd.cleanseSpirit == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Doom Winds
        function self.cast.doomWinds(thisUnit,debug)
            local spellCast = self.spell.doomWinds
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.artifact.doomWinds and self.cd.doomWinds == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Earthen Spike
        function self.cast.earthenSpike(thisUnit,debug)
            local spellCast = self.spell.earthenSpike
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn10 end
            if debug == nil then debug = false end

            if self.talent.earthenSpike and self.cd.earthenSpike == 0 and self.power > 30 and getDistance(thisUnit) < 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Feral Lunge
        function self.cast.feralLunge(thisUnit,debug)
            local spellCast = self.spell.feralLunge
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.talent.feralLunge and self.cd.feralLunge == 0 and (hasThreat(thisUnit) or self.instance == "none") and getDistance(thisUnit) >= 8 and getDistance(thisUnit) < 25 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Feral Spirit
        function self.cast.feralSpirit(thisUnit,debug)
            local spellCast = self.spell.feralSpirit
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 48 and self.cd.feralSpirit == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Flametongue
        function self.cast.flametongue(thisUnit,debug)
            local spellCast = self.spell.flametongue
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn10 end
            if debug == nil then debug = false end

            if self.level >= 12 and self.cd.flametongue == 0 and getDistance(thisUnit) < 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Frostbrand
        function self.cast.frostbrand(thisUnit,debug)
            local spellCast = self.spell.frostbrand
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn10 end
            if debug == nil then debug = false end

            if self.level >= 19 and self.cd.frostbrand == 0 and self.power > 20 and getDistance(thisUnit) < 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Fury of Air
        function self.cast.furyOfAir(thisUnit,debug)
            local spellCast = self.spell.furyOfAir
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.furyOfAir and self.cd.furyOfAir == 0 and self.power > 5 then
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

            if self.level >= 10 and self.cd.healingSurge == 0 and self.powerPercentMana > 22 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Lava Lash
        function self.cast.lavaLash(thisUnit,debug)
            local spellCast = self.spell.lavaLash
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 10 and self.cd.lavaLash == 0 and self.power > 30 and getDistance(thisUnit) < 5 then
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

            if self.level >= 10 and self.cd.lightningBolt == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Lightning Shield
        function self.cast.lightningShield(thisUnit,debug)
            local spellCast = self.spell.lightningShield
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.lightningShield and not self.buff.lightningShield then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Rainfall
        function self.cast.rainfall(thisUnit,debug)
            local spellCast = self.spell.rainfall
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.rainfall and self.cd.rainfall == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castGround(thisUnit,spellCast,40)
                end
            elseif debug then
                return false
            end
        end
        -- Rockbiter
        function self.cast.rockbiter(thisUnit,debug)
            local spellCast = self.spell.rockbiter
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn10 end
            if debug == nil then debug = false end

            if self.level >= 10 and not self.talent.boulderfist and self.cd.rockbiter == 0 and getDistance(thisUnit) < 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Spirit Walk
        function self.cast.spiritWalk(thisUnit,debug)
            local spellCast = self.spell.spiritWalk
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 72 and not self.cd.spiritWalk == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Stormstrike
        function self.cast.stormstrike(thisUnit,debug)
            local spellCast = self.spell.stormstrike
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 26 and (self.power > 40 or (self.buff.stormbringer and self.power > 20)) and self.cd.stormstrike == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Sundering
        function self.cast.sundering(thisUnit,debug)
            local spellCast = self.spell.sundering
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.sundering and self.cd.sundering == 0 and self.power > 60 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Windsong
        function self.cast.windsong(thisUnit,debug)
            local spellCast = self.spell.windsong
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn10 end
            if debug == nil then debug = false end

            if self.talent.windsong and self.cd.windsong == 0 and getDistance(thisUnit) < 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Windstrike
        function self.cast.windstrike(thisUnit,debug)
            local spellCast = self.spell.windstrike
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.buff.ascendance and self.cd.windstrike == 0 and self.power > 40 and getDistance(thisUnit) < 30 then
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
    end-- cEnhancement
end-- select Shaman