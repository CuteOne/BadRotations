if select(3, UnitClass("player")) == 2 then
	function PaladinHoly()
	-- Init Holy specific funnctions, toggles and configs.
		if currentConfig ~= "Holy CodeMyLife" then
			PaladinHolyFunctions();
			PaladinHolyToggles();
			PaladinHolyConfig();
			currentConfig = "Holy CodeMyLife";
		end

		-- Locals Variables
		local _HolyPower = UnitPower("player", 9);

		-- Food/Invis Check   Hm here we are checking if we should abort the rotation pulse due to if we are a vehicle or some stuff
		if canRun() ~= true or UnitInVehicle("Player") then 
			return false; 
		end

		--[[Off GCD in combat]]
		if UnitAffectingCombat("player") then


		end

		--[[Off GCD out of combat]]







		if isCasting() then 
			return false; 
		end

		--[[On GCD Out of Combat]]







		--[[On GCD in combat]]
		if isInCombat("player") then

			--[[Auto Attack if in melee]]
			if isInMelee() and getFacing("player","target") == true then
				RunMacroText("/startattack");
			end

			--[[Lay on Hands I like LoH in combat only because i do not like to waste it because a lock is running to his death.]]
			if getHP("player") <= getValue("Lay On Hands") then
				if castSpell("player",_LayOnHands,true) then 
					return; 
				end
			else
				for i = 1, 3 do
					if nNova[i].hp <= getValue("Lay On Hands") then
						if castSpell(nNova[1].unit,_LayOnHands,true) then 
							return; 
						end
					end
				end
			end





		end
	end
end