local _, br = ...
---------------------------------------------------------------------------------------------------
-- Fight Log
---------------------------------------------------------------------------------------------------
-- A scorecard per fight in Fights.log, in a fixed layout scripts read (.tests/fight_score.py): how
-- the fight went, to compare profiles and versions of one. A fight is the Rotation Log's (combat
-- start to end; written when the Rotation Log closes it, with its cast counts). Counted:
--   combat log    damage done by you and by your pets, guardians and totems (minus overkill), per
--                 spell; healing done (minus overhealing) and overhealing; damage taken; deaths of
--                 you and your group
--   4x a second   BR off (Power) or paused (pause key/toggle, mounted, dead, ...; not its own casts):
--                 the time BR wasn't playing, so a fight it didn't play isn't scored as one;
--                 busy (casting, channelling or the GCD running) or swinging at a target in melee;
--                 idle with an enemy within 8 yd (Idle.log's rule); time at full energy, rage,
--                 focus or runic power; each 30 s+ cooldown among the profile's abilities while it
--                 is ready and usable
--   power events  mana spent and gained (not the mana a death empties)
--   your casts    per spell: casts, and the mana each cost (combat log SPELL_CAST_SUCCESS)
--   between fights (the "rest" before each fight): seconds since the last fight ended, time drinking
--                 and eating (the player's aura changes), mana gained, and spells cast meanwhile with
--                 their mana (the out-of-combat heal, buffs)
-- A value the game hides (secret) isn't added: the event is counted as hidden instead.
--
-- Layout: "=== fight N ===", then one line per section. Most are "section key=value ...", values
-- without spaces; "target", "spells", "spellCasts", "spellMana", "restSpells" and "ready" hold names:
-- "target <name>", and "spells <name>=<n>; <name>=<n>" (most first).
br.log.fights = br.log.fights or {}
local fights = br.log.fights
local log = br.log

local SAMPLE_EVERY = 0.25   -- seconds between samples
local READY_MIN_CD = 30000  -- ms: cooldowns at least this long are watched while ready
local IDLE_NEAR = 8         -- yards: idle with an enemy this close (Idle.log's rule)
local TOP_SPELLS = 8        -- spells listed by damage
local MINE = 0x00000001     -- COMBATLOG_OBJECT_AFFILIATION_MINE: you, your pets, guardians, totems
local GROUP = 0x00000006    -- COMBATLOG_OBJECT_AFFILIATION_PARTY | _RAID
local PLAYER = 0x00000400   -- COMBATLOG_OBJECT_TYPE_PLAYER
local CAPPED_POWER = { [1] = "rage", [2] = "focus", [3] = "energy", [6] = "runicPower" }
-- Pause reasons that are BR playing (its rotation waits while a cast or channel runs), not BR stopped
local PLAYING_PAUSES = { casting = true, channelling = true, ["item channel"] = true }

local GetTime = br.game.GetTime
local fightLine = log:file("Fights.log")
local current      -- the fight being counted, until combat ends
local sampler      -- the ticker taking samples
local playerGUID

-- Between fights, from when the last one ended: open drinking/eating periods (drinkSince, eatSince)
-- and their totals, casts and their mana, and the mana then (manaAtEnd, nil when unknown)
local function newRest(manaAtEnd)
	return { since = GetTime(), drinking = 0, eating = 0, casts = {}, mana = 0, manaAtEnd = manaAtEnd }
end
local rest = newRest(nil)

local function usable(value)
	return value ~= nil and br.functions.misc:canUseValue(value)
end

local function name(text) return log.printable(tostring(text)) end

-- The profile's abilities with a long cooldown, known now: { name, id } (each spell once)
local function watchedCooldowns()
	local list, seen = {}, {}
	local abilities = br.runner and br.runner.spells and br.runner.spells.abilities
	if abilities == nil then return list end
	local spellFns = br.functions.spell
	for _, ref in pairs(abilities) do
		local id = spellFns:currentRank(ref)
		if type(id) == "number" and id > 0 and not seen[id] and spellFns:isKnown(id) then
			seen[id] = true
			local cooldownMS = spellFns:getBaseCooldown(id)
			if usable(cooldownMS) and cooldownMS >= READY_MIN_CD then
				list[#list + 1] = { name = name(spellFns:getName(id)), id = id }
			end
		end
	end
	table.sort(list, function(a, b) return a.name < b.name end)
	return list
end

local function sample()
	local f = current
	if f == nil then return end
	local now = GetTime()
	local dt = now - f.sampledAt
	f.sampledAt = now
	local unitFns = br.functions.unit
	-- BR not playing: Power off (2026-10-26: a death on purpose with Power off was scored as the
	-- profile's 0 dps, 16.8 s idle fight), or paused for something other than its own cast
	local pauseReason = br.runner and br.runner.state and br.runner.state.pauseReason
	if br.core and not br.core:isPowerOn() then
		f.brOff = f.brOff + dt
		return
	elseif pauseReason and not PLAYING_PAUSES[pauseReason] then
		f.brPaused = f.brPaused + dt
		return
	end
	-- Crowd controlled (feared, stunned...): nothing to play, so neither idle nor capped (2026-10-26,
	-- Gruul's Lair: Maulgar's fear and Gruul's Stoned were scored as 13 s and 11 s idle)
	if br.functions.combat:hasHardControl() then
		f.controlled = f.controlled + dt
		return
	end
	local busy = br.game.UnitCastingInfo("player") ~= nil or br.game.UnitChannelInfo("player") ~= nil
		or (br.functions.spell:getGlobalCD() or 0) > 0
	local swinging = not busy and unitFns:isAutoAttacking() and br.game.UnitExists("target")
		and br.functions.range:getDistance("target") < 5
	if busy then
		f.busy = f.busy + dt
	elseif swinging then
		f.swinging = f.swinging + dt
	elseif #br.engines.enemiesEngineFunctions:getEnemies("player", IDLE_NEAR) > 0 then
		f.idleNear = f.idleNear + dt
	end
	local powerType = br.game.UnitPowerType("player")
	local cappedName = CAPPED_POWER[powerType]
	if cappedName then
		local power, max = br.game.UnitPower("player", powerType), br.game.UnitPowerMax("player", powerType)
		if usable(power) and usable(max) and max > 0 and power >= max then
			f.capped[cappedName] = (f.capped[cappedName] or 0) + dt
		end
	end
	for _, watched in ipairs(f.watched) do
		if (br.functions.spell:getSpellCD(watched.id) or 0) == 0 and br.game.C_Spell.IsSpellUsable(watched.id) then
			f.ready[watched.name] = (f.ready[watched.name] or 0) + dt
		end
	end
end

-- Drinking and eating from the player's buffs: a period opens when the buff appears, closes when it goes
local function updateRestBuffs()
	local now, unitFns = GetTime(), br.functions.unit
	local drinking, eating = unitFns:isDrinking("player"), unitFns:isEating("player")
	if drinking and not rest.drinkSince then rest.drinkSince = now
	elseif not drinking and rest.drinkSince then rest.drinking = rest.drinking + now - rest.drinkSince; rest.drinkSince = nil end
	if eating and not rest.eatSince then rest.eatSince = now
	elseif not eating and rest.eatSince then rest.eating = rest.eating + now - rest.eatSince; rest.eatSince = nil end
end

-- The rest before a fight, closed as it starts
local function closeRest(manaStart)
	local now, r = GetTime(), rest
	if r.drinkSince then r.drinking = r.drinking + now - r.drinkSince; r.drinkSince = nil end
	if r.eatSince then r.eating = r.eating + now - r.eatSince; r.eatSince = nil end
	r.seconds = now - r.since
	r.manaGained = (r.manaAtEnd and usable(manaStart)) and math.max(0, manaStart - r.manaAtEnd) or nil
	return r
end

local function start(rotationFight)
	playerGUID = br.game.UnitGUID("player")
	local mana = br.game.UnitPower("player", 0)
	local target
	if br.game.UnitExists("target") then
		log:notePlayer("target")
		target = name(br.game.UnitName("target"))
	end
	current = {
		n = rotationFight.n, startedAt = rotationFight.startedAt, sampledAt = GetTime(), target = target,
		busy = 0, swinging = 0, idleNear = 0, controlled = 0, brOff = 0, brPaused = 0, capped = {}, ready = {}, watched = watchedCooldowns(),
		damage = 0, petDamage = 0, bySpell = {}, taken = 0, healing = 0, overhealing = 0, hidden = 0,
		manaSpent = 0, manaGained = 0, lastMana = usable(mana) and mana or nil, manaStart = mana,
		deaths = 0, groupDeaths = 0, casts = {}, castMana = {}, rest = closeRest(mana),
	}
	if sampler then sampler:Cancel() end
	sampler = br.game.C_Timer.NewTicker(SAMPLE_EVERY, sample)
end

local function stop(rotationFight)
	if current == nil or current.n ~= rotationFight.n then return end
	sample()
	if sampler then sampler:Cancel(); sampler = nil end
	current.manaEnd = br.game.UnitPower("player", 0)
	current.ended = true
	rest = newRest(usable(current.manaEnd) and current.manaEnd or nil)
	updateRestBuffs() -- already drinking as combat ends: counted from now
end

-- "k=v k=v" from pairs in order, numbers to one decimal
local function fields(list)
	local parts = {}
	for i = 1, #list, 2 do
		local value = list[i + 1]
		if type(value) == "number" then value = (value % 1 == 0) and tostring(value) or ("%.1f"):format(value) end
		parts[#parts + 1] = list[i] .. "=" .. tostring(value)
	end
	return table.concat(parts, " ")
end

-- "<name>=<n>; ..." most first, at most limit
local function namedList(map, limit, decimals)
	local list = {}
	for key, value in pairs(map) do list[#list + 1] = { key, value } end
	table.sort(list, function(a, b) if a[2] ~= b[2] then return a[2] > b[2] end return a[1] < b[1] end)
	local parts = {}
	for i = 1, math.min(limit or #list, #list) do
		parts[i] = list[i][1] .. "=" .. (decimals and ("%.1f"):format(list[i][2]) or tostring(math.floor(list[i][2] + 0.5)))
	end
	return table.concat(parts, "; ")
end

local function write(rotationFight)
	local f = current
	if f == nil or f.n ~= rotationFight.n then return end
	current = nil
	local duration = rotationFight.duration or (GetTime() - f.startedAt)
	local perSecond = function(n) return duration > 0 and n / duration or 0 end
	local group = br.game.IsInRaid() and "raid" or (br.game.IsInGroup() and "party" or "solo")
	local manaStart, manaEnd = usable(f.manaStart) and f.manaStart or "hidden", usable(f.manaEnd) and f.manaEnd or "hidden"
	fightLine(("=== fight %d ==="):format(f.n))
	local profile = name(br.loader.selectedProfileName):gsub("%s", "_")
	local spec = tostring(br.loader.selectedSpec):gsub("%s", "_")
	fightLine("fight " .. fields({ "n", f.n, "duration", duration, "flavour", tostring(br.client.flavourName),
		"profile", profile, "spec", spec, "level", br.game.UnitLevel("player"), "group", group }))
	if f.target then fightLine("target " .. f.target) end
	fightLine("casts " .. fields({ "sent", rotationFight.sent or 0, "done", rotationFight.done or 0,
		"failed", rotationFight.failed or 0, "interrupted", rotationFight.interrupted or 0,
		"noAnswer", rotationFight.noAnswer or 0, "refused", rotationFight.refused or 0, "you", rotationFight.you or 0,
		"perMinute", perSecond(rotationFight.sent or 0) * 60 }))
	local timeParts = { "busy", f.busy, "swinging", f.swinging, "idleNear", f.idleNear, "controlled", f.controlled, "brOff", f.brOff, "brPaused", f.brPaused }
	for powerName, seconds in pairs(f.capped) do
		timeParts[#timeParts + 1] = "capped." .. powerName
		timeParts[#timeParts + 1] = seconds
	end
	fightLine("time " .. fields(timeParts))
	fightLine("damage " .. fields({ "done", f.damage, "dps", perSecond(f.damage), "pet", f.petDamage, "taken", f.taken,
		"hidden", f.hidden }))
	local effective = f.healing
	fightLine("healing " .. fields({ "done", effective, "hps", perSecond(effective), "over", f.overhealing,
		"overPct", (effective + f.overhealing) > 0 and f.overhealing * 100 / (effective + f.overhealing) or 0,
		"manaSpent", f.manaSpent, "manaGained", f.manaGained, "perMana", f.manaSpent > 0 and effective / f.manaSpent or 0,
		"manaStart", manaStart, "manaEnd", manaEnd }))
	fightLine("deaths " .. fields({ "you", f.deaths, "group", f.groupDeaths }))
	if next(f.bySpell) then fightLine("spells " .. namedList(f.bySpell, TOP_SPELLS)) end
	if next(f.casts) then fightLine("spellCasts " .. namedList(f.casts)) end
	if next(f.castMana) then fightLine("spellMana " .. namedList(f.castMana)) end
	local r = f.rest
	fightLine("rest " .. fields({ "since", r.seconds, "drinking", r.drinking, "eating", r.eating,
		"manaGained", r.manaGained or "unknown", "manaSpent", r.mana }))
	if next(r.casts) then fightLine("restSpells " .. namedList(r.casts)) end
	if #f.watched > 0 then
		local ready = {}
		for _, watched in ipairs(f.watched) do ready[watched.name] = f.ready[watched.name] or 0 end
		fightLine("ready " .. namedList(ready, nil, true))
	end
	-- Debug Level developer: the fight in one chat line, so a profile change shows its effect at once
	if br.functions.misc:debugAt("developer") then
		local failed = (rotationFight.failed or 0) + (rotationFight.interrupted or 0) + (rotationFight.noAnswer or 0)
		local notPlaying = (f.controlled > 0 and (", crowd controlled %.1fs"):format(f.controlled) or "")
			.. (f.brOff > 0 and (", BR off %.1fs"):format(f.brOff) or "")
			.. (f.brPaused > 0 and (", BR paused %.1fs"):format(f.brPaused) or "")
		br.log:systemDebug(("[FIGHT] %.1fs%s: %.1f dps, %d casts%s, %s mana, idle %.1fs%s"):format(duration,
			f.target and (" vs " .. f.target) or "", perSecond(f.damage), rotationFight.sent or 0,
			failed > 0 and (" (" .. failed .. " didn't land)") or "", tostring(math.floor(f.manaSpent + 0.5)), f.idleNear,
			notPlaying))
	end
end

br.log.rotation:onFight(function(phase, rotationFight)
	if phase == "start" then return start(rotationFight) end
	if phase == "end" then return stop(rotationFight) end
	if phase == "close" then return write(rotationFight) end
end)

-- Mana spent and gained, from the player's power updates; drinking and eating from their buffs (out
-- of combat only: UNIT_AURA fires often in a fight)
local powerEvents = br.game.CreateFrame("Frame")
powerEvents:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
powerEvents:RegisterUnitEvent("UNIT_AURA", "player")
powerEvents:SetScript("OnEvent", function(_, event, _, powerToken)
	local f = current
	if event == "UNIT_AURA" then
		if f == nil or f.ended then updateRestBuffs() end
		return
	end
	if f == nil or f.ended or powerToken ~= "MANA" then return end
	local mana = br.game.UnitPower("player", 0)
	if not usable(mana) then return end
	if f.lastMana then
		local change = mana - f.lastMana
		if change < 0 then
			f.manaSpent = f.manaSpent - change
			f.lastDrop = { amount = -change, at = GetTime(), toZero = mana == 0 }
		else
			f.manaGained = f.manaGained + change
		end
	end
	f.lastMana = mana
end)

-- The mana a spell cast cost (0 for none), by its rank's own ID
local function manaCost(spellID)
	local power = br.functions.power
	if type(spellID) ~= "number" or power == nil then return 0 end
	return power:getManaCostFromRef(spellID) or 0
end

local DAMAGE_AT = { SWING_DAMAGE = 12, RANGE_DAMAGE = 15, SPELL_DAMAGE = 15, SPELL_PERIODIC_DAMAGE = 15,
	DAMAGE_SHIELD = 15, DAMAGE_SPLIT = 15, ENVIRONMENTAL_DAMAGE = 13 }
local HEAL = { SPELL_HEAL = true, SPELL_PERIODIC_HEAL = true }

--- One combat log event, as the combat log reader read it (System/Readers/combatlog.lua dispatch)
function fights:combatEvent(...)
	local f = current
	local _, event, _, sourceGUID, _, sourceFlags, _, destGUID, _, destFlags = ...
	-- Your casts, in the fight or between fights (auto attack and Auto Shot aren't casts)
	if event == "SPELL_CAST_SUCCESS" and sourceGUID ~= nil and sourceGUID == (playerGUID or br.game.UnitGUID("player")) then
		local spellID = select(12, ...)
		local shared = br.lists.spells and br.lists.spells.Shared and br.lists.spells.Shared.Shared
		local abilities = shared and shared.abilities or {}
		if spellID == abilities.autoAttack or spellID == abilities.autoShot then return end
		local spellName, cost = name(select(13, ...)), manaCost(spellID)
		if f ~= nil and not f.ended then
			f.casts[spellName] = (f.casts[spellName] or 0) + 1
			if cost > 0 then f.castMana[spellName] = (f.castMana[spellName] or 0) + cost end
		else
			rest.casts[spellName] = (rest.casts[spellName] or 0) + 1
			rest.mana = rest.mana + cost
		end
		return
	end
	if f == nil or f.ended then return end
	local at = DAMAGE_AT[event]
	if at then
		local amount, overkill = select(at, ...)
		if destGUID == playerGUID then
			if usable(amount) then f.taken = f.taken + amount else f.hidden = f.hidden + 1 end
		end
		if type(sourceFlags) ~= "number" or br.game.bit.band(sourceFlags, MINE) == 0 or event == "ENVIRONMENTAL_DAMAGE" then return end
		if not (usable(amount) and usable(overkill)) then f.hidden = f.hidden + 1; return end
		local effective = amount - math.max(overkill or 0, 0)
		local spellName = event == "SWING_DAMAGE" and "Melee" or name(select(13, ...))
		if sourceGUID ~= playerGUID then
			f.petDamage = f.petDamage + effective
			spellName = "pet " .. spellName
		end
		f.damage = f.damage + effective
		f.bySpell[spellName] = (f.bySpell[spellName] or 0) + effective
	elseif HEAL[event] then
		if type(sourceFlags) ~= "number" or br.game.bit.band(sourceFlags, MINE) == 0 then return end
		local amount, overhealing = select(15, ...)
		if not (usable(amount) and usable(overhealing)) then f.hidden = f.hidden + 1; return end
		local over = math.max(overhealing or 0, 0)
		f.healing = f.healing + amount - over
		f.overhealing = f.overhealing + over
	elseif event == "UNIT_DIED" then
		if destGUID == playerGUID then
			f.deaths = f.deaths + 1
			-- Dying empties the mana bar: that drop wasn't spent (2026-10-26: 201 mana "spent" with 0 casts)
			local drop = f.lastDrop
			if drop and drop.toZero and GetTime() - drop.at <= 1 then f.manaSpent = f.manaSpent - drop.amount end
		elseif type(destFlags) == "number" and br.game.bit.band(destFlags, GROUP) ~= 0 and br.game.bit.band(destFlags, PLAYER) ~= 0 then
			f.groupDeaths = f.groupDeaths + 1
		end
	end
end
