if select(3, UnitClass("player")) == 4 then
	function AssassinationRogue()
		if Currentconfig ~= "Assassination CuteOne" then
			AssOptions()
			Currentconfig = "Assassination CuteOne"
		end
		if not canRun() then
	    	return true
	    end
		AssToggles()
		poisonAssData()
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
		if profileStop == nil then profileStop = false end
     	local enemies = #getEnemies("player",8)
     	local thisUnit = dynamicTarget(5,true)
 		local tarDist = getDistance("player","target")
 		local hasTarget = ObjectExists(thisUnit)
 		local hasMouse = ObjectExists("mouseover")
 		local level = UnitLevel("player")
 		local php = getHP("player")
 		local thp = getHP(thisUnit)
 		local combo = getCombo()
 		local power = getPower("player")
 		local powmax = UnitPowerMax("player")
 		local powgen = getRegen("player")
 		local ttd = getTimeToDie(thisUnit)
 		local ttm = getTimeToMax("player")
 		local deadtar = UnitIsDeadOrGhost(thisUnit)
 		local attacktar = canAttack("player", thisUnit)
 		local swimming = IsSwimming()
 		local stealth = getBuffRemain("player",_Stealth)~=0
 		local lethalRemain = getBuffRemain("player",_LethalPoison)
 		local nonlethalRemain = getBuffRemain("player",_NonLethalPoison)
 		local recRemain = getBuffRemain("player",_Recuperate)
 		local sapRemain = getDebuffRemain(thisUnit,_Sap)
 		local vanRemain = getBuffRemain("player",_VanishBuff)
 		local rupRemain = getDebuffRemain(thisUnit,_Rupture,"player")
 		local sndRemain = getBuffRemain("player",_SliceAndDice)
 		local ctRemain = getDebuffRemain(thisUnit,_CrimsonTempest,"player")
 		local blindside = UnitBuffID("player",_Blindside)
 		local rupDuration = getDebuffDuration(thisUnit,_Rupture,"player")
 		local srRemain = getBuffRemain("player",_ShadowReflection)
 		local venRemain = getDebuffRemain(thisUnit,_Vendetta,"player")
 		local ddRemain = getDebuffRemain(thisUnit,113780,"player")
 		local envRemain = getDebuffRemain(thisUnit,_Envenom,"player")
 		local antCharge = getCharges(_Anticipation)
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
			if not isInCombat("player") and not (IsMounted() or IsFlying() or UnitIsFriend("target","player")) then
	-- Stealth
				if isChecked("Stealth") 
					and (stealthTimer == nil or stealthTimer <= GetTime()-getValue("Stealth Timer")) 
					and getCreatureType("target") == true and not stealth 
				then
					-- Always
					if getValue("Stealth") == 1 then 
						if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
					end
					-- Pre-Pot
					if getValue("Stealth") == 2 and getBuffRemain("player",105697) > 0 and tarDist < 20 then
						if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
					end
					-- 20 Yards
					if getValue("Stealth") == 3 and tarDist < 20 then
						if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
					end
				end
				if ObjectExists("target") and stealth then 
	-- Shadowstep
					if tarDist < 25 and tarDist >= 8 and getTalent(4,2) then
						if castSpell("target",_Shadowstep,false,false,false) then return end
					end
	-- Cloak and Dagger
					if tarDist < 40 and tarDist >= 8 and getTalent(4,1) then
						if castSpell("target",_Ambush,false,false,false) then return end
					end
	-- Sap
					if noattack() and sapRemain==0 and level>=15 and tarDist < 8 then
						if castSpell("target",_Sap,false,false,false) then return end
					end
	-- Pick Pocket
					if canPP() and not isPicked() and tarDist < 8 
						and (stealthTimer == nil or stealthTimer <= GetTime()-getValue("Stealth Timer"))  
					then
						if castSpell("target",_PickPocket,true,false,false) then
							stealthTimer=GetTime();
						   	return
						end
					end
					if not noattack() and (isPicked() or level<15) then
	-- Ambush
						if combo<5 and power>60 then
							if castSpell("target",_Ambush,false,false,false) then return end
						end
	-- 5 Combo Opener
						if combo == 5 then
							if power>25 and sndRemain<5 then
								if castSpell("player",_SliceAndDice,true,false,false) then return end
							end
							if power>25 and rupRemain<3 then
								if castSpell("target",_Rupture,false,false,false) then return end
							end
							if power>35 and envRemain<2 then
								if castSpell("target",_Envenom,false,false,false) then return end
							end
						end
	-- Mutilate
						if combo < 5 and power>55 then
							if castSpell("target",_Mutilate,false,false,false) then return end
						end
					end
				end
			end
-----------------
--- In Combat ---
-----------------
			if isInCombat("player") and ObjectExists("target") then
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
				if useCDs() and not stealth and tarDist<5 then
	-- Preparation
					if vanRemain==0 and getSpellCD(_Vanish)>60 then
						if castSpell("player",_Preparation,true,false,false) then return end
					end
	-- Vanish
					if combo<5 and power<60 and getCombatTime()>10 then
						if castSpell("player",_Vanish,true,false,false) then return end
					end
	-- Shadow Reflection
					if getSpellCD(_Vendetta)==0 then
						if castSpell("player",_ShadowReflection,true,false,false) then return end
					end
	-- Vendetta
					if srRemain>0 or not getTalent(7,2) then
						if castSpell(thisUnit,_Vendetta,false,false,false) then return end
		        	end
		        end
	------------------------------------------
	--- In Combat Rotation ---
	------------------------------------------
	-- Rupture
				if combo==5 and rupRemain<3 and power>25 and tarDist<5 then
					if castSpell(thisUnit,_Rupture,false,false,false) then return end
				end
	-- Rupture - AoE
	    		if useAoE() then
	                for i = 1, #enemiesTable do
	                	if enemiesTable[i].distance<5 then
	                    	local thisUnitAoE = enemiesTable[i].unit
	                    	if getDebuffRemain(thisUnitAoE,_Rupture,"player") < 3 and power > 25 then
	                    	    if castSpell(thisUnitAoE,_Rupture,false,false,false) then return end
	                    	end
	                    end
	                end
	            end
	-- Slice and Dice
				if not isKnown(_ImprovedSliceAndDice) and sndRemain<5 and power>25 and tarDist<5 and combo>0 then
					if castSpell("player",_SliceAndDice,true,false,false) then return end
				end
	-- Marked for Death
				if combo>0 then
					if castSpell(thisUnit,_MarkedForDeath,true,false,false) then return end
				end
	-- Crimson Tempest
				if useAoE() and combo>4 and enemies>=4 and ctRemain<8 and power>35 then
					if castSpell(thisUnit,_CrimsonTempest,true,false,false) then return end
				end
	-- Fan of Knives
				if useAoE() and combo<5 and enemies>=4 and power>35 and tarDist<5 then
					if castSpell("player",_FanOfKnives,true,false,false) then return end
				end
	-- Rupture
				if (rupRemain<2 or (combo==5 and rupRemain<=(rupDuration*0.3))) and enemies==1 and combo>0 and power>25 then
					if castSpell(thisUnit,_Rupture,false,false,false) then return end
				end
	-- Envenom
				if (combo>4 and envRemain<2 and (getSpellCD(_DeathFromAbove)>2 or not getTalent(7,3))) and enemies<4 and ddRemain==0 and power>35 then
					if castSpell(thisUnit,_Envenom,false,false,false) then return end
				end
	-- Envenom
				if (combo>4 and envRemain<2 and (getSpellCD(_DeathFromAbove)>2 or not getTalent(7,3))) and enemies<4 and power>35 then
					if castSpell(thisUnit,_Envenom,false,false,false) then return end
				end
	-- Eviscerate
				if (combo>4 or (combo>3 and ttd<3)) and level<20 and power>35 then
					if castSpell(thisUnit,_Eviscerate,false,false,false) then return end
				end
	-- Fan of Knives
				if useAoE() and enemies>2 and ddRemain==0 and venRemain==0 and power>35 and tarDist<5 then
					if castSpell("player",_FanOfKnives,true,false,false) then return end
				end
	-- Ambush
				if (isPicked() or level<15) and UnitBuffID("player",_Stealth) and combo<5 and power>60 then
					if castSpell(thisUnit,_Ambush,false,false,false) then return end
				end
	-- Mutilate
				if (thp>=35 or level<40) and combo<5 and enemies==2 and ddRemain==0 and venRemain==0 and not blindside and power>55 then
					if castSpell(thisUnit,_Mutilate,false,false,false) then return end
				end
	-- Mutilate
				if (thp>=35 or level<40) and combo<5 and enemies<5 and not blindside and power>55 then
					if castSpell(thisUnit,_Mutilate,false,false,false) then return end
				end
	-- Dispatch
				if (combo<5 or (getTalent(6,3) and antCharge<4)) and enemies==2 and ddRemain==0 and venRemain==0 and ((power>30 and thp<35) or blindside) then
					if castSpell(thisUnit,_Dispatch,false,false,false) then return end
				end
	-- Dispatch
				if (combo<5 or (getTalent(6,3) and antCharge<4)) and enemies<4 and ((power>30 and thp<35) or blindside) then
					if castSpell(thisUnit,_Dispatch,false,false,false) then return end
				end
	-- Mutilate
				if (thp>=35 or level<40) and enemies==2 and ddRemain==0 and not blindside and venRemain==0 and power>55 then
					if castSpell(thisUnit,_Mutilate,false,false,false) then return end
				end
	-- Mutilate
				if (thp>=35 or level<40) and enemies<5 and power>55 and not blindside then
					if castSpell(thisUnit,_Mutilate,false,false,false) then return end
				end
			end --In Combat End
	-- Start Attack
			if tarDist<5 and not stealth and isInCombat("player") and ObjectExists("target") and profileStop==false then
				StartAttack()
			end
		end -- Pause End
	end --Rogue Function End
end --Class Check End
