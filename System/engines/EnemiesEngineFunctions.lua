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

-- How far a unit is from an AoE centred on centreUnit, as the AoE sees it (range:getAoEDistance): an
-- AoE of radius R hits it when this is under R. The height difference counts too, so the larger of the two.
local function aoeDistance(centreUnit, unit)
	local d, dz = br.functions.range:getAoEDistance(centreUnit, unit)
	if d == nil then return 999 end
	return math.max(d, math.abs(dz))
end

-- Lifted from getEnemies (was a per-call closure). Module scope eliminates the
-- per-call allocation that AUDIT.md L21 flagged. targetIsDummy is passed in
-- because it's the only enclosing-scope value the original closure captured;
-- unitFuncs / rangeFuncs are accessed via br.functions (cheap, no allocation).
local function dummyAllowed(u, targetIsDummy)
	if not u or not br.functions.unit:isDummy(u) then return true end
	if br.functions.unit:GetUnitIsUnit(u, "target") then return true end
	if targetIsDummy then
		if aoeDistance("target", u) <= 8 then return true end
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

-- Iterate the source table once, annotate each in-range entry with (aoe,
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
-- Counts by the AoE rule (aoeDistance), kept on each source entry as v.aoeRange
-- for 0.25 s. The entry's .range (getDistance) is refreshed by the engine's own
-- unit update, not here.

-- aoeDistance from the player to an engine entry, kept on the entry for 0.25 s like its range
local function entryAoEFromPlayer(v, now)
	if v.aoeRange ~= nil and v.aoeAt ~= nil and (now - v.aoeAt) <= 0.25 then return v.aoeRange end
	v.aoeRange = aoeDistance("player", v.unit)
	v.aoeAt = now
	return v.aoeRange
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
			local d = entryAoEFromPlayer(v, now)
			if d < targetRadius then
				entries[#entries + 1] = {
					unit    = vUnit,
					aoe     = d,
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
			if entry.aoe < radius and (not facing or entry.facing) then
				tinsert(result, vUnit)
				addedSet[vUnit] = true
			end
		end
	end
	return result
end

--Check Totem
function enemiesEngineFunctions:isTotem(unit)
	return br.functions.unit:isCreatureType(unit, "totem")
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
		and aoeDistance(thisUnit, "target") < radius
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
				local distance = thisUnit == "player" and entryAoEFromPlayer(v, now) or aoeDistance(thisUnit, thisEnemy)
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
-- br.lists.noTouchUnits by NPC ID: { [npcID] = { entries }, any = { entries for every unit (unitID 1) } },
-- built on first use and again when the list grows (it's an array, checked for every unit with Safe
-- Damage Check on)
local noTouchIndex, noTouchIndexed
local NO_ENTRIES = {}
local function noTouchEntries(unitID)
	if noTouchIndex == nil or noTouchIndexed ~= #br.lists.noTouchUnits then
		noTouchIndexed = #br.lists.noTouchUnits
		noTouchIndex = { any = {} }
		for _, entry in ipairs(br.lists.noTouchUnits) do
			local key = entry.unitID == 1 and "any" or entry.unitID
			noTouchIndex[key] = noTouchIndex[key] or {}
			noTouchIndex[key][#noTouchIndex[key] + 1] = entry
		end
	end
	return noTouchIndex.any, noTouchIndex[unitID] or NO_ENTRIES
end

function enemiesEngineFunctions:isSafeToAttack(unit)
	if br.functions.misc:getOptionCheck("Safe Damage Check") == true then
		local startTime = br._G.debugprofilestop()
		-- check if unit is valid
		local unitID = br.functions.unit:GetObjectExists(unit) and br.functions.unit:GetObjectID(unit) or 0
		local anyUnit, thisUnit = noTouchEntries(unitID)
		for pass = 1, 2 do
			local entries = pass == 1 and anyUnit or thisUnit
			for i = 1, #entries do
				local noTouch = entries[i]
				if noTouch.buff == nil then return false end --If a unit exist in the list without a buff it's just blacklisted
				if noTouch.buff > 0 then
					-- Not Safe with Buff/Debuff
					if br.functions.aura:UnitBuffID(unit, noTouch.buff) or br.functions.aura:UnitDebuffID(unit, noTouch.buff)
						-- Bursting M+ Affix (stacks first: time to die is only needed when they're high). The
						-- limit is a Retail option: 0 (no option) means the check doesn't apply
						or (br.functions.misc:getOptionValue("Bursting Stack Limit") > 0
							and br.functions.aura:getDebuffStacks("player", br.lists.unitRules.bursting) >= br.functions.misc:getOptionValue("Bursting Stack Limit")
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

--- How much a shield on the unit should weigh against attacking it (Avoid Shields, br.lists.shieldUnits)
function enemiesEngineFunctions:getShieldCoefficient(unit)
	local coef = 0
	if br.functions.misc:getOptionCheck("Avoid Shields") then
		local shieldedUnit = br.lists.shieldUnits[br.functions.unit:GetObjectID(unit)]
		if shieldedUnit and shieldedUnit.buff and br.functions.aura:UnitBuffID(unit, shieldedUnit.buff) then
			-- a frontal shield only matters from in front of it
			if shieldedUnit.frontal ~= true or br.functions.unit:getFacing(unit, "player") then
				coef = shieldedUnit.coef
			end
		end
	end
	return coef
end

-- Facts about the selected target, read once per frame: whether BR may attack it at all, its
-- distance, and whether it is in front of the player
local targetFacts = { at = nil }
local function readTargetFacts()
	local now = br._G.GetTime()
	if targetFacts.at == now then return targetFacts end
	targetFacts.at = now
	local unitFns, misc = br.functions.unit, br.functions.misc
	local ok = unitFns:GetObjectExists("target") and not unitFns:GetUnitIsDeadOrGhost("target")
		and br.functions.cast:isUnitVisible("target") and misc:isValidUnit("target")
		and not (misc:getOptionCheck("Safe Damage Check") and not enemiesEngineFunctions:isSafeToAttack("target"))
	targetFacts.attackable = ok and true or false
	targetFacts.distance = ok and br.functions.range:getDistance("target") or nil
	targetFacts.inFront = ok and unitFns:getFacing("player", "target") and true or false
	return targetFacts
end

-- Whether the selected target can take a request of this range and facing
local function targetUsable(range, facing)
	local facts = readTargetFacts()
	if not facts.attackable then return false end
	if not ((facts.distance or range) < range) then return false end
	if facing and not facts.inFront then return false end
	return true
end

--- The unit a request of this range (yards) and facing should attack: the selected target when it can
--- take it, otherwise BR's pick (br.engines.targeting), or nil.
--- Options (Targeting page): Targeting Mode Off (or Targeting Only In Combat, out of combat) keeps to
--- the selected target; Assist uses BR's pick when the target can't take the request; Full lets BR's
--- pick replace a usable target and sets the WoW target to it. In combat with no usable target, the
--- WoW target is set to the pick.
function enemiesEngineFunctions:dynamicTarget(range, facing)
	if range == nil or range > 100 then return nil end
	local startTime = br._G.debugprofilestop()
	local misc = br.functions.misc
	facing = facing or false
	local inCombat = br._G.UnitAffectingCombat("player")
	-- Targeting Mode: 1 Off, 2 Assist (the default), 3 Full
	local mode = misc:getOptionValue("Targeting Mode")
	if mode == 0 then mode = 2 end
	local autoTargetDynamic = mode == 3
	local usable = targetUsable(range, facing)
	local result

	local dynamicOn = mode ~= 1 and (inCombat or not misc:isChecked("Targeting Only In Combat"))
	if not dynamicOn then
		result = usable and "target" or nil
	elseif usable and not autoTargetDynamic then
		result = "target"
	elseif usable and br.api and br.api.comboPointsOnTarget
		and (tonumber(br._G.GetComboPoints and br._G.GetComboPoints("player", "target")) or 0) > 0
	then
		-- Combo points are stored on the target (Classic-era) and lost on a switch
		result = "target"
	else
		result = br.engines.targeting:pick(range, facing)
		-- In combat, set the WoW target to the pick when wanted (never to a dummy, nor an explosive
		-- when facing is required)
		if inCombat and result ~= nil then
			local unitFns = br.functions.unit
			local targetExists = unitFns:GetObjectExists("target")
			local wantRetarget = autoTargetDynamic or not targetExists or not br.functions.cast:isUnitVisible("target")
				or (misc:getOptionCheck("Safe Damage Check") and not enemiesEngineFunctions:isSafeToAttack("target"))
			if wantRetarget and not unitFns:GetUnitIsUnit(result, "target") and not unitFns:isDummy(result)
				and not (facing and unitFns:isExplosive(result))
			then
				br._G.TargetUnit(result)
				targetFacts.at = nil -- the target changed: read it afresh
				br.functions.range:clearDistanceMemo()
				enemiesEngineFunctions.lastRetargetAt = br._G.GetTime() -- for the targeting log
			end
		end
	end
	br.debug.cpu:updateDebug(startTime, "enemiesEngine.dynamicTarget")
	return result
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
