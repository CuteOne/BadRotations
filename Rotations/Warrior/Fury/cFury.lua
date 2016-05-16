--- Fury Class
-- Inherit from: ../cCharacter.lua and ../cWarrior.lua
if select(2, UnitClass("player")) == "WARRIOR" then

    cFury = {}
    cFury.rotations = {}

    -- Creates Fury Warrior
    function cFury:new()
        local self = cWarrior:new("Fury")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cFury.rotations

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

        ---------------
        --- TOGGLES ---
        ---------------

        function self.getToggleModes()
            local BadBoy_data   = BadBoy_data

            self.mode.rotation  = BadBoy_data["Rotation"]
            self.mode.cooldowns = BadBoy_data["Cooldowns"]
            self.mode.defensive = BadBoy_data["Defensive"]
            self.mode.interrupt = BadBoy_data["Interrupt"]
            self.mode.cleave    = BadBoy_data["Mover"]
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

        ------------------------
        --- CUSTOM FUNCTIONS ---
        ------------------------
        function hasLust()
            if UnitBuffID("player",2825)        -- Bloodlust
                or UnitBuffID("player",80353)   -- Timewarp
                or UnitBuffID("player",32182)   -- Heroism
                or UnitBuffID("player",90355)   -- Ancient Hysteria
            then
                return true
            else
                return false
            end
        end

        function useAoE()
            local rotation = self.mode.rotation
            if (rotation == 1 and #getEnemies("player",8) >= 2) or rotation == 2 then
            -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
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

        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        -- Return
        return self
    end-- cFury
end-- select Warrior