if select(3, UnitClass("player")) == 4 then
	function AssassinationRogue()
		if Currentconfig ~= "Assassination CuteOne" then
			AssOptions();
			Currentconfig = "Assassination CuteOne"
		end
		if not canRun() then
	    	return true
	    end
		AssToggles();
		-- if worgen==nil then
		-- 	worgen=false
		-- end
		-- if isInCombat("player") or UnitBuffID("player",68992) then
		-- 	worgen=true
		-- end
		-- if not isInCombat("player") and worgen==true and not UnitBuffID("player",68992) then
		-- 	if castSpell("player",68996,true,false,false) then worgen=false; return; end
		-- end


--------------
--- Locals ---
--------------
		if not enemiesTimer or enemiesTimer <= GetTime() - 1 then
        	enemies, enemiesTimer = getNumEnemies("player",8), GetTime()
    	end
		local tarDist = getDistance2("target")
		local hasTarget = UnitExists("target")
		local hasMouse = UnitExists("mouseover")
		local level = UnitLevel("player")
		local php = getHP("player")
		local thp = getHP("target")
		local combo = getCombo()
		local power = getPower("player")
		local powmax = UnitPowerMax("player")
		local powgen = getRegen("player")
		local ttd = getTimeToDie("target")
		local ttm = getTimeToMax("player")
		local deadtar = UnitIsDeadOrGhost("target")
		local attacktar = canAttack("player", "target")
		local swimming = IsSwimming()
		local stealth = UnitBuffID("player",_Stealth)
		local dpRemain = getBuffRemain("player",_DeadlyPoison)
		local lpRemain = getBuffRemain("player",_LeechingPoison)
		local cpRemain = getBuffRemain("player",_CripplingPoison)
		local recRemain = getBuffRemain("player",_Recuperate)
		local sapRemain = getDebuffRemain("target",_Sap)
		local vanRemain = getBuffRemain("player",_VanishBuff)
		local rupRemain = getDebuffRemain("target",_Rupture,"player")
		local sndRemain = getBuffRemain("player",_SliceAndDice)
		local ctRemain = getDebuffRemain("target",_CrimsonTempest,"player")
		local rupDuration = getDebuffDuration("target",_Rupture,"player")
		local srRemain = getBuffRemain("player",_ShadowReflection)
		local venRemain = getDebuffRemain("target",_Vendetta,"player")
		local ddRemain = getDebuffRemain("target",113780,"player")
		local envRemain = getDebuffRemain("target",_Envenom,"player")
		local antCharge = getCharges(_Anticipation)
----------------------------------
--- Poisons/Healing/Dispelling ---
----------------------------------
		if (isCastingSpell(_DeadlyPoison) and dpRemain>5) or ((isCastingSpell(_LeechingPoison) and lpRemain>5)) then
			RunMacroText("/stopcasting")
		end
	-- Deadly Poison
		if dpRemain<5 and not isMoving("player") and not castingUnit("player") and not IsMounted() then
			if castSpell("player",_DeadlyPoison,true) then return; end
		end
	-- Crippling/Leeching Poison
		if not isMoving("player") and not castingUnit("player") and not IsMounted() then
			if isKnown(_LeechingPoison) and lpRemain<5 then
				if castSpell("player",_LeechingPoison,true) then return; end
			elseif cpRemain<5 then
				if castSpell("player",_CripplingPoison,true) then return; end
			end
		end
	-- Recuperate
		if php < 80 and recRemain==0 and combo>0 then
			if castSpell("player",_Recuperate,true,false,false) then return; end
		end
	-- Cloak of Shadows
		if canDispel("player") then
			if castSpell("player",_CloakOfShadows,true,false,false) then return; end
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
					if castSpell("player",_Evasion,true,false,false) then return; end
				end
	-- Combat Readiness
				if php<40 then
					if castSpell("player",_CombatReadiness,true,false,false) then return; end
				end
	-- Recuperate
				if php<30 and combo>3 and recRemain==0 then
					if castSpell("player",_Recuperate) then return; end
				end
	-- Vanish
				if php<15 then
					if castSpell("player",_Vanish) then StopAttack(); ClearTarget(); return; end
				end
    		end
---------------------
--- Out of Combat ---
---------------------
			if not isInCombat("player") and not (IsMounted() or IsFlying() or UnitIsFriend("target","player")) then
	-- Stealth
				if not UnitBuffID("player",_Stealth) and tarDist < 20 then
					if castSpell("player",_Stealth,true,false,false) then return; end
				end
				if tarDist < 25 and tarDist >= 8 and level>=60 then
	-- Shadowstep
					if not UnitBuffID("player",_Stealth) then
						if castSpell("player",_Stealth,true,false,false) then return; end
					else
						if castSpell("target",_Shadowstep,false,false,false) then return; end
					end
				end
				if tarDist < 8 then
	-- Sap
					if noattack() and sapRemain==0 and UnitBuffID("player",_Stealth) and level>=15 then
						if castSpell("target",_Sap,false,false,false) then return; end
					end
	-- Pick Pocket
					if canPP() and not isPicked() and UnitBuffID("player",_Stealth) and level>=15 then
						if castSpell("target",_PickPocket,true) then return; end
					end
	-- Ambush
					if not noattack() and (isPicked() or level<15) and UnitBuffID("player",_Stealth) and combo<5 and power>60 and tarDist<5 then
						if castSpell("target",_Ambush,false,false,false) then return; end
					end
	-- Mutilate
					if not isInCombat("player") and (isPicked() or level<15) and not noattack() and combo < 5 and power>55 and tarDist<5 then
						if castSpell("target",_Mutilate,false,false,false) then return; end
					end
				end
			end
-----------------
--- In Combat ---
-----------------
			if isInCombat("player") then
	------------------------------
	--- In Combat - Dummy Test ---
	------------------------------
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
	------------------------------
	--- In Combat - Interrupts ---
	------------------------------
				if useInterrupts() and not stealth and canInterrupt("target", tonumber(getValue("Interrupts"))) then
	-- Kick
					if level>=18 then
						if castSpell("target",_Kick,false,false,false) then return; end
					end
	-- Gouge
					if getSpellCD(_Kick)>0 then
						if castSpell("target",_Gouge,false,false,false) then return; end
					end
	-- Blind
					if getSpellCD(_Kick)>0 and getSpellCD(_Gouge)>0 then
						if castSpell("target",_Blind,false,false,false) then return; end
					end
			    end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
				if useCDs() and not stealth and tarDist<5 then
	-- Preparation
					if vanRemain==0 and getSpellCD(_Vanish)>60 then
						if castSpell("player",_Preparation,true,false,false) then return; end
					end
	-- Vanish
					if combo<5 and power<60 and getCombatTime()>10 then
						if castSpell("player",_Vanish,true,false,false) then return; end
					end
	-- Shadow Reflection
					if getSpellCD(_Vendetta)==0 then
						if castSpell("player",_ShadowReflection,true,false,false) then return; end
					end
	-- Vendetta
					if srRemain>0 or not getTalent(7,2) then
						if castSpell("target",_Vendetta,false,false,false) then return; end
		        	end
		        end
	------------------------------------------
	--- In Combat Rotation ---
	------------------------------------------
	-- Rupture
				if combo==5 and rupRemain<3 and power>25 and tarDist<5 then
					if castSpell("target",_Rupture,false,false,false) then return; end
				end
	-- Rupture - AoE
	    		if useAoE() and canCast(_Rupture) then
	                if  myEnemies == nil or myMultiTimer == nil or myMultiTimer <= GetTime() - 1 then
	                    myEnemies, myMultiTimer = getEnemies("player",5), GetTime()
	                end
	                for i = 1, #myEnemies do
	                    local thisUnit = myEnemies[i]
	                    if getCreatureType(thisUnit)
	                        and UnitCanAttack(thisUnit,"player")
	                        and not UnitIsDeadOrGhost(thisUnit)
	                        and getFacing("player",thisUnit)
	                        and (UnitAffectingCombat(thisUnit) or isDummy(thisUnit))
	                        and getDebuffRemain(thisUnit,_Rupture,"player") < 3
	                        and power > 25
	                    then
	                        if castSpell(thisUnit,_Rupture,false,false,false) then return; end
	                    end
	                end
	            end
	-- Slice and Dice
				if sndRemain<5 and power>25 and tarDist<5 and combo>0 then
					if castSpell("player",_SliceAndDice,true,false,false) then return; end
				end
	-- Marked for Death
				if combo>0 and tarDist<5 then
					if castSpell("target",_MarkedForDeath,true,false,false) then return; end
				end
	-- Crimson Tempest
				if useAoE() and combo>4 and enemies>=4 and ctRemain<8 and power>35 and tarDist<5 then
					if castSpell("target",_CrimsonTempest,true,false,false) then return; end
				end
	-- Fan of Knives
				if useAoE() and combo<5 and enemies>=4 and power>35 and tarDist<5 then
					if castSpell("player",_FanOfKnives,true,false,false) then return; end
				end
	-- Rupture
				if (rupRemain<2 or (combo==5 and rupRemain<=(rupDuration*0.3))) and enemies==1 and combo>0 and power>25 and tarDist<5 then
					if castSpell("target",_Rupture,false,false,false) then return; end
				end
	-- Envenom
				if (combo>4 and envRemain<2 and (getSpellCD(_DeathFromAbove)>2 or not getTalent(7,3))) and enemies<4 and ddRemain==0 and power>35 and tarDist<5 then
					if castSpell("target",_Envenom,false,false,false) then return; end
				end
	-- Envenom
				if (combo>4 and envRemain<2 and (getSpellCD(_DeathFromAbove)>2 or not getTalent(7,3))) and enemies<4 and power>35 and tarDist<5 then
					if castSpell("target",_Envenom,false,false,false) then return; end
				end
	-- Eviscerate
				if (combo>4 or (combo>3 and ttd<3)) and level<20 and power>35 and tarDist<5 then
					if castSpell("target",_Eviscerate,false,false,false) then return; end
				end
	-- Fan of Knives
				if useAoE() and enemies>2 and ddRemain==0 and venRemain==0 and power>35 and tarDist<5 then
					if castSpell("player",_FanOfKnives,true,false,false) then return; end
				end
	-- Ambush
				if (isPicked() or level<15) and UnitBuffID("player",_Stealth) and combo<5 and power>60 and tarDist<5 then
					if castSpell("target",_Ambush,false,false,false) then return; end
				end
	-- Mutilate
				if thp>35 and combo<5 and enemies==2 and ddRemain==0 and venRemain==0 and power>55 and tarDist<5 then
					if castSpell("target",_Mutilate,false,false,false) then return; end
				end
	-- Mutilate
				if thp>35 and combo<5 and enemies<5 and power>55 and tarDist<5 then
					if castSpell("target",_Mutilate,false,false,false) then return; end
				end
	-- Dispatch
				if (combo<5 or (getTalent(6,3) and antCharge<4)) and enemies==2 and ddRemain==0 and venRemain==0 and power>30 and tarDist<5 then
					if castSpell("target",_Dispatch,false,false,false) then return; end
				end
	-- Dispatch
				if (combo<5 or (getTalent(6,3) and antCharge<4)) and enemies<4 and power>30 and tarDist<5 then
					if castSpell("target",_Dispatch,false,false,false) then return; end
				end
	-- Mutilate
				if enemies==2 and ddRemain==0 and venRemain==0 and power>55 and tarDist<5 then
					if castSpell("target",_Mutilate,false,false,false) then return; end
				end
	-- Mutilate
				if enemies<5 and power>55 and tarDist<5 then
					if castSpell("target",_Mutilate,false,false,false) then return; end
				end
			end --In Combat End
	-- Start Attack
			if tarDist<5 and not stealth and (isInCombat("player") or isDummy()) then
				StartAttack()
			end
		end -- Pause End
	end --Rogue Function End
end --Class Check End
