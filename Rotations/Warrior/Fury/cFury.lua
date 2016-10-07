--- Fury Class
-- Inherit from: ../cCharacter.lua and ../cWarrior.lua
cFury = {}
cFury.rotations = {}

-- Creates Fury Warrior
function cFury:new()
    if GetSpecializationInfo(GetSpecialization()) == 72 then
        local self = cWarrior:new("Fury")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cFury.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------

        self.charges.frac               = {}        -- Fractional Charge
        self.charges.max                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            bladestorm                  = 46924,
            bloodbath                   = 12292,
            bloodthirst                 = 23881,
            commandingShout             = 97462,
            dragonRoar                  = 118000,
            enragedRegeneration         = 184364,
            execute                     = 5308,
            furiousSlash                = 100130,
            heroicLeap                  = 6544,
            intimidatingShout           = 5246,
            odynsFury                   = 205545,
            piercingHowl                = 12323,
            ragingBlow                  = 85288,
            rampage                     = 184367,
            taunt                       = 355,
            whirlwind                   = 190411, 
        }
        self.spell.spec.artifacts       = {
            juggernaut                  = 200875,
            odynsFury                   = 205545,
        }
        self.spell.spec.buffs           = {
            bladestorm                  = 46924,
            bloodbath                   = 12292,
            dragonRoar                  = 118000,
            enrage                      = 184362,
            enragedRegeneration         = 184364,
            frenzy                      = 202539,
            frothingBerserker           = 215572,
            fujiedasFury                = 207775,
            intimidatingShout           = 5246,
            juggernaut                  = 201009,
            massacre                    = 206316,
            meatCleaver                 = 85739,
            stoneHeart                  = 225947,
            tasteForBlood               = 206333,
            wreckingBall                = 215570,
        }
        self.spell.spec.debuffs         = {

        }
        self.spell.spec.debuffs.bleeds  = {

        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            bladestorm                  = 46924,
            bloodbath                   = 12292,
            dragonRoar                  = 118000,
            frenzy                      = 206313,
            frothingBerserker           = 215571,
            innerRage                   = 215573,
            massacre                    = 206315,
            outburst                    = 206320,
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
            self.getPerks() --Removed in Legion
        end

    --------------
    --- UPDATE ---
    --------------

        function self.update()

            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            self.getDynamicUnits()
            self.getEnemies()
            self.getBuffs()
            self.getCharge()
            self.getCooldowns()
            self.getDebuffs()
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
            self.units.dyn8     = dynamicTarget(8, true)
            self.units.dyn15    = dynamicTarget(15, true)

            -- AoE
            self.units.dyn8AoE  = dynamicTarget(8, false)
            self.units.dyn20AoE = dynamicTarget(20, false)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = getEnemies("player", 5) -- Melee
            self.enemies.yards8     = getEnemies("player", 8)
            self.enemies.yards10    = getEnemies("player", 10)
            self.enemies.yards15    = getEnemies("player", 15)
            self.enemies.yards20    = getEnemies("player", 20)
            self.enemies.yards40    = getEnemies("player", 40)
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
                self.charges.frac[k]= getChargesFrac(v)
                self.charges.max[k] = getChargesFrac(v,true)
                self.recharge[k]    = getRecharge(v)
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

    ---------------
    --- DEBUFFS ---
    ---------------
        function self.getDebuffs()
            local UnitDebuffID = UnitDebuffID
            local getDebuffDuration = getDebuffDuration
            local getDebuffRemain = getDebuffRemain

            for k,v in pairs(self.spell.spec.debuffs) do
                if k ~= "bleeds" then
                    self.debuff[k]          = UnitDebuffID(self.units.dyn5,v,"player") ~= nil
                    self.debuff.duration[k] = getDebuffDuration(self.units.dyn5,v,"player") or 0
                    self.debuff.remain[k]   = getDebuffRemain(self.units.dyn5,v,"player") or 0
                    self.debuff.refresh[k]  = (self.debuff.remain[k] < self.debuff.duration[k] * 0.3) or self.debuff.remain[k] == 0
                end
            end
        end        

    --------------
    --- GLYPHS ---
    --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

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

        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes()

            self.mode.rotation  = bb.data["Rotation"]
            self.mode.cooldown  = bb.data["Cooldown"]
            self.mode.defensive = bb.data["Defensive"]
            self.mode.interrupt = bb.data["Interrupt"]
            self.mode.mover     = bb.data["Mover"]
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

            self.cast.debug.bladestorm          = self.cast.bladestorm("player",true)
            self.cast.debug.bloodbath           = self.cast.bloodbath("target",true)
            self.cast.debug.bloodthirst         = self.cast.bloodthirst("target",true)
            self.cast.debug.commandingShout     = self.cast.commandingShout("player",true)
            self.cast.debug.dragonRoar          = self.cast.dragonRoar("player",true)
            self.cast.debug.enragedRegeneration = self.cast.enragedRegeneration("player",true)
            self.cast.debug.execute             = self.cast.execute("target",true)
            self.cast.debug.furiousSlash        = self.cast.furiousSlash("target",true)
            self.cast.debug.intimidatingShout   = self.cast.intimidatingShout("target",true)
            self.cast.debug.odynsFury           = self.cast.odynsFury("player",true)
            self.cast.debug.piercingHowl        = self.cast.piercingHowl("player",true)
            self.cast.debug.ragingBlow          = self.cast.ragingBlow("target",true)
            self.cast.debug.whirlwind           = self.cast.whirlwind("player",true)
        end

        -- Bladestorm
        function self.cast.bladestorm(thisUnit,debug)
            local spellCast = self.spell.bladestorm
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.bladestorm and self.cd.bladestorm == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Bloodbath
        function self.cast.bloodbath(thisUnit,debug)
            local spellCast = self.spell.bloodbath
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.bloodbath and self.cd.bloodbath == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Bloodthirst
        function self.cast.bloodthirst(thisUnit,debug)
            local spellCast = self.spell.bloodthirst
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 10 and self.power > 10 and self.cd.bloodthirst == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Commanding Shout
        function self.cast.commandingShout(thisUnit,debug)
            local spellCast = self.spell.commandingShout
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 83 and self.cd.commandingShout == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Dragon Roar
        function self.cast.dragonRoar(thisUnit,debug)
            local spellCast = self.spell.dragonRoar
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.dragonRoar and self.cd.dragonRoar == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Enraged Regeneration
        function self.cast.enragedRegeneration(thisUnit,debug)
            local spellCast = self.spell.enragedRegeneration
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 12 and self.cd.enragedRegeneration == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Execute
        function self.cast.execute(thisUnit,debug)
            local spellCast = self.spell.execute
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 10 and self.power > 25 and getHP(thisUnit) < 20 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Furious Slash
        function self.cast.furiousSlash(thisUnit,debug)
            local spellCast = self.spell.furiousSlash
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 10 and self.cd.furiousSlash == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Intimidating Shout
        function self.cast.intimidatingShout(thisUnit,debug)
            local spellCast = self.spell.intimidatingShout
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn8 end
            if debug == nil then debug = false end

            if self.level >= 70 and self.cd.intimidatingShout == 0 and getDistance(thisUnit) < 8 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Odyn's Fury
        function self.cast.odynsFury(thisUnit,debug)
            local spellCast = self.spell.odynsFury
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.artifact.odynsFury and self.cd.odynsFury == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Piercing Howl
        function self.cast.piercingHowl(thisUnit,debug)
            local spellCast = self.spell.piercingHowl
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 26 and self.cd.piercingHowl == 0 and self.power > 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Raging Blow
        function self.cast.ragingBlow(thisUnit,debug)
            local spellCast = self.spell.ragingBlow
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 13 and self.cd.ragingBlow == 0 and self.buff.enrage and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Rampage
        function self.cast.rampage(thisUnit,debug)
            local spellCast = self.spell.rampage
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 18 and self.cd.rampage == 0 and self.power > 85 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Whirlwind
        function self.cast.whirlwind(thisUnit,debug)
            local spellCast = self.spell.whirlwind
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 28 and self.cd.whirlwind == 0 then
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
    end-- cFury
end-- select Warrior