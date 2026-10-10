local _, br     = ...
local LibDraw   = br._G.LibStub("LibDraw-BR")
br.engines.enemiesEngineFunctions = br.engines.enemiesEngineFunctions or {}
local enemiesEngineFunctions = br.engines.enemiesEngineFunctions
-- getEnemies results for anchors other than the player: [checkNoCombat][unit][radius][facing] = list
local storedTables = {}
local addedSet = {} -- Reusable set for getEnemies duplicate tracking (avoid per-call allocation)

-- Partition cache for getEnemies: dedupes the multi-radius-scan pattern that
-- rotation runRotation()s exhibit (e.g. Druid-TBC asks for 5y / 8y / 10y / 20y /
-- 40y in one tick). One annotated base scan per source table per within-tick
-- window; subsequent same-source calls derive their result without re-iterating
-- the source table. See AUDIT.md L18.
local partitionCache = {
	enemy = nil,  -- populated when checkNoCombat=false and thisUnit="player"
	units = nil,  -- populated when checkNoCombat=true  and thisUnit="player"
}

-- Lifted from getEnemies (was a per-call closure). Module scope eliminates the
-- per-call allocation that AUDIT.md L21 flagged. targetIsDummy is passed in
-- because it's the only enclosing-scope value the original closure captured;
-- unitFuncs / rangeFuncs are accessed via br.functions (cheap, no allocation).
local function dummyAllowed(u, targetIsDummy)
	if not u or not br.functions.unit:isDummy(u) then return true end
	if br.functions.unit:GetUnitIsUnit(u, "target") then return true end
	if targetIsDummy then
		local d = br.functions.range:getDistance(u, "target")
		if d and d <= 8 then return true end
	end
	return false
end

-- Partition cache validity check. Mirrors the existing storedTables cache
-- invalidation (TTL + player-movement threshold) so the partition cache and
-- storedTables stay in sync — a partition derivation is correctness-equivalent
-- to a fresh full scan within this window.
local function isPartitionCacheValid(pCache, radius, now, inCombat, inRaid)
	if not pCache then return false end
	local cacheExpiration = inCombat and 0.1 or 0.15
	if (now - pCache.timestamp) > cacheExpiration then return false end
	local px = br.engines.enemiesEngine.playerPosX
	local py = br.engines.enemiesEngine.playerPosY
	local pz = br.engines.enemiesEngine.playerPosZ
	if pCache.playerPosX and px and py and pz then
		local dx = pCache.playerPosX - px
		local dy = pCache.playerPosY - py
		local dz = pCache.playerPosZ - pz
		local moved = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
		local moveThreshold = (inRaid and radius and radius > 20) and 3.0 or 2.0
		if moved > moveThreshold then return false end
	end
	return true
end

-- Iterate the source table once, annotate each in-range entry with (range,
-- facing, dummyOk), and store the result. The annotations are computed once
-- per entry per tick; subsequent partition derivations read them directly.
-- Facing is computed during rebuild (Option B from the L18 plan) — cheaper
-- per-tick when multiple partitions need facing variants. Revisit to Option A
-- (compute facing only when a partition needs it) if benchmarking shows
-- facing-required partitions are rare across the 49 rotation profiles.
--
-- Uses strict-less-than (d < targetRadius) to match the original getEnemies
-- filter behavior at the old L441 / current L445; derivePartitionResult uses
-- the same strict form. See AUDIT.md L18 for the preservation note.
--
-- Writes back v.range and v.timestamp on source entries (preserved from
-- original behavior) — this is a load-bearing dependency for L26's due-queue
-- work: the partition cache rebuild is one of the primary places .range gets
-- refreshed. The partition cache is both a .range reader and writer, not just
-- a reader; surface this when L26 is planned.
-- Distance from the player to an engine entry: the stored range while it's under 0.25 s old,
-- otherwise measured and stored back on the entry.
local function entryDistanceFromPlayer(v, now, rangeFuncs)
	if v.range ~= nil and v.timestamp ~= nil and (now - v.timestamp) <= 0.25 then
		return v.range
	end
	local d = rangeFuncs:getDistance("player", v.unit)
	v.range = d
	v.timestamp = now
	return d
end

local function rebuildPartitionCache(sourceKey, targetRadius, unitFuncs, rangeFuncs, targetIsDummy)
	local sourceTable = (sourceKey == "units")
		and br.engines.enemiesEngine.units
		or  br.engines.enemiesEngine.enemy
	local entries = {}
	local now = br._G.GetTime()
	for _, v in pairs(sourceTable) do
		local vUnit = v and v.unit
		if vUnit and not unitFuncs:GetUnitIsDeadOrGhost(vUnit) then
			local d = entryDistanceFromPlayer(v, now, rangeFuncs)
			if d and d < targetRadius then
				entries[#entries + 1] = {
					unit    = vUnit,
					range   = d,
					facing  = unitFuncs:getFacing("player", vUnit),
					dummyOk = dummyAllowed(vUnit, targetIsDummy),
				}
			end
		end
	end
	partitionCache[sourceKey] = {
		timestamp  = now,
		playerPosX = br.engines.enemiesEngine.playerPosX,
		playerPosY = br.engines.enemiesEngine.playerPosY,
		playerPosZ = br.engines.enemiesEngine.playerPosZ,
		maxRadius  = targetRadius,
		entries    = entries,
	}
end

-- Derive a result table from the partition cache. Iterates only the annotated
-- entries (already filtered to maxRadius, dead/ghost-excluded, dummy-checked),
-- applying the call's specific (radius, facing) filter. ipairs over a packed
-- array is faster than the source-table pairs iteration.
--
-- Staleness contract: dead/ghost check happens during rebuild only. Derivations
-- within the TTL window may return units that died mid-window. This matches
-- the existing storedTables cache (which also caches result tables across the
-- same window), so it's not a regression — but the dropped GetUnitIsDeadOrGhost
-- check at the derivation layer is the kind of thing a future reader might flag
-- as missing without realizing the architectural design. Window is bounded by
-- isPartitionCacheValid's 0.02s combat / 0.05s OOC TTL + 2-3y movement.
local function derivePartitionResult(pCache, radius, facing)
	local result = {}
	local tinsert = br._G.tinsert
	table.wipe(addedSet)
	for i = 1, #pCache.entries do
		local entry = pCache.entries[i]
		local vUnit = entry.unit
		if vUnit and entry.dummyOk and not addedSet[vUnit] then
			if entry.range < radius and (not facing or entry.facing) then
				tinsert(result, vUnit)
				addedSet[vUnit] = true
			end
		end
	end
	return result
end

--Check Totem
function enemiesEngineFunctions:isTotem(unit)
	local creatureType = br._G.UnitCreatureType(unit)
	if creatureType ~= nil then
		if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém"
			or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰"
		then
			return true
		end
	end
	return false
end

-- Start getEnemies' per-unit caches over (the engine calls this after each full object scan)
function enemiesEngineFunctions:clearStoredTables()
	for k in pairs(storedTables) do storedTables[k] = nil end
end

-- /dump enemiesEngineFunctions:getEnemies("target",10)
function enemiesEngineFunctions:getEnemies(thisUnit, radius, checkNoCombat, facing)
	local startTime = br._G.debugprofilestop()
	radius = tonumber(radius) or 0
	-- enemyTable selection happens inside rebuildPartitionCache for player-relative
	-- scans; fallback paths below reference br.engines.enemiesEngine.units directly.
	local enemiesTable = {}
	local thisEnemy, distance
	if checkNoCombat == nil then checkNoCombat = false end
	if facing == nil then facing = false end
	local now, inCombat, inRaid = br._G.GetTime(), br._G.UnitAffectingCombat("player"), br._G.IsInRaid()
	if storedTables[checkNoCombat] ~= nil then
		if storedTables[checkNoCombat][thisUnit] ~= nil then
			if storedTables[checkNoCombat][thisUnit][radius] ~= nil then
				if storedTables[checkNoCombat][thisUnit][radius][facing] ~= nil then
					local cachedTable = storedTables[checkNoCombat][thisUnit][radius][facing]
					-- Combat-reactive cache duration: much shorter in combat for higher reactivity
					local cacheExpiration = inCombat and 0.1 or 0.15
					-- Slightly longer TTL when checkNoCombat is true (out-of-combat queries are less time-sensitive)
					if checkNoCombat then cacheExpiration = 0.1 end
					-- Invalidate cache if player moved since cache creation (prevents stale AoE/position info)
					-- Use the position cached by enemiesEngine:Update() to avoid a redundant ObjectPosition call
					local px = br.engines.enemiesEngine.playerPosX
					local py = br.engines.enemiesEngine.playerPosY
					local pz = br.engines.enemiesEngine.playerPosZ
					local movedTooFar = false
					if cachedTable._playerPosX and px and py and pz then
						local dx = cachedTable._playerPosX - px
						local dy = cachedTable._playerPosY - py
						local dz = cachedTable._playerPosZ - pz
						local moved = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
						-- Invalidate cache on significant movement.
						-- Relaxed threshold in raids for large-radius queries (open rooms like Maiden of Virtue).
						local moveThreshold = (inRaid and radius and radius > 20) and 3.0 or 2.0
						if moved > moveThreshold then movedTooFar = true end
					end
					if cachedTable._timestamp and (now - cachedTable._timestamp) < cacheExpiration and not movedTooFar then
						return cachedTable
					end
				end
			end
		end
	end

	-- Localize frequently used references for performance
	local rangeFuncs = br.functions.range
	local unitFuncs = br.functions.unit

	-- Dummies should not influence enemy counts/lists unless the player is explicitly
	-- testing them: only include dummies if they are the player's current target OR
	-- they are within 8 yards of a targeted dummy.
	-- dummyAllowed is now module-scope (lifted to retire AUDIT.md L21); receives
	-- targetIsDummy as a parameter rather than capturing via closure.
	local targetIsDummy = unitFuncs:isDummy("target") and unitFuncs:GetUnitExists("target")

	-- Quick guard: when not requesting `checkNoCombat`, avoid returning enemies
	-- while the player is not in combat and the requested unit (or player's target)
	-- isn't a valid unit. This prevents accidental population outside combat.
	if not checkNoCombat and not inCombat then
		local unitToCheck = thisUnit or "player"
		local validRequest = false
		if unitToCheck == "player" then
			-- If caller asked about player-area, require at least a valid target to proceed
			validRequest = br.functions.misc:isValidUnit("target")
		else
			-- For specific units (target, focus, pointers), only proceed if that unit is valid
			validRequest = br.functions.misc:isValidUnit(unitToCheck)
		end
		if not validRequest then
			if br.functions.misc:isChecked("Enemy List Debug") then
				br._G.print("[enemiesEngine.getEnemies] Early exit: non-combat and no valid unit for: " .. tostring(unitToCheck))
			end
			br.debug.cpu:updateDebug(startTime, "enemiesEngine.getEnemies_quickguard")
			return {}
		end
	end

	-- Partition-cache fast path for player-relative scans.
	--
	-- ARCHITECTURAL GATE — DO NOT EXTEND TO NON-PLAYER UNITS WITHOUT REDESIGN.
	-- The partition cache stores entries annotated with `range` and `facing`
	-- computed relative to the player. enemiesEngine:Update() publishes
	-- enemiesEngine.playerPosX/Y/Z once per pulse so getDistance and getFacing
	-- consume a single coherent position reference. Extending the partition
	-- cache to target-relative scans (or any non-player anchor) would require
	-- a separate cache per anchor unit AND a per-anchor position invalidation
	-- mechanism — different correctness contract, not just a wider scope.
	-- Non-player scans fall through to the existing fallback paths below.
	if thisUnit == "player" then
		local sourceKey = checkNoCombat and "units" or "enemy"
		local pCache = partitionCache[sourceKey]
		if not (isPartitionCacheValid(pCache, radius, now, inCombat, inRaid) and pCache.maxRadius >= radius) then
			-- Cache miss, expired, moved, or radius wider than cached: rebuild.
			-- Widen to max(requested radius, prior cache max) so we don't shrink
			-- the cache if a smaller-radius call follows a larger one.
			local widened = math.max(radius, (pCache and pCache.maxRadius) or 0)
			rebuildPartitionCache(sourceKey, widened, unitFuncs, rangeFuncs, targetIsDummy)
			pCache = partitionCache[sourceKey]
		end
		enemiesTable = derivePartitionResult(pCache, radius, facing)
	end

	-- FIXED: Improved fallback to include enemies not yet in validated tables
	-- Check for target if we have one and it's valid
	if #enemiesTable == 0 and br.functions.unit:GetUnitExists("target")
		and br.functions.range:getDistance("target", "player") < radius
		and br.functions.misc:isValidUnit("target")
		and (not facing or br.functions.unit:getFacing("player", "target")) then
		br._G.tinsert(enemiesTable, "target")
	end

	-- FIXED: If still empty and no target, check for enemies with threat on player/group (e.g., mobs attacking you)
	-- This catches enemies that haven't been validated yet but are actively engaging the player
	if #enemiesTable == 0 and not checkNoCombat and inCombat then
		-- Check all units in the broader units table (includes unvalidated units).
		-- Cap on accepted units (not loop iterations) — bounds the per-fire cost
		-- to (fallbackCap × per-entry ops). See AUDIT.md L19 for cap-value
		-- reasoning (asymmetric error cost: too-high is perf cost, too-low is
		-- correctness/functional cost; 30 picked on that basis, NOT precedent).
		-- Scoping note: fallbackCap is INTENTIONALLY block-local, not hoisted to
		-- function-top. Unlike L18/L26/L27's per-pulse-stable constants, this
		-- value is scoped to this particular fallback's invocation lifetime and
		-- carries no semantic relationship to other call paths through this
		-- function. Reflexive hoisting during a later cleanup pass would lose
		-- the lexical association between cap and the fallback it bounds.
		local fallbackCount = 0
		local fallbackCap = 30
		for _, v in pairs(br.engines.enemiesEngine.units) do
			if fallbackCount >= fallbackCap then break end
			local thisEnemy = v.unit
			if dummyAllowed(thisEnemy, targetIsDummy)
				and br.functions.unit:GetUnitExists(thisEnemy)
				and not br.functions.unit:GetUnitIsDeadOrGhost(thisEnemy) then
				local distance = thisUnit == "player" and entryDistanceFromPlayer(v, now, br.functions.range)
					or br.functions.range:getDistance(thisUnit, thisEnemy)
				if distance < radius and (not facing or br.functions.unit:getFacing("player", thisEnemy)) then
					-- Check if this enemy has threat on us or is targeting us
					if br.functions.combat:hasThreat(thisEnemy) or br.functions.misc:isTargeting(thisEnemy) then
						br._G.tinsert(enemiesTable, thisEnemy)
						fallbackCount = fallbackCount + 1
					end
				end
			end
		end
	end
	---
	-- Empty results are cached too: an empty query otherwise reruns the threat fallback scan on every call
	if thisUnit ~= nil then
		if storedTables[checkNoCombat] == nil then storedTables[checkNoCombat] = {} end
		if storedTables[checkNoCombat][thisUnit] == nil then storedTables[checkNoCombat][thisUnit] = {} end
		if storedTables[checkNoCombat][thisUnit][radius] == nil then storedTables[checkNoCombat][thisUnit][radius] = {} end
		-- FIXED: Add timestamp to cached table so cache expiration check works properly
		enemiesTable._timestamp = now
		-- store player position at cache time to detect movement-based invalidation (flat fields, no sub-table alloc)
		enemiesTable._playerPosX = br.engines.enemiesEngine.playerPosX
		enemiesTable._playerPosY = br.engines.enemiesEngine.playerPosY
		enemiesTable._playerPosZ = br.engines.enemiesEngine.playerPosZ
		storedTables[checkNoCombat][thisUnit][radius][facing] = enemiesTable
		--print("Made Table Unit: "..UnitName(thisUnit).." Radius: "..radius.." CombatCheck: "..tostring(checkNoCombat))
	end
	-- Debugging
	br.debug.cpu:updateDebug(startTime, "enemiesEngine.getEnemies")
	return enemiesTable
end

-- returns true if target should be burnt
function enemiesEngineFunctions:isBurnTarget(unit)
	local coef = 0
	-- check if unit is valid
	if br.functions.misc:getOptionCheck("Forced Burn") and br._G.UnitExists(unit) and br.functions.combat:hasThreat(unit) then
		local unitID = br.functions.unit:GetObjectID(unit)
		local burnUnit = br.lists.burnUnits[unitID]
		local unitTime = br.engines.enemiesEngine.units[unit] ~= nil and br.engines.enemiesEngine.units[unit].timestamp or br._G.GetTime() - 1
		-- if unit have selected debuff
		if burnUnit and burnUnit.isValidUnit and (burnUnit.cast == nil or not br.functions.cast:isCasting(burnUnit.cast, unitID)) and (br._G.GetTime() - unitTime) > 0.25 then
			if burnUnit.buff and br.functions.aura:UnitBuffID(unit, burnUnit.buff) then
				coef = burnUnit.coef
			end
			if not burnUnit.buff and (br._G.UnitName(unit) == burnUnit.name or --[[burnUnit or]] burnUnit.id == unitID) then
				--if not UnitIsUnit("target",unit) then TargetUnit(unit) end
				coef = burnUnit.coef
			end
		end
	end
	return coef
end

-- check for a unit see if its a cc candidate
function enemiesEngineFunctions:isCrowdControlCandidates(Unit)
	local unitID
	-- check if unit is valid
	if br.functions.unit:GetObjectExists(Unit) then
		unitID = br.functions.unit:GetObjectID(Unit)
	else
		return false
	end
	-- cycle list of candidates
	local crowdControlUnit = br.lists.ccUnits[unitID]
	if crowdControlUnit then
		for i = 1, #crowdControlUnit do
			local thisUnit = crowdControlUnit[i]
			-- is in the list of candidates
			if thisUnit.spell == nil or br.functions.cast:isCasting(thisUnit.spell, Unit) or br.functions.aura:UnitBuffID(Unit, thisUnit.buff) then -- doesnt have more requirements or requirements are met
				return true
			end
		end
	end
	return false
end

-- returns true if we can safely attack this target
function enemiesEngineFunctions:isSafeToAttack(unit)
	if br.functions.misc:getOptionCheck("Safe Damage Check") == true then
		local startTime = br._G.debugprofilestop()
		-- check if unit is valid
		local unitID = br.functions.unit:GetObjectExists(unit) and br.functions.unit:GetObjectID(unit) or 0
		for i = 1, #br.lists.noTouchUnits do
			local noTouch = br.lists.noTouchUnits[i]
			if noTouch.unitID == 1 or noTouch.unitID == unitID then
				if noTouch.buff == nil then return false end --If a unit exist in the list without a buff it's just blacklisted
				if noTouch.buff > 0 then
					-- Not Safe with Buff/Debuff
					if br.functions.aura:UnitBuffID(unit, noTouch.buff) or br.functions.aura:UnitDebuffID(unit, noTouch.buff)
						-- Bursting M+ Affix (stacks first: time to die is only needed when they're high)
						or (br.functions.aura:getDebuffStacks("player", br.lists.unitRules.bursting) >= br.functions.misc:getOptionValue("Bursting Stack Limit")
							and (br.engines.ttdTable:getTTD(unit) or 0) <= br.functions.aura:getDebuffRemain("player", br.lists.unitRules.bursting) + (br.functions.spell:getGlobalCD(true) * 2))
					then
						return false
					end
				else
					-- Not Safe without Buff/Debuff
					local posBuff = -(noTouch.buff)
					if not (br.functions.aura:UnitBuffID(unit, posBuff) or br.functions.aura:UnitDebuffID(unit, posBuff)) then
						return false
					end
				end
			end
		end
		-- Debugging
		br.debug.cpu:updateDebug(startTime, "enemiesEngine.isSafeToAttack")
	end
	-- if all went fine return true
	return true
end

-- returns true if target is shielded or should be avoided
local function isShieldedTarget(unit)
	local coef = 0
	if br.functions.misc:getOptionCheck("Avoid Shields") then
		-- check if unit is valid
		local unitID = br.functions.unit:GetObjectID(unit)
		local shieldedUnit = br.lists.shieldUnits[unitID]
		-- if unit have selected debuff
		if shieldedUnit and shieldedUnit.buff and br.functions.aura:UnitBuffID(unit, shieldedUnit.buff) then
			-- if it's a frontal buff, see if we are in front of it
			if shieldedUnit.frontal ~= true or br.functions.unit:getFacing(unit, "player") then
				coef = shieldedUnit.coef
			end
		end
	end
	return coef
end

local coefficientCache = {}
-- Make coefficient cache shorter to adapt to fast-changing combat situations
local COEF_CACHE_TIME = 0.1
local lastCoefficientCleanup = 0
-- This function will set the prioritisation of the units, ie which target should i attack
local function getUnitCoeficient(unit)
	local startTime = br._G.debugprofilestop()
	local now = br._G.GetTime()

	-- Periodic cleanup of dead units from cache (once per second)
	if now - lastCoefficientCleanup > 1 then
		for cachedUnit in pairs(coefficientCache) do
			if not br.functions.unit:GetObjectExists(cachedUnit) then
				coefficientCache[cachedUnit] = nil
			end
		end
		lastCoefficientCleanup = now
	end

    local cached = coefficientCache[unit]
    if cached and (now - cached.time) < COEF_CACHE_TIME then
        return cached.value
    end

    local coef = 0
	local distance = br.functions.range:getDistance("player", unit)
	-- check if unit is valid
	if br.functions.unit:GetObjectExists(unit) then
		-- if unit is out of range, bad prio(0)
		if distance < 50 then
			local unitHP = br.functions.unit:getHP(unit)
			-- if wise target checked, we look for best target by looking to the lowest or highest hp, otherwise we look for target
			if br.functions.misc:getOptionCheck("Wise Target") == true then
				if br.functions.misc:getOptionValue("Wise Target") == 1 then -- Highest
					-- if highest is selected
					coef = unitHP
				elseif br.functions.misc:getOptionValue("Wise Target") == 3 then -- abs Highest
					coef = br._G.UnitHealth(unit)
				elseif br.functions.misc:getOptionValue("Wise Target") == 5 then -- Nearest
					coef = 100 - distance
				elseif br.functions.misc:getOptionValue("Wise Target") == 6 then -- Furthest
					coef = distance
				else                                  -- Lowest
					-- if lowest is selected
					coef = 100 - unitHP
				end
			end
			-- Distance Coef add for multiple burn units (Will prioritize closest first)
			coef = coef + ((50 - distance) / 100)
			-- if its our actual target we give it a bonus (increased to strongly prefer selected target)
			if br.functions.unit:GetUnitIsUnit("target", unit) == true and not br.functions.unit:GetUnitIsDeadOrGhost(unit) then
				coef = coef + 200
			end
			-- raid target management
			-- if the unit have the skull and we have param for it add 50
			if br.functions.misc:getOptionCheck("Skull First") and br._G.GetRaidTargetIndex(unit) == 8 then
				coef = coef + 50
			end
			-- if threat is checked, add 100 points of prio if we lost aggro on that target
			if br.functions.misc:getOptionCheck("Tank Threat") then
				local threat = br._G.UnitThreatSituation("player", unit) or -1
				local _,_,_,_,role =  br._G.GetSpecializationInfoForSpecID(br.loader.selectedSpecID)
				if role == "TANK" and threat < 3 and unitHP > 10 then
					coef = coef + 100 - threat
				end
			end
			if br.functions.misc:isChecked("Prioritize Totems") and enemiesEngineFunctions:isTotem(unit) then
				coef = coef + 100
			end
			-- if user checked burn target then we add the value otherwise will be 0
			if br.functions.misc:getOptionCheck("Forced Burn") then
				coef = coef + enemiesEngineFunctions:isBurnTarget(unit) + ((50 - distance) / 100)
			end
			-- if user checked avoid shielded, we add the % this shield remove to coef
			if br.functions.misc:getOptionCheck("Avoid Shields") then
				coef = coef + isShieldedTarget(unit)
			end
			-- local displayCoef = math.floor(coef*10)/10
			-- local displayName = UnitName(unit) or "invalid"
			-- Print("Unit "..displayName.." - "..displayCoef)
		end
	end

	-- Allow profiles to add custom coefficient weights via units.customTargetWeight
	if br.player and br.player.units and br.player.units.customTargetWeight then
		local customWeight = br.player.units.customTargetWeight(unit)
		if customWeight and type(customWeight) == "number" then
			coef = coef + customWeight
		end
	end

	coefficientCache[unit] = { value = coef, time = now }
	-- Debugging
	br.debug.cpu:updateDebug(startTime, "enemiesEngine.unitCoef")
	return coef
end

-- compare() is used by table.sort in findBestUnit.
-- Pre-computed proxies are stored in _compareData to avoid calling live APIs per-comparison.
local _compareData = {}
local function compare(a, b)
	local da = _compareData[a]
	local db = _compareData[b]
	if da and db then
		if da.hp == db.hp then
			return da.dist < db.dist
		else
			return da.hp < db.hp
		end
	end
	-- Fallback (should not normally be reached)
	if br._G.UnitHealth(a) == br._G.UnitHealth(b) then
		return br.functions.range:getDistance(a) < br.functions.range:getDistance(b)
	else
		return br._G.UnitHealth(a) < br._G.UnitHealth(b)
	end
end

local bestUnitCache = {}
local BEST_UNIT_CACHE_TIME = 0.12

-- Finds the "best" unit for a given range and optional facing
local function findBestUnit(range, facing)
	local tsort = table.sort
	local startTime = br._G.debugprofilestop()
	local bestUnitCoef
	local bestUnit = nil
	local now = br._G.GetTime()
	local cacheKey = range .. "_" .. tostring(facing)
	local cached = bestUnitCache[cacheKey]

	-- Validate cached unit still exists before returning
	if cached and (now - cached.time) < BEST_UNIT_CACHE_TIME then
		if cached.unit and br.functions.unit:GetObjectExists(cached.unit)
			and not br.functions.unit:GetUnitIsDeadOrGhost(cached.unit) then
			-- Don't use cached dummies - they shouldn't be auto-selected
			if br.functions.unit:isDummy(cached.unit) then
				bestUnitCache[cacheKey] = nil
			else
				local stillValid = br.functions.cast:isUnitVisible(cached.unit)
				if stillValid and br.functions.misc:getOptionCheck("Safe Damage Check") and not enemiesEngineFunctions:isSafeToAttack(cached.unit) then
					stillValid = false
				end
				if stillValid then
					return cached.unit
				end
			end
		end
		bestUnitCache[cacheKey] = nil
	end

	-- Only units we can see are candidates. The engine keeps out-of-LoS enemies in its
	-- lists (rotations still count them), so filter here into a new table rather than
	-- touching getEnemies' cached one. A unit that comes back into view is picked up
	-- again on a later call.
	local enemyList = {}
	for _, u in ipairs(enemiesEngineFunctions:getEnemies("player", range, false, facing)) do
		if br.functions.cast:isUnitVisible(u) then
			enemyList[#enemyList + 1] = u
		end
	end

	if #enemyList == 0 then
		bestUnitCache[cacheKey] = { unit = nil, time = now }
		br.debug.cpu:updateDebug(startTime, "enemiesEngine.findBestUnit")
		return nil
	end

	-- Cache option checks to avoid repeated calls inside the loop
	local dontBreakCC = br.functions.misc:getOptionCheck("Don't break CCs")
	local safeDamageCheck = br.functions.misc:getOptionCheck("Safe Damage Check")
	local wiseTargetEnabled = br.functions.misc:getOptionCheck("Wise Target")
	local wiseTargetMode = wiseTargetEnabled and br.functions.misc:getOptionValue("Wise Target") == 4

	-- Single target optimization: skip coefficient calculation when only one enemy
	if #enemyList == 1 then
		local onlyUnit = enemyList[1]
		if br.functions.unit:isDummy(onlyUnit) then
			bestUnitCache[cacheKey] = { unit = nil, time = now }
			br.debug.cpu:updateDebug(startTime, "enemiesEngine.findBestUnit")
			return nil
		end
		if safeDamageCheck and not enemiesEngineFunctions:isSafeToAttack(onlyUnit) then
			bestUnitCache[cacheKey] = { unit = nil, time = now }
			br.debug.cpu:updateDebug(startTime, "enemiesEngine.findBestUnit")
			return nil
		end
		bestUnitCache[cacheKey] = { unit = onlyUnit, time = now }
		br.debug.cpu:updateDebug(startTime, "enemiesEngine.findBestUnit")
		return onlyUnit
	end

	-- Pre-compute health + distance for each unit so compare() does no API calls
	for _, u in ipairs(enemyList) do
		_compareData[u] = { hp = br._G.UnitHealth(u), dist = br.functions.range:getDistance(u) or 999 }
	end

	-- Sort every candidate, then weigh only the first 20 (and the current target wherever it sorted):
	-- in very large pulls the coefficients are the costly part. Cutting before sorting kept an
	-- arbitrary 20 and could drop the best unit.
	tsort(enemyList, compare)
	if #enemyList > 20 then
		local subset = {}
		for i = 1, #enemyList do
			if i <= 20 or br.functions.unit:GetUnitIsUnit(enemyList[i], "target") then subset[#subset + 1] = enemyList[i] end
		end
		for i = 21, #enemyList do _compareData[enemyList[i]] = nil end
		enemyList = subset
	end

	local currHP
	for i = 1, #enemyList do
		local thisUnit = enemyList[i]
		if not br.functions.unit:isHeldBack(thisUnit) then
			if not br.functions.unit:isDummy(thisUnit) then
				local isCC = dontBreakCC and #enemyList > 1 and br.functions.misc:isLongTimeCCed(thisUnit) or false
				local isSafe = (safeDamageCheck and enemiesEngineFunctions:isSafeToAttack(thisUnit)) or not safeDamageCheck or false

				if not isCC and isSafe then
					local coeficient = getUnitCoeficient(thisUnit) or 0

					if wiseTargetMode then
						if currHP == nil or br._G.UnitHealth(thisUnit) < currHP then
							currHP = br._G.UnitHealth(thisUnit)
							coeficient = coeficient + 100
						end
					end

					if coeficient >= 0 and (bestUnitCoef == nil or coeficient > bestUnitCoef) then
						bestUnitCoef = coeficient
						bestUnit = thisUnit
					end
				end
			end
		end
	end

	-- Clean up pre-compute proxy table
	for _, u in ipairs(enemyList) do
		_compareData[u] = nil
	end

	bestUnitCache[cacheKey] = { unit = bestUnit, time = now }
	br.debug.cpu:updateDebug(startTime, "enemiesEngine.findBestUnit")
	return bestUnit
end

-- Sets Target by attempting to find the best unit else defaults to target
function enemiesEngineFunctions:dynamicTarget(range, facing)
	if range == nil or range > 100 then return nil end

	local startTime = br._G.debugprofilestop()
	facing = facing or false
	local bestUnit = nil
	local tarDist = br.functions.unit:GetObjectExists("target") and br.functions.range:getDistance("target") or 99
	local bestDist
	local inCombat = br._G.UnitAffectingCombat("player")
	local autoTargetDynamic = br.functions.misc:isChecked("Target Dynamic Target")

	-- Determine if the current target is valid for our purposes.
	local targetExists = br.functions.unit:GetUnitExists("target")
	local targetFacingOK = (not facing) or br.functions.unit:getFacing("player", "target")
	local targetInRange = targetExists and tarDist < range
	-- A target we can't see can't be hit; treat it as invalid so dynamic targetting
	-- moves on. It's reacquired normally once it's back in view and ranks highest.
	local targetVisible = targetExists and br.functions.cast:isUnitVisible("target")
	local targetValid = targetExists
		and not br.functions.unit:GetUnitIsDeadOrGhost("target")
		and targetInRange
		and targetFacingOK
		and targetVisible
		and br.functions.misc:isValidUnit("target")
	local notSafe = br.functions.misc:getOptionCheck("Safe Damage Check") and not enemiesEngineFunctions:isSafeToAttack("target") or false
	if targetValid and notSafe then
		targetValid = false
	end

	-- Combo Point Lock: if the player has combo points on the current valid target, do not
	-- switch away. In Classic/TBC, combo points are stored on the target and lost on any switch.
	-- Bears and non-CP classes naturally have GetComboPoints()==0, so this never fires for them.
	if br.api and br.api.comboPointsOnTarget and targetValid then
		local cp = br._G.GetComboPoints and tonumber(br._G.GetComboPoints("player", "target")) or 0
		if cp > 0 then
			return "target"
		end
	end

	-- Stick to a valid current target unless the user explicitly wants to follow the dynamic target.
	if targetValid and not autoTargetDynamic then
		bestUnit = "target"
	else
		if br.functions.misc:isChecked("Dynamic Targetting") then
			-- Wise Target Frequency: "Only on Target Death" mode (option value 2)
			if br.functions.misc:getOptionValue("Wise Target Frequency") == 2 then
				-- Stick with current target if it exists, is valid, alive, and in range
				if br.functions.unit:GetObjectExists("target")
					and not br.functions.unit:GetUnitIsDeadOrGhost("target")
					and tarDist < range
					and (not facing or br.functions.unit:getFacing("player", "target"))
					and targetVisible
					and br.functions.misc:isValidUnit("target")
				then
					bestUnit = "target"
				else
					-- Only recalculate when target is dead/invalid
					bestUnit = findBestUnit(range, facing)
				end
			-- Default mode: recalculate based on combat/setting
			elseif br.functions.misc:getOptionValue("Dynamic Targetting") == 2
				or (inCombat and br.functions.misc:getOptionValue("Dynamic Targetting") == 1)
				and (bestUnit == nil or (br.functions.unit:GetUnitIsUnit(bestUnit, "target") and tarDist >= range))
			then
				bestUnit = findBestUnit(range, facing)
			end
		end

		if (not br.functions.misc:isChecked("Dynamic Targetting") or bestUnit == nil)
			and (tarDist < range or br.functions.unit:GetUnitExists("target"))
			and (not facing or (facing and br.functions.unit:getFacing("player", "target")))
			and br.functions.misc:isValidUnit("target")
		then
			bestUnit = "target"
		end

		-- If we still don't have a unit and we're in combat and need one (invalid target OR forcing dynamic), find one.
		if bestUnit == nil and inCombat and (autoTargetDynamic or not targetValid) then
			bestUnit = findBestUnit(range, facing)
		end
	end

	-- If we have a candidate bestUnit, validate it is actually within range.
	if bestUnit ~= nil and bestUnit ~= "target" then
		bestDist = br.functions.range:getDistance(bestUnit)
		if bestDist == nil or bestDist >= range then
			bestUnit = nil
		elseif not br.functions.misc:isValidUnit(bestUnit) then
			bestUnit = nil
		end
	end

	-- Optional: keep the WoW target in sync with the dynamic target.
	if inCombat then
		local wantRetarget = autoTargetDynamic or not targetExists or not targetVisible
			or (not br.functions.misc:isValidUnit(bestUnit)) or notSafe

		if wantRetarget
			and bestUnit ~= nil
			and br.functions.unit:GetObjectExists(bestUnit)
			and not br.functions.unit:GetUnitIsUnit(bestUnit, "target")
		then
			local shouldTarget = true
			-- Never auto-target dummies.
			if br.functions.unit:isDummy(bestUnit) then
				shouldTarget = false
			end
			-- Don't auto-target explosives unless facing is not required.
			if shouldTarget and (not facing) and br.functions.unit:isExplosive(bestUnit) then
				shouldTarget = false
			end
			if shouldTarget then
				br._G.TargetUnit(bestUnit)
			end
		end
	end
	-- Debugging
	br.debug.cpu:updateDebug(startTime, "enemiesEngine.dynamicTarget")
	return bestUnit
end

-- Cone Logic for Enemies
local coneUnits = {}
function enemiesEngineFunctions:getEnemiesInCone(angle, length, checkNoCombat, showLines)
	if angle == nil then angle = 180 end
	if length == nil then length = 0 end
	local playerX, playerY, playerZ = br.functions.unit:GetObjectPosition("player")
	local facing = br.functions.unit:GetObjectFacing("player")
	local unitsCounter = 0
	local enemiesTable = enemiesEngineFunctions:getEnemies("player", length, checkNoCombat, true)
	local inside = false
	---@diagnostic disable-next-line: undefined-field
	if showLines then LibDraw.Arc(playerX, playerY, playerZ, length, angle, 0) end
	table.wipe(coneUnits)
	-- OPTIMIZATION: Limit processing to first 30 enemies for performance
	-- In massive AOE situations, processing every unit is unnecessary and crushes FPS
	local maxProcess = math.min(#enemiesTable, 30)
	for i = 1, maxProcess do
		local thisUnit = enemiesTable[i]
		local radius = br._G.UnitCombatReach(thisUnit)
		local unitX, unitY, unitZ = br._G.GetPositionBetweenObjects(thisUnit, "player", radius)
		if playerX and unitX and playerY and unitY then
			for j = radius, 0, -0.5 do
				inside = false
				if j > 0 then
					unitX, unitY = br._G.GetPositionBetweenObjects(thisUnit, "player", j)
				else
					unitX, unitY = br.functions.unit:GetObjectPosition(thisUnit)
				end
				local angleToUnit = br.engines.healingEngineFunctions:getAngles(playerX, playerY, playerZ, unitX, unitY, unitZ)
				local angleDifference = facing > angleToUnit and facing - angleToUnit or angleToUnit - facing
				local shortestAngle = angleDifference < math.pi and angleDifference or math.pi * 2 - angleDifference
				local finalAngle = shortestAngle / math.pi * 180
				if finalAngle < angle / 2 then
					inside = true
					break
				end
			end
			if inside then
				if showLines then
					LibDraw.Circle(unitX, unitY, playerZ, br._G.UnitBoundingRadius(thisUnit))
				end
				unitsCounter = unitsCounter + 1
				table.insert(coneUnits, thisUnit)
			end
		end
	end

	-- br.ui.chatOverlay:Show(units)
	return unitsCounter, coneUnits
end

-- Rectangle Logic for Enemies
local rectUnits = {}
function enemiesEngineFunctions:getEnemiesInRect(width, length, showLines, checkNoCombat)
	local px, py, pz = br.functions.unit:GetObjectPosition("player")
	if px == nil or py == nil or pz == nil then return 0, {} end
	local function getRect(width, length)
		local facing = br.functions.unit:GetObjectFacing("player") or 0
		local halfWidth = width / 2
		-- Near Left
		local nlX, nlY, _ = br._G.GetPositionFromPosition(px, py, pz, halfWidth, facing + math.rad(90), 0)
		-- Near Right
		local nrX, nrY, nrZ = br._G.GetPositionFromPosition(px, py, pz, halfWidth, facing + math.rad(270), 0)
		-- Far Left
		-- local flX, flY, flZ = GetPositionFromPosition(nlX, nlY, nlZ, length, facing, 0)
		-- Far Right
		local frX, frY, _ = br._G.GetPositionFromPosition(nrX, nrY, nrZ, length, facing, 0)

		return nlX, nlY, nrX, nrY, frX, frY
	end
	checkNoCombat = checkNoCombat or false
	local nlX, nlY, nrX, nrY, frX, frY = getRect(width, length)
	local enemyCounter = 0
	local enemiesTable = enemiesEngineFunctions:getEnemies("player", length, checkNoCombat, true)
	local inside = false
	if #enemiesTable > 0 then
	 	_G.table.wipe(rectUnits)
		-- OPTIMIZATION: Limit processing to first 40 enemies for performance
		-- Rectangle checks are expensive with position calculations
		local maxProcess = math.min(#enemiesTable, 40)
		for i = 1, maxProcess do
			local thisUnit = enemiesTable[i]
			local radius = br._G.UnitCombatReach(thisUnit)
			local tX, tY = br._G.GetPositionBetweenObjects(thisUnit, "player", radius)
			if tX and tY then
				for j = radius, 0, -0.1 do
					inside = false
					local pX, pY
					if j > 0 then
						pX, pY = br._G.GetPositionBetweenObjects(thisUnit, "player", j)
					else
						pX, pY = br.functions.unit:GetObjectPosition(thisUnit)
					end
					if br.engines.healingEngineFunctions:isInside(pX, pY, nlX, nlY, nrX, nrY, frX, frY) then
						inside = true
						break
					end
				end
				if inside then
					if showLines then
						---@diagnostic disable-next-line: undefined-field
						LibDraw.Circle(tX, tY, pz, br._G.UnitBoundingRadius(thisUnit))
					end
					enemyCounter = enemyCounter + 1
					table.insert(rectUnits, thisUnit)
				end
			end
		end
	end
	return enemyCounter, rectUnits
end
