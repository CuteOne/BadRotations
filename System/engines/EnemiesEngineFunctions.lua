br.enemy	= {}
br.lootable = {}
br.units 	= {}
br.storedTables = {}
local refreshStored

local function AddUnit(thisUnit,thisTable)
	local unit = {
		unit = thisUnit,
		name = UnitName(thisUnit),
		guid = UnitGUID(thisUnit),
		id = GetObjectID(thisUnit),
	}
	rawset(thisTable, thisUnit, unit)
end

-- Update Pet
local function UpdatePet(thisUnit)
	if br.player.spell.buffs.demonicEmpowerment ~= nil then
		demoEmpBuff = UnitBuffID(thisUnit,br.player.spell.buffs.demonicEmpowerment) ~= nil
	else
		demoEmpBuff = false
	end
	local unitCount = #getEnemies(thisUnit,10) or 0
	local pet 		= br.player.pet.list[thisUnit]
	pet.deBuff = demoEmpBuff
	pet.numEnemies = unitCount
end

-- Check Critter
local function IsCritter(checkID)
	local numPets = C_PetJournal.GetNumPets(false)
	for i=1,numPets do
		local _, _, _, _, _, _, _, name, _, _, petID = C_PetJournal.GetPetInfoByIndex(i, false)
		if checkID == petID then return true end
	end
	return false
end

--Check Totem
function isTotem(unit)
	local creatureType = UnitCreatureType(unit)
	if creatureType ~= nil then
	  if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then return true end
	end
	return false
end

--Update OM
function updateOMEWT()
	local om = br.om
	local startTime = debugprofilestop()
	local _, updated, added, removed = GetObjectCount(true)
	if updated and #added > 0 then
		for _, v in pairs(added) do
			if ObjectIsUnit(v) then
				local enemyUnit = br.unitSetup:new(v)
				if enemyUnit then
					tinsert(om, enemyUnit)
				end
			end
		end
	end
    refreshStored = true
    -- Debugging
	if isChecked("Debug Timers") then
		br.debug.cpu.enemiesEngine.objects.currentTime = debugprofilestop()-startTime
		br.debug.cpu.enemiesEngine.objects.totalIterations = br.debug.cpu.enemiesEngine.objects.totalIterations + 1
		br.debug.cpu.enemiesEngine.objects.elapsedTime = br.debug.cpu.enemiesEngine.objects.elapsedTime + debugprofilestop()-startTime
		br.debug.cpu.enemiesEngine.objects.averageTime = br.debug.cpu.enemiesEngine.objects.elapsedTime / br.debug.cpu.enemiesEngine.objects.totalIterations
    end
end

--Legacy OM
function updateOM()
	local startTime = debugprofilestop()
	local omCounter = 0
	local fmod = math.fmod
	local loopSet = floor(GetFramerate()) or 0
	-- if isChecked("Disable Object Manager") and (inCombat or not isChecked("Auto Loot")) then
	-- 	if next(br.om) ~= nil then br.om = {} end
	-- 	return
	-- end
	if isChecked("Debug Timers") then
		br.debug.cpu.enemiesEngine.objects.targets = 0
	end
	-- Cycle OM
	local objectCount = EWT ~= nil and GetObjectCount() or 0
	if objectCount > 0 then
		if objectIndex == nil or objectIndex >= objectCount then objectIndex = 1 end
		for i = objectIndex, objectCount do
			objectIndex = objectIndex + 1
			omCounter = omCounter + 1
			if omCounter == 1 then cycleTime = debugprofilestop() end
				-- define our unit
				local thisUnit = GetObjectWithIndex(i)
				if ObjectIsUnit(thisUnit) and ObjectIsVisible(thisUnit) and (UnitReaction("player", thisUnit) <= 4
					or UnitCreator(thisUnit) == "player") and not isCritter(thisUnit) and getDistance(thisUnit) <= 50 and getLineOfSight(thisUnit)
				then
					br.debug.cpu.enemiesEngine.objects.targets = br.debug.cpu.enemiesEngine.objects.targets + 1
					local enemyUnit = br.unitSetup:new(thisUnit)
					if enemyUnit then
						tinsert(br.om, enemyUnit)
					end
				end
			if isChecked("Debug Timers") then
				br.debug.cpu.enemiesEngine.objects.cycleTime = debugprofilestop()-cycleTime
			end
			-- objectIndex = objectIndex + 1
			if fmod(objectIndex,loopSet) == 0 then objectIndex = objectIndex + 1; break end
		end
	end
	refreshStored = true
	-- Debugging
	if isChecked("Debug Timers") then
		br.debug.cpu.enemiesEngine.objects.currentTime = debugprofilestop()-startTime
		br.debug.cpu.enemiesEngine.objects.totalIterations = br.debug.cpu.enemiesEngine.objects.totalIterations + 1
		br.debug.cpu.enemiesEngine.objects.elapsedTime = br.debug.cpu.enemiesEngine.objects.elapsedTime + debugprofilestop()-startTime
		br.debug.cpu.enemiesEngine.objects.averageTime = br.debug.cpu.enemiesEngine.objects.elapsedTime / br.debug.cpu.enemiesEngine.objects.totalIterations
	end
end

-- /dump getEnemies("target",10)
function getEnemies(thisUnit,radius,checkNoCombat,facing)
    local startTime = debugprofilestop()
	local radius = tonumber(radius)
	local targetDist = getDistance("target","player")
	local enemyTable = checkNoCombat and br.units or br.enemy
	local enemiesTable = {}
	local thisEnemy, distance
	if checkNoCombat == nil then checkNoCombat = false end
	if facing == nil then facing = false end
    if refreshStored == true then
    	for k,v in pairs(br.storedTables) do br.storedTables[k] = nil end
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
		-- if br.storedTables[checkNoCombat][thisUnit] ~= nil then
		-- 	local lowestTable
		-- 	for k,v in pairs(br.storedTables[checkNoCombat][thisUnit]) do
		-- 		if k > radius then
		-- 			if (lowestTable ~= nil and k < lowestTable) or lowestTable == nil then
		-- 				lowestTable = k
		-- 			end
		-- 		end
		-- 	end
		-- 	if lowestTable ~= nil then
		-- 		--print("Table found at "..lowestTable.." radius.  Using as enemyTable for "..radius.." radius.")
		-- 		enemyTable = br.storedTables[checkNoCombat][thisUnit][lowestTable]
		-- 	end
		-- end
	end

	for k, v in pairs(enemyTable) do
		thisEnemy = v.unit
		distance =  getDistance(thisUnit,thisEnemy)
		if distance < radius and (not facing or getFacing("player",thisEnemy)) then
			tinsert(enemiesTable,thisEnemy)
		end
    end
	-- for _, enemy in pairs(enemyTable) do
    --     distance =  getDistance(thisUnit, enemy.unit)
    --     if enemiesTable[enemy.unit] == nil and distance < radius then
    --         rawset(enemiesTable, enemy.unit, enemy.unit)
    --     end
    -- end
	if #enemiesTable == 0 and targetDist < radius and isValidUnit("target") and (not facing or getFacing("player","target")) then
		tinsert(enemiesTable,"target")
	end
    ---
	if isChecked("Debug Timers") then
    	br.debug.cpu.enemiesEngine.getEnemies = debugprofilestop()-startTime or 0
	end
    ---
	if #enemiesTable > 0 and thisUnit ~= nil then
		if br.storedTables[checkNoCombat] == nil then br.storedTables[checkNoCombat] = {} end
		if br.storedTables[checkNoCombat][thisUnit] == nil then br.storedTables[checkNoCombat][thisUnit] = {} end
		if br.storedTables[checkNoCombat][radius] == nil then br.storedTables[checkNoCombat][thisUnit][radius] = {} end
		br.storedTables[checkNoCombat][thisUnit][radius][facing] = enemiesTable
		--print("Made Table Unit: "..UnitName(thisUnit).." Radius: "..radius.." CombatCheck: "..tostring(checkNoCombat))
	end
    return enemiesTable
end

-- function to see if our unit is a blacklisted unit
	function isBlackListed(Unit)
		-- check if unit is valid
		if GetObjectExists(Unit) then
			for i = 1, #castersBlackList do
				-- check if unit is valid
				if GetObjectExists(castersBlackList[i].unit) then
					if castersBlackList[i].unit == Unit then
						return true
					end
				end
			end
		end
	end
	-- returns true if target should be burnt
	function isBurnTarget(unit)
		local coef = 0
		-- check if unit is valid
		if getOptionCheck("Forced Burn") then
			local unitID = GetObjectID(unit)
			local burnUnit = br.lists.burnUnits[unitID]
			-- if unit have selected debuff
			if burnUnit and (burnUnit.cast == nil or not isCasting(burnUnit.cast,unitID)) then
				if burnUnit.buff and UnitBuffID(unit,burnUnit.buff) then
					coef = burnUnit.coef
				end
				if not burnUnit.buff and (UnitName(unit) == burnUnit.name or burnUnit or burnUnit.id == unitID) then
					--if not UnitIsUnit("target",unit) then TargetUnit(unit) end
					coef = burnUnit.coef
				end
			end
		end
		return coef
	end
	-- check for a unit see if its a cc candidate
	function isCrowdControlCandidates(Unit)
		-- check if unit is valid
		if GetObjectExists(Unit) then
			local unitID = GetObjectID(Unit)
		end
		-- cycle list of candidates
		local crowdControlUnit = br.lists.ccUnits[unitID]
		if crowdControlUnit then
			-- check if unit is valid
			if GetObjectExists(crowdControlUnit.unit) then
				-- is in the list of candidates
				if (crowdControlUnit.buff == nil or UnitBuffID(Unit,crowdControlUnit.buff))
						and (crowdControlUnit.spell == nil or getCastingInfo(Unit) == GetSpellInfo(crowdControlUnit.spell))
				then -- doesnt have more requirements or requirements are met
					return true
				end
			end
		end
		return false
	end

	-- returns true if we can safely attack this target
	function isSafeToAttack(unit)
		if getOptionCheck("Safe Damage Check") == true then
			-- check if unit is valid
			local unitID = GetObjectExists(unit) and GetObjectID(unit) or 0
			for i = 1, #br.lists.noTouchUnits do
				local noTouch = br.lists.noTouchUnits[i]
				if noTouch.unitID == 1 or noTouch.unitID == unitID then
					if noTouch.buff == nil then return false end --If a unit exist in the list without a buff it's just blacklisted
					if noTouch.buff > 0 then
						-- Not Safe with Buff/Debuff
						if UnitBuffID(unit,noTouch.buff) or UnitDebuffID(unit,noTouch.buff)
							-- Bursting M+ Affix
							or (getTTD(unit) <= getDebuffRemain("player",240443) + (getGlobalCD(max) * 2) 
								and getDebuffStack("player", 240443) >= getOptionValue("Bursting Stack Limit")
						then
							return false
						end
					else
						-- Not Safe without Buff/Debuff
						local posBuff = -(noTouch.buff)
						if not UnitBuffID(unit,posBuff) or not UnitDebuffID(unit,posBuff) then
							return false
						end
					end
				end
			end
		end
		-- if all went fine return true
		return true
	end

	-- returns true if target is shielded or should be avoided
	local function isShieldedTarget(unit)
		local coef = 0
		if getOptionCheck("Avoid Shields") then
			-- check if unit is valid
			local unitID = GetObjectID(unit)
			local shieldedUnit = br.lists.shieldUnits[unitID]
			-- if unit have selected debuff
			if shieldedUnit and shieldedUnit.buff and UnitBuffID(unit,shieldedUnit.buff) then
				-- if it's a frontal buff, see if we are in front of it
				if shieldedUnit.frontal ~= true or getFacing(unit,"player") then
					coef = shieldedUnit.coef
				end
			end
		end
		return coef
	end

-- This function will set the prioritisation of the units, ie which target should i attack
	local function getUnitCoeficient(unit)
		local coef = 0
		-- if distance == nil then distance = getDistance("player",unit) end
		local distance = getDistance("player",unit)
		-- check if unit is valid
		if GetObjectExists(unit) then
			-- if unit is out of range, bad prio(0)
			if distance < 50 then
				local unitHP = getHP(unit)
				-- if wise target checked, we look for best target by looking to the lowest or highest hp, otherwise we look for target
				if getOptionCheck("Wise Target") == true then
					if getOptionValue("Wise Target") == 1 then 	   -- Highest
						-- if highest is selected
						coef = unitHP
					elseif getOptionValue("Wise Target") == 3 then -- abs Highest
						coef = UnitHealth(unit)
					elseif getOptionValue("Wise Target") == 5 then -- Nearest
						coef = 100 - distance
					elseif getOptionValue("Wise Target") == 6 then -- Furthest
						coef = distance
					else 										   -- Lowest
						-- if lowest is selected
						coef = 100 - unitHP
					end
				end
				-- Distance Coef add for multiple burn units (Will prioritize closest first)
				coef = coef + ((50 - distance)/100)
				-- if its our actual target we give it a bonus
				if GetUnitIsUnit("target",unit) == true and not UnitIsDeadOrGhost(unit) then
					coef = coef + 50
				end
				-- raid target management
				-- if the unit have the skull and we have param for it add 50
				if getOptionCheck("Skull First") and GetRaidTargetIndex(unit) == 8 then
					coef = coef + 50
				end
				-- if threat is checked, add 100 points of prio if we lost aggro on that target
				if getOptionCheck("Tank Threat") then
					local threat = UnitThreatSituation("player",unit) or -1
					if select(6, GetSpecializationInfo(GetSpecialization())) == "TANK" and threat < 3 and unitHP > 10 then
						coef = coef + 100 - threat
					end
				end
				if isChecked("Prioritize Totems") and isTotem(unit) then
					coef = coef + 100
				end
				-- if user checked burn target then we add the value otherwise will be 0
				if getOptionCheck("Forced Burn") then
					coef = coef + isBurnTarget(unit) + ((50 - distance)/100)
				end
				-- if user checked avoid shielded, we add the % this shield remove to coef
				if getOptionCheck("Avoid Shields") then
					coef = coef + isShieldedTarget(unit)
				end
				local displayCoef = math.floor(coef*10)/10
				local displayName = UnitName(unit) or "invalid"
				-- Print("Unit "..displayName.." - "..displayCoef)
			end
		end
		return coef
	end

local function compare(a,b)
	if UnitHealth(a) == UnitHealth(b) then
		return getDistance(a) < getDistance(b)
	else
		return  UnitHealth(a) < UnitHealth(b)
	end
end

local function findBestUnit(range,facing)
	local tsort = table.sort
	local startTime = debugprofilestop()
	local bestUnitCoef
	local bestUnit = bestUnit or nil
	local enemyList = getEnemies("player",range,false,facing)
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
				local unitID = GetObjectExists(thisUnit) and GetObjectID(thisUnit) or 0
				if ((unitID == 135360 or unitID == 135358 or unitID == 135359) and UnitBuffID(thisUnit,260805)) or (unitID ~= 135360 and unitID ~= 135358 and unitID ~= 135359) then
					local isCC = getOptionCheck("Don't break CCs") and isLongTimeCCed(thisUnit) or false
					-- local thisUnit = v.unit
					-- local distance = getDistance(thisUnit)
					-- if distance < range then
					if not isCC then
						local coeficient = getUnitCoeficient(thisUnit) or 0
						if getOptionCheck("Wise Target") == true and getOptionValue("Wise Target") == 4 then -- abs Lowest
							if currHP == nil or UnitHealth(thisUnit) < currHP then
								currHP = UnitHealth(thisUnit)
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
	if isChecked("Debug Timers") then
		br.debug.cpu.enemiesEngine.bestUnitFinder = debugprofilestop()-startTime or 0
	end
	return bestUnit
end

function dynamicTarget(range,facing)
	if range == nil or range > 100 then return nil end
	local startTime = debugprofilestop()
	local facing = facing or false
	local bestUnit = bestUnit or nil
	local tarDist = getDistance("target") or 99
	if isChecked("Dynamic Targetting") then
		if getOptionValue("Dynamic Targetting") == 2 or (UnitAffectingCombat("player") and getOptionValue("Dynamic Targetting") == 1)
			and (bestUnit == nil or (UnitIsUnit(bestUnit,"target") and tarDist >= range))
		then
			bestUnit = findBestUnit(range,facing)
		end
	end
	if (not isChecked("Dynamic Targetting") or bestUnit == nil) and tarDist < range
		and (not facing or (facing and getFacing("player","target"))) and isValidUnit("target")
	then
		bestUnit = "target"
	end
	if ((UnitIsDeadOrGhost("target") and not GetUnitIsFriend("target","player")) or (not UnitExists("target") and hasThreat(bestUnit))
		or ((isChecked("Target Dynamic Target") and UnitExists("target")) and not GetUnitIsUnit(bestUnit,"target")))
		or (getOptionCheck("Forced Burn") and isBurnTarget(bestUnit) > 0 and getDistance(bestUnit) < range
			and ((not facing and not isExplosive(bestUnit)) or (facing and getFacing("player",bestUnit))))
	then
		TargetUnit(bestUnit)
	end
	if isChecked("Debug Timers") then
		br.debug.cpu.enemiesEngine.dynamicTarget = debugprofilestop()-startTime or 0
	end
	return bestUnit
end

-- Cone Logic for Enemies
function getEnemiesInCone(angle,length,showLines,checkNoCombat)
	if angle == nil then angle = 180 end
	if length == nil then length = 0 end
    local playerX, playerY, playerZ = GetObjectPosition("player")
    local facing = ObjectFacing("player")
    local units = 0
	local enemiesTable = getEnemies("player",length,checkNoCombat)

    for i = 1, #enemiesTable do
        local thisUnit = enemiesTable[i]
        local unitX, unitY, unitZ = GetPositionBetweenObjects(thisUnit, "player", UnitCombatReach(thisUnit))--GetObjectPosition(thisUnit)
        if playerX and unitX then
            local angleToUnit = getAngles(playerX,playerY,playerZ,unitX,unitY,unitZ)
            local angleDifference = facing > angleToUnit and facing - angleToUnit or angleToUnit - facing
            local shortestAngle = angleDifference < math.pi and angleDifference or math.pi*2 - angleDifference
            local finalAngle = shortestAngle/math.pi*180
            if finalAngle < angle/2 then
                units = units + 1
            end
        end
    end
	-- ChatOverlay(units)
    return units
end

local function getRect(width,length,showLines)
	local width = width or 10
	local length = length or 20
	local px, py, pz = GetObjectPosition("player")
	local facing = ObjectFacing("player") or 0
	local halfWidth = width/2
	-- Near Left
	local nlX, nlY, nlZ = GetPositionFromPosition(px, py, pz, halfWidth, facing + math.rad(90), 0)
	-- Near Right
	local nrX, nrY, nrZ = GetPositionFromPosition(px, py, pz, halfWidth, facing + math.rad(270), 0)
	-- Far Left
	--local flX, flY, flZ = GetPositionFromPosition(nlX, nlY, nlZ, length, facing, 0)
	-- Far Right
	local frX, frY, frZ = GetPositionFromPosition(nrX, nrY, nrZ, length, facing, 0)

	-- if showLines then
	-- 	-- Near Left
	-- 	LibDraw.Line(nlX, nlY, nlZ, playerX, playerY, playerZ)
	-- 	-- Near Right
	-- 	LibDraw.Line(nrX, nrY, nrZ, playerX, playerY, playerZ)
	-- 	-- Far Left
	-- 	LibDraw.Line(flX, flY, flZ, nlX, nlY, nlZ)
	-- 	-- Far Right
	-- 	LibDraw.Line(frX, frY, frZ, nrX, nrY, nrZ)
	-- 	-- Box Complete
	-- 	LibDraw.Line(frX, frY, frZ, flX, flY, flZ)
	-- end

	return nlX, nlY, nrX, nrY, frX, frY
end

function getEnemiesInRect(width,length,showLines,checkNoCombat)
	local LibDraw = LibStub("LibDraw-1.0")
	local checkNoCombat = checkNoCombat or false
	local nlX, nlY, nrX, nrY, frX, frY = getRect(width,length,showLines)
	local enemyCounter = 0
	local enemiesTable = getEnemies("player",length,checkNoCombat)
	local enemiesInRect = enemiesInRect or {}
	if #enemiesTable > 0 then
		table.wipe(enemiesInRect)
		for i = 1, #enemiesTable do
			local thisUnit = enemiesTable[i]
--			if thisUnit ~= "target" then
				local tX, tY = GetPositionBetweenObjects(thisUnit, "player", UnitCombatReach(thisUnit)) --GetObjectPosition(thisUnit)
--			end
			if tX and tY then
				if isInside(tX,tY,nlX,nlY,nrX,nrY,frX,frY) then
					if showLines then
						LibDraw.Circle(tX, tY, playerZ, UnitBoundingRadius(thisUnit))
					end
					enemyCounter = enemyCounter + 1
					table.insert(enemiesInRect,thisUnit)
				end
			end
		end
	end
	if #enemiesInRect ~= 0 then
		return enemyCounter, enemiesInRect
	else
		return enemyCounter
	end
end

-- local function intersects(circle, rect)
local function intersects(tX,tY,tR,aX,aY,cX,cY)
	-- if circle ~= nil then
	local circleDistance_x = math.abs(tX + tR - aX - (aX - cX)/2)
	local circleDistance_y = math.abs(tY + tR - aY - (aY - cY)/2)

	if (circleDistance_x > ((aX - cX)/2 + tR)) then
		return false
	end
	if (circleDistance_y > ((aY - cY)/2 + tR)) then
		return false
	end

	if (circleDistance_x <= ((aX - cX)/2)) then
		return true
	end

	if (circleDistance_y <= ((aY - cY)/2)) then
		return true
	end

	cornerDistance_sq = (circleDistance_x - (aX - cX)/2)^2 + (circleDistance_y - (aY - cY)/2)^2

	return (cornerDistance_sq <= (tR^2));
	-- else
	--     return false
	-- end
end

-- Percentage of enemies that are not in execute HP range
function getNonExecuteEnemiesPercent(executeHP)
    local executeCount = 0
    local nonexecuteCount = 0
    local nonexecutePercent = 0

	for k, v in pairs(br.enemy) do
		local thisUnit = br.enemy[k]
        if GetObjectExists(thisUnit.unit) then
            if getHP(thisUnit) < executeHP then
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
