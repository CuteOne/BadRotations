--- Assassination Class
-- Inherit from: ../cCharacter.lua and ../cPaladin.lua
cRetribution = {}
cRetribution.rotations = {}

-- Creates Retribution Paladin
function cRetribution:new()
    if GetSpecializationInfo(GetSpecialization()) == 70 then
        local self = cPaladin:new("Retribution")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cRetribution.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            avengingWrath               = 31884,
            bladeOfJustice              = 184575,
            bladeOfWrath                = 202270,
            cleanceToxins               = 213644,
            consecration                = 205228,
            crusade                     = 224668,
            divineHammer                = 198034,
            divineStorm                 = 53385,
            executionSentence           = 213757,
            eyeForAnEye                 = 205191,
            greaterBlessingOfKings      = 203538,
            greaterBlessingOfMight      = 203528,
            greaterBlessingOfWisdom     = 203539,
            handOfHinderance            = 183218,
            holyWrath                   = 210220,
            justicarsVengeance          = 215661,
            rebuke                      = 96231,
            sealOfLight                 = 202273,
            shieldOfVengeance           = 184662,
            swordOfLight                = 53503,
            templarsVerdict             = 85256,
            wordOfGlory                 = 210191,
            zeal                        = 217020,
        }
        self.spell.spec.artifacts       = {
            ashbringersLight            = 207604,
            ashesToAshes                = 179546,
            bladeOfLight                = 214081,
            deflection                  = 184778,
            deliverTheJustice           = 186927,
            divineTempest               = 186773,
            echoOfTheHighlord           = 186788,
            embraceTheLight             = 186934,
            endlessResolve              = 185086,
            healingStorm                = 193058,
            highlordsJudgment           = 186941,
            mightOfTheTemplar           = 185368,
            protectorOfTheAshenBlade    = 186944,
            righteousBlade              = 184843,
            sharpenedEdge               = 184759,
            unbreakableWill             = 182234,
            wakeOfAshes                 = 205273,
            wrathOfTheAshbringer        = 186945,
        }
        self.spell.spec.buffs           = {

        }
        self.spell.spec.debuffs         = {

        }
        self.spell.spec.glyphs          = {
            glyphOfWingedVengeance      = 57979,
        }
        self.spell.spec.talents         = {
            bladeOfWrath                = 202270,
            consecration                = 205228,
            crusade                     = 224668,
            divineHammer                = 198034,
            divineIntervention          = 213313,
            executionSentence           = 213757,
            eyeForAnEye                 = 205191,
            finalVerdict                = 198038,
            greaterJudgment             = 218178,
            holyWrath                   = 210220,
            justicarsVengeance          = 215661,
            sealOfLight                 = 202273,
            theFiresOfJustice           = 203316,
            virtuesBlade                = 202271,
            wordOfGlory                 = 210191,
            zeal                        = 217020,
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
            self.getBuffs()
            self.getCastable()
            self.getCharge()
            self.getCooldowns()
            self.getDynamicUnits()
            self.getDebuffs()
            self.getEnemies()
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

            -- AoE

        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = getEnemies("player", 5) -- Melee
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
            local UnitBuffID = UnitBuffID
            local getBuffDuration = getBuffDuration
            local getBuffRemain = getBuffRemain

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
                self.recharge[k]    = getRecharge(v)
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
            self.cast.debug.templarsVerdict = self.cast.templarsVerdict("target",true)
        end

        function self.cast.templarsVerdict(thisUnit,debug)
            local spellCast = self.spell.templarsVerdict
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 10 and self.holyPower >= 3 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    if castSpell(thisUnit,spellCast,false,false,false) then return end
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
    end-- cRetribution
end-- select Paladin