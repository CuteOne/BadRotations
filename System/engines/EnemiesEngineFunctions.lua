br.enemy	= {}
br.lootable = {}
br.units 	= {}
br.objects  = {}
br.storedTables = {}
local refreshStored

local function AddUnit(thisUnit,thisTable,thisType)
	local unit = {
		unit = thisUnit,
		name = UnitName(thisUnit),
		guid = UnitGUID(thisUnit),
		id = GetObjectID(thisUnit),
		type = thisType
	}
	rawset(thisTable, thisUnit, unit)
end

local function AddObject(thisObject,thisTable,thisType)
	local object = {
		object = thisObject,
		name = ObjectName(thisObject),
		id = ObjectID(thisObject),
		type = thisType
	}
	rawset(thisTable, thisObject, object)
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
	local eliteTotems = {
        -- totems we can dot
        [125977] = "Reanimate Totem",
        [127315] = "Reanimate Totem",
        [146731] = "Zombie Dust Totem",
        [297237] = "Endless Hunger Totem"
    }
    local creatureType = UnitCreatureType(unit)
    local objectID = GetObjectID(unit)
    if creatureType ~= nil and eliteTotems[objectID] == nil then
        if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then
            return true
        end
    end
    return false
end

--Update OM
function updateOM()
	local om = br.om
	local startTime = debugprofilestop()
	local _, updated, added, removed = GetObjectCountBR(true,"BR")
	if updated and #added > 0 then
		for _, v in pairs(added) do
			if ObjectIsUnit(v) then
				local enemyUnit = br.unitSetup:new(v)
				if enemyUnit then
					tinsert(om, enemyUnit)
				end
			end
			-- Horrific Vision Object Tracking
			if br.lists ~= nil and br.lists.horrificVision ~= nil then
				for objType, w in pairs(br.lists.horrificVision) do
					for _, id in pairs(w) do
						if br.objects[v] == nil then
							local objectID = ObjectID(v) or 0
							local name = ObjectName(v) or ""
							if ObjectIsVisible(v) and ObjectExists(v) and objectID > 0 and (objectID == id or (objType == "chest" and (string.match(strupper(name),strupper("cache")) or string.match(strupper(name),strupper("chest"))))) then
								AddObject(v,br.objects,objType)
							end
						end
					end
				end
			end
		end
	end
    refreshStored = true
	-- Debugging
	br.debug.cpu:updateDebug(startTime,"enemiesEngine.objects")
end

-- /dump getEnemies("target",10)
function getEnemies(thisUnit,radius,checkNoCombat,facing)
	if checkNoCombat == nil then checkNoCombat = false end
	if facing == nil then facing = false end
    local startTime = debugprofilestop()
	local radius = tonumber(radius)
	local enemyTable = checkNoCombat and br.units or br.enemy
	local enemiesTable = {}
	local thisEnemy, distance
    if refreshStored == true then
		for k,v in pairs(br.storedTables) do br.storedTables[k] = nil end
		refreshStored = false
	end
	if br.storedTables[checkNoCombat] ~= nil then
		if checkNoCombat == false then
			if br.storedTables[checkNoCombat][thisUnit] ~= nil then
				if br.storedTables[checkNoCombat][thisUnit][radius] ~= nil then
					if br.storedTables[checkNoCombat][thisUnit][radius][facing] ~= nil then
						return br.storedTables[checkNoCombat][thisUnit][radius][facing]
					end
				end
			end
		end
	end

	for k, v in pairs(enemyTable) do
		thisEnemy = v.unit
		distance =  getDistance(thisUnit,thisEnemy)
		if distance < radius and (not facing or getFacing("player",thisEnemy)) then
			tinsert(enemiesTable,thisEnemy)
		end
    end
	if #enemiesTable == 0 and getDistance("target","player") < radius and isValidUnit("target") and (not facing or getFacing("player","target")) then
		tinsert(enemiesTable,"target")
	end
    ---
	if #enemiesTable > 0 and thisUnit ~= nil then
		if br.storedTables[checkNoCombat] == nil then br.storedTables[checkNoCombat] = {} end
		if br.storedTables[checkNoCombat][thisUnit] == nil then br.storedTables[checkNoCombat][thisUnit] = {} end
		if br.storedTables[checkNoCombat][radius] == nil then br.storedTables[checkNoCombat][thisUnit][radius] = {} end
		br.storedTables[checkNoCombat][thisUnit][radius][facing] = enemiesTable
	end
	-- Debugging
	br.debug.cpu:updateDebug(startTime,"enemiesEngine.getEnemies")
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
	-- returns true if target should be burnt
	function isBurnTarget(unit)
		local coef = 0
		-- check if unit is valid
		if getOptionCheck("Forced Burn") then
			local unitID = GetObjectID(unit)
			local burnUnit = br.lists.burnUnits[unitID]
			local unitTime = br.units[unit] ~= nil and br.units[unit].timestamp or GetTime() - 1
			-- if unit have selected debuff
			if burnUnit and (burnUnit.cast == nil or not isCasting(burnUnit.cast,unitID)) and (GetTime() - unitTime) > 0.75 then
				if burnUnit.buff and UnitBuffID(unit,burnUnit.buff) then
					coef = burnUnit.coef
				end
				if not burnUnit.buff and (UnitName(unit) == burnUnit.name or burnUnit or burnUnit.id == unitID) then
					--if not GetUnitIsUnit("target",unit) then TargetUnit(unit) end
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
	end
	return coef
end

-- check for a unit see if its a cc candidate
function isCrowdControlCandidates(Unit)
	local unitID
	-- check if unit is valid
	if GetObjectExists(Unit) then
		unitID = GetObjectID(Unit)
	else
		return false
	end
	-- cycle list of candidates
	local crowdControlUnit = br.lists.ccUnits[unitID]
	if crowdControlUnit then
		-- is in the list of candidates
		if crowdControlUnit.spell == nil or isCasting(crowdControlUnit.spell,Unit) or UnitBuffID(Unit,crowdControlUnit.spell)
		then -- doesnt have more requirements or requirements are met
			return true
		end
	end
	return false
end

-- returns true if we can safely attack this target
function isSafeToAttack(unit,bypass)
	if bypass == nil then bypass = false end
	if getOptionCheck("Safe Damage Check") == true or bypass == true then
		-- check if unit is valid
		local unitID = GetObjectExists(unit) and GetObjectID(unit) or 0
		if unitID then
			for i = 1, #br.lists.noTouchUnits do
				local noTouch = br.lists.noTouchUnits[i]
				if noTouch.unitID == 1 or noTouch.unitID == unitID then
					if noTouch.buff == nil then return false end --If a unit exist in the list without a buff it's just blacklisted
					if noTouch.buff > 0 then
						local unitTTD = getTTD(unit) or 0
						local bursting = getDebuffStacks("player",240443) > getOptionValue("Bursting Stack Limit")
						-- Not Safe with Buff/Debuff
						if UnitBuffID(unit,noTouch.buff) or UnitDebuffID(unit,noTouch.buff)
							-- Bursting M+ Affix
							or (bursting and unitTTD <= getDebuffRemain("player",240443) + (getGlobalCD(true) * 2))
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
					if inInstance and select(3, GetInstanceInfo()) == 8 then
						local bursting = getDebuffStacks("player",240443) > getOptionValue("Bursting Stack Limit")
						if bursting and unitTTD <= (getDebuffRemain("player",240443) + getGlobalCD(true) * 2)
						then
							return false
						end
					end
				end
			end
		end
	end
	-- Debugging
	br.debug.cpu:updateDebug(startTime,"enemiesEngine.isSafeToAttack")
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
	local startTime = debugprofilestop()
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
				-- raid target management
				-- if the unit have the skull and we have param for it add 50
				-- if getOptionCheck("Skull First") and GetRaidTargetIndex(unit) == 8 then
				-- 	coef = coef + 50
				-- end
				-- if threat is checked, add 100 points of prio if we lost aggro on that target
				if getOptionCheck("Tank Threat") then
					local threat = UnitThreatSituation("player",unit) or -1
					if select(6, GetSpecializationInfo(GetSpecialization())) == "TANK" and threat < 3 and unitHP > 10 then
						coef = coef + 100 - threat
					end
				end
				-- Blood of the enemy
				if getDebuffRemain(unit, 297108) > 0 then
					coef = coef + 50
				end
				-- if user checked burn target then we add the value otherwise will be 0
				-- if getOptionCheck("Forced Burn") then
				-- 	coef = coef + isBurnTarget(unit) + ((50 - distance)/100)
				-- end
				-- if user checked avoid shielded, we add the % this shield remove to coef
				if getOptionCheck("Avoid Shields") then
					coef = coef + isShieldedTarget(unit)
				end
			end
			local displayCoef = math.floor(coef*10)/10
			local displayName = UnitName(unit) or "invalid"
			-- Print("Unit "..displayName.." - "..displayCoef)
		end
	end
	-- Debugging
	br.debug.cpu:updateDebug(startTime,"enemiesEngine.unitCoef")
	return coef
end

local function compare(a,b)
	if UnitHealth(a) == UnitHealth(b) then
		return getDistance(a) < getDistance(b)
	else
		return  UnitHealth(a) < UnitHealth(b)
	end
end

-- Finds the "best" unit for a given range and optional facing
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
				if isSafeToAttack(thisUnit,true) and (((unitID == 135360 or unitID == 135358 or unitID == 135359) and UnitBuffID(thisUnit,260805)) or (unitID ~= 135360 and unitID ~= 135358 and unitID ~= 135359)) and (unitID ~= 152910 or (unitID == 152910 and UnitBuffID(thisUnit, 300551))) then
					local isCC = getOptionCheck("Don't break CCs") and isLongTimeCCed(thisUnit) or false
					local isSafe = (getOptionCheck("Safe Damage Check") and isSafeToAttack(thisUnit)) or not getOptionCheck("Safe Damage Check") or false
					-- local thisUnit = v.unit
					-- local distance = getDistance(thisUnit)
					-- if distance < range then
					if not isCC then			
						local coeficient = getUnitCoeficient(thisUnit) or 0		
						if getOptionCheck("Skull First") and GetRaidTargetIndex(thisUnit) == 8 and not GetUnitIsDeadOrGhost(thisUnit) then
							bestUnit = thisUnit
							return bestUnit
						end
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
					-- end
		--			lastCheckTime = GetTime() + 1
				end
			end
		end
	end
	-- Debugging
	br.debug.cpu:updateDebug(startTime,"enemiesEngine.findBestUnit")
	return bestUnit
end

-- Sets Target by attempting to find the best unit else defaults to target
function dynamicTarget(range,facing)
	if range == nil or range > 100 then return nil end
	local startTime = debugprofilestop()
	local facing = facing or false
	local bestUnit = bestUnit or nil
	local tarDist = GetUnitExists("target") and getDistance("target") or 99
	local defaultRange 
	if rangeOrMelee[GetSpecializationInfo(GetSpecialization())] ~= nil then
		if rangeOrMelee[GetSpecializationInfo(GetSpecialization())] == "ranged" then
			defaultRange = 40
		elseif rangeOrMelee[GetSpecializationInfo(GetSpecialization())] == "melee" then
			defaultRange = 8
		else
			defaultRange = 40
		end
	else
		defaultRange = 40
	end
	if isChecked("Forced Burn") then
		if isBurnTarget("target") > 0 and ((isExplosive and getFacing("player","target")) or not isExplosive("target")) and getDistance("target") <= range then
			return
		end
		if (GetUnitExists("target" ) and isBurnTarget("target") == 0) or not GetUnitExists("target") then
			local burnUnit
			local enemyList = getEnemies("player",range,false,facing)
			local burnDist
			for i = 1, #enemyList do
				local currDist = getDistance(enemyList[i])
				if isBurnTarget(enemyList[i]) > 0 and (burnDist == nil or currDist < burnDist) then
					if isExplosive(enemyList[i]) and getFacing("player",enemyList[i]) then
						burnDist = currDist
						burnUnit = enemyList[i]
					elseif not isExplosive(enemyList[i]) then
						burnDist = currDist
						burnUnit = enemyList[i]
					end
				end
			end
			if burnUnit ~= nil then
				TargetUnit(burnUnit)
				return
			end
		end
	end
	if isChecked("Darter Targeter") and br.player.eID == 2333 then
		local enemyList = getEnemies("player",defaultRange,false,true)
		local darterHP
		local darterUnit
		for i = 1, #enemyList do
			local unitHP = getHP(enemyList[i])
			if GetObjectID(enemyList[i]) == 157256 then
				if darterHP == nil or unitHP < darterHP*0.9 then
					darterHP = unitHP
					darterUnit = enemyList[i]
				end
			end
		end
		if darterUnit ~= nil then
			TargetUnit(darterUnit)
			return
		end
	end
	if (not isChecked("Dynamic Targetting") or bestUnit == nil) and getDistance("target") < range
		and getFacing("player","target") and not GetUnitIsDeadOrGhost("target") and not GetUnitIsFriend("target","player")
	then
		bestUnit = "target"
	end
	if isChecked("Dynamic Targetting") then
		local enemyList = getEnemies("player",range,false,facing)
		if getOptionValue("Dynamic Targetting") == 2 or (br.player.inCombat and getOptionValue("Dynamic Targetting") == 1) 
			and (bestUnit == nil or (GetUnitIsUnit(bestUnit,"target") and tarDist >= range))
			then
				bestUnit = findBestUnit(range,facing)
		elseif getOptionValue("Dynamic Targetting") == 3 and br.player.inCombat then
			if getOptionCheck("Skull First") then
				for i = 1, #enemyList do
					if GetRaidTargetIndex(enemyList[i]) == 8 and not GetUnitIsDeadOrGhost(enemyList[i]) then
						bestUnit = enemyList[i]
					end
				end
				if bestUnit == nil then
					if not GetUnitExists("target") or (GetUnitIsDeadOrGhost("target") and not GetUnitIsFriend("target","player")) or not isSafeToAttack("target",true) or
						(facing and not getFacing("player","target")) or (getOptionCheck("Don't break CCs") and isLongTimeCCed("target")) or (getDistance("target") > range and isChecked("Include Range")) then
						bestUnit = findBestUnit(defaultRange,facing)
					end
				end
			elseif isChecked("Wise Target") and br.timer:useTimer("wiseTargetDelay", 0.5) then
				if getOptionValue("Wise Target Frequency") == 2 and not (GetUnitIsDeadOrGhost("target") and GetUnitIsFriend("target")) and tarDist <= range then
					return
				end
				local targetHP
				local lowDist
				local highDist
				for i = 1, #enemyList do
					local isCC = getOptionCheck("Don't break CCs") and isLongTimeCCed(enemyList[i]) or false
					local unitHP = getHP(enemyList[i])
					local absUnitHP = UnitHealthMax(enemyList[i])
					local currDist = getDistance(enemyList[i])
					if not isCC and isSafeToAttack(enemyList[i],true) and br.lists.shieldUnits[enemyList[i]] == nil then
						if getOptionValue("Wise Target") == 1 then 	   -- Highest	
							if (targetHP == nil or unitHP*1.10 > targetHP) then
								targetHP = unitHP
								bestUnit = enemyList[i]
							end
						elseif getOptionValue("Wise Target") == 3 then -- abs Highest
							if (targetHP == nil or absUnitHP*1.10 > targetHP) then
								targetHP = absUnitHP
								bestUnit = enemyList[i]
							end
						elseif getOptionValue("Wise Target") == 4 then -- abs Lowest	
							if (targetHP == nil or absUnitHP*.9 < targetHP) then
								targetHP = absUnitHP  
								bestUnit = enemyList[i]
							end
						elseif getOptionValue("Wise Target") == 5  then -- Nearest
							if (lowDist == nil or currDist*0.9 < lowDist*.90) then
								lowDist = currDist
								bestUnit = enemyList[i]
							end
						elseif getOptionValue("Wise Target") == 6  then -- Furthest
							if (highDist == nil or currDist*1.1 > highDist) then
								highDist = currDist
								bestUnit = enemyList[i]
							end
						else  										   -- Lowest
							if (targetHP == nil or unitHP*.9 < targetHP*.90) then
								targetHP = unitHP
								bestUnit = enemyList[i]
							end
						end
					end
				end
			elseif not GetUnitExists("target") or (GetUnitIsDeadOrGhost("target") and not GetUnitIsFriend("target","player")) or not isSafeToAttack("target",true) or
				(facing and not getFacing("player","target")) or (getOptionCheck("Don't break CCs") and isLongTimeCCed("target")) or (getDistance("target") > range and isChecked("Include Range")) then
				bestUnit = findBestUnit(defaultRange,facing)
			end
		end
		if br.timer:useTimer("Unit Delay",0.5) then
			br.addonDebug("Best Unit: "..tostring(bestUnit),true)
		end
		if isChecked("Target Dynamic Target") and bestUnit ~= nil and br.player.inCombat then
			if not GetUnitExists("target") or (GetUnitIsDeadOrGhost("target") and not GetUnitIsFriend("target","player")) then
				TargetUnit(bestUnit)
			elseif not isSafeToAttack("target",true) then
				TargetUnit(bestUnit)
			elseif (isChecked("Wise Target") or isChecked("Skull First")) and not GetUnitIsUnit("target",bestUnit) then
				TargetUnit(bestUnit)
			elseif ((unitID == 135360 or unitID == 135358 or unitID == 135359) and not UnitBuffID(thisUnit,260805)) then 
				TargetUnit(bestUnit)
			elseif (facing and not getFacing("player","target")) then
				TargetUnit(bestUnit)
			elseif getOptionCheck("Don't break CCs") and isLongTimeCCed("target") then
				TargetUnit(bestUnit)
			elseif getDistance("target") > range and isChecked("Include Range") then
				TargetUnit(bestUnit)
			end
		end
	end
	-- Debugging
	br.debug.cpu:updateDebug(startTime,"enemiesEngine.dynamicTarget")
	return bestUnit
end

local function drawRect(nlX, nlY, nlZ,nrX, nrY, nrZ,flX, flY, flZ,frX, frY, frZ)
	 -- Bottom
	 LibDraw.Line(nlX, nlY, nlZ, nrX, nrY, nrZ)
	 -- Far Left
	 LibDraw.Line(flX, flY, flZ, nlX, nlY, nlZ)
	 -- Far Right
	 LibDraw.Line(frX, frY, frZ, nrX, nrY, nrZ)
	 -- Top
	 LibDraw.Line(frX, frY, frZ, flX, flY, flZ)
 end

local function drawCircle(x,y,z,r)
	LibDraw.Circle(x,y,z,r)
end

function br.pointOnACircle(pX,pY,cX,cY,R)
	local vX = pX - cX;
	local vY = pY - cY;
	local magV = math.sqrt(vX*vX + vY*vY);
	local aX = cX + vX / magV * R;
	local aY = cY + vY / magV * R;
	return aX,aY,select(3,GetObjectPosition("player"))
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
	local flX, flY, flZ = GetPositionFromPosition(nlX, nlY, nlZ, length, facing, 0)
	-- Far Right
	local frX, frY, frZ = GetPositionFromPosition(nrX, nrY, nrZ, length, facing, 0)

	LibDraw.clearCanvas()

	if showLines and nlX and px then
		drawRect(nlX, nlY, nlZ,nrX, nrY, nrZ,flX, flY, flZ,frX, frY, frZ)
	end

	return nlX, nlY, nrX, nrY, frX, frY, flX,flY
end

-- local function circleRect(cx, cy, radius, rx, ry, rw, rh) 

--   -- temporary variables to set edges for testing
--   	local testX = cx;
-- 	local testY = cy;
--   -- which edge is closest?
-- 	if (cx < rx) then
-- 		testX = rx-(rw/2) ;      -- test left edge
-- 		print("Left Edge")
--   	elseif (cx > rx) then
-- 		testX = rx+(rw/2);   -- right edge
-- 		print("Right Edge")
--   	end
--   	if (cy < ry) then
-- 		testY = ry-(rh/2);      -- top edge
-- 		print("Bottom Edge")
--   	elseif (cy > ry) then
-- 		testY = ry+(rh/2);   -- bottom edge
-- 		print("Top Edge")
-- 	end
	  
-- 	local nlX, nlY, nrX, nrY, frX, frY, flX,flY = getRect(rw,rh,true)
-- 	--drawCircle(rx,ry,select(3,GetObjectPosition("player")),0.1)
-- 	--drawCircle(testX,testY,select(3,GetObjectPosition("player")),0.1)

--   -- get distance from closest edges
--   	local distX = cx-testX;
--   	local distY = cy-testY;
--   	local distance = math.sqrt((distX*distX)+(distY*distY));

--   -- if the distance is less than the radius, collision!
--   	if (distance <= radius) then
-- 		return true
-- 	end
--   	return false
-- end

-- local function circleRect(cx, cy, radius, rx, ry, rw, rh) 
-- 	-- temporary variables to set edges for testing
-- 		local testX = cx;
-- 		local testY = cy;
  
-- 	-- which edge is closest?
-- 	  if (cx < rx) then
-- 		  testX = rx;      -- test left edge
-- 		elseif (cx > rx+rw) then
-- 		  testX = rx+rw;   -- right edge
-- 		end
-- 		if (cy < ry) then
-- 		  testY = ry;      -- top edge
-- 		elseif (cy > ry+rh) then
-- 		  testY = ry+rh;   -- bottom edge
-- 		end
  
-- 	-- get distance from closest edges
-- 		local distX = cx-testX;
-- 		local distY = cy-testY;
-- 		local distance = math.sqrt((distX*distX)+(distY*distY));

-- 		drawRect(rx, ry, select(3,GetObjectPosition("player")),rx+rw, ry, select(3,GetObjectPosition("player")),rx, ry+rh, select(3,GetObjectPosition("player")),rx+rw, ry+rh, select(3,GetObjectPosition("player")))

-- 		drawCircle(testX,testY,select(3,GetObjectPosition("player")),0.2)
  
-- 	-- if the distance is less than the radius, collision!
-- 		if (distance <= radius) then
-- 		  return true
-- 	  end
-- 		return false
--   end


-- Cone Logic for Enemies
function getEnemiesInCone(angle,length,showLines,checkNoCombat)
	if angle == nil then angle = 180 end
	if length == nil then length = 0 end
    local playerX, playerY, playerZ = GetObjectPosition("player")
    local facing = ObjectFacing("player")
    local units = 0
	local enemiesTable = getEnemies("player",length,checkNoCombat,true)
	local inside = false
    for i = 1, #enemiesTable do
		local thisUnit = enemiesTable[i]
		local radius = UnitCombatReach(thisUnit)
        local unitX, unitY, unitZ = GetPositionBetweenObjects(thisUnit, "player", radius)
		if playerX and unitX then
			for i = radius, 0, -0.1 do
				inside = false
				if i > 0 then
					unitX, unitY = GetPositionBetweenObjects(thisUnit, "player", i)
				else
					unitX, unitY = GetObjectPosition(thisUnit)
				end
				local angleToUnit = getAngles(playerX,playerY,playerZ,unitX,unitY,unitZ)
				local angleDifference = facing > angleToUnit and facing - angleToUnit or angleToUnit - facing
				local shortestAngle = angleDifference < math.pi and angleDifference or math.pi*2 - angleDifference
				local finalAngle = shortestAngle/math.pi*180
				if finalAngle < angle/2 then
					inside = true
					break
				end
			end

            if inside then
                units = units + 1
            end
        end
	end

	-- ChatOverlay(units)
    return units
end

local function getRect(width,length,showLines)
	local px, py, pz = GetObjectPosition("player")
	local facing = ObjectFacing("player") or 0
	local halfWidth = width/2
	-- Near Left
	local nlX, nlY, nlZ = GetPositionFromPosition(px, py, pz, halfWidth, facing + math.rad(90), 0)
	-- Near Right
	local nrX, nrY, nrZ = GetPositionFromPosition(px, py, pz, halfWidth, facing + math.rad(270), 0)
	-- Far Left
	local flX, flY, flZ = GetPositionFromPosition(nlX, nlY, nlZ, length, facing, 0)
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

	return nlX, nlY, nrX, nrY, frX, frY, flX, flY
end

function getEnemiesInRect(width,length,showLines,checkNoCombat)
	local function getRect(width,length,showLines)
		local px, py, pz = GetObjectPosition("player")
		local facing = ObjectFacing("player") or 0
		local halfWidth = width/2
		-- Near Left
		local nlX, nlY, nlZ = GetPositionFromPosition(px, py, pz, halfWidth, facing + math.rad(90), 0)
		-- Near Right
		local nrX, nrY, nrZ = GetPositionFromPosition(px, py, pz, halfWidth, facing + math.rad(270), 0)
		-- Far Left
		-- local flX, flY, flZ = GetPositionFromPosition(nlX, nlY, nlZ, length, facing, 0)
		-- Far Right
		local frX, frY, frZ = GetPositionFromPosition(nrX, nrY, nrZ, length, facing, 0)

		return nlX, nlY, nrX, nrY, frX, frY
	end
	local LibDraw = LibStub("LibDraw-1.0")
	local checkNoCombat = checkNoCombat or false
	local nlX, nlY, nrX, nrY, frX, frY = getRect(width,length,showLines)
	local enemyCounter = 0
	local enemiesTable = getEnemies("player",length,checkNoCombat,true)
	local enemiesInRect = enemiesInRect or {}
	local inside = false
	if #enemiesTable > 0 then
		table.wipe(enemiesInRect)
		for i = 1, #enemiesTable do
			local thisUnit = enemiesTable[i]
			local radius = UnitCombatReach(thisUnit)
			local tX, tY = GetPositionBetweenObjects(thisUnit, "player", radius)
			if tX and tY then
				for i = radius, 0, -0.1 do
					inside = false
					local pX, pY
					if i > 0 then
						pX, pY = GetPositionBetweenObjects(thisUnit, "player", i) 
					else
						pX, pY = GetObjectPosition(thisUnit)
					end
					if isInside(pX,pY,nlX,nlY,nrX,nrY,frX,frY) then inside = true break end
				end
				if inside then
					if showLines then
						LibDraw.Circle(tX, tY, playerZ, UnitBoundingRadius(thisUnit))
					end
					enemyCounter = enemyCounter + 1
					table.insert(enemiesInRect,thisUnit)
				end
			end
		end
	end
	return enemyCounter, enemiesInRect
end

-- local function intersects(circle, rect)
local function intersects(tX,tY,tR,aX,aY,cX,cY)
	-- if circle ~= nil then
	local circleDistance_x = math.abs(tX - (aX + cX)/2)
	local circleDistance_y = math.abs(tY - (aY + cY)/2)

	local rect_l = math.abs(aX-cX)
	local rect_h = math.abs(aY-cY)

	if (circleDistance_x > ((rect_l)/2 + tR)) then
		return false
	end
	if (circleDistance_y > ((rect_h)/2 + tR)) then
		return false
	end

	if (circleDistance_x <= ((rect_l)/2)) then
		return true
	end

	if (circleDistance_y <= ((rect_h)/2)) then
		return true
	end

	cornerDistance_sq = (circleDistance_x - (rect_l)/2)^2 + (circleDistance_y - (rect_h)/2)^2

	return (cornerDistance_sq <= (tR^2));
	-- else
	--     return false
	-- end
end


function getEnemiesInRect(width,length,showLines,checkNoCombat)
	local LibDraw = LibStub("LibDraw-1.0")
	local checkNoCombat = checkNoCombat or false
	local nlX, nlY, nrX, nrY, frX, frY, flX,flY = getRect(width,length,isChecked("Show Drawings"))
	local middleX = (flX+nrX)/2
	local middleY = (flY+nrY)/2
	local enemyCounter = 0
	local enemiesTable = getEnemies("player",length,checkNoCombat)
	local enemiesInRect = enemiesInRect or {}
	if #enemiesTable > 0 then
		table.wipe(enemiesInRect)
		for i = 1, #enemiesTable do
			local thisUnit = enemiesTable[i]
			local tX, tY, tZ = GetObjectPosition(thisUnit) --GetPositionBetweenObjects(thisUnit, "player", UnitCombatReach(thisUnit))
			if tX and tY then
				--if circleRect(tX,tY,UnitBoundingRadius(thisUnit),nlX,nlY, width, length) then
				if  isInside(tX,tY,nlX,nlY,nrX,nrY,frX,frY) then
					if showLines then
						drawCircle(tX,tY,tZ, UnitBoundingRadius(thisUnit))
				 	end
				 	enemyCounter = enemyCounter + 1
				 	table.insert(enemiesInRect,thisUnit)
				end
			end
		end
	end
	return enemyCounter, enemiesInRect
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