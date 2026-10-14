local _, br = ...
---@class br.functions.combat
br.functions.combat = br.functions.combat or {}
local combat = br.functions.combat
local threatCache = {}

local function threatSituation(friendlyUnit, enemyUnit)
	if not br._G.UnitIsVisible(friendlyUnit) then
		return false
	end
	local status = br._G.UnitThreatSituation(friendlyUnit, enemyUnit)
	-- Also check detailed threat situation as a fallback
	if status == nil then
		local _, _, _, _, threatPercent = br._G.UnitDetailedThreatSituation(friendlyUnit, enemyUnit)
		-- If we have any threat percentage, consider it a valid threat situation
		if threatPercent and threatPercent > 0 then
			if br.functions.misc:isChecked("Threat Debug") then
				br.log:say("Threat", "Detailed: " .. br._G.UnitName(friendlyUnit) .. " has " ..
					br.functions.misc:round2(threatPercent, 1) .. "% threat on " .. br._G.UnitName(enemyUnit))
			end
			return true
		end
	end
	return status ~= nil
end

-- if canAttack("player","target") then
function combat:canAttack(Unit1, Unit2)
	if Unit1 == nil then
		Unit1 = "player"
	end
	if Unit2 == nil then
		Unit2 = "target"
	end
	return br._G.UnitCanAttack(Unit1, Unit2)
end

-- Returns true if the player cannot cast *this* spell due to hard loss of control.
-- Allows "regain control" spells (e.g., freedom/berserker rage) via canRegainControl().
function combat:cannotCast(spellID)
	if not br._G.C_LossOfControl then return false end
	local hard, event = combat:hasHardControl()
	if not hard or not event or not event.locType then
		return false
	end
	if spellID ~= nil and combat:canRegainControl(spellID, event.locType) then
		return false
	end
	return true
end

function combat:canRegainControl(spellID, controlEvent)
	local class = select(3, br._G.UnitClass("player"))
	-- Warrior
	if class == 1 then
		if spellID == (br.functions.spell:getHighestSpellID("berserkerRage")) and -- Fear, Sap and Incapacitate
			(controlEvent == "FEAR" or controlEvent == "FEAR_MECHANIC" or controlEvent == "ROOT"
				or controlEvent == "SNARE" or controlEvent == "STUN" or controlEvent == "STUN_MECHANIC")
		then
			return true
		end
	end
	-- Paladin
	if class == 2 then
		if spellID == (br.functions.spell:getHighestSpellID("blessingOfFreedom")) and (controlEvent == "ROOT" or controlEvent == "SNARE") then
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
		if spellID == (br.functions.spell:getHighestSpellID("lichborne")) and --Lichborne
			(controlEvent == "CHARM" or controlEvent == "FEAR" or controlEvent == "FEAR_MECHANIC" or controlEvent == "SLEEP")
		then
			return true
		end
		if spellID == (br.functions.spell:getHighestSpellID("desecratedGround")) and --Desecrated Ground
			(controlEvent == "ROOT" or controlEvent == "SNARE")
		then
			return true
		end
	end
	-- Shaman
	if class == 7 then
		if spellID == (br.functions.spell:getHighestSpellID("spiritWalk")) and -- Spirit Walk
			(controlEvent == "ROOT" or controlEvent == "SNARE")
		then
			return true
		end
		if spellID == (br.functions.spell:getHighestSpellID("windwalkTotem")) and --Windwalk Totem
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
		if spellID ==(br.functions.spell:getHighestSpellID("tigersLust")) and -- Tiger's Lust
			(controlEvent == "ROOT" or controlEvent == "SNARE")
		then
			return true
		end
		if spellID == (br.functions.spell:getHighestSpellID("nimbleBrew")) and -- Nimble Brew
			(controlEvent == "ROOT" or controlEvent == "SNARE" or controlEvent == "STUN" or controlEvent == "STUN_MECHANIC"
			or controlEvent == "FEAR" or controlEvent == "FEAR_MECHANIC")
		then
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

-- When the player entered and last left combat (GetTime). Runtime state, set from the combat events
-- (readers/common.lua); it used to live in the saved settings, which aren't there before a spec loads.
local combatStartedAt, combatEndedAt = nil, nil

-- Seconds in combat (to the millisecond), 0 out of combat.
-- if br.functions.combat:getCombatTime() <= 5 then
function combat:getCombatTime()
	if not br._G.UnitAffectingCombat("player") then return 0 end
	-- In combat without the event (a reload mid-fight): count from now
	if combatStartedAt == nil then combatStartedAt = br._G.GetTime() end
	return math.floor((br._G.GetTime() - combatStartedAt) * 1000) / 1000
end

-- if getLowAlliesInTable(60, nNove) > 3 then
function combat:getLowAlliesInTable(Value, unitTable)
	local lowAllies = 0
	for i = 1, #unitTable do
		if unitTable[i].hp <= Value then
			lowAllies = lowAllies + 1
		end
	end
	return lowAllies
end

-- Seconds since leaving combat (to the millisecond), 0 in combat; with no combat yet this session,
-- the game's uptime (GetTime), i.e. "a long time".
function combat:getOoCTime()
	if br._G.UnitAffectingCombat("player") then return 0 end
	if combatEndedAt == nil then return br._G.GetTime() end
	return math.floor((br._G.GetTime() - combatEndedAt) * 1000) / 1000
end

-- Returns true if the player is under a "hard" loss-of-control effect (typically prevents casting/attacking).
-- Also returns the matching event table (or nil).
function combat:hasHardControl()
	if not br._G.C_LossOfControl then return false, nil end
	local hardTypes = {
		STUN = true,
		STUN_MECHANIC = true,
		FEAR = true,
		FEAR_MECHANIC = true,
		CHARM = true,
		SLEEP = true,
		SILENCE = true,
		PACIFY = true,
		PACIFYSILENCE = true,
		INCAPACITATE = true,
		INCAPACITATE_MECHANIC = true,
		DISORIENT = true,
		HORROR = true,
	}
	local eventIndex = br._G.C_LossOfControl.GetActiveLossOfControlDataCount()
	if eventIndex > 0 then
		for i = 0, eventIndex do
			local event = br._G.C_LossOfControl.GetActiveLossOfControlData(i)
			if event and event.locType and hardTypes[event.locType] then
				return true, event
			end
		end
	end
	return false, nil
end

-- if hasNoControl(12345) == true then
function combat:hasNoControl(spellID)
	if not br._G.C_LossOfControl then return false end
	local event
	local eventIndex = br._G.C_LossOfControl.GetActiveLossOfControlDataCount()
	if eventIndex > 0 then
		for i = 0, eventIndex do
			event = br._G.C_LossOfControl.GetActiveLossOfControlData(i)
			if event then
				local regain = combat:canRegainControl(spellID, event.locType)
				if not regain and br.debug.timer:useTimer("regainTimer", 0.25) then regain = combat:canRegainControl(spellID, event.locType) end
				return regain
			end
		end
	end
	return false
end

-- if br.functions.combat:hasThreat("target") then
-- Whether a friendly unit has any threat on an enemy (caller has checked the enemy is visible)
function combat:hasThreat(unit, playerUnit)
	-- Early Exit
	if unit == nil then return false end
	-- Dummy Validation
	if br.functions.unit:isDummy(unit) and br.functions.range:getDistance("target", unit) < 8 then return true end
	-- Damaged Validation
	if br.engines.enemiesEngine.damaged[br._G.ObjectPointer(unit)] ~= nil then
		if br.functions.misc:isChecked("Threat Debug") then --and not br.functions.unit:GetUnitExists("target") then
			br.log:say("Threat", "Damage: " .. br._G.UnitName(unit) .. " was attacked, it now hates you.")
		end
		return true
	end

	-- FIXED: Early exit for already validated enemies to avoid expensive checks
	-- Safety check: Still verify unit is attackable to handle evade/reset/faction change scenarios
	local unitPointer = br._G.ObjectPointer(unit)
	if br._G.UnitAffectingCombat("player") and br.engines.enemiesEngine.enemy[unitPointer] ~= nil
		and br._G.UnitCanAttack("player", unit) and not br.functions.unit:GetUnitIsDeadOrGhost(unit)
	then
		if br.functions.misc:isChecked("Threat Debug") then
			br.log:say("Threat", "Validated Enemy: " .. br._G.UnitName(unit) .. " is already in enemy table.")
		end
		return true
	end

	-- Per-unit cache for expensive threat computation (0.1s TTL)
	local _tcNow = br._G.GetTime()
	local _tcEntry = threatCache[unit]
	if _tcEntry and (_tcNow - _tcEntry.time) < 0.1 then return _tcEntry.value end

	if playerUnit == nil then
		playerUnit = "player"
	end
	-- Who the unit is targeting, read once (its existence, death and target were each read several times)
	local isDead = br.functions.unit:GetUnitIsDeadOrGhost(unit)
	local targetUnit, targetFriend
	if br.functions.unit:GetUnit(unit) == nil or isDead or br._G.UnitIsTapDenied(unit) then
		targetUnit = "None"
	else
		targetUnit = br._G.UnitTarget(unit) or "None"
	end
	if targetUnit == "None" then
		targetFriend = false
	else
		targetFriend = (targetUnit == br._G.ObjectPointer("player") or br._G.UnitName(targetUnit) == br._G.UnitName("player")
			or (br.functions.unit:GetUnitExists("pet") and br._G.UnitName(targetUnit) == br._G.UnitName("pet"))
			or br._G.UnitInParty(targetUnit) or br._G.UnitInRaid(targetUnit))
	end

	-- Validation Checks
	-- Print("Unit: "..tostring(UnitName(unit)).." | Player: "..tostring(playerUnit))
	local playerInCombat = br._G.UnitAffectingCombat("player")
	local unitInCombat = br._G.UnitAffectingCombat(unit)
	-- local unitObject = br._G.ObjectPointer(unit)
	local instance = select(2, br._G.IsInInstance())

	-- Tapped Unit Targeting Validation
	-- Check if tapped unit is targeting player or group (handles quest mobs that turn hostile)
	if br._G.UnitIsTapDenied(unit) and targetFriend then
		if br.functions.misc:isChecked("Threat Debug") then
			br.log:say("Threat", "Tapped Targeting: " ..
				br._G.UnitName(unit) .. " is tapped but targeting " .. br._G.UnitName(targetUnit))
		end
		return true
	end

	-- Unit is Targeting Player/Pet/Party/Raid Validation
	if targetFriend then
		if br.functions.misc:isChecked("Threat Debug") and not br._G.UnitIsUnit("target", unit) then --and not br.functions.unit:GetObjectExists("target") then
			br.log:say("Threat", "Targeting: " ..
				br._G.UnitName(br.functions.unit:GetUnit(unit)) .. " is targeting " .. br._G.UnitName(targetUnit))
		end
		return true
	end
	-- Boss Adds Validation
	if unitInCombat and (instance == "party" or instance == "raid") and br.functions.unit:isBoss(unit) then -- cheap checks first
		if br.functions.misc:isChecked("Threat Debug") then
			br.log:say("Threat", "Boss: " .. br._G.UnitName(unit) ..
				" has threat with you.")
		end
		return true
	end
	-- Summons of an enemy we're fighting (totems, spirits, idols...) have no threat of their own: they
	-- count when their creator is an enemy in combat with the player or group (no list needed)
	if playerInCombat and br._G.UnitCanAttack("player", unit) then
		local creator = br._G.UnitCreator and br._G.UnitCreator(unit)
		creator = creator ~= nil and br._G.ObjectPointer(creator) or nil
		local enemies = br.engines.enemiesEngine
		if creator ~= nil and creator ~= br._G.ObjectPointer("player")
			and (enemies.enemy[creator] ~= nil or enemies.damaged[creator] ~= nil)
		then
			if br.functions.misc:isChecked("Threat Debug") then
				br.log:say("Threat", "Summon: " .. tostring(br._G.UnitName(unit)) .. " was summoned by an enemy you're fighting.")
			end
			return true
		end
	end
	-- Open World Mob Pack Validation
	if instance == "none" and playerInCombat and not br.functions.unit:isCritter(unit) then
		local unitPointer = br._G.ObjectPointer(unit)
		local targetPointer = br._G.ObjectPointer("target")

		-- If unit is already in the enemy engine, it has threat
		if br.engines.enemiesEngine.enemy[unitPointer] ~= nil then
			if br.functions.misc:isChecked("Threat Debug") then
				br.log:say("Threat", "Open World: " .. br._G.UnitName(unit) .. " is in enemy engine and has threat.")
			end
			return true
		end

		-- If unit is near your current target, it's part of the pack
		if br.engines.enemiesEngine.enemy[targetPointer] ~= nil then
			local distanceToTarget = br.functions.range:getDistance("target", unit)
			if distanceToTarget < 8 then
				if br.functions.misc:isChecked("Threat Debug") then
					br.log:say("Threat", "Open World: " .. br._G.UnitName(unit) .. " is within " ..
						br.functions.misc:round2(distanceToTarget, 1) .. "yrds of your target and is considered a threat.")
				end
				return true
			end
		end
	end
	-- Player Threat Validation. No one has threat on an enemy we can't see, or on one that isn't in
	-- combat (it has no threat table), so those skip the per-player threat reads.
	local enemyVisible = unitInCombat and br._G.UnitIsVisible(unit)
	if enemyVisible and not isDead and threatSituation(playerUnit, unit) then
		if br.functions.misc:isChecked("Threat Debug") then --and not br.functions.unit:GetObjectExists("target") then
			br.log:say("Threat", "Player: " .. br._G.UnitName(playerUnit) .. " has threat with " .. br._G.UnitName(unit))
		end
		threatCache[unit] = { value = true, time = _tcNow }
		return true
	end
	-- Party/Raid Threat Validation
	if enemyVisible and not isDead and #br.engines.healingEngine.friend >= 1 then
		for i = 1, #br.engines.healingEngine.friend do
			if br.engines.healingEngine.friend[i] then
				local thisUnit = br.engines.healingEngine.friend[i].unit
				if threatSituation(thisUnit, unit) then
					if br.functions.misc:isChecked("Threat Debug") then --and not br.functions.unit:GetObjectExists("target") then
						br.log:say("Threat", "Party/Raid: " ..
							br._G.UnitName(thisUnit) .. " has threat with " .. br._G.UnitName(unit))
					end
					threatCache[unit] = { value = true, time = _tcNow }
					return true
				end
			end
		end
	end
	-- Note: Fallback removed - the above checks should be sufficient to detect valid threats
	-- without risking false positives from mobs fighting NPCs or other groups
	threatCache[unit] = { value = false, time = _tcNow }
	return false
end

function combat:isIncapacitated(spellID)
	if not br._G.C_LossOfControl then return false end
	-- Initialize tracking table if it doesn't exist
	if not br.incapacitationTracker then
		br.incapacitationTracker = {}
	end

	local event
	local eventIndex = br._G.C_LossOfControl.GetActiveLossOfControlDataCount()
	if eventIndex > 0 then
		for i = 0, eventIndex do
			event = br._G.C_LossOfControl.GetActiveLossOfControlData(i)
			if event then
				local eventType = event.locType
				local canRegain = combat:canRegainControl(spellID, eventType)

				-- If we cannot regain control (meaning we are incapacitated)
				if not canRegain then
					-- Create a unique key for this event type
					local trackerKey = eventType .. "_" .. spellID

					-- If this is a new incapacitation, record the start time
					if not br.incapacitationTracker[trackerKey] then
						br.incapacitationTracker[trackerKey] = br._G.GetTime()
					end

					-- Calculate time since incapacitation started
					local timeSinceStart = br._G.GetTime() - br.incapacitationTracker[trackerKey]

					-- Human-like delay: 0.15 to 0.45 seconds (base 0.3 +/- 0.15)
					-- You can adjust this value or make it configurable
					local reactionDelay = 0.15 + math.random() * 0.3

					-- Only return true (we are incapacitated) if enough time has passed
					if timeSinceStart >= reactionDelay then
						return true
					else
						-- Still within reaction time, pretend we haven't noticed yet
						return false
					end
				else
					-- We can regain control, so clean up the tracker
					local trackerKey = eventType .. "_" .. spellID
					br.incapacitationTracker[trackerKey] = nil
				end
			end
		end
	else
		-- No loss of control events, clear all trackers
		br.incapacitationTracker = {}
	end
	return false
end

-- BR's notion of "in combat". For the player this also honours the "Ignore Combat" and
-- "Tank Aggro = Player Aggro" options, and treats the player as in combat while grouped
-- and the target is in combat. Other units only use UnitAffectingCombat.
-- if br.functions.combat:isInCombat("player") then
function combat:isInCombat(thisUnit)
	if thisUnit == nil then thisUnit = "player" end
	if br._G.UnitAffectingCombat(thisUnit) then return true end
	if not br.functions.unit:GetUnitIsUnit(thisUnit, "player") then return false end
	return br.functions.misc:isChecked("Ignore Combat")
		or (br.functions.misc:isChecked("Tank Aggro = Player Aggro") and combat:isTankInCombat())
		or (br._G.GetNumGroupMembers() > 1 and br._G.UnitAffectingCombat("target"))
end

-- True if a tank in the player's party/raid within 40 yards is in combat.
-- if br.functions.combat:isTankInCombat() then
--- True when the player is the tank: their group role is Tank, or they're in a tanking form or
--- stance (br.functions.spell:isTankForm).
function combat:isPlayerTank()
	if br._G.UnitGroupRolesAssigned and br._G.UnitGroupRolesAssigned("player") == "TANK" then return true end
	return br.functions.spell:isTankForm(br.functions.unit:getFormSpellID())
end

--- True when it's a good moment to start a fight (e.g. break a crowd control): the player isn't
--- low on health or mana, or eating or drinking, and in a group the tanks aren't low on health.
--- Thresholds: the Ready To Fight Health / Mana options (Targeting page; health 60 when unset).
function combat:isReadyToFight()
	local unitFns, misc = br.functions.unit, br.functions.misc
	local readyHealth = misc:getOptionValue("Ready To Fight Health")
	if readyHealth <= 0 then readyHealth = 60 end
	-- 0 means no mana requirement (the option registers 40 at startup)
	local readyMana = misc:getOptionValue("Ready To Fight Mana")
	if unitFns:getHP("player") < readyHealth then return false end
	if readyMana > 0 and unitFns:usesMana() then
		local maxMana = br._G.UnitPowerMax("player", 0)
		if maxMana > 0 and br._G.UnitPower("player", 0) / maxMana * 100 < readyMana then return false end
	end
	if unitFns:isEating("player") or unitFns:isDrinking("player") then return false end
	local healing = br.engines.healingEngineFunctions
	if br._G.GetNumGroupMembers() > 1 and healing and healing.getTanksTable then
		for _, tank in ipairs(healing:getTanksTable()) do
			if unitFns:getHP(tank.unit) < readyHealth then return false end
		end
	end
	return true
end

function combat:isTankInCombat()
	local instance = select(2, br._G.IsInInstance())
	if instance ~= "raid" and instance ~= "party" then return false end
	local tanksTable = br.engines.healingEngineFunctions:getTanksTable()
	if tanksTable == nil then return false end
	for i = 1, #tanksTable do
		if br._G.UnitAffectingCombat(tanksTable[i].unit) and tanksTable[i].distance < 40 then
			return true
		end
	end
	return false
end

function combat:isTanking(unit)
	return br._G.UnitThreatSituation("player", unit) ~= nil and br._G.UnitThreatSituation("player", unit) >= 2
end

-- The combat events call this: true on entering combat, false on leaving it.
function combat:setInCombat(inCombat)
	if inCombat then
		combatStartedAt = br._G.GetTime()
	else
		combatStartedAt, combatEndedAt = nil, br._G.GetTime()
	end
end
