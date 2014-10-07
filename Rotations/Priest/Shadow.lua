if select(3, UnitClass("player")) == 5 then
	function PriestShadow()

	if currentConfig ~= "Shadow ragnar & CML" then
		ShadowConfig();
		ShadowToggles();
		currentConfig = "Shadow ragnar & CML";
	end


	------------
	-- Locals --
	------------
	local lastPWF = nil;
	local orbs = UnitPower("player", SPELL_POWER_SHADOW_ORBS)
	local SWPrefresh = 3;
	local VTrefresh = 3;
	local StandingTime = 0.15;
	local MinfFlayCastTime = 2.65;
	local MBCooldown= getSpellCD(_MindBlast)
	local CastMindFlay = isCastingSpell(_MindFlay)

	-------------
	-- Toggles --
	-------------

	-- Pause toggle
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then 
		ChatOverlay("|cffFF0000BadBoy Paused", 0); 
		return; 
	end
	
	-- Focus Toggle
	if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == 1 then 
		RunMacroText("/focus mouseover");
	end

	-- Auto Resurrection
	if not isInCombat("player") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("player","mouseover") then
		if castSpell("mouseover",_Resurrection,true,true) then 
			return; 
		end
	end

	------------
	-- Checks --
	------------

	-- Food/Invis Check
	if canRun() ~= true then 
		return false; 
	end

	-- Mounted Check
	if IsMounted("player") then 
		return false; 
	end


	-- Do not Interrupt "player" while GCD (61304)
	if getSpellCD(61304) > 0 then 
		return false; 
	end

	-- Pause Check
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then
		ChatOverlay("|cffFF0000BadBoy Paused", 0);
		return; 
	end

	-------------------
	-- Out of combat --
	-------------------

	-- Power Word: Fortitude
	if isChecked("Power Word: Fortitude") == true and canCast(_PowerWordFortitude,false,false) and (lastPWF == nil or lastPWF <= GetTime() - 5) then

		for i = 1, #nNova do
			if nNova[i].hp < 249 then
				if isPlayer(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{21562,109773,469,90364}) or getBuffRemain(nNova[i].unit,_PowerWordFortitude) < 10*60 then
					if castSpell("player",_PowerWordFortitude,true) then lastPWF = GetTime(); return; end
	    		end 
	   		end
	  	end
	end

	-- Inner Fire
	if not UnitBuffID("player",_InnerFire) then
		if castSpell("player",_InnerFire,true,false) then return; end
	end

	-- Shadowform
	if not UnitBuffID("player",_Shadowform) then
		if castSpell("player",_Shadowform,true,false) then return; end
	end

	-- Angelic Feather
	if getTalent(5) and isChecked("Angelic Feather") and getGround("player") and IsMovingTime(0.33) and not UnitBuffID("player",_AngelicFeatherBuff) then
		if castGround("player",_AngelicFeather,30) then 
			SpellStopTargeting();
			return; 
		end
	end

	-- Body and Soul
	if getTalent(4) and isChecked("Body And Soul") and getGround("player") and IsMovingTime(0.75) and not UnitBuffID("player",_PowerWordShield) and not UnitDebuffID("player",_WeakenedSoul) then
		if castSpell("player",_PowerWordShield,true,false) then 
			return; 
		end
	end




-- 	------------
-- 	-- Combat --
-- 	------------

	-- Break MindFlay cast if (read following comments)
   	if select(1,UnitChannelInfo("player")) == "Mind Flay" then
		
		-- for MindBlast cast and proc
		if canCast(_MindBlast) then
			--RunMacroText("/stopcasting");
			-- cast MindBlast from DI proc
			if orbs < 3 and getTalent(15) and UnitBuffID("player",_DivineInsight) then 
				StopMFCasting();
				print("proc");
			end
			-- cast MindBlast as spell
			if orbs < 3 then
				StopMFCasting();
				print("spell");
			end
		end
		
		-- for SWP refresh
		if getDebuffRemain("target",_ShadowWordPain) <= SWPrefresh then
			StopMFCasting();
			-- RunMacroText("/stopcasting");
		end
		-- for VT refresh
		if getDebuffRemain("target",_VampiricTouch) <= VTrefresh then
			StopMFCasting();
			-- RunMacroText("/stopcasting");
		end

		-- for MindSpike Proc (Surge of Darkness)
		if getTalent(7) and UnitBuffID("player",_SurgeOfDarkness) and getBuffStacks("player",_SurgeOfDarkness) >= 2 then 
			StopMFCasting();
			-- RunMacroText("/stopcasting");
		end

		-- for Halo
		if getTalent(18) and canCast(_Halo) then 
			StopMFCasting();
			-- RunMacroText("/stopcasting");
		end
	end
	
	-- AffectingCombat, Pause, Target, Dead/Ghost Check
if pause() ~= true and UnitAffectingCombat("player") and UnitExists("target") and not UnitIsDeadOrGhost("target") then

		-- Target Tables
		if isChecked("Multi-Dotting") then
		    if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
		    	targetEnnemies, ScanTimer = getEnnemies("target",20), GetTime(); 
		    end
		end

	-- WHY THIS?
	-- surroundingEnnemies = getNumEnnemies("player",30)

	-- Defensives
	
		-- Fade
		if isChecked("Fade") and getHP("player") <= getValue("Fade") and UnitThreatSituation("player") == 3 and GetNumGroupMembers() >= 2 then
			if castSpell("player",_Fade,true,false) then 
				return; 
			end
		end

		-- Healthstone
		if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") then
			if canUse(5512) ~= false then
				UseItemByName(tostring(select(1,GetItemInfo(5512))));
			end
		end

		-- Power Word: Shield
		if isChecked("Power Word: Shield") and canCast(_PowerWordShield,true,false) and not UnitBuffID("player",_PowerWordShield) and not UnitDebuffID("player",_WeakenedSoul) then
			if getHP("player") <= getValue("Power Word: Shield") then
			   	if castSpell("player",_PowerWordShield,true,false) then 
			   		return;
			   	end
			end
		end

		-- Renew
		if isChecked("Renew") and canCast(_PowerWordShield,true,false) and not UnitBuffID("player",_Renew) then
			if getHP("player") <= getValue("Renew") then
			   	if castSpell("player",_Renew,true,false) then 
			   		return;
			   	end
			end
		end

	-- Do not cast while casting following spells
		-- TBD

	-- Offensives

		-- Power Infusion
		if isChecked("PI Toggle") and getTalent(14) then
			if castSpell("player",_PowerInfusion,true,false) then 
				ChatOverlay("PI fired");
				return; 
			end
		end
--[[]]
	-- Rotation

		-- -- Devouring Plague (MB or SW:D CD under 1.5sec for creating another Orb)
		-- if orbs == 3 and (getSpellCD(_MindBlast) < 1.5 or (getHP("target") <= 20 and getSpellCD(_ShadowWordDeath) < 1.5)) then
		-- 	if castSpell("target",_DevouringPlague,true,false) then
		-- 		return;
		-- 	end
		-- end



		--Stopcasting MindFlay if: - Mindblast ready or Mindblast cd < 0.8 or Mind Spike Proc >=2




		-- Devouring Plague without insanity talent
		if orbs == 3 and not getTalent(9) then
			if castSpell("target",_DevouringPlague,true,false) then
				return;
			end
		end

		-- Devouring Plague with insanity talent
		if orbs == 3 and getTalent(9) and getDebuffRemain("target",_ShadowWordPain,"player") >= 8 and getDebuffRemain("target",_VampiricTouch,"player") >= 8 then
			if castSpell("target",_DevouringPlague,true,false) then
				return;
			end
		end

		-- Mind Blast Proc (Divine Insight)
		if orbs < 3 and getTalent(15) and UnitBuffID("player",_DivineInsight) then
			if castSpell("target",_MindBlast,false,false) then
				return;
			end
		end

		-- Mind Blast on CD (not DI Procs)
		if orbs < 3 and isStanding(StandingTime) then 
			if castSpell("target",_MindBlast,false,true) then
				return;
			end
		end

		-- Shadow Word: Death
		if getHP("target") <= 20 and castSpell("target",_ShadowWordDeath,true,false) then
			return;
		end

		-- Mind Spike procs (From Darkness, Comes Light)
		if getTalent(7) and UnitBuffID("player",_SurgeOfDarkness) and getBuffStacks("player",_SurgeOfDarkness) >= 2 then 
			if castSpell("target",_MindSpike,false,false) then
				return;
			end
		end

		-- MF:Insanity while DP is up
		if UnitDebuffID("target",_DevouringPlague,"player") and getTalent(9) then
			if castSpell("target",_MindFlay,false,true,false,true) then
				return;
			end
		end

		-- get number of enemies
		if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
	    	meleeEnnemies, targetEnnemies, ScanTimer = getNumEnnemies("player",4), getEnnemies("target",10), GetTime(); 
	    end

		-- Shadow Word: Pain (cycle_targets=1,max_cycle_targets=5,if=miss_react&!ticking)
		if getDebuffRemain("target",_ShadowWordPain) <= SWPrefresh then 
			if castSpell("target",_ShadowWordPain,true,false) then 
				return; 
			end 
		end
	
		if isChecked("Multi-Dotting") then
			for i = 1, #targetEnnemies do
				ISetAsUnitID(targetEnnemies[i],"thisUnit")
				if UnitAffectingCombat("thisUnit") and getDebuffRemain("thisUnit",_ShadowWordPain) <= SWPrefresh then
					if castSpell("thisUnit",_ShadowWordPain,true,false) then 
						return; 
					end
				end
			end
		end

		-- Vampiric Touch (cycle_targets=1,max_cycle_targets=5,if=remains<cast_time&miss_react)
		if isStanding(0.3) and getDebuffRemain("target",_VampiricTouch) <= VTrefresh and (vampTimer == nil or (vampTimer and vampTimer <= GetTime() - VTrefresh) or vampTarget ~= UnitGUID("target")) then 
			if castSpell("target",_VampiricTouch,true,true) then 
				vampTarget = UnitGUID("target"); vampTimer = GetTime(); 
				return; 
			end 
		end

		if isChecked("Multi-Dotting") then
			for i = 1, #targetEnnemies do
				ISetAsUnitID(targetEnnemies[i],"thisUnit")
				if UnitAffectingCombat("thisUnit") and getDebuffRemain("thisUnit",_VampiricTouch) <= VTrefresh and (vampTimer == nil or (vampTimer and vampTimer <= GetTime() - VTrefresh) or vampTarget ~= UnitGUID("thisUnit")) then
					if castSpell("thisUnit",_VampiricTouch,true,true) then 
						vampTarget = UnitGUID("thisUnit"); vampTimer = GetTime(); 
						return; 
					end
				end
			end	
		end 

		-- Shadow Word: Pain (cycle_targets=1,max_cycle_targets=5,if=miss_react&ticks_remain<=1)
		if getDebuffRemain("target",_ShadowWordPain) <= SWPrefresh then if castSpell("target",_ShadowWordPain,true,false) then return; end end
		if isChecked("Multi-Dotting") then
			for i = 1, #targetEnnemies do
				ISetAsUnitID(targetEnnemies[i],"thisUnit")
				if UnitAffectingCombat("thisUnit") and getDebuffRemain("thisUnit",_ShadowWordPain) <= SWPrefresh then
					if castSpell("thisUnit",_ShadowWordPain,true,false) then 
						return;
					end
				end
			end
		end

		-- Vampiric Touch (cycle_targets=1,max_cycle_targets=5,if=remains<cast_time+tick_time&miss_react)
		if isStanding(0.3) and getDebuffRemain("target",_VampiricTouch) < VTrefresh and (vampTimer == nil or (vampTimer and vampTimer <= GetTime() - VTrefresh) or vampTarget ~= UnitGUID("target")) then 
			if castSpell("target",_VampiricTouch,true,true) then 
				vampTarget = UnitGUID("target"); vampTimer = GetTime(); 
					return;
				end 
			end
		if isChecked("Multi-Dotting") then
			for i = 1, #targetEnnemies do
				ISetAsUnitID(targetEnnemies[i],"thisUnit")
				if UnitAffectingCombat("thisUnit") and getDebuffRemain("thisUnit",_VampiricTouch) < VTrefresh and (vampTimer == nil or (vampTimer and vampTimer <= GetTime() - VTrefresh) or vampTarget ~= UnitGUID("thisUnit")) then
					if castSpell("thisUnit",_VampiricTouch,true,true) then 
						vampTarget = UnitGUID("thisUnit"); vampTimer = GetTime(); 
						return;
					end
				end
			end	
		end	

		-- Mind Spike procs (From Darkness, Comes Light)
		if getTalent(7) and UnitBuffID("player",_SurgeOfDarkness) and getBuffStacks("player",_SurgeOfDarkness) == 1 then 
			if castSpell("target",_MindSpike,false,false) then
				return;
			end
		end

		-- Halo
		if getTalent(18) then 
			if getDistance("player","target") <= 25 and getDistance("player","target") >= 17 then
				if castSpell("target",_Halo) then 
					return;
				end
			end
		end

		-- Mindbender
		if isChecked("Mindbender") and getTalent(8) and getMana("player") <= getValue("Mindbender") then
			if castSpell("target",_Mindbender,true,false) then
			ChatOverlay("Mindbender fired");
				return;
			end
		end

		-- Shadowfiend
		if isChecked("Shadowfiend") and not getTalent(8) and getMana("player") <= getValue("Shadowfiend") then
			if castSpell("target",_Shadowfiend,true,false) then
				ChatOverlay("Shadowfiend fired");
				return;
			end
		end

		-- -- Mind Flay (Filler)
		-- if getDebuffRemain("target",_ShadowWordPain,"player") >= 1 and getDebuffRemain("target",_VampiricTouch,"player") >= 1 then
		-- 	if castSpell("target",_MindFlay,false,true) then
		-- 		return;
		-- 	end
		-- end

		if isStanding(0.3) then
			if castSpell("target",_MindFlay,false,true,false,true) then 
				return; 
			end
		end


print("--- End of Rotation ---");
		




end
end
end