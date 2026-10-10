local _, br = ...
br.functions.cast = br.functions.cast or {}
local cast = br.functions.cast
local castIntentLocks = {} -- Tracks cast intent to prevent multiple cast.able() checks succeeding

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: Cast rejection memory
--
-- When the game refuses a BR cast, remember why so the rotation stops retrying
-- it and falls through to something it can actually do. This works from
-- UI_ERROR_MESSAGE, so it needs no combat log and catches whatever the LoS trace
-- and facing math get wrong.
--   aura   - "A more powerful spell is already active": this spell, this unit.
--   los    - "Target not in line of sight": every spell on this unit.
--   facing - "Target needs to be in front of you": harmful spells on this unit.
--   range  - "Out of range": this spell, this unit.
-- ─────────────────────────────────────────────────────────────────────────────
local REJECT_DURATION = { aura = 30, los = 1.0, facing = 0.5, range = 0.5 }
local UNIT_WIDE_REJECT = { los = true, facing = true }
-- Only attribute an error to BR's last cast if that cast was this recent; older
-- errors most likely came from the player's own button presses.
local REJECT_ATTRIBUTION_WINDOW = 1.0
local rejections = {}

local function rejectionKey(kind, spellID, guid)
	if not guid then return nil end
	if UNIT_WIDE_REJECT[kind] then return kind .. ":" .. guid end
	local name = spellID and br.api.wow.GetSpellInfo(spellID)
	if not name then return nil end
	return kind .. ":" .. name .. ":" .. guid
end

-- Record that the game refused spellID on the unit with this GUID.
function cast:setRejected(kind, spellID, guid)
	local key = rejectionKey(kind, spellID, guid)
	if key then rejections[key] = br._G.GetTime() + (REJECT_DURATION[kind] or 0.5) end
end

-- True while a recent cast of spellID on thisUnit was refused for this reason.
function cast:isRejected(kind, spellID, thisUnit)
	local key = rejectionKey(kind, spellID, thisUnit and br._G.UnitGUID(thisUnit))
	if not key then return false end
	local expires = rejections[key]
	if expires and br._G.GetTime() < expires then return true end
	rejections[key] = nil
	return false
end

-- Kept for existing callers (Buff.lua).
function cast:setAuraBounced(spellID, guid) cast:setRejected("aura", spellID, guid) end
function cast:isAuraBounced(spellID, thisUnit) return cast:isRejected("aura", spellID, thisUnit or "player") end

-- Remember which spell BR last sent and at whom, so UI errors can be pinned on it.
local function recordBotCast(spellID, thisUnit)
	br.botCast     = true
	br.botSpell    = spellID
	br.botUnit     = thisUnit
	br.botGUID     = br._G.UnitGUID(thisUnit)
	br.botCastTime = br._G.GetTime()
end

local function errorText(globalName, fallback)
	local text = br._G[globalName]
	if type(text) == "string" and text ~= "" then return text end
	return fallback
end

local function rejectionKindForError(message)
	if message == errorText("SPELL_FAILED_AURA_BOUNCED", "A more powerful spell is already active.") then return "aura" end
	if message == errorText("SPELL_FAILED_LINE_OF_SIGHT", "Target not in line of sight") then return "los" end
	if message == errorText("SPELL_FAILED_UNIT_NOT_INFRONT", "Target needs to be in front of you.")
		or message == errorText("SPELL_FAILED_NOT_INFRONT", "You must be in front of your target.")
		or message == errorText("ERR_BADATTACKFACING", "You are facing the wrong way!")
	then
		return "facing"
	end
	if message == errorText("SPELL_FAILED_OUT_OF_RANGE", "Out of range.")
		or message == errorText("ERR_OUT_OF_RANGE", "Out of range.")
	then
		return "range"
	end
	return nil
end

local castTimers -- per-spell cast throttle; created on first createCastFunction call

-- Called from the UI_ERROR_MESSAGE reader. Records the refusal against BR's most
-- recent cast and frees that spell's throttles so the rotation can use it on
-- another unit straight away.
function cast:handleCastError(message)
	if type(message) ~= "string" then return end
	local kind = rejectionKindForError(message)
	if not kind then return end
	if not (br.botSpell and br.botGUID and br.botCastTime) then return end
	if kind ~= "aura" and (br._G.GetTime() - br.botCastTime) > REJECT_ATTRIBUTION_WINDOW then return end
	cast:setRejected(kind, br.botSpell, br.botGUID)
	if castTimers then castTimers[br.botSpell] = nil end
	castIntentLocks[br.botSpell] = nil
end

-- One visibility rule for every cast path: the player always passes; any other
-- unit, friend or enemy, needs line of sight and must not have just been refused
-- by the game for being out of it.
local function isUnitVisible(thisUnit)
	if thisUnit == nil then return false end
	if br.functions.unit:GetUnitIsUnit(thisUnit, "player") then return true end
	if cast:isRejected("los", nil, thisUnit) then return false end
	return br.functions.misc:canSee(thisUnit)
end

-- Same rule for callers outside this module (target selection), so a unit the cast
-- gate would refuse is never picked as the target in the first place.
function cast:isUnitVisible(thisUnit)
	return isUnitVisible(thisUnit)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: Pre-casting (spell queue window)
--
-- Near the end of a cast the client accepts the next spell and fires it the
-- moment the current cast ends. The rotation is paused for most of a cast and
-- re-runs, top to bottom, once the cast is inside the queue window; whatever
-- the profile ranks highest at that moment is pre-cast, which may be the same
-- spell again (Wrath -> Wrath) or something else (Moonfire needing a refresh).
-- One decision per cast: after pre-casting, the rotation waits for the current
-- cast to end, so a later, lower-priority line can't replace the queued spell.
-- ─────────────────────────────────────────────────────────────────────────────
local spellQueueWindow, spellQueueWindowReadAt = 0.4, nil
local SPELL_QUEUE_WINDOW_REFRESH = 5

-- The client's effective queue window in seconds. C_Spell.GetSpellQueueWindow
-- reports the value in effect (a CVar read may not be, on Forever).
local function getSpellQueueWindow()
	local now = br._G.GetTime()
	if spellQueueWindowReadAt == nil or now - spellQueueWindowReadAt > SPELL_QUEUE_WINDOW_REFRESH then
		spellQueueWindowReadAt = now
		local ms
		if br._G.C_Spell and br._G.C_Spell.GetSpellQueueWindow then
			ms = tonumber(br._G.C_Spell.GetSpellQueueWindow())
		elseif br._G.GetSpellQueueWindow then
			ms = tonumber(br._G.GetSpellQueueWindow())
		elseif br._G.C_CVar and br._G.C_CVar.GetCVar then
			ms = tonumber(br._G.C_CVar.GetCVar("SpellQueueWindow"))
		end
		if ms then spellQueueWindow = ms / 1000 end
	end
	return spellQueueWindow
end

-- How long before the current cast ends the rotation chooses (and pre-casts) the
-- next spell. As late as possible so the choice sees fresh debuff/resource state,
-- but wide enough that at least one rotation tick lands inside it, and never wider
-- than the client will actually queue.
function cast:getQueueWindow()
	local updateRate = br.engines:getUpdateRate() or 0.1
	return math.min(getSpellQueueWindow(), math.max(0.2, updateRate * 2))
end

local queuedBehindCast -- castID (or end time) of the cast we've pre-cast behind

local function currentCastKey()
	local name, _, _, _, endTime, _, castID = br._G.UnitCastingInfo("player")
	if name == nil then return nil end
	return castID or endTime
end

-- True once the rotation has pre-cast its next spell behind this cast.
function cast:isQueuedBehind(castID, endTime)
	local key = castID or endTime
	return key ~= nil and key == queuedBehindCast
end

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

-- True while the player is casting spellID with more than the queue window left.
-- Inside the window the same spell may be pre-cast behind itself (Wrath -> Wrath).
-- Channels are excluded: they're never pre-cast behind themselves.
local function isCastingOutsideQueueWindow(spellID)
	local _, _, _, _, _, _, _, channelSpellID = br._G.UnitChannelInfo("player")
	if channelSpellID ~= nil and channelSpellID == spellID then return true end
	return getSameSpellCastRemain(spellID) > cast:getQueueWindow()
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
	-- Z comes from a unit or ground position, so it's off by a few yards at most; probing
	-- ±10 yards (21 clicks) covers that without burning a frame on hundreds of clicks.
	local maxAttempts = 21

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

	-- No click landed: drop the targeting cursor. Left up, it pauses the whole rotation
	-- (the pause check treats SpellIsTargeting as the player aiming a spell).
	local stillPending = br._G["IsAoEPending"]()
	if stillPending and br._G.SpellStopTargeting then
		br._G.SpellStopTargeting()
	end

	if mouselookActive then
		br._G.MouselookStart()
	end

	return not stillPending
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
	if distance < maxDistance and distance >= minDistance and br.functions.misc:canSeePosition(X, Y, Z) then
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
		if (not castable() and (cooldown == 0 or cooldown > br.player.state.gcdMax)) then
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

local rangeDelayTimers -- Track when spells first become in range
local RANGE_DELAY_PRUNE_INTERVAL = 10
local rangeDelayNextPrune = 0

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: Public throttle infrastructure (AUDIT.md L33 P0)
--
-- These two methods expose the cast-gate's throttle primitives as first-class
-- public API on br.functions.cast. They are NOT internal scaffolding for the
-- L33 cast.macro extension — they are intentional public API surface available
-- to any future framework caller that needs to participate in the cast gate's
-- protection (e.g., a future cast.itemMacro, alternative cancelaura paths, or
-- any non-createCastFunction dispatch route).
--
-- Design philosophy match: complexity-concentrated-API positive baseline
-- (the createCastFunction precedent recorded in AUDIT.md's categorical
-- addendum). The cast-gate machinery is internally dense; these exposure
-- methods export the minimum surface alternative dispatch paths need to
-- integrate without bypassing protection.
--
-- Do NOT retire on "only one caller" grounds. The whole point of public API
-- surface is supporting additional callers without re-exposing infrastructure
-- each time; current call count is not a retire signal.
-- ─────────────────────────────────────────────────────────────────────────────

--- Set the cast-intent lock for a spell.
-- Marks the spell as "intent to cast in progress" for `duration` seconds; cast
-- gate predicates check this lock to prevent multiple cast.able() success
-- transitions for the same spell within the lock window.
-- @function cast:setCastIntentLock
-- @int spellID The spell ID to lock.
-- @number[opt=0.5] duration Lock duration in seconds. Defaults to 0.5
--   (matches the createCastFunction success-path convention).
-- @return nil
function cast:setCastIntentLock(spellID, duration)
    if spellID == nil then return end
    if duration == nil then duration = 0.5 end
    setCastIntentLock(spellID, duration)
end

--- Set the cast timer for a spell.
-- Marks the spell as "recently dispatched" for `duration` seconds; the cast
-- gate's gateCooldownTimer / gateDoubleCast predicates check this timer to
-- block immediate re-fires.
-- @function cast:setCastTimer
-- @int spellID The spell ID to timer-gate.
-- @number[opt=0.5] duration Timer duration in seconds. Defaults to 0.5
--   (matches the createCastFunction success-path convention at L1343).
-- @return nil
function cast:setCastTimer(spellID, duration)
    if spellID == nil then return end
    if duration == nil then duration = 0.5 end
    if castTimers == nil then castTimers = {} end
    castTimers[spellID] = br._G.GetTime() + duration
end

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

-- Last reason each spell was refused, for "/br why <spell>". cast.able failures
-- never reach chat (they're expected on most ticks), so this is the only way to see
-- why a profile line never fires. Keyed by spell name with case, spaces and
-- punctuation stripped, so "maul", "Maul" and the profile key "demoralizingRoar"
-- all find their spell.
local refusals = {}

local function refusalKey(name)
	if type(name) ~= "string" then return nil end
	return (name:lower():gsub("[^%w]", ""))
end

local function refusalEntry(spellID)
	local name = br.api.wow.GetSpellInfo(spellID)
	local key = refusalKey(name)
	if not key then return nil end
	local entry = refusals[key]
	if not entry then
		entry = {}
		refusals[key] = entry
	end
	entry.name, entry.spellID = name, spellID
	return entry
end

local function recordRefusal(spellID, reason, detail)
	local entry = refusalEntry(spellID)
	if not entry then return end
	entry.reason, entry.detail, entry.refusedAt = reason, detail, br._G.GetTime()
end

local function recordPass(spellID)
	local entry = refusalEntry(spellID)
	if entry then entry.passedAt = br._G.GetTime() end
end

-- Last refusal/pass record for a spell name (any case/spacing), or nil.
function cast:getRefusal(spellName)
	local key = refusalKey(spellName)
	return key and refusals[key]
end

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
	-- IsSpellUsable returns (isUsable, insufficientPower); capture both so gateUsable can
	-- tell a pure power shortfall apart from a wrong-form/other failure (clearcasting fix).
	local isUsable, insufficientPower = br._G.C_Spell.IsSpellUsable(spellID)
	local updateRate = br.engines:getUpdateRate()
	local latency    = select(3, br._G.GetNetStats()) / 1000 -- ms -> seconds

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
		insufficientPower = insufficientPower,
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
	-- Guards instants against a lagged second press. Spells with a cast time are
	-- covered by the casting checks instead; measuring from when the last one landed
	-- would block pre-casting the same spell behind itself.
	if ctx.rawCastTime > 0 then return true end
	local elapsed = br._G.GetTime() - ctx.lastCastTime
	local window  = br.functions.spell:getGlobalCD(true) + ctx.latency
	if elapsed > window then return true end
	return false, "DOUBLE_CAST",
		string.format("cast %.2fs ago, window=%.2fs (GCD %.2fs + lat %.0fms)",
			elapsed, window, br.functions.spell:getGlobalCD(true), ctx.latency * 1000)
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
	-- Clearcasting / free-next-cast fix: IsSpellUsable reports a spell as unusable when we
	-- can't afford its BASE cost, even though an Omen-of-Clarity-style proc makes the next
	-- cast free (TBC's IsSpellUsable does not pre-account for the proc, so a low-energy Shred
	-- during Clearcasting would otherwise be skipped). Bypass ONLY when the sole failure is
	-- insufficient power (not a wrong-form/other failure) AND the active spec has a live
	-- clearcasting buff. Nil-guarded so specs without a "clearcasting" buff are unaffected.
	if ctx.insufficientPower and br.player and br.player.buff and br.player.buff.clearcasting
		and br.player.buff.clearcasting.exists()
	then
		return true
	end
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
	-- Also not blocked: the spell we're casting right now, once it's inside the
	-- queue window (pre-casting the next Wrath behind the current one).
	if castType ~= "pet" and br._G.IsCurrentSpell and br._G.IsCurrentSpell(ctx.spellID) then
		local castingInWindow = getSameSpellCastRemain(ctx.spellID) > 0
			and not isCastingOutsideQueueWindow(ctx.spellID)
		if not isShapeshiftFormSpell(ctx.spellID) and not castingInWindow then
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
			recordRefusal(ctx.spellID, reason, detail)
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
	if br._G.UnitHealth(thisUnit) <= 0 and castType ~= "dead" then
		recordRefusal(ctx.spellID, "UNIT_DEAD", "unit " .. tostring(thisUnit))
		return false
	end

	if cast:isAuraBounced(ctx.spellID, thisUnit) then
		recordRefusal(ctx.spellID, "AURA_BOUNCED", "stronger aura already on unit")
		return false
	end

	recordPass(ctx.spellID)

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

	recordBotCast(ctx.spellID, thisUnit)

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

	-- Sending a spell while another cast is running pre-casts it into the queue window.
	local castBeforeKey = currentCastKey()

	br._G.CastSpellByName(castName, thisUnit)
	if br._G.IsAoEPending() then
		local X, Y, Z = br._G.ObjectPosition(thisUnit)
		br._G.ClickPosition(X, Y, Z)
	end

	local castSucceeded, details = verifyCastStarted(ctx.spellID, snapshot, castName)

	-- A pre-cast shows no new cast or GCD until the current cast ends, so it usually
	-- reads as inconclusive. Either way, the decision for this cast is made: the
	-- rotation now waits for the current cast to end (see misc:pause).
	if castBeforeKey ~= nil and (castSucceeded or (details and details.inconclusive)) then
		queuedBehindCast = castBeforeKey
	end

	if castSucceeded then
		local sameSpellCastRemain = getSameSpellCastRemain(ctx.spellID)
		if sameSpellCastRemain > 0 then
			-- Just started casting this spell: hold it until the cast reaches its own
			-- queue window, where the profile may choose to pre-cast it again.
			local hold = math.max(0.12, sameSpellCastRemain - cast:getQueueWindow())
			castTimers[ctx.spellID] = br._G.GetTime() + hold
			setCastIntentLock(ctx.spellID, hold)
		else
			castTimers[ctx.spellID] = br._G.GetTime() + 1
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
-- Friends and known enemies used to pass before the LoS check ran; every unit
-- other than the player now has to be visible.
local function checkUnitValidity(thisUnit, castType)
	if br.functions.unit:GetUnitIsUnit(thisUnit, "player") then return true end
	if castType == "pet" then
		-- Pet abilities are cast by the pet, so the player's LoS doesn't apply.
		return br._G.UnitExists(thisUnit) == true
	end
	return isUnitVisible(thisUnit)
end

-- checkRange: range check with API + moving-hysteresis guard + distance fallback.
-- Returns true when in range, or false plus a short reason naming which check failed
-- (shown by "/br why <spell>").
local function checkRange(ctx, thisUnit, castType)
	if thisUnit == "player" then return true end
	-- The game just said this spell can't reach this unit; trust it over our math.
	if castType ~= "pet" and cast:isRejected("range", ctx.spellID, thisUnit) then
		return false, "game said out of range moments ago"
	end
	-- For pet castType, IsSpellInRange evaluates from the PLAYER's position — not the
	-- pet's — so it cannot reliably gate melee or short-range pet abilities.  Skip the
	-- API check entirely for pet spells and always measure pet-to-target distance directly.
	if castType ~= "pet" then
		local spellInRange = br._G.C_Spell.IsSpellInRange(ctx.spellName, thisUnit)
		if spellInRange == false then
			local timerKey = ctx.spellID .. "_" .. (br._G.UnitGUID(thisUnit) or thisUnit)
			rangeDelayTimers[timerKey] = nil
			return false, string.format("IsSpellInRange=false (distance %.1f)",
				br.functions.range:getDistance(thisUnit) or -1)
		end
		if spellInRange == true then
			if br.functions.misc:isMoving("player") and ctx.maxRange > 0 then
				local now      = br._G.GetTime()
				-- Entries are keyed per spell + unit GUID and were only ever cleared on
				-- leaving range, so dead/despawned units piled up. Sweep ones not checked lately.
				if now >= rangeDelayNextPrune then
					rangeDelayNextPrune = now + RANGE_DELAY_PRUNE_INTERVAL
					for k, entry in pairs(rangeDelayTimers) do
						if now - entry.seen > RANGE_DELAY_PRUNE_INTERVAL then rangeDelayTimers[k] = nil end
					end
				end
				local timerKey = ctx.spellID .. "_" .. (br._G.UnitGUID(thisUnit) or thisUnit)
				local entry = rangeDelayTimers[timerKey]
				if entry == nil then
					rangeDelayTimers[timerKey] = { started = now, seen = now }
					return false, "moving: just came into range, waiting 0.5s"
				end
				entry.seen = now
				if (now - entry.started) < 0.5 then
					return false, "moving: just came into range, waiting 0.5s"
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
	if ctx.maxRange == 0 then
		if distance <= 5 then return true end
		return false, string.format("IsSpellInRange=nil, distance %.1f > melee 5", distance or -1)
	end
	if distance >= ctx.minRange and distance < ctx.maxRange - 1.5 then return true end
	return false, string.format("IsSpellInRange=nil, distance %.1f, needs %.1f to under %.1f",
		distance or -1, ctx.minRange, ctx.maxRange - 1.5)
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
	local facingOk = (castType == "norm" and br.functions.unit:getFacing("player", thisUnit) ~= false
			and not cast:isRejected("facing", ctx.spellID, thisUnit))
		or (castType == "pet" and br.functions.unit:getFacing("pet", thisUnit) ~= false)
		or ctx.spellType == "Helpful"
		or ctx.spellType == "Unknown"
	if not facingOk then
		recordRefusal(ctx.spellID, "NOT_FACING", "unit " .. tostring(thisUnit))
		return false
	end
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
	-- 0 is a deliberate "no such spell for this character" (e.g. cast.racial() for a race
	-- without a damage racial): not castable, and not an error worth printing.
	if spellID == 0 then return false end
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
	-- Never recast a spell that is already being cast/channelled, until it's inside
	-- the queue window where it may be pre-cast behind itself.
	if isCastingOutsideQueueWindow(spellID) then
		recordRefusal(spellID, "ALREADY_CASTING", "casting it, outside the queue window")
		return false
	end
	-- Intent lock prevents rapid recasting (skipped for cast.able checks).
	if not debug and isCastIntentLocked(spellID) then
		recordRefusal(spellID, "INTENT_LOCK", "just cast; settling")
		return false
	end

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
		-- thisCount is a unit count for the min-units reasons, or a ready-made detail string.
		local refusalDetail
		if type(thisCount) == "string" then
			refusalDetail = "unit " .. tostring(thisUnit) .. ", " .. thisCount
		elseif thisCount ~= nil then
			refusalDetail = "count " .. tostring(thisCount)
		elseif thisUnit ~= nil then
			refusalDetail = "unit " .. tostring(thisUnit)
		end
		recordRefusal(spellID, reasonCode, refusalDetail)
		if debug then return false end -- never print for cast.able checks
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
				br.player.ui.debug(prefix .. ctx.spellName .. " — unit not in range"
					.. (type(thisCount) == "string" and (" (" .. thisCount .. ")") or "") .. ".")
			elseif debugReason == "Not Safe" then
				br.player.ui.debug(prefix .. ctx.spellName .. " — not safe to AoE.")
			elseif debugReason == "Invalid Unit" then
				if cast:isRejected("los", nil, thisUnit) then
					br.player.ui.debug(prefix .. ctx.spellName .. " — game reported unit out of line of sight.")
				elseif not br.functions.misc:canSee(thisUnit) then
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
	local inRange, rangeDetail = checkRange(ctx, thisUnit, castType)
	if not inRange then
		return printReport(false, "No Range", rangeDetail)
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
			local ttl = (br.player.state.gcdMax or 1.5) * 3
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
