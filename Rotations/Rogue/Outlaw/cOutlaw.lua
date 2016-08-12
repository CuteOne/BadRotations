--- Outlaw Class
-- Inherit from: ../cCharacter.lua and ../cRogue.lua
if select(2, UnitClass("player")) == "ROGUE" then
    cOutlaw = {}
    cOutlaw.rotations = {}

    -- Creates Outlaw Rogue
    function cOutlaw:new()
        local self = cRogue:new("Outlaw")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cOutlaw.rotations
        
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
        self.outlawArtifacts     = {
            blackPowder             = 216230,
            bladeDancer             = 202507,
            bladeMaster             = 202628,
            blunderbuss             = 202897,
            blurredTime             = 202769,
            curseOfTheDreadblades   = 202665,
            cursedEdge              = 202463,
            cursedSteel             = 214929,
            deception               = 202755,
            fatesThirst             = 202514,
            fatebringer             = 202524,
            fortuneStrikes          = 202530,
            fortunesBoon            = 202907,
            fortunesStrike          = 202521,
            ghostlyShell            = 202533,
            greed                   = 202820,
            gunslinger              = 202522,
            hiddenBlade             = 202573.
        }
        self.outlawBuffs         = {
            opportunityBuff         = 195627,
        }
        self.outlawDebuffs       = {
            ghostlyStrikeDebuff     = 196937,
        }
        self.outlawSpecials      = {
            adrenalineRush          = 13750,
            ambush                  = 8676,
            betweenTheEyes          = 199804,
            bladeFlurry             = 13877,
            blind                   = 2094,
            bribe                   = 199740,
            gouge                   = 1776,
            masteryMainGauche       = 76806,
            pistolShot              = 185763,
            riposte                 = 199754,
            rollTheBones            = 193316,
            runThrough              = 2098,
            saberSlash              = 193315,
            pistolShot              = 185763,
        }
        self.outlawTalents       = {
            sliceAndDice            = 5171,
            cannonballBarrage       = 185767,
            killingSpree            = 51690,
            dirtyTricks             = 108216,
            parley                  = 199743,
            ironStomach             = 193546,
            acrobaticStikes         = 196924,
            grapplingHook           = 195457,
            hitAndRun               = 196922,
            ghostlyStrike           = 196937,
            quickDraw               = 196938,
            swordmaster             = 200733,  
        }
        -- Merge all spell tables into self.spell
        self.outlawSpells = {}
        self.outlawSpells = mergeTables(self.outlawSpells,self.outlawArtifacts)
        self.outlawSpells = mergeTables(self.outlawSpells,self.outlawBuffs)
        self.outlawSpells = mergeTables(self.outlawSpells,self.outlawDebuffs)
        self.outlawSpells = mergeTables(self.outlawSpells,self.outlawSpecials)
        self.outlawSpells = mergeTables(self.outlawSpells,self.outlawTalents)
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.rogueSpell, self.outlawSpells)
        
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
            -- self.outlaw_bleed_table()
            self.getBuffs()
            self.getBuffsDuration()
            self.getBuffsRemain()
            self.getCharge()
            self.getCooldowns()
            self.getDynamicUnits()
            self.getDebuffs()
            self.getDebuffsDuration()
            self.getDebuffsRemain()
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
            self.units.dyn8 = dynamicTarget(8, true) 
            self.units.dyn13 = dynamicTarget(13, true)
            self.units.dyn20 = dynamicTarget(20, true) --Pistol Shot 

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

            self.buff.opportunity = UnitBuffID("player",self.spell.opportunityBuff) ~= nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            self.buff.duration.opportunity = getBuffDuration("player",self.spell.opportunityBuff) or 0
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            self.buff.remain.opportunity = getBuffRemain("player",self.spell.opportunityBuff) or 0
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

            self.debuff.ghostlyStrike = UnitDebuffID(self.units.dyn5,self.spell.ghostlyStrikeDebuff,"player") ~= nil or false
        end

        function self.getDebuffsDuration()
            local getDebuffDuration = getDebuffDuration

            self.debuff.duration.ghostlyStrike = getDebuffDuration(self.units.dyn5,self.spell.ghostlyStrikeDebuff,"player") or 0
        end

        function self.getDebuffsRemain()
            local getDebuffRemain = getDebuffRemain

            self.debuff.remain.ghostlyStrike = getDebuffRemain(self.units.dyn5,self.spell.ghostlyStrikeDebuff,"player") or 0
        end

    ---------------
    --- CHARGES ---
    ---------------

        function self.getCharge()
            local getCharges = getCharges
            local getChargesFrac = getChargesFrac
            local getBuffStacks = getBuffStacks

            -- self.charges.outlawtalons        = getBuffStacks("player",self.spell.outlawtalonsBuff,"player")
        end
        
    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            self.cd.gouge   = getSpellCD(self.spell.gouge)
            self.cd.riposte = getSpellCD(self.spell.riposte)
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

            self.talent.ghostlyStrike       = getTalent(1,1)
            self.talent.swordmaster         = getTalent(1,2)
            self.talent.quickDraw           = getTalent(1,3)
            self.talent.grapplingHook       = getTalent(2,1)
            self.talent.acrobaticStikes     = getTalent(2,2)
            self.talent.hitAndRun           = getTalent(2,3)
            self.talent.ironStomach         = getTalent(4,1)
            self.talent.parley              = getTalent(5,1)
            self.talent.dirtyTricks         = getTalent(5,3)
            self.talent.cannonballBarrage   = getTalent(6,1)
            self.talent.killingSpree        = getTalent(6,3)
            self.talent.sliceAndDice        = getTalent(7,1)
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

            -- self.castable.ambush        = self.castAmbush(self.units.dyn5,true)
            -- self.castable.ghostlyStrike = self.castGhostlyStrike(self.units.dyn5,true)
            -- self.castable.gouge         = self.castGouge(self.units.dyn5,true)
            -- self.castable.pistolShot    = self.castPistolShot(self.units.dyn20,true)
            -- self.castable.riposte       = self.castRiposte("player",true)
            -- self.castable.runThrough    = self.castRunThrough(self.units.dyn5,true)
            -- self.castable.saberSlash    = self.castSaberSlash(self.units.dyn5,true)
        end

        function self.castAmbush(theUnit,debug)
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 14 and self.power > 60 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,self.spell.ambush,false,false,false,false,false,false,false,true)
                else
                    if castSpell(thisUnit,self.spell.ambush,false,false,false) then return end
                end
            end
        end
        function self.castGhostlyStrike(theUnit,debug)
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.talent.ghostlyStrike and self.power > 30 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,self.spell.ghostlyStrike,false,false,false,false,false,false,false,true)
                else
                    if castSpell(thisUnit,self.spell.ghostlyStrike,false,false,false) then return end
                end
            end
        end 
        function self.castGouge(theUnit,debug)
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 22 and self.power > 25 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,self.spell.gouge,false,false,false,false,false,false,false,true)
                else
                    if castSpell(thisUnit,self.spell.gouge,false,false,false) then return end
                end
            end
        end
        function self.castPistolShot(theUnit,debug)
            if thisUnit == nil then thisUnit = self.units.dyn20 end
            if debug == nil then debug = false end

            if self.level >= 11 and (self.power > 40 or self.buff.opportunity) and hasThreat(thisUnit) and getDistance(thisUnit) < 20 then
                if debug then
                    return castSpell(thisUnit,self.spell.pistolShot,false,false,false,false,false,false,false,true)
                else
                    if castSpell(thisUnit,self.spell.pistolShot,false,false,false) then return end
                end
            end
        end 
        function self.castRiposte(debug)
            if debug == nil then debug = false end

            if self.level >= 10 and self.cd.riposte == 0 then
                if debug then 
                    return castSpell("player",self.spell.riposte,false,false,false,false,false,false,false,true)
                else
                    if castSpell("player",self.spell.riposte,false,false,false) then return end
                end
            end
        end
        function self.castRunThrough(thisUnit,debug)
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 10 and self.power > 35 and self.comboPoints > 0 and getDistance(thisUnit) < 8 then
                if debug then
                    return castSpell(thisunit,self.spell.runThrough,false,false,false,false,false,false,false,true)
                else
                    if castSpell(thisUnit,self.spell.runThrough,false,false,false) then return end
                end
            end
        end
        function self.castSaberSlash(theUnit,debug)
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 10 and self.power > 50 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,self.spell.saberSlash,false,false,false,false,false,false,false,true)
                else
                    if castSpell(thisUnit,self.spell.saberSlash,false,false,false) then return end
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
    end-- cOutlaw
end-- select Rogue