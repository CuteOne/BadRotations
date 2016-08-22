--- Havoc Class
-- Inherit from: ../cCharacter.lua and ../cDemonHunter.lua
cHavoc = {}
cHavoc.rotations = {}

-- Creates Havoc DemonHunter
function cHavoc:new()
    if GetSpecializationInfo(GetSpecialization()) == 577 then
		local self = cDemonHunter:new("Havoc")

		local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cHavoc.rotations
		
    -----------------
    --- VARIABLES ---
    -----------------

        self.charges.frac               = {}        -- Fractional Charge
        self.charges.max                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            chaosBlades                 = 211048,
            felBarrage                  = 211053,
            netherwalk                  = 196555,
            nemesis                     = 206491,
        }
        self.spell.spec.artifacts       = {
            anguishOfTheDeceiver        = 201473,
        }
        self.spell.spec.buffs           = {
            chaosBlades                 = 211797,
            momentum                    = 206476,
            prepared                    = 203650,
        }
        self.spell.spec.debuffs         = {
            nemesis                     = 206491,
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            blindFury                   = 203550,
            bloodlet                    = 206473,
            chaosBlades                 = 211048,
            chaosCleave                 = 206475,
            demonBlades                 = 203555,
            demonReborn                 = 193897,
            demonic                     = 213410,
            demonicAppetite             = 206478,
            desperateInstincts          = 205411,
            felBarrage                  = 211053,
            felMastery                  = 192939,
            firstBlood                  = 206416,
            mastersOfTheGlaive          = 203556,
            momentum                    = 206476,
            nemesis                     = 206491,
            netherwalk                  = 196555,
            prepared                    = 203551,
            soulRending                 = 204909,
            unleashedPower              = 206477,
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

        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

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

            -- self.cast.debug.ashamanesFrenzy             = self.cast.ashamanesFrenzy("target",true)
        end

        -- Ashamane's Frenzy
        -- function self.cast.ashamanesFrenzy(thisUnit,debug)
        --     local spellCast = self.spell.ashamanesFrenzy
        --     local thisUnit = thisUnit
        --     if thisUnit == nil then thisUnit = self.units.dyn5 end
        --     if debug == nil then debug = false end

        --     if self.artifact.ashamanesFrenzy and self.buff.catForm and self.cd.ashamanesFrenzy == 0 and getDistance(thisUnit) < 5 then
        --         if debug then
        --             return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
        --         else
        --             if castSpell(thisUnit,spellCast,false,false,false) then return end
        --         end
        --     elseif debug then
        --         return false
        --     end
        -- end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------
        --Target HP
        function thp(unit)
            return getHP(unit)
        end

        --Target Time to Die
        function ttd(unit)
            return getTimeToDie(unit)
        end

        --Target Distance
        function tarDist(unit)
            return getDistance(unit)
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------
        function worthUsing()
            local demons_bite_per_dance = 35 / 25
            local demons_bite_per_chaos_strike = ( 40 - 20 * (GetCritChance("player")/100) ) / 25
            local mhDamage = ((select(2,UnitDamage("player"))+select(1,UnitDamage("player"))) / 2)
            local ohDamage = ((select(4,UnitDamage("player"))+select(3,UnitDamage("player"))) / 2)
            local totDamage = (mhDamage + UnitAttackPower("player") / 3.5 * 2.4) + (ohDamage + UnitAttackPower("player") / 3.5 * 2.4) 
            local demons_bite_damage = 2.6 * totDamage
            local blade_dance_damage = ((1 * totDamage) + (2 * (0.96 * totDamage)) + (2.88 * totDamage))
            local chaos_strike_damage = 2.75 * totDamage
            if ( blade_dance_damage + demons_bite_per_dance * demons_bite_damage ) / ( 1 + demons_bite_per_dance ) > ( chaos_strike_damage + demons_bite_per_chaos_strike * demons_bite_damage ) / ( 1 + demons_bite_per_chaos_strike ) then
                return true
            else
                return false
            end
        end

        -- Return
        return self
    end-- cHavoc
end-- select Demonhunter