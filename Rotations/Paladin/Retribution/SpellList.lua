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

	-- for retribution we want to fire hammer of wrath if we
		-- can cast the spell

		-- if we have avenging wrath it mean we can on any targets
		-- in this case we want to fire on dyn30

		-- otherwise we need to check if we can cast on said target via hp treshold beign low
		-- we want to cast on units
	function castHammerOfWrathRet(dyn30,buffAvengingWrath)
		local _HammerOfWrath = _HammerOfWrath
		if canCast(_HammerOfWrath) then
			local function castHammerOfWrath(thisUnit)
				if castSpell(thisUnit,_HammerOfWrath,false,false) then
					return true
				end
			end
			-- if we have avenging wrath, cast right away on dyn30
			if buffAvengingWrath then
				if castAvengingWrath(dyn30) then
					return true
				end
			else
				local hpHammerOfWrath = 20
				-- if empowered hammer of wrath, we need to get value for HoW hp at 35%
				if isKnown(157496) then
					hpHammerOfWrath = 35
				end
				local enemiesTable = enemiesTable
				for i = 1, #enemiesTable do
					-- define thisUnit
					local thisUnit = enemiesTable[i]
					if thisUnit.hp < hpHammerOfWrath then
						if castAvengingWrath(thisUnit.unit,_HammerOfWrath,false,false) then
							return true
						end
					end
				end
			end
		end
		return false
	end

	function castTemplarsVerdict(dynamicUnit)
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