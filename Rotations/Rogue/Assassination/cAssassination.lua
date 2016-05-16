--- Assassination Class
-- Inherit from: ../cCharacter.lua and ../cRogue.lua
if select(2, UnitClass("player")) == "ROGUE" then

    cAssassination = {}
    cAssassination.rotations = {}

    -- Creates Combat Rogue
    function cAssassination:new()
        local self = cRogue:new("Assassination")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cAssassination.rotations

        -----------------
        --- VARIABLES ---
        -----------------

        self.enemies = {
            yards5,
            yards8,
            yards12,
        }
        self.assassinationSpell = {
            -- Ability - Offensive
            dispatch                = 111240,
            envenom                 = 32645,
            mutilate                = 1329,
            vendetta                = 79140,
            
            -- Buff - Offensive
            blindsideBuff           = 121153,
            envenomBuff             = 32645,

            -- Debuff - Offensive
            vendettaDebuff          = 79140,

            -- Glyphs
            vendettaGlyph           = 63249,

            -- Perks
            empoweredEnvenom        = 157569,
            enhancedCrimsonTempest  = 157561,
            enhancedVendetta        = 157514,
            improvedSliceAndDice    = 157513,
        }
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.rogueSpell, self.assassinationSpell)

        ------------------
        --- OOC UPDATE ---
        ------------------

        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()

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
            self.getBuffsDuration()
            self.getBuffsRemain()
            self.getDynamicUnits()
            self.getDebuffs()
            self.getDebuffsDuration()
            self.getDebuffsRemain()
            self.getCooldowns()
            self.getEnemies()
            self.getRotation()


            -- Casting and GCD check
            -- TODO: -> does not use off-GCD stuff like pots, dp etc
            if castingUnit() then
                return
            end


            -- Start selected rotation
            self:startRotation()
        end

        -------------
        --- BUFFS ---
        -------------

        function self.getBuffs()
            local UnitBuffID = UnitBuffID

            self.buff.blindside = UnitBuffID("player",self.spell.blindsideBuff)~=nil or false
            self.buff.envenom = UnitBuffID("player",self.spell.envenomBuff)~=nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            self.buff.duration.blindside = getBuffRemain("player",self.spell.blindsideBuff) or 0
            self.buff.duration.envenom = getBuffDuration("player",self.spell.envenomBuff) or 0
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            self.buff.remain.blindside = getBuffRemain("player", self.spell.blindsideBuff) or 0
            self.buff.remain.envenom = getBuffRemain("player",self.spell.envenomBuff) or 0
        end

        ---------------
        --- DEBUFFS ---
        ---------------
        function self.getDebuffs()
            local UnitDebuffID = UnitDebuffID

            self.debuff.vendetta = UnitDebuffID(self.units.dyn5,self.spell.vendettaDebuff,"player")~=nil or false
        end

        function self.getDebuffsDuration()
            local getDebuffDuration = getDebuffDuration

            self.debuff.duration.vendetta = getDebuffDuration(self.units.dyn5,self.spell.vendettaDebuff,"player") or 0
        end

        function self.getDebuffsRemain()
            local getDebuffRemain = getDebuffRemain

            self.debuff.remain.vendetta = getDebuffRemain(self.units.dyn5,self.spell.vendettaDebuff,"player") or 0
        end
        -----------------
        --- COOLDOWNS ---
        -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            self.cd.vendetta = getSpellCD(self.spell.vendetta)
        end

        --------------
        --- GLYPHS ---
        --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            self.glyph.vendetta = hasGlyph(self.spell.vendettaGlyph)
        end

        ---------------
        --- TALENTS ---
        ---------------

        function self.getTalents()
            --local isKnown = isKnown

            --self.talent. = isKnown(self.spell.)
        end

        -------------
        --- PERKS ---
        -------------

        function self.getPerks()
            local isKnown = isKnown

            self.perk.empoweredEnvenom          = isKnown(self.spell.empoweredEnvenom)
            self.perk.enhancedCrimsonTempest    = isKnown(self.spell.enhancedCrimsonTempest)
            self.perk.enhancedVendetta          = isKnown(self.spell.enhancedVendetta)
            self.perk.improvedSliceAndDice      = isKnown(self.spell.improvedSliceAndDice)
        end

        ---------------------
        --- DYNAMIC UNITS ---
        ---------------------

        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn15 = dynamicTarget(15, true) -- Death from Above
            self.units.dyn20 = dynamicTarget(20, true) -- Shadow Reflection
            self.units.dyn20AoE = dynamicTarget(20, false)

            -- AoE
        end

        ---------------
        --- ENEMIES ---
        ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5 = #getEnemies("player", 5)
            self.enemies.yards10 = #getEnemies("player", 10) -- Crimson Tempest, Fan of Knives
            self.enemies.yards12 = #getEnemies("player", 12)
        end

        ---------------
        --- TOGGLES ---
        ---------------

        function self.getToggleModes()
            local BadBoy_data   = BadBoy_data

            self.mode.aoe       = BadBoy_data["AoE"]
            self.mode.cooldowns = BadBoy_data["Cooldowns"]
            self.mode.defensive = BadBoy_data["Defensive"]
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

        -- Dispatch
        function self.castDispatch(cycle)
            if cycle ~= nil then
                for i = 1, #enemiesTable do
                    if enemiesTable[i].distance < 5 then
                        local thisUnit = enemiesTable[i].unit
                        local targetHP = getHP(thisUnit)
                        local deadlyPoision = getDebuffRemain(thisUnit, self.spell.deadlyPoison, "player")
                        if (targetHP < 35 or self.buff.blindside) and deadlyPoision < 4 then
                            return castSpell(thisUnit,self.spell.dispatch,false,false,false) == true or false
                        end
                    end
                end
            else
                local thisUnit = self.units.dyn5
                local targetHP = getHP(thisUnit)
                if (targetHP < 35 or self.buff.blindside) then
                    return castSpell(thisUnit, self.spell.dispatch, false, false) == true or false
                end
            end
        end

        function self.castDispatch2(thisUnit)
            local thisUnit = thisUnit or "target"
            if self.power>30 and self.level>=40 and ObjectExists(thisUnit) then
                return castSpell(thisUnit,self.spell.dispatch,false,false,false) == true or false
            end
        end

        -- Envenom
        function self.castEnvenom(cycle)
            if cycle ~= nil then
                for i = 1, #enemiesTable do
                    if enemiesTable[i].distance < 5 then
                        local thisUnit = enemiesTable[i].unit
                        local deadlyPoision = getDebuffRemain(thisUnit, self.spell.deadlyPoison, "player")
                        if deadlyPoision < 4 then
                            return castSpell(thisUnit,self.spell.envenom,false,false,false) == true or false
                        end
                    end
                end
            else
                local thisUnit = self.units.dyn5
                return castSpell(thisUnit, self.spell.envenom, false, false) == true or false
            end
        end

        function self.castEnvenom2(thisUnit)
            local thisUnit = thisUnit or "target"
            if self.power>35 and self.level>=20 and self.comboPoints>0 and ObjectExists(thisUnit) then
                return castSpell(thisUnit,self.spell.envenom,false,false,false) == true or false
            end
        end

        -- Mutilate
        function self.castMutilate(cycle)
            if cycle ~= nil then
                for i = 1, #enemiesTable do
                    if enemiesTable[i].distance < 5 then
                        local thisUnit = enemiesTable[i].unit
                        local targetHP = getHP(thisUnit)
                        local deadlyPoision = getDebuffRemain(thisUnit, self.spell.deadlyPoison, "player")
                        if targetHP > 35 and deadlyPoision < 4 then
                            return castSpell(thisUnit,self.spell.mutilate,true,false,false) == true or false
                        end
                    end
                end
            else
                local thisUnit = self.units.dyn5
                local targetHP = getHP(thisUnit)
                if targetHP > 35 then
                    return castSpell(thisUnit, self.spell.mutilate,true,false,false) == true or false
                end
            end
        end

        function self.castMutilate2(thisUnit)
            local thisUnit = thisUnit or "target"
            if self.power>55 and self.level>=10 then
                return castSpell(thisUnit,self.spell.mutilate,false,false,false) == true or false
            end
        end

        -- Vendetta
        function self.castVendetta()
            if self.cd.vendetta==0 and self.level>=80 then --and (isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 4 * UnitHealthMax("player"))) then
                return castSpell(self.units.dyn5,self.spell.vendetta,false,false,false) == true or false
            end
        end

        ------------------------
        --- CUSTOM FUNCTIONS ---
        ------------------------

        --Rupture Debuff Time Remaining
        function ruptureRemain(unit)
            return getDebuffRemain(unit,rogueAssassination.spell.ruptureDebuff,"player")
        end

        --Rupture Debuff Total Time
        function ruptureDuration(unit)
            return getDebuffDuration(unit,rogueAssassination.spell.ruptureDebuff,"player")
        end

        --Deadly Poison Remain
        function deadlyRemain(unit)
            return getDebuffRemain(unit,rogueAssassination.spell.deadlyPoisonDebuff,"player")
        end

        --Envenom Remain
        function envenomRemain(unit)
            return getBuffRemain("player",rogueAssassination.spell.envenomBuff)
        end

        --Internal Bleeding Debuff Time Remaining
        function internalBleedingRemain(unit)
            return getDebuffRemain(unit,rogueAssassination.spell.internalBleedingDebuff,"player")
        end

        --Internal Bleeding Debuff Total Time
        function internalBleedingDuration(unit)
            return getDebuffDuration(unit,rogueAssassination.spell.internalBleedingDebuff,"player")
        end

        --Sap Debuff Time Remaining
        function sapRemain(unit)
            return getDebuffRemain(unit,rogueAssassination.spell.sapDebuff,"player")
        end

        --Target HP
        function thp(unit)
          return getHP(unit)
        end

        --Target Time to Die
        function ttd(unit)
          return getTTD(unit)
        end

        function useCDs()
            if (BadBoy_data['Cooldown'] == 1 and isBoss()) or BadBoy_data['Cooldown'] == 2 then
                return true
            else
                return false
            end
        end

        function useAoE()
            if (BadBoy_data['Rotation'] == 1 and #getEnemies("player",8) > 1) or BadBoy_data['Rotation'] == 2 then
                return true
            else
                return false
            end
        end

        function useDefensive()
            if BadBoy_data['Defensive'] == 1 then
                return true
            else
                return false
            end
        end

        function useInterrupts()
            if BadBoy_data['Interrupt'] == 1 then
                return true
            else
                return false
            end
        end

        function useCleave()
            if BadBoy_data['Cleave']==1 and BadBoy_data['Rotation'] < 3 then
                return true
            else
                return false
            end
        end

        function canPP() --Pick Pocket Toggle State
            if BadBoy_data['Picker'] == 1 or BadBoy_data['Picker'] == 2 then
                return true
            else
                return false
            end
        end

        function noattack() --Pick Pocket Toggle State
            if BadBoy_data['Picker'] == 2 then
                return true
            else
                return false
            end
        end

        function isPicked()   --  Pick Pocket Testing
            if GetObjectExists("target") then
                if myTarget ~= UnitGUID("target") then
                    canPickpocket = true
                    myTarget = UnitGUID("target")
                end
            end
            if (canPickpocket == false or BadBoy_data['Picker'] == 3 or GetNumLootItems()>0) then
                return true
            else
                return false
            end
        end

        function hasThreat()
            local dynTar = dynamicTarget(40,true)
            if select(1,UnitDetailedThreatSituation("player", "target")) == nil then
                return false
            elseif select(1,UnitDetailedThreatSituation("player", "target"))==true then
                return true
            end
        end

        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        -- Return
        return self
    end-- cCombat
end-- select Rogue
