if select(3, UnitClass("player")) == 3 then
-- Rotation
function SurvHunter()

if Currentconfig ~= "Survival Avery" then
	SurvConfig();
	SurvToggles();
	Currentconfig = "Survival Avery";
end

-- Food/Invis/Cast Check
if not canRun() or UnitInVehicle("Player") then return false; end
if IsMounted("player") then waitForPetToAppear = nil; return false; end
if isCasting() then return false; end

--Combat
if isInCombat("player") then

	--Killshot
	if getHP("target") <= 20 then
		if castSpell("target",_KillShot,false) then return; end
	end
			
	--Cobra Shot
	if castSpell("target",_CobraShotSurv,false,false) then return; end
end

	end
end