if select(3, UnitClass("player")) == 11 then
function DruidRestoration()
	if currentConfig ~= "Restoration Masou" then
		RestorationConfig();
		RestorationToggles();
		currentConfig = "Restoration Masou";
	end

	-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end

--[[ 	-- On GCD After here, palce out of combats spells here
]]

	if isCasting() then return false; end

	-- Barkskin if < 30%
	if isChecked("Barkskin") and getHP("player") <= getValue("Barkskin") then
		if castSpell("player",_Barkskin,true) then return; end
	end


--[[ 	-- Combats Starts Here
]]

	if isInCombat("player") then

		--if isAlive() and (isEnnemy() or isDummy("target")) and getLineOfSight("player","target") == true and getFacing("player","target") == true then

		if isChecked("Healing Touch") and nNova[1].hp <= getValue("Healing Touch") then
			if castSpell(nNova[1].unit,5185,true) then return; end
		end





		--end
	end
end
end