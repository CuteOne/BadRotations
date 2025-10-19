local _, br = ...
br.functions.misc = {}
local misc = br.functions.misc
-- getLatency()
function misc:getLatency()
	-- local lag = ((select(3,GetNetStats()) + select(4,GetNetStats())) / 1000)
	local lag = select(4, br._G.GetNetStats()) / 1000
	if lag < .05 then
		lag = .05
	elseif lag > .4 then
		lag = .4
	end
	return lag
end

--Calculate Agility
function misc:getAgility()
	local AgiBase, _, AgiPos, AgiNeg = br._G.UnitStat("player", 2)
	local Agi = AgiBase + AgiPos + AgiNeg
	return Agi
end

function misc:getFallDistance()
	local zDist
	local zCoord = nil
	local _, _, position = br.functions.unit:GetObjectPosition("player")

	if position == nil then return 0 end
	if zCoord == nil then
		zCoord = position
	end
	if not br._G.IsFalling() or br._G.IsFlying() then
		zCoord = position
	end
	if position - zCoord < 0 then
		zDist = math.sqrt(((position - zCoord) ^ 2))
	else
		zDist = 0
	end

	return zDist
end

--if getFallTime() > 2 then
function misc:getFallTime()
	if br.fallStarted == nil then
		br.fallStarted = 0
	end
	if br.fallTime == nil then
		br.fallTime = 0
	end
	if br._G.IsFalling() and br.functions.misc:getFallDistance() < 0 then
		if br.fallStarted == 0 then
			br.fallStarted = br._G.GetTime()
		end
		if br.fallStarted ~= 0 then
			br.fallTime = (math.floor((br._G.GetTime() - br.fallStarted) * 1000) / 1000)
		end
	end
	if not br._G.IsFalling() then
		br.fallStarted = 0
		br.fallTime = 0
	end
	return br.fallTime
end

-- if br.functions.misc:getLineOfSight("target"[,"target"]) then
misc.doLinesIntersect = function(a, b, c, d)
	-- parameter conversion
	local L1 = { X1 = a.x, Y1 = a.y, X2 = b.x, Y2 = b.y }
	local L2 = { X1 = c.x, Y1 = c.y, X2 = d.x, Y2 = d.y }

	-- Denominator for ua and ub are the same, so store this calculation
	d = (L2.Y2 - L2.Y1) * (L1.X2 - L1.X1) - (L2.X2 - L2.X1) * (L1.Y2 - L1.Y1)

	-- Make sure there is not a division by zero - this also indicates that the lines are parallel.
	-- If n_a and n_b were both equal to zero the lines would be on top of each
	-- other (coincidental).  This check is not done because it is not
	-- necessary for this implementation (the parallel check accounts for this).
	if (d == 0) then
		return false
	end

	-- n_a and n_b are calculated as seperate values for readability
	local n_a = (L2.X2 - L2.X1) * (L1.Y1 - L2.Y1) - (L2.Y2 - L2.Y1) * (L1.X1 - L2.X1)
	local n_b = (L1.X2 - L1.X1) * (L1.Y1 - L2.Y1) - (L1.Y2 - L1.Y1) * (L1.X1 - L2.X1)

	-- Calculate the intermediate fractional point that the lines potentially intersect.
	local ua = n_a / d
	local ub = n_b / d

	-- The fractional point will be between 0 and 1 inclusive if the lines
	-- intersect.  If the fractional calculation is larger than 1 or smaller
	-- than 0 the lines would need to be longer to intersect.
	if (ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1) then
		local x = L1.X1 + (ua * (L1.X2 - L1.X1))
		local y = L1.Y1 + (ua * (L1.Y2 - L1.Y1))
		return true, { x = x, y = y }
	end

	return false
end

function misc:carapaceMath(Unit1, Unit2)
	if Unit2 == nil then
		Unit2 = Unit1
		if Unit2 == "player" then
			Unit1 = "target"
		else
			Unit1 = "player"
		end
	end
	if (br.player and br.player.eID and br.player.eID == 2337) then
		local pX, pY = br.functions.unit:GetObjectPosition(Unit1)
		local tX, tY = br.functions.unit:GetObjectPosition(Unit2)
		-- local tentExists = false
		local tentCheck
		local tentX, tentY
		--[[ LibDraw.clearCanvas()
		if tX ~= nil then
			LibDraw.Line(pX,pY,pZ,tX,tY,tZ)
		end ]]
		br.tentCache = {}
		for i = 1, br._G.GetObjectCount() do
			local object = br._G.GetObjectWithIndex(i)
			local objectid = br._G.ObjectID(object)
			if objectid == 157485 then
				-- tentExists = true
				local tentFacing = br.functions.unit:GetObjectFacing(object)
				tentX, tentY = br.functions.unit:GetObjectPosition(object)
				table.insert(
					br.tentCache,
					{
						["tentFacing"] = tentFacing,
						["tentX"] = select(1, br.functions.unit:GetObjectPosition(object)),
						["tentY"] = select(2, br.functions.unit:GetObjectPosition(object)),
						["tentZ"] = select(3, br.functions.unit:GetObjectPosition(object)),
						["tentX2"] = tentX + (80 * math.cos(tentFacing)),
						["tentY2"] = tentY + (80 * math.sin(tentFacing))
					}
				)
			end
		end

		local tentfinal = {}
		if tentX ~= nil then
			for i = 1, #br.tentCache do
				if br.tentCache[i]["tentX"] ~= nil then
					local a = { x = br.tentCache[i]["tentX"], y = br.tentCache[i]["tentY"] }
					local b = { x = br.tentCache[i]["tentX2"], y = br.tentCache[i]["tentY2"] }
					local c = { x = tX, y = tY }
					local d = { x = pX, y = pY }
					if tX ~= nil then
						if misc.doLinesIntersect(a, b, c, d) then
							--[[ LibDraw.SetColor(255,0,0)
							LibDraw.Line(tentCache[i]["tentX"],tentCache[i]["tentY"],tentCache[i]["tentZ"],tentCache[i]["tentX2"],tentCache[i]["tentY2"],tentCache[i]["tentZ"])
							]]
							tentCheck =
								false
							table.insert(tentfinal, tentCheck)
							--[[ else
							LibDraw.SetColor(0,255,0)
							LibDraw.Line(tentCache[i]["tentX"],tentCache[i]["tentY"],tentCache[i]["tentZ"],tentCache[i]["tentX2"],tentCache[i]["tentY2"],tentCache[i]["tentZ"])
						]]
						end
					end
				end
			end
			if tentfinal[1] == nil or tentfinal == nil then
				return true
			else
				return false
			end
		else
			return true
		end
	end
end

function misc:getLineOfSight(Unit1, Unit2)
	if Unit2 == nil then
		Unit2 = Unit1
		if Unit2 == "player" then
			Unit1 = "target"
		else
			Unit1 = "player"
		end
	end
	local skipLoSTable = br.lists.los
	if skipLoSTable[br.functions.unit:GetObjectID(Unit1)] or skipLoSTable[br.functions.unit:GetObjectID(Unit2)] or -- Kyrian Hunter Ability
		(Unit1 and Unit1 ~= "player" and br.functions.aura:getDebuffRemain(Unit1, 308498) > 0) or
		(Unit2 and Unit2 ~= "player" and br.functions.aura:getDebuffRemain(Unit2, 308498) > 0)
	then
		return true
	end
	if br.functions.unit:GetObjectExists(Unit1) and br.functions.unit:GetUnitIsVisible(Unit1) and br.functions.unit:GetObjectExists(Unit2) and br.functions.unit:GetUnitIsVisible(Unit2) then
		local X1, Y1, Z1 = br.functions.unit:GetObjectPosition(Unit1)
		local X2, Y2, Z2 = br.functions.unit:GetObjectPosition(Unit2)
		local pX = br.functions.unit:GetObjectPosition("player")
		local flags = bit.bor(0x10, 0x100)
		local trace
		-- Only calculate if we actually got values
		if (X1 == nil or X2 == nil or pX == nil) then return false end
		-- Trace to see if we are in Line of Sight
		if br.player and br.player.eID and (br.player.eID == 2398 or br.player.eID == 2399) then
			trace = br._G.TraceLine(X1, Y1, Z1 + 2 --[[.25]], X2, Y2, Z2 + 2 --[[.25]], 0x100111)
		else
			trace = br._G.TraceLine(X1, Y1, Z1 + 2.25, X2, Y2, Z2 + 2.25, flags)
			-- if (br._G.UnitIsUnit(Unit2,"target")) then
			-- 	br._G.print("Target Is LoS: "..tostring(trace))
			-- end
		end
		if trace == nil or trace == false then
			--Print("Past Traceline")
			if br.player and br.player.eID and br.player.eID == 2141 then
				if pX < -108 and X2 < -108 then
					return true
				elseif (pX > -108 and pX < -54) and (X2 > -108 and X2 < -54) then
					return true
				elseif pX > -54 and X2 > -54 then
					return true
				else
					return false
				end
			elseif br.player and br.player.eID and br.player.eID == 2337 then
				--Print("Past Cara Check")
				if misc:carapaceMath(Unit1, Unit2) == true then
					--Print("Cara True")
					return true
				else
					--Print("cara False")
					return false
				end
			else
				--Print("Skippped all the code")
				return true
			end
		else
			-- br._G.print("Really Skipped it all")
			return true
		end
	else
		return false
	end
end

-- if getGround("target"[,"target"]) then
function misc:getGround(Unit)
	if br.functions.unit:GetObjectExists(Unit) and br.functions.unit:GetUnitIsVisible(Unit) then
		local X1, Y1, Z1 = br.functions.unit:GetObjectPosition(Unit)
		if br._G.TraceLine(X1, Y1, Z1, X1, Y1, Z1 - 2, 0x10) == nil and br._G.TraceLine(X1, Y1, Z1, X1, Y1, Z1 - 2, 0x100) == nil then
			return false
		else
			return true
		end
	end
end

function misc:getGroundDistance(Unit)
	if br.functions.unit:GetObjectExists(Unit) and br.functions.unit:GetUnitIsVisible(Unit) then
		local X1, Y1, Z1 = br.functions.unit:GetObjectPosition(Unit)
		for i = 1, 100 do
			if br._G.TraceLine(X1, Y1, Z1, X1, Y1, Z1 - i / 10, 0x10) ~= nil or br._G.TraceLine(X1, Y1, Z1, X1, Y1, Z1 - i / 10, 0x100) ~= nil then
				return i / 10
			end
		end
	else
		return 0
	end
end

-- if getPetLineOfSight("target"[,"target"]) then
function misc:getPetLineOfSight(Unit)
	if br.functions.unit:GetObjectExists(Unit) and br.functions.unit:GetUnitIsVisible("pet") and br.functions.unit:GetUnitIsVisible(Unit) then
		local X1, Y1, Z1 = br.functions.unit:GetObjectPosition("pet")
		local X2, Y2, Z2 = br.functions.unit:GetObjectPosition(Unit)
		if br._G.TraceLine(X1, Y1, Z1 + 2, X2, Y2, Z2 + 2, 0x10) == nil then
			return true
		else
			return false
		end
	else
		return true
	end
end

--- Round
function misc:round2(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- if getTalent(8) == true then
function misc:getTalent(Row, Column, specGroup)
	if specGroup == nil then
		specGroup = br._G.C_SpecializationInfo.GetActiveSpecGroup()
	end
	local _, _, _, selected = br._G.GetTalentInfo(Row, Column, specGroup)
	return selected or false
end

-- if hasEmptySlots() then
function misc:hasEmptySlots()
	local openSlots = 0
	for i = 0, 4 do       --Let's look at each bag
		local numBagSlots = C_Container.GetContainerNumSlots(i)
		if numBagSlots > 0 then -- Only look for slots if bag present
			openSlots = openSlots + select(1, C_Container.GetContainerNumFreeSlots(i))
		end
	end
	if openSlots > 0 then
		return true
	else
		return false
	end
end

-- if hasGlyph(1234) == true then
function misc:hasGlyph(glyphid)
	for i = 1, 6 do
		if select(4, br._G.GetGlyphSocketInfo(i)) == glyphid or select(6, br._G.GetGlyphSocketInfo(i)) == glyphid then
			return true
		end
	end
	return false
end

-- UnitGUID("target"):sub(-15,-10)

--if isGarrMCd() then
function misc:isGarrMCd(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if br.functions.unit:GetUnitExists(Unit) and (br.functions.aura:UnitDebuffID(Unit, 145832) or br.functions.aura:UnitDebuffID(Unit, 145171) or br.functions.aura:UnitDebuffID(Unit, 145065) or br.functions.aura:UnitDebuffID(Unit, 145071)) then
		return true
	else
		return false
	end
end

-- if isInCombat("target") then
function misc:isInCombat(Unit)
	if br._G.UnitAffectingCombat(Unit) or br.functions.misc:isChecked("Ignore Combat") then
		return true
	else
		return false
	end
end

function misc:isInArdenweald()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.Ardenweald, mapID)
end

function misc:isInBastion()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.Bastion, mapID)
end

function misc:isInMaldraxxus()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.Maldraxxus, mapID)
end

function misc:isInRevendreth()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.Revendreth, mapID)
end

function misc:isInTheMaw()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.TheMaw, mapID)
end

-- if isInDraenor() then
function misc:isInDraenor()
	local tContains = br._G.tContains
	local currentMapID = br._G.C_Map.GetBestMapForUnit("player")
	local draenorMapIDs = br.lists.maps.Draenor
	return tContains(draenorMapIDs, currentMapID)
end

function misc:isInLegion()
	local tContains = br._G.tContains
	local currentMapID = br._G.C_Map.GetBestMapForUnit("player")
	local legionMapIDs = br.lists.maps.Legion
	return tContains(legionMapIDs, currentMapID)
end

function misc:isInProvingGround()
	local currentMapID = br._G.C_Map.GetBestMapForUnit("player")
	return currentMapID == 480
end

-- if IsInPvP() then
function misc:isInPvP()
	local inpvp = br._G.GetPVPTimer()
	if (inpvp ~= 301000 and inpvp ~= -1) or (br._G.UnitIsPVP("player") and br._G.UnitIsPVP("target")) then
		return true
	else
		return false
	end
end

--if isLongTimeCCed("target") then
-- CCs with >=20 seconds
function misc:isLongTimeCCed(Unit)
	if Unit == nil then
		return false
	end
	local longTimeCC = br.lists.longCC
	for i = 1, 40 do
		-- local debuffSpellID = select(10, br._G.UnitDebuff(Unit, i))
		local auraInfo = C_UnitAuras.GetDebuffDataByIndex(Unit, i)
		if auraInfo and longTimeCC[tonumber(auraInfo.spellId)] == true then return true end
		-- if debuffSpellID == nil then
		-- 	return false
		-- end
		-- if longTimeCC[tonumber(debuffSpellID)] == true then
		-- 	return true
		-- end
	end
	return false
end

-- if isLooting() then
function misc:isLooting()
	return br._G.GetNumLootItems() > 0
end

-- if not isMoving("target") then
function misc:isMoving(Unit)
	if Unit == nil then
		return false
	end
	return br._G.GetUnitSpeed(Unit) > 0
end

-- if IsMovingTime(5) then
function misc:IsMovingTime(time)
	if time == nil then
		time = 1
	end
	if br._G.GetUnitSpeed("player") > 0 then
		if br.functions.misc.isRunning == nil then
			br.functions.misc.isRunning = br._G.GetTime()
			br.functions.misc.isStanding = nil
		end
		if br._G.GetTime() - br.functions.misc.isRunning > time then
			return true
		end
	else
		if br.functions.misc.isStanding == nil then
			br.functions.misc.isStanding = br._G.GetTime()
			br.functions.misc.isRunning = nil
		end
		if br._G.GetTime() - br.functions.misc.isStanding > time then
			return false
		end
	end
end

function misc:isPlayer(Unit)
	if br.functions.unit:GetUnitExists(Unit) ~= true then
		return false
	end
	if br._G.UnitIsPlayer(Unit) == true then
		return true
	elseif br._G.UnitIsPlayer(Unit) ~= true then
		local playerNPC = {
			[72218] = "Oto the Protector",
			[72219] = "Ki the Asssassin",
			[72220] = "Sooli the Survivalist",
			[72221] = "Kavan the Arcanist"
		}
		if playerNPC[tonumber(string.match(br._G.UnitGUID(Unit), "-(%d+)-%x+$"))] ~= nil then
			return true
		end
	else
		return false
	end
end

function misc:getStandingTime()
	return br.readers.common.DontMoveStartTime and br._G.GetTime() - br.readers.common.DontMoveStartTime or nil
end

--
function misc:isStanding(Seconds)
	return br._G.IsFalling() == false and br.readers.common.DontMoveStartTime and br.functions.misc:getStandingTime() >= Seconds or false
end

-- if IsStandingTime(5) then
function misc:IsStandingTime(time, unit)
	if time == nil then
		time = 1
	end
	if unit == nil then
		unit = "player"
	end
	if not br._G.IsFalling() and br._G.GetUnitSpeed(unit) == 0 then
		if br.functions.misc.isStanding == nil then
			br.functions.misc.isStanding = br.GetTime()
			br.functions.misc.isRunning = nil
		end
		if br._G.GetTime() - br.functions.misc.isStanding > time then
			return true
		end
	else
		if br.functions.misc.isRunning == nil then
			br.functions.misc.isRunning = br._G.GetTime()
			br.functions.misc.isStanding = nil
		end
		if br._G.GetTime() - br.functions.misc.isRunning > time then
			return false
		end
	end
end

-- if isValidTarget("target") then
function misc:isValidTarget(Unit)
	if br._G.UnitIsEnemy("player", Unit) or br.functions.unit:isDummy(Unit) then
		if br.functions.unit:GetUnitExists(Unit) and not br.functions.unit:GetUnitIsDeadOrGhost(Unit) then
			return true
		else
			return false
		end
	else
		if br.functions.unit:GetUnitExists(Unit) then
			return true
		else
			return false
		end
	end
end

function misc:isTargeting(Unit, MatchUnit)
	if br.functions.unit:GetUnit(Unit) == nil then
		return false
	end
	if br._G.UnitTarget(br.functions.unit:GetUnit(Unit)) == nil then
		return false
	end
	if MatchUnit == nil then
		MatchUnit = "player"
	end
	return br._G.UnitTarget(br.functions.unit:GetUnit(Unit)) == br._G.ObjectPointer(MatchUnit)
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

function misc:enemyListCheck(Unit)
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
	local distance = br.functions.range:getDistance(Unit, "player")
	local mcCheck = (br.functions.misc:isChecked("Attack MC Targets") and (not br.functions.unit:GetUnitIsFriend(Unit, "player") or br._G.UnitIsCharmed(Unit))) or
		not br.functions.unit:GetUnitIsFriend(Unit, "player")
	local inPhase = phaseReason--not phaseReason or phaseReason == 2 or phaseReason == 3
	if (br.functions.aura:UnitDebuffID("player", 320102) or br.functions.aura:UnitDebuffID(Unit, 424495)) and br._G.UnitIsPlayer(Unit) then
		return true
	end
	-- Check if unit was created by player, but allow quest NPCs that turn hostile (like Peak of Serenity monks)
	-- UnitReaction: 1=Hated, 2=Hostile, 3=Unfriendly, 4=Neutral, 5+=Friendly
	local createdByPlayer = br._G.UnitCreator(Unit) == br._G.ObjectPointer("player")
	local unitReaction = br._G.UnitReaction(Unit, "player") or 5
	local isHostileQuestNPC = createdByPlayer and unitReaction < 4 -- Hostile/Unfriendly reaction

	-- Debug output to identify which check is failing
	local checks = {
		exists = br.functions.unit:GetObjectExists(Unit),
		notDead = not br.functions.unit:GetUnitIsDeadOrGhost(Unit),
		canAttack = br._G.UnitCanAttack("player", Unit),
		hasHealth = br._G.UnitHealth(Unit) > 0,
		inRange = distance < 50,
		notCritter = not br.functions.unit:isCritter(Unit),
		mcCheck = mcCheck,
		notPet = not br.functions.unit:GetUnitIsUnit(Unit, "pet"),
		creatorCheck = (not createdByPlayer or isHostileQuestNPC),
		notWaterEle = br.functions.unit:GetObjectID(Unit) ~= 11492,
		los = br.functions.misc:getLineOfSight("player", Unit)
	}

	local allPass = checks.exists and checks.notDead and checks.canAttack and checks.hasHealth
		and checks.inRange and checks.notCritter and checks.mcCheck and checks.notPet
		and checks.creatorCheck and checks.notWaterEle
		-- LoS check: allow units without LoS if they're in combat (actively fighting)
		and (checks.los or br._G.UnitAffectingCombat(Unit))
		and ((Unit ~= 131824 and Unit ~= 131823 and Unit ~= 131825) or ((br.functions.aura:UnitBuffID(Unit, 260805)
			or br.functions.unit:GetUnitIsUnit(Unit, "target")) and (Unit == 131824 or Unit == 131823 or Unit == 131825)))

	-- if not allPass and br.functions.misc:isChecked("Enemy List Debug") then
	-- 	local unitName = br._G.UnitName(Unit) or "Unknown"
	-- 	br._G.print("[EnemyListCheck] FAILED for " .. unitName .. " (Dist: " .. string.format("%.1f", distance) .. ")")
	-- 	for k, v in pairs(checks) do
	-- 		if not v then
	-- 			br._G.print("  - " .. k .. ": FAILED")
	-- 		end
	-- 	end
	-- 	if not checks.los and not br._G.UnitAffectingCombat(Unit) then
	-- 		br._G.print("  - NO LoS AND not in combat")
	-- 	end
	-- end

	return allPass
end

function misc:isValidUnit(Unit)
	if Unit == nil then
		return false
	end

	-- Calculate all conditions once
	local hostileOnly = br.functions.misc:isChecked("Hostiles Only")
	local playerTarget = br.functions.unit:GetUnitIsUnit(Unit, "target")
	local reaction = br.functions.unit:GetUnitReaction(Unit, "player") or 10
	local targeting = br.functions.misc:isTargeting(Unit)
	local dummy = br.functions.unit:isDummy(Unit)
	local burnUnit = br.functions.misc:getOptionCheck("Forced Burn") and br.engines.enemiesEngineFunctions:isBurnTarget(Unit) > 0
	local isCC = br.functions.misc:getOptionCheck("Don't break CCs") and br.functions.misc:isLongTimeCCed(Unit) or false
	local mcCheck = (br.functions.misc:isChecked("Attack MC Targets") and (not br.functions.unit:GetUnitIsFriend(Unit, "player") or (br._G.UnitIsCharmed(Unit) and br._G.UnitCanAttack("player", Unit))))
		or not br.functions.unit:GetUnitIsFriend(Unit, "player")

	-- Early exit for PvP debuffs (special case)
	if playerTarget and (br.functions.aura:UnitDebuffID("player", 320102) or br.functions.aura:UnitDebuffID(Unit, 424495)) and br._G.UnitIsPlayer(Unit) then
		return true
	end

	-- Check if unit is tapped but we've damaged it
	local isTapped = br._G.UnitIsTapDenied(Unit)
	local hasDamagedTapped = isTapped and br.engines.enemiesEngine.damaged[br._G.ObjectPointer(Unit)] ~= nil

	-- Check if unit actually passed enemyListCheck or is in units table
	-- If it's the player target but not in units table, verify it at least passes basic enemyListCheck
	-- Also allow units that have threat on the group (targeting tank/party) even if not in units table yet
	local inUnitsTable = br.engines.enemiesEngine.units[Unit] ~= nil
	local hasThreat = br.functions.combat:hasThreat(Unit)
	local passedEnemyCheck = inUnitsTable or (playerTarget and br.functions.misc:enemyListCheck(Unit)) or burnUnit or dummy or hasThreat

	-- Fast path for special units (dummy/burn) - skip most checks
	if passedEnemyCheck and mcCheck and not isCC and (dummy or burnUnit) then
		return true
	end

	-- Standard validation path
	if passedEnemyCheck and mcCheck and not isCC
		and (hasDamagedTapped or (not isTapped and br.engines.enemiesEngineFunctions:isSafeToAttack(Unit)
			and ((hostileOnly and reaction < 4) or (not hostileOnly and reaction < 5) or playerTarget or targeting)))
	then
		-- Valid if any threat condition is met:
		-- Player target, unit targeting us, burn target, proving grounds, or has group threat
		return playerTarget or targeting or burnUnit or br.functions.misc:isInProvingGround() or hasThreat
	end

	return false
end

function misc:SpecificToggle(toggle)
	if br.customToggle then
		return false
	elseif br.functions.misc:getOptionValue(toggle) == 1 then
		return br._G.IsLeftControlKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 2 then
		return br._G.IsLeftShiftKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 3 then
		return br._G.IsRightControlKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 4 then
		return br._G.IsRightShiftKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 5 then
		return br._G.IsRightAltKeyDown()
	elseif br.functions.misc:getOptionValue(toggle) == 6 then
		return false
	elseif br.functions.misc:getOptionValue(toggle) == 7 then
		return br._G.GetKeyState(0x04)
	elseif br.functions.misc:getOptionValue(toggle) == 8 then
		return br._G.GetKeyState(0x05)
	elseif br.functions.misc:getOptionValue(toggle) == 9 then
		return br._G.GetKeyState(0x06)
	elseif br.functions.misc:getOptionValue(toggle) == 10 then
		return br._G.GetKeyState(0xC0)
	end
end

function misc:UpdateToggle(toggle, delay)
	--if toggle == nil then toggle = "toggle" end
	if br.customToggle then
		toggle = br.toggleKey
	end
	if br._G[toggle .. "Timer"] == nil then
		br._G[toggle .. "Timer"] = 0
	end
	if (br.functions.misc:SpecificToggle(toggle .. " Mode") or br.customToggle) and not br._G.GetCurrentKeyBoardFocus() and br._G.GetTime() - br._G[toggle .. "Timer"] > delay then
		br._G[toggle .. "Timer"] = br._G.GetTime()
		br.ui:UpdateButton(tostring(toggle))
	end
end

function misc:BurstToggle(toggle, delay)
	if br.burstKey == nil then
		br.burstKey = false
	end
	if br._G[toggle .. "Timer"] == nil then
		br._G[toggle .. "Timer"] = 0
	end
	if br.burst and not br._G.GetCurrentKeyBoardFocus() and br._G.GetTime() - _G[toggle .. "Timer"] > delay then
		if not br.burstKey then
			br._G[toggle .. "Timer"] = br._G.GetTime()
			br.burstKey = true
		else
			br._G[toggle .. "Timer"] = br._G.GetTime()
			br.burstKey = false
		end
	end
end

-- if pause() then
-- set skipCastingCheck to true, to not check if player is casting
-- (useful if you want to use off-cd stuff, or spells which can be cast while other is casting)
misc.pauseCast = br._G.GetTime()
function misc:pause(skipCastingCheck)
	local food = { 257427, 225737, 274914, 192001, 167152, 314646, 308433 }
	local eating = false
	local pausekey
	for i = 1, #food do
		if br.functions.aura:UnitBuffID("player", food[i]) then
			eating = true
			break
		end
	end
	-- local button = CreateFrame("Button", "DismountButton")
	-- if button == "RightButton" then
	-- 	Print("Right Clicked")
	-- end
	-- Pause if you have no health
	if br._G.UnitHealth("player") == 0 then return true end
	if br.disableControl == true then
		return true
	end
	if br.functions.misc:SpecificToggle("Pause Mode") == nil or br.functions.misc:getValue("Pause Mode") == 6 then
		pausekey = br._G.IsLeftAltKeyDown()
	else
		pausekey = br.functions.misc:SpecificToggle("Pause Mode")
	end
	-- Focused Azerite Beam / Cyclotronic Blast / Azshara's Font of Power
	if not skipCastingCheck then
		local lastCast = br.functions.lastCast.lastCastTable.tracker[1]
		if misc.pauseCast - br._G.GetTime() <= 0 then
			local hasted = (1 - br._G.UnitSpellHaste("player") / 100)
			-- Focused Azerite Beam
			if lastCast == 295258 and br.functions.spell:getSpellCD(295258) == 0 then
				misc.pauseCast = br._G.GetTime() + br.functions.cast:getCastTime(295258) + (br.functions.cast:getCastTime(295261) * hasted)
			end
			-- Cyclotronic Blast
			if lastCast == 293491 and br._G.C_Container.GetItemCooldown(167555) == 0 then
				misc.pauseCast = br._G.GetTime() + br.functions.cast:getCastTime(293491) + (2.5 * hasted) + br.functions.spell:getGlobalCD(true)
			end
			-- Azshara's Font of Power - Latent Arcana
			if lastCast == 296962 and br._G.C_Container.GetItemCooldown(169314) == 0 then
				misc.pauseCast = br._G.GetTime() + br.functions.cast:getCastTime(296962) + (2.5 * hasted)
			end
		end
		if br._G.GetTime() < misc.pauseCast then
			return true
		elseif br._G.GetTime() >= misc.pauseCast then
			misc.pauseCast = br._G.GetTime()
		end
	end
	-- DPS Testing
	if br.functions.misc:isChecked("DPS Testing") then
		if br.functions.unit:GetObjectExists("target") and br.functions.misc:isInCombat("player") then
			if br.functions.combat:getCombatTime() >= (tonumber(br.functions.misc:getOptionValue("DPS Testing")) * 60) and br.functions.unit:isDummy() then
				br._G.StopAttack()
				br._G.ClearTarget()
				br._G.print(tonumber(br.functions.misc:getOptionValue("DPS Testing")) ..
					" Minute Dummy Test Concluded - Profile Stopped")
				br.profileStop = true
			else
				br.profileStop = false
			end
		elseif not br.functions.misc:isInCombat("player") and br.profileStop == true then
			if br.functions.unit:GetObjectExists("target") then
				br._G.StopAttack()
				br._G.ClearTarget()
				br.profileStop = false
			end
		end
	end
	-- Pause Toggle
	if br.data.settings[br.loader.selectedSpec].toggles ~= nil and br.data.settings[br.loader.selectedSpec].toggles["Pause"] == 1 then
		br.ui.chatOverlay:Show("\124cFFED0000 -- Paused -- ")
		return true
	end
	-- Pause Hold/Auto
	if (pausekey and br._G.GetCurrentKeyBoardFocus() == nil and br.functions.misc:isChecked("Pause Mode")) or br.profileStop
		or (((br._G.IsMounted() or br._G.IsFlying()) and not br.functions.unit:isBoss("target")) or br._G.UnitOnTaxi("player")
			or (br._G.UnitInVehicle("player") and not br.functions.misc:isChecked("Bypass Vehicle Check")
				and (not br._G.UnitExists("target") or (br._G.UnitExists("target") and not br._G.UnitCanAttack("player", "target"))))
			and not (br.functions.aura:UnitBuffID("player", 190784) or br.functions.aura:UnitBuffID("player", 164222) or br.functions.aura:UnitBuffID("player", 165803) or br.functions.aura:UnitBuffID("player", 157059)))
		or br._G.SpellIsTargeting() or (br._G.UnitCastingInfo("player") and not skipCastingCheck)
		or (br._G.UnitChannelInfo("player") and not skipCastingCheck)
		or br._G.UnitIsDeadOrGhost("player") or eating or br.functions.aura:UnitDebuffID("player", 252753) or -- Potion of Replenishment (BFA Mana channel) Apparently a debuff
		br.functions.aura:UnitBuffID("player", 114018)
	then
		if br.empowerID ~= nil and br.empowerID > 0 and not (pausekey and br._G.GetCurrentKeyBoardFocus() == nil and br.functions.misc:isChecked("Pause Mode")) then
			return false
		elseif (br._G.UnitCastingInfo("player") and not skipCastingCheck) then
			local _, _, _, _, endTime = br._G.UnitCastingInfo("player")
			local finish = endTime / 1000 - br._G.GetTime()
			if finish > 0.1 then
				return true
			end
		elseif (br._G.UnitChannelInfo("player") and not skipCastingCheck) then
			return true
		else
			br.ui.chatOverlay:Show("Profile Paused")
			return true
		end
	else
		return false
	end
end

-- feed a var
function misc:toggleTrueNil(var)
	if _G[var] ~= true then
		_G[var] = true
	else
		_G[var] = nil
	end
end

function misc:spellDebug(Message)
	if br.imDebugging == true and br.functions.misc:getOptionCheck("Debugging Mode") then
		br.ui.chatOverlay:Show(Message)
	end
end

local reportFindings = {}
local addFindings = function(thisOption, thisPage, thisTimes)
	local alreadyReported = false
	if reportFindings[thisOption] == nil then
		reportFindings[thisOption] = {}
		reportFindings[thisOption]["Findings"] = {}
		reportFindings[thisOption].reported = false
	end
	if #reportFindings[thisOption].Findings == 0 then
		tinsert(reportFindings[thisOption].Findings, { option = thisOption, page = thisPage, timesFound = thisTimes })
	else
		for i = 1, #reportFindings[thisOption].Findings do
			local report = reportFindings[thisOption].Findings[i]
			if report.option == thisOption and report.page == thisPage then
				-- print("Already Reported")
				alreadyReported = true
				return
			end
		end
		if not alreadyReported then
			tinsert(reportFindings[thisOption].Findings, { option = thisOption, page = thisPage, timesFound = thisTimes })
		end
	end
	-- reportFindings[thisOption].option = thisOption
	-- reportFindings[thisOption].page = thisPage
	-- reportFindings[thisOption].timesFound = thisTimes
end
-- lightweight per-tick cache to avoid repeated heavy searches that can cause "script ran too long"
-- local findOptionCache = {}
-- local findOptionCacheTime = 0

-- local function findOption(Value, Page, Type)
--     -- clear cache each ~frame (small delta) to avoid stale UI changes while still preventing hot-loop reevaluation
--     local now = br._G.GetTime()
--     if now - findOptionCacheTime > 0.05 then
--         findOptionCache = {}
--         findOptionCacheTime = now
--     end

--     local key = tostring(Value) .. "|" .. tostring(Page or "") .. "|" .. tostring(Type or "")
--     if findOptionCache[key] ~= nil then
--         return findOptionCache[key]
--     end

--     -- Assume we are checking Rotation Options, if not specified.
--     if Page == nil then
--         Page = "Rotation Options"
--     end
--     if Type == nil then Type = " Check" end

--     if br.data and br.data.settings then
--         if br.data.settings[br.loader.selectedSpec] and br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] then
--             local settings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
--             local option = Value .. Type
--             -- Attempt to find the option using the provided Page (or default page: "Rotation")
--             if settings[Page] and settings[Page][option] ~= nil then
--                 local res = settings[Page][option] -- Found requested option
--                 findOptionCache[key] = res
--                 return res
--             end
--             -- If no Page was provided, and not in the default location, look for it.
--             local timesFound = 0
--             local foundOption
--             if settings and settings["PageList"] then
--                 for i = 1, #settings["PageList"] do
--                     local thisPage = settings["PageList"][i]
--                     if thisPage and settings[thisPage] and settings[thisPage][option] ~= nil then
--                         timesFound = timesFound + 1
--                         foundOption = settings[thisPage][option]
--                         addFindings(option, thisPage, timesFound)
--                     end
--                 end
--                 -- br.report = reportFindings
--                 if reportFindings[option] and #reportFindings[option].Findings ~= 1 and not reportFindings[option].reported then
--                     if #reportFindings[option].Findings == 0 then
--                         br._G.print("No option found for: " .. tostring(option))
--                         reportFindings[option].reported = true
--                     end
--                     if #reportFindings[option].Findings > 1 then
--                         for i = 1, #reportFindings[option].Findings do
--                             local report = reportFindings[option].Findings[i]
--                             br._G.print("Found Option: " ..
--                                 tostring(report.option) ..
--                                 " on Page: " ..
--                                 tostring(report.page))
--                         end
--                         reportFindings[option].reported = true
--                     end
--                 elseif reportFindings[option] ~= nil and reportFindings[option].Findings ~= nil and #reportFindings[option].Findings == 1 then
--                     local thisOption = reportFindings[option].Findings[1]
--                     if settings and settings[thisOption.page] and settings[thisOption.page][thisOption.option] then
--                         local res = settings[thisOption.page][thisOption.option]
--                         findOptionCache[key] = res
--                         return res
--                     end
--                 end
--             end
--         end
--     end

--     local final = (Type == " Check") and false or 0
--     findOptionCache[key] = final
--     return final
-- end
local function findOption(Value, Page, Type)
	-- Assume we are checking Rotation Options, if not specified.
	if Page == nil then
		Page = "Rotation Options"
		-- else
		-- 	Page = string.gsub(Page, " ", "")
		-- 	Page = string.gsub(Page, "Options", "")
	end
	-- print("Looking in: " .. tostring(Page))
	if Type == nil then Type = " Check" end
	if br.data and br.data.settings then
		if br.data.settings[br.loader.selectedSpec] and br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] then
			local settings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
			local option = Value .. Type
			-- Attempt to find the option using the provided Page (or default page: "Rotation")
			if settings[Page] and settings[Page][option] ~= nil then
				-- print("Found Option: \"" .. tostring(option) .. "\" within Page: \"" .. tostring(Page) .. "\"")
				return settings[Page][option] -- Found requested option
			end
			-- If no Page was provided, and not in the default location, look for it.
			local timesFound = 0
			local foundOption
			if settings and settings["PageList"] then
				for i = 1, #settings["PageList"] do
					local thisPage = settings["PageList"][i]
					-- print("Searching on Page: " .. tostring(thisPage) .. " for Option: " .. tostring(option))
					if thisPage and settings[thisPage] and settings[thisPage][option] ~= nil then
						-- print("Found Option: \"" .. tostring(option) .. "\" within Page: \"" .. tostring(thisPage) .. "\"")
						timesFound = timesFound + 1
						foundOption = settings[thisPage][option] -- Found requested option
						addFindings(option, thisPage, timesFound)
					end
				end
				-- br.report = reportFindings
				if reportFindings[option] and #reportFindings[option].Findings ~= 1 and not reportFindings[option].reported then
					if #reportFindings[option].Findings == 0 then
						br._G.print("No option found for: " .. tostring(option))
						reportFindings[option].reported = true
					end
					if #reportFindings[option].Findings > 1 then
						for i = 1, #reportFindings[option].Findings do
							local report = reportFindings[option].Findings[i]
							br._G.print("Found Option: " ..
								tostring(report.option) ..
								" on Page: " ..
								tostring(report.page))
						end
						reportFindings[option].reported = true
					end
				elseif reportFindings[option] ~= nil and reportFindings[option].Findings ~= nil and #reportFindings[option].Findings == 1 then
					local thisOption = reportFindings[option].Findings[1]
					if settings and settings[thisOption.page] and settings[thisOption.page][thisOption.option] then
						return settings[thisOption.page][thisOption.option]
					end
				end
			end
		end
	end
	if Type == " Check" then
		return false
	else
		return 0
	end
end

-- if br.functions.misc:isChecked("Debug") then
function misc:isChecked(Value, Page)
	return findOption(Value, Page, " Check")
end

-- if br.functions.misc:isSelected("Stormlash Totem") then
function misc:isSelected(Value)
	if br.data.settings ~= nil
		and (br.data.settings[br.loader.selectedSpec].toggles["Cooldowns"] == 3
			or (br.functions.misc:isChecked(Value) and (br.functions.misc:getValue(Value) == 3
				or (br.functions.misc:getValue(Value) == 2 and br.data.settings[br.loader.selectedSpec].toggles["Cooldowns"] == 2))))
	then
		return true
	end
	return false
end

-- if br.functions.misc:getValue("player") <= br.functions.misc:getValue("Eternal Flame") then
-- function misc:getValue(Value)
-- 	if br.data~=nil then
-- 		if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]~=nil then
-- 	        if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][Value.."Status"] ~= nil then
-- 	            return br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][Value.."Status"]
-- 	        elseif br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][Value.."Drop"] ~= nil then
-- 	            return br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][Value.."Drop"]
-- 	        else
-- 	            return 0
-- 	        end
-- 		end
-- 	else
-- 		return 0
-- 	end
-- end
function misc:getValue(Value, Page)
	local statusValue = findOption(Value, Page, " Status")
	if statusValue and statusValue > 0 then
		return statusValue
	end
	local dropValue = findOption(Value, Page, " Drop")
	if dropValue and dropValue > 0 then
		return dropValue
	end
	local editBoxValue = findOption(Value, Page, " EditBox")
	if editBoxValue then
		return editBoxValue
	end
	-- if br.data ~= nil and br.data.settings ~= nil then
	-- 	local selectedProfile = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
	-- 	if selectedProfile ~= nil then
	-- 		if selectedProfile[Value .. "EditBox"] ~= nil then
	-- 			return selectedProfile[Value .. "EditBox"]
	-- 		end
	-- 	end
	-- end
	return 0
	-- if br.data ~= nil and br.data.settings ~= nil then
	-- 	local selectedProfile = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
	-- 	if selectedProfile ~= nil then
	-- 		if selectedProfile[Value .. "Status"] ~= nil then
	-- 			return selectedProfile[Value .. "Status"]
	-- 		elseif selectedProfile[Value .. "Drop"] ~= nil then
	-- 			return selectedProfile[Value .. "Drop"]
	-- 		elseif selectedProfile[Value .. "EditBox"] ~= nil then
	-- 			return selectedProfile[Value .. "EditBox"]
	-- 		else
	-- 			return 0
	-- 		end
	-- 	end
	-- else
	-- 	return 0
	-- end
end

function misc:setValue(Value, Page, Amount)
	local statusValue = findOption(Value, Page, " Status")
	if statusValue and statusValue > 0 then
		statusValue:SetNumber(Amount)
	end
	local dropValue = findOption(Value, Page, " Drop")
	if dropValue and dropValue > 0 then
		dropValue:SetNumber(Amount)
	end
	local editBoxValue = findOption(Value, Page, " EditBox")
	if editBoxValue then
		editBoxValue:SetNumber(Amount)
	end
end

-- used to gather informations from the bot options frame
function misc:getOptionCheck(Value)
	return br.functions.misc:isChecked(Value)
end

function misc:getOptionValue(Value)
	return br.functions.misc:getValue(Value)
end

function misc:setOptionValue(Value, Amount)
	return br.functions.misc:setValue(Value, nil, Amount)
end

function misc:getOptionText(Value)
	if br.data ~= nil and br.data.settings ~= nil then
		local selectedProfile = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
		if selectedProfile ~= nil then
			if selectedProfile[Value .. "Data"] ~= nil then
				if selectedProfile[Value .. "Drop"] ~= nil then
					if selectedProfile[Value .. "Data"][selectedProfile[Value .. "Drop"]] ~= nil then
						return selectedProfile[Value .. "Data"][selectedProfile[Value .. "Drop"]]
					end
				end
			end
		end
	end
	return ""
end

function misc:convertName(name)
	if name ~= nil then
		-- Remove hyphens and lowercase the letter that follows
		name = name:gsub("-(%a)", function(letter)
			return letter:lower()
		end)
		-- Cap All First Letters of Words
		name = name:gsub("(%a)([%w_']*)", function(first, rest)
			return first:upper() .. rest:lower()
		end)
		-- Lower first character of name
		name = name:gsub("%a", string.lower, 1)
		-- Remove all non alphanumeric in string
		name = name:gsub("%W", "")
		return name
	end
	return "None"
end

function misc:devMode()
	if br.functions.misc:isChecked("Dev Mode") then
		if _G.br == nil then
			_G.br = br
			br._G.print("<Dev Mode Enabled>")
		end
	else
		if _G.br ~= nil then
			_G.br = nil
			br._G.print("<Dev Mode Disabled>")
		end
	end
end

function misc:bossHPLimit(unit, hp)
	-- Boss Active/Health Max
	local bossHPMax = 0
	local inBossFight = false
	local enemyList = br.engines.enemiesEngineFunctions:getEnemies("player", 40)
	for i = 1, #enemyList do
		local thisUnit = enemyList[i]
		if br.functions.unit:isBoss(thisUnit) then
			bossHPMax = br._G.UnitHealthMax(thisUnit)
			inBossFight = true
			break
		end
	end
	return (not inBossFight or (inBossFight and br._G.UnitHealthMax(unit) > bossHPMax * (hp / 100)))
end

function misc:talentAnywhere()
	local removeTalent = br._G.RemoveTalent
	local learnTalent = br._G.LearnTalent
	-- Load Talent UI if not opened before
	if not br._G.C_AddOns.IsAddOnLoaded("Blizzard_TalentUI") and not br._G.UnitAffectingCombat("player") then
		br._G.LoadAddOn("Blizzard_TalentUI")
	end

	local function talentSelection(row)
		for column = 1, 3 do
			if
				br._G.IsMouseButtonDown(1) and br.newTalent == nil and br._G.MouseIsOver(_G["PlayerTalentFrameTalentsTalentRow" .. row .. "Talent" .. column]) and
				not select(4, br._G.GetTalentInfoByID(br._G.GetTalentInfo(row, column, 1), 1))
			then
				br.selectedTalent = nil
				br.newTalent = select(1, br._G.GetTalentInfo(row, column, 1))
				br.newTalentRow = row
			end
			if br.newTalentRow ~= nil then
				if select(4, br._G.GetTalentInfoByID(br._G.GetTalentInfo(br.newTalentRow, column, 1), 1)) then
					br.selectedTalent = select(1, br._G.GetTalentInfo(br.newTalentRow, column, 1))
				end
			end
		end
		return br.selectedTalent, br.newTalent -- selectedNew
	end

	if br._G.PlayerTalentFrame and br._G.PlayerTalentFrame:IsVisible() and not br._G.IsResting() then
		for row = 1, 7 do
			br.selectedTalent, br.newTalent, br.selectedNew = talentSelection(row)
		end
		--br.ui.chatOverlay:Show(tostring(selectedTalent).." | "..tostring(newTalent).." | "..tostring(selectedNew))
		if br.newTalent ~= nil then
			if br.selectedTalent ~= nil and br.selectedTalent ~= br.newTalent and not br.selectedNew and br.debug.timer:useTimer("RemoveTalent", 0.1) then
				removeTalent(br.selectedTalent)
			end
			if br.selectedTalent == nil and br.selectedTalent ~= br.newTalent and not br.selectedNew then
				learnTalent(br.newTalent)
				br.selectedNew = true
			end
			if br.selectedTalent == br.newTalent then
				br.selectedNew = false
				br.newTalent = nil
			end
		end
	end
end

function misc:getEssenceRank(essenceName)
	if br._G.GetSpellInfo(essenceName) == nil then
		return 0
	end
	local essenceRank = 0
	local essenceTable = br._G.C_AzeriteEssence.GetMilestones()
	local icon = select(3, br._G.GetSpellInfo(essenceName))
	for i = 1, #essenceTable do
		local milestone = essenceTable[i]
		if milestone.slot ~= nil and milestone.unlocked == true then
			local eRank = br._G.C_AzeriteEssence.GetEssenceInfo(br._G.C_AzeriteEssence.GetMilestoneEssence(milestone.ID))
				.rank
			local eIcon = br._G.C_AzeriteEssence.GetEssenceInfo(br._G.C_AzeriteEssence.GetMilestoneEssence(milestone.ID))
				.icon
			if icon == eIcon then
				essenceRank = eRank
			end
		end
		return essenceRank
	end
end

function misc:addonDebug(msg, system)
	if msg == nil then
		return
	end
	if br.functions.misc:isChecked("Addon Debug Messages") then
		if system == true and (br.functions.misc:getValue("Addon Debug Messages") == 1 or br.functions.misc:getValue("Addon Debug Messages") == 3) then
			if br.debug.timer:useTimer("System Delay", 0.1) then
				print(br.ui.colors.class .. "[BadRotations] System Debug: |cffFFFFFF" .. tostring(msg))
			end
		elseif system ~= true and (br.functions.misc:getValue("Addon Debug Messages") == 2 or br.functions.misc:getValue("Addon Debug Messages") == 3) then
			if br.debug.timer:useTimer("Profile Delay", 0.1) then
				print(br.ui.colors.class .. "[BadRotations] Profile Debug: |cffFFFFFF" .. tostring(msg))
			end
		end
	end
end

function misc:sanguineCheck(unit)
	if br.sanguine then
		local x, y, z = br._G.ObjectPosition(unit)
		for _, v in pairs(br.sanguine) do
			if br._G.sqrt(((x - v.posX) ^ 2) + ((y - v.posY) ^ 2) + ((z - v.posZ) ^ 2)) < 5 then
				return true
			end
		end
	end
	return false
end

function misc:isTableEmpty(table)
	if table == nil then
		return true
	end
	local retval = true
	if next(table) ~= nil then
		retval = false
	end
	return retval
end

function misc:getItemGlow(object)
	return br._G.IsQuestObject(object)
end

function misc:AcceptQueues()
	if misc:getOptionCheck("Accept Queues") then
		-- Accept Queues
		-- local randomReady = math.random(8, 15)
		-- add some randomness
		if misc.readyToAccept and misc.readyToAccept <= br._G.GetTime() - 5 then
			br._G.AcceptProposal()
			misc.readyToAccept = nil
			-- randomReady = nil
		end
	end
end