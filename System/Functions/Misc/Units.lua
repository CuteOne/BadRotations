local _, br = ...
-- Which units count: valid targets, the enemies list check, targeting and tanks.
---@class br.functions.misc
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc
local isValidUnitCache = {}

local lastIsValidUnitCleanup = 0

-- True when an enemy other than Unit is in combat (with the player or their group)
local function othersFighting(Unit)
	local pointer = br._G.ObjectPointer(Unit)
	for other, record in pairs(br.engines.enemiesEngine.enemy) do
		if other ~= pointer and br._G.UnitAffectingCombat(record.unit or other) then return true end
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

-- True when Unit belongs in the enemies list; false and the reason (shown by the Target Validation
-- Debug tooltip) when it doesn't. distance: the unit's distance from the player if the caller has
-- just measured it.
-- Plain true / false returns: some checks compare secret values (health on Forever), and their results
-- would make the answer secret too (usable by BR, but hidden wherever it's shown)
function misc:enemyListCheck(Unit, distance)
	if isAttackablePlayer(Unit) then return true end
	local unitFunctions = br.functions.unit
	distance = distance or br.functions.range:getDistance(Unit, "player")
	if not unitFunctions:GetObjectExists(Unit) then return false, "Doesn't exist" end
	if unitFunctions:GetUnitIsDeadOrGhost(Unit) then return false, "Dead or Ghost" end
	if not br._G.UnitCanAttack("player", Unit) then return false, "Cannot Attack" end
	if not (br._G.UnitHealth(Unit) > 0) then return false, "No Health" end
	if not (distance < 50) then return false, "Too Far (50 yd or more)" end
	if unitFunctions:isCritter(Unit) then return false, "Is Critter" end
	if unitFunctions:GetUnitIsFriend(Unit, "player")
		and not (misc:isChecked("Attack MC Targets") and br._G.UnitIsCharmed(Unit))
	then
		return false, "Is Friendly (not charmed, or Attack MC Targets is off)"
	end
	if unitFunctions:GetUnitIsUnit(Unit, "pet") then return false, "Is Your Pet" end
	-- Made by the player, except quest NPCs that turn hostile (like Peak of Serenity monks)
	-- UnitReaction: 1=Hated, 2=Hostile, 3=Unfriendly, 4=Neutral, 5+=Friendly
	if br._G.UnitCreator(Unit) == br._G.ObjectPointer("player") and (br._G.UnitReaction(Unit, "player") or 5) >= 4 then
		return false, "Created/Summoned by You"
	end
	local ownPet = br.lists.unitRules.ownPets[unitFunctions:GetObjectID(Unit)]
	if ownPet ~= nil then return false, "Is " .. ownPet end
	-- Line of sight is checked last (expensive), and only for units 15 yd or more away that aren't
	-- in combat: 15-40 yd always (pre-combat prowl/stealth decisions need it), beyond 40 yd only when
	-- the unit was damaged or targets the player; any other unit beyond 40 yd doesn't count
	if distance >= 15 and not br._G.UnitAffectingCombat(Unit) then
		if distance > 40 then
			local damaged = br.engines.enemiesEngine.damaged
			if not ((damaged and damaged[br._G.ObjectPointer(Unit)] ~= nil) or misc:isTargeting(Unit)) then
				return false, "Over 40 yd, not in combat, not damaged or targeting you"
			end
		end
		if not misc:getLineOfSight("player", Unit) then return false, "No Line of Sight" end
	end
	-- (isHeldBack compares NPC IDs; this used to compare the unit itself with them, so never applied)
	if unitFunctions:isHeldBack(Unit) then return false, "Held back (unit rules)" end
	return true
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

--if isLongTimeCCed("target") then
-- CCs with >=20 seconds
--- True when "Don't break CCs" should keep BR off Unit, which has crowd control or roots on it
--- (br.lists.longCC). Players CC or root a mob to heal, eat or drink, gain distance or a better spot,
--- park an add, or escape, so BR breaks it only when:
---   it's the player's target (anything else was parked by them or the group), and either
---   it fled at low health (unit:isFleeing "flee": stop it before it brings help; not while the
---   player eats or drinks), or
---   no other enemy is fighting, the player isn't moving (still repositioning), and
---   combat:isReadyToFight() (health, mana, not eating or drinking, tanks).
function misc:isCCProtected(Unit)
	if not misc:isLongTimeCCed(Unit) then return false end
	local unitFns = br.functions.unit
	if not unitFns:GetUnitIsUnit(Unit, "target") then return true end
	if unitFns:isFleeing(Unit) == "flee" then
		return unitFns:isEating("player") or unitFns:isDrinking("player")
	end
	return othersFighting(Unit) or misc:isMoving("player") or not br.functions.combat:isReadyToFight()
end

--- The crowd control on Unit from br.lists.longCC: "cc" (takes it out of the fight), "fear" (a fear:
--- out of the fight, but running loose), "root" (holds it in place; damage may break it), or false.
function misc:isLongTimeCCed(Unit)
	if Unit == nil then
		return false
	end
	local longTimeCC = br.lists.longCC
	local feared, rooted = false, false
	for i = 1, 40 do
		local auraInfo = br.api.wow.GetDebuffDataByIndex(Unit, i)
		if not auraInfo then break end
		local kind = longTimeCC[tonumber(auraInfo.spellId)]
		if kind == true then return "cc" end
		if kind == "fear" then feared = true end
		if kind == "root" then rooted = true end
	end
	return feared and "fear" or rooted and "root" or false
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

-- Caches an isValidUnit answer by GUID and returns it
local function rememberValid(guid, now, value, reason)
	if guid then isValidUnitCache[guid] = { value = value, reason = reason, time = now } end
	return value, reason
end

-- True when BR may attack Unit; false and the reason (shown by the Target Validation Debug tooltip)
-- when it may not.
function misc:isValidUnit(Unit)
	if Unit == nil then
		return false, "No unit"
	end

	local now = br._G.GetTime()
	local guid = br._G.UnitGUID(Unit)

	-- PRIORITY: Units in damaged table bypass most validation checks
	-- These are units actively in combat with our group (attacking or being attacked)
	-- The combatlog cleanup already ensures these units are valid (exists, alive, attackable)
	-- damaged table keys are pointers from GetObjectWithGUID()
	-- damaged table values are unitSetup objects where .unit is also the pointer
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
			if now - cached.time < ttl then return cached.value, cached.reason end
		end
	end

	-- Calculate all conditions once
	local unitPointer = br._G.ObjectPointer(Unit)
	local hostileOnly = misc:isChecked("Hostiles Only")
	local playerTarget = br.functions.unit:GetUnitIsUnit(Unit, "target")
	local reaction = br.functions.unit:GetUnitReaction(Unit, "player") or 10
	local targeting = misc:isTargeting(Unit)
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
	local burnUnit = misc:getOptionCheck("Forced Burn") and br.engines.enemiesEngineFunctions:isBurnTarget(Unit) > 0
	local isCC = misc:getOptionCheck("Don't break CCs") and misc:isCCProtected(Unit) or false
	local mcCheck = (misc:isChecked("Attack MC Targets") and (not br.functions.unit:GetUnitIsFriend(Unit, "player") or (br._G.UnitIsCharmed(Unit) and br._G.UnitCanAttack("player", Unit))))
		or not br.functions.unit:GetUnitIsFriend(Unit, "player")

	-- Early exit for PvP debuffs (special case)
	if playerTarget and isAttackablePlayer(Unit) then
		return rememberValid(guid, now, true)
	end

	-- In the units table, or a burn unit, an eligible dummy, the player's target passing enemyListCheck,
	-- or a unit with threat on the group (targeting tank/party) even if not in the units table yet
	-- (the threat check is the costly one: it's only asked where the cheaper conditions haven't decided)
	local listReason
	local passedEnemyCheck = br.engines.enemiesEngine.units[Unit] ~= nil or burnUnit or dummyEligible
	if not passedEnemyCheck and playerTarget then
		passedEnemyCheck, listReason = misc:enemyListCheck(Unit)
	end
	if not passedEnemyCheck then passedEnemyCheck = br.functions.combat:hasThreat(Unit) end
	if not passedEnemyCheck then
		return rememberValid(guid, now, false, listReason or "Not in the enemies list (not your target, burn unit, dummy or threat)")
	end
	if not mcCheck then
		return rememberValid(guid, now, false, "Is Friendly (not charmed, or Attack MC Targets is off)")
	end
	if isCC then return rememberValid(guid, now, false, "Is CC'd (Don't break CCs)") end

	-- Fast path for special units (dummy/burn) - skip the remaining checks
	if dummyEligible or burnUnit then return rememberValid(guid, now, true) end

	-- A tapped unit counts only once the group has damaged it, and then skips the safety and reaction checks
	local isTapped = br._G.UnitIsTapDenied(Unit)
	if not (isTapped and br.engines.enemiesEngine.damaged[unitPointer] ~= nil) then
		if isTapped then return rememberValid(guid, now, false, "Tap Denied (you haven't damaged it)") end
		if not br.engines.enemiesEngineFunctions:isSafeToAttack(Unit) then
			return rememberValid(guid, now, false, "Not Safe to Attack (CC candidate or a unit not to touch)")
		end
		if not ((hostileOnly and reaction < 4) or (not hostileOnly and reaction < 5) or playerTarget or targeting) then
			return rememberValid(guid, now, false, hostileOnly and "Not hostile (Hostiles Only)" or "Friendly reaction")
		end
	end

	-- Valid if any threat condition is met:
	-- Player target, unit targeting us, proving grounds, or has group threat
	if playerTarget or targeting or misc:isInProvingGround() or br.functions.combat:hasThreat(Unit) then
		return rememberValid(guid, now, true)
	end
	return rememberValid(guid, now, false, "No threat (not your target, not targeting you, no group threat)")
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
