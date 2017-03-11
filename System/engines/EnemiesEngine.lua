-- Function to create and populate table of enemies within a distance from player.
br.enemy = {}

-- Adds Enemies to the enemy table
local function AddEnemy(thisUnit)
	local startTime = debugprofilestop()
	-- if br.enemy[thisUnit] == nil then
		br.enemy[thisUnit] 	= {}
		local enemy 		= br.enemy[thisUnit] 
		enemy.unit 			= thisUnit
		enemy.name 			= UnitName(thisUnit)
		enemy.guid 			= UnitGUID(thisUnit)
		enemy.id 			= GetObjectID(thisUnit)
	-- end
	br.debug.cpu.enemiesEngine.addTime = debugprofilestop()-startTime or 0
end

-- Updates Enemy Info
local function UpdateEnemy(thisUnit)
	local startTime 	= debugprofilestop()
	local longTimeCC
	if getOptionCheck("Don't break CCs") then
		longTimeCC 		= isLongTimeCCed(thisUnit)
	else
		longTimeCC 		= false
	end
	local burnValue 	= isBurnTarget(thisUnit) or 0
	local shieldValue 	= isShieldedTarget(thisUnit) or 0
	local unitDistance 	= getDistance("player",thisUnit)
	local unitThreat 	= UnitThreatSituation("player",thisUnit) or -1
	local enemy 		= br.enemy[thisUnit]
	enemy.inCombat 		= UnitAffectingCombat(thisUnit)
	enemy.coeficient 	= getUnitCoeficient(thisUnit,unitDistance,unitThreat,burnValue,shieldValue) or 0
	enemy.cc 			= isCrowdControlCandidates(thisUnit)
	enemy.isCC 			= isLongTimeCCed(thisUnit)
	enemy.facing 		= getFacing("player",thisUnit)
	enemy.threat 		= UnitThreatSituation("player",thisUnit) or -1
	enemy.hp 			= getHP(thisUnit)
	enemy.hpabs 		= UnitHealth(thisUnit)
	enemy.safe 			= isSafeToAttack(thisUnit)
	enemy.burn 			= isBurnTarget(thisUnit) or 0
	enemy.offensiveBuff = getOffensiveBuffs(thisUnit,unitGUID)
	br.debug.cpu.enemiesEngine.updateTime = debugprofilestop()-startTime or 0
end

-- Remove Invalid Enemies
local function DeleteEnemy(thisUnit)
	if not ObjectExists(thisUnit) or not UnitIsVisible(thisUnit) then
		br.enemy[thisUnit] = nil
	elseif not isValidUnit(thisUnit) then
		-- Print("Removing Enemy")
		br.enemy[thisUnit] = nil
	else
		UpdateEnemy(thisUnit)
	end
end

-- Find Enemies
local function FindEnemy()
	-- DEBUG
    local startTime = debugprofilestop()
    br.debug.cpu.enemiesEngine.unitTargets = 0
    br.debug.cpu.enemiesEngine.sanityTargets = 0
    local objectCount = GetObjectCount() 
	if FireHack ~= nil and objectCount > 0 then --and (enemyCount == 0 or enemyCount < br.debug.cpu.enemiesEngine.sanityTargets) then
        for i = 1, objectCount do
			-- define our unit
            local thisUnit = GetObjectWithIndex(i)
			-- check if it a unit first
            if ObjectIsType(thisUnit, ObjectTypes.Unit) then
                br.debug.cpu.enemiesEngine.unitTargets = br.debug.cpu.enemiesEngine.unitTargets + 1
				-- Enemies
				if ObjectExists(thisUnit) and isValidUnit(thisUnit) and br.enemy[thisUnit] == nil then
                    br.debug.cpu.enemiesEngine.sanityTargets = br.debug.cpu.enemiesEngine.sanityTargets + 1
                    -- Print("Adding Enemy")
					AddEnemy(thisUnit)
				end
			end
		end
	end
	-- Debugging
	br.debug.cpu.enemiesEngine.totalIterations = br.debug.cpu.enemiesEngine.totalIterations + 1
	br.debug.cpu.enemiesEngine.currentTime = debugprofilestop()-startTime
	br.debug.cpu.enemiesEngine.elapsedTime = br.debug.cpu.enemiesEngine.elapsedTime + debugprofilestop()-startTime
	br.debug.cpu.enemiesEngine.averageTime = br.debug.cpu.enemiesEngine.elapsedTime / br.debug.cpu.enemiesEngine.totalIterations
end

function EnemiesEngine()
	-- Run Update/Delete
	if br.enemy ~= nil then
		for k, v in pairs(br.enemy) do
			DeleteEnemy(k)
		end
	end
	FindEnemy()
end

-- returns prefered target for diferent spells
function dynamicTarget(range,facing)
	local startTime = debugprofilestop()
	if getOptionCheck("Dynamic Targetting") then
		local bestUnitCoef = 0
		local bestUnit = "target"
		for k, v in pairs(br.enemy) do
			local thisUnit = br.enemy[k]
			local thisDistance = getDistance("player",thisUnit.unit)
			if GetObjectExists(thisUnit.unit) and ObjectID(thisUnit.unit) ~= 103679 and thisUnit.coeficient ~= nil then
				if (not getOptionCheck("Safe Damage Check") or thisUnit.safe) and not thisUnit.isCC
					and thisDistance < range and (not facing or thisUnit.facing)
				then
					if thisUnit.coeficient >= 0 and thisUnit.coeficient >= bestUnitCoef then
						bestUnitCoef = thisUnit.coeficient
						bestUnit = thisUnit.unit
					end
				end
			end
		end
		br.debug.cpu.enemiesEngine.dynamicTarget = debugprofilestop()-startTime or 0
		return bestUnit
	end
	br.debug.cpu.enemiesEngine.dynamicTarget = debugprofilestop()-startTime or 0
	return "target"
end
-- function dynamicTarget(range,facing)
-- 	if getOptionCheck("Dynamic Targetting") then
-- 		local bestUnitCoef = 0
-- 		local bestUnit = "target"
-- 		for i = 1, ObjectCount() do
-- 			-- define our unit
--             local thisUnit = GetObjectWithIndex(i)
-- 			-- check if it a unit first
--             if ObjectIsType(thisUnit, ObjectTypes.Unit) then
--             	local unitDistance 		= getDistance("player",thisUnit)
--             	local unitThreat 		= UnitThreatSituation("player",thisUnit) or -1
--             	local burnValue 		= isBurnTarget(thisUnit) or 0
-- 				local shieldValue 		= isShieldedTarget(thisUnit) or 0
--             	local unitCoeficient 	= getUnitCoeficient(thisUnit,unitDistance,unitThreat,burnValue,shieldValue) or 0
--             	-- sanity checks
-- 				if isValidUnit(thisUnit) and ObjectID(thisUnit) ~= 103679 then
-- 					if (not getOptionCheck("Safe Damage Check") or isSafeToAttack(thisUnit)) and not isLongTimeCCed(thisUnit)
-- 						and unitDistance < range and (not facing or getFacing("player",thisUnit))
-- 					then
-- 						if unitCoeficient >= 0 and unitCoeficient >= bestUnitCoef then
-- 							bestUnitCoef = unitCoeficient
-- 							bestUnit = thisUnit
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
-- 		return bestUnit
-- 	end
-- 	return "target"
-- end

-- get the best aoe interupt unit for a given range
function getBestAoEInterupt(Range)
	-- pulse our function that add casters around to castersTable
	findCastersAround(Range)
	-- dummy var
	local bestAoEInteruptAmount = 0
	local bestAoEInteruptTarget = "target"
	-- cycle spellCasters to find best case
	local spellCastersTable = br.im.casters
	for i = 1, #spellCastersTable do
		-- check if unit is valid
		if GetObjectExists(spellCastersTable[i].unit) then
			-- if dummy beat old dummy, update
			if spellCastersTable[i].castersAround > bestAoEInteruptAmount then
				bestAoEInteruptAmount = spellCastersTable[i].castersAround
				bestAoEInteruptTarget = spellCastersTable[i].unit
			end
		end
	end
	-- return best case
	return bestAoEInteruptTarget
end

function getDebuffCount(spellID)
	local counter = 0
	for k, v in pairs(br.enemy) do
		local thisUnit = br.enemy[k].unit
		-- check if unit is valid
		if GetObjectExists(thisUnit) then
			-- increase counter for each occurences
			if UnitDebuffID(thisUnit,spellID,"player") then
				counter = counter + 1
			end
		end
	end
	return tonumber(counter)
end

-- to enlight redundant checks in getDistance within getEnemies
function getDistanceXYZ(unit1,unit2)
	-- check if unit is valid
	if GetObjectExists(unit1) and GetObjectExists(unit2) then
		local x1, y1, z1 = GetObjectPosition(unit1)
		local x2, y2, z2 = GetObjectPosition(unit2)
		return math.sqrt(((x2-x1)^2)+((y2-y1)^2)+((z2-z1)^2));
	end
end

-- /dump UnitGUID("target")
-- /dump getEnemies("target",10)
function getEnemies(unit,Radius,InCombat,precise)
	local startTime = debugprofilestop()
	if GetObjectExists(unit) and UnitIsVisible(unit) then
		local getEnemiesTable = { }
		for k, v in pairs(br.enemy) do
			local thisUnit = br.enemy[k].unit
			local thisDistance = getDistance("player",thisUnit)
			-- check if unit is valid
			if GetObjectExists(thisUnit) and (not InCombat or br.enemy[k].inCombat) then
                if unit == "player" and not precise then
                    if thisDistance <= Radius then
                        tinsert(getEnemiesTable,thisUnit)
                    end
                else
                    if getDistance(unit,thisUnit) <= Radius then
                        tinsert(getEnemiesTable,thisUnit)
                    end
                end
			end
		end
		return getEnemiesTable
	else
		return { }
	end
	br.debug.cpu.enemiesEngine.getEnemies = debugprofilestop()-startTime or 0
end

function getTableEnemies(unit,Range,table)
	local getTableEnemies = { }
	if table == nil then return getTableEnemies end
	for i = 1, #table do
		local thisUnit = table[i]
		if getDistance(unit,thisUnit) <= Range then
			tinsert(getTableEnemies,thisUnit)
		end
	end
	return getTableEnemies
end

function isInside(x,y,ax,ay,bx,by,dx,dy)
	bax = bx - ax
	bay = by - ay
	dax = dx - ax
	day = dy - ay

	if ((x - ax) * bax + (y - ay) * bay <= 0.0) then return false end
	if ((x - bx) * bax + (y - by) * bay >= 0.0) then return false end
	if ((x - ax) * dax + (y - ay) * day <= 0.0) then return false end
	if ((x - dx) * dax + (y - dy) * day >= 0.0) then return false end

	return true
end

function getEnemiesInRect(width,length,showLines)
	local LibDraw = LibStub("LibDraw-1.0")
	local playerX, playerY, playerZ = GetObjectPosition("player")
	local facing = ObjectFacing("player")

	-- Near Left
	local nlX, nlY, nlZ = GetPositionFromPosition(playerX, playerY, playerZ, width/2, facing + math.rad(90), 0)
	-- Near Right
	local nrX, nrY, nrZ = GetPositionFromPosition(playerX, playerY, playerZ, width/2, facing + math.rad(270), 0)
	-- Far Left
	local flX, flY, flZ = GetPositionFromPosition(nlX, nlY, nlZ, length, facing + math.rad(0), 0)
	-- Far Right
	local frX, frY, frZ = GetPositionFromPosition(nrX, nrY, nrZ, length, facing + math.rad(0), 0)


	if showLines then
		-- Near Left
		LibDraw.Line(nlX, nlY, nlZ, playerX, playerY, playerZ)
		-- Near Right
		LibDraw.Line(nrX, nrY, nrZ, playerX, playerY, playerZ)
		-- Far Left
		LibDraw.Line(flX, flY, flZ, nlX, nlY, nlZ)
		-- Far Right
		LibDraw.Line(frX, frY, frZ, nrX, nrY, nrZ)
		-- Box Complete
		LibDraw.Line(frX, frY, frZ, flX, flY, flZ)
	end

	local enemiesTable = getEnemies("player",length)
	local enemyCounter = 0
	local maxX = math.max(nrX,nlX,frX,flX)
	local minX = math.min(nrX,nlX,frX,flX)
	local maxY = math.max(nrY,nlY,frY,flY)
	local minY = math.min(nrY,nlY,frY,flY)
	local objectCount = GetObjectCount() or 0
	for i = 1, objectCount do
		local thisUnit = GetObjectWithIndex(i)
		if ObjectIsType(thisUnit, ObjectTypes.Unit) and isValidTarget(thisUnit) and (UnitIsEnemy(thisUnit,"player") or isDummy(thisUnit)) then
			local tX, tY, tZ = GetObjectPosition(thisUnit)
			if isInside(tX,tY,nlX,nlY,nrX,nrY,frX,frY) then
				if showLines then
					LibDraw.Circle(tX, tY, playerZ, UnitBoundingRadius(thisUnit))
				end
				enemyCounter = enemyCounter + 1
			end
		end
	end
	return enemyCounter
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

-- returns true if unit have an Offensive Buff that we should dispel
function getOffensiveBuffs(unit,guid)
	if GetObjectExists(unit) then
		local targets = br.read.enraged
		for i = 1,#targets do
			if guid == targets[i].guid then
				return targets[i].spellType
			end
		end
	end
	return false
end
-- returns true if Unit is a valid enemy
function getSanity(unit)
	if  UnitIsVisible(unit) == true and getCreatureType(unit) == true
		and ((UnitCanAttack(unit, "player") == true or not UnitIsFriend(unit,"player") or isDummy(unit)) and getLineOfSight(unit, "player"))
		and UnitIsDeadOrGhost(unit) == false
	then
		return true
	else
		return false
	end
end
-- This function will set the prioritisation of the units, ie which target should i attack
function getUnitCoeficient(unit,distance,threat,burnValue,shieldValue)
	local coef = 0
	if distance == nil then distance = getDistance("player",unit) end
	-- check if unit is valid
	if GetObjectExists(unit) then
		-- if unit is out of range, bad prio(0)
		if distance < 40 then
			local unitHP = getHP(unit)
			-- if its our actual target we give it a bonus
			if UnitIsUnit("target",unit) == true then
				coef = coef + 1
			end
			-- if wise target checked, we look for best target by looking to the lowest or highest hp, otherwise we look for target
			if getOptionCheck("Wise Target") == true then
				if getOptionValue("Wise Target") == 1 then
					-- if highest is selected
					coef = unitHP
				elseif getOptionValue("Wise Target") == 3 then
					coef = UnitHealth(unit)
				else
					-- if lowest is selected
					coef = 100 - unitHP
				end
			end
			-- raid target management
			-- if the unit have the skull and we have param for it add 50
			if getOptionCheck("Skull First") and GetRaidTargetIndex(unit) == 8 then
				coef = coef + 50
			end
			-- if threat is checked, add 100 points of prio if we lost aggro on that target
			if getOptionCheck("Tank Threat") == true then
				if select(6, GetSpecializationInfo(GetSpecialization())) == "TANK" and threat < 3 and unitHP > 10 then
					coef = coef + 100
				end
			end
			-- if user checked burn target then we add the value otherwise will be 0
			coef = coef + burnValue
			-- if user checked avoid shielded, we add the % this shield remove to coef
			coef = coef + shieldValue
			local displayCoef = math.floor(coef*10)/10
			local displayName = UnitName(unit) or "invalid"
			-- Print("Unit "..displayName.." - "..displayCoef)
		end
	end
	return coef
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
		if GetObjectExists(unit) then
			local unitID = GetObjectID(unit)
			local burnUnit = burnUnitCandidates[unitID]
			-- check if unit is valid
			if GetObjectExists(burnUnit) then
				-- if unit have selected debuff
				if burnUnit and burnUnit.buff and UnitBuffID(unit,burnUnit.buff) then
					coef = burnUnit.coef
				end
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
	local crowdControlUnit = crowdControlCandidates[unitID]
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
--if isLongTimeCCed("target") then
-- CCs with >=20 seconds
function isLongTimeCCed(Unit)
	if Unit == nil then return false end
	-- check if unit is valid
	if GetObjectExists(Unit) then
		for i = 1, #longTimeCC do
			--local checkCC=longTimeCC[i]
			if UnitDebuffID(Unit,longTimeCC[i]) ~= nil then
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
		for i = 1, #doNotTouchUnitCandidates do
			if doNotTouchUnitCandidates[i].unitID == 1 or doNotTouchUnitCandidates[i].unitID == unitID then
				if UnitBuffID(unit,doNotTouchUnitCandidates[i].buff) or UnitDebuffID(unit,doNotTouchUnitCandidates[i].buff) then
					return false
				end
			end
		end
	end
	-- if all went fine return true
	return true
end
-- returns true if target is shielded or should be avoided
function isShieldedTarget(unit)
	local coef = 0
	if getOptionCheck("Avoid Shields") then
		-- check if unit is valid
		if GetObjectExists(unit) then
			local unitID = GetObjectID(unit)
			local shieldedUnit = shieldedUnitCandidates[unitID]
			-- check if unit is valid
			if GetObjectExists(shieldedUnit) then
				-- if unit have selected debuff
				if shieldedUnit and shieldedUnit.buff and UnitBuffID(unit,shieldedUnit.buff) then
					-- if it's a frontal buff, see if we are in front of it
					if shieldedUnit.frontal ~= true or getFacing(unit,"player") == true then
						coef = shieldedUnit.coef
					end
				end
			end
		end
	end
	return coef
end

	-- Todo: So i think the prioritisation should be large by determined by threat or burn prio and then hp.
	-- So design should be,
	-- Check if the unit is on doNotTouchUnitCandidates list which means we should not attack them at all
	-- Check towards doNotTouchUnitCandidatesBuffs (buffs/debuff), ie target we are not allowed to attack due to them having
	-- a (de)buff that hurts us or not. Example http://www.wowhead.com/spell=163689
	-- Is the unit on burn list, set high prio, burn list is a list of mobs that we specify for burn, is highest dps and prio.
	-- We should then look at the threat situation, for tanks the this is of high prio if we are below 3 but all below 3
	-- should have the same prio coefficent. For dps its not that important
	-- Then we should check HP of the targets and set highest prio on low targets, this is also something we need to think
	-- about if the target have a dot so it will die regardless or not. Should have a timetodie?
	-- Stack: Interface\AddOns\BadRotations\System\EnemiesEngine.lua:224: in function `castInterrupt'
	-- isBurnTarget(unit) - Bool - True if we should burn that target according to burnUnitCandidates
	-- isSafeToAttack(unit) - Bool - True if we can attack target according to doNotTouchUnitCandidates
	-- getEnemies(unit,Radius) - Number - Returns number of valid units within radius of unit
	-- castInterrupt(spell,percent) - Multi-Target Interupts - for facing/in movements spells of all ranges.
	-- makeEnemiesTable(55) - Triggered in badboy.lua - generate the br.enemy
	--[[------------------------------------------------------------------------------------------------------------------]]
	--[[------------------------------------------------------------------------------------------------------------------]]
	--[[------------------------------------------------------------------------------------------------------------------]]
	--[[------------------------------------------------------------------------------------------------------------------]]
	--local LibDraw = LibStub("LibDraw-1.0")
-- ToDo: We need to think about if the target have a dot so it will die regardless or not. Should have a timetodie.
