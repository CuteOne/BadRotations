--- Assassination Class
-- Inherit from: ../cCharacter.lua and ../cRogue.lua
if select(2, UnitClass("player")) == "ROGUE" then

    cAssassination = {}

    -- Creates Combat Rogue
    function cAssassination:new()
        local self = cRogue:new("Assassination")

        local player = "player" -- if someone forgets ""

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

        ----------------------
        --- START ROTATION ---
        ----------------------

        -- Rotation selection update
        function self.getRotation()
            self.rotation = bb.selectedProfile

            if bb.rotation_changed then
                --self.createToggles()
                self.createOptions()

                bb.rotation_changed = false
            end
        end

        function self.startRotation()
            if self.rotation == 1 then
                self:assassinationSimC()
                -- put different rotations below dont forget to setup your rota in options
            elseif self.rotation == 2 then
                self:AssassinationCuteOne()
            elseif self.rotation == 3 then
                self:oldAssassination()
            else
                ChatOverlay("No ROTATION ?!", 2000)
            end
        end

        ---------------
        --- OPTIONS ---
        ---------------

        function self.createOptions()
            bb.profile_window = createNewProfileWindow("Assassination")
            local section

            -- Create Base and Class options
            self.createClassOptions()

            -- Combat options
            section = createNewSection(bb.profile_window,  "--- General ---")
            -- Stealth
            createNewDropdown(section,  "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealthing method.")
            createNewSpinner(section,  "Stealth Timer",  1,  0,  2,  0.25,  "|cffFFBB00How long to wait(seconds) before using \n|cffFFFFFFStealth.")
            -- Opening Attack
            createNewDropdown(section, "Opener", {"Ambush", "Mutilate", "Cheap Shot"},  1, "|cffFFFFFFSelect Attack to Break Stealth with")
            checkSectionState(section) 

            
            section = createNewSection(bb.profile_window,  "--- Cooldowns ---")
            -- Agi Pot
            --createNewCheckbox(section,"Agi-Pot")
            -- Legendary Ring
            createNewCheckbox(section,  "Legendary Ring")
            -- Preparation
            createNewCheckbox(section,  "Preparation")
            -- Shadow Reflection
            createNewCheckbox(section,  "Shadow Reflection")
            -- Vanish
            createNewCheckbox(section,  "Vanish - Offensive")
            -- Vendetta
            createNewCheckbox(section,  "Vendetta")
            checkSectionState(section) 

            
            section = createNewSection(bb.profile_window, "--- Defensive ---")
            -- Cloak of Shadows
            if isKnown(self.spell.cloakOfShadows) then
                createNewCheckbox(section,"Cloak of Shadows","Enable or Disable the usage to auto dispel")
            end
            -- Combat Readiness
            createNewSpinner(section, "Combat Readiness",  40,  0,  100,  5, "Set health percent threshhold to cast at - In Combat Only!",  "|cffFFFFFFHealth Percent to Cast At")

            -- Evasion
            if isKnown(self.spell.evasion) then
                createNewSpinner(section, "Evasion",  40,  0,  100,  5, "Set health percent threshhold to cast at - In Combat Only!",  "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Feint
            if isKnown(self.spell.feint) then
                createNewSpinner(section, "Feint",  40,  0,  100,  5, "Set health percent threshhold to cast at - In Combat Only!",  "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Healthstone
            createNewSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Heirloom Neck
            createNewSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Recuperate
            if isKnown(self.spell.recuperate) then
                createNewSpinner(section, "Recuperate Health %",  40,  0,  100,  5, "Set health percent and combo point threshhold to cast at",  "|cffFFFFFFHealth Percent to Cast At")
                createNewSpinner(section, "Recuperate Combo Point",  3,  1,  5,  1, "Set health percent and combo point threshhold to cast at",  "|cffFFFFFFCombo Points to Use At")
            end
            --Shiv
            if isKnown(self.spell.shiv) and getTalent(3,2) then
                createNewSpinner(section, "Shiv",  40,  0,  100,  5, "Set health percent threshhold to cast at - In Combat Only!", "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Smoke Bomb
            if isKnown(self.spell.smokeBomb) then
                createNewSpinner(section, "Smoke Bomb",  40,  0,  100,  5, "Set health percent threshhold to cast at - In Combat Only!", "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Vanish - Defensive
            if isKnown(self.spell.vanish) then
                createNewSpinner(section, "Vanish - Defensive",  40,  0,  100,  5, "Set health percent threshhold to cast at - Defensive Use Only, see Cooldowns for Offensive Use", "|cffFFFFFFHealth Percent to Cast At")
            end
            checkSectionState(section)
            
            
            section = createNewSection(bb.profile_window, "--- Interrupts ---")
            -- Kick
            createNewCheckbox(section,"Kick")
            if getTalent(5,3) then
                -- Gouge
                createNewCheckbox(section,"Gouge")
                -- Blind
                createNewCheckbox(section,"Blind")
            end
            -- Interrupt Percentage
            createNewSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
            checkSectionState(section)
            

            section = createNewSection(bb.profile_window,  "--- Toggle Keys ---")
            -- Single/Multi Toggle
            createNewDropdown(section,  "Rotation Mode", bb.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            createNewDropdown(section,  "Cooldown Mode", bb.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            createNewDropdown(section,  "Defensive Mode", bb.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            createNewDropdown(section,  "Interrupt Mode", bb.dropOptions.Toggle,  6)
            -- Cleave Toggle
            createNewDropdown(section,  "Cleave Mode", bb.dropOptions.Toggle,  6)
            -- Pick Pocket Toggle
            createNewDropdown(section,  "Pick Pocket Mode", bb.dropOptions.Toggle,  6)
            -- Pause Toggle
            createNewDropdown(section,  "Pause Mode", bb.dropOptions.Toggle,  6)
            checkSectionState(section)



            --[[ Rotation Dropdown ]]--
            createNewRotationDropdown(bb.profile_window.parent, {"SimC", "CuteOne", "OLD_ONE"})
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

        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()


        -- Return
        return self
    end-- cCombat
end-- select Rogue
