-----------------------------------------Bubba's Healing Engine--------------------------------------]]
--Modified to enemies engine by fisker
if not metaTable2 then
	-- localizing the commonly used functions while inside loops
	local getDistance,tinsert,tremove,UnitGUID,UnitClass,GetUnitIsUnit = getDistance,tinsert,tremove,UnitGUID,UnitClass,GetUnitIsUnit
	local UnitDebuff,UnitExists = UnitDebuff,UnitExists
	local GetSpellInfo,GetTime,UnitDebuffID,getBuffStacks = GetSpellInfo,GetTime,UnitDebuffID,getBuffStacks
	br.om = {} -- This is our main Table that the world will see
	br.ttd = {} -- Time to die table
	br.unitSetup = {} -- This is one of our MetaTables that will be the default user/contructor
	br.unitSetup.cache = {} -- This is for the cache Table to check against
	metaTable2 = {} -- This will be the MetaTable attached to our Main Table that the world will see
	metaTable2.__index =  {-- Setting the Metamethod of Index for our Main Table
		name = "Enemies Table",
		author = "Bubba",
	}
	-- Creating a default Unit to default to on a check
	br.unitSetup.__index = {
		name = "dangerousbeast",
		hp = 100,
		unit = "noob",
		guid = 0,
		guidsh = 0,
	}

	function br.unitSetup:new(unit)
		-- Seeing if we have already cached this unit before
		if br.unitSetup.cache[unit] then return false end
		local o = {}
		setmetatable(o, br.unitSetup)
		if unit and type(unit) == "string" then
			o.unit = unit
		end
		--Function time to die
		function o:unitTtd(targetPercentage)
			if targetPercentage == nil then targetPercentage = 0 end
			local value
			if o.hp == 0 then return -1 end
			if o.hp == 100 or isDummy(o.unit) then return 999 end
			local timeNow = GetTime()
			-- Reset unit if HP is higher
			if br.ttd[o.unit] ~= nil and (br.ttd[o.unit].lasthp < o.hp or #br.ttd[o.unit].values == 0) then
				br.ttd[o.unit] = nil
			end
			-- initialize new unit
			if br.ttd[o.unit] == nil then
				br.ttd[o.unit] = { } -- create unit
				br.ttd[o.unit].values = { } -- create value table
				value = {time = 0, hp = o.hp} -- create initial values
				tinsert(br.ttd[o.unit].values, 1, value) -- insert unit
				br.ttd[o.unit].lasthp = o.hp -- store current hp pct
				br.ttd[o.unit].startTime = timeNow -- store current time
				br.ttd[o.unit].lastTime = 0 --store last time value
				return 999
			end
			local ttdUnit = br.ttd[o.unit]
			-- add current value to ttd table if HP changed or more than X sec since last update
			if o.hp ~= ttdUnit.lasthp or (timeNow - ttdUnit.startTime - ttdUnit.lastTime) > 0.5 then
				value = {time = timeNow - ttdUnit.startTime, hp = o.hp}
				tinsert(ttdUnit.values, 1, value)
				br.ttd[o.unit].lasthp = o.hp
				br.ttd[o.unit].lastTime = timeNow - ttdUnit.startTime
			end
			-- clean units
			local valueCount = #ttdUnit.values
			while valueCount > 0 and (valueCount > 100 or (timeNow - ttdUnit.startTime - ttdUnit.values[valueCount].time) > 10) do
				ttdUnit.values[valueCount] = nil
				valueCount = valueCount - 1
			end
			-- calculate ttd if more than 3 values
			valueCount = #ttdUnit.values
			if valueCount > 1 then
				-- linear regression calculation from https://github.com/herotc/hero-lib/
				local a, b = 0, 0
				local Ex2, Ex, Exy, Ey = 0, 0, 0, 0
				local x, y
				for i = 1, valueCount do
					x, y = ttdUnit.values[i].time, ttdUnit.values[i].hp
					Ex2 = Ex2 + x * x
					Ex = Ex + x
					Exy = Exy + x * y
					Ey = Ey + y
				end
				local invariant = 1 / (Ex2 * valueCount - Ex * Ex)
				a = (-Ex * Exy * invariant) + (Ex2 * Ey * invariant)
				b = (valueCount * Exy * invariant) - (Ex * Ey * invariant)
				if b ~= 0 then
					local ttdSec = (targetPercentage - a) / b
					ttdSec = math.min(999, ttdSec - (timeNow - ttdUnit.startTime))
					if ttdSec > 0 then
						return ttdSec
					end
					return -1 -- TTD under 0
				end
			end
			return 999 -- not enough values
		end
		-- Updating the values of the Unit
		function o:UpdateUnit()
      -- assign Name of unit
      o.name = UnitName(o.unit)
      -- assign real GUID of unit and Short GUID of unit for the SetupTable
      o.guid = UnitGUID(o.unit)
      -- distance to player
      --o.distance = getDistance("player",o.unit)
      -- Unit's threat situation(1-4)
      --o.threat = UnitThreatSituation("player", o.unit)
			if getOptionCheck("Enhanced Time to Die") then
	      -- Unit HP absolute
	      o.hpabs = UnitHealth(o.unit)
				-- Unit max HP
				o.hpmax = UnitHealthMax(o.unit)
	      -- Unit HP and Absorb
	      o.hp = o.hpabs / o.hpmax * 100
			end
			-- Is valid unit
			if o.validUnitRefresh == nil or o.validUnitRefresh < GetTime() - 0.5 then
				o.isValidUnit = isValidUnit(o.unit)
				o.validUnitRefresh = GetTime()
			end
			------DEBUG VALUES-----
			-- o.unitAffectingCombat = UnitAffectingCombat(o.unit)
			-- o.isBoss = isBoss(o.unit)
			-- o.reaction = GetUnitReaction(o.unit,"player")
			-- o.canAttack = UnitCanAttack("player",o.unit)
			-- o.hasThreat = hasThreat(o.unit)
			-- o.unitTarget = UnitTarget(GetUnit(o.unit))
			o.objectID = ObjectID(o.unit)
			-- EnemyListCheck
			if o.enemyRefresh == nil or o.enemyRefresh < GetTime() - 1 then
				o.enemyListCheck = enemyListCheck(o.unit)
				o.enemyRefresh = GetTime()
			end
			-- ObjectPosition
			o.posX, o.posY, o.posZ = GetObjectPosition(o.unit)
			-- TTD
			if getOptionCheck("Enhanced Time to Die") then
				if o.objectID == 140853 then -- If mother, TTD is 10 pct
					o.ttd = o:unitTtd(10)
				else
					o.ttd = o:unitTtd()
				end				
			end
			-- add unit to setup cache
			br.unitSetup.cache[o.unit] = o -- Add unit to SetupTable
		end
		-- Adding the user and functions we just created to this cached version in case we need it again
		-- This will also serve as a good check for if the unit is already in the table easily
		br.unitSetup.cache[o.unit] = o
		return o
	end
	-- Setting up the tables on either Wipe or Initial Setup
	function SetupEnemyTables() -- Creating the cache (we use this to check if some1 is already in the table)
		setmetatable(br.om, metaTable2) -- Set the metaTable of Main to Meta
		function br.om:Update()
			br.omTableTimer = GetTime()
			local i=1
			if getOptionCheck("Debug TTD") then LibDraw.clearCanvas() end -- clear canvas for ttd
			while i <= #br.om do
				if not GetUnitIsVisible(br.om[i].unit) or getDistance(br.om[i].unit) > 50 then
					for j,v in pairs(br.unitSetup.cache) do
						if br.om[i].unit == j then
							br.unitSetup.cache[j] = nil
							-- reset time to die
							if br.ttd[j] ~= nil then
								br.ttd[j] = nil
							end
						end
					end
					tremove(br.om, i)
				else
					br.om[i]:UpdateUnit()
					--TTD drawing
					if getOptionCheck("Debug TTD") and br.om[i].enemyListCheck and br.om[i].isValidUnit then
						local ox, oy, oz = ObjectPosition(br.om[i].unit)
						local size = 1.75
						if UnitCombatReach(br.om[i].unit) > 0 then size = UnitCombatReach(br.om[i].unit) / 0.857 end
						oz = oz + size + 2
						local mult = 10^2
						local ttdText
						if getOptionCheck("Enhanced Time to Die") then
							ttdText = "TTD: " .. math.floor(br.om[i].ttd * mult + 0.5) / mult
						else
							ttdText = "TTD: " .. math.floor(getTTD(br.om[i].unit) * mult + 0.5) / mult
						end
						LibDraw.Text(ttdText, "DiesalFontNormal", ox, oy, oz)
					end
					i = i + 1
				end
			end
			-- table.sort(br.om, function(x,y)
			-- 	return x.distance < y.distance
			-- end)
		end
	end
	-- We are setting up the Tables for the first time
	SetupEnemyTables()
end
