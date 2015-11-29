--- Frost Class
-- Inherit from: ../cCharacter.lua and ../cDeathKnight.lua
if select(2, UnitClass("player")) == "DEATHKNIGHT" then

    cFrost = {}

    -- Creates Frost Death Knight
    function cFrost:new()
        local self = cDK:new("Frost")

        local player = "player" -- if someone forgets ""

        -----------------
        --- VARIABLES ---
        -----------------

        self.enemies = {
            yards5,
            yards8,
            yards12,
            yards30,
        }
        self.frostSpell = {
            -- Ability - Offensive
            frostStrike         = 49143,
            howlingBlast        = 49184,
            obliterate          = 49020,
            pillarOfFrost       = 51271,
            soulReaper          = 130735,

            -- Buff - Offensive
            killingMachineBuff  = 51124,
            freezingFogBuff     = 59052,
            pillarOfFrostBuff   = 51271,

            -- Debuff - Offensive

            -- Glyphs

            -- Perks

            -- Items
            strengthFlaskLow    = self.flask.wod.strengthLow,
            strengthFlaskBig    = self.flask.wod.strengthBig,
            strengthFlaskLowBuff= self.flask.wod.buff.strengthLow,
            strengthFlaskBigBuff= self.flask.wod.buff.strengthBig,
            strengthPotBasic    = self.potion.wod.strengthBasic,
            strengthPotGarrison = self.potion.wod.strengthPotGarrison,
            strengthPotBuff     = self.potion.wod.buff.strength,
        }
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.dkSpell, self.frostSpell)

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
            self.getDynamicUnits()
            self.getDebuffs()
            self.getDebuffsDuration()
            self.getDebuffsRemain()
            self.getCooldowns()
            self.getEnemies()
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

            self.buff.killingMachine    = UnitBuffID("player",self.spell.killingMachineBuff)~=nil or false
            self.buff.rime              = UnitBuffID("player",self.spell.freezingFogBuff)~=nil or false
            self.buff.strengthFlaskLow  = UnitBuffID("player",self.spell.strengthFlaskLowBuff)~=nil or false
            self.buff.strengthFlaskBig  = UnitBuffID("player",self.spell.strengthFlaskBigBuff)~=nil or false
            self.buff.strengthPot       = UnitBuffID("player",self.spell.strengthPotBuff)~=nil or false
            self.buff.pillarOfFrost     = UnitBuffID("player",self.spell.pillarOfFrostBuff)~=nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            self.buff.duration.killingMachine       = getBuffDuration("player",self.spell.killingMachineBuff) or 0
            self.buff.duration.rime                 = getBuffDuration("player",self.spell.freezingFogBuff) or 0
            self.buff.duration.strengthFlaskLow     = getBuffDuration("player",self.spell.strengthFlaskLowBuff) or 0
            self.buff.duration.strengthFlaskBig     = getBuffDuration("player",self.spell.strengthFlaskBigBuff) or 0
            self.buff.duration.strengthPot          = getBuffDuration("player",self.spell.strengthPotBuff) or 0
            self.buff.duration.pillarOfFrost        = getBuffDuration("player",self.spell.pillarOfFrostBuff) or 0
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            self.buff.remain.killingMachine     = getBuffRemain("player",self.spell.killingMachineBuff) or 0
            self.buff.remain.rime               = getBuffRemain("player",self.spell.freezingFogBuff) or 0
            self.buff.remain.strengthFlaskLow   = getBuffRemain("player",self.spell.strengthFlaskLowBuff) or 0
            self.buff.remain.strengthFlaskBig   = getBuffRemain("player",self.spell.strengthFlaskBigBuff) or 0
            self.buff.remain.strengthPot        = getBuffRemain("player",self.spell.strengthPotBuff) or 0
            self.buff.remain.pillarOfFrost      = getBuffRemain("player",self.spell.pillarOfFrostBuff) or 0
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

            self.cd.obliterate = getSpellCD(self.spell.obliterate)
            self.cd.pillarOfFrost = getSpellCD(self.spell.pillarOfFrost)
            self.cd.soulReaper = getSpellCD(self.spell.soulReaper)
        end

        --------------
        --- GLYPHS ---
        --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            -- self.glyph.vendetta = hasGlyph(self.spell.vendettaGlyph)
        end

        ---------------
        --- TALENTS ---
        ---------------

        function self.getTalents()
            --local isKnown = isKnown

            --self.talent. = isKnown(self.spell.)
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
            self.units.dyn15 = dynamicTarget(15, true)
            self.units.dyn20 = dynamicTarget(20, true)

            -- AoE
        end

        ---------------
        --- ENEMIES ---
        ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5 = #getEnemies("player", 5)
            self.enemies.yards10 = #getEnemies("player", 10)
            self.enemies.yards12 = #getEnemies("player", 12)
            self.enemies.yards30 = #getEnemies("player", 30)
        end

        ----------------------
        --- START ROTATION ---
        ----------------------

        function self.startRotation()
            if self.rotation == 1 then
                self:FrostCuteOne()
            elseif self.rotation == 2 then
                self:FrostOld()
            else
                ChatOverlay("No ROTATION ?!", 2000)
            end
        end

        ---------------
        --- OPTIONS ---
        ---------------

        -- TODO: change toggles to this one
        function self.createToggles()
            --GarbageButtons()

            if self.rotation == 1 then
            end
        end

        function self.createOptions()
            bb.profile_window = createNewProfileWindow("Frost")
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

            -- Mouseover Targeting
            createNewCheckbox(section,"Mouseover Targeting","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFmouseover target validation.|cffFFBB00.")
            checkSectionState(section)


            --   _____            _     _
            --  / ____|          | |   | |
            -- | |     ___   ___ | | __| | _____      ___ __  ___
            -- | |    / _ \ / _ \| |/ _` |/ _ \ \ /\ / / '_ \/ __|
            -- | |___| (_) | (_) | | (_| | (_) \ V  V /| | | \__ \
            --  \_____\___/ \___/|_|\__,_|\___/ \_/\_/ |_| |_|___/
            section = createNewSection(bb.profile_window,  "Cooldowns")
            -- Legendary Ring
            createNewDropdown(section,  "Legendary Ring", bb.dropOptions.CD,  2, "Enable or Disable usage of Legendary Ring.")

            -- Flask / Crystal
            createNewCheckbox(section,"Flask / Crystal")

            -- Trinkets
            createNewCheckbox(section,"Trinkets")

            -- Empower Rune Weapon
            --if isKnown(_EmpowerRuneWeapon) then
                createNewCheckbox(section,"Empower Rune Weapon")
            --end
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

            -- Blood Presence
            createNewSpinner(section, "Blood Presence",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Death Strike
            createNewSpinner(section, "Death Strike",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Icebound Fortitude
            createNewSpinner(section, "Icebound Fortitude",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Lichbourne
            --if getTalent(2,1) then
            createNewCheckbox(section,"Lichborne")
            --end

            -- Anti-Magic Shell/Zone
            --if getTalent(2,2) then
            createNewSpinner(section, "Anti-Magic Zone",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            --else
            createNewSpinner(section, "Anti-Magic Shell",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            --end

            -- Death Pact
            --if getTalent(5,1) then
            createNewSpinner(section, "Death Pact",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            --end

            -- Death Siphon
            --if getTalent(5,2) then
            createNewSpinner(section, "Death Siphon",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            --end

            -- Conversion
            --if getTalent(5,3) then
            createNewSpinner(section, "Conversion",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            --end

            -- Remorseless Winter
            --if getTalent(6,2) then
            createNewSpinner(section, "Remorseless Winter",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            --end

            -- Desecrated Ground
            --if getTalent(6,3) then
            createNewCheckbox(section,"Desecrated Ground")
            --end
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
            -- Mind Freeze
            createNewCheckbox(section,"Mind Freeze")

            --if isKnown(_Asphyxiate) then
            -- Asphyxiate
            createNewCheckbox(section,"Asphyxiate")
            --else
            -- Strangulate
            createNewCheckbox(section,"Strangulate")
            --end

            -- Dark Simulacrum
            createNewCheckbox(section,"Dark Simulacrum")

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

            -- Cleave Toggle
            createNewDropdown(section,  "Cleave Mode", bb.dropOptions.Toggle,  6)

            -- Pause Toggle
            createNewDropdown(section,  "Pause Mode", bb.dropOptions.Toggle,  6)
            checkSectionState(section)



            --[[ Rotation Dropdown ]]--
            createNewRotationDropdown(bb.profile_window.parent, {"CuteOne", "OLD"})
            bb:checkProfileWindowStatus()
        end

        --------------
        --- SPELLS ---
        --------------
        -- Frost Strike
        function self.castFrostStrike()
            if self.level>=55 and self.power>40 and getDistance(self.units.dyn5)<5 then
                if castSpell(self.units.dyn5,self.spell.frostStrike,false,false,false) then return end
            end
        end
        -- Howling Blast
        function self.castHowlingBlast()
            if self.level>=55 and (self.rune.count.frost>=1 or self.rune.count.death>=1) and (hasThreat(self.units.dyn5) or isDummy()) and getDistance(self.units.dyn5)<30 then
                if useCleave() then
                    if castSpell(self.units.dyn5,self.spell.howlingBlast,false,false,false) then return end
                else
                    if castSpell(self.units.dyn5,self.spell.icyTouch,false,false,false) then return end
                end
            end
        end
        -- Obliterate
        function self.castObliterate()
            if self.level>=58 and ((self.rune.count.frost>=1 and self.rune.count.unholy>=1) or (self.rune.count.frost>=1 and self.rune.count.death>=1) or (self.rune.count.death>=1 and self.rune.count.unholy>=1) or self.rune.count.death>=2) and getDistance(self.units.dyn5)<5 then
                if castSpell(self.units.dyn5,self.spell.obliterate,false,false,false) then return end
            end
        end
        -- Pillar of Frost
        function self.castPillarOfFrost()
            if self.level>=68 and self.cd.pillarOfFrost==0 and (self.rune.count.frost>=1 or self.rune.count.death>=1) and getDistance(self.units.dyn5)<5 then
                if castSpell("player",self.spell.pillarOfFrost,false,false,false) then return end
            end
        end
        -- Soul Reaper
        function self.castSoulReaper()
            if self.level>=87 and self.cd.soulReaper==0 and (self.rune.count.frost>=1 or self.rune.count.death>=1) and getDistance(self.units.dyn5)<5 then
                if castSpell(self.units.dyn5,self.spell.soulReaper,false,false,false) then return end
            end
        end

        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------
        self.createToggles()
        self.createOptions()


        -- Return
        return self
    end-- cFrost
end-- select Death Knight
