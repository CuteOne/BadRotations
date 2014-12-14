-- holy prism
-- in order to get the best results out of our holy prism for holy, we will need to calc best scenario of
-- 5 users in 15 yards around a given units that have the lowest hp

-- will first need to target a enemy unit then
	-- compare health to user selected treshold
	-- test its position agains mobs position and calc range(we need to find a way to refresh that only once per cast or something)
	-- add it to a table of valid units around a mob
	-- calc the table best results coefficients
	-- if it beat previous best table then we keep that new one
	-- table will look like
--	prismBestTable = {
--		coefficient = wise maths to find best case,
--		heavilyDamagedUnits = number of units under 30% hp,
--		missingHealthUnits = number of units under treshold,
--		totalmissingHealth = total health missing in range of unit,
--		unit = enemyFH tag
--	}
	-- function will need to find positions trought crossing x-y so we need to gather units positions
	-- we can get enemy position in enemiesTable and the players positions trought nNova


		--[[On GCD Out of Combat]]


-- blessing_of_kings,if=(!aura.str_agi_int.up)&(aura.mastery.up)
-- blessing_of_might,if=!aura.mastery.up
-- seal_of_insight
-- beacon_of_light,target=healing_target
--[[Beacon Of Light]]

-- The first step is to place your Beacon of Light Icon Beacon of Light on players who are taking damage. Typically,
-- this means placing it on the tank.

-- Eternal Flame should be kept up on the tank currently taking damage, and on any other raid members who are
-- taking damage. You do not need to use Eternal Flame with 3 Holy Power, since the amount of Holy Power you use
-- it with now only determines its duration (10 seconds per charge of Holy Power), and not its potency

-- Holy Light Icon Holy Light and Flash of Light Icon Flash of Light should be used to heal raid members,
-- and it is important to note that if used on your Beacon target, 40% of the Mana cost of these heals will be refunded to you (making them quite efficient).

-- To generate Holy Power, you will use Holy Shock Icon Holy Shock on cooldown on any players that need additional healing.
-- Additionally, you should use Crusader Strike Icon Crusader Strike for more Holy Power.

-- You should use Holy Radiance Icon Holy Radiance when there is raid damage, but you need to beware of depleting your Mana too quickly.

-- You can use Light of Dawn Icon Light of Dawn instead of Eternal Flame Icon Eternal Flame if there are at least 6 targets that will not be overhealed
-- (or at least, not too much) by it, although do note that if you are facing heavy raid damage, this may be insufficient.

-- Finally, it is worth noting that, since your Mastery triggers off of each tick of Eternal Flame,
-- it is a useful strategy to pre-HoT a target that you know will take damage so that an absorption shield can be built up on them.

-- If you are using Sacred Shield Icon Sacred Shield as your tier 3 talent, then the way in which you play changes somewhat.
-- Your Beacon should still be placed on the tank or on another player who is taking damage, just as above, but most of the rest of the playstyle changes.

-- You should always keep up Sacred Shield on two targets that are taking constant damage. This will mostly be the two tanks, but it can very depending on the encounter

-- Holy Light Icon Holy Light and Flash of Light Icon Flash of Light are still used for healing individual raid members that are low on health (including your Beacon targets),
-- while Holy Radiance Icon Holy Radiance should be used whenever there is raid damage (and this will also generate Holy Power).

-- For the rest of the Holy Power generation you should use Holy Shock Icon Holy Shock on cooldown, and Crusader Strike Icon Crusader Strike whenever possible.
-- Your Holy Power should be spent almost exclusively on Light of Dawn Icon Light of Dawn.
-- You can use Word of Glory Icon Word of Glory if there is a single target in need of healing, but in every other situation Light of Dawn is stronger.

-- Daybreak Icon Daybreak, a passive ability, causes your Holy Radiance Icon Holy Radiance casts to make your next Holy Shock Icon Holy Shock (including multistrikes) heal up to 6 players
-- in an area around the target for 15% of the original healing. in addition to healing the target itself. You can have up to two Daybreak charges at one time.
-- This proc is very useful, since you should only be using Holy Radiance on players who are near other players, and only during times when you want to do AoE healing.
-- Therefore, it is very easy to simply use the Holy Shock on the same person you used Holy Radiance on. You can, of course, use it on other players for different reasons.

-- snapshot_stats

if select(3, UnitClass("player")) == 2 then
	function PaladinHoly()
	-- Init Holy specific funnctions, toggles and configs.
		if currentConfig ~= "Holy Gabbz & CML" then
			PaladinHolyFunctions()
			PaladinHolyToggles()
			PaladinHolyOptions()
			currentConfig = "Holy Gabbz & CML"
		end

		-- Locals Variables
		_HolyPower = UnitPower("player", 9)

		-- We should start with analysing who to heal so we know what todo later
		--	We should get all tanks and have them
		-- 	Then lowest non tank
		-- 	Then best AoE Heal candidate, for each possible spell we have, Light Of Dawn, Holy Radiance and Holy Shock with Daybreak.
		-- 	Then we need to see who we have beaconed
		--	Then we need to get dispell targets.

		-- 	We should calcualte best healing options and considere mana levels
		-- What different healing roles can we have
		--	Tank healer, beacon on both tanks and heal them or if they are above 90 heal lowest raid unit.
		--		When tanks are getting lower then we switch to heal them
		-- How do we handle beacons, so if we have light and faith, if one of them are full health and we are healing a non tank? 
		-- If we switch beacon it cost 1K mana but we heal for 50%
		-- We start with tank healing, ie beacon on both tanks, heal raid if tanks are above a configured value in options, if below start focusing on tanks.
		--[[Lowest]]

		lowestHP, lowestUnit, lowestTankHP, lowestTankUnit, highestTankHP, highestTankUnit, averageHealth = 100, "player", 100, "player", 100, "player", 0
		
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

		--[[Set Main Healing Tank]]
		if IsLeftAltKeyDown() then -- Set focus, ie primary healing target with left alt and mouseover target
			if UnitIsFriend("player","mouseover") and not UnitIsDeadOrGhost("mouseover") then
				RunMacroText("/focus mouseover")
			end
		end
		local favoriteTank = { name = "NONE" , health = 0}
		if UnitIsDeadOrGhost("focus") then
			if favoriteTank.name ~= "NONE" then
				favoriteTank = { name = "NONE" , health = 0}
				ClearFocus()
			end
		end
		if UnitExists("focus") == nil and favoriteTank.name == "NONE" then
			for i = 1, # nNova do
				if UnitIsDeadOrGhost("focus") == nil and nNova[i].role == "TANK" and UnitHealthMax(nNova[i].unit) > favoriteTank.health then
					favoriteTank = { name = UnitName(nNova[i].unit), health = UnitHealthMax(nNova[i].unit) }
					RunMacroText("/focus "..favoriteTank.name)
				end
			end
		end

		-- Food/Invis Check   Hm here we are checking if we should abort the rotation pulse due to if we are a vehicle or some stuff
		if canRun() ~= true or UnitInVehicle("Player") then
			return false
		end

		if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
			return true
		end

		--[[Off GCD in combat]]
		if UnitAffectingCombat("player") or IsLeftControlKeyDown() then -- Only heal if we are in combat or if left control is down for out of combat rotation
			if castingUnit() then -- Do not interrupt if we are already casting
				return false
			end

			if BeaconOfLight() then 	-- Set Beacon of Light and faith on correct target
				return true
			end

			if not UnitAffectingCombat("player") then
				if preCombatHandlingHoly() then
					return true
				end
			end

			if castDispell() then
				return true
			end

			--[[Auto Attack if in melee]]
			if isInMelee() and getFacing("player","target") == true then
				RunMacroText("/startattack")
			end

			--Todo: Layon hands is just values, we need to add logic regarding who
			if castLayOnHands() then
				return true
			end

			--if unit is critical low 
			--	Holy Light if we have Infusion of Light buff
			--	Holy Shock on CD
			--	Flash of Light and do a beacon switch?
			-- Todo: Need to set this in options
			if lowestTankHP < getValue("Critical Health Level") or lowestHP < getValue("Critical Health Level") then
				if UnitBuffID("player",_InfusionOfLight) then
					if castHolyLight(40) then
						return true
					end
				end
				if canCast(_HolyShock) then
					if castHolyShock(nil, 40) then
						return true
					end
				end
				if castFlashOfLight(nil, 40) then
					return true
				end
			end

			-- AoE healing
			 if castAoEHeals() then
			 	return true
			 end

			--[[holy_shock,if=holy_power<=3]] -- Should add not cast if 5 HoPo
			if getOptionCheck("Holy Shock") and _HolyPower < 5 and castHolyShock(nil, getValue("Holy Shock"))  then
				return true
			end

			--Todo Need to add a check if we have 5 then use it
			if getOptionCheck("Eternal Flame") and castEternalFlame(getValue("Eternal Flame")) then
				return true
			end

			--[[flash_of_light,if=target.health.pct<=30]]
			if isChecked("Flash Of Light") and castFlashOfLight(nil, getValue("Flash Of Light")) then
				return true
			end

			if getOptionCheck("Holy Prism") and HolyPrism(getValue("Holy Prism")) then
				return true
			end

			if getOptionCheck("Holy Light") and castHolyLight(getValue("Holy Light")) then
				return true
			end
			-- Crusader strik for HoPo
		end
	end
end