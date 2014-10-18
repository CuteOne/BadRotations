if select(3, UnitClass("player")) == 7 then
	function ShamanEnhancement()
	    if Currentconfig ~= "Enhancement CuteOne" then
	        EnhancementConfig();
	        Currentconfig = "Enhancement CuteOne";
	    end
	    KeyToggles()
	    if not canRun() then
	    	return true
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
			and not isCasting("player")
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
			and not isCasting("player")
			and not isInCombat("player")
			and UnitIsPlayer("mouseover") then
				if castSpell("mouseover",_AncestralSpirit,true) then return; end
			end
			-- Healing Surge
			if not isInCombat("player")
			and getHP("player") < 75
			and not isCasting("player")
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
			if not isCasting("player") 
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
			if useCDs() and targetDistance <= 10 and isInCombat("player") and (not hasFire() or hasSearing()) then
				if castSpell("player",_FireElementalTotem,true) then return; end
			end
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
			if not isCasting("player") and isInCombat("player") then	
				-- Gift of the Naaru		
				if getHP("player") <= 25 then
					if castSpell("player",59547,true) then return; end
				end
				-- Shamanistic Rage
				if getHP("player") <= 70 then
					if castSpell("player",_ShamanisticRage,true) then return; end
				end
				-- Astral Shift
				if not isCasting("player") and getHP("player")<=40 then
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
			if pause() then
				return true
			end

			-----------------------------
			--- Multi-Target Rotation ---
			-----------------------------
			if getNumEnemies("player",10) >= 3 and targetDistance<5 and useAoE() and isEnnemy("target") and isAlive("target") then
				-- Flame Shock
				if getDebuffRemain("target",_FlameShock) < 3 then
					if castSpell("target",_FlameShock,false) then return; end								
				end
				-- Lava Lash
				if getDebuffRemain("target",_FlameShock)>0 then
					if castSpell("target",_LavaLash,false) then return; end
				end
				-- Fire Nova
				if getDebuffRemain("target",_FlameShock)>0 then
					if castSpell("target",_FireNova,true) then return; end
				end
				-- Unleash Elements
				if castSpell("target",_UnleashElements,true) then return; end
				-- Chain Lightning - 5 Maelstrom Weapon Stacks
				if getHP("player")>=50 and shouldBolt() then
					if castSpell("target",_ChainLightning,false) then return; end
				end
				if UnitLevel("player") >= 26 then
					if getBuffRemain("player",_AscendanceBuff)>0 then
						-- Stormblast
						if castSpell("target",_Stormblast,false,false,false,true) then return; end
					else
						-- Stormstrike
						if castSpell("target",_Stormstrike,false,false,false,true) then return; end
					end
				else
					-- Primal Strike
					if castSpell("target",_PrimalStrike,false) then return; end
				end
				-- Frost Shock
				if castSpell("target",_FrostShock,false) then return; end
			end --Multi-Target Rotation End

			------------------------------
			--- Single Target Rotation ---
			------------------------------
			if getNumEnemies("player",8) < 3 and targetDistance<5 and not useAoE() and isEnnemy("target") and isAlive("target") then		
				if getMWC()==5 then
					-- Lightning Bolt
					if castSpell("target",_LightningBolt,false) then return; end
				end
				if UnitLevel("player") >= 26 then
					if getBuffRemain("player",_AscendanceBuff)>0 then
						-- Stormblast
						if castSpell("target",_Stormblast,false,false,false,true) then return; end
					else
						-- Stormstrike
						if castSpell("target",_Stormstrike,false,false,false,true) then return; end
					end
				else
					-- Primal Strike
					if castSpell("target",_PrimalStrike,false) then return; end
				end
				-- Flame Shock	
				if getDebuffRemain("target",_FlameShock)==0 and getBuffRemain("player",_UnleashFlame)>0 then
					if castSpell("target",_FlameShock,false) then return; end
				end
				-- Flame Shock
				if getDebuffRemain("target",_FlameShock)>0 and getBuffRemain("player",_UnleashFlame)>0 then
					if castSpell("target",_FlameShock,false) then return; end
				end
				-- Flame Shock
				if getDebuffRemain("target",_FlameShock)==0 and getBuffRemain("player",_UnleashFlame)==0 and getSpellCD(_UnleashElements)>5 then
					if castSpell("target",_FlameShock,false) then return; end
				end
				-- Lava Lash
				if castSpell("target",_LavaLash,false) then return; end
				-- Fire Nova
				if getDebuffRemain("target",_FlameShock)>0 and getNumEnemies("player",10)>1 then
					if castSpell("target",_FireNova,true) then return; end
				end
				-- Unleash Elements
				if castSpell("target",_UnleashElements,false) then return; end
				-- Frost Shock
				if castSpell("target",_FrostShock,false) then return; end
				-- Lightning Bolt
				if shouldBolt() then
					if castSpell("target",_LightningBolt,false) then return; end
				end
			end --Single Target Rotation End
			
			if targetDistance<5 and isEnnemy("target") then
				StartAttack()
			end
		end
	end --Class Function End
end --Final End