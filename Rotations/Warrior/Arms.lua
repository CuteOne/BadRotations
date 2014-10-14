if select(3,UnitClass("player")) == 1 then

	function ArmsWarrior()

		if Currentconfig ~= "Arms Chumii" then
			WarriorArmsConfig();
			WarriorArmsToggles()
			Currentconfig = "Arms Chumii";
		end
	------------------------------------------------------------------------------------------------------
	-- Locals --------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		local rage = UnitPower("player");
		local myHP = getHP("player");
		--local ennemyUnits = getNumEnemies("player", 5)

		local GT = GetTime()
		local CS_START, CS_DURATION = GetSpellCooldown(ColossusSmashArms)
		local CS_COOLDOWN = (CS_START - GT + CS_DURATION)
		local RV_START, RV_DURATION = GetSpellCooldown(Ravager)
		local RV_COOLDOWN = (RV_START - GT + RV_DURATION)
		local BLADESTORM = UnitBuffID("player",Bladestorm)
		local DS_START, DS_DURATION = GetSpellCooldown(DisruptingShout)
		local DS_COOLDOWN = (DS_START - GT + DS_DURATION)
	------------------------------------------------------------------------------------------------------
	-- Food/Invis Check ----------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if canRun() ~= true or UnitInVehicle("Player") then
			return false;
		end
		if IsMounted("player") then
			return false;
		end
	------------------------------------------------------------------------------------------------------
	-- Pause ---------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then
			ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
		end
	------------------------------------------------------------------------------------------------------
	-- Spell Queue ---------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if _Queues == nil then
		 _Queues = {
				[Shockwave]  = false,
				[Bladestorm] = false,
				[DragonRoar] = false,
		 }
		end
	------------------------------------------------------------------------------------------------------
	-- Input / Keys --------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------------
	-- Out of Combat -------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		if not isInCombat("player") then
			-- actions.precombat+=/stance,choose=battle
			if GetShapeshiftForm() ~= 1 then
				if castSpell("player",BattleStance,true) then
					return;
				end
			end
			-- Commanding Shout
			if isChecked("Shout") and  getValue("Shout") == 1 then
		  	for i = 1, #members do
	  			if not isBuffed(members[i].Unit,{21562,109773,469,90364}) and (#members==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
	  				if castSpell("player",CommandingShout,true) then
	  					return;
	  				end
	  			end
		  	end
			end
			-- Battle Shout
			if isChecked("Shout") and  getValue("Shout") == 2 then
		  	for i = 1, #members do
	  			if not isBuffed(members[i].Unit,{57330,19506,6673}) and (#members==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
	  				if castSpell("player",BattleShout,true) then
	  					return;
	  				end
	  			end
		  	end
			end
		end -- Out of Combat end
	------------------------------------------------------------------------------------------------------
	-- In Combat -----------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
		-- if pause() ~= true and isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then
			if isInCombat("player") then
	------------------------------------------------------------------------------------------------------
	-- Dummy Test ----------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
			if isChecked("DPS Testing") then
				if UnitExists("target") then
					if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
						StopAttack()
						ClearTarget()
						print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
					end
				end
			end
	------------------------------------------------------------------------------------------------------
	-- Queued Spells -------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
			if _Queues[Shockwave] == true then
				if castSpell("target",Shockwave,false,false) then
					return;
				end
			end
			if _Queues[Bladestorm] == true then
				if castSpell("target",Bladestorm,false,false) then
					return;
				end
			end
			if _Queues[DragonRoar] == true then
				if castSpell("target",DragonRoar,false,false) then
					return;
				end
			end
	------------------------------------------------------------------------------------------------------
	-- Do everytime --------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------

			-- actions+=/auto_attack

	------------------------------------------------------------------------------------------------------
	-- Defensive Cooldowns -------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
			if isChecked("Defensive Mode") then
				if not UnitBuffID("player", 80169) -- Food
				and not UnitBuffID("player", 87959) -- Drink
				and not UnitCastingInfo("player")
				and not UnitChannelInfo("player")
				and not UnitIsDeadOrGhost("player")
				and isInCombat("player") then
					-- Die by the Sword
					if isChecked("DiebytheSword") == true then
						if getHP("player") <= getValue("DiebytheSword") then
							if castSpell("player",DiebytheSword,true) then
								return;
							end
						end
					end
					-- Rallying Cry
					if isChecked("RallyingCry") == true then
						if getHP("player") <= getValue("RallyingCry") then
							if castSpell("player",RallyingCry,true) then
								return;
							end
						end
					end
					-- Enraged Regeneration
					if isChecked("EnragedRegeneration") == true then
						if isKnown(EnragedRegeneration) and getHP("player") <= getValue("EnragedRegeneration") then
							if castSpell("player",EnragedRegeneration,true) then
								return;
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
					-- Vigilance Focus
					if isChecked("VigilanceFocus") == true then
						if getHP("focus") <= getValue("VigilanceFocus") then
							if castSpell("focus",Vigilance,false,false) then
								return;
							end
						end
					end
					-- Def Stance
					if isChecked("DefensiveStance") == true then
						if getHP("player") <= getValue("DefensiveStance") and GetShapeshiftForm() ~= 2 then
							if castSpell("player",DefensiveStance,true) then
								return;
							end
						elseif getHP("player") > getValue("DefensiveStance") and GetShapeshiftForm() ~= 1 then
							if castSpell("player",BattleStance,true) then
								return;
							end
						end
					end
				end -- Playerchecks end
			end -- isChecked("Defensive Mode") end
	------------------------------------------------------------------------------------------------------
	-- Offensive Cooldowns -------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
			if useCDs() and getDistance("player","target") <= 5 then
				--and targetDistance <= 5 then
				-- actions+=/potion,name=draenic_strength,if=(target.health.pct<20&buff.recklessness.up)|target.time_to_die<=25
				if isChecked("usePot") then
					if (getHP("target") < 20 and UnitBuffID("player",Recklessness)) or getTimeToDie <= 25 then
						if canUse(76095) then -- MoP Potion
							UseItemByName(tostring(select(1,GetItemInfo(76095))))
						elseif canUse(109219) then -- WoD Potion
							UseItemByName(tostring(select(1,GetItemInfo(109219))))
						end
					end
				end
				-- actions+=/recklessness,if=(target.time_to_die>190|target.health.pct<20)&(!talent.bloodbath.enabled&(cooldown.colossus_smash.remains<2|debuff.colossus_smash.remains>=5)|buff.bloodbath.up)|target.time_to_die<=10
				if isChecked("useRecklessness") then
					--if (getTimeToDie > 190 or getHP("target") < 20)
					if getHP("target") <20
					and (not isKnown(Bloodbath) and CS_COOLDOWN < 2 or getDebuffRemain("target",ColossusSmashArms,"player") >= 5)
					or UnitDebuffID("target",Bloodbath)
					or getTimeToDie("target") <= 10 then
						if castSpell("player",Recklessness,true) then
							return;
						end
					end
				end
				-- actions+=/bloodbath,if=(active_enemies=1&cooldown.colossus_smash.remains<5)|(active_enemies>=2&buff.ravager.up)|target.time_to_die<=20
				if isChecked("useBloodbath") then
					if (useAoE() and CS_COOLDOWN < 5)
					or (not useAoE() and UnitBuffID("player",Ravager))
					or getTimeToDie("target") <= 20 then
						if castSpell("player",Bloodbath,true) then
							return;
						end
					end
				end
				-- actions+=/avatar,if=buff.recklessness.up|target.time_to_die<=25
				if isChecked("useAvatar") then
					if isKnown(Avatar) and UnitBuffID("player",Recklessness) then
						--or getTimeToDie <= 25 then
						if castSpell("player",Avatar,true) then
							return;
						end
					end
				end
				-- actions+=/blood_fury,if=buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up)|buff.recklessness.up
				-- actions+=/berserking,if=buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up)|buff.recklessness.up
				if isChecked("useRacial") then
					if (isKnown(Bloodbath) and UnitBuffID("player",Bloodbath))
					or (not isKnown(Bloodbath) and UnitDebuffID("target",ColossusSmashArms,"player"))
					or UnitBuffID("player",Recklessness) then
						if select(2, UnitRace("player")) == "Troll" then
	        		if castSpell("player",26297,true) then
	        			return;
	        		end
	        	elseif select(2, UnitRace("player")) == "Orc" then
	        		if castSpell("player",20572,true) then
	        			return;
	        		end
	        	end
		      end
		    end
			end
	------------------------------------------------------------------------------------------------------
	-- Interrupts ----------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------------
	-- Single Target -------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
			if not useAoE() and getDistance("player","target") <= 5 then
			-- and targetDistance <= 5 then
				-- actions.single=rend,if=ticks_remain<2&target.time_to_die>4
				if not UnitDebuffID("target",Rend,"player")
				or (getDebuffRemain("target",Rend,"player") < 6 and getTimeToDie("target") > 4) then
					if castSpell("target",Rend,false,false) then
						return;
					end
				end
				-- actions.single+=/mortal_strike,if=target.health.pct>20
				if getHP("target") > 20 then
					if castSpell("target",MortalStrike,false,false) then
						return;
					end
				end
				-- actions.single+=/heroic_charge

				-- actions.single+=/ravager,if=cooldown.colossus_smash.remains<3
				if isKnown(Ravager) and CS_COOLDOWN < 3 then
					if castGround("target",Ravager,40) then
						return;
					end
        end
				-- actions.single+=/colossus_smash
				if castSpell("target",ColossusSmashArms,false,false) then
					return;
				end
				-- actions.single+=/storm_bolt,if=(cooldown.colossus_smash.remains>4|debuff.colossus_smash.up)&rage<90
				if isKnown(StormBolt) then
					if (CS_COOLDOWN > 4 or UnitDebuffID("target",ColossusSmashArms,"player")) and UnitPower("player") < 90 then
						if castSpell("target",StormBolt,false,false) then
							return;
						end
					end
				end
				-- actions.single+=/siegebreaker
				if isKnown(Siegebreaker) then
					if castSpell("target",Siegebreaker,false,false) then
						return;
					end
				end
				-- actions.single+=/dragon_roar,if=!debuff.colossus_smash.up
				if isChecked("StormRoarST") and isKnown(DragonRoar) then
					if not UnitDebuffID("target",ColossusSmashArms,"player") then
						if castSpell("target",DragonRoar,true) then
							return;
						end
					end
				end
				-- actions.single+=/ExecuteArms,if=(rage>60&cooldown.colossus_smash.remains>ExecuteArms_time)|debuff.colossus_smash.up|buff.sudden_death.up|target.time_to_die<5
				-- if UnitPower("player") > 60
				-- and UnitDebuffID("target",ColossusSmashArms,"player")
				-- or getTimeToDie("target") < 5 then
				--  if castSpell("target",ExecuteArms,false,false) then
				--  	return;
				--  end
				-- end
				-- actions.single+=/impending_victory,if=rage<30&!debuff.colossus_smash.up&target.health.pct>20
				if isKnown(ImpendingVictory) then
					if UnitPower("player") < 30 and not UnitDebuffID("target",ColossusSmashArms,"player") and getHP("target") > 20 then
						if castSpell("target",ImpendingVictory,false,false) then
							return;
						end
					end
				end
				-- actions.single+=/slam,if=(rage>20|cooldown.colossus_smash.remains>ExecuteArms_time)&target.health.pct>20
				if isKnown(Slam) then
					if UnitPower("player") > 20 and getHP("target") > 20 then
						if castSpell("target",Slam,false,false) then
							return;
						end
					end
				end
				-- actions.single+=/whirlwind,if=(rage>60|cooldown.colossus_smash.remains>ExecuteArms_time)&target.health.pct>20&!talent.slam.enabled
				if UnitPower("player") > 60 and getHP("target") > 20 then
					if castSpell("target",Whirlwind,true) then
						return;
					end
				end
				-- actions.single+=/shockwave
			end -- Single Target end
	------------------------------------------------------------------------------------------------------
	-- Multi Target --------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
			if useAoE() then
				-- actions.aoe=sweeping_strikes
				if not UnitBuffID("player",SweepingStrikes) then
					if castSpell("player",SweepingStrikes,true) then
						return;
					end
				end
				-- actions.aoe+=/heroic_charge

				-- actions.aoe+=/rend,if=active_enemies<=4&ticks_remain<2
				if getNumEnemies("player",8) <= 4 and getDebuffRemain("target",Rend,"player") < 6 then
				--if getDebuffRemain("target",Rend,"player") < 6 then
					if castSpell("target",Rend,false,false) then
						return;
					end
				end
				-- actions.aoe+=/ravager
				if castGround("target",Ravager,40) then
					return;
				end
				-- actions.aoe+=/colossus_smash
				if castSpell("target",ColossusSmashArms,false,false) then
					return;
				end
				-- actions.aoe+=/dragon_roar,if=!debuff.colossus_smash.up
				if isChecked("StormRoar") and isKnown(DragonRoar) then
					if not UnitDebuffID("target",ColossusSmashArms,"player") then
						if castSpell("target",DragonRoar,true) then
							return;
						end
					end
				end
				-- actions.aoe+=/ExecuteArms,if=active_enemies<=3&((rage>60&cooldown.colossus_smash.remains>ExecuteArms_time)|debuff.colossus_smash.up|target.time_to_die<5)
				if getNumEnemies("player",8) <= 3
				and (UnitPower("player") > 60
				or UnitDebuffID("target",ColossusSmashArms,"player")
				or getTimeToDie("target") < 5) then
				 if castSpell("target",ExecuteArms,false,false) then
				 	return;
				 end
				end
				-- actions.aoe+=/whirlwind,if=active_enemies>=4|(active_enemies<=3&(rage>60|cooldown.colossus_smash.remains>ExecuteArms_time)&target.health.pct>20)
				if getNumEnemies("player",8) >= 4
				or (getNumEnemies("player",8) <= 3
				and (UnitPower("player") > 60 and getHP("target") > 20)) then
					if castSpell("target",Whirlwind,true) then
						return;
					end
				end
				-- actions.aoe+=/bladestorm,interrupt_if=!cooldown.colossus_smash.remains|!cooldown.ravager.remains
				if isChecked("StormRoar") and isKnown(Bladestorm) then
					if (CS_COOLDOWN <= 1 or canCast(ColossusSmashArms,true)) and BLADESTORM ~= nil
					or (RV_COOLDOWN <= 1 or canCast(Ravager,true)) and BLADESTORM ~= nil then
						RunMacroText("/cancelaura bladestorm")
						return false;
					else
					  if castSpell("target",Bladestorm,true) then
					  	return;
					  end
					end
				end
				-- actions.aoe+=/rend,cycle_targets=1,if=!ticking
				if UnitPower("player") >= 30 and not isGarrMCd() then
					if isChecked("Multi-Rend") then
						for i = 1, GetTotalObjects(TYPE_UNIT) do
							local Guid = IGetObjectListEntry(i)
							ISetAsUnitID(Guid,"thisUnit");
							if getFacing("player","thisUnit") == true
								and getDebuffRemain("thisUnit",Rend) < 3
								and getTimeToDie("thisUnit") > 5
								and getDistance("thisUnit") < 5 then
									if castSpell("thisUnit",Rend,false) then
										return;
									end
							end
						end
					-- elseif getDebuffRemain("target",Rend) < 3 and targetDistance < 5 then
					-- 	if castSpell("target",Rend,false) then
					-- 		return;
					-- 	end
					end
				end
				-- actions.aoe+=/siegebreaker,if=active_enemies=2
				if isKnown(Siegebreaker) then
					if getNumEnemies("player",8) == 2 then
						if castSpell("target",Siegebreaker,false,false) then
							return;
						end
					end
				end
				-- actions.aoe+=/storm_bolt,if=cooldown.colossus_smash.remains>4|debuff.colossus_smash.up
				if isKnown(StormBolt) then
					if CS_COOLDOWN > 4 or UnitDebuffID("target",ColossusSmashArms,"player") then
						if castSpell("target",StormBolt,false,false) then
							return;
						end
					end
				end
				-- actions.aoe+=/shockwave
			end -- Multi Target end
	------------------------------------------------------------------------------------------------------
		end -- In Combat end
	end -- ArmsWarrior() end
end -- Class Check end