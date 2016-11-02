--- Feral Class
-- Inherit from: ../cCharacter.lua and ../cDruid.lua
cFeral = {}
cFeral.rotations = {}

-- Creates Feral Druid
function cFeral:new()
    if GetSpecializationInfo(GetSpecialization()) == 103 then
		local self = cDruid:new("Feral")

		local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cFeral.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------

        self.bleed                      = {}        -- Bleed/Moonfire Tracking
        self.bleed.combatLog            = {} 
        self.charges.frac               = {}        -- Fractional Charge
        self.charges.max                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            ashamanesFrenzy             = 210722,
            berserk                     = 106951,
            brutalSlash                 = 202028,
            elunesGuidance              = 202060,
            ferociousBite               = 22568,
            incarnationKingOfTheJungle  = 102543,
            maim                        = 22570,
            moonfireFeral               = 155625,
            rake                        = 1822,
            removeCorruption            = 2782,
            renewal                     = 108238,
            rip                         = 1079,
            savageRoar                  = 52610,
            shred                       = 5221,
            skullBash                   = 106839,
            stampedingRoar              = 106898,
            survivalInstincts           = 61336,
            swipe                       = 213764,
            thrash                      = 106832,
            tigersFury                  = 5217,
        }
        self.spell.spec.artifacts       = {
            ashamanesBite               = 210702,
            ashamanesEnergy             = 210579,
            ashamanesFrenzy             = 210722,
            attunedToNature             = 210590,
            fangsOfTheFirst             = 214911,
            feralInstinct               = 210631,
            feralPower                  = 210571,
            hardenedRoots               = 210638,
            honedInstinct               = 210557,
            openWounds                  = 210666,
            powerfulBite                = 210575,
            protectionOfAshamane        = 210650,
            razorFangs                  = 210570,
            scentOfBlood                = 210663,
            shadowThrash                = 210676,
            sharpenedClaws              = 210637,
            shredderFangs               = 214736,
            tearTheFlesh                = 210593,
        }
        self.spell.spec.buffs           = {
            berserk                     = 106951,
            bloodtalons                 = 145152,
            clearcasting                = 135700,
            incarnationKingOfTheJungle  = 102543,
            predatorySwiftness          = 69369,
            savageRoar                  = 52610,
            stampedingRoar              = 77764,
            survivalInstincts           = 61336,
            tigersFury                  = 5217,
        }
        self.spell.spec.debuffs         = {
            ashamanesFrenzy             = 210723,
            ashamanes                   = 210705,
            moonfireFeral               = 155625,
            rake                        = 155722,
            rip                         = 1079,
            thrash                      = 106830,
        }
        self.spell.spec.debuffs.bleeds  = {
            moonfireFeral               = 155625,
            rake                        = 155722,
            rip                         = 1079,
            thrash                      = 106832,
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            balanceAffinity             = 197488,
            bloodScent                  = 202022,
            bloodtalons                 = 155672,
            brutalSlash                 = 202028,
            elunesGuidance              = 202060,
            guardianAffinity            = 217615,
            incarnationKingOfTheJungle  = 102543,
            jaggedWounds                = 202032,
            lunarInspiration            = 155580,
            momentOfClarity             = 155577,
            predator                    = 202021,
            renewal                     = 108238,
            restorationAffinity         = 197492,
            sabertooth                  = 202031,
            savageRoar                  = 52610,
            soulOfTheForest             = 158476,
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
            self.getBleedUnits()
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
            if self.talent.balanceAffinity then
                -- Normal
                self.units.dyn8     = dynamicTarget(13, true) -- Swipe
                self.units.dyn13    = dynamicTarget(18, true) -- Skull Bash

                -- AoE
                self.units.dyn8AoE  = dynamicTarget(13, false) -- Thrash
                self.units.dyn20AoE = dynamicTarget(25, false) --Prowl
            else
                -- Normal
                self.units.dyn8     = dynamicTarget(8, true) -- Swipe
                self.units.dyn13    = dynamicTarget(13, true) -- Skull Bash

                -- AoE
                self.units.dyn8AoE  = dynamicTarget(8, false) -- Thrash
                self.units.dyn20AoE = dynamicTarget(20, false) --Prowl
            end
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies
            if self.talent.balanceAffinity then
                self.enemies.yards5     = getEnemies("player", 10) -- Melee
                self.enemies.yards8     = getEnemies("player", 13) -- Swipe/Thrash
                self.enemies.yards13    = getEnemies("player", 18) -- Skull Bash
                self.enemies.yards20    = getEnemies("player", 25) --Prowl
                self.enemies.yards40    = getEnemies("player", 45) --Moonfire
            else
                self.enemies.yards5     = getEnemies("player", 5) -- Melee
                self.enemies.yards8     = getEnemies("player", 8) -- Swipe/Thrash
                self.enemies.yards13    = getEnemies("player", 13) -- Skull Bash
                self.enemies.yards20    = getEnemies("player", 20) --Prowl
                self.enemies.yards40    = getEnemies("player", 40) --Moonfire
            end
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

    --------------
    --- BLEEDS ---
    --------------
        function self.getSnapshotValue(dot)
            if dot ~= self.spell.spec.debuffs.rip and dot ~= self.spell.spec.debuffs.rake then return 0 end
            local multiplier        = 1.00
            local Bloodtalons       = 1.30
            local SavageRoar        = 1.40
            local TigersFury        = 1.15
            local RakeMultiplier    = 1
            local Incarnation       = 2
            local Prowl             = 2

            -- Bloodtalons
            if UnitBuffID("player",self.spell.spec.buffs.bloodtalons) then multiplier = multiplier*Bloodtalons end
            -- Savage Roar
            if UnitBuffID("player",self.spell.spec.buffs.savageRoar) then multiplier = multiplier*SavageRoar end
            -- Tigers Fury
            if UnitBuffID("player",self.spell.spec.buffs.tigersFury) then multiplier = multiplier*TigersFury end

            -- rip
            if dot == self.spell.spec.debuffs.rip then
                -- -- Versatility
                -- multiplier = multiplier*(1+Versatility*0.1)

                -- return rip
                return 5*multiplier
            end
            -- rake
            if dot == self.spell.spec.debuffs.rake then
                -- Incarnation
                if UnitBuffID("player",102543) then
                    RakeMultiplier = Incarnation
                end
                -- Prowl
                if UnitBuffID("player",5215) then
                    RakeMultiplier = Prowl
                end
                -- return rake
                return multiplier*RakeMultiplier
            end
        end

        function self.getBleedUnits()
            for k,v in pairs(self.spell.spec.debuffs.bleeds) do
                self.bleed[k] = {}
                if #self.enemies.yards40 > 0 then
                    for i = 1, #self.enemies.yards40 do
                        local thisUnit = self.enemies.yards40[i]
                        self.bleed[k][thisUnit]             = {}
                        self.bleed[k][thisUnit].remain      = getDebuffRemain(thisUnit,v,"player") or 0
                        self.bleed[k][thisUnit].duration    = getDebuffDuration(thisUnit,v,"player") or 0
                        self.bleed[k][thisUnit].calc        = self.getSnapshotValue(v)
                        if self.bleed.combatLog[thisUnit] ~= nil then
                            if k == "rake" then self.bleed.rake[thisUnit].applied = self.bleed.combatLog[thisUnit].rake end
                            if k == "rip" then self.bleed.rip[thisUnit].applied = self.bleed.combatLog[thisUnit].rip end
                        else
                            if k == "rake" then self.bleed.rake[thisUnit].applied = 1 end
                            if k == "rip" then self.bleed.rip[thisUnit].applied = 2.5 end
                        end
                        if self.bleed[k][thisUnit].applied == nil or self.bleed[k][thisUnit].remain == 0 then
                            if k == "rake" then self.bleed.rake[thisUnit].applied = 1 end
                            if k == "rip" then self.bleed.rip[thisUnit].applied = 2.5 end
                        end
                    end
                end
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
            self.mode.cleave    = bb.data["Cleave"]
            self.mode.prowl     = bb.data["Prowl"]
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

            self.cast.debug.ashamanesFrenzy             = self.cast.ashamanesFrenzy("target",true)
            self.cast.debug.berserk                     = self.cast.berserk("player",true)
            self.cast.debug.brutalSlash                 = self.cast.brutalSlash("player",true)
            self.cast.debug.elunesGuidance              = self.cast.elunesGuidance("player",true)
            self.cast.debug.ferociousBite               = self.cast.ferociousBite("target",true)
            self.cast.debug.incarnationKingOfTheJungle  = self.cast.incarnationKingOfTheJungle("player",true)
            self.cast.debug.maim                        = self.cast.maim("target",true)
            self.cast.debug.moonfireFeral               = self.cast.moonfireFeral("player",true)
            self.cast.debug.rake                        = self.cast.rake("target",true)
            self.cast.debug.removeCorruption            = self.cast.removeCorruption("player",true)
            self.cast.debug.renewal                     = self.cast.renewal("player",true)
            self.cast.debug.rip                         = self.cast.rip("target",true)
            self.cast.debug.savageRoar                  = self.cast.savageRoar("player",true)
            self.cast.debug.shred                       = self.cast.shred("target",true)
            self.cast.debug.skullBash                   = self.cast.skullBash("target",true)
            self.cast.debug.stampedingRoar              = self.cast.stampedingRoar("player",true)
            self.cast.debug.survivalInstincts           = self.cast.survivalInstincts("player",true)
            self.cast.debug.swipe                       = self.cast.swipe("player",true)
            self.cast.debug.thrash                      = self.cast.thrash("player",true)
            self.cast.debug.tigersFury                  = self.cast.tigersFury("player",true)
        end

        -- Ashamane's Frenzy
        function self.cast.ashamanesFrenzy(thisUnit,debug)
            local spellCast = self.spell.ashamanesFrenzy
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.artifact.ashamanesFrenzy and self.buff.catForm and self.cd.ashamanesFrenzy == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Berserk
        function self.cast.berserk(thisUnit,debug)
            local spellCast = self.spell.berserk
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 48 and self.cd.berserk == 0 and self.buff.catForm then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Brutal Slash
        function self.cast.brutalSlash(thisUnit,debug)
            local spellCast = self.spell.brutalSlash
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.brutalSlash and self.cd.brutalSlash == 0 and self.charges.brutalSlash > 0 and self.power > 20 and self.buff.catForm then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Elune's Guidance
        function self.cast.elunesGuidance(thisUnit,debug)
            local spellCast = self.spell.elunesGuidance
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.elunesGuidance and self.cd.elunesGuidance == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Ferocious Bite
        function self.cast.ferociousBite(thisUnit,debug)
            local spellCast = self.spell.ferociousBite
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 3 and self.power > 25 and self.buff.catForm and self.comboPoints > 0 and self.cd.ferociousBite == 0 and getDistance(thisUnit)<5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Incarnation: King of the Jungle
        function self.cast.incarnationKingOfTheJungle(thisUnit,debug)
            local spellCast = self.spell.incarnationKingOfTheJungle
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.incarnationKingOfTheJungle and self.cd.incarnationKingOfTheJungle == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Maim
        function self.cast.maim(thisUnit,debug)
            local spellCast = self.spell.maim
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 72 and self.power > 35 and self.cd.maim == 0 and self.comboPoints > 0 and self.buff.catForm and hasThreat(thisUnit) and getDistance(thisUnit) < 5 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Moonfire
        function self.cast.moonfireFeral(thisUnit,debug)
            local spellCast = self.spell.moonfireFeral
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40AoE end
            if debug == nil then debug = false end

            if self.talent.lunarInspiration and self.power > 30 and self.cd.moonfireFeral == 0 and (hasThreat(thisUnit) or (isDummy(thisUnit) and getDistance(thisUnit) < 8)) and getDistance(thisUnit) < 40 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Rake
        function self.cast.rake(thisUnit,debug)
            local spellCast = self.spell.rake
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 6 and self.power > 35 and self.buff.catForm and self.cd.rake == 0 and (getDebuffDuration(thisUnit,spellCast,"player") == 0 or getDebuffDuration(thisUnit,spellCast,"player") > 4) and getDistance(thisUnit) < 5 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Remove Corruption
        function self.cast.removeCorruption(thisUnit,debug)
            local spellCast = self.spell.removeCorruption
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "mouseover" end
            if debug == nil then debug = false end

            if self.level >= 18 and self.powerPercentMana > 15.8 and self.cd.removeCorruption == 0 and canDispel(thisUnit,spellCast) and getDistance(thisUnit) < 40 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            end
        end
        -- Renewal
        function self.cast.renewal(thisUnit,debug)
            local spellCast = self.spell.renewal
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.renewal and self.cd.renewal == 0 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            end
        end
        -- Rip
        function self.cast.rip(thisUnit,debug)
            local spellCast = self.spell.rip
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 20 and self.power > 30 and self.cd.rip == 0 and self.buff.catForm and self.comboPoints > 0 and getDistance(thisUnit) < 5 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            end
        end
        -- Savage Roar
        function self.cast.savageRoar(thisUnit,debug)
            local spellCast = self.spell.savageRoar
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.savageRoar and self.power > 25 and self.comboPoints > 0 and self.cd.savageRoar == 0 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            end
        end
        -- Shred
        function self.cast.shred(thisUnit,debug)
            local spellCast = self.spell.shred
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 1 and self.buff.catForm and self.power > 40 and self.cd.shred == 0 and getDistance(thisUnit) < 5 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            end
        end
        -- Skull Bash
        function self.cast.skullBash(thisUnit,debug)
            local spellCast = self.spell.skullBash
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn13 end
            if debug == nil then debug = false end

            if self.level >= 64 and self.cd.skullBash == 0 and self.buff.catForm and hasThreat(thisUnit) and getDistance(thisUnit) < 13 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            end
        end
        -- Stampeding Roar
        function self.cast.stampedingRoar(thisUnit,debug)
            local spellCast = self.spell.stampedingRoar
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 83 and self.cd.stampedingRoar == 0 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            end
        end
        -- Survival Instincts
        function self.cast.survivalInstincts(thisUnit,debug)
            local spellCast = self.spell.survivalInstincts
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 40 and self.charges.survivalInstincts > 0 and self.charges.survivalInstincts > 0 and self.cd.survivalInstincts == 0 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            end
        end
        -- Swipe
        function self.cast.swipe(thisUnit,debug)
            local spellCast = self.spell.swipe
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if not self.talent.brutalSlash and self.level >= 32 and self.buff.catForm and self.power > 45 and self.cd.swipe == 0 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            end
        end
        -- Thrash
        function self.cast.thrash(thisUnit,debug)
            local spellCast = self.spell.thrash
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 14 and self.power > 50 and self.buff.catForm and hasThreat(thisUnit) and self.cd.thrash == 0 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            end
        end
        -- Tiger's Fury
        function self.cast.tigersFury(thisUnit,debug)
            local spellCast = self.spell.tigersFury
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level>=12 and self.cd.tigersFury==0 and self.powerDeficit>60 then
                if debug == true then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            end
        end

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

        -- Calculate Ferocious Bite Damage
        function getFbDamage(cp)
            local weaponDPS = (select(2,UnitDamage("player")) - select(1,UnitDamage("player"))) / 2
            local weaponDMG = (weaponDPS + UnitAttackPower("player") / 3.5) 
            local cp = cp
            if cp == nil then cp = bb.player.comboPoints end 
            fbD = 0.749 * cp * UnitAttackPower("player") * (1 + (bb.player.power - 25) / 25)
            if bb.player.inCombat then
                return fbD
            else
                return 0
            end
        end

        function useCleave()
            if self.mode.cleave==1 and self.mode.rotation < 3 then
                return true
            else
                return false
            end
        end

        function useProwl()
            if self.mode.prowl==1 then
                return true
            else
                return false
            end
        end

        function outOfWater()
            if swimTime == nil then swimTime = 0 end
            if outTime == nil then outTime = 0 end
            if IsSwimming() then
                swimTime = GetTime()
                outTime = 0
            end
            if not IsSwimming() then
                outTime = swimTime
                swimTime = 0
            end
            if outTime ~= 0 and swimTime == 0 then
                return true
            end
            if outTime ~= 0 and IsFlying() then
                outTime = 0
                return false
            end
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cFeral
end-- select Druid