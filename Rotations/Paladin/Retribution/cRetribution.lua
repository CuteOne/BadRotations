--- Retribution Class
-- Inherit from: ../cCharacter.lua and ../cPaladin.lua
-- All Paladin specs inherit from cPaladin.lua
if select(3, UnitClass("player")) == 2 and GetSpecialization() == 3 then

    cRetribution = {}

    -- Creates Retribution Paladin
    function cRetribution:new()
        local self = cPaladin:new("Retribution")

        local player = "player" -- if someone forgets ""

        self.rotations = {"Defmaster"}
        self.enemies = {
            yards5,
            yards8,
            yards12,
        }
        self.previousJudgmentTarget = previousJudgmentTarget
        self.retributionSpell = {
            avengingWrath        = 31884,
            divineCrusader       = 144595,
            divinePurpose        = 86172,
            divinePurposeBuff    = 90174,
            divineStorm          = 53385,
            empoweredSeals       = 152263,
            finalVerdict         = 157048,
            hammerOfTheRighteous = 53595,
            hammerOfWrath        = 158392,
            massExorcism         = 122032,
            sanctifiedWrath      = 53376,
            selflessHealerBuff   = 114250,
            seraphim             = 152262,
            templarsVerdict      = 85256,
            turnEvil             = 10326,
            -- Empowered Seals
            liadrinsRighteousness = 156989,
            maraadsTruth          = 156990,
        }

        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.paladinSpell, self.retributionSpell)

        self.defaultSeal = self.spell.sealOfThruth

        -- Update OOC
        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()

            self.getGlyphs()
            self.getTalents()
        end

        -- Update
        function self.update()
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            self.getBuffs()
            self.getCooldowns()
            self.getJudgmentRecharge()
            self.getDynamicUnits()
            self.getEnemies()
            self.getRotation()

            -- truth = true, right = false
            self.seal = GetShapeshiftForm() == 1

            -- Casting and GCD check
            -- TODO: -> does not use off-GCD stuff like pots, dp etc
            if castingUnit() then
                return
            end


            -- Start selected rotation
            self:startRotation()
        end



        -- Buff updates
        function self.getBuffs()
            local getBuffRemain = getBuffRemain

            self.buff.avengingWrath  = getBuffRemain(player,self.spell.avengingWrath)
            self.buff.divineCrusader = getBuffRemain(player,self.spell.divineCrusader)
            self.buff.divinePurpose  = getBuffRemain(player,self.spell.divinePurposeBuff)
            self.buff.finalVerdict   = getBuffRemain(player,self.spell.finalVerdict)
            self.buff.holyAvenger    = getBuffRemain(player,self.spell.holyAvenger)
            self.buff.sacredShield   = getBuffRemain(player,self.spell.sacredShield)
            self.buff.seraphim       = getBuffRemain(player,self.spell.seraphim)

            -- Empowered Seals
            self.buff.liadrinsRighteousness = getBuffRemain(player,self.spell.liadrinsRighteousness)
            self.buff.maraadsTruth          = getBuffRemain(player,self.spell.maraadsTruth)

            -- T17
            self.buff.blazingContempt = getBuffRemain(player,166831)
            self.buff.crusaderFury    = getBuffRemain(player,165442)

            -- T18
            self.buff.wingsOfLiberty = getBuffRemain(player,185647)

            -- T18 - Class trinket
            self.buff.focusOfVengeance    = getBuffRemain(player,184911)

            self.charges.avengingWrath = getCharges(self.spell.avengingWrath)
        end

        -- Cooldown updates
        function self.getCooldowns()
            local getSpellCD = getSpellCD

            self.cd.avengingWrath  = getSpellCD(self.spell.avengingWrath)
            self.cd.judgment       = getSpellCD(self.spell.judgment)
            self.cd.crusaderStrike = getSpellCD(self.spell.crusaderStrike)
            self.cd.seraphim       = getSpellCD(self.spell.seraphim)
        end

        -- Glyph updates
        function self.getGlyphs()
            local hasGlyph = hasGlyph

            self.glyph.massExorcism   = hasGlyph(122028)
            self.glyph.doubleJeopardy = hasGlyph(183)
        end

        -- Talent updates
        function self.getTalents()
            local isKnown = isKnown

            self.talent.empoweredSeals = isKnown(self.spell.empoweredSeals)
            self.talent.finalVerdict   = isKnown(self.spell.finalVerdict)
            self.talent.seraphim       = isKnown(self.spell.seraphim)
        end

        -- Update Dynamic units
        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn8 = dynamicTarget(8,true) -- Divine Storm

            -- AoE
            self.units.dyn8AoE  = dynamicTarget(8,false) -- Divine Storm
            self.units.dyn12AoE = dynamicTarget(12,false) -- Divine Storm w/ Final Verdict Buff
        end

        -- Update Number of Enemies around player
        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5  = #getEnemies("player",5)
            self.enemies.yards8  = #getEnemies("player",8)
            self.enemies.yards12 = #getEnemies("player",12)
        end

        -- Updates Judgment recharge time (cooldown)
        function self.getJudgmentRecharge()
            local GetSpellCooldown = GetSpellCooldown

            local cdCheckJudgment = select(2,GetSpellCooldown(self.spell.judgment))
            if cdCheckJudgment ~= nil and cdCheckJudgment > 2 then
                self.recharge.judgment = select(2,GetSpellCooldown(self.spell.judgment))
            else
                self.recharge.judgment = 4.5
            end
        end

        -- Rotation selection update
        function self.getRotation()
            self.rotation = bb.selectedProfile

            if bb.rotation_changed then
                self.createToggles()
                self.createOptions()

                bb.rotation_changed = false
            end
        end

        -- Starts rotation, uses default if no other specified; starts if inCombat == true
        function self.startRotation()
            if self.rotation == 1 then
                self:retributionSimC()
                -- put different rotations below; dont forget to setup your rota in options
            else
                ChatOverlay("No ROTATION ?!", 2000)
            end
        end

        ---------------------------------------------------------------
        -------------------- OPTIONS ----------------------------------
        ---------------------------------------------------------------

        function self.createToggles()
            GarbageButtons()

            if self.rotation == 1 then
                AoEModes = {
                    [1] = {
                        mode = "1-2",
                        value = 1,
                        overlay = "|cffFFFFFFSingle Target Enabled",
                        tip = "|cffFF0000Used for \n|cffFFDD11Single Target(1-2).",
                        highlight = 0,
                        icon = 35395
                    },
                    [2] = {
                        mode = ">2",
                        value = 2,
                        overlay = "|cffFFBC0BCleave AoE Enabled",
                        tip = "|cffFF0000Used for \n|cffFFDD11AoE(>2).",
                        highlight = 0,
                        icon = 53385
                    },
                    [3] = {
                        mode = "Auto",
                        value = 3,
                        overlay = "|cff00F900Auto-AoE Enabled",
                        tip = "|cffFFDD11Automatic calculations of ennemies.",
                        highlight = 1,
                        icon = 114158
                    }
                }
                CreateButton("AoE",0,1)
                -- Interrupts Button
                InterruptsModes = {
                    [1] = {
                        mode = "None",
                        value = 1 ,
                        overlay = "Interrupts Disabled",
                        tip = "No Interrupts will be used.",
                        highlight = 0,
                        icon = [[INTERFACE\ICONS\ability_hibernation]]
                    },
                    [2] = {
                        mode = "Raid",
                        value = 2 ,
                        overlay = "Interrupts Specific Abilities",
                        tip = "Interrupts preset abilities only.",
                        highlight = 1,
                        icon = [[INTERFACE\ICONS\INV_Misc_Head_Dragon_01.png]]
                    },
                    [3] = {
                        mode = "All",
                        value = 3 ,
                        overlay = "Interrupt All Abilities",
                        tip = "Interrupts everything.",
                        highlight = 1,
                        icon = 147362
                    }
                }
                CreateButton("Interrupts",1,0)
                -- Defensive Button
                DefensiveModes = {
                    [1] = {
                        mode = "None",
                        value = 1 ,
                        overlay = "Defensive Disabled",
                        tip =  "|cffFF0000Defensive Cooldowns Included: \n|cffFFDD11None.",
                        highlight = 0,
                        icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]
                    },
                    [2] = {
                        mode = "User",
                        value = 1 ,
                        overlay = "Selective Defense Enabled",
                        tip = "|cffFF0000Defensive Cooldowns Included: \n|cffFFDD11Config's selected spells.",
                        highlight = 0,
                        icon = 498
                    },
                    [3] = {
                        mode = "All",
                        value = 2 ,
                        overlay = "Defensive Enabled",
                        tip = "|cffFF0000Defensive Cooldowns Included: |cffFFDD11\nDivine Protection, \nDivine Shield.",
                        highlight = 1,
                        icon = 642
                    }
                }
                CreateButton("Defensive",1,1)
                -- Cooldowns Button
                CooldownsModes = {
                    [1] = {
                        mode = "None",
                        value = 1 ,
                        overlay = "Cooldowns Disabled",
                        tip = "|cffFF0000Cooldowns Included: \n|cffFFDD11None.",
                        highlight = 0,
                        icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]
                    },
                    [2] = {
                        mode = "User",
                        value = 2 ,
                        overlay = "User Cooldowns Enabled",
                        tip = "|cffFF0000Cooldowns Included: \n|cffFFDD11Config's selected spells.",
                        highlight = 1,
                        icon = 105809
                    },
                    [3] = {
                        mode = "All",
                        value = 3 ,
                        overlay = "Cooldowns Enabled",
                        tip = "|cffFF0000Cooldowns Included: \n|cffFFDD11Avenging Wrath, \nHoly Avenger, \nLight's Hammer, \nExecution Sentence.",
                        highlight = 1,
                        icon = 31884
                    }
                }
                CreateButton("Cooldowns",2,0)
                -- Healing Button
                HealingModes = {
                    [1] = {
                        mode = "Self",
                        value = 1 ,
                        overlay = "Heal only Self.",
                        tip = "|cffFF0000Healing: |cffFFDD11On self only.",
                        highlight = 0,
                        icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]]
                    },
                    [2] = {
                        mode = "All",
                        value = 2 ,
                        overlay = "Heal Everyone.",
                        tip = "|cffFF0000Healing: |cffFFDD11Everyone.",
                        highlight = 1,
                        icon = 19750
                    }
                }
                CreateButton("Healing",2,1)
            end
        end

        function self.createOptions()
            bb.ui.window.profile = bb.ui:createProfileWindow("Retribution")

            self.createClassOptions()


            local section
            if self.rotation == 1 then
                -- Wrapper
                --section = bb.ui:createSection(bb.ui.window.profile, "Buffs")
                --bb.ui:checkSectionState(section)

                -- Wrapper
                section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
                -- Avenging Wrath
                bb.ui:createDropdown(section, "Avenging Wrath", bb.dropOptions.CD, 1)
                bb.ui:createSpinner(section, "AW Charges", 1, 0, 3, 1, "|cffFFBB00How many charges should be unused from \n|cffFFFFFFAvenging Wrath ?")
                -- Light's Hammer
                bb.ui:createDropdown(section, "Light's Hammer", bb.dropOptions.CD, 1)
                -- Execution sentence
                bb.ui:createDropdown(section, "Execution Sentence", bb.dropOptions.CD, 1)
                -- Execution sentence
                bb.ui:createDropdown(section, "Holy Prism", bb.dropOptions.CD, 1)
                -- Holy Avenger
                bb.ui:createDropdown(section, "Holy Avenger", bb.dropOptions.CD, 1)
                -- Seraphim
                bb.ui:createDropdown(section, "Seraphim", bb.dropOptions.CD, 1)
                bb.ui:checkSectionState(section)


                -- Wrapper
                section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
                -- Divine Protection
                bb.ui:createSpinner(section, "Divine Protection", 75, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Protection")
                -- Divine Shield
                bb.ui:createSpinner(section, "Divine Shield", 10, 0, 100, 1, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Shield")
                bb.ui:checkSectionState(section)


                -- Wrapper
                section = bb.ui:createSection(bb.ui.window.profile, "Healing")
                -- LoH options
                --generalPaladinOptions()

                -- Tier 3 talents
                bb.ui:createSpinner(section, "Sacred Shield", 95, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSacred Shield")
                bb.ui:createSpinner(section, "Selfless Healer", 35, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSelfless Healer on Raid")
                bb.ui:createSpinner(section, "Self Flame", 35, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Self")
                bb.ui:createSpinner(section, "Eternal Flame", 20, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Raid")
                bb.ui:createSpinner(section, "Self Glory", 70, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Self")
                bb.ui:createSpinner(section, "Word Of Glory", 70, 0, 100, 5, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWord Of Glory on Raid")
                bb.ui:checkSectionState(section)


                --[[ Rotation Dropdown ]]--
                bb.ui:createRotationDropdown(bb.ui.window.profile.parent, self.rotations)

                bb:checkProfileWindowStatus()
            end
        end


        ---------------------------------------------------------------
        -------------------- Spell functions --------------------------
        ---------------------------------------------------------------

        -- Avenging Wrath
        function self.castAvengingWrath()
            if isSelected("Avenging Wrath") then
                if (isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 4*UnitHealthMax("player"))) then
                    if ((self.talent.seraphim and self.buff.seraphim) or (not self.talent.seraphim)) and self.buff.avengingWrath == 0 then
                        if self.eq.t18_2pc and isChecked("AW Charges") and getValue("AW Charges") >= self.charges.avengingWrath then return false end
                        return castSpell("player",self.spell.avengingWrath,true,false) == true or false
                    end
                end
            end
        end

        -- Execution sentence
        function self.castExecutionSentence()
            if isSelected("Execution Sentence") then
                if (isDummy(self.units.dyn40) or (UnitHealth(self.units.dyn40) >= 4*UnitHealthMax("player"))) then
                    if castSpell(self.units.dyn30,self.spell.executionSentence,false,false) then
                        return true
                    end
                end
            end
            return false
        end

        -- Crusader Strike
        function self.castCrusaderStrike()
            if self.eq.t18_classTrinket or isDummy(self.units.dyn5) then
                local enemiesTable = enemiesTable
                if #enemiesTable > 1 then
                    for i=1,#enemiesTable do
                        local thisEnemy = enemiesTable[i]
                        if thisEnemy.distance <= 5 then
                            if previousT18classTrinket == thisEnemy.guid and getFacing("player", thisEnemy.unit) then
                                return castSpell(thisEnemy.unit,self.spell.crusaderStrike,false,false) == true or false
                            end
                        end
                    end
                end
            end
            return castSpell(self.units.dyn5,self.spell.crusaderStrike,false,false) == true or false
        end

        -- Divine Shield
        function self.castDivineShield()
            if (isChecked("Divine Shield") and self.mode.defense == 2) or self.mode.defense == 3 then
                if self.health < getValue("Divine Shield") then
                    return castSpell("player",self.spell.divineShield,true,false) == true or false
                end
            end
        end

        -- Divine Storm
        function self.castDivineStorm()
            return (self.buff.finalVerdict and castSpell(self.units.dyn12AoE,self.spell.divineStorm,true,false) == true)
                    or castSpell(self.units.dyn8AoE,self.spell.divineStorm,true,false) == true or false
        end

        -- Exorcism
        function self.castExorcism()
            if self.glyph.massExorcism then
                return castSpell(self.units.dyn5,self.spell.massExorcism,false,false) == true
            else
                return castSpell(self.units.dyn30,self.spell.exorcism,false,false) == true
            end
        end

        -- Final Verdict
        function self.castFinalVerdict()
            return self.castTemplarsVerdict() == true or false
        end

        -- Hammer of the Righteous
        function self.castHammerOfTheRighteous()
            if self.eq.t18_classTrinket or isDummy(self.units.dyn5) then
                local enemiesTable = enemiesTable
                if #enemiesTable > 1 then
                    for i=1,#enemiesTable do
                        local thisEnemy = enemiesTable[i]
                        if thisEnemy.distance <= 5 then
                            if previousT18classTrinket == thisEnemy.guid and getFacing("player", thisEnemy.unit) then
                                return castSpell(thisEnemy.unit,self.spell.hammerOfTheRighteous,false,false) == true or false
                            end
                        end
                    end
                end
            end
            return castSpell(self.units.dyn5,self.spell.hammerOfTheRighteous,false,false) == true or false
        end

        -- Hammer of Wrath
        function self.castHammerOfWrath()
            if canCast(self.spell.hammerOfWrath,true) then
                return castSpell(self.units.dyn30,self.spell.hammerOfWrath,false,false) == true or false
            else
                local hpHammerOfWrath = 35
                local enemiesTable = enemiesTable
                for i = 1,#enemiesTable do
                    if enemiesTable[i].hp < hpHammerOfWrath then
                        return castSpell(enemiesTable[i].unit,self.spell.hammerOfWrath,false,false,false,false,false,false,true) == true or false
                    end
                end
            end
            --end
        end

        -- Holy Avenger
        function self.castHolyAvenger()
            if isSelected("Holy Avenger") then
                if isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 4*UnitHealthMax("player")) then
                    if self.talent.seraphim and self.buff.seraphim or (not self.talent.seraphim and self.holyPower <= 2) then
                        return castSpell("player",self.spell.holyAvenger,true,false) == true or false
                    end
                end
            end
        end

        -- Holy Prism
        function self.castHolyPrism(minimumUnits)
            if self.enemies.yards12 >= minimumUnits then
                return castSpell("player",self.spell.holyPrism,true,false) == true or false
            else
                if minimumUnits == 1 then
                    return castSpell(self.units.dyn30,self.spell.holyPrism,false,false) == true or false
                end
            end
        end

        -- Jeopardy
        function self.castJeopardy()
            if self.glyph.doubleJeopardy then
                -- scan enemies for a different unit
                local enemiesTable = enemiesTable
                if #enemiesTable > 1 then
                    for i = 1, #enemiesTable do
                        local thisEnemy = enemiesTable[i]
                        -- if its in range
                        if thisEnemy.distance < 30 then
                            -- here i will need to compare my previous judgment target with the previous one
                            -- we declare a var in in core updated by reader with last judged unit
                            if previousJudgmentTarget ~= thisEnemy.guid then
                                return castSpell(thisEnemy.unit,self.spell.judgment,true,false) == true or false
                            end
                        end
                    end
                end
            end
            -- if no unit found for jeo, cast on actual target
            return self.castJudgment() == true or false
        end

        -- Judgment
        function self.castJudgment()
            return castSpell(self.units.dyn30AoE,self.spell.judgment,true,false) == true or false
        end

        -- Light's Hammer
        function self.castLightsHammer()
            if isSelected("Light's Hammer") then
                local thisUnit = self.units.dyn30AoE
                if UnitExists(thisUnit) and (isDummy(thisUnit) or not isMoving(thisUnit)) then
                    if getGround(thisUnit) then
                        return castGround(thisUnit,self.spell.lightsHammer,30) == true or false
                    end
                end
            end
        end

        -- Rebuke
        function self.castRebuke()
            -- TODO: implement interrupt
            --if BadBoy_data["Interrupts"] ~= 1 and isChecked("Rebuke") then
            --	castInterrupt(self.spell.rebuke, getValue("Rebuke"))
            --end
        end

        -- Sacred Shield
        function self.castSacredShield()
            if self.health <= getValue("Sacred Shield") then
                if self.buff.sacredShield < 6 then
                    return castSpell("player",self.spell.sacredShield,true,false) == true or false
                end
            end
        end

        -- Selfless Healer
        function self.castSelfLessHealer()
            if getBuffStacks("player",self.spell.selflessHealerBuff) == 3 then
                if self.health <= getValue("Selfless Healer") then
                    return castSpell("player",self.spell.flashOfLight,true,false) == true or false
                end
            end
        end

        -- Seraphim
        function self.castSeraphim()
            if self.talent.seraphim and self.holyPower == 5 then
                if isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 4*UnitHealthMax("player")) then
                    return castSpell("player",self.spell.seraphim,true,false) == true or false
                end
            end
        end

        -- Templars Verdict
        function self.castTemplarsVerdict()
            -- Casts Templars Verdict or Final Verdict if talent selected
            return (self.talent.finalVerdict and castSpell(self.units.dyn8,self.spell.templarsVerdict,false,false)) == true
                    or castSpell(self.units.dyn5,self.spell.templarsVerdict,false,false) == true or false
        end

        -- Word of Glory
        function self.castWordOfGlory()
            if isChecked("Self Glory") then
                if self.health <= getValue("Self Glory") then
                    if self.holyPower >= 3 or self.buff.divinePurpose > 0 then
                        return castSpell("player",self.spell.wordOfGlory,true,false) == true or false
                    end
                end
            end
        end

        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()
        self.createToggles()


        -- Return
        return self
    end
end
