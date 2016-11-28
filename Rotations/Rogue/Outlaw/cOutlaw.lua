--- Outlaw Class
-- Inherit from: ../cCharacter.lua and ../cRogue.lua
cOutlaw = {}
cOutlaw.rotations = {}

    -- Creates Outlaw Rogue
function cOutlaw:new()
    if GetSpecializationInfo(GetSpecialization()) == 260 then--if select(2, UnitClass("player")) == "ROGUE" then
        local self = cRogue:new("Outlaw")
        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cOutlaw.rotations
        
        -----------------
        --- VARIABLES ---
        -----------------
        self.spell.spec             = {}
        self.spell.spec.abilities   = {
            adrenalineRush          = 13750,
            ambush                  = 8676,
            betweenTheEyes          = 199804,
            bladeFlurry             = 13877,
            blind                   = 2094,
            bribe                   = 199740,
            cannonballBarrage       = 185767,
            curseOfTheDreadblades   = 202665,
            ghostlyStrike           = 196937,
            gouge                   = 1776,
            grapplingHook           = 195457,
            killingSpree            = 51690,
            masteryMainGauche       = 76806,
            parley                  = 199743,
            pistolShot              = 185763,
            riposte                 = 199754,
            rollTheBones            = 193316,
            runThrough              = 2098,
            saberSlash              = 193315,
            sliceAndDice            = 5171,
        }
        self.spell.spec.artifacts   = {
            blackPowder             = 216230,
            bladeDancer             = 202507,
            bladeMaster             = 202628,
            blunderbuss             = 202897,
            blurredTime             = 202769,
            cannonballBarrage       = 185767,
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
            hiddenBlade             = 202573,
            killingSpree            = 51690,
            sliceAndDice            = 5171,
        }
        self.spell.spec.buffs       = {
            adrenalineRush          = 13750,
            alacrity                = 193538,
            bladeFlurry             = 13877,
            broadsides              = 193356,
            buriedTreasure          = 199600,
            curseOfTheDreadblades   = 202665,
            grandMelee              = 193358,
            hiddenBlade             = 202754,
            jollyRoger              = 199603,
            opportunity             = 195627,
            sharkInfestedWaters     = 193357,
            sliceAndDice            = 5171,
            trueBearing             = 193359,
            --sorry for the mess :/
            greenskinsWaterloggedWristcuffs = 209420
        }
        self.spell.spec.buffs.rollTheBones = {
            broadsides              = 193356,
            buriedTreasure          = 199600,
            grandMelee              = 193358,
            jollyRoger              = 199603,
            sharkInfestedWaters     = 193357,
            trueBearing             = 193359,
        }
        self.spell.spec.debuffs     = {
            ghostlyStrike           = 196937,
            parley                  = 199743,
        }
        self.spell.spec.talents     = {
            acrobaticStikes         = 196924,
            cannonballBarrage       = 185767,
            dirtyTricks             = 108216,
            ghostlyStrike           = 196937,
            grapplingHook           = 195457,
            hitAndRun               = 196922,
            ironStomach             = 193546,
            killingSpree            = 51690,
            parley                  = 199743,
            sliceAndDice            = 5171,
            swordmaster             = 200733,  
            quickDraw               = 196938,
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
            if not self.inCombat then self.updateOOC() end
            self.getBuffs()
            self.getCharge()
            self.getCooldowns()
            self.getDynamicUnits()
            self.getDebuffs()
            self.getEnemies()
            self.getRecharges()
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
            self.units.dyn13 = dynamicTarget(15, true) -- Blind
            self.units.dyn20 = dynamicTarget(20, true) --Pistol Shot 

            -- AoE
            self.units.dyn8AoE  = dynamicTarget(8, false) -- Blade Flurry
            self.units.dyn35AoE = dynamicTarget(35, false) -- Cannonball Barrage
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards8 = getEnemies("player", 8) -- Blade Flurry
            self.enemies.yards20 = getEnemies("player", 20) -- Interrupts
            self.enemies.yards35 = getEnemies("player", 35) -- Cannonball Barrage
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

            for k,v in pairs(self.spell.spec.buffs) do
                -- print (k)
                if k ~= "rollTheBones" then
                    self.buff[k] = UnitBuffID("player",v) ~= nil
                    self.buff.duration[k] = getBuffDuration("player",v) or 0
                    self.buff.remain[k] = getBuffRemain("player",v) or 0
                    self.buff.stack[k] = getBuffStacks("player",v) or 0
                end
            end

            self.buff.count                 = {}
            self.buff.count.rollTheBones    = 0
            self.buff.duration.rollTheBones = 0
            self.buff.remain.rollTheBones   = 0 
            for k,v in pairs(self.spell.spec.buffs.rollTheBones) do
                if UnitBuffID("player",v) ~= nil then
                    self.buff.count.rollTheBones    = self.buff.count.rollTheBones + 1
                    self.buff.duration.rollTheBones = getBuffDuration("player",v)
                    self.buff.remain.rollTheBones   = getBuffRemain("player",v)
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
                self.debuff[k] = UnitDebuffID(self.units.dyn5,v,"player") ~= nil
                self.debuff.duration[k] = getDebuffDuration(self.units.dyn5,v,"player") or 0
                self.debuff.remain[k] = getDebuffRemain(self.units.dyn5,v,"player") or 0
                self.debuff.refresh[k]  = (self.debuff.remain[k] < self.debuff.duration[k] * 0.3) or self.debuff.remain[k] == 0
            end
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

    --------------
    --- SPELLS ---
    --------------

        function self.getCastable()

            self.cast.debug.adrenalineRush          = self.cast.adrenalineRush("player",true)
            self.cast.debug.ambush                  = self.cast.ambush("target",true)
            self.cast.debug.betweenTheEyes          = self.cast.betweenTheEyes("target",true)
            self.cast.debug.bladeFlurry             = self.cast.bladeFlurry("player",true)
            self.cast.debug.blind                   = self.cast.blind("target",true)
            self.cast.debug.cannonballBarrage       = self.cast.cannonballBarrage("target",true)
            self.cast.debug.curseOfTheDreadblades   = self.cast.curseOfTheDreadblades("player",true)
            self.cast.debug.ghostlyStrike           = self.cast.ghostlyStrike("target",true)
            self.cast.debug.gouge                   = self.cast.gouge("target",true)
            self.cast.debug.grapplingHook           = self.cast.grapplingHook("target",true)
            self.cast.debug.killingSpree            = self.cast.killingSpree("target",true)
            self.cast.debug.parley                  = self.cast.parley
            self.cast.debug.pistolShot              = self.cast.pistolShot("target",true)
            self.cast.debug.riposte                 = self.cast.riposte("player",true)
            self.cast.debug.rollTheBones            = self.cast.rollTheBones("player",true)
            self.cast.debug.runThrough              = self.cast.runThrough("target",true)
            self.cast.debug.saberSlash              = self.cast.saberSlash("target",true)
            self.cast.debug.sliceAndDice            = self.cast.sliceAndDice("player",true)
        end

        function self.cast.adrenalineRush(thisUnit,debug)
            local spellCast = self.spell.adrenalineRush
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 72 and self.cd.adrenalineRush == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.ambush(thisUnit,debug)
            local spellCast = self.spell.ambush
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 14 and self.power > 60 and (self.buff.stealth or self.buff.vanish or self.buff.shadowmeld) and self.cd.ambush == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.betweenTheEyes(thisUnit,debug)
            local spellCast = self.spell.betweenTheEyes
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn20 end
            if debug == nil then debug = false end

            if self.level >= 25 and self.power > 35 and self.cd.betweenTheEyes == 0 and getDistance(thisUnit) < 20 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.bladeFlurry(thisUnit,debug)
            local spellCast = self.spell.bladeFlurry
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 48 and self.cd.bladeFlurry == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.blind(thisUnit,debug)
            local spellCast = self.spell.blind
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn15 end
            if debug == nil then debug = false end

            if self.level >= 38 and self.cd.blind == 0 and getDistance(thisUnit) < 15 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.bribe(thisUnit,debug)
            local spellCast = self.spell.bribe
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.level >= 54 and self.cd.blind == 0 and UnitCreatureType(thisUnit) == "Humanoid" 
                and not UnitIsPlayer(thisUnit) and UnitLevel(thisUnit) <= UnitLevel("player") + 1 and getDistance(thisUnit) < 30 
            then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.cannonballBarrage(thisUnit,debug)
            local spellCast = self.spell.cannonballBarrage
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn35AoE end
            if debug == nil then debug = false end

            if self.talent.cannonballBarrage and self.cd.cannonballBarrage == 0 and getDistance(thisUnit) < 35 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    -- return castSpell(thisUnit,spellCast,false,false,false)
                    return castGround(thisUnit,spellCast,35)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.curseOfTheDreadblades(thisUnit,debug)
            local spellCast = self.spell.curseOfTheDreadblades
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.artifact.curseOfTheDreadblades and self.cd.curseOfTheDreadblades == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.ghostlyStrike(thisUnit,debug)
            local spellCast = self.spell.ghostlyStrike
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.talent.ghostlyStrike and self.power > 30 and self.cd.ghostlyStrike == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    -- ObjectInteract(thisUnit)
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end 
        function self.cast.gouge(thisUnit,debug)
            local spellCast = self.spell.gouge
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 22 and (self.power > 25 or self.talent.dirtyTricks) and self.cd.gouge == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.grapplingHook(thisUnit,debug)
            local spellCast = self.spell.grapplingHook
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.grapplingHook and self.cd.grapplingHook == 0 and getDistance(thisUnit) < 40 and getDistance(thisUnit) >= 8 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castGround(thisUnit,spellCast,40)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.killingSpree(thisUnit,debug)
            local spellCast = self.spell.killingSpree
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn10 end
            if debug == nil then debug = false end

            if self.talent.killingSpree and self.cd.killingSpree == 0 and getDistance(thisUnit) < 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castGround(thisUnit,spellCast,40)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.parley(thisUnit,debug)
            local spellCast = self.spell.parley
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.talent.parley and (UnitCreatureType(thisUnit) == "Humanoid" or UnitCreatureType(thisUnit) == "Demon" or UnitCreatureType(thisUnit) == "Dragonkin") and self.cd.parley == 0 and getDistance(thisUnit) < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end 
        function self.cast.pistolShot(thisUnit,debug)
            local spellCast = self.spell.pistolShot
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn20 end
            if debug == nil then debug = false end

            if self.level >= 11 and (self.power > 40 or self.buff.opportunity) and (hasThreat(thisUnit) or isDummy(thisUnit)) and self.cd.pistolShot == 0 and getDistance(thisUnit) < 20 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end 
        function self.cast.riposte(thisUnit,debug)
            local spellCast = self.spell.riposte
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 10 and self.cd.riposte == 0 then
                if debug then 
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.rollTheBones(thisUnit,debug)
            local spellCast = self.spell.rollTheBones
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 36 and self.power > 25 - (self.artifact.rank.fatebringer * 3) and self.comboPoints > 0 and self.cd.rollTheBones == 0 and not self.talent.sliceAndDice then
                if debug then 
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.runThrough(thisUnit,debug)
            local spellCast = self.spell.runThrough
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 10 and self.power > 35 - (self.artifact.rank.fatebringer * 3) and self.comboPoints > 0 and self.cd.runThrough == 0 and getDistance(thisUnit) < 8 then
                if debug then
                    return castSpell(thisunit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.saberSlash(thisUnit,debug)
            local spellCast = self.spell.saberSlash
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 10 and self.power > 50 and self.cd.saberSlash == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.sliceAndDice(thisUnit,debug)
            local spellCast = self.spell.sliceAndDice
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.sliceAndDice and self.power > 25 - (self.artifact.rank.fatebringer * 3) and self.comboPoints > 0 and self.cd.sliceAndDice == 0 then
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
    end-- cOutlaw
end-- select Rogue
