function AssassinationRogue()
	if select(3, UnitClass("player")) == 4 and GetSpecialization() == 1 then
		if Currentconfig ~= "Assassination CuteOne" then
			AssOptions()
			Currentconfig = "Assassination CuteOne"
		end
		if not canRun() then
	    	return true
	    end
		AssToggles()
		poisonData()
		makeEnemiesTable(40)
		-- if worgen==nil then
		-- 	worgen=false
		-- end
		-- if isInCombat("player") or UnitBuffID("player",68992) then
		-- 	worgen=true
		-- end
		-- if not isInCombat("player") and worgen==true and not UnitBuffID("player",68992) then
		-- 	if castSpell("player",68996,true,false,false) then worgen=false; return end
		-- end


-- --------------
-- --- Locals ---
-- --------------
	-- General Player Variables
		local profileStop = profileStop
		local lootDelay = getValue("LootDelay")
		local level = UnitLevel("player")
		local php = getHP("player")
		local power, powmax, powgen = getPower("player"), UnitPowerMax("player"), getRegen("player")
		local ttm = getTimeToMax("player")
		local enemies, enemiesList = #getEnemies("player",8), getEnemies("player",8)
		local falling, swimming = getFallTime(), IsSwimming()
		local oneHand, twoHand = IsEquippedItemType("One-Hand"), IsEquippedItemType("Two-Hand")
	--General Target Variables
		local tarUnit = {
		["dyn0"] = "target", --No Dynamic
		["dyn5"] = dynamicTarget(5,true), --Melee
		['dyn8AoE'] = dynamicTarget(8,false), --Pick Pocket
		["dyn10"] = dynamicTarget(10,true), --Sap
		["dyn20AoE"] = dynamicTarget(20,false), --Stealth
		["dyn25AoE"] = dynamicTarget(25,false), --Shadowstep
		["dyn40AoE"] = dynamicTarget(40,false), --Cloak and Dagger
		}
		local tarDist = {
		["dyn0"] = getDistance("player",tarUnit.dyn0),
		["dyn5"] = getDistance("player",tarUnit.dyn5),
		["dyn8AoE"] = getDistance("player",tarUnit.dyn8AoE),
		["dyn10"] = getDistance("player",tarUnit.dyn10),
		["dyn20AoE"] = getDistance("player",tarUnit.dyn20AoE),
		["dyn25AoE"] = getDistance("player",tarUnit.dyn25AoE),
		["dyn40AoE"] = getDistance("player",tarUnit.dyn40AoE),
		}
		local hasMouse, deadMouse, playerMouse, mouseDist = ObjectExists("mouseover"), UnitIsDeadOrGhost("mouseover"), UnitIsPlayer("mouseover"), getDistance("player","mouseover") 
		local hastar, deadtar, attacktar, playertar = ObjectExists(tarUnit.dyn0), UnitIsDeadOrGhost(tarUnit.dyn0), UnitCanAttack(tarUnit.dyn0, "player"), UnitIsPlayer(tarUnit.dyn0)
		local friendly = UnitIsFriend(tarUnit.dyn0, "player")
		local thp = getHP(tarUnit.dyn5)
		local ttd = getTimeToDie(tarUnit.dyn5)
		local enemies = #getEnemies("player",8)
	--Specific Player Variables
 		local combo = getCombo()
 		local stealth = getBuffRemain("player",_Stealth)~=0
 		local lethalRemain = getBuffRemain("player",_LethalPoison)
 		local nonlethalRemain = getBuffRemain("player",_NonLethalPoison)
 		local recRemain = getBuffRemain("player",_Recuperate)
 		local vanRemain = getBuffRemain("player",_VanishBuff)
 		local sndRemain = getBuffRemain("player",_SliceAndDice)
 		local blindside = UnitBuffID("player",_Blindside)
 		local srRemain = getBuffRemain("player",_ShadowReflection)
 		local antCharge = getCharges(_Anticipation)
 	--Specific Target Variables
 		local sapRemain = getDebuffRemain(tarUnit.dyn10,_Sap)
 		local rupRemain = getDebuffRemain(tarUnit.dyn5,_Rupture,"player")
 		local ctRemain = getDebuffRemain(tarUnit.dyn5,_CrimsonTempest,"player")
 		local rupDuration = getDebuffDuration(tarUnit.dyn5,_Rupture,"player")
 		local venRemain = getDebuffRemain(tarUnit.dyn5,_Vendetta,"player")
 		local ddRemain = getDebuffRemain(tarUnit.dyn5,_DeadlyPoison,"player")
 		local envRemain = getDebuffRemain(tarUnit.dyn5,_Envenom,"player")

 	-- Profile Stop
		if isInCombat("player") and profileStop==true then
			return true
		else
			profileStop=false
		end
----------------------------------
--- Poisons/Healing/Dispelling ---
----------------------------------
		if (isCastingSpell(_DeadlyPoison) and lethalRemain>5) or ((isCastingSpell(_LeechingPoison) and nonlethalRemain>5)) then
			RunMacroText("/stopcasting")
		end
	-- Leathal Poison
		if lethalRemain<5 and not isMoving("player") and not castingUnit("player") and not IsMounted() then
			if castSpell("player",_LethalPoison,true) then return end
		end
	-- Non-Leathal Poison
		if nonlethalRemain<5 and not isMoving("player") and not castingUnit("player") and not IsMounted() then
			if castSpell("player",_NonLethalPoison,true) then return end
		end
	-- Recuperate
		if php < 80 and recRemain==0 and combo>0 then
			if castSpell("player",_Recuperate,true,false,false) then return end
		end
	-- Cloak of Shadows
		if canDispel("player") then
			if castSpell("player",_CloakOfShadows,true,false,false) then return end
		end

	-- Pause
		if pause() then
			return true
		else
-------------
--- Buffs ---
-------------
    -- Flask / Crystal
	        if isChecked("Flask / Crystal") then
	            if (select(2,IsInInstance())=="raid" or select(2,IsInInstance())=="none") and not UnitBuffID("player",105689) then
	                if not UnitBuffID("player",127230) and canUse(86569) then
	                    UseItemByName(tostring(select(1,GetItemInfo(86569))))
	                end
	            end
	        end
------------------
--- Defensives ---
------------------
			if useDefensive() and not stealth then
	-- Evasion
				if php<50 then
					if castSpell("player",_Evasion,true,false,false) then return end
				end
	-- Combat Readiness
				if php<40 then
					if castSpell("player",_CombatReadiness,true,false,false) then return end
				end
	-- Recuperate
				if php<30 and combo>3 and recRemain==0 then
					if castSpell("player",_Recuperate) then return end
				end
	-- Vanish
				if php<15 then
					if castSpell("player",_Vanish) then StopAttack(); ClearTarget(); return end
				end
    		end
---------------------
--- Out of Combat ---
---------------------
			if not isInCombat("player") and not (IsMounted() or IsFlying() or UnitIsFriend(tarUnit.dyn0,"player")) then
	-- Stealth
				if isChecked("Stealth") 
					and (stealthTimer == nil or stealthTimer <= GetTime()-getValue("Stealth Timer")) 
					and getCreatureType(tarUnit.dyn0) == true and not stealth 
				then
					-- Always
					if getValue("Stealth") == 1 then 
						if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
					end
					-- Pre-Pot
					if getValue("Stealth") == 2 and getBuffRemain("player",105697) > 0 and tarDist.dyn20AoE < 20 then
						if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
					end
					-- 20 Yards
					if getValue("Stealth") == 3 and tarDist.dyn20AoE < 20 then
						if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
					end
				end
				if ObjectExists(tarUnit.dyn0) and stealth then 
	-- Shadowstep
					if tarDist.dyn25AoE < 25 and tarDist.dyn25AoE >= 8 and getTalent(4,2) and (select(2,IsInInstance())=="none" or hasThreat(tarUnit.dyn25AoE)) then
						if castSpell(tarUnit.dyn25AoE,_Shadowstep,false,false,false) then return end
					end
	-- Cloak and Dagger
					if tarDist.dyn40AoE < 40 and tarDist.dyn40AoE >= 8 and getTalent(4,1) and (select(2,IsInInstance())=="none" or hasThreat(tarUnit.dyn40AoE)) then
						if castSpell(tarUnit.dyn40AoE,_Ambush,false,false,false,false,false,true) then return end
					end
	-- Sap
					if noattack() and sapRemain==0 and level>=15 and tarDist.dyn10 < 8 then
						if castSpell(tarUnit.dyn10,_Sap,false,false,false) then return end
					end
	-- Pick Pocket
					if canPP() and not isPicked() and tarDist.dyn0 < 8 
						and (stealthTimer == nil or stealthTimer <= GetTime()-getValue("Stealth Timer"))  
					then
						if castSpell(tarUnit.dyn0,_PickPocket,true,false,false) then
							stealthTimer=GetTime();
						   	return
						end
					end
					if not noattack() and (isPicked() or level<15) then
	-- Ambush
						if combo<5 and power>60 then
							if castSpell(tarUnit.dyn5,_Ambush,false,false,false,false,true) then return end
						end
	-- 5 Combo Opener
						if combo == 5 then
							if power>25 and sndRemain<5 then
								if castSpell("player",_SliceAndDice,true,false,false) then return end
							end
							if power>25 and rupRemain<3 then
								if castSpell(tarUnit.dyn5,_Rupture,false,false,false) then return end
							end
							if power>35 and envRemain<2 then
								if castSpell(tarUnit.dyn5,_Envenom,false,false,false) then return end
							end
						end
	-- Mutilate
						if combo < 5 and power>55 then
							if castSpell(tarUnit.dyn5,_Mutilate,false,false,false) then return end
						end
					end
				end
			end
-----------------
--- In Combat ---
-----------------
			if isInCombat("player") and ObjectExists(tarUnit.dyn5) then
	------------------------------
	--- In Combat - Dummy Test ---
	------------------------------
		-- Dummy Test
				if isChecked("DPS Testing") then
					if ObjectExists("target") then
						if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
							StopAttack()
							ClearTarget()
							ChatOverlay(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
							profileStop = true
						end
					end
				end
	------------------------------
	--- In Combat - Interrupts ---
	------------------------------
				if useInterrupts() and not stealth then
	-- Kick
					if level>=18 then
						if castInterrupt(_Kick,getValue("Interrupt At")) then return end
					end
	-- Gouge
					if castInterrupt(_Gouge,getValue("Interrupt At")) then return end
	-- Blind
					if castInterrupt(_Blind,getValue("Interrupt At")) then return end
			    end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
				if useCDs() and not stealth and tarDist.dyn5<5 then
	-- Preparation
					--if=!buff.vanish.up&cooldown.vanish.remains>30
					if vanRemain==0 and getSpellCD(_Vanish)>30 then
						if castSpell("player",_Preparation,true,false,false) then return end
					end
	-- Trinkets
					--if=active_enemies>1|(debuff.vendetta.up&active_enemies=1)
					if enemies>1 or (venRemain>0 and enemies==1) then
						if canTrinket(13) and useCDs() then
							RunMacroText("/use 13")
							if IsAoEPending() then
								local X,Y,Z = ObjectPosition(Unit)
								CastAtPosition(X,Y,Z)
							end
						end
						if canTrinket(14) and useCDs() then
							RunMacroText("/use 14")
							if IsAoEPending() then
								local X,Y,Z = ObjectPosition(Unit)
								CastAtPosition(X,Y,Z)
							end
						end
					end
	-- Vanish
					--if=time>10&!buff.stealth.up
					if combo<5 and power<60 and getCombatTime()>10 then
						if castSpell("player",_Vanish,true,false,false) then return end
					end
	-- Shadow Reflection
					--if=cooldown.vendetta.remains=0
					if getSpellCD(_Vendetta)==0 then
						if castSpell(tarUnit.dyn20AoE,_ShadowReflection,true,false,false) then return end
					end
	-- Vendetta
					--if=buff.shadow_reflection.up|!talent.shadow_reflection.enabled
					if srRemain>0 or not getTalent(7,2) then
						if castSpell(tarUnit.dyn5,_Vendetta,false,false,false) then return end
		        	end
		        end
	------------------------------------------
	--- In Combat Rotation ---
	------------------------------------------
				if ObjectExists(tarUnit.dyn0) and stealth then 
	-- Shadowstep
					if tarDist.dyn25AoE < 25 and tarDist.dyn25AoE >= 8 and getTalent(4,2) and ((select(2,IsInInstance())=="none" and #members==1) or hasThreat(tarUnit.dyn25AoE)) then
						if castSpell(tarUnit.dyn25AoE,_Shadowstep,false,false,false) then return end
					end
	-- Cloak and Dagger
					if tarDist.dyn40AoE < 40 and tarDist.dyn40AoE >= 8 and getTalent(4,1) and ((select(2,IsInInstance())=="none" and #members==1) or hasThreat(tarUnit.dyn40AoE)) then
						if castSpell(tarUnit.dyn40AoE,_Ambush,false,false,false,false,false,true) then return end
					end
				end
	-- Rupture
				--if=combo_points=5&ticks_remain<3
				if combo==5 and rupRemain<3 and power>25 and tarDist.dyn5<5 then
					if castSpell(tarUnit.dyn5,_Rupture,false,false,false) then return end
				end
	-- Rupture - Multi-Dot
				--if=active_enemies>1&!ticking&combo_points=5
				if useAoE() and combo==5 and power>25 then
					if castDotCycle(100,_Rupture,false,false,0) then return end
				end
	-- Slice and Dice
				--if=buff.slice_and_dice.remains<5
				if not isKnown(_ImprovedSliceAndDice) and sndRemain<5 and power>25 and tarDist.dyn5<5 and combo>0 then
					if castSpell("player",_SliceAndDice,true,false,false) then return end
				end
	-- Marked for Death
				--if=combo_points=0
				if combo>0 and tarDist.dyn5<5 then
					if castSpell(tarUnit.dyn5,_MarkedForDeath,true,false,false) then return end
				end
	-- Crimson Tempest
				--if=combo_points>4&active_enemies>=4&remains<8
				if useAoE() and combo>4 and enemies>=4 and ctRemain<8 and power>35 then
					if castSpell(tarUnit.dyn8AoE,_CrimsonTempest,true,false,false) then return end
				end
	-- Fan of Knives
				--if=combo_points<5&active_enemies>=4
				if useAoE() and combo<5 and enemies>=4 and power>35 and tarDist.dyn5<5 then
					if castSpell("player",_FanOfKnives,true,false,false) then return end
				end
	-- Rupture
				--if=(remains<2|(combo_points=5&remains<=(duration*0.3)))&active_enemies=1
				if (rupRemain<2 or (combo==5 and rupRemain<=(rupDuration*0.3))) and enemies==1 and combo>0 and power>25 then
					if castSpell(tarUnit.dyn5,_Rupture,false,false,false) then return end
				end
	-- AoE
				if useAoE() then
	                for i = 1, #enemiesTable do
	                	if enemiesTable[i].distance<5 then
	                    	local thisunit = enemiesTable[i].unit
	                    	local ttd = getTimeToDie(thisUnit)
	                    	local thp = getHP(thisUnit)
	                    	local dpRemain = getDebuffRemain(thisUnit,_DeadlyPoison,"player")
	                    	local envRemain = getDebuffRemain(thisUnit,_Envenom,"player")
	                    	local venRemain = getDebuffRemain(thisUnit,_Vendetta,"player")
		-- Envenom
							--if=(combo_points>4&buff.envenom.remains<2&(cooldown.death_from_above.remains>2|!talent.death_from_above.enabled))&active_enemies<4&!dot.deadly_poison_dot.ticking
							if (combo>4 and envRemain<2 and (getSpellCD(_DeathFromAbove)>2 or not getTalent(7,3))) and enemies<4 and dpRemain==0 and power>35 then
								if castSpell(thisUnit,_Envenom,false,false,false) then return end
							end
		-- Eviscerate
							if (combo>4 or (combo>3 and ttd<3)) and level<20 and power>35 then
								if castSpell(thisUnit,_Eviscerate,false,false,false) then return end
							end
		-- Fan of Knives
							--if=active_enemies>2&!dot.deadly_poison_dot.ticking&debuff.vendetta.down
							if enemies>2 and dpRemain==0 and venRemain==0 and power>35 then
								if castSpell("player",_FanOfKnives,true,false,false) then return end
							end
		-- Mutilate
							--if=target.health.pct>35&combo_points<5&active_enemies=2&!dot.deadly_poison_dot.ticking&debuff.vendetta.down
							if (thp>=35 or level<40) and combo<5 and enemies==2 and dpRemain==0 and venRemain==0 and not blindside and power>55 then
								if castSpell(thisUnit,_Mutilate,false,false,false) then return end
							end
		-- Dispatch
							--if=(combo_points<5|(talent.anticipation.enabled&anticipation_charges<4))&active_enemies=2&!dot.deadly_poison_dot.ticking&debuff.vendetta.down
							if (combo<5 or (getTalent(6,3) and antCharge<4)) and enemies==2 and dpRemain==0 and venRemain==0 and ((power>30 and thp<35) or blindside) then
								if castSpell(thisUnit,_Dispatch,false,false,false) then return end
							end
		-- Mutilate
							--if=active_enemies=2&!dot.deadly_poison_dot.ticking&debuff.vendetta.down
							if (thp>=35 or level<40) and enemies==2 and dpRemain==0 and not blindside and venRemain==0 and power>55 then
								if castSpell(thisUnit,_Mutilate,false,false,false) then return end
							end
						end
					end
				else
		-- Envenom
					--if=(combo_points>4&buff.envenom.remains<2&(cooldown.death_from_above.remains>2|!talent.death_from_above.enabled))&active_enemies<4
					if (combo>4 and envRemain<2 and (getSpellCD(_DeathFromAbove)>2 or not getTalent(7,3))) and enemies<4 and power>35 then
						if castSpell(tarUnit.dyn5,_Envenom,false,false,false) then return end
					end
		-- Mutilate
					--if=target.health.pct>35&combo_points<5&active_enemies<5
					if (thp>=35 or level<40) and combo<5 and enemies<5 and not blindside and power>55 then
						if castSpell(tarUnit.dyn5,_Mutilate,false,false,false) then return end
					end
		-- Dispatch
					--if=(combo_points<5|(talent.anticipation.enabled&anticipation_charges<4))&active_enemies<4
					if (combo<5 or (getTalent(6,3) and antCharge<4)) and enemies<4 and ((power>30 and thp<35) or blindside) then
						if castSpell(tarUnit.dyn5,_Dispatch,false,false,false) then return end
					end
		-- Mutilate
					--if=active_enemies<5
					if (thp>=35 or level<40) and enemies<5 and power>55 and not blindside then
						if castSpell(tarUnit.dyn5,_Mutilate,false,false,false) then return end
					end
				end
			end --In Combat End
	-- Start Attack
			if tarDist.dyn5<5 and not stealth and isInCombat("player") and ObjectExists(tarUnit.dyn0) and profileStop==false then
				StartAttack()
			end
		end -- Pause End
	end --Rogue Function End
end --Class Check End
