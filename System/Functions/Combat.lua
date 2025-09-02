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
		combatTime = (br._G.GetTime() - combatStarted)
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
		return br._G.GetTime()
	end
	if br._G.UnitAffectingCombat("player") == false then
		combatTime = (br._G.GetTime() - combatStarted)
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
	local eventIndex = br._G.C_LossOfControl.GetActiveLossOfControlDataCount()
	if eventIndex > 0 then
		for i = 0, eventIndex do
			event = br._G.C_LossOfControl.GetActiveLossOfControlData(i)
			if event then
				local eventType = event.locType
				return not br.canRegainControl(spellID, eventType)
			end
		end
	end
	return false
end

function br.canRegainControl(spellID, controlEvent)
	local class = select(3, br._G.UnitClass("player"))
	-- Warrior
	if class == 1 then
		if spellID == 18499 and -- Fear, Sap and Incapacitate
			(controlEvent == "FEAR" or controlEvent == "FEAR_MECHANIC" or controlEvent == "ROOT"
				or controlEvent == "SNARE" or controlEvent == "STUN" or controlEvent == "STUN_MECHANIC")
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
		if controlEvent == "ROOT" or controlEvent == "SNARE" then
			return true
		end
	end
	-- Death Knight
	if class == 6 then
		if spellID == 49039 and --Lichborne
			(controlEvent == "CHARM" or controlEvent == "FEAR" or controlEvent == "FEAR_MECHANIC" or controlEvent == "SLEEP")
		then
			return true
		end
		if spellID == 108201 and --Desecrated Ground
			(controlEvent == "ROOT" or controlEvent == "SNARE")
		then
			return true
		end
	end
	-- Shaman
	if class == 7 then
		if spellID == 58875 and -- Spirit Walk
			(controlEvent == "ROOT" or controlEvent == "SNARE")
		then
			return true
		end
		if spellID == 108273 and --Windwalk Totem
			(controlEvent == "ROOT" or controlEvent == "SNARE")
		then
			return true
		end
	end
	-- Mage
	if class == 8 then
		if controlEvent == "ROOT" or controlEvent == "SNARE" then
			return true
		end
	end
	-- Warlock
	if class == 9 then
		if controlEvent == "ROOT" or controlEvent == "SNARE" then
			return true
		end
	end
	-- Monk
	if class == 10 then
		if controlEvent == "ROOT" or controlEvent == "SNARE" then
			return true
		end
	end
	-- Druid
	if class == 11 then
		if controlEvent == "ROOT" or controlEvent == "SNARE" then
			return true
		end
	end
	-- DemonHunter
	if class == 12 then
		if controlEvent == "ROOT" or controlEvent == "SNARE" then
			return true
		end
	end
	-- Evoker
	if class == 13 then
	end
	return false
end

-- if hasNoControl(12345) == true then
function br.hasNoControl(spellID)
	local event
	local eventIndex = br._G.C_LossOfControl.GetActiveLossOfControlDataCount()
	if eventIndex > 0 then
		for i = 0, eventIndex do
			event = br._G.C_LossOfControl.GetActiveLossOfControlData(i)
			if event then
				local regain = br.canRegainControl(spellID, event.locType)
				if not regain and br.timer:useTimer("regainTimer", 0.25) then regain = br.canRegainControl(spellID, event.locType) end
				return regain
			end
		end
	end
	return false
end

-- if br.hasThreat("target") then
function br.hasThreat(unit, playerUnit)
	-- Early Exit
	if unit == nil then return false end
	-- Dummy Validation
	if br.isDummy(unit) and br.getDistance("target", unit) < 8 then return true end
	-- Damaged Validation
	if br.damaged[br._G.ObjectPointer(unit)] ~= nil then
		if br.isChecked("Threat Debug") then --and not br.GetUnitExists("target") then
			br._G.print("[Damage Threat] " .. br._G.UnitName(unit) .. " was attacked, it now hates you.")
		end
		return true
	end
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
	if not targetUnit or targetUnit == "None" then
		targetFriend = false
	else
		targetFriend = (br.isTargeting(unit) or br._G.UnitName(targetUnit) == br._G.UnitName("player")
			or (br.GetUnitExists("pet") and br._G.UnitName(targetUnit) == br._G.UnitName("pet"))
			or br._G.UnitInParty(targetUnit) or br._G.UnitInRaid(targetUnit))
	end

	local function threatSituation(friendlyUnit, enemyUnit)
		local friendlyUnit = br._G.UnitGUID(friendlyUnit)
		if not br._G.UnitIsVisible(friendlyUnit) or not br._G.UnitIsVisible(enemyUnit) then
			return false
		end
		local status = br._G.UnitThreatSituation(friendlyUnit, enemyUnit)
		return status ~= nil
	end

	-- Valididation Checks
	-- Print("Unit: "..tostring(UnitName(unit)).." | Player: "..tostring(playerUnit))
	local playerInCombat = br._G.UnitAffectingCombat("player")
	local unitInCombat = br._G.UnitAffectingCombat(unit)
	-- local unitObject = br._G.ObjectPointer(unit)
	local instance = select(2, br._G.IsInInstance())
	-- Unit is Targeting Player/Pet/Party/Raid Validation
	if targetFriend then
		if br.isChecked("Threat Debug") and not br._G.UnitIsUnit("target", unit) then --and not br.GetObjectExists("target") then
			br._G.print("[Targeting Threat] " ..
				br._G.UnitName(br.GetUnit(unit)) .. " is targeting " .. br._G.UnitName(targetUnit))
		end
		return true
	end
	-- Boss Adds Validation
	if br.isBoss(unit) and unitInCombat and (instance == "party" or instance == "raid") then
		if br.isChecked("Threat Debug") then
			br._G.print("[Boss Threat] " .. br._G.UnitName(unit) ..
				" has threat with you.")
		end
		return true
		-- Threat Bypass Validation
		-- elseif playerInCombat and br.lists.threatBypass[unitID] ~= nil and #br.getEnemies(unit,20,true) == 0 then
		-- 		return true
	end
	-- Open World Mob Pack Validation
	if instance == "none" and playerInCombat and not br.isCritter(unit) and br.enemy[br._G.ObjectPointer("target")] ~= nil and br.enemy[unit] == nil and br.getDistance("target", unit) < 8 then
		if br.isChecked("Threat Debug") then br._G.print("[Open World Threat] "..br._G.UnitName(unit).." is within "..br.round2(br.getDistance("target",unit),1).."yrds of your target and is considered a threat.") end
		return true
	end
	-- Player Threat Valdation
	if threatSituation(playerUnit, unit) and not br.GetUnitIsDeadOrGhost(unit) then
		if br.isChecked("Threat Debug") then --and not br.GetObjectExists("target") then
			br._G.print("[Player Threat] " .. br._G.UnitName(playerUnit) .. " has threat with " .. br._G.UnitName(unit))
		end
		return true
	end
	-- Party/Raid Threat Validation
	if #br.friend > 1 then
		for i = 1, #br.friend do
			if br.friend[i] then
				local thisUnit = br.friend[i].unit
				if threatSituation(thisUnit, unit) and not br.GetUnitIsDeadOrGhost(unit) then
					if br.isChecked("Threat Debug") then --and not br.GetObjectExists("target") then
						br._G.print("[Party/Raid Threat] " ..
							br._G.UnitName(thisUnit) .. " has threat with " .. br._G.UnitName(unit))
					end
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
