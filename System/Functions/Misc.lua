local _, br = ...
br.functions.misc = {}
local misc = br.functions.misc
local isValidUnitCache = {}
local lastIsValidUnitCleanup = 0
-- getLatency()
function misc:getLatency()
	-- local lag = ((select(3,GetNetStats()) + select(4,GetNetStats())) / 1000)
	local lag = select(4, br._G.GetNetStats()) / 1000
	if lag < .05 then
		lag = .05
	elseif lag > .4 then
		lag = .4
	end
	return lag
end

-- Home latency (to the realm server) in seconds, unclamped.
function misc:getHomeLatency()
	return (select(3, br._G.GetNetStats()) or 0) / 1000
end

-- How long to wait for the server to answer something BR sent: a round trip plus a margin.
-- @param latency home latency in seconds; read from the client when not given
function misc:getRoundTripHold(latency)
	latency = latency or misc:getHomeLatency()
	return math.max(0.20, latency * 2 + 0.10)
end

--Calculate Agility
function misc:getAgility()
	local AgiBase, _, AgiPos, AgiNeg = br._G.UnitStat("player", 2)
	local Agi = AgiBase + AgiPos + AgiNeg
	return Agi
end

function misc:getFallDistance()
	local zDist
	local zCoord = nil
	local _, _, position = br.functions.unit:GetObjectPosition("player")

	if position == nil then return 0 end
	if zCoord == nil then
		zCoord = position
	end
	if not br._G.IsFalling() or br._G.IsFlying() then
		zCoord = position
	end
	if position - zCoord < 0 then
		zDist = math.sqrt(((position - zCoord) ^ 2))
	else
		zDist = 0
	end

	return zDist
end

--if getFallTime() > 2 then
function misc:getFallTime()
	if br.fallStarted == nil then
		br.fallStarted = 0
	end
	if br.fallTime == nil then
		br.fallTime = 0
	end
	if br._G.IsFalling() and br.functions.misc:getFallDistance() < 0 then
		if br.fallStarted == 0 then
			br.fallStarted = br._G.GetTime()
		end
		if br.fallStarted ~= 0 then
			br.fallTime = (math.floor((br._G.GetTime() - br.fallStarted) * 1000) / 1000)
		end
	end
	if not br._G.IsFalling() then
		br.fallStarted = 0
		br.fallTime = 0
	end
	return br.fallTime
end

-- if br.functions.misc:getLineOfSight("target"[,"target"]) then
misc.doLinesIntersect = function(a, b, c, d)
	-- parameter conversion
	local L1 = { X1 = a.x, Y1 = a.y, X2 = b.x, Y2 = b.y }
	local L2 = { X1 = c.x, Y1 = c.y, X2 = d.x, Y2 = d.y }

	-- Denominator for ua and ub are the same, so store this calculation
	d = (L2.Y2 - L2.Y1) * (L1.X2 - L1.X1) - (L2.X2 - L2.X1) * (L1.Y2 - L1.Y1)

	-- Make sure there is not a division by zero - this also indicates that the lines are parallel.
	-- If n_a and n_b were both equal to zero the lines would be on top of each
	-- other (coincidental).  This check is not done because it is not
	-- necessary for this implementation (the parallel check accounts for this).
	if (d == 0) then
		return false
	end

	-- n_a and n_b are calculated as seperate values for readability
	local n_a = (L2.X2 - L2.X1) * (L1.Y1 - L2.Y1) - (L2.Y2 - L2.Y1) * (L1.X1 - L2.X1)
	local n_b = (L1.X2 - L1.X1) * (L1.Y1 - L2.Y1) - (L1.Y2 - L1.Y1) * (L1.X1 - L2.X1)

	-- Calculate the intermediate fractional point that the lines potentially intersect.
	local ua = n_a / d
	local ub = n_b / d

	-- The fractional point will be between 0 and 1 inclusive if the lines
	-- intersect.  If the fractional calculation is larger than 1 or smaller
	-- than 0 the lines would need to be longer to intersect.
	if (ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1) then
		local x = L1.X1 + (ua * (L1.X2 - L1.X1))
		local y = L1.Y1 + (ua * (L1.Y2 - L1.Y1))
		return true, { x = x, y = y }
	end

	return false
end

function misc:carapaceMath(Unit1, Unit2)
	if Unit2 == nil then
		Unit2 = Unit1
		if Unit2 == "player" then
			Unit1 = "target"
		else
			Unit1 = "player"
		end
	end
	if (br.player and br.player.eID and br.player.eID == 2337) then
		local pX, pY = br.functions.unit:GetObjectPosition(Unit1)
		local tX, tY = br.functions.unit:GetObjectPosition(Unit2)
		-- local tentExists = false
		local tentCheck
		local tentX, tentY
		--[[ LibDraw.clearCanvas()
		if tX ~= nil then
			LibDraw.Line(pX,pY,pZ,tX,tY,tZ)
		end ]]
		br.tentCache = {}
		for i = 1, br._G.GetObjectCount() do
			local object = br._G.GetObjectWithIndex(i)
			local objectid = br._G.ObjectID(object)
			if objectid == 157485 then
				-- tentExists = true
				local tentFacing = br.functions.unit:GetObjectFacing(object)
				tentX, tentY = br.functions.unit:GetObjectPosition(object)
				table.insert(
					br.tentCache,
					{
						["tentFacing"] = tentFacing,
						["tentX"] = select(1, br.functions.unit:GetObjectPosition(object)),
						["tentY"] = select(2, br.functions.unit:GetObjectPosition(object)),
						["tentZ"] = select(3, br.functions.unit:GetObjectPosition(object)),
						["tentX2"] = tentX + (80 * math.cos(tentFacing)),
						["tentY2"] = tentY + (80 * math.sin(tentFacing))
					}
				)
			end
		end

		local tentfinal = {}
		if tentX ~= nil then
			for i = 1, #br.tentCache do
				if br.tentCache[i]["tentX"] ~= nil then
					local a = { x = br.tentCache[i]["tentX"], y = br.tentCache[i]["tentY"] }
					local b = { x = br.tentCache[i]["tentX2"], y = br.tentCache[i]["tentY2"] }
					local c = { x = tX, y = tY }
					local d = { x = pX, y = pY }
					if tX ~= nil then
						if misc.doLinesIntersect(a, b, c, d) then
							--[[ LibDraw.SetColor(255,0,0)
							LibDraw.Line(tentCache[i]["tentX"],tentCache[i]["tentY"],tentCache[i]["tentZ"],tentCache[i]["tentX2"],tentCache[i]["tentY2"],tentCache[i]["tentZ"])
							]]
							tentCheck =
								false
							table.insert(tentfinal, tentCheck)
							--[[ else
							LibDraw.SetColor(0,255,0)
							LibDraw.Line(tentCache[i]["tentX"],tentCache[i]["tentY"],tentCache[i]["tentZ"],tentCache[i]["tentX2"],tentCache[i]["tentY2"],tentCache[i]["tentZ"])
						]]
						end
					end
				end
			end
			if tentfinal[1] == nil or tentfinal == nil then
				return true
			else
				return false
			end
		else
			return true
		end
	end
end

function misc:getLineOfSight(Unit1, Unit2)
	if Unit2 == nil then
		Unit2 = Unit1
		if Unit2 == "player" then
			Unit1 = "target"
		else
			Unit1 = "player"
		end
	end

	-- First check: units must be visible
	if not (br.functions.unit:GetObjectExists(Unit1) and br.functions.unit:GetUnitIsVisible(Unit1) and
	        br.functions.unit:GetObjectExists(Unit2) and br.functions.unit:GetUnitIsVisible(Unit2)) then
		return false
	end

	local skipLoSTable = br.lists.los
	if skipLoSTable[br.functions.unit:GetObjectID(Unit1)] or skipLoSTable[br.functions.unit:GetObjectID(Unit2)] or -- Kyrian Hunter Ability
		(Unit1 and Unit1 ~= "player" and br.functions.aura:getDebuffRemain(Unit1, 308498) > 0) or
		(Unit2 and Unit2 ~= "player" and br.functions.aura:getDebuffRemain(Unit2, 308498) > 0)
	then
		return true
	end

	local X1, Y1, Z1 = br.functions.unit:GetObjectPosition(Unit1)
	local X2, Y2, Z2 = br.functions.unit:GetObjectPosition(Unit2)
	local pX = br.functions.unit:GetObjectPosition("player")
	local flags = bit.bor(0x10, 0x100)
	local trace
	-- Only calculate if we actually got values
	if (X1 == nil or X2 == nil or pX == nil) then return false end
	-- Trace to see if we are in Line of Sight
	if br.player and br.player.eID and (br.player.eID == 2398 or br.player.eID == 2399) then
		trace = br._G.TraceLine(X1, Y1, Z1 + 2 --[[.25]], X2, Y2, Z2 + 2 --[[.25]], 0x100111)
	else
		trace = br._G.TraceLine(X1, Y1, Z1 + 2.25, X2, Y2, Z2 + 2.25, flags)
		-- if (br._G.UnitIsUnit(Unit2,"target")) then
		-- 	br._G.print("Target Is LoS: "..tostring(trace))
		-- end
	end
	if trace == nil or trace == false then
		--Print("Past Traceline")
		if br.player and br.player.eID and br.player.eID == 2141 then
			if pX < -108 and X2 < -108 then
				return true
			elseif (pX > -108 and pX < -54) and (X2 > -108 and X2 < -54) then
				return true
			elseif pX > -54 and X2 > -54 then
				return true
			else
				return false
			end
		elseif br.player and br.player.eID and br.player.eID == 2337 then
			--Print("Past Cara Check")
			if misc:carapaceMath(Unit1, Unit2) == true then
				--Print("Cara True")
				return true
			else
				--Print("cara False")
				return false
			end
		else
			--Print("Skippped all the code")
			return true
		end
	else
		-- TraceLine returned a hit position: something blocks the line.
		return false
	end
end

-- Line of sight from the player to a world point, for ground-targeted spells. Traces
-- at the same height above both ends as getLineOfSight, as if a unit stood there.
-- if br.functions.misc:canSeePosition(x, y, z) then
function misc:canSeePosition(X2, Y2, Z2)
	if X2 == nil or Y2 == nil or Z2 == nil then return false end
	local X1, Y1, Z1 = br.functions.unit:GetObjectPosition("player")
	if X1 == nil then return false end
	return br._G.TraceLine(X1, Y1, Z1 + 2.25, X2, Y2, Z2 + 2.25, bit.bor(0x10, 0x100)) == nil
end

-- Cached player -> unit line of sight, keyed by GUID so unit tokens and object
-- pointers share entries. TraceLine is costly; cast checks hit the same few units
-- every tick. A stale "visible" costs one rejected cast, which the cast module's
-- rejection memory then catches.
local losCache = {}
local LOS_CACHE_TTL = 0.25
local LOS_CACHE_PRUNE_INTERVAL = 10
local losCacheNextPrune = 0

-- if br.functions.misc:canSee("target") then
function misc:canSee(Unit)
	if Unit == nil then return false end
	if br.functions.unit:GetUnitIsUnit(Unit, "player") then return true end
	local guid = br._G.UnitGUID(Unit)
	if guid == nil then return misc:getLineOfSight("player", Unit) end
	local now = br._G.GetTime()
	-- Drop expired entries now and then so the cache doesn't grow across a session.
	if now >= losCacheNextPrune then
		losCacheNextPrune = now + LOS_CACHE_PRUNE_INTERVAL
		for k, v in pairs(losCache) do
			if now >= v.expires then losCache[k] = nil end
		end
	end
	local entry = losCache[guid]
	if entry and now < entry.expires then return entry.los end
	local los = misc:getLineOfSight("player", Unit)
	if entry then
		entry.los, entry.expires = los, now + LOS_CACHE_TTL
	else
		losCache[guid] = { los = los, expires = now + LOS_CACHE_TTL }
	end
	return los
end

-- if getGround("target"[,"target"]) then
function misc:getGround(Unit)
	if br.functions.unit:GetObjectExists(Unit) and br.functions.unit:GetUnitIsVisible(Unit) then
		local X1, Y1, Z1 = br.functions.unit:GetObjectPosition(Unit)
		if br._G.TraceLine(X1, Y1, Z1, X1, Y1, Z1 - 2, 0x10) == nil and br._G.TraceLine(X1, Y1, Z1, X1, Y1, Z1 - 2, 0x100) == nil then
			return false
		else
			return true
		end
	end
end

function misc:getGroundDistance(Unit)
	if br.functions.unit:GetObjectExists(Unit) and br.functions.unit:GetUnitIsVisible(Unit) then
		local X1, Y1, Z1 = br.functions.unit:GetObjectPosition(Unit)
		for i = 1, 100 do
			if br._G.TraceLine(X1, Y1, Z1, X1, Y1, Z1 - i / 10, 0x10) ~= nil or br._G.TraceLine(X1, Y1, Z1, X1, Y1, Z1 - i / 10, 0x100) ~= nil then
				return i / 10
			end
		end
	else
		return 0
	end
end

-- if getPetLineOfSight("target"[,"target"]) then
function misc:getPetLineOfSight(Unit)
	if br.functions.unit:GetObjectExists(Unit) and br.functions.unit:GetUnitIsVisible("pet") and br.functions.unit:GetUnitIsVisible(Unit) then
		local X1, Y1, Z1 = br.functions.unit:GetObjectPosition("pet")
		local X2, Y2, Z2 = br.functions.unit:GetObjectPosition(Unit)
		if br._G.TraceLine(X1, Y1, Z1 + 2, X2, Y2, Z2 + 2, 0x10) == nil then
			return true
		else
			return false
		end
	else
		return true
	end
end

--- Round
function misc:round2(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- if getTalent(8) == true then
function misc:getTalent(Row, Column, specGroup)
	if specGroup == nil then
		specGroup = br._G.C_SpecializationInfo.GetActiveSpecGroup()
	end
	local _, _, _, selected = br._G.GetTalentInfo(Row, Column, specGroup)
	return selected or false
end

-- if hasEmptySlots() then
function misc:hasEmptySlots()
	local openSlots = 0
	for i = 0, 4 do       --Let's look at each bag
		local numBagSlots = br._G.C_Container.GetContainerNumSlots(i)
		if numBagSlots > 0 then -- Only look for slots if bag present
			openSlots = openSlots + select(1, br._G.C_Container.GetContainerNumFreeSlots(i))
		end
	end
	if openSlots > 0 then
		return true
	else
		return false
	end
end

-- UnitGUID("target"):sub(-15,-10)

--if isGarrMCd() then
function misc:isGarrMCd(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if br.functions.unit:GetUnitExists(Unit) and (br.functions.aura:UnitDebuffID(Unit, 145832) or br.functions.aura:UnitDebuffID(Unit, 145171) or br.functions.aura:UnitDebuffID(Unit, 145065) or br.functions.aura:UnitDebuffID(Unit, 145071)) then
		return true
	else
		return false
	end
end

-- if isInCombat("target") then
function misc:isInCombat(Unit)
	if br._G.UnitAffectingCombat(Unit) or br.functions.misc:isChecked("Ignore Combat") then
		return true
	else
		return false
	end
end

function misc:isInArdenweald()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.Ardenweald, mapID)
end

function misc:isInBastion()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.Bastion, mapID)
end

function misc:isInMaldraxxus()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.Maldraxxus, mapID)
end

function misc:isInRevendreth()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.Revendreth, mapID)
end

function misc:isInTheMaw()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.TheMaw, mapID)
end

-- if isInDraenor() then
function misc:isInDraenor()
	local tContains = br._G.tContains
	local currentMapID = br._G.C_Map.GetBestMapForUnit("player")
	local draenorMapIDs = br.lists.maps.Draenor
	return tContains(draenorMapIDs, currentMapID)
end

function misc:isInLegion()
	local tContains = br._G.tContains
	local currentMapID = br._G.C_Map.GetBestMapForUnit("player")
	local legionMapIDs = br.lists.maps.Legion
	return tContains(legionMapIDs, currentMapID)
end

function misc:isInProvingGround()
	local currentMapID = br._G.C_Map.GetBestMapForUnit("player")
	return currentMapID == 480
end

-- if IsInPvP() then
function misc:isInPvP()
	local inpvp = br._G.GetPVPTimer()
	if (inpvp ~= 301000 and inpvp ~= -1) or (br._G.UnitIsPVP("player") and br._G.UnitIsPVP("target")) then
		return true
	else
		return false
	end
end

--if isLongTimeCCed("target") then
-- CCs with >=20 seconds
function misc:isLongTimeCCed(Unit)
	if Unit == nil then
		return false
	end
	local longTimeCC = br.lists.longCC
	for i = 1, 40 do
		local auraInfo = br.api.wow.GetDebuffDataByIndex(Unit, i)
		if auraInfo and longTimeCC[tonumber(auraInfo.spellId)] == true then return true end
	end
	return false
end

-- if isLooting() then
function misc:isLooting()
	return br._G.GetNumLootItems() > 0
end

-- if not isMoving("target") then
function misc:isMoving(Unit)
	if Unit == nil then
		return false
	end
	return br._G.GetUnitSpeed(Unit) > 0
end

function misc:isPlayer(Unit)
	if br.functions.unit:GetUnitExists(Unit) ~= true then
		return false
	end
	if br._G.UnitIsPlayer(Unit) == true then
		return true
	elseif br._G.UnitIsPlayer(Unit) ~= true then
		local playerNPC = {
			[72218] = "Oto the Protector",
			[72219] = "Ki the Asssassin",
			[72220] = "Sooli the Survivalist",
			[72221] = "Kavan the Arcanist"
		}
		if playerNPC[tonumber(string.match(br._G.UnitGUID(Unit), "-(%d+)-%x+$"))] ~= nil then
			return true
		end
	else
		return false
	end
end

-- True if the player has stood still (and isn't falling) for at least Seconds.
-- if br.functions.misc:isStanding(2) then
function misc:isStanding(Seconds)
	return not br._G.IsFalling() and misc:getStandingTime() >= (Seconds or 0)
end

-- if isValidTarget("target") then
function misc:isValidTarget(Unit)
	if br._G.UnitIsEnemy("player", Unit) or br.functions.unit:isDummy(Unit) then
		if br.functions.unit:GetUnitExists(Unit) and not br.functions.unit:GetUnitIsDeadOrGhost(Unit) then
			return true
		else
			return false
		end
	else
		if br.functions.unit:GetUnitExists(Unit) then
			return true
		else
			return false
		end
	end
end

function misc:isTargeting(Unit, MatchUnit)
	if br.functions.unit:GetUnit(Unit) == nil then
		return false
	end
	if br._G.UnitTarget(br.functions.unit:GetUnit(Unit)) == nil then
		return false
	end
	if MatchUnit == nil then
		MatchUnit = "player"
	end
	return br._G.UnitTarget(br.functions.unit:GetUnit(Unit)) == br._G.ObjectPointer(MatchUnit)
end

function misc:hasTank()
	if #br.engines.healingEngine.friend == 1 then return false end
	for i = 1, #br.engines.healingEngine.friend do
		local thisUnit = br.engines.healingEngine.friend[i].unit
		if br._G.UnitGroupRolesAssigned(thisUnit) == "TANK"
			and br.functions.range:getDistance(thisUnit) < 40 and br._G.UnitIsPlayer(thisUnit)
		then
			return true
		end
	end
	return false
end

function misc:enemyListCheck(Unit)
	-- local targetBuff = 0
	-- local playerBuff = 0
	-- if br.functions.aura:UnitDebuffID(Unit, 310499) then
	-- 	targetBuff = 1
	-- end
	-- if br.functions.aura:UnitDebuffID("player", 310499) then
	-- 	playerBuff = 1
	-- end
	-- if targetBuff ~= playerBuff then
	-- 	if br.functions.misc:isChecked("Enemy List Debug") then
	-- 		br._G.print("[EnemyListCheck] Phase sync failed for " .. tostring(br._G.UnitName(Unit)))
	-- 	end
	-- 	return false
	-- end
	local phaseReason = br._G.UnitInPhase(Unit)--br._G.UnitPhaseReason(Unit)
	local distance = br.functions.range:getDistance(Unit, "player")
	local mcCheck = (br.functions.misc:isChecked("Attack MC Targets") and (not br.functions.unit:GetUnitIsFriend(Unit, "player") or br._G.UnitIsCharmed(Unit))) or
		not br.functions.unit:GetUnitIsFriend(Unit, "player")
	local inPhase = phaseReason--not phaseReason or phaseReason == 2 or phaseReason == 3
	if br._G.UnitIsPlayer(Unit) and (br.functions.aura:UnitDebuffID("player", 320102) or br.functions.aura:UnitDebuffID(Unit, 424495)) then
		return true
	end
	-- Check if unit was created by player, but allow quest NPCs that turn hostile (like Peak of Serenity monks)
	-- UnitReaction: 1=Hated, 2=Hostile, 3=Unfriendly, 4=Neutral, 5+=Friendly
	local createdByPlayer = br._G.UnitCreator(Unit) == br._G.ObjectPointer("player")
	local unitReaction = br._G.UnitReaction(Unit, "player") or 5
	local isHostileQuestNPC = createdByPlayer and unitReaction < 4 -- Hostile/Unfriendly reaction

	-- Perform all cheap checks as individual locals (no table allocation in this hot path)
	local checkExists   = br.functions.unit:GetObjectExists(Unit)
	local checkNotDead  = not br.functions.unit:GetUnitIsDeadOrGhost(Unit)
	local checkCanAttack = br._G.UnitCanAttack("player", Unit)
	local checkHasHealth = br._G.UnitHealth(Unit) > 0
	local checkInRange   = distance < 50
	local checkNotCritter = not br.functions.unit:isCritter(Unit)
	local checkNotPet    = not br.functions.unit:GetUnitIsUnit(Unit, "pet")
	local checkCreator   = (not createdByPlayer or isHostileQuestNPC)
	local checkNotWaterEle = br.functions.unit:GetObjectID(Unit) ~= 11492

	-- Expensive LoS check only done if other checks pass (early exit optimization)
	local basicChecks = checkExists and checkNotDead and checkCanAttack and checkHasHealth
		and checkInRange and checkNotCritter and mcCheck and checkNotPet
		and checkCreator and checkNotWaterEle

	if not basicChecks then
		return false -- Early exit before expensive LoS check
	end

	-- OPTIMIZATION: More aggressive LoS check skipping to reduce FPS impact
	-- Skip LoS check entirely for:
	-- 1. Close enemies (<15y) - always reachable
	-- 2. Units in combat - already engaged
	-- 3. Mid-range units (15-40y) - perform check to maintain accuracy for prowl/pre-combat detection
	-- 4. Distant units (>40y) - skip unless damaged or targeting us
	local isDamagedUnit = br.engines.enemiesEngine.damaged and br.engines.enemiesEngine.damaged[br._G.ObjectPointer(Unit)] ~= nil
	local isTargetingUs = br.functions.misc:isTargeting(Unit)
	local los = true -- Default to true (skip check)

	if distance >= 15 and not br._G.UnitAffectingCombat(Unit) then
		-- CRITICAL: Always check LoS for mid-range units (15-40y) to support pre-emptive prowling/stealth detection
		-- These checks are needed for Feral pre-emptive prowl, Rogue stealth prep, etc.
		if distance <= 40 then
			los = br.functions.misc:getLineOfSight("player", Unit)
		elseif isDamagedUnit or isTargetingUs then
			-- Distant but important: damaged or targeting us
			los = br.functions.misc:getLineOfSight("player", Unit)
		else
			-- Very distant (>40y), not damaged, not targeting: skip LoS check, assume no LoS
			-- These units are too far to matter for gameplay
			los = false
		end
	end

	local allPass = basicChecks and los
		and ((Unit ~= 131824 and Unit ~= 131823 and Unit ~= 131825) or ((br.functions.aura:UnitBuffID(Unit, 260805)
			or br.functions.unit:GetUnitIsUnit(Unit, "target")) and (Unit == 131824 or Unit == 131823 or Unit == 131825)))

	return allPass
end

function misc:isValidUnit(Unit)
	if Unit == nil then
		return false
	end

	local now = br._G.GetTime()
	local guid = br._G.UnitGUID(Unit)

	-- PRIORITY: Units in damaged table bypass most validation checks
	-- These are units actively in combat with our group (attacking or being attacked)
	-- The combatlog cleanup already ensures these units are valid (exists, alive, attackable)
	-- damaged table keys are pointers from GetObjectWithGUID()
	-- damaged table values are unitSetup objects where .unit is also the pointer
	-- HOWEVER, we still need to check line of sight to prevent casting on units behind walls
	if br.engines.enemiesEngine.damaged then
		local unitPointer = br._G.ObjectPointer(Unit)
		-- Direct pointer lookup - ObjectPointer() should match GetObjectWithGUID() for same unit
		if unitPointer and br.engines.enemiesEngine.damaged[unitPointer] ~= nil then
			return true
		end
	end

	-- Short-circuit cache for the expensive validation path (TTL: 0.05s combat, 0.10s out-of-combat)
	if guid then
		if now - lastIsValidUnitCleanup > 1.0 then
			for k, v in pairs(isValidUnitCache) do
				if now - v.time > 0.5 then isValidUnitCache[k] = nil end
			end
			lastIsValidUnitCleanup = now
		end
		local cached = isValidUnitCache[guid]
		if cached then
			local ttl = br._G.UnitAffectingCombat("player") and 0.05 or 0.10
			if now - cached.time < ttl then return cached.value end
		end
	end

	-- Calculate all conditions once
	local unitPointer = br._G.ObjectPointer(Unit)
	local hostileOnly = br.functions.misc:isChecked("Hostiles Only")
	local playerTarget = br.functions.unit:GetUnitIsUnit(Unit, "target")
	local reaction = br.functions.unit:GetUnitReaction(Unit, "player") or 10
	local targeting = br.functions.misc:isTargeting(Unit)
	-- Dummies have special handling:
	-- They should only be treated as "valid" when they are your current target OR
	-- when you have a dummy targeted and this unit is within 8 yards of that targeted dummy.
	-- Otherwise, dummies follow the standard validation path (and generally won't be considered valid without threat/targeting).
	local isDummy = br.functions.unit:isDummy(Unit)
	local dummyEligible = false
	if isDummy then
		if playerTarget then
			dummyEligible = true
		else
			-- Nearby-dummy allowance for cleave testing: allow other dummies near the targeted dummy.
			if br.functions.unit:GetObjectExists("target") and br.functions.unit:isDummy("target") then
				local distToTarget = br.functions.range:getDistance(Unit, "target")
				if distToTarget ~= nil and distToTarget <= 8 then
					dummyEligible = true
				end
			end
		end
	end
	local burnUnit = br.functions.misc:getOptionCheck("Forced Burn") and br.engines.enemiesEngineFunctions:isBurnTarget(Unit) > 0
	local isCC = br.functions.misc:getOptionCheck("Don't break CCs") and br.functions.misc:isLongTimeCCed(Unit) or false
	local mcCheck = (br.functions.misc:isChecked("Attack MC Targets") and (not br.functions.unit:GetUnitIsFriend(Unit, "player") or (br._G.UnitIsCharmed(Unit) and br._G.UnitCanAttack("player", Unit))))
		or not br.functions.unit:GetUnitIsFriend(Unit, "player")

	-- Early exit for PvP debuffs (special case)
	if playerTarget and br._G.UnitIsPlayer(Unit) and (br.functions.aura:UnitDebuffID("player", 320102) or br.functions.aura:UnitDebuffID(Unit, 424495)) then
		if guid then isValidUnitCache[guid] = { value = true, time = now } end
		return true
	end

	-- Check if unit is tapped but we've damaged it
	local isTapped = br._G.UnitIsTapDenied(Unit)
	local hasDamagedTapped = isTapped and br.engines.enemiesEngine.damaged[unitPointer] ~= nil

	-- Check if unit actually passed enemyListCheck or is in units table
	-- If it's the player target but not in units table, verify it at least passes basic enemyListCheck
	-- Also allow units that have threat on the group (targeting tank/party) even if not in units table yet
	local inUnitsTable = br.engines.enemiesEngine.units[Unit] ~= nil
	local hasThreat = br.functions.combat:hasThreat(Unit)
	local passedEnemyCheck = inUnitsTable or (playerTarget and br.functions.misc:enemyListCheck(Unit)) or burnUnit or dummyEligible or hasThreat

	-- Fast path for special units (dummy/burn) - skip most checks
	if passedEnemyCheck and mcCheck and not isCC and (dummyEligible or burnUnit) then
		if guid then isValidUnitCache[guid] = { value = true, time = now } end
		return true
	end

	-- Standard validation path
	if passedEnemyCheck and mcCheck and not isCC
		and (hasDamagedTapped or (not isTapped and br.engines.enemiesEngineFunctions:isSafeToAttack(Unit)
			and ((hostileOnly and reaction < 4) or (not hostileOnly and reaction < 5) or playerTarget or targeting)))
	then
		-- Valid if any threat condition is met:
		-- Player target, unit targeting us, burn target, proving grounds, or has group threat
		local result = playerTarget or targeting or burnUnit or br.functions.misc:isInProvingGround() or hasThreat
		if guid then isValidUnitCache[guid] = { value = result, time = now } end
		return result
	end

	if guid then isValidUnitCache[guid] = { value = false, time = now } end
	return false
end

function misc:SpecificToggle(toggle)
	if br.customToggle then
		return false
	elseif br.functions.misc:getOptionValue(toggle) == 1 then
		return br._G.IsLeftControlKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 2 then
		return br._G.IsLeftShiftKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 3 then
		return br._G.IsRightControlKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 4 then
		return br._G.IsRightShiftKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 5 then
		return br._G.IsRightAltKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 6 then
		return false
	elseif br.functions.misc:getOptionValue(toggle) == 7 then
		return br._G.GetKeyState(0x04)
	elseif br.functions.misc:getOptionValue(toggle) == 8 then
		return br._G.GetKeyState(0x05)
	elseif br.functions.misc:getOptionValue(toggle) == 9 then
		return br._G.GetKeyState(0x06)
	elseif br.functions.misc:getOptionValue(toggle) == 10 then
		return br._G.GetKeyState(0xC0)
	end
end

function misc:UpdateToggle(toggle, delay)
	--if toggle == nil then toggle = "toggle" end
	if br.customToggle then
		toggle = br.toggleKey
	end
	if br._G[toggle .. "Timer"] == nil then
		br._G[toggle .. "Timer"] = 0
	end
	if (br.functions.misc:SpecificToggle(toggle .. " Mode") or br.customToggle) and not br._G.GetCurrentKeyBoardFocus() and br._G.GetTime() - br._G[toggle .. "Timer"] > delay then
		br._G[toggle .. "Timer"] = br._G.GetTime()
		br.ui:UpdateButton(tostring(toggle))
	end
end

function misc:BurstToggle(toggle, delay)
	if br.burstKey == nil then
		br.burstKey = false
	end
	if br._G[toggle .. "Timer"] == nil then
		br._G[toggle .. "Timer"] = 0
	end
	if br.burst and not br._G.GetCurrentKeyBoardFocus() and br._G.GetTime() - _G[toggle .. "Timer"] > delay then
		if not br.burstKey then
			br._G[toggle .. "Timer"] = br._G.GetTime()
			br.burstKey = true
		else
			br._G[toggle .. "Timer"] = br._G.GetTime()
			br.burstKey = false
		end
	end
end

-- if pause() then
-- set skipCastingCheck to true, to not check if player is casting
-- (useful if you want to use off-cd stuff, or spells which can be cast while other is casting)
misc.pauseCast = br._G.GetTime()

-- Channels the player can freely act through — moving, attacking, or casting does NOT
-- cancel them — so the rotation must NOT pause while they tick (otherwise we just stand
-- there taking damage until the channel's own timer ends).
--
-- Opt-in per spell on purpose: the default "pause during any channel" behavior is correct
-- for normal channels, where acting would clip them. Reference each by its spell-list name
-- (the actual ID lives in br.lists.spells.Shared.Shared.abilities — e.g. fumping = 39238 in
-- Expansions/TBC/Global.lua). To capture a new channel's ID, run this WHILE channeling it:
--     /run print((select(8, UnitChannelInfo("player"))))
local nonBlockingChannelNames = {
	"fumping", -- Fumper (item 31810, TBC quest "Fumping"): surfaces a hostile bone sifter
}
-- Resolved { [spellID] = true } lookup, built lazily on first pause() call (the spell lists
-- load after this file). Names absent on the active expansion resolve to nil and are
-- skipped, so this is safe to share across Classic/TBC/MOP/Retail.
local nonBlockingChannels

function misc:pause(skipCastingCheck)
	-- Cache GetTime() once — used repeatedly below.
	local now = br._G.GetTime()
	local pausekey

	-- ── List references (IDs live in Retail/Global.lua + System/Lists/Items.lua) ──
	local sb    = br.lists.spells.Shared.Shared.buffs      -- Shared.buffs
	local sa    = br.lists.spells.Shared.Shared.abilities  -- Shared.abilities
	local sd    = br.lists.spells.Shared.Shared.debuffs    -- Shared.debuffs
	local items = br.lists.items

	-- Resolve the act-through-channel ID set once, now that the spell lists are loaded.
	if nonBlockingChannels == nil and sa then
		nonBlockingChannels = {}
		for i = 1, #nonBlockingChannelNames do
			local id = sa[nonBlockingChannelNames[i]]
			if id then nonBlockingChannels[id] = true end
		end
	end

	-- ── Fast-path exits (cheapest checks first) ────────────────────────────
	-- Dead (health = 0 or ghost-running). UnitIsDeadOrGhost is more thorough
	-- but UnitHealth == 0 is the fastest pre-filter for the fully-dead state.
	if br._G.UnitHealth("player") == 0 then return true end
	if br.disableControl == true then return true end

	-- ── Deferred locals (only evaluated after cheap early exits) ───────────
	local eating   = br.functions.unit:isEating()
	local drinking = br.functions.unit:isDrinking()

	-- ── Pause key resolution ───────────────────────────────────────────────
	if br.functions.misc:SpecificToggle("Pause Mode") == nil or br.functions.misc:getValue("Pause Mode") == 6 then
		pausekey = br._G.IsLeftAltKeyDown()
	else
		pausekey = br.functions.misc:SpecificToggle("Pause Mode")
	end

	-- ── BFA item channel lock (Retail only) ───────────────────────────────
	-- Focused Azerite Beam (295258→295261), Cyclotronic Blast (293491),
	-- and Azshara's Font of Power / Latent Arcana (296962) each trigger a
	-- follow-up channel that must complete uninterrupted. misc.pauseCast
	-- stores the timestamp at which the follow-up finishes.
	if br.api.hasBFAItemChannels and not skipCastingCheck then
		local lastCast = br.functions.lastCast.lastCastTable.tracker[1]
		if misc.pauseCast - now <= 0 then
			local hasted = (1 - br._G.UnitSpellHaste("player") / 100)
			-- Focused Azerite Beam
			if lastCast == sa.focusedAzeriteBeam and br.functions.spell:getSpellCD(sa.focusedAzeriteBeam) == 0 then
				misc.pauseCast = now + br.functions.cast:getCastTime(sa.focusedAzeriteBeam) + (br.functions.cast:getCastTime(sa.focusedAzeriteBeamChannel) * hasted)
			end
			-- Cyclotronic Blast
			if lastCast == sa.cyclotronicBlast and br._G.C_Container.GetItemCooldown(items.pocketSizedComputationDevice) == 0 then
				misc.pauseCast = now + br.functions.cast:getCastTime(sa.cyclotronicBlast) + (2.5 * hasted) + br.functions.spell:getGlobalCD(true)
			end
			-- Azshara's Font of Power - Latent Arcana
			if lastCast == sb.latentArcana and br._G.C_Container.GetItemCooldown(items.azsharasFontOfPower) == 0 then
				misc.pauseCast = now + br.functions.cast:getCastTime(sb.latentArcana) + (2.5 * hasted)
			end
		end
		if now < misc.pauseCast then
			return true
		else
			misc.pauseCast = now
		end
	end

	-- ── DPS Testing timer ──────────────────────────────────────────────────
	if br.functions.misc:isChecked("DPS Testing") then
		if br.functions.unit:GetObjectExists("target") and br.functions.misc:isInCombat("player") then
			if br.functions.combat:getCombatTime() >= (tonumber(br.functions.misc:getOptionValue("DPS Testing")) * 60) and br.functions.unit:isDummy() then
				br._G.StopAttack()
				br._G.ClearTarget()
				br._G.print(tonumber(br.functions.misc:getOptionValue("DPS Testing")) ..
					" Minute Dummy Test Concluded - Profile Stopped")
				br.profileStop = true
			else
				br.profileStop = false
			end
		elseif not br.functions.misc:isInCombat("player") and br.profileStop == true then
			if br.functions.unit:GetObjectExists("target") then
				br._G.StopAttack()
				br._G.ClearTarget()
				br.profileStop = false
			end
		end
	end

	-- ── Pause Toggle (UI button) ───────────────────────────────────────────
	if br.data.settings[br.loader.selectedSpec].toggles ~= nil and br.data.settings[br.loader.selectedSpec].toggles["Pause"] == 1 then
		br.ui.chatOverlay:Show("\124cFFED0000 -- Paused -- ")
		return true
	end

	-- ── Build named conditions for the main halt check ────────────────────

	-- Pause key held with keyboard focus clear and option enabled.
	local isPauseKey = pausekey and br._G.GetCurrentKeyBoardFocus() == nil and br.functions.misc:isChecked("Pause Mode")

	-- Mounted or flying — but NOT when targeting a boss. Some outdoor/encounter
	-- sequences require the rotation to function while the player is airborne
	-- (e.g. Netherwing Drake quests, outdoor world bosses with flying phases).
	-- UnitOnTaxi covers flight paths.
	-- Vehicle: pause unless "Bypass Vehicle Check" is on, OR the player has a
	-- valid attackable target (combat vehicles like Siege Engine, gunship, etc.).
	-- Exception: Draenor Nagrand mounts (164222/165803/157059) are combat mounts
	-- that allow normal spellcasting; Divine Steed (190784) is a Paladin
	-- mobility buff that briefly triggers IsMounted but permits combat.
	local nagrandMount = br.functions.aura:UnitBuffID("player", sb.divineSteed)
		or br.functions.aura:UnitBuffID("player", sb.nagrandTalbuk)
		or br.functions.aura:UnitBuffID("player", sb.nagrandClefthoof)
		or br.functions.aura:UnitBuffID("player", sb.nagrandRidingClefthoof)
		or br.functions.aura:UnitBuffID("player", sb.nagrandGoat)
	local isMobilized = not nagrandMount and (
		((br._G.IsMounted() or br._G.IsFlying()) and not br.functions.unit:isBoss("target"))
		or br._G.UnitOnTaxi("player")
		or (br._G.UnitInVehicle("player")
			and not br.functions.misc:isChecked("Bypass Vehicle Check")
			and not (br._G.UnitExists("target") and br._G.UnitCanAttack("player", "target")))
	)

	-- Casting / channeling a spell (with latency window handled in the then-block).
	local isCasting   = not skipCastingCheck and br._G.UnitCastingInfo("player") ~= nil
	-- Channeling pauses the rotation EXCEPT for act-through channels (nonBlockingChannels):
	-- those let us move/attack/cast without clipping them, so we keep running and fight back.
	local channelName, _, _, _, _, _, _, channelSpellID = br._G.UnitChannelInfo("player")
	local isChanneling = not skipCastingCheck and channelName ~= nil
		and not (channelSpellID and nonBlockingChannels and nonBlockingChannels[channelSpellID])

	-- Dead, eating, drinking, specific channeled debuffs/buffs.
	-- 252753 = Potion of Replenishment (BFA mana channel — registered as a debuff).
	-- 114018 = Shroud of Concealment (Rogue group stealth, MOP+); rotation should
	--          remain idle while the group is sneaking.
	local isIncapacitated = br._G.UnitIsDeadOrGhost("player")
		or eating or drinking
		or br.functions.aura:UnitDebuffID("player", sd.potionOfReplenishment)
		or br.functions.aura:UnitBuffID("player", sb.shroudOfConcealment)

	-- Pet battle: player character is completely locked during a pet battle UI.
	-- C_PetBattles exists on MOP+ only; nil-guarded for Classic/TBC safety.
	local inPetBattle = br._G.C_PetBattles and br._G.C_PetBattles.IsInBattle and br._G.C_PetBattles.IsInBattle()

	-- Mind Control / Charm: player is controlled by an enemy and cannot act.
	-- On Classic/TBC/MOP, hasCharmBreakTracking = false, so this always pauses
	-- (no C_LossOfControl infrastructure exists on those clients).
	-- On Retail, hasCharmBreakTracking = true: pause by default, but a rotation
	-- that implements a charm-break ability (e.g. DK Lichborne) can enable the
	-- "Bypass CC Pause" option to let Cast.lua's per-spell cannotCast() gate
	-- handle the MC instead of halting the entire rotation here.
	local isCharmed = br._G.UnitIsCharmed("player")
		and (not br.api.hasCharmBreakTracking or not br.functions.misc:isChecked("Bypass CC Pause"))

	-- ── Spell-targeting cursor active (player clicked a targeted spell) ────
	local isTargeting = br._G.SpellIsTargeting()

	-- ── Main halt condition ────────────────────────────────────────────────
	if isPauseKey or br.profileStop
		or isMobilized or isTargeting
		or isCasting or isChanneling
		or isIncapacitated or inPetBattle or isCharmed
	then
		-- Evoker empowered spells must continue updating their charge stage even
		-- while the outer condition would normally halt everything. Only the
		-- deliberate pause-key press overrides this.
		if br.empowerID ~= nil and br.empowerID > 0 and not isPauseKey then
			return false
		end

		-- Casting: stay paused until the cast is inside the spell queue window, then
		-- run the profile once to pre-cast whatever it ranks highest. After that
		-- choice is sent, stay paused until this cast ends so nothing replaces it.
		-- Only in combat: a pull spell's window falls before its bolt lands, so out of
		-- combat the profile would pre-cast a second pull spell instead of letting the
		-- first decision after the pull use its in-combat priorities.
		if isCasting then
			local _, _, _, _, endTime, _, castID = br._G.UnitCastingInfo("player")
			local window = br._G.UnitAffectingCombat("player") and br.functions.cast:getQueueWindow() or 0
			if (endTime / 1000 - now) > window then
				return true
			end
			if br.functions.cast:isQueuedBehind(castID, endTime) then
				return true
			end
			-- Inside the queue window and nothing pre-cast yet — fall through.
		else
			br.ui.chatOverlay:Show("Profile Paused")
			return true
		end
	end

	return false
end

-- feed a var
function misc:toggleTrueNil(var)
	if _G[var] ~= true then
		_G[var] = true
	else
		_G[var] = nil
	end
end

function misc:spellDebug(Message)
	if br.imDebugging == true and br.functions.misc:getOptionCheck("Debugging Mode") then
		br.ui.chatOverlay:Show(Message)
	end
end

-- Option index: where each option lives (storage page) and its default, recorded by the UI
-- elements as they are created (br.ui:createCheckbox / createSpinner / createDropdown / ...).
-- Lookups go straight to the option's page instead of searching every page.
local optionIndex = {}      -- [option key, e.g. "Auto Loot Check"] = page
local optionDefaults = {}   -- [page] = { [option key] = default }
local fallbackPages = {}    -- pages found by searching before the option was registered
local warnedDuplicates = {}

--- Records an option's page and default (called by the UI elements).
-- The first page an option is created on wins; another page with the same option is reported once.
function misc:registerOption(page, key, default)
	if page == nil or key == nil then return end
	optionDefaults[page] = optionDefaults[page] or {}
	optionDefaults[page][key] = default
	local known = optionIndex[key]
	if known == nil then
		optionIndex[key] = page
	elseif known ~= page and not warnedDuplicates[key] then
		warnedDuplicates[key] = true
		br._G.print("|cffFF8800Option \"" .. key .. "\" exists on pages \"" .. known .. "\" and \"" .. page
			.. "\"; using \"" .. known .. "\". Rename one of them.|r")
	end
end

--- Clears the option index (a new profile's pages are about to be built).
function misc:resetOptionIndex()
	optionIndex = {}
	optionDefaults = {}
	fallbackPages = {}
end

--- Page -> { option key -> default } for every registered option (used by the save guard).
function misc:getOptionDefaults()
	return optionDefaults
end

local function findOption(Value, Page, Type)
	if Type == nil then Type = " Check" end
	local notFound = 0
	if Type == " Check" then notFound = false end
	-- A nil or secret option name can't be a real option
	if Value == nil or (issecretvalue and issecretvalue(Value)) then return notFound end
	local specSettings = br.data and br.data.settings and br.data.settings[br.loader.selectedSpec]
	local settings = specSettings and specSettings[br.loader.selectedProfile]
	if settings == nil then return notFound end
	local option = Value .. Type
	-- An explicit page that holds the option
	if Page ~= nil and settings[Page] ~= nil and settings[Page][option] ~= nil then
		return settings[Page][option]
	end
	-- The page the option was created on (or found on earlier)
	local page = optionIndex[option] or fallbackPages[option]
	if page ~= nil then
		local pageSettings = settings[page]
		if pageSettings ~= nil and pageSettings[option] ~= nil then return pageSettings[option] end
		if optionIndex[option] ~= nil then return notFound end
	end
	-- Not registered yet (UI not built, or Power off): find it once and remember the page
	for pageName, pageSettings in pairs(settings) do
		if type(pageSettings) == "table" and pageName ~= "PageList" and pageSettings[option] ~= nil then
			fallbackPages[option] = pageName
			return pageSettings[option]
		end
	end
	return notFound
end

-- if br.functions.misc:isChecked("Debug") then
function misc:isChecked(Value, Page)
	if Value == nil then return false end
	return findOption(Value, Page, " Check")
end

-- if br.functions.misc:isSelected("Stormlash Totem") then
function misc:isSelected(Value)
	if br.data.settings ~= nil
		and (br.data.settings[br.loader.selectedSpec].toggles["Cooldowns"] == 3
			or (br.functions.misc:isChecked(Value) and (br.functions.misc:getValue(Value) == 3
				or (br.functions.misc:getValue(Value) == 2 and br.data.settings[br.loader.selectedSpec].toggles["Cooldowns"] == 2))))
	then
		return true
	end
	return false
end

-- if br.functions.misc:getValue("player") <= br.functions.misc:getValue("Eternal Flame") then
-- function misc:getValue(Value)
-- 	if br.data~=nil then
-- 		if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]~=nil then
-- 	        if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][Value.."Status"] ~= nil then
-- 	            return br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][Value.."Status"]
-- 	        elseif br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][Value.."Drop"] ~= nil then
-- 	            return br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][Value.."Drop"]
-- 	        else
-- 	            return 0
-- 	        end
-- 		end
-- 	else
-- 		return 0
-- 	end
-- end
function misc:getValue(Value, Page)
	local statusValue = findOption(Value, Page, " Status")
	if statusValue and statusValue > 0 then
		return statusValue
	end
	local dropValue = findOption(Value, Page, " Drop")
	if dropValue and dropValue > 0 then
		return dropValue
	end
	local editBoxValue = findOption(Value, Page, " EditBox")
	if editBoxValue then
		return editBoxValue
	end
	-- if br.data ~= nil and br.data.settings ~= nil then
	-- 	local selectedProfile = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
	-- 	if selectedProfile ~= nil then
	-- 		if selectedProfile[Value .. "EditBox"] ~= nil then
	-- 			return selectedProfile[Value .. "EditBox"]
	-- 		end
	-- 	end
	-- end
	return 0
	-- if br.data ~= nil and br.data.settings ~= nil then
	-- 	local selectedProfile = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
	-- 	if selectedProfile ~= nil then
	-- 		if selectedProfile[Value .. "Status"] ~= nil then
	-- 			return selectedProfile[Value .. "Status"]
	-- 		elseif selectedProfile[Value .. "Drop"] ~= nil then
	-- 			return selectedProfile[Value .. "Drop"]
	-- 		elseif selectedProfile[Value .. "EditBox"] ~= nil then
	-- 			return selectedProfile[Value .. "EditBox"]
	-- 		else
	-- 			return 0
	-- 		end
	-- 	end
	-- else
	-- 	return 0
	-- end
end

function misc:setValue(Value, Page, Amount)
	local statusValue = findOption(Value, Page, " Status")
	if statusValue and statusValue > 0 then
		statusValue:SetNumber(Amount)
	end
	local dropValue = findOption(Value, Page, " Drop")
	if dropValue and dropValue > 0 then
		dropValue:SetNumber(Amount)
	end
	local editBoxValue = findOption(Value, Page, " EditBox")
	if editBoxValue then
		editBoxValue:SetNumber(Amount)
	end
end

-- used to gather informations from the bot options frame
function misc:getOptionCheck(Value)
	return br.functions.misc:isChecked(Value)
end

function misc:getOptionValue(Value)
	return br.functions.misc:getValue(Value)
end

function misc:setOptionValue(Value, Amount)
	return br.functions.misc:setValue(Value, nil, Amount)
end

function misc:getOptionText(Value)
	if br.data ~= nil and br.data.settings ~= nil then
		local selectedProfile = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
		if selectedProfile ~= nil then
			if selectedProfile[Value .. "Data"] ~= nil then
				if selectedProfile[Value .. "Drop"] ~= nil then
					if selectedProfile[Value .. "Data"][selectedProfile[Value .. "Drop"]] ~= nil then
						return selectedProfile[Value .. "Data"][selectedProfile[Value .. "Drop"]]
					end
				end
			end
		end
	end
	return ""
end

function misc:convertName(name)
	if name ~= nil then
		-- Remove hyphens and lowercase the letter that follows
		name = name:gsub("-(%a)", function(letter)
			return letter:lower()
		end)
		-- Cap All First Letters of Words
		name = name:gsub("(%a)([%w_']*)", function(first, rest)
			return first:upper() .. rest:lower()
		end)
		-- Lower first character of name
		name = name:gsub("%a", string.lower, 1)
		-- Remove all non alphanumeric in string
		name = name:gsub("%W", "")
		return name
	end
	return "None"
end

function misc:devMode()
	if br.functions.misc:isChecked("Dev Mode") then
		if _G.br == nil then
			_G.br = br
			br._G.print("<Dev Mode Enabled>")
		end
	else
		if _G.br ~= nil then
			_G.br = nil
			br._G.print("<Dev Mode Disabled>")
		end
	end
end

function misc:bossHPLimit(unit, hp)
	-- Boss Active/Health Max
	local bossHPMax = 0
	local inBossFight = false
	local enemyList = br.engines.enemiesEngineFunctions:getEnemies("player", 40)
	for i = 1, #enemyList do
		local thisUnit = enemyList[i]
		if br.functions.unit:isBoss(thisUnit) then
			bossHPMax = br._G.UnitHealthMax(thisUnit)
			inBossFight = true
			break
		end
	end
	return (not inBossFight or (inBossFight and br._G.UnitHealthMax(unit) > bossHPMax * (hp / 100)))
end

function misc:talentAnywhere()
	local removeTalent = br._G.RemoveTalent
	local learnTalent = br._G.LearnTalent
	-- Load Talent UI if not opened before
	if not br._G.C_AddOns.IsAddOnLoaded("Blizzard_TalentUI") and not br._G.UnitAffectingCombat("player") then
		br._G.LoadAddOn("Blizzard_TalentUI")
	end

	local function talentSelection(row)
		for column = 1, 3 do
			if
				br._G.IsMouseButtonDown(1) and br.newTalent == nil and br._G.MouseIsOver(_G["PlayerTalentFrameTalentsTalentRow" .. row .. "Talent" .. column]) and
				not select(4, br._G.GetTalentInfoByID(br._G.GetTalentInfo(row, column, 1), 1))
			then
				br.selectedTalent = nil
				br.newTalent = select(1, br._G.GetTalentInfo(row, column, 1))
				br.newTalentRow = row
			end
			if br.newTalentRow ~= nil then
				if select(4, br._G.GetTalentInfoByID(br._G.GetTalentInfo(br.newTalentRow, column, 1), 1)) then
					br.selectedTalent = select(1, br._G.GetTalentInfo(br.newTalentRow, column, 1))
				end
			end
		end
		return br.selectedTalent, br.newTalent -- selectedNew
	end

	if br._G.PlayerTalentFrame and br._G.PlayerTalentFrame:IsVisible() and not br._G.IsResting() then
		for row = 1, 7 do
			br.selectedTalent, br.newTalent, br.selectedNew = talentSelection(row)
		end
		--br.ui.chatOverlay:Show(tostring(selectedTalent).." | "..tostring(newTalent).." | "..tostring(selectedNew))
		if br.newTalent ~= nil then
			if br.selectedTalent ~= nil and br.selectedTalent ~= br.newTalent and not br.selectedNew and br.debug.timer:useTimer("RemoveTalent", 0.1) then
				removeTalent(br.selectedTalent)
			end
			if br.selectedTalent == nil and br.selectedTalent ~= br.newTalent and not br.selectedNew then
				learnTalent(br.newTalent)
				br.selectedNew = true
			end
			if br.selectedTalent == br.newTalent then
				br.selectedNew = false
				br.newTalent = nil
			end
		end
	end
end

function misc:getEssenceRank(essenceName)
	if br.api.wow.GetSpellInfo(essenceName) == nil then
		return 0
	end
	local essenceRank = 0
	local essenceTable = br._G.C_AzeriteEssence.GetMilestones()
	local icon = select(3, br.api.wow.GetSpellInfo(essenceName))
	for i = 1, #essenceTable do
		local milestone = essenceTable[i]
		if milestone.slot ~= nil and milestone.unlocked == true then
			local eRank = br._G.C_AzeriteEssence.GetEssenceInfo(br._G.C_AzeriteEssence.GetMilestoneEssence(milestone.ID))
				.rank
			local eIcon = br._G.C_AzeriteEssence.GetEssenceInfo(br._G.C_AzeriteEssence.GetMilestoneEssence(milestone.ID))
				.icon
			if icon == eIcon then
				essenceRank = eRank
			end
		end
		return essenceRank
	end
end

function misc:addonDebug(msg, system)
	if msg == nil then
		return
	end
	local msgText = tostring(msg)
	-- Prefer the dropdown value for Addon Debug Messages. Some configs
	-- may not include a separate checkbox, so rely on the dropdown being
	-- set.
	local addonDebugValue = br.functions.misc:getValue("Addon Debug Messages")
	if br.functions.misc:isChecked("Addon Debug Messages") and addonDebugValue then
		local showSystem = addonDebugValue == 1 or addonDebugValue == 2
		local showProfile = addonDebugValue == 1 or addonDebugValue == 3

		-- Use a per-message short timer key so different messages printed
		-- within a short interval aren't suppressed by the same global key.
		local msgKey = msgText
		if #msgKey > 40 then msgKey = msgKey:sub(1, 40) end

		-- Immediate-print for casting-related messages to avoid them being
		-- swallowed by simultaneous 'Combat Started' messages. Use a
		-- short per-message guard so we don't spam identical lines.
		-- Respect configured channel filtering (System/Profile/All).
		if showProfile and system ~= true and string.find(msgText, "Casting") then
			local castKey = "Casting Immediate:" .. msgKey
			if br.debug.timer:useTimer(castKey, 0.05) then
				print(br.ui.colors.class .. "[BadRotations] Profile Debug: |cffFFFFFF" .. msgText)
			end
			return
		end

		if system == true and showSystem then
			local timerKey = "System Delay:" .. msgKey
			if br.debug.timer:useTimer(timerKey, 0.1) then
				print(br.ui.colors.class .. "[BadRotations] System Debug: |cffFFFFFF" .. msgText)
			end
		elseif system ~= true and showProfile then
			local timerKey = "Profile Delay:" .. msgKey
			if br.debug.timer:useTimer(timerKey, 0.1) then
				print(br.ui.colors.class .. "[BadRotations] Profile Debug: |cffFFFFFF" .. msgText)
			end
		end
	end
end

function misc:sanguineCheck(unit)
	if br.sanguine then
		local x, y, z = br._G.ObjectPosition(unit)
		for _, v in pairs(br.sanguine) do
			if br._G.sqrt(((x - v.posX) ^ 2) + ((y - v.posY) ^ 2) + ((z - v.posZ) ^ 2)) < 5 then
				return true
			end
		end
	end
	return false
end

function misc:isTableEmpty(table)
	if table == nil then
		return true
	end
	local retval = true
	if next(table) ~= nil then
		retval = false
	end
	return retval
end

function misc:getItemGlow(object)
	return br._G.IsQuestObject(object)
end

function misc:AcceptQueues()
	if misc:getOptionCheck("Accept Queues") then
		-- Accept Queues
		-- local randomReady = math.random(8, 15)
		-- add some randomness
		if misc.readyToAccept and misc.readyToAccept <= br._G.GetTime() - 5 then
			br._G.AcceptProposal()
			misc.readyToAccept = nil
			-- randomReady = nil
		end
	end
end

-- Seconds the player has been moving (0 while standing still).
-- if br.functions.misc:getMovingTime() > 2 then
local movingTimer
function misc:getMovingTime()
	local now = br._G.GetTime()
	if movingTimer == nil or br._G.GetUnitSpeed("player") == 0 then movingTimer = now end
	return now - movingTimer
end

-- Seconds the player has been standing still (0 while moving).
-- if br.functions.misc:getStandingTime() > 2 then
local standingTimer
function misc:getStandingTime()
	local now = br._G.GetTime()
	if standingTimer == nil or br._G.GetUnitSpeed("player") > 0 then standingTimer = now end
	return now - standingTimer
end

-- Stores an enemies list on the player as enemies.yards<range><tags> (used by the Enemies API).
-- Tags: t/f/p/m... for the center unit, nc for no-combat check, f for facing, r/c for rect/cone.
function misc:setEnemiesVariable(self, unit, range, checkNoCombat, facing, type, table, count)
	if unit == nil then unit = "player" end
	if range == nil then range = 5 end
	if checkNoCombat == nil then checkNoCombat = false end
	if facing == nil then facing = false end
	if type == nil then type = "" end
	if table == nil then table = {} end
	if count == nil then count = #table end
	-- Build enemies.yards variable
	local insertTable = "yards" ..
		range ..
		type -- Ex: enemies.yards8 (returns all enemies around player in 8yrds), Adds Table Type (r for Rect, c for Cone, blank for Normal)
	if unit ~= "player" then
		-- letter tag on end based on type of unit passed, if target or enemy unit then "t" otherwise first letter of what is passed in: f - "focus", p - "pet", m - "mouseover", etc
		if br.engines.enemiesEngine.units[unit] ~= nil then
			insertTable = insertTable .. "t" -- Ex: enemies.yards8t (returns all enemies around target in 8yrds)
		else
			insertTable = insertTable ..
				unit:sub(1, 1) -- Ex: enemies.yards8f (returns all enemies around "focus" in 8yrds)
		end
	end
	if checkNoCombat then insertTable = insertTable .. "nc" end -- Ex: enemies.yards8tnc (returns all units around target in 8yrds)
	if facing then insertTable = insertTable .. "f" end         -- Ex: enemies.yards8tncf (returns all units the target is facing in 8yrds)
	if self.enemies[insertTable] == nil then self.enemies[insertTable] = {} else br._G.wipe(self.enemies[insertTable]) end
	if count > 0 then br.functions.custom:insertTableIntoTable(self.enemies[insertTable], table) end
end

-- Reads a module option: from "Rotation Options" when the profile defines that page, otherwise
-- from "Base Options" (option lookups search the other pages when not found on the first).
-- if br.functions.misc:getModuleOption("Use Racial", "Check") then
function misc:getModuleOption(option, optionType)
	local settings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
	local page = (settings ~= nil and settings["Rotation Options"] ~= nil) and "Rotation Options" or "Base Options"
	if optionType == "Check" then return misc:isChecked(option, page) end
	if optionType == "Value" then return misc:getOptionValue(option, page) end
end

-- Class folder name used under Rotations/ and Settings/ (e.g. "Druid", "Death Knight").
-- local folder = br.functions.misc:getClassFolderName("DEATHKNIGHT")
function misc:getClassFolderName(class)
	if class == nil then class = "" end
	local formatClass = class:sub(1, 1):upper() .. class:sub(2):lower()
	if formatClass == "Deathknight" then formatClass = "Death Knight" end
	if formatClass == "Demonhunter" then formatClass = "Demon Hunter" end
	return formatClass
end

-- BadRotations' folder on disk and the path separator for this OS.
-- local path, sep = br.functions.misc:getAddonPath()
function misc:getAddonPath()
	local sep = br._G.IsMacClient() and "/" or "\\"
	local wowDir = br._G.GetWoWDirectory() or ""
	if wowDir:match('_retail_') then
		return wowDir .. sep .. 'Interface' .. sep .. 'AddOns' .. sep .. br.loader.addonName, sep
	end
	return wowDir .. sep .. br.loader.addonName, sep
end

-- Warns once per profile when the rotation relies on a toggle it never created (e.g. it calls
-- ui.useCDs() without a "Cooldown" toggle, so cooldowns would silently never be used).
-- Only checks once startup has finished, so a toggle bar deferred by combat isn't reported.
-- br.functions.misc:warnMissingToggle("Cooldown", "cooldowns", "ui.useCDs()")
local warnedMissingToggles = {}
function misc:warnMissingToggle(toggleName, purpose, apiCall)
	if not (br.loader.bootstrap and br.loader.bootstrap.stage == "RUNNING") then return end
	if br.ui.toggles and br.ui.toggles[toggleName] ~= nil then return end
	local profile = tostring(br.loader.selectedProfileName)
	local key = profile .. "|" .. toggleName
	if warnedMissingToggles[key] then return end
	warnedMissingToggles[key] = true
	br._G.print("|cffFF8800" .. profile .. " uses " .. purpose .. " (" .. apiCall .. ") but has no \"" .. toggleName
		.. "\" toggle, so " .. purpose .. " will never be used. Add a " .. toggleName .. " toggle to the profile.|r")
end
