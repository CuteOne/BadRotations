if select(3, UnitClass("player")) == 9 then
	function WarlockAffliction()
		if affliWarlock == nil then
			AfflictionToggles()

			affliWarlock = cAffliction:new()
			setmetatable(affliWarlock, {__index = cAffliction})
			affliWarlock:updateOOC()
			affliWarlock:update()
		end

		if not UnitAffectingCombat("player") then
			affliWarlock:updateOOC()
		end
		
		affliWarlock:update()
	end
end