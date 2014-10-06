if select(3, UnitClass("player")) == 3 then
-- Rotation
function MarkHunter()
	if Currentconfig ~= "Marksmanship" then
		MarkConfig();
		MarkToggles();
		Currentconfig = "Marksmanship";
	end

	-- Food/Invis Check
	if not canRun() or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then waitForPetToAppear = nil; return false; end
	if isCasting() then return false; end

	-- Revive Pet
	if UnitIsDeadOrGhost("pet") then
		if castSpell("player",RevivePet) then return; end
	end
	
	end
end