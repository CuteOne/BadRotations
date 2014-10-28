if select(3, UnitClass("player")) == 8 then

function ArcaneMage()

	if currentConfig ~= "Arcane ragnar" then
		ArcaneMageConfig();
		ArcaneMageToggles();
		currentConfig = "Arcane ragnar";
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


	-- Do not Interrupt "player" while GCD (61304)k
	if getSpellCD(61304) > 0 then
		return false;
	end

	-- Arcane Brilliance
	if isChecked("Arcane Brilliance") then
		if not UnitExists("mouseover") then
		-- if isChecked("Arcane Brilliance") == true and not UnitExists("mouseover") then
			GroupInfo()
			for i = 1, #members do --members
				if not isBuffed(members[i].Unit,{1459}) and (#nNova==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
					if castSpell("player",ArcaneBrilliance,false,false) then
						return;
					end
				end
			end
		end
	end


	------------
	-- COMBAT --
	------------

		-- AffectingCombat, Pause, Target, Dead/Ghost Check
	if pause() ~= true and UnitAffectingCombat("player") and UnitExists("target") and not UnitIsDeadOrGhost("target") then

		if BadBoy_data['Defensive'] == 2 then
			ArcaneMageDefensives()
		end


		if BadBoy_data['Cooldowns'] == 2 then
			ArcaneMageCooldowns();
		end


		-- actions+=/call_action_list,name=burn,if=time_to_die<mana.pct*0.35*spell_haste|cooldown.evocation.remains<=(mana.pct-30)*0.3*spell_haste|(buff.arcane_power.up&cooldown.evocation.remains<=(mana.pct-30)*0.4*spell_haste)
		if isChecked("Burn Mana") then
			if getTimeToDie("target")<getMana("player")*0.35*GetHaste() or getSpellCD(Evocation)<=(getMana("player")-30)*0.3*GetHaste() or (UnitBuffID("player",ArcanePower) and getSpellCD(Evocation)<=(getMana("player")-30)*0.4*GetHaste()) then
				ArcaneMageSingleTargetSimcraftBurn();
			end
		end

		-- actions+=/call_action_list,name=conserve
		ArcaneMageSingleTargetSimcraftConserve()

	end

end
end