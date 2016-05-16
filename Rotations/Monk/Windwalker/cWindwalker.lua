--- Windwalker Class
-- Inherit from: ../cCharacter.lua and ../cMonk.lua
if select(2, UnitClass("player")) == "MONK" then

    cWindwalker = {}
    cWindwalker.rotations = {}

    -- Creates Windwalker Monk
    function cWindwalker:new()
        local self = cMonk:new("Windwalker")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cWindwalker.rotations

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

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------
       function canToD()
            local thisUnit = dynamicTarget(5,true)
            if (getHP(thisUnit)<=10 or UnitHealth(thisUnit)<=UnitHealthMax("player")) and not UnitIsPlayer(thisUnit) then
                return true
            else
                return false
            end
        end

        function canEnhanceToD()
            local thisUnit = dynamicTarget(5,true)
            local boostedHP = UnitHealthMax("player")+(UnitHealthMax("player")*0.2)
            if (getHP(thisUnit)<=10 or (UnitHealth(thisUnit)<=boostedHP)) and UnitHealth(thisUnit) > UnitHealthMax("player") and not UnitIsPlayer(thisUnit) then
                return true
            else
                return false
            end
        end

        function useAoE()
            if ((BadBoy_data['Rotation'] == 1 and #getEnemies("player",8) >= 3) or BadBoy_data['Rotation'] == 2) and UnitLevel("player")>=46 then
                return true
            else
                return false
            end
        end

        function useCDs()
            if (BadBoy_data['Cooldown'] == 1 and isBoss()) or BadBoy_data['Cooldown'] == 2 then
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

        function getFacingDistance()
            if UnitIsVisible("player") and UnitIsVisible("target") then
                --local targetDistance = getRealDistance("player","target")
                local Y1,X1,Z1 = GetObjectPosition("player");
                local Y2,X2,Z2 = GetObjectPosition("target");
                local Angle1 = GetObjectFacing("player")
                local deltaY = Y2 - Y1
                local deltaX = X2 - X1
                Angle1 = math.deg(math.abs(Angle1-math.pi*2))
                if deltaX > 0 then
                    Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2)+math.pi)
                elseif deltaX <0 then
                    Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2))
                end
                local Dist = round2(math.tan(math.abs(Angle2 - Angle1)*math.pi/180)*targetDistance*10000)/10000
                if ObjectIsFacing("player","target") then
                    return Dist
                else
                    return -(math.abs(Dist))
                end
            else
                return 1000
            end
        end

        function usingFSK()
            if select(3,GetSpellInfo(101545)) == "INTERFACE\\ICONS\\priest_icon_chakra_green" then
                return true
            else
                return false
            end
        end

        function canFSK(unit)
            local targetDistance = getRealDistance("player","target")
            if ((targetDistance < 5 and isInCombat("player")) or (targetDistance < 60 and targetDistance > 5)) 
                and not hasGlyph(1017)
                and ((getSpellCD(_FlyingSerpentKick)==0 and not usingFSK()) 
                    or usingFSK())
                and (getFacingDistance() < 5 and getFacingDistance()>0)
                and not UnitIsDeadOrGhost(unit)
                and getTimeToDie(unit) > 10
                and not IsSwimming()
            then
                return true
            else
                return false
            end
        end

        function getOption(spellID)
            return tostring(select(1,GetSpellInfo(spellID)))
        end

        -- Def Windwalker Functions
        function MonkWwFunctions()
            -- we want to build core only once
            if core == nil then
              
              -- Build core
              local wwCore = {
                profile = "Windwalker",
                -- player stats
                buff = { },
                cd = { },
                charges = { },
                channel = { },
                glyph = { },
                health = 100,
                chi = 0,
                chiMax = 0,
                chiDiff = 0,
                energyTimeToMax = 0,
                inCombat = false,
                melee5Yards = 0,
                melee8Yards = 0,
                melee10Yards = 0,
                melee12Yards = 0,
                mode = { },
                recharge = { },
                stacks = { },
                talent = { },
                units = { },
                spell = {
                  blackoutKick               =   100784,  --Blackout Kick
                  chiBrew                    =   115399,  --Chi Brew
                  chiBurst          = 123986, --Chi Burst
                  chiExplosion        = 152174, --Chi Explosion
                  chiWave                    =   115098,  --Chi Wave
                  cracklingJadeLightning     =   117952,  --Crackling Jade Lightning
                  dampenHarm                 =   122278,  --Dampen Harm
                  diffuseMagic        = 122783, --Diffuse Magic
                  disable                    =   116095,  --Disable
                  detox                      =   115450,  --Detox
                  energizingBrew             =   115288,  --Energizing Brew
                  expelHarm                  =   115072,  --Expel Harm
                  fistsOfFury                =   113656,  --Fists of Fury
                  flyingSerpentKick          =   101545,  --Flying Serpent Kick
                  flyingSerpentKickEnd       =   115057,  --Flying Serpent Kick End
                  fortifyingBrew             =   115203,  --Fortifying Brew
                  hurricaneStrike     = 152175, --Hurricane Strike
                  invokeXuen                 =   123904,  --Invoke Xuen
                  jab                        =   108557,  --Jab
                  legSweep                   =   119381,  --Leg Sweep
                  legacyOfTheWhiteTiger      =   116781,  --Legacy of the White Tiger
                  nimbleBrew                 =   137562,  --Nimble Brew
                  paralysis                  =   115078,  --Paralysis
                  provoke                    =   115546,  --Provoke
                  quakingPalm                =   107079,  --Quaking Palm
                  risingSunKick             =   107428,  --Raising Sun Kick
                  resuscitate                =   115178,  --Resuscitate
                  rushingJadeWind     = 116847, --Rushing Jade Wind
                  serenity          = 152173, --Serenity
                  spinningCraneKick          =   101546,  --Spinning Crane Kick
                  stanceOfTheFierceTiger     =   103985,  --Stance of the Fierce Tiger
                  stormEarthFire        = 137639, --Storm, Earth, and Fire
                  stormEarthFireDebuff       =   138130,  --Storm, Earth, and Fire
                  spearHandStrike            =   116705,  --Spear Hand Strike
                  surgingMist       = 116694, --Surging Mist
                  tigereyeBrew        = 116740, --Tigereye Brew Damage
                  tigereyeBrewStacks          =   125195,  --Tigereye Brew Stacks
                  tigersLust          = 116841, --Tiger's Lust
                  tigerPalm                  =   100787,  --Tiger Palm
                  touchOfDeath               =   115080,  --Touch of Death
                  touchOfKarma               =   122470,  --Touch of Karma
                  zenMeditation       = 115176, --Zen Meditation
                  zenPilgramage              =   126892,  --Zen Pilgramage
                  zenSphere                  =   124081,  --Zen Sphere
                  deathNote                  =   121125, --Tracking Touch of Death Availability
                  tigerPower                 =   125359, --Tiger Power
                  comboBreakerTigerPalm      =   118864, --Combo Breaker: Tiger Palm
                  comboBreakerBlackoutKick   =   116768, --Combo Breaker: Blackout Kick
                  comboBreakerChiExplosion  = 159407, --Combo Breaker: Chi Explosion
                  zenSphereBuff              =   124081, --Zen Sphere Buff
                  disableDebuff              =   116706, --Disable (root)
                }
              }
            

              -- Global
              core = wwCore

              -- localise commonly used functions
              local getHP,getChi,getChiMax,hasGlyph,UnitPower,UnitPowerMax,getBuffRemain,getBuffStacks = getHP,getChi,getChiMax,hasGlyph,UnitPower,UnitPowerMax,getBuffRemain,getBuffStacks
              local UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies = UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies
              local player,BadBoy_data,GetShapeshiftForm,dynamicTarget = "player",BadBoy_data,GetShapeshiftForm,dynamicTarget
              local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
              local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
              local getGround,canCast,isKnown,enemiesTable,sp = getGround,canCast,isKnown,enemiesTable,core.spells
              local UnitHealth,print,UnitHealthMax,getCharges = UnitHealth,print,UnitHealthMax,getCharges
              local canTrinket,useItem,GetInventoryItemID,UnitSpellHaste = canTrinket,useItem,GetInventoryItemID,UnitSpellHaste
              local getPower,getRegen,getRecharge,GetInventorySlotInfo,GetItemInfo = getPower,getRegen,getRecharge,GetInventorySlotInfo,GetItemInfo

              -- no external access after here
              setfenv(1,wwCore)

              -- Refresh out of combat
              function wwCore:ooc()
                -- Talents (refresh ooc)
                self.talent.chiWave     = isKnown(self.spell.chiWave)
                self.talent.zenSphere     = isKnown(self.spell.zenSphere)
                self.talent.chiBurst    = isKnown(self.spell.chiBurst)
                self.talent.serenity    = isKnown(self.spell.serenity)
                self.talent.chiBrew     = isKnown(self.spell.chiBrew)
                self.talent.chiExplosion  = isKnown(self.spell.chiExplosion)
                self.talent.hurricaneStrike = isKnown(self.spell.hurricaneStrike)
                self.talent.rushingJadeWind = isKnown(self.spell.rushingJadeWind)
                self.talent.powerStrikes  = isKnown(121817)

                -- GET Jab SpellID
                local itemId = GetInventoryItemID(player,select(1,GetInventorySlotInfo("MainHandSlot")))
                local _, _, _, _, _, _, SubType, _ = GetItemInfo(itemId)

                -- Jab IDS: Staff   - 108557,
                --      Axe   - 115687,
                --      Mace  - 115693,
                --      Sword   - 115695,
                --      Polearm - 115698
                if SubType == "Staves" then
                  self.spell.jab = 108557
                elseif SubType == "One-Handed Axes" or SubType == "Two-Handed Axes" then
                  self.spell.jab = 115687
                elseif SubType == "One-Handed Maces" or SubType == "Two-Handed Maces" then
                  self.spell.jab = 115693
                elseif SubType == "One-Handed Swords" or SubType == "Two-Handed Swords" then
                  self.spell.jab = 115695
                elseif SubType == "Polearms" then
                  self.spell.jab = 115698
                end
                -- END get Jab Spellid

                -- Glyph (refresh ooc)
                self.glyph.touchOfDeath = hasGlyph(1014)

                self.inCombat = false
              end

              -- this will be used to make the core refresh itself
              function wwCore:update()
                -- player stats
                self.health   = getHP(player)
                self.chi    = getChi(player)
                self.chiMax   = getChiMax(player)
                self.chiDiff  = self.chiMax - self.chi

                -- Buffs
                self.buff.comboBreakerBlackoutKick  = getBuffRemain(player,self.spell.comboBreakerBlackoutKick)
                self.buff.comboBreakerChiExplosion  = getBuffRemain(player,self.spell.comboBreakerChiExplosion)
                self.buff.comboBreakerTigerPalm   = getBuffRemain(player,self.spell.comboBreakerTigerPalm)
                self.buff.energizingBrew      = getBuffRemain(player,self.spell.energizingBrew)
                self.buff.serenity          = getBuffRemain(player,self.spell.serenity)
                self.buff.tigereyeBrew        = getBuffRemain(player,self.spell.tigereyeBrew)
                self.buff.tigereyeBrewStacks    = getBuffRemain(player,self.spell.tigereyeBrewStacks)
                self.buff.tigerPower        = getBuffRemain(player,self.spell.tigerPower)
                self.buff.zenSphere         = getBuffRemain(player,self.spell.zenSphere)

                -- Buff Stacks
                self.stacks.tigereyeBrewStacks  = getBuffStacks(player,self.spell.tigereyeBrewStacks)
                self.stacks.stormEarthFire    = getBuffStacks(player,self.spell.stormEarthFire)

                -- Buff Charges
                self.charges.chiBrew  = getCharges(self.spell.chiBrew)

                -- Buff Recharge
                self.recharge.chiBrew   = getRecharge(self.spell.chiBrew)

                -- Cooldowns
                self.cd.fistsOfFury   = getSpellCD(self.spell.fistsOfFury)
                self.cd.hurricaneStrike = getSpellCD(self.spell.hurricaneStrike)
                self.cd.touchOfDeath  = getSpellCD(self.spell.touchOfDeath)
                self.cd.serenity    = getSpellCD(self.spell.serenity)
                self.cd.risingSunKick   = getSpellCD(self.spell.risingSunKick)
                self.cd.invokeXuen    = getSpellCD(self.spell.invokeXuen)

                -- Channel Time
                self.channel.fistsOfFury    = 4-(4*UnitSpellHaste(player)/100)
                self.channel.hurricaneStrike  = 2-(2*UnitSpellHaste(player)/100)

                self.energyTimeToMax  = (UnitPowerMax(player)-UnitPower(player)) / (10*(1+(UnitSpellHaste(player)/100)))
                

                -- Global Cooldown = 1.5 / ((Spell Haste Percentage / 100) + 1)
                --local gcd = (1.5 / ((UnitSpellHaste(player)/100)+1))
                --if gcd < 1 then
                --  self.cd.globalCooldown = 1
                --else
                --  self.cd.globalCooldown = gcd
                --end
                
                self.inCombat = true

                -- Units
                self.melee5Yards  = #getEnemies(player,5)
                self.melee8Yards  = #getEnemies(player,8)
                self.melee10Yards   = #getEnemies(player,10)
                self.melee12Yards   = #getEnemies(player,12) 

                -- Modes
                self.mode.sef     = BadBoy_data["SEF"]
                self.mode.cooldowns = BadBoy_data["Cooldowns"]
                --self.mode.defensive = BadBoy_data["Defensive"]
                --self.mode.healing = BadBoy_data["Healing"]

                -- dynamic units
                self.units.dyn5   = dynamicTarget(5,true)

                self.units.dyn8AoE  = dynamicTarget(8,false)
                self.units.dyn8   = dynamicTarget(8,true)

                self.units.dyn10  = dynamicTarget(10,true)

                self.units.dyn12  = dynamicTarget(12,true)
                self.units.dyn12AoE = dynamicTarget(12,false)

                self.units.dyn25  = dynamicTarget(25,true)
                self.units.dyn25AoE = dynamicTarget(25,false)

                self.units.dyn30  = dynamicTarget(30,true)
                self.units.dyn40  = dynamicTarget(40,true)
                self.units.dyn40AoE = dynamicTarget(40,false)
                -- 
              end

              -- Blackout Kick
              function wwCore:castBlackoutKick()
                return castSpell(self.units.dyn5,self.spell.blackoutKick,false,false) == true or false
              end

              -- Chi Brew
              function wwCore:castChiBrew()
                if isSelected("Chi Brew") then
                  return castSpell(player,self.spell.chiBrew,true,false) == true or false
                end
              end

              -- Chi Burst
              function wwCore:castChiBurst()
                if isSelected("Talent Row 2") then
                  return castSpell(self.units.dyn40,self.spell.chiBurst,false,false) == true or false
                end
              end

              -- Chi Explosion
              function wwCore:castChiExplosion()
                return castSpell(self.units.dyn30,self.spell.chiExplosion,false,false) == true or false
              end

              -- Chi Wave
              function wwCore:castChiWave()
                if isSelected("Talent Row 2") then
                  return castSpell(self.units.dyn25AoE,self.spell.chiWave,true,false) == true or false
                end
              end

              -- Crackling Jade Lightning
              -- TODO: add into rotation if not in melee range and stand still for > 1
              function wwCore:castCracklingJadeLightning()
                return castSpell(self.units.dyn40,self.spell.cracklingJadeLightning,false,false) == true or false
              end

              -- Energizing Brew
              function wwCore:castEnergizingBrew()
                if isSelected("Energizing Brew") then
                  return castSpell(player,self.spell.energizingBrew,true,false) == true or false
                end
              end

              -- Expel Harm
              function wwCore:castExpelHarm()
                return castSpell(player,self.spell.expelHarm,true,false) == true or false
              end

              -- TODO: Glyph range extend
              function wwCore:castFistsOfFury()
                return castSpell(self.units.dyn5,self.spell.fistsOfFury,false,false) == true or false
              end

              -- TODO: Flying Serpent Kick

              -- Fortifying Brew
              function wwCore:castFortifyingBrew()
                if isSelected("Fortifying Brew") and isSelected("Touch Of Death") then
                  return castSpell(player,self.spell.fortifyingBrew,true,false) == true or false
                end
              end

              -- Hurricane Strike
              function wwCore:castHurricaneStrike()
                return castSpell(self.units.dyn12AoE,self.spell.hurricaneStrike,true,false) == true or false
              end

              -- Invoke Xuen
              function wwCore:castInvokeXuen()
                if isSelected("Invoke Xuen") then
                  return castSpell(self.units.dyn40,self.spell.invokeXuen,true,false) == true or false
                end
              end

              -- Jab
              -- TODO: different spellids needed?
              function wwCore:castJab()
                return castSpell(self.units.dyn5,self.spell.jab,false,false) == true or false
              end

              -- TODO: Nimble Brew

              -- TODO: Paralysis

              -- TODO: Resuscitate

              -- Rising Sun Kick
              function wwCore:castRisingSunKick()
                return castSpell(self.units.dyn5,self.spell.risingSunKick,false,false) == true or false
              end

              -- TODO: Roll

              -- Rushing Jade Wind
              function wwCore:castRushingJadeWind() -- 8y
                return castSpell(player,self.spell.rushingJadeWind,true,false) == true or false
              end

              -- Serenity
              function wwCore:castSerenity()
                if isSelected("Serenity") then
                  return castSpell(player,self.spell.serenity,true,false) == true or false
                end
              end

              -- TODO: Spear Hand Strike

              -- Spinning Crane Kick
              function wwCore:castSpinningCraneKick() -- 8y
                return castSpell(player,self.spell.spinningCraneKick,true,false) == true or false
              end

              -- Storm Earth Fire
              function wwCore:castStormEarthFire()
                return castSpell(self.units.dyn40AoE,self.spell.stormEarthFire,true,false) == true or false
              end

              -- Surging Mist
              function wwCore:castSurgingMist()
                return castSpell(player,self.spell.surgingMist,true,false) == true or false
              end

              -- Tigerpalm
              function wwCore:castTigerPalm()
                return castSpell(self.units.dyn5,self.spell.tigerPalm,false,false) == true or false
              end

              -- Tigereye Brew
              function wwCore:castTigereyeBrew()
                return castSpell(player,self.spell.tigereyeBrew,true,false) == true or false
              end

              -- Touch of Death
              function wwCore:castTouchOfDeath()
                if isSelected("Touch Of Death") then
                  return castSpell(self.units.dyn5,self.spell.touchOfDeath,true,false) == true or false
                end
              end

              -- Touch of Karma
              function wwCore:castTouchOfKarma() -- TODO: range glyph, 25y
                return castSpell(self.units.dyn5,self.spell.touchOfKarma,true,false) == true or false
              end

              -- Zen Sphere
              -- Used on self or if already on player cast on focus
              function wwCore:castZenSphere()
                if isSelected("Talent Row 2") then
                  if not UnitBuffID(player,self.buff.zenSphere) then
                    return castSpell(player,self.spell.zenSphere,true,false) == true or false
                  end
                  if not UnitBuffID("focus",self.buff.zenSphere) then
                    return castSpell("focus",self.spell.zenSphere,true,false) == true or false
                  end
                  return false
                end
              end

            end -- function wwCore:update()
        end -- function MonkWwFunctions()

        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()


        -- Return
        return self
    end-- cWindwalker
end-- select Monk