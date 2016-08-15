--- Spec Class
-- Inherit from: ../cCharacter.lua and ../cClass.lua
if select(2,GetSpecializationInfo(GetSpecialization())) == specID then -- Change specID to ID of spec. IE: https://github.com/MrTheSoulz/NerdPack/wiki/Class-&-Spec-IDs
    cSpec = {} -- Change cSpec to name of spec. IE: cFeral or cWindwalker
    cSpec.rotations = {} -- Change cSpec to name of spec. IE: cFeral or cWindwalker

    -- Creates Spec
    function cSpec:new() -- Change cSpec to name of spec. IE: cFeral or cWindwalker
        local self = cClass:new("Spec") -- Change cClass to name of class and "Spec" to name of spec. IE: cDruid or cMonk for cClass and "Feral" or "Windwalker" for "Spec"

        local player = "player" -- if someone forgets ""

        -- Mandatory ! - DO NOT EDIT
        self.rotations = cSpec.rotations
        
        -----------------
        --- VARIABLES --- -- Only list tables specific to this Spec -- change all spec entries to name of spec IE: feral or windwalker
        -----------------
        self.specArtifacts     = {
            
        }
        self.specBuffs         = {
            
        }
        self.specDebuffs       = {
            
        }
        self.specSpecials      = {
           
        }
        self.specTalents       = {
             
        }
        -- Merge all spell tables into self.spell
        self.specSpells = {}
        self.specSpells = mergeTables(self.specSpells,self.specArtifacts)
        self.specSpells = mergeTables(self.specSpells,self.specBuffs)
        self.specSpells = mergeTables(self.specSpells,self.specDebuffs)
        self.specSpells = mergeTables(self.specSpells,self.specSpecials)
        self.specSpells = mergeTables(self.specSpells,self.specTalents)
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.classSpell, self.specSpells) -- Also change self.classSpell to name of class IE: druid or monk
        
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
            self.getPerks() --Removed in Legion
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

            self.enemies.yards5 = getEnemies("player", 5) -- Melee
            self.enemies.yards8 = getEnemies("player", 8) -- Typical Melee AoE Range
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getArtifacts() -- Dynamicaly creates artifact lists based on the spell table above - NOTE: Change self.specArtifactss to the name of the artifact table)
            local isKnown = isKnown

            for k,v in pairs(self.specArtifacts) do
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

            for k,v in pairs(self.specBuffs) do
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

            for k,v in pairs(self.specSpells) do
                self.charges[k] = getCharges(v)
            end
            for k,v in pairs(self.specBuffs) do
                self.charges[k] = getBuffStacks("player",v,"player")
            end
        end

    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getCooldowns() -- Dynamicaly creates cooldown lists based on the spell table above - NOTE: Change self.specCooldowns to the name of the cooldown table)
            local getSpellCD = getSpellCD

            for k,v in pairs(self.specSpell) do
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

            for k,v in pairs(self.specDebuffs) do
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

            for k,v in pairs(self.specSpells) do
                self.recharge[k] = getRecharge(v)
            end
        end

    ----------------
    --- TALENTS ---
    ----------------

        function self.getTalents() -- Dynamicaly creates talent list based on the talent table above - NOTE: Change self.specTalents to the name of the talent table)
            local getTalent = getTalent

            for r = 1, 7 do --search each talent row
                for c = 1, 3 do -- search each talent column
                    local talentID = select(6,GetTalentInfo(r,c,GetActiveSpecGroup())) -- ID of Talent at current Row and Column
                    for k,v in pairs(self.specTalents) do
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

        function self.getCastable()
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
    --- CUSTOM FUNCTIONS --- -- List all custom functions used only by this spec here 
    ------------------------
        

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cSpec
end-- select Class