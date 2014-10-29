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

	--# Defensive
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
		if ischecked("Mirror Image") then
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

-- Defensives
function ArcaneMageDefensives()

	-- Evanesce
	if isKnown(Evanesce) then
		if isChecked("Evanesce") then
			if getHP("player") < getValue("Evanesce") then
				if castSpell("player",Evanesce,true,false) then
					return;
				end
			end
		end
	end

	-- Healthstone
	if isChecked("Healthstone") == true then
		if getHP("player") <= getValue("Healthstone") then
			if canUse(5512) then
				UseItemByName(tostring(select(1,GetItemInfo(5512))))
			end
		end
	end


end

-- AoE
function ArcaneMageAoESimcraft()

	-- actions.aoe=call_action_list,name=cooldowns
	-- actions.aoe+=/nether_tempest,cycle_targets=1,if=buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
	if Charge()==4 and (not UnitDebuffID("target",NetherTempest) or (UnitDebuffID("target",NetherTempest) and getDebuffRemain("target",NetherTempest)<3.6)) then
		return;
	end

	-- actions.aoe+=/supernova
	if castSpell("target",Supernova,false,false) then
		return;
	end

	-- actions.aoe+=/arcane_barrage,if=buff.arcane_charge.stack=4
	if Charge()==4 then
		if castSpell("target",ArcaneBarrage,false,false) then
			return;
		end
	end

	-- actions.aoe+=/arcane_orb,if=buff.arcane_charge.stack<4
	if isKnown(ArcaneOrb) then
		if Charge()<4 then
			if castSpell("target",ArcaneOrb,false,true) then
				return;
			end
		end
	end

	-- actions.aoe+=/cone_of_cold,if=glyph.cone_of_cold.enabled
	if hasGlyph(323) then
		if castSpell("target",ConeOfCold,false,true) then
			return;
		end
	end

	-- actions.aoe+=/arcane_explosion
	if getNumEnemies("player",10) then
		if castSpell("target",ArcaneExplosion,true,false) then
			return;
		end
	end

end

-- Cooldowns
function ArcaneMageCooldowns()

	-- Berserk
	if isChecked("Racial") then
		if isKnown(Berserkering) then
			if castSpell("player",Berserkering,true,true) then
				return;
			end
		end
	end

	-- Arcane Power
	if isChecked("Arcane Power") then
		if castSpell("player",ArcanePower,true,true) then
			return;
		end
	end

	-- actions+=/cold_snap,if=buff.presence_of_mind.down&cooldown.presence_of_mind.remains>75
	if isKnown(ColdSnap) then
		if isChecked(ColdSnap) then
			if not UnitBuffID("player",PresenceOfMind) and getSpellCD(PresenceOfMind)>75 then
				return;
			end
		end
	end

end

-- burn Mana down
function ArcaneMageSingleTargetSimcraftBurn()
	-- actions.burn=call_action_list,name=cooldowns
	-- actions.burn+=/arcane_missiles,if=buff.arcane_missiles.react=3
	if getBuffStacks("player",ArcaneMissilesP)==3 then
		if castSpell("target",ArcaneMissiles,false,true) then
			return;
		end
	end

	local ABCASTTIME = select(4,GetSpellInfo(ArcaneBlast))/1000
	-- actions.burn+=/arcane_missiles,if=buff.arcane_instability.react&buff.arcane_instability.remains<action.arcane_blast.execute_time
	if UnitBuffID("player",T17_4P_Arcane) and getBuffRemain("player",T17_4P_Arcane)<ABCASTTIME then
		if castSpell("target",ArcaneMissiles,false,false) then
			return;
		end
	end

	-- actions.burn+=/supernova,if=time_to_die<8|charges=2
	if isKnown(Supernova) then
		if getTimeToDie("target")<8 or Charge()==2 then
			if castSpell("target",Supernova,false,false) then
				return;
			end
		end
	end
	-- actions.burn+=/nether_tempest,cycle_targets=1,if=target!=prismatic_crystal&buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
	if UnitName("target") ~= "Prismatic Crystal" and Charge()==4 and (not UnitDebuffID("target",NetherTempest) or ((UnitDebuffID("target",NetherTempest) and getDebuffRemain("target",NetherTempest)<3.6))) then
		if castSpell("target",NetherTempest,true,false) then
			return;
		end
	end

	-- actions.burn+=/arcane_orb,if=buff.arcane_charge.stack<4
	if isKnown(ArcaneOrb) then
		if Charge()==4 then
			if castSpell("target",ArcaneOrb,false,true) then
				return;
			end
		end
	end

	-- actions.burn+=/supernova,if=current_target=prismatic_crystal
	if isKnown(Supernova) then
		if UnitName("target") == "Prismatic Crystal" then
			if castSpell("target",Supernova,false,false) then
				return;
			end
		end
	end

	-- actions.burn+=/presence_of_mind,if=mana.pct>96
	if getMana("player")>96 then
		if castSpell("player",PresenceOfMind,true,false) then
			return;
		end
	end

	-- actions.burn+=/arcane_blast,if=buff.arcane_charge.stack=4&mana.pct>93
	if Charge()==4 and getMana("player")>getValue("ArcaneBlast (x4)") then
		if castSpell("target",ArcaneBlast,false,true) then
			return;
		end
	end

	-- actions.burn+=/arcane_missiles,if=buff.arcane_charge.stack=4
	if Charge()==4 and UnitBuffID("player",ArcaneMissilesP) then
		if castSpell("target",ArcaneMissiles,false,false) then
			return;
		end
	end

	-- actions.burn+=/supernova,if=mana.pct<96
	if isKnown(Supernova) then
		if getMana("player") < 96 then
			if castSpell("target",Supernova,false,false) then
				return;
			end
		end
	end

	-- actions.burn+=/call_action_list,name=conserve,if=cooldown.evocation.duration-cooldown.evocation.remains<5
		-- with perk:
		if isKnown(157614) then
			if 90-getSpellCD(Evocation)<5 then
				ArcaneMageSingleTargetSimcraftConserve();
			end
		end
		-- without perk:
		if not isKnown(157614) then
			if 120-getSpellCD(Evocation)<5 then
				ArcaneMageSingleTargetSimcraftConserve();
			end
		end

	-- actions.burn+=/evocation,interrupt_if=mana.pct>92,if=time_to_die>10&mana.pct<50


	-- actions.burn+=/presence_of_mind
	if castSpell("player",PresenceOfMind,true,false) then
		return;
	end

	-- actions.burn+=/arcane_blast
	if castSpell("target",ArcaneBlast,false,true) then
		return;
	end

end

-- conserve Mana
function ArcaneMageSingleTargetSimcraftConserve()

	-- local Charge = select(4,UnitDebuffID("player",ArcaneCharge))
	-- if Charge == nil then
	-- 	Charge = 0;
	-- end

	-- actions.conserve=call_action_list,name=cooldowns,if=time_to_die<30|(buff.arcane_charge.stack=4&(!talent.prismatic_crystal.enabled|cooldown.prismatic_crystal.remains>15))
	-- actions.conserve+=/arcane_missiles,if=buff.arcane_missiles.react=3|(talent.overpowered.enabled&buff.arcane_power.up&buff.arcane_power.remains<action.arcane_blast.execute_time)
	if getBuffStacks("player",ArcaneMissilesP)==3 or (isKnown(Overpowered) and UnitBuffID("player",ArcanePower) and getBuffRemain("player",ArcanePower)<(select(4,GetSpellInfo(ArcaneBlast))/1000)) then
		if castSpell("target",ArcaneMissiles,false,true) then
			return;
		end
	end

	-- actions.conserve+=/arcane_missiles,if=buff.arcane_instability.react&buff.arcane_instability.remains<action.arcane_blast.execute_time
	if UnitBuffID("player",T17_4P_Arcane) and getBuffRemain("player",T17_4P_Arcane)<(select(4,GetSpellInfo(ArcaneBlast)/1000)) then
		if castSpell("target",ArcaneMissiles,false,true) then
			return;
		end
	end

	-- actions.conserve+=/nether_tempest,cycle_targets=1,if=target!=prismatic_crystal&buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
	if UnitName("target") ~= "Prismatic Crystal" and Charge()==4 and (not UnitDebuffID("target",NetherTempest) or ((UnitDebuffID("target",NetherTempest) and getDebuffRemain("target",NetherTempest)<3.6))) then
		if castSpell("target",NetherTempest,true,false) then
			return;
		end
	end

	-- actions.conserve+=/supernova,if=time_to_die<8|(charges=2&(buff.arcane_power.up|!cooldown.arcane_power.up)&(!talent.prismatic_crystal.enabled|cooldown.prismatic_crystal.remains>8))
	if getTimeToDie("target")<8 or (Charge()==2 and (UnitBuffID("player",ArcanePower) or getSpellCD(ArcanePower)>0) and (not isKnown(PrismaticCrystal) or getSpellCD(PrismaticCrystal>8))) then
		if castSpell("target",Supernova,false,false) then
			return;
		end
	end

	-- actions.conserve+=/arcane_orb,if=buff.arcane_charge.stack<2
	if isKnown(ArcaneOrb) then
		if Charge()<2 then
			if castSpell("target",ArcaneOrb,false,true) then
				return;
			end
		end
	end

	-- actions.conserve+=/presence_of_mind,if=mana.pct>96
	if getMana("player")>96 then
		if castSpell("player",PresenceOfMind,true,false) then
			return;
		end
	end

	-- actions.conserve+=/arcane_blast,if=buff.arcane_charge.stack=4&mana.pct>93
	if Charge()==4 and getMana("player")>getValue("ArcaneBlast (x4)") then
		if castSpell("target",ArcaneBlast,false,true) then
			return;
		end
	end

	-- actions.conserve+=/arcane_missiles,if=buff.arcane_charge.stack=4&(!talent.overpowered.enabled|cooldown.arcane_power.remains>10*spell_haste)
	if Charge()==4 and (not isKnown(Overpowered) or getSpellCD(ArcanePower)>10*GetHaste()) then
		if castSpell("target",ArcaneMissiles,false,true) then
			return;
		end
	end

	-- actions.conserve+=/supernova,if=mana.pct<96&(  buff.arcane_missiles.stack<2| buff.arcane_charge.stack=4)&    (buff.arcane_power.up|(charges=1&   cooldown.arcane_power.remains>recharge_time   )  )   &   (!talent.prismatic_crystal.enabled|       current_target=prismatic_crystal|    (charges=1&cooldown.prismatic_crystal.remains>recharge_time+8))
	if getMana("player")<96 and (getBuffStacks("player",ArcaneMissilesP)<2 or Charge()==4) and (UnitBuffID("player",ArcanePower) or (GetSpellCharges(Supernova)==1 and getSpellCD(ArcanePower)>getRecharge(Supernova))) and (not isKnown(PrismaticCrystal) or UnitName("target") ~= "Prismatic Crystal" or (GetSpellCharges(Supernova)==1 and getSpellCD(PrismaticCrystal)>(getRecharge(Supernova)+8))) then
		if castSpell("target",Supernova,true,false) then
			return;
		end
	end

	--[[ TBD ]]
	-- actions.conserve+=/nether_tempest,cycle_targets=1,if=target!=prismatic_crystal&buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<(10-3*talent.arcane_orb.enabled)*spell_haste))
	--if UnitName("target") ~= "Prismatic Crystal" and getDebuffStacks("player",ArcaneCharge) == 4 and (UnitDebuffID("target",NetherTempest) or (UnitDebuffID("target",NetherTempest) and getDebuffRemain("target",NetherTempest)<(10)*GetHaste())


	-- actions.conserve+=/arcane_barrage,if=buff.arcane_charge.stack=4
	if Charge()==4 then
		if castSpell("target",ArcaneBarrage,false,false) then
			return;
		end
	end

	-- actions.conserve+=/presence_of_mind,if=buff.arcane_charge.stack<2
	if Charge() < 2 then
		if castSpell("player",PresenceOfMind,true,false) then
			return;
		end
	end

	-- actions.conserve+=/arcane_blast
	if castSpell("target",ArcaneBlast,false,true) then
		return;
	end

	-- actions.conserve+=/ice_floes,moving=1
	if isKnown(IceFloes) then
		if isMoving("player") then
			if castSpell("player",IceFloes,true,false) then
				return;
			end
		end
	end

	-- actions.conserve+=/arcane_barrage,moving=1
	if isMoving("player") then
		if castSpell("target",ArcaneBarrage,false,false) then
			return;
		end
	end

end






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


function CalculateHP(unit)
  incomingheals = UnitGetIncomingHeals(unit) or 0
  return 100 * ( UnitHealth(unit) + incomingheals ) / UnitHealthMax(unit)
end

function GroupInfo()
    members, group = { { Unit = "player", HP = CalculateHP("player") } }, { low = 0, tanks = { } }
    group.type = IsInRaid() and "raid" or "party"
    group.number = GetNumGroupMembers()
    if group.number > 0 then
        for i=1,group.number do
            if canHeal(group.type..i) then
                local unit, hp = group.type..i, CalculateHP(group.type..i)
                table.insert( members,{ Unit = unit, HP = hp } )
                if hp < 90 then group.low = group.low + 1 end
                if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(group.tanks,unit) end
            end
        end
        if group.type == "raid" and #members > 1 then table.remove(members,1) end
        table.sort(members, function(x,y) return x.HP < y.HP end)
        --local customtarget = canHeal("target") and "target" -- or CanHeal("mouseover") and GetMouseFocus() ~= WorldFrame and "mouseover"
        --if customtarget then table.sort(members, function(x) return UnitIsUnit(customtarget,x.Unit) end) end
    end
end

-- Arcane Charge
function Charge()
	if UnitDebuffID("player",ArcaneCharge) then
		return select(4,UnitDebuffID("player",ArcaneCharge))
	else
		return 0;
	end
end



end