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
-- Seconds of damage needed before an estimate is given: one early hit over a moment would read as
-- "dying now". (The Enhanced path needs two samples about 0.5 s apart.)
local MIN_SAMPLE = 1
local lastRefreshAt, lastRefreshHP -- frame time and HP threshold of the last TTDRefresh
local refreshStamp = 0

-- The enemy object for a unit token ("target", which units.dynN often is) or an object.
-- Enemies are keyed by object, so a token never matched before.
local function objectOf(unit)
	if unit == nil then return nil end
	return br._G.ObjectPointer(unit) or unit
end

--- Updates time to die for every enemy. The clock for a unit starts at the first damage seen (its
--- health and the time are moved along while it takes none, or is healed back), so time it spent
--- idle before the pull doesn't dilute its damage rate. Units that left the enemies list are dropped.
-- @param hpLimit the health percentage to estimate the time to (0 = death)
function br.engines.ttdTable:TTDRefresh(hpLimit)
	if not enemyTable then
		enemyTable = {
			units = {},
			ttd = {},
			dps = {},
			health = {},
			seen = {},
			totalUnits = 0,
		}
	end

	local units = enemyTable.units
	local ttd = enemyTable.ttd
	local dps = enemyTable.dps
	local health = enemyTable.health
	local seen = enemyTable.seen
	local now = br._G.GetTime()
	refreshStamp = refreshStamp + 1

	if hpLimit == nil then hpLimit = 0 end

	for _, record in pairs(br.engines.enemiesEngine.enemy) do
		local object = record.unit
		local currentHP = br._G.UnitHealth(object)
		seen[object] = refreshStamp
		if not units[object] then
			enemyTable.totalUnits = enemyTable.totalUnits + 1
			units[object], health[object], dps[object], ttd[object] = now, currentHP, 0, TTD_NEVER
		else
			local diff = health[object] - currentHP
			if diff <= 0 then
				-- No damage since the clock started (or healed back): start it again from here
				units[object], health[object], dps[object], ttd[object] = now, currentHP, 0, TTD_NEVER
			else
				local dura = now - units[object]
				local rate = diff / dura
				dps[object] = math.floor(rate)
				if dura < MIN_SAMPLE then
					ttd[object] = TTD_NEVER
				else
					-- 0 means the unit is at/below the requested HP threshold (dying now)
					local adjustment = health[object] * (hpLimit / 100)
					ttd[object] = math.max(0, currentHP - adjustment) / rate
				end
			end
		end
	end
	for object in pairs(units) do
		if seen[object] ~= refreshStamp then
			units[object], ttd[object], health[object], dps[object], seen[object] = nil, nil, nil, nil, nil
			enemyTable.totalUnits = enemyTable.totalUnits - 1
		end
	end
end

--- Seconds until unit dies (or reaches hp percent), or 999 when it isn't known to be dying.
function br.engines.ttdTable:getTTD(unit, hp)
	local object = objectOf(unit)
	if br.functions.misc:getOptionCheck("Enhanced Time to Die") then
		local record = object and br.engines.enemiesEngine.records[object]
		if record ~= nil then
			record:unitTtd(hp)
			-- Un-computed .ttd (nil) means "unknown", not "dying now" — return
			-- TTD_NEVER so `ttd < N` checks don't misfire. unitTtd no longer
			-- returns negatives (0 = dead/now, positive = estimate, 999 = unknown).
			return record.ttd or TTD_NEVER
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
	if enemyTable and object and enemyTable.ttd[object] ~= nil then
		return enemyTable.ttd[object]
	end
	return TTD_NEVER
end
