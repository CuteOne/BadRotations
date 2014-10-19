if select(3,UnitClass("player")) == 1 then

	function ProtectionWarrior()
	
		if Currentconfig ~= "Protection Warrior" then
			WarriorProtConfig();
			WarriorProtToggles()
			Currentconfig = "Protection Warrior";
		end

		--General Locals
		local RAGE = UnitPower("player");
		local TARGETHP = (100*(UnitHealth("target")/UnitHealthMax("target")));
		local PLAYERHP = (100*(UnitHealth("player")/UnitHealthMax("player"))); 
		
		--Buff/Debuff Locals
		local BATTLESHOUT = UnitBuffID("player",BattleShout)
		local COMMANDINGSHOUT = UnitBuffID("player",CommandingShout)

		if canRun() ~= true or UnitInVehicle("Player") or IsMounted("player") then return false; end
	
		--Combat
		if not isInCombat("player") then

		elseif isInCombat("player") then
		
		end	
		
	end
end