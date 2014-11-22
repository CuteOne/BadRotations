function makeEnemiesTable(maxDistance)
	local  maxDistance = maxDistance or 50
	-- Throttle this 1 sec.
	if enemiesTable == nil or enemiesTableTimer == nil or enemiesTableTimer <= GetTime() - 1 then
		-- create/empty table
		enemiesTable = { };
		-- use objectmanager to build up table
	 	for i=1,ObjectCount() do
	 		if UnitExists(ObjectWithIndex(i)) and bit.band(ObjectType(ObjectWithIndex(i)), ObjectTypes.Unit) == 8 then
		  		local thisUnit = ObjectWithIndex(i);
		  		if UnitIsVisible(thisUnit) == true and getCreatureType(thisUnit) == true then
		  			if UnitCanAttack(thisUnit, "player") == true and UnitIsDeadOrGhost(thisUnit) == false then
		  				local unitThreat = UnitThreatSituation(thisUnit)
		  				local unitCasting
		  				if UnitCastingInfo(thisUnit) ~= nil or UnitChannelInfo(thisUnit) ~= nil then
		  					unitCasting = true
		  				else
		  					unitCasting = false
		  				end
		  				local unitDistance = getDistance("player",thisUnit)
		  				local X1, Y1, Z1 = ObjectPosition(thisUnit)

		  				if unitDistance <= maxDistance then
		  					local unitHP = getHP(thisUnit)
		  					-- insert unit as a sub-array holding unit informations
		   					tinsert(enemiesTable,{casting = unitCasting, threat = unitThreat, unit = thisUnit, distance = unitDistance, hp = unitHP, x = X1, y = Y1, z = Z1 })
		   					--print("inserted")
		   				end
		  			end
		  		end
		  	end
	 	end

	 	-- sort them by threat
	 	table.sort(enemiesTable, function(x,y)
	 		return x.threat and y.threat and x.threat < y.threat or false
	 	end)
	end
end