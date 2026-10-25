local _, br = ...
---@class br.functions.power
br.functions.power = br.functions.power or {}
local power = br.functions.power

-- if getCombo() >= 1 then
function power:getCombo(thisUnit)
	if thisUnit == nil then thisUnit = "target" end
	return br.game.GetComboPoints("player", thisUnit) --GetComboPoints("player") - Legion Change
end

-- Mana cost of a spell reference (id, name, or BR spell table); 0 if free, not mana, or treatAsFree.
-- local cost = br.functions.power:getManaCostFromRef(br.rotation.spells.regrowth)
function power:getManaCostFromRef(spellRef, treatAsFree)
	if treatAsFree then return 0 end
	local id = br.functions.spell:getSpellIdFromRef(spellRef)
	if id == nil then return 0 end
	local cost, _, costType = br.functions.power:getSpellCost(id)
	if not cost or cost <= 0 then return 0 end
	-- Mana is power type 0.
	if costType ~= 0 then return 0 end
	return cost
end

-- Return the maximum rune cooldown percent among all runes (0..1)
function power:getMaxRuneCDPercent()
	local maxPct = 0
	for i = 1, 6 do
		local pct = power:runeCDPercent(i)
		if pct > maxPct then maxPct = pct end
	end
	return maxPct
end

-- if br.functions.power:getPower("target") <= 15 then
-- The unit's power of that type (index 4: the player's combo points on the unit), as the game reports it.
-- Clearcasting and similar free casts are the cast engine's concern, not a different power value.
function power:getPower(Unit, index)
	if index == 4 then return br.game.GetComboPoints("player", Unit) end
	return br.game.UnitPower(Unit, index)
end

function power:getPowerMax(Unit, index)
	return br.game.UnitPowerMax(Unit, index)
end

-- The unit's power type as a lowercase name ("energy", "rage", "mana", ...), matching the profile API's power keys
function power:getPowerTypeName(Unit)
	local _, token = br.game.UnitPowerType(Unit or "player")
	return token and token:lower()
end

-- if br.functions.power:getRegen("player") > 15 then
function power:getRegen(Unit)
	return select(2, br.game.GetPowerRegen(Unit))
end

-- Get Count of Specific Rune Time
function power:getRuneCount(Type)
	-- Use SimC-style counting: include death runes for base types
	Type = string.lower(Type or "")
	if Type == "" then return 0 end
	-- for death queries, return strict death count
	if Type == "death" then
		return power:runesCount("death", false)
	end
	-- for base types include death runes as usable
	if Type == "blood" or Type == "frost" or Type == "unholy" then
		return power:runesCount(Type, true)
	end
end

-- Fractional rune value used by DKs: ready runes + highest CD percent
function power:getRuneFrac()
	return power:getTotalReadyRunes() + power:getMaxRuneCDPercent()
end

-- Return array of 6 rune objects suitable for SimC-style logic
-- rune object: { base = "blood"|"frost"|"unholy", is_death = bool, ready = bool }
function power:getRuneObjects()
	local runes = {}
	for i = 1, 6 do
		local rt = br.game.GetRuneType(i)
		local is_death = (rt == 4)
		local base
		-- if i <= 2 then
		-- 	base = "blood"
		-- elseif i <= 4 then
		-- 	base = "frost"
		-- else
		-- 	base = "unholy"
		-- end
		if rt == 1 then
			base = "blood"
		elseif rt == 2 then
			base = "frost"
		elseif rt == 3 then
			base = "unholy"
		end
		local start, duration, ready = br.game.GetRuneCooldown(i)
		runes[i] = { base = base, is_death = is_death, ready = ready }
	end
	return runes
end

-- Get Colldown Percent Remaining of Specific Runes
function power:getRunePercent(Type)
	-- Compute percent using per-rune cooldowns; include death runes for base types
	Type = string.lower(Type or "")
	if Type == "" then return 0 end

	local include_death = (Type == "blood" or Type == "frost" or Type == "unholy")
	local readyCount = 0
	local maxCooldownPercent = 0
	local timeNow = br.game.GetTime()

	for i = 1, 6 do
		local start, duration, ready = br.game.GetRuneCooldown(i)
		local rt = br.game.GetRuneType(i)
		local base = (rt == 1) and "blood" or (rt == 2) and "frost" or (rt == 3) and "unholy"
		local is_match = false
		if Type == "death" then
			is_match = (rt == 4)
		else
			is_match = (base == Type) or (include_death and rt == 4)
		end
		if is_match then
			if ready then
				readyCount = readyCount + 1
			else
				if duration and duration > 0 and start then
					local CDrune = duration - (timeNow - start)
					local CDpercent
					if CDrune > duration then
						CDpercent = 1 - (CDrune / (duration * 2))
					else
						CDpercent = 1 - CDrune / duration
					end
					if CDpercent > maxCooldownPercent then maxCooldownPercent = CDpercent end
				end
			end
		end
	end

	if readyCount >= 2 then return 2 end
	if readyCount == 1 then return 1 + maxCooldownPercent end
	return maxCooldownPercent
end

-- Destruction Warlock soul shards with their fragments, as one number (3.4 = 3 shards, 4 fragments)
function power:getSoulShardFrac()
	local soulShards = br.game.Enum.PowerType.SoulShards
	local shardPower = br.game.UnitPower("player", soulShards, true)
	local shardModifier = br.game.UnitPowerDisplayMod(soulShards)
	local fragmentCount = (shardModifier ~= 0) and (shardPower / shardModifier) or 0
	return (shardPower + fragmentCount) / 10
end

function power:getSpellCost(spell)
	if spell == nil then
		return 0
	end

	local spellKey = spell
	if type(spell) == "table" then
		if type(spell.id) == "function" then
			local ok, value = pcall(spell.id)
			if ok and value ~= nil then
				spellKey = value
			end
		elseif type(spell.id) == "number" then
			spellKey = spell.id
		end
	end

	local t = br.game.C_Spell.GetSpellPowerCost(spellKey)
	if (not t or not t[1]) and type(spellKey) == "number" then
		-- Fallback for older clients/APIs that may prefer spellName.
		local spellName = br.functions.spell:getName(spellKey)
		if spellName then
			t = br.game.C_Spell.GetSpellPowerCost(spellName)
		end
	end
	if not t then
		return 0
	elseif not t[1] then
		return 0
	elseif not t[1]["minCost"] then
		return 0
	elseif not t[2] then
		return t[1]["minCost"], t[1]["cost"], t[1]["type"]
	elseif not t[2]["minCost"] then
		return t[1]["minCost"], t[1]["cost"], t[1]["type"]
	else
		return t[1]["minCost"], t[1]["cost"], t[1]["type"], t[2]["minCost"], t[2]["cost"]
	end
end

-- Every resource a spell costs right now, as a list of { type = power type, amount = cost }
-- (a spell can cost two, such as energy and combo points); costs of 0 are left out.
function power:getSpellCosts(spellID)
	local costs = {}
	local list = br.game.C_Spell.GetSpellPowerCost(spellID)
	if type(list) ~= "table" then return costs end
	for _, entry in ipairs(list) do
		local amount = entry.minCost or entry.cost or 0
		if entry.type ~= nil and amount > 0 then
			costs[#costs + 1] = { type = entry.type, amount = amount }
		end
	end
	return costs
end

-- if getTimeToMax("player") < 3 then
function power:getTimeToMax(Unit, Limit)
	local timeTill = 999
	local max = Limit or br.game.UnitPowerMax(Unit)
	local curr = br.game.UnitPower(Unit)
	local curr2 = curr
	local _, regen = br.game.GetPowerRegen(Unit)
	-- Feral's Soul of the Forest gives energy back per combo point spent
	local soulOfTheForest = br.rotation and br.rotation.spells and br.rotation.spells.soulOfTheForest
	if select(3, br.game.UnitClass("player")) == 11 and br.game.C_SpecializationInfo.GetSpecialization() == 2
		and soulOfTheForest and br.functions.spell:isKnown(soulOfTheForest)
	then
		curr2 = curr + 4 * br.functions.power:getCombo()
	end
	timeTill = (curr2 > max) and 0 or (max - curr2) * (1.0 / regen)
	return timeTill
end

-- Count total ready runes (simple helper)
function power:getTotalReadyRunes()
	local total = 0
	for i = 1, 6 do
		local _, _, ready = br.game.GetRuneCooldown(i)
		if ready then total = total + 1 end
	end
	return total
end

function power:runeCDPercent(runeIndex)
	local start, duration, ready = br.game.GetRuneCooldown(runeIndex)
	if start == nil or duration == 0 then
		return 0
	end
	if not ready then
		return (br.game.GetTime() - start) / duration
	else
		return 0
	end
end

function power:runeRecharge(runeIndex)
	local start, duration, ready = br.game.GetRuneCooldown(runeIndex)
	if not ready and duration and duration > 0 and start then
		return duration - (br.game.GetTime() - start)
	else
		return 0
	end
end

-- SimC-style rune counting
-- rt: "blood"|"frost"|"unholy"|"death"
-- include_death: bool - if true, death runes count toward base types
-- position: optional numeric positional query (1 or 2) for base types, or Nth death rune when rt=="death"
function power:runesCount(rt, include_death, position)
	rt = rt and string.lower(rt) or nil
	local runes = power:getRuneObjects()

	-- positional base-type query (e.g., second blood slot)
	if position and position > 0 and (rt == "blood" or rt == "frost" or rt == "unholy") then
		local ti = (rt == "blood") and 1 or (rt == "frost") and 2 or (rt == "unholy") and 3
		if not ti then return 0 end
		local idx = (ti - 1) * 2 + position -- Lua 1-based index
		local r = runes[idx]
		return (r and r.ready) and 1 or 0
	end

	local result = 0
	local rpc = 0
	for i = 1, 6 do
		local r = runes[i]
		-- positional death-query (nth death rune)
		if position and position ~= 0 and rt == "death" and r.is_death then
			rpc = rpc + 1
			if rpc == position then
				return r.ready and 1 or 0
			end

		else
			if ((include_death or rt == "death") and r.is_death) or (r.base == rt) then
				if r.ready then result = result + 1 end
			end
		end
	end

	return result
end

function power:runeTimeTill(runeIndex)
	local runeCDs = {}
	local runeCount = 0
	local timeTill = 0
	for i = 1, 6 do
		local start, duration, ready = br.game.GetRuneCooldown(i)
		if ready then
			runeCount = runeCount + 1
		else
			runeCDs[i] = br.functions.power:runeRecharge(i)
		end
	end
	if runeCount < runeIndex then
		for _, v in pairs(runeCDs) do
			timeTill = timeTill + v
		end
	end
	return timeTill
end
