if select(3, UnitClass("player")) == 5 then
	function PriestShadow()
		if shdw == nil then
			ShadowToggles()

			shdw = cShadow:new()
			setmetatable(shdw, {__index = cShadow})
			shdw:updateOOC()
			shdw:update()
		end

		if not UnitAffectingCombat("player") then
			shdw:updateOOC()
		end
		
		shdw:update()
	end
end