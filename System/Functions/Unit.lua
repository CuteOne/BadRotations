function GetObjectExists(Unit)
	if Unit == nil then return false end
	return GetUnitIsVisible(Unit)
end
function GetUnit(Unit)
	if Unit ~= nil and GetObjectExists(Unit) then
		if (EWT or Toolkit_GetVersion ~= nil) then
			return Unit
		elseif FireHack and not (EWT or Toolkit_GetVersion ~= nil) then
			return ObjectIdentifier(Unit)
		end
	end
	return nil
end

function GetUnitIsUnit(Unit, otherUnit)
	if not GetUnitIsVisible(Unit) or not GetUnitIsVisible(otherUnit) then return false end
	return UnitIsUnit(Unit,otherUnit)
end

function GetUnitReaction(Unit,otherUnit)
	if not UnitIsVisible(Unit) or not UnitIsVisible(otherUnit) then return 10 end
	 return UnitReaction(Unit,otherUnit)
end

function GetUnitIsFriend(Unit, otherUnit)
	if not GetUnitIsVisible(Unit) or not GetUnitIsVisible(otherUnit) then return false end
	return UnitIsFriend(Unit,otherUnit)
end
function GetUnitExists(Unit)
	if Unit == nil then return false end
	return UnitExists(Unit)
end
function GetUnitIsVisible(Unit)
	if Unit == nil then return false end
	return UnitIsVisible(Unit)
end
function GetObjectFacing(Unit)
    if FireHack and GetObjectExists(Unit) then
        return ObjectFacing(Unit)
    else
        return false
    end
end
function GetObjectPosition(Unit)
    if FireHack then
		if Unit == nil then return ObjectPosition("player") end
		if GetObjectExists(Unit) then return ObjectPosition(Unit) end
    else
        return 0, 0, 0
    end
end
function GetObjectType(Unit)
    if FireHack and GetObjectExists(Unit) then
        return ObjectTypes(Unit)
    else
        return 65561
    end
end
function GetObjectIndex(Index)
    if FireHack and GetObjectExists(GetObjectWithIndex(Index)) then
        return GetObjectWithIndex(Index)
    else
        return 0
    end
end
-- function GetObjectCountBR()
-- 	if FireHack then
--     	return GetObjectCount()
--     else
--     	return 0
--     end
-- end
function GetObjectID(Unit)
	if FireHack and GetObjectExists(Unit) then
		return ObjectID(Unit)
	else
		return 0
	end
end
--[[ OLD pcall functions
function GetObjectExists(Unit)
	if select(2,pcall(GetObjectExists,Unit)) == true then
		return true
	else
		return false
	end
end
function GetObjectFacing(Unit)
	if GetObjectExists(Unit) then
		return select(2,pcall(ObjectFacing,Unit))
	else
		return false
	end
end
function GetObjectPosition(Unit)
	if GetObjectExists(Unit) then
		return select(2,pcall(ObjectPosition,Unit))
	else
		return false
	end
end
function GetObjectType(Unit)
	if GetObjectExists(Unit) then
		return select(2,pcall(ObjectTypes,Unit))
	else
		return false
	end
end
function GetObjectIndex(Index)
	if GetObjectExists(select(2,pcall(GetObjectWithIndex,Index))) then
		return select(2,pcall(GetObjectWithIndex,Index))
	else
		return false
	end
end
function GetObjectCountBR()
	return select(2,pcall(GetObjectCount))
end
]]

function UnitIsTappedByPlayer(mob)
	-- if UnitTarget("player") and mob == UnitTarget("player") then return true end
	-- if UnitAffectingCombat(mob) and UnitTarget(mob) then
	--    	mobPlaceHolderOne = UnitTarget(mob)
	--    	mobPlaceHolderOne = UnitCreator(mobPlaceHolderOne) or mobPlaceHolderOne
	--    	if UnitInParty(mobPlaceHolderOne) then return true end
	-- end
	-- return false
	if UnitIsTapDenied(mob)==false then
		return true
	else
		return false
	end
end
function getSpellUnit(spellCast,aoe)
	local spellName,_,_,_,_,maxRange = GetSpellInfo(spellCast)
	local spellType = getSpellType(spellName)
	local thisUnit
	if maxRange == nil or maxRange == 0 then maxRange = 5 end
	if aoe == nil then aoe = false end
	local facing = not aoe
	local unit = dynamicTarget(maxRange,facing)
    if spellType == "Helpful" then
        thisUnit = "player"
    elseif spellType == "Harmful" or spellType == "Both" then
        thisUnit = unit
    elseif spellType == "Unknown" and getDistance(unit) < maxRange then
        if castSpell(unit,spellCast,false,false,false,false,false,false,false,true) then
            thisUnit = unit
        elseif castSpell("player",spellCast,false,false,false,false,false,false,false,true) then
            thisUnit = "player"
        end
    end
    return thisUnit
end
-- if getCreatureType(Unit) == true then
function getCreatureType(Unit)
	local CreatureTypeList = {"Critter","Totem","Non-combat Pet","Wild Pet"}
	for i=1,#CreatureTypeList do
		if UnitCreatureType(Unit) == CreatureTypeList[i] then
			return false
		end
	end
	if not UnitIsBattlePet(Unit) and not UnitIsWildBattlePet(Unit) then
		return true
	else
		return false
	end
end
-- if getFacing("target","player") == false then
function getFacing(Unit1,Unit2,Degrees)
	if Degrees == nil then
		Degrees = 90
	end
	if Unit2 == nil then
		Unit2 = "player"
	end
	if GetObjectExists(Unit1) and GetUnitIsVisible(Unit1) and GetObjectExists(Unit2) and GetUnitIsVisible(Unit2) then
		local angle3
		local angle1 = GetObjectFacing(Unit1)
		local angle2 = GetObjectFacing(Unit2)
		local Y1,X1,Z1 = GetObjectPosition(Unit1)
		local Y2,X2,Z2 = GetObjectPosition(Unit2)
		if Y1 and X1 and Z1 and angle1 and Y2 and X2 and Z2 and angle2 then
			local deltaY = Y2 - Y1
			local deltaX = X2 - X1
			angle1 = math.deg(math.abs(angle1-math.pi*2))
			if deltaX > 0 then
				angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2)+math.pi)
			elseif deltaX <0 then
				angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2))
			end
			if angle2-angle1 > 180 then
				angle3 = math.abs(angle2-angle1-360)
			elseif angle1-angle2 > 180 then
				angle3 = math.abs(angle1-angle2-360)
			else
				angle3 = math.abs(angle2-angle1)
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
function getGUID(unit)
	local nShortHand, targetGUID = "", ""
	if GetObjectExists(unit) then
		if UnitIsPlayer(unit) then
			targetGUID = UnitGUID(unit)
			nShortHand = string.sub(UnitGUID(unit),-5)
		else
			targetGUID = string.match(UnitGUID(unit),"-(%d+)-%x+$")
			nShortHand = string.sub(UnitGUID(unit),-5)
		end
	end
	return targetGUID,nShortHand
end
-- if getHP("player") then
function getHP(Unit)
	if GetObjectExists(Unit) then
		if UnitIsEnemy("player", Unit) then
			return 100*UnitHealth(Unit)/UnitHealthMax(Unit)
		else
			if not UnitIsDeadOrGhost(Unit) and GetUnitIsVisible(Unit) then
				for i = 1,#br.friend do
					if br.friend[i].guidsh == string.sub(UnitGUID(Unit),-5) then
						return br.friend[i].hp
					end
				end
				if getOptionCheck("Incoming Heals") == true and UnitGetIncomingHeals(Unit,"player") ~= nil then
					return 100*(UnitHealth(Unit)+UnitGetIncomingHeals(Unit,"player"))/UnitHealthMax(Unit)
				else
					return 100*UnitHealth(Unit)/UnitHealthMax(Unit)
				end
			end
		end
	end
	return 0
end
-- if getHPLossPercent("player",5) then
function getHPLossPercent(unit,sec)
	local currentHP = getHP(unit)
	if unit == nil then unit = "player" end
	if sec == nil then sec = 1 end
	if snapHP == nil then snapHP = 0 end
	if br.timer:useTimer("Loss Percent", sec) then
		snapHP = currentHP
	end
	if snapHP < currentHP then
		return 0
	else
		return snapHP - currentHP
	end
end

-- if getBossID("boss1") == 71734 then
function getBossID(BossUnitID)
	return GetObjectID(BossUnitID)
end
function getUnitID(Unit)
	if GetObjectExists(Unit) and GetUnitIsVisible(Unit) then
		local id = select(6,strsplit("-", UnitGUID(Unit) or ""))
		return tonumber(id)
	end
	return 0
end
-- if isAlive([Unit]) == true then
function isAlive(Unit)
	local Unit = Unit or "player"
	if UnitIsDeadOrGhost(Unit) == false then
		return true
	end
end
function isInstanceBoss(unit)
	if IsInInstance() then
		local lockTimeleft, isPreviousInstance, encountersTotal, encountersComplete = GetInstanceLockTimeRemaining();
		for i=1,encountersTotal do
			if unit == "player" then
				local bossList = select(1,GetInstanceLockTimeRemainingEncounter(i))
				Print(bossList)
			end
			if GetObjectExists(unit) then
				local bossName = GetInstanceLockTimeRemainingEncounter(i)
				local targetName = UnitName(unit)
				-- Print("Target: "..targetName.." | Boss: "..bossName.." | Match: "..tostring(targetName == bossName))
				if targetName == bossName then return true end
			end
		end
		for i = 1, 5 do
			local bossNum = "boss"..i
			if GetUnitIsUnit(bossNum,unit) then return true end
		end
	end
	return false
end
-- isBoss()
function isBoss(unit)
	if unit == nil then unit = "target" end
	if GetObjectExists(unit) then
		local class = UnitClassification(unit)
		local healthMax = UnitHealthMax(unit)
		local pHealthMax = UnitHealthMax("player")
		local instance = select(2,IsInInstance())
		return isInstanceBoss(unit) or isDummy(unit) or (not UnitIsTrivial(unit) and instance ~= "party"
			and ((class == "rare" and healthMax > 4 * pHealthMax) or class == "rareelite" or class == "worldboss"
				or (class == "elite" and healthMax > 4 * pHealthMax and instance ~= "raid")	or UnitLevel(unit) < 0))
	end
	return false
end
function isCritter(Unit) -- From LibBabble
	if Unit == nil then Unit = "target" end
	local unitType = UnitCreatureType(Unit)
	local types = {
		"Critter",
		"Kleintier",
		"Bestiole",
		"동물",
		"Alma",
		"Bicho",
		"Animale",
		"Существо",
		"小动物",
		"小動物",
		"Wild Pet",
		"Ungezähmtes Tier",
		"Mascotte sauvage",
		"야생 애완동물",
		"Mascota salvaje",
		"Mascóta Salvaje",
		"Mascote Selvagem",
		"Creatura Selvaggia",
		"野生宠物",
		"野生寵物",
	}
	for i = 1, #types do
		if unitType == types[i] then return true end
	end
	return false
end
-- Dummy Check
function isDummy(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if GetObjectExists(Unit) then
		local dummies = br.lists.dummies
		local objectID = GetObjectID(Unit)
		-- if dummies[tonumber(string.match(UnitGUID(Unit),"-(%d+)-%x+$"))] then --~= nil
		return dummies[objectID] ~= nil
	end
	return false
end
-- if isEnnemy([Unit])
function isEnnemy(Unit)
	Unit = Unit or "target"
	if UnitCanAttack(Unit,"player") then
		return true
	else
		return false
	end
end
function isTankInRange()
	if #br.friend > 1 then
		for i = 1, #br.friend do
			local friend = br.friend[i]
			if friend.GetRole()== "TANK" and not UnitIsDeadOrGhost(friend.unit) and getDistance(friend.unit) < 40 then
				return true
			end
		end
	end
	return false
end
