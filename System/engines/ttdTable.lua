
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
 
	for k, v in pairs(br.enemy) do
		local object = br.enemy[k].unit
		if not units[object] then
			units[object] = GetTime()
			health[object] = UnitHealth(object)
			dps[object] = 0
			if ttd[object] == nil then
				ttd[object] = -1
			end
			enemyTable.totalUnits = enemyTable.totalUnits + 1
		else
			if units[object] and ttd[object] then
				local currentHP = UnitHealth(object)
				local maxHP = health[object]
				local diff = maxHP - currentHP
				local dura = GetTime() - units[object]
				local _dps = diff / dura
				local death = death
				if _dps ~= 0 then death = currentHP / _dps else death = 0 end
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
		if not GetUnitExists(object) then
			units[object] = nil
			ttd[object] = nil
			health[object] = nil
			dps[object] = nil
			enemyTable.totalUnits = enemyTable.totalUnits -1
		end
	end
end

function getTTD(unit)
	TTDRefresh()
	local thisUnit = unit
	if thisUnit ~= nil then
		if not string.find(thisUnit,"0x") then
			if GetObjectExists(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and GetUnitIsVisible(thisUnit) then
				thisUnit = GetObjectWithGUID(UnitGUID(thisUnit))
			else
				return -2
			end
		end
	end
	
	if enemyTable then
		if enemyTable.ttd[thisUnit] ~= nil then
			return enemyTable.ttd[thisUnit]
		end
	end
	if isDummy() then
		return 99
	else
		return -1
	end
end