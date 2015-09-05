--- Frosy Class
-- Inherit from: ../cCharacter.lua and ../cDeathKnight.lua
if select(2, UnitClass("player")) == "DEATHKNIGHT" then

    cFrost = {}

    -- Creates Frost Death Knight
    function cFrost:new()
        local self = cDK:new("Frost")

        local player = "player" -- if someone forgets ""

        -----------------
        --- VARIABLES ---
        -----------------

        self.enemies = {
            yards5,
            yards8,
            yards12,
        }
        self.frostSpell = {
            -- Ability - Offensive
            
            -- Buff - Offensive

            -- Debuff - Offensive

            -- Glyphs

            -- Perks
        }
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.dkSpell, self.frostSpell)

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

            -- self.buff.blindside = UnitBuffID("player",self.spell.blindsideBuff)~=nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            -- self.buff.duration.envenom = getBuffDuration("player",self.spell.envenomBuff) or 0
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            -- self.buff.remain.blindside = getBuffRemain("player", self.spell.blindsideBuff) or 0
        end

        ---------------
        --- DEBUFFS ---
        ---------------
        function self.getDebuffs()
            local UnitDebuffID = UnitDebuffID

            -- self.debuff.vendetta = UnitDebuffID(self.units.dyn5,self.spell.vendettaDebuff,"player")~=nil or false
        end

        function self.getDebuffsDuration()
            local getDebuffDuration = getDebuffDuration

            -- self.debuff.duration.vendetta = getDebuffDuration(self.units.dyn5,self.spell.vendettaDebuff,"player") or 0
        end

        function self.getDebuffsRemain()
            local getDebuffRemain = getDebuffRemain

            -- self.debuff.remain.vendetta = getDebuffRemain(self.units.dyn5,self.spell.vendettaDebuff,"player") or 0
        end
        -----------------
        --- COOLDOWNS ---
        -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            -- self.cd.vendetta = getSpellCD(self.spell.vendetta)
        end

        --------------
        --- GLYPHS ---
        --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            -- self.glyph.vendetta = hasGlyph(self.spell.vendettaGlyph)
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

            -- self.perk.empoweredEnvenom          = isKnown(self.spell.empoweredEnvenom)
        end

        ---------------------
        --- DYNAMIC UNITS ---
        ---------------------

        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn15 = dynamicTarget(15, true)
            self.units.dyn20 = dynamicTarget(20, true)

            -- AoE
        end

        ---------------
        --- ENEMIES ---
        ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5 = #getEnemies("player", 5)
            self.enemies.yards10 = #getEnemies("player", 10)
            self.enemies.yards12 = #getEnemies("player", 12)
        end

        ----------------------
        --- START ROTATION ---
        ----------------------

        function self.startRotation()
            if self.rotation == 1 then
                self:FrostCuteOne()
            elseif self.rotation == 2 then
                self:FrostOld()
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
            CreateNewTitle(thisConfig, "Frost")

            -- Create Base and Class options
            self.createClassOptions()

            -- Combat options
            CreateNewWrap(thisConfig, "--- General ---");

            -- Rotation
            CreateNewDrop(thisConfig, "Rotation", 1, "Select Rotation.", "|cff00FF00CuteOne", "|cff00FF00OLD");
            CreateNewText(thisConfig, "Rotation");

            -- Dummy DPS Test
            CreateNewCheck(thisConfig,"DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.");
            CreateNewBox(thisConfig,"DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            CreateNewText(thisConfig,"DPS Testing");

            -- Mouseover Targeting
            CreateNewCheck(thisConfig,"Mouseover Targeting","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFmouseover target validation.|cffFFBB00.")
            CreateNewText(thisConfig,"Mouseover Targeting")

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

            -- Flask / Crystal
            CreateNewCheck(thisConfig,"Flask / Crystal")
            CreateNewText(thisConfig,"Flask / Crystal")

            -- Trinkets
            CreateNewCheck(thisConfig,"Trinkets")
            CreateNewText(thisConfig,"Trinkets")

            -- Empower Rune Weapon
            if isKnown(_EmpowerRuneWeapon) then
              CreateNewCheck(thisConfig,"Empower Rune Weapon")
              CreateNewText(thisConfig,"Empower Rune Weapon")
            end

            -- Spacer
            CreateNewText(thisConfig," ");
            CreateNewWrap(thisConfig,"--- Defensive ---");

            -- Healthstone
            CreateNewCheck(thisConfig,"Healthstone");
            CreateNewBox(thisConfig,"Healthstone", 0, 100, 5, 60, "|cffFFBB00Health Percentage to use at.");
            CreateNewText(thisConfig,"Healthstone");

            -- Heirloom Neck
            CreateNewCheck(thisConfig,"Heirloom Neck");
            CreateNewBox(thisConfig,"Heirloom Neck", 0, 100, 5, 60, "|cffFFBB00Health Percentage to use at.");
            CreateNewText(thisConfig,"Heirloom Neck");

            -- Blood Presence
            CreateNewCheck(thisConfig,"Blood Presence")
            CreateNewBox(thisConfig,"Blood Presence", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
            CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_BloodPresence))))

            -- Death Strike
            CreateNewCheck(thisConfig,"Death Strike")
            CreateNewBox(thisConfig,"Death Strike", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
            CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_DeathStrike))))

            -- Icebound Fortitude
            CreateNewCheck(thisConfig,"Icebound Fortitude")
            CreateNewBox(thisConfig,"Icebound Fortitude", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
            CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_IceboundFortitude))))

            -- Lichbourne
            if getTalent(2,1) then
              CreateNewCheck(thisConfig,"Lichbourne")
              CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_Lichbourne))))
            end

            -- Anti-Magic Shell/Zone
            if getTalent(2,2) then
              CreateNewCheck(thisConfig,"Anti-Magic Zone")
              CreateNewBox(thisConfig,"Anti-Magic Zone", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
              CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_AntiMagicZone))))
            else
              CreateNewCheck(thisConfig,"Anti-Magic Shell")
              CreateNewBox(thisConfig,"Anti-Magic Shell", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
              CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_AntiMagicShell))))
            end

            -- Death Pact
            if getTalent(5,1) then
              CreateNewCheck(thisConfig,"Death Pact")
              CreateNewBox(thisConfig,"Death Pact", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
              CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_DeathPact))))
            end

            -- Death Siphon
            if getTalent(5,2) then
              CreateNewCheck(thisConfig,"Death Siphon")
              CreateNewBox(thisConfig,"Death Siphon", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
              CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_DeathSiphon))))
            end

            -- Conversion
            if getTalent(5,3) then
              CreateNewCheck(thisConfig,"Conversion")
              CreateNewBox(thisConfig,"Conversion", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
              CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_Conversion))))
            end

            -- Remorseless Winter
            if getTalent(6,2) then
              CreateNewCheck(thisConfig,"Remorseless Winter")
              CreateNewBox(thisConfig,"Remorseless Winter", 0, 100, 5, 75, "|cffFFFFFFHealth Percent to Cast At")
              CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_RemorselessWinter))))
            end

            -- Desecrated Ground
            if getTalent(6,3) then
              CreateNewCheck(thisConfig,"Desecrated Ground")
              CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_DesecratedGround))))
            end

            -- Spacer --
            CreateNewText(thisConfig," ");
            CreateNewWrap(thisConfig,"--- Interrupts ---");

            -- Mind Freeze
            CreateNewCheck(thisConfig,"Mind Freeze")
            CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_MindFreeze))))

            if isKnown(_Asphyxiate) then
              -- Asphyxiate
              CreateNewCheck(thisConfig,"Asphyxiate")
              CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_Asphyxiate))))
            else
              -- Strangulate
              CreateNewCheck(thisConfig,"Strangulate")
              CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_Strangulate))))
            end

            -- Dark Simulacrum
            CreateNewCheck(thisConfig,"Dark Simulacrum")
            CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_DarkSimulacrum))))

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


        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()


        -- Return
        return self
    end-- cFrost
end-- select Death Knight
