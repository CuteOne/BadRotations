local _, br = ...
br.functions.cast = br.functions.cast or {}
local cast = br.functions.cast
local castIntentLocks = {} -- Tracks cast intent to prevent multiple cast.able() checks succeeding

local function shouldPrintCastDebug()
	return br.functions.misc and (br.functions.misc:isChecked("Cast Debug") or br.functions.misc:isChecked("Display Failcasts"))
end

local function setCastIntentLock(spellID, duration)
	if spellID == nil then return end
	if duration == nil then duration = 0.15 end
	castIntentLocks[spellID] = br._G.GetTime() + duration
end

local function isCastIntentLocked(spellID)
	if spellID == nil then return false end
	return castIntentLocks[spellID] ~= nil and br._G.GetTime() < castIntentLocks[spellID]
end

local function getSameSpellCastRemain(spellID)
	local now = br._G.GetTime()
	local _, _, _, _, castEndTime, _, _, _, castingSpellID = br._G.UnitCastingInfo("player")
	if castingSpellID == spellID and castEndTime and castEndTime > 0 then
		return math.max(0, (castEndTime / 1000) - now)
	end
	local _, _, _, _, channelEndTime, _, _, channelingSpellID = br._G.UnitChannelInfo("player")
	if channelingSpellID == spellID and channelEndTime and channelEndTime > 0 then
		return math.max(0, (channelEndTime / 1000) - now)
	end
	return 0
end

local function takeCastStartSnapshot(spellID)
	local spellCdBefore = 0
	if br.functions.spell and br.functions.spell.getSpellCD then
		spellCdBefore = br.functions.spell:getSpellCD(spellID) or 0
	end
	local currentSpellBefore = false
	if br._G.IsCurrentSpell then
		currentSpellBefore = br._G.IsCurrentSpell(spellID) == true
	end
	local buffBefore = false
	if br.functions.aura and br.functions.aura.UnitBuffID then
		buffBefore = br.functions.aura:UnitBuffID("player", spellID) ~= nil
	end
	return {
		timeNow = br._G.GetTime(),
		gcdBefore = br.functions.spell:getGlobalCD(),
		castingBefore = br._G.UnitCastingInfo("player") ~= nil,
		channelingBefore = br._G.UnitChannelInfo("player") ~= nil,
		prevLastCastTime = (br.functions.lastCast and br.functions.lastCast.lastCastTable and br.functions.lastCast.lastCastTable.castTime and br.functions.lastCast.lastCastTable.castTime[spellID]) or 0,
		spellCdBefore = spellCdBefore,
		currentSpellBefore = currentSpellBefore,
		buffBefore = buffBefore,
	}
end

-- verifyCastStarted: two-stage synchronous cast confirmation.
--
-- Stage 1 (immediate, synchronous): Checks snapshot deltas that update in the same
-- frame the cast fires — GCD tick, UnitCastingInfo/UnitChannelInfo starting a new cast,
-- spell cooldown appearing, IsCurrentSpell toggling, or a self-buff appearing.
-- Any of these signals confirms success without waiting for events.
--
-- Stage 2 (deferred event fallback): If no synchronous signal is observed but
-- lastCastTable.castTime[spellID] was updated (populated by UNIT_SPELLCAST_* events),
-- that event-driven confirmation is accepted as success on the next check.
--
-- 'inconclusive' is returned when no signal has arrived in either stage yet.
-- The caller should throttle retries but not emit a CAST_FAILED message.
local function verifyCastStarted(spellID, snapshot, expectedSpellName)
	expectedSpellName = expectedSpellName or br.api.wow.GetSpellInfo(spellID)
	local gcdAfter = br.functions.spell:getGlobalCD()
	local castNameAfter, _, _, _, _, _, _, _, castSpellIdAfter = br._G.UnitCastingInfo("player")
	local channelNameAfter, _, _, _, _, _, _, _, channelSpellIdAfter = br._G.UnitChannelInfo("player")
	local castingAfter = castNameAfter ~= nil
	local channelingAfter = channelNameAfter ~= nil
	local spellCdAfter = (br.functions.spell and br.functions.spell.getSpellCD) and (br.functions.spell:getSpellCD(spellID) or 0) or 0
	local currentSpellAfter = br._G.IsCurrentSpell and (br._G.IsCurrentSpell(spellID) == true) or false
	local buffAfter = (br.functions.aura and br.functions.aura.UnitBuffID) and (br.functions.aura:UnitBuffID("player", spellID) ~= nil) or false
	local failedAt = (br.functions.lastCast and br.functions.lastCast.lastCastTable and br.functions.lastCast.lastCastTable.failedTime and br.functions.lastCast.lastCastTable.failedTime[spellID]) or 0
	local recentlyFailed = failedAt ~= 0 and (br._G.GetTime() - failedAt) < 0.20

	local startedNewCast = castingAfter and not snapshot.castingBefore
	local startedNewChannel = channelingAfter and not snapshot.channelingBefore
	local startedAnyNew = startedNewCast or startedNewChannel

	local function matchesExpected(observedName, observedSpellId)
		if observedSpellId ~= nil and observedSpellId ~= 0 then
			return observedSpellId == spellID
		end
		if observedName ~= nil and expectedSpellName ~= nil then
			return observedName == expectedSpellName
		end
		return true -- Can't determine; don't block.
	end

	local observedName = startedNewCast and castNameAfter or (startedNewChannel and channelNameAfter or nil)
	local observedSpellId = startedNewCast and castSpellIdAfter or (startedNewChannel and channelSpellIdAfter or nil)
	local spellMatches = (not startedAnyNew) or matchesExpected(observedName, observedSpellId)

	local cooldownStarted = spellCdAfter > (snapshot.spellCdBefore or 0)
	local buffGained = buffAfter and not (snapshot.buffBefore == true)
	local currentSpellChangedOn = currentSpellAfter and not (snapshot.currentSpellBefore == true)
	local currentSpellAlreadyOn = (spellID == 6603) and currentSpellAfter
	local startedOffGcdEffect = cooldownStarted or buffGained or currentSpellChangedOn or currentSpellAlreadyOn

	local castSucceeded = (gcdAfter > snapshot.gcdBefore) or startedAnyNew or startedOffGcdEffect
	if startedAnyNew and not spellMatches then
		castSucceeded = false
	end

	local newLastCastTime = (br.functions.lastCast and br.functions.lastCast.lastCastTable and br.functions.lastCast.lastCastTable.castTime and br.functions.lastCast.lastCastTable.castTime[spellID])
	if not castSucceeded and newLastCastTime and newLastCastTime ~= 0 and newLastCastTime ~= snapshot.prevLastCastTime and (br._G.GetTime() - newLastCastTime) < 1 then
		castSucceeded = true
	end

	local noObservableSignals = (gcdAfter == snapshot.gcdBefore)
		and (not startedAnyNew)
		and (not startedOffGcdEffect)
		and ((newLastCastTime or 0) == (snapshot.prevLastCastTime or 0))
		and (spellCdAfter == (snapshot.spellCdBefore or 0))
		and (buffAfter == (snapshot.buffBefore == true))
		and (currentSpellAfter == (snapshot.currentSpellBefore == true))

	if not castSucceeded and recentlyFailed then
		castSucceeded = false
	end

	local inconclusive = (not castSucceeded) and (not recentlyFailed) and noObservableSignals

	return castSucceeded, {
		gcdAfter = gcdAfter,
		castingAfter = castingAfter,
		channelingAfter = channelingAfter,
		startedNewCast = startedNewCast,
		startedNewChannel = startedNewChannel,
		spellMatches = spellMatches,
		castNameAfter = castNameAfter,
		castSpellIdAfter = castSpellIdAfter,
		channelNameAfter = channelNameAfter,
		channelSpellIdAfter = channelSpellIdAfter,
		newLastCastTime = newLastCastTime,
		spellCdBefore = snapshot.spellCdBefore,
		spellCdAfter = spellCdAfter,
		currentSpellBefore = snapshot.currentSpellBefore,
		currentSpellAfter = currentSpellAfter,
		buffBefore = snapshot.buffBefore,
		buffAfter = buffAfter,
		cooldownStarted = cooldownStarted,
		buffGained = buffGained,
		currentSpellChangedOn = currentSpellChangedOn,
		currentSpellAlreadyOn = currentSpellAlreadyOn,
		recentlyFailed = recentlyFailed,
		failedAt = failedAt,
		inconclusive = inconclusive,
		noObservableSignals = noObservableSignals,
	}
end

local function printCastFailedDetails(prefix, spellID, spellName, snapshot, details)
	br._G.print(prefix .. "Failed cast attempt: SpellID=" .. tostring(spellID) .. " Name=" .. tostring(spellName))
	br._G.print("  GCD before/after: " .. tostring(snapshot.gcdBefore) .. " -> " .. tostring(details.gcdAfter))
	br._G.print("  Casting before/after: " .. tostring(snapshot.castingBefore) .. " -> " .. tostring(details.castingAfter))
	br._G.print("  Channeling before/after: " .. tostring(snapshot.channelingBefore) .. " -> " .. tostring(details.channelingAfter))
	br._G.print("  PrevLastCastTime/newLastCastTime: " .. tostring(snapshot.prevLastCastTime) .. " -> " .. tostring(details.newLastCastTime))
	br._G.print("  SpellCD before/after: " .. tostring(snapshot.spellCdBefore) .. " -> " .. tostring(details.spellCdAfter))
	br._G.print("  IsCurrentSpell before/after: " .. tostring(snapshot.currentSpellBefore) .. " -> " .. tostring(details.currentSpellAfter))
	br._G.print("  SelfBuff before/after: " .. tostring(snapshot.buffBefore) .. " -> " .. tostring(details.buffAfter))
	br._G.print("  RecentlyFailed/failedAt: " .. tostring(details.recentlyFailed) .. " -> " .. tostring(details.failedAt))
	br._G.print("  Inconclusive/noSignals: " .. tostring(details.inconclusive) .. " -> " .. tostring(details.noObservableSignals))
end

-- if canCast(12345,true)
function cast:canCast(SpellID, KnownSkip, MovementCheck, thisUnit)
	if thisUnit == nil then thisUnit = "target" end
	local myCooldown = br.functions.spell:getSpellCD(SpellID) or 0
	-- local lagTolerance = br.functions.misc:getValue("Lag Tolerance") or 0
	if (KnownSkip == true or br.functions.spell:isKnown(SpellID)) and (br._G.UnitIsUnit(thisUnit, "target") and br._G.C_Spell.IsSpellUsable(SpellID) or true) and myCooldown < 0.1
		and (MovementCheck == false or myCooldown == 0 or br.functions.misc:isMoving("player") ~= true or br.functions.aura:UnitBuffID("player", 79206) ~= nil) then
		return true
	end
end

function cast:castAoEHeal(spellID, numUnits, missingHP, rangeValue)
	-- i start an iteration that i use to build each units Table,which i will reuse for the next second
	if not br.holyRadianceRangeTable or not br.holyRadianceRangeTableTimer or br.holyRadianceRangeTableTimer <= br._G.GetTime() - 1 then
		br.holyRadianceRangeTable = {}
		for i = 1, #br.engines.healingEngine.friend do
			-- i declare a sub-table for this unit if it dont exists
			if br.engines.healingEngine.friend[i].distanceTable == nil then br.engines.healingEngine.friend[i].distanceTable = {} end
			-- i start a second iteration where i scan unit ranges from one another.
			for j = 1, #br.engines.healingEngine.friend do
				-- i make sure i dont compute unit range to hisself.
				if not br.functions.unit:GetUnitIsUnit(br.engines.healingEngine.friend[i].unit, br.engines.healingEngine.friend[j].unit) then
					-- table the units
					br.engines.healingEngine.friend[i].distanceTable[j] = {
						distance = br.functions.range:getDistance(br.engines.healingEngine.friend[i].unit, br.engines.healingEngine.friend[j].unit),
						unit =
							br.engines.healingEngine.friend[j].unit,
						hp = br.engines.healingEngine.friend[j].hp
					}
				end
			end
		end
	end
	-- declare locals that will hold number
	local bestTarget, bestTargetUnits = 1, 1
	-- now that nova range is built,i can iterate it
	local inRange, missingHealth, mostMissingHealth = 0, 0, 0
	for i = 1, #br.engines.healingEngine.friend do
		if br.engines.healingEngine.friend[i].distanceTable ~= nil then
			-- i count units in range
			for j = 1, #br.engines.healingEngine.friend do
				if br.engines.healingEngine.friend[i].distanceTable[j] and br.engines.healingEngine.friend[i].distanceTable[j].distance < rangeValue then
					inRange = inRange + 1
					missingHealth = missingHealth + (100 - br.engines.healingEngine.friend[i].distanceTable[j].hp)
				end
			end
			br.engines.healingEngine.friend[i].inRangeForHolyRadiance = inRange
			-- i check if this is going to be the best unit for my spell
			if missingHealth > mostMissingHealth then
				bestTarget, bestTargetUnits, mostMissingHealth = i, inRange, missingHealth
			end
		end
	end
	if bestTargetUnits and bestTargetUnits > 3 and mostMissingHealth and missingHP and mostMissingHealth > missingHP then
		if br.functions.cast:castSpell(br.engines.healingEngine.friend[bestTarget].unit, spellID, true, true) then return true end
	end
end

--cast spell on position x,y,z
function cast:castAtPosition(X, Y, Z, SpellID)
	local mouselookActive = false
	if br._G.IsMouselooking() then
		mouselookActive = true
		br._G.MouselookStop()
	end

	-- Ground-targeted spells should not be cast "on" a unit token; doing so can force a self-cast.
	-- We want the targeting cursor so we can click the provided world coordinates.
	br._G.CastSpellByName(br.api.wow.GetSpellInfo(SpellID))

	local baseZ = Z
	local attempts = 0
	local maxAttempts = 201

	-- Try the provided Z first, then probe around it if needed.
	while br._G["IsAoEPending"]() and attempts < maxAttempts do
		local offset
		if attempts == 0 then
			offset = 0
		else
			local step = math.ceil(attempts / 2)
			offset = (attempts % 2 == 1) and step or -step
		end

		br._G["ClickPosition"](X, Y, baseZ + offset)
		attempts = attempts + 1
	end

	if mouselookActive then
		br._G.MouselookStart()
	end

	if br._G["IsAoEPending"]() then return false end
	return true
end

-- castGround("target",12345,40)
function cast:castGround(Unit, SpellID, maxDistance, minDistance, radius, castTime)
	if radius == nil then radius = maxDistance end
	if minDistance == nil then minDistance = 0 end
	local groundDistance = br.functions.range:getDistance("player", Unit, "dist4") + 1
	local distance = br.functions.range:getDistance("player", Unit)
	local mouselookActive = false
	if br.functions.unit:GetUnitExists(Unit) and br.functions.spell:getSpellCD(SpellID) == 0 and br.functions.misc:getLineOfSight("player", Unit)
		and distance < maxDistance and distance >= minDistance
		and #br.engines.enemiesEngineFunctions:getEnemies(Unit, radius) >= #br.engines.enemiesEngineFunctions:getEnemies(Unit, radius, true)
	then
		if br._G.IsMouselooking() then
			mouselookActive = true
			br._G.MouselookStop()
		end
		br._G.CastSpellByName(br.api.wow.GetSpellInfo(SpellID))
		local X, Y, Z
		if castTime == nil or castTime == 0 then
			X, Y, Z = br.functions.unit:GetObjectPosition(Unit)
		else
			X, Y, Z = br.functions.custom:GetFuturePostion(Unit, castTime)
		end
		--local distanceToGround = getGroundDistance(Unit) or 0
		if groundDistance > maxDistance then
			X, Y, Z = br._G.GetPositionBetweenObjects(Unit, "player",
				groundDistance - maxDistance)
		end
		br._G.ClickPosition((X + math.random() * 2), (Y + math.random() * 2), Z) --distanceToGround
		if mouselookActive then
			br._G.MouselookStart()
		end
		return true
	end
	return false
end

--castGroundLocation(123,456,98765,40,0,8)
function cast:castGroundLocation(X, Y, SpellID, maxDistance, minDistance, radius)
	if X == nil or Y == nil then return false end
	if radius == nil then radius = maxDistance end
	if minDistance == nil then minDistance = 0 end
	--local groundDistance = br.functions.range:getDistance("player",Unit,"dist4")+1
	local pX, pY, Z = br.functions.unit:GetObjectPosition("player")
	local distance = br._G.sqrt(((X - pX) ^ 2) + ((Y - pY) ^ 2))
	local mouselookActive = false
	if distance < maxDistance and distance >= minDistance then
		if br._G.IsMouselooking() then
			mouselookActive = true
			br._G.MouselookStop()
		end
		-- br._G.print("Casting Spell")
		br._G.CastSpellByName(br.api.wow.GetSpellInfo(SpellID))
		if br._G.IsAoEPending() then
			-- br._G.print("Clicking Position")
			br._G.ClickPosition((X + math.random() * 2), (Y + math.random() * 2), Z) --distanceToGround
		end
		if mouselookActive then
			br._G.MouselookStart()
		end
		return true
	end
	return false
end

-- castGroundBetween("target",12345,40)
function cast:castGroundBetween(Unit, SpellID, maxDistance)
	if br.functions.unit:GetUnitExists(Unit) and br.functions.spell:getSpellCD(SpellID) <= 0.4 and br.functions.misc:getLineOfSight("player", Unit) and br.functions.range:getDistance("player", Unit) <= maxDistance then
		br._G.CastSpellByName(br.api.wow.GetSpellInfo(SpellID))
		local X, Y, Z = br.functions.unit:GetObjectPosition(Unit)
		br._G.ClickPosition(X, Y, Z, true)
		return true
	end
	return false
end

-- if shouldNotOverheal(spellCastTarget) > 80 then
function cast:shouldNotOverheal(Unit)
	local myIncomingHeal, allIncomingHeal = 0, 0
	if br._G.UnitGetIncomingHeals(Unit, "player") ~= nil then myIncomingHeal = br._G.UnitGetIncomingHeals(Unit, "player") end
	if br._G.UnitGetIncomingHeals(Unit) ~= nil then allIncomingHeal = br._G.UnitGetIncomingHeals(Unit) end
	allIncomingHeal = allIncomingHeal or 0
	local overheal
	if myIncomingHeal >= allIncomingHeal then
		overheal = myIncomingHeal
	else
		overheal = allIncomingHeal
	end
	local CurShield = br._G.UnitHealth(Unit)
	if br.functions.aura:UnitDebuffID("player", 142861) then --Ancient Miasma
		CurShield = select(14, br.functions.aura:UnitDebuffID(Unit, 142863)) or select(14, br.functions.aura:UnitDebuffID(Unit, 142864)) or
			select(14, br.functions.aura:UnitDebuffID(Unit, 142865)) or (br._G.UnitHealthMax(Unit) / 2)
		overheal = 0
	end
	local overhealth = 100 * (CurShield + overheal) / br._G.UnitHealthMax(Unit)
	if overhealth and overheal then
		return overhealth, overheal
	else
		return 0, 0
	end
end

-- if castHealGround(_HealingRain,18,80,3) then
function cast:castHealGround(SpellID, Radius, Health, NumberOfPlayers)
	if br.engines.interrupts:shouldStopCasting(SpellID) ~= true then
		local lowHPTargets, foundTargets = {}, {}
		for i = 1, #br.engines.healingEngine.friend do
			if br.functions.unit:getHP(br.engines.healingEngine.friend[i].unit) <= Health then
				if br.functions.unit:GetUnitIsVisible(br.engines.healingEngine.friend[i].unit) and br.functions.unit:GetObjectExists(br.engines.healingEngine.friend[i].unit) then
					local X, Y, Z = br.functions.unit:GetObjectPosition(br.engines.healingEngine.friend[i].unit)
					br._G.tinsert(lowHPTargets, { unit = br.engines.healingEngine.friend[i].unit, x = X, y = Y, z = Z })
				end
			end
		end
		if #lowHPTargets >= NumberOfPlayers then
			for i = 1, #lowHPTargets do
				for j = 1, #lowHPTargets do
					if lowHPTargets[i].unit ~= lowHPTargets[j].unit then
						if math.sqrt(((lowHPTargets[j].x - lowHPTargets[i].x) ^ 2) + ((lowHPTargets[j].y - lowHPTargets[i].y) ^ 2)) < Radius then
							for k = 1, #lowHPTargets do
								if lowHPTargets[i].unit ~= lowHPTargets[k].unit and lowHPTargets[j].unit ~= lowHPTargets[k].unit then
									if math.sqrt(((lowHPTargets[k].x - lowHPTargets[i].x) ^ 2) + ((lowHPTargets[k].y - lowHPTargets[i].y) ^ 2)) < Radius
										and math.sqrt(((lowHPTargets[k].x - lowHPTargets[j].x) ^ 2) + ((lowHPTargets[k].y - lowHPTargets[j].y) ^ 2)) < Radius
									then
										br._G.tinsert(foundTargets,
											{
												unit = lowHPTargets[i].unit,
												x = lowHPTargets[i].x,
												y = lowHPTargets[i].y,
												z =
													lowHPTargets[i].z
											})
										br._G.tinsert(foundTargets,
											{
												unit = lowHPTargets[j].unit,
												x = lowHPTargets[j].x,
												y = lowHPTargets[j].y,
												z =
													lowHPTargets[i].z
											})
										br._G.tinsert(foundTargets,
											{
												unit = lowHPTargets[k].unit,
												x = lowHPTargets[k].x,
												y = lowHPTargets[k].y,
												z =
													lowHPTargets[i].z
											})
									end
								end
							end
						end
					end
				end
			end
			local medX, medY, medZ = 0, 0, 0
			if foundTargets ~= nil and #foundTargets >= NumberOfPlayers then
				for i = 1, 3 do
					medX = medX + foundTargets[i].x
					medY = medY + foundTargets[i].y
					medZ = medZ + foundTargets[i].z
				end
				medX, medY, medZ = medX / 3, medY / 3, medZ / 3
				local myX, myY = br.functions.unit:GetObjectPosition("player")
				if math.sqrt(((medX - myX) ^ 2) + ((medY - myY) ^ 2)) < 40 then
					br._G.CastSpellByName(br.api.wow.GetSpellInfo(SpellID), "target")
					br._G.ClickPosition(medX, medY, medZ, true)
					if SpellID == 145205 then br.shroomsTable[1] = { x = medX, y = medY, z = medZ } end
					return true
				end
			elseif lowHPTargets ~= nil and #lowHPTargets == 1 and lowHPTargets[1].unit == "player" then
				local myX, myY, myZ = br.functions.unit:GetObjectPosition("player")
				br._G.CastSpellByName(br.api.wow.GetSpellInfo(SpellID), "target")
				br._G.ClickPosition(myX, myY, myZ, true)
				if SpellID == 145205 then br.shroomsTable[1] = { x = medX, y = medY, z = medZ } end
				return true
			end
		end
	else
		return false
	end
end

--[[castSpell(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip)
Parameter 	Value
First 	 	UnitID 			Enter valid UnitID
Second 		SpellID 		Enter ID of spell to use
Third 		Facing 			True to allow 360 degrees,false to use facing check
Fourth 		MovementCheck	True to make sure player is standing to cast,false to allow cast while moving
Fifth 		SpamAllowed 	True to skip that check,false to prevent spells that we dont want to spam from beign recast for 1 second
Sixth 		KnownSkip 		True to skip isKnown check for some spells that are not managed correctly in wow's spell book.
Seventh 	DeadCheck 		True to skip checking for dead units. (IE: Resurrection Spells)
Eigth 		DistanceSkip    True to skip range checking.
Ninth 		usableSkip 		True to skip usability checks.
Tenth 		noCast			True to return True/False instead of casting spell.
]]
-- castSpell("target",12345,true)
--                ( 1  ,    2  ,     3     ,     4       ,      5    ,   6     ,   7     ,    8       ,   9      ,  10  )
function cast:castSpell(Unit, SpellID, FacingCheck, MovementCheck, SpamAllowed, KnownSkip, DeadCheck, DistanceSkip,
					  usableSkip, noCast)
	if br.functions.unit:GetObjectExists(Unit) --and betterStopCasting(SpellID) ~= true
		and (not br.functions.unit:GetUnitIsDeadOrGhost(Unit) or DeadCheck)
	then
		-- we create an usableSkip for some specific spells like hammer of wrath aoe mode
		if usableSkip == nil then usableSkip = false end
		-- stop if not enough power for that spell
		if usableSkip ~= true and br._G.C_Spell.IsSpellUsable(SpellID) ~= true then return false end
		-- Table used to prevent refiring too quick
		if br.timersTable == nil then br.timersTable = {} end
		-- default noCast to false
		if noCast == nil then noCast = false end
		-- make sure it is a known spell
		if not (KnownSkip == true or br.functions.spell:isKnown(SpellID)) then return false end
		-- gather our spell range information
		local spellRange = select(6, br.api.wow.GetSpellInfo(SpellID))
		if DistanceSkip == nil then DistanceSkip = false end
		if spellRange == nil or (spellRange < 4 and DistanceSkip == false) then spellRange = 4 end
		if DistanceSkip == true then spellRange = 40 end
		-- Check unit,if it's player then we can skip facing
		if (Unit == nil or br.functions.unit:GetUnitIsUnit("player", Unit)) -- Player
			or (Unit ~= nil and br.functions.unit:GetUnitIsFriend("player", Unit)) -- Ally
			or br._G.IsHackEnabled("AlwaysFacing")
		then
			FacingCheck = true
		elseif br.engines.enemiesEngineFunctions:isSafeToAttack(Unit) ~= true then -- enemy
			return false
		end
		-- if MovementCheck is nil or false then we dont check it
		if MovementCheck == false or br.functions.misc:isMoving("player") ~= true
			-- skip movement check during spiritwalkers grace and aspect of the fox
			or br.functions.aura:UnitBuffID("player", 79206) ~= nil
		then
			-- if ability is ready and in range
			-- if br.functions.spell:getSpellCD(SpellID) < select(4,GetNetStats()) / 1000
			if (br.functions.spell:getSpellCD(SpellID) < select(4, br._G.GetNetStats()) / 1000) and (br.functions.misc:getOptionCheck("Skip Distance Check") or br.functions.range:getDistance("player", Unit) <= spellRange or DistanceSkip == true or br.functions.range:inRange(SpellID, Unit)) then
				-- if spam is not allowed
				if SpamAllowed == false then
					-- get our last/current cast
					if br.timersTable == nil or (br.timersTable ~= nil and (br.timersTable[SpellID] == nil or br.timersTable[SpellID] <= br._G.GetTime() - 0.6)) then
						if (FacingCheck == true or br.functions.unit:getFacing("player", Unit) == true) and (br.functions.unit:GetUnitIsUnit("player", Unit) or br.engines.enemiesEngine.units[Unit] ~= nil or br.functions.misc:getLineOfSight("player", Unit) == true) then
							if noCast then
								return true
							else
								local snapshot = takeCastStartSnapshot(SpellID)

								br.timersTable[SpellID] = br._G.GetTime()
								-- currentTarget = UnitGUID(Unit) -- Not Used
								br.botCast = true -- Used by old Queue Cast
								br.botSpell = SpellID -- Used by old Queue Cast
								br.botUnit = Unit
								br._G.CastSpellByName(br.api.wow.GetSpellInfo(SpellID), Unit)
								if br._G.IsAoEPending() then
									local X, Y, Z = br._G.ObjectPosition(Unit)
									br._G.ClickPosition(X, Y, Z)
								end
								local castSucceeded, details = verifyCastStarted(SpellID, snapshot)

								if castSucceeded then
									--lastSpellCast = SpellID
									-- change main button icon
									--if br.functions.misc:getOptionCheck("Start/Stop BadRotations") then
									br.ui.toggles.mainButton:SetNormalTexture(select(3, br.api.wow.GetSpellInfo(SpellID)))
									br.lastSpellCast = SpellID
									br.lastSpellTarget = br._G.UnitGUID(Unit)
									--end
									return true
								elseif details and details.inconclusive then
									-- Unable to observe cast-start signals reliably; avoid false failspam.
									return true
								else
									-- Cast failed - reset timer to allow retry
									br.timersTable[SpellID] = nil
									-- Optional debug logging
									-- if shouldPrintCastDebug() then
									-- 	printCastFailedDetails("[CAST FAIL][CAST_FAILED] ", SpellID, br.api.wow.GetSpellInfo(SpellID), snapshot, details)
									-- end
									return false
								end
							end
						end
					end
				elseif (FacingCheck == true or br.functions.unit:getFacing("player", Unit) == true) and (br.functions.unit:GetUnitIsUnit("player", Unit) or br.engines.enemiesEngine.units[Unit] ~= nil or br.functions.misc:getLineOfSight("player", Unit) == true) then
					if noCast then
						return true
					else
						local snapshot = takeCastStartSnapshot(SpellID)

						-- currentTarget = UnitGUID(Unit) -- Not Used
						br.botCast = true
						br.botSpell = SpellID
						br.botUnit = Unit
						br._G.CastSpellByName(br.api.wow.GetSpellInfo(SpellID), Unit)
						if br._G.IsAoEPending() then
							local X, Y, Z = br._G.ObjectPosition(Unit)
							br._G.ClickPosition(X, Y, Z)
						end
						local castSucceeded, details = verifyCastStarted(SpellID, snapshot)

						if castSucceeded then
							--if br.functions.misc:getOptionCheck("Start/Stop BadRotations") then
							br.ui.toggles.mainButton:SetNormalTexture(select(3, br.api.wow.GetSpellInfo(SpellID)))
							br.lastSpellCast = SpellID
							br.lastSpellTarget = br._G.UnitGUID(Unit)
							--end
							return true
						elseif details and details.inconclusive then
							return true
						else
							-- Cast failed - don't set lastSpellCast
							-- if shouldPrintCastDebug() then
							-- 	printCastFailedDetails("[CAST FAIL][CAST_FAILED] ", SpellID, br.api.wow.GetSpellInfo(SpellID), snapshot, details)
							-- end
							return false
						end
					end
				end
			end
		end
	end
	return false
end

--[[castSpellMacro(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip)
Parameter 	Value
First 	 	UnitID 			Enter valid UnitID
Second 		SpellID 		Enter ID of spell to use
Third 		Facing 			True to allow 360 degrees,false to use facing check
Fourth 		MovementCheck	True to make sure player is standing to cast,false to allow cast while moving
Fifth 		SpamAllowed 	True to skip that check,false to prevent spells that we dont want to spam from beign recast for 1 second
Sixth 		KnownSkip 		True to skip isKnown check for some spells that are not managed correctly in wow's spell book.
Seventh 	DeadCheck 		True to skip checking for dead units. (IE: Resurrection Spells)
Eigth 		DistanceSkip    True to skip range checking.
Ninth 		usableSkip 		True to skip usability checks.
Tenth 		noCast			True to return True/False instead of casting spell.
]]
-- castSpell("target",12345,true)
--                ( 1  ,    2  ,     3     ,     4       ,      5    ,   6     ,   7     ,    8       ,   9      ,  10  )
function cast:castSpellMacro(Unit, SpellID, FacingCheck, MovementCheck, SpamAllowed, KnownSkip, DeadCheck, DistanceSkip,
						   usableSkip, noCast)
	if br.functions.unit:GetObjectExists(Unit) and br.engines.interrupts:betterStopCasting(SpellID) ~= true
		and (not br.functions.unit:GetUnitIsDeadOrGhost(Unit) or DeadCheck) then
		-- we create an usableSkip for some specific spells like hammer of wrath aoe mode
		if usableSkip == nil then usableSkip = false end
		-- stop if not enough power for that spell
		if usableSkip ~= true and br._G.C_Spell.IsSpellUsable(SpellID) ~= true then return false end
		-- Table used to prevent refiring too quick
		if br.timersTable == nil then br.timersTable = {} end
		-- default noCast to false
		if noCast == nil then noCast = false end
		-- make sure it is a known spell
		if not (KnownSkip == true or br.functions.spell:isKnown(SpellID)) then return false end
		-- gather our spell range information
		local spellRange = select(6, br.api.wow.GetSpellInfo(SpellID))
		if DistanceSkip == nil then DistanceSkip = false end
		if spellRange == nil or (spellRange < 4 and DistanceSkip == false) then spellRange = 4 end
		if DistanceSkip == true then spellRange = 40 end
		-- Check unit,if it's player then we can skip facing
		if (Unit == nil or br.functions.unit:GetUnitIsUnit("player", Unit)) or -- Player
			(Unit ~= nil and br.functions.unit:GetUnitIsFriend("player", Unit)) then -- Ally
			FacingCheck = true
		elseif br.engines.enemiesEngineFunctions:isSafeToAttack(Unit) ~= true then          -- enemy
			return false
		end
		-- if MovementCheck is nil or false then we dont check it
		if MovementCheck == false or br.functions.misc:isMoving("player") ~= true
			-- skip movement check during spiritwalkers grace and aspect of the fox
			or br.functions.aura:UnitBuffID("player", 79206) ~= nil
		then
			-- if ability is ready and in range
			-- if br.functions.spell:getSpellCD(SpellID) < select(4,GetNetStats()) / 1000
			if (br.functions.spell:getSpellCD(SpellID) < select(4, br._G.GetNetStats()) / 1000) and (br.functions.misc:getOptionCheck("Skip Distance Check") or br.functions.range:getDistance("player", Unit) <= spellRange or DistanceSkip == true or br.functions.range:inRange(SpellID, Unit)) then
				-- if spam is not allowed
				if SpamAllowed == false then
					-- get our last/current cast
					if br.timersTable == nil or (br.timersTable ~= nil and (br.timersTable[SpellID] == nil or br.timersTable[SpellID] <= br._G.GetTime() - 0.6)) then
						if (FacingCheck == true or br.functions.unit:getFacing("player", Unit) == true) and (br.functions.unit:GetUnitIsUnit("player", Unit) or br.functions.misc:getLineOfSight("player", Unit) == true) then
							if noCast then
								return true
							else
								local snapshot = takeCastStartSnapshot(SpellID)

								br.timersTable[SpellID] = br._G.GetTime()
								br.currentTarget = br._G.UnitGUID(Unit)
								br.botCast = true
								br.botSpell = SpellID
								br.botUnit = Unit
								br._G.RunMacroText("/cast [@" .. Unit .. "] " .. br.api.wow.GetSpellInfo(SpellID))
								local castSucceeded, details = verifyCastStarted(SpellID, snapshot)

								if castSucceeded then
									--lastSpellCast = SpellID
									-- change main button icon
									--if br.functions.misc:getOptionCheck("Start/Stop BadRotations") then
									br.ui.toggles.mainButton:SetNormalTexture(select(3, br.api.wow.GetSpellInfo(SpellID)))
									br.lastSpellCast = SpellID
									br.lastSpellTarget = br._G.UnitGUID(Unit)
									--end
									return true
								elseif details and details.inconclusive then
									return true
								else
									-- Cast failed - reset timer to allow retry
									br.timersTable[SpellID] = nil
									return false
								end
							end
						end
					end
				elseif (FacingCheck == true or br.functions.unit:getFacing("player", Unit) == true) and (br.functions.unit:GetUnitIsUnit("player", Unit) or br.functions.misc:getLineOfSight("player", Unit) == true) then
					if noCast then
						return true
					else
						local snapshot = takeCastStartSnapshot(SpellID)
						br.currentTarget = br._G.UnitGUID(Unit)
						br.botCast = true
						br.botSpell = SpellID
						br.botUnit = Unit
						br._G.RunMacroText("/cast [@" .. Unit .. "] " .. br.api.wow.GetSpellInfo(SpellID))
						local castSucceeded, details = verifyCastStarted(SpellID, snapshot)

						if castSucceeded then
							br.ui.toggles.mainButton:SetNormalTexture(select(3, br.api.wow.GetSpellInfo(SpellID)))
							br.lastSpellCast = SpellID
							br.lastSpellTarget = br._G.UnitGUID(Unit)
							return true
						end
						if details and details.inconclusive then
							return true
						end

						-- if shouldPrintCastDebug() then
						-- 	printCastFailedDetails("[CAST FAIL][CAST_FAILED] ", SpellID, br.api.wow.GetSpellInfo(SpellID), snapshot, details)
						-- end
						return false
					end
				end -- End Spam Check
			end -- End CD/Distance Check
		end -- End Movement check
	end
	return false
end

-- Used in openers
function cast:castOpener(spellIndex, flag, index, checkdistance)
	local spellCast = br.player.spells[spellIndex]
	local castable = br.player.cast.able[spellIndex]
	local castSpell = br.player.cast[spellIndex]
	local spellName = select(1, br.api.wow.GetSpellInfo(spellCast))
	local maxRange = select(6, br.api.wow.GetSpellInfo(spellCast))
	local cooldown = br.player.cd[spellIndex].remain()
	if not maxRange or maxRange == 0 then maxRange = 5 end
	if checkdistance == nil then checkdistance = true end
	if not checkdistance or br.functions.range:getDistance("target") < maxRange then
		if (not castable() and (cooldown == 0 or cooldown > br.player.gcdMax)) then
			br.functions.cast:castOpenerFail(spellName, flag, index)
			-- Print(index..": "..spellName.." (Uncastable)");
			-- br._G[flag] = true;
			-- return true
		else
			if castSpell() then
				if br.player.opener[flag] == nil then
					br._G.print(index .. ": " .. spellName)
					br.player.opener[flag] = true
				elseif br.player.opener[flag] ~= true then
					br._G.print(index .. ": " .. spellName)
					br.player.opener[flag] = true
				end
				return true
			end
		end
	end
end

function cast:castOpenerFail(spellName, flag, index)
	if br.player.opener[flag] == nil then
		br._G.print(index .. ": " .. spellName .. " (Uncastable)")
		br.player.opener[flag] = true
	end
	return true
end

function cast:castMouseoverHealing(Class)
	if br._G.UnitAffectingCombat("player") then
		local spellTable = {
			["Druid"] = { heal = 8936, dispel = 88423 }
		}
		local npcTable = {
			71604, -- Contaminated Puddle- Immerseus - SoO
			71995, -- Norushen
			71996, -- Norushen
			72000, -- Norushen
			71357, -- Wrathion
		}
		local SpecialTargets = { "mouseover", "target", "focus" }
		-- local dispelid = spellTable[Class].dispel
		for i = 1, #SpecialTargets do
			local target = SpecialTargets[i]
			if br.functions.unit:GetUnitExists(target) and not br._G.UnitIsPlayer(target) then
				local npcID = tonumber(string.match(br._G.UnitGUID(target), "-(%d+)-%x+$"))
				for j = 1, #npcTable do
					if npcID == npcTable[j] then
						-- Dispel
						for n = 1, 40 do
							local buff, _, _, bufftype = br._G.UnitDebuff(target, n)
							if buff then
								if bufftype == "Magic" or bufftype == "Curse" or bufftype == "Poison" then
									if br.functions.cast:castSpell(target, 88423, true, false) then
										return
									end
								end
							else
								break
							end
						end
						-- Heal
						local npcHP = br.functions.unit:getHP(target)
						if npcHP < 100 then
							if br.functions.cast:castSpell(target, spellTable[Class].heal, true) then
								return
							end
						end
					end
				end
			end
		end
	end
end

function cast:isCastingTime(lagTolerance)
	lagTolerance = lagTolerance or 0
	if br._G.UnitCastingInfo("player") ~= nil then
		if select(5, br._G.UnitCastingInfo("player")) - br._G.GetTime() <= lagTolerance then
			return true
		end
	elseif br._G.UnitChannelInfo("player") ~= nil then
		if select(5, br._G.UnitChannelInfo("player")) - br._G.GetTime() <= lagTolerance then
			return true
		end
	elseif br.functions.spell:getGlobalCD() <= lagTolerance then
		return true
	else
		return false
	end
end

-- if getCastTime("Healing Touch")<3 then
function cast:getCastTime(spellID)
	if spellID == 202767 then
		if select(3, br.api.wow.GetSpellInfo(202767)) == 1392545 then
			spellID = 202767
		elseif select(3, br.api.wow.GetSpellInfo(202767)) == 1392543 then
			spellID = 202768
		elseif select(3, br.api.wow.GetSpellInfo(202767)) == 1392542 then
			spellID = 202771
		end
	end
	local castTime = select(4, br.api.wow.GetSpellInfo(spellID)) / 1000
	return castTime
end

function cast:getCastTimeRemain(unit)
	if br._G.UnitCastingInfo(unit) ~= nil then
		return select(5, br._G.UnitCastingInfo(unit)) / 1000 - br._G.GetTime()
	elseif br._G.UnitChannelInfo(unit) ~= nil then
		return select(5, br._G.UnitChannelInfo(unit)) / 1000 - br._G.GetTime()
	else
		return 0
	end
end

-- if isCasting() == true then
function cast:castingUnit(Unit)
	if Unit == nil then Unit = "player" end
	if br._G.UnitCastingInfo(Unit) ~= nil
		or br._G.UnitChannelInfo(Unit) ~= nil
		or br.functions.spell:getGlobalCD() > 0.001 then
		return true
	else
		return false
	end
end

-- if br.functions.cast:isCastingSpell(12345) == true then
function cast:isCastingSpell(spellID, unit)
	if unit == nil then unit = "player" end
	-- Check regular cast (UnitCastingInfo returns spellID as 9th value)
	local _, _, _, _, _, _, _, _, castingSpellID = br._G.UnitCastingInfo(unit)
	if castingSpellID == spellID then
		return true
	end
	-- Check channel (UnitChannelInfo returns spellID as 8th value)
	local _, _, _, _, _, _, _, channelingSpellID = br._G.UnitChannelInfo(unit)
	if channelingSpellID == spellID then
		return true
	end
	return false
end

-- if isCasting(12345,"target") then
function cast:isCasting(SpellID, Unit)
	if br.functions.unit:GetUnitIsVisible(Unit) and br._G.UnitCastingInfo(Unit) then
		if br._G.UnitCastingInfo(Unit) == br.api.wow.GetSpellInfo(SpellID) then
			return true
		end
	else
		return false
	end
end

-- if br.functions.cast:isCastingSpell(12345) == true then
function cast:isUnitCasting(unit)
	if unit == nil then unit = "player" end
	local spellCasting = br._G.UnitCastingInfo(unit)
	if spellCasting == nil then
		spellCasting = br._G.UnitChannelInfo(unit)
	end
	if spellCasting ~= nil then
		return true
	else
		return false
	end
end

local castTimers
local rangeDelayTimers -- Track when spells first become in range

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: Pet action bar cache
--
-- FindSpellBookSlotBySpellID and IsSpellKnown(id, true) do not exist on
-- TBC Classic 2.5.x clients, making it impossible to determine whether a pet
-- knows a spell through the standard spell-knowledge APIs.
-- Instead we scan the pet action bar (GetPetActionInfo) by name — this is the
-- only reliable TBC-compatible way to discover pet spell knowledge.
-- The cache is rebuilt at most once every 5 seconds (the bar never changes
-- mid-fight except when the pet learns a new rank between pulls).
-- ─────────────────────────────────────────────────────────────────────────────
local petBarCache     = nil  -- map: ability name → slot index
local petBarCacheTime = 0

local function getPetBarSlot(spellName)
	if not spellName then return nil end
	local now = br._G.GetTime()
	if not petBarCache or now - petBarCacheTime > 5 then
		petBarCache     = {}
		petBarCacheTime = now
		if br._G.NUM_PET_ACTION_SLOTS then
			for i = 1, br._G.NUM_PET_ACTION_SLOTS do
				local name = br._G.GetPetActionInfo(i)
				if name then petBarCache[name] = i end
			end
		end
	end
	return petBarCache[spellName]
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: createCastFunction infrastructure
--
-- These module-level helpers are shared across every createCastFunction call.
-- Splitting them out of the function body means they are allocated once (not
-- once per call) and can be read, tested, and debugged independently.
-- ─────────────────────────────────────────────────────────────────────────────

-- Gate debug message throttle: emit at most once per 2s per spell to avoid flooding chat.
local gateDebugThrottle = {}
local GATE_DEBUG_THROTTLE_SECS = 2.0
local gateDebugSilentUntil = 0 -- suppresses gate debug for N seconds after castTimers reset

local function emitGateDebug(spellID, spellName, reason, detail)
	if not shouldPrintCastDebug() then return end
	local now = br._G.GetTime()
	if now < gateDebugSilentUntil then return end
	local key = spellID .. reason
	if gateDebugThrottle[key] and now < gateDebugThrottle[key] then return end
	gateDebugThrottle[key] = now + GATE_DEBUG_THROTTLE_SECS
	local msg = "[GATE: " .. reason .. "] " .. tostring(spellName) .. " (" .. tostring(spellID) .. ")"
	if detail then msg = msg .. " — " .. detail end
	br.player.ui.debug(msg)
end

-- buildSpellContext: collect all spell info and computed values that the gate
-- and dispatch phases need.  Called once per createCastFunction invocation so
-- every downstream check reads from the returned table instead of re-calling
-- the same WoW APIs multiple times.
local function buildSpellContext(spellID, predict, predictPad, castType, effectRng)
	local spellName, _, icon, rawCastTime, minRange, maxRange = br.api.wow.GetSpellInfo(spellID)
	local baseSpellID   = br.api.wow.FindBaseSpellByID(spellID)
	local overrideSpellID = br._G.FindSpellOverrideByID(spellID)
	local baseSpellName = br.api.wow.GetSpellInfo(baseSpellID)
	local spellType     = br.functions.spell:getSpellType(baseSpellName)

	-- Resolve range: some spells return 0 for maxRange on the override; fall back to base.
	if (not maxRange or maxRange == 0) and baseSpellID and baseSpellID ~= spellID then
		_, _, _, _, minRange, maxRange = br.api.wow.GetSpellInfo(baseSpellID)
	end

	-- Cast-time handling: if prediction is requested include cast time (in seconds).
	local castTime = rawCastTime or 0
	if predict then
		castTime = castTime / 1000
	else
		castTime = 0
	end
	if predictPad then castTime = castTime + predictPad end

	-- Normalise ranges.
	minRange = minRange or 0
	if not maxRange or maxRange == 0 then
		-- For castType "pet", maxRange=0 from the API is the literal melee range —
		-- preserve it so checkRange uses `distance <= 5` (melee test).  For all
		-- other cast types, 0 means "range unspecified" so we substitute effectRng.
		maxRange = (castType == "pet") and 0 or tonumber(effectRng)
	else
		maxRange = tonumber(maxRange)
	end

	-- Snapshot values that are used in multiple gate checks.
	local spellCD    = br.functions.spell:getSpellCD(spellID) or 0
	local globalCD   = br.functions.spell:getGlobalCD()
	local baseCooldown = (select(2, br._G.GetSpellBaseCooldown(spellID)) or 0)
	local isUsable   = br._G.C_Spell.IsSpellUsable(spellID)
	local updateRate = br.engines:getUpdateRate()
	local latency    = select(3, br._G.GetNetStats()) / 100

	-- lastCastTime lookup (seed it lazily; identical to original behaviour).
	if br.functions.lastCast.lastCastTable.castTime[spellID] == nil then
		br.functions.lastCast.lastCastTable.castTime[spellID] = br._G.GetTime() -
			(br.functions.spell:getGlobalCD(true) + latency)
	end
	local lastCastTime = br.functions.lastCast.lastCastTable.castTime[spellID]

	return {
		spellID        = spellID,
		baseSpellID    = baseSpellID,
		overrideSpellID = overrideSpellID,
		spellName      = spellName,
		baseSpellName  = baseSpellName,
		icon           = icon,
		rawCastTime    = rawCastTime or 0,
		castTime       = castTime,
		minRange       = minRange,
		maxRange       = maxRange,
		spellType      = spellType,
		spellCD        = spellCD,
		globalCD       = globalCD,
		baseCooldown   = baseCooldown,
		isUsable       = isUsable,
		updateRate     = updateRate,
		latency        = latency,
		lastCastTime   = lastCastTime,
	}
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: Gate functions
--
-- Each returns (true) on pass, or (false, "REASON_CODE", "human detail") on
-- fail.  The gate runner calls emitGateDebug on any failure when debug output
-- is enabled.
-- ─────────────────────────────────────────────────────────────────────────────

local function gateSpellID(ctx, thisUnit, castType, allTalents, allSpells) -- luacheck: ignore 212
	if ctx.baseSpellID == ctx.spellID or ctx.overrideSpellID == ctx.spellID then
		if br.empowerID ~= nil and br.empowerID ~= 0 then
			-- Empowered spell in progress; only allow that specific spell.
			if ctx.spellID ~= br.empowerID then
				return false, "EMPOWER_LOCKED",
					"empowerID=" .. tostring(br.empowerID) .. " != spellID=" .. tostring(ctx.spellID)
			end
		end
		return true
	end
	return false, "SPELL_ID_MISMATCH",
		"base=" .. tostring(ctx.baseSpellID) ..
		" override=" .. tostring(ctx.overrideSpellID) ..
		" spellID=" .. tostring(ctx.spellID)
end

local function gateDoubleCast(ctx, thisUnit, castType, allTalents, allSpells) -- luacheck: ignore 212
	local elapsed = br._G.GetTime() - ctx.lastCastTime
	local window  = br.functions.spell:getGlobalCD(true) + ctx.latency
	if elapsed > window then return true end
	return false, "DOUBLE_CAST",
		string.format("cast %.2fs ago, window=%.2fs (GCD %.2fs + lat %.0fms)",
			elapsed, window, br.functions.spell:getGlobalCD(true), ctx.latency * 100)
end

local function gateDiesSoon(ctx, thisUnit, castType, allTalents, allSpells) -- luacheck: ignore 212
	-- Self or friendly targets never fail this check.
	if thisUnit == nil
		or br._G.UnitIsUnit(thisUnit, "player")
		or br._G.UnitIsFriend(thisUnit, "player")
	then
		return true
	end
	-- castType "dead" is handled separately below; skip dies-soon for it.
	if castType == "dead" then return true end
	local gcdVal = br.functions.spell:getGlobalCD(true)
	if ctx.rawCastTime / 1000 <= gcdVal
		or (ctx.rawCastTime / 1000) < br.engines.ttdTable:getTTD(thisUnit)
	then
		return true
	end
	return false, "DIES_SOON",
		string.format("castTime=%.2fs TTD=%.2fs",
			ctx.rawCastTime / 1000, br.engines.ttdTable:getTTD(thisUnit))
end

local function gateUsable(ctx, thisUnit, castType, allTalents, allSpells) -- luacheck: ignore 212
	-- Pet abilities live in the pet spellbook; C_Spell.IsSpellUsable on the player
	-- returns false regardless of the actual pet cooldown/focus state — check focus directly.
	if castType == "pet" then
		-- getSpellCost uses C_Spell.GetSpellPowerCost which returns the spell's resource cost
		-- and power type from the spell definition, even for pet ability IDs.
		-- If the API returns 0 (e.g. not exposed for this spell), the check is skipped safely.
		local minCost, _, powerType = br.functions.power:getSpellCost(ctx.spellID)
		if minCost and minCost > 0 then
			local petPower = powerType
				and (br._G.UnitPower("pet", powerType) or 0)
				or  (br._G.UnitPower("pet") or 0)
			if petPower < minCost then
				return false, "NOT_USABLE",
					string.format("pet focus %d < cost %d", petPower, minCost)
			end
		end
		return true
	end
	-- IsSpellUsable returns false when the player lacks resources, wrong form, etc.
	-- nil means "usable but no resource requirement" — treat as pass.
	if ctx.isUsable ~= false then return true end
	return false, "NOT_USABLE",
		"IsSpellUsable=false (wrong form / insufficient power)"
end

local function gateCooldownTimer(ctx, thisUnit, castType, allTalents, allSpells) -- luacheck: ignore 212
	-- Pet abilities: GetSpellCooldown does not reflect pet bar state from the player
	-- side.  Use GetPetActionCooldown on the actual bar slot — the only TBC-compatible
	-- source of truth for per-ability cooldown state.
	if castType == "pet" then
		local slot = getPetBarSlot(ctx.spellName)
		if slot and br._G.GetPetActionCooldown then
			local cdStart, cdDuration = br._G.GetPetActionCooldown(slot)
			if cdStart and cdDuration and cdDuration > 0
					and (cdStart + cdDuration) > br._G.GetTime() then
				return false, "PET_ON_COOLDOWN",
					string.format("petCD=%.2fs remaining", (cdStart + cdDuration) - br._G.GetTime())
			end
		end
		-- castTimers fallback: covers CastPetAction attempts where the game did not apply a
		-- bar cooldown (e.g. pet was out of range so the ability queued but never executed).
		-- The dispatch always writes castTimers, so this prevents rapid-fire retries even
		-- when GetPetActionCooldown still reports 0 on the same or next tick.
		if castTimers then
			local t = castTimers[ctx.spellID]
			if t and t > br._G.GetTime() then
				return false, "PET_CAST_TIMER",
					string.format("pet cast timer expires in %.2fs", t - br._G.GetTime())
			end
		end
		return true
	end
	if castTimers == nil then return true end -- not yet initialised; pass
	local t = castTimers[ctx.spellID]
	if t == nil or t < br._G.GetTime() then
		if ctx.spellCD <= ctx.updateRate then return true end
		return false, "ON_COOLDOWN",
			string.format("spellCD=%.2fs updateRate=%.3fs", ctx.spellCD, ctx.updateRate)
	end
	return false, "CAST_TIMER",
		string.format("castTimer expires in %.2fs", t - br._G.GetTime())
end

local function gateGCD(ctx, thisUnit, castType, allTalents, allSpells) -- luacheck: ignore 212
	-- Pass if: GCD is clear, OR spell has its own CD ready, OR spell has no base CD (instant),
	-- OR a cast is already in progress and will complete within the update window.
	if ctx.globalCD <= 0 then return true end
	if ctx.spellCD <= 0 then return true end
	if ctx.baseCooldown <= 0 then return true end
	if ctx.rawCastTime > 0 then
		local castTimeRemain = br.functions.cast:getCastTimeRemain("player")
		if castTimeRemain <= ctx.updateRate then return true end
	end
	return false, "GCD_BLOCKED",
		string.format("globalCD=%.2fs spellCD=%.2fs baseCooldown=%d",
			ctx.globalCD, ctx.spellCD, ctx.baseCooldown)
end

local function gateKnownTalent(ctx, thisUnit, castType, allTalents, allSpells) -- luacheck: ignore 212
	-- Known check.
	-- For pet castType, scan the pet action bar by name — the only TBC-compatible
	-- way to verify the pet actually has this ability (spell-knowledge APIs that
	-- accept isPetSpell do not exist on TBC Classic 2.5.x).
	if castType == "pet" then
		if not getPetBarSlot(ctx.spellName) then
			return false, "NOT_KNOWN",
				"Pet ability '" .. tostring(ctx.spellName) .. "' not found on pet action bar"
		end
		-- Talent table not applicable for pet spells.
		return true
	end
	local isCondemn = allSpells and (ctx.spellID == allSpells.condemn or ctx.spellID == allSpells.condemnMassacre)
	local isKnownOrPet = br.functions.spell:isKnown(ctx.spellID)
		or (castType == "pet" and (
			(br._G.IsSpellKnown and br._G.IsSpellKnown(ctx.spellID, true))
			or br.functions.spell:isSpellInSpellbook(ctx.spellID, "pet")))
	if not isKnownOrPet and castType ~= "known" and not isCondemn then
		return false, "NOT_KNOWN",
			"isKnown=false castType=" .. tostring(castType)
	end
	-- Talent check.
	if allTalents then
		for k, v in pairs(allTalents) do
			if ctx.spellID == v then
				if not (br.player.talent[k] or br.functions.spell:isKnown(ctx.spellID)) then
					return false, "NO_TALENT",
						"talent '" .. tostring(k) .. "' not active"
				end
				break
			end
		end
	end
	return true
end

local function gateHardCC(ctx, thisUnit, castType, allTalents, allSpells) -- luacheck: ignore 212
	if br.functions.combat
		and br.functions.combat.cannotCast
		and br.functions.combat:cannotCast(ctx.spellID)
	then
		return false, "HARD_CC", "cannotCast=true"
	end
	if br.functions.combat:isIncapacitated(ctx.spellID) then
		return false, "HARD_CC", "isIncapacitated=true"
	end
	return true
end

-- Returns true if spellID maps to a shapeshift/stance toggle button.
-- These report IsCurrentSpell=true while the form is *active*, but the player
-- can legitimately force-recast them (e.g. powershift via "/cast !Cat Form") —
-- blocking them here would silently break that pattern.
-- Cache is rebuilt whenever the form count changes (talent respec / level-up).
local shapeshiftFormCache = nil
local function isShapeshiftFormSpell(spellID)
	if not br._G.GetNumShapeshiftForms or not br._G.GetShapeshiftFormInfo then
		return false
	end
	local count = br._G.GetNumShapeshiftForms()
	if not shapeshiftFormCache or shapeshiftFormCache.count ~= count then
		shapeshiftFormCache = { count = count }
		for i = 1, count do
			local _, _, _, formSpellID = br._G.GetShapeshiftFormInfo(i)
			if formSpellID then
				shapeshiftFormCache[formSpellID] = true
			end
		end
	end
	return shapeshiftFormCache[spellID] == true
end

local function gateAutoRepeat(ctx, thisUnit, castType, allTalents, allSpells) -- luacheck: ignore 212
	local spellName = ctx.spellName
	if br._G.C_Spell.IsAutoRepeatSpell(spellName) then
		return false, "AUTO_REPEAT", "IsAutoRepeatSpell=true"
	end
	-- Block any non-pet spell that IsCurrentSpell reports as already active/queued
	-- (e.g. Heroic Strike / Maul / Raptor Strike sitting in the melee queue).
	-- Exception: shapeshift/stance toggle spells report IsCurrentSpell=true while
	-- the form is active, but they are safe to force-recast with the ! prefix —
	-- do not block those here.
	-- Skipped for pet castType: pet abilities are not current player spells, and
	-- auto-cast enabled pet abilities could spuriously match on some clients.
	if castType ~= "pet" and br._G.IsCurrentSpell and br._G.IsCurrentSpell(ctx.spellID) then
		if not isShapeshiftFormSpell(ctx.spellID) then
			return false, "CURRENT_SPELL", "IsCurrentSpell=true (already queued)"
		end
	end
	return true
end

local function gateDeadCheck(ctx, thisUnit, castType, allTalents, allSpells) -- luacheck: ignore 212
	if castType ~= "dead" then return true end
	if thisUnit == nil then return true end
	if br._G.UnitIsDeadOrGhost(thisUnit) then return true end
	return false, "NOT_DEAD_TARGET", "castType=dead but unit is alive"
end

-- Ordered list of gates executed by runGates. All gate functions share the
-- uniform signature (ctx, thisUnit, castType, allTalents, allSpells) so the
-- runner can call every entry identically without branching.
local GATE_FUNCTIONS = {
	gateSpellID,
	gateDoubleCast,
	gateDiesSoon,
	gateUsable,
	gateCooldownTimer,
	gateGCD,
	gateKnownTalent,
	gateHardCC,
	gateAutoRepeat,
	gateDeadCheck,
}

-- runGates: execute all gate functions in order.
-- Returns true on full pass, or false with the failing reason code.
-- isAbleCheck: when true (cast.able calls), gate failures are expected and not printed.
local function runGates(ctx, thisUnit, castType, isAbleCheck)
	local allTalents = br.player and br.player.spells and br.player.spells.talents
	local allSpells  = br.player and br.player.spells
	for _, gateFn in ipairs(GATE_FUNCTIONS) do
		local pass, reason, detail = gateFn(ctx, thisUnit, castType, allTalents, allSpells)
		if not pass then
			if not isAbleCheck then
				emitGateDebug(ctx.spellID, ctx.spellName, reason, detail)
			end
			return false, reason
		end
	end
	return true
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: Per-tick gate result cache
--
-- When cast.able.X() (debug=true) passes all gates we cache the context keyed
-- by (spellID | castType | rawUnit).  If cast.X() is called in the same Lua
-- frame with the same arguments, we skip re-running buildSpellContext and the
-- gate runner entirely and reuse the cached ctx.
--
-- WoW Lua is single-threaded and synchronous: no C-side game state changes
-- between two calls in the same rotation tick, so reusing the gate result is
-- always correct.  The cache TTL (50 ms) is intentionally shorter than the
-- engine update rate so that stale entries from previous ticks are never used.
-- ─────────────────────────────────────────────────────────────────────────────

local GATE_CACHE_TTL = 0.05 -- seconds
local gateCache = {}

local function gateCacheKey(spellID, castType, thisUnitArg)
	return tostring(spellID) .. "|" .. tostring(castType or "norm") .. "|" .. tostring(thisUnitArg or "nil")
end

local function gateCacheStore(key, ctx)
	gateCache[key] = { ctx = ctx, expiresAt = br._G.GetTime() + GATE_CACHE_TTL }
end

-- Returns the cached ctx if valid, nil otherwise.
local function gateCacheGet(key)
	local entry = gateCache[key]
	if entry and br._G.GetTime() < entry.expiresAt then
		return entry.ctx
	end
	gateCache[key] = nil -- expired; clear slot
	return nil
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: castingSpell (was a closure; now module-level for zero reallocation)
--
-- Performs the actual WoW cast API call and post-cast verification.
-- debug=true: used by cast.able — returns true immediately without casting.
-- ─────────────────────────────────────────────────────────────────────────────

local function castingSpell(ctx, thisUnit, castType, printReport, debug)
	if br._G.UnitHealth(thisUnit) <= 0 and castType ~= "dead" then return false end

	-- cast.able path: no side effects.
	if debug then return true end

	-- Hard CC guard (re-checked here so the timer is set correctly even if the
	-- gate was bypassed via cache).
	if br.functions.combat and br.functions.combat.cannotCast and br.functions.combat:cannotCast(ctx.spellID) then
		castTimers[ctx.spellID] = br._G.GetTime() + 0.50
		setCastIntentLock(ctx.spellID, 0.50)
		return printReport(false, "No Control")
	end

	setCastIntentLock(ctx.spellID, 0.20)
	local snapshot = takeCastStartSnapshot(ctx.spellID)

	br.botCast = true
	br.botSpell = ctx.spellID
	br.botUnit  = thisUnit

	-- Condemn patch (Blizzard spell-swap quirk).
	local castName = ctx.spellName
	if br.player and br.player.spells
		and (ctx.spellID == br.player.spells.condemn or ctx.spellID == br.player.spells.condemnMassacre)
	then
		castName = br.api.wow.GetSpellInfo(br.player.spells.execute)
	end

	-- Pet ability dispatch: CastSpellByName cannot activate pet action bar abilities.
	-- Scan the pet action bar for a slot matching the spell name and use CastPetAction.
	if castType == "pet" then
		if br._G.NUM_PET_ACTION_SLOTS then
			for i = 1, br._G.NUM_PET_ACTION_SLOTS do
				local slotName = br._G.GetPetActionInfo(i)
				if slotName == castName then
					br._G.CastPetAction(i)
					-- Read the cooldown the game just applied to the bar slot.
					-- GetPetActionCooldown is updated synchronously after CastPetAction,
					-- so cdDuration reflects the real ability cooldown on TBC Classic.
					local cdStart, cdDuration
					if br._G.GetPetActionCooldown then
						cdStart, cdDuration = br._G.GetPetActionCooldown(i)
					end
					local petCDSec = (cdDuration and cdDuration > 0) and cdDuration
						or (ctx.baseCooldown > 0 and ctx.baseCooldown / 1000)
						or 8  -- fallback: most pet abilities are 8–10 s
					castTimers[ctx.spellID] = br._G.GetTime() + math.max(petCDSec, 1)
					setCastIntentLock(ctx.spellID, 0.5)
					br.ui.toggles.mainButton:SetNormalTexture(ctx.icon)
					br.lastSpellCast   = ctx.spellID
					br.lastSpellTarget = br._G.UnitGUID(thisUnit)
					return true
				end
			end
		end
		return printReport(false, "PET_SLOT_NOT_FOUND", castName)
	end

	br._G.CastSpellByName(castName, thisUnit)
	if br._G.IsAoEPending() then
		local X, Y, Z = br._G.ObjectPosition(thisUnit)
		br._G.ClickPosition(X, Y, Z)
	end

	local castSucceeded, details = verifyCastStarted(ctx.spellID, snapshot, castName)

	if castSucceeded then
		castTimers[ctx.spellID] = br._G.GetTime() + 1
		local sameSpellCastRemain = getSameSpellCastRemain(ctx.spellID)
		if sameSpellCastRemain > 0 then
			setCastIntentLock(ctx.spellID, sameSpellCastRemain + 0.12)
		else
			local settleLock = 0.12
			if ctx.spellType == "Helpful" then
				settleLock = 0.30
			elseif ctx.spellType == "Harmful" and not br._G.UnitAffectingCombat("player") then
				settleLock = 0.30
			end
			setCastIntentLock(ctx.spellID, settleLock)
		end
		br.ui.toggles.mainButton:SetNormalTexture(ctx.icon)
		br.lastSpellCast   = ctx.spellID
		br.lastSpellTarget = br._G.UnitGUID(thisUnit)
		return true
	end

	if details and details.inconclusive then
		castTimers[ctx.spellID] = br._G.GetTime() + 0.10
		setCastIntentLock(ctx.spellID, 0.20)
		return true -- queued / not yet confirmed; do not spam CAST_FAILED
	end

	castTimers[ctx.spellID] = br._G.GetTime() + 0.10
	setCastIntentLock(ctx.spellID, 0.20)
	return printReport(false, "Cast Failed")
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: Unit selection helpers
-- ─────────────────────────────────────────────────────────────────────────────

-- resolveUnit: if thisUnit is nil, ask the engine for the best match.
-- Returns the resolved unit token, or nil if nothing found.
local function resolveUnit(ctx, thisUnit, castType)
	if thisUnit ~= nil then return thisUnit end
	if castType == "norm" or castType == "dead" or castType == "rect" or castType == "cone" then
		return br.functions.unit:getSpellUnit(ctx.baseSpellID, false, ctx.minRange, ctx.maxRange, ctx.spellType)
	elseif castType == "groundCC" or castType == "groundLocation" then
		return nil -- handled as early exits in the dispatch section
	else
		return br.functions.unit:getSpellUnit(ctx.baseSpellID, true, ctx.minRange, ctx.maxRange, ctx.spellType)
	end
end

-- checkUnitValidity: returns true when the unit is acceptable to cast on.
local function checkUnitValidity(thisUnit, castType)
	if br.functions.unit:GetUnitIsUnit(thisUnit, "player")    then return true end
	if br.functions.unit:GetUnitIsFriend(thisUnit, "player")  then return true end
	if castType == "pet" then
		return br._G.UnitExists(thisUnit) == true
	end
	if br.engines.enemiesEngine.units[thisUnit] ~= nil         then return true end
	if br.functions.misc:getLineOfSight("player", thisUnit)    then return true end
	return false
end

-- checkRange: range check with API + moving-hysteresis guard + distance fallback.
local function checkRange(ctx, thisUnit, castType)
	if thisUnit == "player" then return true end
	-- For pet castType, IsSpellInRange evaluates from the PLAYER's position — not the
	-- pet's — so it cannot reliably gate melee or short-range pet abilities.  Skip the
	-- API check entirely for pet spells and always measure pet-to-target distance directly.
	if castType ~= "pet" then
		local spellInRange = br._G.C_Spell.IsSpellInRange(ctx.spellName, thisUnit)
		if spellInRange == false then
			local timerKey = ctx.spellID .. "_" .. (br._G.UnitGUID(thisUnit) or thisUnit)
			rangeDelayTimers[timerKey] = nil
			return false
		end
		if spellInRange == true then
			if br.functions.misc:isMoving("player") and ctx.maxRange > 0 then
				local now      = br._G.GetTime()
				local timerKey = ctx.spellID .. "_" .. (br._G.UnitGUID(thisUnit) or thisUnit)
				if rangeDelayTimers[timerKey] == nil then
					rangeDelayTimers[timerKey] = now
					return false
				end
				if (now - rangeDelayTimers[timerKey]) < 0.5 then
					return false
				end
			end
			return true
		end
	end
	-- nil from IsSpellInRange (or pet castType): measure distance directly.
	-- For pet castType, getDistance(pettarget, "pet") measures pet-to-target distance.
	local distance = (castType == "pet")
		and br.functions.range:getDistance(thisUnit, "pet")
		or  br.functions.range:getDistance(thisUnit)

	-- Melee spells (maxRange == 0) would produce distance < -1.5 which is always false.
	-- Treat as in-range when within 5 yards (standard melee reach).
	if ctx.maxRange == 0 then return distance <= 5 end
	return (distance >= ctx.minRange and distance < ctx.maxRange - 1.5)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: Dispatch helpers (AoE and ST)
-- ─────────────────────────────────────────────────────────────────────────────

local function dispatchAoE(ctx, thisUnit, castType, minUnits, effectRng, enemies, printReport, debug)
	local enemyCount = enemies
		or ((castType == "ground" or castType == "aoe") and #br.engines.enemiesEngineFunctions:getEnemies("player", ctx.maxRange))
		or (castType == "cone"      and br.engines.enemiesEngineFunctions:getEnemiesInCone(effectRng, ctx.maxRange))
		or (castType == "rect"      and br.engines.enemiesEngineFunctions:getEnemiesInRect(effectRng, ctx.maxRange))
		or (castType == "targetAOE" and #br.engines.enemiesEngineFunctions:getEnemies(thisUnit, effectRng))
		or 0
	if enemyCount >= minUnits
		and (br.functions.range:isSafeToAoE(ctx.spellID, thisUnit, effectRng, minUnits, castType, enemyCount)
			or br.functions.unit:isDummy("target"))
	then
		return castingSpell(ctx, thisUnit, castType, printReport, debug)
	end
	if castType == "cone" then return printReport(false, "Below Min Units Cone", enemyCount) end
	if castType == "rect" then return printReport(false, "Below Min Units Rect", enemyCount) end
	return printReport(false, "Below Min Units", enemyCount)
end

local function dispatchST(ctx, thisUnit, castType, minUnits, enemies, printReport, debug)
	-- getFacing returns true/false/nil. nil means "can't determine" (no unlocker, or positions
	-- unavailable). Treat nil as OK — only block when the API definitively says not facing.
	local facingOk = (castType == "norm" and br.functions.unit:getFacing("player", thisUnit) ~= false)
		or (castType == "pet" and br.functions.unit:getFacing("pet", thisUnit) ~= false)
		or ctx.spellType == "Helpful"
		or ctx.spellType == "Unknown"
	if not facingOk then return false end
	local enemyFacingCount = enemies or #br.engines.enemiesEngineFunctions:getEnemies("player", ctx.maxRange, false, true) or 0
	if minUnits == 1 or enemyFacingCount >= minUnits
		or ctx.spellType == "Helpful" or ctx.spellType == "Unknown"
	then
		return castingSpell(ctx, thisUnit, castType, printReport, debug)
	end
	return printReport(false, "Below Min Units Facing", enemyFacingCount)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: createCastFunction (public entry point)
--
-- cast.able.X() calls this with debug=true  → run pipeline, return bool, no cast.
-- cast.X()      calls this with debug=false → run pipeline, cast, return bool.
--
-- Profile-level API is unchanged.  The internal structure is now:
--   1. Resolve spell ID table → single spellID
--   2. Guard: isCastingSpell / intentLock (intent lock skipped on debug=true)
--   3. buildSpellContext (or reuse per-tick gate cache)
--   4. Quaking Helper affix check
--   5. runGates (all gate checks, each with structured debug output)
--   6. Normalise parameters
--   7. Pre-fill enemies counts
--   8. resolveUnit / special-unit early exits
--   9. checkUnitValidity + checkRange
--  10. dispatchAoE or dispatchST → castingSpell
-- ─────────────────────────────────────────────────────────────────────────────
function cast:createCastFunction(thisUnit, castType, minUnits, effectRng, spellID, index, predict, predictPad, enemies,
							   debug)
	-- ── Step 1: Resolve spell ID table → single spellID ──────────────────────
	if type(spellID) == "table" then
		if castType == "pet" then
			-- TBC Classic does not expose FindSpellBookSlotBySpellID or a pet-aware
			-- IsSpellKnown.  Scan the pet action bar by name to find which rank the
			-- pet knows: GetPetActionInfo always exposes the pet's current learned rank.
			for i = #spellID, 1, -1 do
				local name = br.api.wow.GetSpellInfo(spellID[i])
				if name and getPetBarSlot(name) then
					spellID = spellID[i]
					break
				end
			end
		else
			for i = #spellID, 1, -1 do
				if br.functions.spell:isKnown(spellID[i]) then
					spellID = spellID[i]
					break
				end
			end
		end
	end
	if spellID == nil or br.api.wow.GetSpellInfo(spellID) == nil then
		br._G.print("Invalid Spell ID: " .. tostring(spellID) .. " for key: " .. tostring(index))
		return false
	end

	-- ── Step 2: Normalise call parameters ────────────────────────────────────
	if castType == nil  then castType  = "norm" end
	if minUnits == nil  then minUnits  = 1      end
	if effectRng == nil then effectRng = 5      end
	if debug == nil     then debug     = false   end

	-- ── Step 3: Fast guards (no ctx needed) ──────────────────────────────────
	-- Never recast a spell that is already being cast/channelled.
	if cast:isCastingSpell(spellID, "player") then return false end
	-- Intent lock prevents rapid recasting (skipped for cast.able checks).
	if not debug and isCastIntentLocked(spellID) then return false end

	-- ── Step 4: Empowered-spell bypass (Evoker) ───────────────────────────────
	-- When an empowered cast is in progress, only that spell bypasses normal gates.
	local isEmpoweredBypass = br.empowerID ~= nil and br.empowerID ~= 0 and spellID == br.empowerID

	-- ── Step 5: Build spell context (or reuse per-tick cache) ─────────────────
	-- The cache key includes the raw thisUnit arg (before unit resolution) because
	-- the gate checks that involve thisUnit (dies-soon, dead-check) must see the
	-- same argument both times to be valid cache hits.
	local cacheKey = gateCacheKey(spellID, castType, thisUnit)
	local ctx = not isEmpoweredBypass and gateCacheGet(cacheKey) or nil
	local gatesPassed = (ctx ~= nil) -- cache hit → gates already passed this tick

	if ctx == nil then
		-- Initialise shared tables on first use.
		if castTimers == nil then
			castTimers = {}
			gateDebugSilentUntil = br._G.GetTime() + 5 -- suppress gate debug burst after reload
		end
		if castTimers[spellID] == nil then castTimers[spellID] = 0 end -- 0 so t < GetTime() is immediately true
		if rangeDelayTimers == nil then rangeDelayTimers = {} end

		ctx = buildSpellContext(spellID, predict, predictPad, castType, effectRng)
	end

	-- ── Step 6: Quaking Helper (M+ affix) ────────────────────────────────────
	if not gatesPassed and br.functions.misc:getOptionCheck("Quaking Helper") then
		local channeledSpell = false
		local costTable = br._G.C_Spell.GetSpellPowerCost(spellID) or {}
		for _, costInfo in pairs(costTable) do
			if costInfo.costPerSec > 0 then channeledSpell = true end
		end
		local quakeRemain = br.functions.aura:getDebuffRemain("player", 240448)
		if quakeRemain > 0 then
			if (ctx.rawCastTime > 0 and quakeRemain <= ((ctx.rawCastTime + 300) / 1000))
				or (ctx.rawCastTime == 0 and channeledSpell and quakeRemain < 1.5)
			then
				return false
			end
		end
	end

	-- ── Step 7: Run gate checks (skipped on cache hit or empowered bypass) ───
	if not gatesPassed and not isEmpoweredBypass then
		local passed, _ = runGates(ctx, thisUnit, castType, debug)
		if not passed then return false end
		-- Cache the passing context so cast.X() in the same tick skips re-running.
		if debug then
			gateCacheStore(cacheKey, ctx)
		end
	end

	-- ── Step 8: Normalise castType "known" → "norm" ───────────────────────────
	if castType == "known" then castType = "norm" end

	-- ── Step 9: Pre-fill enemies count from pre-calculated tables ─────────────
	if enemies == nil then
		local eKey = "yards" .. effectRng
		if (castType == "norm" or castType == "pet") and br.player.enemies[eKey .. "f"] ~= nil then
			enemies = #br.player.enemies[eKey .. "f"]
		elseif castType == "cone" and br.player.enemies[eKey .. "c"] ~= nil then
			enemies = #br.player.enemies[eKey .. "c"]
		elseif castType == "rect" and br.player.enemies[eKey .. "r"] ~= nil then
			enemies = #br.player.enemies[eKey .. "r"]
		elseif castType == "aoe" then
			if thisUnit == "player" and br.player.enemies[eKey] ~= nil then
				enemies = #br.player.enemies[eKey]
			elseif br.player.enemies[eKey .. "t"] ~= nil then
				enemies = #br.player.enemies[eKey .. "t"]
			end
		elseif castType == "targetAOE" and br.player.enemies[eKey .. "t"] ~= nil then
			enemies = #br.player.enemies[eKey .. "t"]
		end
	end

	-- ── Step 10: printReport closure (post-gate failure messages) ─────────────
	local function printReport(debugOnly, debugReason, thisCount)
		if debug then return false end -- never print for cast.able checks
		if debugReason == nil then debugReason = "" end
		local canonicalCodes = {
			["No Unit"]               = "NO_UNIT",
			["Below Min Units"]       = "MIN_UNITS",
			["Below Min Units Facing"]= "MIN_UNITS_FACING",
			["Below Min Units Cone"]  = "MIN_UNITS_CONE",
			["Below Min Units Rect"]  = "MIN_UNITS_RECT",
			["Not Dead"]              = "NOT_DEAD",
			["No Range"]              = "NO_RANGE",
			["Not Safe"]              = "NOT_SAFE",
			["Invalid Unit"]          = "INVALID_UNIT",
			["No Control"]            = "NO_CONTROL",
			["Cast Failed"]           = "CAST_FAILED",
		}
		local reasonCode = canonicalCodes[debugReason]
			or (debugReason ~= "" and tostring(debugReason):upper():gsub("[^A-Z0-9]+", "_") or "UNKNOWN")
		local prefix = "[CAST FAIL][" .. reasonCode .. "] "
		if (br.functions.misc:isChecked("Display Failcasts") and not debugOnly)
			or br.functions.misc:isChecked("Cast Debug")
		then
			if debugReason == "No Unit" then
				br.player.ui.debug(prefix .. ctx.spellName .. " — no unit found in " .. ctx.maxRange .. " yrds.")
			elseif debugReason == "Below Min Units" then
				br.player.ui.debug(prefix .. ctx.spellName .. " — " .. tostring(thisCount) ..
					" enemies in " .. ctx.maxRange .. " yrds, need " .. minUnits .. ".")
			elseif debugReason == "Below Min Units Facing" then
				br.player.ui.debug(prefix .. ctx.spellName .. " — " .. tostring(thisCount) ..
					" facing enemies in " .. ctx.maxRange .. " yrds, need " .. minUnits .. ".")
			elseif debugReason == "Below Min Units Cone" then
				br.player.ui.debug(prefix .. ctx.spellName .. " — " .. tostring(thisCount) ..
					" enemies in " .. effectRng .. "° cone/" .. ctx.maxRange .. " yrds, need " .. minUnits .. ".")
			elseif debugReason == "Below Min Units Rect" then
				br.player.ui.debug(prefix .. ctx.spellName .. " — " .. tostring(thisCount) ..
					" enemies in " .. ctx.maxRange .. "×" .. effectRng .. " yrd rect, need " .. minUnits .. ".")
			elseif debugReason == "Not Dead" then
				br.player.ui.debug(prefix .. ctx.spellName .. " — unit is not dead.")
			elseif debugReason == "No Range" then
				br.player.ui.debug(prefix .. ctx.spellName .. " — unit not in range.")
			elseif debugReason == "Not Safe" then
				br.player.ui.debug(prefix .. ctx.spellName .. " — not safe to AoE.")
			elseif debugReason == "Invalid Unit" then
				if not br._G.UnitIsFriend(thisUnit, "player") and br.engines.enemiesEngine.units[thisUnit] == nil then
					br.player.ui.debug(prefix .. ctx.spellName .. " — unit is not player/friend/known enemy.")
				elseif not br.functions.misc:getLineOfSight(thisUnit) then
					br.player.ui.debug(prefix .. ctx.spellName .. " — unit out of line of sight.")
				else
					br.player.ui.debug(prefix .. ctx.spellName .. " — unit invalid (unknown reason).")
				end
			elseif debugReason == "No Control" then
				br.player.ui.debug(prefix .. ctx.spellName .. " — player is crowd controlled.")
			elseif debugReason == "Cast Failed" then
				local wowReason = br.functions.lastCast
					and br.functions.lastCast.lastCastTable
					and br.functions.lastCast.lastCastTable.lastFailedReason
					and br.functions.lastCast.lastCastTable.lastFailedReason[ctx.spellID]
				if wowReason and wowReason ~= "" then
					br.player.ui.debug(prefix .. ctx.spellName .. " — WoW rejected: " .. wowReason)
				else
					br.player.ui.debug(prefix .. ctx.spellName .. " — no GCD/cast/channel signal after cast attempt.")
				end
			else
				br._G.print("|cffFF0000Error: |r " .. prefix ..
					ctx.spellName .. " ID:" .. spellID ..
					" type:" .. ctx.spellType ..
					" range:[" .. ctx.minRange .. "-" .. ctx.maxRange .. "]" ..
					" dist:" .. br.functions.range:getDistance(thisUnit) ..
					" inRange:" .. tostring(br._G.C_Spell.IsSpellInRange(ctx.spellName, thisUnit)) ..
					" unit:" .. tostring(thisUnit))
			end
		end
		return false
	end

	-- ── Step 11: Unit resolution ──────────────────────────────────────────────
	if thisUnit == nil then
		if castType == "groundCC" or castType == "groundLocation" then
			return -- these types have no unit; handled below
		end
		thisUnit = resolveUnit(ctx, nil, castType)
	end

	if thisUnit == nil or thisUnit == "None" then
		printReport(true, "No Unit")
		return false
	end

	-- ── Step 12: Special unit / ground-targeted early exits ───────────────────
	if thisUnit == "best" then
		if debug then return true end
		return br.functions.custom:castGroundAtBestLocation(spellID, effectRng, minUnits, ctx.maxRange, ctx.minRange, castType, ctx.castTime)
	end

	if thisUnit == "playerGround" or thisUnit == "targetGround" or castType == "groundCC" then
		local targetUnit = (thisUnit == "playerGround") and "player" or "target"
		if castType == "groundCC" then targetUnit = thisUnit end
		if br.functions.range:getDistance(targetUnit) < ctx.maxRange
			or br._G.C_Spell.IsSpellInRange(ctx.spellName, targetUnit) == true
		then
			if debug then return true end
			return br.functions.custom:castGroundAtUnit(spellID, effectRng, minUnits, ctx.maxRange, ctx.minRange, castType, targetUnit)
		end
		return false
	end

	if thisUnit == "groundLocation" then
		if debug then return true end
		return br.functions.cast:castGroundLocation(castType, minUnits, ctx.baseSpellID, ctx.maxRange, ctx.minRange, effectRng)
	end

	-- ── Step 13: Unit validity check ──────────────────────────────────────────
	if not checkUnitValidity(thisUnit, castType) then
		return printReport(false, "Invalid Unit")
	end

	-- ── Step 14: Range check ──────────────────────────────────────────────────
	if not checkRange(ctx, thisUnit, castType) then
		return printReport(false, "No Range")
	end

	-- ── Step 15: Dead-friend cast type ────────────────────────────────────────
	if castType == "dead" then
		if br._G.UnitIsPlayer(thisUnit)
			and br.functions.unit:GetUnitIsDeadOrGhost(thisUnit)
			and br.functions.unit:GetUnitIsFriend(thisUnit, "player")
		then
			return castingSpell(ctx, thisUnit, castType, printReport, debug)
		end
		return printReport(false, "Not Dead")
	end

	-- ── Step 16: AoE dispatch ─────────────────────────────────────────────────
	if castType == "ground" or castType == "aoe" or castType == "cone"
		or castType == "rect" or castType == "targetAOE"
	then
		return dispatchAoE(ctx, thisUnit, castType, minUnits, effectRng, enemies, printReport, debug)
	end

	-- ── Step 17: Single-target dispatch ──────────────────────────────────────
	if castType == "norm" or castType == "pet" then
		return dispatchST(ctx, thisUnit, castType, minUnits, enemies, printReport, debug)
	end

	return false
end

-- Cast Spell Queue
function cast:castQueue()
	-- Catch for spells not registering on Combat log
	if br.player ~= nil then
		if br.player.queue ~= nil and #br.player.queue > 0 and not br._G.IsAoEPending() then
			local now = br._G.GetTime()
			-- TTL: expire queue entries older than 3 GCDs to prevent indefinite retry of stale spells
			local ttl = (br.player.gcdMax or 1.5) * 3
			local i = 1
			while i <= #br.player.queue do
				local entry = br.player.queue[i]
				if entry.queuedAt and (now - entry.queuedAt) > ttl then
					br._G.tremove(br.player.queue, i)
					if not br.functions.misc:isChecked("Mute Queue") then
						br._G.print("Queue entry expired: |cFFFF0000" .. tostring(entry.name) .. "|r")
					end
				else
					i = i + 1
				end
			end
			for j = 1, #br.player.queue do
				local thisUnit = br.player.queue[j].target
				local debug = br.player.queue[j].debug
				local minUnits = br.player.queue[j].minUnits
				local effectRng = br.player.queue[j].effectRng
				local spellID = br.player.queue[j].id
				if br.functions.cast:createCastFunction(thisUnit, debug, minUnits, effectRng, spellID) then return end
			end
		end
	end
	return
end
