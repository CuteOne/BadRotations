--- Frost Class
-- Inherit from: ../cCharacter.lua and ../cDeathKnight.lua
if select(2, UnitClass("player")) == "DEATHKNIGHT" then

    cFrost = {}
    cFrost.rotations = {}

    -- Creates Frost Death Knight
    function cFrost:new()
        local self = cDK:new("Frost")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cFrost.rotations

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

        ---------------
        --- TOGGLES ---
        ---------------

        function self.getToggleModes()
            local data   = bb.data

            self.mode.aoe       = data["AoE"]
            self.mode.cooldowns = data["Cooldowns"]
            self.mode.defensive = data["Defensive"]
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
            if self.level>=68 and self.cd.pillarOfFrost==0 and (self.rune.count.frost>=1 or self.rune.count.death>=1 or isKnown(157389)) then
                if castSpell("player",self.spell.pillarOfFrost,false,false,false) then return end
            end
        end
        -- Soul Reaper
        function self.castSoulReaper()
            if self.level>=87 and self.cd.soulReaper==0 and (self.rune.count.frost>=1 or self.rune.count.death>=1) and getDistance(self.units.dyn5)<5 then
                if castSpell(self.units.dyn5,self.spell.soulReaper,false,false,false) then return end
            end
        end

        ------------------------
        --- CUSTOM FUNCTIONS ---
        ------------------------
        function useAoE()
            local enemies = #getEnemies("player",10)
            local oneHand, twoHand  = IsEquippedItemType("One-Hand"), IsEquippedItemType("Two-Hand")
            if (bb.data['Rotation'] == 1 and ((enemies>=3 and oneHand) or (enemies>=4 and twoHand))) or bb.data['Rotation'] == 2 then
                -- if bb.data['AoE'] == 1 or bb.data['AoE'] == 2 then
                return true
            else
                return false
            end
        end

        function useCDs()
            if (bb.data['Cooldown'] == 1 and isBoss()) or bb.data['Cooldowns'] == 2 then
                return true
            else
                return false
            end
        end

        function useDefensive()
            if bb.data['Defensive'] == 1 then
                return true
            else
                return false
            end
        end

        function useInterrupts()
            if bb.data['Interrupt'] == 1 then
                return true
            else
                return false
            end
        end

        function useCleave()
            if bb.data['Cleave']==1 and bb.data['AoE'] ~= 3 then
                return true
            else
                return false
            end
        end

        simList = {
            -- Highmaul
            {spell = 161630, spelltype = "Damage",}, --Bladespire Sorcerer - Molten Bomb
            {spell = 161634, spelltype = "Damage",}, --Bladespire Sorcerer - Molten Bomb
            {spell = 175610, spelltype = "Damage",}, --Night-Twisted Shadowsworn - Chaos Blast
            {spell = 175614, spelltype = "Damage",}, --Night-Twisted Shadowsworn - Chaos Blast
            {spell = 175899, spelltype = "Damage",}, --Gorian Runemaster - Rune of Unmaking
            {spell = 172066, spelltype = "Damage",}, --Oro - Radiating Poison
            -- Auchindoun
            {spell = 176518, spelltype = "Damage",}, --Sargerei Soulpriest - Shadow Word: Pain
            {spell = 154477, spelltype = "Damage",}, --Soulbinder Nyami - Shadow Word: Pain
            {spell = 167092, spelltype = "Damage",}, --Cackling Pyromaniac - Felblast
            {spell = 178837, spelltype = "Damage",}, --Cackling Pyromaniac - Felblast
            {spell = 154221, spelltype = "Damage",}, --Cackling Pyromaniac - Felblast
            {spell = 157053, spelltype = "Damage",}, --Durag the Dominator - Shadow Bolt
            {spell = 156954, spelltype = "Damage",}, --Gul'kosh - Unstable Affliction
            {spell = 157049, spelltype = "Damage",}, --Grom'tash the Destructor - Immolate
            {spell = 156842, spelltype = "Damage",}, --Teron'gor - Corruption
            {spell = 156925, spelltype = "Damage",}, --Teron'gor - Agony
            {spell = 156829, spelltype = "Damage",}, --Teron'gor - Shadow Bolt
            {spell = 156975, spelltype = "Damage",}, --Teron'gor - Chaos Bolt
            {spell = 156964, spelltype = "Damage",}, --Teron'gor - Immolate
            {spell = 156965, spelltype = "Damage",}, --Teron'gor - Doom
            -- Bloodmaul Slag Mines
            {spell = 151558, spelltype = "Damage",}, --Bloodmaul Ogre Mage - Lava Burst
            {spell = 152427, spelltype = "Damage",}, --Magma Lord - Fireball
            {spell = 150290, spelltype = "Damage",}, --Calamity - Scorch
            {spell = 164615, spelltype = "Damage",}, --Bloodmaul Flamespeaker - Channel Flames
            {spell = 164616, spelltype = "Damage",}, --Bloodmaul Flamespeaker - Channel Flames
            {spell = 150677, spelltype = "Damage",}, --Gug'rokk - Molten Blast
            -- Grimrail Depot
            -- Iron Docks
            {spell = 165122, spelltype = "Damage",}, --Ahri'ok Dugru - Blood Bolt
            -- Shadowmoon Burial Grounds
            {spell = 152819, spelltype = "Damage",}, --Shadowmoon Bone-Mender - Shadow Word: Frailty
            {spell = 156776, spelltype = "Damage",}, --Shadowmoon Enslaver - Rending Voidlash
            {spell = 156722, spelltype = "Damage",}, --Shadowmoon Exhumer - Void Bolt
            {spell = 156717, spelltype = "Damage",}, --Monstrous Corpse Spider - Death Venom
            {spell = 153524, spelltype = "Damage",}, --Plagued Bat - Plague Spit
            -- Skyreach
            {spell = 152894, spelltype = "Non-Damage",}, --Adept of the Dawn - Flash Heal
            {spell = 154396, spelltype = "Damage",}, --High Sage Viryx - Solar Burst
            -- The Everbloom
            {spell = 165213, spelltype = "Non-Damage",}, --Everbloom Tender - Enraged Growth
            {spell = 167966, spelltype = "Damage",}, --Earthshaper Telu - Bramble Patch
            {spell = 169843, spelltype = "Damage",}, --Putrid Pyromancer - Dragon's Breath
            {spell = 169844, spelltype = "Damage",}, --Putrid Pyromancer - Dragon's Breath
            -- Upper Blackrock Spire
            {spell = 155588, spelltype = "Damage",}, --Black Iron Dreadweaver - Shadow Bolt Volley
            {spell = 155587, spelltype = "Damage",}, --Black Iron Dreadweaver - Shadow Bolt
            {spell = 155590, spelltype = "Damage",}, --Black Iron Summoner - Fireball
            {spell = 163057, spelltype = "Damage",}, --Black Iron Flame Reaver - Flame Shock
        }

        function isSimSpell()
            local simSpell = self.darkSimulacrum
            for i=1, #bb.enemy do
                if bb.enemy[i].distance<40 then
                    local thisUnit = bb.enemy[i].unit
                    if castingUnit(thisUnit) then
                        for f=1, #simList do
                            local simListSpell = simList[f].spell
                            if isCastingSpell(simListSpell,thisUnit) then
                              simSpell = simListSpell
                              simUnit = thisUnit
                              break
                            else
                              simSpell = self.darkSimulacrum
                              simUnit = "target"
                            end
                        end
                    end
                end
            end
            if simSpell~=self.darkSimulacrum then
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
    end-- cFrost
end-- select Death Knight
