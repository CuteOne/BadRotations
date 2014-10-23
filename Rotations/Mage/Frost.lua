if select(3, UnitClass("player")) == 8 then

function FrostMage()


	if currentConfig ~= "Frost ragnar" then
		--FrostConfig();
		--FrostToggles();
		currentConfig = "Frost ragnar";
	end

	------------
	-- CHECKS --
	------------

	if BadBoy_data["Power"]==0 then
		RunMacroText("/petfollow [target=pettarget,exists]");
	end

	if UnitAffectingCombat("player") and UnitName("pettarget")==nil then
		RunMacroText("/petpasive [target=pettarget,exists]");
		RunMacroText("/petfollow [target=pettarget,exists]");
	end
	if not UnitAffectingCombat("player") and UnitName("pettarget") then
	end


	-- Food/Invis Check
	if canRun() ~= true then
		return false;
	end

	-- Mounted Check
	if IsMounted("player") then
		return false;
	end


	-- Do not Interrupt "player" while GCD (61304)k
	if getSpellCD(61304) > 0 then
		return false;
	end



	------------
	-- COMBAT --
	------------

	-- AffectingCombat, Pause, Target, Dead/Ghost Check
	if pause() ~= true and UnitAffectingCombat("player") and UnitExists("target") and not UnitIsDeadOrGhost("target") then

		FrostSingleTargetSimcraft()
	end

end
end