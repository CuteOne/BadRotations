--- Enhancement Class
-- Inherit from: ../cCharacter.lua and ../cShaman.lua
if select(2, UnitClass("player")) == "SHAMAN" then

    cEnhancement = {}

    -- Creates Enhancement Shaman
    function cEnhancement:new()
        local self = cShaman:new("Enhancement")

        local player = "player" -- if someone forgets ""

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

        ---------------------
        --- Totem Updates ---
        ---------------------
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
                self:EnhancementCuteOne()
                --elseif self.rotation == 2 then
                --    self:EnhancementOld()
            else
                ChatOverlay("No ROTATION ?!", 2000)
            end
        end

        ---------------
        --- OPTIONS ---
        ---------------

        function self.createOptions()
            bb.ui.window.profile = bb.ui:createProfileWindow("Enhancement")
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

            -- Earthbind/Earthgrab Totem
            if self.talent.earthgrabTotem then
                bb.ui:createCheckbox(section,"Earthgrab Totem")
            else
                bb.ui:createCheckbox(section,"Earthbind Totem")
            end

            -- Ghost Wolf
            bb.ui:createCheckbox(section,"Ghost Wolf")

            -- Spirit Walk
            bb.ui:createCheckbox(section,"Spirit Walk")

            -- Tremor Totem
            bb.ui:createCheckbox(section,"Tremor Totem")

            -- Water Walking
            bb.ui:createCheckbox(section,"Water Walking")

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
            bb.ui:createCheckbox(section,"Agi-Pot")

            -- Legendary Ring
            bb.ui:createCheckbox(section, "Legendary Ring", "Enable or Disable usage of Legendary Ring.")
            -- bb.ui:createDropdown(section,  "Legendary Ring", { "CD"},  2)

            -- Flask / Crystal
            bb.ui:createCheckbox(section,"Flask / Crystal")

            -- Trinkets
            bb.ui:createCheckbox(section,"Trinkets")

            -- Touch of the Void
            bb.ui:createCheckbox(section,"Touch of the Void")

            -- Heroism/Bloodlust
            bb.ui:createCheckbox(section,"HeroLust")
            if self.faction=="Alliance" then
                
            end
            if self.faction=="Horde" then
                
            end

            -- Elemental Mastery
            bb.ui:createCheckbox(section,"Elemental Mastery")

            -- Storm Elemental Totem
            bb.ui:createCheckbox(section,"Storm Elemental Totem")

            -- Fire Elemental Totem
            bb.ui:createCheckbox(section,"Fire Elemental Totem")

            -- Feral Spirit
            bb.ui:createCheckbox(section,"Feral Spirit")

            -- Liquid Magma
            bb.ui:createCheckbox(section,"Liquid Magma")

            -- Ancestral Swiftness
            bb.ui:createCheckbox(section,"Ancestral Swiftness")

            -- Ascendance
            bb.ui:createCheckbox(section,"Ascendance")
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

            -- Ancestral Guidance
            bb.ui:createSpinner(section, "Ancestral Guidance",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Ancestral Spirit
            bb.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")

            -- Astral Shift
            bb.ui:createSpinner(section, "Astral Shift",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Capacitor Totem
            bb.ui:createSpinner(section, "Capacitor Totem - Defensive",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            
            -- Earth Elemental Totem
            bb.ui:createSpinner(section, "Earth Elemental Totem",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            
            -- Healing Rain
            bb.ui:createSpinner(section, "Healing Rain",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            bb.ui:createSpinner(section, "Healing Rain Targets",  3,  1,  10,  1,  "|cffFFFFFFNumber of targets to consider before casting")
            
            -- Healing Stream Totem
            bb.ui:createSpinner(section, "Healing Stream Totem",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            
            -- Healing Surge
            bb.ui:createCheckbox(section,"Healing Surge")
            bb.ui:createSpinner(section, "Healing Surge - Level",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            bb.ui:createDropdown(section, "Healing Surge - Target", {"|cff00FF00Player Only","|cffFFFF00Lowest Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            
            -- Shamanistic Rage
            bb.ui:createSpinner(section, "Shamanistic Rage",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            
            -- Cleanse Spirit
            bb.ui:createDropdown(section, "Clease Spirit", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            
            -- Purge
            bb.ui:createCheckbox(section,"Purge")
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
            -- Capacitor Totem
            bb.ui:createCheckbox(section,"Capacitor Totem - Interrupt")
            
            -- Grounding Totem
            bb.ui:createCheckbox(section,"Grounding Totem")
            
            -- Wind Shear
            bb.ui:createCheckbox(section,"Wind Shear")
            
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

        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()


        -- Return
        return self
    end-- cEnhancement
end-- select Shaman