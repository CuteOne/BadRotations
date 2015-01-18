-- Todo : It seems that sometimes FrozenBomb is not cast altough it meets the requirements such as 2 FoF
-- Todo : When we pause BB we should make sure the pet is put on passive.
-- Todo : We need to figure out how to handle the pet, how do we set him in BB to active and passive?
-- Todo : We should not do anything OOC unless we manually overide, like with a modifier, in order to not look like a bot
-- Todo : We need to add a prepull logic that would start casting something and then, prepot
-- Todo : Falling logic, we should somewhere place Slow Fall
-- Todo : Spellsteal, not only as dispell enrages but also get buffed
-- Todo : we need to make sure to align the pet casting water jet and us casting frostbolt
-- Todo : We need to create a WaterJet/FrostBomb target to be used when doing waterjet actions
-- Todo : We need to fix the WaterJet action and rotation
-- Todo : We need to handle facing logic for Frozen Orb
-- Todo : Spells to implement
--			: Ice Floes, talent, need to check how it works, 3 charges, 20 sec recharge, cast while moving.
--			: Evanesce, talent, 3 sec immunity(replaces IceBlock) and is possible to remove CD with Ice Snap for 6 seconds immunity in defensive function
--			: Ice Barrier, talent which could be cast as lowest prio before moving and ice lance, different options, always on or as filler. More advanced to cast based on unit/spell
--			: Flameglow, talent, always on and should be activated pre pull if existing, only for fights with alot of aoe damage.
--			: Alter Time, talent, manual cast since it is very hard to code correctly
--			: IceWard, talent, freezes 3 attacker close to friendly target
--			: FrostJaw, talent, interrupt and stun.
--			: Frostbomb, talent, places 

if select(3, UnitClass("player")) == 8 then

	function FrostMage()
		if currentConfig ~= "Frost ragnar" then
			FrostMageConfig()
			FrostMageToggles()
			currentConfig = "Frost ragnar"
		end

		-- Manual Input
		if IsLeftShiftKeyDown() or IsLeftAltKeyDown() or not canRun then -- Pause the script, keybind in wow shift+1 etc for manual cast
			return true
		end
		
		if not UnitAffectingCombat("player") and IsLeftControlKeyDown() then -- If we are OOC we can use left shift to auto prepull
			
			------------
			-- CHECKS --
			------------
			-- Pet active/passive
			-- check if pet is dead
			if not UnitExists("pet") and isChecked("Auto Summon Pet") then
				if castSpell("player",SummonPet,true,true) then
					return true
				end
			end
			-- Petpassive, Petagressive
			if getOptionCheck("Start/Stop BadBoy") then
				if IsPetAttackActive() == true then
					RunMacroText("/petpassive")
					return true
				end
			end
			if getOptionCheck("Start/Stop BadBoy") then
				if select(5,GetPetActionInfo(8)) == false then
					RunMacroText("/petassist")
					return true
				end
			end

			--Ice barrier should be up when solo PvE
			if not UnitBuffID("player",IceBarrier)  then -- Ice barrier
				if castSpell("player",IceBarrier,false,false) then 
					return true
				end
			end

			-- Todo : Buff with Arcane Brilliance on all
			if isChecked("Arcane Brilliance") then
				if not isBuffed("player", ArcaneBrilliance)  then
					if castSpell("player", ArcaneBrilliance,false,false) then
						return true
					end
				end
			end

			-- cleanup after combat
			initWaterJet = false
		end	

		

		------------
		-- COMBAT --
		------------

		-- AffectingCombat, Pause, Target, Dead/Ghost Check
		if UnitAffectingCombat("player") then
			---------------
			-- Variables --
			---------------
			local dynamicUnit = {
			["dyn5"] = dynamicTarget(5,true), --Melee
			["dyn12AoE"] = dynamicTarget(12,false), -- Frost Nova
			["dyn30"] = dynamicTarget(30,true), --
			["dyn35"] = dynamicTarget(35,true), -- Deep Freeze, Blizzard
			["dyn40"] = dynamicTarget(40,true), -- SpellSteal, 
			["dyn40AoE"] = dynamicTarget(40,false), -- 
			}

			-- Todo : We need to create a WaterJet/FrostBomb target to be used when doing waterjet actions

			-- Get GCD Time
			local haste = GetHaste()
			local gcdTime = 1.5/(1+haste/100)
			local FrostBoltCastTime = select(4,GetSpellInfo(FrostBolt))/1000
			initWaterJet = initWaterJet or false -- Does this work? So if its true then its true or else false?
			isPlayerMoving = isMoving("player")
			isKnownPrismaticCrystal = isKnown(PrismaticCrystal)
			nrOfFrostFingerStacks = getBuffStacks("player",FingersOfFrost) or 0
			waterJetCooldown = getMagePetSpellCD(WaterJet)


			--Todo 
			-- FrostMageDefensives()
			-- Interrupts
			-- Dispells
			-- FrostMageCooldowns(), ie burst logic
			
			-- Single Target Rotation

			--Apply Frost Bomb Icon Frost Bomb or refresh it (if it is about to expire), but only if one of the following condition holds (let it drop otherwise):
			--you have 2 charges of Fingers of Frost Icon Fingers of Frost or;
			--Frozen Orb Icon Frozen Orb is about to come off cooldown;
			--Water Jet Icon Water Jet is about to come off cooldown.
			if isKnown(FrostBomb) and UnitDebuffID("target",FrostBomb,"player") and getDebuffRemain("target",FrostBomb,"player") < 2 then
				if nrOfFrostFingerStacks == 2 or getSpellCD(FrozenOrb) < 2 or waterJetCooldown < 2 then
					if castFrostBomb("target") then
						return true
					end
				end
			end

			-- ice_lance,if=buff.fingers_of_frost.react&buff.fingers_of_frost.remains<action.frostbolt.execute_time
			if UnitBuffID("player",FingersOfFrost) and getBuffRemain("player",FingersOfFrost) < FrostBoltCastTime then
				if castIceLance("target") then
					return true
				end
			end

			-- frostfire_bolt,if=buff.brain_freeze.react&buff.brain_freeze.remains<action.frostbolt.execute_time
			if UnitBuffID("player",BrainFreeze) and getBuffRemain("player",BrainFreeze) < FrostBoltCastTime then
				if castFrostFireBolt("target") then
					return true
				end
			end			

			-- frost_bomb,if=!talent.prismatic_crystal.enabled&cooldown.frozen_orb.remains<gcd.max&debuff.frost_bomb.remains<10
			if not isKnownPrismaticCrystal and getSpellCD(FrozenOrb) < 2 and getDebuffRemain("target",FrostBomb,"player") < 10  then
				if castFrostBomb("target") then
					return true
				end
			end

			-- frozen_orb,if=!talent.prismatic_crystal.enabled&buff.fingers_of_frost.stack<2&cooldown.icy_veins.remains>45
			if not isKnownPrismaticCrystal and nrOfFrostFingerStacks < 2 and getSpellCD(IcyVeins) > 45 then
				if castFrozenOrb("target") then --Todo : We need to have facing here
					return true
				end
			end

			-- frost_bomb,if=remains<action.ice_lance.travel_time&(buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&(talent.thermal_void.enabled|buff.fingers_of_frost.remains<gcd.max*2)))
			if getDebuffRemain("target",FrostBomb) < 1 then
				if nrOfFrostFingerStacks ==2 or (UnitBuffID("player",FingersOfFrost) and (isKnown(ThermalVoid) or getBuffRemain("player",FingersOfFrost) < gcdTime*2)) then
					if castFrostBomb("target") then
						return true
					end
				end
			end
			
			-- ice_nova,if=time_to_die<10|(charges=2&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up))
			-- actions.single_target+=/ice_nova,if=time_to_die<10|(charges=2&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up))
			--if isKnown(IceNova) then
			--	if getTimeToDie("target") < 10 or (getCharges(IceNova) and (not isKnown(PrismaticCrystal) or getSpellCD(PrismaticCrystal)>0)) then
			--		if castSpell("target",IceNova,false,false) then
			--			return;
			--		end
			--	end
			--end

			-- ice_lance,if=buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&dot.frozen_orb.ticking)
			if nrOfFrostFingerStacks == 2 or (nrOfFrostFingerStacks > 0 and UnitDebuffID("target",FrozenOrb,"player")) then
				if castIceLance("target") then
					return true
				end
			end

			-- ice_nova,if=(!talent.prismatic_crystal.enabled|(charges=1&cooldown.prismatic_crystal.remains>recharge_time&buff.incanters_flow.stack>3))&(buff.icy_veins.up|(charges=1&cooldown.icy_veins.remains>recharge_time))

			-- ice_lance,if=set_bonus.tier17_4pc&talent.thermal_void.enabled&dot.frozen_orb.ticking
			if isKnown(T17_4P_Frost) and isKnown(ThermalVoid) and UnitDebuffID("target",FrozenOrbDebuff,"player") then
				if castIceLance("target") then
					return true
				end
			end

			-- frostfire_bolt,if=buff.brain_freeze.react
			if UnitBuffID("player",BrainFreeze) then
				if castFrostFireBolt("target") then
					return true
				end
			end

			-- ice_lance,if=set_bonus.tier17_4pc&talent.thermal_void.enabled&talent.mirror_image.enabled&dot.frozen_orb.ticking

			-- ice_lance,if=talent.frost_bomb.enabled&buff.fingers_of_frost.react&debuff.frost_bomb.remains>travel_time&(!talent.thermal_void.enabled|cooldown.icy_veins.remains>8)
			if isKnown(FrostBomb) then
				if UnitBuffID("player",FingersOfFrost) and getDebuffRemain("target",FrostBomb,"player") > 1.5 and (not isKnown(ThermalVoid) or getSpellCD(IcyVeins)>8) then
					if castIceLance("target") then
						return true
					end
				end
			end
			
			-- frostbolt,if=set_bonus.tier17_2pc&buff.ice_shard.up&!(talent.thermal_void.enabled&buff.icy_veins.up&buff.icy_veins.remains<10)

			-- ice_lance,if=!talent.frost_bomb.enabled&buff.fingers_of_frost.react&(!talent.thermal_void.enabled|cooldown.icy_veins.remains>8)
			if not isKnown(FrostBomb) and UnitBuffID("player",FingersOfFrost) and (not isKnown(ThermalVoid) or getSpellCD(IcyVeins)>8) then
				if castIceLance("target") then
					return true
				end
			end

			--call_action_list,name=init_water_jet,if=pet.water_elemental.cooldown.water_jet.remains<=gcd.max*(buff.fingers_of_frost.react+talent.frost_bomb.enabled)&!dot.frozen_orb.ticking
			--	if UnitExists("pet") and getMagePetSpellCD(WaterJets) < 2 and getBuffStacks("player",FingersOfFrost) < 1 and not UnitDebuffID("target",FrozenOrb,"player") then 
			--		initWaterJet = true				
			--	end

			if not isPlayerMoving then
				if castFrostBolt("target") then
					return true
				end
			end

			if isPlayerMoving then
				if castIceLance("target") then
					return true
				end
			end
		end
	end
end