local _, br = ...
local runeTable = {}
function br.getChi(Unit)
	return br._G.UnitPower(Unit, 12)
end
function br.getChiMax(Unit)
	return br._G.UnitPowerMax(Unit, 12)
end
-- if getCombo() >= 1 then
function br.getCombo()
	return br._G.UnitPower("player", 4) --GetComboPoints("player") - Legion Change
end
function br.getEmber(Unit)
	return br._G.UnitPower(Unit, 14)
end
function br.getEmberMax(Unit)
	return br._G.UnitPowerMax(Unit, 14)
end
-- if getMana("target") <= 15 then
function br.getMana(Unit)
	return 100 * br._G.UnitPower(Unit, 0) / br._G.UnitPowerMax(Unit, 0)
end
-- if br.getPower("target") <= 15 then
function br.getPower(Unit, index)
	local value = br._G.UnitPower(Unit, index)
	if select(3, br._G.UnitClass("player")) == 11 or select(3, br._G.UnitClass("player")) == 4 then
		if --[[br.UnitBuffID("player", 106951) or]] br.UnitBuffID("player", 102543) then
			value = br._G.UnitPower(Unit, index) * 1.2
		end
	end
	return value
end
function br.getPowerMax(Unit, index)
	local value = br._G.UnitPowerMax(Unit, index)
	if select(3, br._G.UnitClass("player")) == 11 or select(3, br._G.UnitClass("player")) == 4 then
		if --[[br.UnitBuffID("player", 106951) or]] br.UnitBuffID("player", 102543) then
			value = br._G.UnitPowerMax(Unit, index) * 1.2
		end
	end
	return value
end
function br.getPowerAlt(Unit)
	local value = 0
	local class = select(2, br._G.UnitClass(Unit))
	local spec = br._G.GetSpecialization()
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
	return value
end
-- Rune Tracking Table
function br.getRuneInfo()
	local bCount = 0
	local uCount = 0
	local fCount = 0
	local dCount = 0
	local bPercent = 0
	local uPercent = 0
	local fPercent = 0
	local dPercent = 0
	_G.table.wipe(runeTable)
	for i = 1, 6 do
		local CDstart = select(1, br._G.GetRuneCooldown(i))
		local CDduration = select(2, br._G.GetRuneCooldown(i))
		local CDready = select(3, br._G.GetRuneCooldown(i))
		local CDrune = CDduration - (br._G.GetTime() - CDstart)
		local CDpercent = 0
		local runePercent = 0
		local runeCount = 0
		local runeCooldown = 0
		local dCooldown
		local bCooldown
		local uCooldown
		local fCooldown
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
		if br._G.GetRuneType(i) == 4 then
			dPercent = runePercent
			dCount = runeCount
			dCooldown = runeCooldown
			runeTable[#runeTable + 1] = {Type = "death", Index = i, Count = dCount, Percent = dPercent, Cooldown = dCooldown}
		end
		if br._G.GetRuneType(i) == 1 then
			bPercent = runePercent
			bCount = runeCount
			bCooldown = runeCooldown
			runeTable[#runeTable + 1] = {Type = "blood", Index = i, Count = bCount, Percent = bPercent, Cooldown = bCooldown}
		end
		if br._G.GetRuneType(i) == 2 then
			uPercent = runePercent
			uCount = runeCount
			uCooldown = runeCooldown
			runeTable[#runeTable + 1] = {Type = "unholy", Index = i, Count = uCount, Percent = uPercent, Cooldown = uCooldown}
		end
		if br._G.GetRuneType(i) == 3 then
			fPercent = runePercent
			fCount = runeCount
			fCooldown = runeCooldown
			runeTable[#runeTable + 1] = {Type = "frost", Index = i, Count = fCount, Percent = fPercent, Cooldown = fCooldown}
		end
	end
	return runeTable
end
-- Get Count of Specific Rune Time
function br.getRuneCount(Type)
	Type = string.lower(Type)
	local runeCount = 0
	for i = 1, 6 do
		if runeTable[i].Type == Type then
			runeCount = runeCount + runeTable[i].Count
		end
	end
	return runeCount
end
-- Get Colldown Percent Remaining of Specific Runes
function br.getRunePercent(Type)
	Type = string.lower(Type)
	local runePercent = 0
	local runeCooldown = 0
	for i = 1, 6 do
		if runeTable[i].Type == Type then --and runeTable[i].Cooldown > runeCooldown then
			runePercent = runeTable[i].Percent
			runeCooldown = runeTable[i].Cooldown
		end
	end
	if br.getRuneCount(Type) == 2 then
		return 2
	elseif br.getRuneCount(Type) == 1 then
		return runePercent + 1
	else
		return runePercent
	end
end
function br.runeCDPercent(runeIndex)
	if br._G.GetRuneCount(runeIndex) == 0 then
		return (br._G.GetTime() - select(1, br._G.GetRuneCooldown(runeIndex))) / select(2, br._G.GetRuneCooldown(runeIndex))
	else
		return 0
	end
end
function br.runeRecharge(runeIndex)
	if not select(3, br._G.GetRuneCooldown(runeIndex)) then
		return select(2, br._G.GetRuneCooldown(runeIndex)) - (br._G.GetTime() - select(1, br._G.GetRuneCooldown(runeIndex)))
	else
		return 0
	end
end
function br.runeTimeTill(runeIndex)
	local runeCDs = {}
	local runeCount = 0
	local timeTill = 0
	for i = 1, 6 do
		runeCount = runeCount + br._G.GetRuneCount(i)
		if runeCDs[runeIndex] == nil then
			runeCDs[i] = br.runeRecharge(i)
		end
	end
	if runeCount < runeIndex then
		for _, v in pairs(runeCDs) do
			timeTill = timeTill + v
		end
	end
	return timeTill
end
-- if getTimeToMax("player") < 3 then
function br.getTimeToMax(Unit,Limit)
	local timeTill = 999
	local max = Limit or br._G.UnitPowerMax(Unit)
	local curr = br._G.UnitPower(Unit)
	local curr2 = curr
	local _, regen = br._G.GetPowerRegen(Unit)
	if select(3, br._G.UnitClass("player")) == 11 and br._G.GetSpecialization() == 2 and br.isKnown(114107) then
		curr2 = curr + 4 * br.getCombo()
	end
	timeTill = (curr2 > max) and 0 or (max - curr2) * (1.0 / regen)
	return timeTill
end
-- /dump getCastRegen(185358)
function br.getCastRegen(spellId)
	local regenRate = br._G.GetPowerRegen("player")
	local power = 0

	-- Get the "execute time" of the spell (larger of GCD or the cast time).
	local castTime = br.getCastTime(spellId) or 0
	local gcd = br.getSpellCD(61304)
	if gcd == 0 then
		gcd = _G.max(1, 1.5 / (1 + br._G.UnitSpellHaste("player") / 100))
	end
	local castSeconds = (castTime > gcd) and castTime or gcd
	power = power + regenRate * castSeconds

	return power
end
-- if br.getRegen("player") > 15 then
function br.getRegen(Unit)
	return select(2, br._G.GetPowerRegen(Unit))
end
function br.getSpellCost(spell)
	local t = br._G.GetSpellPowerCost(br._G.GetSpellInfo(spell))
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

function br.hasResources(spell, offset)
	local cost, _, costtype = br.getSpellCost(spell)
	offset = offset or 0
	if not cost then
		return false
	elseif cost == 0 then
		return true
	elseif br._G.UnitPower("player", costtype) > cost + offset then
		return true
	end
end
