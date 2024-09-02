local _, br = ...
local enemyTable
function br.TTDRefresh(hpLimit)
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

	for k, _ in pairs(br.enemy) do
		local object = br.enemy[k].unit
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

function br.getTTD(unit, hp)
	if br.getOptionCheck("Enhanced Time to Die") then
		if unit == "target" and br.GetObjectExists("target") then unit = br._G.UnitTarget("player") end
		if br.unitSetup.cache[unit] ~= nil then
			br.unitSetup.cache[unit]:unitTtd(hp)
			return br.unitSetup.cache[unit].ttd
		end
		return -2
	end
	if br.isDummy() then return 99 end
	br.TTDRefresh(hp)
	local thisUnit = unit
	-- if thisUnit ~= nil then
	-- 	if not string.find(thisUnit, "0x") or not type(thisUnit) == "number" then
	-- 		if br.GetObjectExists(thisUnit) and not br.GetUnitIsDeadOrGhost(thisUnit) and br.GetUnitIsVisible(thisUnit) then
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
