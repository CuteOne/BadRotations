--[[---------------------------------------------------------------------------------------------------



-----------------------------------------Bubba's Healing Engine--------------------------------------]]
--Modified to enemies engine by fisker
if not metaTable2 then
	-- localizing the commonly used functions while inside loops
	local getDistance,tinsert,tremove,UnitGUID,UnitClass,UnitIsUnit = getDistance,tinsert,tremove,UnitGUID,UnitClass,UnitIsUnit
	local UnitDebuff,UnitExists,UnitHealth,UnitHealthMax = UnitDebuff,UnitExists,UnitHealth,UnitHealthMax
	local GetSpellInfo,GetTime,UnitDebuffID,getBuffStacks = GetSpellInfo,GetTime,UnitDebuffID,getBuffStacks
	br.enemiesv2 = {} -- This is our main Table that the world will see
	unitSetup = {} -- This is one of our MetaTables that will be the default user/contructor
	unitSetup.cache = {} -- This is for the cache Table to check against
	metaTable2 = {} -- This will be the MetaTable attached to our Main Table that the world will see
	metaTable2.__index =  {-- Setting the Metamethod of Index for our Main Table
		name = "Enemies Table",
		author = "Bubba",
	}
	-- Creating a default Unit to default to on a check
	unitSetup.__index = {
		name = "dangerousbeast",
		hp = 100,
		unit = "noob",
		guid = 0,
		guidsh = 0,
	}

	function unitSetup:new(unit)
		-- Seeing if we have already cached this unit before
		if unitSetup.cache[unit] then return false end
		local o = {}
		setmetatable(o, unitSetup)
		if unit and type(unit) == "string" then
			o.unit = unit
		end
		-- returns unit GUID
		function o:nGUID()
			local nShortHand = ""
			if GetUnitExists(unit) then
				targetGUID = ObjectGUID(unit)
				nShortHand = ObjectGUID(unit):sub(-5)
			end
			return targetGUID, nShortHand
		end
		-- sets actual position of unit in engine, shouldnt refresh more than once/sec
		function o:GetPosition()
			if GetUnitIsVisible(o.unit) then
				o.refresh = GetTime()
				local x,y,z = GetObjectPosition(o.unit)
				x = math.ceil(x*100)/100
				y = math.ceil(y*100)/100
				z = math.ceil(z*100)/100
				return x,y,z
			else
				return 0,0,0
			end
		end
		--Function time to die
		function o:unitTtd()
			if o.ttdRefresh == nil then o.ttdRefresh = GetTime() return 99 end
			if o.hpmissing == 0 then return 99
			else
				if o.hpmissinglast == nil then o.hpmissinglast = o.hpmissing end
				local diff = o.hpmissing - o.hpmissinglast
				local timeSinceLast = GetTime() - o.ttdRefresh
				local ttdDps = diff / timeSinceLast
				o.hpmissinglast = o.hpmissing
				o.ttdRefresh = GetTime()
				if ttdDps ~= 0 then return o.hpabs/ttdDps else return 99 end
			end
		end
		-- Updating the values of the Unit
		function o:UpdateUnit()
      -- assign Name of unit
      o.name = UnitName(o.unit)
      -- assign real GUID of unit and Short GUID of unit for the SetupTable
      o.guid, o.guidsh = o:nGUID()
      -- distance to player
      --o.distance = getDistance("player",o.unit)
      -- Unit's threat situation(1-4)
      --o.threat = UnitThreatSituation("player", o.unit)
      -- Unit HP absolute
      --o.hpabs = ObjectDescriptor(o.unit, GetOffset("CGUnitData__Health"), Types.Int)
			-- Unit max HP
			--o.hpmax = ObjectDescriptor(o.unit, GetOffset("CGUnitData__MaxHealth"), Types.Int)
			-- Unit HP missing absolute
			--o.hpmissing = o.hpmax - o.hpabs
      -- Unit HP and Absorb
      --o.hp = o.hpabs / o.hpmax * 100
			-- Is valid unit
			if o.validUnitRefresh == nil or o.validUnitRefresh < GetTime() - 0.5 then
				o.isValidUnit = isValidUnit(o.unit)
				o.validUnitRefresh = GetTime()
			end
			-- Unit in combat
			--o.inCombat = UnitAffectingCombat(o.unit)
			-- Unit is boss
			--o.boss = isBoss(o.unit)
			-- EnemyListCheck
			if o.enemyRefresh == nil or o.enemyRefresh < GetTime() - 1 then
				o.enemyListCheck = enemyListCheck(o.unit)
				o.enemyRefresh = GetTime()
			end
			-- Is unit pet
			--o.isPet = ObjectCreator(o.unit) == GetObjectWithGUID(UnitGUID("player"))
			-- TTD
			-- if o.ttdRefresh == nil or o.ttdRefresh < GetTime() - 2 then
			-- 	o.ttd = o:unitTtd()
			-- end
			-- add unit to setup cache
			unitSetup.cache[o.unit] = o -- Add unit to SetupTable
		end
		-- Adding the user and functions we just created to this cached version in case we need it again
		-- This will also serve as a good check for if the unit is already in the table easily
		unitSetup.cache[o.unit] = o
		return o
	end
	-- Setting up the tables on either Wipe or Initial Setup
	function SetupEnemyTables() -- Creating the cache (we use this to check if some1 is already in the table)
		setmetatable(br.enemiesv2, metaTable2) -- Set the metaTable of Main to Meta
		function br.enemiesv2:Update()
			br.enemiesv2TableTimer = GetTime()
			local i=1
			while i <= #br.enemiesv2 do
				if not GetUnitIsVisible(br.enemiesv2[i].unit) or getDistance(br.enemiesv2[i].unit) > 50 then
					for j,v in pairs(unitSetup.cache) do
						if br.enemiesv2[i].unit == j then
							unitSetup.cache[j] = nil
						end
					end
					tremove(br.enemiesv2, i)
				else
					br.enemiesv2[i]:UpdateUnit()
					i = i + 1
				end
			end
			-- table.sort(br.enemiesv2, function(x,y)
			-- 	return x.distance < y.distance
			-- end)
		end
	end
	-- We are setting up the Tables for the first time
	SetupEnemyTables()
end
