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
--   behind - "You must be behind your target": unit.isBehind says no for this unit, only while
--            nothing that decides it has changed (see behindChanged), at most 3 sec.
--   range  - "Out of range": this spell, this unit.
--   cancelled - the player cancelled BR's cast (cast:noteInterrupted): this spell, this unit, until the
--            player changes target, combat starts, or 3 sec.
-- ─────────────────────────────────────────────────────────────────────────────
local REJECT_DURATION = { aura = 30, los = 1.0, facing = 0.5, behind = 3.0, range = 0.5, cancelled = 3.0 }
local UNIT_WIDE_REJECT = { los = true, facing = true, behind = true }
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
	if key then rejections[key] = br.game.GetTime() + (duration or REJECT_DURATION[kind] or 0.5) end
end

-- "A more powerful spell is already active": how long that aura has left on the unit (found by the
-- spell's name, from any caster), so the spell is left alone until it ends rather than retried
-- every 30 s. nil when it can't be found or doesn't expire.
local function strongerAuraRemaining(spellID, guid)
	local unit = br.game.GetObjectWithGUID and br.game.GetObjectWithGUID(guid)
	local name = br.functions.spell:getName(spellID)
	if not unit or not name then return nil end
	local filter = br.functions.spell:getSpellType(name) == "Harmful" and "HARMFUL" or "HELPFUL"
	local aura = br.functions.aura:findByName(name, unit, filter)
	local expires = aura and aura.expirationTime
	if not expires or expires == 0 then return nil end
	local remaining = expires - br.game.GetTime()
	return remaining > 0 and remaining or nil
end

-- "Not behind" holds only while the things that decide it stay as they were at the refusal: where
-- you and the unit stand and face, who it targets, and its unit flags (a stun or a fear). Moving
-- half a yard or turning 10 degrees, on either side, asks the behind check again, so stepping
-- behind the unit right after a refusal doesn't wait out the block.
local BEHIND_MOVE, BEHIND_TURN = 0.5, math.rad(10)
local behindAtRefusal = {} -- unit GUID -> what decided the refusal

local function behindState(thisUnit)
	local unitFns = br.functions.unit
	local px, py = unitFns:GetObjectPosition("player")
	local ux, uy = unitFns:GetObjectPosition(thisUnit)
	local victim = br.game.UnitTarget and br.game.UnitTarget(thisUnit)
	return {
		px = px or 0, py = py or 0, pf = unitFns:GetObjectFacing("player") or 0,
		ux = ux or 0, uy = uy or 0, uf = unitFns:GetObjectFacing(thisUnit) or 0,
		victim = victim and br.game.UnitGUID(victim),
		flags = br.game.UnitFlags and br.game.UnitFlags(thisUnit),
	}
end

local function turned(a, b)
	local d = math.abs(a - b) % (2 * math.pi)
	return math.min(d, 2 * math.pi - d) >= BEHIND_TURN
end

local function behindChanged(guid, thisUnit)
	local was = behindAtRefusal[guid]
	if was == nil then return false end
	local now = behindState(thisUnit)
	return (now.px - was.px) ^ 2 + (now.py - was.py) ^ 2 >= BEHIND_MOVE ^ 2
		or (now.ux - was.ux) ^ 2 + (now.uy - was.uy) ^ 2 >= BEHIND_MOVE ^ 2
		or turned(now.pf, was.pf) or turned(now.uf, was.uf)
		or now.victim ~= was.victim or now.flags ~= was.flags
end

-- A cancel holds only while the player stays out of combat on the target they had when they cancelled
local targetAtCancel = {} -- rejection key -> the player's target GUID then
local function cancelReleased(key)
	return br.game.UnitAffectingCombat("player") or br.game.UnitGUID("target") ~= targetAtCancel[key]
end

-- True while a recent cast of spellID on thisUnit was refused for this reason.
function cast:isRejected(kind, spellID, thisUnit)
	if next(rejections) == nil then return false end -- the usual case: nothing refused lately
	local guid = thisUnit and br.game.UnitGUID(thisUnit)
	local key = rejectionKey(kind, spellID, guid)
	if not key then return false end
	local expires = rejections[key]
	if expires and br.game.GetTime() < expires and not (kind == "behind" and behindChanged(guid, thisUnit))
		and not (kind == "cancelled" and cancelReleased(key))
	then
		return true
	end
	rejections[key] = nil
	if kind == "behind" then behindAtRefusal[guid] = nil end
	if kind == "cancelled" then targetAtCancel[key] = nil end
	return false
end

-- The player's cast was interrupted (Readers/common.lua). Out of combat nothing in the world
-- interrupts a cast, so when it's the one BR just sent, the player stopped it (moving, jumping, Esc):
-- their "no". BR doesn't send it at that unit again until they change target, combat starts, or 3 s
-- pass (2026-10-26: a pull bolt cancelled twice in a row, BR re-sent it 0.7 s after the first).
function cast:noteInterrupted(spellID)
	if br.game.UnitAffectingCombat("player") then return end
	if not (br.botSpell and br.botGUID and br.botCastTime) or br.game.GetTime() - br.botCastTime > 10 then return end
	local name = br.functions.spell:getName(spellID)
	if name == nil or name ~= br.functions.spell:getName(br.botSpell) then return end
	cast:setRejected("cancelled", spellID, br.botGUID)
	local key = rejectionKey("cancelled", spellID, br.botGUID)
	if key then targetAtCancel[key] = br.game.UnitGUID("target") end
end

-- True while a stronger aura on the unit refused this spell (Buff.lua's refresh checks it).
function cast:isAuraBounced(spellID, thisUnit) return cast:isRejected("aura", spellID, thisUnit or "player") end

-- Remember which spell BR last sent and at whom, so UI errors can be pinned on it.
function E.recordBotCast(spellID, thisUnit)
	br.botCast     = true
	br.botSpell    = spellID
	br.botUnit     = thisUnit
	br.botGUID     = br.game.UnitGUID(thisUnit)
	br.botCastTime = br.game.GetTime()
	-- a weapon imbue: the hands' enchants now, to see where it lands (Functions/Item.lua)
	br.functions.item:noteImbueSent(spellID)
end

local function errorText(globalName, fallback)
	local text = br.game[globalName]
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
	if message == errorText("SPELL_FAILED_NOT_BEHIND", "You must be behind your target.") then return "behind" end
	if message == errorText("SPELL_FAILED_OUT_OF_RANGE", "Out of range.")
		or message == errorText("ERR_OUT_OF_RANGE", "Out of range.")
	then
		return "range"
	end
	return nil
end

E.castTimers = nil -- per-spell cast throttle; created on first createCastFunction call

-- Game refusals that contradict a check BR made before sending (range, sight, facing, behind): BR
-- said yes, the game said no. Expected and handled, but each one points at a gap in BR's own check,
-- so they stay in chat (a Vale Moth bolt at 29.9 yd found the moving-target range gap, 2026-10-26)
local MISMATCH_KINDS = { range = true, los = true, facing = true, behind = true }

-- Why a game refusal is expected (the fight caused it, or BR already handles it), or nil when it
-- points at a problem worth seeing. Unknown messages count as problems, so nothing new is hidden.
-- Second return: true when it contradicts BR's own pre-send check (MISMATCH_KINDS).
function E.expectedRefusal(message, castGUID)
	local kind = rejectionKindForError(message)
	local mismatch = MISMATCH_KINDS[kind] == true
	if kind == "aura" then return "a stronger aura is active; BR leaves the spell until it ends" end
	if kind == "los" then return "out of sight; BR waits until the unit is back in view", mismatch end
	if kind == "facing" then return "not facing; BR turns to other units meanwhile", mismatch end
	if kind == "behind" then return "not behind; BR uses attacks that work from the front meanwhile", mismatch end
	if kind == "range" then return "out of range", mismatch end
	if message == errorText("SPELL_FAILED_INTERRUPTED", "Interrupted") then
		-- An on-next-swing attack is dropped when the target dies or changes, or auto attack stops
		local unit = castGUID and br.game.GetObjectWithGUID and br.game.GetObjectWithGUID(castGUID)
		if unit == nil or br.functions.unit:GetUnitIsDeadOrGhost(unit) then return "the target died" end
		if br.game.UnitGUID("target") ~= castGUID then return "the target changed" end
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
	-- At Debug Level problems and up, show the game error behind a refused cast, so a cast that was sent but refused
	-- by the server (shapeshifted, no mana, ...) shows why instead of only "Casting". The error doesn't
	-- say which spell it's about; a spell-failed event naming one within a frame or two does (an
	-- on-next-swing Maul failing at the swing, after BR has cast something else), so the line waits a
	-- frame for it. Without one the error isn't about a cast at all (auto-loot's "There is no loot.",
	-- a profession, ...) and isn't reported.
	local errorAt = br.game.GetTime()
	if (errorAt - br.botCastTime) <= REJECT_ATTRIBUTION_WINDOW and E.showRefusal("problem") then
		local lastCastGUID = br.botGUID
		br.game.C_Timer.After(0, function()
			local failed = br.functions.lastCast and br.functions.lastCast.lastCastTable
			if not (failed and failed.lastFailedSpellID and failed.lastFailedAt and math.abs(failed.lastFailedAt - errorAt) <= 0.1) then
				return
			end
			local spellID = failed.lastFailedSpellID
			local expected, mismatch = E.expectedRefusal(message, lastCastGUID)
			local kind = expected == nil and "problem" or mismatch and "mismatch" or "expected"
			if not E.showRefusal(kind) then return end
			local spellName = tostring(br.functions.spell:getName(spellID))
			local text = "[CAST FAIL][SERVER] " .. spellName .. " — game said: " .. message
			-- Expected and nothing BR could have known (the target died, a stronger aura): Gate.log
			if kind == "expected" then
				return E.writeGateLine(spellID, "SERVER", br.functions.misc:plainText(text .. " (expected: " .. expected .. ")"))
			end
			-- BR's own check allowed it and the game didn't: a gap in BR's check (range and behind have
			-- what BR saw in Cast.log)
			if kind == "mismatch" then
				local kindName = rejectionKindForError(message)
				return br.log:systemDebug("[BR vs GAME] " .. spellName .. ": BR's check allowed it, the game said \"" .. message .. "\""
					.. ((kindName == "range" or kindName == "behind") and " (Logs\\Cast.log has what BR saw)" or ""))
			end
			br.log:systemDebug(text)
		end)
	end
	local kind = rejectionKindForError(message)
	if not kind then return end
	-- A cast on yourself can't be out of sight or facing the wrong way: never mark the player
	if UNIT_WIDE_REJECT[kind] and br.botGUID == br.game.UnitGUID("player") then return end
	if kind ~= "aura" and (br.game.GetTime() - br.botCastTime) > REJECT_ATTRIBUTION_WINDOW then return end
	local duration
	if kind == "aura" then
		local remaining = strongerAuraRemaining(br.botSpell, br.botGUID)
		duration = remaining and math.max(REJECT_DURATION.aura, remaining) or nil
	end
	if kind == "range" and br.debug.cast then br.debug.cast:noteOutOfRange(br.botSpell, br.botGUID) end
	if kind == "behind" then
		br.debug.cast:noteNotBehind(br.botSpell, br.botGUID)
		local refusedUnit = br.game.GetObjectWithGUID and br.game.GetObjectWithGUID(br.botGUID)
		behindAtRefusal[br.botGUID] = refusedUnit and behindState(refusedUnit) or nil
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
	local now = br.game.GetTime()
	if frameValues.at ~= now then
		frameValues.at         = now
		frameValues.updateRate = br.core:getUpdateRate()
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
	local now = br.game.GetTime()
	if spellQueueWindowReadAt == nil or now - spellQueueWindowReadAt > SPELL_QUEUE_WINDOW_REFRESH then
		spellQueueWindowReadAt = now
		local ms
		if br.game.C_Spell and br.game.C_Spell.GetSpellQueueWindow then
			ms = tonumber(br.game.C_Spell.GetSpellQueueWindow())
		elseif br.game.GetSpellQueueWindow then
			ms = tonumber(br.game.GetSpellQueueWindow())
		elseif br.game.C_CVar and br.game.C_CVar.GetCVar then
			ms = tonumber(br.game.C_CVar.GetCVar("SpellQueueWindow"))
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
	local name, _, _, _, endTime, _, castID = br.game.UnitCastingInfo("player")
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
			or (entry.swing and not (br.game.C_Spell.IsCurrentSpell(entry.spellID)))
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

-- Power of one type promised to casts other than spellID (all of them when spellID is nil; call after
-- prunePromised)
local function promisedPower(powerType, spellID)
	local promised = 0
	for _, entry in ipairs(E.promised) do
		if entry.type == powerType and entry.spellID ~= spellID then promised = promised + entry.amount end
	end
	return promised
end

-- Can the player pay for spellID after what earlier casts have been promised? Returns true, or
-- false and a description. Free when nothing is promised (the usual case).
function E.affordableAfterPromised(spellID)
	if #E.promised == 0 then return true end
	prunePromised(br.game.GetTime())
	if #E.promised == 0 then return true end
	local costs = br.functions.power:getSpellCosts(spellID)
	-- A spell's own promise is left out (it isn't another cast), except while the player is casting it:
	-- then the one asked for now is a second, pre-cast behind the first, and the first's cost is charged
	-- only when it ends (2026-10-26: a Lightning Bolt queued behind a Lightning Bolt on 21 mana came back
	-- "Not enough mana")
	local exclude = not br.functions.cast:isCastingSpell(spellID, "player") and spellID or nil
	for i = 1, #costs do
		local cost = costs[i]
		local promised = promisedPower(cost.type, exclude)
		if promised > 0 then
			local current = br.game.UnitPower("player", cost.type)
			if type(current) == "number" and br.functions.misc:canUseValue(current) and current - promised < cost.amount then
				return false, string.format("power %d, %d promised to earlier casts, cost %d",
					br.functions.misc:plainNumber(current), br.functions.misc:plainNumber(promised),
					br.functions.misc:plainNumber(cost.amount))
			end
		end
	end
	return true
end

--- Power of a type (Enum.PowerType) promised to casts BR has sent that the game hasn't charged yet: a
--- cast-time spell until it ends, an instant for a round trip, an on-next-swing attack until its swing.
-- local promisedMana = br.functions.cast:getPromisedPower(0)
function cast:getPromisedPower(powerType)
	if #E.promised == 0 then return 0 end
	prunePromised(br.game.GetTime())
	return promisedPower(powerType, nil)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: Mana kept to shift back into a form left in combat
--
-- Leaving a form to cast (unit.cancelFormFor) is only worth it with the mana to shift back. That is
-- checked when the form is left, but once out of form further casts (another heal) could spend that
-- mana and strand the player in Caster Form (2026-10-12, Druid-Forever). So while a shift back is
-- owed, every other mana cast leaves the form's cost: the spell the form was left for (already
-- budgeted, or an emergency) and the form spell itself may use it. Owed until a form is up again
-- or combat ends.
-- ─────────────────────────────────────────────────────────────────────────────
E.reshift = nil -- { formSpellID, formName, forName }: the form to shift back into, the spell it was left for

-- unit.cancelFormFor calls this when it leaves a form in combat to cast forSpellID
function cast:setReshiftOwed(formSpellID, forSpellID)
	if formSpellID == nil or not br.game.UnitAffectingCombat("player") then return end
	E.reshift = { formSpellID = formSpellID, formName = br.functions.spell:getName(formSpellID),
		forName = forSpellID and br.functions.spell:getName(forSpellID) }
end

-- The form a shift back is owed into (its spell ID), or nil; ends the debt once a form is up again
-- (not the one still on its way out) or combat is over.
function cast:getReshiftOwed()
	local owed = E.reshift
	if owed == nil then return nil end
	local backInForm = (br.game.GetShapeshiftForm() or 0) ~= 0 and not br.functions.unit:isFormCancelPending()
	if backInForm or not br.game.UnitAffectingCombat("player") then
		E.reshift = nil
		return nil
	end
	return owed.formSpellID
end

-- A sent spell: the one the form was left for has had its turn
function E.noteReshiftSpellSent(spellName)
	if E.reshift and E.reshift.forName ~= nil and spellName == E.reshift.forName then E.reshift.forName = nil end
end

-- Can the player pay for spellID's mana and still shift back into the form left? Returns true, or
-- false and a description. Free when no shift back is owed (the usual case).
function E.affordableWithReshift(spellID, spellName)
	if E.reshift == nil or cast:getReshiftOwed() == nil then return true end
	local owed = E.reshift
	if spellID == owed.formSpellID or spellName == owed.formName or spellName == owed.forName then return true end
	local power = br.functions.power
	local cost = power:getManaCostFromRef(spellID, false)
	local reserve = power:getManaCostFromRef(owed.formSpellID, false)
	if cost <= 0 or reserve <= 0 then return true end
	local current = br.game.UnitPower("player", 0)
	if type(current) ~= "number" or not br.functions.misc:canUseValue(current) then return true end
	prunePromised(br.game.GetTime())
	local promised = promisedPower(0, spellID)
	if current - promised - reserve >= cost then return true end
	local plain = function(v) return br.functions.misc:plainNumber(v) end
	return false, string.format("mana %d, %d kept to shift back into %s, cost %d", plain(current - promised),
		plain(reserve), br.functions.misc:plainText(tostring(owed.formName)), plain(cost))
end

-- What a refusal shows at which Debug Level (Bot Options > Debug Options, misc:debugAt) is below
-- (E.showRefusal). At trace, routine refusals are written to Gate.log.
function E.traceOn()
	return br.functions.misc ~= nil and br.functions.misc:debugAt("trace")
end
-- Whether to show a refusal of this kind at the Debug Level:
--   "problem"   worth fixing (no mana, wrong form, ...): problems and up, in chat
--   "mismatch"  BR's own check allowed what the game refused: developer and up, in chat
--   "expected"  the cast system or the fight handled it (out of range, the target died): trace, Gate.log
local SHOWN_FROM = { problem = "problems", mismatch = "developer", expected = "trace" }
function E.showRefusal(kind)
	return br.functions.misc ~= nil and br.functions.misc:debugAt(SHOWN_FROM[kind])
end

function E.setCastIntentLock(spellID, duration)
	if spellID == nil then return end
	if duration == nil then duration = 0.15 end
	castIntentLocks[spellID] = br.game.GetTime() + duration
end

function E.isCastIntentLocked(spellID)
	if spellID == nil then return false end
	return castIntentLocks[spellID] ~= nil and br.game.GetTime() < castIntentLocks[spellID]
end

-- Time left on the player's cast or channel of spellID (0 when it isn't being cast), and
-- whether that's a channel.
local function sameSpellCastRemain(spellID)
	local _, _, _, _, castEndTime, _, _, _, castingSpellID = br.game.UnitCastingInfo("player")
	if castingSpellID == spellID and castEndTime and castEndTime > 0 then
		return math.max(0, (castEndTime / 1000) - br.game.GetTime()), false
	end
	local _, _, _, _, channelEndTime, _, _, channelingSpellID = br.game.UnitChannelInfo("player")
	if channelingSpellID ~= nil and channelingSpellID == spellID then
		local remain = (channelEndTime and channelEndTime > 0) and math.max(0, (channelEndTime / 1000) - br.game.GetTime()) or 0
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
	local currentSpellBefore = br.game.C_Spell.IsCurrentSpell(spellID) == true
	local buffBefore = false
	if br.functions.aura and br.functions.aura.UnitBuffID then
		buffBefore = br.functions.aura:UnitBuffID("player", spellID) ~= nil
	end
	return {
		timeNow = br.game.GetTime(),
		gcdBefore = br.functions.spell:getGlobalCD(),
		castingBefore = br.game.UnitCastingInfo("player") ~= nil,
		channelingBefore = br.game.UnitChannelInfo("player") ~= nil,
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
	local castNameAfter, _, _, _, _, _, _, _, castSpellIdAfter = br.game.UnitCastingInfo("player")
	local channelNameAfter, _, _, _, _, _, _, _, channelSpellIdAfter = br.game.UnitChannelInfo("player")
	local castingAfter = castNameAfter ~= nil
	local channelingAfter = channelNameAfter ~= nil
	local spellCdAfter = (br.functions.spell and br.functions.spell.getSpellCD) and (br.functions.spell:getSpellCD(spellID) or 0) or 0
	local currentSpellAfter = br.game.C_Spell.IsCurrentSpell(spellID) == true
	local buffAfter = (br.functions.aura and br.functions.aura.UnitBuffID) and (br.functions.aura:UnitBuffID("player", spellID) ~= nil) or false
	local failedAt = (br.functions.lastCast and br.functions.lastCast.lastCastTable and br.functions.lastCast.lastCastTable.failedTime and br.functions.lastCast.lastCastTable.failedTime[spellID]) or 0
	local recentlyFailed = failedAt ~= 0 and (br.game.GetTime() - failedAt) < 0.20

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
	if not castSucceeded and newLastCastTime and newLastCastTime ~= 0 and newLastCastTime ~= snapshot.prevLastCastTime and (br.game.GetTime() - newLastCastTime) < 1 then
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

