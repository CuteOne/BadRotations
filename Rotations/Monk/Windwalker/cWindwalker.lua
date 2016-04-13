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

        self.trinket = {} -- Trinket Procs
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
            self.getTrinketProc()
            self.hasTrinketProc()


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

        --------------------
        --- TRINKET PROC ---
        --------------------

        function self.getTrinketProc()
            local UnitBuffID = UnitBuffID

            -- self.trinket.WitherbarksBranch              = UnitBuffID("player",165822)~=nil or false --Haste Proc
            -- self.trinket.TurbulentVialOfToxin           = UnitBuffID("player",176883)~=nil or false --Mastery Proc
            -- self.trinket.KihrasAdrenalineInjector       = UnitBuffID("player",165485)~=nil or false --Mastery Proc
            self.trinket.GorashansLodestoneSpike        = UnitBuffID("player",165542)~=nil or false --Multi-Strike Proc
            self.trinket.DraenicPhilosophersStone       = UnitBuffID("player",157136)~=nil or false --Agility Proc
            self.trinket.BlackheartEnforcersMedallion   = UnitBuffID("player",176984)~=nil or false --Multi-Strike Proc
            -- self.trinket.MunificentEmblemOfTerror       = UnitBuffID("player",165830)~=nil or false --Critical Strike Proc
            self.trinket.PrimalCombatantsInsignia       = UnitBuffID("player",182059)~=nil or false --Agility Proc
            -- self.trinket.SkullOfWar                     = UnitBuffID("player",162915)~=nil or false --Critical Strike Proc
            self.trinket.ScalesOfDoom                   = UnitBuffID("player",177038)~=nil or false --Multi-Strike Proc
            self.trinket.LuckyDoubleSidedCoin           = UnitBuffID("player",177597)~=nil or false --Agility Proc
            -- self.trinket.MeatyDragonspineTrophy         = UnitBuffID("player",177035)~=nil or false --Haste Proc
            self.trinket.PrimalGladiatorsInsignia       = UnitBuffID("player",182068)~=nil or false --Agility Proc
            self.trinket.BeatingHeartOfTheMountain      = UnitBuffID("player",176878)~=nil or false --Multi-Strike Proc
            -- self.trinket.HummingBlackironTrigger        = UnitBuffID("player",177067)~=nil or false --Critical Stike Proc
            self.trinket.MaliciousCenser                = UnitBuffID("player",183926)~=nil or false --Agility Proc
        end

        function self.hasTrinketProc()
            for i = 1, #self.trinket do
                if self.trinket[i]==true then return true else return false end
            end
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
                --elseif self.rotation == 2 then
                --    self:WindwalkerDef()
                --elseif self.rotation == 3 then
                --    self:WindwalkerOld()
            else
                ChatOverlay("No ROTATION ?!", 2000)
            end
        end

        ---------------
        --- OPTIONS ---
        ---------------

        function self.createOptions()
            bb.ui.window.profile = bb.ui:createProfileWindow("Windwalker")
            local section

            -- Create Base and Class options
            self.createClassOptions()

            -- Combat options
            section = bb.ui:createSection(bb.ui.window.profile,  "General")
            -- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")

            -- Death Monk
                bb.ui:createCheckbox(section,"Death Monk Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.")

            -- Legacy of the White Tiger
                bb.ui:createCheckbox(section,"Legacy of the White Tiger","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Legacy of the White Tiger usage. When enabled rotation will scan party/raid groups and cast if anyone in range in missing a similar buff.")

            -- Fortifying Brew w/ Touch of Death
                bb.ui:createCheckbox(section,"Fort Brew w/ ToD","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFuse of Fortifying to empower Touch of Death.")

            -- Pre-Pull Timer
                bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
                
            bb.ui:checkSectionState(section)
         

            section = bb.ui:createSection(bb.ui.window.profile,  "Cooldowns")
            -- Agi Pot
                bb.ui:createCheckbox(section,"Agi-Pot")

            -- Legendary Ring
                bb.ui:createCheckbox(section,"Legendary Ring")

            -- Flask / Crystal
                bb.ui:createCheckbox(section,"Flask / Crystal")

            -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")

            -- Touch of the Void
                bb.ui:createCheckbox(section,"Touch of the Void")

            -- Serenity
                bb.ui:createCheckbox(section,"Serenity")

            -- Xuen
                bb.ui:createCheckbox(section,"Xuen")
            bb.ui:checkSectionState(section)


            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
            -- Healthstone
                bb.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Heirloom Neck
                bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            --  Expel Harm
                bb.ui:createSpinner(section, "Expel Harm",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Surging Mist
                bb.ui:createSpinner(section, "Surging Mist",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Touch of Karma
                bb.ui:createSpinner(section, "Touch of Karma",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Fortifying Brew
                bb.ui:createSpinner(section, "Fortifying Brew",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Diffuse Magic/Dampen Harm
                bb.ui:createSpinner(section, "Diffuse/Dampen",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Zen Meditation
                bb.ui:createSpinner(section, "Zen Meditation",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Nimble Brew
                bb.ui:createCheckbox(section,"Nimble Brew")
            bb.ui:checkSectionState(section)


            section = bb.ui:createSection(bb.ui.window.profile,  "Interrupts")
            --Quaking Palm
                bb.ui:createCheckbox(section,"Quaking Palm")

            -- Spear Hand Strike
                bb.ui:createCheckbox(section,"Spear Hand Strike")

            -- Paralysis
                bb.ui:createCheckbox(section,"Paralysis")

            -- Leg Sweep
                bb.ui:createCheckbox(section,"Leg Sweep")

            -- Interrupt Percentage
                bb.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
            bb.ui:checkSectionState(section)


            section = bb.ui:createSection(bb.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
                bb.ui:createDropdown(section,  "Rotation Mode", bb.dropOptions.Toggle,  4)

            --Cooldown Key Toggle
                bb.ui:createDropdown(section,  "Cooldown Mode", bb.dropOptions.Toggle,  3)

            --Defensive Key Toggle
                bb.ui:createDropdown(section,  "Defensive Mode", bb.dropOptions.Toggle,  6)

            -- Interrupts Key Toggle
                bb.ui:createDropdown(section,  "Interrupt Mode", bb.dropOptions.Toggle,  6)

            -- SEF Toggle
                bb.ui:createDropdown(section,  "SEF Mode", bb.dropOptions.Toggle,  5)

            -- FSK Toggle
                bb.ui:createDropdown(section,  "FSK Mode", bb.dropOptions.Toggle,  5)

            -- Chi Builder Toggle
                bb.ui:createDropdown(section,  "Builder Mode", bb.dropOptions.Toggle,  5)

            -- Pause Toggle
                bb.ui:createDropdown(section,  "Pause Mode", bb.dropOptions.Toggle,  6)
            bb.ui:checkSectionState(section)



            --[[ Rotation Dropdown ]]--
            bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"CuteOne"})
            bb:checkProfileWindowStatus()
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
                    local hasThreat                 = hasThreat(thisUnit) -- UnitThreatSituation("player",thisUnit)~=nil or false
                    local debuffStormEarthAndFire   = UnitDebuffID(thisUnit,self.spell.stormEarthAndFireDebuff,"player")~=nil or false

                    if not debuffStormEarthAndFire and thisUnit~=myTarget and self.charges.stormEarthAndFire<2 and hasThreat and UnitName(thisUnit)~="Dungeoneer's Training Dummy" then
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