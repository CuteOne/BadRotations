if select(3, UnitClass("player")) == 8 then

function FrostMage()


	if currentConfig ~= "Frost ragnar" then
		FrostMageConfig();
		FrostMageToggles();
		currentConfig = "Frost ragnar";
	end

	-------------------
	-- Rune Of Power --
	-------------------
	if BadBoy_data["Rune"] == 1 and BadBoy_data["Power"] == 1 then
		--[[ begin Rune Stuff ]]					-- add rune of power toggle!!!!!!!!!!!!!!!!!!!!!!!!!!!!

		--AoESpell, AoESpellTarget= nil, nil;
		if AoESpell == RuneOfPower then
			AoESpellTarget = "player";
		else
			AoESpellTarget = nil;
		end
		if IsAoEPending() and AoESpellTarget ~= nil then
			local X, Y, Z = ObjectPosition("player");
			CastAtPosition(X,Y,Z);
			SpellStopTargeting()
			return true;
		end


		--[[rune_of_power,if=talent.rune_of_power.enabled&(buff.rune_of_power.remains<cast_time&buff.alter_time.down)]]
		if isKnown(RuneOfPower) then
			if not UnitBuffID("player",RuneOfPower) and isStanding(0.5) then
				if runeTimer == nil or runeTimer <= GetTime() - 3 then
					AoESpell = RuneOfPower;
					runeTimer = GetTime();
					CastSpellByName(GetSpellInfo(RuneOfPower),nil)
					return;
				end
			end
		end

		--[[ end Rune Stuff ]]
	end

	------------
	-- CHECKS --
	------------

	-- Pet checks
	-- Set petpassive if power=0
	-- if BadBoy_data["Power"]==0 then
	-- 	if UnitName("pettarget")~=nil then
	-- 		RunMacroText("/petfollow [target=pettarget,exists]");
	-- 		RunMacroText("/petpassive");
	-- 	end
	-- end
	-- -- Set petassist if power=1
	-- if BadBoy_data["Power"]==1 and UnitName("pettarget")==nil then
	-- 	RunMacroText("/petassist");
	-- end
	-- -- Set petpassive if power=1 and not in combat
	-- if BadBoy_data["Power"]==1 and not UnitAffectingCombat("player") then
	-- 	RunMacroText("/petfollow [target=pettarget,exists]");
	-- 	RunMacroText("/petpassive");
	-- end

	-- Pet active/passive
	if BadBoy_data["Pet"] == 1 then
		-- check if pet is dead
		if not UnitExists("pet") then
			if castSpell("player",SummonPet,true,true) then
				return;
			end
		end
		-- Petpassive, Petagressive
		if BadBoy_data["Power"]==0 then
			if IsPetAttackActive() == true then
				RunMacroText("/petpassive")
			end
		end
		if BadBoy_data["Power"]==1 then
			if select(5,GetPetActionInfo(8)) == false then
				RunMacroText("/petassist")
			end
		end
	end


	------------
	-- Checks --
	------------

	-- Food/Invis Check
	if canRun() ~= true then
		return false;
	end

	-- Pause
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
		ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
	end

	-- Mounted Check
	if IsMounted("player") then
		return false;
	end

	--Ice barrier should be up when solo PvE
		if not UnitBuffID("player",11426)  then -- Ice barrier
			if castSpell("player",11426,false,false) then return; 
			end
		end

	-- Do not Interrupt "player" while GCD (61304)k
	if getSpellCD(61304) > 0 then
		return false;
	end

	-- Arcane Brilliance
	--if isChecked("Arcane Brilliance") then
	--	if not UnitExists("mouseover") then
	--	  if isChecked("Arcane Brilliance") == true and not UnitExists("mouseover") then
	--		GroupInfo()
	--		for i = 1, #members do --members
	--			if not isBuffed(members[i].Unit,{1459}) and (#nNova==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
	--				if castSpell("player",ArcaneBrilliance,false,false) then
	--					return;
	--				end
	--			end
	--		end
	--	end
	--end

	------------
	-- COMBAT --
	------------

	-- AffectingCombat, Pause, Target, Dead/Ghost Check
	if pause() ~= true and UnitAffectingCombat("player") and UnitExists("target") and not UnitIsDeadOrGhost("target") then

		FrostMageDefensives()

		if BadBoy_data['Cooldowns'] == 2 then
			FrostMageCooldowns();
		end

		-- Single Target Rotation

		if getValue("RotationSelect") == 1 then
			FrostMageSingleTargetIcyVeins()
		end
		if getValue("RotationSelect") == 2 then
			FrostMageSingleTargetSimcraft()
		end



	end

end
end