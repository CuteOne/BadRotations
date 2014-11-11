if select(3, UnitClass("player")) == 2 then
	function PaladinHoly()
	-- Init Holy specific funnctions, toggles and configs.
		if currentConfig ~= "Holy CodeMyLife" then
			PaladinHolyFunctions()
			PaladinHolyToggles()
			PaladinHolyOptions()
			currentConfig = "Holy CodeMyLife"
		end

		-- Locals Variables
		_HolyPower = UnitPower("player", 9)

		--[[Lowest]]
		lowestHP, lowestUnit, lowestTankHP, lowestTankUnit, averageHealth = 100, "player", 100, "player", 0

		-- We should get tankUnits so we have them both or one,
		-- tankOne, tankTwo(check if we have 2 ie party or raid), if we dont have roles assigned we should manually set the tank via keypress ie focus and right control
		-- We should be able to set high prio via mouseover and right modifier, ie shift or alt or a combination.
		-- We should be able to check specc for more accurate roles.
		-- local currentSpec = GetSpecialization()
		-- local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"
		-- print("Your current spec:", currentSpecName)
		-- local roleToken = GetSpecializationRole(specIndex[, isInspect[, isPet]])

		-- Beacon Tank or whoever will take alot of damage(heals 50% and FoL Holy light refund 40% mana)
		
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

		-- Food/Invis Check   Hm here we are checking if we should abort the rotation pulse due to if we are a vehicle or some stuff
		if canRun() ~= true or UnitInVehicle("Player") then
			return false
		end

		--[[Off GCD in combat]]
		if UnitAffectingCombat("player") then


		end

		--[[Off GCD out of combat]]







		if castingUnit() then
			return false;
		end

		--[[On GCD Out of Combat]]


-- blessing_of_kings,if=(!aura.str_agi_int.up)&(aura.mastery.up)
-- blessing_of_might,if=!aura.mastery.up
-- seal_of_insight
-- beacon_of_light,target=healing_target
		--[[Beacon Of Light]]
		
		--The first step is to place your Beacon of Light Icon Beacon of Light on players who are taking damage. Typically, this means placing it on the tank.
		

		-- Eternal Flame should be kept up on the tank currently taking damage, and on any other raid members who are taking damage. 
		-- You do not need to use Eternal Flame with 3 Holy Power, since the amount of Holy Power you use it with now only determines its duration (10 seconds per charge of Holy Power), and not its potency

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

		BeaconOfLight()

		--[[On GCD in combat]]
		if isInCombat("player") then

			--[[Auto Attack if in melee]]
			if isInMelee() and getFacing("player","target") == true then
				RunMacroText("/startattack")
			end







			-- auto_attack
			-- speed_of_light,if=movement.remains>1
			-- blood_fury
			-- berserking
			-- arcane_torrent
			-- avenging_wrath
			--[[Lay on Hands I like LoH in combat only because i do not like to waste it because a lock is running to his death.]]
			if getHP("player") <= getValue("Lay On Hands") then
				if castSpell("player",_LayOnHands,true) then
					return
				end
			else
				for i = 1, #nNova do
					if nNova[i].hp <= getValue("Lay On Hands") then
						if castSpell(nNova[1].unit,_LayOnHands,true) then
							return
						end
					end
				end
			end
			-- judgment,if=talent.selfless_healer.enabled&buff.selfless_healer.stack<3

			--[[_EternalFlame]]
			if isChecked("Word Of Glory") and WordOfGlory(getValue("Word Of Glory")) then
				return
			end

			--[[word_of_glory,if=holy_power>=3]]
			if isChecked("Eternal Flame") and EternalFlame(getValue("Eternal Flame")) then
				return
			end

			--[[holy_shock,if=holy_power<=3]]
			if isChecked("Holy Shock") and HolyShock(getValue("Holy Shock")) then return end

			--[[flash_of_light,if=target.health.pct<=30]]
			if isChecked("Flash Of Light") and FlashOfLight(getValue("Flash Of Light")) then return end

			--[[Holy Radiance]]
			if isChecked("HR Missing Health") then
				if castAoEHeal(_HolyRadiance, getValue("HR Units"), getValue("HR Missing Health"), 15) then return end
			end

			-- judgment,if=holy_power<3
			-- lay_on_hands,if=mana.pct<5
			--[[holy_light]]
			if isChecked("Holy Light") and HolyLight(getValue("Holy Light")) then return end

		end
	end
end