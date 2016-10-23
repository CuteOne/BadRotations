--- Windwalker Class
-- Inherit from: ../cCharacter.lua and ../cMonk.lua
cWindwalker = {}
cWindwalker.rotations = {}

-- Creates Windwalker Monk
function cWindwalker:new()
    if GetSpecializationInfo(GetSpecialization()) == 269 then
        local self = cMonk:new("Windwalker")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cWindwalker.rotations

    -----------------
    --- VARIABLES ---
    -----------------
        self.spell.spec             = {}
        self.spell.spec.abilities   = {
            chiWave                         = 115098,
            detox                           = 218164,
            disable                         = 116095,
            energizingElixir                = 115288,
            fistsOfFury                     = 113656,
            flyingSerpentKick               = 101545,
            flyingSerpentKickEnd            = 115057,
            healingElixir                   = 122281,
            invokeXuen                      = 123904,
            risingSunKick                   = 107428,
            rushingJadeWind                 = 116847,
            serenity                        = 152173,
            spearHandStrike                 = 116705,
            spinningCraneKick               = 101546,
            stormEarthAndFire               = 137639,
            stormEarthAndFireFixate         = 221771,
            strikeOfTheWindlord             = 205320,
            touchOfDeath                    = 115080,
            touchOfKarma                    = 122470,
            whirlingDragonPunch             = 152175,
        }
        self.spell.spec.artifacts   = {
            crosswinds                      = 195650,
            darkSkies                       = 195265,
            deathArt                        = 195266,
            fistsOfTheWind                  = 195291,
            galeBurst                       = 195399,
            goodKarma                       = 195295,
            healingWinds                    = 195380,
            innerPeace                      = 195243,
            lightOnYourFeet                 = 195244,
            powerOfAThousandCranes          = 195269,
            risingWinds                     = 195263,
            spiritualFocus                  = 195298,
            strengthOfXuen                  = 195267,
            strikeOfTheWindlord             = 205320,
            tigerClaws                      = 218607,
            tornadoKicks                    = 196082,
            transferOfPower                 = 195300,
            windborneBlows                  = 214922,
        }
        self.spell.spec.buffs       = {
            serenity                        = 152173,
            stormEarthAndFire               = 137639,
            touchOfKarma                    = 122470,
            hitCombo                        = 196741,
        }
        self.spell.spec.debuffs     = {
            markOfTheCrane                  = 228287,
            touchOfDeath                    = 115080,
        }
        self.spell.spec.glyphs      = {
            glyphOfRisingTigerKick          = 125151,
        }
        self.spell.spec.talents     = {
            ascension                       = 115396,
            chiOrbit                        = 196743,
            chiWave                         = 115098,
            dizzyingKicks                   = 196722,
            energizingElixir                = 115288,
            eyeOfTheTiger                   = 196607,
            healingElixir                   = 122281,
            hitCombo                        = 196740,
            invokeXuen                      = 123904,
            powerStrikes                    = 121817,
            rushingJadeWind                 = 116847,
            serenity                        = 152173,
            whirlingDragonPunch             = 152175,
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
            self.getCharges()
            self.getDynamicUnits()
            self.getDebuffs()
            self.getCooldowns()
            self.getEnemies()
            self.getCastable()
            self.getToggleModes()
            self.getRotation()

            -- Start selected rotation
            self:startRotation()
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getArtifacts()
            local hasPerk = hasPerk

            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact[k] = hasPerk(v) or false
            end
        end

        function self.getArtifactRanks()
            local getPerkRank = getPerkRank

            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact.rank[k] = getPerkRank(v) or 0
            end
        end

    -------------
    --- BUFFS ---
    -------------

        function self.getBuffs()
            local UnitBuffID = UnitBuffID
            local getBuffDuration = getBuffDuration
            local getBuffRemain = getBuffRemain
            local getBuffStacks = getBuffStacks

            for k,v in pairs(self.spell.spec.buffs) do
                self.buff[k]            = UnitBuffID("player",v) ~= nil
                self.buff.duration[k]   = getBuffDuration("player",v) or 0
                self.buff.remain[k]     = getBuffRemain("player",v) or 0
                self.buff.stacks[k]     = getBuffStacks("player",v) or 0
            end
        end

    ---------------
    --- CHARGES ---
    ---------------

        function self.getCharges()

            for k,v in pairs(self.spell.spec.abilities) do
                self.charges[k] = getCharges(v) or 0
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

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn8     = dynamicTarget(8, true)
            self.units.dyn15    = dynamicTarget(15, true)
            self.units.dyn20    = dynamicTarget(20, true)

            -- AoE
            self.units.dyn8AoE  = dynamicTarget(8,false)
            self.units.dyn20AoE = dynamicTarget(20,false)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = getEnemies("player", 5)
            self.enemies.yards8     = getEnemies("player", 8)
            self.enemies.yards12    = getEnemies("player", 12)
            self.enemies.yards40    = getEnemies("player", 40)
        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes()

            self.mode.sef       = bb.data["SEF"]
            self.mode.fsk       = bb.data["FSK"]
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

        function self.getCastable()
            self.cast.debug.chiWave                 = self.cast.chiWave("player",true)
            self.cast.debug.detox                   = self.cast.detox("player",true)
            self.cast.debug.disable                 = self.cast.disable("target",true)
            self.cast.debug.energizingElixir        = self.cast.energizingElixir("player",true)
            self.cast.debug.fistsOfFury             = self.cast.fistsOfFury("target",true)
            self.cast.debug.flyingSerpentKick       = self.cast.flyingSerpentKick("target",true)            
            self.cast.debug.flyingSerpentKickEnd    = self.cast.flyingSerpentKickEnd("target",true)            
            self.cast.debug.healingElixir           = self.cast.healingElixir("player",true)
            self.cast.debug.invokeXuen              = self.cast.invokeXuen("target",true)
            self.cast.debug.risingSunKick           = self.cast.risingSunKick("target",true)
            self.cast.debug.rushingJadeWind         = self.cast.rushingJadeWind("player",true)
            self.cast.debug.serenity                = self.cast.serenity("player",true)
            self.cast.debug.spearHandStrike         = self.cast.spearHandStrike("target",true)
            self.cast.debug.spinningCraneKick       = self.cast.spinningCraneKick("player",true)
            self.cast.debug.stormEarthAndFire       = self.cast.stormEarthAndFire("player",true)
            self.cast.debug.stormEarthAndFireFixate = self.cast.stormEarthAndFireFixate("target",true)
            self.cast.debug.strikeOfTheWindlord     = self.cast.strikeOfTheWindlord("target",true)
            self.cast.debug.touchOfDeath            = self.cast.touchOfDeath("target",true)
            self.cast.debug.touchOfKarma            = self.cast.touchOfKarma("target",true)
            self.cast.debug.whirlingDragonPunch     = self.cast.whirlingDragonPunch("target",true)
        end

        -- Chi Wave
        function self.cast.chiWave(thisUnit,debug)
            local spellCast = self.spell.chiWave
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.chiWave and self.cd.chiWave == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Detox
        function self.cast.detox(thisUnit,debug)
            local spellCast = self.spell.detox
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 22 and self.cd.detox == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Disable
        function self.cast.disable(thisUnit,debug)
            local spellCast = self.spell.disable
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 25 and self.cd.disable == 0 and self.power > 15 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Energizing Elixer
        function self.cast.energizingElixir(thisUnit,debug)
            local spellCast = self.spell.energizingElixir
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.energizingElixir and self.cd.energizingElixir == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Fists of Fury
        function self.cast.fistsOfFury(thisUnit,debug)
            local spellCast = self.spell.fistsOfFury
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 28 and self.cd.fistsOfFury == 0 and self.chi.count >= 3 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Flying Serpent Kick
        function self.cast.flyingSerpentKick(thisUnit,debug)
            local spellCast = self.spell.flyingSerpentKick
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.level >= 10 and self.cd.flyingSerpentKick == 0 and (self.instance == "none" or hasThreat(thisUnit)) 
                and getFacingDistance() < 5 and getFacingDistance() > 0 
                and getDistance(thisUnit) >= 5 and getDistance(thisUnit) < 60 
            then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.flyingSerpentKickEnd(thisUnit,debug)
            local spellCast = self.spell.flyingSerpentKickEnd
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.level >= 10 and self.cd.flyingSerpentKickEnd == 0 and (getDistance(thisUnit) < 5 or getFacingDistance() ~= abs(getFacingDistance())) 
                and select(3,GetSpellInfo(101545)) == 463281 
            then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Healing Elixirs
        function self.cast.healingElixir(thisUnit,debug)
            local spellCast = self.spell.healingElixir
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.healingElixir and self.charges.healingElixir > 0 and self.cd.healingElixir then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Invoke Xuen
        function self.cast.invokeXuen(thisUnit,debug)
            local spellCast = self.spell.invokeXuen
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40AoE end
            if debug == nil then debug = false end

            if self.talent.invokeXuen and self.cd.invokeXuen == 0 and getDistance(self.units.dyn40AoE) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Rising Sun Kick
        function self.cast.risingSunKick(thisUnit,debug)
            local spellCast = self.spell.risingSunKick
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 18 and self.cd.risingSunKick == 0 and self.chi.count >= 2 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Rushing Jade Wind
        function self.cast.rushingJadeWind(thisUnit,debug)
            local spellCast = self.spell.rushingJadeWind
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.rushingJadeWind and self.cd.rushingJadeWind == 0 and self.chi.count >= 1 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Serenity
        function self.cast.serenity(thisUnit,debug)
            local spellCast = self.spell.serenity
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.serenity and self.cd.serenity == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Spear Hand Strike
        function self.cast.spearHandStrike(thisUnit,debug)
            local spellCast = self.spell.spearHandStrike
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 32 and self.cd.spearHandStrike == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Spinning Crane Kick
        function self.cast.spinningCraneKick(thisUnit,debug)
            local spellCast = self.spell.spinningCraneKick
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 40 and self.cd.spinningCraneKick == 0 and self.chi.count >= 3 and getDistance(thisUnit) < 8 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Storm Earth and Fire
        function self.cast.stormEarthAndFire(thisUnit,debug)
            local spellCast = self.spell.stormEarthAndFire
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 65 and self.cd.stormEarthAndFire == 0 and self.charges.stormEarthAndFire > 0 and not self.buff.stormEarthAndFire then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.stormEarthAndFireFixate(thisUnit,debug)
            local spellCast = self.spell.stormEarthAndFireFixate
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 65 and self.cd.stormEarthAndFireFixate == 0 and self.buff.stormEarthAndFire then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Strike of the Windlord
        function self.cast.strikeOfTheWindlord(thisUnit,debug)
            local spellCast = self.spell.strikeOfTheWindlord
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn8 end
            if debug == nil then debug = false end

            if self.artifact.strikeOfTheWindlord and self.cd.strikeOfTheWindlord == 0 and self.chi.count >= 2 and getDistance(thisUnit) < 8 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Touch of Death
        function self.cast.touchOfDeath(thisUnit,debug)
            local spellCast = self.spell.touchOfDeath
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 24 and self.cd.touchOfDeath == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Touch of Karma
        function self.cast.touchOfKarma(thisUnit,debug)
            local spellCast = self.spell.touchOfKarma
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn20AoE end
            if debug == nil then debug = false end

            if self.level >= 22 and self.cd.touchOfKarma == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Whirling Dragon Punch
        function self.cast.whirlingDragonPunch(thisUnit,debug)
            local spellCast = self.spell.whirlingDragonPunch
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn8AoE end
            if debug == nil then debug = false end

            if self.talent.whirlingDragonPunch and self.cd.whirlingDragonPunch == 0 and self.cd.fistsOfFury ~= 0 and self.cd.risingSunKick ~= 0 and getDistance(thisUnit) < 8 then
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
       function canToD()
            local thisUnit = dynamicTarget(5,true)
            if (getHP(thisUnit)<=10 or UnitHealth(thisUnit)<=UnitHealthMax("player")) and not UnitIsPlayer(thisUnit) then
                return true
            else
                return false
            end
        end

        function canEnhanceToD()
            local thisUnit = dynamicTarget(5,true)
            local boostedHP = UnitHealthMax("player")+(UnitHealthMax("player")*0.2)
            if (getHP(thisUnit)<=10 or (UnitHealth(thisUnit)<=boostedHP)) and UnitHealth(thisUnit) > UnitHealthMax("player") and not UnitIsPlayer(thisUnit) then
                return true
            else
                return false
            end
        end    

        function useSEF()
            if self.mode.sef == 1 then
                return true
            else
                return false
            end
        end

        function useFSK()
            if self.mode.fsk == 1 then
                return true
            else
                return false
            end
        end

        function getFacingDistance()
            if UnitIsVisible("player") and UnitIsVisible("target") then
                --local targetDistance = getRealDistance("target")
                local targetDistance = getDistance("target")
                local Y1,X1,Z1 = GetObjectPosition("player");
                local Y2,X2,Z2 = GetObjectPosition("target");
                local Angle1 = GetObjectFacing("player")
                local deltaY = Y2 - Y1
                local deltaX = X2 - X1
                Angle1 = math.deg(math.abs(Angle1-math.pi*2))
                if deltaX > 0 then
                    Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2)+math.pi)
                elseif deltaX <0 then
                    Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2))
                end
                local Dist = round2(math.tan(math.abs(Angle2 - Angle1)*math.pi/180)*targetDistance*10000)/10000
                if ObjectIsFacing("player","target") then
                    return Dist
                else
                    return -(math.abs(Dist))
                end
            else
                return 1000
            end
        end

        function usingFSK()
            if select(3,GetSpellInfo(101545)) == 463281 then
                return true
            else
                return false
            end
        end

        -- function canFSK()
        --     --local targetDistance = getRealDistance("player","target")
        --     local targetDistane = getDistance("target")
        --     stopFSK = false
        --     if not inCombat and not UnitIsDeadOrGhost("target") and getTimeToDie("target") > 10 and not IsSwimming() and getTTD("target") and targetDistance < 60 then
        --         if (solo or hasThreat("target")) and self.cd.flyingSerpentKick == 0 and getFacingDistance() < 5 and getFacingDistance()>0 then
        --             if targetDistance < 8 then
        --                 stopFSK = true
        --                 return true
        --             elseif targetDistance >= 8 then
        --                 return true
        --             else
        --                 return false
        --             end
        --         end
        --     end
        -- end


        --     if ((targetDistance < 5 and isInCombat("player")) or (targetDistance < 60 and targetDistance > 5)) 
        --         and ((getSpellCD(_FlyingSerpentKick)==0 and not usingFSK()) 
        --             or usingFSK())
        --         and (getFacingDistance() < 5 and getFacingDistance()>0)
        --         and not UnitIsDeadOrGhost(unit)
        --         and getTimeToDie(unit) > 10
        --         and not IsSwimming()
        --     then
        --         return true
        --     else
        --         return false
        --     end
        -- end

        function getOption(spellID)
            return tostring(select(1,GetSpellInfo(spellID)))
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- self.createOptions()
        -- Return
        return self
    end-- cWindwalker
end-- select Monk