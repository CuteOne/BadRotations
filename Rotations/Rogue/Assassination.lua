if select(3, UnitClass("player")) == 4 then
	function AssassinationRogue()
		if Currentconfig ~= "Assassination CuteOne" then
			AssOptions();
			Currentconfig = "Assassination CuteOne"
		end
		AssToggles();
		ChatOverlay(canPickpocket)
--------------
--- Poison ---
--------------
		if (isCastingSpell(_DeadlyPoison) and getBuffRemain("player",_DeadlyPoison)>5) or ((isCastingSpell(_LeechingPoison) and getBuffRemain("player",_LeechingPoison)>5)) then
			RunMacroText("/stopcasting")
		end
	-- Deadly Poison
		if getBuffRemain("player",_DeadlyPoison)<5 and not isMoving("player") and not castingUnit("player") and not IsMounted() then
			if castSpell("player",_DeadlyPoison) then return; end
		end
	-- Leeching Poison
		if getBuffRemain("player",_LeechingPoison)<5 and not isMoving("player") and not castingUnit("player") and not IsMounted()  then
			if castSpell("player",_LeechingPoison) then return; end
		end
----------------------
--- Healing/Dispel ---
----------------------
	-- Recuperate
		if getHP("player") < 80 and getBuffRemain("player",_Recuperate)==0 and getCombo()>0 then
			if castSpell("player",_Recuperate) then return; end
		end
	-- Cloak of Shadows
		if canDispel("player") then
			if castSpell("player",_CloakOfShadows) then return; end
		end
--------------
--- Opener ---
--------------
	-- Stealth
		if not isInCombat("player") and not UnitBuffID("player",_Stealth) and canAttack("player","target") and not UnitIsDeadOrGhost("target") and targetDistance < 20 and getSpellCD(_Stealth)==0 then
			if castSpell("player",_Stealth) then return; end
		end
		if canAttack("player","target") and not UnitIsDeadOrGhost("target") and targetDistance < 25 and targetDistance >= 8 and UnitLevel("player")>=60 then
	-- Shadowstep
			if not isInCombat("player") and not UnitBuffID("player",_Stealth) and canAttack("player","target") and not UnitIsDeadOrGhost("target") and getSpellCD(_Stealth)==0 then
				if castSpell("player",_Stealth) then return; end
			else
				if castSpell("target",_Shadowstep) then return; end
			end
		end
		if canAttack("player","target") and not UnitIsDeadOrGhost("target") and targetDistance < 8 then
	-- Sap
			if noattack() and getDebuffRemain("target",_Sap)==0 and UnitBuffID("player",_Stealth) and UnitLevel("player")>=15 then
				if castSpell("target",_Sap) then return; end
			end
	-- Pick Pocket
			if canPP() and not isPicked() and UnitBuffID("player",_Stealth) and UnitLevel("player")>=15 then
				if castSpell("target",_PickPocket) then return; end
			end
	-- Ambush
			if not noattack() and getFacing("target","player")==false and isPicked() and UnitBuffID("player",_Stealth) and getCombo()<5 and getPower("player")>=60 then
				if castSpell("target",_Ambush,false) then return; end
			end
	-- Mutilate
			if not isInCombat("player") and not noattack() and getFacing("target","player") and getCombo() < 5 and getPower("player")>=55 then
				if castSpell("target",_Mutilate) then return; end
			end
		end
-----------------
--- In Combat ---
-----------------
		if isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then
	--------------
	--- Pause ---
	--------------
			if pause() then
				return true
			end
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
	-----------------
	--- Defensive ---
	-----------------
			if not UnitBuffID("player",_Stealth) then
	-- Dismantle
				if canDisarm("target") then
					if castSpell("target",_Dismantle) then return; end
				end
	-- Evasion
				if getHP("player")<50 then
					if castSpell("player",_Evasion) then return; end
				end
	-- Combat Readiness
				if getHP("player")<40 then
					if castSpell("player",_CombatReadiness) then return; end
				end
	-- Recuperate
				if getHP("player")<30 and getCombo()>3 and getBuffRemain("player",_Recuperate)==0 then
					if castSpell("player",_Recuperate) then return; end
				end
	-- Vanish
				if getHP("player")<10 then
					if castSpell("player",_Vanish) then return; end
					StopAttack()
					ClearTarget()
				end
			end
	------------------
	--- Interrupts ---
	------------------
	-- Kick
			if canInterrupt(_Kick,tonumber(getValue("Interrupts"))) and UnitLevel("player")>=18 then
				if castSpell("target",_Kick) then return; end
			end
	-- Gouge
			if canInterrupt(_Gouge,tonumber(getValue("Interrupts"))) and getSpellCD(_Kick)>0 and getFacing("target","player") then
				if castSpell("target",_Gouge) then return; end
			end
	-- Blind
			if canInterrupt(_Blind,tonumber(getValue("Interrupts"))) and getSpellCD(_Kick)>0 and getSpellCD(_Gouge)>0 then
				if castSpell("target",_Blind) then return; end
			end
	-----------------
	--- Cooldowns ---
	-----------------
			if not UnitBuffID("player",_Stealth) and targetDistance<=8 and useCDs() then
	-- Preparation
				if getBuffRemain("player",_VanishBuff)==0 and getSpellCD(_Vanish)>60 then
					if castSpell("player",_Preparation) then return; end
				end
	-- Vanish
				if getCombo()<5
					and getPower("player")<60
					and getBuffRemain("player",_ShadowBlades)==0
					and getCombatTime()>10
				then
					if castSpell("player",_Vanish) then return; end
				end
	-- Shadow Blades
				if isBuffed("player",{2825,90355,16042,80353,32182}) or getCombatTime()>60 then
					if castSpell("player",_ShadowBlades) then return; end
				end
	-- Vendetta
				if castSpell("target",_Vendetta) then return; end
			end
	-------------------------
	--- Multiple Rotation ---
	-------------------------
			if not UnitBuffID("player",_Stealth) and targetDistance<=8 and useAoE() and UnitLevel("player")>=66 then
				local ennemyCount = getNumEnemies("player",10)
				if ennemyCount>8 then
					if getCombo()<5 then
						if castSpell("player",_FanOfKnives) then return; end
					else
						if castSpell("target",_Envenom) then return; end
					end
				end
				if ennemyCount>=4 and ennemyCount<=8 then
					if getRupr()<3 and getCombo()>3 then
						for i = 1, GetTotalObjects(TYPE_UNIT) do
							local Guid = IGetObjectListEntry(i)
							ISetAsUnitID(Guid,"thisUnit");
							if getFacing("player","thisUnit") == true
								and getDebuffRemain("thisUnit",_Rupture) < 3
								and getTimeToDie("thisUnit") > 5
								and getDistance("thisUnit") < 5
								and getCombo()
							then
								if castSpell("target",_Rupture) then return;end
							end
						end
					elseif getCombo()>4 and getRupr()>=3 then
						if castSpell("target",_Envenom) then return; end
					else
						if castSpell("player",_FanOfKnives) then return; end
					end
				end
			end
	-----------------------
	--- Single Rotation ---
	-----------------------
			if not UnitBuffID("player",_Stealth) and targetDistance<=5 and (not useAoE() or UnitLevel("player")<66) then
	-- Slice and Dice
				if getSndr()<2 and getCombo()>0 and getPower("player")>=25 then
					if castSpell("player",_SliceAndDice,true) then return; end
				end
	-- Dispatch/Mutilate
				if getRupr()<2 and getPower("player")>90 then
					if UnitLevel("player")>40 and (getHP("target")<35 or getBuffRemain("player",_Blindside)>0) then
						if castSpell("target",_Dispatch,false) then return; end
					else
						if castSpell("target",_Mutilate,false) then return; end
					end
				end
	-- Marked for Death
				if getCombo()==0 then
					if castSpell("target",_MarkedForDeath,false) then return; end
				end

	-- Rupture
				if getNumEnemies("player",10) > 1 and getRupr() > 20 then
    				for i = 1, GetTotalObjects(TYPE_UNIT) do
        				local Guid = IGetObjectListEntry(i)
        				ISetAsUnitID(Guid,"thisUnit");
         				if getFacing("player","thisUnit") == true
           					and getDebuffRemain("thisUnit",_Rupture) < 5
				            and getHP("thisUnit") > 50
				            and getDistance("thisUnit") < 5
           				then
          					if castSpell("thisUnit",_Rupture,false) then return; end
         				end
       				end
       			elseif getSndr()>0 and getCombo()>0 and (getRupr()<2 or (getCombo()==5 and getRupr()<3)) then
					if castSpell("target",_Rupture,false) then return; end
				end

	-- Envenom
				if getSndr()>0 and (getCombo()>4 or (getCombo()>=2 and getSndr()<3)) then
					if castSpell("target",_Envenom,false,false,false,true) then return; end
				end
	-- Dispatch/Mutilate
				if getCombo()<5 then
					if UnitLevel("player")>=40 and (getHP("target")<35 or getBuffRemain("player",_Blindside)>0) then
						if castSpell("target",_Dispatch,false,false,false,true) then return; end
					end
					if (getHP("target")>=35 or UnitLevel("player")<40) and getBuffRemain("player",_Blindside)==0 then
						if castSpell("target",_Mutilate,false) then return; end
					end
				end
			end --End Rotation
	-- Start Attack
			if not UnitBuffID("player",_Stealth) then
				StartAttack()
			end
		end -- End Combat
	end
end