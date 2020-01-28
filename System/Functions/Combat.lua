function canAoE(unit,distance)
	local notValid = false
	if unit == nil then return false end
	if distance == nil then distance = 8 end
	for i = 1, #getEnemies(unit,distance) do
		local thisUnit = getEnemies(unit,distance)[i]
		if not isValidUnit(thisUnit) then
			notValid = true;
			break
		end
	end
	if notValid then
		return false
	end
	return true
end
-- if canAttack("player","target") then
function canAttack(Unit1,Unit2)
	if Unit1 == nil then
		Unit1 = "player"
	end
	if Unit2 == nil then
		Unit2 = "target"
	end
	return UnitCanAttack(Unit1,Unit2)
end
function canDisarm(Unit)
	if DisarmedTarget == nil then DisarmedTarget = 0 end
	if isDisarmed == true then
		if GetUnitExists(Unit) and UnitGUID(Unit)~=DisarmedTarget then
			DisarmedTarget = UnitGUID(Unit)
			return false
		else
			isDisarmed = false
			return true
		end
	end
	if not isInCombat("player") or GetUnitExists(Unit) then
		if not isInCombat("player") or UnitGUID(Unit)~=DisarmedTarget then
			isDisarmed = false
			return true
		end
	end
end
-- if getCombatTime() <= 5 then
function getCombatTime()
	local combatStarted = br.data.settings[br.selectedSpec]["Combat Started"]
	local combatTime = br.data.settings[br.selectedSpec]["Combat Time"]
	if combatStarted == nil then
		return 0
	end
	if combatTime == nil then
		combatTime = 0
	end
	if UnitAffectingCombat("player") == true then
		combatTime = (GetTime() - combatStarted)
	else
		combatTime = 0
	end
	br.data.settings[br.selectedSpec]["Combat Time"] = combatTime
	return (math.floor(combatTime*1000)/1000)
end
-- if getLowAllies(60) > 3 then
function getLowAllies(Value)
	local lowAllies = 0
	for i = 1,#br.friend do
		if br.friend[i].hp <= Value then
			lowAllies = lowAllies + 1
		end
	end
	return lowAllies
end
-- if getLowAlliesInTable(60, nNove) > 3 then
function getLowAlliesInTable(Value, unitTable)
	local lowAllies = 0
	for i = 1,#unitTable do
		if unitTable[i].hp <= Value then
			lowAllies = lowAllies + 1
		end
	end
	return lowAllies
end
-- if getNumEnemies("target",10) >= 3 then
function getNumEnemies(Unit,Radius)
	return #getEnemies(Unit,Radius)
end

function isIncapacitated(spellID)
	local eventIndex = C_LossOfControl.GetNumEvents()
	while (eventIndex > 0) do
		local _,_,text = C_LossOfControl.GetEventInfo(eventIndex)
		if (text == LOSS_OF_CONTROL_DISPLAY_FEAR
			or text == LOSS_OF_CONTROL_DISPLAY_HORROR
			or text == LOSS_OF_CONTROL_DISPLAY_STUN
			or text == LOSS_OF_CONTROL_DISPLAY_CHARM
			or text == LOSS_OF_CONTROL_DISPLAY_SLEEP
			or text == LOSS_OF_CONTROL_DISPLAY_DISORIENT
			or text == LOSS_OF_CONTROL_DISPLAY_INCAPACITATE
			or text == LOSS_OF_CONTROL_DISPLAY_GRIP)
			and not hasNoControl(spellID)
		then
			return true
		end
	end
	return false
end
-- if hasNoControl(12345) == true then
function hasNoControl(spellID,unit)
	if unit==nil then unit="player" end
	local eventIndex = C_LossOfControl.GetNumEvents()
	while (eventIndex > 0) do
		local _,_,text = C_LossOfControl.GetEventInfo(eventIndex)
		local class = select(3,UnitClass("player"))
		-- Warrior
		if class == 1 then
			if spellID == 18499
				-- Fear, Sap and Incapacitate
				and (text == LOSS_OF_CONTROL_DISPLAY_FEAR
				or text == LOSS_OF_CONTROL_DISPLAY_ROOT
				or text == LOSS_OF_CONTROL_DISPLAY_SNARE
				or text == LOSS_OF_CONTROL_DISPLAY_STUN)
			then
				return true
			end
		end
		-- Paladin
		if class == 2 then
			if spellID == 1044
				and (text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE)
			then
				return true
			end
		end
		-- Hunter
		if class == 3 then
			if text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE then
				return true
			end
		end
		-- Rogue
		if class == 4 then
		end
		-- Priest
		if class == 5 then
		end
		-- Death Knight
		if class == 6 then
			if spellID == 49039 --Lichborne
				and (text == LOSS_OF_CONTROL_DISPLAY_CHARM
				or text == LOSS_OF_CONTROL_DISPLAY_FEAR
				or text == LOSS_OF_CONTROL_DISPLAY_SLEEP)
			then
				return true
			end
			if spellID == 108201 --Desecrated Ground
				and (text == LOSS_OF_CONTROL_DISPLAY_ROOT
				or text == LOSS_OF_CONTROL_DISPLAY_SNARE)
			then
				return true
			end
		end
		-- Shaman
		if class == 7 then
			if spellID == 58875 -- Spirit Walk
				and (text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE)
			then
				return true
			end
			if spellID == 8143 --Tremor Totem
				and	(text == LOSS_OF_CONTROL_DISPLAY_CHARM
				or text == LOSS_OF_CONTROL_DISPLAY_FEAR
				or text == LOSS_OF_CONTROL_DISPLAY_SLEEP)
			then
				return true
			end
			if spellID == 108273 --Windwalk Totem
				and (text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE)
			then
				return true
			end
		end
		-- Mage
		if class == 8 then
		end
		-- Warlock
		if class == 9 then
		end
		-- Monk
		if class == 10 then
			if text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE then
				return true
			end
		end
		-- Druid
		if class == 11 then
			if tostring(text) == "Rooted" --[[LOSS_OF_CONTROL_DISPLAY_ROOT]] or text == LOSS_OF_CONTROL_DISPLAY_SNARE then
				return true
			end
		end
		eventIndex = eventIndex - 1
	end
	return false
end
-- if hasThreat("target") then
function hasThreat(unit,playerUnit)
	-- Damaged Validation
	if br.damaged[ObjectPointer(unit)] ~= nil then return true end
	local unitID = getUnitID(unit)
	local instance = select(2,IsInInstance())
	if playerUnit == nil then playerUnit = "player" end
	local targetUnit, targetFriend
	if GetUnit(unit) == nil or UnitIsDeadOrGhost(unit) or UnitIsTapDenied(unit) then
		targetUnit = "None"
	elseif UnitTarget(GetUnit(unit)) ~= nil then
		targetUnit = UnitTarget(GetUnit(unit))
	else
		targetUnit = "None"
	end
	if targetUnit == "None" then targetFriend = false
	else targetFriend = (UnitName(targetUnit) == UnitName("player") or (UnitExists("pet") and UnitName(targetUnit) == UnitName("pet")) or UnitInParty(targetUnit) or UnitInRaid(targetUnit))
	end
	local function threatSituation(friendlyUnit,enemyUnit)
		local _,_,threatPct = UnitDetailedThreatSituation(friendlyUnit,enemyUnit)
		if threatPct ~= nil then 
			if threatPct > 0 then
				if isChecked("Cast Debug") and not UnitExists("target") then Print(UnitName(enemyUnit).." is threatening "..UnitName(friendlyUnit).."."); end
				return true
			end
		end	 
		return false
	end
	-- Print(tostring(unit).." | "..tostring(GetUnit(unit)).." | "..tostring(targetUnit).." | "..tostring(targetFriend))
	if unit == nil --[[or (not GetObjectExists(targetUnit) and br.lists.threatBypass[unitID] == nil)]] then return false end
	if targetFriend then
		if isChecked("Cast Debug") and not GetObjectExists("target") then Print(UnitName(GetUnit(unit)).." is targetting "..UnitName(targetUnit)) end
		return targetFriend
	-- elseif br.damaged[ObjectPointer(unit)] ~= nil then --UnitAffectingCombat("player") and br.lists.threatBypass[unitID] ~= nil and #getEnemies(unit,20,true) == 0 then
	-- 	return true
	elseif threatSituation(playerUnit, unit) then
		return true
	elseif #br.friend > 1 then
		for i = 1, #br.friend do
			local thisUnit = br.friend[i].unit
			if threatSituation(thisUnit,unit) then
				return true
			end
		end
	elseif isBoss() and UnitAffectingCombat(unit) and (instance == "party" or instance == "raid") then
		return true
	end
	return false
end
function isTanking(unit)
	return UnitThreatSituation("player", unit) ~= nil and UnitThreatSituation("player", unit) >= 2
end
-- if isAggroed("target") then
function isAggroed(unit)
	for i = 1, #br.friend do
		local friend = br.friend[i].unit
		local threat = select(5,UnitDetailedThreatSituation(friend,unit))
		if threat ~= nil then
			if threat >= 0 then
				return true
			end
		end
	end
	return false
end
