if select(3, UnitClass("player")) == 8 then

	function FrostMageDefensives()


	end

		--# AOE
	function FrostMageAoESimcraft()
		-- actions.aoe=call_action_list,name=cooldowns
		-- actions.aoe+=/frost_bomb,if=remains<action.ice_lance.travel_time&(cooldown.frozen_orb.remains<gcd|buff.fingers_of_frost.react=2)
		-- actions.aoe+=/frozen_orb
		if castSpell("target",FrozenOrb,false,true) then
			return;
		end

		-- actions.aoe+=/ice_lance,if=buff.fingers_of_frost.react&debuff.frost_bomb.up
		if UnitBuffID("player",FingersOfFrost,"player") and UnitDebuffID("target",FrostBomb,"player") then
			if castSpell("target",IceLance,false,false) then
				return;
			end
		end

		-- actions.aoe+=/comet_storm
		if isKnown(CometStorm) then
			if castSpell("target",CometStorm,false,false) then
				return;
			end
		end

		-- actions.aoe+=/ice_nova
		if isKnown(IceNova) then
			if castSpell("target",IceNova,false,false) then
				return;
			end
		end

		-- actions.aoe+=/cold_snap,if=glyph.cone_of_cold.enabled&!cooldown.cone_of_cold.up
		if hasGlyph(GlyphConeOfCold) and getSpellCD(ConeOfCold)>0 then
			if castSpell("target",ColdSnap,true,false) then
				return;
			end
		end

		-- actions.aoe+=/cone_of_cold,if=glyph.cone_of_cold.enabled
		if hasGlyph(GlyphConeOfCold) then
			if castSpell("target",ConeOfCold,false,false) then
				return;
			end
		end

		-- actions.aoe+=/blizzard,interrupt_if=cooldown.frozen_orb.up|(talent.frost_bomb.enabled&buff.fingers_of_frost.react=2)
		-- actions.aoe+=/ice_floes,moving=1
		if isKnown(IceFloes) then
			if isMoving("player") then
				if castSpell("target",IceFloes,true,false) then
					return;
				end
			end
		end
	end

	--# Cooldowns
	function FrostMageCooldowns()
		-- actions.cooldowns=icy_veins
		if isChecked("Icy Veins") then
			if castSpell("player",IcyVeins,true,false) then
				return;
			end
		end

		-- Mirrors

		if isKnown(MirrorImage) then
			if isChecked("Mirror Image") then
				if castSpell("player",MirrorImage,true,true) then
					return;
				end
			end
		end

		-- actions.cooldowns+=/blood_fury		-- Orc Racial
		-- actions.cooldowns+=/berserking		-- Troll Racial
		if isChecked("Racial") then
			if isKnown(Berserkering) then
				if castSpell("player",Berserkering,true,true) then
					return;
				end
			end
		end

		-- actions.cooldowns+=/arcane_torrent	-- B11 Racial
		-- actions.cooldowns+=/potion,name=draenic_intellect,if=buff.bloodlust.up|buff.icy_veins.up		-- Pot
	end

		--# Crystal Sequence
	function FrostMageCrystalSimcraft()

			-- actions.crystal_sequence=frost_bomb,if=active_enemies=1&current_target!=prismatic_crystal&remains<10
			if isKnown(FrostBomb) and UnitName("target") ~= "Prismatic Crystal" then
				if castSpell("target",FrostBomb,false,false) then
					return;
				end
			end
			-- actions.crystal_sequence+=/frozen_orb
			if castSpell("target",FrozenOrb,false,false) then
				print("crystalorb");
				return;
			end

			-- actions.crystal_sequence+=/call_action_list,name=cooldowns

			-- take crystal in focus
			RunMacroText("/focus Prismatic Crystal")

			-- actions.crystal_sequence+=/prismatic_crystal
			if isKnown(PrismaticCrystal) and getSpellCD(PrismaticCrystal) <= 0 then
				local X, Y, Z = ObjectPosition("focus");
				CastAtPosition(X,Y,Z);
			end

																																			--[[TBD ACTIVE ENEMIES]]
			-- actions.crystal_sequence+=/frost_bomb,if=active_enemies>1&current_target=prismatic_crystal&!ticking
			if isKnown(FrostBomb) then
				if UnitName("focus") == "Prismatic Crystal" then
					if castSpell("focus",FrostBomb,false,false) then
						return;
					end
				end
			end

			-- actions.crystal_sequence+=/ice_lance,if=buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&active_dot.frozen_orb>=1)
			if getBuffStacks("player",FingersOfFrost) == 2 or (UnitBuffID("player",FingersOfFrost) and UnitDebuffID("target",FrozenOrbDebuff) and getDebuffRemain("target",FrozenOrbDebuff) >=1) then
				if castSpell("focus",IceLance,false,false) then
					return;
				end
			end

			-- actions.crystal_sequence+=/ice_nova,if=charges=2
			if isKnown(IceNova) then
				if getCharges(IceNova) == 2 then
					if castSpell("focus",IceNova,false,false) then
						return;
					end
				end
			end

			-- actions.crystal_sequence+=/frostfire_bolt,if=buff.brain_freeze.react
			if UnitBuffID("player",BrainFreeze) then
				if castSpell("focus",FrostfireBolt,false,false) then
					return;
				end
			end

			-- actions.crystal_sequence+=/ice_lance,if=buff.fingers_of_frost.react
			if UnitBuffID("player",FingersOfFrost) then
				if castSpell("focus",IceLance,false,false) then
					return;
				end
			end

			-- actions.crystal_sequence+=/ice_nova
			if isKnown(IceNova) then
				if getCharges(IceNova) > 0 then
					if castSpell("focus",IceNova,false,false) then
						return;
					end
				end
			end

			-- actions.crystal_sequence+=/blizzard,interrupt_if=cooldown.frozen_orb.up|(talent.frost_bomb.enabled&buff.fingers_of_frost.react=2),if=active_enemies>=5
			-- actions.crystal_sequence+=/frostbolt
			if castSpell("target",Frostbolt,false,true) then
				return;
			end
	end

		--# Single Target Icy Veins
	function FrostMageSingleTargetIcyVeins()
		local GT = GetTime();
		if lastFB == nil then
			lastFB = GT;
		end

		-- Apply Frost Bomb Icon Frost Bomb or refresh it (if it is about to expire), but only if one of the following condition holds (let it drop otherwise):
			-- you have 2 charges of Fingers of Frost Icon Fingers of Frost or;
			-- Frozen Orb is about to come off cooldown.
		if not UnitDebuffID("target",FrostBomb) and (GT-lastFB > 2) or (UnitDebuffID("target",FrostBomb) and getDebuffRemain("target",FrostBomb)<3) then
			if getBuffStacks("player",FingersOfFrost)==2 or getSpellCD(FrozenOrb)<5 then
				if castSpell("target",FrostBomb,false,false) then
					return;
				end
			end
		end

		-- Cast Frozen Orb on cooldown (unless you want to save it for an upcoming AoE phase).
		if castSpell("target",FrozenOrb) then
			return;
		end

		-- Cast Ice Lance when Frost Bomb is up and you have 1 or 2 charges of Fingers of Frost.
			-- Otherwise, let Fingers of Frost build up until you have 2 charges, so that you can apply Frost Bomb, before consuming your charges.
			-- Only cast Ice Lance without Frost Bomb, if you have 1 charge of Fingers of Frost and it is about to expire.
		if (UnitDebuffID("target",FrostBomb) and getBuffStacks("player",FingersOfFrost)>=1) or (UnitBuffID("player",FingersOfFrost) and getBuffRemain("player",FingersOfFrost)==2) then
			if castSpell("target",IceLance,false,false) then
				return;
			end
		end

		-- Cast Frostfire Bolt when Brain Freeze procs (you can have up to 2 charges).
			-- Frostfire Bolt can give you a charge of Fingers of Frost, so avoid casting it if you already have 2 charges.
		if UnitBuffID("player",BrainFreeze) and getBuffStacks("player",FingersOfFrost)<2 then
			if castSpell("target",FrostfireBolt,false,false) then
				return;
			end
		end

		-- Cast Frostbolt Icon Frostbolt as a filler spell.
		-- actions.single_target+=/water_jet,if=buff.fingers_of_frost.react=0&!dot.frozen_orb.ticking
		if UnitExists("pet") == 1 and getBuffStacks("player",FingersOfFrost) < 1 and not UnitDebuffID("target",FrozenOrb,"player") then
			if castSpell("target",WaterJet,true,false) then
				return;
			end
		end

		-- actions.single_target+=/frostbolt
		if castSpell("target",Frostbolt,false,true) then
			return;
		end

		-- actions.single_target+=/ice_floes,moving=1
		if isMoving("player") then
			if castSpell("target",IceFloes,false,false) then
				return;
			end
		end

		-- actions.single_target+=/ice_lance,moving=1
		if isMoving("player") then
			if castSpell("target",IceLance,false,false) then
				return;
			end
		end
	end

		--# SingleTarget Simcraft
	function FrostMageSingleTargetSimcraft()

		-- Get GCD Time
		local HASTE = GetHaste()
		local GCDTIME = 1.5/(1+HASTE/100)



		-- actions.single_target=call_action_list,name=cooldowns,if=!talent.prismatic_crystal.enabled|cooldown.prismatic_crystal.remains>45
		-- actions.single_target+=/ice_lance,if=buff.fingers_of_frost.react&buff.fingers_of_frost.remains<action.frostbolt.execute_time
		local FBCASTTIME = select(4,GetSpellInfo(Frostbolt))/1000

		if UnitBuffID("player",FingersOfFrost) and getBuffRemain("player",FingersOfFrost) < FBCASTTIME then
			if castSpell("target",IceLance,false,false) then
				return;
			end
		end

		-- actions.single_target+=/frostfire_bolt,if=buff.brain_freeze.react&buff.brain_freeze.remains<action.frostbolt.execute_time
		if UnitBuffID("player",BrainFreeze) and getBuffRemain("player",BrainFreeze) < GCDTIME then
			if castSpell("target",FrostfireBolt,false,false) then
				return;
			end
		end

		-- actions.single_target+=/frost_bomb,if=!talent.prismatic_crystal.enabled&cooldown.frozen_orb.remains<gcd&debuff.frost_bomb.remains<10
		if not isKnown(PrismaticCrystal) and getSpellCD(FrozenOrb) < 2 and getDebuffRemain("target",FrostBomb,"player") < 10  then
			if castSpell("target",FrostBomb,false,false) then
				return;
			end
		end

		--Apply Frost Bomb Icon Frost Bomb or refresh it (if it is about to expire), but only if one of the following condition holds (let it drop otherwise):
			--you have 2 charges of Fingers of Frost Icon Fingers of Frost or;
			--Frozen Orb Icon Frozen Orb is about to come off cooldown.

		-- if isKnown(FrostBomb) then
		-- 	if getBuffStacks("player",FingersOfFrost)==2 or getSpellCD(FrozenOrb) < 2
		-- 	end
		-- end

		-- actions.single_target+=/frozen_orb,if=!talent.prismatic_crystal.enabled&buff.fingers_of_frost.stack<2&cooldown.icy_veins.remains>45
		if not isKnown(PrismaticCrystal) and getBuffStacks("player",FingersOfFrost) < 2 and getSpellCD(IcyVeins) > 45 then
			if castSpell("target",FrozenOrb,false,true) then
				return;
			end
		end

		-- Same without CDs checked
		if not isKnown(PrismaticCrystal) and getBuffStacks("player",FingersOfFrost) < 2 then
			if castSpell("target",FrozenOrb,false,true) then
				return;
			end
		end


		-- actions.single_target+=/frost_bomb,if=remains<action.ice_lance.travel_time&(buff.fingers_of_frost.react=2|  (buff.fingers_of_frost.react&(talent.thermal_void.enabled|buff.fingers_of_frost.remains<gcd*2)))
		if getDebuffRemain("target",FrostBomb) < 1 then
			if getBuffStacks("player",FingersOfFrost)==2 or (UnitBuffID("player",FingersOfFrost) and (isKnown(ThermalVoid) or getBuffRemain("player",FingersOfFrost)<GCDTIME*2)) then
				if castSpell("target",FrostBomb,false,false) then
					return;
				end
			end
		end

		-->>> buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&(talent.thermal_void.enabled|buff.fingers_of_frost.remains<gcd*2)))
		-- if getBuffStacks("player",FingersOfFrost)==2 or (UnitBuffID("player",FingersOfFrost) and (isKnown(ThermalVoid) or getBuffRemain("player",FingersOfFrost)<2*GCDTIME)) then
		-- 	if castSpell("target",FrostBomb,false,false) then
		-- 		print("2222");
		-- 		return;
		-- 	end
		-- end

		-- actions.single_target+=/ice_nova,if=time_to_die<10|(charges=2&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up))
		if isKnown(IceNova) then
			if getTimeToDie("target") < 10 or (getCharges(IceNova) and (not isKnown(PrismaticCrystal) or getSpellCD(PrismaticCrystal)>0)) then
				if castSpell("target",IceNova,false,false) then
					return;
				end
			end
		end

		-- actions.single_target+=/ice_lance,if=buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&dot.frozen_orb.ticking)
		if getBuffStacks("player",FingersOfFrost) == 2 or (getBuffStacks("player",FingersOfFrost) == 2 and getDebuffRemain("target",FrozenOrb,"player")) then
			if castSpell("target",IceLance,false,false) then
				return;
			end
		end

		-- actions.single_target+=/comet_storm
		if isKnown(CometStorm) then
			if castSpell("target",CometStorm,false,false) then
				return;
			end
		end

		-- actions.single_target+=/ice_lance,if=set_bonus.tier17_4pc&talent.thermal_void.enabled&dot.frozen_orb.ticking
		if isKnown(T17_4P_Frost) and isKnown(ThermalVoid) and UnitDebuffID("target",FrozenOrbDebuff,"player") then
			if castSpell("target",IceLance,false,false) then
				return;
			end
		end

		-- actions.single_target+=/ice_nova,if=(!talent.prismatic_crystal.enabled|(charges=1&cooldown.prismatic_crystal.remains>recharge_time))&(buff.icy_veins.up|(charges=1&cooldown.icy_veins.remains>recharge_time))
		-- actions.single_target+=/frostfire_bolt,if=buff.brain_freeze.react
		if UnitBuffID("player",BrainFreeze) then
			if castSpell("target",FrostfireBolt,false,false) then
				return;
			end
		end

		-- actions.single_target+=/ice_lance,if=buff.fingers_of_frost.react&debuff.frost_bomb.remains>travel_time&(!talent.thermal_void.enabled|cooldown.icy_veins.remains>8)
		if isKnown(FrostBomb) then
			if UnitBuffID("player",FingersOfFrost) and getDebuffRemain("target",FrostBomb,"player") > 1.5 and (not isKnown(ThermalVoid) or getSpellCD(IcyVeins)>8) then
				if castSpell("target",IceLance,false,true) then
					return;
				end
			end
		end

		-- actions.single_target+=/frostbolt,if=buff.ice_shard.up&!(talent.thermal_void.enabled&buff.icy_veins.up&buff.icy_veins.remains<10)
		-- if UnitBuffID("player",IceShard) then
		-- 	if not(isKnown(ThermalVoid) and getBuffRemain("player",IcyVeins)<10 and UnitBuffID("player",IcyVeins)) then
		-- 		if castSpell("target",Frostbolt,false,true) then
		-- 			return;
		-- 		end
		-- 	end
		-- end

		-- actions.single_target+=/ice_lance,if=buff.fingers_of_frost.react&!talent.frost_bomb.enabled&(!talent.thermal_void.enabled|cooldown.icy_veins.remains>8)
		if not isKnown(FrostBomb) then
			if UnitBuffID("player",FingersOfFrost) and (not isKnown(ThermalVoid) or getSpellCD(IcyVeins) > 8) then
				if castSpell("target",IceLance,false,false) then
					return;
				end
			end
		end

		-- actions.single_target+=/ice_lance,if=talent.thermal_void.enabled&buff.icy_veins.up&buff.icy_veins.remains<6&buff.icy_veins.remains<cooldown.icy_veins.remains
		if isKnown(ThermalVoid) then
			if getDebuffRemain("player",IcyVeins) < 6 and getSpellCD(IcyVeins) then
				if castSpell("target",IceLance,false,false) then
					return;
				end
			end
		end

		-- actions.single_target+=/water_jet,if=buff.fingers_of_frost.react=0&!dot.frozen_orb.ticking
		if UnitExists("pet") == 1 and getBuffStacks("player",FingersOfFrost) < 1 and not UnitDebuffID("target",FrozenOrb,"player") then
			if castSpell("target",WaterJet,true,false) then
				return;
			end
		end

		-- actions.single_target+=/frostbolt
		if castSpell("target",Frostbolt,false,true) then
			return;
		end

		-- actions.single_target+=/ice_floes,moving=1
		if isMoving("player") then
			if castSpell("target",IceFloes,false,false) then
				return;
			end
		end

		-- actions.single_target+=/ice_lance,moving=1
		if isMoving("player") then
			if castSpell("target",IceLance,false,false) then
				return;
			end
		end

	end
end