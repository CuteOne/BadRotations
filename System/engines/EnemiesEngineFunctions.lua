local _, br     = ...
local LibDraw   = br._G.LibStub("LibDraw-BR")
br.engines.enemiesEngineFunctions = br.engines.enemiesEngineFunctions or {}
br.engines.enemiesEngine.enemy        = {}
br.engines.enemiesEngine.lootable     = {}
br.engines.enemiesEngine.units        = {}
br.engines.enemiesEngine.storedTables = {}
local enemiesEngineFunctions = br.engines.enemiesEngineFunctions
local refreshStored
local lastOMUpdate = 0
local lastTrackerUpdate = 0
-- More reactive update intervals (favor accuracy over FPS)
local OM_UPDATE_INTERVAL = 0.25 -- Update every 0.25 seconds
local TRACKER_UPDATE_INTERVAL = 0.05
local scanOffset = 1 -- Used for batched scanning when object count is high
local addedSet = {} -- Reusable set for getEnemies duplicate tracking (avoid per-call allocation)

-- Tracker list reuse (avoid O(n^2) duplicate checks)
br.engines.tracker = br.engines.tracker or {}
br.engines.tracker.tracking = br.engines.tracker.tracking or {}
br.engines.tracker.trackingIndex = br.engines.tracker.trackingIndex or {}

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

local function unitExistsInOM(unit)
	local omIndex = br.engines.enemiesEngine.omIndex
	return omIndex ~= nil and omIndex[unit] ~= nil
end



--Update OM
function enemiesEngineFunctions:updateOM()
	local now = br._G.GetTime()
	local startTime = br._G.debugprofilestop()

	-- Separate tracker updates from OM updates
	local misc = br.functions.misc
	local shouldUpdateTracker = misc:isChecked("Enable Tracker") and (now - lastTrackerUpdate) >= TRACKER_UPDATE_INTERVAL
    local shouldUpdateOM = (now - lastOMUpdate) >= OM_UPDATE_INTERVAL

	-- Skip building tracker list if no tracker mode is active
	local trackerModeActive = false
	if shouldUpdateTracker then
		local showRare = misc:isChecked("Rare Tracker")
		local showQuest = misc:isChecked("Quest Tracker")
		local showCustom = misc:isChecked("Custom Tracker")
		local customValue = tostring(misc:getOptionValue("Custom Tracker") or "")
		trackerModeActive = showRare or showQuest or (showCustom and customValue ~= "" and string.len(customValue) >= 3)
		if not trackerModeActive then
			shouldUpdateTracker = false
		end
	end

	-- Always update tracker list if needed
	if shouldUpdateTracker then
		table.wipe(br.engines.tracker.tracking)
		table.wipe(br.engines.tracker.trackingIndex)
		lastTrackerUpdate = now
	end

	local om = br.engines.enemiesEngine.om
	br.engines.enemiesEngine.omIndex = br.engines.enemiesEngine.omIndex or {}
	local omIndex = br.engines.enemiesEngine.omIndex
	local objUnit
	local name
	local objectid
	local objectguid
	-- OM is built via index scanning for maximum compatibility across supported unlockers.
	local totalObjects = br._G.GetObjectCount() or 0
	local total = math.min(totalObjects, 500)

	-- Localize hot global functions to reduce table lookups in tight loops
	local GetObjectWithIndex = br._G.GetObjectWithIndex
	local ObjectExists = br._G.ObjectExists
	local ObjectIsUnit = br._G.ObjectIsUnit
	local UnitIsVisible = br._G.UnitIsVisible
	local UnitIsPlayer = br._G.UnitIsPlayer
	local UnitIsUnit = br._G.UnitIsUnit
	local ObjectPosition = br._G.ObjectPosition
	local UnitName = br._G.UnitName
	local ObjectName = br._G.ObjectName
	local ObjectID = br._G.ObjectID
	local UnitGUID = br._G.UnitGUID
	local tinsert = br._G.tinsert

	--[[
		Performance Optimization System:

		1. FPS-based Range Gating for Tracker:
		   - Dynamically reduces scan radius as FPS drops to maintain smooth performance
		   - Graduated tiers: 30y (< 25 FPS), 50y (< 35 FPS), 70y (< 45 FPS), 100y (< 55 FPS), unlimited (55+ FPS)
		   - Prevents scanning distant objects that won't be interacted with when performance is low

		2. Object Count Batching:
		   - When > 300 objects exist, limits objects scanned per update cycle
		   - Spreads the load across multiple frames to prevent frame drops

		3. Distance-based Skipping:
		   - Skips very distant objects for OM updates when FPS is struggling
		   - Works in conjunction with tracker range gating for maximum performance
	]]--
	-- Performance optimization: Dynamically adjust scanning based on object count and FPS
	-- Cache FPS to avoid expensive GetFramerate() calls multiple times per update
	local fps = br.engines.enemiesEngine.cachedFPS or br._G.GetFramerate() or 60
	br.engines.enemiesEngine.cachedFPS = fps -- Cache for use by UpdateUnit

	local objectsPerScan = total
	local skipDistance = nil
	local trackerScanRadius = nil -- Range limit for tracker objects

	-- FPS-based range gating for tracker to maintain smooth performance
	-- Gradually reduce scan radius as FPS drops
	if fps < 25 then
		trackerScanRadius = 30 -- Critical FPS: very tight radius
		skipDistance = 40
	elseif fps < 35 then
		trackerScanRadius = 50 -- Low FPS: tight radius
		skipDistance = 60
	elseif fps < 45 then
		trackerScanRadius = 70 -- Medium-low FPS: moderate radius
		skipDistance = 80
	elseif fps < 55 then
		trackerScanRadius = 100 -- Medium FPS: normal radius
		skipDistance = 100
	else
		-- Good FPS (55+): no tracker range limit but still cap OM distance at 100y
		trackerScanRadius = nil
		skipDistance = 100 -- Always cap at 100y - nothing beyond this matters for gameplay
	end

	-- High object count optimization
	if totalObjects > 300 then
		-- Limit objects scanned per update based on object density
		if totalObjects > 450 then
			objectsPerScan = 150 -- Very high density: scan 1/3 per update
		elseif totalObjects > 350 then
			objectsPerScan = 200 -- High density: scan ~half per update
		else
			objectsPerScan = 250 -- Moderate-high: scan most per update
		end

		-- Additionally skip distant objects if performance is struggling
		-- Override with more aggressive limits at very low FPS
		if fps < 30 then
			skipDistance = math.min(skipDistance or 999, 50) -- Extremely aggressive
		elseif fps < 40 then
			skipDistance = math.min(skipDistance or 999, 60) -- Only scan within 60 yards
		elseif fps < 50 then
			skipDistance = math.min(skipDistance or 999, 80) -- Only scan within 80 yards
		end
	end

	-- Always scan for units to add to OM, but only when we should update
	if shouldUpdateOM then
		lastOMUpdate = now

		-- Refresh object count each OM update tick (keeps batching accurate).
		totalObjects = br._G.GetObjectCount() or 0
		total = math.min(totalObjects, 500)

		-- Calculate scan range for this update
		local scanStart = scanOffset
		local scanEnd = math.min(scanOffset + objectsPerScan - 1, total)

		-- Cache player position for distance checks
		local playerX, playerY, playerZ = ObjectPosition("player")

		for i = scanStart, scanEnd do
			local thisUnit = GetObjectWithIndex(i)
			local shouldProcess = false

			if ObjectExists(thisUnit) and ObjectIsUnit(thisUnit) then
				-- Fast fail checks before expensive operations
				if not UnitIsPlayer(thisUnit) and not UnitIsUnit("player", thisUnit) then
					-- OPTIMIZATION: Check visibility FIRST before any other processing
					-- This is cheap and filters out many units immediately
					if not UnitIsVisible(thisUnit) then
						shouldProcess = false
					else
						shouldProcess = true

						-- Distance check if we're throttling (with cached position)
						if skipDistance ~= nil and playerX ~= nil then
							local unitX, unitY, unitZ = ObjectPosition(thisUnit)
							if unitX ~= nil then
								local distance = math.sqrt(((unitX - playerX) ^ 2) + ((unitY - playerY) ^ 2) + ((unitZ - playerZ) ^ 2))
								if distance > skipDistance then
									shouldProcess = false -- Skip distant units when performance is low
								end
							else
								shouldProcess = false -- No position = skip
							end
						end
					end

					-- Final validation checks (critter check, etc)
					-- NOTE: We always allow batched inserts. `skipOMInsert` only reduces scan budget.
					if shouldProcess and omIndex[thisUnit] == nil and not br.functions.unit:isCritter(thisUnit)
						--and (not br._G.UnitIsFriend("player", thisUnit) or string.match(br._G.UnitGUID(thisUnit), "Pet"))
					then
						local enemyUnit = br.engines.enemiesEngine.unitSetup:new(thisUnit)
						if enemyUnit then
							tinsert(om, enemyUnit)
							omIndex[enemyUnit.unit] = #om
						end
					end
				end
			end

			-- Update tracker during full OM scan
			if shouldUpdateTracker
				and thisUnit ~= nil and ObjectExists(thisUnit)
				and ((ObjectIsUnit(thisUnit) and UnitIsVisible(thisUnit)) or not ObjectIsUnit(thisUnit))
			then
				-- Apply FPS-based range gating for tracker
				local shouldAddToTracker = true
				if trackerScanRadius ~= nil and playerX ~= nil then
					local unitX, unitY, unitZ = ObjectPosition(thisUnit)
					if unitX ~= nil then
						local distance = math.sqrt(((unitX - playerX) ^ 2) + ((unitY - playerY) ^ 2) + ((unitZ - playerZ) ^ 2))
						if distance > trackerScanRadius then
							shouldAddToTracker = false -- Skip distant units for tracker when FPS is low
						end
					end
				end

				if shouldAddToTracker then
					objUnit = ObjectIsUnit(thisUnit)
					name = objUnit and UnitName(thisUnit) or ObjectName(thisUnit)
					objectid = ObjectID(thisUnit)
					objectguid = UnitGUID(thisUnit)
					if thisUnit and name and objectid and objectguid and not br.engines.tracker.trackingIndex[thisUnit] then
						br.engines.tracker.trackingIndex[thisUnit] = true
						tinsert(br.engines.tracker.tracking,
							{ object = thisUnit, unit = objUnit, name = name, id = objectid, guid = objectguid })
					end
				end
			end
		end

		-- Update scan offset for next cycle (batched scanning)
		scanOffset = scanEnd + 1
		if scanOffset > total then
			scanOffset = 1 -- Reset to beginning
			refreshStored = true
		end
	else
		-- When throttled, only update tracker if needed
		if shouldUpdateTracker then
			-- Cache player position for distance checks
			local playerX, playerY, playerZ = ObjectPosition("player")

			for i = 1, total do
				local thisUnit = GetObjectWithIndex(i)
				if ObjectExists(thisUnit)
					and ((ObjectIsUnit(thisUnit) and UnitIsVisible(thisUnit)) or not ObjectIsUnit(thisUnit))
				then
					-- Apply FPS-based range gating for tracker
					local shouldAddToTracker = true
					if trackerScanRadius ~= nil and playerX ~= nil then
						local unitX, unitY, unitZ = ObjectPosition(thisUnit)
						if unitX ~= nil then
							local distance = math.sqrt(((unitX - playerX) ^ 2) + ((unitY - playerY) ^ 2) + ((unitZ - playerZ) ^ 2))
							if distance > trackerScanRadius then
								shouldAddToTracker = false -- Skip distant units for tracker when FPS is low
							end
						end
					end

					if shouldAddToTracker then
						objUnit = ObjectIsUnit(thisUnit)
						name = objUnit and UnitName(thisUnit) or ObjectName(thisUnit)
						objectid = ObjectID(thisUnit)
						objectguid = UnitGUID(thisUnit)
						if thisUnit and name and objectid and objectguid and not br.engines.tracker.trackingIndex[thisUnit] then
							br.engines.tracker.trackingIndex[thisUnit] = true
							tinsert(br.engines.tracker.tracking,
								{ object = thisUnit, unit = objUnit, name = name, id = objectid, guid = objectguid })
						end
					end
				end
			end
		end
	end

	-- Debugging
	br.debug.cpu:updateDebug(startTime, "enemiesEngine.objects")
end

function enemiesEngineFunctions:omDist(thisUnit)
	local x1, y1, z1 = br._G.ObjectPosition("player")
	local x2, y2, z2 = br._G.ObjectPosition(thisUnit)
	if x1 == nil or x2 == nil or y1 == nil or y2 == nil or z1 == nil or z2 == nil then
		return 99
	else
		return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2)) -
			((br._G.UnitCombatReach("player") or 0) + (br._G.UnitCombatReach(thisUnit) or 0))
	end
end

function enemiesEngineFunctions:isInOM(thisUnit)
	-- Use omIndex for O(1) lookup (previous impl passed .guid to ObjectPosition which is a native crash risk)
	local omIndex = br.engines.enemiesEngine.omIndex
	return omIndex ~= nil and omIndex[thisUnit] ~= nil
end

-- /dump enemiesEngineFunctions:getEnemies("target",10)
function enemiesEngineFunctions:getEnemies(thisUnit, radius, checkNoCombat, facing)
	local startTime = br._G.debugprofilestop()
	radius = tonumber(radius) or 0
	local enemyTable = checkNoCombat and br.engines.enemiesEngine.units or br.engines.enemiesEngine.enemy
	local enemiesTable = {}
	local thisEnemy, distance
	if checkNoCombat == nil then checkNoCombat = false end
	if facing == nil then facing = false end
	if refreshStored == true then
		for k, _ in pairs(br.engines.enemiesEngine.storedTables) do br.engines.enemiesEngine.storedTables[k] = nil end
		refreshStored = false
	end
	-- if br.engines.enemiesEngine.storedTables[checkNoCombat] ~= nil then
	-- 	if checkNoCombat == false then
	-- 		if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit] ~= nil then
	-- 			if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius] ~= nil then
	-- 				if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius][facing] ~= nil then
	-- 					--print("Found Table Unit: "..UnitName(thisUnit).." Radius: "..radius.." CombatCheck: "..tostring(checkNoCombat))
	-- 					return br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius][facing]
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end
	if br.engines.enemiesEngine.storedTables[checkNoCombat] ~= nil then
		if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit] ~= nil then
			if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius] ~= nil then
				if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius][facing] ~= nil then
					local cachedTable = br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius][facing]
					-- Combat-reactive cache duration: much shorter in combat for higher reactivity
					local cacheExpiration = br._G.UnitAffectingCombat("player") and 0.02 or 0.05
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
						-- Invalidate cache on significant movement (2.0 yards).
						-- 0.5 was too tight -- normal melee repositioning triggered constant cache rebuilds.
						if moved > 2.0 then movedTooFar = true end
					end
					if cachedTable._timestamp and (br._G.GetTime() - cachedTable._timestamp) < cacheExpiration and not movedTooFar then
						return cachedTable
					end
				end
			end
		end
	end

	-- Localize frequently used references for performance
	local rangeFuncs = br.functions.range
	local unitFuncs = br.functions.unit
	local tinsert = br._G.tinsert

	-- Dummies should not influence enemy counts/lists unless the player is explicitly
	-- testing them: only include dummies if they are the player's current target OR
	-- they are within 8 yards of a targeted dummy.
	local targetIsDummy = unitFuncs:isDummy("target") and unitFuncs:GetUnitExists("target")
	local function dummyAllowed(u)
		if not u or not unitFuncs:isDummy(u) then return true end
		if unitFuncs:GetUnitIsUnit(u, "target") then return true end
		if targetIsDummy then
			local d = rangeFuncs:getDistance(u, "target")
			if d and d <= 8 then return true end
		end
		return false
	end

	-- Quick guard: when not requesting `checkNoCombat`, avoid returning enemies
	-- while the player is not in combat and the requested unit (or player's target)
	-- isn't a valid unit. This prevents accidental population outside combat.
	if not checkNoCombat and not br._G.UnitAffectingCombat("player") then
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

	-- Fast-path when checking around the player: use precomputed .range where available
	if thisUnit == "player" then
		local now = br._G.GetTime()
		table.wipe(addedSet) -- O(1) hash set replaces O(n) GetUnitIsUnit duplicate scan
		for _, v in pairs(enemyTable) do
			local vUnit = v and v.unit
			if vUnit and not unitFuncs:GetUnitIsDeadOrGhost(vUnit) and dummyAllowed(vUnit) and not addedSet[vUnit] then
				local d
				-- Ensure we have an up-to-date range on the enemy entry. Recalculate if missing.
				if v.range ~= nil and v.timestamp ~= nil and (now - v.timestamp) <= 0.25 then
					d = v.range
				else
					d = rangeFuncs:getDistance("player", vUnit)
					v.range = d
					v.timestamp = now
				end
				if d and d < radius and (not facing or unitFuncs:getFacing("player", vUnit)) then
					tinsert(enemiesTable, vUnit)
					addedSet[vUnit] = true
				end
			end
		end
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
	if #enemiesTable == 0 and not checkNoCombat and br._G.UnitAffectingCombat("player") then
		-- Check all units in the broader units table (includes unvalidated units)
		for _, v in pairs(br.engines.enemiesEngine.units) do
			local thisEnemy = v.unit
			if dummyAllowed(thisEnemy)
				and br.functions.unit:GetUnitExists(thisEnemy)
				and not br.functions.unit:GetUnitIsDeadOrGhost(thisEnemy) then
				local distance = br.functions.range:getDistance(thisUnit, thisEnemy)
				if distance < radius and (not facing or br.functions.unit:getFacing("player", thisEnemy)) then
					-- Check if this enemy has threat on us or is targeting us
					if br.functions.combat:hasThreat(thisEnemy) or br.functions.misc:isTargeting(thisEnemy) then
						br._G.tinsert(enemiesTable, thisEnemy)
					end
				end
			end
		end
	end
	---
	if #enemiesTable > 0 and thisUnit ~= nil then
		if br.engines.enemiesEngine.storedTables[checkNoCombat] == nil then br.engines.enemiesEngine.storedTables[checkNoCombat] = {} end
		if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit] == nil then br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit] = {} end
		if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius] == nil then br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius] = {} end
		-- FIXED: Add timestamp to cached table so cache expiration check works properly
		enemiesTable._timestamp = br._G.GetTime()
		-- store player position at cache time to detect movement-based invalidation (flat fields, no sub-table alloc)
		enemiesTable._playerPosX = br.engines.enemiesEngine.playerPosX
		enemiesTable._playerPosY = br.engines.enemiesEngine.playerPosY
		enemiesTable._playerPosZ = br.engines.enemiesEngine.playerPosZ
		br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius][facing] = enemiesTable
		--print("Made Table Unit: "..UnitName(thisUnit).." Radius: "..radius.." CombatCheck: "..tostring(checkNoCombat))
	end
	-- Debugging
	br.debug.cpu:updateDebug(startTime, "enemiesEngine.getEnemies")
	return enemiesTable
end

-- function to see if our unit is a blacklisted unit
function enemiesEngineFunctions:isBlackListed(Unit)
	-- check if unit is valid
	if br.functions.unit:GetObjectExists(Unit) then
		for i = 1, #br.castersBlackList do
			-- check if unit is valid
			if br.functions.unit:GetObjectExists(br.castersBlackList[i].unit) then
				if br.castersBlackList[i].unit == Unit then
					return true
				end
			end
		end
	end
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
			if thisUnit.spell == nil or br.functions.cast:isCasting(thisUnit.spell, Unit) or br.functions.aura:UnitBuffID(thisUnit.buff) then -- doesnt have more requirements or requirements are met
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
					local unitTTD = br.engines.ttdTable:getTTD(unit) or 0
					-- Not Safe with Buff/Debuff
					if br.functions.aura:UnitBuffID(unit, noTouch.buff) or br.functions.aura:UnitDebuffID(unit, noTouch.buff)
						-- Bursting M+ Affix
						or (unitTTD <= br.functions.aura:getDebuffRemain("player", 240443) + (br.functions.spell:getGlobalCD(true) * 2)
							and br.functions.aura:getDebuffStacks("player", 240443) >= br.functions.misc:getOptionValue("Bursting Stack Limit"))
					then
						return false
					end
				else
					-- Not Safe without Buff/Debuff
					local posBuff = -(noTouch.buff)
					if not br.functions.aura:UnitBuffID(unit, posBuff) or not br.functions.aura:UnitDebuffID(unit, posBuff) then
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
				if select(6, br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())) == "TANK" and threat < 3 and unitHP > 10 then
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
			-- Outlaw - Blind Shot 10% dmg increase all sources
			if select(2, br._G.UnitClass('player')) == "ROGUE" and br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization()) == 260 then
				-- Between the eyes
				if br.functions.aura:getDebuffRemain(unit, 315341) > 0 then
					coef = coef + 75
				end
				-- Blood of the enemy
				if br.functions.aura:getDebuffRemain(unit, 297108) > 0 then
					coef = coef + 50
				end
				-- Marked for death
				if br.functions.aura:getDebuffRemain(unit, 137619) > 0 then
					coef = coef + 75
				end
				-- Prey on the weak
				if br.functions.aura:getDebuffRemain(unit, 131511) > 0 then
					coef = coef + 50
				end
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
				local stillValid = true
				if br.functions.misc:getOptionCheck("Safe Damage Check") and not enemiesEngineFunctions:isSafeToAttack(cached.unit) then
					stillValid = false
				end
				if stillValid then
					return cached.unit
				end
			end
		end
		bestUnitCache[cacheKey] = nil
	end

	local enemyList = enemiesEngineFunctions:getEnemies("player", range, false, facing)

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

	-- Limit processing to prevent long loops in very large pulls
	local maxProcess = math.min(#enemyList, 20)
	if #enemyList > maxProcess then
		local subset = {}
		for i = 1, maxProcess do
			subset[i] = enemyList[i]
		end
		enemyList = subset
	end

	tsort(enemyList, compare)

	local currHP
	for i = 1, #enemyList do
		local thisUnit = enemyList[i]
		local unitID = br.functions.unit:GetObjectExists(thisUnit) and br.functions.unit:GetObjectID(thisUnit) or 0

		if ((unitID == 135360 or unitID == 135358 or unitID == 135359) and br.functions.aura:UnitBuffID(thisUnit, 260805))
			or (unitID ~= 135360 and unitID ~= 135358 and unitID ~= 135359)
		then
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
	local targetValid = targetExists
		and not br.functions.unit:GetUnitIsDeadOrGhost("target")
		and targetInRange
		and targetFacingOK
		and br.functions.misc:isValidUnit("target")
	local notSafe = br.functions.misc:getOptionCheck("Safe Damage Check") and not enemiesEngineFunctions:isSafeToAttack("target") or false
	if targetValid and notSafe then
		targetValid = false
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
		local wantRetarget = autoTargetDynamic or (not br.functions.misc:isValidUnit(bestUnit)) or notSafe

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

local function angleDifference(unit1, unit2)
	local facing = br.functions.unit:GetObjectFacing(unit1)
	local distance = br.functions.range:getDistance(unit1, unit2)
	local unit1X, unit1Y, unit1Z = br.functions.unit:GetObjectPosition(unit1)
	local unit2X, unit2Y, _ = br.functions.unit:GetObjectPosition(unit2)
	local pX, pY, _ = br._G.GetPositionFromPosition(unit1X, unit1Y, unit1Z, distance, facing, 0)
	local vectorAX, vectorAY = unit1X - pX, unit1Y - pY
	local vectorBX, vectorBY = unit1X - unit2X, unit1Y - unit2Y
	local dotProduct = function(ax, ay, bx, by)
		return (ax * bx) + (ay * by)
	end
	local vectorProduct = dotProduct(vectorAX, vectorAY, vectorBX, vectorBX)
	---@diagnostic disable-next-line: deprecated
	local magnitudeA = math.pow(dotProduct(vectorAX, vectorAY, vectorAX, vectorAY), 0.5)
	---@diagnostic disable-next-line: deprecated
	local magnitudeB = math.pow(dotProduct(vectorBX, vectorBY, vectorBX, vectorBY), 0.5)
	local angle = math.acos((vectorProduct / magnitudeB) / magnitudeA)
	local finalAngle = (angle * 57.2958) % 360
	if (finalAngle - 180) >= 0 then return 360 - finalAngle else return finalAngle end
end
local function isWithinAngleDifference(unit1, unit2, angle)
	local angleDiff = angleDifference(unit1, unit2)
	return angleDiff <= angle
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
				-- if isWithinAngleDifference("player", thisUnit, angle) then
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
	if px == nil or py == nil or pz == nil then return {} end
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

-- -- local function intersects(circle, rect)
-- local function intersects(tX,tY,tR,aX,aY,cX,cY)
-- 	-- if circle ~= nil then
-- 	local circleDistance_x = math.abs(tX + tR - aX - (aX - cX)/2)
-- 	local circleDistance_y = math.abs(tY + tR - aY - (aY - cY)/2)

-- 	if (circleDistance_x > ((aX - cX)/2 + tR)) then
-- 		return false
-- 	end
-- 	if (circleDistance_y > ((aY - cY)/2 + tR)) then
-- 		return false
-- 	end

-- 	if (circleDistance_x <= ((aX - cX)/2)) then
-- 		return true
-- 	end

-- 	if (circleDistance_y <= ((aY - cY)/2)) then
-- 		return true
-- 	end

-- 	local cornerDistance_sq = (circleDistance_x - (aX - cX)/2)^2 + (circleDistance_y - (aY - cY)/2)^2

-- 	return (cornerDistance_sq <= (tR^2));
-- 	-- else
-- 	--     return false
-- 	-- end
-- end

-- Percentage of enemies that are not in execute HP range
function enemiesEngineFunctions:getNonExecuteEnemiesPercent(executeHP)
	local executeCount = 0
	local nonexecuteCount = 0
	local nonexecutePercent = 0

	for k, _ in pairs(br.engines.enemiesEngine.enemy) do
		local thisUnit = br.engines.enemiesEngine.enemy[k]
		if br.functions.unit:GetObjectExists(thisUnit.unit) then
			if br.functions.unit:getHP(thisUnit) < executeHP then
				executeCount = executeCount + 1
			else
				nonexecuteCount = nonexecuteCount + 1
			end
		end
	end
	local divisor = executeCount + nonexecuteCount
	if divisor > 0 then
		nonexecutePercent = nonexecuteCount / divisor
	end
	return nonexecutePercent
end

-- Tracks AoE Damage
function enemiesEngineFunctions:AoEDamageTracker()
	for i = 1, #br.lists.AoEDamage do
		if br.functions.DBM:getTimer(br.lists.AoEDamage[i]) ~= 999 then
			br.curAoESpell = br.lists.AoEDamage[i]
			if br.lastAoESpell == nil then
				br.lastAoESpell = br.curAoESpell
			end
			if br.curAoESpell == br.lastAoeSpell then
				if br.burstCount == nil then br.burstCount = 0 end
				br.burstCount = br.burstCount + 1
			else
				br.lastAoESpell = br.curAoESpell
				br.burstCount = 1
			end
			return br.functions.DBM:getTimer(br.lists.AoEDamage[i]), br.burstCount
		end
	end
	return -1
end
