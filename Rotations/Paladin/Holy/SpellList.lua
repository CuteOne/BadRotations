if select(3,UnitClass("player")) == 2 then

	function castHolyRadiance(unit) --Todo: Not its on unit but we should be able to set smart checks, ie best target for HolyRaidances
		if unit then
			if castSpell(unit,_HolyRadiance,true,false) then
				return true
			end
		end
		return false
	end

	-- Holy Shock
	function castHolyShock(unit, hpValue)
		if unit then
			if castSpell(unit, _HolyShock, true, false) then
				return true
			end
		else
			if _HolyPower < 5 or lowestHP < 90 then
				for i = 1, #nNova do
					if nNova[i].hp < hpValue then
						if castSpell(nNova[i].unit, _HolyShock, true, false) then return end
					end
				end
			end
		end
	end

	-- Holy Light
	function castHolyLight(hpValue)
		for i = 1, #nNova do
			if nNova[i].hp < hpValue then
				if castSpell(nNova[i].unit, _HolyLight, true, true) then return end
			end
		end
	end

	-- Flash Of Light
	function castFlashOfLight(unit, hpValue)
		if unit then
			if castSpell(unit, _HolyShock, true, false) then
				return true
			end
		else
			for i = 1, #nNova do
				if nNova[i].hp < hpValue then
					if castSpell(nNova[i].unit, _FlashOfLight, true, true) then
						return true
					end
				end
			end
		end
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

	-- Flash of light(Selfless Healer)
	function castSelfLessHealer(health)
		if getBuffStacks("player",114250) == 3 then
			if health <= getValue("Selfless Healer") then
				if castSpell("player",_FlashOfLight,true) then
					return
				end
			elseif modeHealing == 2 then
				for i = 1, #nNova do
					if nNova[i].hp <= getValue("Selfless Healer") then
						if castSpell(nNova[i].unit,_FlashOfLight,true) then
							return
						end
					end
				end
			end
		end
	end
end