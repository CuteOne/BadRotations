local _, br = ...
br.functions.cast = br.functions.cast or {}
local cast = br.functions.cast
-- State and helpers shared by the files in System/Functions/Cast (internal, not for profiles)
cast.internal = cast.internal or {}
local E = cast.internal

-- Shared state and tracking: cast rejection memory, unit visibility, the queue window,
-- intent locks and checking that a cast started.

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
	local name = spellID and br.functions.spell:getName(spellID)
	if not name then return nil end
	return kind .. ":" .. name .. ":" .. guid
end

-- Record that the game refused spellID on the unit with this GUID (for duration seconds, or the
-- usual time for this kind of refusal).
function cast:setRejected(kind, spellID, guid, duration)
	local key = rejectionKey(kind, spellID, guid)
	if key then rejections[key] = br._G.GetTime() + (duration or REJECT_DURATION[kind] or 0.5) end
end

-- "A more powerful spell is already active": how long that aura has left on the unit (found by the
-- spell's name, from any caster), so the spell is left alone until it ends rather than retried
-- every 30 s. nil when it can't be found or doesn't expire.
local function strongerAuraRemaining(spellID, guid)
	local unit = br._G.GetObjectWithGUID and br._G.GetObjectWithGUID(guid)
	local name = br.functions.spell:getName(spellID)
	if not unit or not name then return nil end
	local filter = br.functions.spell:getSpellType(name) == "Harmful" and "HARMFUL" or "HELPFUL"
	local aura = br.api.wow.FindAuraByName(name, unit, filter)
	local expires = aura and aura.expirationTime
	if not expires or expires == 0 then return nil end
	local remaining = expires - br._G.GetTime()
	return remaining > 0 and remaining or nil
end

-- True while a recent cast of spellID on thisUnit was refused for this reason.
function cast:isRejected(kind, spellID, thisUnit)
	if next(rejections) == nil then return false end -- the usual case: nothing refused lately
	local key = rejectionKey(kind, spellID, thisUnit and br._G.UnitGUID(thisUnit))
	if not key then return false end
	local expires = rejections[key]
	if expires and br._G.GetTime() < expires then return true end
	rejections[key] = nil
	return false
end

-- True while a stronger aura on the unit refused this spell (Buff.lua's refresh checks it).
function cast:isAuraBounced(spellID, thisUnit) return cast:isRejected("aura", spellID, thisUnit or "player") end

-- Remember which spell BR last sent and at whom, so UI errors can be pinned on it.
function E.recordBotCast(spellID, thisUnit)
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

-- Errors from the auto-attack swing, not from a spell: "You are facing the wrong way!" fires while
-- auto attack is on and the target is behind you, whatever BR last cast (Demoralizing Roar, a heal).
local function isSwingError(message)
	return message == errorText("ERR_BADATTACKFACING", "You are facing the wrong way!")
end

local function rejectionKindForError(message)
	if message == errorText("SPELL_FAILED_AURA_BOUNCED", "A more powerful spell is already active.") then return "aura" end
	if message == errorText("SPELL_FAILED_LINE_OF_SIGHT", "Target not in line of sight") then return "los" end
	if message == errorText("SPELL_FAILED_UNIT_NOT_INFRONT", "Target needs to be in front of you.")
		or message == errorText("SPELL_FAILED_NOT_INFRONT", "You must be in front of your target.")
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

E.castTimers = nil -- per-spell cast throttle; created on first createCastFunction call

-- Why a game refusal is expected (the fight caused it, or BR already handles it), or nil when it
-- points at a problem worth seeing. Unknown messages count as problems, so nothing new is hidden.
function E.expectedRefusal(message, castGUID)
	local kind = rejectionKindForError(message)
	if kind == "aura" then return "a stronger aura is active; BR leaves the spell until it ends" end
	if kind == "los" then return "out of sight; BR waits until the unit is back in view" end
	if kind == "facing" then return "not facing; BR turns to other units meanwhile" end
	if kind == "range" then return "out of range" end
	if message == errorText("SPELL_FAILED_INTERRUPTED", "Interrupted") then
		-- An on-next-swing attack is dropped when the target dies or changes, or auto attack stops
		local unit = castGUID and br._G.GetObjectWithGUID and br._G.GetObjectWithGUID(castGUID)
		if unit == nil or br.functions.unit:GetUnitIsDeadOrGhost(unit) then return "the target died" end
		if br._G.UnitGUID("target") ~= castGUID then return "the target changed" end
		return "interrupted by movement or the fight"
	end
	return nil
end

-- Called from the UI_ERROR_MESSAGE reader. Records the refusal against BR's most
-- recent cast and frees that spell's throttles so the rotation can use it on
-- another unit straight away.
function cast:handleCastError(message)
	if type(message) ~= "string" or isSwingError(message) then return end
	if not (br.botSpell and br.botGUID and br.botCastTime) then return end
	-- With Cast Debug on, show the game error behind a refused cast, so a cast that was sent but refused
	-- by the server (shapeshifted, no mana, ...) shows why instead of only "Casting". The error doesn't
	-- say which spell it's about; a spell-failed event naming one within a frame or two does (an
	-- on-next-swing Maul failing at the swing, after BR has cast something else), so the line waits a
	-- frame for it. Without one the error isn't about a cast at all (auto-loot's "There is no loot.",
	-- a profession, ...) and isn't reported.
	local errorAt = br._G.GetTime()
	if (errorAt - br.botCastTime) <= REJECT_ATTRIBUTION_WINDOW and (E.castDebugOn() or E.showRefusal(false)) then
		local lastCastGUID = br.botGUID
		br._G.C_Timer.After(0, function()
			local failed = br.functions.lastCast and br.functions.lastCast.lastCastTable
			if not (failed and failed.lastFailedSpellID and failed.lastFailedAt and math.abs(failed.lastFailedAt - errorAt) <= 0.1) then
				return
			end
			local spellID = failed.lastFailedSpellID
			local expected = E.expectedRefusal(message, lastCastGUID)
			if not E.showRefusal(expected ~= nil) then return end
			br.player.ui.debug("[CAST FAIL][SERVER] " .. tostring(br.functions.spell:getName(spellID)) .. " — game said: " .. message
				.. (expected and (" (expected: " .. expected .. ")") or ""))
		end)
	end
	local kind = rejectionKindForError(message)
	if not kind then return end
	-- A cast on yourself can't be out of sight or facing the wrong way: never mark the player
	if UNIT_WIDE_REJECT[kind] and br.botGUID == br._G.UnitGUID("player") then return end
	if kind ~= "aura" and (br._G.GetTime() - br.botCastTime) > REJECT_ATTRIBUTION_WINDOW then return end
	local duration
	if kind == "aura" then
		local remaining = strongerAuraRemaining(br.botSpell, br.botGUID)
		duration = remaining and math.max(REJECT_DURATION.aura, remaining) or nil
	end
	cast:setRejected(kind, br.botSpell, br.botGUID, duration)
	if E.castTimers then E.castTimers[br.botSpell] = nil end
	castIntentLocks[br.botSpell] = nil
end

-- One visibility rule for every cast path: the player always passes; any other
-- unit, friend or enemy, needs line of sight and must not have just been refused
-- by the game for being out of it.
function E.isUnitVisible(thisUnit)
	if thisUnit == nil then return false end
	if br.functions.unit:GetUnitIsUnit(thisUnit, "player") then return true end
	if cast:isRejected("los", nil, thisUnit) then return false end
	return br.functions.misc:canSee(thisUnit)
end

-- Same rule for callers outside this module (target selection), so a unit the cast
-- gate would refuse is never picked as the target in the first place.
function cast:isUnitVisible(thisUnit)
	return E.isUnitVisible(thisUnit)
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

-- Values that can't change within a frame (GetTime is fixed for the whole frame), read once per
-- frame instead of once per cast attempt. The live GCD isn't one: a cast earlier in the frame starts it.
local frameValues = {}
function E.getFrameValues()
	local now = br._G.GetTime()
	if frameValues.at ~= now then
		frameValues.at         = now
		frameValues.updateRate = br.engines:getUpdateRate()
		frameValues.latency    = br.functions.misc:getHomeLatency()
		frameValues.gcdMax     = br.functions.spell:getGlobalCD(true)
	end
	return frameValues
end

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
	local updateRate = E.getFrameValues().updateRate or 0.1
	return math.min(getSpellQueueWindow(), math.max(0.2, updateRate * 2))
end

E.queuedBehindCast = nil -- castID (or end time) of the cast we've pre-cast behind

function E.currentCastKey()
	local name, _, _, _, endTime, _, castID = br._G.UnitCastingInfo("player")
	if name == nil then return nil end
	return castID or endTime
end

-- True once the rotation has pre-cast its next spell behind this cast.
function cast:isQueuedBehind(castID, endTime)
	local key = castID or endTime
	return key ~= nil and key == E.queuedBehindCast
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: Power already promised to casts the client hasn't charged yet
--
-- A spell's cost leaves the player's power only when the server confirms it (an instant: a round
-- trip later), when its cast ends (cast-time spells, and spells pre-cast behind the current cast),
-- or when the swing lands (Maul, Heroic Strike and other on-next-swing attacks). Until then the
-- client still shows the power as available, so a second spell could be sent with power the first
-- one will take: Demoralizing Roar sent, then Maul queued on the same rage, then Maul failing at the
-- swing with "Not enough rage". Like a player keeping a tally, each send records its costs here
-- and the usability gate requires current power minus what's promised to cover the next spell.
-- ─────────────────────────────────────────────────────────────────────────────
E.promised = {} -- { spellID, type, amount, untilTime, swing }

-- Drop promises that have been charged (time passed, or the queued swing landed / dropped off)
local function prunePromised(now)
	local promised = E.promised
	for i = #promised, 1, -1 do
		local entry = promised[i]
		local done = now > entry.untilTime
			or (entry.swing and not (br._G.IsCurrentSpell and br._G.IsCurrentSpell(entry.spellID)))
		if done then table.remove(promised, i) end
	end
end

-- Record a sent spell's costs. kind: "swing" (on-next-swing attack, held until it lands), or a
-- time the cost will have been charged by.
function E.promiseCosts(spellID, untilTime, swing)
	local costs = br.functions.power:getSpellCosts(spellID)
	for i = 1, #costs do
		E.promised[#E.promised + 1] = { spellID = spellID, type = costs[i].type, amount = costs[i].amount,
			untilTime = untilTime, swing = swing }
	end
end

-- Can the player pay for spellID after what earlier casts have been promised? Returns true, or
-- false and a description. Free when nothing is promised (the usual case).
function E.affordableAfterPromised(spellID)
	if #E.promised == 0 then return true end
	prunePromised(br._G.GetTime())
	if #E.promised == 0 then return true end
	local costs = br.functions.power:getSpellCosts(spellID)
	for i = 1, #costs do
		local cost = costs[i]
		local promised = 0
		for _, entry in ipairs(E.promised) do
			if entry.type == cost.type and entry.spellID ~= spellID then promised = promised + entry.amount end
		end
		if promised > 0 then
			local current = br._G.UnitPower("player", cost.type)
			if type(current) == "number" and br.functions.misc:canUseValue(current) and current - promised < cost.amount then
				return false, string.format("power %d, %d promised to earlier casts, cost %d",
					br.functions.misc:plainNumber(current), br.functions.misc:plainNumber(promised),
					br.functions.misc:plainNumber(cost.amount))
			end
		end
	end
	return true
end

-- The two debug options:
--   Cast Debug         every refusal and check, routine ones tagged, for troubleshooting
--   Display Failcasts  only refusals that point at a problem (a profile, BR, or the setup)
function E.castDebugOn()
	return br.functions.misc ~= nil and br.functions.misc:isChecked("Cast Debug")
end
-- Whether to show a refusal: always with Cast Debug; with Display Failcasts unless it's expected
function E.showRefusal(expected)
	if E.castDebugOn() then return true end
	return not expected and br.functions.misc ~= nil and br.functions.misc:isChecked("Display Failcasts")
end

function E.setCastIntentLock(spellID, duration)
	if spellID == nil then return end
	if duration == nil then duration = 0.15 end
	castIntentLocks[spellID] = br._G.GetTime() + duration
end

function E.isCastIntentLocked(spellID)
	if spellID == nil then return false end
	return castIntentLocks[spellID] ~= nil and br._G.GetTime() < castIntentLocks[spellID]
end

-- Time left on the player's cast or channel of spellID (0 when it isn't being cast), and
-- whether that's a channel.
local function sameSpellCastRemain(spellID)
	local _, _, _, _, castEndTime, _, _, _, castingSpellID = br._G.UnitCastingInfo("player")
	if castingSpellID == spellID and castEndTime and castEndTime > 0 then
		return math.max(0, (castEndTime / 1000) - br._G.GetTime()), false
	end
	local _, _, _, _, channelEndTime, _, _, channelingSpellID = br._G.UnitChannelInfo("player")
	if channelingSpellID ~= nil and channelingSpellID == spellID then
		local remain = (channelEndTime and channelEndTime > 0) and math.max(0, (channelEndTime / 1000) - br._G.GetTime()) or 0
		return remain, true
	end
	return 0, false
end

function E.getSameSpellCastRemain(spellID)
	return (sameSpellCastRemain(spellID))
end

-- True while the player is casting spellID with more than the queue window left.
-- Inside the window the same spell may be pre-cast behind itself (Wrath -> Wrath).
-- Channels are excluded: they're never pre-cast behind themselves.
function E.isCastingOutsideQueueWindow(spellID)
	local remain, isChannel = sameSpellCastRemain(spellID)
	if isChannel then return true end
	return remain > cast:getQueueWindow()
end

function E.takeCastStartSnapshot(spellID)
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
function E.verifyCastStarted(spellID, snapshot, expectedSpellName)
	expectedSpellName = expectedSpellName or br.functions.spell:getName(spellID)
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
	local currentSpellAlreadyOn = (spellID == br.functions.spell:getHighestSpellID("autoAttack")) and currentSpellAfter
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

