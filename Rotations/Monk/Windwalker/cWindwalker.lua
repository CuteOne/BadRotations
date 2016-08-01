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
        self.windwalkerArtifacts = {
            crosswinds                      = 195650,
            darkSkies                       = 195265,
            deathArt                        = 195266,
            fistsOfTheWind                  = 195291,
            galeBurst                       = 195399,
            goodKarma                       = 195295,
            healingWinds                    = 195380,
            innerPeace                      = 195243,
            lightOnYourFeet                 = 195244,
            powerOfAThousandCranes          = 195269,
            risingWinds                     = 195263,
            spiritualFocus                  = 195298,
            strengthOfXuen                  = 195267,
            strikeOfTheWindlordArtifact     = 205320,
            strikeOfTheWindlord             = 222029,
            tigerClaws                      = 218607,
            tornadoKicks                    = 196082,
            transferOfPower                 = 195300,
            windborneBlows                  = 214922,
        }
        self.windwalkerBuffs = {
            serenityBuff                    = 152173,
            -- stormEarthAndFireBuff           = 137639,
            touchOfKarmaBuff                = 122470,
        }
        self.windwalkerDebuffs = {
            markOfTheCrane                  = 228287,
            -- stormEarthAndFireDebuff         = 138130,
        }
        self.windwalkerGlyphs = {
            glyphOfRisingTigerKick          = 125151,
        }
        self.windwalkerSpecials = {
            detox                           = 218164,
            disable                         = 116095,
            fistsOfFury                     = 113656,
            flyingSerpentKick               = 101545,
            flyingSerpentKickEnd            = 115057,
            risingSunKick                   = 107428,
            spearHandStrike                 = 116705,
            spinningCraneKick               = 101546,
            stormEarthAndFire               = 137639,
            touchOfDeath                    = 115080,
            touchOfKarma                    = 122470,
        }
        self.windwalkerTalents = {
            ascension                       = 115396,
            chiOrbit                        = 196743,
            chiWave                         = 115098,
            dizzyingKicks                   = 196722,
            energizingElixer                = 115288,
            eyeOfTheTiger                   = 196607,
            healingElixer                   = 122281,
            hitCombo                        = 196740,
            invokeXuen                      = 123904,
            powerStrikes                    = 121817,
            rushingJadeWind                 = 116847,
            serenity                        = 152173,
            whirlingDragonPunch             = 152175,
        }

        -- Merge all spell tables into self.spell
        self.windwalkerSpells = {}
        self.windwalkerSpells = mergeTables(self.windwalkerSpells,self.windwalkerArtifacts)
        self.windwalkerSpells = mergeTables(self.windwalkerSpells,self.windwalkerBuffs)
        self.windwalkerSpells = mergeTables(self.windwalkerSpells,self.windwalkerDebuffs)
        self.windwalkerSpells = mergeTables(self.windwalkerSpells,self.windwalkerGlyphs)
        self.windwalkerSpells = mergeTables(self.windwalkerSpells,self.windwalkerSpecials)
        self.windwalkerSpells = mergeTables(self.windwalkerSpells,self.windwalkerTalents)
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.monkSpells, self.windwalkerSpells)

        ------------------
        --- OOC UPDATE ---
        ------------------

        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()
            self.getArtifacts()
            self.getArtifactRanks()
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

        -----------------
        --- ARTIFACTS ---
        -----------------

            function self.getArtifacts()
                local isKnown = isKnown

                self.artifact.galeBurst             = isKnown(self.spell.galeBurst)
                self.artifact.strikeOfTheWindlord   = isKnown(self.spell.strikeOfTheWindlordArtifact)
            end

            function self.getArtifactRanks()

            end

        -------------
        --- BUFFS ---
        -------------

        function self.getBuffs()
            local UnitBuffID = UnitBuffID

            self.buff.serenity      = UnitBuffID("player",self.spell.serenityBuff)~=nil or false
            self.buff.touchOfKarma  = UnitBuffID("player",self.spell.touchOfKarmaBuff)~=nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            self.buff.duration.serenity         = getBuffDuration("player",self.spell.serenityBuff) or 0
            self.buff.duration.touchOfKarma     = getBuffDuration("player",self.spell.touchOfKarmaBuff) or 0
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            -- self.buff.remain.serenity       = getBuffRemain("player",self.spell.serenityBuff) or 0
            -- self.buff.remain.touchOfKarma   = getBuffRemain("player", self.spell.touchOfKarmaBuff) or 0
        end

        function self.getCharges()
            local getBuffStacks = getBuffStacks

            -- self.charges.stormEarthAndFire  = getBuffStacks("player",self.spell.stormEarthAndFireStacks,"player") or 0
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

            self.cd.chiWave             = getSpellCD(self.spell.chiWave)
            self.cd.detox               = getSpellCD(self.spell.detox)
            self.cd.energizingElixer    = getSpellCD(self.spell.energizingElixer)
            self.cd.fistsOfFury         = getSpellCD(self.spell.fistsOfFury)
            self.cd.flyingSerpentKick   = getSpellCD(self.spell.flyingSerpentKick)
            self.cd.invokeXuen          = getSpellCD(self.spell.invokeXuen)
            self.cd.risingSunKick       = getSpellCD(self.spell.risingSunKick)
            self.cd.spearHandStrike     = getSpellCD(self.spell.spearHandStrike)
            self.cd.strikeOfTheWindlord = getSpellCD(self.spell.strikeOfTheWindlord)
            self.cd.touchOfDeath        = getSpellCD(self.spell.touchOfDeath)
            self.cd.touchOfKarma        = getSpellCD(self.spell.touchOfKarma)
        end

        --------------
        --- GLYPHS ---
        --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            -- self.glyph.touchOfKarma = hasGlyph(self.spell.touchOfKarmaGlyph)
        end

        ---------------
        --- TALENTS ---
        ---------------

        function self.getTalents()
            local getTalent = getTalent

            self.talent.eyeOfTheTiger       = getTalent(1,2)
            self.talent.chiWave             = getTalent(1,3)
            self.talent.energizingElixer    = getTalent(3,1)
            self.talent.ascension           = getTalent(3,2)
            self.talent.powerStrikes        = getTalent(3,3)
            self.talent.dizzyingKicks       = getTalent(4,2)
            self.talent.healingElixer       = getTalent(5,1)
            self.talent.rushingJadeWind     = getTalent(6,1)
            self.talent.invokeXuen          = getTalent(6,2)
            self.talent.hitCombo            = getTalent(6,3)
            self.talent.chiOrbit            = getTalent(7,1)
            self.talent.whirlingDragonPunch = getTalent(7,2)
            self.talent.serenity            = getTalent(7,3)
        end

        --------------------
        --- TRINKET PROC ---
        --------------------

        function self.getTrinketProc()
            local UnitBuffID = UnitBuffID

            -- -- self.trinket.WitherbarksBranch              = UnitBuffID("player",165822)~=nil or false --Haste Proc
            -- -- self.trinket.TurbulentVialOfToxin           = UnitBuffID("player",176883)~=nil or false --Mastery Proc
            -- -- self.trinket.KihrasAdrenalineInjector       = UnitBuffID("player",165485)~=nil or false --Mastery Proc
            -- self.trinket.GorashansLodestoneSpike        = UnitBuffID("player",165542)~=nil or false --Multi-Strike Proc
            -- self.trinket.DraenicPhilosophersStone       = UnitBuffID("player",157136)~=nil or false --Agility Proc
            -- self.trinket.BlackheartEnforcersMedallion   = UnitBuffID("player",176984)~=nil or false --Multi-Strike Proc
            -- -- self.trinket.MunificentEmblemOfTerror       = UnitBuffID("player",165830)~=nil or false --Critical Strike Proc
            -- self.trinket.PrimalCombatantsInsignia       = UnitBuffID("player",182059)~=nil or false --Agility Proc
            -- -- self.trinket.SkullOfWar                     = UnitBuffID("player",162915)~=nil or false --Critical Strike Proc
            -- self.trinket.ScalesOfDoom                   = UnitBuffID("player",177038)~=nil or false --Multi-Strike Proc
            -- self.trinket.LuckyDoubleSidedCoin           = UnitBuffID("player",177597)~=nil or false --Agility Proc
            -- -- self.trinket.MeatyDragonspineTrophy         = UnitBuffID("player",177035)~=nil or false --Haste Proc
            -- self.trinket.PrimalGladiatorsInsignia       = UnitBuffID("player",182068)~=nil or false --Agility Proc
            -- self.trinket.BeatingHeartOfTheMountain      = UnitBuffID("player",176878)~=nil or false --Multi-Strike Proc
            -- -- self.trinket.HummingBlackironTrigger        = UnitBuffID("player",177067)~=nil or false --Critical Stike Proc
            -- self.trinket.MaliciousCenser                = UnitBuffID("player",183926)~=nil or false --Agility Proc
        end

        function self.hasTrinketProc()
            for i = 1, #self.trinket do
                if self.trinket[i]==true then return true else return false end
            end
        end

        -------------
        --- PERKS ---
        -------------

        function self.getPerks() -- Removed in Legion
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

            self.mode.rotation  = bb.data["Rotation"]
            self.mode.cooldown  = bb.data["Cooldown"]
            self.mode.defensive = bb.data["Defensive"]
            self.mode.interrupt = bb.data["Interrupt"]
            self.mode.sef       = bb.data["SEF"]
            self.mode.fsk       = bb.data["FSK"]
            self.mode.builder   = bb.data["Builder"]
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
        -- Chi Wave
        function self.castChiWave()
            if self.talent.chiWave and self.cd.chiWave == 0 and getDistance(self.units.dyn40AoE) < 40 then
                if castSpell("player",self.spell.chiWave,false,false,false) then return end
            end
        end
        -- Detox
        function self.castDetox(thisUnit)
            if self.level >= 22 and self.cd.detox == 0 and getDistance(thisUnit) < 40 then
                if castSpell(thisUnit,self.spell.detox,false,false,false) then return end
            end
        end
        -- Disable
        function self.castDisable(thisUnit)
            if self.level >= 25 and self.power > 15 and getDistance(thisUnit) < 5 then
                if castSpell(thisUnit,self.spell.disable,false,false,false) then return end
            end
        end
        -- Energizing Elixer
        function self.castEnergizingElixer()
            if self.talent.energizingElixer and self.cd.energizingElixer == 0 then
                if castSpell("player",self.spell.energizingElixer,false,false,false) then return end
            end 
        end
        -- Fists of Fury
        function self.castFistsOfFury()
            if self.level >= 28 and self.cd.fistsOfFury == 0 and self.chi.count >= 3 and getDistance(self.units.dyn5) < 5 then
                if castSpell(self.units.dyn5,self.spell.fistsOfFury,false,false,false) then return end
            end
        end
        -- Flying Serpent Kick
        function self.castFlyingSerpentKick()
            if self.level >= 10 and self.cd.flyingSerpentKick == 0 and (solo or hasThreat("target")) 
                and getFacingDistance() < 5 and getFacingDistance() > 0 and getDistance("target") >= 10 
            then
                if castSpell("player",self.spell.flyingSerpentKick,false,false,false) then return end
            end
        end
        function self.castFlyingSerpentKickEnd()
            if self.level >= 10 and getDistance("target") < 8 and select(3,GetSpellInfo(101545)) == 463281 then
                if castSpell("player",self.spell.flyingSerpentKickEnd,false,false,false) then return end
            end
        end
        -- Invoke Xuen
        function self.castInvokeXuen()
            if self.talent.invokeXuen and self.cd.invokeXuen == 0 and getDistance(self.units.dyn40AoE) < 40 then
                if castSpell(self.units.dyn40AoE,self.spell.invokeXuen,false,false,false) then return end
            end
        end
        -- Rising Sun Kick
        function self.castRisingSunKick(thisUnit)
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if self.level >= 18 and self.cd.risingSunKick == 0 and self.chi.count >= 2 and getDistance(thisUnit) < 5 then
                if castSpell(thisUnit,self.spell.risingSunKick,false,false,false) then return end
            end
        end
        -- Rushing Jade Wind
        function self.castRushingJadeWind()
            if self.talent.rushingJadeWind and self.cd.rushingJadeWind == 0 and self.chi >= 1 and getDistance(self.units.dyn8AoE) < 8 then
                if castSpell("player",self.spell.rushingJadeWind,false,false,false) then return end
            end
        end
        -- Serenity
        function self.castSerenity()
            if self.talent.serenity and self.cd.serenity == 0 and getDistance(self.units.dyn5) < 5 then
                if castSpell("player",self.spell.serenity,false,false,false) then return end
            end
        end
        -- Spear Hand Strike
        function self.castSpearHandStrike(thisUnit)
            if self.level >= 32 and self.cd.spearHandStrike == 0 and getDistance(thisUnit) < 5 then
                if castSpell(thisUnit,self.spell.spearHandStrike,false,false,false) then return end
            end
        end
        -- Spinning Crane Kick
        function self.castSpinningCraneKick()
            if self.level >= 40 and self.chi.count >= 3 and getDistance(self.units.dyn8AoE) < 8 then
                if castSpell("player",self.spell.spinningCraneKick,false,false,false) then return end
            end
        end
        -- Storm Earth and Fire
        function self.castStormEarthAndFire()
        --     if self.enemies.yards40>1 then
        --         local myTarget   = 0
        --         local sefEnemies = getEnemies("player",40)
        --         if ObjectExists("target") then
        --             myTarget = ObjectPointer("target")
        --         else
        --             myTarget = 0
        --         end
        --         for i=1, #sefEnemies do
        --             local thisUnit                  = sefEnemies[i]
        --             local hasThreat                 = hasThreat(thisUnit) -- UnitThreatSituation("player",thisUnit)~=nil or false
        --             local debuffStormEarthAndFire   = UnitDebuffID(thisUnit,self.spell.stormEarthAndFireDebuff,"player")~=nil or false

        --             if not debuffStormEarthAndFire and thisUnit~=myTarget and self.charges.stormEarthAndFire<2 and hasThreat and UnitName(thisUnit)~="Dungeoneer's Training Dummy" then
        --                 if castSpell(thisUnit,self.spell.stormEarthAndFire,false,false,false) then return end
        --             end
        --             if debuffStormEarthAndFire and thisUnit==myTarget then
        --                 if CancelUnitBuff("player", GetSpellInfo(self.spell.stormEarthAndFire)) then return end
        --             end
        --         end
        --     end
        end
        -- Strike of the Windlord
        function self.castStrikeOfTheWindlord()
            if self.artifact.strikeOfTheWindlord and self.cd.strikeOfTheWindlord == 0 and self.chi >= 2 and getDistance(self.units.dyn8) < 8 then
                if castSpell("player",self.spell.strikeOfTheWindlord,false,false,false) then return end
            end
        end
        -- Touch of Death
        function self.castTouchOfDeath()
            if self.level >= 24 and self.cd.touchOfDeath == 0 and getDistance(self.units.dyn5) < 5 then
                if castSpell(self.units.dyn5,self.spell.touchOfDeath,false,false,false) then return end
            end
        end
        -- Touch of Karma
        function self.castTouchOfKarma()
            if self.level >= 22 and self.cd.touchOfKarma == 0 and getDistance(self.units.dyn20AoE) < 20 then
                if castSpell(self.units.dyn20AoE,self.spell.touchOfKarma,false,false,false) then return end
            end
        end
        -- Whirling Dragon Punch
        function self.castWhirlingDragonPunch()
            if self.talent.whirlingDragonPunch and self.cd.whirlingDragonPunch == 0 and self.cd.fistOfFury == 0 and self.cd.risingSunKick == 0 and getDistance(self.units.dyn8AoE) < 8 then
                if castSpell("player",self.spell.whirlingDragonPunch,false,false,false) then return end
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
            if ((self.mode.rotation == 1 and #getEnemies("player",8) >= 3) or self.mode.rotation == 2) and UnitLevel("player")>=40 then
                return true
            else
                return false
            end
        end

        function useCDs()
            if (self.mode.cooldown == 1 and isBoss()) or self.mode.cooldown == 2 then
                return true
            else
                return false
            end
        end

        function useDefensive()
            if self.mode.defensive == 1 then
                return true
            else
                return false
            end
        end

        function useInterrupts()
            if self.mode.interrupt == 1 then
                return true
            else
                return false
            end
        end

        function useSEF()
            if self.mode.sef == 1 then
                return true
            else
                return false
            end
        end

        function useFSK()
            if self.mode.fsk == 1 then
                return true
            else
                return false
            end
        end

        function getFacingDistance()
            if UnitIsVisible("player") and UnitIsVisible("target") then
                --local targetDistance = getRealDistance("target")
                local targetDistance = getDistance("target")
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
            if select(3,GetSpellInfo(101545)) == 463281 then
                return true
            else
                return false
            end
        end

        -- function canFSK()
        --     --local targetDistance = getRealDistance("player","target")
        --     local targetDistane = getDistance("target")
        --     stopFSK = false
        --     if not inCombat and not UnitIsDeadOrGhost("target") and getTimeToDie("target") > 10 and not IsSwimming() and getTTD("target") and targetDistance < 60 then
        --         if (solo or hasThreat("target")) and self.cd.flyingSerpentKick == 0 and getFacingDistance() < 5 and getFacingDistance()>0 then
        --             if targetDistance < 8 then
        --                 stopFSK = true
        --                 return true
        --             elseif targetDistance >= 8 then
        --                 return true
        --             else
        --                 return false
        --             end
        --         end
        --     end
        -- end


        --     if ((targetDistance < 5 and isInCombat("player")) or (targetDistance < 60 and targetDistance > 5)) 
        --         and ((getSpellCD(_FlyingSerpentKick)==0 and not usingFSK()) 
        --             or usingFSK())
        --         and (getFacingDistance() < 5 and getFacingDistance()>0)
        --         and not UnitIsDeadOrGhost(unit)
        --         and getTimeToDie(unit) > 10
        --         and not IsSwimming()
        --     then
        --         return true
        --     else
        --         return false
        --     end
        -- end

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
              local player,data,GetShapeshiftForm,dynamicTarget = "player",bb.data,GetShapeshiftForm,dynamicTarget
              local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
              local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
              local getGround,canCast,isKnown,sp = getGround,canCast,isKnown,core.spells
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
                self.mode.sef     = data["SEF"]
                self.mode.cooldowns = data["Cooldowns"]
                --self.mode.defensive = bb.data["Defensive"]
                --self.mode.healing = bb.data["Healing"]

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