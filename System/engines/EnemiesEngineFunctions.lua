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
local OM_UPDATE_INTERVAL = 0.5 -- Update every 0.5 seconds

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
	local exists = false
	for index, value in pairs(br.engines.enemiesEngine.om) do
		if type(value) == "table" and value.unit and value.unit == unit then
			exists = true
			break;
		end
	end
	return exists
end



--Update OM
function enemiesEngineFunctions:updateOM()
	-- wipe(br.engines.enemiesEngine.om)
	wipe(br.engines.tracker.tracking)
	local om = br.engines.enemiesEngine.om
	local startTime = br._G.debugprofilestop()
	local now = br._G.GetTime()
    if now - lastOMUpdate < OM_UPDATE_INTERVAL then
        return -- Skip update
    end
    lastOMUpdate = now

	local objUnit
	local name
	local objectid
	local objectguid
	local total = math.min(br._G.GetObjectCount(true, "BR") or 0, 500)
	for i = 1, total do
		local thisUnit = br._G.GetObjectWithIndex(i)
		-- br._G.print(thisUnit .. " - Is Unit: " .. tostring(br._G.ObjectIsUnit(thisUnit)) .. " - Name: " .. tostring(br._G.UnitName(thisUnit)))
		if br._G.ObjectExists(thisUnit) and br._G.ObjectIsUnit(thisUnit) and br._G.UnitIsVisible(thisUnit) then--and br.functions.misc:getLineOfSight("player", thisUnit) then
			if not br._G.UnitIsPlayer(thisUnit) and not br.functions.unit:isCritter(thisUnit) and not br._G.UnitIsUnit("player", thisUnit)
				and (not br._G.UnitIsFriend("player", thisUnit) or string.match(br._G.UnitGUID(thisUnit), "Pet"))
			then
				local enemyUnit = br.engines.enemiesEngine.unitSetup:new(thisUnit)
				if enemyUnit then
					br._G.tinsert(om, enemyUnit)
				end
			end
		end
		if br.functions.misc:isChecked("Enable Tracker") and thisUnit ~= nil and br._G.ObjectExists(thisUnit)
			and ((br._G.ObjectIsUnit(thisUnit) and br._G.UnitIsVisible(thisUnit) and not br.functions.unit:GetUnitIsDeadOrGhost(thisUnit)) or not br._G.ObjectIsUnit(thisUnit))
		then
			objUnit = br._G.ObjectIsUnit(thisUnit)
			name = objUnit and br._G.UnitName(thisUnit) or br._G.ObjectName(thisUnit)
			objectid = br._G.ObjectID(thisUnit)
			objectguid = br._G.UnitGUID(thisUnit)
			if thisUnit and name and objectid and objectguid then
				local trackerFound = false
				if #br.engines.tracker.tracking > 0 then
					for i = 1, #br.engines.tracker.tracking do
						local thisTracker = br.engines.tracker.tracking[i]
						if thisTracker.object == thisUnit then
							trackerFound = true
							return
						end
					end
				end
				if not trackerFound then
					br._G.tinsert(br.engines.tracker.tracking,
						{ object = thisUnit, unit = objUnit, name = name, id = objectid, guid = objectguid })
				end
			end
		end
	end

	refreshStored = true
	-- Debugging
	br.debug.cpu:updateDebug(startTime, "enemiesEngine.objects")

	-- local counter = 0
	-- local grappleCounter = 0
	-- for i = 1, br._G.GetObjectCount(), 1 do
	--    	local guid = br._G.GetObjectWithIndex(i)
	--    	if IsGuid(guid) and br._G.ObjectExists(guid) and br._G.ObjectIsUnit(guid) and not unitExistsInOM(guid) and enemiesEngine:omDist(guid) < 50
	--    		and not br._G.UnitIsUnit("player", guid) and not br._G.UnitIsFriend("player", guid) and not br._G.UnitIsPlayer(guid)
	-- 	then
	-- 		print(ObjectName(guid).." - "..guid)
	-- 		counter = counter + 1
	-- 		if ObjectName(guid) == "Grapple Point" then
	-- 			grappleCounter = grappleCounter + 1
	-- 		end
	--    	end
	-- end

	-- br._G.print("OM Count: "..counter..", BR OM Count: "..#br.engines.enemiesEngine.om..", Grapple Count: "..grappleCounter)
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
	if #br.engines.enemiesEngine.om == 0 then return false end
	for i = 1, #br.engines.enemiesEngine.om do
		local thisX, thisY, thisZ = br._G.ObjectPosition(thisUnit)
		local omX, omY, omZ = br._G.ObjectPosition(br.engines.enemiesEngine.om[i].guid)
		if --[[br.engines.enemiesEngine.om[i].guid == thisUnit and]] thisX == omX and thisY == omY and thisZ == omZ then return true end
	end
	return false
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
		if checkNoCombat == false then
			if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit] ~= nil then
				if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius] ~= nil then
					if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius][facing] ~= nil then
						local cachedTable = br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius][facing]
						-- Add timestamp check
						if cachedTable._timestamp and (br._G.GetTime() - cachedTable._timestamp) < 0.1 then
							return cachedTable
						end
					end
				end
			end
		end
	end

	for _, v in pairs(enemyTable) do
		thisEnemy = v.unit
		distance = br.functions.range:getDistance(thisUnit, thisEnemy)
		if distance < radius and (not facing or br.functions.unit:getFacing("player", thisEnemy)) then
			br._G.tinsert(enemiesTable, thisEnemy)
		end
	end
	if #enemiesTable == 0 and br.functions.range:getDistance("target", "player") < radius and br.functions.misc:isValidUnit("target") and (not facing or br.functions.unit:getFacing("player", "target")) then
		br._G.tinsert(enemiesTable, "target")
	end
	---
	if #enemiesTable > 0 and thisUnit ~= nil then
		if br.engines.enemiesEngine.storedTables[checkNoCombat] == nil then br.engines.enemiesEngine.storedTables[checkNoCombat] = {} end
		if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit] == nil then br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit] = {} end
		if br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius] == nil then br.engines.enemiesEngine.storedTables[checkNoCombat][thisUnit][radius] = {} end
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
local COEF_CACHE_TIME = 0.2
-- This function will set the prioritisation of the units, ie which target should i attack
local function getUnitCoeficient(unit)
	local startTime = br._G.debugprofilestop()
	local now = br._G.GetTime()
    local cached = coefficientCache[unit]
    if cached and (now - cached.time) < COEF_CACHE_TIME then
        return cached.value
    end

    local startTime = br._G.debugprofilestop()
    local coef = 0
	-- if distance == nil then distance = br.functions.range:getDistance("player",unit) end
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
			-- if its our actual target we give it a bonus
			if br.functions.unit:GetUnitIsUnit("target", unit) == true and not br.functions.unit:GetUnitIsDeadOrGhost(unit) then
				coef = coef + 50
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
	coefficientCache[unit] = { value = coef, time = now }
	-- Debugging
	br.debug.cpu:updateDebug(startTime, "enemiesEngine.unitCoef")
	return coef
end

local function compare(a, b)
	if br._G.UnitHealth(a) == br._G.UnitHealth(b) then
		return br.functions.range:getDistance(a) < br.functions.range:getDistance(b)
	else
		return br._G.UnitHealth(a) < br._G.UnitHealth(b)
	end
end

local bestUnitCache = {}
local BEST_UNIT_CACHE_TIME = 0.15
-- Finds the "best" unit for a given range and optional facing
local function findBestUnit(range, facing)
	local tsort = table.sort
	local startTime = br._G.debugprofilestop()
	local bestUnitCoef
	local bestUnit = nil
	local now = br._G.GetTime()
    local cacheKey = range .. "_" .. tostring(facing)
    local cached = bestUnitCache[cacheKey]

    if cached and (now - cached.time) < BEST_UNIT_CACHE_TIME then
        return cached.unit
    end
	local enemyList = enemiesEngineFunctions:getEnemies("player", range, false, facing)
	-- Limit processing to prevent long loops
    local maxProcess = math.min(#enemyList, 20)
    if #enemyList > maxProcess then
        -- Only sort subset for performance
        local subset = {}
        for i = 1, maxProcess do
            subset[i] = enemyList[i]
        end
        enemyList = subset
    end
	tsort(enemyList, compare)
	if bestUnit ~= nil and br.engines.enemiesEngine.enemy[bestUnit] == nil then bestUnit = nil end
	if bestUnit == nil
	--		or GetTime() > lastCheckTime
	then
		-- for k, v in pairs(enemyList) do
		if #enemyList > 0 then
			local currHP
			tsort(enemyList, compare)
			for i = 1, #enemyList do
				local thisUnit = enemyList[i]
				local unitID = br.functions.unit:GetObjectExists(thisUnit) and br.functions.unit:GetObjectID(thisUnit) or 0
				if ((unitID == 135360 or unitID == 135358 or unitID == 135359) and br.functions.aura:UnitBuffID(thisUnit, 260805)) or (unitID ~= 135360 and unitID ~= 135358 and unitID ~= 135359) then
					local isCC = br.functions.misc:getOptionCheck("Don't break CCs") and #enemyList > 1 and br.functions.misc:isLongTimeCCed(thisUnit) or
						false
					local isSafe = (br.functions.misc:getOptionCheck("Safe Damage Check") and enemiesEngineFunctions:isSafeToAttack(thisUnit)) or
						not br.functions.misc:getOptionCheck("Safe Damage Check") or false
					-- local thisUnit = v.unit
					-- local distance = br.functions.range:getDistance(thisUnit)
					-- if distance < range then
					if not isCC and isSafe then
						local coeficient = getUnitCoeficient(thisUnit) or 0
						if br.functions.misc:getOptionCheck("Wise Target") == true and br.functions.misc:getOptionValue("Wise Target") == 4 then -- abs Lowest
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
				--			lastCheckTime = GetTime() + 1
			end
		end
	end
	bestUnitCache[cacheKey] = { unit = bestUnit, time = now }
	-- Debugging
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
	if br.functions.misc:isChecked("Dynamic Targetting") then
		if br.functions.misc:getOptionValue("Dynamic Targetting") == 2 or (br._G.UnitAffectingCombat("player") and br.functions.misc:getOptionValue("Dynamic Targetting") == 1)
			and (bestUnit == nil or (br.functions.unit:GetUnitIsUnit(bestUnit, "target") and tarDist >= range))
		then
			bestUnit = findBestUnit(range, facing)
		end
	end
	if (not br.functions.misc:isChecked("Dynamic Targetting") or bestUnit == nil) and tarDist < range
		and (not facing or (facing and br.functions.unit:getFacing("player", "target"))) and br.functions.misc:isValidUnit("target")
	then
		bestUnit = "target"
	end
	bestDist = br.functions.range:getDistance(bestUnit) or 99
	if bestDist < range and not br.functions.unit:GetUnitIsUnit(bestUnit, "target") then
		if ((br.functions.unit:GetUnitIsDeadOrGhost("target") and not br.functions.unit:GetUnitIsFriend("target", "player")) or (not br.functions.unit:GetUnitExists("target") and br.functions.combat:hasThreat(bestUnit))
				or ((br.functions.misc:isChecked("Target Dynamic Target") and br.functions.unit:GetUnitExists("target"))))
			or (br.functions.misc:getOptionCheck("Forced Burn") and enemiesEngineFunctions:isBurnTarget(bestUnit) > 0 and br.functions.unit:GetUnitExists(bestUnit)
				and ((not facing and not br.functions.unit:isExplosive(bestUnit)) or (facing and br.functions.unit:getFacing("player", bestUnit))))
			or (br.functions.misc:getOptionCheck("Safe Damage Check") and not enemiesEngineFunctions:isSafeToAttack("target"))
		then
			if bestUnit ~= nil then
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
	for i = 1, math.min(#enemiesTable, 30) do
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
		for i = 1, #enemiesTable do
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
