local _, br = ...
local LibDraw = LibStub("LibDraw-BR")
br.enemy	= {}
br.lootable = {}
br.units 	= {}
br.objects  = {}
br.storedTables = {}
local refreshStored

--Check Totem
function br.isTotem(unit)
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
	for index, value in pairs(br.om) do
	   if type(value) == "table" and value.unit and value.unit == unit then
		  exists = true
		  break;
	   end
	end
	return exists
 end



--Update OM
function br:updateOM()
	local om = br.om
	local startTime = br._G.debugprofilestop()

	local total = br._G.GetObjectCount(true,"BR") or 0
	for i = 1,total do
		local thisUnit = br._G.GetObjectWithIndex(i)
		if br._G.IsGuid(thisUnit) and br._G.ObjectExists(thisUnit) and br._G.ObjectIsUnit(thisUnit) --[[and not unitExistsInOM(thisUnit) and br.omDist(thisUnit) < 50]] then
			if not br._G.UnitIsPlayer(thisUnit) and not br.isCritter(thisUnit) and not br._G.UnitIsUnit("player", thisUnit) and not br._G.UnitIsFriend("player", thisUnit) then
				local enemyUnit = br.unitSetup:new(thisUnit)
				if enemyUnit then--and not br.isInOM(enemyUnit) then
					br._G.tinsert(om, enemyUnit)
				end
			end
		end
	end

	refreshStored = true
	-- Debugging
    br.debug.cpu:updateDebug(startTime,"enemiesEngine.objects")

	-- local counter = 0
	-- local grappleCounter = 0
	-- for i = 1, br._G.GetObjectCount(), 1 do
	--    	local guid = br._G.GetObjectWithIndex(i)
	--    	if IsGuid(guid) and br._G.ObjectExists(guid) and br._G.ObjectIsUnit(guid) and not unitExistsInOM(guid) and br.omDist(guid) < 50
	--    		and not br._G.UnitIsUnit("player", guid) and not br._G.UnitIsFriend("player", guid) and not br._G.UnitIsPlayer(guid)
	-- 	then
	-- 		print(ObjectName(guid).." - "..guid)
	-- 		counter = counter + 1
	-- 		if ObjectName(guid) == "Grapple Point" then
	-- 			grappleCounter = grappleCounter + 1
	-- 		end
	--    	end
	-- end

	-- br._G.print("OM Count: "..counter..", BR OM Count: "..#br.om..", Grapple Count: "..grappleCounter)
end

function br.omDist(thisUnit)
	local x1, y1, z1 = br._G.ObjectPosition("player")
	local x2, y2, z2 = br._G.ObjectPosition(thisUnit)
	if x1 == nil  or x2 == nil or y1 == nil or y2 == nil or z1 == nil or z2 == nil then
		return 99
	else
		return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2)) -
		((br._G.UnitCombatReach("player") or 0) + (br._G.UnitCombatReach(thisUnit) or 0))
	end
end

function br.isInOM(thisUnit)
	if #br.om == 0 then return false end
	for i = 1, #br.om do
		local thisX, thisY, thisZ = br._G.ObjectPosition(thisUnit)
		local omX, omY, omZ = br._G.ObjectPosition(br.om[i].guid)
		if --[[br.om[i].guid == thisUnit and]] thisX == omX and thisY == omY and thisZ == omZ then return true end
	end
	return false
end

-- /dump br.getEnemies("target",10)
function br.getEnemies(thisUnit,radius,checkNoCombat,facing)
    local startTime = _G.debugprofilestop()
	radius = tonumber(radius)
	local enemyTable = checkNoCombat and br.units or br.enemy
	local enemiesTable = {}
	local thisEnemy, distance
	if checkNoCombat == nil then checkNoCombat = false end
	if facing == nil then facing = false end
    if refreshStored == true then
		for k,_ in pairs(br.storedTables) do br.storedTables[k] = nil end
		refreshStored = false
	end
	if br.storedTables[checkNoCombat] ~= nil then
		if checkNoCombat == false then
			if br.storedTables[checkNoCombat][thisUnit] ~= nil then
				if br.storedTables[checkNoCombat][thisUnit][radius] ~= nil then
					if br.storedTables[checkNoCombat][thisUnit][radius][facing] ~= nil then
						--print("Found Table Unit: "..UnitName(thisUnit).." Radius: "..radius.." CombatCheck: "..tostring(checkNoCombat))
						return br.storedTables[checkNoCombat][thisUnit][radius][facing]
					end
				end
			end
		end
	end

	for _, v in pairs(enemyTable) do
		thisEnemy = v.unit
		distance =  br.getDistance(thisUnit,thisEnemy)
		if distance < radius and (not facing or br.getFacing("player",thisEnemy)) then
			_G.tinsert(enemiesTable,thisEnemy)
		end
    end
	if #enemiesTable == 0 and br.getDistance("target","player") < radius and br.isValidUnit("target") and (not facing or br.getFacing("player","target")) then
		_G.tinsert(enemiesTable,"target")
	end
    ---
	if #enemiesTable > 0 and thisUnit ~= nil then
		if br.storedTables[checkNoCombat] == nil then br.storedTables[checkNoCombat] = {} end
		if br.storedTables[checkNoCombat][thisUnit] == nil then br.storedTables[checkNoCombat][thisUnit] = {} end
		if br.storedTables[checkNoCombat][radius] == nil then br.storedTables[checkNoCombat][thisUnit][radius] = {} end
		br.storedTables[checkNoCombat][thisUnit][radius][facing] = enemiesTable
		--print("Made Table Unit: "..UnitName(thisUnit).." Radius: "..radius.." CombatCheck: "..tostring(checkNoCombat))
	end
	-- Debugging
	br.debug.cpu:updateDebug(startTime,"enemiesEngine.getEnemies")
    return enemiesTable
end

-- function to see if our unit is a blacklisted unit
function br.isBlackListed(Unit)
	-- check if unit is valid
	if br.GetObjectExists(Unit) then
		for i = 1, #br.castersBlackList do
			-- check if unit is valid
			if br.GetObjectExists(br.castersBlackList[i].unit) then
				if br.castersBlackList[i].unit == Unit then
					return true
				end
			end
		end
	end
end

-- returns true if target should be burnt
function br.isBurnTarget(unit)
	local coef = 0
	-- check if unit is valid
	if br.getOptionCheck("Forced Burn") then
		local unitID = br.GetObjectID(unit)
		local burnUnit = br.lists.burnUnits[unitID]
		local unitTime = br.units[unit] ~= nil and br.units[unit].timestamp or _G.GetTime() - 1
		-- if unit have selected debuff
		if burnUnit and (burnUnit.cast == nil or not br.isCasting(burnUnit.cast,unitID)) and (_G.GetTime() - unitTime) > 0.25 then
			if burnUnit.buff and br.UnitBuffID(unit,burnUnit.buff) then
				coef = burnUnit.coef
			end
			if not burnUnit.buff and (br._G.UnitName(unit) == burnUnit.name or burnUnit or burnUnit.id == unitID) then
				--if not UnitIsUnit("target",unit) then TargetUnit(unit) end
				coef = burnUnit.coef
			end
		end
	end
	return coef
end

-- check for a unit see if its a cc candidate
function br.isCrowdControlCandidates(Unit)
	local unitID
	-- check if unit is valid
	if br.GetObjectExists(Unit) then
		unitID = br.GetObjectID(Unit)
	else
		return false
	end
	-- cycle list of candidates
	local crowdControlUnit = br.lists.ccUnits[unitID]
	if crowdControlUnit then
		for i = 1, #crowdControlUnit do
			local thisUnit = crowdControlUnit[i]
			-- is in the list of candidates
			if thisUnit.spell == nill or br.isCasting(thisUnit.spell,Unit) or br.UnitBuffID(thisUnit.buff) then -- doesnt have more requirements or requirements are met
				return true
			end
		end
	end
	return false
end

-- returns true if we can safely attack this target
function br.isSafeToAttack(unit)
	if br.getOptionCheck("Safe Damage Check") == true then
		local startTime = _G.debugprofilestop()
		-- check if unit is valid
		local unitID = br.GetObjectExists(unit) and br.GetObjectID(unit) or 0
		for i = 1, #br.lists.noTouchUnits do
			local noTouch = br.lists.noTouchUnits[i]
			if noTouch.unitID == 1 or noTouch.unitID == unitID then
				if noTouch.buff == nil then return false end --If a unit exist in the list without a buff it's just blacklisted
				if noTouch.buff > 0 then
					local unitTTD = br.getTTD(unit) or 0
					-- Not Safe with Buff/Debuff
					if br.UnitBuffID(unit,noTouch.buff) or br.UnitDebuffID(unit,noTouch.buff)
						-- Bursting M+ Affix
						or (unitTTD <= br.getDebuffRemain("player",240443) + (br.getGlobalCD(true) * 2)
							and br.getDebuffStacks("player", 240443) >= br.getOptionValue("Bursting Stack Limit"))
					then
						return false
					end
				else
					-- Not Safe without Buff/Debuff
					local posBuff = -(noTouch.buff)
					if not br.UnitBuffID(unit,posBuff) or not br.UnitDebuffID(unit,posBuff) then
						return false
					end
				end
			end
		end
		-- Debugging
		br.debug.cpu:updateDebug(startTime,"enemiesEngine.isSafeToAttack")
	end
	-- if all went fine return true
	return true
end

-- returns true if target is shielded or should be avoided
local function isShieldedTarget(unit)
	local coef = 0
	if br.getOptionCheck("Avoid Shields") then
		-- check if unit is valid
		local unitID = br.GetObjectID(unit)
		local shieldedUnit = br.lists.shieldUnits[unitID]
		-- if unit have selected debuff
		if shieldedUnit and shieldedUnit.buff and br.UnitBuffID(unit,shieldedUnit.buff) then
			-- if it's a frontal buff, see if we are in front of it
			if shieldedUnit.frontal ~= true or br.getFacing(unit,"player") then
				coef = shieldedUnit.coef
			end
		end
	end
	return coef
end

-- This function will set the prioritisation of the units, ie which target should i attack
local function getUnitCoeficient(unit)
	local startTime = _G.debugprofilestop()
	local coef = 0
	-- if distance == nil then distance = br.getDistance("player",unit) end
	local distance = br.getDistance("player",unit)
	-- check if unit is valid
	if br.GetObjectExists(unit) then
		-- if unit is out of range, bad prio(0)
		if distance < 50 then
			local unitHP = br.getHP(unit)
			-- if wise target checked, we look for best target by looking to the lowest or highest hp, otherwise we look for target
			if br.getOptionCheck("Wise Target") == true then
				if br.getOptionValue("Wise Target") == 1 then 	   -- Highest
					-- if highest is selected
					coef = unitHP
				elseif br.getOptionValue("Wise Target") == 3 then -- abs Highest
					coef = br._G.UnitHealth(unit)
				elseif br.getOptionValue("Wise Target") == 5 then -- Nearest
					coef = 100 - distance
				elseif br.getOptionValue("Wise Target") == 6 then -- Furthest
					coef = distance
				else 										   -- Lowest
					-- if lowest is selected
					coef = 100 - unitHP
				end
			end
			-- Distance Coef add for multiple burn units (Will prioritize closest first)
			coef = coef + ((50 - distance)/100)
			-- if its our actual target we give it a bonus
			if br.GetUnitIsUnit("target",unit) == true and not br.GetUnitIsDeadOrGhost(unit) then
				coef = coef + 50
			end
			-- raid target management
			-- if the unit have the skull and we have param for it add 50
			if br.getOptionCheck("Skull First") and br._G.GetRaidTargetIndex(unit) == 8 then
				coef = coef + 50
			end
			-- if threat is checked, add 100 points of prio if we lost aggro on that target
			if br.getOptionCheck("Tank Threat") then
				local threat = br._G.UnitThreatSituation("player",unit) or -1
				if select(6, _G.GetSpecializationInfo(_G.GetSpecialization())) == "TANK" and threat < 3 and unitHP > 10 then
					coef = coef + 100 - threat
				end
			end
			if br.isChecked("Prioritize Totems") and br.isTotem(unit) then
				coef = coef + 100
			end
			-- if user checked burn target then we add the value otherwise will be 0
			if br.getOptionCheck("Forced Burn") then
				coef = coef + br.isBurnTarget(unit) + ((50 - distance)/100)
			end
			-- if user checked avoid shielded, we add the % this shield remove to coef
			if br.getOptionCheck("Avoid Shields") then
				coef = coef + isShieldedTarget(unit)
			end
			-- Outlaw - Blind Shot 10% dmg increase all sources
			if select(2,br._G.UnitClass('player')) == "ROGUE" and _G.GetSpecializationInfo(_G.GetSpecialization()) == 260 then
				-- Between the eyes
				if br.getDebuffRemain(unit, 315341) > 0 then
					coef = coef + 75
				end
				-- Blood of the enemy
				if br.getDebuffRemain(unit, 297108) > 0 then
					coef = coef + 50
				end
				-- Marked for death
				if br.getDebuffRemain(unit, 137619) > 0 then
					coef = coef + 75
				end
				-- Prey on the weak
				if br.getDebuffRemain(unit, 131511) > 0 then
					coef = coef + 50
				end
			end
			-- local displayCoef = math.floor(coef*10)/10
			-- local displayName = UnitName(unit) or "invalid"
			-- Print("Unit "..displayName.." - "..displayCoef)
		end
	end
	-- Debugging
	br.debug.cpu:updateDebug(startTime,"enemiesEngine.unitCoef")
	return coef
end

local function compare(a,b)
	if br._G.UnitHealth(a) == br._G.UnitHealth(b) then
		return br.getDistance(a) < br.getDistance(b)
	else
		return  br._G.UnitHealth(a) < br._G.UnitHealth(b)
	end
end

-- Finds the "best" unit for a given range and optional facing
local function findBestUnit(range,facing)
	local tsort = table.sort
	local startTime = _G.debugprofilestop()
	local bestUnitCoef
	local bestUnit = nil
	local enemyList = br.getEnemies("player",range,false,facing)
	if bestUnit ~= nil and br.enemy[bestUnit] == nil then bestUnit = nil end
	if bestUnit == nil
--		or GetTime() > lastCheckTime
		then
		-- for k, v in pairs(enemyList) do
		if #enemyList > 0 then
			local currHP
			tsort(enemyList,compare)
			for i = 1, #enemyList do
				local thisUnit = enemyList[i]
				local unitID = br.GetObjectExists(thisUnit) and br.GetObjectID(thisUnit) or 0
				if ((unitID == 135360 or unitID == 135358 or unitID == 135359) and br.UnitBuffID(thisUnit,260805)) or (unitID ~= 135360 and unitID ~= 135358 and unitID ~= 135359) then
					local isCC = br.getOptionCheck("Don't break CCs") and #enemyList > 1 and br.isLongTimeCCed(thisUnit) or false
					local isSafe = (br.getOptionCheck("Safe Damage Check") and br.isSafeToAttack(thisUnit)) or not br.getOptionCheck("Safe Damage Check") or false
					-- local thisUnit = v.unit
					-- local distance = br.getDistance(thisUnit)
					-- if distance < range then
					if not isCC and isSafe then
						local coeficient = getUnitCoeficient(thisUnit) or 0
						if br.getOptionCheck("Wise Target") == true and br.getOptionValue("Wise Target") == 4 then -- abs Lowest
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
	-- Debugging
	br.debug.cpu:updateDebug(startTime,"enemiesEngine.findBestUnit")
	return bestUnit
end

-- Sets Target by attempting to find the best unit else defaults to target
function br.dynamicTarget(range,facing)
	if range == nil or range > 100 then return nil end
	local startTime = _G.debugprofilestop()
	facing = facing or false
	local bestUnit = nil
	local tarDist = br.GetObjectExists("target") and br.getDistance("target") or 99
	local bestDist
	if br.isChecked("Dynamic Targetting") then
		if br.getOptionValue("Dynamic Targetting") == 2 or (br._G.UnitAffectingCombat("player") and br.getOptionValue("Dynamic Targetting") == 1)
			and (bestUnit == nil or (br.GetUnitIsUnit(bestUnit,"target") and tarDist >= range))
		then
			bestUnit = findBestUnit(range,facing)
		end
	end
	if (not br.isChecked("Dynamic Targetting") or bestUnit == nil) and tarDist < range
		and (not facing or (facing and br.getFacing("player","target"))) and br.isValidUnit("target")
	then
		bestUnit = "target"
	end
	bestDist = br.getDistance(bestUnit) or 99
	if bestDist < range then
		if ((br.GetUnitIsDeadOrGhost("target") and not br.GetUnitIsFriend("target","player")) or (not br._G.UnitExists("target") and br.hasThreat(bestUnit))
			or ((br.isChecked("Target Dynamic Target") and br.GetUnitExists("target")) and not br.GetUnitIsUnit(bestUnit,"target")))
			or (br.getOptionCheck("Forced Burn") and br.isBurnTarget(bestUnit) > 0 and br.GetUnitExists(bestUnit)
				and ((not facing and not br.isExplosive(bestUnit)) or (facing and br.getFacing("player",bestUnit))))
			or (br.getOptionCheck("Safe Damage Check") and not br.GetUnitIsUnit(bestUnit,"target") and not br.isSafeToAttack("target"))
		then
			br._G.TargetUnit(bestUnit)
		end
	end
	-- Debugging
	br.debug.cpu:updateDebug(startTime,"enemiesEngine.dynamicTarget")
	return bestUnit
end

local function angleDifference(unit1, unit2)
	local facing = br.GetObjectFacing(unit1)
	local distance = br.getDistance(unit1, unit2)
	local unit1X, unit1Y, unit1Z = br.GetObjectPosition(unit1)
	local unit2X, unit2Y, unit2Z = br.GetObjectPosition(unit2)
	local pX, pY, pZ = br._G.GetPositionFromPosition(unit1X, unit1Y, unit1Z, distance, facing, 0)
	local vectorAX, vectorAY = unit1X - pX, unit1Y - pY
	local vectorBX, vectorBY = unit1X - unit2X, unit1Y - unit2Y
	local dotProduct = function(ax, ay, bx, by)
		return (ax * bx) + (ay * by)
	end
	local vectorProduct = dotProduct(vectorAX, vectorAY, vectorBX, vectorBX)
	local magnitudeA = math.pow(dotProduct(vectorAX, vectorAY, vectorAX, vectorAY), 0.5)
	local magnitudeB = math.pow(dotProduct(vectorBX, vectorBY, vectorBX, vectorBY), 0.5)
	local angle = math.acos((vectorProduct / magnitudeB) / magnitudeA)
	local finalAngle = (angle * 57.2958) % 360
	if (finalAngle - 180) >= 0 then return 360 - finalAngle else return finalAngle end
end
local function isWithinAngleDifference(unit1, unit2, angle)
	local angleDiff = angleDifference(unit1,unit2)
	return angleDiff <= angle
end

-- Cone Logic for Enemies
local coneUnits = {}
function br.getEnemiesInCone(angle,length,checkNoCombat, showLines)
	if angle == nil then angle = 180 end
	if length == nil then length = 0 end
    local playerX, playerY, playerZ = br.GetObjectPosition("player")
    local facing = br.GetObjectFacing("player")
	local unitsCounter = 0
	local enemiesTable = br.getEnemies("player",length,checkNoCombat,true)
	local inside = false
---@diagnostic disable-next-line: undefined-field
	if showLines then LibDraw.Arc(playerX, playerY, playerZ, length, angle, 0) end
	table.wipe(coneUnits)
    for i = 1, #enemiesTable do
		local thisUnit = enemiesTable[i]
		local radius = br._G.UnitCombatReach(thisUnit)
        local unitX, unitY, unitZ = br._G.GetPositionBetweenObjects(thisUnit, "player", radius)
		if playerX and unitX and playerY and unitY then
			for j = radius, 0, -0.1 do
				inside = false
				if j > 0 then
					unitX, unitY = br._G.GetPositionBetweenObjects(thisUnit, "player", j)
				else
					unitX, unitY = br.GetObjectPosition(thisUnit)
				end
				local angleToUnit = br.getAngles(playerX,playerY,playerZ,unitX,unitY,unitZ)
				local angleDifference = facing > angleToUnit and facing - angleToUnit or angleToUnit - facing
				local shortestAngle = angleDifference < math.pi and angleDifference or math.pi*2 - angleDifference
				local finalAngle = shortestAngle/math.pi*180
				if finalAngle < angle/2 then
					inside = true
					break
				end
			end
            if inside then
			-- if isWithinAngleDifference("player", thisUnit, angle) then
				if showLines then
---@diagnostic disable-next-line: undefined-field
					LibDraw.Circle(unitX, unitY, playerZ, br._G.UnitBoundingRadius(thisUnit))
				end
                unitsCounter = unitsCounter + 1
				table.insert(coneUnits,thisUnit)
            end
        end
	end

	-- br.ChatOverlay(units)
    return unitsCounter, coneUnits
end

-- Rectangle Logic for Enemies
local rectUnits = {}
function br.getEnemiesInRect(width,length,showLines,checkNoCombat)
	local px, py, pz = br.GetObjectPosition("player")
	local function getRect(width,length)
		local facing = br.GetObjectFacing("player") or 0
		local halfWidth = width/2
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
	local nlX, nlY, nrX, nrY, frX, frY = getRect(width,length)
	local enemyCounter = 0
	local enemiesTable = br.getEnemies("player",length,checkNoCombat,true)
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
						pX, pY = br.GetObjectPosition(thisUnit)
					end
					if br.isInside(pX,pY,nlX,nlY,nrX,nrY,frX,frY) then inside = true break end
				end
				if inside then
					if showLines then
---@diagnostic disable-next-line: undefined-field
						LibDraw.Circle(tX, tY, pz, br._G.UnitBoundingRadius(thisUnit))
					end
					enemyCounter = enemyCounter + 1
					table.insert(rectUnits,thisUnit)
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
function br.getNonExecuteEnemiesPercent(executeHP)
    local executeCount = 0
    local nonexecuteCount = 0
    local nonexecutePercent = 0

	for k, _ in pairs(br.enemy) do
		local thisUnit = br.enemy[k]
        if br.GetObjectExists(thisUnit.unit) then
            if br.getHP(thisUnit) < executeHP then
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
function br.AoEDamageTracker()
	for i = 1, #br.lists.AoEDamage do
		if br.DBM:getTimer(br.lists.AoEDamage[i]) ~= 999 then
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
			return br.DBM:getTimer(br.lists.AoEDamage[i]), br.burstCount
		end
	end
	return -1
end
