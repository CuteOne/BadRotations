if select(3, UnitClass("player")) == 1 then
	function ArmsWarrior()
		if rms == nil then
			WarriorArmsToggles()

			rms = cArms:new()
			setmetatable(rms, {__index = cArms})
			rms:updateOOC()
			rms:update()
		end

		if not UnitAffectingCombat("player") then
			rms:updateOOC()
		end
		
		rms:update()
	end
end