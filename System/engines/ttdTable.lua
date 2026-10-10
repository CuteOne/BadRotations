local _, br = ...
br.engines.ttdTable = br.engines.ttdTable or {}
local ttdTable = br.engines.ttdTable
local enemyTable

-- Sentinel returned when a unit is not on track to die: warm-up (just sighted),
-- no net damage observed yet, no measurable DPS, or untracked. A large positive
-- value so `ttd < N` "dying soon" execute/finisher checks correctly evaluate
-- false while it is unknown. Mirrors the Enhanced TTD path (EnemiesEngine.lua),
-- which already returns 999 for the same states. The old -1/0 sentinels were
-- less than every threshold, so e.g. Druid biteAtEnd (`ttd < 6`) misread an
-- unknown TTD as "target dies in <6s" and fired the wrong finisher.
local TTD_NEVER = 999
local lastRefreshAt, lastRefreshHP -- frame time and HP threshold of the last TTDRefresh

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
			-- Baseline health is the unit's current health at first sighting
			health[object] = br._G.UnitHealth(object)
			dps[object] = 0
			if ttd[object] == nil then
				ttd[object] = TTD_NEVER
			end
			enemyTable.totalUnits = enemyTable.totalUnits + 1
		else
			if units[object] and ttd[object] then
				local currentHP = br._G.UnitHealth(object)
				local maxHP = health[object]
				local diff = maxHP - currentHP
				local dura = br._G.GetTime() - units[object]
				local _dps = (dura > 0) and (diff / dura) or 0
				dps[object] = math.floor(_dps)
				local adjustment = maxHP * (hpLimit / 100)
				-- No net damage observed (diff <= 0, e.g. healed back to baseline)
				-- or no measurable DPS yet: the unit is not on track to die, so
				-- report TTD_NEVER rather than the old -1/0 sentinels that
				-- `ttd < N` checks misread as "dying now".
				if diff <= 0 or _dps <= 0 then
					ttd[object] = TTD_NEVER
				else
					-- max(0, ...) over a positive dps is always >= 0; 0 means the
					-- unit is at/below the requested HP threshold (dying now).
					ttd[object] = math.max(0, currentHP - adjustment) / _dps
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
			-- Un-computed .ttd (nil) means "unknown", not "dying now" — return
			-- TTD_NEVER so `ttd < N` checks don't misfire. unitTtd no longer
			-- returns negatives (0 = dead/now, positive = estimate, 999 = unknown).
			return br.engines.enemiesEngine.unitSetup.cache[unit].ttd or TTD_NEVER
		end
		return TTD_NEVER -- not yet in the enemies cache: unknown, treat as not-soon-dying
	end
	if br.functions.unit:isDummy() then return 99 end
	-- TTDRefresh updates every enemy; values can't change within a frame, so do it once per frame.
	-- It writes one shared table for its HP threshold, so a different threshold refreshes again.
	local now = br._G.GetTime()
	if now ~= lastRefreshAt or hp ~= lastRefreshHP then
		lastRefreshAt, lastRefreshHP = now, hp
		ttdTable:TTDRefresh(hp)
	end
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
	return TTD_NEVER
end
