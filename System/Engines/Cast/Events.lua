local _, br = ...
br.engines.cast = br.engines.cast or {}
local cast = br.engines.cast
-- The player's cast events, read once: one frame for the game's UNIT_SPELLCAST_* on "player", handing each event to
-- the parts of BR that follow the player's casts. Loaded ahead of the files that subscribe (RotationLog, the
-- Readers, Debugging, the Functions), so it sits early in the toc; what it calls on an event exists by then.
--
-- Subscribers, in the order they're called (the order they subscribe, which is the toc's):
--   1. the cast engine itself (below): BR's send answered (cast:noteSucceeded), failed or interrupted, the Queue
--      Casting queue
--   2. RotationLog: the Rotation window's rows
--   3. Debugging recorders: Melee.log, the swing-around-a-cast probe, Idle.log, Cast.log, Aggro.log
--   4. Item: weapon imbues landing
--   5. LastCast: the cast history (cast.last, timeSinceLast)
--   6. Misc/Units: enemy players you engaged
--   7. Misc/Pause: your own key press holding BR's sends
--   8. Unit: the bleed-immune learning
--   9. SmartQueue: the queued spell went off
-- The engine's bookkeeping comes first so the rest see BR's send record as it now stands.
-- Other units' casts aren't here: the group healer watch (Misc/Units) keeps its own frame for those.

local EVENTS = {
	"UNIT_SPELLCAST_SENT", "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_DELAYED",
	"UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_CHANNEL_STOP", "UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_FAILED_QUIET", "UNIT_SPELLCAST_INTERRUPTED",
}
local known = {}
for _, event in ipairs(EVENTS) do known[event] = true end

local subscribers = {} -- event -> { handler, ... } in subscription order
local frame
local byUnit -- the frame takes events for one unit (RegisterUnitEvent), so the unit needn't be checked

-- An error in one subscriber goes to Errors.log and BugSack and the rest still run, as with a frame each
local function report(err)
	if br.log and br.log.reportError then return br.log:reportError(err, br.game.debugstack and br.game.debugstack(2)) end
	local handler = br.game.geterrorhandler and br.game.geterrorhandler()
	if handler then handler(err) end
end

local function readable(value)
	if value == nil then return nil end
	local misc = br.functions.misc
	if misc and misc.canUseValue and not misc:canUseValue(value) then return nil end
	return value
end

--- Hands one of the game's cast events to the subscribers (the frame below; the tests call it directly). The payload
--- is the game's: (unit, castGUID, spellID), and for SENT (unit, target, castGUID, spellID).
function cast.playerCastEvent(event, unit, a, b, c)
	local list = subscribers[event]
	if list == nil then return end
	if not byUnit and (readable(unit) == nil or unit ~= "player") then return end
	-- a value BR may not read reaches no one: each subscriber would have to check it
	if event == "UNIT_SPELLCAST_SENT" then
		a, b, c = readable(a), readable(b), readable(c)
	else
		a, b = readable(a), readable(b)
	end
	for i = 1, #list do
		---@diagnostic disable-next-line: redundant-parameter
		xpcall(list[i], report, event, "player", a, b, c)
	end
end

--- Calls handler(event, "player", ...) on each of the player's cast events named in events, with the game's payload
--- (see cast.playerCastEvent); a spell ID, cast GUID or target BR may not read comes as nil. Subscribers run in the
--- order they subscribed, after the cast engine's own.
-- br.engines.cast:onPlayerCast({ "UNIT_SPELLCAST_SUCCEEDED" }, function(event, unit, castGUID, spellID) ... end)
function cast:onPlayerCast(events, handler)
	if frame == nil and br.game.CreateFrame then
		frame = br.game.CreateFrame("Frame")
		byUnit = frame.RegisterUnitEvent ~= nil
		frame:SetScript("OnEvent", function(_, event, ...) cast.playerCastEvent(event, ...) end)
	end
	for _, event in ipairs(events) do
		assert(known[event], "not a player cast event: " .. tostring(event))
		local list = subscribers[event]
		if list == nil then
			list = {}
			subscribers[event] = list
			if frame then
				if byUnit then frame:RegisterUnitEvent(event, "player") else frame:RegisterEvent(event) end
			end
		end
		list[#list + 1] = handler
	end
end

-- 1. The engine's own: BR's send answered, failed or interrupted, and the Queue Casting queue
cast:onPlayerCast({ "UNIT_SPELLCAST_SUCCEEDED", "UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_FAILED_QUIET",
	"UNIT_SPELLCAST_INTERRUPTED" }, function(event, _, _, spellID)
	if event ~= "UNIT_SPELLCAST_SUCCEEDED" then
		-- out of combat an interrupted cast of BR's is the player cancelling it
		if event == "UNIT_SPELLCAST_INTERRUPTED" then cast:noteInterrupted(spellID) end
		-- its heal isn't on its way and its cost won't be charged
		cast:noteCastFailed(spellID, event == "UNIT_SPELLCAST_FAILED_QUIET")
		-- BR's send got its answer
		if spellID ~= nil and spellID == (cast:getLastSend()) then cast:noteSucceeded() end
		return
	end
	cast:noteSucceeded()
	-- Queue Casting: the queued spell went off, drop it from the queue
	local queue = cast.queue
	if spellID == nil or queue == nil or #queue == 0 then return end
	local spellFns = br.functions.spell
	for i = 1, #queue do
		local queuedID = queue[i].id
		if type(queuedID) == "table" then
			queuedID = spellFns.getHighestKnownRank and spellFns:getHighestKnownRank(queuedID) or queuedID[1]
		end
		if spellFns:getName(spellID) == spellFns:getName(queuedID) then
			br.game.tremove(queue, i)
			if br.game.IsAoEPending() then br.game.SpellStopTargeting() end
			if not br.functions.misc:isChecked("Mute Queue") then
				br.log:say("Queue", "Cast " .. br.log.highlight(spellFns:getName(queuedID)) .. ", removed from the queue")
			end
			break
		end
	end
end)
