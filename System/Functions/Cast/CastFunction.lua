local _, br = ...
local cast = br.functions.cast
local E = cast.internal

-- Entry point: createCastFunction (cast.<spell> and cast.able.<spell>) and the cast queue.

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
				if name and E.getPetBarSlot(name) then
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
	if E.isCastingOutsideQueueWindow(spellID) then
		E.recordRefusal(spellID, "ALREADY_CASTING", "casting it, outside the queue window")
		return false
	end
	-- Intent lock prevents rapid recasting (skipped for cast.able checks).
	if not debug and E.isCastIntentLocked(spellID) then
		E.recordRefusal(spellID, "INTENT_LOCK", "just cast; settling")
		return false
	end

	-- ── Step 4: Empowered-spell bypass (Evoker) ───────────────────────────────
	-- When an empowered cast is in progress, only that spell bypasses normal gates.
	local isEmpoweredBypass = br.empowerID ~= nil and br.empowerID ~= 0 and spellID == br.empowerID

	-- ── Step 5: Build spell context (or reuse per-tick cache) ─────────────────
	-- The cache key includes the raw thisUnit arg (before unit resolution) because
	-- the gate checks that involve thisUnit (dies-soon, dead-check) must see the
	-- same argument both times to be valid cache hits.
	local cacheKey = E.gateCacheKey(spellID, castType, thisUnit)
	local ctx = not isEmpoweredBypass and E.gateCacheGet(cacheKey) or nil
	local gatesPassed = (ctx ~= nil) -- cache hit → gates already passed this tick

	if ctx == nil then
		-- Initialise shared tables on first use.
		if E.castTimers == nil then
			E.castTimers = {}
			E.gateDebugSilentUntil = br._G.GetTime() + 5 -- suppress gate debug burst after reload
		end
		if E.castTimers[spellID] == nil then E.castTimers[spellID] = 0 end -- 0 so t < GetTime() is immediately true
		if E.rangeDelayTimers == nil then E.rangeDelayTimers = {} end

		-- Most spells asked about during the GCD are on cooldown: refuse those before the context
		if not isEmpoweredBypass and not E.cooldownPrecheck(spellID, castType, debug) then return false end

		ctx = E.buildSpellContext(spellID, predict, predictPad, castType, effectRng)
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
		local passed, _ = E.runGates(ctx, thisUnit, castType, debug)
		if not passed then return false end
		-- Cache the passing context so cast.X() in the same tick skips re-running.
		if debug then
			E.gateCacheStore(cacheKey, ctx)
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

	-- ── Step 10: What this call asked for, for printReport ─────────────────────
	ctx.debug, ctx.minUnits, ctx.effectRng = debug, minUnits, effectRng

	-- ── Step 11: Unit resolution ──────────────────────────────────────────────
	if thisUnit == nil then
		-- groundCC/groundLocation need a unit or location from the caller; resolveUnit has none for them
		thisUnit = E.resolveUnit(ctx, nil, castType)
	end
	ctx.unit = thisUnit

	if thisUnit == nil or thisUnit == "None" then
		E.printReport(ctx, true, "No Unit")
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
	if not E.checkUnitValidity(thisUnit, castType) then
		return E.printReport(ctx, false, "Invalid Unit")
	end

	-- ── Step 14: Range check ──────────────────────────────────────────────────
	local inRange, rangeDetail = E.checkRange(ctx, thisUnit, castType)
	if not inRange then
		return E.printReport(ctx, false, "No Range", rangeDetail)
	end

	-- ── Step 15: Dead-friend cast type ────────────────────────────────────────
	if castType == "dead" then
		if br._G.UnitIsPlayer(thisUnit)
			and br.functions.unit:GetUnitIsDeadOrGhost(thisUnit)
			and br.functions.unit:GetUnitIsFriend(thisUnit, "player")
		then
			return E.castingSpell(ctx, thisUnit, castType, debug)
		end
		return E.printReport(ctx, false, "Not Dead")
	end

	-- ── Step 16: AoE dispatch ─────────────────────────────────────────────────
	if castType == "ground" or castType == "aoe" or castType == "cone"
		or castType == "rect" or castType == "targetAOE"
	then
		return E.dispatchAoE(ctx, thisUnit, castType, minUnits, effectRng, enemies, debug)
	end

	-- ── Step 17: Single-target dispatch ──────────────────────────────────────
	if castType == "norm" or castType == "pet" then
		return E.dispatchST(ctx, thisUnit, castType, minUnits, enemies, debug)
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
				local entry = br.player.queue[j]
				-- Entries hold id, name, target and queuedAt (readers/combatlog.lua); castType and the
				-- AoE settings are optional and default like a plain cast.<spell>(target).
				if br.functions.cast:createCastFunction(entry.target, entry.castType, entry.minUnits, entry.effectRng,
					entry.id, entry.name) then return end
			end
		end
	end
	return
end
