if select(3,UnitClass("player")) == 10 then

function BrewmasterMonk()
	if AoEModesLoaded ~= "Brew Monk AoE Modes" then
		MonkBrewToggles();
		MonkBrewConfig();
	end
-- Barrel Thrower
	if SpellIsTargeting() then
		if UnitExists("target") then
			local X, Y, Z = IGetLocation(UnitGUID("target"));
			CastAtLocation(X,Y,Z);
			SpellStopTargeting()
			return true;
		end
	end
-- Locals
	local chi = UnitPower("player", SPELL_POWER_CHI);
	local energy = getPower("player");
	local myHP = getHP("player");
	local ennemyUnits = getNumEnnemies("player", 5)
-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then return false; end
    GroupInfo()
---------------------------------------
--- Ressurection/Dispelling/Healing ---
---------------------------------------
	if isValidTarget("mouseover")
		and UnitIsDeadOrGhost("mouseover") 
		and UnitIsPlayer("mouseover") 
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
		if isChecked("Detox") == true and canDispel("player",_Detox) then
			if castSpell("player",_Detox,true) then return; end
		end
		if isChecked("Detox") == true and canDispel("mouseover",_Detox) then
			if castSpell("mouseover",_Detox,true) then return; end
		end
-- Resuscitate
		if isChecked("Resuscitate") == true and not isInCombat("player") then
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
-- Stance
		local myStance = GetShapeshiftForm()
	    if isChecked("Stance") then
	    	if getValue("Stance") == 1 and myStance ~= 1 then
	    		if castSpell("player",115069,true) then return; end
	    	elseif getValue("Stance") == 2 and myStance ~= 2 then
	    		if castSpell("player",103985,true) then return; end
	    	end
	    end
	   	if not UnitExists("mouseover") then
		  	for i = 1, #members do
		  		if (#members==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
-- Legacy of the Emperor
		  			if not isBuffed(members[i].Unit,{115921,20217,1126,90363}) then
						if castSpell("player",_LegacyOfTheEmperor,true) then return; end
			  		end
		  		end
			end 
		end
	end

------------------
--- Defensives ---
------------------
--	Expel Harm
	if getHP("player")<=80 and (getChiMax("player")-getChi("player"))>=2 and getPower("player")>=40 and not isCasting("player") then
		if castSpell("player",_ExpelHarm,true) then return; end
	end
-- Nimble Brew
	if hasNoControl() then
		if castSpell("player",_NimbleBrew,true) then 
			return; 
		elseif castSpell("player",_TigersLust,true) then 
			return;
		end
	end

---------------------
--- Out of Combat ---
---------------------
	if not isInCombat("player") then
		if canAttack("target","player") and not UnitIsDeadOrGhost("target") then
-- Dazzling Brew
			if isChecked("Dazzling Brew") == true then
				if targetDistance <= 40 and getGround("target") == true and UnitExists("target") and (isDummy("target") or getDistance("target","targettarget") <= 15) then
					 CastSpellByName(GetSpellInfo(115180),nil);
					 return;
				end
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

		--[[Quaking Palm]]
		if isChecked("Quaking Palm") and canInterrupt(_QuakingPalm,tonumber(getValue("Quaking Palm"))) then
			if castSpell("target",_QuakingPalm,false) then return; end
		end

		--[[Spear Hand Strike]]
		if isChecked("Spear Hand Strike") and canInterrupt(_SpearHandStrike,tonumber(getValue("Spear Hand Strike"))) then
			if castSpell("target",_SpearHandStrike,false) then return; end
		end

    	--[[Fortifying Brew]]
    	if isChecked("Fortifying Brew") == true and myHP <= getValue("Fortifying Brew") then
    		if castSpell("player",115203,true) then return; end
    	end
	end

	if isCasting() then return false; end

	if targetDistance > 5 and targetDistance <= 40 and UnitExists("target") and not UnitIsDeadOrGhost("target") then

		--[[Chi Wave]]
	    if castSpell("target",115098,false) then return; end

    	--[[Dazzling Brew]]
		if isChecked("Dazzling Brew") == true then
			if UnitExists("target") and not UnitIsDeadOrGhost("target") and getCreatureType("target") == true and getGround("target") == true then
				if castSpell("player",115180,true,false) then return; end
			end
		end   
		



	elseif UnitExists("target") and not UnitIsDeadOrGhost("target") and isEnnemy("target") == true and getCreatureType("target") == true then



		--[[Chi Wave]]
	    if castSpell("target",_ChiWave,false) then return; end

		--[[Breath of Fire if >= 3 targets dump.]]
	    if chi >= 3 and ennemyUnits > 2 then
	    	if castSpell("target",_BreathOfFire,false) then return; end
	    end	

		--[[Blackout Kick dump.]]
	    if chi >= 3 then
	    	if castSpell("target",_BlackoutKick,true) then return; end
	    end	

		--[[Keg Smash on cooldown when at < 3 Chi. Applies Weakened Blows.]]
	    if chi < 3 then
	    	if castSpell("target",_KegSmash,false) then return; end
	    end		

		--[[Tiger Palm does not cost Chi, but is used like a finisher (Tiger Power).]]
	    if getBuffRemain("player",125359) < 2 then
	    	if castSpell("target",_TigerPalm,true) then return; end
	    end	

		--[[Expel Harm when you are not at full health.]]
		if energy >= 40 and myHP <= getValue("Expel Harm") then
	    	if castSpell("player",_ExpelHarm,true) then return; end
	    end	  

		--[[Touch of Death]]
	    if chi >= 3 and myHP > getHP("target") then
	    	if castSpell("target",_TouchOfDeath,false) then return; end
	    end		

		--[[Jab use to build Chi and prevent Energy capping.]]
    	if (energy > 70 and chi < 4) or energy >= 90 then
    		if castSpell("target",_Jab,false) then return; end
    	end



		--[[Purifying Brew to remove your Stagger DoT when Yellow or Red.]]

		--[[Elusive Brew if > 10 stacks. Delay up to 10-15 sec for anticipated damage.]]

		--[[Guard on cooldown. Delay up to 10-15 sec for anticipated damage.]]
	    if chi >= 2 and getBuffRemain("player",118636) > 1 then
	    	if castSpell("player",_Guard,true) then return; end
	    end		

		--[[Breath of Fire if > 3 targets]]
	    if chi >= 3 and ennemyUnits > 2 then
	    	if castSpell("target",_BreathOfFire,false) then return; end
	    end	

		--[[Blackout Kick as often as possible. Aim for ~80% uptime on Shuffle.]]
	    if (chi >= 3 and getBuffRemain("player",115307) <= 1) or chi >= 3 then
	    	if castSpell("target",_BlackoutKick,true) then return; end
	    end	

		--[[Tiger Palm filler.]]
	    if castSpell("target",_TigerPalm,true) then return; end			
  
	end

end



end
