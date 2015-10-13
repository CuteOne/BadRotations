if select(3, UnitClass("player")) == 9 then
	function WarlockAffliction()
		if currentConfig ~= "Affliction ragnar" then
			AfflictionConfig()
			AfflictionToggles()

			affli = cAffliction:new()
			setmetatable(affli, {__index = cAffliction})
			affli:updateOOC()
			affli:update()

			currentConfig = "Affliction ragnar"
		end

		if not UnitAffectingCombat("player") then
			affli:updateOOC()
		end
		
		affli:update()
	end
end