-- Inherit from: ../cCharacter.lua
-- All Class specs inherit from this file
if select(2, UnitClass("player")) == "CLASS" then -- Changed to name of class. IE: DRUID, DEATHKNIGHT
    cClass = {} -- Change cClass to name of class IE: cDruid or cMonk
    -- Creates Class with given specialisation
    function cClass:new(spec) -- Change cClass to name of class IE: cDruid or cMonk
        local self = cCharacter:new("Class") -- Change to name of class. IE: Druid, Deathknigh

        local player = "player" -- if someone forgets ""

    -----------------
    --- VARIABLES --- -- List of tables 
    -----------------
        self.profile         = spec
        self.artifact        = {}
        self.artifact.perks  = {}
        self.buff.duration   = {}       -- Buff Durations
        self.buff.remain     = {}       -- Buff Time Remaining
        self.castable        = {}       -- Cast Spell Functions
        self.debuff.duration = {}       -- Debuff Durations
        self.debuff.remain   = {}       -- Debuff Time Remaining
        self.debuff.refresh  = {}       -- Debuff Refreshable
        self.enemies         = {}       -- Enemies 
        self.classAbilities  = {        -- Abilities Available To All Specs in Class, change class to name of class IE: druid or monk
            -- sampleeAbility         = 00000,  
        }
        self.classArtifacts  = {        -- Artifact Traits Available To All Specs in Class, change class to name of class IE: druid or monk
            -- sampleArtifact         = 00000,
        }
        self.classBuffs      = {        -- Buffs Available To All Specs in Class, change class to name of class IE: druid or monk
            -- sampleBuff             = 00000,
        }
        self.classDebuffs    = {        -- Debuffs Available To All Specs in Class, change class to name of class IE: druid or monk
            -- sampleDebuff           = 00000,
        }
        self.classGlyphs     = {        -- Glyphs Available To All Specs in Class, change class to name of class IE: druid or monk
            -- sampleGlyph            = 00000,
        }
        self.classSpecials   = {        -- Specializations Available To All Specs in Class, change class to name of class IE: druid or monk
            -- sampleSpecial          = 00000,
        }
        self.classTalents    = {        -- Talents Available To All Specs in Class, change class to name of class IE: druid or monk
            -- sampleTalent           = 193539,
        }
        -- Merge all spell tables into self.classSpell, change class to name of class IE: druid or monk
        self.classSpell = {} 
        self.classSpell = mergeTables(self.classSpell,self.classAbilities)
        self.classSpell = mergeTables(self.classSpell,self.classArtifacts)
        self.classSpell = mergeTables(self.classSpell,self.classBuffs)
        self.classSpell = mergeTables(self.classSpell,self.classDebuffs)
        self.classSpell = mergeTables(self.classSpell,self.classGlyphs)
        self.classSpell = mergeTables(self.classSpell,self.classSpecials)
        self.classSpell = mergeTables(self.classSpell,self.classTalents) 

    ------------------
    --- OOC UPDATE ---
    ------------------

        function self.classUpdateOOC() -- Add any functions or variables that need to be updated only when not in combat here
            -- Call baseUpdateOOC()
            self.baseUpdateOOC()
            self.getClassArtifacts()
            self.getClassArtifactRanks()
            self.getClassGlyphs()
            self.getClassTalents()
            self.getClassPerks()
        end

    --------------
    --- UPDATE ---
    --------------

        function self.classUpdate() -- Add any functions or variables that need to be updated all the time here
            -- Call baseUpdate()
            self.baseUpdate()
            self.getClassDynamicUnits()
            self.getClassEnemies()
            self.getClassBuffs()
            self.getClassCastable()
            self.getClassCharges()
            self.getClassCooldowns()
            self.getClassDebuffs()
            self.getClassToggleModes()

            -- Update Energy Regeneration
            self.powerRegen  = getRegen("player")
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getClassDynamicUnits() -- Dynamic Target Selection based on Range and AoE/Non-AoE - NOTE: some more common ones are already setup in cCharacter.lua
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn10 = dynamicTarget(10,true) -- Sample Non-AoE

            -- AoE
            self.units.dyn35AoE = dynamicTarget(35, false) -- Sample AoE 
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getClassEnemies() -- sets table of enemies for specified ranges useful for knowing number of enemies in a certain ranges or target cycleing
            local getEnemies = getEnemies

            self.enemies.yards5 = getEnemies("player", 5) -- Melee
            self.enemies.yards8 = getEnemies("player", 8) -- Typical Melee AoE Range
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getClassArtifacts() -- Dynamicaly creates artifact lists based on the spell table above - NOTE: Change self.classArtifactss to the name of the artifact table)
            local isKnown = isKnown

            for k,v in pairs(self.classArtifacts) do
                self.artifact[k] = isKnown(v)
            end
        end

        function self.getClassArtifactRanks() -- Not yet implemented

        end

    -------------
    --- BUFFS ---
    -------------
    
        function self.getClassBuffs() -- Dynamicaly creates buff lists based on the spell table above - NOTE: Change self.classBuffs to the name of the buff table)
            local UnitBuffID = UnitBuffID
            local getBuffDuration = getBuffDuration
            local getBuffRemain = getBuffRemain

            for k,v in pairs(self.classBuffs) do
                self.buff[k] = UnitBuffID("player",v) ~= nil
                self.buff.duration[k] = getBuffDuration("player",v) or 0
                self.buff.remain[k] = getBuffRemain("player",v) or 0
            end
        end

    ---------------
    --- CHARGES ---
    ---------------
        function self.getClassCharges() -- Dynamicaly creates charge lists based on the spell/buff table above - NOTE: Change self.classSpells/self.classBuffs to the name of the spell/buff table)
            local getCharges = getCharges

            for k,v in pairs(self.classSpells) do
                self.charges[k] = getCharges(v)
            end
            for k,v in pairs(self.classBuffs) do
                self.charges[k] = getBuffStacks("player",v,"player")
            end
        end

    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getClassCooldowns() -- Dynamicaly creates cooldown lists based on the spell table above - NOTE: Change self.classCooldowns to the name of the cooldown table)
            local getSpellCD = getSpellCD

            for k,v in pairs(self.classSpell) do
                if getSpellCD(v) ~= nil then
                    self.cd[k] = getSpellCD(v)
                end
            end
        end

    ---------------
    --- DEBUFFS ---
    ---------------

        function self.getClassDebuffs() -- Dynamicaly creates debuff lists based on the debuff table above - NOTE: Change self.classDebuffs to the name of the debuff table)
            local UnitDebuffID = UnitDebuffID
            local getDebuffDuration = getDebuffDuration
            local getDebuffRemain = getDebuffRemain

            for k,v in pairs(self.classDebuffs) do
                self.debuff[k] = UnitDebuffID(self.units.dyn5,v,"player") ~= nil
                self.debuff.duration[k] = getDebuffDuration(self.units.dyn5,v,"player") or 0
                self.debuff.remain[k] = getDebuffRemain(self.units.dyn5,v,"player") or 0
            end
        end

    --------------
    --- GLYPHS ---
    --------------

        function self.getClassGlyphs() -- Gylphs not so important in legion so not yet reimplemented
            local hasGlyph = hasGlyph

            -- self.glyph.cheetah           = hasGlyph(self.spell.glyphOfTheCheetah)
        end

    -------------
    --- PERKS ---
    -------------

        function self.getClassPerks() -- no longer used in Legion
            local isKnown = isKnown

            -- self.perk.enhancedRebirth = isKnown(self.spell.enhancedRebirth)
        end

    -----------------
    --- RECHARGES ---
    -----------------
    
        function self.getClassRecharges() -- Dynamicaly creates recharge list based on the spell table above - NOTE: Change self.classSpells to the name of the spell table)
            local getRecharge = getRecharge

            for k,v in pairs(self.classSpells) do
                self.recharge[k] = getRecharge(v)
            end
        end

    ----------------
    --- TALENTS ---
    ----------------

        function self.getClassTalents() -- Dynamicaly creates talent list based on the talent table above - NOTE: Change self.classTalents to the name of the talent table)
            local getTalent = getTalent

            for r = 1, 7 do --search each talent row
                for c = 1, 3 do -- search each talent column
                    local talentID = select(6,GetTalentInfo(r,c,GetActiveSpecGroup())) -- ID of Talent at current Row and Column
                    for k,v in pairs(self.classTalents) do
                        if v == talentID then
                            self.talent[k] = getTalent(r,c)
                        end
                    end
                end
            end
        end            

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getClassToggleModes() -- Toggle State checks for Toggles shared by all specs

            self.mode.rotation      = bb.data["Rotation"]
            self.mode.cooldown      = bb.data["Cooldown"]
            self.mode.defensive     = bb.data["Defensive"]
            self.mode.interrupt     = bb.data["Interrupt"]
        end

        -- Create the toggle defined within rotation files *DO NOT EDIT*
        function self.createClassToggles()
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

        -- Class options
        -- Options which every Paladin should have
        function self.createClassOptions()
            -- Class Wrap
            local section = bb.ui:createSection(bb.ui.window.profile,  "Class Options", "Nothing")
                -- List Class Wide Options Here
            bb.ui:checkSectionState(section)
        end

    --------------
    --- SPELLS --- -- List spell cast functions for spells available to all specs in class here.
    --------------

        function self.getClassCastable()
            self.castable.sampleSpell     = self.castSampleSpell("target",true) -- not required but useful to see if base spell cast conditions are being met
        end

        function self.castSampleSpell(thisUnit,debug)
            local spellCast = self.spell.sampleSpell -- localized spell id you are trying to cast, this helps standardize cast functions for easy copy paste edit.
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end -- Nil error catch, change what thisUnit equals to correct default spell target (IE: "player", "target", self.units.dyn5)
            if debug == nil then debug = false end

            if self.level >= 29 and self.power > 40 and self.buff.stealth and getDistance(thisUnit) < 5 then -- Minimal requirements to cast spell (Level, Talent, Power, Cooldown, Range, Etc)
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true) -- Returns True if debugging and spell is castable
                else
                    return castSpell(thisUnit,spellCast,false,false,false) -- Returns actual spell casting
                end
            elseif debug then
                return false -- Debugging False Return
            end
        end
        

    ------------------------
    --- CUSTOM FUNCTIONS --- -- List all custom functions used by all Paladins here 
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

        function useCleave()
            if self.mode.cleave==1 and self.mode.rotation < 3 then
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
    end --End function cRogue:new(spec)
end -- End Select 

