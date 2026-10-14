local _, br = ...
local cast = br.functions.cast
local E = cast.internal

-- Dispatch: failure reports, the cast itself (castingSpell), unit and range checks and
-- the AoE / single-target dispatchers.

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: printReport (failure messages after the gates)
--
-- Records why a cast was refused for "/br why" and, with Display Failcasts / Cast Debug on,
-- prints it. Reads the call's unit and options from ctx (ctx.unit, ctx.debug, ctx.minUnits,
-- ctx.effectRng), set by createCastFunction. Always returns false.
-- ─────────────────────────────────────────────────────────────────────────────

-- Reason text -> code shown in "/br why" and the [CAST FAIL] prefix
local REPORT_CODES = {
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

-- Refusals that are part of normal play, not a problem
local EXPECTED_REPORTS = {
	["No Unit"] = true, ["Below Min Units"] = true, ["Below Min Units Facing"] = true,
	["Below Min Units Cone"] = true, ["Below Min Units Rect"] = true, ["No Range"] = true,
	["Not Safe"] = true, ["Invalid Unit"] = true, ["No Control"] = true,
}

function E.printReport(ctx, debugOnly, debugReason, thisCount)
	if debugReason == nil then debugReason = "" end
	local thisUnit, spellID, minUnits, effectRng = ctx.unit, ctx.spellID, ctx.minUnits, ctx.effectRng
	local reasonCode = REPORT_CODES[debugReason]
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
	E.recordRefusal(spellID, reasonCode, refusalDetail)
	if ctx.debug then return false end -- never print for cast.able checks
	local prefix = "[CAST FAIL][" .. reasonCode .. "] "
	-- Routine refusals (no unit, not enough units, out of range, unsafe, out of sight, crowd controlled)
	-- show with Cast Debug only; the rest (cast failed, not dead, ...) with Display Failcasts too
	if E.showRefusal(debugOnly or EXPECTED_REPORTS[debugReason] == true) then
		if debugReason == "No Unit" then
			br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — no unit found in " .. ctx.maxRange .. " yrds.", true)
		elseif debugReason == "Below Min Units" then
			br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — " .. tostring(thisCount) ..
				" enemies in " .. ctx.maxRange .. " yrds, need " .. minUnits .. ".", true)
		elseif debugReason == "Below Min Units Facing" then
			br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — " .. tostring(thisCount) ..
				" facing enemies in " .. ctx.maxRange .. " yrds, need " .. minUnits .. ".", true)
		elseif debugReason == "Below Min Units Cone" then
			br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — " .. tostring(thisCount) ..
				" enemies in " .. effectRng .. "° cone/" .. ctx.maxRange .. " yrds, need " .. minUnits .. ".", true)
		elseif debugReason == "Below Min Units Rect" then
			br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — " .. tostring(thisCount) ..
				" enemies in " .. ctx.maxRange .. "×" .. effectRng .. " yrd rect, need " .. minUnits .. ".", true)
		elseif debugReason == "Not Dead" then
			br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — unit is not dead.", true)
		elseif debugReason == "No Range" then
			br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — unit not in range"
				.. (type(thisCount) == "string" and (" (" .. thisCount .. ")") or "") .. ".", true)
		elseif debugReason == "Not Safe" then
			br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — not safe to AoE.", true)
		elseif debugReason == "Invalid Unit" then
			if cast:isRejected("los", nil, thisUnit) then
				br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — game reported unit out of line of sight.", true)
			elseif not br.functions.misc:canSee(thisUnit) then
				br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — unit out of line of sight.", true)
			else
				br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — unit invalid (unknown reason).", true)
			end
		elseif debugReason == "No Control" then
			br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — player is crowd controlled.", true)
		elseif debugReason == "Cast Failed" then
			local wowReason = br.functions.lastCast
				and br.functions.lastCast.lastCastTable
				and br.functions.lastCast.lastCastTable.lastFailedReason
				and br.functions.lastCast.lastCastTable.lastFailedReason[ctx.spellID]
			if wowReason and wowReason ~= "" then
				br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — WoW rejected: " .. wowReason, true)
			else
				br.functions.misc:addonDebug(prefix .. ctx.spellName .. " — no GCD/cast/channel signal after cast attempt.", true)
			end
		else
			br.log:error(prefix ..
				ctx.spellName .. " ID:" .. spellID ..
				" type:" .. ctx.spellType ..
				" range:[" .. ctx.minRange .. "-" .. ctx.maxRange .. "]" ..
				" dist:" .. tostring(br.functions.misc:plainNumber(br.functions.range:getDistance(thisUnit))) ..
				" inRange:" .. tostring(br._G.C_Spell.IsSpellInRange(ctx.spellName, thisUnit)) ..
				" unit:" .. tostring(thisUnit))
		end
	end
	return false
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: castingSpell (was a closure; now module-level for zero reallocation)
--
-- Performs the actual WoW cast API call and post-cast verification.
-- debug=true: used by cast.able — returns true immediately without casting.
-- ─────────────────────────────────────────────────────────────────────────────

function E.castingSpell(ctx, thisUnit, castType, debug)
	if br._G.UnitHealth(thisUnit) <= 0 and castType ~= "dead" then
		E.recordRefusal(ctx.spellID, "UNIT_DEAD", "unit " .. tostring(thisUnit))
		return false
	end

	if cast:isAuraBounced(ctx.spellID, thisUnit) then
		E.recordRefusal(ctx.spellID, "AURA_BOUNCED", "stronger aura already on unit")
		return false
	end

	E.recordPass(ctx.spellID)

	-- cast.able path: no side effects.
	if debug then return true end

	-- Hard CC guard (re-checked here so the timer is set correctly even if the
	-- gate was bypassed via cache).
	if br.functions.combat and br.functions.combat.cannotCast and br.functions.combat:cannotCast(ctx.spellID) then
		E.castTimers[ctx.spellID] = br._G.GetTime() + 0.50
		E.setCastIntentLock(ctx.spellID, 0.50)
		return E.printReport(ctx, false, "No Control")
	end

	E.setCastIntentLock(ctx.spellID, 0.20)
	local snapshot = E.takeCastStartSnapshot(ctx.spellID)

	E.recordBotCast(ctx.spellID, thisUnit)

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
		local slot = E.getPetBarSlot(castName, true)
		if slot then
			br._G.CastPetAction(slot)
			-- Read the cooldown the game just applied to the bar slot.
			-- GetPetActionCooldown is updated synchronously after CastPetAction,
			-- so cdDuration reflects the real ability cooldown on TBC Classic.
			local cdStart, cdDuration
			if br._G.GetPetActionCooldown then
				cdStart, cdDuration = br._G.GetPetActionCooldown(slot)
			end
			local petCDSec = (cdDuration and cdDuration > 0) and cdDuration
				or (ctx.baseCooldown > 0 and ctx.baseCooldown / 1000)
				or 8  -- fallback: most pet abilities are 8–10 s
			E.castTimers[ctx.spellID] = br._G.GetTime() + math.max(petCDSec, 1)
			E.setCastIntentLock(ctx.spellID, 0.5)
			br.ui.toggles.mainButton:SetNormalTexture(ctx.icon)
			br.lastSpellCast   = ctx.spellID
			br.lastSpellTarget = br._G.UnitGUID(thisUnit)
			return true
		end
		return E.printReport(ctx, false, "PET_SLOT_NOT_FOUND", castName)
	end

	-- Sending a spell while another cast is running pre-casts it into the queue window.
	local castBeforeKey = E.currentCastKey()
	if br.debug.cast then br.debug.cast:noteSend(ctx.spellID) end

	-- A lower rank than the best one known (cast.<spell>.rank(n)) has to be sent by ID: on ranked
	-- clients casting by name sends the highest known rank.
	local bestRankID = br.api.hasSpellRanks and castName == ctx.spellName and select(7, br.api.wow.GetSpellInfo(castName))
	if bestRankID and bestRankID ~= ctx.spellID then
		cast:castByID(ctx.spellID, thisUnit)
	else
		cast:castByName(castName, thisUnit)
	end
	if br._G.IsAoEPending() then
		local X, Y, Z = br._G.ObjectPosition(thisUnit)
		br._G.ClickPosition(X, Y, Z)
	end

	local castSucceeded, details = E.verifyCastStarted(ctx.spellID, snapshot, castName)

	-- A pre-cast shows no new cast or GCD until the current cast ends, so it usually
	-- reads as inconclusive. Either way, the decision for this cast is made: the
	-- rotation now waits for the current cast to end (see misc:pause).
	if castBeforeKey ~= nil and (castSucceeded or (details and details.inconclusive)) then
		E.queuedBehindCast = castBeforeKey
	end

	if castSucceeded or (details and details.inconclusive) then E.noteReshiftSpellSent(castName) end

	-- Sent: its costs are promised until the client charges them (see E.promiseCosts)
	if (castSucceeded or (details and details.inconclusive))
		and not (br.player and br.player.buff and br.player.buff.clearcasting and br.player.buff.clearcasting.exists())
	then
		local now = br._G.GetTime()
		local hold = br.functions.misc:getRoundTripHold(ctx.latency)
		local _, _, _, _, castEnd = br._G.UnitCastingInfo("player")
		if castBeforeKey == nil and br._G.IsCurrentSpell and br._G.IsCurrentSpell(ctx.spellID) and castEnd == nil then
			E.promiseCosts(ctx.spellID, now + 6, true)          -- on-next-swing: until the swing
		elseif castEnd then
			E.promiseCosts(ctx.spellID, castEnd / 1000 + hold)  -- cast-time, or pre-cast behind a cast
		else
			E.promiseCosts(ctx.spellID, now + hold)             -- instant: until the server's reply
		end
	end

	if castSucceeded then
		local sameSpellCastRemain = E.getSameSpellCastRemain(ctx.spellID)
		if sameSpellCastRemain > 0 then
			-- Just started casting this spell: hold it until the cast reaches its own
			-- queue window, where the profile may choose to pre-cast it again.
			local hold = math.max(0.12, sameSpellCastRemain - cast:getQueueWindow())
			E.castTimers[ctx.spellID] = br._G.GetTime() + hold
			E.setCastIntentLock(ctx.spellID, hold)
		else
			E.castTimers[ctx.spellID] = br._G.GetTime() + 1
			local settleLock = 0.12
			if ctx.spellType == "Helpful" then
				settleLock = 0.30
			elseif ctx.spellType == "Harmful" and not br._G.UnitAffectingCombat("player") then
				settleLock = 0.30
			end
			E.setCastIntentLock(ctx.spellID, settleLock)
		end
		br.ui.toggles.mainButton:SetNormalTexture(ctx.icon)
		br.lastSpellCast   = ctx.spellID
		br.lastSpellTarget = br._G.UnitGUID(thisUnit)
		return true
	end

	if details and details.inconclusive then
		-- Sent, but nothing showed it starting yet (off-GCD spells, or the server's reply is still on
		-- its way). Hold the spell for a server round trip so it isn't sent a second time before the
		-- reply arrives.
		local hold = br.functions.misc:getRoundTripHold(ctx.latency)
		E.castTimers[ctx.spellID] = br._G.GetTime() + hold
		E.setCastIntentLock(ctx.spellID, hold)
		return true -- queued / not yet confirmed; do not spam CAST_FAILED
	end

	E.castTimers[ctx.spellID] = br._G.GetTime() + 0.10
	E.setCastIntentLock(ctx.spellID, 0.20)
	return E.printReport(ctx, false, "Cast Failed")
end

E.rangeDelayTimers = nil -- Track when spells first become in range
E.RANGE_DELAY_PRUNE_INTERVAL = 10
E.rangeDelayNextPrune = 0

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: Unit selection helpers
-- ─────────────────────────────────────────────────────────────────────────────

-- resolveUnit: if thisUnit is nil, ask the engine for the best match.
-- Returns the resolved unit token, or nil if nothing found.
function E.resolveUnit(ctx, thisUnit, castType)
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
function E.checkUnitValidity(thisUnit, castType)
	if br.functions.unit:GetUnitIsUnit(thisUnit, "player") then return true end
	if castType == "pet" then
		-- Pet abilities are cast by the pet, so the player's LoS doesn't apply.
		return br._G.UnitExists(thisUnit) == true
	end
	return E.isUnitVisible(thisUnit)
end

-- checkRange: range check with API + moving-hysteresis guard + distance fallback.
-- Returns true when in range, or false plus a short reason naming which check failed
-- (shown by "/br why <spell>").
function E.checkRange(ctx, thisUnit, castType)
	if thisUnit == "player" then return true end
	-- The game just said this spell can't reach this unit; trust it over our math.
	if castType ~= "pet" and cast:isRejected("range", ctx.spellID, thisUnit) then
		return false, "game said out of range moments ago"
	end
	-- A harmful spell with no range of its own (a next-swing spell such as Maul) lands only in melee,
	-- but the game reports it in range at any distance, so measure melee instead.
	if castType ~= "pet" and ctx.hasNoRange and ctx.spellType == "Harmful" then
		local distance = br.functions.range:getDistance(thisUnit)
		if distance < 5 then return true end
		return false, string.format("no range of its own: needs melee (distance %.1f)", distance or -1)
	end
	-- For pet castType, IsSpellInRange evaluates from the PLAYER's position — not the
	-- pet's — so it cannot reliably gate melee or short-range pet abilities.  Skip the
	-- API check entirely for pet spells and always measure pet-to-target distance directly.
	if castType ~= "pet" then
		local spellInRange = br._G.C_Spell.IsSpellInRange(ctx.spellName, thisUnit)
		if spellInRange == false then
			local timerKey = ctx.spellID .. "_" .. (br._G.UnitGUID(thisUnit) or thisUnit)
			E.rangeDelayTimers[timerKey] = nil
			return false, string.format("IsSpellInRange=false (distance %.1f)",
				br.functions.range:getDistance(thisUnit) or -1)
		end
		if spellInRange == true then
			if br.functions.misc:isMoving("player") and ctx.maxRange > 0 then
				local now      = br._G.GetTime()
				-- Entries are keyed per spell + unit GUID and were only ever cleared on
				-- leaving range, so dead/despawned units piled up. Sweep ones not checked lately.
				if now >= E.rangeDelayNextPrune then
					E.rangeDelayNextPrune = now + E.RANGE_DELAY_PRUNE_INTERVAL
					for k, entry in pairs(E.rangeDelayTimers) do
						if now - entry.seen > E.RANGE_DELAY_PRUNE_INTERVAL then E.rangeDelayTimers[k] = nil end
					end
				end
				local timerKey = ctx.spellID .. "_" .. (br._G.UnitGUID(thisUnit) or thisUnit)
				local entry = E.rangeDelayTimers[timerKey]
				if entry == nil then
					E.rangeDelayTimers[timerKey] = { started = now, seen = now }
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

	-- getDistance is 0 in melee, else edge to edge (what spell ranges are measured against).
	-- maxRange 0 (pet melee abilities): melee.
	if ctx.maxRange == 0 then
		if distance < 5 then return true end
		return false, string.format("IsSpellInRange=nil, distance %.1f: not in melee", distance or -1)
	end
	if distance >= ctx.minRange and distance <= ctx.maxRange then return true end
	return false, string.format("IsSpellInRange=nil, distance %.1f, needs %.1f to %.1f",
		distance or -1, ctx.minRange, ctx.maxRange)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SECTION: Dispatch helpers (AoE and ST)
-- ─────────────────────────────────────────────────────────────────────────────

function E.dispatchAoE(ctx, thisUnit, castType, minUnits, effectRng, enemies, debug)
	local enemyCount = enemies
		or (castType == "ground"    and #br.engines.enemiesEngineFunctions:getEnemies(thisUnit, effectRng)) -- around the spot
		or (castType == "aoe"       and #br.engines.enemiesEngineFunctions:getEnemies("player", ctx.maxRange))
		or (castType == "cone"      and br.engines.enemiesEngineFunctions:getEnemiesInCone(effectRng, ctx.maxRange))
		or (castType == "rect"      and br.engines.enemiesEngineFunctions:getEnemiesInRect(effectRng, ctx.maxRange))
		or (castType == "targetAOE" and #br.engines.enemiesEngineFunctions:getEnemies(thisUnit, effectRng))
		or 0
	if enemyCount >= minUnits then
		-- The safety check counts every unit in reach itself. It used to be handed this count of
		-- valid enemies as its "all units" count, so it compared the count with itself and an AoE
		-- was always safe: in game, Demoralizing Roar pulled a neutral mob standing nearby.
		if br.functions.range:isSafeToAoE(ctx.spellID, thisUnit, effectRng, minUnits, castType)
			or br.functions.unit:isDummy("target")
		then
			return E.castingSpell(ctx, thisUnit, castType, debug)
		end
		return E.printReport(ctx, false, "Not Safe")
	end
	if castType == "cone" then return E.printReport(ctx, false, "Below Min Units Cone", enemyCount) end
	if castType == "rect" then return E.printReport(ctx, false, "Below Min Units Rect", enemyCount) end
	return E.printReport(ctx, false, "Below Min Units", enemyCount)
end

function E.dispatchST(ctx, thisUnit, castType, minUnits, enemies, debug)
	-- A harmful spell with no range, cast on the player, hits everything around the player
	-- (Demoralizing Roar, Thunder Clap): it gets the AoE safety check, so it doesn't pull neutral or
	-- not-yet-engaged mobs standing nearby. Without a radius from the call, 10 yards.
	if thisUnit == "player" and castType == "norm" and ctx.spellType == "Harmful"
		and br._G.C_Spell.SpellHasRange and not br._G.C_Spell.SpellHasRange(ctx.spellName)
		and not br.functions.range:isSafeToAoE(ctx.spellID, "player", math.max(ctx.effectRng or 5, 10), 1, "aoe")
	then
		return E.printReport(ctx, false, "Not Safe")
	end
	-- getFacing returns true/false/nil. nil means "can't determine" (no unlocker, or positions
	-- unavailable). Treat nil as OK — only block when the API definitively says not facing.
	local facingOk = (castType == "norm" and br.functions.unit:getFacing("player", thisUnit) ~= false
			and not cast:isRejected("facing", ctx.spellID, thisUnit))
		or (castType == "pet" and br.functions.unit:getFacing("pet", thisUnit) ~= false)
		or ctx.spellType == "Helpful"
		or ctx.spellType == "Unknown"
	if not facingOk then
		E.recordRefusal(ctx.spellID, "NOT_FACING", "unit " .. tostring(thisUnit))
		return false
	end
	if minUnits == 1 or ctx.spellType == "Helpful" or ctx.spellType == "Unknown" then
		return E.castingSpell(ctx, thisUnit, castType, debug)
	end
	-- Only count the enemies in front when the call needs more than one
	local enemyFacingCount = enemies or #br.engines.enemiesEngineFunctions:getEnemies("player", ctx.maxRange, false, true) or 0
	if enemyFacingCount >= minUnits then
		return E.castingSpell(ctx, thisUnit, castType, debug)
	end
	return E.printReport(ctx, false, "Below Min Units Facing", enemyFacingCount)
end
