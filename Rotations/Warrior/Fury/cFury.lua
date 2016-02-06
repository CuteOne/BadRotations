--- Fury Class
-- Inherit from: ../cCharacter.lua and ../cWarrior.lua
if select(2, UnitClass("player")) == "WARRIOR" then

    cFury = {}

    -- Creates Fury Warrior
    function cFury:new()
        local self = cWarrior:new("Fury")

        local player = "player" -- if someone forgets ""

        -----------------
        --- VARIABLES ---
        -----------------

        self.enemies = {
            -- yards10,
            -- yards30,
        }
        self.furySpell = {
            -- Ability - Defensive
            dieByTheSword               = 118038,
            piercingHowl                = 12323,
            rallyingCry                 = 97462,
            shieldBarrier               = 174926,

            -- Ability - Offensive
            bloodthirst                 = 23881,
            execute                     = 5308,
            ragingBlow                  = 85288,
            recklessness                = 1719,
            siegebreaker                = 176289,
            whirlwind                   = 1680,
            wildStrike                  = 100130,

            -- Buff - Defensive
            
            -- Buff - Offensive
            bloodsurgeBuff              = 46915,
            enrageBuff                  = 13046,
            meatCleaverBuff             = 85739,
            ragingBlowBuff              = 131116,
            recklessnessBuff            = 1719,
            suddenDeathBuff             = 52437,
            
            -- Buff - Stacks

            -- Debuff - Offensive
            
            -- Glyphs
            
            -- Perks

            -- Talent
            furiousStrikesTalent        = 169679,
            siegebreakerTalent          = 176289,
            unquenchableThirstTalent    = 169683,
            
            -- Totems
        }
        self.frac  = {}
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.warriorSpell, self.furySpell)

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

            self.buff.bloodsurge    = UnitBuffID("player",self.spell.bloodsurgeBuff)~=nil or false
            self.buff.enrage        = UnitBuffID("player",self.spell.enrageBuff)~=nil or false
            self.buff.meatCleaver   = UnitBuffID("player",self.spell.meatCleaverBuff)~=nil or false
            self.buff.ragingBlow    = UnitBuffID("player",self.spell.ragingBlowBuff)~=nil or false
            self.buff.recklessness  = UnitBuffID("player",self.spell.recklessnessBuff)~=nil or false
            self.buff.suddenDeath   = UnitBuffID("player",self.spell.suddenDeathBuff)~=nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            self.buff.duration.recklessness = getBuffDuration("player",self.spell.recklessnessBuff) or 0
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            self.buff.remain.enrage         = getBuffRemain("player",self.spell.enrageBuff) or 0
            self.buff.remain.recklessness   = getBuffRemain("player",self.spell.recklessnessBuff) or 0
        end

        function self.getCharges()
            local getBuffStacks = getBuffStacks
            local getCharges = getCharges

            self.charges.meatCleaver    = getBuffStacks("player",self.spell.meatCleaverBuff) or 0
            self.charges.ragingBlow     = getBuffStacks("player",self.spell.ragingBlowBuff) or 0
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

            -- self.debuff.colossusSmash   = UnitDebuffID(self.units.dyn5,self.spell.colossusSmashDebuff,"player")~=nil or false
        end

        function self.getDebuffsDuration()
            local getDebuffDuration = getDebuffDuration

            -- self.debuff.duration.colossusSmash  = getDebuffDuration(self.units.dyn5,self.spell.colossusSmashDebuff,"player") or 0
        end

        function self.getDebuffsRemain()
            local getDebuffRemain = getDebuffRemain

            -- self.debuff.remain.colossusSmash    = getDebuffRemain(self.units.dyn5,self.spell.colossusSmashDebuff,"player") or 0
        end

        function self.getDebuffsCount()
            local UnitDebuffID = UnitDebuffID
            -- local rendCount = 0

            -- if rendCount>0 and not inCombat then rendCount = 0 end

            -- for i=1,#getEnemies("player",5) do
            --     local thisUnit = getEnemies("player",5)[i]
            --     if UnitDebuffID(thisUnit,self.spell.rendDebuff,"player") then
            --         rendCount = rendCount+1
            --     end
            -- end
            -- self.debuff.count.rend    = rendCount or 0
        end

        -----------------
        --- COOLDOWNS ---
        -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            self.cd.bloodthirst     = getSpellCD(self.spell.bloodthirst)
            self.cd.dieByTheSword   = getSpellCD(self.spell.dieByTheSword)
            self.cd.siegebreaker    = getSpellCD(self.spell.siegebreaker)
        end

        --------------
        --- GLYPHS ---
        --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            -- self.glyph.resonatingPower = hasGlyph(self.spell.resonatingPowerGlyph)
        end

        ---------------
        --- TALENTS ---
        ---------------

        function self.getTalents()
            local getTalent = getTalent

            self.talent.furiousStrikes      = getTalent(3,1)
            self.talent.unquenchableThirst  = getTalent(3,3)
            self.talent.siegebreaker        = getTalent(7,3)
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
                self:FuryCuteOne()
            elseif self.rotation == 2 then
                self:FuryAvery()
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
            bb.profile_window = createNewProfileWindow("Fury")
            local section

            -- Create Base and Class options
            self.createClassOptions()

            --   _____                           _
            --  / ____|                         | |
            -- | |  __  ___ _ __   ___ _ __ __ _| |
            -- | | |_ |/ _ \ '_ \ / _ \ '__/ _` | |
            -- | |__| |  __/ | | |  __/ | | (_| | |
            --  \_____|\___|_| |_|\___|_|  \__,_|_|
            section = createNewSection(bb.profile_window,  "General")
            -- Dummy DPS Test
                createNewSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")

            -- Berserker Rage
                createNewCheckbox(section,"Berserker Rage")

            -- Hamstring
                createNewCheckbox(section,"Hamstring")

            -- Pre-Pull Timer
                createNewSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")

            checkSectionState(section)
            
            --   _____            _     _
            --  / ____|          | |   | |
            -- | |     ___   ___ | | __| | _____      ___ __  ___
            -- | |    / _ \ / _ \| |/ _` |/ _ \ \ /\ / / '_ \/ __|
            -- | |___| (_) | (_) | | (_| | (_) \ V  V /| | | \__ \
            --  \_____\___/ \___/|_|\__,_|\___/ \_/\_/ |_| |_|___/
            section = createNewSection(bb.profile_window,  "Cooldowns")
            -- Agi Pot
                createNewCheckbox(section,"Str-Pot")

            -- Legendary Ring
                createNewCheckbox(section, "Legendary Ring", "Enable or Disable usage of Legendary Ring.")
                -- createNewDropdown(section,  "Legendary Ring", { "CD"},  2)

            -- Flask / Crystal
                createNewCheckbox(section,"Flask / Crystal")

            -- Racials
                createNewCheckbox(section,"Racial")

            -- Trinkets
                createNewCheckbox(section,"Trinkets")

            -- Touch of the Void
                createNewCheckbox(section,"Touch of the Void")

            -- Avatar
                createNewCheckbox(section,"Avatar")

            -- Bladestorm
                createNewCheckbox(section,"Bladestorm")

            -- Bloodbath
                createNewCheckbox(section,"Bloodbath")

            -- Dragon Roar
                createNewCheckbox(section,"Dragon Roar")

            -- Ravager
                createNewCheckbox(section,"Ravager")

            -- Recklessness
                createNewCheckbox(section,"Recklessness")

            -- Shockwave
                createNewCheckbox(section,"Shockwave")

            -- Siegebreaker
                createNewCheckbox(section,"Siegebreaker")

            checkSectionState(section)
            
            --  _____        __               _
            -- |  __ \      / _|             (_)
            -- | |  | | ___| |_ ___ _ __  ___ ___   _____
            -- | |  | |/ _ \  _/ _ \ '_ \/ __| \ \ / / _ \
            -- | |__| |  __/ ||  __/ | | \__ \ |\ V /  __/
            -- |_____/ \___|_| \___|_| |_|___/_| \_/ \___|
            section = createNewSection(bb.profile_window, "Defensive")
            -- Healthstone
                createNewSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Heirloom Neck
                createNewSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Gift of The Naaru
                if self.race == "Draenei" then
                    createNewSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                end

            -- Defensive Stance
                createNewSpinner(section, "Defensive Stance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Die By The Sword
                createNewSpinner(section, "Die by the Sword",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Intervene
                createNewSpinner(section, "Intervene",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Intimidating Shout
                createNewSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Rallying Cry
                createNewSpinner(section, "Rallying Cry",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Vigilance
                createNewSpinner(section, "Vigilance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            checkSectionState(section)

            --  _____       _                             _
            -- |_   _|     | |                           | |
            --   | |  _ __ | |_ ___ _ __ _ __ _   _ _ __ | |_ ___
            --   | | | '_ \| __/ _ \ '__| '__| | | | '_ \| __/ __|
            --  _| |_| | | | ||  __/ |  | |  | |_| | |_) | |_\__ \
            -- |_____|_| |_|\__\___|_|  |_|   \__,_| .__/ \__|___/
            --                                     | |
            --                                     |_|
            section = createNewSection(bb.profile_window, "Interrupts")
            
            -- Pummel
                createNewCheckbox(section,"Pummel")

            -- Intimidating Shout
                createNewCheckbox(section,"Intimidating Shoult - Int")
            
            -- Spell Reflection
                createNewCheckbox(section,"Spell Refelection")

            -- Interrupt Percentage
                createNewSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")

            checkSectionState(section)

            -- _______                _        _  __
            --|__   __|              | |      | |/ /
            --   | | ___   __ _  __ _| | ___  | ' / ___ _   _ ___
            --   | |/ _ \ / _` |/ _` | |/ _ \ |  < / _ \ | | / __|
            --   | | (_) | (_| | (_| | |  __/ | . \  __/ |_| \__ \
            --   |_|\___/ \__, |\__, |_|\___| |_|\_\___|\__, |___/
            --             __/ | __/ |                   __/ |
            --            |___/ |___/                   |___/
            section = createNewSection(bb.profile_window,  "Toggle Keys")
            -- Single/Multi Toggle
                createNewDropdown(section,  "Rotation Mode", bb.dropOptions.Toggle,  4)

            --Cooldown Key Toggle
                createNewDropdown(section,  "Cooldown Mode", bb.dropOptions.Toggle,  3)

            --Defensive Key Toggle
                createNewDropdown(section,  "Defensive Mode", bb.dropOptions.Toggle,  6)

            -- Interrupts Key Toggle
                createNewDropdown(section,  "Interrupt Mode", bb.dropOptions.Toggle,  6)

            -- Pause Toggle
                createNewDropdown(section,  "Pause Mode", bb.dropOptions.Toggle,  6)

            checkSectionState(section)

            --[[ Rotation Dropdown ]]--
            createNewRotationDropdown(bb.profile_window.parent, {"CuteOne"})
            bb:checkProfileWindowStatus()
        end

        --------------
        --- SPELLS ---
        --------------
        function self.castBloodthirst()
            if self.level>=10 and self.cd.bloodthirst==0 and getDistance(self.units.dyn5)<5 then
                if castSpell(self.units.dyn5,self.spell.bloodthirst,false,false,false) then return end
            end
        end
        function self.castDieByTheSword()
            if self.level>=56 and self.cd.dieByTheSword==0 then
                if castSpell("player",self.spell.dieByTheSword,false,false,false) then return end
            end
        end
        function self.castExecute(thisUnit)
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if self.level>=7 and ((self.power>30 and getHP(thisUnit)<20) or self.buff.suddenDeath) and getDistance(thisUnit)<5 then
                if castSpell(thisUnit,self.spell.execute,false,false,false) then return end
            end
        end
        function self.castRagingBlow()
            if self.level>=30 and self.power>10 and self.buff.ragingBlow and getDistance(self.units.dyn5)<5 then
                if castSpell(self.units.dyn5,self.spell.ragingBlow,false,false,false) then return end
            end
        end
        function self.castRallyingCry()
            if self.level>=83 and self.cd.rallyingCry==0 then
                if castSpell("player",self.spell.rallyingCry,false,false,false) then return end
            end
        end
        function self.castRecklessness()
            if self.level>=87 and self.buff.battleStance and self.cd.recklessness==0 and getDistance(self.units.dyn5)<5 and getTimeToDie(self.units.dyn5)>5 then
                if castSpell("player",self.spell.recklessness,false,false,false) then return end
            end
        end
        function self.castSiegebreaker()
            if self.talent.siegebreaker and self.cd.siegebreaker==0 and getDistance(self.units.dyn5)<5 and getTimeToDie(self.units.dyn5)>5 then
                if castSpell(self.units.dyn5,self.spell.siegebreaker,false,false,false) then return end
            end
        end
        function self.castWhirlwind()
            if self.level>=26 and self.power>30 and getDistance(self.units.dyn8AoE)<8 then
                if castSpell(self.units.dyn8AoE,self.spell.whirlwind,false,false,false) then return end
            end
        end
        function self.castWildStrike()
            if self.level>=18 and (self.power>45 or self.buff.bloodsurge or (self.talent.furiousStrikes and self.power>20)) and getDistance(self.units.dyn5)<5 then
                if castSpell(self.units.dyn5,self.spell.wildStrike,false,false,false) then return end
            end
        end
        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()


        -- Return
        return self
    end-- cFury
end-- select Warrior