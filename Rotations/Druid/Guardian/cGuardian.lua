--- Guardian Class
-- Inherit from: ../cCharacter.lua and ../cDruid.lua
cGuardian = {}
cGuardian.rotations = {}

-- Creates Guardian Druid
function cGuardian:new()
    if GetSpecializationInfo(GetSpecialization()) == 104 then
        local self = cDruid:new("Guardian")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cGuardian.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------

        self.charges.frac               = {}        -- Fractional Charge
        self.charges.max                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            barkskin                    = 22812,
            bristlingFur                = 155835,
            frenziedRegeneration        = 22842,
            incapacitatingRoar          = 99,
            incarnationGuardianOfUrsoc  = 102558,
            ironfur                     = 192081,
            lunarBeam                   = 204066,
            mangle                      = 33917,
            markOfUrsoc                 = 192083,
            maul                        = 6807,
            pulverize                   = 80313,
            removeCorruption            = 2782,
            skullBash                   = 106839,
            stampedingRoar              = 106898,
            survivalInstincts           = 61336,
            swipe                       = 213764,
            thrash                      = 106832,
        }
        self.spell.spec.artifacts       = {

        }
        self.spell.spec.buffs           = {
            ironfur                     = 192081,
            pulverize                   = 158792,
        }
        self.spell.spec.debuffs         = {

        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            balanceAffinity             = 197488,
            bloodFrenzy                 = 203962,
            brambles                    = 203953,
            bristlingFur                = 155835,
            earthwarden                 = 203974,
            feralAffinity               = 202155,
            galacticGuardian            = 203964,
            guardianOfElune             = 155578,
            gutteralRoars               = 204012,
            incarnationGuardianOfUrsoc  = 102558,
            lunarBeam                   = 204066,
            pulverize                   = 80313,
            rendAndTear                 = 204053,
            restorationAffinity         = 197492,
            soulOfTheForest             = 158477,
            survivalOfTheFittest        = 203965,
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

            -- Normal
            self.units.dyn8     = dynamicTarget(8, true) -- Swipe
            self.units.dyn13    = dynamicTarget(13, true) -- Skull Bash

            -- AoE
            self.units.dyn8AoE  = dynamicTarget(8, false) -- Thrash
            self.units.dyn20AoE = dynamicTarget(20, false) --Prowl
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = getEnemies("player", 5) -- Melee
            self.enemies.yards8     = getEnemies("player", 8) -- Swipe/Thrash
            self.enemies.yards13    = getEnemies("player", 13) -- Skull Bash
            self.enemies.yards20    = getEnemies("player", 20) --Prowl
            self.enemies.yards40    = getEnemies("player", 40) --Moonfire
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
            self.mode.cleave    = bb.data["Cleave"]
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

            self.cast.debug.barkskin                    = self.cast.barkskin("player",true)
            self.cast.debug.bristlingFur                = self.cast.bristlingFur("player",true)
            self.cast.debug.frenziedRegeneration        = self.cast.frenziedRegeneration("player",true)
            self.cast.debug.incapacitatingRoar          = self.cast.incapacitatingRoar("player",true)
            self.cast.debug.incarnationGuardianOfUrsoc  = self.cast.incarnationGuardianOfUrsoc("player",true)
            self.cast.debug.ironfur                     = self.cast.ironfur("player",true)
            self.cast.debug.lunarBeam                   = self.cast.lunarBeam("target",true)
            self.cast.debug.markOfUrsoc                 = self.cast.markOfUrsoc("player",true)
            self.cast.debug.maul                        = self.cast.maul("target",true)
            self.cast.debug.pulverize                   = self.cast.pulverize("target",true)
            self.cast.debug.removeCorruption            = self.cast.removeCorruption("player",true)
            self.cast.debug.skullBash                   = self.cast.skullBash("target",true)
            self.cast.debug.stampedingRoar              = self.cast.stampedingRoar("player",true)
            self.cast.debug.survivalInstincts           = self.cast.survivalInstincts("player",true)
            self.cast.debug.swipe                       = self.cast.swipe("player",true)
            self.cast.debug.trash                       = self.cast.thrash("player",true)
        end

        -- Barkskin
        function self.cast.barkskin(thisUnit,debug)
            local spellCast = self.spell.barkskin
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 26 and self.cd.barkskin == 0 then
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

        function useCleave()
            if self.mode.cleave==1 and self.mode.rotation < 3 then
                return true
            else
                return false
            end
        end

        function useProwl()
            if self.mode.prowl==1 then
                return true
            else
                return false
            end
        end

        function outOfWater()
            if swimTime == nil then swimTime = 0 end
            if outTime == nil then outTime = 0 end
            if IsSwimming() then
                swimTime = GetTime()
                outTime = 0
            end
            if not IsSwimming() then
                outTime = swimTime
                swimTime = 0
            end
            if outTime ~= 0 and swimTime == 0 then
                return true
            end
            if outTime ~= 0 and IsFlying() then
                outTime = 0
                return false
            end
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cGuardian
end-- select Druid