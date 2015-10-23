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
            self.enemies.yards30 = #getEnemies("player",30)
        end

        ----------------------
        --- START ROTATION ---
        ----------------------

        function self.startRotation()
            if self.rotation == 1 then
                self:EnhancementCuteOne()
            elseif self.rotation == 2 then
                self:EnhancementOld()
            else
                ChatOverlay("No ROTATION ?!", 2000)
            end
        end

        ---------------
        --- OPTIONS ---
        ---------------

        function self.createOptions()
            thisConfig = 0

            -- Title
            CreateNewTitle(thisConfig, "Enhancement")

            -- Create Base and Class options
            self.createClassOptions()

            -- Combat options
            CreateNewWrap(thisConfig, "--- General ---");

                -- Rotation
                CreateNewDrop(thisConfig, "Rotation", 1, "Select Rotation.", "|cff00FF00CuteOne", "|cff00FF00Old");
                CreateNewText(thisConfig, "Rotation");

                -- Dummy DPS Test
                CreateNewCheck(thisConfig,"DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.");
                CreateNewBox(thisConfig,"DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
                CreateNewText(thisConfig,"DPS Testing");

                -- Earthbind/Earthgrab Totem
                if self.talent.earthgrabTotem then
                    CreateNewCheck(thisConfig,"Earthgrab Totem");
                    CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.earthgrabTotem))));
                else
                    CreateNewCheck(thisConfig,"Earthbind Totem");
                    CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.earthbindTotem))));
                end

                -- Ghost Wolf
                CreateNewCheck(thisConfig,"Ghost Wolf");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.ghostWolf))));

                -- Spirit Walk
                CreateNewCheck(thisConfig,"Spirit Walk");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.spiritWalk))));

                -- Tremor Totem
                CreateNewCheck(thisConfig,"Tremor Totem");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.tremorTotem))));

                -- Water Walking
                CreateNewCheck(thisConfig,"Water Walking");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.waterWalking))));

            -- Spacer
            CreateNewText(thisConfig, " ");
            CreateNewWrap(thisConfig, "--- Cooldowns ---");

                -- Agi Pot
                CreateNewCheck(thisConfig,"Agi-Pot");
                CreateNewText(thisConfig,"Agi-Pot");

                -- Legendary Ring
                CreateNewCheck(thisConfig, "Legendary Ring", "Enable or Disable usage of Legendary Ring.");
                -- CreateNewDrop(thisConfig, "Legendary Ring", 2, "CD")
                CreateNewText(thisConfig, "Legendary Ring");

                -- Flask / Crystal
                CreateNewCheck(thisConfig,"Flask / Crystal")
                CreateNewText(thisConfig,"Flask / Crystal")

                -- Trinkets
                CreateNewCheck(thisConfig,"Trinkets")
                CreateNewText(thisConfig,"Trinkets")

                -- Touch of the Void
                CreateNewCheck(thisConfig,"Touch of the Void");
                CreateNewText(thisConfig,"Touch of the Void");

                -- Heroism/Bloodlust
                CreateNewCheck(thisConfig,"HeroLust");
                if self.faction=="Alliance" then
                    CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.heroism))));
                end
                if self.faction=="Horde" then
                    CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.bloodlust))));
                end

                -- Elemental Mastery
                CreateNewCheck(thisConfig,"Elemental Mastery");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.elementalMastery))));

                -- Storm Elemental Totem
                CreateNewCheck(thisConfig,"Storm Elemental Totem");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.stormElementalTotem))));

                -- Fire Elemental Totem
                CreateNewCheck(thisConfig,"Fire Elemental Totem");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.fireElementalTotem))));

                -- Feral Spirit
                CreateNewCheck(thisConfig,"Feral Spirit");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.feralSpirit))));

                -- Liquid Magma
                CreateNewCheck(thisConfig,"Liquid Magma");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.liquidMagma))));

                -- Ancestral Swiftness
                CreateNewCheck(thisConfig,"Ancestral Swiftness");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.ancestralSwiftness))));

                -- Ascendance
                CreateNewCheck(thisConfig,"Ascendance");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.ascendance))));

             -- Spacer
            CreateNewText(thisConfig," ");
            CreateNewWrap(thisConfig,"--- Defensive ---");

                -- Healthstone
                CreateNewCheck(thisConfig,"Healthstone");
                CreateNewBox(thisConfig,"Healthstone", 0, 100, 5, 60, "|cffFFBB00Health Percentage to use at.");
                CreateNewText(thisConfig,"Healthstone");

                -- Heirloom Neck
                CreateNewCheck(thisConfig,"Heirloom Neck");
                CreateNewBox(thisConfig,"Heirloom Neck", 0, 100, 5, 60, "|cffFFBB00Health Percentage to use at.");
                CreateNewText(thisConfig,"Heirloom Neck");

                -- Gift of The Naaru
                if self.race == "Draenei" then
                    CreateNewCheck(thisConfig,"Gift of the Naaru");
                    CreateNewBox(thisConfig,"Gift of the Naaru", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                    CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.getRacial()))));
                end

                -- Ancestral Guidance
                CreateNewCheck(thisConfig,"Ancestral Guidance");
                CreateNewBox(thisConfig,"Ancestral Guidance", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.ancestralGuidance))));

                -- Ancestral Spirit
                CreateNewCheck(thisConfig,"Ancestral Spirit");
                CreateNewDrop(thisConfig,"Ancestral Spirit",1,"|ccfFFFFFFTarget to Cast On","|cffFFFF00Selected Target","|cffFF0000Mouseover Target")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.ancestralSpirit))));

                -- Astral Shift
                CreateNewCheck(thisConfig,"Astral Shift");
                CreateNewBox(thisConfig,"Astral Shift", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.astralShift))));

                -- Capacitor Totem
                CreateNewCheck(thisConfig,"Capacitor Totem - Defensive");
                CreateNewBox(thisConfig,"Capacitor Totem", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.capacitorTotem))).." - Defensive");

                -- Earth Elemental Totem
                CreateNewCheck(thisConfig,"Earth Elemental Totem");
                CreateNewBox(thisConfig,"Earth Elemental Totem", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.earthElementalTotem))));
                
                -- Healing Rain
                CreateNewCheck(thisConfig,"Healing Rain");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.healingRain))));

                -- Healing Stream Totem
                CreateNewCheck(thisConfig,"Healing Stream Totem");
                CreateNewBox(thisConfig,"Healing Stream Totem", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.healingStreamTotem))));

                -- Healing Surge
                CreateNewCheck(thisConfig,"Healing Surge");
                CreateNewBox(thisConfig,"Healing Surge - Level", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.healingSurge))).." - Level");
                CreateNewDrop(thisConfig,"Healing Surge - Target",1,"|cffFFFFFFTarget to cast on","|cff00FF00Player Only","|cffFFFF00Lowest Target","|cffFF0000Mouseover Target")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.healingSurge))).." - Target");

                -- Shamanistic Rage
                CreateNewCheck(thisConfig,"Shamanistic Rage");
                CreateNewBox(thisConfig,"Shamanistic Rage", 0, 100, 5, 50, "|cffFFFFFFHealth Percent to Cast At");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.shamanisticRage))));

                -- Cleanse Spirit
                CreateNewCheck(thisConfig,"Cleanse Spirit");
                CreateNewDrop(thisConfig,"Clease Spirit",1,"|cffFFFFFFTarget to Cast On","|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.cleanseSpirit))));

                -- Purge
                CreateNewCheck(thisConfig,"Purge");
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.purge))));

            -- Spacer --
            CreateNewText(thisConfig," ");
            CreateNewWrap(thisConfig,"--- Interrupts ---");

                -- Capacitor Totem
                CreateNewCheck(thisConfig,"Capacitor Totem - Interrupt")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.capacitorTotem))).." - Interrupt")

                -- Grounding Totem
                CreateNewCheck(thisConfig,"Grounding Totem")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.groundingTotem))))

                -- Wind Shear
                CreateNewCheck(thisConfig,"Wind Shear")
                CreateNewText(thisConfig,tostring(select(1,GetSpellInfo(self.spell.windShear))))
                
                -- Interrupt Percentage
                CreateNewCheck(thisConfig,"InterruptAt");
                CreateNewBox(thisConfig, "InterruptAt", 0, 95, 5, 0, "|cffFFBB00Cast Percentage to use at.");
                CreateNewText(thisConfig,"InterruptAt");

            -- Spacer
            CreateNewText(thisConfig, " ");
            CreateNewWrap(thisConfig, "--- Toggle Keys ---");

                -- Single/Multi Toggle
                CreateNewCheck(thisConfig, "Rotation Mode", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFRotation Mode Toggle Key|cffFFBB00.");
                CreateNewDrop(thisConfig, "Rotation Mode", 4, "Toggle")
                CreateNewText(thisConfig, "Rotation Mode");

                --Cooldown Key Toggle
                CreateNewCheck(thisConfig, "Cooldown Mode", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFCooldown Mode Toggle Key|cffFFBB00.");
                CreateNewDrop(thisConfig, "Cooldown Mode", 3, "Toggle")
                CreateNewText(thisConfig, "Cooldown Mode")

                --Defensive Key Toggle
                CreateNewCheck(thisConfig, "Defensive Mode", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFDefensive Mode Toggle Key|cffFFBB00.");
                CreateNewDrop(thisConfig, "Defensive Mode", 6, "Toggle")
                CreateNewText(thisConfig, "Defensive Mode")

                -- Interrupts Key Toggle
                CreateNewCheck(thisConfig, "Interrupt Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFInterrupt Mode Toggle Key|cffFFBB00.")
                CreateNewDrop(thisConfig, "Interrupt Mode", 6, "Toggle")
                CreateNewText(thisConfig, "Interrupts")

                -- Pause Toggle
                CreateNewCheck(thisConfig, "Pause Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFPause Toggle Key - None Defaults to LeftAlt|cffFFBB00.")
                CreateNewDrop(thisConfig, "Pause Mode", 6, "Toggle")
                CreateNewText(thisConfig, "Pause Mode")

            -- General Configs
            CreateGeneralsConfig();

            WrapsManager();
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
            if self.level>=10 and self.cd.lavaLash==0 and (getDistance(self.units.dyn5)<5 or IsSpellInRange(GetSpellInfo(self.spell.lavaLash),self.units.dyn5)~=nil) then
                if castSpell(self.units.dyn5,self.spell.lavaLash,false,false,false) then return end
            end 
        end
        -- Magma Totem
        function self.castMagmaTotem()
            if self.level>=36 and ((not self.totem.magmaTotem) or (self.totem.magmaTotem and (self.talent.liquidMagma and self.cd.liquidMagma<35) and ObjectExists("target") and getTotemDistance("target")>=8 and getDistance("target")<8)) and self.powerPercent>21.1 and not isMoving("player") and ObjectExists("target") then
                if castSpell("player",self.spell.magmaTotem,false,false,false) then return end
            end
        end
        -- Stormstrike
        function self.castStormstrike(thisUnit)
            local thisUnit = thisUnit or self.units.dyn5
            if self.level>=26 and self.cd.stormstrike==0 and not self.buff.ascendance and (getDistance(self.units.dyn5)<5 or IsSpellInRange(GetSpellInfo(self.spell.stormstrike),self.units.dyn5)~=nil) then
                if castSpell(self.units.dyn5,self.spell.stormstrike,false,false,false) then return end
            end
            if self.level<26 and self.cd.primalStrike==0 and (getDistance(self.units.dyn5)<5 or IsSpellInRange(GetSpellInfo(self.spell.primalStrike),self.units.dyn5)~=nil) then
               if castSpell(self.units.dyn5,self.spell.primalStrike,false,false,false) then return end
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
            local thisUnit = thisUnit or self.units.dyn5
            if self.buff.ascendance and self.cd.windstrike==0 and (getDistance(self.units.dyn5)<5 or IsSpellInRange(GetSpellInfo(self.spell.windstrike),self.units.dyn5)~=nil) then
                if castSpell(self.units.dyn5,self.spell.stormstrike,false,false,false) then return end
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