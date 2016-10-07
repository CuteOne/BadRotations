--- Shadow Class
-- Inherit from: ../cCharacter.lua and ../cClass.lua

cShadow = {} 
cShadow.rotations = {} 

    -- Creates Spec
function cShadow:new() 
    if GetSpecializationInfo(GetSpecialization()) == 258 then 
        local self = cPriest:new("Shadow")

        local player = "player" -- if someone forgets ""

        -- Mandatory ! - DO NOT EDIT
        self.rotations = cShadow.rotations
        
        -----------------
        --- VARIABLES --- 
        -----------------
        self.enemies = {
            yards40,
        }
        self.shadowArtifacts     = {
            
        }
        self.shadowBuffs         = {
            shadowyInsight = 124430,
            voidForm = 194249 
        }
        self.shadowDebuffs       = {
            shadowWordPain = 589,
            vampiricTouch = 34914,
        }
        self.shadowSpecials      = {
            dispelMagic = 528,
            dispersion = 47585,
            fade = 586,
            levitate = 1706,
            massDispel = 32375,
            mindBlast = 8092,
            mindfiend = 34433,
            mindFlay = 15407,
            mindSear = 48045,  
            mindVision = 2096,
            powerWordShield = 17,
            purifyDisease = 213634,
            resurrection = 2006,
            shackleUndead = 9484,
            shadowMend = 186263,
            shadowWordDeath = 32379,
            shadowWordPain = 589,
            shadowfiend = 34433,
            silence = 15487,
            vampiricEmbrace = 15286,
            vampiricTouch = 34914,
            voidBolt = 205448,
            voidEruption = 228260
            
        }
        self.self.spell.spec.talents       = {
            mindBomb = 205369,
            powerInfusion = 10060,
            mindBender = 200174,
            mindSpike = 73510,
        }
        -- Merge all spell tables into self.spell
        self.shadowSpells = {}
        self.shadowSpells = mergeTables(self.shadowSpells,self.shadowArtifacts)
        self.shadowSpells = mergeTables(self.shadowSpells,self.shadowBuffs)
        self.shadowSpells = mergeTables(self.shadowSpells,self.shadowDebuffs)
        self.shadowSpells = mergeTables(self.shadowSpells,self.shadowSpecials)
        self.shadowSpells = mergeTables(self.shadowSpells,self.shadowTalents)
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.priestSpell, self.shadowSpells) -- Also change self.classSpell to name of class IE: druid or monk
        
    ------------------
    --- OOC UPDATE ---
    ------------------

        function self.updateOOC()  -- Add any functions or variables that need to be updated only when not in combat here
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

        function self.update() -- Add any functions or variables that need to be updated all the time here

            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            self.getDynamicUnits()
            self.getEnemies()
            self.getBuffs()
            self.getCharges()
            self.getCooldowns()
            self.getDebuffs()
            self.getRecharges()
            self.getToggleModes()
            self.getDebuffsCount()
            --self.getCastable()


            -- Casting and GCD check
            -- TODO: -> does not use off-GCD stuff like pots, dp etc
            --if castingUnit() then
            --    return
            --end

            -- Start selected rotation - DO NOT EDIT
            self:startRotation()
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getDynamicUnits() -- Dynamic Target Selection based on Range and AoE/Non-AoE - NOTE: some more common ones are already setup in cCharacter.lua - NOTE: Do not relist and already provided Class file or cCharacter
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn40 = dynamicTarget(40,true) -- Sample Non-AoE
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies() -- sets table of enemies for specified ranges useful for knowing number of enemies in a certain ranges or target cycleing - NOTE: Do not relist and already provided Class file
            local getEnemies = getEnemies

            self.enemies.yards40 = #getEnemies("player",40)
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getArtifacts() -- Dynamicaly creates artifact lists based on the spell table above - NOTE: Change self.specArtifactss to the name of the artifact table)
            local isKnown = isKnown

            for k,v in pairs(self.shadowArtifacts) do
                self.artifact[k] = isKnown(v)
            end
        end

        function self.getArtifactRanks() -- Not yet implemented

        end

    -------------
    --- BUFFS ---
    -------------
    
        function self.getBuffs() -- Dynamicaly creates buff lists based on the spell table above - NOTE: Change self.specBuffs to the name of the buff table)
            local UnitBuffID = UnitBuffID
            local getBuffDuration = getBuffDuration
            local getBuffRemain = getBuffRemain

            for k,v in pairs(self.shadowBuffs) do
                self.buff[k] = UnitBuffID("player",v) ~= nil
                self.buff.duration[k] = getBuffDuration("player",v) or 0
                self.buff.remain[k] = getBuffRemain("player",v) or 0
            end
        end

    ---------------
    --- CHARGES ---
    ---------------
        function self.getCharges() -- Dynamicaly creates charge lists based on the spell/buff table above - NOTE: Change self.specSpells/self.specBuffs to the name of the spell/buff table)
            local getCharges = getCharges

            for k,v in pairs(self.shadowSpells) do
                self.charges[k] = getCharges(v)
            end
            for k,v in pairs(self.shadowBuffs) do
                self.charges[k] = getBuffStacks("player",v,"player")
            end
        end

    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getCooldowns() -- Dynamicaly creates cooldown lists based on the spell table above - NOTE: Change self.specCooldowns to the name of the cooldown table)
            local getSpellCD = getSpellCD

            for k,v in pairs(self.shadowSpells) do
                if getSpellCD(v) ~= nil then
                    self.cd[k] = getSpellCD(v)
                end
            end
        end

    ---------------
    --- DEBUFFS ---
    ---------------

        function self.getDebuffs() -- Dynamicaly creates debuff lists based on the debuff table above - NOTE: Change self.specDebuffs to the name of the debuff table)
            local UnitDebuffID = UnitDebuffID
            local getDebuffDuration = getDebuffDuration
            local getDebuffRemain = getDebuffRemain

            for k,v in pairs(self.shadowDebuffs) do
                self.debuff[k] = UnitDebuffID(self.units.dyn40,v,"player") ~= nil
                self.debuff.duration[k] = getDebuffDuration(self.units.dyn40,v,"player") or 0
                self.debuff.remain[k] = getDebuffRemain(self.units.dyn40,v,"player") or 0
            end
        end

        function self.getDebuffsCount()
            local UnitDebuffID = UnitDebuffID
            local vampiricTouchCount = 0
            local shadowWordPainCount = 0

            if vampiricTouchCount>0 and not inCombat then vampiricTouchCount = 0 end
            if shadowWordPainCount>0 and not inCombat then shadowWordPainCount = 0 end

            for i=1,#getEnemies("player", 40) do
                local thisUnit = getEnemies("player", 40)[i]
                if UnitDebuffID(thisUnit,self.spell.vampiricTouch,"player") then
                    vampiricTouchCount = vampiricTouchCount+1
                end
                if UnitDebuffID(thisUnit,self.spell.shadowWordPain,"player") then
                    shadowWordPainCount = shadowWordPainCount+1
                end
            end
            self.debuff.count.vampiricTouch     = vampiricTouchCount or 0
            self.debuff.count.shadowWordPain    = shadowWordPainCount or 0
        end
    --------------
    --- GLYPHS ---
    --------------

        function self.getGlyphs() -- Gylphs not so important in legion so not yet reimplemented
            local hasGlyph = hasGlyph

            -- self.glyph.cheetah           = hasGlyph(self.spell.glyphOfTheCheetah)
        end

    -------------
    --- PERKS ---
    -------------

        function self.getPerks() -- no longer used in Legion
            local isKnown = isKnown

            -- self.perk.enhancedRebirth = isKnown(self.spell.enhancedRebirth)
        end

    -----------------
    --- RECHARGES ---
    -----------------
    
        function self.getRecharges() -- Dynamicaly creates recharge list based on the spell table above - NOTE: Change self.specSpells to the name of the spell table)
            local getRecharge = getRecharge

            for k,v in pairs(self.shadowSpells) do
                self.recharge[k] = getRecharge(v)
            end
        end

    ----------------
    --- TALENTS ---
    ----------------

        function self.getTalents() -- Dynamicaly creates talent list based on the talent table above - NOTE: Change self.specTalents to the name of the talent table)
            local getTalent = getTalent

            self.talent.twistOfFate                 = getTalent(1,1)
            self.talent.fortressOfTheMind           = getTalent(1,2)
            self.talent.shadowWordVoid              = getTalent(1,3)
            self.talent.mania                       = getTalent(2,1)
            self.talent.bodyAndSoul                 = getTalent(2,2)
            self.talent.masochism                   = getTalent(2,3)
            self.talent.mindBomb                    = getTalent(3,1)
            self.talent.psychicVoices               = getTalent(3,2)
            self.talent.dominateMind                = getTalent(3,3)
            self.talent.voidLord                    = getTalent(4,1)
            self.talent.reaperOfSouls               = getTalent(4,2)
            self.talent.voidRay                     = getTalent(4,3)
            self.talent.sanlaryn                    = getTalent(5,1)
            self.talent.auspiciousSpirits           = getTalent(5,2)
            self.talent.shadowyInsight              = getTalent(5,3)
            self.talent.powerInfusion               = getTalent(6,1)
            self.talent.shadowCrash                 = getTalent(6,2)
            self.talent.mindBender                  = getTalent(6,3)
            self.talent.legacyOfTheVoid             = getTalent(7,1)
            self.talent.mindSpike                   = getTalent(7,2)
            self.talent.surrenderToMadness          = getTalent(7,3)
        end 

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes() -- Toggle State checks for Toggles shared by specific spec

        end

        -- Create the toggle defined within rotation files - DO NOT EDIT
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
        
        -- Creates the option/profile window - DO NOT EDIT
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
    --- SPELLS --- -- List spell cast functions for spells available to specific spec here.
    --------------
    -- arcane_torrent
        
        
        -- shadow_word_death
        function self.castSWDAuto(thisTarget)
            if self.cd.shadow_word_death <= 0 then
                if GetObjectExists(thisTarget) then
                    local thisUnit = thisTarget
                    local range = getDistance("player",thisUnit)
                    local hp = getHP(thisUnit)
                    if hp < 20 and range < 40 then
                        return castSpell(thisUnit,self.spell.shadowWordDeath,true,false) == true or false
                    end
                end
                for i=1,#bb.enemy do
                    local thisUnit = bb.enemy[i].unit
                    local range = bb.enemy[i].distance
                    local hp = bb.enemy[i].hp
                    if hp < 20 and range < 40 then
                        return castSpell(thisUnit,self.spell.shadowWordDeath,true,false,false,false,false,false,true) == true or false
                    end
                end
            end
            return false
        end


        -- shadow_word_pain
        function self.castSWPAutoApply(maxTargets)
            -- try to apply on target first
            if self.castSWPOnTarget(maxTargets) then return true end
            -- then apply on others
            if self.debuff.count.shadowWordPain < maxTargets 
            and self.debuff.count.vampiricTouch >= 1 then
                for i=1,#bb.enemy do
                    local thisUnit = bb.enemy[i].unit
                    local hp = bb.enemy[i].hpabs
                    local ttd = bb.enemy[i].ttd
                    local distance = bb.enemy[i].distance
                    -- infight
                    --if UnitIsTappedByPlayer(thisUnit) then
                        -- blacklists: CC, DoT Blacklist
                        --if not isCCed(thisUnit) and self.SWP_allowed(thisUnit) then
                            -- check for running dot and remaining time
                            if getDebuffRemain(thisUnit,self.spell.shadowWordPain,"player") <= 18*0.3 then
                                -- in range?
                                if distance < 40 then
                                    -- TTD or dummy
                                    --if ttd > self.options.rotation.ttdSWP or isDummy(thisUnit) then
                                        return castSpell(thisUnit,self.spell.shadowWordPain,true,false) == true or false
                                    --end
                                end
                            end
                        --end
                    --end
                end
            end
            return false
        end
        function self.castSWPOnTarget(maxTargets)
            if self.debuff.count.shadowWordPain < maxTargets then
                -- infight
                --if UnitIsTappedByPlayer(self.units.dyn40) then
                    -- blacklists: CC, DoT Blacklist
                    --if not isCCed(self.units.dyn40) and self.SWP_allowed(self.units.dyn40) then
                        -- check for running dot and remaining time
                        if getDebuffRemain(self.units.dyn40,self.spell.shadowWordPain,"player") <= 18*0.3 then
                            -- in range?
                            if getDistance("player",self.units.dyn40) < 40 then
                                -- TTD or dummy
                                --if getTTD(self.units.dyn40) > self.options.rotation.ttdSWP or isDummy("target") then
                                    return castSpell(self.units.dyn40,self.spell.shadowWordPain,true,false) == true or false
                                --end
                            end
                        end
                    --end
                --end
            end
            return false
        end
        function self.castSWPOnUnit(thisTarget)
            if UnitExists(thisTarget) and UnitCanAttack("player",thisTarget) then
            --if self.getSWPrunning() < maxTargets then
                -- infight
                --if UnitIsTappedByPlayer(thisTarget) then
                    -- blacklists: CC, DoT Blacklist
                    --if not isCCed(thisTarget) and self.SWP_allowed(thisTarget) and self.CoP_offdot_allowed(thisTarget) then
                        -- check for running dot and remaining time
                        if getDebuffRemain(thisTarget,self.spell.shadowWordPain,"player") <= 18*0.3 then
                            -- in range?
                            if getDistance("player",thisTarget) < 40 then
                                -- TTD or dummy
                                --if getTTD(GetObjectWithGUID(UnitGUID(thisTarget))) > self.options.rotation.ttdSWP or isDummy(thisTarget) then
                                    return castSpell(thisTarget,self.spell.shadowWordPain,true,false) == true or false
                                --end
                            end
                        end
                    --end
                --end
            --end
            return false
            end
        end


       
        -- vampiric_touch
        function self.castVTAutoApply(maxTargets)
            -- try to apply on target first
            if self.castVTOnTarget(maxTargets) then return true end
            -- then apply on others
            if self.debuff.count.vampiricTouch < maxTargets
            and self.debuff.count.shadowWordPain >= 1 then
                local castTime = 0.001*select(4,GetSpellInfo(self.spell.vampiricTouch))
                for i=1,#bb.enemy do
                    local thisUnit = bb.enemy[i].unit
                    local hp = bb.enemy[i].hpabs
                    local ttd = bb.enemy[i].ttd
                    local distance = bb.enemy[i].distance
                    -- infight
                    --if UnitIsTappedByPlayer(thisUnit) then
                        -- blacklists: CC, DoT Blacklist
                        --if not isCCed(thisUnit) and self.SWP_allowed(thisUnit) then
                            -- check for running dot and remaining time
                            if getDebuffRemain(thisUnit,self.spell.vampiricTouch,"player") <= 18*0.3+castTime then
                                -- in range?
                                if distance < 40 then
                                    -- TTD or dummy
                                    --if ttd > self.options.rotation.ttdSWP or isDummy(thisUnit) then
                                        return castSpell(thisUnit,self.spell.vampiricTouch,true,false) == true or false
                                    --end
                                end
                            end
                        --end
                    --end
                end
            end
            return false
        end
        function self.castVTOnTarget(maxTargets)
            if self.debuff.count.vampiricTouch < maxTargets then
                local castTime = 0.001*select(4,GetSpellInfo(self.spell.vampiricTouch))
                -- infight
                --if UnitIsTappedByPlayer(self.units.dyn40) then
                    -- blacklists: CC, DoT Blacklist
                    --if not isCCed(self.units.dyn40) and self.SWP_allowed(self.units.dyn40) then
                        -- check for running dot and remaining time
                        if getDebuffRemain(self.units.dyn40,self.spell.vampiricTouch,"player") <= 18*0.3 + castTime then
                            -- in range?
                            if getDistance("player",self.units.dyn40) < 40 then
                                -- TTD or dummy
                                --if getTTD(self.units.dyn40) > self.options.rotation.ttdSWP or isDummy("target") then
                                    return castSpell(self.units.dyn40,self.spell.vampiricTouch,true,false) == true or false
                                --end
                            end
                        end
                    --end
                --end
            end
            return false
        end
        function self.castVTOnUnit(thisTarget)
            if UnitExists(thisTarget) and UnitCanAttack("player",thisTarget) then
            --if self.getVTrunning() < maxTargets then
                local castTime = 0.001*select(4,GetSpellInfo(34914))
                -- infight
                if UnitIsTappedByPlayer(thisTarget) then
                    -- last VT check
                    if lastVTTarget ~= thisUnitGUID and lastVTTime+5 < GetTime() then
                        -- blacklists: CC, DoT Blacklist
                        if not isCCed(thisTarget) and self.VT_allowed(thisTarget) and self.CoP_offdot_allowed(thisTarget) then
                            -- check for running dot and remaining time
                            if getDebuffRemain(thisTarget,self.spell.vampiricTouch,"player") <= 15*0.3+castTime then
                                -- in range?
                                if getDistance("player",thisTarget) < 40 then
                                    -- TTD or dummy
                                    if getTTD(GetObjectWithGUID(UnitGUID(thisTarget))) > self.options.rotation.ttdSWP+castTime or isDummy(thisTarget) then
                                        return castSpell(thisTarget,self.spell.vampiricTouch,true,false) == true or false
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return false
        end
        function self.castVT(thisTarget)
            return castSpell(thisTarget,self.spell.vampiricTouch,true,true) == true or false
        end
        -- void Eruption
        function self.castVoidEruption()
            return castSpell("player",self.spell.voidEruption,false,true) == true or false
        end
        -- void Bolt
        function self.castVoidBolt(thisTarget)
            return castSpell(thisTarget,self.spell.voidBolt,false,false,false,true,false,false,true) == true or false
        end

        
    ------------------------
    --- CUSTOM FUNCTIONS --- -- List all custom functions used only by this spec here 
    ------------------------
    function useCDs(spellid)
            if (bb.data['Cooldown'] == 1 and isBoss()) or bb.data['Cooldown'] == 2 then
                return true
            else
                return false
            end
        end
        function useAuto()
            if bb.data['Rotation'] == 1 then
                return true
            else
                return false
            end
        end
        function useAoE()
            if bb.data['Rotation'] == 2 then
               return true
            else
                return false
            end
        end
        function useSingle()
            if bb.data['Rotation'] == 3 then
                return true
            else
                return false
            end
        end
        function useInterrupts()
            if bb.data['Interrupt'] == 1 then
               return true
            else
                return false
            end
        end
        function useDefensive()
            if bb.data['Defensive'] == 1 then
                return true
            else
                return false
            end
        end      
        -- Blacklist
        -- SWP
        function self.SWP_allowed(targetUnit)
            if targetUnit == nil or not UnitExists(targetUnit) then 
                return true 
            end
            
            local thisUnit = targetUnit
            local thisUnitID = getUnitID(thisUnit)
            local Blacklist_UnitID = {
            -- HM: Highmaul
                79956,      -- Ko'ragh: Volatile Anomaly
                78077,      -- Mar'gok: Volatile Anomaly
            -- BRF: Blackrock Foundry
                77128,      -- Darmac: Pack Beast
                77394,      -- Thogar: Iron Raider (Train Ads)
                77893,      -- Kromog: Grasping Earth (Hands)
                77665,      -- Blackhand: Iron Soldier
            -- HFC: Hellfire Citadel
                90114,      -- Hellfire Assault: damn small ads
                --94326,        -- Iron Reaver: Reactive Bomb
                90513,      -- Kilrogg: Fel Blood Globule
                96077,      -- Kilrogg: Fel Blood Globule
                90477,      -- Kilrogg: Blood Globule
                93288,      -- Gorefiend: Corrupted Players
                --95101,        -- Socrethar: Phase1 Voracious Soulstalker
                --92919,        -- Zakuun: Mythic dat orb
                92208,      -- Archimonde: Doomfire Spirit
            }
            local Blacklist_BuffID = {
            -- blackrock foundry
                155176,     -- Blast Furnace: Primal Elementalist: http://www.wowhead.com/spell=155176/damage-shield
                176141,     -- Blast Furnace: Slag Elemental: http://www.wowhead.com/spell=176141/hardened-slag
            }

            -- check for buffs
            for i = 1, #Blacklist_BuffID do
                if getBuffRemain(thisUnit,Blacklist_BuffID[i]) > 0 or getDebuffRemain(thisUnit,Blacklist_BuffID[i]) > 0 then return false end
            end
            -- check for unit id
            for i = 1, #Blacklist_UnitID do
                if thisUnitID == Blacklist_UnitID[i] then return false end
            end
            return true
        end
        -- VT
        function self.VT_allowed(targetUnit)
            if targetUnit == nil or not UnitExists(targetUnit) then 
                return true 
            end

            local thisUnit = targetUnit
            local thisUnitID = getUnitID(thisUnit)
            local Blacklist_UnitID = {
            -- BRF: Blackrock Foundry
                77893,      -- Kromog: Grasping Earth (Hands)
                78981,      -- Thogar: Iron Gunnery Sergeant (canons on trains)
                80654,      -- Blackhand Mythic Siegemakers
                80659,      -- Blackhand Mythic Siegemakers
                80646,      -- Blackhand Mythic Siegemakers
                80660,      -- Blackhand Mythic Siegemakers
            -- HFC: Hellfire Citadel
                --94865,        -- Hellfire Council: Jubei'thos Mirrors
                94231,      -- Xhul'horac: Wild Pyromaniac
                --92208,        -- Archimonde: Doomfire Spirit
                --91938,        -- Socrethar: Haunting Soul
                --90409,        -- Hellfire Assault: Gorebound Felcaster
                93717,      -- Iron Reaver: Volatile Firebomb
                91368,      -- Kormrok: Crushing Hand
                93830,      -- Hellfire Assault: Iron Dragoon
                90114,      -- Hellfire Assault: Iron Dragoon
                93369,      -- Kilrogg: Salivating Bloodthirster
                90521,      -- Kilrogg: Salivating Bloodthirster
                --90388,        -- Gorefiend: Digest Mobs
                93288,      -- Gorefiend: Corrupted Players
                95101,      -- Socrethar: Phase1 Voracious Soulstalker
                91259,      -- Mannoroth: Fel Imp
                92208,      -- Archimonde: Doomfire Spirit
                93616,      -- Archimonde: Dreadstalker
            }

            local Blacklist_BuffID = {
            }

            -- check for buffs
            for i = 1, #Blacklist_BuffID do
                if getBuffRemain(thisUnit,Blacklist_BuffID[i]) > 0 or getDebuffRemain(thisUnit,Blacklist_BuffID[i]) > 0 then return false end
            end
            -- check for unit id
            for i = 1, #Blacklist_UnitID do
                if thisUnitID == Blacklist_UnitID[i] then return false end
            end
            return true
        end
    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cShadow
end-- select Class