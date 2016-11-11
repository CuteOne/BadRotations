--- Mistweaver Class
-- Inherit from: ../cCharacter.lua and ../cMonk.lua
cMistweaver = {}
cMistweaver.rotations = {}

-- Creates Mistweaver Monk
function cMistweaver:new()
    if GetSpecializationInfo(GetSpecialization()) == 270 then
        local self = cMonk:new("Mistweaver")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cMistweaver.rotations

    -----------------
    --- VARIABLES ---
    -----------------
        self.spell.spec             = {}
        self.spell.spec.abilities   = {
            blackoutKick = 100784,
            chiBurst = 123986,
            cracklingJadeLightning = 117952,
            detox = 115450,
            diffuseMagic = 122783,
            effuse = 116694,
            envelopingMist = 124682,
            essenceFont = 191837,
            healingElixir = 122281,
            invokeChiJi = 198664,
            lifeCocoon = 116849,
            manaTea = 197908,
            paralysis = 115078,
            provoke = 115546,
            reawaken = 212051,
            refreshingJadeWind = 196725,
            renewingMist = 115151,
            resuscitate = 115178,
            revival = 115310,
            ringOfPeace = 116844,
            risingSunKick = 107428,
            roll = 109132,
            sheilunsGift = 205406,
            spiningCraneKick = 101546,
            thunderFocusTea = 116680,
            tigerPalm = 100780,
            tigersLust = 116841,
            vivify = 116670

        }
        self.spell.spec.artifacts   = {

        }
        self.spell.spec.buffs       = {
            sheilunsGift = 205406,
            upliftingTrance = 197206
        }
        self.spell.spec.debuffs     = {

        }
        self.spell.spec.glyphs      = {

        }
        self.spell.spec.talents     = {
            chiBurst = 123986,
            zenPulse = 124081,
            mistwalk = 197945,
            chiTorpedo = 115008,
            tigersLust = 116841,
            celerity = 115173,
            lifecycles = 197915,
            spiritOfTheCrane = 210802,
            mistWwrap = 197900,
            ringOfPeace = 116844,
            songOfChiJi = 1988898,
            legSweep = 119381,
            healingElixir = 122281,
            diffuseMagic = 122783,
            dampenHarm = 122278,
            refreshingJadeWind = 196725,
            invokeChiJi = 198664,
            summonJadeSerpentStatue = 115313,
            manaTea = 197908,
            focusedThunder = 197895,
            risingThunder = 210804
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

            self.mode.sef       = bb.data["SEF"]
            self.mode.fsk       = bb.data["FSK"]
        end

    ---------------
    --- OPTIONS ---
    ---------------

        -- Create the toggle defined within rotation files
        function self.createToggles()
            GarbageButtons()
            self.rotations[bb.selectedProfile].toggles()
        end

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
            local profileTable = self.rotations[bb.selectedProfile].options()

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
            for k,v in pairs(self.spell.spec.abilities) do
                local spellCast = v
                local spellName = GetSpellInfo(v)
                if IsHarmfulSpell(spellName) then
                    self.cast.debug[k] = self.cast[k]("target",true)
                else
                    self.cast.debug[k] = self.cast[k]("player",true)
                end
            end
        end

        for k,v in pairs(self.spell.spec.abilities) do
            self.cast[k] = function(thisUnit,debug,minUnits,effectRng)
                local spellCast = v
                local spellName = GetSpellInfo(v)
                if thisUnit == nil then
                    if IsHarmfulSpell(spellName) then thisUnit = "target" end
                    if IsHelpfulSpell(spellName) then thisUnit = "player" end
                end
                if SpellHasRange(spellName) then
                    if IsSpellInRange(spellName,thisUnit) == 0 then
                        amIinRange = false 
                    else
                        amIinRange = true
                    end
                else
                    amIinRange = true
                end
                local minRange = select(5,GetSpellInfo(spellName))
                local maxRange = select(6,GetSpellInfo(spellName))
                if minUnits == nil then minUnits = 1 end
                if effectRng == nil then effectRng = 8 end
                if debug == nil then debug = false end
                if IsUsableSpell(v) and getSpellCD(v) == 0 and isKnown(v) and amIinRange then
                    if debug then
                        return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                    else
                        if IsHarmfulSpell(spellName) or IsHelpfulSpell(spellName) then
                            return castSpell(thisUnit,spellCast,false,false,false)
                        else
                            if thisUnit ~= "player" then
                                return castGround(thisUnit,spellCast,maxRange,minRange)
                            else
                                return castGroundAtBestLocation(spellCast,effectRng,minUnits,maxRange,minRange)
                            end
                        end
                    end
                elseif debug then
                    return false
                end
            end
        end
        

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
    end-- cMistweaver
end-- select Monk