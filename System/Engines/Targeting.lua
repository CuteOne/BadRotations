local _, br = ...
-- Targeting: BR's choice of which enemy to attack (dynamic targeting).
--
-- Once per frame every valid enemy within SCAN_RANGE that BR may attack is scored on one scale:
--   preference     the Target Preference (health or distance), up to W.preference
--   nearDeath      Prefer Near Death: more the closer a unit below NEAR_DEATH health is to dying
--   nearness       a tie-break, closer first
--   attackingMe    the unit attacks the player; attackingGroup: it attacks someone in the group
--   lostAggro      Tank Threat: the player is the tank and the unit attacks someone else
--   priority       skull (Skull First), totems (Prioritize Totems)
--   burn           Forced Burn: W.priority plus the list entry's own weight
--   shields, the profile's weight (units.setTargetWeight -> targeting.customWeight): their own values
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
	nearDeath = 30,
	hold = 15,
}
local NEAR_DEATH = 20  -- health % below which Prefer Near Death weighs a unit more
local HOLD_TIME = 1.0  -- seconds a new focus is kept before another unit may replace it
local SCAN_RANGE = 50  -- yards; the enemies engine lists no further

local scoredAt          -- GetTime of the frame the scores are for
local scores = {}       -- unit -> score, for every unit BR may attack this frame
local distances = {}    -- unit -> distance (yards), measured with the scores
local priority = {}     -- unit -> "burn", "totem" or "skull" for priority units this frame (by option)
local focus, focusSince -- BR's overall choice and when it was made
local lastPick = {}     -- request key -> the unit it took last
local explaining        -- while explaining: unit -> { { part, value }, ... }
local unitScore, unitParts -- the unit being scored

-- Adds a part to the unit being scored (and to its explanation while explaining)
local function addPart(name, value)
	if value == 0 then return end
	unitScore = unitScore + value
	if unitParts then unitParts[#unitParts + 1] = { name, value } end
end

-- Target Preference: 0..1 for how well the unit matches it (mode: 1 Highest %, 2 Lowest %,
-- 3 Highest health, 4 Lowest health, 5 Nearest, 6 Furthest; the option's "None" is 0)
local function preference(unit, mode, distance, mostHealth)
	if mode == 1 then return br.functions.unit:getHP(unit) / 100 end                -- Highest %
	if mode == 2 then return 1 - br.functions.unit:getHP(unit) / 100 end            -- Lowest %
	if mode == 3 then return mostHealth > 0 and br.game.UnitHealth(unit) / mostHealth or 0 end      -- abs Highest
	if mode == 4 then return mostHealth > 0 and 1 - br.game.UnitHealth(unit) / mostHealth or 0 end  -- abs Lowest
	if mode == 5 then return math.max(0, 1 - distance / SCAN_RANGE) end            -- Nearest
	if mode == 6 then return math.min(1, distance / SCAN_RANGE) end                 -- Furthest
	return 0
end

-- Whether BR may attack the unit at all (validity is the enemies engine's; this is the choosing rules)
local function attackable(unit, dontBreakCC, safeCheck)
	local unitFns = br.functions.unit
	if unitFns:isHeldBack(unit) or unitFns:isDummy(unit) then return false end
	if not br.functions.cast:isUnitVisible(unit) then return false end
	if dontBreakCC and br.functions.misc:isCCProtected(unit) then return false end
	if safeCheck and not br.engines.enemiesEngineFunctions:isSafeToAttack(unit) then return false end
	return true
end

-- Scores every unit BR may attack, once per frame, and keeps or replaces the focus
local function refresh()
	local now = br.game.GetTime()
	if now == scoredAt then return end
	scoredAt = now
	br.game.wipe(scores)
	br.game.wipe(distances)
	br.game.wipe(priority)
	local misc, ef = br.functions.misc, br.engines.enemiesEngineFunctions
	local mode = misc:getOptionValue("Target Preference") - 1
	local nearDeath = misc:isChecked("Prefer Near Death")
	local dontBreakCC, safeCheck = misc:getOptionCheck("Don't break CCs"), misc:getOptionCheck("Safe Damage Check")
	local skull, totems = misc:getOptionCheck("Skull First"), misc:isChecked("Prioritize Totems")
	local burn, shields = misc:getOptionCheck("Forced Burn"), misc:getOptionCheck("Avoid Shields")
	local tank = misc:getOptionCheck("Tank Threat") and br.functions.combat:isPlayerTank()
	local custom = targeting.customWeight
	local targetPointer = br.game.UnitExists("target") and br.game.ObjectPointer("target") or nil

	local units = {}
	for _, unit in ipairs(ef:getEnemies("player", SCAN_RANGE)) do
		if attackable(unit, dontBreakCC, safeCheck) then units[#units + 1] = unit end
	end
	local mostHealth = 0
	if mode == 3 or mode == 4 then
		for _, unit in ipairs(units) do mostHealth = math.max(mostHealth, br.game.UnitHealth(unit)) end
	end
	for _, unit in ipairs(units) do
		local distance = br.functions.range:getDistance(unit) or SCAN_RANGE
		distances[unit] = distance
		-- the parts of the score are kept only while explaining (/br target)
		unitScore, unitParts = 0, explaining and {} or nil
		addPart("preference", W.preference * preference(unit, mode, distance, mostHealth))
		addPart("nearness", W.nearness * math.max(0, 1 - distance / SCAN_RANGE))
		-- Who it attacks, compared with UnitIsUnit: unlockers hand UnitTarget back as a pointer, GUID or
		-- token, which doesn't always equal ObjectPointer("player")
		local victim = br.game.UnitTarget(unit)
		local onPlayer = victim ~= nil and br.game.UnitIsUnit(victim, "player")
		if onPlayer then
			addPart("attacking you", W.attackingMe)
		elseif victim ~= nil and (br.game.UnitIsUnit(victim, "pet") or br.game.UnitInParty(victim) or br.game.UnitInRaid(victim)) then
			addPart("attacking your group", W.attackingGroup)
		end
		if tank and victim ~= nil and not onPlayer then addPart("lost aggro", W.lostAggro) end
		if nearDeath then
			local hp = br.functions.unit:getHP(unit)
			if hp < NEAR_DEATH then addPart("near death", W.nearDeath * (1 - hp / NEAR_DEATH)) end
		end
		if skull and br.game.GetRaidTargetIndex(unit) == 8 then
			addPart("skull", W.priority)
			priority[unit] = priority[unit] or "skull"
		end
		if totems and ef:isTotem(unit) then
			addPart("totem", W.priority)
			priority[unit] = priority[unit] or "totem"
		end
		-- a burn unit must die to prevent heavy damage: the top priority plus its own weight, so it
		-- beats ordinary reasons and takes over the focus when it appears mid-fight
		if burn then
			local burnWeight = ef:isBurnTarget(unit)
			if burnWeight > 0 then
				addPart("burn", W.priority + burnWeight)
				priority[unit] = "burn"
			end
		end
		if shields then addPart("shield", ef:getShieldCoefficient(unit)) end
		if custom then
			local weight = custom(unit)
			if type(weight) == "number" then addPart("profile weight", weight) end
		end
		if unit == targetPointer then addPart("your target", W.hold) end
		scores[unit] = unitScore
		if unitParts then explaining[unit] = unitParts end
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

--- The best priority unit (burn, totem with Prioritize Totems, skull with Skull First) a request of this
--- range and facing can reach, or nil. Priority units take spells even over a usable target
--- (enemiesEngineFunctions:dynamicTarget). burnOnly: only burn units (a target holding combo points).
function targeting:pickPriority(range, facing, burnOnly)
	refresh()
	if next(priority) == nil then return nil end
	local best
	for _, unit in ipairs(br.engines.enemiesEngineFunctions:getEnemies("player", range, false, facing)) do
		local kind = priority[unit]
		if kind and (not burnOnly or kind == "burn") and distances[unit] < range
			and (best == nil or scores[unit] > scores[best])
		then
			best = unit
		end
	end
	return best
end

--- True for a priority unit this frame (see targeting:pickPriority).
function targeting:isPriority(unit)
	refresh()
	return priority[unit] ~= nil
end

--- BR's overall focus this frame and the scores (for /br target and diagnostics).
function targeting:getFocus()
	refresh()
	return focus, scores
end

--- The current scores, explained: BR's focus and every unit it may attack, best first, each as
--- { unit = , score = , distance = , parts = { { name, value }, ... } } (for /br target).
function targeting:explain()
	explaining, scoredAt = {}, nil
	refresh()
	local list = {}
	for unit, score in pairs(scores) do
		list[#list + 1] = { unit = unit, score = score, distance = distances[unit], parts = explaining[unit] or {} }
	end
	explaining = nil
	table.sort(list, function(x, y) return x.score > y.score end)
	return focus, list
end

