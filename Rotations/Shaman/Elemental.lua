if select(3, UnitClass("player")) == 7 then
-- Rotation
function ShamanElemental()
	if currentConfig ~= "Elemental CodeMyLife" then
		ElementalConfig();
		ElementalToggles();
		currentConfig = "Elemental CodeMyLife";
	end
	dynamicUnit = {
		dyn25 = dynamicTarget(25,true), -- wind shear
		dyn30 = dynamicTarget(35,true), -- purge
		dyn35AoE = dynamicTarget(35,false), -- earthquake
		dyn40 = dynamicTarget(40,true), -- flame shock
		dyn40AoE = dynamicTarget(40,false) -- searing
	}
	local _Ascendance = 165339

	player = {
		buff = {
			ascendance = {
				duration = 15,
				remains = getBuffRemain("player",114050),
				up = UnitBuffID("player",114050)
			},
			bloodlust = {
				duration = 40,
				remains = getBuffRemain("player",_Heroism),
				up = UnitBuffID("player",_Heroism)
			},
			lavaSurge = {
				up = UnitBuffID("player",_LavaSurge)
			},
			lightningShield = {
				up = UnitBuffID("player",_LightningShield),
				stacks = getBuffStacks("player",_LightningShield)
			}
		},
		enemiesIn10 = getEnemies("player",10),
		glyph = {
			thunderstorm = hasGlyph(612)
		},
		inCombat = isInCombat("player"),
		hp = getHP("player"),
		mana = getPower("player"),
		moving = isMoving("player"),
		spell = {
			ascendance = {
				cooldown = getSpellCD(165339)
			},
			elementalBlast = {
				cooldown = getSpellCD(_ElementalBlast)
			},
			lavaBurst = {
				cooldown = getSpellCD(_LavaBurst),
				castTime = select(4,GetSpellInfo(_LavaBurst))/1000
			}
		},
		talent = {
			ancestralSwiftness = isKnown(_AncestralSwiftness),
			elementalBlast = isKnown(_ElementalBlast),
			elementalMastery = isKnown(_ElementalMastery),
			liquidMagma = isKnown(_LiquidMagma),
			stormElementalTotem = isKnown(_StormElementalTotem),
			unleashedFury = isKnown(_UnleashedFury)
		},
		target = {
			debuff = {
				flameShock = {
					remains = getDebuffRemain(dynamicUnit.dyn40,_FlameShock,"player"),
					up = UnitDebuffID(dynamicUnit.dyn40,_FlameShock),

				}
			},
			timeToDie = getTimeToDie(dynamicUnit.dyn40),
			enemiesIn10 = getEnemies(dynamicUnit.dyn40,10)
		},
		time = BadBoy_data["Combat Started"] - GetTime(),
		totem = {
			air = {
				current = select(2,GetTotemInfo(4)),
				remains = select(4,GetTotemInfo(4)) - (GetTime() - select(3,GetTotemInfo(4))),
				up = select(2,GetTotemInfo(4)) ~= ""
			},
			earth = {
				current = select(2,GetTotemInfo(2)),
				remains = select(4,GetTotemInfo(2)) - (GetTime() - select(3,GetTotemInfo(2))),
				up = select(2,GetTotemInfo(2)) ~= ""
			},
			fire = {
				current = select(2,GetTotemInfo(1)),
				remains = select(4,GetTotemInfo(1)) - (GetTime() - select(3,GetTotemInfo(1))),
				up = select(2,GetTotemInfo(1)) ~= ""
			},
			air = {
				current = select(2,GetTotemInfo(3)),
				remains = select(4,GetTotemInfo(3)) - (GetTime() - select(3,GetTotemInfo(3))),
				up = select(2,GetTotemInfo(3)) ~= ""
			},
		},
	}


	-- Pause toggle
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then
		ChatOverlay("|cffFF0000BadBoy Paused",0)
		return
	end

	-- Food/Invis Check
	if canRun() ~= true then
		return false
	end

	if player.inCombat then
		-- Wind Shear
		if isChecked("Wind Shear") then
			castInterrupt(_WindShear,getValue("Wind Shear"))
		end
		-- Astral Shift if < 30%
		if isChecked("Astral Shift") and player.hp <= getValue("Astral Shift") then
			if castSpell("player",_AstralShift,true) then
				return
			end
		end
		-- Healing Stream if < 50%
		if isChecked("Healing Stream") == 1 and player.hp <= getValue("Healing Stream") then
			if castSpell("player",_HealingStreamTotem,true) then
				return
			end
		end
		-- Shamanistic Rage if < 80%
		if isChecked("Shamanistic Rage") == 1 and player.hp <= getValue("Shamanistic Rage") then
			if castSpell("player",_ShamanisticRage,true) then
				return
			end
		end
	end

--[[ 	-- On GCD After here
]]

	if castingUnit() then
		return
	end


	if isChecked("Healing Surge Toggle") and SpecificToggle("Healing Surge Toggle") == 1 and GetCurrentKeyBoardFocus() == nil then
		if castSpell("player",_HealingSurge,true,true) then return; end
	end

		if isInCombat("player") then
	-- In-combat potion is preferentially linked to Ascendance, unless combat will end shortly
	-- potion,name=draenic_intellect,if=buff.ascendance.up|target.time_to_die<=30
	-- berserking,if=!buff.bloodlust.up&!buff.elemental_mastery.up&(set_bonus.tier15_4pc_caster=1|(buff.ascendance.cooldown_remains=0&(dot.flame_shock.remains>buff.ascendance.duration|level<87)))
	-- blood_fury,if=buff.bloodlust.up|buff.ascendance.up|((cooldown.ascendance.remains>10|level<87)&cooldown.fire_elemental_totem.remains>10)
	-- arcane_torrent

		-- flametongue_weapon,weapon=main
		if isChecked("Flametongue Weapon") and GetWeaponEnchantInfo() ~= 1 then
			if castSpell("player",_FlametongueWeapon,true) then
				return
			end
		end

		-- lightning_shield,if=!buff.lightning_shield.up
		if isChecked("Lightning Shield") and not player.buff.lightningShield then
			if castSpell("player",_LightningShield,true) then
				return
			end
		end

	--[[












	]]

		-- elemental_mastery,if=action.lava_burst.cast_time>=1.2
		if player.talent.elementalMastery and player.spell.lavaBurst.cooldown >= 1.2 then
			if castSpell("player",_ElementalMastery,true) then
				return
			end
		end
		-- ancestral_swiftness,if=!buff.ascendance.up
		if player.talent.ancestralSwiftness and not player.buff.ascendance then
			if castSpell("player",_Ascendance,true,false) then
				return
			end
		end
		-- storm_elemental_totem
		if player.talent.stormElementalTotem then
			if castSpell("player",_StormElementalTotem) then
				return
			end
		end
		-- fire_elemental_totem,if=!active
		if player.totem.fire ~= GetSpellInfo(_FireElementalTotem) then
			if castSpell("player",_FireElementalTotem,true,false) then
				return
			end
		end
		-- ascendance,if=active_enemies>1|
		if not player.buff.ascendance.up and player.spell.ascendance.cooldown == 0 and (#player.target.enemiesIn10 > 1
		  -- (dot.flame_shock.remains>buff.ascendance.duration&(target.time_to_die<20|buff.bloodlust.up|time>=60)
		  or (player.target.debuff.flameShock.remains > player.buff.ascendance.duration and (player.target.timeToDie < 20 or player.buff.bloodlust.up or player.time >= 60)
			-- &cooldown.lava_burst.remains>0)
		  and player.spell.lavaBurst.cooldown > 0)) then
		  	if castSpell("player",_Ascendance,true,false) then
		  	 	return
		  	end
		end
		-- liquid_magma,if=pet.searing_totem.remains>=15|pet.fire_elemental_totem.remains>=15
		if (player.totem.fire.current == GetSpellInfo(_SearingTotem) or player.totem.fire.current == GetSpellInfo(_FireElementalTotem))
		  and player.totem.fire.remains > 15 then
		  	if castSpell("player",_LiquidMagma,true,false) then
	  			return
	  		end
	  	end
		-- #If only one enemy, priority follows the 'single' action list.
		-- call_action_list,name=single,if=active_enemies=1
		if #player.target.enemiesIn10 == 1 then
			-- #Single target action priority list
			-- unleash_flame,moving=1
			if player.moving then
				if castSpell(dynamicUnit.dyn40,_UnleashFlame,false,false) then
					return
				end
			end
			-- spiritwalkers_grace,moving=1,if=buff.ascendance.up
			if player.moving and player.buff.ascendance.up then
				if castSpell("player",_SpiritwalkersGrace,true,false) then
					return
				end
			end
			-- earth_shock,if=buff.lightning_shield.react=buff.lightning_shield.max_stack
			if player.buff.lightningShield.up and player.buff.lightningShield.stacks == 15 then
				if castSpell(dynamicUnit.dyn40,_EarthShock,false,false) then
					return
				end
			end
			-- lava_burst,if=dot.flame_shock.remains>cast_time&(buff.ascendance.up|cooldown_react)
			if player.target.debuff.flameShock.remains > player.spell.lavaBurst.castTime
			  and (player.buff.ascendance.up or player.spell.lavaBurst.cooldown <= 0.5) then
			  	if castSpell(dynamicUnit.dyn40,_LavaBurst,false,true) then
			  		return
			  	end
			end
			-- unleash_flame,if=talent.unleashed_fury.enabled&!buff.ascendance.up
			if player.talent.unleashedFury and not player.buff.ascendance.up then
				if castSpell(dynamicUnit.dyn40,_UnleashFlame,false,false) then
					return
				end
			end
			-- flame_shock,if=dot.flame_shock.remains<=9
			if player.target.debuff.flameShock.remains <= 9 then
				if castSpell(dynamicUnit.dyn40,_FlameShock,false,false) then
					return
				end
			end
			-- earth_shock,if=(set_bonus.tier17_4pc&buff.lightning_shield.react>=15&!buff.lava_surge.up)|(!set_bonus.tier17_4pc&buff.lightning_shield.react>15)
			if player.buff.lightningShield.stacks == 15 then
				if castSpell(dynamicUnit.dyn40,_EarthShock,false,false) then
					return
				end
			end
			-- earthquake,if=!talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=(1.875+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&buff.elemental_mastery.down&buff.bloodlust.down
			-- earthquake,if=!talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=1.3*(1.875+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&(buff.elemental_mastery.up|buff.bloodlust.up)
			-- earthquake,if=!talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=(1.875+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&(buff.elemental_mastery.remains>=10|buff.bloodlust.remains>=10)
			-- earthquake,if=talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&buff.elemental_mastery.down&buff.bloodlust.down
			-- earthquake,if=talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=1.3*((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&(buff.elemental_mastery.up|buff.bloodlust.up)
			-- earthquake,if=talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&(buff.elemental_mastery.remains>=10|buff.bloodlust.remains>=10)

			-- elemental_blast
			if castSpell(dynamicUnit.dyn40,_ElementalBlast,false,true) then
				return
			end
			-- #After the initial Ascendance, use Flame Shock pre-emptively just before Ascendance to guarantee Flame Shock staying up for the full duration of the Ascendance buff
			-- flame_shock,if=time>60&remains<=buff.ascendance.duration&cooldown.ascendance.remains+buff.ascendance.duration<duration
			if player.time > 60 and player.target.debuff.flameShock < player.buff.ascendance.remains
			  and player.spell.ascendance.cooldown + player.buff.ascendance.duration < player.target.debuff.flameShock.remains then
			  	if castSpell(dynamicUnit.dyn40,_FlameShock,false,false) then
			  		return
			  	end
			end
			-- #Keep Searing Totem up, unless Fire Elemental Totem is coming off cooldown in the next 20 seconds
			-- searing_totem,if=(!talent.liquid_magma.enabled&!totem.fire.active)
			if (not player.talent.liquidMagma and not player.totem.fire.up)
			  -- |(talent.liquid_magma.enabled&pet.searing_totem.remains<=20
			  or (player.talent.liquidMagma and not (player.totem.fire.current ~= GetSpellInfo(_SearingTotem) and pet.totem.fire.remains <= 20)
			  -- &!pet.fire_elemental_totem.active
			  and player.totem.fire.current ~= GetSpellInfo(_FireElementalTotem)
			  -- &!buff.liquid_magma.up)
			  and not player.buff.liquidMagma.up) then
			  	if castSpell("player",_SearingTotem,true,false) then
			  		return
			  	end
			end

			-- spiritwalkers_grace,moving=1,if=((talent.elemental_blast.enabled&cooldown.elemental_blast.remains=0)
			if player.moving and ((player.talent.elementalBlast and player.spell.elementalBlast.cooldown == 0)
			  -- |(cooldown.lava_burst.remains=0&!buff.lava_surge.react))
			  or (player.spell.lavaBurst.cooldown == 0 and player.buff.lavaSurge.up)) then
				if castSpell("player",_SpiritwalkersGrace,true,false) then
					return
				end
			end
			-- thunderstorm,mana<70
			if player.mana < 70 and (player.enemiesIn10 == 0 or player.glyph.thunderstorm) then
				if castSpell("player",_Thunderstorm,true,false) then
					return
				end
			end
			-- lightning_bolt
			if castSpell(dynamicUnit.dyn40,_LightningBolt,false,true) then
				return
			end
		else
			-- #Multi target action priority list

			-- earthquake,cycle_targets=1,if=!ticking&(buff.enhanced_chain_lightning.up|level<=90)&active_enemies>=2

			-- lava_beam
			if player.buff.ascendance.up then
				if castSpell(dynamicUnit.dyn40,_LavaBeam,false,true) then
					return
				end
			end
			-- earth_shock,if=buff.lightning_shield.react=buff.lightning_shield.max_stack
			if player.buff.lightningShield.up and player.buff.lightningShield.stacks == 15 then
				if castSpell(dynamicUnit.dyn40,_EarthShock,false,false) then
					return
				end
			end
			-- thunderstorm,if=active_enemies>=10
			if #player.enemiesIn10 >= 10 then
				if castSpell("player",_Thunderstorm,true,false) then
					return
				end
			end
			-- searing_totem,if=(!talent.liquid_magma.enabled&!totem.fire.active)
			if (not player.talent.liquidMagma and not player.totem.fire.up)
			  -- |(talent.liquid_magma.enabled&pet.searing_totem.remains<=20
			  or (player.talent.liquidMagma and not (player.totem.fire.current ~= GetSpellInfo(_SearingTotem) and pet.totem.fire.remains <= 20)
			  -- &!pet.fire_elemental_totem.active
			  and player.totem.fire.current ~= GetSpellInfo(_FireElementalTotem)
			  -- &!buff.liquid_magma.up)
			  and not player.buff.liquidMagma.up) then
			  	if castSpell("player",_SearingTotem,true,false) then
			  		return
			  	end
			end
			-- chain_lightning,if=active_enemies>=2
			if #player.target.enemiesIn10 > 2 then
				if castSpell(dynamicUnit.dyn40,_ChainLightning,false,true) then
					return
				end
			end
			-- lightning_bolt
			if castSpell(dynamicUnit.dyn40,_LightningBolt,false,true) then
				return
			end
		end
	end

--[[



















]]
end
end