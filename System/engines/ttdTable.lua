
function TTDRefresh()
	if not enemyTable then
		enemyTable = {
		units = {},
		ttd = {},
		dps = {},
		health = {},
		totalUnits = 0,
		}
	end

	local totalUnits = enemyTable.totalUnits
	local units = enemyTable.units
	local ttd = enemyTable.ttd
	local dps = enemyTable.dps
	local health = enemyTable.health

	local totalObjects = ObjectCount()
	for i = 1, totalObjects do
		local object = ObjectWithIndex(i)
		if UnitAffectingCombat(object) and UnitIsTappedByPlayer(object) and not units[object] then
			units[object] = GetTime()
			health[object] = UnitHealth(object)
			dps[object] = 0
			if ttd[object] == nil then
				ttd[object] = -1
			end
			enemyTable.totalUnits = enemyTable.totalUnits + 1
		elseif not UnitAffectingCombat(object) and UnitIsTappedByPlayer(object) and units[object] then
			units[object] = nil
			ttd[object] = nil
			health[object] = nil
			dps[object] = nil
			enemyTable.totalUnits = enemyTable.totalUnits - 1
		else
			if units[object] and ttd[object] then
				local currentHP = UnitHealth(object)
				local maxHP = health[object]
				local diff = maxHP - currentHP
				local dura = GetTime() - units[object]
				local _dps = diff / dura
				local death = currentHP / _dps
				dps[object] = math.floor(_dps)
				if death == math.huge then
					ttd[object] = -1
				elseif death < 0 then
					ttd[object] = 0
				else
					ttd[object] = death
				end
			end
		end
	end
	for object, _ in pairs(units) do
		if not UnitExists(object) then
			units[object] = nil
			ttd[object] = nil
			health[object] = nil
			dps[object] = nil
			enemyTable.totalUnits = enemyTable.totalUnits -1
		end
	end
end



function getTTD(unit)
	if enemyTable then
		if enemyTable.ttd[unit] ~= nil then 
			return enemyTable.ttd[unit]
		elseif unit=="target" and enemyTable.ttd[ObjectPointer("target")] ~=nil then
			return enemyTable.ttd[ObjectPointer("target")]
		end
	end
	-- unit not found
	return -1
end

--- example for rotate through table
-- function rotateThroughTable()
-- 	for object, _ in pairs(units) do
-- 		if castSpell("target",8092,true,false) then return true end
-- 	end
-- end

