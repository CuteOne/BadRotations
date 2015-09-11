--- Frost Class
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
            yards30,
        }
        self.frostSpell = {
            -- Ability - Offensive
            frostStrike         = 49143,
            howlingBlast        = 49184,
            obliterate          = 49020,
            pillarOfFrost       = 51271,
            soulReaper          = 130735,
            
            -- Buff - Offensive
            killingMachineBuff  = 51124,
            freezingFogBuff     = 59052,
            pillarOfFrostBuff   = 51271, 

            -- Debuff - Offensive

            -- Glyphs

            -- Perks

            -- Items
            strengthFlaskLow    = self.flask.wod.strengthLow,
            strengthFlaskBig    = self.flask.wod.strengthBig,
            strengthFlaskLowBuff= self.flask.wod.buff.strengthLow,
            strengthFlaskBigBuff= self.flask.wod.buff.strengthBig,
            strengthPotBasic    = self.potion.wod.strengthBasic,
            strengthPotGarrison = self.potion.wod.strengthPotGarrison,
            strengthPotBuff     = self.potion.wod.buff.strength, 
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

            self.buff.killingMachine    = UnitBuffID("player",self.spell.killingMachineBuff)~=nil or false
            self.buff.rime              = UnitBuffID("player",self.spell.freezingFogBuff)~=nil or false
            self.buff.strengthFlaskLow  = UnitBuffID("player",self.spell.strengthFlaskLowBuff)~=nil or false
            self.buff.strengthFlaskBig  = UnitBuffID("player",self.spell.strengthFlaskBigBuff)~=nil or false
            self.buff.strengthPot       = UnitBuffID("player",self.spell.strengthPotBuff)~=nil or false
            self.buff.pillarOfFrost     = UnitBuffID("player",self.spell.pillarOfFrostBuff)~=nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            self.buff.duration.killingMachine       = getBuffDuration("player",self.spell.killingMachineBuff) or 0
            self.buff.duration.rime                 = getBuffDuration("player",self.spell.freezingFogBuff) or 0
            self.buff.duration.strengthFlaskLow     = getBuffDuration("player",self.spell.strengthFlaskLowBuff) or 0
            self.buff.duration.strengthFlaskBig     = getBuffDuration("player",self.spell.strengthFlaskBigBuff) or 0
            self.buff.duration.strengthPot          = getBuffDuration("player",self.spell.strengthPotBuff) or 0
            self.buff.duration.pillarOfFrost        = getBuffDuration("player",self.spell.pillarOfFrostBuff) or 0
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            self.buff.remain.killingMachine     = getBuffRemain("player",self.spell.killingMachineBuff) or 0
            self.buff.remain.rime               = getBuffRemain("player",self.spell.freezingFogBuff) or 0
            self.buff.remain.strengthFlaskLow   = getBuffRemain("player",self.spell.strengthFlaskLowBuff) or 0
            self.buff.remain.strengthFlaskBig   = getBuffRemain("player",self.spell.strengthFlaskBigBuff) or 0
            self.buff.remain.strengthPot        = getBuffRemain("player",self.spell.strengthPotBuff) or 0
            self.buff.remain.pillarOfFrost      = getBuffRemain("player",self.spell.pillarOfFrostBuff) or 0
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

            self.cd.obliterate = getSpellCD(self.spell.obliterate)
            self.cd.pillarOfFrost = getSpellCD(self.spell.pillarOfFrost)
            self.cd.soulReaper = getSpellCD(self.spell.soulReaper)
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
            self.enemies.yards30 = #getEnemies("player", 30)
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
              CreateNewCheck(thisConfig,"Lichborne")
              CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_Lichborne))))
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
            CreateNewCheck(thisConfig,"InterruptAt");
            CreateNewBox(thisConfig, "InterruptAt", 0, 95, 5, 0, "|cffFFBB00Cast Percentage to use at.");
            CreateNewText(thisConfig,"InterruptAt");

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
        -- Frost Strike
        function self.castFrostStrike()
            if self.level>=55 and self.power>40 and getDistance(self.units.dyn5)<5 then
                if castSpell(self.units.dyn5,self.spell.frostStrike,false,false,false) then return end
            end
        end
        -- Howling Blast
        function self.castHowlingBlast()
            if self.level>=55 and (self.rune.count.frost>=1 or self.rune.count.death>=1) and getDistance(self.units.dyn30)<30 then
                if castSpell(self.units.dyn30,self.spell.howlingBlast,false,false,false) then return end
            end
        end
        -- Obliterate
        function self.castObliterate()
            if self.level>=58 and ((self.rune.count.frost>=1 and self.rune.count.unholy>=1) or (self.rune.count.frost>=1 and self.rune.count.death>=1) or (self.rune.count.death>=1 and self.rune.count.unholy>=1) or self.rune.count.death>=2) and getDistance(self.units.dyn5)<5 then
                if castSpell(self.units.dyn5,self.spell.obliterate,false,false,false) then return end
            end
        end
        -- Pillar of Frost
        function self.castPillarOfFrost()
            if self.level>=68 and self.cd.pillarOfFrost==0 and (self.rune.count.frost>=1 or self.rune.count.death>=1) and getDistance(self.units.dyn5)<5 then
                if castSpell("player",self.spell.pillarOfFrost,false,false,false) then return end
            end
        end
        -- Soul Reaper
        function self.castSoulReaper()
            if self.level>=87 and self.cd.soulReaper==0 and (self.rune.count.frost>=1 or self.rune.count.death>=1) and getDistance(self.units.dyn5)<5 then
                if castSpell(self.units.dyn5,self.spell.soulReaper,false,false,false) then return end
            end
        end

        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()


        -- Return
        return self
    end-- cFrost
end-- select Death Knight
