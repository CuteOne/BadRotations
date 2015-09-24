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
            yards40,
        }
        self.windwalkerSpell = {
            -- Ability - Defensive
            touchOfKarma                    = 122470,

            -- Ability - Offensive
            chiExplosion                    = 152174,
            energizingBrew                  = 115288,
            fistsOfFury                     = 113656,
            flyingSerpentKick               = 101545,
            flyingSerpentKickEnd            = 115057,
            stormEarthAndFire               = 137639,
            tigereyeBrew                    = 116740,

            -- Buff - Defensive
            touchOfKarmaBuff                = 122470,
            
            -- Buff - Offensive
            comboBreakerBlackoutKickBuff    = 116768,
            comboBreakerChiExplosionBuff    = 159407,
            comboBreakerTigerPalmBuff       = 118864,
            energizingBrewBuff              = 115288,
            stormEarthAndFireBuff           = 137639,
            tigereyeBrewBuff                = 116740,

            -- Buff - Stacks
            stormEarthAndFireStacks         = 137639,
            tigereyeBrewStacks              = 125195,

            -- Debuff - Offensive
            stormEarthAndFireDebuff         = 138130,

            -- Glyphs
            touchOfKarmaGlyph               = 125678,

            -- Perks

            -- Talent
            chiExplosionTalent              = 152174,
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
            self.getCharges()
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

            self.buff.comboBreakerBlackoutKick  = UnitBuffID("player",self.spell.comboBreakerBlackoutKickBuff)~=nil or false
            self.buff.comboBreakerChiExplosion  = UnitBuffID("player",self.spell.comboBreakerChiExplosionBuff)~=nil or false
            self.buff.comboBreakerTigerPalm     = UnitBuffID("player",self.spell.comboBreakerTigerPalmBuff)~=nil or false
            self.buff.energizingBrew            = UnitBuffID("player",self.spell.energizingBrewBuff)~=nil or false
            if getBuffRemain("player",self.spell.tigereyeBrewBuff)>15 then
                self.buff.tigereyeBrew          = false
            else
                self.buff.tigereyeBrew          = true
            end
            self.buff.touchOfKarma              = UnitBuffID("player",self.spell.touchOfKarmaBuff)~=nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            self.buff.duration.comboBreakerBlackoutKick = getBuffDuration("player",self.spell.comboBreakerBlackoutKickBuff) or 0
            self.buff.duration.comboBreakerChiExplosion = getBuffDuration("player",self.spell.comboBreakerChiExplosionBuff) or 0
            self.buff.duration.comboBreakerTigerPalm    = getBuffDuration("player",self.spell.comboBreakerTigerPalmBuff) or 0
            self.buff.duration.energizingBrew           = getBuffDuration("player",self.spell.energizingBrewBuff) or 0
            if getBuffRemain("player",self.spell.tigereyeBrewBuff)>15 then
                self.buff.duration.tigereyeBrew         = 15
            else
                self.buff.duration.tigereyeBrew         = 0
            end
            self.buff.duration.touchOfKarma             = getBuffDuration("player",self.spell.touchOfKarmaBuff) or 0
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            self.buff.remain.comboBreakerBlackoutKick   = getBuffRemain("player",self.spell.comboBreakerBlackoutKickBuff) or 0
            self.buff.remain.comboBreakerChiExplosion   = getBuffRemain("player",self.spell.comboBreakerChiExplosionBuff) or 0
            self.buff.remain.comboBreakerTigerPalm      = getBuffRemain("player",self.spell.comboBreakerTigerPalmBuff) or 0
            self.buff.remain.energizingBrew             = getBuffRemain("player",self.spell.energizingBrewBuff) or 0
            if getBuffRemain("player",self.spell.tigereyeBrewBuff)>15 then
                self.buff.remain.tigereyeBrew           = 0
            else
                self.buff.remain.tigereyeBrew           = getBuffRemain("player",self.spell.tigereyeBrewBuff)
            end
            self.buff.remain.touchOfKarma               = getBuffRemain("player", self.spell.touchOfKarmaBuff) or 0
        end

        function self.getCharges()
        local getBuffStacks = getBuffStacks

            self.charges.stormEarthAndFire  = getBuffStacks("player",self.spell.stormEarthAndFireStacks,"player") or 0
            self.charges.tigereyeBrew       = getBuffStacks("player",self.spell.tigereyeBrewStacks,"player") or 0
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

            self.cd.energizingBrew      = getSpellCD(self.spell.energizingBrew)
            self.cd.fistsOfFury         = getSpellCD(self.spell.fistsOfFury)
            self.cd.flyingSerpentKick   = getSpellCD(self.spell.flyingSerpentKick)
            self.cd.tigereyeBrew        = getSpellCD(self.spell.tigereyeBrew)
            self.cd.touchOfKarma        = getSpellCD(self.spell.touchOfKarma)
        end

        --------------
        --- GLYPHS ---
        --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            self.glyph.touchOfKarma = hasGlyph(self.spell.touchOfKarmaGlyph)
        end

        ---------------
        --- TALENTS ---
        ---------------

        function self.getTalents()
            local getTalent = getTalent

            self.talent.chiExplosion = getTalent(7,2)
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
            self.units.dyn8     = dynamicTarget(8, true)
            self.units.dyn15    = dynamicTarget(15, true)
            self.units.dyn20    = dynamicTarget(20, true)

            -- AoE
            self.units.dyn8AoE  = dynamicTarget(8,false)
            self.units.dyn20AoE = dynamicTarget(20,false)
        end

        ---------------
        --- ENEMIES ---
        ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = #getEnemies("player", 5)
            self.enemies.yards8     = #getEnemies("player", 8)
            self.enemies.yards12    = #getEnemies("player", 12)
            self.enemies.yards40    = #getEnemies("player", 40)
        end

        ----------------------
        --- START ROTATION ---
        ----------------------

        function self.startRotation()
            if self.rotation == 1 then
                self:WindwalkerCuteOne()
            elseif self.rotation == 2 then
                self:WindwalkerDef()
            elseif self.rotation == 3 then
                self:WindwalkerOld()
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
            CreateNewDrop(thisConfig, "Rotation", 1, "Select Rotation.", "|cff00FF00CuteOne", "|cff00FF00Def", "|cff00FF00Old");
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

            -- Touch of the Void
            CreateNewCheck(thisConfig,"Touch of the Void");
            CreateNewText(thisConfig,"Touch of the Void");

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
            CreateNewCheck(thisConfig,"InterruptAt");
            CreateNewBox(thisConfig, "InterruptAt", 0, 95, 5, 0, "|cffFFBB00Cast Percentage to use at.");
            CreateNewText(thisConfig,"InterruptAt");

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
        -- Chi Explosion
        function self.castChiExplosion()
            if getTalent(7,2) and self.chi.count>=1 and getDistance(self.units.dyn30)<30 then
                if castSpell(self.units.dyn30,self.spell.chiExplosion,false,false,false) then return end
            end
        end
        -- Energizing Brew
        function self.castEnergizingBrew()
            if self.level>=36 and self.cd.energizingBrew==0 and self.timeToMax>6 then
                if castSpell("player",self.spell.energizingBrew,false,false,false) then return end
            end
        end
        -- Fists of Fury
        function self.castFistsOfFury()
            if self.level>=10 and self.cd.fistsOfFury==0 and self.chi.count>=3 and getDistance(self.units.dyn5)<5 then
                if castSpell(self.units.dyn5,self.spell.fistsOfFury,false,false,false) then return end
            end
        end
        -- Flying Serpent Kick
        function self.castFlyingSerpentKick()
            if self.level>=18 and self.cd.flyingSerpentKick==0 then
                if castSpell("player",self.spell.flyingSerpentKick,false,false,false) then return end
            end
        end
        function self.castFlyingSerpentKickEnd()
            if self.level>=18 then
                if castSpell("player",self.spell.flyingSerpentKickEnd,false,false,false) then return end
            end
        end
        -- Storm Earth and Fire
        function self.castStormEarthAndFire()
            if self.enemies.yards40>1 then
                local myTarget   = 0
                local sefEnemies = getEnemies("player",40)
                if ObjectExists("target") then
                    myTarget = ObjectPointer("target")
                else
                    myTarget = 0
                end
                for i=1, #sefEnemies do
                    local thisUnit                  = sefEnemies[i]
                    local hasThreat                 = UnitThreatSituation("player",thisUnit)~=nil or false
                    local debuffStormEarthAndFire   = UnitDebuffID(thisUnit,self.spell.stormEarthAndFireDebuff,"player")~=nil or false

                    if not debuffStormEarthAndFire and thisUnit~=myTarget and self.charges.stormEarthAndFire<2 and hasThreat then
                        if castSpell(thisUnit,self.spell.stormEarthAndFire,false,false,false) then return end
                    end
                    if debuffStormEarthAndFire and thisUnit==myTarget then
                        if CancelUnitBuff("player", GetSpellInfo(self.spell.stormEarthAndFire)) then return end
                    end
                end
            end
        end
        -- Tiger's Eye Brew
        function self.castTigereyeBrew()
            if self.level>=56 and self.cd.tigereyeBrew==0 and self.charges.tigereyeBrew>0 and getDistance(self.units.dyn5)<5 then
                if castSpell("player",self.spell.tigereyeBrew,false,false,false) then return end
            end
        end
        -- Touch of Karma
        function self.castTouchOfKarma()
            if self.level>=22 and self.cd.touchOfKarma==0 then
                if self.glyph.touchOfKarma and getDistance(self.units.dyn20AoE)<20 then
                    if castSpell(self.units.dyn20AoE,self.spell.touchOfKarma,false,false,false) then return end
                elseif getDistance(self.units.dyn5)<5 then
                    if castSpell(self.units.dyn5,self.spell.touchOfKarma,false,false,false) then return end
                end
            end
        end
        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()


        -- Return
        return self
    end-- cWindwalker
end-- select Monk