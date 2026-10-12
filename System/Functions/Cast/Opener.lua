local _, br = ...
local cast = br.functions.cast
local E = cast.internal

-- Opener: cast.opener.<spell>(...) casts like cast.<spell>(...), and returns true when the cast is
-- sent, but as one step of a sequence. The profile writes its opener as ordinary priority lines;
-- the steps go in the order they're called in, and a finished step drops out:
--   * a step that's done (or skipped) lets the next line run;
--   * the first step not done is the current one: it casts when it can. While it waits (GCD, power,
--     the cast on its way) every cast after it in this pass is refused ("OPENER" in /br why), so
--     nothing further down the rotation jumps in. Lines above the opener still run. A next-swing
--     spell (Maul) stops holding once the game shows it queued.
--   * later steps wait their turn.
-- A step is done when the game confirms the cast (UNIT_SPELLCAST_SUCCEEDED), not when it's sent,
-- so a refused cast is tried again. It's skipped when the spell isn't known, its cooldown won't
-- be up in time, or it can't be cast for a while. A step whose line isn't called (its condition is
-- false) is passed over, and once a later step has gone it's skipped: the order of the lines is
-- learned from the order they're called in. The opener resets out of combat without a target, and
-- when the target it started on changes.

local opener = {
	steps = {},       -- [step key] = "done" | "skipped"
	pending = {},     -- [step key] = { ids, sentAt, name }: sent, not confirmed yet
	started = false,
	complete = false,
	startGUID = nil,  -- the target the opener started on
	current = nil,    -- the step being worked on, and since when
	currentSince = 0,
	order = {},       -- step keys in the profile's line order, as learned from the calls
	occurrences = {}, -- per pass: how often each spell was called (one spell can be two steps)
	lastCalled = nil, -- per pass: the step called before this one
	held = false,     -- per pass: the current step is waiting, so later casts this pass are refused
	inStep = false,   -- the current step's own cast is under way
}

-- True when a cast now would jump ahead of an opener step that's waiting (createCastFunction).
function E.openerHolds()
	return opener.held and not opener.inStep
end

-- How long a step may wait for its spell before it's skipped: about two GCDs.
local function stepTimeout()
	return 2 * (E.getFrameValues().gcdMax or 1.5)
end

local function debug(message)
	if br.player and br.player.ui and br.player.ui.debug then br.player.ui.debug(message) end
end

local function targetGUID()
	local guid = br._G.UnitGUID("target")
	if guid ~= nil and br.functions.misc:canUseValue(guid) then return guid end
	return nil
end

-- The spell IDs a step can show up as (every rank of a rank list).
local function stepIDs(id)
	if type(id) == "table" then return id end
	return { id }
end

local function castSince(ids, since)
	local castTime = br.functions.lastCast.lastCastTable.castTime
	for i = 1, #ids do
		local at = castTime[ids[i]]
		if at ~= nil and at > since then return true end
	end
	return false
end

-- Still on its way: being cast or channelled, queued on the next swing, or sent within a round trip.
-- The second result is true when it's queued on the next swing (Maul): it's committed, and its cost
-- is already promised (E.promiseCosts), but it lands only when a swing does, which can take seconds
-- (target behind the player or out of reach), so later casts don't wait for it.
local function stillPending(entry)
	local now = br._G.GetTime()
	if now - entry.sentAt < br.functions.misc:getRoundTripHold() then return true, false end
	local _, _, _, _, _, _, _, _, castingID = br._G.UnitCastingInfo("player")
	local _, _, _, _, _, _, _, channelID = br._G.UnitChannelInfo("player")
	for i = 1, #entry.ids do
		local id = entry.ids[i]
		if id == castingID or id == channelID then return true, false end
		if br._G.IsCurrentSpell and br._G.IsCurrentSpell(id) and now - entry.sentAt < 6 then return true, true end
	end
	return false, false
end

-- Settles sent steps: done once confirmed, back to not done once they're no longer on their way.
local function settlePending()
	for key, entry in pairs(opener.pending) do
		if castSince(entry.ids, entry.sentAt - 0.001) then
			opener.steps[key] = "done"
			opener.pending[key] = nil
		elseif not stillPending(entry) then
			opener.pending[key] = nil
		end
	end
end

function cast:resetOpener()
	br._G.wipe(opener.steps)
	br._G.wipe(opener.pending)
	br._G.wipe(opener.order)
	opener.started, opener.complete = false, false
	opener.startGUID, opener.current = nil, nil
end

-- Called by the rotation pulse (Player:startRotation) before and after the profile runs.
function cast:openerBeginPass()
	br._G.wipe(opener.occurrences)
	opener.held, opener.lastCalled = false, nil
	if opener.started and not br._G.UnitAffectingCombat("player")
		and (not br._G.UnitExists("target") or br._G.UnitIsDeadOrGhost("target"))
	then
		cast:resetOpener()
		return
	end
	settlePending()
end

function cast:openerEndPass()
	if opener.started and not opener.complete and not opener.held and next(opener.pending) == nil then
		opener.complete = true
		opener.current = nil
		debug("Opener complete")
	end
	opener.held = false -- casts outside the rotation pass are never held
end

-- Learns where a step's line sits: a step seen for the first time goes right after the step
-- called before it this pass (first, when none was). Returns its place in the order.
local function placeStep(key)
	local order = opener.order
	local at
	for i = 1, #order do if order[i] == key then at = i break end end
	if at == nil then
		at = 1
		if opener.lastCalled ~= nil then
			for i = 1, #order do if order[i] == opener.lastCalled then at = i + 1 break end end
		end
		table.insert(order, at, key)
	end
	opener.lastCalled = key
	return at
end

-- True when a step after this place has already gone (done or on its way): this step's turn passed.
local function turnPassed(at)
	local order = opener.order
	for i = at + 1, #order do
		local key = order[i]
		if opener.steps[key] == "done" or opener.pending[key] ~= nil then return true end
	end
	return false
end

local function skipStep(key, name, why)
	opener.steps[key] = "skipped"
	opener.current = nil
	debug("Opener: " .. tostring(name) .. " skipped (" .. why .. ")")
	return false
end

-- Why the cast was just refused, from the cast engine's refusal record ("/br why").
local function lastRefusal(name)
	local entry = cast:getRefusal(name)
	if entry and entry.refusedAt == br._G.GetTime() then return entry.reason end
	return nil
end

-- Refusals that won't change during the opener: skip the step straight away
local SKIP_AT_ONCE = { NOT_KNOWN = "not known", NO_TALENT = "talent not taken" }

-- One opener step: spellKey/id from the spell list, castFn the spell's cast.<spell>, then the
-- cast.<spell> arguments.
function cast:openerStep(spellKey, id, castFn, ...)
	local guid = targetGUID()
	if opener.started and guid ~= nil and opener.startGUID ~= nil and guid ~= opener.startGUID then
		cast:resetOpener() -- a new target gets a new opener
	end
	if opener.complete then return false end

	local count = (opener.occurrences[spellKey] or 0) + 1
	opener.occurrences[spellKey] = count
	local key = spellKey .. "#" .. count
	local at = placeStep(key)
	if opener.steps[key] ~= nil then return false end -- done or skipped
	if opener.held then return false end               -- an earlier step is still current

	local ids = stepIDs(id)
	local name = br.functions.spell:getName(br.functions.spell:currentRank(id)) or spellKey
	if opener.pending[key] == nil and turnPassed(at) then
		return skipStep(key, name, "its turn passed")
	end
	local now = br._G.GetTime()
	opener.held = true
	if not opener.started then
		opener.started = true
		opener.startGUID = guid
		debug("Opener started")
	end
	if opener.current ~= key then
		opener.current, opener.currentSince = key, now
	end

	-- Sent and still on its way: wait for it
	local entry = opener.pending[key]
	if entry ~= nil then
		if castSince(ids, entry.sentAt - 0.001) then
			opener.steps[key] = "done"
			opener.pending[key] = nil
			opener.current, opener.held = nil, false
			return false -- the next line is the next step, this pass
		end
		local pending, onNextSwing = stillPending(entry)
		if pending then
			if onNextSwing then opener.held = false end -- queued: the next lines may go
			return false
		end
		opener.pending[key] = nil -- never landed: try again
	end

	opener.inStep = true
	local sent = castFn(...)
	opener.inStep = false
	if sent then
		opener.pending[key] = { ids = ids, sentAt = now, name = name }
		return true
	end

	-- Refused: wait for it, or skip it
	local reason = lastRefusal(name)
	if reason ~= nil and SKIP_AT_ONCE[reason] then
		opener.held = false
		return skipStep(key, name, SKIP_AT_ONCE[reason])
	end
	local timeout = stepTimeout()
	if reason == "ON_COOLDOWN" and (br.functions.spell:getSpellCD(br.functions.spell:currentRank(id)) or 0) > timeout then
		opener.held = false
		return skipStep(key, name, "on cooldown")
	end
	if now - opener.currentSince > timeout then
		opener.held = false
		return skipStep(key, name, "couldn't cast it: " .. (reason and reason:lower():gsub("_", " ") or "no reason given"))
	end
	return false -- held: waiting for it
end

-- True once the opener has run all its steps (until it resets).
function cast:isOpenerDone() return opener.complete end

-- True while an opener is under way: started and not finished.
function cast:isOpenerActive() return opener.started and not opener.complete end
