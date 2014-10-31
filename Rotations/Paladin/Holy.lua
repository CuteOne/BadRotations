if select(3, UnitClass("player")) == 2 then
	function PaladinHoly()
	-- Init Holy specific funnctions, toggles and configs.
		if currentConfig ~= "Holy CodeMyLife" then
			PaladinHolyFunctions();
			PaladinHolyToggles();
			PaladinHolyOptions();
			currentConfig = "Holy CodeMyLife";
		end

		-- Locals Variables
		_HolyPower = UnitPower("player", 9);

		--[[Lowest]]
		lowestHP, lowestUnit, lowestTankHP, lowestTankUnit, averageHealth = 100, "player", 100, "player", 0;
		for i = 1, #nNova do
			if nNova[i].role == "TANK" then
				if nNova[i].hp < lowestTankHP then
					lowestTankHP = nNova[i].hp;
					lowestTankUnit = nNova[i].unit;
				end
			end
			if nNova[i].hp < lowestHP then
				lowestHP = nNova[i].hp;
				lowestUnit = nNova[i].unit;
			end
			averageHealth = averageHealth + nNova[i].hp;
		end
		averageHealth = averageHealth/#nNova;

		-- Food/Invis Check   Hm here we are checking if we should abort the rotation pulse due to if we are a vehicle or some stuff
		if canRun() ~= true or UnitInVehicle("Player") then
			return false;
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






-- snapshot_stats

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
			-- word_of_glory,if=holy_power>=3
			if isChecked("Word Of Glory") and WordOfGlory(getValue("Word Of Glory")) then return end
			-- wait,if=target.health.pct>=75&mana.pct<=10

			--[[holy_shock,if=holy_power<=3]]
			if isChecked("Holy Shock") and HolyShock(getValue("Holy Shock")) then return end

			--[[flash_of_light,if=target.health.pct<=30]]
			if isChecked("Falsh Of Light") and FlashOfLight(getValue("Falsh Of Light")) then return end
			--[[Holy Radiance]]
			if isChecked("Holy Radiance Health") then
				if castAoEHeal(_HolyRadiance, getValue("Holy Radiance Units"), getValue("Holy Radiance Health"), 15) then return end
			end
			-- judgment,if=holy_power<3
			-- lay_on_hands,if=mana.pct<5
			--[[holy_light]]
			if isChecked("Holy Light") and HolyLight(getValue("Holy Light")) then return end

		end
	end
end