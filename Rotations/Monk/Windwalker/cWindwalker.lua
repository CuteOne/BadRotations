--- Windwalker Class
-- Inherit from: ../cCharacter.lua and ../cMonk.lua
if select(2, UnitClass("player")) == "MONK" then

    cWindwalker = {}

    -- Creates Windwalker Monk
    function cWindwalker:new()
        local self = cMonk:new("Windwalker")

        local player = "player" -- if someone forgets ""

        -----------------
        --- VARIABLES ---
        -----------------

        self.enemies = {
            yards5,
            yards8,
            yards12,
        }
        self.windwalkerSpell = {
            -- Ability - Offensive
            
            -- Buff - Offensive

            -- Debuff - Offensive

            -- Glyphs

            -- Perks
        }
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.monkSpell, self.windwalkerSpell)

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
                self:WindwalkerCuteOne()
            elseif self.rotation == 2 then
                self:WindwalkerDef()
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
            CreateNewTitle(thisConfig, "Windwalker")

            -- Create Base and Class options
            self.createClassOptions()

            -- Combat options
            CreateNewWrap(thisConfig, "--- General ---");

            -- Rotation
            CreateNewDrop(thisConfig, "Rotation", 1, "Select Rotation.", "|cff00FF00CuteOne", "|cff00FF00Def");
            CreateNewText(thisConfig, "Rotation");

            -- Dummy DPS Test
            CreateNewCheck(thisConfig,"DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.");
            CreateNewBox(thisConfig,"DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            CreateNewText(thisConfig,"DPS Testing");

            if self.rotation == 1 then -- CuteOne Rotation
                -- Death Monk
                CreateNewCheck(thisConfig,"Death Monk Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.");
                CreateNewText(thisConfig,"Death Monk Mode");

                -- Legacy of the White Tiger
                CreateNewCheck(thisConfig,"Legacy of the White Tiger","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Legacy of the White Tiger usage. When enabled rotation will scan party/raid groups and cast if anyone in range in missing a similar buff.");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_LegacyOfTheWhiteTiger))));
            end

            if self.rotation == 2 then -- Def Rotation
                -- -- Legacy of the White Tiger
                CreateNewCheck(thisConfig,"Legacy of the White Tiger","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Not yet implemented");
                CreateNewText(thisConfig,"Legacy of the White Tiger");
            end

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

            if self.rotation == 1 then
                -- Xuen
                CreateNewCheck(thisConfig,"Xuen");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_InvokeXuen))));
            end

            if self.rotaion == 2 then
                -- Xuen
                CreateNewCheck(thisConfig,"Invoke Xuen");
                CreateNewDrop(thisConfig,"Invoke Xuen",1,"CD");
                CreateNewText(thisConfig,"Invoke Xuen");

                -- Chi Brew
                CreateNewCheck(thisConfig,"Chi Brew");
                CreateNewDrop(thisConfig,"Chi Brew",1,"CD");
                CreateNewText(thisConfig,"Chi Brew");

                -- Zen Sphere / Chi Wave / Chi Burst
                CreateNewCheck(thisConfig,"Talent Row 2","|cffFFFFFFUses your 2. Talentrow spell. Sphere/Wave/Burst");
                CreateNewDrop(thisConfig,"Talent Row 2",1,"CD");
                CreateNewText(thisConfig,"Talent Row 2");

                -- Energizing Brew
                CreateNewCheck(thisConfig,"Energizing Brew");
                CreateNewDrop(thisConfig,"Energizing Brew",1,"CD");
                CreateNewText(thisConfig,"Energizing Brew");

                -- Fortifying Brew
                CreateNewCheck(thisConfig,"Fortifying Brew","|cffFFFFFFUsed offensivly with Touch of Death.");
                CreateNewDrop(thisConfig,"Fortifying Brew",1,"CD");
                CreateNewText(thisConfig,"Fortifying Brew");

                -- Serenity
                CreateNewCheck(thisConfig,"Serenity");
                CreateNewDrop(thisConfig,"Serenity",1,"CD");
                CreateNewText(thisConfig,"Serenity");

                -- Touch Of Death
                CreateNewCheck(thisConfig,"Touch Of Death");
                CreateNewDrop(thisConfig,"Touch Of Death",1,"CD");
                CreateNewText(thisConfig,"Touch Of Death");
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

            if self.rotation == 1 then
                --  Expel Harm
                CreateNewCheck(thisConfig,"Expel Harm");
                CreateNewBox(thisConfig,"Expel Harm", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_ExpelHarm))));

                -- Surging Mist
                CreateNewCheck(thisConfig,"Surging Mist");
                CreateNewBox(thisConfig,"Surging Mist", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_SurgingMist))));

                -- Touch of Karma
                CreateNewCheck(thisConfig,"Touch of Karma");
                CreateNewBox(thisConfig,"Touch of Karma", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_TouchOfKarma))));

                -- Fortifying Brew
                CreateNewCheck(thisConfig,"Fortifying Brew");
                CreateNewBox(thisConfig,"Fortifying Brew", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_FortifyingBrew))));

                -- Diffuse Magic/Dampen Harm
                CreateNewCheck(thisConfig,"Diffuse/Dampen");
                CreateNewBox(thisConfig,"Diffuse/Dampen", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                if getTalent(5,2) then
                  CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_DampenHarm))));
                else
                  CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_DiffuseMagic))));
                end

                -- Zen Meditation
                CreateNewCheck(thisConfig,"Zen Meditation");
                CreateNewBox(thisConfig,"Zen Meditation", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_ZenMeditation))));

                -- Nimble Brew
                CreateNewCheck(thisConfig,"Nimble Brew");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_NimbleBrew))));
            end

            -- Spacer --
            CreateNewText(thisConfig," ");
            wrapOp("--- Interrupts ---");

            if self.rotation == 1 then
                --Quaking Palm
                CreateNewCheck(thisConfig,"Quaking Palm")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_QuakingPalm))))

                -- Spear Hand Strike
                CreateNewCheck(thisConfig,"Spear Hand Strike")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_SpearHandStrike))))

                -- Paralysis
                CreateNewCheck(thisConfig,"Paralysis")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_Paralysis))))

                -- Leg Sweep
                CreateNewCheck(thisConfig,"Leg Sweep")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(_LegSweep))))
            end

            -- Interrupt Percentage
            CreateNewCheck(thisConfig,"Interrupt At");
            CreateNewBox(thisConfig, "Interrupt At", 0, 95, 5, 0, "|cffFFBB00Cast Percentage to use at.");
            CreateNewText(thisConfig,"Interrupt At");

            -- Spacer
            CreateNewText(thisConfig, " ");
            CreateNewWrap(thisConfig, "--- Toggle Keys ---");

            if self.rotation == 1 then
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

                -- SEF Toggle
                CreateNewCheck(thisConfig,"SEF Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFSEF Toggle Key|cffFFBB00.");
                CreateNewBox(thisConfig,"SEF Mode", 5, "Toggle")
                CreateNewText(thisConfig,"SEF Mode");

                -- FSK Toggle
                CreateNewCheck(thisConfig,"FSK Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFFSK Toggle Key|cffFFBB00.");
                CreateNewBox(thisConfig,"FSK Mode", 5, "Toggle")
                CreateNewText(thisConfig,"FSK Mode");

                -- Chi Builder Toggle
                CreateNewCheck(thisConfig,"Builder Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFChi Builder Toggle Key|cffFFBB00.");
                CreateNewBox(thisConfig,"Builder Mode", 5, "Toggle")
                CreateNewText(thisConfig,"Builder Mode");
            end

            if self.rotation == 2 then
                -- SEF Toggle
                CreateNewCheck(thisConfig,"SEF Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFSEF Toggle Key|cffFFBB00.");
                CreateNewDrop(thisConfig,"SEF Mode", 5, "Toggle")
                CreateNewText(thisConfig,"SEF Mode");
            end

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
    end-- cWindwalker
end-- select Monk