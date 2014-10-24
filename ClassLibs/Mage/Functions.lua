if select(3, UnitClass("player")) == 8 then


--[[            ]]   --[[]]   --[[           ]]
--[[            ]]   --[[]]   --[[            ]]
--[[            ]]   --[[]]   --[[]]       --[[]]
--[[]]               --[[]]   --[[]]        --[[]]
--[[]]               --[[]]   --[[]]       --[[]]
--[[       ]]        --[[]]   --[[            ]]
--[[       ]]        --[[]]   --[[          ]]
--[[]]               --[[]]   --[[]]      --[[]]
--[[]]               --[[]]   --[[]]       --[[]]
--[[]]               --[[]]   --[[]]       --[[]]
--[[]]               --[[]]   --[[]]       --[[]]




--[[            ]]   --[[           ]]
--[[            ]]   --[[            ]]
--[[            ]]   --[[]]       --[[]]
--[[]]               --[[]]        --[[]]
--[[]]               --[[]]       --[[]]
--[[       ]]        --[[            ]]
--[[       ]]        --[[          ]]
--[[]]               --[[]]      --[[]]
--[[]]               --[[]]       --[[]]
--[[]]               --[[]]       --[[]]
--[[]]               --[[]]       --[[]]

--# Executed before combat begins. Accepts non-harmful actions only.

-- actions.precombat=flask,type=greater_draenic_intellect_flask
-- actions.precombat+=/food,type=calamari_crepes
-- actions.precombat+=/arcane_brilliance
-- actions.precombat+=/water_elemental
-- actions.precombat+=/snapshot_stats
-- actions.precombat+=/rune_of_power
-- actions.precombat+=/mirror_image
-- actions.precombat+=/potion,name=draenic_intellect
-- actions.precombat+=/frostbolt

--# Checks
-- actions=counterspell,if=target.debuff.casting.react
-- actions+=/blink,if=movement.distance>10
-- actions+=/blazing_speed,if=movement.remains>0
-- actions+=/time_warp,if=target.health.pct<25|time>5
-- actions+=/mirror_image
-- actions+=/rune_of_power,if=buff.rune_of_power.remains<cast_time
-- actions+=/rune_of_power,if=(cooldown.icy_veins.remains<gcd&buff.rune_of_power.remains<20)|(cooldown.prismatic_crystal.remains<gcd&buff.rune_of_power.remains<10)
-- actions+=/call_action_list,name=cooldowns,if=time_to_die<24
-- actions+=/call_action_list,name=crystal_sequence,if=talent.prismatic_crystal.enabled&(cooldown.prismatic_crystal.remains<=action.frozen_orb.gcd|pet.prismatic_crystal.active)
-- actions+=/call_action_list,name=aoe,if=active_enemies>=5
-- actions+=/call_action_list,name=single_target

	--# AOE
function FrostAoESimcraft()
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
function FrostCDs()
	-- actions.cooldowns=icy_veins
	if castSpell("target",IcyVeins,true,false) then
		return;
	end

	-- Mirrors
	if isKnown(MirrorImage) then
		if castSpell("target",MirrorImage,true,true) then
			return;
		end
	end

	-- actions.cooldowns+=/blood_fury		-- Orc Racial
	-- actions.cooldowns+=/berserking		-- Troll Racial
	-- actions.cooldowns+=/arcane_torrent	-- B11 Racial
	-- actions.cooldowns+=/potion,name=draenic_intellect,if=buff.bloodlust.up|buff.icy_veins.up		-- Pot
end

	--# Crystal Sequence
function FrostCrystalSimcraft()

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

																																		--[[TBD Debuff on target]]
		-- actions.crystal_sequence+=/ice_lance,if=buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&active_dot.frozen_orb>=1)
		if getBuffStacks("player",FingersOfFrost) == 2 then
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

	--# SingleTarget
function FrostSingleTargetSimcraft()

	-- Get GCD Time
	local HASTE = GetHaste()
	local GCDTIME = 1.5/(1+HASTE/100)



	-- actions.single_target=call_action_list,name=cooldowns,if=!talent.prismatic_crystal.enabled|cooldown.prismatic_crystal.remains>45
	-- actions.single_target+=/ice_lance,if=buff.fingers_of_frost.react&buff.fingers_of_frost.remains<action.frostbolt.execute_time
	if UnitBuffID("player",FingersOfFrost) and getBuffRemain("player",FingersOfFrost) < GCDTIME then
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
	if not isKnown(PrismaticCrystal) and getSpellCD(FrozenOrb) < GCDTIME and getDebuffRemain("target",FrostBomb,"player") then
		if castSpell("target",FrostBomb,false,false) then
			return;
		end
	end

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


	-- actions.single_target+=/frost_bomb,if=remains<action.ice_lance.travel_time&(buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&(talent.thermal_void.enabled|buff.fingers_of_frost.remains<gcd*2)))
	-->>> buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&(talent.thermal_void.enabled|buff.fingers_of_frost.remains<gcd*2)))
	if getBuffStacks("player",FingersOfFrost)==2 or (UnitBuffID("player",FingersOfFrost) and (isKnown(ThermalVoid) or getBuffRemain("player",FingersOfFrost)<2*GCDTIME)) then
		if castSpell("target",FrostBomb,false,false) then
			return;
		end
	end

	-- actions.single_target+=/ice_nova,if=time_to_die<10|(charges=2&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up))
	if isKnown(IceNova) then
		if getTimeToDie("target") < 10 or (getCharges(IceNova) and (not isKnown(PrismaticCrystal) or getSpellCD(PrismaticCrystal)>0)) then
			if castSpell("target",IceNova,false,false) then
				return;
			end
		end
	end

	-- actions.single_target+=/ice_lance,if=buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&dot.frozen_orb.ticking)
	if getBuffStacks("player",FingersOfFrost) == 2 or (getBuffStacks("player",FingersOfFrost) >= 1 and getDebuffRemain("target",FrozenOrb,"player")) then
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
	-- actions.single_target+=/frostbolt,if=buff.ice_shard.up&!(talent.thermal_void.enabled&buff.icy_veins.up&buff.icy_veins.remains<10)
	-- actions.single_target+=/ice_lance,if=buff.fingers_of_frost.react&!talent.frost_bomb.enabled&(!talent.thermal_void.enabled|cooldown.icy_veins.remains>8)
	-- actions.single_target+=/ice_lance,if=talent.thermal_void.enabled&buff.icy_veins.up&buff.icy_veins.remains<6&buff.icy_veins.remains<cooldown.icy_veins.remains
	-- actions.single_target+=/water_jet,if=buff.fingers_of_frost.react=0&!dot.frozen_orb.ticking
	if UnitExists("pet") == 1 and getBuffStacks("player",FingersOfFrost) < 1 and not UnitDebuffID("target",FrozenOrb,"player") then
		if castSpell("target",WaterJet, true,false) then
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



    --[[    ]]       --[[           ]]
  --[[        ]]     --[[            ]]
 --[[          ]]    --[[]]       --[[]]
--[[]]      --[[]]   --[[]]        --[[]]
--[[]]      --[[]]   --[[]]       --[[]]
--[[            ]]   --[[            ]]
--[[            ]]   --[[          ]]
--[[]]      --[[]]   --[[]]      --[[]]
--[[]]      --[[]]   --[[]]       --[[]]
--[[]]      --[[]]   --[[]]       --[[]]
--[[]]      --[[]]   --[[]]       --[[]]





--[[            ]]   --[[]]       --[[]]
--[[            ]]   --[[]]       --[[]]
--[[            ]]   --[[]]       --[[]]
--[[]]               --[[]]       --[[]]
--[[]]               --[[]]       --[[]]
--[[       ]]        --[[]]       --[[]]
--[[       ]]        --[[]]       --[[]]
--[[]]               --[[]]       --[[]]
--[[]]               --[[ ]]     --[[ ]]
--[[]]                --[[           ]]
--[[]]                  --[[       ]]






end