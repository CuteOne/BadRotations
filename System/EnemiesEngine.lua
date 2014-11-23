-- Function to create and populate table of enemies within a distance from player.
-- Todo, nice to have is enemies around any unit, in order to compute AOE toggling. Ie (enemesAround("HEALER")
function makeEnemiesTable(maxDistance)
	local  maxDistance = maxDistance or 50
	-- Throttle this 1 sec.
	if enemiesTable == nil or enemiesTableTimer == nil or enemiesTableTimer <= GetTime() - 1 then
		-- create/empty table
		enemiesTable = { }
		-- use objectmanager to build up table
	 	for i=1,ObjectCount() do
	 		-- define our unit
		  	local thisUnit = ObjectWithIndex(i);
	 		-- sanity checks
	 		if getSanity(thisUnit) == true then
  				-- get the unit distance
  				local unitDistance = getDistance("player",thisUnit)
				-- distance check according to profile needs
  				if unitDistance <= maxDistance then
		  			-- get unit Infos
		  			local unitName = UnitName(thisUnit)
	  				local unitThreat = UnitThreatSituation("player",thisUnit) or -1
	  				local unitCasting, unitCastLenght, unitCastTime, unitCanBeInterrupt, unitCastType = getCastingInfo(thisUnit)
	  				local X1, Y1, Z1 = ObjectPosition(thisUnit)
					local unitCoeficient = getUnitCoeficient(thisUnit,unitDistance)
  					local unitHP = getHP(thisUnit)
  					-- insert unit as a sub-array holding unit informations
   					tinsert(enemiesTable, { 
   						name = unitName, 
   						coeficient = unitCoeficient, 
   						cast = {  --List of casting information
   							casting = unitCasting or false, 
   							castLenght = unitCastLenght, 
   							castTime = unitCastTime, 
   							canBeInterrupted = unitCanBeInterrupt or false, 
   							castType = unitCastType 
   								}, 
   						threat = unitThreat, 
   						unit = thisUnit, 
   						distance = unitDistance, 
   						hp = unitHP, 
   						x = X1, y = Y1, z = Z1 
   						})
   				end
		  	end
	 	end

	 	-- sort them by coeficient
	 	table.sort(enemiesTable, function(x,y)
	 		return x.coeficient and y.coeficient and x.coeficient < y.coeficient or false
	 	end)
	end
end

function getUnitCoeficient(unit, distance) 
	local coef = 250
	if distance < 40 then
		coef = getHP(unit)
		if UnitGroupRolesAssigned("player") == "TANK" then
			coef = coef + UnitThreatSituation("player",thisUnit)*10
		end
	end
	return coef
end

-- returns anme fo cast/channel and casting("cast") or channelling("chan") /dump getCastingInfo("target")
function getCastingInfo(unit)
	if UnitCastingInfo(unit) ~= nil then
		local unitCastName, _, _, _, unitCastStart, unitCastEnd, _, unitCastID, unitCastNotInteruptible = UnitCastingInfo(unit)
		return unitCastName, getCastLenght(unitCastStart,unitCastEnd), getTimeUntilCastEnd(unitCastEnd), unitCastNotInteruptible == false, "cast"
	elseif UnitChannelInfo(unit) ~= nil then
		local unitCastName, _, _, _, unitCastStart, unitCastEnd, _, unitCastID, unitCastNotInteruptible = UnitChannelInfo(unit)
		return unitCastName, getCastLenght(unitCastStart,unitCastEnd), getTimeUntilCastEnd(unitCastEnd), unitCastNotInteruptible == false, "chan"
	else
		return false, "none"
	end
end

-- returns true if Unit is a valid enemy
function getSanity(unit)
	if UnitExists(unit) and bit.band(ObjectType(unit), ObjectTypes.Unit) == 8 
	  and UnitIsVisible(unit) == true and getCreatureType(unit) == true
	  and UnitCanAttack(unit, "player") == true and UnitIsDeadOrGhost(unit) == false then
	  	return true
	else
		return false
	end
end

-- casting informations
function getCastLenght(castStart,castEnd)
	return (castEnd-castStart)/1000
end

function getTimeUntilCastEnd(castEnd)
	return math.floor((castEnd/1000 - GetTime())*100)/100
end

-- casters table
function makeSpellCastersTable()
	spellCastersTable = { }
	for i = 1, #enemiesTable do
		if enemiesTable[i].cast.casting ~= false and enemiesTable[i].cast.canBeInterrupted == true 
		  and getFacing("player",enemiesTable[i].unit) == true then
		  	tinsert(spellCastersTable, { unit = enemiesTable[i].unit, castName = enemiesTable[i].cast.casting, 
		  	  castLenght = enemiesTable[i].cast.castLenght, castEnd = enemiesTable[i].cast.castTime, distance = enemiesTable[i].distance, })
		end
	end
end

-- function to compare spells to casting units
function castInterupt(spell,percent)
	if castersBlackList == nil then castersBlackList = { } end
	for i = 1, #castersBlackList do
		if castersBlackList[i].time ~= nil and castersBlackList[i].time < GetTime() - 0.5 then
			tremove(castersBlackList, i)
		end
	end
	if canCast(spell,false,false) == true then
		for i = 1, #spellCastersTable do
			local blackListedUnit = false
			for j = 1, #castersBlackList do
				if castersBlackList[j].unit == spellCastersTable[i].unit then
					blackListedUnit = true
					break
				end
			end
			if blackListedUnit == false then
				-- make sure we cover melee range
				local allowedDistance = select(6,GetSpellInfo(spell))
				if allowedDistance < 5 then 
					allowedDistance = 5 
				end
				
				if getSpellCD(spell) < spellCastersTable[i].castEnd 
				  and spellCastersTable[i].castEnd/spellCastersTable[i].castLenght < (100 - percent)/100
				  and spellCastersTable[i].distance < allowedDistance then
					if castSpell(spellCastersTable[i].unit,spell,false,false) then 
						tinsert(castersBlackList, { unit = spellCastersTable[i].unit, time = GetTime() })
						return 
					end
				end
			end
		end
	end
end

