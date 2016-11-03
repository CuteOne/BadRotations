--- Demonology Class
-- Inherit from: ../cCharacter.lua and ../cWarlock.lua
cDemonology = {}
cDemonology.rotations = {}

-- Creates Demonology Warlock
function cDemonology:new()
    if GetSpecializationInfo(GetSpecialization()) == 266 then
        local self = cWarlock:new("Demonology")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cDemonology.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
        self.charges.frac               = {}        -- Fractional Charge
        self.charges.max                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            callDreadstalkers           = 104316,
            commandDemon                = 119898,
            demonbolt                   = 157695,
            demonicEmpowerment          = 193396,
            demonwrath                  = 193440,
            doom                        = 603,
            grimoireFelguard            = 111898,
            handOfGuldan                = 105174,
            implosion                   = 196277,
            shadowbolt                  = 686,
            shadowflame                 = 205181,
            summonDarkglare             = 205180,
            summonFelguard              = 30146,
            thalkielsConsumption        = 211714,
        }
        self.spell.spec.artifacts       = {
            thalkielsConsumption        = 211714,
        }
        self.spell.spec.buffs           = {
            demonicCalling              = 205146,
            demonicEmpowerment          = 193396,
            demonwrath                  = 193440,
        }
        self.spell.spec.debuffs         = {
            doom                        = 603,
            shadowflame                 = 205181,
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            demonbolt                   = 157695,
            grimoireOfSynergy           = 171975,
            handOfDoom                  = 196283,
            implosion                   = 196277,
            shadowflame                 = 205181,
            summonDarkglare             = 205180,
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
            self.getPetInfo()

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
            self.enemies.yards10 = getEnemies("target", 10)
            self.enemies.yards40 = getEnemies("player", 40)
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
            local getBuffRemain = getBuffRemain
            local getBuffDuration = getBuffDuration
            local getBuffStacks = getBuffStacks

            for k,v in pairs(self.spell.spec.buffs) do
                self.buff[k]            = UnitBuffID("player",v) ~= nil
                self.buff.pet[k]        = UnitBuffID("pet",v) ~= nil
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
            local getDebuffStacks = getDebuffStacks

            for k,v in pairs(self.spell.spec.debuffs) do
                if k ~= "bleeds" then
                    self.debuff[k]          = UnitDebuffID("target",v,"player") ~= nil
                    self.debuff.duration[k] = getDebuffDuration("target",v,"player") or 0
                    self.debuff.remain[k]   = getDebuffRemain("target",v,"player") or 0
                    self.debuff.refresh[k]  = (self.debuff.remain[k] < self.debuff.duration[k] * 0.3) or self.debuff.remain[k] == 0
                    self.debuff.stack[k]    = getDebuffStacks("target",v,"player") or 0
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

    ----------------
    --- PET INFO ---
    ----------------
        function self.getPetInfo()
            self.petInfo = {}
            for i = 1, ObjectCount() do
                -- define our unit
                --local thisUnit = GetObjectIndex(i)
                local thisUnit = GetObjectWithIndex(i)
                -- check if it a unit first
                if ObjectIsType(thisUnit, ObjectTypes.Unit)  then
                    local unitName      = UnitName(thisUnit)
                    local unitID        = ObjectID(thisUnit)
                    local unitGUID      = UnitGUID(thisUnit)
                    local unitCreator   = UnitCreator(thisUnit)
                    local player        = GetObjectWithGUID(UnitGUID("player"))
                    if unitCreator == player and (unitID == 55659 or unitID == 98035 or unitID == 103673 or unitID == 11859 or unitID == 89 
                        or unitID == 416 or unitID == 1860 or unitID == 417 or unitID == 1863 or unitID == 17252) 
                    then
                        local demoEmpBuff   = UnitBuffID(thisUnit,self.spell.demonicEmpowerment) ~= nil
                        local unitCount     = #getEnemies(tostring(thisUnit),10) or 0
                        tinsert(self.petInfo,{name = unitName, guid = unitGUID, id = unitID, creator = unitCreator, deBuff = demoEmpBuff, numEnemies = unitCount})
                    end
                end
            end
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

            self.cast.debug.callDreadstalkers        = self.cast.callDreadstalkers("target",true)
            self.cast.debug.commandDemon             = self.cast.commandDemon("player",true)
            self.cast.debug.demonbolt                = self.cast.demonbolt("target",true)
            self.cast.debug.demonicEmpowerment       = self.cast.demonicEmpowerment("player",true)
            self.cast.debug.demonwrath               = self.cast.demonwrath("player",true)
            self.cast.debug.doom                     = self.cast.doom("target",true)
            self.cast.debug.grimoireFelguard         = self.cast.grimoireFelguard("player",true)
            self.cast.debug.handOfGuldan             = self.cast.handOfGuldan("target",true)
            self.cast.debug.implosion                = self.cast.implosion("target",true)
            self.cast.debug.shadowbolt               = self.cast.shadowbolt("target",true)
            self.cast.debug.shadowflame              = self.cast.shadowflame("target",true)
            self.cast.debug.summonDarkglare          = self.cast.summonDarkglare("player",true)
            self.cast.debug.summonFelguard           = self.cast.summonFelguard("player",true)
            self.cast.debug.thalkielsConsumption     = self.cast.thalkielsConsumption("target",true)
        end
        
        -- Call Dreadstalkers
        function self.cast.callDreadstalkers(thisUnit,debug)
            local spellCast = self.spell.callDreadstalkers
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 14 and self.shards >= 2 and self.cd.callDreadstalkers == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Command Demon
        function self.cast.commandDemon(thisUnit,debug)
            local spellCast = self.spell.commandDemon
            local thisUnit = thisUnit
            local currentPet = self.petId
            if thisUnit == nil then thisUnit = "pet" end
            if debug == nil then debug = false end

            if self.level >= 31 and self.cd.commandDemon == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Demonbolt
        function self.cast.demonbolt(thisUnit,debug)
            local spellCast = self.spell.demonbolt
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.demonbolt and self.powerPercentMana > 4.8 and self.cd.demonbolt and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Demonic Empowerment
        function self.cast.demonicEmpowerment(thisUnit,debug)
            local spellCast = self.spell.demonicEmpowerment
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 12 and self.powerPercentMana > 6 and self.cd.demonicEmpowerment then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Demonwrath
        function self.cast.demonwrath(thisUnit,debug)
            local spellCast = self.spell.demonwrath
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 36 and self.powerPercentMana > 2.5 and self.cd.demonwrath and not castingUnit("player") then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Doom
        function self.cast.doom(thisUnit,debug)
            local spellCast = self.spell.doom
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 26 and self.powerPercentMana > 2 and self.cd.doom and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Grimoire: Felguard
        function self.cast.grimoireFelguard(thisUnit,debug)
            local spellCast = self.spell.grimoireFelguard
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.grimoireOfService and self.shards > 0 and self.cd.grimoireFelguard == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Hand of Guldan
        function self.cast.handOfGuldan(thisUnit,debug)
            local spellCast = self.spell.handOfGuldan
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 10 and self.shards > 0 and self.cd.handOfGuldan == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Implosion
        function self.cast.implosion(thisUnit,debug)
            local spellCast = self.spell.handOfGuldan
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.implosion and self.powerPercentMana > 6 and self.cd.implosion == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Shadowbolt
        function self.cast.shadowbolt(thisUnit,debug)
            local spellCast = self.spell.shadowbolt
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if not self.talent.demonbolt and self.powerPercentMana > 6 and self.cd.shadowbolt == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Shadowflame
        function self.cast.shadowflame(thisUnit,debug)
            local spellCast = self.spell.shadowflame
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.shadowflame and self.cd.shadowflame == 0 and self.charges.shadowflame > 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Summon Darkglare
        function self.cast.summonDarkglare(thisUnit,debug)
            local spellCast = self.spell.summonDarkglare
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.summonDarkglare and self.shards > 0 and self.cd.summonDarkglare == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Summon Felguard
        function self.cast.summonFelguard(thisUnit,debug)
            local spellCast = self.spell.summonFelguard
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 40 and self.shards > 0 and self.cd.summonFelguard == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Thal'kiel's Consumption
        function self.cast.thalkielsConsumption(thisUnit,debug)
            local spellCast = self.spell.thalkielsConsumption
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.artifact.thalkielsConsumption and self.cd.thalkielsConsumption == 0 and getDistance(thisUnit) < 40 then
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
    end-- cDemonology
end-- select Warlock