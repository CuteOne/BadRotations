if select(3, UnitClass("player")) == 7 then
-- Rotation
function ShamanElemental()
	if currentConfig ~= "Elemental CodeMyLife" then
		ElementalConfig();
		ElementalToggles();
		currentConfig = "Elemental CodeMyLife";
	end

	-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then waitForPetToAppear = nil; return false; end

	-- Wind Shear
	if isChecked("Wind Shear") and UnitAffectingCombat("player") then
		if canInterrupt(_WindShear, tonumber(BadBoy_data["Box Wind Shear"])) and getDistance("player","target") <= 25 then
			castSpell("target",_WindShear,false);
		end
	end

--[[ 	-- On GCD After here
]]

	if isCasting() then return false; end

	-- Astral Shift if < 30%
	if BadBoy_data["Check Astral Shift"] == 1 and getHP("player") <= BadBoy_data["Box Astral Shift"] then
		if castSpell("player",_AstralShift,true) then return; end
	end
	-- Healing Stream if < 50%
	if BadBoy_data["Check Healing Stream"] == 1 and getHP("player") <= BadBoy_data["Box Healing Stream"] then
		if castSpell("player",_HealingStream,true) then return; end
	end
	-- Shamanistic Rage if < 80%
	if BadBoy_data["Check Shamanistic Rage"] == 1 and getHP("player") <= BadBoy_data["Box Shamanistic Rage"] then
		if castSpell("player",_ShamanisticRage,true) then return; end
	end

	-- snapshot_stats
	-- jade_serpent_potion

	-- flametongue_weapon,weapon=main
	if isChecked("Flametongue Weapon") and GetWeaponEnchantInfo() ~= 1 then 
		if castSpell("player",_FlametongueWeapon,true) then return; end
	end

	-- lightning_shield,if=!buff.lightning_shield.up
	if isChecked("Lightning Shield") and UnitBuffID("player",_LightningShield) == nil then
		if castSpell("player",_LightningShield,true) then return; end
	end



--[[ 	-- Combats Starts Here
]]

	if isInCombat("player") then

		if isAlive() and (isEnnemy() or isDummy("target")) and getLineOfSight("player","target") == true and getFacing("player","target") == true then

			-- jade_serpent_potion,if=time>60&(pet.primal_fire_elemental.active|pet.greater_fire_elemental.active|target.time_to_die<=60)
			-- berserking,if=!buff.bloodlust.up&!buff.elemental_mastery.up&(set_bonus.tier15_4pc_caster=1|(buff.ascendance.cooldown_remains=0&(dot.flame_shock.remains>buff.ascendance.duration|level<87)))
			-- blood_fury,if=buff.bloodlust.up|buff.ascendance.up|((cooldown.ascendance.remains>10|level<87)&cooldown.fire_elemental_totem.remains>10)
			-- arcane_torrent

			-- stormlash_totem,if=!active&!buff.stormlash.up&(buff.bloodlust.up|time>=60)
			if isSelected("Stormlash Totem") and not isAirTotem(_StormlashTotem) and UnitBuffID("player",120676) == nil then
				if castSpell("player",_StormlashTotem,true) then return; end
			end

			-- elemental_mastery,if=talent.elemental_mastery.enabled&(time>15&((!buff.bloodlust.up&time<120)|(!buff.berserking.up&!buff.bloodlust.up&buff.ascendance.up)|(time>=200&(cooldown.ascendance.remains>30|level<87))))
			if castSpell("player",_ElementalMastery,true) and UnitBuffID("player",_AscendanceBuff) == nil then return; end

			-- ancestral_swiftness,if=talent.ancestral_swiftness.enabled&!buff.ascendance.up
			if castSpell("player",_AncestralSwiftness,true) and UnitBuffID("player",_AscendanceBuff) == nil then return; end

			-- fire_elemental_totem,if=!active
			if isSelected("Fire Elemental") and not isFireTotem(_FireElementalTotem) then
				if castSpell("player",_FireElementalTotem,true) then return; end
			end	

			-- ascendance,if=active_enemies>1|(dot.flame_shock.remains>buff.ascendance.duration&(target.time_to_die<20|buff.bloodlust.up|time>=60)&cooldown.lava_burst.remains>0)
			if isSelected("Ascendance") and getDebuffRemain("target",_FlameShock) > 15 and getSpellCD(_LavaBurst) > 1 and UnitBuffID("player",_AscendanceBuff) == nil then
				if castSpell("player",_Ascendance,true) then return; end
			end

			local numEnnemies = getNumEnnemies("target",10)
			if BadBoy_data["AoE"] == 3 and numEnnemies > 1 or BadBoy_data["AoE"] == 2 then

--[[			#Multi target action priority list
]]
				-- lava_beam,if=buff.ascendance.up
				if UnitBuffID("player",_AscendanceBuff) ~= nil then
					if castSpell("target",_LavaBeam,false) then return; end
				end

				-- magma_totem,if=active_enemies>2&!totem.fire.active
				if  (not (hasMagma() or hasFireElemental()) or (hasMagma() and getTotemDistance("target") > 8)) and targetDistance<8 and getNumEnnemies("player",8) > 2 and isInCombat("player") then
					if castSpell("player",_MagmaTotem,true) then return; end
				end

				-- lava_burst,if=active_enemies<3&dot.flame_shock.remains>cast_time&cooldown_react
				if numEnnemies == 2 and getDebuffRemain("target",_FlameShock) > select(7,GetSpellInfo(_LavaBurst))/1000 and getSpellCD(_LavaBurst) == 0 then
					if castSpell("target",_LavaBurst,false) then return; end
				end

				-- flame_shock,if=ticks_remain<2
				if getDebuffRemain("target",_FlameShock) < 2 then
					if castSpell("target",_FlameShock,false) then return; end
				end	

				-- flame_shock,cycle_targets=1,if=!ticking&active_enemies<3
				if numEnnemies == 2 then
					for i = 1, GetTotalObjects(TYPE_UNIT) do
						local Guid = IGetObjectListEntry(i)
						ISetAsUnitID(Guid,"thisUnit");
						if getFacing("player","thisUnit") == true
							and getDebuffRemain("thisUnit",_FlameShock) < 3
							and (UnitHealth("thisUnit") >= (150*UnitHealth("player")/100)*(GetNumGroupMembers()+1) or isDummy("thisUnit"))
						then
							if castSpell("thisUnit",_FlameShock,false) then return; end								
						end
					end
				end				

				-- earthquake,if=active_enemies>4
				if isSelected("EarthQuake") and numEnnemies > 4 then
					if getGround("target") == true and isMoving("target") == false and (isDummy("target") or (getDistance("target","targettarget") <= 5 and UnitHealth("target")*numEnnemies >= 150*UnitHealthMax("player")/100)) then
						if castGround("target",_Earthquake,40) then return; end
					end
				end

				-- thunderstorm,if=mana.pct_nonproc<80
				if isSelected("Thunderstorm") and getMana("player") < 75 then
					if castSpell("player",_Thunderstorm,false) then return; end
				end	

				-- chain_lightning,if=mana.pct_nonproc>10
				if castSpell("target",_ChainLightning,false) then return; end

				-- lightning_bolt
				if castSpell("target",_LightningBolt,false) then return; end

			end

--[[		# Single target action priority list
]]
			-- use_item,name=grips_of_tidal_force,if=((cooldown.ascendance.remains>10|level<87)&cooldown.fire_elemental_totem.remains>10)|buff.ascendance.up|buff.bloodlust.up|totem.fire_elemental_totem.active

			-- unleash_elements,if=talent.unleashed_fury.enabled&!buff.ascendance.up
			if isSelected("Unleash Element") and isKnown(_UnleashElements) and UnitBuffID("player",_Ascendance) == nil then
				if castSpell("target",_UnleashElements,false) then return; end
			end

			-- spiritwalkers_grace,moving=1,if=buff.ascendance.up
			if isMoving("player") and UnitBuffID("player",_Ascendance) ~= nil then
				if castSpell("player",_SpiritwalkersGrace,true) then return; end
			end

			-- lava_burst,if=dot.flame_shock.remains>cast_time&(buff.ascendance.up|cooldown_react)
			if getDebuffRemain("target",_FlameShock) > select(7,GetSpellInfo(_LavaBurst))/1000 and 
				(UnitBuffID("player",_AscendanceBuff) ~= nil or getSpellCD(_LavaBurst) == 0) then
				if castSpell("target",_LavaBurst,false) then return; end
			end

			-- flame_shock,if=ticks_remain<2
			if getDebuffRemain("target",_FlameShock) < 2 then
				if castSpell("target",_FlameShock,false) then return; end
			end		

			-- elemental_blast,if=talent.elemental_blast.enabled
			if isKnown(_ElementalBlast) then
				if castSpell("target",_ElementalBlast,false) then return; end
			end

			---- # Use Earth Shock if Lightning Shield is at max (7) charges
			-- earth_shock,if=buff.lightning_shield.react=buff.lightning_shield.max_stack
			if getBuffStacks("player",_LightningShield) == 7 then
				if castSpell("target",_EarthShock,false) then return; end
			end		

			---- # Use Earth Shock if Lightning Shield is above 3 charges and the Flame Shock remaining duration is longer than the shock cooldown but shorter than shock cooldown + tick time interval
			-- earth_shock,if=buff.lightning_shield.react>3&dot.flame_shock.remains>cooldown&dot.flame_shock.remains<cooldown+action.flame_shock.tick_time
			if getBuffStacks("player",_LightningShield) > 3 and getDebuffRemain("target",_FlameShock) > 7 then
				if castSpell("target",_EarthShock,false) then return; end
			end	

			---- # After the initial Ascendance, use Flame Shock pre-emptively just before Ascendance to guarantee Flame Shock staying up for the full duration of the Ascendance buff
			-- flame_shock,if=time>60&remains<=buff.ascendance.duration&cooldown.ascendance.remains+buff.ascendance.duration<duration
			if getSpellCD(_Ascendance) < 12 and getDebuffRemain("target",_FlameShock) < getSpellCD(_Ascendance) + 15 then
				if castSpell("target",_FlameShock,false) then return; end
			end			

			-- earth_elemental_totem,if=!active&cooldown.fire_elemental_totem.remains>=60
			if getSpellCD(_FireElementalTotem) > 60 then
				if castSpell("player",_FlameShock,false) then return; end
			end		

			---- # Keep Searing Totem up, unless Fire Elemental Totem is coming off cooldown in the next 20 seconds
			-- searing_totem,if=cooldown.fire_elemental_totem.remains>20&!totem.fire.active
			if isFireTotem(_FireElementalTotem) == false and (isFireTotem(_SearingTotem) == false or getTotemDistance("target") > 25) and getDistance("target") <= 25 and (isSelected("Fire Elemental") ~= true or GetSpellCD(_FireElementalTotem) > 20) then
				if castSpell("player",_SearingTotem,true) then return; end
			end	

			-- spiritwalkers_grace,moving=1,if=((talent.elemental_blast.enabled&cooldown.elemental_blast.remains=0)|(cooldown.lava_burst.remains=0&!buff.lava_surge.react))|(buff.raid_movement.duration>=action.unleash_elements.gcd+action.earth_shock.gcd)
			if isMoving("player") and (GetSpellCD(_ElementalBlast) == 0 or GetSpellCD(_LavaBurst) == 0) then
				if castSpell("player",_SpiritwalkersGrace,true) then return; end
			end

			-- thunderstorm,if=mana.pct_nonproc<80
			if isSelected("Thunderstorm") and getMana("player") < 75 then
				if castSpell("player",_Thunderstorm,false) then return; end
			end	
			
			-- lightning_bolt
			if castSpell("target",_LightningBolt,false,false) then return; end
		end
	end
end
end