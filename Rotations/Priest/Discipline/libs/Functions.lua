if select(3, UnitClass("player")) == 5 and GetSpecialization()==1 then


	------------------------------------------------------------------------------------------------------
	-- misc ----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------

	function getRole(unit)
		-- DAMAGER
		-- HEALER
		-- NONE
		-- TANK
		return UnitGroupRolesAssigned(unit)
	end

	function isTank(unit)
		if getRole(unit)=="TANK" then return true end
	end

	function getPoM()
		local counter = 0
		for i=1,#nNova do
			thisUnit = nNova[i]
			if getBuffStacks(thisUnit.unit,41635,"player") then
				counter = counter + 1
			end
		end
		return counter
	end

	function getPWS()
		local counter = 0
		for i=1,#nNova do
			thisUnit = nNova[i].unit
			if getBuffRemain(thisUnit,17,"player") then
				counter = counter + 1
			end
		end
		return counter
	end

	------------------------------------------------------------------------------------------------------
	-- Casts ---------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------

	-- Mindbender
	function castMindbender(targetUnit)
		if getTalent(3,2) then
			if targetUnit==nil then
				return castSpell(enemiesTable[1].unit,spell.mindbender,true,false)
			else
				return castSpell(targetUnit,spell.mindbender,true,false)
			end
		end
	end

	-- Holy Fire
	function castHolyFire()
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			return castSpell(thisUnit,spell.holyFire,false,false)
		end
	end

	-- PW Solace
	function castPWSolace()
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			return castSpell(thisUnit,spell.pwSolace,false,false)
		end
	end		

	-- Smite
	function castSmite()
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			return castSpell(thisUnit,spell.smite,false,true)
		end
	end

	-- Penance
	function castPenance(targetUnit)
		-- can cast while moving
		if hasGlyph(119866) then
			return castSpell(targetUnit,spell.penance,true,false)
		else 
			return castSpell(targetUnit,spell.penance,true,true)
		end
	end
	function castPenanceE(targetUnit)
		-- can cast while moving
		if hasGlyph(119866) then
			return castSpell(targetUnit,spell.penance,false,false)
		else 
			return castSpell(targetUnit,spell.penance,false,true)
		end
	end

	function castPenanceTank()
		for i=1,#nNova do
			local thisUnit = nNova[i]
			if isTank(thisUnit) then
				if nNova[i].hpmissing >= heal.penance.heal then
					return castPenance(thisUnit.unit)
				end
			end
		end
	end

	function castPenancePlayer()
		for i=1,#nNova do
			local thisUnit = nNova[i]
			if thisUnit.hpmissing >= heal.penance.heal then
				return castPenance(thisUnit.unit)
			end
		end
	end

	function castPenanceEnemy()
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			return castPenanceE(thisUnit)
		end
	end

	-- PWS
	function castPWS(targetUnit)
		if not UnitDebuffID(targetUnit,6788) then
			return castSpell(targetUnit,spell.pws,true,false)
		end
	end

	function castPWSTank()
		if getPWS() <= options.heal.PWS.value then
			for i=1,#nNova do
				local thisUnit = nNova[i]
				if isTank(thisUnit.unit) then
					if not UnitDebuffID(thisUnit.unit,6788) then
						return castSpell(thisUnit.unit,spell.pws,true,false)
					end
				end
			end
		end
	end

	function castPWSPlayer()
		if getPWS() <= options.heal.PWS.value then
			for i=1,#nNova do
				local thisUnit = nNova[i]
				if not UnitDebuffID(thisUnit.unit,6788) then
					return castSpell(thisUnit.unit,spell.pws,true,false)
				end
			end
		end
	end

	-- Archangel
	function castArchangel()
		return castSpell("player",spell.archangel,true,false)
	end

	-- PoM
	function castPoM()
		if GetNumGroupMembers()>0 then
			--print("tank check")
			-- tank
			for i=1,#nNova do
				local thisUnit = nNova[i]
				if isTank(thisUnit) then
					if nNova[i].hpmissing >= heal.PoM.heal then
						--print("tank cast")
						return castSpell(thisUnit.unit,spell.PoM,true,true)
					end
				end
			end
			--print("player check")
			-- player
			for i=1,#nNova do
				local thisUnit = nNova[i]
				if nNova[i].hpmissing >= heal.PoM.heal then
					--print("player cast")
					return castSpell(thisUnit.unit,spell.PoM,true,true)
				end
			end
		end
	end

	-- Heal
	function castHeal()
		if options.heal.heal.check then
			for i=1,#nNova do
				local thisUnit = nNova[i]
				if nNova[i].hp <= options.heal.heal.value then
					return castSpell(thisUnit.unit,spell.heal,true,true)
				end
			end
		end
	end

	-- Flash Heal
	function castFlashHeal()
		if options.heal.flashHeal.check then
			for i=1,#nNova do
				local thisUnit = nNova[i]
				if nNova[i].hp <=  options.heal.flashHeal.value then
					return castSpell(thisUnit.unit,spell.heal,true,true)
				end
			end
		end
	end

	-- Cascade
	function castCascadeAuto()
		for i=1,#nNova do
			local thisUnit = nNova[i].unit
			local thisUnitdistance = getDistance("player",thisUnit)

			print(thisUnit.." __ "..thisUnitdistance)
			-- sort nNova for best initial target
			if nNova then
				table.sort(nNova, function(x,y)
					return x.distance and y.distance and x.distance > y.distance or false
				end)
			end
			-- cast
			if thisUnitdistance < 40 and getLineOfSight(thisUnit) then
				if castSpell(thisUnit,spell.cascade,true,true) then return end
			end
		end
	end
end