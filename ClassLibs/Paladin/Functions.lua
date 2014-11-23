if select(3,UnitClass("player")) == 2 then

	function Blessings()
		if UnitBuffID("player",144051) ~= nil then return false end
		local BlessingCount = 0
		for i = 1, #nNova do
			local _, MemberClass = select(2,UnitClass(nNova[i].unit))
			if UnitExists(nNova[i].unit) then
				if MemberClass ~= nil then
					if MemberClass == "DRUID" then BlessingCount = BlessingCount + 1 end
					if MemberClass == "MONK" then BlessingCount = BlessingCount + 1 end
					if MemberClass == "PALADIN" then BlessingCount = BlessingCount + 50 end
					if MemberClass == "SHAMAN" then BlessingCount = BlessingCount + 1000 end
				end
			end
		end
		if BlessingCount > 50 and BlessingCount < 1000 then
			MyBlessing = _BlessingOfMight
		else
			MyBlessing = _BlessingOfKings
		end
		if ActiveBlessingsValue == 2 then
			MyBlessing = _BlessingOfKings
		elseif ActiveBlessingsValue == 3 then
			MyBlessing = _BlessingOfMight
		end
		if MyBlessing == _BlessingOfMight and not Spells[_BlessingOfMight].known then MyBlessing = _BlessingOfKings end
		if MyBlessing == _BlessingOfKings and not Spells[_BlessingOfKings].known then BuffTimer = GetTime() + 600 return false end
		if BuffTimer == nil or BuffTimer < GetTime() then
			for i=1, #nNova do
				if not UnitBuffID(nNova[i].unit,MyBlessing) then
					BuffTimer = GetTime() + random(15,30);
					if castSpell("player",MyBlessing,true,false) then return; end
				end
			end
		end
	end

    function PaladinProtFunctions()

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
			if isChecked("Crowd Control") then
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
			if isChecked("Avengers Shield Interrupt") or isChecked("Rebuke") then
				makeSpellCastersTable()
			end
			if isChecked("Avengers Shield Interrupt") then
				castInterupt(_AvengersShield,getValue("Avengers Shield Interrupt"))
			end

			if isChecked("Rebuke") then 
				castInterupt(_Rebuke,getValue("Rebuke"))-- We should handle who to interrupt outside the castRebuke etc, hardocded to target atm
			end
			
			-- Should add Fist of Justice or other stuns/cc
			return false
		end


		function ProtPaladinSurvivalSelf() -- Check if we are close to dying and act accoridingly
			local playerHP = getHP("player")

			if castLayOnHands("player") then
				return true
			end

			--Should create a seperate function for this to make it generic

			if playerHP < 40 then
				 if useItem(5512) then -- Healthstone
				 	return true
				 end
				 if useItem(118006) then -- Shieldtronic Shield
				 	return true
				 end

				 if useItem(113143) then -- Glowing Honeycomb
				 	return true
				 end
			end

			return false
		end

		-- ProtPaladinSurvivalOther() -- Check if raidmember are close to dying and act accoridingly
		function ProtPaladinSurvivalOther()
			-- Lay on Hands
			-- It should be possible to set this so we only cast it on non tanks, or tanks or all.
			if castLayOnHands() then
				return true
			end
		end

		function ProtPaladinBuffs() -- Make sure that we are buffed, 2 modes, inCombat and Out Of Combat, Blessings, RF, -- ProtPaladinBuffs()
			-- Righteous Fury
			if castRighteousFury() then
				return true
			end
			-- Blessings Logic here, incombat mode, self check or party/raid check
			-- Seal Logic here, wait for emp seal logic to settle.
			-- Food checks, flask, etc

			return false
		end

		function  ProtPaladinDispell() -- Handling the dispelling self and party
			-- Defensive and offensive dispelling, ie debuffs or buffs
			--canDispel(Unit,spellID)
			return false -- Return false until we have coded it
		end
		-- ProtPaladinCooldowns() -- Handles the use of offensive Coolsdowns, ProtPaladinSurvival... handles the defensive.

		-- Todo: Create logic for when to use it, proccs or whatever
		-- 	Also toggle/configuration for more flexibility, at the moment its on or off

		function ProtPaladinEnemyUnitHandler() -- Handles Enemy Units gathering
			-- At the moment only populating table to see performance.
			makeEnemiesTable(40)-- Unit in 40 range
			--tinsert(enemiesTable,{ unit = thisUnit, distance = unitDistance, hp = unitHP })

			-- Make sure we declare our AoE treshold ASAP and refresh it every seconds
			if numberOfTargetsMelee == nil or numberOfTargetsMeleeTimer == nil or numberOfTargetsMeleeTimer <= GetTime() - 1 then
				numberOfTargetsMelee, numberOfTargetsMeleeTimer = getNumEnemies("player",4), GetTime()
			end

			if numberOfTargetsForHammerOfRighteuos == nil or numberOfTargetsForHammerOfRighteuosTimer == nil or numberOfTargetsForHammerOfRighteuosTimer <= GetTime() - 1 then
				numberOfTargetsForHammerOfRighteuos, numberOfTargetsForHammerOfRighteuosTimer = getNumEnemies("target",7), GetTime() --getNumEnemiesInRange("target",8)
			end
			return
		end


		function ProtPaladinFriendlyUnitHandler() -- Handles freindly Units gathering
			-- Using Novas table
			--print("Table has " ..#nNova)

			-- Todo: Check threat levels for each member and attack their  targets or cast HoSalv. Should we not just check enemies?
			-- Todo: Check for valed aoe heals target for lights hammer
			-- Todo: Checl targets for dispelling
			-- Todo Check targets for Hand Of Freedom
			-- Todo Check targets for Hand of Protection

			return
		end

		function ProtPaladinHolyPowerConsumers() -- Handle the use of HolyPower
			-- Only cast WoG if we are buffed with bastion of glory, base heal of 3 stacks is 11K(5% of hp)
			-- We should pool HP in able to use them when needed. However cast SoR on 5 HP, or DP or when low HP
			-- WE need also to see what damage since SoR is physical only.
			if UnitBuffID("player", _DivinePurposeBuff) then  -- If we get free HP then use it on WoG if we are low health and have bastion of Glory stacks > 2, Todo; Get correct values
				if getHP("player") < 50 and getBuffStacks("player", _BastionOfGlory) > 4 then
					if castWordOfGlory("player", 0, 1) then
						return true
					end
				end	
				-- If we are not low health then we should use it on SoR
				if castShieldOfTheRighteous("target", 5) then
					return true
				end
			end	
			
			if getBuffStacks("player", _BastionOfGlory) > 4 then -- if we have bastion buff then we should use it 
				if castWordOfGlory("player", 0, 3) then --cast if we are 70% and have HP
					return true
				end

				if castWordOfGlory("player", 40, 1) then --cast if we are 40% and have 1 HP
					return true
				end
			end

			if getHP("player") < 50 then
				if castShieldOfTheRighteous("target", 3) then
					return true
				end
			end				

			if castShieldOfTheRighteous("target", 5) then
				return true
			end
		end

		function ProtPaladinHolyPowerCreaters() -- Handle the normal rotation
			-- Todos: Talents, only light hammer is handled, Prism and Sentence is not
			-- Todos: Glyphs, we have no support for the Holy Wrath glyph which should put it higher on priority after Judgement.

			-- Seal Switching if we are waiting for CS or Judge CD
			-- seal_of_insight,if=talent.empowered_seals.enabled&!seal.insight&buff.uthers_insight.remains<cooldown.judgment.remains
			-- seal_of_righteousness,if=talent.empowered_seals.enabled&!seal.righteousness&buff.uthers_insight.remains>cooldown.judgment.remains&buff.liadrins_righteousness.down
			-- seal_of_truth,if=talent.empowered_seals.enabled&!seal.truth&buff.uthers_insight.remains>cooldown.judgment.remains&buff.liadrins_righteousness.remains>cooldown.judgment.remains&buff.maraads_truth.down


			-- If we have 3 targets for Avenger Shield and we have Grand Crusader Buff
			-- Todo : we need to check if AS will hit 3 targets, so what is the range of AS jump? We are usimg same logic as Hammer of Righ at the moment, 8 yard.
			if UnitBuffID("player", 85043) and numberOfTargetsForHammerOfRighteuos > 2 then -- Grand Crusader buff, we use 8 yards from target as check
				if castAvengersShield("target") then
					--print("Casting AS in AoE rotation with Grand Crusader procc")
					return true
				end
			end

			local strike = strike; -- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
			if BadBoy_data["AoE"] == 2 or (BadBoy_data["AoE"] == 3 and numberOfTargetsForHammerOfRighteuos > 2) or keyPressAoE then  --If Toggle to 2(AoE) or 3(Auto and more then 2 targets, its actually 4 but its just simplier to do aoe
				strike = _HammerOfTheRighteous;
			else
				strike = _CrusaderStrike;
			end

			-- Cast Crusader for Single and Hammer of Right if aoe
			if isInMelee() then
				if castSpell("target",strike,false,false) then
					return
				end
			end

			-- wait,sec=cooldown.crusader_strike.remains,if=cooldown.crusader_strike.remains>0&cooldown.crusader_strike.remains<=0.35

			if castJudgement("target") then
				--print("Casting Judgement")
				return true
			end

			--wait,sec=cooldown.judgment.remains,if=cooldown.judgment.remains>0&cooldown.judgment.remains<=0.35

			if numberOfTargetsForHammerOfRighteuos > 1 then -- Grand Crusader buff, we use 8 yards from target as check
				if castAvengersShield("target") then
					--print("Casting AS in AoE rotation with Grand Crusader procc")
					return true
				end
			end

			-- holy_wrath,if=talent.sanctified_wrath.enabled

			if UnitBuffID("player", 85043) then -- Grand Crusader buff if we are single target
				if castAvengersShield("target") then
					--print("Casting AS in rotation with Grand Crusader procc")
					return true
				end
			end

			if castSacredShield(2) then
				return true
			end

			-- holy_wrath,if=glyph.final_wrath.enabled&target.health.pct<=20

			if castAvengersShield("target") then
				--print("Casting lights Hammer in rotation")
				return true
			end
			-- Todo We could add functionality that cycle all unit to find one that is casting since the Avenger Shield is silencing as well.

			if castLightsHammer("target") then
				--print("Casting lights Hammer in rotation")
				return true
			end

			-- Holy Prism, simcraft

			-- We should cast concenration if more then 3 targets are getting hit
			-- TODO we need to understand the range of consentrations
			if numberOfTargetsMelee > 2 then
				if castConsecration("target") then
					--print("Casting AOE Consecration")
					return true
				end
			end

			if castHammerOfWrath("target") then
				--print("Casting Hammer of Wrath")
				return true
			end

			-- Todo: Could use enhanced logic here, cluster of mobs, cluster of damaged friendlies etc
			if castHolyWrath("target") then
				--print("Casting Holy Wrath")
				return true
			end
			
			--Execution Sentence, simcraft

			if castHammerOfWrath("target") then
				--print("Casting Hammer of Wrath")
				return true
			end

			if castSacredShield(8) then
				return true
			end

			if numberOfTargetsMelee > 0 then
				if castConsecration("target") then
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
		end

		function ProtPaladingHolyPowerCreatersAoE() -- Rotation that focus on AoE, should be done to pick up group of adds
			-- Todos: Talents, only light hammer is handled, Prism and Sentence is not

			if UnitBuffID("player", 85043) then -- Grand Crusader buff
				if castAvengersShield("target") then
					--print("Casting AS in AoE rotation with Grand CRusader procc")
					return true
				end
			end

			local strike = strike; -- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
			if BadBoy_data["AoE"] == 2 or (BadBoy_data["AoE"] == 3 and numberOfTargetsForHammerOfRighteuos > 2) or keyPressAoE then  --If Toggle to 2(AoE) or 3(Auto and more then 2 targets, its actually 4 but its just simplier to do aoe
				strike = _HammerOfTheRighteous;
			else
				strike = _CrusaderStrike;
			end

			-- Cast Crusader for Single and Hammer of Right if aoe, should check other targets for spell if not in melee
			if isInMelee("target") then
				if castSpell("target",strike,false,false) then
					return
				end
			end

			if castAvengersShield("target") then
				--print("Casting lights Hammer in AoE rotation")
				return true
			end
			-- Todo We could add functionality that cycle all unit to find one that is casting since the Avenger Shield is silencing as well.

			if castLightsHammer("target") then
				--print("Casting lights Hammer in AoE rotation")
				return true
			end

			if castHolyWrath("target") then
				--print("Casting AoE Holy Wrath")
				return true
			end

			if castConsecration("target") then
				--print("Casting AOE Consecration")
				return true
			end
			-- Todo, we could check number of mobs in melee ranged
		--Todo Check number of targets in range do Concentration and have it earlier.
		end
	end
--[[

Holy

]]	function PaladinHolyFunctions()

		-- Eternal Flame
		function EternalFlame(hpValue)
			if _HolyPower > 3 then
				for i = 1, #nNova do
					if (nNova[i].hp < hpValue and getBuffRemain(nNova[i].unit,_EternalFlame) < 5) or (nNova[i].hp < 100 and _HolyPower == 5 and getBuffRemain(nNova[i].unit,_EternalFlame) < 5) or nNova[i].hp < hpValue - 20 then
						if castSpell(nNova[i].unit, _EternalFlame, true, false) then return end
					end
				end
			end
		end
		-- Holy Light
		function HolyLight(hpValue)
			for i = 1, #nNova do
				if nNova[i].hp < hpValue then
					if castSpell(nNova[i].unit, _HolyLight, true, true) then return end
				end
			end
		end

		-- Flash Of Light
		function FlashOfLight(hpValue)
			for i = 1, #nNova do
				if nNova[i].hp < hpValue then
					if castSpell(nNova[i].unit, _FlashOfLight, true, true) then return end
				end
			end
		end

		-- Holy Shock
		function HolyShock(hpValue)
			if _HolyPower < 5 or lowestHP < 90 then
				for i = 1, #nNova do
					if nNova[i].hp < hpValue then
						if castSpell(nNova[i].unit, _HolyShock, true, false) then return end
					end
				end
			end
		end

		-- Word Of Glory
		function WordOfGlory(hpValue)
			if _HolyPower > 3 then
				for i = 1, #nNova do
					if nNova[i].hp < hpValue or (nNova[i].hp < 100 and _HolyPower == 5) then
						if castSpell(nNova[i].unit, _WordOfGlory, true, false) then return end
					end
				end
			end
		end

		-- Beacon Of Light
		function BeaconOfLight()
			local beaconTarget, beaconRole, beaconHP = "player", "HEALER", getHP("player")
			-- Find if we have any, note if its a tank.
			for i = 1, #nNova do
				if UnitBuffID(nNova[i].unit,_BeaconOfLight,"player") then
					beaconTarget, beaconRole, beaconHP = nNova[i].unit, nNova[i].role, nNova[i].hp
				end
			end
			-- if we are not beacon on a tank and on tanks is checked we find a proper tank if focus dont exists.
			if beaconRole ~= "TANK" then
				if UnitExists("focus") == true and UnitInRaid("focus") == true and UnitIsVisible("focus") then
					if castSpell("focus",_BeaconOfLight,true,false) then return end
				else
					for i = 1, #nNova do
						if nNova[i].role == "TANK" then
							if castSpell(nNova[i].unit,_BeaconOfLight,true,false) then return end
						end
					end
				end
			end
		end
	end
end