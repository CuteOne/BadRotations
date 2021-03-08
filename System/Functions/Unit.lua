local _, br = ...
function br.GetObjectExists(Unit)
	if Unit == nil then return false end
	return br.GetUnitIsVisible(Unit)
end
function br.GetUnit(Unit)
	if Unit ~= nil and br.GetObjectExists(Unit) then
		return Unit
	end
	return nil
end

function br.GetUnitIsUnit(Unit, otherUnit)
	if not br.GetUnitIsVisible(Unit) or not br.GetUnitIsVisible(otherUnit) then return false end
	return br._G.UnitIsUnit(Unit,otherUnit)
end

function br.GetUnitReaction(Unit,otherUnit)
	if not br.GetUnitIsVisible(Unit) or not br.GetUnitIsVisible(otherUnit) then return 10 end
	 return br._G.UnitReaction(Unit,otherUnit)
end

function br.GetUnitIsFriend(Unit, otherUnit)
	if not br.GetUnitIsVisible(Unit) or not br.GetUnitIsVisible(otherUnit) then return false end
	return br._G.UnitIsFriend(Unit,otherUnit)
end
function br.GetUnitExists(Unit)
	if Unit == nil then return false end
	return br._G.UnitExists(Unit)
end
function br.GetUnitIsVisible(Unit)
	if Unit == nil then return false end
	return br._G.UnitIsVisible(Unit)
end
function br.GetUnitIsDeadOrGhost(Unit)
	if Unit == nil then return false end
	return br._G.UnitIsDeadOrGhost(Unit)
end
function br.GetObjectFacing(Unit)
    if br.unlocked and br.GetObjectExists(Unit) then
        return br._G.ObjectFacing(Unit)
    else
        return false
    end
end
function br.GetObjectPosition(Unit)
    if br.unlocked then --EWT then
		if Unit == nil then return br._G.ObjectPosition("player") end
		if br.GetObjectExists(Unit) then return br._G.ObjectPosition(Unit) end
    else
        return 0, 0, 0
    end
end
function br.GetObjectType(Unit)
    if br.unlocked and br.GetObjectExists(Unit) then
        return br._G.ObjectTypes(Unit)
    else
        return 65561
    end
end
function br.GetObjectIndex(Index)
    if br.unlocked and br.GetObjectExists(br._G.GetObjectWithIndex(Index)) then
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
function br.GetObjectID(Unit)
	if br.unlocked and br.GetObjectExists(Unit) then
		return br._G.ObjectID(Unit)
	else
		return 0
	end
end

function br.UnitIsTappedByPlayer(mob)
	-- if br._G.UnitTarget("player") and mob == br._G.UnitTarget("player") then return true end
	-- if UnitAffectingCombat(mob) and br._G.UnitTarget(mob) then
	--    	mobPlaceHolderOne = br._G.UnitTarget(mob)
	--    	mobPlaceHolderOne = br._G.UnitCreator(mobPlaceHolderOne) or mobPlaceHolderOne
	--    	if UnitInParty(mobPlaceHolderOne) then return true end
	-- end
	-- return false
	if br._G.UnitIsTapDenied(mob)==false then
		return true
	else
		return false
	end
end
function br.getSpellUnit(spellCast,aoe,minRange,maxRange,spellType)
	local spellName = _G.GetSpellInfo(spellCast)
	if aoe == nil then aoe = false end
	local hasRange = _G.SpellHasRange(spellName) and true or false
	local facing = not aoe
	local unit = br.dynamicTarget(maxRange,facing) or (not hasRange and "player")
	if not unit then return "None" end
	local distance = br.getDistance(unit)
	local thisUnit = "None"
	if (distance >= minRange and distance < maxRange) then
		if spellType == "Helpful" then return "player" end
		if hasRange then return unit else return "player" end
	end
    return thisUnit
end
-- if getCreatureType(Unit) == true then
function br.getCreatureType(Unit)
	local CreatureTypeList = {"Critter","Totem","Non-combat Pet","Wild Pet"}
	for i=1,#CreatureTypeList do
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
-- if br.getFacing("target","player") == false then
function br.getFacing(Unit1,Unit2,Degrees)
	if Degrees == nil then
		Degrees = 90
	end
	if Unit2 == nil then
		Unit2 = "player"
	end
	if br.GetObjectExists(Unit1) and br.GetUnitIsVisible(Unit1) and br.GetObjectExists(Unit2) and br.GetUnitIsVisible(Unit2) then
		local angle3
		local angle1 = br.GetObjectFacing(Unit1)
		local angle2 = br.GetObjectFacing(Unit2)
		local Y1,X1,Z1 = br.GetObjectPosition(Unit1)
		local Y2,X2,Z2 = br.GetObjectPosition(Unit2)
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
function br.getGUID(unit)
	local nShortHand, targetGUID = "", ""
	if br.GetObjectExists(unit) then
		if br._G.UnitIsPlayer(unit) then
			targetGUID = br._G.UnitGUID(unit)
			nShortHand = string.sub(br._G.UnitGUID(unit),-5)
		else
			targetGUID = string.match(br._G.UnitGUID(unit),"-(%d+)-%x+$")
			nShortHand = string.sub(br._G.UnitGUID(unit),-5)
		end
	end
	return targetGUID,nShortHand
end
-- if br.getHP("player") then
function br.getHP(Unit)
	if br.GetObjectExists(Unit) then
		if br._G.UnitIsEnemy("player", Unit) then
			return 100*br._G.UnitHealth(Unit)/br._G.UnitHealthMax(Unit)
		else
			if not br.GetUnitIsDeadOrGhost(Unit) and br.GetUnitIsVisible(Unit) then
				for i = 1,#br.friend do
					if br.friend[i] then
						if br.friend[i].guidsh == string.sub(br._G.UnitGUID(Unit),-5) then
							return br.friend[i].hp
						end
					end
				end
				if br.getOptionCheck("Incoming Heals") == true and br._G.UnitGetIncomingHeals(Unit,"player") ~= nil then
					return 100*(br._G.UnitHealth(Unit)+br._G.UnitGetIncomingHeals(Unit,"player"))/br._G.UnitHealthMax(Unit)
				else
					return 100*br._G.UnitHealth(Unit)/br._G.UnitHealthMax(Unit)
				end
			end
		end
	end
	return 0
end
-- if br.getHPLossPercent("player",5) then
function br.getHPLossPercent(unit,sec)
	if unit == nil then unit = "player" end
	local currentHP = br.getHP(unit)
	if sec == nil then sec = 1 end
	if br.snapHP == nil then br.snapHP = 0 end
	if br.timer:useTimer("Loss Percent", sec) then
		br.snapHP = currentHP
	end
	if br.snapHP < currentHP then
		return 0
	else
		return br.snapHP - currentHP
	end
end
function br.getLowestUnit(range)
	local lowestUnit = "player"
	local lowestHP = br.getHP("player")
	if range == nil then range = 40 end
	if br ~= nil and br.friend ~= nil then
		for i = 1, #br.friend do
			local thisUnit = br.friend[i].unit
            local thisDist = br.getDistance(thisUnit)
            local thisHp = br.getHP(thisUnit)
			if thisDist < range and thisHp < lowestHP and thisHp > 0 then
                lowestUnit = thisUnit
                lowestHP = thisHp
			end
		end
	end
	return lowestUnit
end
-- if getBossID("boss1") == 71734 then
function br.getBossID(BossUnitID)
	return br.GetObjectID(BossUnitID)
end
function br.getUnitID(Unit)
	if br.GetObjectExists(Unit) and br.GetUnitIsVisible(Unit) then
		local id = select(6,_G.strsplit("-", br._G.UnitGUID(Unit) or ""))
		return tonumber(id)
	end
	return 0
end
function br.isAberration(Unit)
	if Unit == nil then Unit = "target" end
	return br._G.UnitCreatureType(Unit) == "Aberration"
end
-- if br.isAlive([Unit]) == true then
function br.isAlive(Unit)
	Unit = Unit or "player"
	if br._G.UnitIsDeadOrGhost(Unit) == false then
		return true
	end
end
function br.isInstanceBoss(unit)
	if _G.IsInInstance() then
		local _, _, encountersTotal = _G.GetInstanceLockTimeRemaining();
		for i=1,encountersTotal do
			if unit == "player" then
				local bossList = _G.GetInstanceLockTimeRemainingEncounter(i)
				br._G.print(bossList)
			end
			if br.GetObjectExists(unit) then
				local bossName = _G.GetInstanceLockTimeRemainingEncounter(i)
				local targetName = br._G.UnitName(unit)
				-- Print("Target: "..targetName.." | Boss: "..bossName.." | Match: "..tostring(targetName == bossName))
				if targetName == bossName then return true end
			end
		end
		for i = 1, 5 do
			local bossNum = "boss"..i
			if br.GetUnitIsUnit(bossNum,unit) then return true end
		end
	end
	return false
end
-- br.isBoss()
function br.isBoss(unit)
	if unit == nil then unit = "target" end
	if br.GetObjectExists(unit) and not br.isTotem(unit) then
		local class = br._G.UnitClassification(unit)
		local healthMax = br._G.UnitHealthMax(unit)
		local pHealthMax = br._G.UnitHealthMax("player")
		local instance = select(2,_G.IsInInstance())
		return br.isInstanceBoss(unit) or br.isDummy(unit)
			or (not br.isChecked("Boss Detection Only In Instance") and not br._G.UnitIsTrivial(unit) and instance ~= "party"
				and ((class == "rare" and healthMax > 4 * pHealthMax) or class == "rareelite" or class == "worldboss"
					or (class == "elite" and ((healthMax > 4 * pHealthMax and instance ~= "raid") or instance == "scenario")) or br._G.UnitLevel(unit) < 0))
	end
	return false
end
function br.isCritter(Unit) -- From LibBabble
	if Unit == nil then Unit = "target" end
	local unitType = br._G.UnitCreatureType(Unit)
	local types = {
		"Critter",
		"Kleintier",
		"Alma",
		"Bestiole",
		"Animale",
		"Bicho",
		"Существо",
		"동물",
		"小动物",
		"小動物"
	}
	return types[unitType] ~= nil
end
function br.isDemon(Unit)
	if Unit == nil then Unit = "target" end
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
	return types[unitType] ~= nil
end
function br.isExplosive(Unit)
	return br.GetObjectID(Unit) == 120651
end
function br.isUndead(Unit)
	if Unit == nil then Unit = "target" end
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
	return types[unitType] ~= nil
end
function br.isBeast(Unit)
	if Unit == nil then Unit = "target" end
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
	return types[unitType] ~= nil
end
function br.isHumanoid(Unit)
	if Unit == nil then Unit = "target" end
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
	return types[unitType] ~= nil
end
-- Dummy Check
function br.isDummy(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if br.GetObjectExists(Unit) then
		local dummies = br.lists.dummies
		local objectID = br.GetObjectID(Unit)
		-- if dummies[tonumber(string.match(UnitGUID(Unit),"-(%d+)-%x+$"))] then --~= nil
		return dummies[objectID] ~= nil
	end
	return false
end
-- if isEnemy([Unit])
function br.isEnemy(Unit)
	Unit = Unit or "target"
	if br._G.UnitCanAttack(Unit,"player") then
		return true
	else
		return false
	end
end
function br.isTankInRange()
	if #br.friend > 1 then
		for i = 1, #br.friend do
			local friend = br.friend[i]
			if friend.GetRole()== "TANK" and not br.GetUnitIsDeadOrGhost(friend.unit) and br.getDistance(friend.unit) < 40 then
				return true,friend.unit
			end
		end
	end
	return false
end
