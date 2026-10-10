local _, br = ...
br.engines.healingEngineFunctions = br.engines.healingEngineFunctions or {}
local healingEngineFunctions = br.engines.healingEngineFunctions

-- here we want to define functions to use with the healing profiles
-- find tanks
function healingEngineFunctions:getTanksTable()
	local tanksTable = {}
	for i = 1, #br.engines.healingEngine.friend do
		if br.engines.healingEngine.friend[i] then
			if br.engines.healingEngine.friend[i].role == "TANK" then
				br._G.tinsert(tanksTable, br.engines.healingEngine.friend[i])
			end
		end
	end
	-- We are sorting by Health first
	table.sort(tanksTable, function(x,y)
		return x.hp < y.hp
	end)
	return tanksTable
end
-- function to define range between players in tables.
function healingEngineFunctions:getNovaDistance(Unit1,Unit2)
	-- if we are comparing same unit return 0
	if Unit1.guid == Unit2.guid then
		return 0
			-- elseif unit 2 is valid (we have unit one valid check up before entering here)
	elseif Unit2 then
		local X1,Y1,Z1 = Unit1.x,Unit1.y,Unit1.z
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
-- now that we have our units in br.engines.healingEngine.friend with their positions, we can compare them to our enemies
-- we will send them as object args to our distance functions... since both engines have x and y, we will be able to mix them up
function healingEngineFunctions:getUnitsToHealAround(UnitID,radius,health,count)
	-- if we provide an unitID, we get this units location once
	local X1,Y1,Z1 = 0,0,0
	-- if an unit of type string is passed we consider it as a UnitID
	if type(UnitID) == "string" then
		X1,Y1,Z1 = br.functions.unit:GetObjectPosition(UnitID)
		-- if we provide it a table, take that object position(accepts br.engines.enemiesEngine.enemy[i] or br.engines.healingEngine.friend[i])
	elseif UnitID and UnitID.x ~= 0 then
		X1,Y1,Z1 = UnitID.x,UnitID.y,UnitID.z
	end
	local unit = {x = X1,y = Y1,z = Z1,guid = br._G.UnitGUID(UnitID),name = br._G.UnitName(UnitID)}
	-- once we get our unit location we call our getdistance
	local lowHealthCandidates = {}
	for i = 1, #br.engines.healingEngine.friend do
		local thisUnit = br.engines.healingEngine.friend[i]
		-- if in given radius
		if thisUnit.hp <= health and br.engines.healingEngineFunctions:getNovaDistance(unit,thisUnit) < radius then
			-- if its first item in table, insert
			if #lowHealthCandidates == 0 then
				br._G.tinsert(lowHealthCandidates, 1, {hp = thisUnit.hp,x = thisUnit.x,y = thisUnit.y,z = thisUnit.z,name = thisUnit.name,guid = thisUnit.guid})
				-- else compare and place our item at the right position in our table
			else
				-- scan from last to first and if higher just break out
				local lowHealthUnitsCount = #lowHealthCandidates
				-- local placedInTable = false
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
					br._G.tinsert(lowHealthCandidates, bestPosition, {hp = thisUnit.hp,x = thisUnit.x,y = thisUnit.y,z = thisUnit.z,name = thisUnit.name,guid = thisUnit.guid})
				elseif lowHealthUnitsCount < count then
					br._G.tinsert(lowHealthCandidates, lowHealthUnitsCount+1, {hp = thisUnit.hp,x = thisUnit.x,y = thisUnit.y,z = thisUnit.z,name = thisUnit.name,guid = thisUnit.guid})
				end
				if #lowHealthCandidates > count then
					br._G.tremove(lowHealthCandidates) -- drop the highest-health candidate past the count
				end
			end
		end
	end
	lowHealthCandidates[0] = { unit = UnitID, coef = br.engines.healingEngineFunctions:getLowHealthCoeficient(lowHealthCandidates) }
	return lowHealthCandidates
end

-- returns coefficient of low health units around another unit
function healingEngineFunctions:getLowHealthCoeficient(lowHealthCandidates)
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
function healingEngineFunctions:getAllies(Unit,Radius)
	local alliesTable = {}
	for i=1,#br.engines.healingEngine.friend do
		if not br.functions.unit:GetUnitIsDeadOrGhost(br.engines.healingEngine.friend[i].unit) then
			if br.functions.range:getDistance(Unit,br.engines.healingEngine.friend[i].unit) <= Radius then
				br._G.tinsert(alliesTable,br.engines.healingEngine.friend[i])
			end
		end
	end
	return alliesTable
end
function healingEngineFunctions:inLoSHealer()
	local function drawHealers(healer)
		local LibDraw 					= br._G.LibStub("LibDraw-BR")
		-- local facing 					= br.functions.unit:GetObjectFacing("player")
		local playerX, playerY, playerZ = br.functions.unit:GetObjectPosition("player")
		-- local locateX, locateY, locateZ = br.functions.unit:GetObjectPosition(healer)
		local healerX, healerY, healerZ = br.functions.unit:GetObjectPosition(healer)
		if br.functions.misc:getLineOfSight("player",healer) then
			LibDraw.SetColor(0, 255, 0)
		else
			LibDraw.SetColor(255, 0, 0)
		end
		return LibDraw.Line(playerX, playerY, playerZ, healerX, healerY, healerZ)
	end
	for i = 1, #br.engines.healingEngine.friend do
		local thisUnit = br.engines.healingEngine.friend[i].unit
		if not br.functions.unit:GetUnitIsUnit(thisUnit,"player") and br._G.UnitGroupRolesAssigned(thisUnit) == "HEALER" then
			drawHealers(thisUnit)
		end
	end
end


function healingEngineFunctions:isInside(x,y,ax,ay,bx,by,dx,dy)
	local bax = bx - ax
	local bay = by - ay
	local dax = dx - ax
	local day = dy - ay
	if (x == nil or y == nil) then return false end
	if ((x - ax) * bax + (y - ay) * bay <= 0.0) then return false end
	if ((x - bx) * bax + (y - by) * bay >= 0.0) then return false end
	if ((x - ax) * dax + (y - ay) * day <= 0.0) then return false end
	if ((x - dx) * dax + (y - dy) * day >= 0.0) then return false end

	return true
end

function healingEngineFunctions:getUnitsInRect(width,length, showLines, hp)
	local LibDraw = br._G.LibStub("LibDraw-BR")
	local playerX, playerY, playerZ = br.functions.unit:GetObjectPosition("player")
	local facing = br.functions.unit:GetObjectFacing("player")
	-- Near Left
	local nlX, nlY, nlZ = br._G.GetPositionFromPosition(playerX, playerY, playerZ, width/2, facing + math.rad(90), 0)
	-- Near Right
	local nrX, nrY, nrZ = br._G.GetPositionFromPosition(playerX, playerY, playerZ, width/2, facing + math.rad(270), 0)
	-- Far Left
	local flX, flY, flZ = br._G.GetPositionFromPosition(nlX, nlY, nlZ, length, facing + math.rad(0), 0)
	-- Far Right
	local frX, frY, frZ = br._G.GetPositionFromPosition(nrX, nrY, nrZ, length, facing + math.rad(0), 0)


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
	_G.table.wipe(UnitsInRect)
	for i = 1, #br.engines.healingEngine.friend do
		local thisUnit = br.engines.healingEngine.friend[i]
		if br.functions.unit:GetUnitExists(thisUnit.unit) and thisUnit.hp <= hp and not br.functions.unit:GetUnitIsDeadOrGhost(thisUnit.unit) then
			local tX, tY = thisUnit.x, thisUnit.y
			if tX and tY then
				if br.engines.healingEngineFunctions:isInside(tX,tY,nlX,nlY,nrX,nrY,frX,frY) then
					if showLines then
						LibDraw.Circle(tX, tY, playerZ, br._G.UnitBoundingRadius(thisUnit.unit))
					end
					unitCounter = unitCounter + 1
					table.insert(UnitsInRect,thisUnit)
				end
			end
		end
	end
	return unitCounter, UnitsInRect
end

function healingEngineFunctions:getAngles(X1,Y1,Z1,X2,Y2,Z2)
	return math.atan2(Y2-Y1,X2-X1)
end

-- <summary>
-- Ground cast a spell at the provided location. Implements the cast and the mouse click.
-- </summary>
-- <param name="loc">location to cast at: {x,y,z}</param>
-- <param name="SpellID">ID of spell to ground cast</param>
-- <returns>Returns if successfully tried to cast</returns>
function healingEngineFunctions:castGroundAtLocation(loc, SpellID)
    br._G.CastSpellByName(br.api.wow.GetSpellInfo(SpellID))
    --local mouselookup = IsMouseButtonDown(2)
	--MouselookStop()
	local px,py,pz = br._G.ObjectPosition("player")
	local hit1x,hit1y,hit1z = br._G.TraceLine(loc.x, loc.y, loc.z+5, loc.x, loc.y, loc.z-5, 0x110) -- Raytrace correct z, Terrain and WMO hit
	if hit1z ~= nil and
		br._G.TraceLine(px, py, pz+2, loc.x, loc.y, loc.z+1, 0x100010) == nil and
		br._G.TraceLine(loc.x, loc.y, loc.z+4, loc.x, loc.y, loc.z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 colissions and check no m2 on hook location
		if br._G.SpellIsTargeting() then
			br._G.ClickPosition(loc.x,loc.y,hit1z)
		end
		--if mouselookup then MouselookStart() end
		if br._G.SpellIsTargeting() then
			br._G.SpellStopTargeting()
			br.functions.misc:addonDebug("Canceling Spell", true)
		end
		return true
	end
end
