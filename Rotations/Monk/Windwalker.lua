if select(3, UnitClass("player")) == 10 then
	function WindwalkerMonk()
	    if Currentconfig ~= "Windwalker CuteOne" then
	        WindwalkerConfig();
	        Currentconfig = "Windwalker CuteOne";
	    end
	    WindwalkerToggles()
	    GroupInfo()
	    if not canRun() then
	    	return true
	    end
---------------------------------------
--- Ressurection/Dispelling/Healing ---
---------------------------------------
		if isValidTarget("mouseover")
			and UnitIsDeadOrGhost("mouseover") 
			and UnitIsPlayer("mouseover") 
			and not UnitBuffID("player", prl)
			and not UnitBuffID("player", 80169) -- Food
	  		and not UnitBuffID("player", 87959) -- Drink
	 	 	and UnitCastingInfo("player") == nil
	 	 	and UnitChannelInfo("player") == nil 
		  	and not UnitIsDeadOrGhost("player")
		  	and not IsMounted()
		  	and not IsFlying()
		  	and targetDistance <= 40
		then
	-- Detox
			if canDispel("player",_Detox) then
				if castSpell("player",_Detox,true) then return; end
			end
			if canDispel("mouseover",_Detox) then
				if castSpell("mouseover",_Detox,true) then return; end
			end
	-- Resuscitate
			if not isInCombat("player") then
				if castSpell("mouseover",_Resuscitate,true) then return; end
			end
		end
-------------
--- Buffs ---
-------------
		if not UnitBuffID("player", 80169) -- Food
			and not UnitBuffID("player", 87959) -- Drink
			and UnitCastingInfo("player") == nil
			and UnitChannelInfo("player") == nil 
			and not UnitIsDeadOrGhost("player")
			and not IsMounted()
			and not IsFlying()
			and not isInCombat("player")
		then
		   	if not UnitExists("mouseover") then
			  	for i = 1, #members do
			  		if (#members==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
	-- Legacy of the Emperor
			  			if not isBuffed(members[i].Unit,{115921,20217,1126,90363}) then
							if castSpell("player",_LegacyOfTheEmperor,true) then return; end
				  		end
	-- Legacy of the White Tiger
						if not isBuffed(members[i].Unit,{17007,1459,61316,116781,90309,126373,160052,126309,24604}) then
	  						if castSpell("player",_LegacyOfTheWhiteTiger,true) then return; end
			  			end
			  		end
				end 
			end
		end

------------------
--- Defensives ---
------------------
	--	Expel Harm
		if getHP("player")<=80 and getPower("player")>=40 and not isCasting("player") then
			if isInCombat("player") and (getChiMax("player")-getChi("player"))>=2 then
				if castSpell("player",_ExpelHarm,true) then return; end
			end
			if not isInCombat("player") and getNumEnnemies("player",10)==0 then
				if castSpell("player",_ExpelHarm,true) then return; end
			end
		end
	-- Touch of Karma
		if getHP("player")<=50 and canAttack("target","player") and not UnitIsDeadOrGhost("target") then
			if castSpell("target",_TouchOfKarma,false) then return; end
		end
	-- Fortifying Brew
		if getHP("player")<=40 then
			if castSpell("player",_FortifyingBrew,true) then return; end
		end
	-- Nimble Brew
		if hasNoControl() then
			if castSpell("player",_NimbleBrew,true) then return; end
		end

---------------------
--- Out of Combat ---
---------------------
		if not isInCombat("player") then
	-- Expel Harm (Chi Builer)
			if BadBoy_data['Builder']==1 and (getChiMax("player")-getChi("player"))>=2 and getPower("player")>=40 and not isCasting("player") then
				if castSpell("player",_ExpelHarm,true) then return; end
			end
	-- Provoke
			if not IsMounted() and canAttack("target","player") and not UnitIsDeadOrGhost("target") then
				if select(2,IsInInstance())=="none" and #members==1 then
					if castSpell("target",_Provoke,true) then return; end
				end
			end
		end

-----------------
--- In Combat ---
-----------------
		if isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then			
	
	----------------------
	--- Rotation Pause ---
	----------------------
			if pause() then
				return true
			end

	--------------------------------------------------
	--- In Combat - Dummy Test / Cat Form Maintain ---
	--------------------------------------------------
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
		-- Quaking Palm
			if canInterrupt(_QuakingPalm,tonumber(getValue("Interrupts"))) and targetDistance<3.5 then
				if castSpell("target",_QuakingPalm,false) then return; end
			end
		-- Spear Hand Strike
			if canInterrupt(_SpearHandStrike,tonumber(getValue("Interrupts"))) and getSpellCD(_QuakingPalm)>0 and getSpellCD(_QuakingPalm)<119 and targetDistance<3.5 then
				if castSpell("target",_SpearHandStrike,false) then return; end
			end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
		-- Energizing Brew
			if getTimeToMax("player")>5 then
				if castSpell("player",_EnergizingBrew,true) then return; end
			end
	--------------------------------
	--- In Combat - All Rotation ---
	--------------------------------
		-- Touch of Death
			if UnitBuffID("player",_DeathNote) and targetDistance<3.5 then
				if castSpell("target",_TouchOfDeath,false) then return; end
			end
		-- Chi Brew
			if getChi("player")<=2 and (getAgility() > AgiSnap or (getCharges(_ChiBrew)==1 and getRecharge(_ChiBrew)<=10) or getCharges(_ChiBrew)==2 or getTimeToDie("target")<(getCharges(_ChiBrew)*10)) then
				if castSpell("player",_ChiBrew,true) then return; end
			end
		-- Tiger Palm
			if  targetDistance<3.5 and getBuffRemain("player",_TigerPower)<=3 and getChi("player")>=1 then
				if castSpell("target",_TigerPalm,false) then return; end
			end
		-- Raising Sun Kick

		-- Tiger Palm
			if  targetDistance<3.5 and getBuffRemain("player",_TigerPower)==0 and getRSR()>1 and getTimeToMax("player")>1 and getChi("player")>=1 then
				if castSpell("target",_TigerPalm,false) then return; end
			end

	-----------------------------------------
	--- In Combat - Multi-Target Rotation ---
	-----------------------------------------
			if useAoE() then
		--	Spinning Crane Kick

			end
	------------------------------------------
	--- In Combat - Single-Target Rotation ---
	------------------------------------------
			if not useAoE() then
		-- Raising Sun Kick

		-- Fists of Fury
				if getSpellCD(_EnergizingBrew)==0 
					and getTimeToMax("player")>4 
					and getBuffRemain("player",_TigerPower)>4 
					and getChi("player")>=3 
					and not isStanding(0.5) 
					and getFacing("player","target")==true 
					and targetDistance < 3.5
				then
					if castSpell("player",_FistsOfFury,true) then return; end
				end
		-- Tiger Palm
				if targetDistance<3.5	and getBuffRemain("player",_ComboBreakerTigerPalm)>0 and (getBuffRemain("player",_ComboBreakerTigerPalm)<=2 or getTimeToMax("player")>=2) then
					if castSpell("target",_TigerPalm,false) then return; end
				end
		-- Chi Wave
				if getTimeToMax("player")>2 and targetDistance<=40 then
					if castSpell("player",_ChiWave,true) then return; end
				end
		-- Blackout Kick
				if getBuffRemain("player",_ComboBreakerBlackoutKick)>0	and targetDistance<3.5 then
					if castSpell("target",_BlackoutKick,false) then return; end
				end
		-- Jab
				if (getChiMax("player")-getChi("player"))>=2 and getPower("player")>=40 and (getHP("player")>=80 or getSpellCD(_ExpelHarm)>0) and targetDistance<3.5 then
					if castSpell("target",_Jab,false) then return; end
				end
		-- Blackout Kick
				if getPower("player")+getRegen("player")*getRSRCD()>=40 and getChi("player")>=2 and targetDistance<3.5 then
					if castSpell("target",_BlackoutKick,false) then return; end
				end
			end
		end --In Combat End	
	-- Start Attack
		if targetDistance<3.5 and isEnnemy("target") and not UnitIsDeadOrGhost("target") then
			StartAttack()
		end
	end
end