local _, br = ...
br.engines.ttdTable = br.engines.ttdTable or {}
local ttdTable = br.engines.ttdTable
local enemyTable

function br.engines.ttdTable:TTDRefresh(hpLimit)
	if not enemyTable then
		enemyTable = {
			units = {},
			ttd = {},
			dps = {},
			health = {},
			totalUnits = 0,
		}
	end

	local units = enemyTable.units
	local ttd = enemyTable.ttd
	local dps = enemyTable.dps
	local health = enemyTable.health

	if hpLimit == nil then hpLimit = 0 end

	for k, _ in pairs(br.engines.enemiesEngine.enemy) do
		local object = br.engines.enemiesEngine.enemy[k].unit
		if not units[object] then
			units[object] = br._G.GetTime()
			health[object] = br._G.UnitHealth(object)
			dps[object] = 0
			if ttd[object] == nil then
				ttd[object] = -1
			end
			enemyTable.totalUnits = enemyTable.totalUnits + 1
		else
			if units[object] and ttd[object] then
				local currentHP = br._G.UnitHealth(object)
				local maxHP = health[object]
				local diff = maxHP - currentHP
				local dura = br._G.GetTime() - units[object]
				local _dps = diff / dura
				local death
				local adjustment = maxHP * (hpLimit / 100)
				if _dps ~= 0 then death = math.max(0, currentHP - adjustment) / _dps else death = 0 end
				dps[object] = math.floor(_dps)
				if death == math.huge then
					ttd[object] = -1
				elseif death < 0 then
					ttd[object] = 0
				else
					ttd[object] = death
				end
				if maxHP - currentHP == 0 then
					ttd[object] = -1
				end
			end
		end
	end
	for object, _ in pairs(units) do
		local unitHealth = br._G.UnitHealth(object) or 0
		if unitHealth <= 0 then
			units[object] = nil
			ttd[object] = nil
			health[object] = nil
			dps[object] = nil
			enemyTable.totalUnits = enemyTable.totalUnits - 1
		end
	end
end

function br.engines.ttdTable:getTTD(unit, hp)
	if br.functions.misc:getOptionCheck("Enhanced Time to Die") then
		if unit == "target" and br.functions.unit:GetObjectExists("target") then unit = br._G.UnitTarget("player") end
		if br.engines.enemiesEngine.unitSetup.cache[unit] ~= nil then
			br.engines.enemiesEngine.unitSetup.cache[unit]:unitTtd(hp)
			return br.engines.enemiesEngine.unitSetup.cache[unit].ttd or -2
		end
		return -2
	end
	if br.functions.unit:isDummy() then return 99 end
	ttdTable:TTDRefresh(hp)
	local thisUnit = unit
	-- if thisUnit ~= nil then
	-- 	if not string.find(thisUnit, "0x") or not type(thisUnit) == "number" then
	-- 		if br.functions.unit:GetObjectExists(thisUnit) and not br.functions.unit:GetUnitIsDeadOrGhost(thisUnit) and br.functions.unit:GetUnitIsVisible(thisUnit) then
	-- 			thisUnit = br._G.GetObjectWithGUID(br._G.UnitGUID(thisUnit))
	-- 		else
	-- 			return -2
	-- 		end
	-- 	end
	-- end

	if enemyTable then
		if enemyTable.ttd[thisUnit] ~= nil then
			return enemyTable.ttd[thisUnit]
		end
	end
	return -1
end
