if select(3,UnitClass("player")) == 2 then
	-- exorcist support both glyphed and not glyphed
	function castExorcism()
		if hasGlyph(122028) then
			if castSpell(dynamicUnit.dyn5,_MassExorcism,false,false) then
				return true
			end
		else
			if castSpell(dynamicUnit.dyn30,_Exorcism,false,false) then
				return true
			end
		end
		return false
	end

	function castDivineStorm()
		local targetDivineStorm = dynamicUnit.dyn8AoE
		if getBuffRemain("player",_FinalVerdict) > 0 then
			targetDivineStorm = dynamicUnit.dyn16AoE
		end
		if castSpell(targetDivineStorm,_DivineStorm,false,false) then
	  		return true
	  	end
	  	return false
	end

	function castTemplarsVerdict()
		-- here we need to see if we want to cast as 5 yard or 8yard
		local templarsVerdictUnit = dynamicUnit.dyn5
		if isKnown(_FinalVerdict) then
			templarsVerdictUnit = dynamicUnit.dyn8
		end
		if castSpell(templarsVerdictUnit,_TemplarsVerdict,false,false) then
			return true
		end
		return false
	end
end