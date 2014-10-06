if select(3, UnitClass("player")) == 3 then
-- Rotation
function SurvHunter()

if Currentconfig ~= "Survival Avery" then
	SurvConfig();
	SurvToggles();
	Currentconfig = "Survival Avery";
end

--Locals
local _Focus = UnitPower("player")

--Aoe checks
if AOETimer == nil then AOETimer = 0; end
if ENEMYS == nil or (AOETimer and AOETimer <= GetTime() - 1) then AOETimer = GetTime() ENEMYS = getNumEnnemies("target", 10) end
if isChecked("AutoAoE") ~= true then
	if isChecked("Rotation Up") == true then
		if SpecificToggle("Rotation Up") == 1 and GetCurrentKeyBoardFocus() == nil then
			if GetTime() - AOETimer > 0.25 then AOETimer = GetTime() ToggleValue("AoE"); end
		end
	end
	if isChecked("Rotation Down") == true then
		if SpecificToggle("Rotation Down") == 1 and GetCurrentKeyBoardFocus() == nil then
			if GetTime() - AOETimer > 0.25 then AOETimer = GetTime() ToggleMinus("AoE"); end
		end
	end
end

-- Food/Invis/Cast Check
if not canRun() or UnitInVehicle("Player") then return false; end
if IsMounted("player") then waitForPetToAppear = nil; return false; end
if isCasting() then return false; end

--Out of Combat
if isInCombat("player") == nil then



--Combat
elseif isInCombat("player") then
	
	--one target
	if (isChecked("AutoAoE") ~= true and BadBoy_data['AoE'] == 1) or (isChecked("AutoAoE") == true and ENEMYS <= 1) then

		--Killshot
		if getHP("target") <= 20 then
			if castSpell("target",_KillShot,false) then return; end
		end
		
		-- Arcane Shot
		if _Focus >= 69 then
			if castSpell("target",_ArcaneShot,false) then return; end
		end
				
		--Cobra Shot
		if castSpell("target",_CobraShotSurv,false,false) then return; end

	--2 targets
	elseif (isChecked("AutoAoE") ~= true and BadBoy_data['AoE'] == 2) or (isChecked("AutoAoE") == true and ENEMYS == 2) then
	
		--Killshot
		if getHP("target") <= 20 then
			if castSpell("target",_KillShot,false) then return; end
		end
		
		-- Multi Shot
		if _Focus >= 69 then
			if castSpell("target",_MultiShot,false) then return; end
		end
				
		--Cobra Shot
		if castSpell("target",_CobraShotSurv,false,false) then return; end
	
	--3 targets
	elseif (isChecked("AutoAoE") ~= true and BadBoy_data['AoE'] == 3) or (isChecked("AutoAoE") == true and ENEMYS >= 3) then

		--Killshot
		if getHP("target") <= 20 then
			if castSpell("target",_KillShot,false) then return; end
		end
		
		-- Barrage
		if _Focus >= 69 then
			if castSpell("target",_Barrage,false) then return; end
		end
				
		--Cobra Shot
		if castSpell("target",_CobraShotSurv,false,false) then return; end	
	
	end

end

	end
end