--- Enhancement Class
-- Inherit from: ../cCharacter.lua and ../cShaman.lua
if select(2, UnitClass("player")) == "SHAMAN" then

    cEnhancement = {}
    cEnhancement.rotations = {}

    -- Creates Enhancement Shaman
    function cEnhancement:new()
        local self = cShaman:new("Enhancement")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cEnhancement.rotations

        -----------------
        --- VARIABLES ---
        -----------------

        self.enemies = {
            yards10,
            yards20,
            yards30,
        }
        self.enhancementSpell = {
            -- Ability - Defensive

            -- Ability - Offensive
            ascendance              = 114051,
            feralSpirit             = 51533,
            fireNova                = 1535,
            lavaLash                = 60103,
            primalStrike            = 73899,
            stormstrike             = 17364,
            unleashElements         = 73680,
            windstrike              = 115356,

            -- Buff - Defensive
            
            -- Buff - Offensive
            ascendanceBuff          = 114051,
            unleashFlameBuff        = 73683,
            unleashWindBuff         = 73681,

            -- Buff - Stacks
            lavaLashStacks          = 60103,
            maelstromWeaponStacks   = 53817,
            stormstrikeStacks       = 17364,
            windstrikeStacks        = 115356,
            unleashWindStacks       = 73681,

            -- Debuff - Offensive
            stormstrikeDebuff       = 17364,
            windstrikeDebuff        = 115356,

            -- Glyphs
            fireNovaGlyph           = 55450,

            -- Perks

            -- Talent
            unleashedFuryTalent     = 117012,

            -- Totems
            magmaTotem              = 8190,
        }
        self.frac  = {}
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.shamanSpell, self.enhancementSpell)

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
            self.getFrac()
            self.getRecharge()
            self.getRotation()
            self.getTotems()
            self.getTotemsDuration()
            self.getTotemsRemain()


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

            self.buff.ascendance        = UnitBuffID("player",self.spell.ascendanceBuff)~=nil or false
            self.buff.maelstromWeapon   = UnitBuffID("player",self.spell.maelstromWeaponStacks)~=nil or false
            self.buff.unleashFlame      = UnitBuffID("player",self.spell.unleashFlameBuff)~=nil or false
            self.buff.unleashWind       = UnitBuffID("player",self.spell.unleashWindBuff)~=nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            self.buff.duration.ascendance       = getBuffDuration("player",self.spell.ascendanceBuff) or 0
            self.buff.duration.maelstromWeapon  = getBuffDuration("player",self.spell.maelstromWeaponStacks) or 0
            self.buff.duration.unleashFlame     = getBuffDuration("player",self.spell.unleashFlameBuff) or 0
            self.buff.duration.unleashWind      = getBuffDuration("player",self.spell.unleashWindBuff) or 0
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            self.buff.remain.ascendance         = getBuffRemain("player",self.spell.ascendanceBuff) or 0
            self.buff.remain.maelstromWeapon    = getBuffRemain("player",self.spell.maelstromWeaponStacks) or 0
            self.buff.remain.unleashFlame       = getBuffRemain("player",self.spell.unleashFlameBuff) or 0
            self.buff.remain.unleashWind        = getBuffRemain("player",self.spell.unleashWindBuff) or 0
        end

        function self.getCharges()
            local getBuffStacks = getBuffStacks
            local getCharges = getCharges

            self.charges.lavaLash           = getCharges(self.spell.lavaLashStacks) or 0
            self.charges.maelstromWeapon    = getBuffStacks("player",self.spell.maelstromWeaponStacks,"player") or 0
            self.charges.stormstrike        = getCharges(self.spell.stormstrikeStacks) or 0
            self.charges.windstrike         = getCharges(self.spell.windstrikeStacks) or 0
            self.charges.unleashWind        = getBuffStacks("player",self.spell.unleashWindStacks,"player") or 0
        end

        function self.getRecharge()
            local getRecharge = getRecharge

            self.recharge.lavaLash      = getRecharge(self.spell.lavaLashStacks) or 0
            self.recharge.stormstrike   = getRecharge(self.spell.stormstrikeStacks) or 0 
            self.recharge.windstrike    = getRecharge(self.spell.windstrikeStacks) or 0
        end

        function self.getFrac()
            local getCharges = getCharges
            local getRecharge = getRecharge
            local lavaLashRechargeTime = select(4,GetSpellCharges(self.spell.lavaLashStacks))
            local stormstrikeRechargeTime = select(4,GetSpellCharges(self.spell.stormstrikeStacks))
            local windstrikeRechargeTime = select(4,GetSpellCharges(self.spell.windstrikeStacks))

            self.frac.lavaLash      = (getCharges(self.spell.lavaLashStacks)+((lavaLashRechargeTime-getRecharge(self.spell.lavaLashStacks))/lavaLashRechargeTime)) or 0
            self.frac.stormstrike   = (getCharges(self.spell.stormstrikeStacks)+((stormstrikeRechargeTime-getRecharge(self.spell.stormstrikeStacks))/stormstrikeRechargeTime)) or 0
            self.frac.windstrike    = (getCharges(self.spell.windstrikeStacks)+((windstrikeRechargeTime-getRecharge(self.spell.windstrikeStacks))/windstrikeRechargeTime)) or 0
        end

        ---------------
        --- DEBUFFS ---
        ---------------
        function self.getDebuffs()
            local UnitDebuffID = UnitDebuffID

            self.debuff.stormstrike = UnitDebuffID(self.units.dyn5,self.spell.stormstrikeDebuff,"player")~=nil or false
            self.debuff.windstrike = UnitDebuffID(self.units.dyn5,self.spell.windstrikeDebuff,"player")~=nil or false
        end

        function self.getDebuffsDuration()
            local getDebuffDuration = getDebuffDuration

            self.debuff.duration.stormstrike = getDebuffDuration(self.units.dyn5,self.spell.stormstrikeDebuff,"player") or 0
            self.debuff.duration.windstrike = getDebuffDuration(self.units.dyn5,self.spell.windstrikeDebuff,"player") or 0
        end

        function self.getDebuffsRemain()
            local getDebuffRemain = getDebuffRemain

            self.debuff.remain.stormstrike = getDebuffRemain(self.units.dyn5,self.spell.stormstrikeDebuff,"player") or 0
            self.debuff.remain.windstrike = getDebuffRemain(self.units.dyn5,self.spell.windstrikeDebuff,"player") or 0
        end

        function self.getDebuffsCount()
            local UnitDebuffID = UnitDebuffID
            local stormstrikeCount = 0
            local windstrikeCount = 0

            if stormstrikeCount>0 and not inCombat then stormstrikeCount = 0 end
            if windstrikeCount>0 and not inCombat then windstrikeCount = 0 end

            for i=1,#getEnemies("player",5) do
                local thisUnit = getEnemies("player",5)[i]
                if UnitDebuffID(thisUnit,self.spell.stormstrikeDebuff,"player") then
                    stormstrikeCount = stormstrikeCount+1
                end
                if UnitDebuffID(thisUnit,self.spell.windstrikeDebuff,"player") then
                    windstrikeCount = windstrikeCount+1
                end
            end
            self.debuff.count.stormstrike   = stormstrikeCount or 0
            self.debuff.count.windstrike    = windstrikeCount or 0
        end

        -----------------
        --- COOLDOWNS ---
        -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            self.cd.ascendance      = getSpellCD(self.spell.ascendance)
            self.cd.feralSpirit     = getSpellCD(self.spell.feralSpirit)
            self.cd.fireNova        = getSpellCD(self.spell.fireNova)
            self.cd.lavaLash        = getSpellCD(self.spell.lavaLash)
            self.cd.primalStrike    = getSpellCD(self.spell.primalStrike)
            self.cd.stormstrike     = getSpellCD(self.spell.stormstrike)
            self.cd.unleashElements = getSpellCD(self.spell.unleashElements)
            self.cd.windstrike      = getSpellCD(self.spell.windstrike)
        end

        --------------
        --- TOTEMS ---
        --------------

        function self.getTotems()
            local fire, earth, water, air = 1, 2, 3, 4
            local GetTotemInfo = GetTotemInfo
            local GetSpellInfo = GetSpellInfo

            self.totem.magmaTotem   = (select(2, GetTotemInfo(fire)) == GetSpellInfo(self.spell.magmaTotem))
        end

        function self.getTotemsDuration()

            self.totem.duration.magmaTotem  = 60
        end

        function self.getTotemsRemain()
            local fire, earth, water, air = 1, 2, 3, 4
            local GetTotemTimeLeft = GetTotemTimeLeft

            if (select(2, GetTotemInfo(fire)) == GetSpellInfo(self.spell.magmaTotem)) then
                self.totem.remain.magmaTotem    = GetTotemTimeLeft(fire) or 0
            else
                self.totem.remain.magmaTotem    = 0
            end
        end

        --------------
        --- GLYPHS ---
        --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            self.glyph.fireNova = hasGlyph(self.spell.fireNovaGlyph)
        end

        ---------------
        --- TALENTS ---
        ---------------

        function self.getTalents()
            local getTalent = getTalent

            self.talent.unleashedFury = getTalent(6,1)
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

            -- -- Normal
            self.units.dyn10     = dynamicTarget(10, true)

            -- -- AoE
            self.units.dyn10AoE  = dynamicTarget(10,false)
            self.units.dyn15AoE  = dynamicTarget(15,false)
            self.units.dyn20AoE  = dynamicTarget(20,false)
        end

        ---------------
        --- ENEMIES ---
        ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards10 = #getEnemies("player",10)
            self.enemies.yards20 = #getEnemies("player",20)
            self.enemies.yards30 = #getEnemies("player",30)
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

        -- Ascendance
        function self.castAscendance()
            if self.level>=87 and self.cd.ascendance==0 then
                if castSpell("player",self.spell.ascendance,false,false,false) then return end
            end
        end
        -- Feral Spirit
        function self.castFeralSpirit()
            if self.level>=60 and self.cd.feralSpirit==0 then
                if castSpell("player",self.spell.feralSpirit,false,false,false) then return end
            end
        end
        -- Fire Nova
        function self.castFireNova()
            local fireNovaTarget = fireNovaTarget
            if self.glyph.fireNova then fireNovaTarget = self.units.dyn20AoE else fireNovaTarget = self.units.dyn15AoE end
            if self.level>=44 and self.cd.fireNova==0 and self.powerPercent>13.7 and getDebuffRemain(fireNovaTarget,self.spell.flameShock,"player")>0 then
                if castSpell(fireNovaTarget,self.spell.fireNova,false,false,false) then return end
            end
        end
        -- Lava Lash
        function self.castLavaLash()
            if self.level>=10 and self.cd.lavaLash==0 and getDistance(self.units.dyn5)<5 then
                if castSpell(self.units.dyn5,self.spell.lavaLash,false,false,false) then return end
            end 
        end
        -- Magma Totem
        function self.castMagmaTotem()
            if self.level>=36 and ((not self.totem.magmaTotem) or (self.totem.magmaTotem and (self.talent.liquidMagma and self.cd.liquidMagma<35) and ObjectExists(self.units.dyn10AoE) 
                and getTotemDistance(self.units.dyn10AoE)>=8 and getDistance(self.units.dyn10AoE)<8)) 
                and self.powerPercent>21.1 and not isMoving("player") and ObjectExists(self.units.dyn10AoE) 
            then
                if castSpell("player",self.spell.magmaTotem,false,false,false) then return end
            end
        end
        -- Stormstrike
        function self.castStormstrike(thisUnit)
            if self.level>=26 and self.cd.stormstrike==0 and not self.buff.ascendance and getDistance(thisUnit)<5 then
                if castSpell(thisUnit,self.spell.stormstrike,false,false,false) then return end
            end
            if self.level<26 and self.cd.primalStrike==0 and getDistance(thisUnit)<5 then
               if castSpell(thisUnit,self.spell.primalStrike,false,false,false) then return end
            end 
        end
        -- Unleash Elements
        function self.castUnleashElements()
            if self.level>=81 and self.cd.unleashElements==0 and self.powerPercent>7.5 then
                if castSpell("player",self.spell.unleashElements,false,false,false) then return end
            end
        end
        -- Windstrike
        function self.castWindstrike(thisUnit)
            if self.buff.ascendance and self.cd.windstrike==0 and getDistance(thisUnit)<5 then
                if castSpell(thisUnit,self.spell.stormstrike,false,false,false) then return end
            end
        end

        ------------------------
        --- CUSTOM FUNCTIONS ---
        ------------------------
        function useCDs(spellid)
            if (BadBoy_data['Cooldown'] == 1 and isBoss()) or BadBoy_data['Cooldown'] == 2 then
                return true
            else
                return false
            end
        end
        function useAuto()
            if BadBoy_data['Rotation'] == 1 then
                return true
            else
                return false
            end
        end
        function useAoE()
            if BadBoy_data['Rotation'] == 2 then
               return true
            else
                return false
            end
        end
        function useSingle()
            if BadBoy_data['Rotation'] == 3 then
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
        function useDefensive()
            if BadBoy_data['Defensive'] == 1 then
                return true
            else
                return false
            end
        end
        function shouldBolt()
            local self = enhancementShaman
            local lightning = 0
            local lowestCD = 0
            if useAoE() then
                if self.cd.chainLightning==0 and self.level>=28 then
                    if self.buff.ancestralSwiftness and (select(7,GetSpellInfo(self.spell.chainLightning))/1000)<10 then
                        lightning = 0
                    else
                        lightning = select(7,GetSpellInfo(self.spell.chainLightning))/1000
                    end
                else
                    if self.buff.ancestralSwiftness and select(7,GetSpellInfo(self.spell.lightningBolt)/1000)<10 then
                        lightning = 0
                    else
                        lightning = select(7,GetSpellInfo(self.spell.lightningBolt))/1000
                    end
                end
            else
                if self.buff.ancestralSwiftness and select(7,GetSpellInfo(self.spell.lightningBolt)/1000)<10 then
                    lightning = 0
                else
                    lightning = select(7,GetSpellInfo(self.spell.lightningBolt))/1000
                end
            end
            if self.level < 3 then
                lowestCD = lightning+1
            elseif self.level < 10 then
                lowestCD = min(self.cd.primalStrike)
            elseif self.level < 12 then
                lowestCD = min(self.cd.primalStrike,self.cd.lavaLash)
            elseif self.level < 26 then
                lowestCD = min(self.cd.primalStrike,self.cd.lavaLash,self.cd.flameShock)
            elseif self.level < 81 then
                lowestCD = min(self.cd.stormstrike,self.cd.lavaLash,self.cd.flameShock)
            elseif self.level < 87 then
                lowestCD = min(self.cd.stormstrike,self.cd.lavaLash,self.cd.flameShock,self.cd.unleashElements)
            elseif self.level >= 87 then
                if self.buff.remain.ascendance > 0 then
                    lowestCD = min(self.cd.windstrike,self.cd.lavaLash,self.cd.flameShock,self.cd.unleashElements)
                else
                    lowestCD = min(self.cd.stormstrike,self.cd.lavaLash,self.cd.flameShock,self.cd.unleashElements)
                end
            end
            if (lightning <= lowestCD or lightning <= self.gcd) and getTimeToDie("target") >= lightning then
                return true
            elseif castingUnit("player") and (isCastingSpell(_LightningBolt) or isCastingSpell(_ChainLightning)) and lightning > lowestCD then
                StopCasting()
                return false
            else
                return false
            end
        end

        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()


        -- Return
        return self
    end-- cEnhancement
end-- select Shaman