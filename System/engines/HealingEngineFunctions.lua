-- here we want to define functions to use with the healing profiles
-- find best tank to put our lb/beacon/earth shield on
function getFocusedTank()
	local tanks = getTanksTable()
	-- if we are targetting a mob and its targetting a tank we want to define which tank it is.
	if #tanks > 0 and GetUnitExists("target") and GetUnitIsVisible("target") and GetUnitExists("targettarget")
		and GetUnitIsVisible("targettarget") then
		local targetTargetGUID = UnitGUID("targettarget")
		for i = 1,#tanks do
			if tanks[i].guid == targetTargetGUID then
				oldTank = tanks[i]
				return tanks[i]
			end
		end
	elseif #tanks > 0 then
		-- otherwise we want to see which tank is beign targetted by its mob and whos threat is highest
		for i = 1,#tanks do
			--Print(UnitGUID(tanks[i].target)..""..tanks[i].guid)
			if UnitGUID(tanks[i].target) == tanks[i].guid then
				-- mob is on this unit
				oldTank = tanks[i]
				return tanks[i]
			end
		end
	else
		--Print(":( no tanks")
	end
end
-- find tanks
function getTanksTable()
	local tanksTable = {}
	for i = 1, #br.friend do
		if br.friend[i].role == "TANK" then
			tinsert(tanksTable, br.friend[i])
		end
	end
	-- We are sorting by Health first
	table.sort(tanksTable, function(x,y)
		return x.hp < y.hp
	end)
	return tanksTable
end
-- we want to define an iteration that will compare allies to heal in range of enemies or allies
function castWiseAoEHeal(unitTable,spell,radius,health,minCount,maxCount,facingCheck,movementCheck)
	if movementCheck ~= true or not isMoving("player") then
		local bestCandidate = nil
		-- find best candidate with list of units
		for i = 1, #unitTable do
			-- added a visible check as its not in healing engine.
			if (GetUnitIsVisible(unitTable[i].unit) and (facingCheck ~= true or getFacing("player",unitTable[i].unit)) or GetUnitIsUnit(unitTable[i].unit,"player")) then
				local candidate = getUnitsToHealAround(unitTable[i].unit,radius,health,maxCount)
				if bestCandidate == nil or bestCandidate[0].coef > candidate[0].coef then
					bestCandidate = candidate
				end
			end
		end
		-- if we meet count minimum then we cast
		if bestCandidate ~= nil and #bestCandidate >= minCount and getLineOfSight("player",bestCandidate[0].unit) and getDistance("player",bestCandidate[0].unit) <= 40 then
			-- here we would like instead to cast on unit
			if castSpell(bestCandidate[0].unit,spell,facingCheck,movementCheck) then
				if IsAoEPending() then SpellStopTargeting() br.addonDebug("Canceling Spell", true) end
				return true
			end
		end
	end
	return false
end
-- function to define range between players in tables.
function getNovaDistance(Unit1,Unit2)
	-- if we are comparing same unit return 0
	if Unit1.guid == Unit2.guid then
		return 0
			-- elseif unit 2 is valid (we have unit one valid check up before entering here)
	elseif Unit2 then
		local X1,Y1,Z1 = Unit1.x,Unit1.y,Unit2.z
		local X2,Y2,Z2 = Unit2.x,Unit2.y,Unit2.z
		-- return distance between two users
		if X1 ~= nil and X2 ~= nil and Y1 ~= nil and Y2 ~= nil and Z1 ~= nil and Z2 ~= nil then
			return math.sqrt(((X2-X1)^2)+((Y2-Y1)^2)+((Z2-Z1)^2))
		else
			return 1000
		end
	else
		return 1000
	end
end
-- now that we have our units in br.friend with their positions, we can compare them to our enemies
-- we will send them as object args to our distance functions... since both engines have x and y, we will be able to mix them up
function getUnitsToHealAround(UnitID,radius,health,count)
	-- if we provide an unitID, we get this units location once
	local X1,Y1,Z1 = 0,0,0
	-- if an unit of type string is passed we consider it as a UnitID
	if type(UnitID) == "string" then
		X1,Y1,Z1 = GetObjectPosition(UnitID)
		-- if we provide it a table, take that object position(accepts br.enemy[i] or br.friend[i])
	elseif UnitID and UnitID.x ~= 0 then
		X1,Y1,Z1 = UnitID.x,UnitID.y,UnitID.z
	end
	local unit = {x = X1,y = Y1,z = Z1,guid = UnitGUID(UnitID),name = UnitName(UnitID)}
	-- once we get our unit location we call our getdistance
	local lowHealthCandidates = {}
	for i = 1, #br.friend do
		local thisUnit = br.friend[i]
		-- if in given radius
		if thisUnit.hp <= health and getNovaDistance(unit,thisUnit) < radius then
			-- if its first item in table, insert
			if #lowHealthCandidates == 0 then
				tinsert(lowHealthCandidates, 1, {hp = thisUnit.hp,x = thisUnit.x,y = thisUnit.y,z = thisUnit.z,name = thisUnit.name,guid = thisUnit.guid})
				-- else compare and place our item at the right position in our table
			else
				-- scan from last to first and if higher just break out
				local lowHealthUnitsCount = #lowHealthCandidates
				local placedInTable = false
				local bestPosition = 0
				if lowHealthUnitsCount > 0 then
					for j = lowHealthUnitsCount,1,-1 do
						if thisUnit.hp < lowHealthCandidates[j].hp then
							bestPosition = j
						else
							break
						end
					end
				end
				if bestPosition ~= 0 then
					tinsert(lowHealthCandidates, bestPosition, {hp = thisUnit.hp,x = thisUnit.x,y = thisUnit.y,z = thisUnit.z,name = thisUnit.name,guid = thisUnit.guid})
				elseif lowHealthUnitsCount < count then
					tinsert(lowHealthCandidates, lowHealthUnitsCount+1, {hp = thisUnit.hp,x = thisUnit.x,y = thisUnit.y,z = thisUnit.z,name = thisUnit.name,guid = thisUnit.guid})
				end
				if #lowHealthCandidates > count then
					tremove(lowHealthCandidates[lowHealthUnitsCount])
				end
			end
		end
	end
	lowHealthCandidates[0] = { unit = UnitID, coef = getLowHealthCoeficient(lowHealthCandidates) }
	return lowHealthCandidates
end

totalUnits = {}
local startUnit
local currentJump 
local jumpFound = true
local function chainJumps(unit,hp,range)
	for i = 1, #br.friend do
		local newUnit = br.friend[i]
		local unitFound = false
		if newUnit.hp <= hp and newUnit.guid ~= unit.guid and getNovaDistance(unit,newUnit) <= range then
			for j = 1, #totalUnits do
				if totalUnits[j].guid == newUnit.guid then
					unitFound = true
				end
			end
			if unitFound == false then
				currentJump = newUnit
				tinsert(totalUnits, #totalUnits+1, {guid = newUnit.guid})
				return 
			end
		end
	end
	jumpFound = false
end


function chainHealUnits(spell,range,hp,count)
	jumpFound = true
	for i = 1, #br.friend do
		local thisUnit = br.friend[i]
		if thisUnit.hp <= hp then
			startUnit = thisUnit.unit
			currentJump = thisUnit
			tinsert(totalUnits, #totalUnits+1, {guid = thisUnit.guid})
			while #totalUnits < count and jumpFound do
				chainJumps(currentJump,hp,range)
			end
			if #totalUnits < count then
				totalUnits = {}
			elseif #totalUnits >= count then
				totalUnits= {}
				if castSpell(startUnit,spell,false,true) then
					return true 
				end
			end
		end
	end
end

-- returns coefficient of low health units around another unit
function getLowHealthCoeficient(lowHealthCandidates)
	local tableCoef = 0
	local lowHealthCount = #lowHealthCandidates
	-- if critical status, add it more coef
	for i = 1, lowHealthCount do
		local candidate = lowHealthCandidates[i]
		if candidate.hp < 30 then
			tableCoef = tableCoef + 1.5*(100-candidate.hp)
		else
			tableCoef = tableCoef + (100-candidate.hp)
		end
	end
	return tableCoef
end
-- old design with so many objectmanager queries it was wrong.
-- if getAllies("player",40) > 5 then
function getAllies(Unit,Radius)
	local alliesTable = {}
	for i=1,#br.friend do
		if not UnitIsDeadOrGhost(br.friend[i].unit) then
			if getDistance(Unit,br.friend[i].unit) <= Radius then
				tinsert(alliesTable,br.friend[i])
			end
		end
	end
	return alliesTable
end
-- if getAlliesInLocation("player",X,Y,Z) > 5 then
function getAlliesInLocation(myX,myY,myZ,Radius)
	local alliesTable = {}
	for i=1,#br.friend do
		if not UnitIsDeadOrGhost(br.friend[i].unit) then
			if getDistanceToObject(br.friend[i].unit,myX,myY,myZ) <= Radius then
				tinsert(alliesTable,br.friend[i].unit)
			end
		end
	end
	return alliesTable
end
--We check if unit has a badly debuff thats need a personal CD to survive or reduce damage
--Todo check for more details for example how much damage are we going to take and whats the best spell to use.
--For example we can check if we are going to die or not.
function isBadlyDeBuffed(Unit)
	if Unit == nil then
		return false
	end

	for i=1,#novaEngineTables.BadlyDeBuffed do
		if UnitDebuffID(Unit,novaEngineTables.BadlyDeBuffed[i])~=nil then
			return true
		end
	end
	return false
end

function inLoSHealer()
	local function drawHealers(healer)
		local LibDraw 					= LibStub("LibDraw-1.0")
		local facing 					= ObjectFacing("player")
		local playerX, playerY, playerZ = GetObjectPosition("player")
		local locateX, locateY, locateZ = GetObjectPosition(healer)
		local healerX, healerY, healerZ = GetObjectPosition(healer)
		if getLineOfSight("player",healer) then
			LibDraw.SetColor(0, 255, 0)
		else
			LibDraw.SetColor(255, 0, 0)
		end
		return LibDraw.Line(playerX, playerY, playerZ, healerX, healerY, healerZ)
	end
	for i = 1, #br.friend do
		local thisUnit = br.friend[i].unit
		if not GetUnitIsUnit(thisUnit,"player") and  UnitGroupRolesAssigned(thisUnit) == "HEALER" then
			drawHealers(thisUnit)
		end
	end
end


function isInside(x,y,ax,ay,bx,by,dx,dy)
	local bax = bx - ax
	local bay = by - ay
	local dax = dx - ax
	local day = dy - ay

	if ((x - ax) * bax + (y - ay) * bay <= 0.0) then return false end
	if ((x - bx) * bax + (y - by) * bay >= 0.0) then return false end
	if ((x - ax) * dax + (y - ay) * day <= 0.0) then return false end
	if ((x - dx) * dax + (y - dy) * day >= 0.0) then return false end

	return true
end

function getUnitsInRect(width,length, showLines, hp)
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

	local unitCounter = 0
	local UnitsInRect = {}
	table.wipe(UnitsInRect)
	for i = 1, #br.friend do
		local thisUnit = br.friend[i]
		if GetUnitExists(thisUnit.unit) and thisUnit.hp <= hp and not UnitIsDeadOrGhost(thisUnit.unit) then
			local tX, tY = thisUnit.x, thisUnit.y
			if tX and tY then
				if isInside(tX,tY,nlX,nlY,nrX,nrY,frX,frY) then
					if showLines then
						LibDraw.Circle(tX, tY, playerZ, UnitBoundingRadius(thisUnit.unit))
					end
					unitCounter = unitCounter + 1
					table.insert(UnitsInRect,thisUnit)
				end
			end
		end
	end
	return unitCounter, UnitsInRect
end

function getAngles(X1,Y1,Z1,X2,Y2,Z2)
	return math.atan2(Y2-Y1,X2-X1)
end

function getUnitsInCone(length,angle,hp)
    local playerX, playerY, playerZ = GetObjectPosition("player")
    local facing = ObjectFacing("player")
    local units = {};

    for i = 1, #br.friend do
        local thisUnit = br.friend[i].unit
		if thisUnit.hp <= hp then
			if br.friend[i].distance <= Length then			
		        if not GetUnitIsUnit(thisUnit,"player") and (isDummy(thisUnit) or GetUnitIsFriend(thisUnit,"player")) then
		            local unitX, unitY, unitZ = GetObjectPosition(thisUnit)
		            if playerX and unitX then
		                local angleToUnit = getAngles(playerX,playerY,playerZ,unitX,unitY,unitZ)
		                local angleDifference = facing > angleToUnit and facing - angleToUnit or angleToUnit - facing
		                local shortestAngle = angleDifference < math.pi and angleDifference or math.pi*2 - angleDifference
		                local finalAngle = shortestAngle/math.pi*180
		                if finalAngle < angle then
		                    table.insert(units, thisUnit)
		                end
		            end
		        end
		    end
		end
    end
    return units
end

function healConeAround(numUnitsp, healthp, anglep, rangeInfrontp, rangeAroundp)
    local total         = 0
    local numUnits        = tonumber(numUnitsp)
    local health        = tonumber(healthp)
    local angle         = tonumber(anglep)
    local rinfront         = tonumber(rangeInfrontp)
    local raround       = tonumber(rangeAroundp)
    local playerX, playerY, playerZ     = GetObjectPosition('player')
    local facing         = GetObjectFacing("player")
    
    for i=1,#br.friend do
	local thisUnit = br.friend[i].unit
        if br.friend[i].hp < health then 
            -- First check around us, light of dawn do heal 5 yards around
            if br.friend[i].distance < raround then
                total = total +1
            else --dont doubledipp so an else
            	if br.friend[i].distance < rinfront then --only if they are in range
	            	local unitX, unitY, unitZ = GetObjectPosition(thisUnit)
	            	if playerX and unitX then
	                	local angleToUnit = getAngles(playerX,playerY,playerZ,unitX,unitY,unitZ)
	                	local angleDifference = facing > angleToUnit and facing - angleToUnit or angleToUnit - facing
	                	local shortestAngle = angleDifference < math.pi and angleDifference or math.pi*2 - angleDifference
	                	local finalAngle = shortestAngle/math.pi*180
	                	if finalAngle < angle then
	                		total = total + 1
	                	end
	            	end
	        	end
            end
        end
    end
   	if total >= numUnits then
        return true
    end
    return false
end

-- <summary>
-- Calculate the factorial of a non-negative integer
-- </summary>
-- <param name="n">number to calculate the factorial of</param>
-- <returns>Returns factorial of the integer n</returns>
function Factorial(n)
	if n < 0 then return nil end
	if n >= 2 then return n * Factorial(n - 1) end
	return 1
end

-- <summary>
-- Get all possible unique combinations of choosing n points (x,y,z positions) from a list of points, order independent.
-- ***BE CAREFUL*** with this one. It's recursive, and if you pass in too big a table, it will take a long time to process.
-- recommend tables no bigger than 12 for now (may change as I test further)
-- </summary>
-- <param name="points">table of points to consider (the domain) Looks like: {{x1,y1,z1},{x2,y2,z2},{x3,y3,z3}...}</param>
-- <param name="choose">the minimum number of points to choose from the table for each combination</param>
-- <returns>Returns a table containing all possible unique combinations</returns>
function GetCombinations(points, choose)
	function fOfN(n, src, got, all)
		function tableConcat(t1,t2)
		    local t3 = {}
		    for i=1,#t1 do
		        t3[i] = t1[i]
		    end
		    for i=1,#t2 do
		        t3[#t3+1] = t2[i]
		    end
		    return t3
		end
		function tableSlice(tbl, first)
		  local sliced = {}
		  for i = first, #tbl do
		    sliced[#sliced+1] = tbl[i]
		  end
		  return sliced
		end
	    if n == 0 then
	        if #got > 0 then
	            all[#all+1] = got
	        end
	    end
	    for j = 1, #src do
	        fOfN(n-1, tableSlice(src, j+1), tableConcat(got, {src[j]}), all);
	    end
	end
    all = {}
    for i = choose, #points do
        fOfN(i, points, {}, all);
    end
    --table.insert(all,a)
    return all;
end


-- <summary>
-- Get the distance from an x,y,z point to the nearest member of a table of x,y,z points
-- </summary>
-- <param name="p">point to check distance from</param>
-- <param name="points">table of x,y,z points to check distances against</param>
-- <returns>Returns the distance to the closest x,y,z in the table</returns>
function GetDistanceToClosestNeighbor(p,points)
	local minDist = 999
	if p ~= nil and p.x ~= nil and p.y ~= nil and p.z ~= nil then 
		for i=1,#points do
			local p1 = points[i]
			if p1.x ~= nil and p1.y ~= nil and p1.z ~= nil then
				local dist = math.sqrt(((p1.x-p.x)^2)+((p1.y-p.y)^2)+((p1.z-p.z)^2))
				if dist < minDist then minDist = dist end
			end
		end
	end
	return minDist
end

-- <summary>
-- calculates how many of a table of points is within a circle on the ground
-- </summary>
-- <param name="center">Center of the circle</param>
-- <param name="radius">radius of the circle</param>
-- <param name="points">List of points to check</param>
-- <returns>Returns the number of points inside the circle</returns>
function GetNumPointsInCircle(center,radius,points)
	if points == nil or #points < 1 then return 0 end
	local count = 0
	if center ~= nil and center.x ~= nil and center.y ~= nil and center.z ~= nil then 
		for i=1,#points do
			local p1 = points[i]
			if p1.x ~= nil and p1.y ~= nil and p1.z ~= nil then
				local dist = math.sqrt(((p1.x-center.x)^2)+((p1.y-center.y)^2)+((p1.z-center.z)^2))
				if dist <= radius then count = count + 1 end
			end
		end
	end
	return count
end

-- <summary>
-- Calculates the geometric center of a table of points. This is useful for casting a spell on the ground at the center of a group of targets
-- </summary>
-- <param name="points">table of points</param>
-- <returns>Returns the centroid of the points</returns>
function GetCentroidOfPoints(points)
	if points == nil then return nil end
	if #points < 1 then return nil end
	if #points == 1 then return points[i] end
	
	local maxX = 0
	local maxY = 0
	local maxZ = 0

	for i =1, #points do
		maxX = maxX + points[i].x
		maxY = maxY + points[i].y
		maxZ = maxZ + points[i].z
	end

	local centerPoint = {}
	centerPoint.x = maxX/#points
	centerPoint.y = maxY/#points
	centerPoint.z = maxZ/#points
	return centerPoint
	-- local minX = points[1].x
	-- local minY = points[1].y
	-- local minZ = points[1].z
	-- local maxX = points[1].x
	-- local maxY = points[1].y
	-- local maxZ = points[1].z

	-- for i=2,#points do
	-- 	local p = points[i]
	-- 	if p.x < minX then minX = p.x end
	-- 	if p.y < minY then minY = p.y end
	-- 	if p.z < minZ then minZ = p.z end
	-- 	if p.x > minX then maxX = p.x end
	-- 	if p.y > minY then maxY = p.y end
	-- 	if p.z > minZ then maxZ = p.z end
	-- end
	-- local centerPoint = {}
	-- centerPoint.x = minX + ((maxX - minX) / 2)
	-- centerPoint.y = minY + ((maxY - minY) / 2)
	-- centerPoint.z = minZ + ((maxZ - minZ) / 2)
	-- return centerPoint
end

-- <summary>
-- Ground cast a spell at the provided location. Implements the cast and the mouse click.
-- </summary>
-- <param name="loc">location to cast at: {x,y,z}</param>
-- <param name="SpellID">ID of spell to ground cast</param>
-- <returns>Returns if successfully tried to cast</returns>
function castGroundAtLocation(loc, SpellID)
    CastSpellByName(GetSpellInfo(SpellID))
    --local mouselookup = IsMouseButtonDown(2)
	--MouselookStop()
	local px,py,pz = ObjectPosition("player")
	loc.z = select(3,TraceLine(loc.x, loc.y, loc.z+5, loc.x, loc.y, loc.z-5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
	if loc.z ~= nil and TraceLine(px, py, pz+2, loc.x, loc.y, loc.z+1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z+4, loc.x, loc.y, loc.z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 colissions and check no m2 on hook location
		if SpellIsTargeting() then
			ClickPosition(loc.x,loc.y,loc.z)
		end
		--if mouselookup then MouselookStart() end
    	if SpellIsTargeting() then SpellStopTargeting() br.addonDebug("Canceling Spell", true) end
		return true
	end
end

-- <summary>
-- Given a table of units, find the best location for a circle that will encompass the highest number of those units
-- </summary>
-- <param name="unitTable">table of units to consider</param>
-- <param name="minTargets">Minimum number of units that must be inside the circle</param>
-- <param name="radius">radius of the circle</param>
-- <returns>Returns the center {x,y,z} of the circle if at least minTargets are within the circle, otherwise returns nil</returns>
function getBestGroundCircleLocation(unitTable,minTargets,maxHealTargets,radius)
	if unitTable == nil then print("getBestGround: unitTable is nil") end
	if minTargets == nil then print("getBestGround: minTargets is nil") end
	if #unitTable < minTargets then return nil end
	local startTime = debugprofilestop()
	local points = {}          -- table of points (x,y,z positions)
	local X1,Y1,Z1 = 0,0,0
	for i=1,#unitTable do
		local thisUnit = unitTable[i].unit
		-- get the x,y,z position for this Unit
		if type(thisUnit) == "string" then
			X1,Y1,Z1 = GetObjectPosition(thisUnit)
			-- if we provide it a table, take that object position(accepts br.enemy[i] or br.friend[i])
		elseif thisUnit and thisUnit.x ~= 0 then
			X1,Y1,Z1 = thisUnit.x,thisUnit.y,thisUnit.z
		end
		-- add the x,y,z position for this unit to our local points table
		local p = {}
		p.x = X1
		p.y = Y1
		p.z = Z1
		tinsert(points,p)
	end
    -- first, eliminate solo outliers
    -- any unit that is more than 'radius*2' distance from every other unit can be excluded
    local pointsInRange = {}
    for i=1,#points do
    	if GetDistanceToClosestNeighbor(points[i],points) <= 2 * radius then
    		tinsert(pointsInRange,points[i])
    	end
    end
    if #pointsInRange < minTargets then return nil end
    -- check the remaining units. If they are all (or all but 1) inside the circle centered on the whole group, then we have the best solution
	local center = GetCentroidOfPoints(pointsInRange)
	if center == nil then return nil end
	local numInside = GetNumPointsInCircle(center,radius,pointsInRange)
	local X1,Y1,Z1 = GetObjectPosition("player")
	local X2,Y2,Z2 = center.x,center.y,center.z
	local LoS = TraceLine(X1, Y1, Z1 + 2, X2, Y2, Z2 + 2, 0x10) == nil
	local distance = getDistanceToObject("player",X2,Y2,Z2) <= 40
    if (numInside >= #points - 1) and (numInside >= minTargets) and LoS and distance then return center end

    -- start with taking #pointsInRange, #pointsInRange-1 at a time
    -- then take #pointsInRange, #pointsInRange-2 at a time
    -- then #pointsInRange-3 at a time, etc.
    -- while #pointsInRange-n is >= minTargets
    -- keeping track of the best (largest) fully contained cluster of points as we go
    local bestGroup = nil
    local bestGroupSize = 0

    -- start with a grouping size of #pointsInRange - 1
    local groupSize = #pointsInRange - 1
    if groupSize > maxHealTargets then
    	groupSize = maxHealTargets
    end
    while groupSize >= minTargets do
    	local allCombinations = GetCombinations(pointsInRange,groupSize)
    	for i=1, #allCombinations do
    		-- get the centroid of this list of points
			local c = GetCentroidOfPoints(allCombinations[i])
			if c == nil then return nil end
			local tx,ty,tz = c.x,c.y,c.z
			local LoS = TraceLine(X1, Y1, Z1 + 2, tx, ty, tz + 2, 0x10) == nil
			local tdistance = getDistanceToObject("player",tx,ty,tz) <= 40
			if LoS and tdistance then
				-- how many of the points are inside the circle?
				local n = GetNumPointsInCircle(c,radius,allCombinations[i])
				-- if we got a whole group inside the circle, we can stop here
				if n >= groupSize then
					-- Logging.WriteDebug("GetBestCircleLocation(): Found Whole Group Solution for " + n.ToString() + " points");
					return c
				end

				-- is this result better than our best so far?
				if n > bestGroupSize then
					-- update best group
					bestGroup = allCombinations[i]
					bestGroupSize = n
				end
			end
        end
        -- decrement group size for next loop
        groupSize = groupSize - 1
    end
	-- return the geocenter of the best grouping
    return GetCentroidOfPoints(bestGroup)
end