local _, br = ...
-- Which units count: valid targets, the enemies list check, targeting and tanks.
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc

local isValidUnitCache = {}

local lastIsValidUnitCleanup = 0

--if isLongTimeCCed("target") then
-- CCs with >=20 seconds
function misc:isLongTimeCCed(Unit)
	if Unit == nil then
		return false
	end
	local longTimeCC = br.lists.longCC
	for i = 1, 40 do
		local auraInfo = br.api.wow.GetDebuffDataByIndex(Unit, i)
		if auraInfo and longTimeCC[tonumber(auraInfo.spellId)] == true then return true end
	end
	return false
end

function misc:isPlayer(Unit)
	if br.functions.unit:GetUnitExists(Unit) ~= true then
		return false
	end
	if br._G.UnitIsPlayer(Unit) == true then
		return true
	elseif br._G.UnitIsPlayer(Unit) ~= true then
		if br.lists.unitRules.provingGrounds[tonumber(string.match(br._G.UnitGUID(Unit), "-(%d+)-%x+$"))] ~= nil then
			return true
		end
	else
		return false
	end
end

function misc:isTargeting(Unit, MatchUnit)
	local thisUnit = br.functions.unit:GetUnit(Unit)
	if thisUnit == nil then
		return false
	end
	local unitTarget = br._G.UnitTarget(thisUnit)
	if unitTarget == nil then
		return false
	end
	return unitTarget == br._G.ObjectPointer(MatchUnit or "player")
end

function misc:hasTank()
	if #br.engines.healingEngine.friend == 1 then return false end
	for i = 1, #br.engines.healingEngine.friend do
		local thisUnit = br.engines.healingEngine.friend[i].unit
		if br._G.UnitGroupRolesAssigned(thisUnit) == "TANK"
			and br.functions.range:getDistance(thisUnit) < 40 and br._G.UnitIsPlayer(thisUnit)
		then
			return true
		end
	end
	return false
end

-- distance: the unit's distance from the player if the caller has just measured it
-- Other players count as enemies while the player, or they, have one of the unitRules debuffs
local function isAttackablePlayer(Unit)
	if not br._G.UnitIsPlayer(Unit) then return false end
	local rules = br.lists.unitRules
	for _, debuff in ipairs(rules.attackPlayersWhilePlayerHas) do
		if br.functions.aura:UnitDebuffID("player", debuff) then return true end
	end
	for _, debuff in ipairs(rules.attackPlayersWithDebuff) do
		if br.functions.aura:UnitDebuffID(Unit, debuff) then return true end
	end
	return false
end

function misc:enemyListCheck(Unit, distance)
	-- local targetBuff = 0
	-- local playerBuff = 0
	-- if br.functions.aura:UnitDebuffID(Unit, 310499) then
	-- 	targetBuff = 1
	-- end
	-- if br.functions.aura:UnitDebuffID("player", 310499) then
	-- 	playerBuff = 1
	-- end
	-- if targetBuff ~= playerBuff then
	-- 	if br.functions.misc:isChecked("Enemy List Debug") then
	-- 		br._G.print("[EnemyListCheck] Phase sync failed for " .. tostring(br._G.UnitName(Unit)))
	-- 	end
	-- 	return false
	-- end
	local phaseReason = br._G.UnitInPhase(Unit)--br._G.UnitPhaseReason(Unit)
	distance = distance or br.functions.range:getDistance(Unit, "player")
	local mcCheck = (br.functions.misc:isChecked("Attack MC Targets") and (not br.functions.unit:GetUnitIsFriend(Unit, "player") or br._G.UnitIsCharmed(Unit))) or
		not br.functions.unit:GetUnitIsFriend(Unit, "player")
	local inPhase = phaseReason--not phaseReason or phaseReason == 2 or phaseReason == 3
	if isAttackablePlayer(Unit) then
		return true
	end
	-- Check if unit was created by player, but allow quest NPCs that turn hostile (like Peak of Serenity monks)
	-- UnitReaction: 1=Hated, 2=Hostile, 3=Unfriendly, 4=Neutral, 5+=Friendly
	local createdByPlayer = br._G.UnitCreator(Unit) == br._G.ObjectPointer("player")
	local unitReaction = br._G.UnitReaction(Unit, "player") or 5
	local isHostileQuestNPC = createdByPlayer and unitReaction < 4 -- Hostile/Unfriendly reaction

	-- Perform all cheap checks as individual locals (no table allocation in this hot path)
	local checkExists   = br.functions.unit:GetObjectExists(Unit)
	local checkNotDead  = not br.functions.unit:GetUnitIsDeadOrGhost(Unit)
	local checkCanAttack = br._G.UnitCanAttack("player", Unit)
	local checkHasHealth = br._G.UnitHealth(Unit) > 0
	local checkInRange   = distance < 50
	local checkNotCritter = not br.functions.unit:isCritter(Unit)
	local checkNotPet    = not br.functions.unit:GetUnitIsUnit(Unit, "pet")
	local checkCreator   = (not createdByPlayer or isHostileQuestNPC)
	local checkNotOwnPet = br.lists.unitRules.ownPets[br.functions.unit:GetObjectID(Unit)] == nil

	-- Expensive LoS check only done if other checks pass (early exit optimization)
	local basicChecks = checkExists and checkNotDead and checkCanAttack and checkHasHealth
		and checkInRange and checkNotCritter and mcCheck and checkNotPet
		and checkCreator and checkNotOwnPet

	if not basicChecks then
		return false -- Early exit before expensive LoS check
	end

	-- OPTIMIZATION: More aggressive LoS check skipping to reduce FPS impact
	-- Skip LoS check entirely for:
	-- 1. Close enemies (<15y) - always reachable
	-- 2. Units in combat - already engaged
	-- 3. Mid-range units (15-40y) - perform check to maintain accuracy for prowl/pre-combat detection
	-- 4. Distant units (>40y) - skip unless damaged or targeting us
	local isDamagedUnit = br.engines.enemiesEngine.damaged and br.engines.enemiesEngine.damaged[br._G.ObjectPointer(Unit)] ~= nil
	local isTargetingUs = br.functions.misc:isTargeting(Unit)
	local los = true -- Default to true (skip check)

	if distance >= 15 and not br._G.UnitAffectingCombat(Unit) then
		-- CRITICAL: Always check LoS for mid-range units (15-40y) to support pre-emptive prowling/stealth detection
		-- These checks are needed for Feral pre-emptive prowl, Rogue stealth prep, etc.
		if distance <= 40 then
			los = br.functions.misc:getLineOfSight("player", Unit)
		elseif isDamagedUnit or isTargetingUs then
			-- Distant but important: damaged or targeting us
			los = br.functions.misc:getLineOfSight("player", Unit)
		else
			-- Very distant (>40y), not damaged, not targeting: skip LoS check, assume no LoS
			-- These units are too far to matter for gameplay
			los = false
		end
	end

	-- (isHeldBack compares NPC IDs; this used to compare the unit itself with them, so never applied)
	-- A plain true / false: some checks compare secret values (health on Forever), and their results
	-- would make this answer secret too (usable by BR, but hidden wherever it's shown)
	if basicChecks and los and not br.functions.unit:isHeldBack(Unit) then return true end
	return false
end

function misc:isValidUnit(Unit)
	if Unit == nil then
		return false
	end

	local now = br._G.GetTime()
	local guid = br._G.UnitGUID(Unit)

	-- PRIORITY: Units in damaged table bypass most validation checks
	-- These are units actively in combat with our group (attacking or being attacked)
	-- The combatlog cleanup already ensures these units are valid (exists, alive, attackable)
	-- damaged table keys are pointers from GetObjectWithGUID()
	-- damaged table values are unitSetup objects where .unit is also the pointer
	-- HOWEVER, we still need to check line of sight to prevent casting on units behind walls
	if br.engines.enemiesEngine.damaged then
		local unitPointer = br._G.ObjectPointer(Unit)
		-- Direct pointer lookup - ObjectPointer() should match GetObjectWithGUID() for same unit
		if unitPointer and br.engines.enemiesEngine.damaged[unitPointer] ~= nil then
			return true
		end
	end

	-- Short-circuit cache for the expensive validation path (TTL: 0.05s combat, 0.10s out-of-combat)
	if guid then
		if now - lastIsValidUnitCleanup > 1.0 then
			for k, v in pairs(isValidUnitCache) do
				if now - v.time > 0.5 then isValidUnitCache[k] = nil end
			end
			lastIsValidUnitCleanup = now
		end
		local cached = isValidUnitCache[guid]
		if cached then
			local ttl = br._G.UnitAffectingCombat("player") and 0.05 or 0.10
			if now - cached.time < ttl then return cached.value end
		end
	end

	-- Calculate all conditions once
	local unitPointer = br._G.ObjectPointer(Unit)
	local hostileOnly = br.functions.misc:isChecked("Hostiles Only")
	local playerTarget = br.functions.unit:GetUnitIsUnit(Unit, "target")
	local reaction = br.functions.unit:GetUnitReaction(Unit, "player") or 10
	local targeting = br.functions.misc:isTargeting(Unit)
	-- Dummies have special handling:
	-- They should only be treated as "valid" when they are your current target OR
	-- when you have a dummy targeted and this unit is within 8 yards of that targeted dummy.
	-- Otherwise, dummies follow the standard validation path (and generally won't be considered valid without threat/targeting).
	local isDummy = br.functions.unit:isDummy(Unit)
	local dummyEligible = false
	if isDummy then
		if playerTarget then
			dummyEligible = true
		else
			-- Nearby-dummy allowance for cleave testing: allow other dummies near the targeted dummy.
			if br.functions.unit:GetObjectExists("target") and br.functions.unit:isDummy("target") then
				local distToTarget = br.functions.range:getDistance(Unit, "target")
				if distToTarget ~= nil and distToTarget <= 8 then
					dummyEligible = true
				end
			end
		end
	end
	local burnUnit = br.functions.misc:getOptionCheck("Forced Burn") and br.engines.enemiesEngineFunctions:isBurnTarget(Unit) > 0
	local isCC = br.functions.misc:getOptionCheck("Don't break CCs") and br.functions.misc:isLongTimeCCed(Unit) or false
	local mcCheck = (br.functions.misc:isChecked("Attack MC Targets") and (not br.functions.unit:GetUnitIsFriend(Unit, "player") or (br._G.UnitIsCharmed(Unit) and br._G.UnitCanAttack("player", Unit))))
		or not br.functions.unit:GetUnitIsFriend(Unit, "player")

	-- Early exit for PvP debuffs (special case)
	if playerTarget and isAttackablePlayer(Unit) then
		if guid then isValidUnitCache[guid] = { value = true, time = now } end
		return true
	end

	-- Check if unit is tapped but we've damaged it
	local isTapped = br._G.UnitIsTapDenied(Unit)
	local hasDamagedTapped = isTapped and br.engines.enemiesEngine.damaged[unitPointer] ~= nil

	-- Check if unit actually passed enemyListCheck or is in units table
	-- If it's the player target but not in units table, verify it at least passes basic enemyListCheck
	-- Also allow units that have threat on the group (targeting tank/party) even if not in units table yet
	-- (the threat check is the costly one: it's only asked where the cheaper conditions haven't decided)
	local inUnitsTable = br.engines.enemiesEngine.units[Unit] ~= nil
	local passedEnemyCheck = inUnitsTable or (playerTarget and br.functions.misc:enemyListCheck(Unit)) or burnUnit or dummyEligible
		or br.functions.combat:hasThreat(Unit)

	-- Fast path for special units (dummy/burn) - skip most checks
	if passedEnemyCheck and mcCheck and not isCC and (dummyEligible or burnUnit) then
		if guid then isValidUnitCache[guid] = { value = true, time = now } end
		return true
	end

	-- Standard validation path
	if passedEnemyCheck and mcCheck and not isCC
		and (hasDamagedTapped or (not isTapped and br.engines.enemiesEngineFunctions:isSafeToAttack(Unit)
			and ((hostileOnly and reaction < 4) or (not hostileOnly and reaction < 5) or playerTarget or targeting)))
	then
		-- Valid if any threat condition is met:
		-- Player target, unit targeting us, burn target, proving grounds, or has group threat
		local result = playerTarget or targeting or burnUnit or br.functions.misc:isInProvingGround() or br.functions.combat:hasThreat(Unit)
		if guid then isValidUnitCache[guid] = { value = result, time = now } end
		return result
	end

	if guid then isValidUnitCache[guid] = { value = false, time = now } end
	return false
end

-- Stores an enemies list on the player as enemies.yards<range><tags> (used by the Enemies API).
-- Tags: t/f/p/m... for the center unit, nc for no-combat check, f for facing, r/c for rect/cone.
function misc:setEnemiesVariable(self, unit, range, checkNoCombat, facing, type, table, count)
	if unit == nil then unit = "player" end
	if range == nil then range = 5 end
	if checkNoCombat == nil then checkNoCombat = false end
	if facing == nil then facing = false end
	if type == nil then type = "" end
	if table == nil then table = {} end
	if count == nil then count = #table end
	-- Build enemies.yards variable
	local insertTable = "yards" ..
		range ..
		type -- Ex: enemies.yards8 (returns all enemies around player in 8yrds), Adds Table Type (r for Rect, c for Cone, blank for Normal)
	if unit ~= "player" then
		-- letter tag on end based on type of unit passed, if target or enemy unit then "t" otherwise first letter of what is passed in: f - "focus", p - "pet", m - "mouseover", etc
		if br.engines.enemiesEngine.units[unit] ~= nil then
			insertTable = insertTable .. "t" -- Ex: enemies.yards8t (returns all enemies around target in 8yrds)
		else
			insertTable = insertTable ..
				unit:sub(1, 1) -- Ex: enemies.yards8f (returns all enemies around "focus" in 8yrds)
		end
	end
	if checkNoCombat then insertTable = insertTable .. "nc" end -- Ex: enemies.yards8tnc (returns all units around target in 8yrds)
	if facing then insertTable = insertTable .. "f" end         -- Ex: enemies.yards8tncf (returns all units the target is facing in 8yrds)
	if self.enemies[insertTable] == nil then self.enemies[insertTable] = {} else br._G.wipe(self.enemies[insertTable]) end
	if count > 0 then br.functions.custom:insertTableIntoTable(self.enemies[insertTable], table) end
end
