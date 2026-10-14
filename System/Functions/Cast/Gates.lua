local _, br = ...
local cast = br.functions.cast
local E = cast.internal

-- Spell context and gates: refusal records ("/br why"), per-frame values and spell facts,
-- buildSpellContext, the gate checks and the per-tick gate cache.

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
E.gateDebugSilentUntil = 0 -- suppresses gate debug for N seconds after castTimers reset

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
	local name = br.functions.spell:getName(spellID)
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

function E.recordRefusal(spellID, reason, detail)
	local entry = refusalEntry(spellID)
	if not entry then return end
	entry.reason, entry.detail, entry.refusedAt = reason, detail, br._G.GetTime()
end

function E.recordPass(spellID)
	local entry = refusalEntry(spellID)
	if entry then entry.passedAt = br._G.GetTime() end
end

--- Calls fn(name, reason, detail) for every spell the engine refused since `since` (GetTime), and
--- fn(name, nil) for every one it passed (diagnostics, e.g. br.debug.melee).
function cast:eachDecisionSince(since, fn)
	for _, entry in pairs(refusals) do
		if entry.refusedAt and entry.refusedAt >= since then fn(entry.name, entry.reason, entry.detail) end
		if entry.passedAt and entry.passedAt >= since then fn(entry.name, nil) end
	end
end

-- Last refusal/pass record for a spell name (any case/spacing), or nil.
function cast:getRefusal(spellName)
	local key = refusalKey(spellName)
	return key and refusals[key]
end

-- A number for a debug detail: flagged values print as <SECRET> and hide the whole line
local function plain(value) return br.functions.misc:plainNumber(value) end

local function emitGateDebug(spellID, spellName, reason, detail)
	if not E.castDebugOn() then return end -- gate refusals (on cooldown, GCD, ...) are routine
	local now = br._G.GetTime()
	if now < E.gateDebugSilentUntil then return end
	local key = spellID .. reason
	if gateDebugThrottle[key] and now < gateDebugThrottle[key] then return end
	gateDebugThrottle[key] = now + GATE_DEBUG_THROTTLE_SECS
	local msg = "[GATE: " .. reason .. "] " .. tostring(br.functions.misc:plainText(spellName)) .. " (" .. tostring(spellID) .. ")"
	-- Detail numbers are made printable where they're built (plain); anything still flagged would
	-- hide the whole line, so only the detail is left out
	if detail then msg = msg .. " — " .. (br.functions.misc:isFlagged(detail) and "(detail holds a secret value)" or detail) end
	br.functions.misc:addonDebug(msg, true)
end

-- Facts about a spell that only change when the character's spells or talents do. Kept until
-- cast:clearSpellFacts(), which the spell/talent/level events call (readers/common.lua).
-- Whether a spell is known isn't kept: some spells only exist while a form or buff is up, and
-- the spellbook event isn't guaranteed then.
local spellFacts = {}       -- spellID -> { spellType, baseCooldown }
local talentKeyBySpell = {} -- spellID -> talent key, built from talentKeySource
local talentKeySource = nil

function cast:clearSpellFacts()
	br._G.wipe(spellFacts)
	talentKeySource = nil
end

local function getSpellFacts(spellID, baseSpellName)
	local facts = spellFacts[spellID]
	if facts == nil then
		facts = {
			spellType    = br.functions.spell:getSpellType(baseSpellName),
			baseCooldown = select(2, br._G.GetSpellBaseCooldown(spellID)) or 0,
		}
		-- "Unknown" / "Invalid" can mean the spell isn't available right now; ask again next time
		if facts.spellType ~= "Unknown" and facts.spellType ~= "Invalid" then spellFacts[spellID] = facts end
	end
	return facts
end

-- The talent list key whose spell ID this is, or nil when the spell isn't a talent.
local function getTalentKey(spellID, allTalents)
	if talentKeySource ~= allTalents then
		talentKeySource = allTalents
		br._G.wipe(talentKeyBySpell)
		for key, id in pairs(allTalents) do
			if talentKeyBySpell[id] == nil then talentKeyBySpell[id] = key end
		end
	end
	return talentKeyBySpell[spellID]
end

-- buildSpellContext: the spell info and computed values the gates and the dispatch need.
-- Built lazily: each group of values is read from the game the first time a gate or the
-- dispatch asks for one of its fields, then kept on the context for the rest of this attempt.
-- A refusal only pays for what the refusing gate looked at. (A group's fields can be nil, so
-- "already read" is tracked per group, not by the field being present.)
local contextGroups = {} -- field name -> loader(ctx) that rawsets every field of its group

local function defineGroup(fields, loader)
	for _, field in ipairs(fields) do contextGroups[field] = loader end
end

defineGroup({ "spellName", "icon", "rawCastTime", "castTime", "minRange", "maxRange", "hasNoRange" }, function(ctx)
	local spellName, _, icon, rawCastTime, minRange, maxRange = br.api.wow.GetSpellInfo(ctx.spellID)
	-- Some spells return 0 for maxRange on the override; fall back to the base spell.
	if (not maxRange or maxRange == 0) and ctx.baseSpellID and ctx.baseSpellID ~= ctx.spellID then
		_, _, _, _, minRange, maxRange = br.api.wow.GetSpellInfo(ctx.baseSpellID)
	end
	-- Cast time in seconds, only when prediction was asked for, plus any padding.
	local castTime = ctx.predict and (rawCastTime or 0) / 1000 or 0
	if ctx.predictPad then castTime = castTime + ctx.predictPad end
	-- maxRange 0 from the API: for castType "pet" that's the literal melee range (checkRange
	-- uses distance <= 5); for every other cast type it means "unspecified", so effectRng.
	rawset(ctx, "hasNoRange", not maxRange or maxRange == 0)
	if not maxRange or maxRange == 0 then
		maxRange = (ctx.castType == "pet") and 0 or tonumber(ctx.requestedRng)
	else
		maxRange = tonumber(maxRange)
	end
	rawset(ctx, "spellName", spellName)
	rawset(ctx, "icon", icon)
	rawset(ctx, "rawCastTime", rawCastTime or 0)
	rawset(ctx, "castTime", castTime)
	rawset(ctx, "minRange", minRange or 0)
	rawset(ctx, "maxRange", maxRange)
end)

defineGroup({ "baseSpellID", "overrideSpellID" }, function(ctx)
	rawset(ctx, "baseSpellID", br.api.wow.FindBaseSpellByID(ctx.spellID))
	rawset(ctx, "overrideSpellID", br._G.FindSpellOverrideByID(ctx.spellID))
end)

defineGroup({ "baseSpellName" }, function(ctx)
	local baseSpellID = ctx.baseSpellID
	rawset(ctx, "baseSpellName", baseSpellID == ctx.spellID and ctx.spellName or br.api.wow.GetSpellInfo(baseSpellID))
end)

defineGroup({ "spellType", "baseCooldown" }, function(ctx)
	local facts = getSpellFacts(ctx.spellID, ctx.baseSpellName)
	rawset(ctx, "spellType", facts.spellType)
	rawset(ctx, "baseCooldown", facts.baseCooldown)
end)

defineGroup({ "spellCD" }, function(ctx)
	rawset(ctx, "spellCD", br.functions.spell:getSpellCD(ctx.spellID) or 0)
end)

defineGroup({ "globalCD" }, function(ctx)
	rawset(ctx, "globalCD", br.functions.spell:getGlobalCD())
end)

-- IsSpellUsable returns (isUsable, insufficientPower); both are kept so gateUsable can tell a
-- pure power shortfall apart from a wrong-form/other failure (clearcasting fix).
defineGroup({ "isUsable", "insufficientPower" }, function(ctx)
	local isUsable, insufficientPower = br._G.C_Spell.IsSpellUsable(ctx.spellID)
	rawset(ctx, "isUsable", isUsable)
	rawset(ctx, "insufficientPower", insufficientPower)
end)

defineGroup({ "gcdMax", "updateRate", "latency" }, function(ctx)
	local frame = E.getFrameValues()
	rawset(ctx, "gcdMax", frame.gcdMax)
	rawset(ctx, "updateRate", frame.updateRate)
	rawset(ctx, "latency", frame.latency)
end)

-- When this spell last went off (UNIT_SPELLCAST events), 0 if it hasn't. Read only: writing a
-- placeholder here made cast.timeSinceLast report a spell that was never cast as just cast.
defineGroup({ "lastCastTime" }, function(ctx)
	rawset(ctx, "lastCastTime", br.functions.lastCast.lastCastTable.castTime[ctx.spellID] or 0)
end)

local contextMeta = {
	__index = function(ctx, field)
		local loader = contextGroups[field]
		if loader == nil then return nil end
		local loaded = rawget(ctx, "loadedGroups")
		if loaded[loader] then return nil end -- read already; the value is nil
		loaded[loader] = true
		loader(ctx)
		return rawget(ctx, field)
	end,
}

-- spellCD: the cooldown the precheck already read, if it did.
function E.buildSpellContext(spellID, predict, predictPad, castType, effectRng, spellCD)
	return setmetatable({
		spellID      = spellID,
		predict      = predict,
		predictPad   = predictPad,
		castType     = castType,
		requestedRng = effectRng,
		spellCD      = spellCD,
		loadedGroups = {},
	}, contextMeta)
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
	local window  = ctx.gcdMax + ctx.latency
	if elapsed > window then return true end
	return false, "DOUBLE_CAST",
		string.format("cast %.2fs ago, window=%.2fs (GCD %.2fs + lat %.0fms)",
			plain(elapsed), plain(window), plain(ctx.gcdMax), plain(ctx.latency * 1000))
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
	local castSeconds = ctx.rawCastTime / 1000
	if castSeconds <= ctx.gcdMax then return true end
	local ttd = br.engines.ttdTable:getTTD(thisUnit)
	if castSeconds < ttd then return true end
	return false, "DIES_SOON", string.format("castTime=%.2fs TTD=%.2fs", plain(castSeconds), plain(ttd))
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
					string.format("pet focus %d < cost %d", plain(petPower), plain(minCost))
			end
		end
		return true
	end
	-- Clearcasting / Omen of Clarity: the next cast is free, so promised power doesn't matter
	local freeCast = br.player and br.player.buff and br.player.buff.clearcasting
		and br.player.buff.clearcasting.exists()
	-- IsSpellUsable returns false when the player lacks resources, wrong form, etc.
	-- nil means "usable but no resource requirement" — treat as pass.
	if ctx.isUsable ~= false then
		if freeCast then return true end
		-- Power earlier casts have taken but the client hasn't charged yet isn't available
		local affordable, detail = E.affordableAfterPromised(ctx.spellID)
		if not affordable then return false, "NOT_USABLE", detail end
		-- Nor is the mana kept to shift back into a form left in combat
		affordable, detail = E.affordableWithReshift(ctx.spellID, ctx.spellName)
		if affordable then return true end
		return false, "NOT_USABLE", detail
	end
	-- Clearcasting / free-next-cast fix: IsSpellUsable reports a spell as unusable when we
	-- can't afford its BASE cost, even though an Omen-of-Clarity-style proc makes the next
	-- cast free (TBC's IsSpellUsable does not pre-account for the proc, so a low-energy Shred
	-- during Clearcasting would otherwise be skipped). Bypass ONLY when the sole failure is
	-- insufficient power (not a wrong-form/other failure) AND the active spec has a live
	-- clearcasting buff. Nil-guarded so specs without a "clearcasting" buff are unaffected.
	if ctx.insufficientPower and freeCast then
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
		local slot = E.getPetBarSlot(ctx.spellName)
		if slot and br._G.GetPetActionCooldown then
			local cdStart, cdDuration = br._G.GetPetActionCooldown(slot)
			if cdStart and cdDuration and cdDuration > 0
					and (cdStart + cdDuration) > br._G.GetTime() then
				return false, "PET_ON_COOLDOWN",
					string.format("petCD=%.2fs remaining", plain((cdStart + cdDuration) - br._G.GetTime()))
			end
		end
		-- castTimers fallback: covers CastPetAction attempts where the game did not apply a
		-- bar cooldown (e.g. pet was out of range so the ability queued but never executed).
		-- The dispatch always writes castTimers, so this prevents rapid-fire retries even
		-- when GetPetActionCooldown still reports 0 on the same or next tick.
		if E.castTimers then
			local t = E.castTimers[ctx.spellID]
			if t and t > br._G.GetTime() then
				return false, "PET_CAST_TIMER",
					string.format("pet cast timer expires in %.2fs", t - br._G.GetTime())
			end
		end
		return true
	end
	if E.castTimers == nil then return true end -- not yet initialised; pass
	local t = E.castTimers[ctx.spellID]
	if t == nil or t < br._G.GetTime() then
		if ctx.spellCD <= ctx.updateRate then return true end
		return false, "ON_COOLDOWN",
			string.format("spellCD=%.2fs updateRate=%.3fs", plain(ctx.spellCD), plain(ctx.updateRate))
	end
	return false, "CAST_TIMER",
		string.format("castTimer expires in %.2fs", t - br._G.GetTime())
end

-- Cheap refusal before the full spell context. The rotation runs every tick, also during the
-- GCD, and most spells it asks about then are simply on cooldown; the cooldown gate needs only
-- the spell's cooldown, BR's cast timer and the update rate, so it runs on those alone first and
-- the context (about eight more game calls) is only built for spells that might pass. Same gate,
-- same refusal record and debug line as the full gate run.
local precheckCtx = {}
-- Returns true (and the cooldown it read, for the context) when the spell might pass.
function E.cooldownPrecheck(spellID, castType, isAbleCheck)
	if castType == "pet" or E.castTimers == nil then return true end
	precheckCtx.spellID = spellID
	precheckCtx.spellCD = br.functions.spell:getSpellCD(spellID) or 0
	precheckCtx.updateRate = E.getFrameValues().updateRate
	local pass, reason, detail = gateCooldownTimer(precheckCtx, nil, castType)
	if pass then return true, precheckCtx.spellCD end
	E.recordRefusal(spellID, reason, detail)
	if not isAbleCheck then
		emitGateDebug(spellID, br.functions.spell:getName(spellID), reason, detail)
	end
	return false
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
		if not E.getPetBarSlot(ctx.spellName) then
			return false, "NOT_KNOWN",
				"Pet ability '" .. tostring(ctx.spellName) .. "' not found on pet action bar"
		end
		-- Talent table not applicable for pet spells.
		return true
	end
	local isCondemn = allSpells and (ctx.spellID == allSpells.condemn or ctx.spellID == allSpells.condemnMassacre)
	local isKnown = br.functions.spell:isKnown(ctx.spellID)
	if not isKnown and castType ~= "known" and not isCondemn then
		return false, "NOT_KNOWN",
			"isKnown=false castType=" .. tostring(castType)
	end
	-- Talent check.
	if allTalents then
		local talentKey = getTalentKey(ctx.spellID, allTalents)
		if talentKey ~= nil and not (br.player.talent[talentKey] or isKnown) then
			return false, "NO_TALENT",
				"talent '" .. tostring(talentKey) .. "' not active"
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
		local castingInWindow = E.getSameSpellCastRemain(ctx.spellID) > 0
			and not E.isCastingOutsideQueueWindow(ctx.spellID)
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
-- Every gate has to pass, so the order only decides how much work a refusal costs and which
-- reason "/br why" shows. Known comes first so an unlearned spell is reported as that rather
-- than as unusable; then the cheap checks that refuse most often (cooldown, power, GCD), and
-- the ones that ask the game or other engines last.
local GATE_FUNCTIONS = {
	gateSpellID,
	gateKnownTalent,
	gateCooldownTimer,
	gateUsable,
	gateGCD,
	gateDoubleCast,
	gateDeadCheck,
	gateAutoRepeat,
	gateDiesSoon,
	gateHardCC,
}

-- runGates: execute all gate functions in order.
-- Returns true on full pass, or false with the failing reason code.
-- isAbleCheck: when true (cast.able calls), gate failures are expected and not printed.
function E.runGates(ctx, thisUnit, castType, isAbleCheck)
	local allTalents = br.player and br.player.spells and br.player.spells.talents
	local allSpells  = br.player and br.player.spells
	for _, gateFn in ipairs(GATE_FUNCTIONS) do
		local pass, reason, detail = gateFn(ctx, thisUnit, castType, allTalents, allSpells)
		if not pass then
			E.recordRefusal(ctx.spellID, reason, detail)
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

function E.gateCacheKey(spellID, castType, thisUnitArg)
	return tostring(spellID) .. "|" .. tostring(castType or "norm") .. "|" .. tostring(thisUnitArg or "nil")
end

function E.gateCacheStore(key, ctx)
	gateCache[key] = { ctx = ctx, expiresAt = br._G.GetTime() + GATE_CACHE_TTL }
end

-- Returns the cached ctx if valid, nil otherwise.
function E.gateCacheGet(key)
	local entry = gateCache[key]
	if entry and br._G.GetTime() < entry.expiresAt then
		return entry.ctx
	end
	gateCache[key] = nil -- expired; clear slot
	return nil
end
