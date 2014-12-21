if select(3,UnitClass("player")) == 2 then

	

    function PaladinProtFunctions()

    	function ProtPaladinEnemyUnitHandler() -- Handles Enemy Units gathering
			-- check if target is safe or if u need to switch

			dynamicUnit = {
				dyn5 = dynamicTarget(5,true),
				dyn5AoE = dynamicTarget(5,false), --ToDo: This is nothing to do with AoE, its facing or not. We should add a true AoE candidate to dynamicTargetting
				dyn8AoE = dynamicTarget(8,false),
				dyn30 = dynamicTarget(30,true),
				dyn30AoE = dynamicTarget(30,false),
				dyn40AoE = dynamicTarget(30,false),
			}

			meleeEnemies = #getEnemies("player", 5)

			--Todo: Do we need to pulse this? Is that not already done in the enemies engine?
			-- ToDo: we are here only checking the already define best melee target, that is of course almost always the same as as all melee but we should check for the best hammer of righoues on all enemies in melee
			if numberOfTargetsForHammerOfRighteous == nil or numberOfTargetsForHammerOfRighteousTimer == nil or numberOfTargetsForHammerOfRighteousTimer <= GetTime() - 1 then
				numberOfTargetsForHammerOfRighteous, numberOfTargetsForHammerOfRighteousTimer = #getEnemies(dynamicUnit.dyn5,7), GetTime() --getNumEnemiesInRange("target",8)
			end

			--Todo: Add glyphed logic, is targetted on ground.
			if numberOfTargetsForConsecration == nil or numberOfTargetsForConsecrationTimer == nil or numberOfTargetsForConsecrationTimer <= GetTime() - 1 then
				numberOfTargetsForConsecration, numberOfTargetsForConsecrationTimer = #getEnemies("player",9), GetTime() --getNumEnemiesInRange("target",8)
			end

			-- Todo: Add number of  mobs getting stunned?
			if numberOfTargetsForHolyWrath == nil or numberOfTargetsForHolyWrathTimer == nil or numberOfTargetsForHolyWrathTimer <= GetTime() - 1 then
				numberOfTargetsForHolyWrath, numberOfTargetsForHolyWrathTimer = #getEnemies("player",10), GetTime() --getNumEnemiesInRange("target",8)
			end

			-- Todo: Add dynamic unit to check for, ie best aoe spot to drop it At the moment its just on player
			if numberOfTargetsForLightsHammer == nil or numberOfTargetsForLightsHammerTimer == nil or numberOfTargetsForLightsHammerTimer <= GetTime() - 1 then
				numberOfTargetsForLightsHammer, numberOfTargetsForLightsHammerTimer = #getEnemies("player",10), GetTime() --getNumEnemiesInRange("target",8)
			end

			--Todo: Do the same for 
			-- 	Holy Prism, healing melee friends
			--	Hammer of Wrath, need to check low health targets, first on all dynamic, then perhaps scan the enemies table. 
			-- 	Word Of Glory if glyphed, but should we spend HoPo on dps? If the encounter  is trivila or if we are offtanking?
			
			--Todo: Add in ability specefic targets based on dynamic ones.ie under HP, if not having buff etc

			if not isSafeToAttack("target") then
			end

			if  isBurnTarget("target") > 0 then
			end
			
			return true
		end
    	function ProtPaladinFriendlyUnitHandler() -- Handles freindly Units gathering
    		--ToDo here is where we should check out if there is any friendly unit that need to be handled in same way
    		--	Hand of Protection if possible, Kargath chasing someone for example
    		--	Hand of Sacrifice if raid member needs it, should be based on table for scenarios where we should cast Hand of Sacrifice, Kargaths Second Impale for example
    		--	Hand of Salvation if someone have high threat, kind of useless since threat is not an issue at the moment, perhaps if taun is on CD or something and other tank is getting pounded
    		-- 	Healing candidate based on low health, altough we need to be careful here since our heals are weak and cost HoPo and we can "heal" ourself better and let the healers heal the raid.
    		--		Here is also the LayOnHands target. Including ourself
    		--	Dispell targets
    		
    		-- Generic Lowest Tank and Raider
    		for i = 1, #nNova do
				if nNova[i].role == "TANK" then
					if nNova[i].hp < lowestTankHP then
						lowestTankHP = nNova[i].hp
						lowestTankUnit = nNova[i].unit
					end
				end
				if nNova[i].hp < lowestHP then
					lowestHP = nNova[i].hp
					lowestUnit = nNova[i].unit
				end
				averageHealth = averageHealth + nNova[i].hp
			end
			averageHealth = averageHealth/#nNova

			--iterate one more time to get highest hp tank
			for i = 1, #nNova do
				if nNova[i].role == "TANK" then
					if nNova[i].unit ~= lowestTankUnit then
						highestTankHP = nNova[i].hp
						highestTankUnit = nNova[i].unit
					end
				end
			end

			-- ToDo:  find suitable target for healing friendly allies. x number of allies under y % of health.

			-- ToDo: Find dispell target



			return false
		end
    	-- Logic to seal Switch if we have the talent
    	function sealSwitchProt()
    		return false
    		-- seal_of_insight,if=talent.empowered_seals.enabled&!seal.insight&buff.uthers_insight.remains<=buff.liadrins_righteousness.remains&buff.uthers_insight.remains<=buff.maraads_truth.remains
    		-- seal_of_righteousness,if=talent.empowered_seals.enabled&!seal.righteousness&buff.liadrins_righteousness.remains<=buff.uthers_insight.remains&buff.liadrins_righteousness.remains<=buff.maraads_truth.remains
    		-- seal_of_truth,if=talent.empowered_seals.enabled&!seal.truth&buff.maraads_truth.remains<buff.uthers_insight.remains&buff.maraads_truth.remains<buff.liadrins_righteousness.remains
    	end

		function ProtPaladinControl(unit)
			--If no unit then we should check autotargetting
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

		function ProtPaladinUtility()

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

		-- Functionality regarding interrupting target(s) spellcasting
		-- Rebuke is used if available and implemented as of now. This could be enhanced to use other spells for interrup
		-- returns of the cast is succesful or not.
		-- ToDos:  Add multiple interrupts such as binding light(if within 10 yards and facing, Fist of Justice(stuns), Avengers shield
		-- Should perhaps move out the spellCD and ranged outside canInterrupt?? So first check if range and cd is ok for cast, then check for timeframe?d
		function ProtPaladinInterrupt()

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
				if castInterrupt(_AvengersShield,getValue("Avengers Shield Interrupt")) then
					return true
				end
			end

			if getOptionCheck("Rebuke") then
				if castInterrupt(_Rebuke,getValue("Rebuke")) then
					return true
				end
			end

			if getOptionCheck("Arcane Torrent Interrupt") then
				if castInterrupt(_ArcaneTorrent,getValue("Arcane Torrent Interrupt")) then
					return true
				end
			end
			--Todo: Add stuns(Justice, Holy Wrath, p)
			return false
		end


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
					print("Casting Hammer")
					return true
				end
			end

			if numberOfTargetsForHammerOfRighteous < 3 then
				if castCrusaderStrike(dynamicUnit.dyn5) then
					print("Casting Crusader")
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
	end
end

