if select(3,UnitClass("player")) == 1 then

function ArmsWarrior()

if Currentconfig ~= "Arms Avery/Chumii" then
 WarriorArmsConfig();
 WarriorArmsToggles()
 Currentconfig = "Arms Avery/Chumii";
end

--[[Queues]]
if _Queues == nil then
 _Queues = {
    [Shockwave] = false, -- Shockwave
    [Bladestorm] = false,
    [DragonRoar] = false,
 }
end

if isChecked("Rotation Up") then
		if SpecificToggle("Rotation Up") == 1 and GetCurrentKeyBoardFocus() == nil then
	 	if myTimer == nil or myTimer <= GetTime() -0.7 then
	  		myTimer = GetTime()
	  		ToggleValue("AoE");
	 	end
	end
end
if isChecked("Rotation Down") then
    if SpecificToggle("Rotation Down") == 1 and GetCurrentKeyBoardFocus() == nil then
	 	if myTimer == nil or myTimer <= GetTime() -0.7 then
	  		myTimer = GetTime()
	  		ToggleMinus("AoE");
	 	end
	end
end

-- Locals
	local rage = UnitPower("player");
	local myHP = getHP("player");
	local ennemyUnits = getNumEnnemies("player", 5)

	local GT = GetTime()
	local CS_START, CS_DURATION = GetSpellCooldown(ColossusSmash)
	local CS_COOLDOWN = (CS_START - GT + CS_DURATION)
	local BLADESTORM = UnitBuffID("player",Bladestorm)
	local DS_START, DS_DURATION = GetSpellCooldown(DisruptingShout)
	local DS_COOLDOWN = (DS_START - GT + DS_DURATION)

-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then return false; end

-- Pause 
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then ChatOverlay("|cffFF0000BadBoy Paused", 0); return; end

-- HeroicLeapKey 
	 if isChecked("HeroicLeapKey") and SpecificToggle("HeroicLeapKey") == 1 then 
 		if not GetCurrentKeyBoardFocus() and not IsMouselooking() then
   			CastSpellByName(GetSpellInfo(6544))
   		if SpellIsTargeting() then 
   			CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop() 
   			return true;
  		end
  	end
 	end

	if not isInCombat("player") then
---------------------
--- Out of Combat ---
---------------------

-- Shout
	if isChecked("ShoutOOC") == true then
		if isChecked("Shout") == true then
			--Commanding
			if getValue("Shout") == 1 and not UnitBuffID("player",CommandingShout) then
				if castSpell("player",CommandingShout,true) then
					return;
				end
			end
			-- Battle
			if getValue("Shout") == 2 and not UnitBuffID("player",BattleShout) then
				if castSpell("player",BattleShout,true) then
					return;
				end
			end
		end
	end

	--[[Charge if getDistance > 10]]
		if isChecked("Charge") == true and canAttack("target","player") and not UnitIsDeadOrGhost("target") and getDistance("player","target") > 10 then
			if targetDistance <= 40 and getGround("target") == true and UnitExists("target") then
				if castSpell("target",100,false,false) then return; end
			end
		end

	end
	if pause() ~= true and isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then			
-----------------
--- In Combat ---
-----------------
	EvilEye();

	-- Dummy Test
				if isChecked("DPS Testing") then
					if UnitExists("target") then
						if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then  
							StopAttack()
							ClearTarget()
							print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
						end
					end
				end

--------------------
--- Queue Spells ---
--------------------

if _Queues[Shockwave] == true then
 if castSpell("target",Shockwave,false,false) then return; end
end
if _Queues[Bladestorm] == true then
 if castSpell("target",Bladestorm,false,false) then return; end
end
if _Queues[DragonRoar] == true then
 if castSpell("target",DragonRoar,false,false) then return; end
end

------------------
--- Offensives ---
------------------

		-- Recklessness
		-- actions+=/recklessness,if=!talent.bloodbath.enabled&((cooldown.colossus_smash.remains<2|debuff.colossus_smash.remains>=5)
			-- &(target.time_to_die>(192*buff.cooldown_reduction.value)|target.health.pct<20))
			--|buff.bloodbath.up&(target.time_to_die>(192*buff.cooldown_reduction.value)|target.health.pct<20)|target.time_to_die<=12
        if isChecked("Recklessness") == true then
        	if getValue("Recklessness") == 2 and isBoss("target") or isDummy("target") then
        		if not isKnown(Bloodbath) 
        			and ((getSpellCD(ColossusSmash) < 2 or getDebuffRemain("target",ColossusSmash) >= 5)
        			and ((getTimeToDie("target") > 192*CD_Reduction_Value) or getHP("target") < 20))
        			or UnitBuffID("player",Bloodbath)
        			and ((getTimeToDie("target") > 192*CD_Reduction_Value) 
        			or getHP("target") < 20 
        			or getTimeToDie("target") <= 12) then
		        		if castSpell("player",Recklessness,true) then
		        			return;
		        		end
		     	end
        	elseif getValue("Recklessness") == 1 then
        		if not isKnown(Bloodbath) 
        			and ((getSpellCD(ColossusSmash) < 2 or getDebuffRemain("target",ColossusSmash) >= 5)
        			and ((getTimeToDie("target") > 192*CD_Reduction_Value) or getHP("target") < 20))
        			or UnitBuffID("player",Bloodbath)
        			and ((getTimeToDie("target") > 192*CD_Reduction_Value) 
        			or getHP("target") < 20 
        			or getTimeToDie("target") <= 12) then
		        		if castSpell("player",Recklessness,true) then
		        			return;
		        		end
		     	end
        	end
        end

        -- SkullBanner
        -- actions+=/skull_banner,if=buff.skull_banner.down&(((cooldown.colossus_smash.remains<2|debuff.colossus_smash.remains>=5)
        	-- &target.time_to_die>192&buff.cooldown_reduction.up)|buff.recklessness.up)
        if isChecked("SkullBanner") == true then
        	if getValue("SkullBanner") == 2 and isBoss("target") or isDummy("target") then
        		if not UnitBuffID("player",SkullBanner)
        		and (((getSpellCD(ColossusSmash) < 2 or getDebuffRemain("target",ColossusSmash) >= 5)
        			and getTimeToDie("target") > 192*CD_Reduction_Value)
        		or UnitBuffID("player",Recklessness)) then
	        		if castSpell("player",SkullBanner,true) then
	        			return;
	        		end
	        	end
        	elseif getValue("SkullBanner") == 1 then
        		if not UnitBuffID("player",SkullBanner)
        		and (((getSpellCD(ColossusSmash) < 2 or getDebuffRemain("target",ColossusSmash) >= 5)
        			and getTimeToDie("target") > 192*CD_Reduction_Value)
        		or UnitBuffID("player",Recklessness)) then
	        		if castSpell("player",SkullBanner,true) then
	        			return;
	        		end
	        	end
        	end
        end

        -- Avatar 
        -- actions+=/avatar,if=enabled&(buff.recklessness.up|target.time_to_die<=25)
        if isChecked("Avatar") == true then
        	if getValue("Avatar") == 2 and isBoss("target") or isDummy("target") then
        		if UnitBuffID("player",Recklessness) or getTimeToDie("target") <= 25 then
	        		if castSpell("player",Avatar,true) then
	        			return;
	        		end
	        	end
        	elseif getValue("Avatar") == 1 then
        		if UnitBuffID("player",Recklessness) or getTimeToDie("target") <= 25 then
	        		if castSpell("player",Avatar,true) then
	        			return;
	        		end
	        	end
        	end
        end

        -- Racial
        -- if=buff.cooldown_reduction.down&(buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up))|buff.cooldown_reduction.up&buff.recklessness.up
		if isChecked("Racial") == true then
        	if getValue("Racial") == 2 and isBoss("target") or isDummy("target") then
        		if CD_Reduction_Value == 1 and (UnitBuffID("player",Bloodbath) or (not isKnown(Bloodbath) and UnitDebuffID("target",ColossusSmash)))
        		or CD_Reduction_Value ~= 1 and UnitBuffID("player",Recklessness) then
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
        	elseif getValue("Racial") == 1 then
        		if CD_Reduction_Value == 1 and (UnitBuffID("player",Bloodbath) or (not isKnown(Bloodbath) and UnitDebuffID("target",ColossusSmash)))
        		or CD_Reduction_Value ~= 1 and UnitBuffID("player",Recklessness) then
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

        --actions+=/mogu_power_potion,if=(target.health.pct<20&buff.recklessness.up)|buff.bloodlust.react|target.time_to_die<=25
        if (getHP("target") <= 20 and UnitBuffID("player",Recklessness)) or hasLust() or getTimeToDie("target") <= 25 then
        	if isBoss("target") or isDummy("target") then	
	        	if canUse(76095) then
					UseItemByName(tostring(select(1,GetItemInfo(76095))))
				end
			end
		end

------------------
--- Defensives ---
------------------
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

		-- ShieldWall
		if isChecked("ShieldWall") == true then
			if getHP("player") <= getValue("ShieldWall") then
				if castSpell("player",ShieldWall,true) then
					return;
				end
			end
		end

		-- Healthstone
        if isChecked("Healthstone") == true then
			if getHP("player") <= getValue("Healthstone") then
					useItem(5512)
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
------------------
--- Interrupts ---
------------------

		--Quaking Palm
		if isChecked("Quaking Palm") and canInterrupt(107079,tonumber(getValue("Quaking Palm"))) then
			if castSpell("target",107079,false) then
				return;
			end
		end

-- if myTimer == nil or myTimer <= GetTime() - 1 then
--  if canInterrupt(Pummel,1) then
--   print("Pummel")
--   if castSpell("target",Pummel,false,false) then

--    myTimer = GetTime()
--    return;
--   end
--  end
--  if canInterrupt(DisruptingShout,1) then
--  	print("DShout")
--   if castSpell("target",DisruptingShout,true,false) then
--    myTimer = GetTime()
--    return;
--   end
--  end
-- end

		-- --Pummel
		-- if isChecked("Pummel") == true and canInterrupt(Pummel,tonumber(getValue("Pummel"))) then
		-- 	if isChecked("Disrupting Shout") == true then
		-- 		if (DS_COOLDOWN <= 39  and DS_COOLDOWN > 0) then
		-- 			if castSpell("target",Pummel,false) then
		-- 				return; 
		-- 			end
		-- 		end
		-- 	elseif isChecked("Disrupting Shout") == false then
		-- 		if castSpell("target",Pummel,false) then
		-- 			return; 
		-- 		end
		-- 	end
		-- end

		-- --Disrupting Shout
		-- if isChecked("Disrupting Shout") == true and canInterrupt(DisruptingShout,tonumber(getValue("Disrupting Shout"))) then
		-- 	if castSpell("target",DisruptingShout,false) then
		-- 		return; 
		-- 	end
		-- end

		if isCasting() then return false; end
		if targetDistance > 5 and targetDistance <= 40 then
--------------------
--- Out of Range ---
--------------------

			--Auto Charge
			if isChecked("Charge") == true and canAttack("target","player") and not UnitIsDeadOrGhost("target") and getDistance("player","target") > 10 then
				if targetDistance <= 40 and getGround("target") == true and UnitExists("target") then
					if castSpell("target",100,false,false) then return; end
				end
			end

		elseif UnitExists("target") and not UnitIsDeadOrGhost("target") and isEnnemy("target") == true and getCreatureType("target") == true then
----------------
--- In Range ---
----------------

			-- shout once to get starting rage
			if getCombatTime() < 5 then
				if isChecked("Shout") == true then
					--Commanding
					if getValue("Shout") == 1 then
						if castSpell("player",CommandingShout,true) then
							return;
						end
					end
					-- Battle
					if getValue("Shout") == 2 then
						if castSpell("player",BattleShout,true) then
							return;
						end
					end
				end
			end
--------------------
--- Do everytime ---
--------------------

			-- actions+=/bloodbath,if=enabled&(debuff.colossus_smash.remains>0.1|cooldown.colossus_smash.remains<5|target.time_to_die<=20)
			if getDebuffRemain("target",ColossusSmash) > 0.1 or getSpellCD(ColossusSmash) < 5 or getTimeToDie("target") <= 20 then
				if castSpell("player",Bloodbath,true) then
					return;
				end
			end
			-- actions+=/berserker_rage,if=buff.enrage.remains<0.5
			if getBuffRemain("player",Enrage) < 0.5 then
				if castSpell("player",BerserkerRage,true) then
					return;
				end
			end
---------------------
--- Single Target ---
---------------------
			if not useAoE() and targetDistance < 5 then 
				-- actions.single_target=heroic_strike,if=rage>115|(debuff.colossus_smash.up&rage>60&set_bonus.tier16_2pc_melee)
				if rage >= 115 or (UnitDebuffID("target",ColossusSmash,"player") and rage >= 60) then
					if castSpell("target",HeroicStrike,false,false) then
						return;
					end
				end
				-- actions.single_target+=/mortal_strike,if=dot.deep_wounds.remains<1.0|buff.enrage.down|rage<10
				if getDebuffRemain("target",DeepWounds,"player") <= 1 or not UnitBuffID("player",Enrage) or rage <= 10 then
					if castSpell("target",MortalStrike,false,false) then
						return;
					end
				end
				-- actions.single_target+=/colossus_smash,if=debuff.colossus_smash.remains<1.0
				if getDebuffRemain("target",ColossusSmash,"player") <= 1 then
					if castSpell("target",ColossusSmash,false,false) then
						return;
					end
				end
				-- # Use cancelaura (in-game) to stop bladestorm if CS comes off cooldown during it for any reason.
				-- actions.single_target+=/bladestorm,if=enabled,interrupt_if=!cooldown.colossus_smash.remains
				if isChecked("StormRoarST") == true then
					if (CS_COOLDOWN <= 1 or canCast(ColossusSmash,true)) and BLADESTORM ~= nil then
						RunMacroText("/cancelaura bladestorm")
						return false;
						else
							if IsSpellInRange(GetSpellInfo(HeroicStrike),"target") == 1 then
						  		if castSpell("target",Bladestorm,true) then
						   		return;
						  		end
						 	end
					end
				end
				-- actions.single_target+=/mortal_strike
				if castSpell("target",MortalStrike,false,false) then
						return;
					end
				-- actions.single_target+=/storm_bolt,if=enabled&debuff.colossus_smash.up
				if UnitDebuffID("target",ColossusSmash,"player") and getDistance("player","target") <= 30 then
					if castSpell("target",StormBolt,false,false) then
						return;
					end
				end
				-- actions.single_target+=/dragon_roar,if=enabled&debuff.colossus_smash.down
				if isChecked("StormRoarST") == true then
					if getDistance("player","target") <= 8 and not UnitDebuffID("target",ColossusSmash,"player") then
						if castSpell("target",DragonRoar,false,false) then
							return;
						end
					end
				end
				-- actions.single_target+=/execute,if=buff.sudden_execute.down|buff.taste_for_blood.down|rage>90|target.time_to_die<12
				if UnitBuffID("player",SuddenExecute) or not UnitBuffID("player",TasteforBlood) or rage > 90 or getTimeToDie("target") < 12 then
					if castSpell("target",Execute,false,false) then
						return;
					end
				end
				-- # Slam is preferable to overpower with crit procs/recklessness.
				-- actions.single_target+=/slam,if=target.health.pct>=20&(trinket.stacking_stat.crit.stack>=10|buff.recklessness.up)
				if getHP("target") >= 20 and (getBuffStacks("player",146293) >= 10 or UnitBuffID("player",Recklessness)) then
					if castSpell("target",Slam,false,false) then
						return;
					end
				end
				-- actions.single_target+=/overpower,if=target.health.pct>=20&rage<100|buff.sudden_execute.up
				if getHP("target") >= 20 and rage < 100 or UnitBuffID("player",SuddenExecute) then
					if castSpell("target",Overpower,false,false) then
						return;
					end
				end
				-- actions.single_target+=/execute
				if castSpell("target",Execute,false,false) then
						return;
				end
				-- actions.single_target+=/slam,if=target.health.pct>=20
				if getHP("target") >= 20 then
					if castSpell("target",Slam,false,false) then
						return;
					end
				end
				-- actions.single_target+=/heroic_throw
				if castSpell("target",HeroicThrow,false,false) then
						return;
				end
				-- actions.single_target+=/battle_shout
				if isChecked("Shout") == true then
					--Commanding
					if getValue("Shout") == 1 then
						if castSpell("player",CommandingShout,true) then
							return;
						end
					end
					-- Battle
					if getValue("Shout") == 2 then
						if castSpell("player",BattleShout,true) then
							return;
						end
					end
				end
			end
-----------
--- AoE ---
-----------
			if useAoE() then
				-- actions.aoe=sweeping_strikes
				if not UnitBuffID("player",SweepingStrikes) then
					if castSpell("player",SweepingStrikes,true) then
						return;
					end
				end
				-- actions.aoe+=/cleave,if=rage>110&active_enemies<=4
				if rage > 110 and getNumEnnemies("player",10) <= 4 then
					if castSpell("target",Cleave,false,false) then
						return;
					end
				end
				-- actions.aoe+=/bladestorm,if=enabled&(buff.bloodbath.up|!talent.bloodbath.enabled)
				if isChecked("StormRoar") == true then
					if isKnown(Bladestorm) then
						if UnitBuffID("player",Bloodbath) or not isKnown(Bloodbath) then
							if castSpell("target",Bladestorm,true) then
								return;
							end
						end
					end
				end
				-- actions.aoe+=/dragon_roar,if=enabled&debuff.colossus_smash.down
				if isChecked("StormRoar") == true then
					if getDistance("player","target") <= 8 and not UnitDebuffID("target",ColossusSmash,"player") then
						if castSpell("target",DragonRoar,false,false) then
							return;
						end
					end
				end
				-- actions.aoe+=/colossus_smash,if=debuff.colossus_smash.remains<1
				if getDebuffRemain("target",ColossusSmash,"player") <= 1 then
					if castSpell("target",ColossusSmash,false,false) then
						return;
					end
				end
				-- actions.aoe+=/thunder_clap,target=2,if=dot.deep_wounds.attack_power*1.1<stat.attack_power
				if not UnitDebuffID("target",DeepWounds,"player") then
					if castSpell("target",ThunderClap,true) then
						return;
					end
				end
				-- actions.aoe+=/mortal_strike,if=active_enemies=2|rage<50
				if rage < 50 then
					if castSpell("target",MortalStrike,false,false) then
						return;
					end
				end				
				-- actions.aoe+=/execute,if=buff.sudden_execute.down&active_enemies=2
				if not UnitBuffID("player",SuddenExecute) then
					if castSpell("target",Execute,false,false) then
						return;
					end
				end
				-- actions.aoe+=/slam,if=buff.sweeping_strikes.up&debuff.colossus_smash.up
				if UnitBuffID("player",SweepingStrikes) and UnitDebuffID("target",ColossusSmash) then
					if castSpell("target",Slam,false,false) then
						return;
					end
				end
				-- actions.aoe+=/overpower,if=active_enemies=2
				if castSpell("target",Overpower,false,false) then
						return;
				end
				-- actions.aoe+=/slam,if=buff.sweeping_strikes.up
				if UnitBuffID("player",SweepingStrikes) then
					if castSpell("target",Slam,false,false) then
						return;
					end
				end
				-- actions.aoe+=/battle_shout
				if isChecked("Shout") == true then
					--Commanding
					if getValue("Shout") == 1 then
						if castSpell("player",CommandingShout,true) then
							return;
						end
					end
					-- Battle
					if getValue("Shout") == 2 then
						if castSpell("player",BattleShout,true) then
							return;
						end
					end
				end
			end

		end
	end
end
end
