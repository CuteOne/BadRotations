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
        self.shadowArtifacts     = {
            
        }
        self.shadowBuffs         = {
            shadowyInsight = 124430 
        }
        self.shadowDebuffs       = {
            shadowWordPainDebuff = 589,
            vampiricTouchDebuff = 34914,
        }
        self.shadowSpecials      = {
            dispelMagic = 528,
            dispersion = 47585,
            fade = 586,
            levitate = 1706,
            massDispel = 32375,
            mindBlast = 8092,
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
            voidEruption = 228260
        }
        self.shadowTalents       = {
            mindBomb = 205369,
            powerInfusion = 10060,
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
            self.getCastable()


            -- Casting and GCD check
            -- TODO: -> does not use off-GCD stuff like pots, dp etc
            if castingUnit() then
                return
            end

            -- Start selected rotation - DO NOT EDIT
            self:startRotation()
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getDynamicUnits() -- Dynamic Target Selection based on Range and AoE/Non-AoE - NOTE: some more common ones are already setup in cCharacter.lua - NOTE: Do not relist and already provided Class file or cCharacter
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn10 = dynamicTarget(10,true) -- Sample Non-AoE

            -- AoE
            self.units.dyn35AoE = dynamicTarget(35, false) -- Sample AoE 
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies() -- sets table of enemies for specified ranges useful for knowing number of enemies in a certain ranges or target cycleing - NOTE: Do not relist and already provided Class file
            local getEnemies = getEnemies

            self.enemies.active_enemies_30 = #getEnemies("player",30)
            self.enemies.active_enemies_40 = #getEnemies("player",40)
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
                self.debuff[k] = UnitDebuffID(self.units.dyn5,v,"player") ~= nil
                self.debuff.duration[k] = getDebuffDuration(self.units.dyn5,v,"player") or 0
                self.debuff.remain[k] = getDebuffRemain(self.units.dyn5,v,"player") or 0
            end
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
            self.talent.mindbender                  = getTalent(6,3)
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
        function self.castArcaneTorrent()
            return castSpell("player",self.spell.arcaneTorrent,true,false) == true or false
        end
        -- dispel_magic
        function self.castDispellMagic(thisTarget)
            return castSpell(thisTarget,self.spell.dispelMagic,true,false) == true or false
        end
        -- dispersion
        function self.castDispersion()
            return castSpell("player",self.spell.dispersion,true,false) == true or false
        end
        -- fade
        function self.castFade()
            return castSpell("player",self.spell.fade,true,false) == true or false
        end
        -- levitate
        function self.castLevitate(thisTarget)
            return castSpell(thisTarget,self.spell.levitate,true,false) == true or false
        end
        -- mind_blast
        function self.castMindBlast(thisTarget)
            return castSpell(thisTarget,self.spell.mindBlast,false,true) == true or false
        end
        -- mind_flay
        function self.castMindFlay(thisTarget)
            return castSpell(thisTarget,self.spell.mindFlay,false,true) == true or false
        end
        -- mind_sear
        function self.castMindSear(thisTarget)
            return castSpell(thisTarget,self.spell.mindSear,true,true) == true or false
        end
        -- mind_spike
        function self.castMindSpike(thisTarget)
            return castSpell(thisTarget,self.spell.mindSpike,false,true) == true or false
        end
        -- power_word_shield
        function self.castPWS(thisTarget)
            return castSpell(thisTarget,self.spell.powerWordShield,true,false) == true or false
        end
        -- resurrection
        function self.castResurrection(thisTarget)
            return castSpell(thisTarget,self.spell.resurrection,true,true) == true or false
        end
        -- shackle_undead
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
        function self.castSWD(thisTarget)
            if getHP(thisTarget)<=20 then
                return castSpell(thisTarget,self.spell.shadowWordDeath,true,false) == true or false
            end
            return false
        end
        -- shadow_word_pain
        function self.castSWPAutoApply(maxTargets)
            -- try to apply on target first
            if self.castSWPOnTarget(maxTargets) then return true end
            -- then apply on others
            if self.getSWPrunning() < maxTargets then
                for i=1,#bb.enemy do
                    local thisUnit = bb.enemy[i].unit
                    local hp = bb.enemy[i].hpabs
                    local ttd = bb.enemy[i].ttd
                    local distance = bb.enemy[i].distance
                    -- infight
                    if UnitIsTappedByPlayer(thisUnit) then
                        -- blacklists: CC, DoT Blacklist
                        if not isCCed(thisUnit) and self.SWP_allowed(thisUnit) then
                            -- check for running dot and remaining time
                            if getDebuffRemain(thisUnit,self.spell.shadowWordPain,"player") <= 18*0.3 then
                                -- in range?
                                if distance < 40 then
                                    -- TTD or dummy
                                    if ttd > self.options.rotation.ttdSWP or isDummy(thisUnit) then
                                        return castSpell(thisUnit,self.spell.shadowWordPain,true,false) == true or false
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return false
        end
        function self.castSWPOnTarget(maxTargets)
            if self.getSWPrunning() < maxTargets then
                -- infight
                if UnitIsTappedByPlayer("target") then
                    -- blacklists: CC, DoT Blacklist
                    if not isCCed("target") and self.SWP_allowed("target") then
                        -- check for running dot and remaining time
                        if getDebuffRemain("target",self.spell.shadowWordPain,"player") <= 18*0.3 then
                            -- in range?
                            if getDistance("player","target") < 40 then
                                -- TTD or dummy
                                if getTTD("target") > self.options.rotation.ttdSWP or isDummy("target") then
                                    return castSpell("target",self.spell.shadowWordPain,true,false) == true or false
                                end
                            end
                        end
                    end
                end
            end
            return false
        end
        function self.castSWPOnUnit(thisTarget)
            if UnitExists(thisTarget) and UnitCanAttack("player",thisTarget) then
            --if self.getSWPrunning() < maxTargets then
                -- infight
                if UnitIsTappedByPlayer(thisTarget) then
                    -- blacklists: CC, DoT Blacklist
                    if not isCCed(thisTarget) and self.SWP_allowed(thisTarget) and self.CoP_offdot_allowed(thisTarget) then
                        -- check for running dot and remaining time
                        if getDebuffRemain(thisTarget,self.spell.shadowWordPain,"player") <= 18*0.3 then
                            -- in range?
                            if getDistance("player",thisTarget) < 40 then
                                -- TTD or dummy
                                if getTTD(GetObjectWithGUID(UnitGUID(thisTarget))) > self.options.rotation.ttdSWP or isDummy(thisTarget) then
                                    return castSpell(thisTarget,self.spell.shadowWordPain,true,false) == true or false
                                end
                            end
                        end
                    end
                end
            end
            return false
        end
        function self.castSWP(thisTarget)
            return castSpell(thisTarget,self.spell.shadowWordPain,true,false) == true or false
        end
        -- shadowfiend
        function self.castShadowfiend(thisTarget)
            if self.mode.cooldowns == 2 then
                if self.options.cooldowns.Mindbender then
                    return castSpell(thisTarget,self.spell.shadowfiend,true,false) == true or false
                end
            end
            return false
        end
        -- silence
        function self.castSilence(thisTarget)
            return castSpell(thisTarget,self.spell.silence,true,false) == true or false
        end
        -- vampiric_embrace
        function self.castVampiricEmbrace()
            return castSpell("player",self.spell.vampiricEmbrace,true,false) == true or false
        end
        -- vampiric_touch
        function self.castVTOnTarget(maxTargets)
            if self.getVTrunning() < maxTargets then
                local castTime = 0.001*select(4,GetSpellInfo(34914))
                -- infight
                if UnitIsTappedByPlayer("target") then
                    -- last VT check
                    if lastVTTarget ~= thisUnitGUID and lastVTTime+5 < GetTime() then
                        -- blacklists: CC, DoT Blacklist
                        if not isCCed("target") and self.VT_allowed("target") then
                            -- check for running dot and remaining time
                            if getDebuffRemain("target",self.spell.vampiricTouch,"player") <= 15*0.3+castTime then
                                -- in range?
                                if getDistance("player","target") < 40 then
                                    -- TTD or dummy
                                    if getTTD("target") > self.options.rotation.ttdSWP+castTime or isDummy("target") then
                                        return castSpell("target",self.spell.vampiricTouch,true,true) == true or false
                                    end
                                end
                            end
                        end
                    end
                end
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
                                        return castSpell(thisTarget,self.spell.vampiricTouch,true,true) == true or false
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

        
    ------------------------
    --- CUSTOM FUNCTIONS --- -- List all custom functions used only by this spec here 
    ------------------------
        

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cShadow
end-- select Class