local _, br = ...
br.engines.enemiesEngine = br.engines.enemiesEngine or {}
local enemiesEngine = br.engines.enemiesEngine

-----------------------------------------Bubba's Healing Engine--------------------------------------
--Modified to enemies engine by fisker
if not enemiesEngine.metaTable2 then
	-- localizing the commonly used functions while inside loops
	local tinsert, tremove, GetTime = br._G.tinsert, br._G.tremove, br._G.GetTime
	local pX, pY, pZ, pCR, autoLoot
	enemiesEngine.om = {}             -- This is our main Table that the world will see
	enemiesEngine.ttd = {}            -- Time to die table
	enemiesEngine.unitSetup = {}      -- This is one of our MetaTables that will be the default user/contructor
	enemiesEngine.unitSetup.cache = {} -- This is for the cache Table to check against
	enemiesEngine.unitBlacklist = {   -- blacklist for units
		[129359] = true,   -- Sawtooth Shark
		[129448] = true,   -- Hammer Shark
		[144942] = true,   -- Spark Bot
	}
	enemiesEngine.metaTable2 = {}     -- This will be the MetaTable attached to our Main Table that the world will see
	enemiesEngine.metaTable2.__index = { -- Setting the Metamethod of Index for our Main Table
		name = "Enemies Table",
		author = "Bubba",
	}
	-- Creating a default Unit to default to on a check
	enemiesEngine.unitSetup.__index = {
		name = "dangerousbeast",
		hp = 100,
		unit = "noob",
		guid = 0,
		guidsh = 0,
		range = 100,
		debuffs = {},
		timestamp = GetTime(),
	}

	function enemiesEngine.unitSetup:new(unit)
		local startTime = br._G.debugprofilestop()
		-- Seeing if we have already cached this unit before
		if enemiesEngine.unitSetup.cache[unit] then return false end
		if br.functions.aura:UnitDebuffID("player", 295249) and br._G.UnitIsPlayer(unit) then return false end
		if enemiesEngine.unitBlacklist[br.functions.unit:GetObjectID(unit)] then return false end
		local o = {}
		setmetatable(o, br.engines.enemiesEngine.unitSetup)
		if unit and (type(unit) == "string" or (br.unlockers.selected == "NN" and type(unit) == "number")) then
			o.unit = unit
		end
		--Function time to die
		function o:unitTtd(targetPercentage)
			local startTime = br._G.debugprofilestop()
			if targetPercentage == nil then targetPercentage = 0 end
			local value
			if o.hp == 0 then return -1 end
			if o.hp == 100 or br.functions.unit:isDummy(o.unit) then return 999 end
			local timeNow = GetTime()
			-- Reset unit if HP is higher
			if enemiesEngine.ttd[o.unit] ~= nil and (enemiesEngine.ttd[o.unit].lasthp < o.hp or #enemiesEngine.ttd[o.unit].values == 0) then
				enemiesEngine.ttd[o.unit] = nil
			end
			-- initialize new unit
			if enemiesEngine.ttd[o.unit] == nil then
				enemiesEngine.ttd[o.unit] = {}          -- create unit
				enemiesEngine.ttd[o.unit].values = {}   -- create value table
				value = { time = 0, hp = o.hp } -- create initial values
				tinsert(enemiesEngine.ttd[o.unit].values, 1, value) -- insert unit
				enemiesEngine.ttd[o.unit].lasthp = o.hp -- store current hp pct
				enemiesEngine.ttd[o.unit].startTime = timeNow -- store current time
				enemiesEngine.ttd[o.unit].lastTime = 0  --store last time value
				return 999
			end
			local ttdUnit = enemiesEngine.ttd[o.unit]
			-- add current value to ttd table if HP changed or more than X sec since last update
			if o.hp ~= ttdUnit.lasthp or (timeNow - ttdUnit.startTime - ttdUnit.lastTime) > 0.5 then
				value = { time = timeNow - ttdUnit.startTime, hp = o.hp }
				tinsert(ttdUnit.values, 1, value)
				enemiesEngine.ttd[o.unit].lasthp = o.hp
				enemiesEngine.ttd[o.unit].lastTime = timeNow - ttdUnit.startTime
			end
			-- clean units
			local valueCount = #ttdUnit.values
			while valueCount > 0 and (valueCount > 100 or (timeNow - ttdUnit.startTime - ttdUnit.values[valueCount].time) > 10) do
				ttdUnit.values[valueCount] = nil
				valueCount = valueCount - 1
			end
			-- calculate ttd if more than 3 values
			-- valueCount = #ttdUnit.values
			-- if valueCount > 1 then
			-- 	-- linear regression calculation from https://github.com/herotc/hero-lib/
			-- 	local a, b = 0, 0
			-- 	local Ex2, Ex, Exy, Ey = 0, 0, 0, 0
			-- 	local x, y
			-- 	for i = 1, valueCount do
			-- 		x, y = ttdUnit.values[i].time, ttdUnit.values[i].hp
			-- 		Ex2 = Ex2 + x * x
			-- 		Ex = Ex + x
			-- 		Exy = Exy + x * y
			-- 		Ey = Ey + y
			-- 	end
			-- 	local invariant = 1 / (Ex2 * valueCount - Ex * Ex)
			-- 	a = (-Ex * Exy * invariant) + (Ex2 * Ey * invariant)
			-- 	b = (valueCount * Exy * invariant) - (Ex * Ey * invariant)
			-- 	if b ~= 0 then
			-- 		local ttdSec = (targetPercentage - a) / b
			-- 		ttdSec = math.min(999, ttdSec - (timeNow - ttdUnit.startTime))
			-- 		if ttdSec > 0 then
			-- 			return ttdSec
			-- 		end
			-- 		return -1 -- TTD under 0
			-- 	end
			-- end
			valueCount = #ttdUnit.values
			-- limit samples used for regression to avoid long computation in combat UI
			if valueCount > 1 then
				local maxSamples = 20
				local samples = math.min(valueCount, maxSamples)
				-- linear regression calculation from https://github.com/herotc/hero-lib/
				local a, b = 0, 0
				local Ex2, Ex, Exy, Ey = 0, 0, 0, 0
				local x, y
				-- use most recent 'samples' entries (values are inserted at index 1)
				for i = 1, samples do
					x, y = ttdUnit.values[i].time, ttdUnit.values[i].hp
					Ex2 = Ex2 + x * x
					Ex = Ex + x
					Exy = Exy + x * y
					Ey = Ey + y
				end
				local denom = (Ex2 * samples - Ex * Ex)
				if denom ~= 0 then
					local invariant = 1 / denom
					a = (-Ex * Exy * invariant) + (Ex2 * Ey * invariant)
					b = (samples * Exy * invariant) - (Ex * Ey * invariant)
					if b ~= 0 then
						local ttdSec = (targetPercentage - a) / b
						ttdSec = math.min(999, ttdSec - (timeNow - ttdUnit.startTime))
						if ttdSec > 0 then
							return ttdSec
						end
						return -1 -- TTD under 0
					end
				end
			end
			-- Debugging
			br.debug.cpu:updateDebug(startTime, "enemiesEngine.unitSetup.ttd")
			return 999 -- not enough values
		end

		--Distance
		function o:RawDistance()
			local x1, y1, z1 = pX, pY, pZ
			local x2, y2, z2 = o.posX, o.posY, o.posZ
			if x1 == nil or x2 == nil or y1 == nil or y2 == nil or z1 == nil or z2 == nil then
				return 99
			else
				return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2)) -
					((pCR or 0) + (br._G.UnitCombatReach(o.unit) or 0)), z2 - z1
			end
		end

		--Add unit to table
		function o:AddUnit(table)
			local thisUnit
			if br._G.UnitIsOtherPlayersPet(o.unit) then
				thisUnit = {
					unit = o.unit,
				}
			else
				thisUnit = {
					unit = o.unit,
					name = o.name,
					guid = o.guid,
					id = o.objectID,
					range = o.range,
					debuffs = o.debuffs,
					timestamp = GetTime(),
				}
			end
			-- br._G.print("Adding "..thisUnit.unit.." to table")
			rawset(table, o.unit, thisUnit)
		end

		--Debuffs
		function o:UpdateDebuffs(debuffList, unit)
			local startTime = br._G.debugprofilestop()
			if not br.functions.misc:isChecked("Cache Debuffs") then
				debuffList = {}
				return debuffList
			end
			local tracker
			local buffCaster
			local buffName
			local buffUnit
			-- Add Debuffs
			local function cacheDebuff(buffUnit, buffName, buffCaster)
				-- Print("Caching Debuff!")
				-- Cache it to the OM
				if buffCaster ~= nil and buffCaster == "player" then --(buffCaster == "player" or UnitIsFriend("player",buffCaster)) then
					if debuffList[buffCaster] == nil then debuffList[buffCaster] = {} end
					if debuffList[buffCaster][buffName] == nil then
						-- Print("Adding player debuff")
						debuffList[buffCaster][buffName] = function(buffName, unit)
							return br._G.AuraUtil.FindAuraByName(br._G.GetSpellInfo(buffName), buffUnit, "HARMFUL|PLAYER")
						end
						if debuffList[buffCaster][buffName] ~= nil then br.readers.combatLog.debuffTracker[unit][buffName] = nil end
					end
				end
			end
			-- Get the Info from Combat Log
			for k, _ in pairs(br.readers.combatLog.debuffTracker) do
				tracker = br.readers.combatLog.debuffTracker[k]
				for j, _ in pairs(tracker) do
					buffCaster = tracker[j][1]
					buffName = tracker[j][2]
					buffUnit = tracker[j][3]
					if buffUnit == unit and (debuffList[buffCaster] == nil or debuffList[buffCaster][buffName] == nil) then
						cacheDebuff(buffUnit, buffName, buffCaster)
					end
				end
			end
			-- Remove Debuffs
			for buffCaster, buffs in pairs(debuffList) do
				for buffName, _ in pairs(buffs) do
					if debuffList[buffCaster][buffName] ~= nil then
						if debuffList[buffCaster][buffName](buffName, unit) == nil then
							-- Print("Removing player expired - "..buffName)
							debuffList[buffCaster][buffName] = nil
							if br.readers.combatLog.debuffTracker[unit] ~= nil and br.readers.combatLog.debuffTracker[unit][buffName] ~= nil and br.readers.combatLog.debuffTracker[unit][buffName][1] == buffCaster then
								br.readers.combatLog.debuffTracker[unit][buffName] = nil
							end
						end
					end
				end
			end
			-- Debugging
			br.debug.cpu:updateDebug(startTime, "enemiesEngine.unitSetup.updateDebuffs")
			return debuffList
		end

		-- Updating the values of the Unit
		function o:UpdateUnit()
			-- br._G.print("Updating "..o.unit)
			local startTime = br._G.debugprofilestop()
			o.posX, o.posY, o.posZ = br._G.ObjectPosition(o.unit)
			o.name = br._G.UnitName(o.unit)
			o.guid = br._G.UnitGUID(o.unit)
			o.distance = o:RawDistance()
			o.hpabs = br._G.UnitHealth(o.unit)
			o.hpmax = br._G.UnitHealthMax(o.unit)
			o.hp = o.hpabs / o.hpmax * 100
			o.objectID = br._G.ObjectID(o.unit)
			o.range = o.range or 0
			o.debuffs = o.debuffs or {}
			if o.distance <= 50 and not br.functions.unit:GetUnitIsDeadOrGhost(o.unit) and not br.functions.unit:isCritter(o.unit) then
				-- EnemyListCheck
				if o.enemyRefresh == nil or o.enemyRefresh < GetTime() - 1 then
					o.enemyListCheck = br.functions.misc:enemyListCheck(o.unit)
					o.enemyRefresh = GetTime()
					if o.enemyListCheck == true then
						o.range = br.functions.range:getDistanceCalc(o.unit)
						if br.engines.enemiesEngine.units[o.unit] == nil then
							o:AddUnit(br.engines.enemiesEngine.units)
						end
						br.engines.enemiesEngine.units[o.unit].range = o.range
					else
						if br.engines.enemiesEngine.units[o.unit] ~= nil then
							br.engines.enemiesEngine.units[o.unit] = nil
						end
					end
				end
			else
				o.enemyListCheck = false
				if br.engines.enemiesEngine.units[o.unit] ~= nil then
					br.engines.enemiesEngine.units[o.unit] = nil
				end
			end
			-- Is valid unit - only check if enemyList checks out
			if o.enemyListCheck == true then
				o.isValidUnit = br.functions.misc:isValidUnit(o.unit)
				if o.isValidUnit == true then
					o.debuffs = o:UpdateDebuffs(o.debuffs, o.unit)
					-- o.range = getDistanceCalc(o.unit)
					if br.engines.enemiesEngine.enemy[o.unit] == nil then
						o:AddUnit(br.engines.enemiesEngine.enemy)
					end
					-- br.engines.enemiesEngine.enemy[o.unit].range = o.
					br.engines.enemiesEngine.enemy[o.unit].debuffs = o.debuffs
				else
					if br.engines.enemiesEngine.enemy[o.unit] ~= nil then
						br.engines.enemiesEngine.enemy[o.unit] = nil
					end
					if br.engines.enemiesEngine.damaged ~= nil and br.engines.enemiesEngine.damaged[o.unit] ~= nil then br.engines.enemiesEngine.damaged[o.unit] = nil end
				end
			else
				o.isValidUnit = false
				if br.engines.enemiesEngine.enemy[o.unit] ~= nil then
					br.engines.enemiesEngine.enemy[o.unit] = nil
				end
				if br.engines.enemiesEngine.damaged ~= nil and br.engines.enemiesEngine.damaged[o.unit] ~= nil then br.engines.enemiesEngine.damaged[o.unit] = nil end
			end
			-- TTD
			if br.functions.misc:getOptionCheck("Enhanced Time to Die") then
				if o.objectID == 140853 then -- If mother, TTD is 10 pct
					o.ttd = o:unitTtd(10)
				elseif o.objectID == 149684 then -- Jaina tps out at 5%
					o.ttd = o:unitTtd(5)
				else
					o.ttd = o:unitTtd()
				end
			end
			-- Check for loots
			if autoLoot and br.engines.enemiesEngine.lootable[o.unit] == nil and br.functions.unit:GetUnitIsDeadOrGhost(o.unit) then
				-- print("Checking unit: " .. o.guid .. " for loot.")
				local hasLoot = br._G.CanLootUnit(o.guid)
				if hasLoot then
					-- print("Adding lootable unit")
					o:AddUnit(br.engines.enemiesEngine.lootable)
				end
			end
			-- Add pets
			if br.player ~= nil and br.player.pet.list[o.unit] == nil and (o.objectID == 11492 or br.functions.unit:GetUnitIsUnit(br._G.UnitCreator(o.unit), "player")) then
				o:AddUnit(br.player.pet.list)
			end
			-- Add other player pets
			if br.engines.enemiesEngine.pet ~= nil and br.engines.enemiesEngine.pet[o.unit] == nil and (br._G.UnitIsOtherPlayersPet(o.unit)) then
				o:AddUnit(br.engines.enemiesEngine.pet)
			end

			-- add unit to setup cache
			enemiesEngine.unitSetup.cache[o.unit] = o -- Add unit to SetupTable
			-- Debugging
			br.debug.cpu:updateDebug(startTime, "enemiesEngine.unitSetup.updateUnit")
		end

		-- Adding the user and functions we just created to this cached version in case we need it again
		-- This will also serve as a good check for if the unit is already in the table easily
		enemiesEngine.unitSetup.cache[o.unit] = o
		-- Debugging
		br.debug.cpu:updateDebug(startTime, "enemiesEngine.unitSetup")
		return o
	end

	-- Setting up the tables on either Wipe or Initial Setup
	function enemiesEngine:SetupEnemyTables()
		-- Creating the cache (we use this to check if some1 is already in the table)
		local startTime = br._G.debugprofilestop()
		setmetatable(enemiesEngine.om, enemiesEngine.metaTable2) -- Set the metaTable of Main to Meta

		-- Debugging
		br.debug.cpu:updateDebug(startTime, "enemiesEngine.enemySetup")
	end

	function enemiesEngine:Update()
			enemiesEngine.omTableTimer = GetTime()
			--Set variables we don't need to update for each unit
			pX, pY, pZ = br._G.ObjectPosition("player")
			pCR = br._G.UnitCombatReach("player")
			autoLoot = br.functions.misc:isChecked("Auto Loot")
			if br.engines.enemiesEngine.pet == nil then
				br.engines.enemiesEngine.pet = {}
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
			local i = 1
			while i <= #enemiesEngine.om do
				if enemiesEngine.om[i] ~= nil and (enemiesEngine.om[i].pulseTime == nil or GetTime() >= enemiesEngine.om[i].pulseTime) then
					-- this delay is extremely important as the unit updates are a major source of FPS loss for BR
					-- for non-raids, this code will spread out unit updates so that everything gets updated every update
					-- for raids, only half of units will be updated per BR update
					local delay = ((math.random() * 0.25) + 0.75) * br.engines:getUpdateRate()
					if br._G.IsInRaid() then
						delay = delay * 2.00
					end

					enemiesEngine.om[i].pulseTime = GetTime() + delay
					local thisUnit = enemiesEngine.om[i].unit
					-- setfenv(1, C_Timer.Nn)
					-- br._G.print(tostring(br._G.UnitName(thisUnit)).." is Visible: "..tostring(br.functions.unit:GetUnitIsVisible(thisUnit)))
					-- br._G.print(tostring(br._G.UnitName(thisUnit)).." = "..tostring(UnitName(thisUnit)))
					if not br.functions.unit:GetUnitIsVisible(thisUnit) then
						--Delete units no longer in OM
						enemiesEngine.unitSetup.cache[thisUnit] = nil
						if enemiesEngine.ttd[thisUnit] ~= nil then
							enemiesEngine.ttd[thisUnit] = nil
						end
						if br.engines.enemiesEngine.units[thisUnit] ~= nil then
							br.engines.enemiesEngine.units[thisUnit] = nil
						end
						if br.engines.enemiesEngine.enemy[thisUnit] ~= nil then
							br.engines.enemiesEngine.enemy[thisUnit] = nil
						end
						if br.player ~= nil and br.player.pet.list[thisUnit] ~= nil then
							br.player.pet.list[thisUnit] = nil
						end
						if br.engines.enemiesEngine.lootable[thisUnit] ~= nil then
							br.engines.enemiesEngine.lootable[thisUnit] = nil
						end
						if br.engines.enemiesEngine.pet[thisUnit] ~= nil then
							br.engines.enemiesEngine.pet[thisUnit] = nil
						end
						enemiesEngine.om[i] = nil
						-- br._G.print("Removing "..thisUnit.." from om table")
						-- tremove(enemiesEngine.om, i)
					else
						--Update unit and move to next
						enemiesEngine.om[i]:UpdateUnit()
						i = i + 1
					end
				else
					i = i + 1
				end
			end
			-- clean our loots
			if autoLoot then
				for k, _ in pairs(br.engines.enemiesEngine.lootable) do
					if not br._G.CanLootUnit(br.engines.enemiesEngine.lootable[k].guid) or not br.functions.unit:GetObjectExists(br.engines.enemiesEngine.lootable[k].unit) then
						br.engines.enemiesEngine.lootable[k] = nil
					end
				end
			end
		end

	-- We are setting up the Tables for the first time
	enemiesEngine:SetupEnemyTables()
end
