if select(3,UnitClass("player")) == 1 then

	function FuryWarrior()

		if Currentconfig ~= "Fury Warrior" then
			FuryOptions();
			KeyToggles();
			Currentconfig = "Fury Warrior";
		end
		
		if AOETimer == nil then AOETimer = 0; end
		
		if isChecked("AutoAoE") == true then
			if ENEMYS == nil or (AOETimer and AOETimer <= GetTime() - 1) then AOETimer = GetTime() ENEMYS = getNumEnemies("player", 8) end
		end
		
		if isChecked("AutoAoE") ~= true then
			if isChecked("Rotation Up") == true then
				if SpecificToggle("Rotation Up") == true and GetCurrentKeyBoardFocus() == nil then
					if GetTime() - AOETimer > 0.25 then AOETimer = GetTime() ToggleValue("AoE"); end
				end
			end
			if isChecked("Rotation Down") == true then
				if SpecificToggle("Rotation Down") == true and GetCurrentKeyBoardFocus() == nil then
					if GetTime() - AOETimer > 0.25 then AOETimer = GetTime() ToggleMinus("AoE"); end
				end
			end
		end

	end
	
end