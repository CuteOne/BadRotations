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
		timestamp = GetTime(),
	}

	local unitIndex = enemiesEngine.unitSetup.__index

	-- Function time to die
	function unitIndex:unitTtd(targetPercentage)
		local startTime = br._G.debugprofilestop()
		if targetPercentage == nil then targetPercentage = 0 end
		local value
		if self.hp == 0 then return -1 end
		if self.hp == 100 or br.functions.unit:isDummy(self.unit) then return 999 end
		local timeNow = GetTime()
		-- Reset unit if HP is higher
		if enemiesEngine.ttd[self.unit] ~= nil and (enemiesEngine.ttd[self.unit].lasthp < self.hp or #enemiesEngine.ttd[self.unit].values == 0) then
			enemiesEngine.ttd[self.unit] = nil
		end
		-- initialize new unit
		if enemiesEngine.ttd[self.unit] == nil then
			enemiesEngine.ttd[self.unit] = {}          -- create unit
			enemiesEngine.ttd[self.unit].values = {}   -- create value table
			value = { time = 0, hp = self.hp } -- create initial values
			tinsert(enemiesEngine.ttd[self.unit].values, 1, value) -- insert unit
			enemiesEngine.ttd[self.unit].lasthp = self.hp -- store current hp pct
			enemiesEngine.ttd[self.unit].startTime = timeNow -- store current time
			enemiesEngine.ttd[self.unit].lastTime = 0  --store last time value
			return 999
		end
		local ttdUnit = enemiesEngine.ttd[self.unit]
		-- add current value to ttd table if HP changed or more than X sec since last update
		if self.hp ~= ttdUnit.lasthp or (timeNow - ttdUnit.startTime - ttdUnit.lastTime) > 0.5 then
			value = { time = timeNow - ttdUnit.startTime, hp = self.hp }
			tinsert(ttdUnit.values, 1, value)
			enemiesEngine.ttd[self.unit].lasthp = self.hp
			enemiesEngine.ttd[self.unit].lastTime = timeNow - ttdUnit.startTime
		end
		-- clean units
		local valueCount = #ttdUnit.values
		while valueCount > 0 and (valueCount > 100 or (timeNow - ttdUnit.startTime - ttdUnit.values[valueCount].time) > 10) do
			ttdUnit.values[valueCount] = nil
			valueCount = valueCount - 1
		end
		-- limit samples used for regression to avoid long computation in combat UI
		valueCount = #ttdUnit.values
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

	-- Distance
	function unitIndex:RawDistance()
		local x1, y1, z1 = pX, pY, pZ
		local x2, y2, z2 = self.posX, self.posY, self.posZ
		if x1 == nil or x2 == nil or y1 == nil or y2 == nil or z1 == nil or z2 == nil then
			return 99
		else
			return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2)) -
				((pCR or 0) + (br._G.UnitCombatReach(self.unit) or 0)), z2 - z1
		end
	end

	-- Add unit to table
	function unitIndex:AddUnit(table)
		local thisUnit
		if br._G.UnitIsOtherPlayersPet(self.unit) then
			thisUnit = {
				unit = self.unit,
			}
		else
			thisUnit = {
				unit = self.unit,
				name = self.name,
				guid = self.guid,
				id = self.objectID,
				range = self.range,
				debuffs = self.debuffs,
				timestamp = GetTime(),
			}
		end
		-- br._G.print("Adding "..thisUnit.unit.." to table")
		rawset(table, self.unit, thisUnit)
	end

	-- Debuffs
	function unitIndex:UpdateDebuffs(debuffList, unit)
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
			-- Cache it to the OM
			if buffCaster ~= nil and buffCaster == "player" then
				if debuffList[buffCaster] == nil then debuffList[buffCaster] = {} end
				if debuffList[buffCaster][buffName] == nil then
					debuffList[buffCaster][buffName] = function(buffName, unit)
						return br.api.wow.FindAuraByName(br.api.wow.GetSpellInfo(buffName), buffUnit, "HARMFUL|PLAYER")
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
	function unitIndex:UpdateUnit()
		local startTime = br._G.debugprofilestop()
		-- Localize hot APIs for this update to reduce table lookups
		local ObjectPosition = br._G.ObjectPosition
		local UnitName = br._G.UnitName
		local UnitGUID = br._G.UnitGUID
		local UnitHealth = br._G.UnitHealth
		local UnitHealthMax = br._G.UnitHealthMax
		local ObjectPointer = br._G.ObjectPointer
		local UnitCanAttack = br._G.UnitCanAttack
		local UnitAffectingCombat = br._G.UnitAffectingCombat
		local GetTime = br._G.GetTime

		-- Cache position first (used multiple times below)
		self.posX, self.posY, self.posZ = ObjectPosition(self.unit)

		-- Early exit if unit has no position (invalid)
		if not self.posX then
			return
		end

		self.name = UnitName(self.unit)
		self.guid = UnitGUID(self.unit)
		self.distance = self:RawDistance()
		self.hpabs = UnitHealth(self.unit)
		self.hpmax = UnitHealthMax(self.unit)
		self.hp = self.hpabs / self.hpmax * 100
		self.objectID = br._G.ObjectID(self.unit)
		self.range = self.range or 0
		self.debuffs = self.debuffs or {}

		-- Check if this unit is in damaged table (bypass normal validation)
		local unitPointer = ObjectPointer(self.unit)
		local isDamagedUnit = br.engines.enemiesEngine.damaged and br.engines.enemiesEngine.damaged[unitPointer] ~= nil

		if self.distance <= 50 and not br.functions.unit:GetUnitIsDeadOrGhost(self.unit) and not br.functions.unit:isCritter(self.unit) then
			-- EnemyListCheck
			-- FPS-adaptive refresh rate for optimal responsiveness without sacrificing performance
			local fps = br.engines.enemiesEngine.cachedFPS or 60
			local refreshInterval = 1 -- Default: solo content
			if br._G.GetNumGroupMembers() > 0 then
				if fps >= 60 then
					refreshInterval = 0.25 -- Excellent FPS: maximum responsiveness
				elseif fps >= 45 then
					refreshInterval = 0.4 -- Good FPS: balanced
				elseif fps >= 30 then
					refreshInterval = 0.6 -- Acceptable FPS: reduce load
				else
					refreshInterval = 0.8 -- Low FPS: prioritize performance over responsiveness
				end
			end

			-- Combat-reactive refresh rates for better responsiveness
			local isAlreadyValid = br.engines.enemiesEngine.units[self.unit] ~= nil
			local actualRefreshInterval

			if UnitAffectingCombat("player") then
				local needsFastValidation = false
				if isDamagedUnit then
					needsFastValidation = true
				elseif br.functions.misc:isTargeting(self.unit) then
					needsFastValidation = true
				elseif not isAlreadyValid and br._G.GetNumGroupMembers() > 0 then
					needsFastValidation = br.functions.combat:hasThreat(self.unit)
				end

				if needsFastValidation then
					actualRefreshInterval = 0.05
				elseif isAlreadyValid then
					actualRefreshInterval = refreshInterval * 1.1
				else
					actualRefreshInterval = refreshInterval
				end
			elseif isAlreadyValid then
				actualRefreshInterval = refreshInterval * 1.25
			else
				actualRefreshInterval = refreshInterval
			end

			if self.enemyRefresh == nil or self.enemyRefresh < GetTime() - actualRefreshInterval then
				if isDamagedUnit then
					self.enemyListCheck = true
				else
					self.enemyListCheck = br.functions.misc:enemyListCheck(self.unit)
				end
				self.enemyRefresh = GetTime()
				if self.enemyListCheck == true then
					self.range = br.functions.range:getDistanceCalc(self.unit)
					if br.engines.enemiesEngine.units[self.unit] == nil then
						self:AddUnit(br.engines.enemiesEngine.units)
					end
					br.engines.enemiesEngine.units[self.unit].range = self.range
				else
					if br.engines.enemiesEngine.units[self.unit] ~= nil then
						br.engines.enemiesEngine.units[self.unit] = nil
					end
				end
			end
		else
			self.enemyListCheck = false
			if br.engines.enemiesEngine.units[self.unit] ~= nil then
				br.engines.enemiesEngine.units[self.unit] = nil
			end
		end

		-- Fast invalidation path (already-valid enemies):
		-- Goal: reflect CC/no-touch/unattackable state ASAP without re-running full validation every pulse.
		-- This only runs for units currently in the enemy table and uses a very short TTL to cap aura scan cost.
		local isAlreadyEnemy = br.engines.enemiesEngine.enemy[self.unit] ~= nil
		if isAlreadyEnemy and self.enemyListCheck == true and not isDamagedUnit then
			local now = GetTime()
			local fastTTL = UnitAffectingCombat("player") and 0.05 or 0.10
			if self.fastInvalidationRefresh == nil or self.fastInvalidationRefresh < (now - fastTTL) then
				local ok = true
				-- Basic cheap guards (avoid waiting for enemyListCheck refresh)
				if self.hpabs <= 0 or br.functions.unit:GetUnitIsDeadOrGhost(self.unit) then
					ok = false
				elseif not UnitCanAttack("player", self.unit) then
					ok = false
				end
				-- Don't break CCs (fast response)
				if ok and br.functions.misc:getOptionCheck("Don't break CCs") and br.functions.misc:isLongTimeCCed(self.unit) then
					ok = false
				end
				-- No-touch / invuln / affix safety rules
				if ok and not br.engines.enemiesEngineFunctions:isSafeToAttack(self.unit) then
					ok = false
				end

				self.fastInvalidationOk = ok
				self.fastInvalidationRefresh = now
			end

			if self.fastInvalidationOk == false then
				self.isValidUnit = false
				br.engines.enemiesEngine.enemy[self.unit] = nil
				-- Skip expensive validation this pulse; the unit can re-validate on the next pass.
				br.debug.cpu:updateDebug(startTime, "enemiesEngine.unitSetup.updateUnit")
				return
			end
		end

		-- Is valid unit - only check if enemyList checks out OR if unit is in damaged table
		if self.enemyListCheck == true then
			if isDamagedUnit then
				self.isValidUnit = true
			else
				-- Short TTL caching for expensive validation.
				-- We keep responsiveness for important units and reduce CPU load for stable packs.
				local now = GetTime()
				local needsFastValidation = false
				if br.functions.misc:isTargeting(self.unit) then
					needsFastValidation = true
				elseif br.functions.unit:GetUnitIsUnit(self.unit, "target") then
					needsFastValidation = true
				elseif br._G.GetNumGroupMembers() > 0 and br.functions.combat:hasThreat(self.unit) then
					needsFastValidation = true
				end
				local validTTL
				if needsFastValidation then
					validTTL = 0.05
				elseif br.engines.enemiesEngine.enemy[self.unit] ~= nil then
					validTTL = UnitAffectingCombat("player") and 0.15 or 0.25
				else
					validTTL = UnitAffectingCombat("player") and 0.10 or 0.20
				end

				if self.validRefresh == nil or self.validRefresh < (now - validTTL) then
					self.isValidUnit = br.functions.misc:isValidUnit(self.unit)
					self.validRefresh = now
				end
			end

			if self.isValidUnit == true then
				local shouldUpdateDebuffs = br._G.UnitAffectingCombat("player") and
					(self.distance < 40 or br.functions.unit:GetUnitIsUnit(self.unit, "target"))
				if shouldUpdateDebuffs then
					self.debuffs = self:UpdateDebuffs(self.debuffs, self.unit)
				end
				if br.engines.enemiesEngine.enemy[self.unit] == nil then
					self:AddUnit(br.engines.enemiesEngine.enemy)
				end
				if shouldUpdateDebuffs then
					br.engines.enemiesEngine.enemy[self.unit].debuffs = self.debuffs
				end
			else
				if br.engines.enemiesEngine.enemy[self.unit] ~= nil then
					br.engines.enemiesEngine.enemy[self.unit] = nil
				end
			end
		else
			self.isValidUnit = false
			if br.engines.enemiesEngine.enemy[self.unit] ~= nil then
				br.engines.enemiesEngine.enemy[self.unit] = nil
			end
		end

		-- TTD
		if br.functions.misc:getOptionCheck("Enhanced Time to Die") then
			if self.objectID == 140853 then
				self.ttd = self:unitTtd(10)
			elseif self.objectID == 149684 then
				self.ttd = self:unitTtd(5)
			else
				self.ttd = self:unitTtd()
			end
		end

		-- Check for loots
		if autoLoot and br.engines.enemiesEngine.lootable[self.unit] == nil and br.functions.unit:GetUnitIsDeadOrGhost(self.unit) then
			local hasLoot = br._G.CanLootUnit(self.guid)
			if hasLoot then
				self:AddUnit(br.engines.enemiesEngine.lootable)
			end
		end
		-- Add pets
		if br.player ~= nil and br.player.pet.list[self.unit] == nil and (self.objectID == 11492 or br.functions.unit:GetUnitIsUnit(br._G.UnitCreator(self.unit), "player")) then
			self:AddUnit(br.player.pet.list)
		end
		-- Add other player pets
		if br.engines.enemiesEngine.pet ~= nil and br.engines.enemiesEngine.pet[self.unit] == nil and (br._G.UnitIsOtherPlayersPet(self.unit)) then
			self:AddUnit(br.engines.enemiesEngine.pet)
		end

		-- add unit to setup cache
		enemiesEngine.unitSetup.cache[self.unit] = self
		-- Debugging
		br.debug.cpu:updateDebug(startTime, "enemiesEngine.unitSetup.updateUnit")
	end

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
		-- Ensure per-unit state is not accidentally shared via the metatable.
		o.debuffs = {}
		if o.unit ~= nil then
			enemiesEngine.unitSetup.cache[o.unit] = o
		end
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

				-- Reduce delay for unvalidated units (not yet in units table) for faster responsiveness
				-- Once validated and in combat rotation, full throttle applies for FPS optimization
				if enemiesEngine.om[i].enemyListCheck == nil or br.engines.enemiesEngine.units[enemiesEngine.om[i].unit] == nil then
					delay = delay * 0.25 -- New/unvalidated units check 4x faster to minimize perceived lag
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
						-- IMPORTANT: keep enemiesEngine.om as a packed array.
						-- Setting enemiesEngine.om[i] = nil creates holes, making #enemiesEngine.om unreliable
						-- and causing this loop (and future tinsert) to miss units.
						local omIndex = enemiesEngine.omIndex
						if omIndex ~= nil then
							omIndex[thisUnit] = nil
						end
						local last = #enemiesEngine.om
						if i ~= last then
							enemiesEngine.om[i] = enemiesEngine.om[last]
							if omIndex ~= nil and enemiesEngine.om[i] and enemiesEngine.om[i].unit ~= nil then
								omIndex[enemiesEngine.om[i].unit] = i
							end
						end
						enemiesEngine.om[last] = nil
						-- Do not increment i here; we need to process the swapped-in entry at index i.
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
			for k, v in pairs(br.engines.enemiesEngine.lootable) do
				if v ~= nil and v.unit ~= nil and v.guid ~= nil then
					-- Check if unit still exists and has loot
					if not br.functions.unit:GetObjectExists(v.unit) or not br._G.CanLootUnit(v.guid) then
						br.engines.enemiesEngine.lootable[k] = nil
					end
				else
					-- Invalid entry, remove it
					br.engines.enemiesEngine.lootable[k] = nil
				end
			end
		end

		-- Periodic cleanup of unitSetup.cache to avoid stale units inflating enemy counts
		if enemiesEngine.cacheCleanupTimer == nil then enemiesEngine.cacheCleanupTimer = 0 end
		local now = GetTime()
		-- Run cleanup every 5 seconds
		if (now - enemiesEngine.cacheCleanupTimer) >= 5 then
			enemiesEngine.cacheCleanupTimer = now
			for u, entry in pairs(enemiesEngine.unitSetup.cache) do
				local shouldRemove = false
				-- If unit no longer exists, dead/ghost or not visible and not referenced elsewhere, remove it
				if not br.functions.unit:GetObjectExists(u)
					or br.functions.unit:GetUnitIsDeadOrGhost(u)
					or not br.functions.unit:GetUnitIsVisible(u)
				then
					if (br.engines.enemiesEngine.enemy[u] == nil) and (br.engines.enemiesEngine.units[u] == nil)
						and (br.engines.enemiesEngine.damaged == nil or br.engines.enemiesEngine.damaged[u] == nil) then
						shouldRemove = true
					end
				end
				if shouldRemove then
					enemiesEngine.unitSetup.cache[u] = nil
				end
			end
		end
	end	-- We are setting up the Tables for the first time
	enemiesEngine:SetupEnemyTables()
end
