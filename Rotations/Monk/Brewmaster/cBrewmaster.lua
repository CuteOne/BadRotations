--- Brewmaster Class
-- Inherit from: ../cCharacter.lua and ../cMonk.lua
cBrewmaster = {}
cBrewmaster.rotations = {}

-- Creates Brewmaster Monk
function cBrewmaster:new()
    if GetSpecializationInfo(GetSpecialization()) == 268 then
        local self = cMonk:new("Brewmaster")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cBrewmaster.rotations

    -----------------
    --- VARIABLES ---
    -----------------
        self.spell.spec             = {}
        self.spell.spec.abilities   = {

        }
        self.spell.spec.artifacts   = {

        }
        self.spell.spec.buffs       = {

        }
        self.spell.spec.debuffs     = {

        }
        self.spell.spec.glyphs      = {

        }
        self.spell.spec.talents     = {

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
            self.getPerks()
            self.getTalents()
        end

    --------------
    --- UPDATE ---
    --------------

        function self.update()
            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end

            self.getBuffs()
            self.getCharges()
            self.getDynamicUnits()
            self.getDebuffs()
            self.getCooldowns()
            self.getEnemies()
            self.getCastable()
            self.getToggleModes()
            self.getRotation()

            -- Start selected rotation
            self:startRotation()
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
            local getBuffDuration = getBuffDuration
            local getBuffRemain = getBuffRemain
            local getBuffStacks = getBuffStacks

            for k,v in pairs(self.spell.spec.buffs) do
                self.buff[k]            = UnitBuffID("player",v) ~= nil
                self.buff.duration[k]   = getBuffDuration("player",v) or 0
                self.buff.remain[k]     = getBuffRemain("player",v) or 0
                self.buff.stacks[k]     = getBuffStacks("player",v) or 0
            end
        end

    ---------------
    --- CHARGES ---
    ---------------

        function self.getCharges()

            for k,v in pairs(self.spell.spec.abilities) do
                self.charges[k] = getCharges(v) or 0
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
                self.debuff[k]          = UnitDebuffID(self.units.dyn5,v,"player") ~= nil
                self.debuff.duration[k] = getDebuffDuration(self.units.dyn5,v,"player") or 0
                self.debuff.remain[k]   = getDebuffRemain(self.units.dyn5,v,"player") or 0
                self.debuff.refresh[k]  = (self.debuff.remain[k] < self.debuff.duration[k] * 0.3) or self.debuff.remain[k] == 0
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

    --------------
    --- GLYPHS ---
    --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            -- self.glyph.catForm           = hasGlyph(self.spell.catFormGlyph))
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

            -- self.perk.enhancedBerserk        = isKnown(self.spell.enhancedBerserk)
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn8     = dynamicTarget(8, true)
            self.units.dyn15    = dynamicTarget(15, true)
            self.units.dyn20    = dynamicTarget(20, true)
            self.units.dyn25    = dynamicTarget(25, true)

            -- AoE
            self.units.dyn8AoE  = dynamicTarget(8,false)
            self.units.dyn20AoE = dynamicTarget(20,false)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = getEnemies("player", 5)
            self.enemies.yards8     = getEnemies("player", 8)
            self.enemies.yards12    = getEnemies("player", 12)
            self.enemies.yards25    = getEnemies("player", 25)
            self.enemies.yards40    = getEnemies("player", 40)
        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes()

            self.mode.sef       = br.data["SEF"]
            self.mode.fsk       = br.data["FSK"]
        end

    ---------------
    --- OPTIONS ---
    ---------------

        -- Create the toggle defined within rotation files
        function self.createToggles()
            GarbageButtons()
            self.rotations[br.selectedProfile].toggles()
        end

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
            local profileTable = self.rotations[br.selectedProfile].options()

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

        -- -- Chi Wave
        -- function self.cast.chiWave(thisUnit,debug)
        --     local spellCast = self.spell.chiWave
        --     local thisUnit = thisUnit
        --     if thisUnit == nil then thisUnit = "player" end
        --     if debug == nil then debug = false end

        --     if self.talent.chiWave and self.cd.chiWave == 0 then
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


        function getOption(spellID)
            return tostring(select(1,GetSpellInfo(spellID)))
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- self.createOptions()
        -- Return
        return self
    end-- cBrewmaster
end-- select Monk