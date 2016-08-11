--- Assassination Class
-- Inherit from: ../cCharacter.lua and ../cRogue.lua
if select(2, UnitClass("player")) == "ROGUE" then
    cAssassination = {}
    cAssassination.rotations = {}

    -- Creates Assassination Rogue
    function cAssassination:new()
        local self = cRogue:new("Assassination")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cAssassination.rotations
        
        -----------------
        --- VARIABLES ---
        -----------------
        self.charges.frac       = {}        -- Fractional Charges
        self.trinket            = {}        -- Trinket Procs
        self.enemies            = {
            yards5,
            yards8,
            yards13,
            yards20,
            yards40,
        }
        self.assassinationArtifacts     = {
            assassinsBlades         = 214368,
            bagOfTricks             = 192657,
            balancedBlades          = 192326,
            bloodOfTheAssassinated  = 192923,
            fadeIntoShadows         = 192323,
            fromTheShadows          = 192428,
            gushingWound            = 192329,
            kingsbane               = 192759,
            masterAlchemist         = 192318,
            masterAssassin          = 192349,
            poisonKnives            = 192376,
            serratedEdge            = 192315,
            shadowSwiftness         = 192422,
            shadowWalker            = 192345,
            slayersPrecision        = 214928,
            surgeOfToxins           = 192424,
            toxicBlades             = 192310,
            urgeToKill              = 192384,
        }
        self.assassinationBuffs         = {
            deadlyPoisonBuff        = 2823,
            elaboratePlanningBuff   = 193641,
        }
        self.assassinationDebuffs       = {
            deadlyPoisonDebuff      = 2818,
            ruptureDebuff           = 1943,
        }
        self.assassinationSpecials      = {
            assassinsResolve        = 84601,
            cripplingPoison         = 3408,
            cutToTheChase           = 51667,
            deadlyPoison            = 2823,
            envenom                 = 32645,
            evasion                 = 5277,
            fanOfKnives             = 51723,
            garrote                 = 703,
            improvedPoisons         = 14117,
            kidneyShot              = 408,
            masteryPotentPoisons    = 76803,
            mutilate                = 1329,
            poisonedKnife           = 185565,
            rupture                 = 1943,
            sealFate                = 14190,
            shadowStep              = 36554,
            vendetta                = 79140,
            venomousWounds          = 79134,
            woundPoison             = 8679,
        }
        self.assassinationTalents       = {
            agonizingPoison         = 200802,
            elaboratePlanning       = 193640,
            exsanguinate            = 200806,
            hemorrhage              = 16511,
            internalBleeding        = 154904,
            leechingPoison          = 108211,
            masterPoisoner          = 196864,
            nightstalker            = 14062,
            shadowFocus             = 108209,
            subterfuge              = 108208,
            thuggee                 = 196861,
            venomRush               = 152152,            
        }
        -- Merge all spell tables into self.spell
        self.assassinationSpells = {}
        self.assassinationSpells = mergeTables(self.assassinationSpells,self.assassinationArtifacts)
        self.assassinationSpells = mergeTables(self.assassinationSpells,self.assassinationBuffs)
        self.assassinationSpells = mergeTables(self.assassinationSpells,self.assassinationDebuffs)
        self.assassinationSpells = mergeTables(self.assassinationSpells,self.assassinationSpecials)
        self.assassinationSpells = mergeTables(self.assassinationSpells,self.assassinationTalents)
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.rogueSpell, self.assassinationSpells)
        
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
            -- self.assassination_bleed_table()
            self.getBuffs()
            self.getBuffsDuration()
            self.getBuffsRemain()
            self.getCastable()
            self.getCharge()
            self.getCooldowns()
            self.getDynamicUnits()
            self.getDebuffs()
            self.getDebuffsDuration()
            self.getDebuffsRemain()
            self.getDebuffsRefresh()
            self.getTrinketProc()
            self.hasTrinketProc()
            self.getEnemies()
            self.getRecharges()
            self.getToggleModes()
            self.getCastable()


            -- Casting and GCD check
            -- TODO: -> does not use off-GCD stuff like pots, dp etc
            if castingUnit() then
                return
            end

            -- Start selected rotation
            self:startRotation()
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn8 = dynamicTarget(8, true) -- Swipe
            self.units.dyn13 = dynamicTarget(13, true) -- Skull Bash

            -- AoE
            self.units.dyn8AoE = dynamicTarget(8, false) -- Thrash
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getArtifacts()
            local isKnown = isKnown

            --self.artifact.ashamanesBite     = isKnown(self.spell.ashamanesBite)
        end

        function self.getArtifactRanks()

        end
       
    -------------
    --- BUFFS ---
    -------------

        function self.getBuffs()
            local UnitBuffID = UnitBuffID

            self.buff.deadlyPoison      = UnitBuffID("player",self.spell.deadlyPoisonBuff) ~= nil or false
            self.buff.elaboratePlanning = UnitBuffID("playe",self.spell.elaboratePlanningBuff) ~= nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            self.buff.duration.deadlyPoison         = getBuffDuration("player",self.spell.deadlyPoisonBuff) or 0
            self.buff.duration.elaboratePlanning    = getBuffDuration("player",self.spell.elaboratePlanningBuff) or 0 
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            self.buff.remain.deadlyPoison       = getBuffRemain("player",self.spell.deadlyPoisonBuff) or 0
            self.buff.remain.elaboratePlanning  = getBuffRemain("player",self.spell.elaboratePlanningBuff) or 0 
        end

        function self.getTrinketProc()
            local UnitBuffID = UnitBuffID

        end

        function self.hasTrinketProc()
            -- for i = 1, #self.trinket do
            --     if self.trinket[i]==true then return true else return false end
            -- end
        end

    ---------------
    --- DEBUFFS ---
    ---------------
        function self.getDebuffs()
            local UnitDebuffID = UnitDebuffID

            self.debuff.deadlyPoison = UnitDebuffID(self.units.dyn5,self.spell.deadlyPoisonDebuff,"player")~=nil or false
            self.debuff.rupture      = UnitDebuffID(self.units.dyn5,self.spell.ruptureDebuff,"player")~=nil or false
        end

        function self.getDebuffsDuration()
            local getDebuffDuration = getDebuffDuration

            self.debuff.duration.deadlyPoison = getDebuffDuration(self.units.dyn5,self.spell.deadlyPoisonDebuff,"player") or 0
            self.debuff.duration.rupture      = getDebuffDuration(self.units.dyn5,self.spell.ruptureDebuff,"player") or 0
        end

        function self.getDebuffsRemain()
            local getDebuffRemain = getDebuffRemain

            self.debuff.remain.deadlyPoison = getDebuffRemain(self.units.dyn5,self.spell.deadlyPoisonDebuff,"player") or 0
            self.debuff.remain.rupture      = getDebuffRemain(self.units.dyn5,self.spell.ruptureDebuff,"player") or 0
        end

        function self.getDebuffsRefresh()
            
            self.debuff.refresh.rupture = (self.debuff.remain.rupture < self.debuff.duration.rupture * 0.3) or false
        end

    ---------------
    --- CHARGES ---
    ---------------

        function self.getCharge()
            local getCharges = getCharges
            local getChargesFrac = getChargesFrac
            local getBuffStacks = getBuffStacks

            -- self.charges.assassinationtalons        = getBuffStacks("player",self.spell.assassinationtalonsBuff,"player")
        end
        
    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            self.cd.evasion = getSpellCD(self.spell.evasion)
            self.cd.garrote = getSpellCD(self.spell.garrote)
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

            -- self.talent.predator                    = getTalent(1,1)
        end

    -------------
    --- PERKS ---
    -------------

        function self.getPerks()
            local isKnown = isKnown

            -- self.perk.enhancedBerserk        = isKnown(self.spell.enhancedBerserk)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5 = #getEnemies("player", 5) -- Melee
            self.enemies.yards8 = #getEnemies("player", 8) -- Swipe/Thrash
            self.enemies.yards13 = #getEnemies("player", 13) -- Skull Bash
            self.enemies.yards20 = #getEnemies("player", 20) --Prowl
            self.enemies.yards40 = #getEnemies("player", 40) --Moonfire
        end

    -----------------
    --- RECHARGES ---
    -----------------
    
        function self.getRecharges()
            local getRecharge = getRecharge

            -- self.recharge.forceOfNature = getRecharge(self.spell.forceOfNature)
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

            self.castable.deadlyPoison  = self.castDeadlyPoison(true)
            self.castable.envenom       = self.castEnvenom(self.units.dyn5,true)
            self.castable.evasion       = self.castEvasion(true)
            self.castable.mutilate      = self.castMutilate(self.units.dyn5,true)
        end

        function self.castDeadlyPoison(debug)
            if debug == nil then debug = false end
            if self.level > 1 and self.buff.remain.deadlyPoison < 600 and not isUnitCasting() then
                if debug then
                    return castSpell("player",self.spell.deadlyPoison,false,false,false,false,false,false,false,true)
                else
                    if castSpell("player",self.spell.deadlyPoison,false,false,false) then return end
                end
            end
        end
        function self.castEnvenom(thisUnit,debug)
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level > 2 and self.power > 35 and self.comboPoints > 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,self.spell.envenom,false,false,false,false,false,false,false,true)
                else
                    if castSpell(thisUnit,self.spell.envenom,false,false,false) then return end
                end
            end
        end
        function self.castEvasion(debug)
            if debug == nil then debug = false end
            if self.level > 7 and self.cd.evasion == 0 then
                if debug then
                    return castSpell("player",self.spell.evasion,false,false,false,false,false,false,false,true)
                else
                    if castSpell("player",self.spell.evasion,false,false,false) then return end
                end
            end
        end
        function self.castMutilate(thisUnit,debug)
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level > 0 and self.power > 55 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,self.spell.mutilate,false,false,false,false,false,false,false,true)
                else
                    if castSpell(thisUnit,self.spell.mutilate,false,false,false) then return end
                end
            end
        end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------
        function useCDs()
            local cooldown = self.mode.cooldown
            if (cooldown == 1 and isBoss()) or cooldown == 2 then
                return true
            else
                return false
            end
        end

        function useAoE()
            local rotation = self.mode.rotation
            if (rotation == 1 and #getEnemies("player",8) >= 3) or rotation == 2 then
                return true
            else
                return false
            end
        end

        function useDefensive()
            if self.mode.defensive == 1 then
                return true
            else
                return false
            end
        end

        function useInterrupts()
            if self.mode.interrupt == 1 then
                return true
            else
                return false
            end
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cAssassination
end-- select Rogue