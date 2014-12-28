if select(3,UnitClass("player")) == 2 then
    function PaladinRetFunctions()
        -- we want to build core only only
        if core == nil then

            -- build core
            local retCore = {
                -- player stats
                buff = { },
                cd = { },
                glyph = { },
                health = 100,
                holyPower = 0,
                inCombat = false,
                melee5Yards = 0,
                melee8Yards = 0,
                melee16Yards = 0,
                mode = { },
                recharge = { },
                talent = { },
                units = { },
                seal = true,
                spell = {
                    avengingWrath = 31884,
                    crusaderStrike = 35395,
                    divineCrusader = 144595,
                    divinePurpose = 86172,
                    divinePurposeBuff = 90174,
                    divineShield = 642,
                    divineStorm = 53385,
                    eternalFlame = 114163,
                    executionSentence = 114157,
                    exorcism = 879,
                    finalVerdict = 157048,
                    fistOfJustice = 105593,
                    flashOfLight = 19750,
                    hammerOfJustice = 853,
                    hammerOfTheRighteous = 53595,
                    hammerOfWrath = 24275,
                    holyAvenger = 105809,
                    holyPrism = 114165,
                    judgment = 20271,
                    layOnHands = 633,
                    lightsHammer = 114158,
                    massExorcism = 122032,
                    rebuke = 96231,
                    repentance = 20066,
                    sanctifiedWrath = 53376,
                    sacredShield = 20925,
                    sealOfRighteousness = 20154,
                    sealOfThruth = 31801,
                    selflessHealerBuff = 114250,
                    seraphim = 152262,
                    templarsVerdict = 85256,
                    turnEvil = 10326,
                    wordOfGlory = 85673,
                 }
            }

            -- Global
            core = retCore

            -- localise commonly used functions
            local getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks = getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks
            local UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies = UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies
            local player,BadBoy_data,GetShapeshiftForm,dynamicTarget = "player",BadBoy_data,GetShapeshiftForm,dynamicTarget
            local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
            local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
            local getGround,canCast,isKnown,enemiesTable,sp = getGround,canCast,isKnown,enemiesTable,core.spells
            local UnitHealth,previousJudgmentTarget,print,UnitHealthMax = UnitHealth,previousJudgmentTarget,print,UnitHealthMax


            -- no external access after here
            setfenv(1,retCore)

            function retCore:ooc()
                -- Talents (refresh ooc)
                self.talent.empoweredSeals = isKnown(152263)
                self.talent.finalVerdict = isKnown(self.spell.finalVerdict)
                self.talent.seraphim = isKnown(self.spell.seraphim) and isSelected("Seraphim")
                -- Glyph (refresh ooc)
                self.glyph.massExorcism = hasGlyph(122028)
                self.glyph.doubleJeopardy = hasGlyph(183)
                self.inCombat = false
            end

            -- this will be used to make the core refresh itself
            function retCore:update()
                -- player stats
                self.health = getHP(player)
                self.holyPower = UnitPower(player,9)
                -- Buffs
                self.buff.avengingWrath = getBuffRemain(player,self.spell.avengingWrath)
                self.buff.divineCrusader = getBuffRemain(player,self.spell.divineCrusader)
                self.buff.holyAvenger = getBuffRemain(player,self.spell.holyAvenger)
                self.buff.divinePurpose = getBuffRemain(player,self.spell.divinePurpose)
                self.buff.finalVerdict = getBuffRemain(player,self.spell.finalVerdict)
                self.buff.liadrinsRighteousness = getBuffRemain(player,156989)
                self.buff.seraphim = getBuffRemain(player,self.spell.seraphim)
                self.buff.blazingContemp = IsSpellOverlayed(122032)
                self.buff.maraadsTruth = getBuffRemain(player,156990)
                -- Cooldowns
                self.cd.avengingWrath = getSpellCD(self.spell.avengingWrath)
                self.cd.judgment = getSpellCD(self.spell.judgment)
                self.cd.seraphim = getSpellCD(self.spell.seraphim)
                self.inCombat = true
                -- Units
                self.melee5Yards = #getEnemies(player,5)
                self.melee8Yards = #getEnemies(player,8)
                self.melee16Yards = #getEnemies(player,16)
                -- Modes
                self.mode.aoe = BadBoy_data["AoE"]
                self.mode.cooldowns = BadBoy_data["Cooldowns"]
                self.mode.defensive = BadBoy_data["Defensive"]
                self.mode.healing = BadBoy_data["Healing"]
                -- truth = true, right = false
                self.seal = GetShapeshiftForm() == 1

                -- dynamic units
                self.units.dyn5 = dynamicTarget(5,true)
                self.units.dyn8AoE = dynamicTarget(8,false)
                self.units.dyn8 = dynamicTarget(8,true)
                self.units.dyn16AoE = dynamicTarget(16,false)
                self.units.dyn30 = dynamicTarget(30,true)
                self.units.dyn30AoE = dynamicTarget(30,false)
                self.units.dyn40 = dynamicTarget(40,true)

                local cdCheckJudgment = select(2,GetSpellCooldown(self.spell.judgment))
                if cdCheckJudgment ~= nil and cdCheckJudgment > 2 then
                    self.recharge.judgment = select(2,GetSpellCooldown(self.spell.judgment))
                else
                    self.recharge.judgment = 4.5
                end
            end

            -- Avenging Wrath
            function retCore:castAvengingWrath()
                if isSelected("Avenging Wrath") then
                    if (isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 400*UnitHealthMax(player)/100)) then
                        if self.talent.seraphim and self.buff.seraphim or (not self.talent.seraphim and self.holyPower <= 2) then
                            return castSpell(player,self.spell.avengingWrath,true,false) == true or false
                        end
                    end
                end
            end

            -- Todo : Execution sentence make sure we cast on a unit with as much HP as possible
            function retCore:castExecutionSentence()
                if isSelected("Execution Sentence") then
                    if (isDummy(self.units.dyn40) or (UnitHealth(self.units.dyn40) >= 400*UnitHealthMax("player")/100)) then
                        if castSpell(self.units.dyn30,self.spell.executionSentence,false,false) then
                            return true
                        end
                    end
                end
                return false
            end

            -- Crusader Strike
            function retCore:castCrusaderStrike()
                return castSpell(self.units.dyn5,self.spell.crusaderStrike,false,false) == true or false
            end

            -- Divine Shield
            function retCore:castDivineShield()
                if (isChecked("Divine Shield") and mode.defense == 2) or mode.defense == 3 then
                    return self.health < getValue("Divine Shield") and castSpell(player,self.spell.divineShield,true,false) == true or false
                end
            end

            -- Divine Storm
            function retCore:castDivineStorm()
                return (self.buff.finalVerdict and castSpell(self.units.dyn16AoE,self.spell.divineStorm,true,false) == true) or castSpell(self.units.dyn8AoE,self.spell.divineStorm,true,false) == true or false
            end

            -- Exorcism
            function retCore:castExorcism()
                if self.glyph.massExorcism then
                    return castSpell(self.units.dyn5,self.spell.massExorcism,false,false) == true
                else
                    return castSpell(self.units.dyn30,self.spell.exorcism,false,false) == true
                end
            end

            -- Hammer of the Righteous
            function retCore:castHammerOfTheRighteous()
                return castSpell(self.units.dyn5,self.spell.hammerOfTheRighteous,false,false) == true or false
            end

            -- Hammer of Wrath
            function retCore:castHammerOfWrath()
                if canCast(self.spell.hammerOfWrath) then
                    if self.buff.avengingWrath > 0 then
                        return castSpell(self.units.dyn30,self.spell.hammerOfWrath,false,false) == true or false
                    else
                        local hpHammerOfWrath = 20
                        -- if empowered hammer of wrath, we need to get value for HoW hp at 35%
                        if isKnown(157496) then
                            hpHammerOfWrath = 35
                        end
                        local enemiesTable = enemiesTable
                        for i = 1,#enemiesTable do
                            if enemiesTable[i].hp < hpHammerOfWrath then
                                return castSpell(enemiesTable[i].unit,self.spell.hammerOfWrath,false,false) == true or false
                            end
                        end
                    end
                end
            end

            -- Holy Avenger
            function retCore:castHolyAvenger()
                if isSelected("Holy Avenger") then
                    if isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 400*UnitHealthMax(player)/100) then
                        if self.talent.seraphim and self.buff.seraphim or (not self.talent.seraphim and self.holyPower <= 2) then
                            return castSpell(player,self.spell.holyAvenger,true,false) == true or false
                        end
                    end
                end
            end

            -- Holy Prism
            function retCore:castHolyPrism(minimumUnits)
                if self.melee16Yards >= minimumUnits then
                    return castSpell(player,self.spell.holyPrism,true,false) == true or false
                else
                    if minimumUnits == 1 then
                        return castSpell(self.units.dyn30,self.spell.holyPrism,false,false) == true or false
                    end
                end
            end

            -- Jeopardy
            function retCore:castJeopardy()
                -- scan enemies for a different unit
                local enemiesTable = enemiesTable
                if #enemiesTable > 1 then
                    for i = 1, #enemiesTable do
                        local thisEnemy = enemiesTable[i]
                        -- if its in range
                        if thisEnemy.distance < 30 then
                            -- here i will need to compare my previous judgment target with the previous one
                            -- we declare a var in in core updated by reader with last judged unit
                            if self.previousJudgmentTarget ~= thisEnemy.guid then
                                return castSpell(thisEnemy.unit,self.spell.judgment,true,false) == true or false
                            end
                        end
                    end
                end
                -- if no unit found for jeo, cast on actual target
                return castSpell(self.units.dyn30AoE,self.spell.judgment,true,false) == true or false
            end

            -- Judgment
            function retCore:castJudgment()
                return castSpell(self.units.dyn30AoE,self.spell.judgment,true,false) == true or false
            end

            -- Light's Hammer
            function retCore:castLightsHammer()
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
            function retCore:castRebuke()
                castInterrupt(self.spell.rebuke, getValue("Rebuke"))
            end

            -- Seals
            function retCore:castSeal(value)
                if value == 1 then
                    return castSpell(player,self.spell.sealOfThruth,true,false) == true or false
                else
                    return castSpell(player,self.spell.sealOfRighteousness,true,false) == true or false
                end
            end

            -- Selfless Healer
            function retCore:castSelfLessHealer()
                if getBuffStacks(player,114250) == 3 then
                    if self.health <= getValue("Selfless Healer") then
                        return castSpell(player,self.spell.flashOfLight,true,false) == true or false
                    end
                end
            end

            -- Seraphim
            function retCore:castSeraphim()
                if self.talent.seraphim and self.holyPower == 5 then
                    if isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 400*UnitHealthMax(player)/100) then
                        return castSpell(player,self.spell.seraphim,true,false) == true or false
                    end
                end
            end

            -- Templars Verdict
            function retCore:castTemplarsVerdict()
                return (self.talent.finalVerdict and castSpell(self.units.dyn8,self.spell.templarsVerdict,false,false)) == true
                  or castSpell(self.units.dyn5,self.spell.templarsVerdict,false,false) == true or false
            end

            -- Word of glory
            function retCore:castWordOfGlory()
                if isChecked("Word Of Glory On Self") then
                    if self.health <= getValue("Word Of Glory On Self") then
                        if self.holyPower >= 3 or self.buff.divinePurpose then
                            return castSpell(player,self.spell.wordOfGlory,true,false) == true or false
                        end
                    end
                end
            end
        end
    end
end
