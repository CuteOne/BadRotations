if select(3,UnitClass("player")) == 2 then
    function PaladinProtFunctions()
        -- we want to build core only only
        if protCore == nil then
            -- build core
            local protCore = {
                -- player stats
                buff = { },
                combatStarted = 0,
                cd = { },
                globalCooldown = 0,
                glyph = { },
                health = 100,
                holyPower = 0,
                inCombat = false,
                melee5Yards = 0,
                melee8Yards = 0,
                melee16Yards = 0,
                mode = { },
                nova = {
                	lowestHP = 0,
                	lowestUnit = "player",
                	lowestTankHP = 0,
                	lowestTankUnit = "player"
                },
                recharge = { },
                talent = { },
                units = { },
                seal = true,
                spell = {
                    arcaneTorrent = 28730,
                	ardentDefender = 31850,
                	avengersShield = 31935,
                    avengingWrath = 31884,
                    consecration = 26573,
                    crusaderStrike = 35395,
                    divineProtection = 498,
                    divinePurpose = 86172,
                    divinePurposeBuff = 90174,
                    divineShield = 642,
                    divineStorm = 53385,
                    eternalFlame = 114163,
                    executionSentence = 114157,
                    fistOfJustice = 105593,
                    flashOfLight = 19750,
                    guardianOfAncientKings = 86659,
                    hammerOfJustice = 853,
                    hammerOfTheRighteous = 53595,
                    hammerOfWrath = 24275,
                    harshWords = 136494,
                    holyAvenger = 105809,
                    holyPrism = 114165,
                    holyWrath = 119072,
                    judgment = 20271,
                    layOnHands = 633,
                    lightsHammer = 114158,
                    rebuke = 96231,
                    repentance = 20066,
                    righteousFury = 25780,
                    sanctifiedWrath = 53376,
                    sacredShield = 20925,
                    sealOfInsight = 20165,
                    sealOfRighteousness = 20154,
                    sealOfThruth = 31801,
                    selflessHealerBuff = 114250,
                    seraphim = 152262,
                    shieldOfTheRighteous = 53600,
                    turnEvil = 10326,
                    wordOfGlory = 85673,
                 }
            }

            -- Global
            core = protCore

            -- localise commonly used functions
            local getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks = getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks
            local UnitBuffID,isInMelee,getSpellCD,getEnemies = UnitBuffID,isInMelee,getSpellCD,getEnemies
            local player,BadBoy_data,GetShapeshiftForm,dynamicTarget = "player",BadBoy_data,GetShapeshiftForm,dynamicTarget
            local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
            local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
            local getGround,canCast,isKnown,enemiesTable,sp = getGround,canCast,isKnown,enemiesTable,core.spells
            local UnitHealth,previousJudgmentTarget,print,UnitHealthMax = UnitHealth,previousJudgmentTarget,print,UnitHealthMax
            local getDistance,getDebuffRemain,GetTime,getFacing = getDistance,getDebuffRemain,GetTime,getFacing
            local spellCastersTable = spellCastersTable

            -- no external access after here
            setfenv(1,protCore)

            function protCore:ooc()
                -- Talents (refresh ooc)
                self.talent.empoweredSeals = isKnown(152263)
                self.talent.seraphim = isKnown(self.spell.seraphim) and isSelected("Seraphim")
                -- Glyph (refresh ooc)
                self.glyph.doubleJeopardy = hasGlyph(183)
                self.glyph.harshWords = hasGlyph(197)
                self.inCombat = false
            end

            -- this will be used to make the core refresh itself
            function protCore:update()
                -- player stats
                self.health = getHP(player)
                self.holyPower = UnitPower(player,9)
                -- Buffs
                self.buff.ardentDefender = getBuffRemain(player,self.spell.ardentDefender)
                self.buff.avengingWrath = getBuffRemain(player,self.spell.avengingWrath)
                self.buff.holyAvenger = getBuffRemain(player,self.spell.holyAvenger)
                self.buff.divineProtection = getBuffRemain(player,self.spell.divineProtection)
                self.buff.divinePurpose = getBuffRemain(player,self.spell.divinePurpose)
                self.buff.grandCrusader = getBuffRemain(player,85416)
                self.buff.guardianOfAncientKings = getBuffRemain(player,self.spell.guardianOfAncientKings)
                self.buff.liadrinsRighteousness = getBuffRemain(player,156989)
                self.buff.righteousFury = UnitBuffID(player,self.spell.righteousFury)
                self.buff.sacredShield = getBuffRemain(player,self.spell.sacredShield)
                self.buff.shieldOfTheRighteous = getBuffRemain(player,132403)
                self.buff.seraphim = getBuffRemain(player,self.spell.seraphim)
                self.buff.uthersInsight = getBuffRemain(player,156988)
                self.buff.maraadsTruth = getBuffRemain(player,156990)
                -- Cooldowns
                self.cd.avengingWrath = getSpellCD(self.spell.avengingWrath)
                self.cd.crusaderStrike = getSpellCD(self.spell.crusaderStrike)
                self.cd.divineProtection = getSpellCD(self.spell.divineProtection)
                self.cd.judgment = getSpellCD(self.spell.judgment)
                self.cd.seraphim = getSpellCD(self.spell.seraphim)
                self.globalCooldown = getSpellCD(61304)
                self.inCombat = true
                -- Units
                self.melee5Yards = #getEnemies(player,5) -- (meleeEnemies)
                self.melee9Yards = #getEnemies(player,9) -- (Consecration)
                self.melee10Yards = #getEnemies(player,10) -- (Holy Wrath)
                self.aroundTarget7Yards = #getEnemies(self.units.dyn5,7) -- (Hammer of the Righteous)
                -- Modes
                self.mode.aoe = BadBoy_data["AoE"]
                self.mode.cooldowns = BadBoy_data["Cooldowns"]
                self.mode.defensive = BadBoy_data["Defensive"]
                self.mode.healing = BadBoy_data["Healing"]
                self.mode.rotation = BadBoy_data["Rota"]
                -- truth = true, right = false
                self.seal = GetShapeshiftForm()
                -- dynamic units
                self.units.dyn5 = dynamicTarget(5,true)
                self.units.dyn5AoE = dynamicTarget(5,false)
                self.units.dyn8AoE = dynamicTarget(8,false)
                self.units.dyn30 = dynamicTarget(30,true)
                self.units.dyn30AoE = dynamicTarget(30,false)
                self.units.dyn40 = dynamicTarget(40,true)

	    		-- Generic Lowest Tank and Raider
	    		local validMembers = 0

                -- others
                self.unitInFront = getFacing("player",self.units.dyn5) == true or false
                self.combatLenght = GetTime() - BadBoy_data["Combat Started"]
                local cdCheckJudgment = select(2,GetSpellCooldown(self.spell.judgment))
                if cdCheckJudgment ~= nil and cdCheckJudgment > 2 then
                    self.recharge.judgment = select(2,GetSpellCooldown(self.spell.judgment))
                else
                    self.recharge.judgment = 4.5
                end
            end

            -- Ardent Defender
            function protCore:castArdentDefender()
                return isChecked("Ardent Defender") and self.health <= getValue("Ardent Defender") and castSpell(player,self.spell.ardentDefender,true,false)
            end

            -- Avenger's Shield
			function protCore:castAvengersShield()
				return castSpell(self.units.dyn30,self.spell.avengersShield,false,false) == true or false
			end


			-- Todo : Check Glyphs(is on us or can we cast it on ground 25 yards
			function protCore:castConsecration()
                local consecrationDebuff = 81298
				if isInMelee(self.units.dyn5AoE) and getDebuffRemain(self.units.dyn5AoE,consecrationDebuff,"player") < 2 then
					return castSpell(player,self.spell.consecration,true,false) == true or false
				end
			end

            -- Crusader Strike
            function protCore:castCrusaderStrike()
                return castSpell(self.units.dyn5,self.spell.crusaderStrike,false,false) == true or false
            end

            -- Guardian Of Ancient Kings
            function protCore:castGuardianOfAncientKings()
                return self.health < getValue("Guardian Of Ancient Kings") and castSpell(player,self.spell.guardianOfAncientKings,true,false)
            end

            -- Guardian Of Ancient Kings
            function protCore:castDivineProtection()
                return isChecked("Divine Protection") and self.health <= getValue("Divine Protection") and castSpell(player,self.spell.divineProtection,true,false)
            end

            -- Divine Shield
            function protCore:castDivineShield()
                if (isChecked("Divine Shield") and mode.defense == 2) or mode.defense == 3 then
                    return self.health < getValue("Divine Shield") and castSpell(player,self.spell.divineShield,true,false) == true or false
                end
            end

            -- Todo : Execution sentence make sure we cast on a unit with as much HP as possible
            function protCore:castExecutionSentence()
                if isSelected("Execution Sentence") then
                    if (isDummy(self.units.dyn40) or (UnitHealth(self.units.dyn40) >= 400*UnitHealthMax("player")/100)) then
                        return castSpell(self.units.dyn30,self.spell.executionSentence,false,false) == true or false
                    end
                end
                return false
            end

            -- Guardian Of Ancient Kings
            function protCore:castGuardianOfAncientKings()
                return isChecked("Guardian Of Ancient Kings") and self.health <= getValue("Guardian Of Ancient Kings") and castSpell(player,self.spell.guardianOfAncientKings,true,false)
            end

            -- Hammer of the Righteous
            function protCore:castHammerOfTheRighteous()
                return castSpell(self.units.dyn5,self.spell.hammerOfTheRighteous,false,false) == true or false
            end

            -- Hammer of Wrath
            function protCore:castHammerOfWrath()
                if canCast(self.spell.hammerOfWrath) then
                    for i = 1,#enemiesTable do
                        if enemiesTable[i].hp < 20 then
                            return castSpell(enemiesTable[i].unit,self.spell.hammerOfWrath,false,false) == true or false
                        end
                    end
                end
            end

            function castHandOfSacrifice()
            -- Todo: We should add glyph check or health check, at the moment we assume the glyph
            -- Todo:  We should be able to config who to use as candidate, other tank, healer, based on debuffs etc.
            -- Todo: add check if target already have sacrifice buff
            -- Todo Is the talent handle correctly? 2 charges? CD starts but u have 2 charges
            -- This is returning false since its not proper designed yet. We need to have a list of scenarios when we should cast sacrifice, off tanking, dangerous debuffs/dots or high spike damage on someone.
                return false
            end

            -- Harsh Words(glyphed WoG)
            function protCore:castHarshWords()
                return castSpell(self.units.dyn40,self.spell.harshWords,false,false) == true or false
            end
            -- Holy Avenger
            function protCore:castHolyAvenger()
                if isSelected("Holy Avenger") then
                    if isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 400*UnitHealthMax(player)/100) then
                        if self.talent.seraphim and self.buff.seraphim or (not self.talent.seraphim and self.holyPower <= 2) then
                            return castSpell(player,self.spell.holyAvenger,true,false) == true or false
                        end
                    end
                end
            end

            -- Holy Prism
            function protCore:castHolyPrism()
                if self.melee16Yards >= 2 then
                    return castSpell(player,self.spell.holyPrism,true,false) == true or false
                else
                    return castSpell(self.units.dyn30,self.spell.holyPrism,false,false) == true or false
                end
            end

            -- Holy Wrath
            function protCore:castHolyWrath()
            	return (getDistance(player,self.units.dyn8AoE) < 8 and castSpell(player,self.spell.holyWrath,true,false) == true) or false
            end

            -- Jeopardy
            function protCore:castJeopardy()
                -- scan enemies for a different unit
                local enemiesTable = enemiesTable
                if #enemiesTable > 1 then
                    for i = 1, #enemiesTable do
                        local thisEnemy = enemiesTable[i]
                        -- if its in range
                        if thisEnemy.distance < 30 then
                            -- here i will need to compare my previous judgment target with the previous one
                            -- we declare a var in core updated by reader with last judged unit
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
            function protCore:castJudgment()
                return castSpell(self.units.dyn30AoE,self.spell.judgment,true,false) == true or false
            end

            -- Light's Hammer
            function protCore:castLightsHammer()
                if isSelected("Light's Hammer") then
                    local thisUnit = self.units.dyn30AoE
                    if UnitExists(thisUnit) and (isDummy(thisUnit) or not isMoving(thisUnit)) then
                        if getGround(thisUnit) then
                            return castGround(thisUnit,self.spell.lightsHammer,30) == true or false
                        end
                    end
                end
            end

			function protCore:castRighteousFury()
				if isChecked("Righteous Fury") then
					if not self.buff.righteousFury then
						return castSpell(player,self.spell.righteousFury,true,false) == true or false
					end
				end
				return false
			end

			function protCore:castSacredShield()
				return castSpell(player,self.spell.sacredShield,true,false) == true or false
			end

            -- Seals
            function protCore:castSeal(value)
                if value == 1 then
                    return castSpell(player,self.spell.sealOfThruth,true,false) == true or false
                elseif value == 2 then
                    return castSpell(player,self.spell.sealOfRighteousness,true,false) == true or false
                else
                    return castSpell(player,self.spell.sealOfInsight,true,false) == true or false
                end
            end

            -- Selfless Healer
            function protCore:castSelfLessHealer()
                if getBuffStacks(player,114250) == 3 then
                    if self.health <= getValue("Selfless Healer") then
                        return castSpell(player,self.spell.flashOfLight,true,false) == true or false
                    end
                end
            end

            -- Seraphim
            function protCore:castSeraphim()
                if self.talent.seraphim and self.holyPower == 5 then
                    if isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 400*UnitHealthMax(player)/100) then
                        return castSpell(player,self.spell.seraphim,true,false) == true or false
                    end
                end
            end

			function protCore:castShieldOfTheRighteous()
				return castSpell(self.units.dyn5,self.spell.shieldOfTheRighteous,false,false) == true or false
			end

            -- Word of glory
            function protCore:castWordOfGlory()
                if isChecked("Word Of Glory On Self") then
                    if self.health <= getValue("Word Of Glory On Self") then
                        if self.holyPower >= 3 or self.buff.divinePurpose then
                            return castSpell(player,self.spell.wordOfGlory,true,false) == true or false
                        end
                    end
                end
            end

            function protCore:paladinUtility()

                if getOptionCheck("Hand Of Freedom") then
                    if checkForDebuffThatIShouldRemovewithHoF("player") then -- Only doing it for me at the moment, todo: add party/friendly units
                        if castHandOfFreedom("player") then
                            return true
                        end
                    end
                end
                if castHandOfSacrifice() then
                    return true
                end
                if castHandOfSalvation() then
                    return true
                end
                -- Todo Blinding Light, Turn Evil, HoP, HoF etc, revive
            end

            function protCore:interrupt()
                -- we return as soon as we cast any interupt to avoid interupting more than once on same unit
                if #spellCastersTable > 1 then
                    local numberofcastersinrangeofarcanetorrent = 0
                    for i = 1, #spellCastersTable do
                        if spellCastersTable[i].distance < 8 then
                            numberofcastersinrangeofarcanetorrent = numberofcastersinrangeofarcanetorrent + 1
                        end
                    end
                    if numberofcastersinrangeofarcanetorrent > 1 and castArcaneTorrent() then
                        return true
                    end
                end

                if getOptionCheck("Avengers Shield Interrupt") then
                    if castInterrupt(self.spell.avengersShield,getValue("Avengers Shield Interrupt")) then
                        return true
                    end
                end

                if getOptionCheck("Rebuke") then
                    if castInterrupt(self.spell.rebuke,getValue("Rebuke")) then
                        return true
                    end
                end

                if getOptionCheck("Arcane Torrent Interrupt") then
                    if castInterrupt(self.spell.arcaneTorrent,getValue("Arcane Torrent Interrupt")) then
                        return true
                    end
                end
                --Todo: Add stuns(Justice, Holy Wrath, p)
            end


--[[
            function protCore:paladinControl(unit)
                -- If no unit then we should check autotargetting
                -- If the unit is a player controlled then assume pvp and always CC
                -- Otherwise check towards config, always or whitelist.
                -- we have the following CCs HammerOFJustice, Fist of Justice, Repentance, Blinding Light, Turn Evil, Holy Wrath
                -- We should be able to configure, always stun, stun based on whitelist, stun if low health, stun if target is casting/buffed
                if getOptionCheck("Crowd Control") then
                    if getValue("Crowd Control") == 1 then -- This is set to never but we should use the box tick for this so atm this is whitelist
                        --Todo: Create whitelist of mobs we are going to stun always
                        --Todo: Create whitelist of (de)buffs we are going to stun always or scenarios(more then x number of attackers
                    elseif getValue("Crowd Control") == 2 then -- This is set to to CD

                    elseif getValue("Crowd Control") == 3 then -- This is set to Always

                    end
                end
                if unit then

                end
                -- put auto logic here
                return false
            end
]]


        end
    end
end



--[[



	    	function protCore:paladinFriendlyUnitHandler()
	    		-- Handles freindly Units gathering -- nNova
	    		--ToDo here is where we should check out if there is any friendly unit that need to be handled in same way
	    		--	Hand of Protection if possible, Kargath chasing someone for example
	    		--	Hand of Sacrifice if raid member needs it, should be based on table for scenarios where we should cast Hand of Sacrifice, Kargaths Second Impale for example
	    		--	Hand of Salvation if someone have high threat, kind of useless since threat is not an issue at the moment, perhaps if taun is on CD or something and other tank is getting pounded
	    		-- 	Healing candidate based on low health, altough we need to be careful here since our heals are weak and cost HoPo and we can "heal" ourself better and let the healers heal the raid.
	    		--	Here is also the LayOnHands target. Including ourself
	    		--	Dispell targets



				-- ToDo:  find suitable target for healing friendly allies. x number of allies under y % of health.

				-- ToDo: Find dispell target

				return false
			end



			-- Functionality regarding interrupting target(s) spellcasting
			-- Rebuke is used if available and implemented as of now. This could be enhanced to use other spells for interrup
			-- returns of the cast is succesful or not.
			-- ToDos:  Add multiple interrupts such as binding light(if within 10 yards and facing, Fist of Justice(stuns), Avengers shield
			-- Should perhaps move out the spellCD and ranged outside canInterrupt?? So first check if range and cd is ok for cast, then check for timeframe?d


			function ProtPaladinSurvivalSelf() -- Check if we are close to dying and act accoridingly

				if getOptionCheck("Lay On Hands Self") and playerHP <= getValue("Lay On Hands Self") then
					if castLayOnHands("player") then
						return true
					end
				end
				if playerHP < 40 then
					 if useItem(5512) then -- Healthstone
					 	return true
					 end
				end
				return false
			end

			-- ProtPaladinSurvivalOther() -- Check if raidmember are close to dying and act accoridingly
			function ProtPaladinSurvivalOther()
				if enhancedLayOnHands() then
					return
				end
			end

			function ProtPaladinBuffs()
			-- Make sure that we are buffed, 2 modes, inCombat and Out Of Combat, Blessings, RF
				-- Righteous Fury
				if castRighteousFury() then
					return true
				end
				-- Blessings Logic here, incombat mode, self check or party/raid check
				-- Cast selected blessing or auto
				castBlessing()
				-- Seal Logic here, wait for emp seal logic to settle.
				-- Food checks, flask, etc

				return false
			end

			function  ProtPaladinDispell() -- Handling the dispelling self and party
				--canDispel(Unit,spellID)
				return false -- Return false until we have coded it
			end

			function ProtPaladinHolyPowerConsumers() -- Handle the use of HolyPower
				-- At the moment its hard to automate since SoR should be cast only if need be, ie large physical incoming damanage.
				-- Therefore the logic is just to automate default, ie at 5 HoPo Cast SoR and DP cast either WoG or SoR
				-- Only cast WoG if we are buffed with bastion of glory, base heal of 3 stacks is 11K(5% of hp)
				-- We should pool HP in able to use them when needed. However cast SoR on 5 HP, or DP or when low HP
				-- WE need also to see what damage since SoR is physical only.
				-- Should add logic, ie abilities we need to cast SoR for, Piercong armor in Skyreach fro example
				-- Todo: Add a event that read combatlog and populate incoming damage where we can track the last 10 damage to see if they are physical or magic in order to determine if we should use SoR
				if UnitBuffID("player", _DivinePurposeBuff) then  -- If we get free HP then use it on WoG if we are low health and have bastion of Glory stacks > 2, Todo Get correct values
					if getHP("player") < 50 and getBuffStacks("player", _BastionOfGlory) > 4 then
						if castWordOfGlory("player", 0, 1) then
							return false
						end
					end
					-- If we are not low health then we should use it on SoR
					if castShieldOfTheRighteous(dynamicUnit.dyn5, 5) then
						return false
					end
				end

				if getBuffStacks("player", _BastionOfGlory) > 4 then -- if we have bastion buff then we should use it
					if castWordOfGlory("player", 0, 3) then --cast if we are 70% and have HP
						return false
					end
				end

				if castShieldOfTheRighteous(dynamicUnit.dyn5, 5) then
					return false
				end
			end

			function ProtPaladinHolyPowerCreaters() -- Handle the normal rotatio
				-- If we have 3 targets for Avenger Shield and we have Grand Crusader Buff
				-- Todo : we need to check if AS will hit 3 targets, so what is the range of AS jump? We are usimg same logic as Hammer of Righ at the moment, 8 yard.
				if UnitBuffID("player", 85043) and numberOfTargetsForHammerOfRighteous > 2 then -- Grand Crusader buff, we use 8 yards from target as check
					if castAvengersShield(dynamicUnit.dyn30) then
						--print("Casting AS in AoE rotation with Grand Crusader procc")
						return true
					end
				end

				-- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
				--castStrike()
				if numberOfTargetsForHammerOfRighteous > 2 then
					if castHammerOfTheRighteous(dynamicUnit.dyn5) then
						--print("Casting Hammer")
						return true
					end
				end

				if numberOfTargetsForHammerOfRighteous < 3 then
					if castCrusaderStrike(dynamicUnit.dyn5) then
						--print("Casting Crusader")
						return true
					end
				end
				-- ToDo: -- wait,sec=cooldown.crusader_strike.remains,if=cooldown.crusader_strike.remains>0&cooldown.crusader_strike.remains<=0.35

				-- ToDo_ -- Add Double jeopardy
				if castJudgement(dynamicUnit.dyn30AoE) then
					--print("Casting Judgement")
					return true
				end
				-- ToDo: --wait,sec=cooldown.judgment.remains,if=cooldown.judgment.remains>0&cooldown.judgment.remains<=0.35

				-- ToDo --avengers_shield,if=active_enemies>1&!glyph.focused_shield.enabled
				-- ToDo --holy_wrath,if=talent.sanctified_wrath.enabled

				-- ToDo: --avengers_shield,if=active_enemies>1&!glyph.focused_shield.enabled , ie we should check if its glyphed or not.
				if numberOfTargetsForHammerOfRighteous > 1 then -- Grand Crusader buff, we use 8 yards from target as check
					if castAvengersShield(dynamicUnit.dyn30) then
						--print("Casting AS in AoE rotation with Grand Crusader procc")
						return true
					end
				end

				-- ToDo: --holy_wrath,if=talent.sanctified_wrath.enabled

				-- avengers_shield,if=buff.grand_crusader.react
				if UnitBuffID("player", 85043) then -- Grand Crusader buff if we are single target
					if castAvengersShield(dynamicUnit.dyn30) then
						--print("Casting AS in rotation with Grand Crusader procc")
						return true
					end
				end

				if castSacredShield(2) then
					return true
				end
				-- ToDo: --holy_wrath,if=talent.sanctified_wrath.enabled
				-- ToDo: --holy_wrath,if=glyph.final_wrath.enabled&target.health.pct<=20

				if castAvengersShield(dynamicUnit.dyn30) then
					--print("Casting lights Hammer in rotation")
					return true
				end
				-- Todo We could add functionality that cycle all unit to find one that is casting since the Avenger Shield is silencing as well.

				-- ToDo: We really should look into this with lights hammer. We should check how many mobs are around us and cast it earlier if there are more
				-- We should also really look into the healing aspect.
				-- ToDo: --lights_hammer,if=!talent.seraphim.enabled|buff.seraphim.remains>10|cooldown.seraphim.remains<6
				if isChecked("Light's Hammer") then
					if castLightsHammer(dynamicUnit.dyn5) then
						--print("Casting lights Hammer in rotation")
						return true
					end
				end

				-- Holy Prism, heal or aoe
				-- ToDo: Similiar to Lights Hammer, this can be improved, number of heals and enemies will give this a higher prio
				if isKnown(_HolyPrism) then
					castWiseAoEHeal(enemiesTable,114165,15,90,1,3,false,false)
					if meleeEnemies > 2 then
						castHolyPrism("player")
					end
				end


				-- We should cast concenration if more then 3 targets are getting hit
				-- TODO we need to understand the range of consentrations
				if meleeEnemies > 2 then
					if castConsecration(dynamicUnit.dyn5AoE) then
						--print("Casting AOE Consecration")
						return true
					end
				end

				--ToDo: --execution_sentence,if=!talent.seraphim.enabled|buff.seraphim.up|time<12


				if castHammerOfWrath(dynamicUnit.dyn30) then
					--print("Casting Hammer of Wrath")
					return true
				end

				if castSacredShield(8) then
					return true
				end

				-- Todo: Could use enhanced logic here, cluster of mobs, cluster of damaged friendlies etc
				if castHolyWrath(dynamicUnit.dyn5AoE) then
					--print("Casting Holy Wrath")
					return true
				end

				--Execution Sentence, simcraft

				if castHammerOfWrath(dynamicUnit.dyn30) then
					--print("Casting Hammer of Wrath")
					return true
				end

				if meleeEnemies > 0 then
					if castConsecration(dynamicUnit.dyn5AoE) then
						--print("Casting Consecration")
						return true
					end
				end

				if getTalent(7,1) then
					if sealSwitchProt() then -- For lvl 100 Emp Seals logicS
						return true
					end
				end

				-- holy_wrath from simcraft

				-- If we are waiting for CDs we can cast SS
				if castSacredShield(15) then
					return true
				end

				if getTalent(3,1) then  -- Self Less Healer
					if select(4, UnitBuff("player", _SelflessHealerBuff)) then  -- 4th oaram is count
						-- Todo: We should find friendly candidate to cast on
					end
				end

				if isKnown(_HolyPrism) then
					castHolyPrism(dynamicUnit.dyn30)
				end
			end
			]]