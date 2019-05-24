-----------------------------------------Bubba's Healing Engine--------------------------------------]]
--Modified to enemies engine by fisker
if not metaTable2 then
	-- localizing the commonly used functions while inside loops
	local tinsert,tremove,GetTime = tinsert,tremove,GetTime
	local pX, pY, pZ, pCR, autoLoot
	br.om = {} -- This is our main Table that the world will see
	br.ttd = {} -- Time to die table
	br.unitSetup = {} -- This is one of our MetaTables that will be the default user/contructor
	br.unitSetup.cache = {} -- This is for the cache Table to check against
	br.unitBlacklist = { -- blacklist for units
		[129359]=true, -- Sawtooth Shark
        [129448]=true, -- Hammer Shark
		[144942]=true, -- Spark Bot
	}
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
		if br.unitBlacklist[GetObjectID(unit)] then return false end
		if UnitIsUnit("player", unit) then return false end
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
		--Distance
		function o:RawDistance()
			local x1, y1, z1 = pX, pY, pZ
			local x2, y2, z2 = o.posX, o.posY, o.posZ
			return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2)) -
				((pCR or 0) + (UnitCombatReach(o.unit) or 0)), z2 - z1
		end
		--Add unit to table
		function o:AddUnit(table)
			local thisUnit
			if UnitIsOtherPlayersPet(o.unit) then
				thisUnit = {
					unit = o.unit,
				}
			else
				thisUnit = {
					unit = o.unit,
					name = o.name,
					guid = o.guid,
					id = o.objectID
				}
			end
			rawset(table, o.unit, thisUnit)
		end
		-- Updating the values of the Unit
		function o:UpdateUnit()
			o.posX, o.posY, o.posZ = ObjectPosition(o.unit)
			o.name = UnitName(o.unit)
			o.guid = UnitGUID(o.unit)
			o.distance = o:RawDistance()
			o.hpabs = UnitHealth(o.unit)
			o.hpmax = UnitHealthMax(o.unit)
			o.hp = o.hpabs / o.hpmax * 100
			o.objectID = ObjectID(o.unit)
			if o.distance <= 50 and not UnitIsDeadOrGhost(o.unit) then
				-- EnemyListCheck
				if o.enemyRefresh == nil or o.enemyRefresh < GetTime() - 1 then
					o.enemyListCheck = enemyListCheck(o.unit)
					o.enemyRefresh = GetTime()
					if o.enemyListCheck == true then
						if br.units[o.unit] == nil then
							o:AddUnit(br.units)
						end
					else
						if br.units[o.unit] ~= nil then
							br.units[o.unit] = nil
						end
					end
				end
			else
				o.enemyListCheck = false
				if br.units[o.unit] ~= nil then
					br.units[o.unit] = nil
				end
			end
			-- Is valid unit - only check if enemyList checks out
			if o.enemyListCheck == true then
				o.isValidUnit = isValidUnit(o.unit)
				if o.isValidUnit == true then
					if br.enemy[o.unit] == nil then
						o:AddUnit(br.enemy)
					end
				else
					if br.enemy[o.unit] ~= nil then
						br.enemy[o.unit] = nil
					end
				end
			else
				o.isValidUnit = false
				if br.enemy[o.unit] ~= nil then
					br.enemy[o.unit] = nil
				end
			end
			-- TTD
			if getOptionCheck("Enhanced Time to Die") then
				if o.objectID == 140853 then -- If mother, TTD is 10 pct
					o.ttd = o:unitTtd(10)
				elseif o.objectID == 149684 then -- Jaina tps out at 5%
					o.ttd = o:unitTtd(5)
				else
					o.ttd = o:unitTtd()
				end
			end
			-- Check for loots
			if autoLoot and br.lootable[o.unit] == nil and UnitIsDeadOrGhost(o.unit) then
				local hasLoot, canLoot = CanLootUnit(o.guid)
				if hasLoot and canLoot then
					o:AddUnit(br.lootable)
				end
			end
			-- Add pets
			if br.player ~= nil and br.player.pet.list[o.unit] == nil and (o.objectID == 11492 or GetUnitIsUnit(UnitCreator(o.unit), "player")) then
				o:AddUnit(br.player.pet.list)
			end
			-- Add other player pets
			if br.pet ~= nil and br.pet[o.unit] == nil and (UnitIsOtherPlayersPet(o.unit)) then
				o:AddUnit(br.pet)
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
			--Set variables we don't need to update for each unit
			pX, pY, pZ = ObjectPosition("player")
			pCR = UnitCombatReach("player")
			autoLoot = isChecked("Auto Loot")
			if br.pet == nil then
				br.pet = {}
			end
			--Make sure we have pet tables
			if br.player ~= nil then
				if br.player.pet == nil then
					br.player.pet = {}
				end
				if br.player.pet.list == nil then
					br.player.pet.list = {}
				end
			end
			--Cycle and clean tables
			local i=1
			while i <= #br.om do
				if br.om[i].pulseTime == nil or GetTime() >= (br.om[i].pulseTime + (math.random(1,12)/100)) then
					br.om[i].pulseTime = GetTime()
					local thisUnit = br.om[i].unit
					if not GetUnitIsVisible(thisUnit) then
						--Delete units no longer in OM
						br.unitSetup.cache[thisUnit] = nil
						if br.ttd[thisUnit] ~= nil then
							br.ttd[thisUnit] = nil
						end
						if br.units[thisUnit] ~= nil then
							br.units[thisUnit] = nil
						end
						if br.enemy[thisUnit] ~= nil then
							br.enemy[thisUnit] = nil
						end
						if br.player ~= nil and br.player.pet.list[thisUnit] ~= nil then
							br.player.pet.list[thisUnit] = nil
						end
						if br.lootable[thisUnit] ~= nil then
							br.lootable[thisUnit] = nil
						end
						if br.pet[thisUnit] ~= nil then
							br.pet[thisUnit] = nil
						end
						tremove(br.om, i)
					else
						--Update unit and move to next
						br.om[i]:UpdateUnit()
						i = i + 1
					end
				else
					i = i + 1
				end
			end
			-- clean our loots
			if autoLoot then
				for k, v in pairs(br.lootable) do
					if not CanLootUnit(br.lootable[k].guid) or not GetObjectExists(br.lootable[k].unit) then
						br.lootable[k] = nil
					end
				end
			end
		end
	end
	-- We are setting up the Tables for the first time
	SetupEnemyTables()
end