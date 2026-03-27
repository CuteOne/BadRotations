local _, br = ...
br.functions.unit = br.functions.unit or {}
local unit = br.functions.unit

unit.isDisarmed = false

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
	local spellName = br.api.wow.GetSpellInfo(spellCast)
	if aoe == nil then aoe = false end
	local hasRange = br._G.C_Spell.SpellHasRange(spellName) and true or false
	local facing = not aoe
	local unit = maxRange > 0 and br.engines.enemiesEngineFunctions:dynamicTarget(maxRange, facing) or nil

	-- Handle nil from dynamicTarget
	-- if not unit then
	-- 	-- Fallback to player for non-ranged spells only
	-- 	if not hasRange then
	-- 		return "player"
	-- 	end
	-- 	return "None"
	-- end

	local distance = unit and br.functions.range:getDistance(unit) or 0
	if not distance then return "None" end

	if (distance >= minRange and distance < maxRange) or (minRange > maxRange) then
		if spellType == "Helpful" then return "player" end
		if hasRange then return unit else return "player" end
	end
	return "None"
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
	if Degrees == nil then Degrees = 90 end
	if Unit2 == nil then Unit2 = "player" end

	-- We can only do accurate facing math when the unlocker APIs are available.
	if not br.unlocked then
		return nil
	end
	if not (br.functions.unit:GetObjectExists(Unit1) and br.functions.unit:GetUnitIsVisible(Unit1)
			and br.functions.unit:GetObjectExists(Unit2) and br.functions.unit:GetUnitIsVisible(Unit2)) then
		return nil
	end

	-- Prefer unlocker-provided implementation when present.
	-- Note: our Degrees parameter is treated as a HALF-angle (e.g. 90 == 180deg front hemisphere).
	if br._G.ObjectIsFacing ~= nil then
		local ok, result = pcall(br._G.ObjectIsFacing, Unit1, Unit2, Degrees * 2)
		if not ok then return nil end
		return result == true
	end

	-- Fallback: compute shortest angle between Unit1 facing and the vector Unit1->Unit2.
	local facing = br.functions.unit:GetObjectFacing(Unit1)
	local x1, y1, z1 = br.functions.unit:GetObjectPosition(Unit1)
	local x2, y2, z2 = br.functions.unit:GetObjectPosition(Unit2)
	if facing == nil or x1 == nil or y1 == nil or x2 == nil or y2 == nil then
		return nil
	end

	local angleTo = math.atan2(y2 - y1, x2 - x1) % (math.pi * 2)
	local diff = math.abs(facing - angleTo)
	if diff > math.pi then
		diff = (math.pi * 2) - diff
	end
	return diff < math.rad(Degrees)
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
	unit = unit or "target"
	if not br.functions.unit:GetObjectExists(unit) then return false end

	if br._G.IsInInstance and br._G.IsInInstance() then
		-- Try modern instance API first (may exist on Retail or newer clients)
		if br._G.GetInstanceLockTimeRemaining then
			local ok, _, _, encountersTotal = pcall(br._G.GetInstanceLockTimeRemaining)
			if ok and type(encountersTotal) == "number" and encountersTotal > 0 then
				for i = 1, encountersTotal do
					local ok2, bossName = pcall(br._G.GetInstanceLockTimeRemainingEncounter, i)
					if ok2 and bossName and br.functions.unit:GetObjectExists(unit) then
						local targetName = br._G.UnitName(unit)
						if targetName == bossName then return true end
					end
				end
			end
		end

		-- Always fall back to boss1..boss5 unit frames (works in Classic and Retail)
		for i = 1, 5 do
			local bossNum = "boss" .. i
			if br.functions.unit:GetUnitIsUnit(bossNum, unit) then return true end
		end

		-- Extra heuristics
		local class = br._G.UnitClassification(unit)
		if class == "worldboss" then return true end
		local level = br._G.UnitLevel(unit)
		if level and level < 0 then return true end
	end
	return false
end

-- br.functions.unit:isBoss()
function unit:isBoss(unit)
	unit = unit or "target"
	if not br.functions.unit:GetObjectExists(unit) or br.engines.enemiesEngineFunctions:isTotem(unit) then return false end

	-- Quick exact-match check using static boss ID list
	if br.lists and br.lists.bossIds then
		local id = br.functions.unit:getUnitID(unit)
		if id and id > 0 and br.lists.bossIds[id] then
			return true
		end
	end

	local class = br._G.UnitClassification(unit)
	local healthMax = br._G.UnitHealthMax(unit) or 0
	local pHealthMax = br._G.UnitHealthMax("player") or 1
	local instance = select(2, br._G.IsInInstance())

	return br.functions.unit:isInstanceBoss(unit) or br.functions.unit:isDummy(unit)
		or (not br.functions.misc:isChecked("Boss Detection Only In Instance") and not br._G.UnitIsTrivial(unit) and instance ~= "party"
			and ((class == "rare" and healthMax > 4 * pHealthMax) or class == "rareelite" or class == "worldboss"
				or (class == "elite" and ((healthMax > 4 * pHealthMax and instance ~= "raid") or instance == "scenario")) or (br._G.UnitLevel(unit) and br._G.UnitLevel(unit) < 0)))
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

function unit:isFleeing(thisUnit)
    if thisUnit == nil then thisUnit = "target" end

    -- Early exit if unit doesn't exist or is dead
    if not unit:GetObjectExists(thisUnit) or unit:GetUnitIsDeadOrGhost(thisUnit) then
        return false
    end

    -- Don't check bosses (they typically don't flee)
    if unit:isBoss(thisUnit) then
        return false
    end

    -- Health-based fleeing detection (10-25% health range)
    local unitHP = unit:getHP(thisUnit)
    local lowHealthThreshold = unitHP <= 25 and unitHP > 0

    -- Movement pattern detection
    local isMovingAway = false
    local unitSpeed = br._G.GetUnitSpeed(thisUnit)
    if unitSpeed > 0 then
        -- Check if unit is facing away from player (indicating fleeing)
        local isFacingPlayer = unit:getFacing(thisUnit, "player")
        if not isFacingPlayer then
            isMovingAway = true
        end
    end

    -- Return true if any fleeing condition is met
    return --[[lowHealthThreshold and]] isMovingAway
end

function unit:isElemental(Unit)
	if Unit == nil then Unit = "target" end
	local isElemental = false
	local unitType = br._G.UnitCreatureType(Unit)
	local types = {
		"Elemental",
		"Elementar",
		"Elemental", -- ES/PT
		"Élémentaire",
		"Elementare",
		"Элементаль",
		"정령",
		"元素生物",
		"元素生物"
	}
	for i = 1, #types do
		if types[i] == unitType then isElemental = true end
	end
	return isElemental
end

-- if br.functions.unit:isEating([Unit]) == true then
function unit:isEating(Unit)
	Unit = Unit or "player"
	local eatingBuffNames = {
		["Eating"]             = true, -- enUS
		["Food"]               = true, -- enUS (food buff)
		["Essen"]              = true, -- deDE
		["Speise"]             = true, -- deDE (food buff)
		["Nahrung"]            = true, -- deDE (alt)
		["Manger"]             = true, -- frFR
		["Nourriture"]         = true, -- frFR (food buff)
		["Comiendo"]           = true, -- esES / esMX
		["Comida"]             = true, -- esES / esMX / ptBR (food buff)
		["Comendo"]            = true, -- ptBR
		["Alimento"]           = true, -- ptBR (food buff)
		["Mangiando"]          = true, -- itIT
		["Cibo"]               = true, -- itIT (food buff)
		["Поглощение пищи"]    = true, -- ruRU
		["Еда"]                = true, -- ruRU (food buff)
		["Пища"]               = true, -- ruRU (alt)
		["음식 먹는 중"]         = true, -- koKR
		["음식"]                = true, -- koKR (food buff)
		["进食中"]              = true, -- zhCN
		["食物"]               = true, -- zhCN / zhTW (food buff)
		["進食中"]              = true, -- zhTW
	}
	for i = 1, 40 do
		local name = br.functions.aura:UnitBuff(Unit, i)
		if not name then break end
		if eatingBuffNames[name] then return true end
	end
	return false
end

-- if br.functions.unit:isDrinking([Unit]) == true then
function unit:isDrinking(Unit)
	Unit = Unit or "player"
	local drinkingBuffNames = {
		["Drinking"]           = true, -- enUS
		["Drink"]              = true, -- enUS (drink buff)
		["Trinken"]            = true, -- deDE
		["Getränk"]            = true, -- deDE (drink buff)
		["Boire"]              = true, -- frFR
		["Boisson"]            = true, -- frFR (drink buff)
		["Bebiendo"]           = true, -- esES / esMX
		["Bebida"]             = true, -- esES / esMX / ptBR (drink buff)
		["Bebendo"]            = true, -- ptBR
		["Bevendo"]            = true, -- itIT
		["Bevanda"]            = true, -- itIT (drink buff)
		["Употребление напитка"] = true, -- ruRU
		["Напиток"]             = true, -- ruRU (drink buff)
		["음료 마시는 중"]        = true, -- koKR
		["음료"]                = true, -- koKR (drink buff)
		["喝水中"]              = true, -- zhCN / zhTW
		["饮料"]               = true, -- zhCN (drink buff)
		["飲料"]               = true, -- zhTW (drink buff)
	}
	for i = 1, 40 do
		local name = br.functions.aura:UnitBuff(Unit, i)
		if not name then break end
		if drinkingBuffNames[name] then return true end
	end
	return false
end