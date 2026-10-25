local _, br = ...
br.engines.enemiesEngine = br.engines.enemiesEngine or {}
local engine = br.engines.enemiesEngine

--[[ Enemies engine

One record per unit the object scan finds (or the combat log sees fighting the group), keyed by
the unit's pointer. Everything about a unit lives on its record:
  facts that never change   guid, name, id (NPC ID), isCritter, isOtherPet, isOwnPet; read once
  per update                position, distance, dead / alive
  on their own timers       candidate (passed misc:enemyListCheck), valid (misc:isValidUnit), los

The sets the rest of BR reads hold the same records (no copies):
  engine.units[pointer]     candidates (misc:enemyListCheck passed, or damaged by / attacking the group)
  engine.enemy[pointer]     valid enemies (misc:isValidUnit passed)
  engine.pet[pointer]       other players' pets
  engine.lootable[pointer]  dead units with loot (Auto Loot)
  engine.damaged[pointer]   filled by readers/combatlog.lua
Records keep the fields the old per-set entries had (unit, name, guid, id, range, debuffs, timestamp).

Each engine pulse (Core.lua's object manager frame) runs engine:Update(): scan a slice of the
object list for new units, then update the records that are due. Updates are spread out over time
(engine:Update) so a large pull doesn't update every unit every pulse.
]]

engine.records    = {} -- pointer -> record, every tracked unit
engine.recordList = {} -- the same records as a packed array, for spreading updates
engine.units      = {}
engine.enemy      = {}
engine.pet        = {}
engine.lootable   = {}
engine.damaged    = engine.damaged or {}
engine.ttd        = {} -- pointer -> samples used by record:unitTtd (Enhanced Time to Die)
-- NPC / spell IDs this engine treats specially are in br.lists.unitRules (System/Lists/UnitRules.lua)

local GetTime = br._G.GetTime
local tinsert = br._G.tinsert
local pX, pY, pZ, pCR, autoLoot -- player position / combat reach / Auto Loot, set once per pulse
local playerPointer, targetPointer -- the player's and their target's pointers, set once per pulse

-- ─────────────────────────────────────────────────────────────────────────────
-- Records
-- ─────────────────────────────────────────────────────────────────────────────
local Record = {}
Record.__index = Record

-- A valid unit reference for this unlocker: pointers are strings, or numbers on NN
local function isUnitReference(unit)
	return type(unit) == "string" or (br.unlockers.selected == "NN" and type(unit) == "number")
end

--- The record for a unit pointer, or nil when the engine isn't tracking it.
function engine:getRecord(unit)
	return engine.records[unit]
end

--- The record for a unit pointer, created when the unit may be tracked. Returns nil for units the
-- engine never tracks (unitRules.neverTrack NPCs; other players while the player has
-- unitRules.ignorePlayersWhilePlayerHas).
function engine:track(unit)
	if unit == nil then return nil end
	local record = engine.records[unit]
	if record then return record end
	if not isUnitReference(unit) then return nil end
	local rules = br.lists.unitRules
	if br._G.UnitIsPlayer(unit) and br.functions.aura:UnitDebuffID("player", rules.ignorePlayersWhilePlayerHas) then return nil end
	local id = br.functions.unit:GetObjectID(unit)
	if rules.neverTrack[id] then return nil end
	record = setmetatable({
		unit       = unit,
		guid       = br._G.UnitGUID(unit),
		name       = br._G.UnitName(unit),
		id         = id,
		isCritter  = br.functions.unit:isCritter(unit) and true or false,
		isOtherPet = br._G.UnitIsOtherPlayersPet(unit) and true or false,
		isOwnPet   = rules.ownPets[id] ~= nil or br.functions.unit:GetUnitIsUnit(br._G.UnitCreator(unit), "player"),
		debuffs    = {},
		range      = 0,
		seenAt     = br._G.GetTime(), -- when the engine first saw it (timestamp is the last re-check)
	}, Record)
	engine.records[unit] = record
	return record
end

-- Put a record in the update list (once)
local function list(record)
	if record.listIndex then return end
	local recordList = engine.recordList
	recordList[#recordList + 1] = record
	record.listIndex = #recordList
end

-- Forget a unit everywhere (despawned / out of view)
local function forget(record)
	local unit = record.unit
	engine.records[unit] = nil
	engine.units[unit] = nil
	engine.enemy[unit] = nil
	engine.pet[unit] = nil
	engine.lootable[unit] = nil
	engine.ttd[unit] = nil
	if br.player ~= nil and br.player.pet ~= nil and br.player.pet.list ~= nil then br.player.pet.list[unit] = nil end
	local index = record.listIndex
	if index then
		local recordList = engine.recordList
		local last = #recordList
		if index ~= last then
			recordList[index] = recordList[last]
			recordList[index].listIndex = index
		end
		recordList[last] = nil
		record.listIndex = nil
	end
end

--- Drop a record that only exists for the damaged table (the scan never listed it).
function engine:release(unit)
	local record = engine.records[unit]
	if record and record.listIndex == nil then engine.records[unit] = nil end
end

--- Forget a unit that just died (combat log UNIT_DIED): it leaves every set at once.
function engine:forget(unit)
	local record = engine.records[unit]
	if record then forget(record) end
	engine.damaged[unit] = nil
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Time to die (Enhanced Time to Die): linear regression over recent HP samples
-- ─────────────────────────────────────────────────────────────────────────────
function Record:unitTtd(targetPercentage)
	local startTime = br._G.debugprofilestop()
	if targetPercentage == nil then targetPercentage = 0 end
	if self.hp == 0 then return 0 end -- dead: no time left (0, not a misleading negative)
	if self.hp == 100 or br.functions.unit:isDummy(self.unit) then return 999 end
	local timeNow = GetTime()
	local samples = engine.ttd[self.unit]
	-- Reset when HP went up
	if samples ~= nil and (samples.lasthp < self.hp or #samples.values == 0) then
		engine.ttd[self.unit] = nil
		samples = nil
	end
	if samples == nil then
		engine.ttd[self.unit] = { values = { { time = 0, hp = self.hp } }, lasthp = self.hp, startTime = timeNow, lastTime = 0 }
		return 999
	end
	-- Add a sample when HP changed or every 0.5 s
	if self.hp ~= samples.lasthp or (timeNow - samples.startTime - samples.lastTime) > 0.5 then
		tinsert(samples.values, 1, { time = timeNow - samples.startTime, hp = self.hp })
		samples.lasthp = self.hp
		samples.lastTime = timeNow - samples.startTime
	end
	-- Drop samples beyond 100 or older than 10 s
	local valueCount = #samples.values
	while valueCount > 0 and (valueCount > 100 or (timeNow - samples.startTime - samples.values[valueCount].time) > 10) do
		samples.values[valueCount] = nil
		valueCount = valueCount - 1
	end
	if valueCount > 1 then
		-- linear regression over the 20 most recent samples (from https://github.com/herotc/hero-lib/)
		local count = math.min(valueCount, 20)
		local Ex2, Ex, Exy, Ey = 0, 0, 0, 0
		for i = 1, count do
			local x, y = samples.values[i].time, samples.values[i].hp
			Ex2 = Ex2 + x * x
			Ex = Ex + x
			Exy = Exy + x * y
			Ey = Ey + y
		end
		local denom = (Ex2 * count - Ex * Ex)
		if denom ~= 0 then
			local invariant = 1 / denom
			local a = (-Ex * Exy * invariant) + (Ex2 * Ey * invariant)
			local b = (count * Exy * invariant) - (Ex * Ey * invariant)
			if b ~= 0 then
				local ttdSec = math.min(999, (targetPercentage - a) / b - (timeNow - samples.startTime))
				-- A slope that projects the unit as already dead while it's alive is an unreliable
				-- estimate (damage gaps); report 999 so `ttd < N` checks don't fire on a healthy target.
				br.debug.cpu:updateDebug(startTime, "enemiesEngine.record.ttd")
				if ttdSec > 0 then return ttdSec end
				return 999
			end
		end
	end
	br.debug.cpu:updateDebug(startTime, "enemiesEngine.record.ttd")
	return 999 -- not enough samples
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Per-unit update
-- ─────────────────────────────────────────────────────────────────────────────

-- Distance from the player (position read this update), less both combat reaches
function Record:RawDistance()
	local x2, y2, z2 = self.posX, self.posY, self.posZ
	if pX == nil or x2 == nil then return 99 end
	return math.sqrt(((x2 - pX) ^ 2) + ((y2 - pY) ^ 2) + ((z2 - pZ) ^ 2)) - ((pCR or 0) + (br._G.UnitCombatReach(self.unit) or 0)), z2 - pZ
end

-- Shared debuff lookup for the Cache Debuffs option
local function findDebuffOnUnit(buffName, unit)
	return br.functions.aura:findByName(br.api.wow.GetSpellInfo(buffName), unit, "HARMFUL|PLAYER")
end

-- Cache Debuffs: the player's debuffs on this unit, from the combat log's tracker
function Record:UpdateDebuffs()
	local startTime = br._G.debugprofilestop()
	local debuffList = self.debuffs
	if not br.functions.misc:isChecked("Cache Debuffs") then
		self.debuffs = {}
		return
	end
	local unit = self.unit
	local debuffTracker = br.readers.combatLog.debuffTracker
	for _, tracker in pairs(debuffTracker) do
		for _, entry in pairs(tracker) do
			local buffCaster, buffName, buffUnit = entry[1], entry[2], entry[3]
			if buffUnit == unit and buffCaster == "player" and (debuffList[buffCaster] == nil or debuffList[buffCaster][buffName] == nil) then
				debuffList[buffCaster] = debuffList[buffCaster] or {}
				debuffList[buffCaster][buffName] = findDebuffOnUnit
				if debuffTracker[unit] ~= nil then debuffTracker[unit][buffName] = nil end
			end
		end
	end
	for buffCaster, buffs in pairs(debuffList) do
		for buffName, finder in pairs(buffs) do
			if finder(buffName, unit) == nil then
				buffs[buffName] = nil
				local tracked = debuffTracker[unit] ~= nil and debuffTracker[unit][buffName]
				if tracked and tracked[1] == buffCaster then debuffTracker[unit][buffName] = nil end
			end
		end
	end
	br.debug.cpu:updateDebug(startTime, "enemiesEngine.record.updateDebuffs")
end

-- How often a unit's candidate check (misc:enemyListCheck) is redone, by group size and FPS
local function candidateInterval(hasGroup, fps)
	if not hasGroup then return 1 end
	if fps >= 60 then return 0.25 end
	if fps >= 45 then return 0.4 end
	if fps >= 30 then return 0.6 end
	return 0.8
end

function Record:update(now, inCombat, hasGroup, fps)
	local startTime = br._G.debugprofilestop()
	local unit = self.unit
	local units, enemy = engine.units, engine.enemy

	self.posX, self.posY, self.posZ = br._G.ObjectPosition(unit)
	if not self.posX then return end -- no position: skip until it has one

	self.distance = self:RawDistance()
	self.hpabs = br._G.UnitHealth(unit)
	self.hpmax = br._G.UnitHealthMax(unit)
	self.hp = self.hpabs / self.hpmax * 100

	local isDamaged = engine.damaged[unit] ~= nil
	local isDead = br.functions.unit:GetUnitIsDeadOrGhost(unit)
	-- "Targeting the player?" by UnitIsUnit: unlockers return UnitTarget as a pointer, GUID or token
	-- (not always equal to the player's pointer); "is the player's target?" is a pointer compare
	local victim = br._G.UnitTarget(unit)
	local isTargeting = victim ~= nil and br._G.UnitIsUnit(victim, "player") and true or false
	local isPlayerTarget = targetPointer ~= nil and unit == targetPointer

	-- Candidate: close, alive, not a critter, and passes misc:enemyListCheck (damaged units always do)
	if self.distance <= 50 and not isDead and not self.isCritter then
		local isCandidate = units[unit] ~= nil
		local interval = candidateInterval(hasGroup, fps)
		if inCombat then
			if isDamaged or isTargeting or (not isCandidate and hasGroup and br.functions.combat:hasThreat(unit)) then
				interval = 0.05
			elseif isCandidate then
				interval = interval * 1.1
			end
		elseif isCandidate then
			interval = interval * 1.25
		end
		if self.candidateAt == nil or self.candidateAt < now - interval then
			self.range = br.functions.range:getDistance(unit)
			self.timestamp = now
			self.candidate = isDamaged or br.functions.misc:enemyListCheck(unit, self.range)
			self.candidateAt = now
			if self.candidate then
				units[unit] = self
			else
				units[unit] = nil
			end
		end
	else
		self.candidate = false
		units[unit] = nil
	end

	-- Already an enemy: drop it quickly when it can't be attacked, is crowd controlled, or is unsafe,
	-- without waiting for the full validation below
	if enemy[unit] ~= nil and self.candidate and not isDamaged then
		local ttl = inCombat and 0.05 or 0.10
		if self.quickCheckAt == nil or self.quickCheckAt < now - ttl then
			self.quickCheckOk = self.hpabs > 0 and not isDead and br._G.UnitCanAttack("player", unit)
				and not (br.functions.misc:getOptionCheck("Don't break CCs") and br.functions.misc:isCCProtected(unit))
				and br.engines.enemiesEngineFunctions:isSafeToAttack(unit)
			self.quickCheckAt = now
		end
		if not self.quickCheckOk then
			self.valid = false
			enemy[unit] = nil
			br.debug.cpu:updateDebug(startTime, "enemiesEngine.record.update")
			return
		end
	end

	-- Valid enemy: misc:isValidUnit (damaged units always are)
	if self.candidate then
		if isDamaged then
			self.valid = true
		else
			local ttl
			if isTargeting or isPlayerTarget or (hasGroup and br.functions.combat:hasThreat(unit)) then
				ttl = 0.05
			elseif enemy[unit] ~= nil then
				ttl = inCombat and 0.15 or 0.25
			else
				ttl = inCombat and 0.10 or 0.20
			end
			if self.validAt == nil or self.validAt < now - ttl then
				self.valid = br.functions.misc:isValidUnit(unit)
				self.validAt = now
			end
		end
		if self.valid then
			-- Line of sight is expensive: rechecked on its own timer. Out-of-sight enemies stay listed
			-- (rotations still count them); targeting and casting check sight themselves.
			if self.losAt == nil or now > self.losAt + (inCombat and 0.5 or 1.0) then
				self.los = br.functions.misc:getLineOfSight("player", unit)
				self.losAt = now
			end
			if inCombat and self.los ~= false and (self.distance < 40 or isPlayerTarget) then
				self:UpdateDebuffs()
			end
			enemy[unit] = self
		else
			enemy[unit] = nil
		end
	else
		self.valid = false
		enemy[unit] = nil
	end

	-- Enhanced Time to Die
	if br.functions.misc:getOptionCheck("Enhanced Time to Die") then
		self.ttd = self:unitTtd(br.lists.unitRules.ttdPercent[self.id])
	end

	-- Loot
	if autoLoot and isDead and engine.lootable[unit] == nil and br._G.CanLootUnit(self.guid) then
		engine.lootable[unit] = self
		if br.debug.loot then
			br.debug.loot:line(("lootable: %s %s at %.0f yd"):format(br.functions.misc:plainText(br._G.UnitName(unit) or "?"),
				br.debug.loot:tag(self.guid), br.functions.misc:plainNumber(self.distance or 0)))
		end
	end
	-- Pets: the player's own, and other players'
	if self.isOwnPet and br.player ~= nil and br.player.pet.list[unit] == nil then
		br.player.pet.list[unit] = self
	end
	if self.isOtherPet then engine.pet[unit] = self end

	br.debug.cpu:updateDebug(startTime, "enemiesEngine.record.update")
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Object scan: finds new units, a slice of the object list per pulse
-- ─────────────────────────────────────────────────────────────────────────────
local scanCursor = 1
local lastScanAt = 0
local SCAN_INTERVAL = 0.25 -- seconds between scan slices (0.5 in raids)

-- How many objects one scan slice reads, and how far out it looks, for this object count and FPS
local function scanBudget(totalObjects, fps, inRaid)
	local perSlice = totalObjects
	local maxDistance
	if fps < 25 then maxDistance = 40
	elseif fps < 35 then maxDistance = 60
	elseif fps < 45 then maxDistance = 80
	else maxDistance = 100 end
	if totalObjects > 150 then
		if totalObjects > 450 then perSlice = 150
		elseif totalObjects > 350 then perSlice = 200
		elseif totalObjects > 250 then perSlice = 250
		else perSlice = math.floor(totalObjects * 0.65) end
		if inRaid then perSlice = math.min(perSlice, 180) end
		if fps < 30 then maxDistance = math.min(maxDistance, 50)
		elseif fps < 40 then maxDistance = math.min(maxDistance, 60)
		elseif fps < 50 then maxDistance = math.min(maxDistance, 80) end
	end
	return perSlice, maxDistance
end

-- Most units the engine tracks at once (keeps very busy areas affordable)
local function trackLimit(inRaid)
	if inRaid then return 120 end
	if br._G.GetNumGroupMembers() > 0 then return 200 end
	return 300
end

-- Scan the next slice of the object list. Every object is reached in turn, however many there are.
-- Returns true when the slice reached the end of the list.
function engine:scan(now, fps, inRaid)
	local startTime = br._G.debugprofilestop()
	if now - lastScanAt < (inRaid and 0.5 or SCAN_INTERVAL) then return false end
	lastScanAt = now
	local totalObjects = br._G.GetObjectCount() or 0
	if totalObjects == 0 then return false end
	local perSlice, maxDistance = scanBudget(totalObjects, fps, inRaid)
	if scanCursor > totalObjects then scanCursor = 1 end
	local last = math.min(scanCursor + perSlice - 1, totalObjects)
	local limit = trackLimit(inRaid)
	local records = engine.records
	local GetObjectWithIndex, ObjectExists, ObjectIsUnit = br._G.GetObjectWithIndex, br._G.ObjectExists, br._G.ObjectIsUnit
	local UnitIsPlayer, UnitIsVisible, ObjectPosition = br._G.UnitIsPlayer, br._G.UnitIsVisible, br._G.ObjectPosition
	for i = scanCursor, last do
		local unit = GetObjectWithIndex(i)
		local record = records[unit]
		if (record == nil or record.listIndex == nil) and ObjectExists(unit) and ObjectIsUnit(unit)
			and not UnitIsPlayer(unit) and UnitIsVisible(unit)
		then
			local x, y, z = ObjectPosition(unit)
			local inReach = x ~= nil and pX ~= nil and math.sqrt(((x - pX) ^ 2) + ((y - pY) ^ 2) + ((z - pZ) ^ 2)) <= maxDistance
			-- A corpse you may loot is tracked too (Auto Loot), even when the game no longer counts it
			-- as attackable: one that died out of view or before a /reload was never tracked alive
			if inReach and #engine.recordList < limit and not br.functions.unit:isCritter(unit)
				and (br._G.UnitCanAttack("player", unit) or (br._G.UnitGUID(unit) and string.match(br._G.UnitGUID(unit), "Pet"))
					or (autoLoot and br._G.UnitIsDeadOrGhost(unit) and br._G.CanLootUnit(br._G.UnitGUID(unit))))
			then
				record = engine:track(unit)
				if record then list(record) end
			end
		end
	end
	scanCursor = last + 1
	br.debug.cpu:updateDebug(startTime, "enemiesEngine.objects")
	return scanCursor > totalObjects
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Pulse
-- ─────────────────────────────────────────────────────────────────────────────
function engine:Update()
	local now = GetTime()
	pX, pY, pZ = br._G.ObjectPosition("player")
	-- Published for getEnemies' caches (position the enemy lists were built at)
	engine.playerPosX, engine.playerPosY, engine.playerPosZ = pX, pY, pZ
	pCR = br._G.UnitCombatReach("player")
	playerPointer = br._G.ObjectPointer("player")
	targetPointer = br._G.UnitExists("target") and br._G.ObjectPointer("target") or nil
	autoLoot = br.functions.misc:isChecked("Auto Loot")
	if br.player ~= nil then
		br.player.pet = br.player.pet or {}
		br.player.pet.list = br.player.pet.list or {}
	end
	local fps = br._G.GetFramerate() or 60
	engine.fps = fps
	local inRaid = br._G.IsInRaid()

	if engine:scan(now, fps, inRaid) then
		-- A full pass over the object list: getEnemies' per-unit caches start over
		if br.engines.enemiesEngineFunctions.clearStoredTables then br.engines.enemiesEngineFunctions:clearStoredTables() end
	end

	-- Update the records that are due. Each update reschedules the record a little under one
	-- update period ahead (randomised so updates spread out); in raids half as often. New units
	-- and units not yet candidates are checked four times as often, so they show up quickly.
	local updateRate = br.engines:getUpdateRate()
	local raidMultiplier = inRaid and 2.00 or 1.00
	local inCombat = br._G.UnitAffectingCombat("player")
	local hasGroup = br._G.GetNumGroupMembers() > 0
	local recordList = engine.recordList
	local i = 1
	while i <= #recordList do
		local record = recordList[i]
		if record.nextUpdate == nil or now >= record.nextUpdate then
			local delay = ((math.random() * 0.25) + 0.75) * updateRate * raidMultiplier
			if record.candidateAt == nil or engine.units[record.unit] == nil then delay = delay * 0.25 end
			record.nextUpdate = now + delay
			-- Gone, or the pointer now belongs to a different unit (its record's facts would be wrong):
			-- forget it; the scan picks a new unit up again
			if not br.functions.unit:GetUnitIsVisible(record.unit) or br._G.UnitGUID(record.unit) ~= record.guid then
				forget(record) -- the last record was swapped into slot i: process it next
			else
				record:update(now, inCombat, hasGroup, engine.fps)
				i = i + 1
			end
		else
			i = i + 1
		end
	end

	-- Loot that's gone or already looted
	if autoLoot then
		for unit, record in pairs(engine.lootable) do
			if not br.functions.unit:GetObjectExists(unit) or not br._G.CanLootUnit(record.guid) then
				engine.lootable[unit] = nil
			end
		end
	end
end
