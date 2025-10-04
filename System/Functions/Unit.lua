local _, br = ...
br.functions.unit = br.functions.unit or {}
local unit = br.functions.unit

function unit:GetObjectExists(Unit)
	if Unit == nil then return false end
	return br.functions.unit:GetUnitIsVisible(Unit)
end

function unit:GetUnit(Unit)
	if Unit ~= nil and br.functions.unit:GetObjectExists(Unit) then
		return Unit
	end
	return nil
end

function unit:GetUnitIsUnit(Unit, otherUnit)
	if not br.functions.unit:GetUnitIsVisible(Unit) or not br.functions.unit:GetUnitIsVisible(otherUnit) then return false end
	return br._G.UnitIsUnit(Unit, otherUnit)
end

function unit:GetUnitReaction(Unit, otherUnit)
	if not br.functions.unit:GetUnitIsVisible(Unit) or not br.functions.unit:GetUnitIsVisible(otherUnit) then return 10 end
	return br._G.UnitReaction(Unit, otherUnit)
end

function unit:GetUnitIsFriend(Unit, otherUnit)
	if not br.functions.unit:GetUnitIsVisible(Unit) or not br.functions.unit:GetUnitIsVisible(otherUnit) then return false end
	return br._G.UnitIsFriend(Unit, otherUnit)
end

function unit:GetUnitExists(Unit)
	if Unit == nil then return false end
	return br._G.UnitExists(Unit)
end

function unit:GetUnitIsVisible(Unit)
	if Unit == nil then return false end
	return br._G.UnitIsVisible(Unit)
end

function unit:GetUnitIsDeadOrGhost(Unit)
	if Unit == nil then return false end
	return br._G.UnitIsDeadOrGhost(Unit)
end

function unit:GetObjectFacing(Unit)
	if br.unlocked and br.functions.unit:GetObjectExists(Unit) then
		return br._G.ObjectFacing(Unit)
	else
		return 0
	end
end

function unit:GetObjectPosition(Unit)
	local x, y, z = 0, 0, 0
	if br.unlocked then --EWT then
		if Unit == nil then return br._G.ObjectPosition("player") end
		if br.functions.unit:GetObjectExists(Unit) then
			x, y, z = br._G.ObjectPosition(Unit)
		end
	end
	return x, y, z
end

function unit:GetObjectType(Unit)
	if br.unlocked and br.functions.unit:GetObjectExists(Unit) then
		return br._G.ObjectTypes(Unit)
	else
		return 65561
	end
end

function unit:GetObjectIndex(Index)
	if br.unlocked and br.functions.unit:GetObjectExists(br._G.GetObjectWithIndex(Index)) then
		return br._G.GetObjectWithIndex(Index)
	else
		return 0
	end
end

-- function GetObjectCountBR()
-- 	if EWT then
--     	return GetObjectCountBR()
--     else
--     	return 0
--     end
-- end
function unit:GetObjectID(Unit)
	if br.unlocked and br.functions.unit:GetObjectExists(Unit) then
		return br._G.ObjectID(Unit)
	else
		return 0
	end
end

function unit:UnitIsTappedByPlayer(mob)
	-- if br._G.UnitTarget("player") and mob == br._G.UnitTarget("player") then return true end
	-- if UnitAffectingCombat(mob) and br._G.UnitTarget(mob) then
	--    	mobPlaceHolderOne = br._G.UnitTarget(mob)
	--    	mobPlaceHolderOne = br._G.UnitCreator(mobPlaceHolderOne) or mobPlaceHolderOne
	--    	if UnitInParty(mobPlaceHolderOne) then return true end
	-- end
	-- return false
	if br._G.UnitIsTapDenied(mob) == false then
		return true
	else
		return false
	end
end

function unit:getSpellUnit(spellCast, aoe, minRange, maxRange, spellType)
	local spellName = br._G.GetSpellInfo(spellCast)
	if aoe == nil then aoe = false end
	local hasRange = br._G.C_Spell.SpellHasRange(spellName) and true or false
	local facing = not aoe
	local unit = br.engines.enemiesEngineFunctions:dynamicTarget(maxRange, facing) or (not hasRange and "player")
	if not unit then return "None" end
	local distance = br.functions.range:getDistance(unit)
	local thisUnit = "None"
	if (distance >= minRange and distance < maxRange) then
		if spellType == "Helpful" then return "player" end
		if hasRange then return unit else return "player" end
	end
	return thisUnit
end

-- if getCreatureType(Unit) == true then
function unit:getCreatureType(Unit)
	local CreatureTypeList = { "Critter", "Totem", "Non-combat Pet", "Wild Pet" }
	for i = 1, #CreatureTypeList do
		if br._G.UnitCreatureType(Unit) == CreatureTypeList[i] then
			return false
		end
	end
	if not br._G.UnitIsBattlePet(Unit) and not br._G.UnitIsWildBattlePet(Unit) then
		return true
	else
		return false
	end
end

-- if br.functions.unit:getFacing("target","player") == false then
function unit:getFacing(Unit1, Unit2, Degrees)
	if Degrees == nil then
		Degrees = 90
	end
	if Unit2 == nil then
		Unit2 = "player"
	end
	if br.functions.unit:GetObjectExists(Unit1) and br.functions.unit:GetUnitIsVisible(Unit1) and br.functions.unit:GetObjectExists(Unit2) and br.functions.unit:GetUnitIsVisible(Unit2) then
		local angle3
		local angle1 = br.functions.unit:GetObjectFacing(Unit1)
		local angle2 = br.functions.unit:GetObjectFacing(Unit2)
		local Y1, X1, Z1 = br.functions.unit:GetObjectPosition(Unit1)
		local Y2, X2, Z2 = br.functions.unit:GetObjectPosition(Unit2)
		if Y1 and X1 and Z1 and angle1 and Y2 and X2 and Z2 and angle2 then
			local deltaY = Y2 - Y1
			local deltaX = X2 - X1
			angle1 = math.deg(math.abs(angle1 - math.pi * 2))
			if deltaX > 0 then
				angle2 = math.deg(math.atan(deltaY / deltaX) + (math.pi / 2) + math.pi)
			elseif deltaX < 0 then
				angle2 = math.deg(math.atan(deltaY / deltaX) + (math.pi / 2))
			end
			if angle2 - angle1 > 180 then
				angle3 = math.abs(angle2 - angle1 - 360)
			elseif angle1 - angle2 > 180 then
				angle3 = math.abs(angle1 - angle2 - 360)
			else
				angle3 = math.abs(angle2 - angle1)
			end
			-- return angle3
			if angle3 < Degrees then
				return true
			else
				return false
			end
		end
	end
end

function unit:getGUID(unit)
	local nShortHand, targetGUID = "", ""
	if br.functions.unit:GetObjectExists(unit) then
		local guid = br._G.UnitGUID(unit)
		if guid ~= nil then
			if br._G.UnitIsPlayer(unit) then
				targetGUID = guid
				nShortHand = string.sub(guid, -5)
			else
				targetGUID = string.match(guid, "-(%d+)-%x+$")
				nShortHand = string.sub(guid, -5)
			end
		end
	end
	return targetGUID, nShortHand
end

-- if br.functions.unit:getHP("player") then
function unit:getHP(Unit)
	if br.functions.unit:GetObjectExists(Unit) then
		if br._G.UnitIsEnemy("player", Unit) then
			return 100 * (br._G.UnitHealth(Unit) / br._G.UnitHealthMax(Unit))
		else
			if not br.functions.unit:GetUnitIsDeadOrGhost(Unit) and br.functions.unit:GetUnitIsVisible(Unit) then
				for i = 1, #br.engines.healingEngine.friend do
					if br.engines.healingEngine.friend[i] then
						if br.engines.healingEngine.friend[i].guidsh == string.sub(br._G.UnitGUID(Unit), -5) then
							return br.engines.healingEngine.friend[i].hp
						end
					end
				end
				if br.functions.misc:getOptionCheck("Incoming Heals") == true and br._G.UnitGetIncomingHeals(Unit, "player") ~= nil then
					return 100 * (br._G.UnitHealth(Unit) + br._G.UnitGetIncomingHeals(Unit, "player")) /
					br._G.UnitHealthMax(Unit)
				else
					return 100 * br._G.UnitHealth(Unit) / br._G.UnitHealthMax(Unit)
				end
			end
		end
	end
	return 0
end

-- if br.functions.unit:getHPLossPercent("player",5) then
function unit:getHPLossPercent(unit, sec)
	if unit == nil then unit = "player" end
	local currentHP = br.functions.unit:getHP(unit)
	if sec == nil then sec = 1 end
	if br.snapHP == nil then br.snapHP = 0 end
	if br.debug.timer:useTimer("Loss Percent", sec) then
		br.snapHP = currentHP
	end
	if br.snapHP < currentHP then
		return 0
	else
		return br.snapHP - currentHP
	end
end

function unit:getLowestUnit(range)
	local lowestUnit = "player"
	local lowestHP = br.functions.unit:getHP("player")
	if range == nil then range = 40 end
	if br ~= nil and br.engines.healingEngine.friend ~= nil then
		for i = 1, #br.engines.healingEngine.friend do
			local thisUnit = br.engines.healingEngine.friend[i].unit
			local thisDist = br.functions.range:getDistance(thisUnit)
			local thisHp = br.functions.unit:getHP(thisUnit)
			if thisDist < range and thisHp < lowestHP and thisHp > 0 then
				lowestUnit = thisUnit
				lowestHP = thisHp
			end
		end
	end
	return lowestUnit
end

-- if getBossID("boss1") == 71734 then
function unit:getBossID(BossUnitID)
	return br.functions.unit:GetObjectID(BossUnitID)
end

function unit:getUnitID(Unit)
	if br.functions.unit:GetObjectExists(Unit) and br.functions.unit:GetUnitIsVisible(Unit) then
		local id = select(6, br._G.strsplit("-", br._G.UnitGUID(Unit) or ""))
		return tonumber(id)
	end
	return 0
end

function unit:isAberration(Unit)
	if Unit == nil then Unit = "target" end
	return br._G.UnitCreatureType(Unit) == "Aberration"
end

-- if br.functions.unit:isAlive([Unit]) == true then
function unit:isAlive(Unit)
	Unit = Unit or "player"
	if br._G.UnitIsDeadOrGhost(Unit) == false then
		return true
	end
end

function unit:isInstanceBoss(unit)
	if br._G.IsInInstance() then
		local _, _, encountersTotal = br._G.GetInstanceLockTimeRemaining();
		for i = 1, encountersTotal do
			if unit == "player" then
				local bossList = br._G.GetInstanceLockTimeRemainingEncounter(i)
				br._G.print(bossList)
			end
			if br.functions.unit:GetObjectExists(unit) then
				local bossName = br._G.GetInstanceLockTimeRemainingEncounter(i)
				local targetName = br._G.UnitName(unit)
				-- Print("Target: "..targetName.." | Boss: "..bossName.." | Match: "..tostring(targetName == bossName))
				if targetName == bossName then return true end
			end
		end
		for i = 1, 5 do
			local bossNum = "boss" .. i
			if br.functions.unit:GetUnitIsUnit(bossNum, unit) then return true end
		end
	end
	return false
end

-- br.functions.unit:isBoss()
function unit:isBoss(unit)
	if unit == nil then unit = "target" end
	if br.functions.unit:GetObjectExists(unit) and not br.engines.enemiesEngineFunctions:isTotem(unit) then
		local class = br._G.UnitClassification(unit)
		local healthMax = br._G.UnitHealthMax(unit)
		local pHealthMax = br._G.UnitHealthMax("player")
		local instance = select(2, br._G.IsInInstance())
		return br.functions.unit:isInstanceBoss(unit) or br.functions.unit:isDummy(unit)
			or (not br.functions.misc:isChecked("Boss Detection Only In Instance") and not br._G.UnitIsTrivial(unit) and instance ~= "party"
				and ((class == "rare" and healthMax > 4 * pHealthMax) or class == "rareelite" or class == "worldboss"
					or (class == "elite" and ((healthMax > 4 * pHealthMax and instance ~= "raid") or instance == "scenario")) or br._G.UnitLevel(unit) < 0))
	end
	return false
end

local critterTypes = {
	["Critter"] = true,
	["Kleintier"] = true,
	["Alma"] = true,
	["Bestiole"] = true,
	["Animale"] = true,
	["Bicho"] = true,
	["Существо"] = true,
	["동물"] = true,
	["小动物"] = true,
	["小動物"] = true,
	["Wild Pet"] = true,
	["Ungezähmtes Tier"] = true,
	["Mascotte sauvage"] = true
}
function unit:isCritter(Unit)
	if Unit == nil then Unit = "target" end
	return critterTypes[br._G.UnitCreatureType(Unit)] or false
end

function unit:isDemon(Unit)
	if Unit == nil then Unit = "target" end
	local isDemon = false
	local unitType = br._G.UnitCreatureType(Unit)
	local types = {
		"Demon",
		"Dämon",
		"Demonio",
		"Démon",
		"Demone",
		"Demônio",
		"Демон",
		"악마",
		"恶魔",
		"惡魔"
	}
	for i = 1, #types do
		if types[i] == unitType then isDemon = true end
	end
	return isDemon
end

function unit:isExplosive(Unit)
	return br.functions.unit:GetObjectID(Unit) == 120651
end

function unit:isUndead(Unit)
	if Unit == nil then Unit = "target" end
	local isUndead = false
	local unitType = br._G.UnitCreatureType(Unit)
	local types = {
		"Undead",
		"Untoter",
		"Mort-vivant",
		"언데드",
		"No-muerto",
		"Morto-vivo",
		"Non Morto",
		"Нежить",
		"亡灵",
		"不死族",
	}
	for i = 1, #types do
		if types[i] == unitType then isUndead = true end
	end
	return isUndead
end

function unit:isBeast(Unit)
	if Unit == nil then Unit = "target" end
	local isBeast = false
	local unitType = br._G.UnitCreatureType(Unit)
	local types = {
		"Beast",
		"Wildtier",
		"Bestia",
		"Bête",
		"Fera",
		"Животное",
		"야수",
		"野兽",
		"野獸"
	}
	for i = 1, #types do
		if types[i] == unitType then isBeast = true end
	end
	return isBeast
end

function unit:isHumanoid(Unit)
	if Unit == nil then Unit = "target" end
	local isHumanoid = false
	local unitType = br._G.UnitCreatureType(Unit)
	local types = {
		"Humanoid",
		"Humanoide",
		"Humanoïde",
		"Umanoide",
		"Гуманоид",
		"인간형",
		"人型生物",
	}
	for i = 1, #types do
		if types[i] == unitType then isHumanoid = true end
	end
	return isHumanoid
end

-- Dummy Check
function unit:isDummy(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if br.functions.unit:GetObjectExists(Unit) then
		local dummies = br.lists.dummies
		local objectID = br.functions.unit:GetObjectID(Unit)
		-- if dummies[tonumber(string.match(UnitGUID(Unit),"-(%d+)-%x+$"))] then --~= nil
		return dummies[objectID] ~= nil
	end
	return false
end

-- if isEnemy([Unit])
function unit:isEnemy(Unit)
	Unit = Unit or "target"
	if br._G.UnitCanAttack(Unit, "player") then
		return true
	else
		return false
	end
end

function unit:isTankInRange(range)
	if range == nil then range = 40 end
	if #br.engines.healingEngine.friend > 1 then
		for i = 1, #br.engines.healingEngine.friend do
			local friend = br.engines.healingEngine.friend[i]
			if friend.GetRole() == "TANK" and not br.functions.unit:GetUnitIsDeadOrGhost(friend.unit) and br.functions.range:getDistance(friend.unit) < range then
				return true, friend.unit
			end
		end
	end
	return false
end
