if select(3, UnitClass("player")) == 5 then
	function PriestShadow()
		if currentConfig ~= "Shadow ragnar" then
			ShadowConfig()
			ShadowToggles()

			shdw = cShadow:new()
			setmetatable(shdw, {__index = cShadow})
			shdw:updateOOC()
			shdw:update()

			currentConfig = "Shadow ragnar"
		end

		if not UnitAffectingCombat("player") then
			shdw:updateOOC()
		end
		
		shdw:update()
	end
end