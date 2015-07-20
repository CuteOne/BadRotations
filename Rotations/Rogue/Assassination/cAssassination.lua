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
            -- Buff
            blindside = 121153,
            -- Defensive
            -- Offensive
            dispatch = 111240,
            envenom = 32645,
            fanOfKnives = 51723,
            mutilate = 1329,
            rupture = 1943,
            vendetta = 79140,
            -- Misc
            -- Poison
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
            self.getDebuffs()
            self.getCooldowns()
            self.getDynamicUnits()
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
            local getBuffRemain = getBuffRemain

            self.buff.blindside = getBuffRemain("player", self.spell.blindside)
            self.buff.envenom   = getBuffRemain("player", self.spell.envenom)
        end

        ---------------
        --- DEBUFFS ---
        ---------------
        function self.getDebuffs()
            local getDebuffRemain, getDebuffDuration = getDebuffRemain, getDebuffDuration

            self.debuff.rupture         = getDebuffRemain(self.units.dyn5, self.spell.rupture, "player") or 0
            self.debuff.ruptureDuration = getDebuffDuration(self.units.dyn5, self.spell.rupture, "player") or 0
            self.debuff.crimsonTempest  = getDebuffRemain(self.units.dyn5, self.spell.crimsonTempest, "player") or 0
            self.debuff.vendetta        = getDebuffRemain(self.units.dyn5, self.spell.vendetta, "player") or 0
            self.debuff.deadlyPoison    = getDebuffRemain(self.units.dyn5, self.spell.deadlyPoison, "player") or 0
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
            --local hasGlyph = hasGlyph

            --self.glyph.   = hasGlyph()
        end

        ---------------
        --- TALENTS ---
        ---------------

        function self.getTalents()
            --local isKnown = isKnown

            --self.talent. = isKnown(self.spell.)
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
            CreateNewTitle(thisConfig, "Assassination Defmaster")

            -- Create Base and Class options
            self.createClassOptions()

            -- Combat options
            CreateNewWrap(thisConfig, "--- General ---");

            -- Rotation
            CreateNewDrop(thisConfig, "Rotation", 1, "Select Rotation.", "|cff00FF00SimC", "|cff00FF00OLD_ONE");
            CreateNewText(thisConfig, "Rotation");

            -- Dummy DPS Test
            --CreateNewCheck(thisConfig,"DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.");
            --CreateNewBox(thisConfig,"DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            --CreateNewText(thisConfig,"DPS Testing");

            -- Stealth Timer
            CreateNewCheck(thisConfig, "Stealth Timer");
            CreateNewBox(thisConfig, "Stealth Timer", 0, 2, 0.25, 1, "|cffFFBB00How long to wait(seconds) before using \n|cffFFFFFFStealth.");
            CreateNewText(thisConfig, "Stealth Timer");

            -- Stealth
            CreateNewCheck(thisConfig, "Stealth");
            CreateNewDrop(thisConfig, "Stealth", 1, "Stealthing method.", "|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards");
            CreateNewText(thisConfig, "Stealth");

            -- Spacer
            CreateNewText(thisConfig, " ");
            CreateNewWrap(thisConfig, "--- Cooldowns ---");

            -- Agi Pot
            --CreateNewCheck(thisConfig,"Agi-Pot");
            --CreateNewText(thisConfig,"Agi-Pot");

            -- Vanish
            CreateNewCheck(thisConfig, "Vanish", "Enable or Disable usage of Vanish.");
            CreateNewDrop(thisConfig, "Vanish", 2, "CD")
            CreateNewText(thisConfig, "Vanish");

            -- Vendetta
            CreateNewCheck(thisConfig, "Vendetta", "Enable or Disable usage of Vendetta.");
            CreateNewDrop(thisConfig, "Vendetta", 2, "CD")
            CreateNewText(thisConfig, "Vendetta");

            -- Spacer
            CreateNewText(thisConfig, " ");
            CreateNewWrap(thisConfig, "--- Defensive ---");

            -- Healthstone
            --CreateNewCheck(thisConfig,"Pot/Stoned");
            --CreateNewBox(thisConfig,"Pot/Stoned", 0, 100, 5, 60, "|cffFFBB00Health Percentage to use at.");
            --CreateNewText(thisConfig,"Pot/Stoned");

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
            CreateNewText(thisConfig, "Cooldowns")

            --Defensive Key Toggle
            CreateNewCheck(thisConfig, "Defensive Mode", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFDefensive Mode Toggle Key|cffFFBB00.");
            CreateNewDrop(thisConfig, "Defensive Mode", 6, "Toggle")
            CreateNewText(thisConfig, "Defensive")

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

        -- Fan of Knives
        function self.castFanOfKnives()
            return castSpell("player", self.spell.fanOfKnives, true, false) == true or false
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
                            return castSpell(thisUnit,self.spell.mutilate,false,false,false) == true or false
                        end
                    end
                end
            else
                local thisUnit = self.units.dyn5
                local targetHP = getHP(thisUnit)
                if targetHP > 35 then
                    return castSpell(thisUnit, self.spell.mutilate, false, false) == true or false
                end
            end
        end

        -- Rupture
        function self.castRupture()
            return castSpell(self.units.dyn5, self.spell.rupture, false, false) == true or false
        end

        -- Rupture Cycle
        function self.castRuptureCycle()
            for i = 1, #enemiesTable do
                if enemiesTable[i].distance < 5 then
                    local thisUnit = enemiesTable[i].unit
                    local ruptureRemain   = getDebuffRemain(thisUnit,self.spell.rupture,"player")
                    local ruptureDuration = getDebuffDuration(thisUnit, self.spell.rupture, "player")
                    if ruptureRemain == 0 or ruptureRemain <= ruptureDuration*0.3 then
                        return castSpell(thisUnit, self.spell.rupture,false,false,false) == true or false
                    end
                end
            end
        end

        -- Vendetta
        function self.castVendetta()
            if isSelected("Vendetta") then
                if (isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 4 * UnitHealthMax("player"))) then
                    if castSpell(self.units.dyn30, self.spell.vendetta, true, false) then
                        return true
                    end
                end
            end
            return false
        end

        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()


        -- Return
        return self
    end-- cCombat
end-- select Rogue
