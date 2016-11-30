--- Discipline Class
-- Inherit from: ../cCharacter.lua and ../cWarrior.lua
cDiscipline = {} 
cDiscipline.rotations = {}

function cDiscipline:new()
    if GetSpecializationInfo(GetSpecialization()) == 256 then 
        local self = cPriest:new("Discipline")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cDiscipline.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------

        self.charges.frac               = {}
        self.charges.max                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {         
            angelicFeather              = 121536,
            divineStar                  = 110744,
            halo                        = 120517,
            leapOfFaith                 = 73325,
            lightsWrath                 = 207946,
            massResurrection            = 212036,
            painSuppression             = 33206,
            penance                     = 47540,
            plea                        = 200829,
            powerWordBarrier            = 62618,
            powerWordRadiance           = 194509,
            powerWordShield             = 17,
            powerWordSolace             = 129250,
            purgeTheWicked              = 204197,
            purify                      = 527,
            rapture                     = 47536,
            shadowMend                  = 186263,
            schism                      = 214621
        }
        self.spell.spec.artifacts       = {    

        }
        self.spell.spec.buffs           = {         
            atonement                   = 194384
        }
        self.spell.spec.debuffs         = {         
            purgeTheWicked              = 204213,
            shadowWordPain              = 589,
            smite                       = 585
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
    --- DYNAMIC UNITS --- -- Define dynamic targetting for specific range limits here
    ---------------------

        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn40     = dynamicTarget(40, true) 
        end

    ---------------
    --- ENEMIES --- -- Define enemy tables for specific range limits here
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards40     = getEnemies("player", 40) -- Melee
        end

    -----------------
    --- ARTIFACTS --- -- Should not need to edit
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
    --- BUFFS --- -- Should not need to edit
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
    --- CHARGES --- -- Should not need to edit
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
    --- COOLDOWNS --- -- Should not need to edit
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
    --- DEBUFFS --- -- Should not need to edit
    ---------------
        function self.getDebuffs()
            local UnitDebuffID = UnitDebuffID
            local getDebuffDuration = getDebuffDuration
            local getDebuffRemain = getDebuffRemain

            for k,v in pairs(self.spell.spec.debuffs) do
                if k ~= "bleeds" then
                    self.debuff[k]          = UnitDebuffID(self.units.dyn40,v,"player") ~= nil
                    self.debuff.duration[k] = getDebuffDuration(self.units.dyn40,v,"player") or 0
                    self.debuff.remain[k]   = getDebuffRemain(self.units.dyn40,v,"player") or 0
                    self.debuff.refresh[k]  = (self.debuff.remain[k] < self.debuff.duration[k] * 0.3) or self.debuff.remain[k] == 0
                end
            end
        end        

    --------------
    --- GLYPHS --- -- Should not need to edit
    --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

        end

    ---------------
    --- TALENTS --- -- Should not need to edit
    ---------------

        function self.getTalents()
            local getTalent = getTalent

            self.talent.thePenitent                 = getTalent(1,1)
            self.talent.castigation                 = getTalent(1,2)
            self.talent.schism                      = getTalent(1,3)
            self.talent.angelicFeather              = getTalent(2,1)
            self.talent.bodyAndSoul                 = getTalent(2,2)
            self.talent.masochism                   = getTalent(2,3)
            self.talent.shiningForce                = getTalent(3,1)
            self.talent.psychicVoices               = getTalent(3,2)
            self.talent.dominateMind                = getTalent(3,3)
            self.talent.powerWordSolace             = getTalent(4,1)
            self.talent.shieldDiscipline            = getTalent(4,2)
            self.talent.mindBender                  = getTalent(4,3)
            self.talent.contrition                  = getTalent(5,1)
            self.talent.powerInfusion               = getTalent(5,2)
            self.talent.twistOfFate                 = getTalent(5,3)
            self.talent.clarityOfWill               = getTalent(6,1)
            self.talent.divineStar                  = getTalent(6,2)
            self.talent.halo                        = getTalent(6,3)
            self.talent.purgeTheWicked              = getTalent(7,1)
            self.talent.grace                       = getTalent(7,2)
            self.talent.shadowCovenant              = getTalent(7,3)
        end

    -------------
    --- PERKS --- -- Should not need to edit
    -------------

        function self.getPerks()
            local isKnown = isKnown

        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes() -- list toggles here to be able to refer to them via br.player.mode

            self.mode.rotation  = br.data["Rotation"]
            self.mode.cooldown  = br.data["Cooldown"]
            self.mode.defensive = br.data["Defensive"]
            self.mode.interrupt = br.data["Interrupt"]
        end

        -- Create the toggle defined within rotation files, should not need editing
        function self.createToggles()
            GarbageButtons()
            if self.rotations[br.selectedProfile] ~= nil then
                self.rotations[br.selectedProfile].toggles()
            else
                return
            end
        end

    ---------------
    --- OPTIONS --- - Should not need editing
    ---------------
        
        -- Creates the option/profile window
        function self.createOptions()
            br.ui.window.profile = br.ui:createProfileWindow(self.profile)

            -- Get the names of all profiles and create rotation dropdown
            local names = {}
            for i=1,#self.rotations do
                tinsert(names, self.rotations[i].name)
            end
            br.ui:createRotationDropdown(br.ui.window.profile.parent, names)

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
            if self.rotations[br.selectedProfile] ~= nil then
                profileTable = self.rotations[br.selectedProfile].options()
            else
                return
            end

            -- Only add profile pages if they are found
            if profileTable then
                insertTableIntoTable(optionTable, profileTable)
            end

            -- Create pages dropdown
            br.ui:createPagesDropdown(br.ui.window.profile, optionTable)
            br:checkProfileWindowStatus()
        end

    --------------
    --- SPELLS --- 
    --------------

        function self.getCastable() 

        end

        -- Angelic Feather
        function self.cast.angelicFeather(thisUnit,debug)
            local spellCast = self.spell.angelicFeather
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.angelicFeather == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Divine Star
        function self.cast.divineStar(thisUnit,debug)
            local spellCast = self.spell.divineStar
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.divineStar == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Halo
        function self.cast.halo(thisUnit,debug)
            local spellCast = self.spell.halo
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.halo == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Leap Of Faith
        function self.cast.leapOfFaith(thisUnit,debug)
            local spellCast = self.spell.leapOfFaith
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.leapOfFaith == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Light's Wrath
        function self.cast.lightsWrath(thisUnit,debug)
            local spellCast = self.spell.lightsWrath
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.lightsWrath == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Mass Resurrection
        function self.cast.massResurrection(thisUnit,debug)
            local spellCast = self.spell.massResurrection
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.massResurrection == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Pain Suppression
        function self.cast.painSuppression(thisUnit,debug)
            local spellCast = self.spell.painSuppression
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.painSuppression == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Penance
        function self.cast.penance(thisUnit,debug)
            local spellCast = self.spell.penance
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.penance == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Plea
        function self.cast.plea(thisUnit,debug)
            local spellCast = self.spell.plea
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.plea == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Power Word: Barrier
        function self.cast.powerWordBarrier(thisUnit,debug)
            local spellCast = self.spell.powerWordBarrier
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.powerWordBarrier == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Power Word: Radiance
        function self.cast.powerWordRadiance(thisUnit,debug)
            local spellCast = self.spell.powerWordRadiance
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.powerWordRadiance == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Power Word: Solace
        function self.cast.powerWordSolace(thisUnit,debug)
            local spellCast = self.spell.powerWordSolace
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.powerWordSolace == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Purge The Wicked
        function self.cast.purgeTheWicked(thisUnit,debug)
            local spellCast = self.spell.purgeTheWicked
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.purgeTheWicked and self.cd.purgeTheWicked == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Purify
        function self.cast.purify(thisUnit,debug)
            local spellCast = self.spell.purify
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.purify == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Rapture
        function self.cast.rapture(thisUnit,debug)
            local spellCast = self.spell.rapture
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.rapture == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Schism
        function self.cast.schism(thisUnit,debug)
            local spellCast = self.spell.schism
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.cd.schism == 0 and getDistance(thisUnit) < 40 then
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
    end-- cFury
end-- select Warrior