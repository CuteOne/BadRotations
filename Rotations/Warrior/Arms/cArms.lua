--- Arms Class
-- Inherit from: ../cCharacter.lua and ../cWarrior.lua
if select(2, UnitClass("player")) == "WARRIOR" then

    cArms = {}
    cArms.rotations = {}

    -- Creates Arms Warrior
    function cArms:new()
        local self = cWarrior:new("Arms")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cArms.rotations

        -----------------
        --- VARIABLES ---
        -----------------

        self.enemies = {
            -- yards10,
            -- yards30,
        }
        self.armsSpell = {
            -- Ability - Defensive
            dieByTheSword           = 118038,
            rallyingCry             = 97462,
            shieldBarrier           = 174926,

            -- Ability - Offensive
            colossusSmash           = 167105,
            execute                 = 163201,
            mortalStrike            = 12294,
            recklessness            = 1719,
            rend                    = 772,
            siegebreaker            = 176289,
            slam                    = 1464,
            sweepingStrikes         = 12328,
            thunderClap             = 6343,
            whirlwind               = 1680,

            -- Buff - Defensive
            dieByTheSwordBuff       = 118038,
            shieldBarrierBuff       = 174926,

            -- Buff - Offensive
            recklessnessBuff        = 1719,
            slamBuff                = 1464,
            suddenDeathBuff         = 52437,
            sweepingStrikesBuff     = 12328,

            -- Buff - Stacks

            -- Debuff - Offensive
            colossusSmashDebuff     = 167105,
            rendDebuff              = 772,

            -- Glyphs
            resonatingPowerGlyph    = 58356,
            -- Perks

            -- Talent
            siegebreakerTalent      = 176289,
            slamTalent              = 1464,
            tasteForBloodTalent     = 56636,

            -- Totems
        }
        self.frac  = {}
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.warriorSpell, self.armsSpell)

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
            self.getDebuffsCount()
            self.getCooldowns()
            self.getEnemies()
            -- self.getFrac()
            self.getRecharge()
            self.getToggleModes()


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

            self.buff.recklessness  = UnitBuffID("player",self.spell.recklessnessBuff)~=nil or false
            self.buff.slam          = UnitBuffID("player",self.spell.slamBuff)~=nil or false
            self.buff.suddenDeath   = UnitBuffID("player",self.spell.suddenDeathBuff)~=nil or false
            self.buff.shieldBarrier = UnitBuffID("player",self.spell.shieldBarrierBuff)~=nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            self.buff.duration.recklessness = getBuffDuration("player",self.spell.recklessnessBuff) or 0
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            self.buff.remain.recklessness = getBuffRemain("player",self.spell.recklessnessBuff) or 0
        end

        function self.getCharges()
            local getBuffStacks = getBuffStacks
            local getCharges = getCharges

            -- self.charges.lavaLash           = getCharges(self.spell.lavaLashStacks) or 0
        end

        function self.getRecharge()
            local getRecharge = getRecharge

            -- self.recharge.lavaLash      = getRecharge(self.spell.lavaLashStacks) or 0
        end

        -- function self.getFrac()
        --     local getCharges = getCharges
        --     local getRecharge = getRecharge
        --     local lavaLashRechargeTime = select(4,GetSpellCharges(self.spell.lavaLashStacks))

        --     self.frac.lavaLash      = (getCharges(self.spell.lavaLashStacks)+((lavaLashRechargeTime-getRecharge(self.spell.lavaLashStacks))/lavaLashRechargeTime)) or 0
        -- end

        ---------------
        --- DEBUFFS ---
        ---------------
        function self.getDebuffs()
            local UnitDebuffID = UnitDebuffID

            self.debuff.colossusSmash   = UnitDebuffID(self.units.dyn5,self.spell.colossusSmashDebuff,"player")~=nil or false
            self.debuff.rend            = UnitDebuffID(self.units.dyn5,self.spell.rendDebuff,"player")~=nil or false
        end

        function self.getDebuffsDuration()
            local getDebuffDuration = getDebuffDuration

            self.debuff.duration.colossusSmash  = getDebuffDuration(self.units.dyn5,self.spell.colossusSmashDebuff,"player") or 0
            self.debuff.duration.rend           = getDebuffDuration(self.units.dyn5,self.spell.rendDebuff,"player") or 0
        end

        function self.getDebuffsRemain()
            local getDebuffRemain = getDebuffRemain

            self.debuff.remain.colossusSmash    = getDebuffRemain(self.units.dyn5,self.spell.colossusSmashDebuff,"player") or 0
            self.debuff.remain.rend             = getDebuffRemain(self.units.dyn5,self.spell.rendDebuff,"player") or 0
        end

        function self.getDebuffsCount()
            local UnitDebuffID = UnitDebuffID
            local rendCount = 0

            if rendCount>0 and not inCombat then rendCount = 0 end

            for i=1,#getEnemies("player",5) do
                local thisUnit = getEnemies("player",5)[i]
                if UnitDebuffID(thisUnit,self.spell.rendDebuff,"player") then
                    rendCount = rendCount+1
                end
            end
            self.debuff.count.rend    = rendCount or 0
        end

        -----------------
        --- COOLDOWNS ---
        -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            self.cd.colossusSmash   = getSpellCD(self.spell.colossusSmash)
            self.cd.dieByTheSword   = getSpellCD(self.spell.dieByTheSword)
            self.cd.mortalStrike    = getSpellCD(self.spell.mortalStrike)
            self.cd.rallyingCry     = getSpellCD(self.spell.rallyingCry)
            self.cd.shieldBarrier   = getSpellCD(self.spell.shieldBarrier)
            self.cd.siegebreaker    = getSpellCD(self.spell.siegebreaker)
            self.cd.sweepingStrikes = getSpellCD(self.spell.sweepingStrikes)
            self.cd.thunderClap     = getSpellCD(self.spell.thunderClap)
        end

        --------------
        --- GLYPHS ---
        --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            self.glyph.resonatingPower = hasGlyph(self.spell.resonatingPowerGlyph)
        end

        ---------------
        --- TALENTS ---
        ---------------

        function self.getTalents()
            local getTalent = getTalent

            self.talent.slam         = getTalent(3,3)
            self.talent.siegebreaker = getTalent(7,3)
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

            -- AoE
            self.units.dyn8AoE  = dynamicTarget(8,false)
        end

        ---------------
        --- ENEMIES ---
        ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            -- self.enemies.yards10 = #getEnemies("player",10)
        end

        ---------------
        --- TOGGLES ---
        ---------------

        function self.getToggleModes()
            local data   = bb.data

            self.mode.rotation  = data["Rotation"]
            self.mode.cooldown  = data["Cooldown"]
            self.mode.defensive = data["Defensive"]
            self.mode.interrupt = data["Interrupt"]
            self.mode.mover     = data["Mover"]
        end

        -- Create the toggle defined within rotation files
        function self.createToggles()
            GarbageButtons()
            self.rotations[bb.selectedProfile].toggles()
        end

        ---------------
        --- OPTIONS ---
        ---------------

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
        function self.castColossusSmash()
            if self.level>=81 and self.buff.battleStance and self.cd.colossusSmash==0 and self.power>10 and getTimeToDie(self.units.dyn5)>5 then
                if castSpell(self.units.dyn5,self.spell.colossusSmash,false,false,false) then return end
            end
        end
        function self.castDieByTheSword()
            if self.level>=56 and self.cd.dieByTheSword==0 then
                if castSpell("player",self.spell.dieByTheSword,false,false,false) then return end
            end
        end
        function self.castExecute(thisUnit)
            local thisUnit = thisUnit
            if self.level>=7 and ((self.power>10 and getHP(thisUnit)<20) or self.buff.suddenDeath) then
                if castSpell(thisUnit,self.spell.execute,false,false,false) then return end
            end
        end
        function self.castMortalStrike()
            if self.level>=10 and self.cd.mortalStrike==0 and self.power>20 then
                if castSpell(self.units.dyn5,self.spell.mortalStrike,false,false,false) then return end
            end
        end
        function self.castRallyingCry()
            if self.level>=83 and self.cd.rallyingCry==0 then
                if castSpell("player",self.spell.rallyingCry,false,false,false) then return end
            end
        end
        function self.castRecklessness()
            if self.level>=87 and self.buff.battleStance and self.cd.recklessness==0 and inRange(self.spell.rend,self.units.dyn5) and getTimeToDie(self.units.dyn5)>5 then
                if castSpell("player",self.spell.recklessness,false,false,false) then return end
            end
        end
        function self.castRend(thisUnit)
            local thisUnit = thisUnit
            if self.level>=7 and self.power>5 then
                if castSpell(thisUnit,self.spell.rend,false,false,false) then return end
            end
        end
        function self.castShieldBarrier()
            if self.level>=81 and self.power>20 and self.buff.defensiveStance and self.cd.shieldBarrier==0 and not self.buff.shieldBarrier then
                if castSpell("player",self.spell.shieldBarrier,false,false,false) then return end
            end
        end
        function self.castSiegebreaker()
            if self.talent.siegebreaker and self.cd.siegebreaker==0 and inRange(self.spell.rend,self.units.dyn5) then
                if castSpell(self.units.dyn5,self.spell.siegebreaker,false,false,false) then return end
            end
        end
        function self.castSlam()
            if self.talent.slam and ((self.power>10 and not self.buff.slam) or (self.buff.slam and self.power>20)) then
                if castSpell(self.units.dyn5,self.spell.slam,false,false,false) then return end
            end
        end
        function self.castSweepingStrikes()
            if self.level>=60 and self.cd.sweepingStrikes==0 and self.power>10 and getDistance(self.units.dyn8AoE)<8 and getTimeToDie(self.units.dyn8AoE)>5 then
                if castSpell(self.units.dyn8AoE,self.spell.sweepingStrikes,false,false,false) then return end
            end
        end
        function self.castThunderClap()
            if self.level>=14 and self.cd.thunderClap==0 and self.power>10 and getDistance(self.units.dyn8AoE)<8 then
                if castSpell(self.units.dyn8AoE,self.spell.thunderClap,false,false,false) then return end
            end
        end
        function self.castWhirlwind()
            if self.level>=26 and self.power>20 and getDistance(self.units.dyn8AoE)<8 then
                if castSpell(self.units.dyn8AoE,self.spell.whirlwind,false,false,false) then return end
            end
        end

        ------------------------
        --- CUSTOM FUNCTIONS ---
        ------------------------

        function hasLust()
            if UnitBuffID("player",2825)       -- Bloodlust
                or UnitBuffID("player",80353)  -- Timewarp
                or UnitBuffID("player",32182)  -- Heroism
                or UnitBuffID("player",90355)  -- Ancient Hysteria
            then
                return true
            else
                return false
            end
        end

        function useAoE()
            local rotation = self.mode.rotation
            if (rotation == 1 and #getEnemies("player",8) >= 2) or rotation == 2 then
            -- if bb.data['AoE'] == 1 or bb.data['AoE'] == 2 then
                return true
            else
                return false
            end
        end

        function useCDs()
            local cooldown = self.mode.cooldown 
            if (cooldown == 1 and isBoss()) or cooldown == 2 then
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

        function useMover()
            if self.mode.mover == 1 then
                return true
            else
                return false
            end
        end

        SLASH_armshelp1 = "/armshelp"
        function SlashCmdList.armshelp(msg, editbox)
            print("|cFFC79C6EBadBoy Arms Warrior")
            print("|cFFC79C6EUsage: |rAuto AoE if 2+ Targets in 8y\nWill always spread Rend on all targets in Melee-Range\nWill Execute nearby low enemies\nAll other spells will be casted regarding your Dyncamic Target Settings")
            print("|cFFC79C6EOptions:|rSingle / Multi BS/DR/RV\nWill use Bladestorm, Dragon Roar, Ravager automatically (turn off you want to use them manually for specific Raid Events)")
            print("Ravager will be excluded from auto-usage if >Ravager Key< is checked")
        end

        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        -- Return
        return self
    end-- cArms
end-- select Warrior