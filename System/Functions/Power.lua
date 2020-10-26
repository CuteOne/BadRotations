local runeTable = {}
function getChi(Unit)
	return UnitPower(Unit, 12)
end
function getChiMax(Unit)
	return UnitPowerMax(Unit, 12)
end
-- if getCombo() >= 1 then
function getCombo()
	return UnitPower("player", 4) --GetComboPoints("player") - Legion Change
end
function getEmber(Unit)
	return UnitPower(Unit, 14)
end
function getEmberMax(Unit)
	return UnitPowerMax(Unit, 14)
end
-- if getMana("target") <= 15 then
function getMana(Unit)
	return 100 * UnitPower(Unit, 0) / UnitPowerMax(Unit, 0)
end
-- if getPower("target") <= 15 then
function getPower(Unit, index)
	local value = value
	if select(3, UnitClass("player")) == 11 or select(3, UnitClass("player")) == 4 then
		if --[[UnitBuffID("player", 106951) or]] UnitBuffID("player", 102543) then
			value = UnitPower(Unit, index) * 1.2
		else
			value = UnitPower(Unit, index)
		end
	else
		value = UnitPower(Unit, index) -- 100 * UnitPower(Unit) / UnitPowerMax(Unit)
	end
	return UnitPower(Unit, index)
end
function getPowerMax(Unit, index)
	local value = value
	if select(3, UnitClass("player")) == 11 or select(3, UnitClass("player")) == 4 then
		if --[[UnitBuffID("player", 106951) or]] UnitBuffID("player", 102543) then
			value = UnitPowerMax(Unit, index) * 1.2
		else
			value = UnitPowerMax(Unit, index)
		end
	else
		value = UnitPowerMax(Unit, index) -- 100 * UnitPower(Unit) / UnitPowerMax(Unit)
	end
	return UnitPowerMax(Unit, index)
end
function getPowerAlt(Unit)
	local value = value
	local class = select(2, UnitClass(Unit))
	local spec = GetSpecialization()
	local power = UnitPower
	if (class == "DRUID" and spec == 2) or class == "ROGUE" then
		return power(Unit, 4)
	end
	if class == "DEATHKNIGHT" then
		return power(Unit, 5)
	end
	if class == "WARLOCK" then
		return power(Unit, 7)
	end
	return 0
end
-- Rune Tracking Table
function getRuneInfo()
	local bCount = 0
	local uCount = 0
	local fCount = 0
	local dCount = 0
	local bPercent = 0
	local uPercent = 0
	local fPercent = 0
	local dPercent = 0
	table.wipe(runeTable)
	for i = 1, 6 do
		local CDstart = select(1, GetRuneCooldown(i))
		local CDduration = select(2, GetRuneCooldown(i))
		local CDready = select(3, GetRuneCooldown(i))
		local CDrune = CDduration - (GetTime() - CDstart)
		local CDpercent = CDpercent
		local runePercent = 0
		local runeCount = 0
		local runeCooldown = 0
		if CDrune > CDduration then
			CDpercent = 1 - (CDrune / (CDduration * 2))
		else
			CDpercent = 1 - CDrune / CDduration
		end
		if not CDready then
			runePercent = CDpercent
			runeCount = 0
			runeCooldown = CDrune
		else
			runePercent = 1
			runeCount = 1
			runeCooldown = 0
		end
		if GetRuneType(i) == 4 then
			dPercent = runePercent
			dCount = runeCount
			dCooldown = runeCooldown
			runeTable[#runeTable + 1] = {Type = "death", Index = i, Count = dCount, Percent = dPercent, Cooldown = dCooldown}
		end
		if GetRuneType(i) == 1 then
			bPercent = runePercent
			bCount = runeCount
			bCooldown = runeCooldown
			runeTable[#runeTable + 1] = {Type = "blood", Index = i, Count = bCount, Percent = bPercent, Cooldown = bCooldown}
		end
		if GetRuneType(i) == 2 then
			uPercent = runePercent
			uCount = runeCount
			uCooldown = runeCooldown
			runeTable[#runeTable + 1] = {Type = "unholy", Index = i, Count = uCount, Percent = uPercent, Cooldown = uCooldown}
		end
		if GetRuneType(i) == 3 then
			fPercent = runePercent
			fCount = runeCount
			fCooldown = runeCooldown
			runeTable[#runeTable + 1] = {Type = "frost", Index = i, Count = fCount, Percent = fPercent, Cooldown = fCooldown}
		end
	end
	return runeTable
end
-- Get Count of Specific Rune Time
function getRuneCount(Type)
	local Type = string.lower(Type)
	local runeCount = 0
	for i = 1, 6 do
		if runeTable[i].Type == Type then
			runeCount = runeCount + runeTable[i].Count
		end
	end
	return runeCount
end
-- Get Colldown Percent Remaining of Specific Runes
function getRunePercent(Type)
	Type = string.lower(Type)
	local runePercent = 0
	local runeCooldown = 0
	for i = 1, 6 do
		if runeTable[i].Type == Type then --and runeTable[i].Cooldown > runeCooldown then
			runePercent = runeTable[i].Percent
			runeCooldown = runeTable[i].Cooldown
		end
	end
	if getRuneCount(Type) == 2 then
		return 2
	elseif getRuneCount(Type) == 1 then
		return runePercent + 1
	else
		return runePercent
	end
end
function runeCDPercent(runeIndex)
	if GetRuneCount(runeIndex) == 0 then
		return (GetTime() - select(1, GetRuneCooldown(runeIndex))) / select(2, GetRuneCooldown(runeIndex))
	else
		return 0
	end
end
function runeRecharge(runeIndex)
	if not select(3, GetRuneCooldown(runeIndex)) then
		return select(2, GetRuneCooldown(runeIndex)) - (GetTime() - select(1, GetRuneCooldown(runeIndex)))
	else
		return 0
	end
end
function runeTimeTill(runeIndex)
	local runeCDs = {}
	local runeCount = 0
	local timeTill = 0
	for i = 1, 6 do
		runeCount = runeCount + GetRuneCount(i)
		if runeCDs[runeIndex] == nil then
			runeCDs[i] = runeRecharge(i)
		end
	end
	if runeCount < runeIndex then
		for k, v in pairs(runeCDs) do
			timeTill = timeTill + v
		end
	end
	return timeTill
end
-- if getTimeToMax("player") < 3 then
function getTimeToMax(Unit,Limit)
	local timeTill = 999
	local max = Limit or UnitPowerMax(Unit)
	local curr = UnitPower(Unit)
	local curr2 = curr
	local _, regen = GetPowerRegen(Unit)
	if select(3, UnitClass("player")) == 11 and GetSpecialization() == 2 and isKnown(114107) then
		curr2 = curr + 4 * getCombo()
	end
	timeTill = (curr2 > max) and 0 or (max - curr2) * (1.0 / regen)
	return timeTill
end
-- /dump getCastRegen(185358)
function getCastRegen(spellId)
	local regenRate = GetPowerRegen("player")
	local power = 0

	-- Get the "execute time" of the spell (larger of GCD or the cast time).
	local castTime = getCastTime(spellId) or 0
	local gcd = getSpellCD(61304)
	if gcd == 0 then
		gcd = max(1, 1.5 / (1 + UnitSpellHaste("player") / 100))
	end
	local castSeconds = (castTime > gcd) and castTime or gcd
	power = power + regenRate * castSeconds

	return power
end
-- if getRegen("player") > 15 then
function getRegen(Unit)
	return select(2, GetPowerRegen(Unit))
end
function getSpellCost(spell)
	local t = GetSpellPowerCost(GetSpellInfo(spell))
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

function hasResources(spell, offset)
	local cost, _, costtype = getSpellCost(spell)
	offset = offset or 0
	if not cost then
		return false
	elseif cost == 0 then
		return true
	elseif UnitPower("player", costtype) > cost + offset then
		return true
	end
end
