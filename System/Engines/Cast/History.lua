local _, br = ...
br.engines.cast = br.engines.cast or {}
local cast = br.engines.cast
-- The player's cast history, from the cast engine's events (Events.lua): the rotation's abilities as they went
-- out (cast.last.<spell>), when each last went off (cast.last.time, cast.timeSinceLast, the opener's steps, the
-- send check's late confirmation) and when each last failed, with the reason the combat log gave.

local RECENT = 9 -- casts kept (cast.last.<spell>(index) looks up to 9 back)
local recent = {} -- spell IDs, the latest first
local castAt = {} -- spell ID -> when it last went off (UNIT_SPELLCAST_SUCCEEDED)
local failedAt = {} -- spell ID -> when it last failed or was interrupted
local failedReason = {} -- spell ID -> the combat log's reason for its last failure
local lastFailure = { spellID = nil, at = nil, event = nil }
local sentAt = {} -- spell ID -> when the game last fired UNIT_SPELLCAST_SENT for it (BR's send or a key press)
local waitForSuccess -- the spell sent or started, until it goes off or stops

-- Spells the history leaves out (procs and reactions that aren't rotation choices)
local IGNORED = { "counterspell", "iceBarrier", "shimmer" }
local abilityIDs, ignoredIDs

local function buildAbilityIDs()
	local abilities = br.runner and br.runner.spells and br.runner.spells.abilities
	if abilities == nil then return false end
	abilityIDs, ignoredIDs = {}, {}
	for _, v in pairs(abilities) do
		if type(v) == "table" then
			for _, rankID in ipairs(v) do abilityIDs[rankID] = true end
		elseif v then
			abilityIDs[v] = true
		end
	end
	for _, key in ipairs(IGNORED) do
		local v = abilities[key]
		if type(v) == "table" then
			for _, rankID in ipairs(v) do ignoredIDs[rankID] = true end
		elseif v then
			ignoredIDs[v] = true
		end
	end
	return true
end

local function isAbility(spellID)
	if abilityIDs == nil and not buildAbilityIDs() then return false end
	return abilityIDs[spellID] == true
end

local function isIgnored(spellID)
	if ignoredIDs == nil and not buildAbilityIDs() then return false end
	return ignoredIDs[spellID] == true
end

local function addRecent(spellID)
	if not isAbility(spellID) then return end
	table.insert(recent, 1, spellID)
	recent[RECENT + 1] = nil
end

local function noteCastAt(spellID)
	if isAbility(spellID) then castAt[spellID] = br.game.GetTime() end
end

-- SENT is (unit, target, castGUID, spellID), the others (unit, castGUID, spellID)
local function onCastEvent(event, _, a, b, c)
	local spellID = event == "UNIT_SPELLCAST_SENT" and c or b
	if spellID == nil or br.runner == nil or isIgnored(spellID) then return end
	if event == "UNIT_SPELLCAST_SENT" or event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
		waitForSuccess = spellID
		-- into the history once, at the send (a cast-time spell also starts)
		if event == "UNIT_SPELLCAST_SENT" then
			sentAt[spellID] = br.game.GetTime()
			addRecent(spellID)
		end
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		noteCastAt(spellID)
		if waitForSuccess == spellID then
			waitForSuccess = nil
		else
			-- no SENT for it (an instant the game cast without one, or one that went off after a failure)
			addRecent(spellID)
		end
	else -- STOP, CHANNEL_STOP, FAILED, FAILED_QUIET, INTERRUPTED: it ended without going off
		if waitForSuccess == spellID then
			table.remove(recent, 1)
			waitForSuccess = nil
		end
		if event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_FAILED_QUIET" or event == "UNIT_SPELLCAST_INTERRUPTED" then
			local now = br.game.GetTime()
			failedAt[spellID] = now
			lastFailure.spellID, lastFailure.at, lastFailure.event = spellID, now, event
		end
	end
end
cast:onPlayerCast({ "UNIT_SPELLCAST_SENT", "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_CHANNEL_START",
	"UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_CHANNEL_STOP", "UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_FAILED_QUIET",
	"UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_SUCCEEDED" }, onCastEvent)

--- The index-th latest of the rotation's abilities the player cast (1, the default, is the latest; up to 9), or nil.
-- if br.engines.cast:getRecentCast(1) == spellID then
function cast:getRecentCast(index) return recent[index or 1] end

--- When (GetTime) spellID last went off, 0 if it hasn't this session.
-- local since = br.functions.misc:getTime() - br.engines.cast:getLastCastTime(spellID)
function cast:getLastCastTime(spellID) return castAt[spellID] or 0 end

--- When (GetTime) spellID last failed or was interrupted, or nil.
function cast:getLastFailedTime(spellID) return failedAt[spellID] end

--- The player's latest failed or interrupted cast: spellID, when, and the event (UNIT_SPELLCAST_FAILED, ..._QUIET or
--- ..._INTERRUPTED); nil when none yet.
function cast:getLastFailure() return lastFailure.spellID, lastFailure.at, lastFailure.event end

--- When (GetTime) the game last fired UNIT_SPELLCAST_SENT for spellID (any spell, BR's or the player's), or nil.
-- A failure with no send before it may be one the game cast by itself (2026-11-14: Track Humanoids refused "not
-- ready" 0.2 s after each Cat Form, once the player had used it)
function cast:getLastSentTime(spellID) return sentAt[spellID] end

--- The combat log's reason for spellID's last failure ("Out of range", "Not enough mana"), or nil.
function cast:getFailedReason(spellID) return failedReason[spellID] end

--- The combat log's reason for a failure of the player's spellID (Readers/combatlog.lua).
function cast:noteFailedReason(spellID, reason)
	if spellID ~= nil then failedReason[spellID] = reason end
end

--- True when spellID is one of the rotation's abilities (any rank of a rank list).
-- if br.engines.cast:isAbility(spellID) then
function cast:isAbility(spellID) return isAbility(spellID) end

--- The spell lists changed (spells learned, talents, spec): the abilities are worked out again when next asked.
function cast:clearAbilityIDs() abilityIDs, ignoredIDs = nil, nil end
