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

        function self.startRotation()
            if self.rotation == 1 then
                self:assassinationSimC()
                -- put different rotations below; dont forget to setup your rota in options
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
            thisConfig = 0

            -- Title
            CreateNewTitle(thisConfig, "Assassination")

            -- Create Base and Class options
            self.createClassOptions()

            -- Combat options
            CreateNewWrap(thisConfig, "--- General ---");

            -- Rotation
            CreateNewDrop(thisConfig, "Rotation", 1, "Select Rotation.", "|cff00FF00SimC", "|cff00FF00CuteOne", "|cff00FF00OLD_ONE");
            CreateNewText(thisConfig, "Rotation");

            -- Dummy DPS Test
            --CreateNewCheck(thisConfig,"DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.");
            --CreateNewBox(thisConfig,"DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            --CreateNewText(thisConfig,"DPS Testing");

            -- Stealth
            CreateNewCheck(thisConfig, "Stealth");
            CreateNewDrop(thisConfig, "Stealth", 1, "Stealthing method.", "|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards");
            CreateNewText(thisConfig, "Stealth");
            CreateNewBox(thisConfig, "Stealth Timer", 0, 2, 0.25, 1, "|cffFFBB00How long to wait(seconds) before using \n|cffFFFFFFStealth.");
            CreateNewText(thisConfig, "Stealth Timer");

            -- Opening Attack
            CreateNewDrop(thisConfig,"Opener", 1, "|cffFFFFFFSelect Attack to Break Stealth with",
                "Ambush",
                "Mutilate",
                "Cheap Shot")
            CreateNewText(thisConfig,"Opener")

            -- Spacer
            CreateNewText(thisConfig, " ");
            CreateNewWrap(thisConfig, "--- Cooldowns ---");

            -- Agi Pot
            --CreateNewCheck(thisConfig,"Agi-Pot");
            --CreateNewText(thisConfig,"Agi-Pot");

            -- Legendary Ring
            CreateNewCheck(thisConfig, "Legendary Ring", "Enable or Disable usage of Legendary Ring.");
            CreateNewDrop(thisConfig, "Legendary Ring", 2, "CD")
            CreateNewText(thisConfig, "Legendary Ring");

            -- Preparation
            CreateNewCheck(thisConfig, "Preparation", "Enable or Disable usage of Preparation.");
            CreateNewDrop(thisConfig, "Preparation", 2, "CD")
            CreateNewText(thisConfig, "Preparation");

            -- Vanish
            CreateNewCheck(thisConfig, "Vanish - Offensive", "Enable or Disable usage of Vanish.");
            CreateNewDrop(thisConfig, "Vanish - Offensive", 2, "CD")
            CreateNewText(thisConfig, "Vanish - Offensive");

            -- Vendetta
            CreateNewCheck(thisConfig, "Vendetta", "Enable or Disable usage of Vendetta.");
            CreateNewDrop(thisConfig, "Vendetta", 2, "CD")
            CreateNewText(thisConfig, "Vendetta");

            -- Spacer
            CreateNewText(thisConfig," ");
            CreateNewWrap(thisConfig,"--- Defensive ---");

            -- Cloak of Shadows
            if isKnown(self.spell.cloakOfShadows) then
                CreateNewCheck(thisConfig,"Cloak of Shadows","Enable or Disable the usage to auto dispel")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.cloakOfShadows))))
            end

            -- Combat Readiness
            if self.talent.combatReadiness then
                CreateNewCheck(thisConfig,"Combat Readiness","Set health percent threshhold to cast at - In Combat Only!")
                CreateNewBox(thisConfig,"Combat Readiness", 0, 100, 5, 40, "|cffFFFFFFHealth Percent to Cast At")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.combatReadiness))))
            end

            -- Evasion
            if isKnown(self.spell.evasion) then
                CreateNewCheck(thisConfig,"Evasion","Set health percent threshhold to cast at - In Combat Only!")
                CreateNewBox(thisConfig,"Evasion", 0, 100, 5, 40, "|cffFFFFFFHealth Percent to Cast At")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.evasion))))
            end

            -- Feint
            if isKnown(self.spell.feint) then
                CreateNewCheck(thisConfig,"Feint","Set health percent threshhold to cast at - In Combat Only!")
                CreateNewBox(thisConfig,"Feint", 0, 100, 5, 40, "|cffFFFFFFHealth Percent to Cast At")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.feint))))
            end

            -- Healthstone
            CreateNewCheck(thisConfig,"Healthstone");
            CreateNewBox(thisConfig,"Healthstone", 0, 100, 5, 60, "|cffFFBB00Health Percentage to use at.");
            CreateNewText(thisConfig,"Healthstone");

            -- Heirloom Neck
            CreateNewCheck(thisConfig,"Heirloom Neck");
            CreateNewBox(thisConfig,"Heirloom Neck", 0, 100, 5, 60, "|cffFFBB00Health Percentage to use at.");
            CreateNewText(thisConfig,"Heirloom Neck");

            -- Recuperate
            if isKnown(self.spell.recuperate) then
                CreateNewCheck(thisConfig,"Recuperate","Set health percent and combo point threshhold to cast at")
                CreateNewBox(thisConfig,"Recuperate Health %", 0, 100, 5, 40, "|cffFFFFFFHealth Percent to Cast At")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.recuperate))).." Health %")
                CreateNewBox(thisConfig,"Recuperate Combo Point", 1, 5, 1, 3, "|cffFFFFFFCombo Points to Use At")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.recuperate))).." Combo Points")
            end

            --Shiv
            if isKnown(self.spell.shiv) and getTalent(3,2) then
                CreateNewCheck(thisConfig,"Shiv","Set health percent threshhold to cast at - In Combat Only!")
                CreateNewBox(thisConfig,"Shiv", 0, 100, 5, 40, "|cffFFFFFFHealth Percent to Cast At")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.shiv))))
            end 

            -- Smoke Bomb
            if isKnown(self.spell.smokeBomb) then
                CreateNewCheck(thisConfig,"Smoke Bomb","Set health percent threshhold to cast at - In Combat Only!")
                CreateNewBox(thisConfig,"Smoke Bomb", 0, 100, 5, 40, "|cffFFFFFFHealth Percent to Cast At")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.smokeBomb))))
            end

            -- Vanish - Defensive
            if isKnown(self.spell.vanish) then
                CreateNewCheck(thisConfig,"Vanish - Defensive","Set health percent threshhold to cast at - Defensive Use Only, see Cooldowns for Offensive Use")
                CreateNewBox(thisConfig,"Vanish - Defensive", 0, 100, 5, 40, "|cffFFFFFFHealth Percent to Cast At")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.vanish))).." - Defensive")
            end 

            -- Spacer --
            CreateNewText(thisConfig," ");
            CreateNewWrap(thisConfig,"--- Interrupts ---");

            -- Kick
            CreateNewCheck(thisConfig,"Kick")
            CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.kick))))

          
            if getTalent(5,3) then
            -- Gouge
                CreateNewCheck(thisConfig,"Gouge")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.gouge))))

            -- Blind
                CreateNewCheck(thisConfig,"Blind")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.blind)))) 
            end

            -- Interrupt Percentage
            CreateNewCheck(thisConfig,"Interrupt At");
            CreateNewBox(thisConfig, "Interrupt At", 0, 95, 5, 0, "|cffFFBB00Cast Percentage to use at.");
            CreateNewText(thisConfig,"Interrupt At");

            -- Spacer
            CreateNewText(thisConfig, " ");
            CreateNewWrap(thisConfig, "--- Toggle Keys ---");

            -- Single/Multi Toggle
            CreateNewCheck(thisConfig, "Rotation Mode", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFRotation Mode Toggle Key|cffFFBB00.");
            CreateNewDrop(thisConfig, "Rotation Mode", 4, "Toggle")
            CreateNewText(thisConfig, "Rotation Mode");

            --Cooldown Key Toggle
            CreateNewCheck(thisConfig, "Cooldown Mode", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFCooldown Mode Toggle Key|cffFFBB00.");
            CreateNewDrop(thisConfig, "Cooldown Mode", 3, "Toggle")
            CreateNewText(thisConfig, "Cooldown Mode")

            --Defensive Key Toggle
            CreateNewCheck(thisConfig, "Defensive Mode", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFDefensive Mode Toggle Key|cffFFBB00.");
            CreateNewDrop(thisConfig, "Defensive Mode", 6, "Toggle")
            CreateNewText(thisConfig, "Defensive Mode")

            -- Interrupts Key Toggle
            CreateNewCheck(thisConfig, "Interrupt Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFInterrupt Mode Toggle Key|cffFFBB00.")
            CreateNewDrop(thisConfig, "Interrupt Mode", 6, "Toggle")
            CreateNewText(thisConfig, "Interrupts")

            -- Cleave Toggle
            CreateNewCheck(thisConfig, "Cleave Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFCleave Toggle Key|cffFFBB00.")
            CreateNewDrop(thisConfig, "Cleave Mode", 6, "Toggle")
            CreateNewText(thisConfig, "Cleave Mode")

            -- Pick Pocket Toggle
            CreateNewCheck(thisConfig, "Pick Pocket Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFPick Pocket Toggle Key|cffFFBB00.")
            CreateNewDrop(thisConfig, "Pick Pocket Mode", 6, "Toggle")
            CreateNewText(thisConfig, "Pick Pocket Mode")

            -- Pause Toggle
            CreateNewCheck(thisConfig, "Pause Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFPause Toggle Key - None Defaults to LeftAlt|cffFFBB00.")
            CreateNewDrop(thisConfig, "Pause Mode", 6, "Toggle")
            CreateNewText(thisConfig, "Pause Mode")

            -- General Configs
            CreateGeneralsConfig();

            WrapsManager();
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
                return castSpell(thisUnit,self.spell.dispatch,true,false,false) == true or false
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
                return castSpell(thisUnit,self.spell.envenom,true,false,false) == true or false
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
            if self.cd.vendetta==0 and self.level>=80 and (isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 4 * UnitHealthMax("player"))) then
                if castSpell(self.units.dyn30, self.spell.vendetta, true, false) then
                    return true
                end
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
