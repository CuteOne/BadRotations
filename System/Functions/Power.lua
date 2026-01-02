local _, br = ...
br.functions.power = br.functions.power or {}
local power = br.functions.power
local runeTable = {}

function power:getChi(Unit)
	return br._G.UnitPower(Unit, 12)
end

function power:getChiMax(Unit)
	return br._G.UnitPowerMax(Unit, 12)
end

-- if getCombo() >= 1 then
function power:getCombo(thisUnit)
	if thisUnit == nil then thisUnit = "target" end
	return br._G.GetComboPoints("player", thisUnit) --GetComboPoints("player") - Legion Change
end

function power:getEmber(Unit)
	return br._G.UnitPower(Unit, 14)
end

function power:getEmberMax(Unit)
	return br._G.UnitPowerMax(Unit, 14)
end

-- if getMana("target") <= 15 then
function power:getMana(Unit)
	return 100 * br._G.UnitPower(Unit, 0) / br._G.UnitPowerMax(Unit, 0)
end

function power:getEssence(Unit)
	return br._G.UnitPower(Unit, 19)
end

function power:getEssenceMax(Unit)
	return br._G.UnitPowerMax(Unit, 19)
end

-- if br.functions.power:getPower("target") <= 15 then
function power:getPower(Unit, index)
	local value = index == 4 and br._G.GetComboPoints("player", Unit) or br._G.UnitPower(Unit, index)
	-- Only apply Druid buffs to energy (index 3)
	if index == 3 and select(3, br._G.UnitClass("player")) == 11 then
		-- Druid: Berserk affects energy values report as having 50% more
		if br.functions.aura:UnitBuffID("player", 106951) then
			value = value * 5
		end
	end
	return value
end

function power:getPowerMax(Unit, index)
	local value = br._G.UnitPowerMax(Unit, index)
	-- Only apply Druid buffs to energy (index 3)
	if index == 3 and select(3, br._G.UnitClass("player")) == 11 then
		-- Druid: Berserk halves costs -> treat energy max as doubled for checks
		if br.functions.aura:UnitBuffID("player", 106951) then
            value = value * 2
        end
	end
	return value
end

function power:getPowerAlt(Unit)
	local value = 0
	local class = select(2, br._G.UnitClass(Unit))
	local spec = br._G.C_SpecializationInfo.GetSpecialization()
	local power = br._G.UnitPower
	if (class == "DRUID" and spec == 2) or class == "ROGUE" then
		value = power(Unit, 4)
	end
	if class == "DEATHKNIGHT" then
		value = power(Unit, 5)
	end
	if class == "WARLOCK" then
		value = power(Unit, 7)
	end
	if class == "EVOKER" then
		value = power(Unit, 19)
	end
	return value
end

-- Return array of 6 rune objects suitable for SimC-style logic
-- rune object: { base = "blood"|"frost"|"unholy", is_death = bool, ready = bool }
function power:getRuneObjects()
	local runes = {}
	for i = 1, 6 do
		local rt = br._G.GetRuneType(i)
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
		local start, duration, ready = br._G.GetRuneCooldown(i)
		runes[i] = { base = base, is_death = is_death, ready = ready }
	end
	return runes
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

-- Get Colldown Percent Remaining of Specific Runes
function power:getRunePercent(Type)
	-- Compute percent using per-rune cooldowns; include death runes for base types
	Type = string.lower(Type or "")
	if Type == "" then return 0 end

	local include_death = (Type == "blood" or Type == "frost" or Type == "unholy")
	local readyCount = 0
	local maxCooldownPercent = 0
	local timeNow = br._G.GetTime()

	for i = 1, 6 do
		local start, duration, ready = br._G.GetRuneCooldown(i)
		local rt = br._G.GetRuneType(i)
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

function power:runeCDPercent(runeIndex)
	local start, duration, ready = br._G.GetRuneCooldown(runeIndex)
	if start == nil or duration == 0 then
		return 0
	end
	if not ready then
		return (br._G.GetTime() - start) / duration
	else
		return 0
	end
end

function power:runeRecharge(runeIndex)
	local start, duration, ready = br._G.GetRuneCooldown(runeIndex)
	if not ready and duration and duration > 0 and start then
		return duration - (br._G.GetTime() - start)
	else
		return 0
	end
end

function power:runeTimeTill(runeIndex)
	local runeCDs = {}
	local runeCount = 0
	local timeTill = 0
	for i = 1, 6 do
		local start, duration, ready = br._G.GetRuneCooldown(i)
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

-- Count total ready runes (simple helper)
function power:getTotalReadyRunes()
	local total = 0
	for i = 1, 6 do
		local _, _, ready = br._G.GetRuneCooldown(i)
		if ready then total = total + 1 end
	end
	return total
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

-- Fractional rune value used by DKs: ready runes + highest CD percent
function power:getRuneFrac()
	return power:getTotalReadyRunes() + power:getMaxRuneCDPercent()
end

-- if getTimeToMax("player") < 3 then
function power:getTimeToMax(Unit, Limit)
	local timeTill = 999
	local max = Limit or br._G.UnitPowerMax(Unit)
	local curr = br._G.UnitPower(Unit)
	local curr2 = curr
	local _, regen = br._G.GetPowerRegen(Unit)
	if select(3, br._G.UnitClass("player")) == 11 and br._G.C_SpecializationInfo.GetSpecialization() == 2 and br.functions.spell:isKnown(114107) then
		curr2 = curr + 4 * br.functions.power:getCombo()
	end
	timeTill = (curr2 > max) and 0 or (max - curr2) * (1.0 / regen)
	return timeTill
end

-- /dump getCastRegen(185358)
function power:getCastRegen(spellId)
	local regenRate = br._G.GetPowerRegen("player")
	local power = 0

	-- Get the "execute time" of the spell (larger of GCD or the cast time).
	local castTime = br.functions.cast:getCastTime(spellId) or 0
	local gcd = br.functions.spell:getSpellCD(61304)
	if gcd == 0 then
		gcd = br._G.max(1, 1.5 / (1 + br._G.UnitSpellHaste("player") / 100))
	end
	local castSeconds = (castTime > gcd) and castTime or gcd
	power = power + regenRate * castSeconds

	return power
end

-- if br.functions.power:getRegen("player") > 15 then
function power:getRegen(Unit)
	return select(2, br._G.GetPowerRegen(Unit))
end

function power:getSpellCost(spell)
	local spellName = br._G.GetSpellInfo(spell) or ""
	local t = br._G.C_Spell.GetSpellPowerCost(spellName)
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

function power:hasResources(spell, offset)
	local cost, _, costtype = br.functions.power:getSpellCost(spell)
	offset = offset or 0
	if not cost then
		return false
	elseif cost == 0 then
		return true
	elseif br._G.UnitPower("player", costtype) > cost + offset then
		return true
	end
end
