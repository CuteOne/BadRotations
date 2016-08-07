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
            stormEarthAndFireBuff           = 137639,
            touchOfKarmaBuff                = 122470,
        }
        self.windwalkerDebuffs = {
            markOfTheCrane                  = 228287,
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
            stormEarthAndFireFixate         = 221771,
            touchOfDeath                    = 115080,
            touchOfKarma                    = 122470,
        }
        self.windwalkerTalents = {
            ascension                       = 115396,
            chiOrbit                        = 196743,
            chiWave                         = 115098,
            dizzyingKicks                   = 196722,
            energizingElixir                = 115288,
            eyeOfTheTiger                   = 196607,
            healingElixir                   = 122281,
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

            self.buff.serenity          = UnitBuffID("player",self.spell.serenityBuff)~=nil or false
            self.buff.stormEarthAndFire = UnitBuffID("player",self.spell.stormEarthAndFireBuff)~=nil or false
            self.buff.touchOfKarma      = UnitBuffID("player",self.spell.touchOfKarmaBuff)~=nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            self.buff.duration.serenity             = getBuffDuration("player",self.spell.serenityBuff) or 0
            self.buff.duration.stormEarthAndFire    = getBuffDuration("player",self.spell.stormEarthAndFireBuff) or 0
            self.buff.duration.touchOfKarma         = getBuffDuration("player",self.spell.touchOfKarmaBuff) or 0
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            self.buff.remain.serenity           = getBuffRemain("player",self.spell.serenityBuff) or 0
            self.buff.remain.stormEarthAndFire  = getBuffRemain("player",self.spell.stormEarthAndFireBuff) or 0
            self.buff.remain.touchOfKarma       = getBuffRemain("player", self.spell.touchOfKarmaBuff) or 0
        end

        function self.getCharges()
            local getBuffStacks = getBuffStacks

            self.charges.healingElixir      = getCharges(self.spell.healingElixir) or 0
            self.charges.stormEarthAndFire  = getCharges(self.spell.stormEarthAndFire) or 0
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
            self.cd.energizingElixir    = getSpellCD(self.spell.energizingElixir)
            self.cd.fistsOfFury         = getSpellCD(self.spell.fistsOfFury)
            self.cd.flyingSerpentKick   = getSpellCD(self.spell.flyingSerpentKick)
            self.cd.invokeXuen          = getSpellCD(self.spell.invokeXuen)
            self.cd.risingSunKick       = getSpellCD(self.spell.risingSunKick)
            self.cd.spearHandStrike     = getSpellCD(self.spell.spearHandStrike)
            self.cd.strikeOfTheWindlord = getSpellCD(self.spell.strikeOfTheWindlord)
            self.cd.touchOfDeath        = getSpellCD(self.spell.touchOfDeath)
            self.cd.touchOfKarma        = getSpellCD(self.spell.touchOfKarma)
            self.cd.whirlingDragonPunch = getSpellCD(self.spell.whirlingDragonPunch)
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
            self.talent.energizingElixir    = getTalent(3,1)
            self.talent.ascension           = getTalent(3,2)
            self.talent.powerStrikes        = getTalent(3,3)
            self.talent.dizzyingKicks       = getTalent(4,2)
            self.talent.healingElixir       = getTalent(5,1)
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
        function self.castEnergizingElixir()
            if self.talent.energizingElixir and self.cd.energizingElixir == 0 then
                if castSpell("player",self.spell.energizingElixir,false,false,false) then return end
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
            if self.level >= 10 and self.cd.flyingSerpentKick == 0 and (self.instance == "none" or hasThreat("target")) 
                and getFacingDistance() < 5 and getFacingDistance() > 0 
                and getDistance("target") >= 5 and getDistance("target") < 60 
            then
                if castSpell("player",self.spell.flyingSerpentKick,false,false,false) then return end
            end
        end
        function self.castFlyingSerpentKickEnd()
            if self.level >= 10 and (getDistance("target") < 5 or getFacingDistance() ~= abs(getFacingDistance())) and select(3,GetSpellInfo(101545)) == 463281 then
                if castSpell("player",self.spell.flyingSerpentKickEnd,false,false,false) then return end
            end
        end
        -- Healing Elixirs
        function self.castHealingElixir()
            if self.talent.healingElixir and self.charges.healingElixir > 0 then
                if castSpell("player",self.spell.healingElixir,false,false,false) then return end
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
            if self.level >= 65 and self.charges.stormEarthAndFire > 0 and not self.buff.stormEarthAndFire and getDistance(self.units.dyn5) < 5 then
                if castSpell(self.units.dyn5,self.spell.stormEarthAndFire,false,false,false) then return end
            end
        end
        -- Storm Earth and Fire Fixate
        function self.castStormEarthAndFireFixate()
            if self.level >= 65 and self.buff.stormEarthAndFire then
                if castSpell(self.units,dyn5,self.spell.stormEarthAndFireFixate,false,false,false) then return end
            end
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
            if self.talent.whirlingDragonPunch and self.cd.whirlingDragonPunch == 0 and self.cd.fistsOfFury ~= 0 and self.cd.risingSunKick ~= 0 and getDistance(self.units.dyn8AoE) < 8 then
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

        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()


        -- Return
        return self
    end-- cWindwalker
end-- select Monk