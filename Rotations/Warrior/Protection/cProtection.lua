--- Protection Class
-- Inherit from: ../cCharacter.lua and ../cWarrior.lua
cProtection = {}
cProtection.rotations = {}

-- Creates Protection Warrior
function cProtection:new()
    if GetSpecializationInfo(GetSpecialization()) == 73 then
        local self = cWarrior:new("Protection")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cProtection.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
        self.charges.frac               = {}        -- Fractional Charge
        self.charges.max                = {}        -- Max Charges
        self.spell.spec                 = {} 
        self.spell.spec.abilities       = { 

        }
        self.spell.spec.artifacts       = {

        }
        self.spell.spec.buffs           = {

        }
        self.spell.spec.debuffs         = {

        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {

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

        -- -- Ascendance
        -- function self.cast.ascendance(thisUnit,debug)
        --     local spellCast = self.spell.ascendance
        --     local thisUnit = thisUnit
        --     if thisUnit == nil then thisUnit = "player" end
        --     if debug == nil then debug = false end

        --     if self.talent.ascendance and self.cd.ascendance == 0 then
        --         if debug then
        --             return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
        --         else
        --             return castSpell(thisUnit,spellCast,false,false,false)
        --         end
        --     elseif debug then
        --         return false
        --     end
        -- end
       

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