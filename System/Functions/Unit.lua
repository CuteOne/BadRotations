local _, br = ...
---@class br.functions.unit
br.functions.unit = br.functions.unit or {}
local unit = br.functions.unit
-- When each mob (GUID) gave the flee emote, and how long a flee counts for (TrinityCore's default
-- flee delay is 7 s; a fleeing mob runs until it finds help or the timer ends)
local fleeEmoteAt = {}
local FLEE_TIME = 10
unit.isDisarmed = false

-- Creature types, by the ID UnitCreatureType returns as its second value. Clients that return only the
-- (localized) name are matched by these names instead.
local creatureTypes = {
	beast        = { id = 1,  names = { "Beast", "Wildtier", "Bestia", "Bête", "Fera", "Животное", "야수", "野兽", "野獸" } },
	dragonkin    = { id = 2,  names = { "Dragonkin" } },
	demon        = { id = 3,  names = { "Demon", "Dämon", "Demonio", "Démon", "Demone", "Demônio", "Демон", "악마", "恶魔", "惡魔" } },
	elemental    = { id = 4,  names = { "Elemental", "Elementar", "Élémentaire", "Elementare", "Элементаль", "정령", "元素生物" } },
	undead       = { id = 6,  names = { "Undead", "Untoter", "Mort-vivant", "언데드", "No-muerto", "Morto-vivo", "Non Morto", "Нежить", "亡灵", "不死族" } },
	humanoid     = { id = 7,  names = { "Humanoid", "Humanoide", "Humanoïde", "Umanoide", "Гуманоид", "인간형", "人型生物" } },
	critter      = { id = 8,  names = { "Critter", "Kleintier", "Alma", "Bestiole", "Animale", "Bicho", "Существо", "동물", "小动物", "小動物" } },
	totem        = { id = 11, names = { "Totem", "Tótem", "Totém", "Тотем", "토템", "图腾", "圖騰" } },
	nonCombatPet = { id = 12, names = { "Non-combat Pet" } },
	wildPet      = { id = 14, names = { "Wild Pet", "Ungezähmtes Tier", "Mascotte sauvage" } },
	aberration   = { id = 15, names = { "Aberration" } },
}

local creatureTypeByName = {}

for _, creatureType in pairs(creatureTypes) do
	for _, name in ipairs(creatureType.names) do creatureTypeByName[name] = creatureType.id end
end

local noManaClasses = { WARRIOR = true, ROGUE = true, DEATHKNIGHT = true, DEMONHUNTER = true }

local lossOfControlTypes = {
	fearCharm = { FEAR = true, FEAR_MECHANIC = true, CHARM = true, POSSESS = true, CONFUSE = true },
	anyCC = { STUN = true, STUN_MECHANIC = true, FEAR = true, FEAR_MECHANIC = true, CHARM = true, POSSESS = true, CONFUSE = true },
	rooted = { ROOT = true },
}

-- When BR last cancelled the player's shapeshift form. The form's buff only goes once the server
-- replies, so for a round trip the form still looks active and a rotation would cancel it again.
-- Whether the player is auto-attacking, from the game's PLAYER_ENTER_COMBAT / PLAYER_LEAVE_COMBAT
-- (Readers/common.lua). IsCurrentSpell on the Attack spell reads false while an on-next-swing
-- attack (Maul, Heroic Strike) is queued, so it can't answer this on its own.
local autoAttacking = false

-- Kept apart from the cast throttles (castTimers / intent locks): a cancel isn't a cast, and locking
-- the form's spell would also block casting that form and be cleared by unrelated cast errors.
local formCancelSentAt = -math.huge

-- Drink and food buffs by name, in every client language (unit:isDrinking, unit:isEating)
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

-- True when the unit has a buff whose name is in names
local function hasBuffNamed(Unit, names)
	for i = 1, 40 do
		local auraInfo = br._G.C_UnitAuras.GetBuffDataByIndex(Unit, i)
		if not auraInfo then return false end
		if names[auraInfo.name] then return true end
	end
	return false
end

-- True if any enemy (in combat or not) within radius yards would aggro on the player.
-- if br.functions.unit:anyInAggroRange(5) then
function unit:anyInAggroRange(offset, radius)
	local nearby = br.engines.enemiesEngineFunctions:getEnemies("player", radius or 40, true)
	for i = 1, #nearby do
		if unit:isInAggroRange(nearby[i], offset) then return true end
	end
	return false
end

--- Cancels the player's shapeshift form, unless the player isn't in one or a cancel is already on
-- its way. Returns true when a cancel was sent now.
function unit:cancelShapeshiftForm()
	if (br._G.GetShapeshiftForm() or 0) == 0 or unit:isFormCancelPending() then return false end
	br._G.CancelShapeshiftForm()
	formCancelSentAt = br._G.GetTime()
	return true
end

-- Aggro radius of a unit against the player: 20 yards, +/- 1 per level difference, minimum 5.
-- if br.functions.unit:getAggroRange("target") > 15 then
function unit:getAggroRange(thisUnit)
	if thisUnit == nil then thisUnit = "target" end
	local thisLevel = br._G.UnitLevel(thisUnit) or 0
	local playerLevel = br._G.UnitLevel("player") or 0
	-- UnitLevel returns -1 for skull-level units; treat them as far above the player
	if thisLevel < 0 then thisLevel = playerLevel + 10 end
	return math.max(20 + (thisLevel - playerLevel), 5)
end

-- Picks the unit to buff from a "Player/Target/Mouseover/Focus/Group" option value.
-- needsBuff(unit) decides which group member to pick; missing units fall back to the player.
-- local thisUnit = br.functions.unit:getBuffUnit(2, function(u) return true end, 30)
function unit:getBuffUnit(choice, needsBuff, range)
	range = range or 40
	if choice == 2 and unit:GetUnitExists("target") then return "target" end
	if choice == 3 and unit:GetUnitExists("mouseover") then return "mouseover" end
	if choice == 4 and unit:GetUnitExists("focus") then return "focus" end
	if choice == 5 and needsBuff ~= nil then
		local friends = br.engines.healingEngine.friend
		if friends ~= nil and #friends > 1 then
			for i = 1, #friends do
				local nextUnit = friends[i].unit
				if needsBuff(nextUnit) and (br.functions.range:getDistance("player", nextUnit) or 99) < range then
					return nextUnit
				end
			end
		end
	end
	return "player"
end

-- False for critters, totems and pets (battle pets included); true for everything else.
-- if br.functions.unit:getCreatureType(Unit) == true then
function unit:getCreatureType(Unit)
	local id = unit:getCreatureTypeID(Unit)
	if id == creatureTypes.critter.id or id == creatureTypes.totem.id or id == creatureTypes.nonCombatPet.id
		or id == creatureTypes.wildPet.id
	then
		return false
	end
	return not br._G.UnitIsBattlePet(Unit) and not br._G.UnitIsWildBattlePet(Unit)
end

-- The unit's creature type ID, or nil when it has none the game reports.
-- if br.functions.unit:getCreatureTypeID("target") == 1 then
function unit:getCreatureTypeID(Unit)
	local name, id = br._G.UnitCreatureType(Unit)
	if id ~= nil then return id end
	return name and creatureTypeByName[name]
end

-- A dead player in the group within range, for a resurrection; nil when there's none. Give roles
-- ("TANK", "HEALER", "DAMAGER") to only pick those; without any, anyone.
-- local thisUnit = br.functions.unit:getDeadGroupMember(30, "TANK", "HEALER")
function unit:getDeadGroupMember(range, ...)
	local roles = select("#", ...) > 0 and { ... } or nil
	local friends = br.engines.healingEngine.friend
	for i = 1, #friends do
		local friend = friends[i]
		local thisUnit = friend.unit
		if br._G.UnitIsPlayer(thisUnit) and br._G.UnitIsDeadOrGhost(thisUnit)
			and (br.functions.range:getDistance("player", thisUnit) or 99) < range
		then
			if roles == nil then return thisUnit end
			for j = 1, #roles do
				if friend.role == roles[j] then return thisUnit end
			end
		end
	end
	return nil
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

	-- A unit facing its target (see getServerFacing) is worked out here; otherwise the unlocker's own
	-- check is preferred when present.
	-- Note: our Degrees parameter is treated as a HALF-angle (e.g. 90 == 180deg front hemisphere).
	local _, fromTarget = br.functions.unit:getServerFacing(Unit1)
	if br._G.ObjectIsFacing ~= nil and not fromTarget then
		local ok, result = pcall(br._G.ObjectIsFacing, Unit1, Unit2, Degrees * 2)
		if not ok then return nil end
		return result == true
	end

	local angle = br.functions.unit:getFacingAngle(Unit1, Unit2)
	if angle == nil then return nil end
	return angle < Degrees
end

--- Which way Unit faces as the server has it, in radians, and whether that came from its target.
-- The server turns a unit to face the unit it attacks or casts at without telling the client
-- (CMaNGOS Unit::SelectHostileTarget -> SetInFront), so the client's facing for it can be far off
-- (2026-10-19: read 125 degrees away while the server refused Shred as "not behind"). For any unit
-- but the player that has a target, that's the direction to its target. A stun or fear clears its
-- target and sends the real facing (Unit::SetStunned), so without a target the client's is right.
function unit:getServerFacing(Unit)
	if Unit ~= "player" and br._G.UnitTarget and not br.functions.unit:GetUnitIsUnit(Unit, "player") then
		local victim = br._G.UnitTarget(Unit)
		if victim ~= nil and not br._G.UnitIsUnit(victim, Unit) then
			if br._G.UnitIsUnit(victim, "player") then victim = "player" end
			local x1, y1 = br.functions.unit:GetObjectPosition(Unit)
			local x2, y2 = br.functions.unit:GetObjectPosition(victim)
			if x1 and y1 and x2 and y2 and (x1 ~= x2 or y1 ~= y2) then
				return math.atan2(y2 - y1, x2 - x1) % (math.pi * 2), true
			end
		end
	end
	return br.functions.unit:GetObjectFacing(Unit), false
end

--- How far Unit2 is off Unit1's facing (as the server has it, see getServerFacing), in degrees
-- (0 = straight ahead, 180 = right behind), and the distance between their centres (the angle means
-- little when the centres nearly meet). nil when the positions or the facing can't be read.
function unit:getFacingAngle(Unit1, Unit2)
	local facing = br.functions.unit:getServerFacing(Unit1)
	local x1, y1 = br.functions.unit:GetObjectPosition(Unit1)
	local x2, y2 = br.functions.unit:GetObjectPosition(Unit2)
	if facing == nil or x1 == nil or y1 == nil or x2 == nil or y2 == nil then
		return nil
	end
	local angleTo = math.atan2(y2 - y1, x2 - x1) % (math.pi * 2)
	local diff = math.abs(facing - angleTo)
	if diff > math.pi then
		diff = (math.pi * 2) - diff
	end
	return math.deg(diff), math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

--- The spell ID of the player's current shapeshift form, or nil when not in one.
function unit:getFormSpellID()
	if not br._G.GetShapeshiftForm or not br._G.GetShapeshiftFormInfo then return nil end
	local formIndex = br._G.GetShapeshiftForm() or 0
	if formIndex == 0 then return nil end
	local _, _, _, formSpellID = br._G.GetShapeshiftFormInfo(formIndex)
	return formSpellID
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

function unit:GetObjectExists(Unit)
	if Unit == nil then return false end
	return br.functions.unit:GetUnitIsVisible(Unit)
end

function unit:GetObjectFacing(Unit)
	if br.unlocked and br.functions.unit:GetObjectExists(Unit) then
		return br._G.ObjectFacing(Unit)
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
		-- units the enemies engine tracks already have their NPC ID on record
		local record = br.engines.enemiesEngine and br.engines.enemiesEngine.records and br.engines.enemiesEngine.records[Unit]
		if record and record.id then return record.id end
		return br._G.ObjectID(Unit)
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

-- The player's highest primary stat: "Strength", "Agility" or "Intellect".
-- Stats are secret in combat on some clients, so call this out of combat (e.g. when building options).
-- local stat = br.functions.unit:getPrimaryStat()
function unit:getPrimaryStat()
	local stats = {
		Strength = select(2, br._G.UnitStat("player", 1)),
		Agility = select(2, br._G.UnitStat("player", 2)),
		Intellect = select(2, br._G.UnitStat("player", 4)),
	}
	local highestStat, highestValue = "", 0
	for statName, statValue in pairs(stats) do
		if statValue > highestValue then
			highestValue = statValue
			highestStat = statName
		end
	end
	return highestStat
end

function unit:getSpellUnit(spellCast, aoe, minRange, maxRange, spellType)
	local spellName = br.functions.spell:getName(spellCast)
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

function unit:GetUnit(Unit)
	if Unit ~= nil and br.functions.unit:GetObjectExists(Unit) then
		return Unit
	end
	return nil
end

function unit:GetUnitExists(Unit)
	if Unit == nil then return false end
	return br._G.UnitExists(Unit)
end

function unit:getUnitID(Unit)
	if br.functions.unit:GetObjectExists(Unit) and br.functions.unit:GetUnitIsVisible(Unit) then
		local id = select(6, br._G.strsplit("-", br._G.UnitGUID(Unit) or ""))
		return tonumber(id)
	end
	return 0
end

function unit:GetUnitIsDeadOrGhost(Unit)
	if Unit == nil then return false end
	return br._G.UnitIsDeadOrGhost(Unit)
end

function unit:GetUnitIsFriend(Unit, otherUnit)
	if not br.functions.unit:GetUnitIsVisible(Unit) or not br.functions.unit:GetUnitIsVisible(otherUnit) then return false end
	return br._G.UnitIsFriend(Unit, otherUnit)
end

function unit:GetUnitIsUnit(Unit, otherUnit)
	if not br.functions.unit:GetUnitIsVisible(Unit) or not br.functions.unit:GetUnitIsVisible(otherUnit) then return false end
	return br._G.UnitIsUnit(Unit, otherUnit)
end

function unit:GetUnitIsVisible(Unit)
	if Unit == nil then return false end
	return br._G.UnitIsVisible(Unit)
end

function unit:GetUnitReaction(Unit, otherUnit)
	if not br.functions.unit:GetUnitIsVisible(Unit) or not br.functions.unit:GetUnitIsVisible(otherUnit) then return 10 end
	return br._G.UnitReaction(Unit, otherUnit)
end

-- True while the player has an active loss of control effect in the given category:
-- "fearCharm" (fear, charm, possess, confuse), "anyCC" (fearCharm plus stuns) or "rooted".
-- Returns false where C_LossOfControl is unavailable.
-- if br.functions.unit:hasLossOfControl("rooted") then
function unit:hasLossOfControl(category)
	local types = lossOfControlTypes[category]
	local LoC = br._G.C_LossOfControl
	if types == nil or LoC == nil or LoC.GetActiveLossOfControlDataCount == nil then return false end
	for i = 1, LoC.GetActiveLossOfControlDataCount() do
		local data = LoC.GetActiveLossOfControlData(i)
		if data and types[data.locType] then return true end
	end
	return false
end

function unit:isAberration(Unit)
	return unit:isCreatureType(Unit, "aberration")
end

-- True when an enemy is attacking a friendly unit other than the player (to taunt it off them).
-- if br.functions.unit:isAttackingOthers(thisUnit) then
function unit:isAttackingOthers(thisUnit)
	if not br._G.UnitAffectingCombat(thisUnit) or br.functions.combat:isTanking(thisUnit) then return false end
	local victim = br._G.UnitTarget(thisUnit)
	return victim ~= nil and br._G.UnitIsFriend(victim, "player") and not br._G.UnitIsUnit(victim, "player")
end

function unit:isAutoAttacking() return autoAttacking end

function unit:isBeast(Unit)
	return unit:isCreatureType(Unit, "beast")
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

-- True while the player is running away from an enemy within radius that is chasing it (escapes).
-- if br.functions.unit:isChased(10) then
function unit:isChased(radius)
	local nearby = br.engines.enemiesEngineFunctions:getEnemies("player", radius or 10)
	for i = 1, #nearby do
		if unit:isFleeingFrom("player", nearby[i]) then return true end
	end
	return false
end

-- True when the unit is of that creature type: "beast", "dragonkin", "demon", "elemental", "undead",
-- "humanoid", "critter", "totem", "nonCombatPet", "wildPet" or "aberration".
-- if br.functions.unit:isCreatureType("target", "beast") then
function unit:isCreatureType(Unit, typeName)
	return unit:getCreatureTypeID(Unit or "target") == creatureTypes[typeName].id
end

-- Critters and wild pets
function unit:isCritter(Unit)
	return unit:isCreatureType(Unit, "critter") or unit:isCreatureType(Unit, "wildPet")
end

function unit:isDemon(Unit)
	return unit:isCreatureType(Unit, "demon")
end

function unit:isDragonkin(Unit)
	return unit:isCreatureType(Unit, "dragonkin")
end

-- if br.functions.unit:isDrinking([Unit]) == true then
function unit:isDrinking(Unit)
	Unit = Unit or "player"
	return hasBuffNamed(Unit, drinkingBuffNames)
end

function unit:isDummy(Unit)
	if Unit == nil then
		Unit = "target"
	end
	-- GetObjectID is 0 for a unit that doesn't exist, and 0 is never a dummy
	return br.lists.dummies[br.functions.unit:GetObjectID(Unit)] ~= nil
end

-- if br.functions.unit:isEating([Unit]) == true then
function unit:isEating(Unit)
	Unit = Unit or "player"
	return hasBuffNamed(Unit, eatingBuffNames)
end

function unit:isElemental(Unit)
	return unit:isCreatureType(Unit, "elemental")
end

-- True when an enemy is close enough to start a fight: one already fighting within radius, or an idle
-- one whose aggro range you're in. For stealthing before a pull (Prowl, Stealth).
-- if br.functions.unit:isEnemyNear(20) then
function unit:isEnemyNear(radius)
	if #br.engines.enemiesEngineFunctions:getEnemies("player", radius) > 0 then return true end
	return unit:anyInAggroRange(0, radius)
end

function unit:isExplosive(Unit)
	return br.lists.unitRules.explosive[br.functions.unit:GetObjectID(Unit)] ~= nil
end

--- Whether thisUnit is running loose: "flee" (it fled at low health: the game's flee emote named it,
--- or the unlocker's fleeing unit flag is set without a fear on it), "fear" (a fear from
--- br.lists.longCC), or false. A unit merely moving away doesn't count.
function unit:isFleeing(thisUnit)
	if thisUnit == nil then thisUnit = "target" end
	if not unit:GetObjectExists(thisUnit) or unit:GetUnitIsDeadOrGhost(thisUnit) then return false end
	if br.functions.misc:isLongTimeCCed(thisUnit) == "fear" then return "fear" end
	local guid = br._G.UnitGUID(thisUnit)
	local fledAt = guid and fleeEmoteAt[guid]
	if fledAt then
		if br._G.GetTime() - fledAt <= FLEE_TIME then return "flee" end
		fleeEmoteAt[guid] = nil
	end
	-- The server's fleeing unit flag, where the unlocker reads unit flags and the expansion has
	-- confirmed the bit (br.api.fleeingUnitFlag)
	local flag = br.api.fleeingUnitFlag
	if flag and br._G.UnitFlags then
		local flags = br._G.UnitFlags(thisUnit)
		if type(flags) == "number" and bit.band(flags, flag) ~= 0 then return "flee" end
	end
	return false
end

-- True if thisUnit is moving away from fromUnit while fromUnit faces it (being chased).
-- Unknown facing (nil) never counts as fleeing.
-- if br.functions.unit:isFleeingFrom("player", "target") then
function unit:isFleeingFrom(thisUnit, fromUnit)
	if thisUnit == nil then thisUnit = "player" end
	if fromUnit == nil then fromUnit = "target" end
	if (br._G.GetUnitSpeed(thisUnit) or 0) <= 0 then return false end
	return unit:getFacing(thisUnit, fromUnit) == false and unit:getFacing(fromUnit, thisUnit) == true
end

--- True while a form cancel BR sent is still on its way (sent within a round trip, form still on).
--- Records a CHAT_MSG_MONSTER_EMOTE: the flee emote (br.lists.fleeEmotes) marks the mob as fleeing.
--- guid: the emote's sender GUID. Forever's client leaves it empty, so
--- the mob is then found by name: an enemy in the enemies engine with that name, the player's target
--- first, otherwise the one lowest on health (mobs flee at low health).
function unit:noteFleeEmote(text, guid, name)
	if not (text and br.lists.fleeEmotes[text]) then return end
	if guid == nil and name ~= nil then
		local best, bestHP
		for pointer, record in pairs(br.engines.enemiesEngine.units) do
			if record.name == name then
				if br.functions.unit:GetUnitIsUnit(pointer, "target") then
					best = pointer
					break
				end
				local hp = unit:getHP(pointer)
				if bestHP == nil or hp < bestHP then best, bestHP = pointer, hp end
			end
		end
		guid = best and br._G.UnitGUID(best)
	end
	if guid then fleeEmoteAt[guid] = br._G.GetTime() end
end

function unit:isFormCancelPending()
	return br._G.GetTime() - formCancelSentAt < br.functions.misc:getRoundTripHold() and (br._G.GetShapeshiftForm() or 0) ~= 0
end

-- Dummy Check
--- True for an NPC that's only attacked while it has a certain buff (br.lists.unitRules.attackOnlyWithBuff)
-- and doesn't have it now, unless it's the player's target.
function unit:isHeldBack(Unit)
	local requiredBuff = br.lists.unitRules.attackOnlyWithBuff[br.functions.unit:GetObjectID(Unit)]
	if requiredBuff == nil then return false end
	return not (br.functions.aura:UnitBuffID(Unit, requiredBuff) or br.functions.unit:GetUnitIsUnit(Unit, "target"))
end

function unit:isHumanoid(Unit)
	return unit:isCreatureType(Unit, "humanoid")
end

-- True if thisUnit would aggro on the player: hostile (or neutral and targeted) and within
-- its aggro radius plus offset yards.
-- if br.functions.unit:isInAggroRange("target", 5) then
function unit:isInAggroRange(thisUnit, offset)
	if thisUnit == nil then thisUnit = "target" end
	if not unit:GetObjectExists(thisUnit) or unit:GetUnitIsDeadOrGhost(thisUnit)
		or not br._G.UnitCanAttack("player", thisUnit)
	then
		return false
	end
	local reaction = unit:GetUnitReaction(thisUnit, "player") or 10
	if not (reaction < 4 or (reaction == 4 and unit:GetUnitIsUnit("target", thisUnit))) then
		return false
	end
	local distance = br.functions.range:getDistance("player", thisUnit)
	return distance ~= nil and distance < unit:getAggroRange(thisUnit) + (offset or 0)
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

function unit:isTankInRange(range)
	if range == nil then range = 40 end
	if #br.engines.healingEngine.friend > 1 then
		-- Primary: role-based detection (Cataclysm+)
		for i = 1, #br.engines.healingEngine.friend do
			local friend = br.engines.healingEngine.friend[i]
			if friend.GetRole() == "TANK"
				and not br.functions.unit:GetUnitIsDeadOrGhost(friend.unit)
				and br.functions.range:getDistance(friend.unit) < range
			then
				return true, friend.unit
			end
		end
		-- Fallback: class-based detection for expansions without a role system (TBC, Classic).
		-- Activates when UnitGroupRolesAssigned returns "NONE" for the player, indicating the
		-- role API is unavailable. Warrior, Paladin, and Druid are valid tank classes in both.
		local uigra = br._G.UnitGroupRolesAssigned
		if uigra and uigra("player") == "NONE" then
			local tankClass = { WARRIOR = true, PALADIN = true, DRUID = true }
			for i = 1, #br.engines.healingEngine.friend do
				local friend = br.engines.healingEngine.friend[i]
				if not br._G.UnitIsUnit(friend.unit, "player")
					and not br.functions.unit:GetUnitIsDeadOrGhost(friend.unit)
					and br.functions.range:getDistance(friend.unit) < range
				then
					local _, classTag = br._G.UnitClass(friend.unit)
					if classTag and tankClass[classTag] then
						return true, friend.unit
					end
				end
			end
		end
	end
	return false
end

function unit:isUndead(Unit)
	return unit:isCreatureType(Unit, "undead")
end

function unit:setAutoAttacking(on) autoAttacking = on and true or false end

--- Whether leaving the current form to cast a spell is what a player would do now. Returns the answer
-- and, when it's no, why. A player stays in form when stealthed (leaving breaks Prowl), when tanking
-- in a bear form, or without the mana to cast the spell and shift back into the current form; in an
-- emergency (about to die) none of that matters.
-- @param outOfFormSpell     the spell to cast once out of form (spell ID, list of rank IDs, or spell)
-- @param treatOutSpellAsFree true when that spell costs nothing this time (e.g. Clearcasting)
-- @param emergency          true to leave form regardless
function unit:shouldLeaveFormFor(outOfFormSpell, treatOutSpellAsFree, emergency)
	local formSpellID = unit:getFormSpellID()
	if formSpellID == nil then return false, "not in a form" end
	if emergency then return true end
	if br._G.IsStealthed and br._G.IsStealthed() then return false, "stealthed" end
	-- A tank in a group keeps its form while it holds threat (dropping it risks the group); solo there's
	-- no one else to heal it, so it may leave the form like any other
	if br.functions.spell:isTankForm(formSpellID) and br.functions.combat:isTanking()
		and br._G.IsInGroup and br._G.IsInGroup()
	then
		return false, "tanking for the group"
	end
	local power = br.functions.power
	local needed = power:getManaCostFromRef(outOfFormSpell, treatOutSpellAsFree) + power:getManaCostFromRef(formSpellID, false)
	if needed > 0 and (br._G.UnitPower("player", 0) or 0) < needed then return false, "not enough mana to shift back" end
	return true
end

-- True if the player's class uses mana (decided by class, so no secret power reads are needed).
-- if br.functions.unit:usesMana() then
function unit:usesMana()
	local _, playerClass = br._G.UnitClass("player")
	return not noManaClasses[playerClass]
end
