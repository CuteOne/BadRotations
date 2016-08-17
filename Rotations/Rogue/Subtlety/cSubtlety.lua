--- Subtlety Class
-- Inherit from: ../cCharacter.lua and ../cRogue.lua
cSubtlety = {}
cSubtlety.rotations = {}

-- Creates Subtlety Rogue
function cSubtlety:new()
    if GetSpecializationInfo(GetSpecialization()) == 261 then
        local self = cRogue:new("Subtlety")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cSubtlety.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
        self.spell.spec             = {}
        self.spell.spec.abilities   = {
            backstab                = 53,
            blind                   = 2094,
            envelopingShadows       = 206237,
            evasion                 = 5277,
            eviscerate              = 196819,
            gloomblade              = 200758,
            kidneyShot              = 408,
            masteryExecutioner      = 76808,
            nightblade              = 195452,
            shadowBlades            = 121471,
            shadowDance             = 185313,
            shadowstep              = 36554,
            shadowstrike            = 185438,
            shurikenStorm           = 197835,
            shurikenToss            = 114014,
            symbolsOfDeath          = 212283,
        }
        self.spell.spec.artifacts   = {
            akaarisSoul             = 209835,
            catlikeReflexes         = 210144,
            demonsKiss              = 197233,
            embraceOfDarkness       = 197604,
            energeticStabbing       = 197239,
            finality                = 197406,
            flickeringShadows       = 197256,
            fortunesBite            = 197369,
            ghostArmor              = 197244,
            goremawsBite            = 209782,
            gutRipper               = 197234,
            legionblade             = 214903,
            precisionStrike         = 197235,
            secondShuriken          = 197610,
            shadowFangs             = 221856,
            shadowNova              = 209781,
            shadowSouls             = 197386,
            theQuietKnife           = 197231,
        }
        self.spell.spec.buffs       = {
            shadowDance             = 185422,
            symbolsOfDeath          = 212283,
        }
        self.spell.spec.debuffs     = {
            nightblade              = 195452,
        }
        self.spell.spec.talents     = {
            envelopingShadows       = 206237,
            gloomblade              = 200758,
            masterOfShadows         = 196976,
            masterOfSubtlety        = 31223,
            nightstalker            = 14062,
            premeditation           = 196979,
            shadowFocus             = 108209,
            soothingDarkness        = 200759,
            subterfuge              = 108208,
            strikeFromTheShadows    = 196951,
            tangledShadow           = 200778,
            weaponmaster            = 193537,
        }
        -- Merge all spell ability tables into self.spell
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.spell.class.abilities, self.spell.spec.abilities)
        
    ------------------
    --- OOC UPDATE ---
    ------------------

        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()
            self.getArtifacts()
            self.getArtifactRanks()
            self.getGlyphs()
            self.getTalents()
            -- self.getPerks() --Removed in Legion
        end

    --------------
    --- UPDATE ---
    --------------

        function self.update()

            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            -- self.subtlety_bleed_table()
            self.getBuffs()
            self.getCharge()
            self.getCooldowns()
            self.getDynamicUnits()
            self.getDebuffs()
            self.getEnemies()
            self.getToggleModes()
            self.getCastable()

            -- Start selected rotation
            self:startRotation()
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn8     = dynamicTarget(8, true) -- Swipe
            self.units.dyn13    = dynamicTarget(15, true) -- Blind

            -- AoE
            self.units.dyn8AoE  = dynamicTarget(8, false) -- Thrash
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = getEnemies("player", 5) -- Melee
            self.enemies.yards8     = getEnemies("player", 8) -- Swipe/Thrash
            self.enemies.yards13    = getEnemies("player", 13) -- Skull Bash
            self.enemies.yards20    = getEnemies("player", 20) --Prowl
            self.enemies.yards40    = getEnemies("player", 40) --Moonfire
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getArtifacts()
            local isKnown = isKnown

            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact[k] = isKnown(v) or false
            end
        end

        function self.getArtifactRanks()

        end
       
    -------------
    --- BUFFS ---
    -------------

        function self.getBuffs()
            local UnitBuffID = UnitBuffID
            local getBuffDuration = getBuffDuration
            local getBuffRemain = getBuffRemain

            for k,v in pairs(self.spell.spec.buffs) do
                self.buff[k]            = UnitBuffID("player",v) ~= nil
                self.buff.duration[k]   = getBuffDuration("player",v) or 0
                self.buff.remain[k]     = getBuffRemain("player",v) or 0
            end
        end

    ---------------
    --- CHARGES ---
    ---------------

        function self.getCharge()
            local getCharges = getCharges
            local getChargesFrac = getChargesFrac
            local getBuffStacks = getBuffStacks
            local getRecharge = getRecharge

            for k,v in pairs(self.spell.spec.abilities) do
                self.charges[k]     = getCharges(v)
                self.recharge[k]    = getRecharge(v)
            end
        end

    ---------------
    --- DEBUFFS ---
    ---------------
        function self.getDebuffs()
            local UnitDebuffID = UnitDebuffID
            local getDebuffDuration = getDebuffDuration
            local getDebuffRemain = getDebuffRemain

            for k,v in pairs(self.spell.spec.debuffs) do
                self.debuff[k]          = UnitDebuffID(self.units.dyn5,v,"player") ~= nil
                self.debuff.duration[k] = getDebuffDuration(self.units.dyn5,v,"player") or 0
                self.debuff.remain[k]   = getDebuffRemain(self.units.dyn5,v,"player") or 0
                self.debuff.refresh[k]  = (self.debuff.remain[k] < self.debuff.duration[k] * 0.3) or self.debuff.remain[k] == 0
            end
        end

        
    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            for k,v in pairs(self.spell.spec.abilities) do
                if getSpellCD(v) ~= nil then
                    self.cd[k] = getSpellCD(v)
                end
            end
        end

    --------------
    --- GLYPHS ---
    --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            -- self.glyph.catForm           = hasGlyph(self.spell.catFormGlyph))
        end

    ---------------
    --- TALENTS ---
    ---------------

        function self.getTalents()
            local getTalent = getTalent

            for r = 1, 7 do --search each talent row
                for c = 1, 3 do -- search each talent column
                    local talentID = select(6,GetTalentInfo(r,c,GetActiveSpecGroup())) -- ID of Talent at current Row and Column
                    for k,v in pairs(self.spell.spec.talents) do
                        if v == talentID then
                            self.talent[k] = getTalent(r,c)
                        end
                    end
                end
            end
        end

    -------------
    --- PERKS ---
    -------------

        function self.getPerks()
            local isKnown = isKnown

            -- self.perk.enhancedBerserk        = isKnown(self.spell.enhancedBerserk)
        end


    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes()

        end

        -- Create the toggle defined within rotation files
        function self.createToggles()
            GarbageButtons()
            if self.rotations[bb.selectedProfile] ~= nil then
                self.rotations[bb.selectedProfile].toggles()
            else
                return
            end
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
            local profileTable = profileTable
            if self.rotations[bb.selectedProfile] ~= nil then 
                profileTable = self.rotations[bb.selectedProfile].options()
            else
                return
            end

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

        function self.getCastable()

            self.cast.debug.backstab          = self.cast.backstab("target",true)
            self.cast.debug.blind             = self.cast.blind("target",true)
            self.cast.debug.evasion           = self.cast.evasion("player",true)
            self.cast.debug.eviscerate        = self.cast.eviscerate("target",true)
            self.cast.debug.kidneyShot        = self.cast.kidneyShot("target",true)
            self.cast.debug.nightblade        = self.cast.nightblade("target",true)
            self.cast.debug.shadowDance       = self.cast.shadowDance("player",true)
            self.cast.debug.shadowstep        = self.cast.shadowstep("target",true)
            self.cast.debug.shadowstrike      = self.cast.shadowstrike("target",true)
            self.cast.debug.shurikenToss      = self.cast.shurikenToss("target",true)
            self.cast.debug.symbolsOfDeath    = self.cast.symbolsOfDeath("player",true)
        end

        function self.cast.backstab(thisUnit,debug)
            local spellCast = self.spell.backstab
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end
            if self.talent.gloomblade then spellCast = self.spell.gloomblade end

            if self.level >= 10 and self.power >= 35 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.blind(thisUnit,debug)
            local spellCast = self.spell.blind
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn15 end
            if debug == nil then debug = false end

            if self.level >= 38 and self.cd.blind == 0 and getDistance(thisUnit) < 15 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.evasion(thisUnit,debug)
            local spellCast = self.spell.evasion
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 8 and self.cd.evasion == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.eviscerate(thisUnit,debug)
            local spellCast = self.spell.eviscerate
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 10 and self.power >= 35 and self.comboPoints > 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.kidneyShot(thisUnit,debug)
            local spellCast = self.spell.kidneyShot
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 40 and self.power > 25 and self.comboPoints > 0 and self.cd.kidneyShot == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.nightblade(thisUnit,debug)
            local spellCast = self.spell.nightblade
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 46 and self.power > 25 and self.comboPoints > 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.shadowDance(thisUnit,debug)
            local spellCast = self.spell.shadowDance
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 36 and self.charges.shadowDance > 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.shadowstep(thisUnit,debug)
            local spellCast = self.spell.shadowstep
            local spellRange = select(6,GetSpellInfo(spellCast))
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.level >= 13 and self.cd.shadowstep == 0 and getDistance(thisUnit) < spellRange and getDistance(thisUnit) >= 8 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.shadowstrike(thisUnit,debug)
            local spellCast = self.spell.shadowstrike
            local spellRange = select(6,GetSpellInfo(spellCast))
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.level >= 22 and self.power > 22 and (self.buff.stealth or self.buff.shadowDance) and getDistance(thisUnit) < spellRange then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.shurikenToss(thisUnit,debug)
            local spellCast = self.spell.shurikenToss
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.level >= 11 and self.power > 40 and getDistance(thisUnit) < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.symbolsOfDeath(thisUnit,debug)
            local spellCast = self.spell.symbolsOfDeath
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 34 and self.power > 35 and self.cd.symbolsOfDeath == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cSubtlety
end-- select Rogue