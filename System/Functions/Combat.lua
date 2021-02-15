local _, br = ...
function br.canAoE(unit, distance)
	local notValid = false
	if unit == nil then
		return false
	end
	if distance == nil then
		distance = 8
	end
	for i = 1, #br.getEnemies(unit, distance) do
		local thisUnit = br.getEnemies(unit, distance)[i]
		if not br.isValidUnit(thisUnit) then
			notValid = true
			break
		end
	end
	if notValid then
		return false
	end
	return true
end
-- if canAttack("player","target") then
function br.canAttack(Unit1, Unit2)
	if Unit1 == nil then
		Unit1 = "player"
	end
	if Unit2 == nil then
		Unit2 = "target"
	end
	return br._G.UnitCanAttack(Unit1, Unit2)
end
function br.canDisarm(Unit)
	if br.DisarmedTarget == nil then
		br.DisarmedTarget = 0
	end
	if br.isDisarmed == true then
		if br.GetUnitExists(Unit) and br._G.UnitGUID(Unit) ~= br.DisarmedTarget then
			br.DisarmedTarget = br._G.UnitGUID(Unit)
			return false
		else
			br.isDisarmed = false
			return true
		end
	end
	if not br.isInCombat("player") or br.GetUnitExists(Unit) then
		if not br.isInCombat("player") or br._G.UnitGUID(Unit) ~= br.DisarmedTarget then
			br.isDisarmed = false
			return true
		end
	end
end
-- if br.getCombatTime() <= 5 then
function br.getCombatTime()
	local combatStarted = br.data.settings[br.selectedSpec]["Combat Started"]
	local combatTime = br.data.settings[br.selectedSpec]["Combat Time"]
	if combatStarted == nil then
		return 0
	end
	if combatTime == nil then
		combatTime = 0
	end
	if br._G.UnitAffectingCombat("player") == true then
		combatTime = (_G.GetTime() - combatStarted)
	else
		combatTime = 0
	end
	br.data.settings[br.selectedSpec]["Combat Time"] = combatTime
	return (math.floor(combatTime * 1000) / 1000)
end
function br.getOoCTime()
	local combatStarted = br.data.settings[br.selectedSpec]["Combat Started"]
	local combatTime
	if combatStarted ~= nil then
		return _G.GetTime()
	end
	if br._G.UnitAffectingCombat("player") == false then
		combatTime = (_G.GetTime() - combatStarted)
	else
		combatTime = 0
	end
	return (math.floor(combatTime * 1000) / 1000)
end
-- if getLowAllies(60) > 3 then
function br.getLowAllies(Value)
	local lowAllies = 0
	for i = 1, #br.friend do
		if br.friend[i].hp <= Value then
			lowAllies = lowAllies + 1
		end
	end
	return lowAllies
end
-- if getLowAlliesInTable(60, nNove) > 3 then
function br.getLowAlliesInTable(Value, unitTable)
	local lowAllies = 0
	for i = 1, #unitTable do
		if unitTable[i].hp <= Value then
			lowAllies = lowAllies + 1
		end
	end
	return lowAllies
end
-- if getNumEnemies("target",10) >= 3 then
function br.getNumEnemies(Unit, Radius)
	return #br.getEnemies(Unit, Radius)
end

function br.isIncapacitated(spellID)
	local event
	local eventIndex = _G.C_LossOfControl.GetActiveLossOfControlDataCount()
	if eventIndex > 0 then
		for i = 0, eventIndex do
			event = _G.C_LossOfControl.GetActiveLossOfControlData(i)
			if event then
				if not br.canRegainControl(spellID, event.locType) and (event.locType ~= "DISARM" and event.locType ~= "ROOT" or event.locType == "SNARE") then
					-- (event.locType == "NONE"
					-- 	or event.locType == ""CHARM""
					-- 	or event.locType == "DISORIENT"
					-- 	or event.locType == "FEAR"
					-- 	or event.locType == "GRIP"
					-- 	or event.locType == "HORROR"
					-- 	or event.locType == "INCAPACITATE"
					-- 	or event.locType == "ROOT"
					-- 	or event.locType == "SLEEP"
					-- 	or event.locType == "SNARE"
					-- 	or event.locType == "STUN")
					-- 	and not canRegainControl(spellID,event.locType)
					return true
				end
			end
		end
	end
	return false
end
function br.canRegainControl(spellID, controlEvent)
	local class = select(3, br._G.UnitClass("player"))
	-- Warrior
	if class == 1 then
		if
			spellID == 18499 and -- Fear, Sap and Incapacitate
				(controlEvent == "FEAR" or controlEvent == "ROOT" or controlEvent == "SNARE" or controlEvent == "STUN")
		 then
			return true
		end
	end
	-- Paladin
	if class == 2 then
		if spellID == 1044 and (controlEvent == "ROOT" or controlEvent == "SNARE") then
			return true
		end
	end
	-- Hunter
	if class == 3 then
		if controlEvent == "ROOT" or controlEvent == "SNARE" then
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
		if
			spellID == 49039 and --Lichborne
				(controlEvent == "CHARM" or controlEvent == "FEAR" or controlEvent == "SLEEP")
		 then
			return true
		end
		if
			spellID == 108201 and --Desecrated Ground
				(controlEvent == "ROOT" or controlEvent == "SNARE")
		 then
			return true
		end
	end
	-- Shaman
	if class == 7 then
		if
			spellID == 58875 and -- Spirit Walk
				(controlEvent == "ROOT" or controlEvent == "SNARE")
		 then
			return true
		end
		if
			spellID == 108273 and --Windwalk Totem
				(controlEvent == "ROOT" or controlEvent == "SNARE")
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
		if controlEvent == "ROOT" or controlEvent == "SNARE" then
			return true
		end
	end
	-- Druid
	if class == 11 then
		if tostring(controlEvent) == "ROOT" or controlEvent == "SNARE" then
			return true
		end
	end
	return false
end
-- if hasNoControl(12345) == true then
function br.hasNoControl(spellID)
	local event
	local eventIndex = _G.C_LossOfControl.GetActiveLossOfControlDataCount()
	if eventIndex > 0 then
		for i = 0, eventIndex do
			event = _G.C_LossOfControl.GetActiveLossOfControlData(i)
			if event then
				-- Print("Event LocType: "..tostring(event.locType).." - LockoutSchool "..tostring(event.lockoutSchool))
				if br.canRegainControl(spellID, event.locType) then
					return true
				end
			end
		end
	end
	return false
end
-- if br.hasThreat("target") then
function br.hasThreat(unit, playerUnit)
	-- Damaged Validation
	if br.damaged[br._G.ObjectPointer(unit)] ~= nil --[[Print("[Damage Threat] You attacked "..UnitName(unit).." it now hates you.")]] then
		return true
	end
	local instance = select(2, _G.IsInInstance())
	if playerUnit == nil then
		playerUnit = "player"
	end
	local targetUnit, targetFriend
	if br.GetUnit(unit) == nil or br.GetUnitIsDeadOrGhost(unit) or br._G.UnitIsTapDenied(unit) then
		targetUnit = "None"
	elseif br._G.UnitTarget(br.GetUnit(unit)) ~= nil then
		targetUnit = br._G.UnitTarget(br.GetUnit(unit))
	else
		targetUnit = "None"
	end
	if targetUnit == "None" then
		targetFriend = false
	else
		targetFriend =
			(br.isTargeting(unit) or br._G.UnitName(targetUnit) == br._G.UnitName("player") or (br.GetUnitExists("pet") and br._G.UnitName(targetUnit) == br._G.UnitName("pet")) or
			br._G.UnitInParty(targetUnit) or
			br._G.UnitInRaid(targetUnit))
	end

	local function threatSituation(friendlyUnit, enemyUnit)
		if not UnitIsVisible(friendlyUnit) or not UnitIsVisible(enemyUnit) then
			return false
		end
		local _, _, threatPct = br._G.UnitDetailedThreatSituation(friendlyUnit, enemyUnit)
		if threatPct ~= nil then
			if threatPct > 0 then
				if br.isChecked("Cast Debug") and not br.GetUnitExists("target") then
					br._G.print(br._G.UnitName(enemyUnit) .. " is threatening " .. br._G.UnitName(friendlyUnit) .. ".")
				end
				return true
			end
		end
		return false
	end

	-- Valididation Checks
	-- Print(tostring(unit).." | "..tostring(br.GetUnit(unit)).." | "..tostring(targetUnit).." | "..tostring(targetFriend))
	if unit == nil --[[or (not br.GetObjectExists(targetUnit) and br.lists.threatBypass[unitID] == nil)]] then
		return false
	end
	-- Print("Unit: "..tostring(UnitName(unit)).." | Player: "..tostring(playerUnit))
	local playerInCombat = br._G.UnitAffectingCombat("player")
	local unitInCombat = br._G.UnitAffectingCombat(unit)
	local unitObject = br._G.ObjectPointer(unit)
	-- Unit is Targeting Player/Pet/Party/Raid Validation
	if targetFriend then
		if br.isChecked("Cast Debug") and not br.GetObjectExists("target") then
			br._G.print(br._G.UnitName(br.GetUnit(unit)) .. " is targetting " .. br._G.UnitName(targetUnit))
		end
		-- Print("[Targeting Threat] "..UnitName(br.GetUnit(unit)).." is targetting "..UnitName(targetUnit))
		return targetFriend
	end
	-- Boss Adds Validation
	if br.isBoss(unit) and unitInCombat and (instance == "party" or instance == "raid") then
		-- Print("[Boss Threat] "..UnitName(unit).." has threat with you.")
		return true
	-- Threat Bypass Validation
	-- elseif playerInCombat and br.lists.threatBypass[unitID] ~= nil and #br.getEnemies(unit,20,true) == 0 then
	-- 		return true
	end
	-- Open World Mob Pack Validation
	if instance == "none" and playerInCombat and br.enemy[br._G.ObjectPointer("target")] ~= nil and br.enemy[objectUnit] == nil and br.getDistance("target", unitObject) < 8 then
		-- if isChecked("Cast Debug") then Print("[Open World Threat] "..UnitName(unit).." is within "..round2(getDistance("target",unitObject),1).."yrds of your target and is considered a threat.") end
		-- Print("[Open World Threat] "..UnitName(unit).." is within "..round2(getDistance("target",unitObject),1).."yrds of your target and is considered a threat.")
		return true
	end
	-- Player Threat Valdation
	if threatSituation(playerUnit, unit) then
		-- Print("[Player Threat] "..UnitName(playerUnit).." have threat with "..UnitName(unit))
		return true
	end
	-- Party/Raid Threat Validation
	if #br.friend > 1 then
		for i = 1, #br.friend do
			if br.friend[i] then
				local thisUnit = br.friend[i].unit
				if threatSituation(thisUnit, unit) then
					-- Print("[Party/Raid Threat] "..UnitName(thisUnit).." has threat with "..UnitName(unit))
					return true
				end
			end
		end
	end
	return false
end
function br.isTanking(unit)
	return br._G.UnitThreatSituation("player", unit) ~= nil and br._G.UnitThreatSituation("player", unit) >= 2
end
-- if isAggroed("target") then
function br.isAggroed(unit)
	for i = 1, #br.friend do
		local friend = br.friend[i].unit
		local threat = select(5, br._G.UnitDetailedThreatSituation(friend, unit))
		if threat ~= nil then
			if threat >= 0 then
				return true
			end
		end
	end
	return false
end
