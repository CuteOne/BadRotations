if select(3, UnitClass("player")) == 7 then
	function ShamanEnhancement()
	    if Currentconfig ~= "Enhancement CuteOne" then
	        EnhancementConfig();
	        Currentconfig = "Enhancement CuteOne";
	    end
	    if not canRun() then
	    	return true
	    end
		EnhanceReader()
		KeyToggles()
		makeEnemiesTable(40)
		
		----------------
		--Local Vars--
		----------------
		local UFtalent = getTalent(6,1)
		local as = UnitBuffID("player",  _AncestralSwiftness) 
		local ascandance = UnitBuffID("player",  _AscendanceBuff) 
		local elementalFusionTalent, efstack = getTalent(7,1), select(4,UnitBuffID("player",157174))
		local UnleashFlame = UnitBuffID("player",73683)
		local flameshock, flameshockDuration = UnitDebuffID(dynamicTarget(5,true),_FlameShock) ,getDebuffRemain(dynamicTarget(5,true),_FlameShock)
		local deadtar, attacktar, hastar, playertar = deadtar, attacktar, hastar, UnitIsPlayer("target")
			if deadtar == nil then deadtar = UnitIsDeadOrGhost("target") end
			if attacktar == nil then attacktar = UnitCanAttack("target", "player") end
			if hastar == nil then hastar = UnitExists("target") end
		local fs, fscd = UnitDebuffID(dynamicTarget(5,true), _FrostShock), getSpellCD(_FrostShock)
		local fncd = getSpellCD(_FireNova)
		local enemiesNear = getNumEnemies("player", 12)
		
		if FlameShockTargets == nil then
			FlameShockTargets = {}
		end
		
		--FlameShock Cleanup
		for i=1, #FlameShockTargets do
			if (GetTime() - FlameShockTargets[i].time) >= 40  then
				--print("Removing "..FlameShockTargets[i].unit.." Because of timeout")
				table.remove(FlameShockTargets, i)
				break
			end
         end
		
		-------------------------------------
		--- Shields Up! / Weapons Online! ---
		-------------------------------------
		if not IsMounted() then
			-- Lightning Shield
			if getBuffRemain("player",_LightningShield)<10 and getPower("player")>=5 then
				if castSpell("player",_LightningShield,true) then return; end
			end

			------------------
			--- Dummy Test ---
			------------------
			-- Dummy Test
			if BadBoy_data["Check DPS Testing"] == 1 then
				if UnitExists("target") then
					if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
						if castSpell("player",_TotemRecall,true) and hasTotem() then return; end
						StopAttack()
						ClearTarget()
						ChatOverlay(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
					end
				end
			end

			-----------------------
			--- Doge/Jebus Mode ---
			-----------------------
			-- Ghost Wolf
			if not IsMounted()
			and not UnitBuffID("player",_GhostWolf)
			and isMoving("player")
			and not castingUnit("player")
			and getBuffRemain("player",_AscendanceBuff)==0
			and (not isInCombat("player") or (isInCombat("player") and targetDistance>10)) then
				if castSpell("player",_GhostWolf,true) then return; end
			end
			-- Water Walking
			if IsSwimming() and not isInCombat("player") and not UnitBuffID("player",_WaterWalking) then
				if castSpell("player",_WaterWalking,true) then return; end
			end
			-- Ancestral Spirit
			if not isAlive("mouseover")
			and not isEnnemy("mouseover")
			and not castingUnit("player")
			and not isInCombat("player")
			and UnitIsPlayer("mouseover") then
				if castSpell("mouseover",_AncestralSpirit,true) then return; end
			end
			-- Healing Surge
			if not isInCombat("player")
			and getHP("player") < 75
			and not castingUnit("player")
			and not isMoving("player")
			and not isLooting("player") then
					if castSpell("player",_HealingSurge,true) then return; end
			end
			-- Spiritwalker's Grace
			if isMoving("player") and isInCombat("player") then
				if castSpell("player",_SpiritwalkersGrace,true) then return; end
			end

			--------------
			--- Totems ---
			--------------
			-- Recall
			if not isInCombat("player")
			and not hasHST()
			and hasTotem() then
				if castSpell("player",_TotemRecall,true) then return; end
			end
			-- Earth
			if not castingUnit("player")
			and canInterrupt(_GroundingTotem, tonumber(getValue("Interrupts")))
			and getSpellCD(_WindShear) > 0
			and getSpellCD(_WindShear) < 12 then
				if castSpell("player",_GroundingTotem,true) then return; end
			end
			if hasNoControl(_TremorTotem) then
				if castSpell("player",_TremorTotem,true) then return; end
			end
			if useCDs() and getSpellCD(_FireElementalTotem) > 0 and targetDistance <= 10 and isInCombat("player") then
				if castSpell("player",_EarthElementalTotem,true) then return; end
			end
			-- Fire
			if (not (hasSearing() or hasFireElemental()) or (hasSearing() and getTotemDistance("target") > 20)) and targetDistance<=20 and getNumEnemies("player",8)<6 and isInCombat("player") then
				if castSpell("player",_SearingTotem,true) then return; end
			end
			if (not (hasMagma() or hasFireElemental()) or (hasMagma() and getTotemDistance("target") > 8)) and targetDistance<8 and getNumEnemies("player",8)>=6 and isInCombat("player") then
				if castSpell("player",_MagmaTotem,true) then return; end
			end
			-- Wind
			if hasNoControl(_WindwalkTotem) then
				if castSpell("player",_WindwalkTotem,true) then return; end
			end
			-- Water
			if getHP("player") < 25 and not hasWater() then
				if castSpell("player",_HealingStreamTotem,true) then return; end
			end
			-- Heart?!?!!
			--No Captain Totem =(

			---------------------------
			--- Defensive Abilities ---
			---------------------------
			if not castingUnit("player") and isInCombat("player") then
				-- Gift of the Naaru
				if getHP("player") <= 25 then
					if castSpell("player",59547,true) then return; end
				end
				-- Shamanistic Rage
				if getHP("player") <= 70 then
					if castSpell("player",_ShamanisticRage,true) then return; end
				end
				-- Astral Shift
				if not castingUnit("player") and getHP("player")<=40 then
					if castSpell("player",_AstralShift,true) then return; end
				end
				-- Cleanse Spirit
				if canDispel("player",_CleanseSpirit) then
					if castSpell("player",_CleanseSpirit,true) then return; end
				end
				if canDispel("mouseover",_CleanseSpirit) and UnitIsPlayer("mouseover") then
					if castSpell("mouseover",_CleanseSpirit,true) then return; end
				end
			end

			------------------
			--- Interrupts ---
			------------------
			-- Wind Shear
			if canInterrupt(_WindShear, tonumber(getValue("Interrupts"))) then
				ChatOverlay(canInterrupt(_WindShear, tonumber(getValue("Interrupts"))))
				if castSpell("target",_WindShear,false) then return; end
			end

			-----------------
			--- Cooldowns ---
			-----------------
			if useCDs() and targetDistance<5 and isInCombat("player") and hasFire() then
				--Fire Elemental
				if castSpell("player",_FireElementalTotem,true) then return; end
				-- Feral Spirit
				if castSpell("player",_FeralSpirit,true) then return; end
				-- Elemental Mastery
				if castSpell("player",_ElementalMastery,true) then return; end
				-- Ancestral Swiftness
				if castSpell("player",_AncestralSwiftness,true) then return; end
				-- Ascendance
				if getBuffRemain("player",_AscendanceBuff) == 0 then
					if castSpell("player",_Ascendance,true) then return; end
				end
			end

			-------------
			--- Pause ---
			-------------
			if pause() 
			or SpellIsTargeting()
			or UnitInVehicle("player")
			or UnitIsDead("target") 
			or UnitIsDead("player") then
				return true
			end
			
			
			if hastar and attacktar and isInCombat("player") then
				-------------------------
				---Combat Rotation---
				-------------------------
				if not useAoE() then	
					--liquid_magma,if=pet.searing_totem.remains>=15|pet.magma_totem.remains>=15|pet.fire_elemental_totem.remains>=15
					if GetTotemTimeLeft(1)  >= 15 then
						if castSpell("player",_LiquidMagma,false) then return; end
					end
					
					
					--unleash_elements,if=(talent.unleashed_fury.enabled|set_bonus.tier16_2pc_melee=1)
					if UFtalent then
						if castSpell("player",_UnleashElements,false) then return; end
					end
					
					
					--elemental_blast,if=buff.maelstrom_weapon.react>=4|buff.ancestral_swiftness.up
					if getMWC() >= 4
					or as then
						if castSpell(dynamicTarget(40,true),_ElementalBlast,false) then return; end
					end
					
					--lightning_bolt,if=buff.maelstrom_weapon.react=5|(buff.maelstrom_weapon.react>=4&!buff.ascendance.up)|(buff.ancestral_swiftness.up&buff.maelstrom_weapon.react>=3)
					if (getMWC()==5)
					or (getMWC()>=4 and not ascandance)
					or ( as and getMWC()>=3)
					then
						if castSpell(dynamicTarget(40,true),_LightningBolt,false) then return; end
					end
					
					--Stormstrike
					if castSpell(dynamicTarget(5,true),_Stormstrike,false,false,false,true) then return; end

					-- Lava Lash
					if castSpell(dynamicTarget(5,true),_LavaLash,false) then return; end
					
					--flame_shock,if=(talent.elemental_fusion.enabled&buff.elemental_fusion.stack=2&buff.unleash_flame.up&dot.flame_shock.remains<16)|(!talent.elemental_fusion.enabled&buff.unleash_flame.up&dot.flame_shock.remains<=9)|!ticking
					if ( elementalFusionTalent and efstack == 2 and UnleashFlame and flameshockDuration <= 16)
					or ( not elementalFusionTalent and UnleashFlame and flameshockDuration <= 9)
					or (not flameshock) then
						if castSpell(dynamicTarget(25,true),_FlameShock,false) then return; end
					end
					
					-- Unleashed elements
					if castSpell("player",_UnleashElements,false) then return; end
					
					--frost_shock,if=(talent.elemental_fusion.enabled&dot.flame_shock.remains>=16)|!talent.elemental_fusion.enabled
					if (elementalFusionTalent and flameshockDuration > 16)
					or ( not elementalFusionTalent) then
						if castSpell(dynamicTarget(25,true),_FrostShock,false) then return; end
					end
					
					--elemental_blast,if=buff.maelstrom_weapon.react>=1
					if getMWC() >= 1 then
						if castSpell(dynamicTarget(40,true),_ElementalBlast,false) then return; end
					end
					
					--lightning_bolt,if=buff.maelstrom_weapon.react>=1&!buff.ascendance.up
					if getMWC() >= 1 
					and not ascendance then
						if castSpell(dynamicTarget(40,true),_LightningBolt,false) then return; end
					end
				end
				
				if useAoE() then
						
					enemiesNear = getNumEnemies("player" 12)
					
					--unleash_elements,if=active_enemies>=4&dot.flame_shock.ticking&(cooldown.shock.remains>cooldown.fire_nova.remains|cooldown.fire_nova.remains=0)
					if enemiesNear >= 4
					and #FlameShockTargets >= 1
					and ((fscd > fncd) or fncd ==0) then
						if castSpell("player",_UnleashElements,false) then return; end
					end
					
					--fire_nova,if=active_dot.flame_shock>=3
					if #FlameShockTargets >=3 then
						if castSpell("player",_FlameNova,false) then return; end
					end
					
					--lava_lash,if=dot.flame_shock.ticking&(active_dot.flame_shock<active_enemies)
					if UnitDebuffID("target", _FlameShock)
					and #FlameShockTargets < enemiesNear then
						if castSpell("target",_LavaLash,false) then return; end
					end
					
					--chain_lightning,if=glyph.chain_lightning.enabled&active_enemies>=4&(buff.maelstrom_weapon.react=5|(buff.ancestral_swiftness.up&buff.maelstrom_weapon.react>=3))
					
					
					--unleash_elements,if=active_enemies<4
					if enemiesNear < 4 then
						if castSpell("player",_UnleashElements,false) then return; end
					end
					
					--flame_shock,cycle_targets=1,if=!ticking
					if fscd == 0 then
						for i=1, #enemiesTable do
							if enemiesTable[i].distance<20 then
								if not UnitDebuffID(enemiesTable[i].unit, _FlameShock) then
									if castSpell(enemiesTable[i].unit,_FlameShock,false) then return end
								end							
							end
						end
					end
					--lightning_bolt,if=(!glyph.chain_lightning.enabled|active_enemies<=3)&(buff.maelstrom_weapon.react=5|(buff.ancestral_swiftness.up&buff.maelstrom_weapon.react>=3))
					--windstrike
					--elemental_blast,if=!buff.unleash_flame.up&buff.maelstrom_weapon.react>=1
					--chain_lightning,if=glyph.chain_lightning.enabled&active_enemies>=4&buff.maelstrom_weapon.react>=1
					
					--fire_nova,if=active_dot.flame_shock>=2
					if #FlameShockTargets >=2 then
						if castSpell(dynamicTarget(5,true),_FlameNova,false) then return; end
					end
					
					--Stormstrike
					if castSpell(dynamicTarget(5,true),_Stormstrike,false,false,false,true) then return; end
					
					--frost_shock,if=active_enemies<4
					if enemiesNear < 4 then
						if castSpell(dynamicTarget(5,true),_FrostShock,false) then return; end
					end
					
					--elemental_blast,if=buff.maelstrom_weapon.react>=1
					
					--chain_lightning,if=active_enemies>=3&buff.maelstrom_weapon.react>=1
					if enemiesNear >= 3
					and getMWC() >= 1 then
						if castSpell(dynamicTarget(5,true),_ChainLightning,false) then return; end
					end
					
					--lightning_bolt,if=active_enemies<3&buff.maelstrom_weapon.react>=1
					if enemiesNear < 3
					and getMWC() >= 1 then
						if castSpell(dynamicTarget(5,true),_LightningBolt,false) then return; end
					end
					
					--fire_nova,if=active_dot.flame_shock>=1
					if #FlameShockTargets >=1 then
						if castSpell(dynamicTarget(5,true),_FlameNova,false) then return; end
					end	
					
				 end-- End of UseAoE()
				
			end --Combat Rotation
		end	-- End IsMounted()
	end --Class Function End
end --Final End