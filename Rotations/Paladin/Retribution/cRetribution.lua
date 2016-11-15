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
        -- self.charges.frac               = {}        -- Fractional Charge
        -- self.charges.max                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            avengingWrath               = 31884,
            bladeOfJustice              = 184575,
            cleanseToxins               = 213644,
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
            templarsVerdict             = 85256,
            wakeOfAshes                 = 205273,
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
            divinePurpose               = 223819,
            theFiresOfJustice           = 209785,
            whisperOfTheNathrezim       = 207635,
        }
        self.spell.spec.debuffs         = {

        }
        self.spell.spec.glyphs          = {
            glyphOfWingedVengeance      = 57979,
        }
        self.spell.spec.talents         = {
            bladeOfWrath                = 231832,
            consecration                = 205228,
            crusade                     = 231895,
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
            -- self.getArtifacts()
            -- self.getArtifactRanks()
            -- self.getGlyphs()
            -- self.getTalents()
            -- self.getPerks() --Removed in Legion
        end

    --------------
    --- UPDATE ---
    --------------

        function self.update()

            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            cFileBuild("spec",self)
            -- self.getBuffs()
            -- self.getCastable()
            -- self.getCharge()
            -- self.getCooldowns()
            -- self.getDynamicUnits()
            -- self.getDebuffs()
            -- self.getEnemies()
            -- self.getToggleModes()
            -- self.getCastable()

            -- Start selected rotation
            self:startRotation()
        end

    -- ---------------------
    -- --- DYNAMIC UNITS ---
    -- ---------------------

    --     function self.getDynamicUnits()
    --         local dynamicTarget = dynamicTarget

    --         -- Normal
    --         self.units.dyn12 = dynamicTarget(12,true) -- Hammer of Justice
    --         -- AoE

    --     end

    -- ---------------
    -- --- ENEMIES ---
    -- ---------------

    --     function self.getEnemies()
    --         local getEnemies = getEnemies

    --         self.enemies.yards5     = getEnemies("player", 5) -- Melee
    --     end

    -- -----------------
    -- --- ARTIFACTS ---
    -- -----------------

    --     function self.getArtifacts()
    --         local isKnown = isKnown

    --         for k,v in pairs(self.spell.spec.artifacts) do
    --             self.artifact[k] = isKnown(v) or false
    --         end
    --     end

    --     function self.getArtifactRanks()

    --     end
       
    -- -------------
    -- --- BUFFS ---
    -- -------------

    --     function self.getBuffs()
    --         local UnitBuffID = UnitBuffID
    --         local getBuffDuration = getBuffDuration
    --         local getBuffRemain = getBuffRemain

    --         for k,v in pairs(self.spell.spec.buffs) do
    --             self.buff[k]            = UnitBuffID("player",v) ~= nil
    --             self.buff.duration[k]   = getBuffDuration("player",v) or 0
    --             self.buff.remain[k]     = getBuffRemain("player",v) or 0
    --         end
    --     end

    -- ---------------
    -- --- CHARGES ---
    -- ---------------

    --     function self.getCharge()
    --         local getCharges = getCharges
    --         local getChargesFrac = getChargesFrac
    --         local getBuffStacks = getBuffStacks
    --         local getRecharge = getRecharge

    --         for k,v in pairs(self.spell.spec.abilities) do
    --             self.charges[k]     = getCharges(v)
    --             self.charges.frac[k]= getChargesFrac(v)
    --             self.charges.max[k] = getChargesFrac(v,true)
    --             self.recharge[k]    = getRecharge(v)
    --         end
    --     end

    -- ---------------
    -- --- DEBUFFS ---
    -- ---------------
    --     function self.getDebuffs()
    --         local UnitDebuffID = UnitDebuffID
    --         local getDebuffDuration = getDebuffDuration
    --         local getDebuffRemain = getDebuffRemain

    --         for k,v in pairs(self.spell.spec.debuffs) do
    --             self.debuff[k]          = UnitDebuffID(self.units.dyn5,v,"player") ~= nil
    --             self.debuff.duration[k] = getDebuffDuration(self.units.dyn5,v,"player") or 0
    --             self.debuff.remain[k]   = getDebuffRemain(self.units.dyn5,v,"player") or 0
    --             self.debuff.refresh[k]  = (self.debuff.remain[k] < self.debuff.duration[k] * 0.3) or self.debuff.remain[k] == 0
    --         end
    --     end
        
    -- -----------------
    -- --- COOLDOWNS ---
    -- -----------------

    --     function self.getCooldowns()
    --         local getSpellCD = getSpellCD

    --         for k,v in pairs(self.spell.spec.abilities) do
    --             if getSpellCD(v) ~= nil then
    --                 self.cd[k] = getSpellCD(v)
    --             end
    --         end
    --     end

    -- --------------
    -- --- GLYPHS ---
    -- --------------

    --     function self.getGlyphs()
    --         local hasGlyph = hasGlyph

    --     end

    -- ---------------
    -- --- TALENTS ---
    -- ---------------

    --     function self.getTalents()
    --         local getTalent = getTalent

    --         for r = 1, 7 do --search each talent row
    --             for c = 1, 3 do -- search each talent column
    --                 local talentID = select(6,GetTalentInfo(r,c,GetActiveSpecGroup())) -- ID of Talent at current Row and Column
    --                 for k,v in pairs(self.spell.spec.talents) do
    --                     if v == talentID then
    --                         self.talent[k] = getTalent(r,c)
    --                     end
    --                 end
    --             end
    --         end
    --     end

    -- -------------
    -- --- PERKS ---
    -- -------------

    --     function self.getPerks()
    --         local isKnown = isKnown

    --     end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes()

        end

        -- Create the toggle defined within rotation files
        function self.createToggles()
            GarbageButtons()
            if self.rotations[br.selectedProfile] ~= nil then
                self.rotations[br.selectedProfile].toggles()
            else
                return
            end
        end

    ---------------
    --- OPTIONS ---
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

    -- --------------
    -- --- SPELLS ---
    -- --------------

    --     function self.getCastable()
    --         self.cast.debug.avengingWrath           = self.cast.avengingWrath("player",true)
    --         self.cast.debug.bladeOfJustice          = self.cast.bladeOfJustice("target",true)
    --         self.cast.debug.bladeOfWrath            = self.cast.bladeOfWrath("target",true)
    --         self.cast.debug.blessingOfFreedom       = self.cast.blessingOfFreedom("player",true)
    --         self.cast.debug.blessingOfProtection    = self.cast.blessingOfProtection("player",true)
    --         self.cast.debug.cleanseToxins           = self.cast.cleanseToxins("player",true)
    --         self.cast.debug.consecration            = self.cast.consecration("player",true)
    --         self.cast.debug.crusade                 = self.cast.crusade("player",true)
    --         self.cast.debug.divineHammer            = self.cast.divineHammer("player",true)
    --         self.cast.debug.divineStorm             = self.cast.divineStorm("player",true)
    --         self.cast.debug.executionSentence       = self.cast.executionSentence("target",true)
    --         self.cast.debug.eyeForAnEye             = self.cast.eyeForAnEye("player",true)
    --         self.cast.debug.greaterBlessingOfKings  = self.cast.greaterBlessingOfKings("player",true)
    --         self.cast.debug.greaterBlessingOfMight  = self.cast.greaterBlessingOfMight("player",true)
    --         self.cast.debug.greaterBlessingOfWisdom = self.cast.greaterBlessingOfWisdom("player",true)
    --         self.cast.debug.handOfHinderance        = self.cast.handOfHinderance("target",true)
    --         self.cast.debug.holyWrath               = self.cast.holyWrath("player",true)
    --         self.cast.debug.justicarsVengeance      = self.cast.justicarsVengeance("target",true)
    --         self.cast.debug.rebuke                  = self.cast.rebuke("target",true)
    --         self.cast.debug.sealOfLight             = self.cast.sealOfLight("player",true)
    --         self.cast.debug.shieldOfVengeance       = self.cast.shieldOfVengeance("player",true)
    --         self.cast.debug.templarsVerdict         = self.cast.templarsVerdict("target",true)
    --         self.cast.debug.wakeOfAshes             = self.cast.wakeOfAshes("player",true)
    --         self.cast.debug.wordOfGlory             = self.cast.wordOfGlory("player",true)
    --         self.cast.debug.zeal                    = self.cast.zeal("target",true)
    --     end

    --     function self.cast.avengingWrath(thisUnit,debug)
    --         local spellCast = self.spell.avengingWrath
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.level >= 72 and self.cd.avengingWrath == 0 and not self.talent.crusade then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.bladeOfJustice(thisUnit,debug)
    --         local spellCast = self.spell.bladeOfJustice
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = self.units.dyn12 end
    --         if debug == nil then debug = false end

    --         if self.level >= 16 and self.cd.bladeOfJustice == 0 and getDistance(thisUnit) < 12 and not self.talent.divineHammer then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.bladeOfWrath(thisUnit,debug)
    --         local spellCast = self.spell.bladeOfWrath
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = self.units.dyn12 end
    --         if debug == nil then debug = false end

    --         if self.talent.bladeOfWrath and self.cd.bladeOfWrath == 0 and getDistance(thisUnit) < 12 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.blessingOfFreedom(thisUnit,debug)
    --         local spellCast = self.spell.blessingOfFreedom
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.level >= 52 and self.powerPercentMana > 15 and self.cd.blessingOfFreedom == 0 and getDistance(thisUnit) < 40 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.blessingOfProtection(thisUnit,debug)
    --         local spellCast = self.spell.blessingOfProtection
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.level >= 48 and self.powerPercentMana > 15 and self.cd.blessingOfProtection == 0 and getDistance(thisUnit) < 40 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.cleanseToxins(thisUnit,debug)
    --         local spellCast = self.spell.cleanseToxins
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.level >= 21 and self.powerPercentMana > 13 and self.cd.cleanseToxins == 0 and canDispel(thisUnit,spellCast) and getDistance(thisUnit) < 40 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.consecration(thisUnit,debug)
    --         local spellCast = self.spell.consecration
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.talent.consecration and self.cd.consecration == 0 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.crusade(thisUnit,debug)
    --         local spellCast = self.spell.crusade
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.talent.crusade and self.cd.crusade == 0 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.divineHammer(thisUnit,debug)
    --         local spellCast = self.spell.divineHammer
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.talent.divineHammer and self.cd.divineHammer == 0 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.divineStorm(thisUnit,debug)
    --         local spellCast = self.spell.divineStorm
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.level >= 32 and (self.holyPower >= 3 or (self.holyPower >= 2 and self.buff.theFiresOfJustice)) then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.executionSentence(thisUnit,debug)
    --         local spellCast = self.spell.executionSentence
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = self.units.dyn20 end
    --         if debug == nil then debug = false end

    --         if self.talent.executionSentence and (self.holyPower >= 3 or (self.holyPower >= 2 and self.buff.theFiresOfJustice)) and self.cd.executionSentence == 0 and getDistance(thisUnit) < 20 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.eyeForAnEye(thisUnit,debug)
    --         local spellCast = self.spell.eye
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.talent.eyeForAnEye and self.cd.eyeForAnEye == 0 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.greaterBlessingOfKings(thisUnit,debug)
    --         local spellCast = self.spell.greaterBlessingOfKings
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.level >= 44 and not self.buff.greaterBlessingOfKings and getDistance(thisUnit) < 30 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.greaterBlessingOfMight(thisUnit,debug)
    --         local spellCast = self.spell.greaterBlessingOfMight
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.level >= 42 and not self.buff.greaterBlessingOfMight and getDistance(thisUnit) < 30 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.greaterBlessingOfWisdom(thisUnit,debug)
    --         local spellCast = self.spell.greaterBlessingOfWisdom
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.level >= 46 and not self.buff.greaterBlessingOfWisdom and getDistance(thisUnit) < 30 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.handOfHinderance(thisUnit,debug)
    --         local spellCast = self.spell.handOfHinderance
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = self.units.dyn30 end
    --         if debug == nil then debug = false end

    --         if self.level >= 26 and self.powerPercentMana >= 27 and self.cd.handOfHinderance == 0 and getDistance(thisUnit) < 30 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.holyWrath(thisUnit,debug)
    --         local spellCast = self.spell.holyWrath
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.talent.holyWrath and self.cd.holyWrath == 0 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.justicarsVengeance(thisUnit,debug)
    --         local spellCast = self.spell.justicarsVengeance
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = self.units.dyn5 end
    --         if debug == nil then debug = false end

    --         if self.talent.justicarsVengeance and (self.holyPower >= 5 or (self.holyPower >= 4 and self.buff.theFiresOfJustice)) and getDistance(thisUnit) < 5 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.rebuke(thisUnit,debug)
    --         local spellCast = self.spell.rebuke
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = self.units.dyn5 end
    --         if debug == nil then debug = false end

    --         if self.level >= 36 and self.cd.rebuke == 0 and getDistance(thisUnit) < 5 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.sealOfLight(thisUnit,debug)
    --         local spellCast = self.spell.sealOfLight
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.talent.sealOfLight and (self.holyPower > 0 or self.buff.theFiresOfJustice) and not self.buff.sealOfLight == 0 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.shieldOfVengeance(thisUnit,debug)
    --         local spellCast = self.spell.shieldOfVengeance
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.level >= 24 and self.cd.shieldOfVengeance == 0 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.templarsVerdict(thisUnit,debug)
    --         local spellCast = self.spell.templarsVerdict
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = self.units.dyn5 end
    --         if debug == nil then debug = false end

    --         if self.level >= 10 and (self.holyPower >= 3 or (self.holyPower >= 2 and self.buff.theFiresOfJustice)) and getDistance(thisUnit) < 5 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.wakeOfAshes(thisUnit,debug)
    --         local spellCast = self.spell.wakeOfAshes
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.artifact.wakeOfAshes and self.cd.wakeOfAshes == 0 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.wordOfGlory(thisUnit,debug)
    --         local spellCast = self.spell.wordOfGlory
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = "player" end
    --         if debug == nil then debug = false end

    --         if self.talent.wordOfGlory and (self.holyPower >= 3 or (self.holyPower >= 2 and self.buff.theFiresOfJustice)) and self.cd.wordOfGlory == 0 and self.charges.wordOfGlory > 0 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end
    --     function self.cast.zeal(thisUnit,debug)
    --         local spellCast = self.spell.zeal
    --         local thisUnit = thisUnit
    --         if thisUnit == nil then thisUnit = self.units.dyn5 end
    --         if debug == nil then debug = false end

    --         if self.talent.zeal and self.cd.zeal == 0 and self.charges.zeal > 0 and getDistance(thisUnit) < 5 then
    --             if debug then
    --                 return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
    --             else
    --                 return castSpell(thisUnit,spellCast,false,false,false)
    --             end
    --         elseif debug then
    --             return false
    --         end
    --     end


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