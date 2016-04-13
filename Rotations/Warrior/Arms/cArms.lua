--- Arms Class
-- Inherit from: ../cCharacter.lua and ../cWarrior.lua
if select(2, UnitClass("player")) == "WARRIOR" then

    cArms = {}

    -- Creates Arms Warrior
    function cArms:new()
        local self = cWarrior:new("Arms")

        local player = "player" -- if someone forgets ""

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

            self.buff.recklessness  = UnitBuffID("player",self.spell.recklessnessBuff)~=nil or false
            self.buff.slam          = UnitBuffID("player",self.spell.slamBuff)~=nil or false
            self.buff.suddenDeath   = UnitBuffID("player",self.spell.suddenDeathBuff)~=nil or false
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

        ----------------------
        --- START ROTATION ---
        ----------------------

        -- Rotation selection update
        function self.getRotation()
            self.rotation = bb.selectedProfile

            if bb.rotation_changed then
                --self.createToggles()
                self.createOptions()

                bb.rotation_changed = false
            end
        end

        function self.startRotation()
            if self.rotation == 1 then
                self:ArmsCuteOne()
            elseif self.rotation == 2 then
                self:ArmsOld()
            elseif self.rotation == 3 then
                ChatOverlay("No Rotation Selected!")
            else
                ChatOverlay("No ROTATION ?!", 2000)
            end
        end

        ---------------
        --- OPTIONS ---
        ---------------

        function self.createOptions()
            bb.ui.window.profile = bb.ui:createProfileWindow("Arms")
            local section

            -- Create Base and Class options
            self.createClassOptions()

            --   _____                           _
            --  / ____|                         | |
            -- | |  __  ___ _ __   ___ _ __ __ _| |
            -- | | |_ |/ _ \ '_ \ / _ \ '__/ _` | |
            -- | |__| |  __/ | | |  __/ | | (_| | |
            --  \_____|\___|_| |_|\___|_|  \__,_|_|
            section = bb.ui:createSection(bb.ui.window.profile,  "General")
            -- Dummy DPS Test
            bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")

            -- Berserker Rage
            bb.ui:createCheckbox(section,"Berserker Rage")

            -- Hamstring
            bb.ui:createCheckbox(section,"Hamstring")

            -- Pre-Pull Timer
            bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")

            bb.ui:checkSectionState(section)
            
            --   _____            _     _
            --  / ____|          | |   | |
            -- | |     ___   ___ | | __| | _____      ___ __  ___
            -- | |    / _ \ / _ \| |/ _` |/ _ \ \ /\ / / '_ \/ __|
            -- | |___| (_) | (_) | | (_| | (_) \ V  V /| | | \__ \
            --  \_____\___/ \___/|_|\__,_|\___/ \_/\_/ |_| |_|___/
            section = bb.ui:createSection(bb.ui.window.profile,  "Cooldowns")
            -- Agi Pot
            bb.ui:createCheckbox(section,"Str-Pot")

            -- Legendary Ring
            bb.ui:createCheckbox(section, "Legendary Ring", "Enable or Disable usage of Legendary Ring.")
            -- bb.ui:createDropdown(section,  "Legendary Ring", { "CD"},  2)

            -- Flask / Crystal
            bb.ui:createCheckbox(section,"Flask / Crystal")

            -- Trinkets
            bb.ui:createCheckbox(section,"Trinkets")

            -- Touch of the Void
            bb.ui:createCheckbox(section,"Touch of the Void")
            
            bb.ui:checkSectionState(section)

            --  _____        __               _
            -- |  __ \      / _|             (_)
            -- | |  | | ___| |_ ___ _ __  ___ ___   _____
            -- | |  | |/ _ \  _/ _ \ '_ \/ __| \ \ / / _ \
            -- | |__| |  __/ ||  __/ | | \__ \ |\ V /  __/
            -- |_____/ \___|_| \___|_| |_|___/_| \_/ \___|
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
            -- Healthstone
            bb.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Heirloom Neck
            bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Gift of The Naaru
            if self.race == "Draenei" then
                bb.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end

            -- Defensive Stance
            bb.ui:createSpinner(section, "Defensive Stance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Die By The Sword
            bb.ui:createSpinner(section, "Die by the Sword",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Intervene
            bb.ui:createSpinner(section, "Intervene",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Intimidating Shout
            bb.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Rallying Cry
            bb.ui:createSpinner(section, "Rallying Cry",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Vigilance
            bb.ui:createSpinner(section, "Vigilance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            bb.ui:checkSectionState(section)


            --  _____       _                             _
            -- |_   _|     | |                           | |
            --   | |  _ __ | |_ ___ _ __ _ __ _   _ _ __ | |_ ___
            --   | | | '_ \| __/ _ \ '__| '__| | | | '_ \| __/ __|
            --  _| |_| | | | ||  __/ |  | |  | |_| | |_) | |_\__ \
            -- |_____|_| |_|\__\___|_|  |_|   \__,_| .__/ \__|___/
            --                                     | |
            --                                     |_|
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
            
            -- Pummel
            bb.ui:createCheckbox(section,"Pummel")

            -- Intimidating Shout
            bb.ui:createCheckbox(section,"Intimidating Shoult - Int")
            
            -- Spell Reflection
            bb.ui:createCheckbox(section,"Spell Refelection")

            -- Interrupt Percentage
            bb.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
            bb.ui:checkSectionState(section)

            -- _______                _        _  __
            --|__   __|              | |      | |/ /
            --   | | ___   __ _  __ _| | ___  | ' / ___ _   _ ___
            --   | |/ _ \ / _` |/ _` | |/ _ \ |  < / _ \ | | / __|
            --   | | (_) | (_| | (_| | |  __/ | . \  __/ |_| \__ \
            --   |_|\___/ \__, |\__, |_|\___| |_|\_\___|\__, |___/
            --             __/ | __/ |                   __/ |
            --            |___/ |___/                   |___/
            section = bb.ui:createSection(bb.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            bb.ui:createDropdown(section,  "Rotation Mode", bb.dropOptions.Toggle,  4)

            --Cooldown Key Toggle
            bb.ui:createDropdown(section,  "Cooldown Mode", bb.dropOptions.Toggle,  3)

            --Defensive Key Toggle
            bb.ui:createDropdown(section,  "Defensive Mode", bb.dropOptions.Toggle,  6)

            -- Interrupts Key Toggle
            bb.ui:createDropdown(section,  "Interrupt Mode", bb.dropOptions.Toggle,  6)

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
        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()


        -- Return
        return self
    end-- cArms
end-- select Warrior