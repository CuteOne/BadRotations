local _, br = ...
local cast = br.functions.cast
local E = cast.internal

-- Public cast helpers: ground casts, openers, cast-time and casting queries, the public
-- throttle setters and the pet action bar cache.

--cast spell on position x,y,z
function cast:castAtPosition(X, Y, Z, SpellID)
	local mouselookActive = false
	if br._G.IsMouselooking() then
		mouselookActive = true
		br._G.MouselookStop()
	end

	-- Ground-targeted spells should not be cast "on" a unit token; doing so can force a self-cast.
	-- We want the targeting cursor so we can click the provided world coordinates.
	br._G.CastSpellByName(br.functions.spell:getName(SpellID))

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
		br._G.CastSpellByName(br.functions.spell:getName(SpellID))
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

-- The spell's cast time in seconds, for what it currently is (spells that turn into another, like
-- New Moon's cycle, report the spell they've become); 0 for an instant or unknown spell.
-- if br.functions.cast:getCastTime(br.player.spells.healingTouch) < 3 then
function cast:getCastTime(spellID)
	if br._G.FindSpellOverrideByID then spellID = br._G.FindSpellOverrideByID(spellID) or spellID end
	return (select(4, br.api.wow.GetSpellInfo(spellID)) or 0) / 1000
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
    E.setCastIntentLock(spellID, duration)
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
    if E.castTimers == nil then E.castTimers = {} end
    E.castTimers[spellID] = br._G.GetTime() + duration
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

-- @param refresh true to re-read the bar now (before casting from a slot)
function E.getPetBarSlot(spellName, refresh)
	if not spellName then return nil end
	local now = br._G.GetTime()
	if refresh or not petBarCache or now - petBarCacheTime > 5 then
		petBarCache     = {}
		petBarCacheTime = now
		if br._G.NUM_PET_ACTION_SLOTS then
			for i = 1, br._G.NUM_PET_ACTION_SLOTS do
				local name = br._G.GetPetActionInfo(i)
				if name and not petBarCache[name] then petBarCache[name] = i end
			end
		end
	end
	return petBarCache[spellName]
end
