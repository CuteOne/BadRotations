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
	if select(3, br._G.UnitClass("player")) == 11 or select(3, br._G.UnitClass("player")) == 4 then
		-- Druid: Incarnation affects all energy values report as having 20% more
		if br.functions.aura:UnitBuffID("player", 102543) then
			value = value * 1.2
		end
		if br.functions.aura:UnitBuffID("player", 106951) then
			-- Druid: Berserk affects energy values report as having 50% more
			value = value * 5
		end
	end
	return value
end

function power:getPowerMax(Unit, index)
	local value = br._G.UnitPowerMax(Unit, index)
	if select(3, br._G.UnitClass("player")) == 11 or select(3, br._G.UnitClass("player")) == 4 then
		-- Druid: Incarnation affects all energy values report as having 20% more
		if br.functions.aura:UnitBuffID("player", 102543) then
			value = value * 1.2
		end
		if br.functions.aura:UnitBuffID("player", 106951) then
            -- Druid: Berserk halves costs -> treat energy max as doubled for checks
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

-- Rune Tracking Table
function power:getRuneInfo()
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
			runeTable[#runeTable + 1] = {
				Type = "death",
				Index = i,
				Count = dCount,
				Percent = dPercent,
				Cooldown =
					dCooldown
			}
		end
		if br._G.GetRuneType(i) == 1 then
			bPercent = runePercent
			bCount = runeCount
			bCooldown = runeCooldown
			runeTable[#runeTable + 1] = {
				Type = "blood",
				Index = i,
				Count = bCount,
				Percent = bPercent,
				Cooldown =
					bCooldown
			}
		end
		if br._G.GetRuneType(i) == 2 then
			uPercent = runePercent
			uCount = runeCount
			uCooldown = runeCooldown
			runeTable[#runeTable + 1] = {
				Type = "unholy",
				Index = i,
				Count = uCount,
				Percent = uPercent,
				Cooldown =
					uCooldown
			}
		end
		if br._G.GetRuneType(i) == 3 then
			fPercent = runePercent
			fCount = runeCount
			fCooldown = runeCooldown
			runeTable[#runeTable + 1] = {
				Type = "frost",
				Index = i,
				Count = fCount,
				Percent = fPercent,
				Cooldown =
					fCooldown
			}
		end
	end
	return runeTable
end

-- Get Count of Specific Rune Time
function power:getRuneCount(Type)
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
function power:getRunePercent(Type)
	Type = string.lower(Type)
	local runePercent = 0
	-- local runeCooldown = 0
	for i = 1, 6 do
		if runeTable[i].Type == Type then --and runeTable[i].Cooldown > runeCooldown then
			runePercent = runeTable[i].Percent
			-- runeCooldown = runeTable[i].Cooldown
		end
	end
	if br.functions.power:getRuneCount(Type) == 2 then
		return 2
	elseif br.functions.power:getRuneCount(Type) == 1 then
		return runePercent + 1
	else
		return runePercent
	end
end

function power:runeCDPercent(runeIndex)
	if br._G.GetRuneCount(runeIndex) == 0 then
		return (br._G.GetTime() - select(1, br._G.GetRuneCooldown(runeIndex))) /
			select(2, br._G.GetRuneCooldown(runeIndex))
	else
		return 0
	end
end

function power:runeRecharge(runeIndex)
	if not select(3, br._G.GetRuneCooldown(runeIndex)) then
		return select(2, br._G.GetRuneCooldown(runeIndex)) -
			(br._G.GetTime() - select(1, br._G.GetRuneCooldown(runeIndex)))
	else
		return 0
	end
end

function power:runeTimeTill(runeIndex)
	local runeCDs = {}
	local runeCount = 0
	local timeTill = 0
	for i = 1, 6 do
		runeCount = runeCount + br._G.GetRuneCount(i)
		if runeCDs[runeIndex] == nil then
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
