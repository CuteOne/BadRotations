local _, br = ...
-- Targeting: BR's choice of which enemy to attack (dynamic targeting).
--
-- Once per frame every valid enemy within SCAN_RANGE that BR may attack is scored on one scale:
--   preference     the Wise Target choice (health or distance), up to W.preference
--   nearness       a tie-break, closer first
--   attackingMe    the unit attacks the player; attackingGroup: it attacks someone in the group
--   lostAggro      Tank Threat: the player is the tank and the unit attacks someone else
--   priority       skull (Skull First), totems (Prioritize Totems)
--   burn, shields, the profile's units.customTargetWeight: their own values
--   hold           the current target and BR's current focus, so a switch needs a clearly better unit
-- The focus is the best-scored unit overall; once chosen it is kept for HOLD_TIME. Each request
-- (range, facing) takes the focus when it can reach it, otherwise the best-scored unit it can reach,
-- so every spell in a tick agrees wherever it can. A request that reaches nothing gets nil.
-- The selected target and the targeting options are handled by enemiesEngineFunctions:dynamicTarget.
br.engines.targeting = br.engines.targeting or {}
local targeting = br.engines.targeting

local W = {
	preference = 20,
	nearness = 1,
	attackingMe = 40,
	attackingGroup = 15,
	lostAggro = 40,
	priority = 60,
	hold = 15,
}
local HOLD_TIME = 1.0  -- seconds a new focus is kept before another unit may replace it
local SCAN_RANGE = 50  -- yards; the enemies engine lists no further

local scoredAt          -- GetTime of the frame the scores are for
local scores = {}       -- unit -> score, for every unit BR may attack this frame
local distances = {}    -- unit -> distance (yards), measured with the scores
local focus, focusSince -- BR's overall choice and when it was made
local lastPick = {}     -- request key -> the unit it took last

-- Wise Target: 0..1 for how well the unit matches the chosen preference
local function preference(unit, mode, distance, mostHealth)
	if mode == 1 then return br.functions.unit:getHP(unit) / 100 end                -- Highest %
	if mode == 2 then return 1 - br.functions.unit:getHP(unit) / 100 end            -- Lowest %
	if mode == 3 then return mostHealth > 0 and br._G.UnitHealth(unit) / mostHealth or 0 end      -- abs Highest
	if mode == 4 then return mostHealth > 0 and 1 - br._G.UnitHealth(unit) / mostHealth or 0 end  -- abs Lowest
	if mode == 5 then return math.max(0, 1 - distance / SCAN_RANGE) end            -- Nearest
	if mode == 6 then return math.min(1, distance / SCAN_RANGE) end                 -- Furthest
	return 0
end

-- Whether BR may attack the unit at all (validity is the enemies engine's; this is the choosing rules)
local function attackable(unit, dontBreakCC, safeCheck)
	local unitFns = br.functions.unit
	if unitFns:isHeldBack(unit) or unitFns:isDummy(unit) then return false end
	if not br.functions.cast:isUnitVisible(unit) then return false end
	if dontBreakCC and br.functions.misc:isLongTimeCCed(unit) then return false end
	if safeCheck and not br.engines.enemiesEngineFunctions:isSafeToAttack(unit) then return false end
	return true
end

-- Scores every unit BR may attack, once per frame, and keeps or replaces the focus
local function refresh()
	local now = br._G.GetTime()
	if now == scoredAt then return end
	scoredAt = now
	br._G.wipe(scores)
	br._G.wipe(distances)
	local misc, ef = br.functions.misc, br.engines.enemiesEngineFunctions
	local mode = misc:getOptionCheck("Wise Target") and misc:getOptionValue("Wise Target") or nil
	local dontBreakCC, safeCheck = misc:getOptionCheck("Don't break CCs"), misc:getOptionCheck("Safe Damage Check")
	local skull, totems = misc:getOptionCheck("Skull First"), misc:isChecked("Prioritize Totems")
	local burn, shields = misc:getOptionCheck("Forced Burn"), misc:getOptionCheck("Avoid Shields")
	local tank = misc:getOptionCheck("Tank Threat") and br.functions.combat:isPlayerTank()
	local custom = br.player and br.player.units and br.player.units.customTargetWeight
	local playerPointer = br._G.ObjectPointer("player")
	local targetPointer = br._G.UnitExists("target") and br._G.ObjectPointer("target") or nil
	local group = {}
	for _, friend in ipairs(br.engines.healingEngine.friend or {}) do
		local pointer = br._G.ObjectPointer(friend.unit)
		if pointer and pointer ~= playerPointer then group[pointer] = true end
	end

	local units = {}
	for _, unit in ipairs(ef:getEnemies("player", SCAN_RANGE)) do
		if attackable(unit, dontBreakCC, safeCheck) then units[#units + 1] = unit end
	end
	local mostHealth = 0
	if mode == 3 or mode == 4 then
		for _, unit in ipairs(units) do mostHealth = math.max(mostHealth, br._G.UnitHealth(unit)) end
	end
	for _, unit in ipairs(units) do
		local distance = br.functions.range:getDistance(unit) or SCAN_RANGE
		distances[unit] = distance
		local score = W.preference * preference(unit, mode, distance, mostHealth)
			+ W.nearness * math.max(0, 1 - distance / SCAN_RANGE)
		local victim = br._G.UnitTarget(unit)
		if victim ~= nil and victim == playerPointer then
			score = score + W.attackingMe
		elseif victim ~= nil and group[victim] then
			score = score + W.attackingGroup
		end
		if tank and victim ~= nil and victim ~= playerPointer then score = score + W.lostAggro end
		if skull and br._G.GetRaidTargetIndex(unit) == 8 then score = score + W.priority end
		if totems and ef:isTotem(unit) then score = score + W.priority end
		if burn then score = score + ef:isBurnTarget(unit) end
		if shields then score = score + ef:getShieldCoefficient(unit) end
		if custom then
			local weight = custom(unit)
			if type(weight) == "number" then score = score + weight end
		end
		if unit == targetPointer then score = score + W.hold end
		scores[unit] = score
	end

	-- The focus: kept for HOLD_TIME, then replaced only by a clearly better unit
	if focus ~= nil and scores[focus] == nil then focus = nil end
	local best
	for unit, score in pairs(scores) do
		if best == nil or score > scores[best] then best = unit end
	end
	if best ~= nil and best ~= focus then
		if focus == nil or (now - focusSince >= HOLD_TIME and scores[best] > scores[focus] + W.hold) then
			focus, focusSince = best, now
		end
	end
end

--- The unit BR would attack with a request of this range (yards) and facing (true: units in front),
--- or nil when it reaches none. Ignores the selected target (see enemiesEngineFunctions:dynamicTarget).
function targeting:pick(range, facing)
	refresh()
	local key = range .. (facing and "f" or "")
	local best, bestScore
	for _, unit in ipairs(br.engines.enemiesEngineFunctions:getEnemies("player", range, false, facing)) do
		local score = scores[unit]
		if score ~= nil and distances[unit] < range then
			if unit == focus then
				lastPick[key] = unit
				return unit
			end
			if unit == lastPick[key] then score = score + W.hold end
			if best == nil or score > bestScore then best, bestScore = unit, score end
		end
	end
	lastPick[key] = best
	return best
end

--- BR's overall focus this frame and the scores (for /br target and diagnostics).
function targeting:getFocus()
	refresh()
	return focus, scores
end
