if select(3,UnitClass("player")) == 2 then
	-- Todo : Check Glyphs(is on us or can we cast it on ground 25 yards
	function castConsecration(unit)
		if canCast(_Consecration) and isInMelee(unit) then
			if castSpell("player",_Consecration,true) then
				return true
			end
		end
		return false
	end


	--Todo, we can check if the target is not inmelle there could be other targets in melee
	function castHolyWrath(unit)
		if canCast(_HolyWrath) and isInMelee(unit) then
			if castSpell(unit,_HolyWrath,true,false) then
				return true
			end
		end
		return false
	end

	function castAvengersShield(unit)
		if canCast(_AvengersShield) then
			if getLineOfSight("player",unit) and getDistance("player",unit) <= 30 then
				if castSpell(unit,_AvengersShield,false,false) then
					return true
				end
			end
		end
		return false
	end

	function castShieldOfTheRighteous(unit,holypower)
		if canCast(_ShieldOfTheRighteous) and (_HolyPower >= holypower or UnitBuffID("player", _DivinePurposeBuff)) then
			if castSpell(unit,_ShieldOfTheRighteous,false,false) then
				-- we dont return because its an instant spell, also it should be moved atop rotation
			end
			--Todo, we could check other targets to use HP on but this should be controlled by config.
			-- dynamic targeting enabled
		end
		return false
	end

	function castRighteousFury()
		if isChecked("Righteous Fury") then
			if UnitBuffID("player",_RighteousFury)== nil then
				if castSpell("player",_RighteousFury, true, false) then
					return true
				end
			end
		end
		return false
	end

	function castHammerOfTheRighteous()
		if castSpell(dynamicUnit.dyn5,_HammerOfTheRighteous,false,false) then
			return true
		end
	end
	function castCrusaderStrike()
		if castSpell(dynamicUnit.dyn5,_CrusaderStrike,false,false) then
			return true
		end
	end
	function castJudgement(unit)
		if unit == nil then
			unit = dynamicUnit.dyn30AoE
		end
		if canCast(_Judgment) and getDistance("player", unit) <= 30 then
			if castSpell(unit,_Judgment,true,false) then
				return true
			end
		end
		return false
	end

	--Todo: Lights Hammer can be improved
	function castLightsHammer(unit)
		if getGround(unit) and not isMoving(unit) and UnitExists(unit) and ((isDummy(unit) or getDistance(unit,"targettarget") <= 5)) then
			if castGround(unit,_LightsHammer,30) then
				return true
			end
		end
		return false
	end

	function castHolyPrism(unit)
		if unit then
			if castSpell(unit, _HolyPrism, true, false) then
				return true
			end
		end
		-- Cast on enemies first
		if getValue("Holy Prism Mode") == 2 or 3 then
			if castWiseAoEHeal(enemiesTable,_HolyPrism,15,95,1,5,false) then
				return true
			end
		else
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Holy Prism") then
					if castSpell(nNova[i].unit,_HolyPrism,true, false) then
						return true
					end
				end
			end
		end
		return false
	end
end