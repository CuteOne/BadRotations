local _, br = ...
-- getLatency()
function br.getLatency()
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
function br.getAgility()
	local AgiBase, _, AgiPos, AgiNeg = br._G.UnitStat("player", 2)
	local Agi = AgiBase + AgiPos + AgiNeg
	return Agi
end

function br.getFallDistance()
	local zDist
	local zCoord = nil
	local _, _, position = br.GetObjectPosition("player")

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
function br.getFallTime()
	if br.fallStarted == nil then
		br.fallStarted = 0
	end
	if br.fallTime == nil then
		br.fallTime = 0
	end
	if br._G.IsFalling() and br.getFallDistance() < 0 then
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

-- if br.getLineOfSight("target"[,"target"]) then
br.doLinesIntersect = function(a, b, c, d)
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

function br.carapaceMath(Unit1, Unit2)
	if Unit2 == nil then
		Unit2 = Unit1
		if Unit2 == "player" then
			Unit1 = "target"
		else
			Unit1 = "player"
		end
	end
	if (br.player and br.player.eID and br.player.eID == 2337) then
		local pX, pY = br.GetObjectPosition(Unit1)
		local tX, tY = br.GetObjectPosition(Unit2)
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
				local tentFacing = br.GetObjectFacing(object)
				tentX, tentY = br.GetObjectPosition(object)
				table.insert(
					br.tentCache,
					{
						["tentFacing"] = tentFacing,
						["tentX"] = select(1, br.GetObjectPosition(object)),
						["tentY"] = select(2, br.GetObjectPosition(object)),
						["tentZ"] = select(3, br.GetObjectPosition(object)),
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
						if br.doLinesIntersect(a, b, c, d) then
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

function br.getLineOfSight(Unit1, Unit2)
	if Unit2 == nil then
		Unit2 = Unit1
		if Unit2 == "player" then
			Unit1 = "target"
		else
			Unit1 = "player"
		end
	end
	local skipLoSTable = br.lists.los
	if skipLoSTable[br.GetObjectID(Unit1)] or skipLoSTable[br.GetObjectID(Unit2)] or -- Kyrian Hunter Ability
		(Unit1 and Unit1 ~= "player" and br.getDebuffRemain(Unit1, 308498) > 0) or
		(Unit2 and Unit2 ~= "player" and br.getDebuffRemain(Unit2, 308498) > 0)
	then
		return true
	end
	if br.GetObjectExists(Unit1) and br.GetUnitIsVisible(Unit1) and br.GetObjectExists(Unit2) and br.GetUnitIsVisible(Unit2) then
		local X1, Y1, Z1 = br.GetObjectPosition(Unit1)
		local X2, Y2, Z2 = br.GetObjectPosition(Unit2)
		local pX = br.GetObjectPosition("player")
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
				if br.carapaceMath(Unit1, Unit2) == true then
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
function br.getGround(Unit)
	if br.GetObjectExists(Unit) and br.GetUnitIsVisible(Unit) then
		local X1, Y1, Z1 = br.GetObjectPosition(Unit)
		if br._G.TraceLine(X1, Y1, Z1, X1, Y1, Z1 - 2, 0x10) == nil and br._G.TraceLine(X1, Y1, Z1, X1, Y1, Z1 - 2, 0x100) == nil then
			return false
		else
			return true
		end
	end
end

function br.getGroundDistance(Unit)
	if br.GetObjectExists(Unit) and br.GetUnitIsVisible(Unit) then
		local X1, Y1, Z1 = br.GetObjectPosition(Unit)
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
function br.getPetLineOfSight(Unit)
	if br.GetObjectExists(Unit) and br.GetUnitIsVisible("pet") and br.GetUnitIsVisible(Unit) then
		local X1, Y1, Z1 = br.GetObjectPosition("pet")
		local X2, Y2, Z2 = br.GetObjectPosition(Unit)
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
function br.round2(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- if getTalent(8) == true then
function br.getTalent(Row, Column, specGroup)
	if specGroup == nil then
		specGroup = br._G.GetActiveSpecGroup()
	end
	local _, _, _, selected = br._G.GetTalentInfo(Row, Column, specGroup)
	return selected or false
end

-- if hasEmptySlots() then
function br.hasEmptySlots()
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
function br.hasGlyph(glyphid)
	for i = 1, 6 do
		if select(4, br._G.GetGlyphSocketInfo(i)) == glyphid or select(6, br._G.GetGlyphSocketInfo(i)) == glyphid then
			return true
		end
	end
	return false
end

-- UnitGUID("target"):sub(-15,-10)

--if isGarrMCd() then
function br.isGarrMCd(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if br.GetUnitExists(Unit) and (br.UnitDebuffID(Unit, 145832) or br.UnitDebuffID(Unit, 145171) or br.UnitDebuffID(Unit, 145065) or br.UnitDebuffID(Unit, 145071)) then
		return true
	else
		return false
	end
end

-- if isInCombat("target") then
function br.isInCombat(Unit)
	if br._G.UnitAffectingCombat(Unit) or br.isChecked("Ignore Combat") then
		return true
	else
		return false
	end
end

function br.isInArdenweald()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.Ardenweald, mapID)
end

function br.isInBastion()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.Bastion, mapID)
end

function br.isInMaldraxxus()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.Maldraxxus, mapID)
end

function br.isInRevendreth()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.Revendreth, mapID)
end

function br.isInTheMaw()
	local tContains = br._G.tContains
	local mapID = br._G.C_Map.GetBestMapForUnit("player")
	return tContains(br.lists.maps.TheMaw, mapID)
end

-- if isInDraenor() then
function br.isInDraenor()
	local tContains = br._G.tContains
	local currentMapID = br._G.C_Map.GetBestMapForUnit("player")
	local draenorMapIDs = br.lists.maps.Draenor
	return tContains(draenorMapIDs, currentMapID)
end

function br.isInLegion()
	local tContains = br._G.tContains
	local currentMapID = br._G.C_Map.GetBestMapForUnit("player")
	local legionMapIDs = br.lists.maps.Legion
	return tContains(legionMapIDs, currentMapID)
end

function br.isInProvingGround()
	local currentMapID = br._G.C_Map.GetBestMapForUnit("player")
	return currentMapID == 480
end

-- if IsInPvP() then
function br.isInPvP()
	local inpvp = br._G.GetPVPTimer()
	if (inpvp ~= 301000 and inpvp ~= -1) or (br._G.UnitIsPVP("player") and br._G.UnitIsPVP("target")) then
		return true
	else
		return false
	end
end

--if isLongTimeCCed("target") then
-- CCs with >=20 seconds
function br.isLongTimeCCed(Unit)
	if Unit == nil then
		return false
	end
	local longTimeCC = br.lists.longCC
	for i = 1, 40 do
		local debuffSpellID = select(10, br._G.UnitDebuff(Unit, i))
		if debuffSpellID == nil then
			return false
		end
		if longTimeCC[tonumber(debuffSpellID)] == true then
			return true
		end
	end
	return false
end

-- if isLooting() then
function br.isLooting()
	return br._G.GetNumLootItems() > 0
end

-- if not isMoving("target") then
function br.isMoving(Unit)
	if Unit == nil then
		return false
	end
	return br._G.GetUnitSpeed(Unit) > 0
end

-- if IsMovingTime(5) then
function br.IsMovingTime(time)
	if time == nil then
		time = 1
	end
	if br._G.GetUnitSpeed("player") > 0 then
		if br.IsRunning == nil then
			br.IsRunning = br._G.GetTime()
			br.IsStanding = nil
		end
		if br._G.GetTime() - br.IsRunning > time then
			return true
		end
	else
		if br.IsStanding == nil then
			br.IsStanding = br._G.GetTime()
			br.IsRunning = nil
		end
		if br._G.GetTime() - br.IsStanding > time then
			return false
		end
	end
end

function br.isPlayer(Unit)
	if br.GetUnitExists(Unit) ~= true then
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

function br.getStandingTime()
	return br.DontMoveStartTime and br._G.GetTime() - br.DontMoveStartTime or nil
end

--
function br.isStanding(Seconds)
	return br._G.IsFalling() == false and br.DontMoveStartTime and br.getStandingTime() >= Seconds or false
end

-- if IsStandingTime(5) then
function br.IsStandingTime(time, unit)
	if time == nil then
		time = 1
	end
	if unit == nil then
		unit = "player"
	end
	if not br._G.IsFalling() and br._G.GetUnitSpeed(unit) == 0 then
		if br.IsStanding == nil then
			br.IsStanding = br.GetTime()
			br.IsRunning = nil
		end
		if br._G.GetTime() - br.IsStanding > time then
			return true
		end
	else
		if br.IsRunning == nil then
			br.IsRunning = br._G.GetTime()
			br.IsStanding = nil
		end
		if br._G.GetTime() - br.IsRunning > time then
			return false
		end
	end
end

-- if isValidTarget("target") then
function br.isValidTarget(Unit)
	if br._G.UnitIsEnemy("player", Unit) or br.isDummy(Unit) then
		if br.GetUnitExists(Unit) and not br.GetUnitIsDeadOrGhost(Unit) then
			return true
		else
			return false
		end
	else
		if br.GetUnitExists(Unit) then
			return true
		else
			return false
		end
	end
end

function br.isTargeting(Unit, MatchUnit)
	if br.GetUnit(Unit) == nil then
		return false
	end
	if br._G.UnitTarget(br.GetUnit(Unit)) == nil then
		return false
	end
	if MatchUnit == nil then
		MatchUnit = "player"
	end
	return br._G.UnitTarget(br.GetUnit(Unit)) == br._G.ObjectPointer(MatchUnit)
end

function br.hasTank()
	if #br.friend == 1 then return false end
	for i = 1, #br.friend do
		local thisUnit = br.friend[i].unit
		if br._G.UnitGroupRolesAssigned(thisUnit) == "TANK"
			and br.getDistance(thisUnit) < 40 and br._G.UnitIsPlayer(thisUnit)
		then
			return true
		end
	end
	return false
end

function br.enemyListCheck(Unit)
	local targetBuff = 0
	local playerBuff = 0
	if br.UnitDebuffID(Unit, 310499) then
		targetBuff = 1
	end
	if br.UnitDebuffID("player", 310499) then
		playerBuff = 1
	end
	if targetBuff ~= playerBuff then
		return false
	end
	local phaseReason = br._G.UnitPhaseReason(Unit)
	local distance = br.getDistance(Unit, "player")
	local mcCheck = (br.isChecked("Attack MC Targets") and (not br.GetUnitIsFriend(Unit, "player") or br._G.UnitIsCharmed(Unit))) or
		not br.GetUnitIsFriend(Unit, "player")
	local inPhase = not phaseReason or phaseReason == 2 or phaseReason == 3
	if (br.UnitDebuffID("player", 320102) or br.UnitDebuffID(Unit, 424495)) and br._G.UnitIsPlayer(Unit) then
		return true
	end
	return br.GetObjectExists(Unit) and not br.GetUnitIsDeadOrGhost(Unit) and inPhase and
		br._G.UnitCanAttack("player", Unit) and br._G.UnitHealth(Unit) > 0 and distance < 50 and
		not br.isCritter(Unit) and
		mcCheck and
		not br.GetUnitIsUnit(Unit, "pet") and
		br._G.UnitCreator(Unit) ~= br._G.ObjectPointer("player") and
		br.GetObjectID(Unit) ~= 11492 and
		br.getLineOfSight("player", Unit) and
		((Unit ~= 131824 and Unit ~= 131823 and Unit ~= 131825) or
			((br.UnitBuffID(Unit, 260805) or br.GetUnitIsUnit(Unit, "target")) and (Unit == 131824 or Unit == 131823 or Unit == 131825)))
end

function br.isValidUnit(Unit)
	local inInstance = br._G.IsInInstance()
	local hostileOnly = br.isChecked("Hostiles Only")
	local playerTarget = br.GetUnitIsUnit(Unit, "target")
	local reaction = br.GetUnitReaction(Unit, "player") or 10
	local targeting = br.isTargeting(Unit)
	local dummy = br.isDummy(Unit)
	local burnUnit = br.getOptionCheck("Forced Burn") and br.isBurnTarget(Unit) > 0
	local isCC = br.getOptionCheck("Don't break CCs") and br.isLongTimeCCed(Unit) or false
	local mcCheck = (br.isChecked("Attack MC Targets") and (not br.GetUnitIsFriend(Unit, "player") or (br._G.UnitIsCharmed(Unit) and br._G.UnitCanAttack("player", Unit))))
		or not br.GetUnitIsFriend(Unit, "player")
	if playerTarget and (br.UnitDebuffID("player", 320102) or br.UnitDebuffID(Unit, 424495)) and br._G.UnitIsPlayer(Unit) then
		return true
	end
	if playerTarget and br.units[br._G.UnitTarget("player")] == nil and not br.enemyListCheck("target") then
		return false
	end
	if not br.pause(true) and Unit ~= nil and (br.units[Unit] ~= nil or Unit == "target" or burnUnit or dummy) and mcCheck
		and not isCC and (dummy or burnUnit or (not br._G.UnitIsTapDenied(Unit) and br.isSafeToAttack(Unit)
			and ((hostileOnly and reaction < 4) or (not hostileOnly and reaction < 5) or playerTarget or targeting)))
	then
		return (playerTarget and (not inInstance or (inInstance and (#br.friend == 1 or not br.hasTank())))) or targeting or
			burnUnit or br.isInProvingGround() or br.hasThreat(Unit)
	end
	return false
end

function br.SpecificToggle(toggle)
	if br.customToggle then
		return false
	elseif br.getOptionValue(toggle) == 1 then
		return br._G.IsLeftControlKeyDown()
	elseif br.getOptionValue(toggle) == 2 then
		return br._G.IsLeftShiftKeyDown()
	elseif br.getOptionValue(toggle) == 3 then
		return br._G.IsRightControlKeyDown()
	elseif br.getOptionValue(toggle) == 4 then
		return br._G.IsRightShiftKeyDown()
	elseif br.getOptionValue(toggle) == 5 then
		return br._G.IsRightAltKeyDown()
	elseif br.getOptionValue(toggle) == 6 then
		return false
	elseif br.getOptionValue(toggle) == 7 then
		return br._G.GetKeyState(0x04)
	elseif br.getOptionValue(toggle) == 8 then
		return br._G.GetKeyState(0x05)
	elseif br.getOptionValue(toggle) == 9 then
		return br._G.GetKeyState(0x06)
	elseif br.getOptionValue(toggle) == 10 then
		return br._G.GetKeyState(0xC0)
	end
end

function br.UpdateToggle(toggle, delay)
	--if toggle == nil then toggle = "toggle" end
	if br.customToggle then
		toggle = br.toggleKey
	end
	if br._G[toggle .. "Timer"] == nil then
		br._G[toggle .. "Timer"] = 0
	end
	if (br.SpecificToggle(toggle .. " Mode") or br.customToggle) and not br._G.GetCurrentKeyBoardFocus() and br._G.GetTime() - br._G[toggle .. "Timer"] > delay then
		br._G[toggle .. "Timer"] = br._G.GetTime()
		br.UpdateButton(tostring(toggle))
	end
end

function br.BurstToggle(toggle, delay)
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
function br.pause(skipCastingCheck)
	local food = { 257427, 225737, 274914, 192001, 167152, 314646, 308433 }
	local eating = false
	local pausekey
	for i = 1, #food do
		if br.UnitBuffID("player", food[i]) then
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
	if br.SpecificToggle("Pause Mode") == nil or br.getValue("Pause Mode") == 6 then
		pausekey = br._G.IsLeftAltKeyDown()
	else
		pausekey = br.SpecificToggle("Pause Mode")
	end
	-- Focused Azerite Beam / Cyclotronic Blast / Azshara's Font of Power
	if not skipCastingCheck then
		local lastCast = br.lastCastTable.tracker[1]
		if br.pauseCast - br._G.GetTime() <= 0 then
			local hasted = (1 - br._G.UnitSpellHaste("player") / 100)
			-- Focused Azerite Beam
			if lastCast == 295258 and br.getSpellCD(295258) == 0 then
				br.pauseCast = br._G.GetTime() + br.getCastTime(295258) + (br.getCastTime(295261) * hasted)
			end
			-- Cyclotronic Blast
			if lastCast == 293491 and br._G.GetItemCooldown(167555) == 0 then
				br.pauseCast = br._G.GetTime() + br.getCastTime(293491) + (2.5 * hasted) + br.getGlobalCD(true)
			end
			-- Azshara's Font of Power - Latent Arcana
			if lastCast == 296962 and br._G.GetItemCooldown(169314) == 0 then
				br.pauseCast = br._G.GetTime() + br.getCastTime(296962) + (2.5 * hasted)
			end
		end
		if br._G.GetTime() < br.pauseCast then
			return true
		elseif br._G.GetTime() >= br.pauseCast then
			br.pauseCast = br._G.GetTime()
		end
	end
	-- DPS Testing
	if br.isChecked("DPS Testing") then
		if br.GetObjectExists("target") and br.isInCombat("player") then
			if br.getCombatTime() >= (tonumber(br.getOptionValue("DPS Testing")) * 60) and br.isDummy() then
				br._G.StopAttack()
				br._G.ClearTarget()
				br._G.print(tonumber(br.getOptionValue("DPS Testing")) ..
					" Minute Dummy Test Concluded - Profile Stopped")
				br.profileStop = true
			else
				br.profileStop = false
			end
		elseif not br.isInCombat("player") and br.profileStop == true then
			if br.GetObjectExists("target") then
				br._G.StopAttack()
				br._G.ClearTarget()
				br.profileStop = false
			end
		end
	end
	-- Pause Toggle
	if br.data.settings[br.selectedSpec].toggles ~= nil and br.data.settings[br.selectedSpec].toggles["Pause"] == 1 then
		br.ChatOverlay("\124cFFED0000 -- Paused -- ")
		return true
	end
	-- Pause Hold/Auto
	if (pausekey and br._G.GetCurrentKeyBoardFocus() == nil and br.isChecked("Pause Mode")) or br.profileStop
		or (br._G.IsMounted() or br._G.IsFlying() or br._G.UnitOnTaxi("player")
			or (br._G.UnitInVehicle("player") and not br.isChecked("Bypass Vehicle Check")
				and (not br._G.UnitExists("target") or (br._G.UnitExists("target") and not br._G.UnitCanAttack("player", "target"))))
			and not (br.UnitBuffID("player", 190784) or br.UnitBuffID("player", 164222) or br.UnitBuffID("player", 165803) or br.UnitBuffID("player", 157059)))
		or br._G.SpellIsTargeting() or (br._G.UnitCastingInfo("player") and not skipCastingCheck)
		or (br._G.UnitChannelInfo("player") and not skipCastingCheck)
		or br._G.UnitIsDeadOrGhost("player") or eating or br.UnitDebuffID("player", 252753) or -- Potion of Replenishment (BFA Mana channel) Apparently a debuff
		br.UnitBuffID("player", 114018)
	then
		if br.empowerID ~= nil and br.empowerID > 0 and not (pausekey and br._G.GetCurrentKeyBoardFocus() == nil and br.isChecked("Pause Mode")) then
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
			br.ChatOverlay("Profile Paused")
			return true
		end
	else
		return false
	end
end

-- feed a var
function br.toggleTrueNil(var)
	if _G[var] ~= true then
		_G[var] = true
	else
		_G[var] = nil
	end
end

function br.spellDebug(Message)
	if br.imDebugging == true and br.getOptionCheck("Debugging Mode") then
		br.ChatOverlay(Message)
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
		if br.data.settings[br.selectedSpec] and br.data.settings[br.selectedSpec][br.selectedProfile] then
			local settings = br.data.settings[br.selectedSpec][br.selectedProfile]
			local option = Value .. Type
			-- Attempt to find the option using the provided Page (or default page: "Rotation")
			if settings[Page] and settings[Page][option] ~= nil then
				-- print("Found Option: \"" .. tostring(option) .. "\" within Page: \"" .. tostring(Page) .. "\"")
				return settings[Page][option] -- Found requested option
			end
			-- If no Page was provided, and not in the default location, look for it.
			local timesFound = 0
			local foundOption
			if settings["PageList"] then
				for i = 1, #settings["PageList"] do
					local thisPage = settings["PageList"][i]
					-- print("Searching on Page: " .. tostring(thisPage) .. " for Option: " .. tostring(option))
					if settings[thisPage] and settings[thisPage][option] ~= nil then
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

-- if br.isChecked("Debug") then
function br.isChecked(Value, Page)
	return findOption(Value, Page, " Check")
end

-- if br.isSelected("Stormlash Totem") then
function br.isSelected(Value)
	if br.data.settings ~= nil
		and (br.data.settings[br.selectedSpec].toggles["Cooldowns"] == 3
			or (br.isChecked(Value) and (br.getValue(Value) == 3
				or (br.getValue(Value) == 2 and br.data.settings[br.selectedSpec].toggles["Cooldowns"] == 2))))
	then
		return true
	end
	return false
end

-- if br.getValue("player") <= br.getValue("Eternal Flame") then
-- function br.getValue(Value)
-- 	if br.data~=nil then
-- 		if br.data.settings[br.selectedSpec][br.selectedProfile]~=nil then
-- 	        if br.data.settings[br.selectedSpec][br.selectedProfile][Value.."Status"] ~= nil then
-- 	            return br.data.settings[br.selectedSpec][br.selectedProfile][Value.."Status"]
-- 	        elseif br.data.settings[br.selectedSpec][br.selectedProfile][Value.."Drop"] ~= nil then
-- 	            return br.data.settings[br.selectedSpec][br.selectedProfile][Value.."Drop"]
-- 	        else
-- 	            return 0
-- 	        end
-- 		end
-- 	else
-- 		return 0
-- 	end
-- end
function br.getValue(Value, Page)
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
	-- 	local selectedProfile = br.data.settings[br.selectedSpec][br.selectedProfile]
	-- 	if selectedProfile ~= nil then
	-- 		if selectedProfile[Value .. "EditBox"] ~= nil then
	-- 			return selectedProfile[Value .. "EditBox"]
	-- 		end
	-- 	end
	-- end
	return 0
	-- if br.data ~= nil and br.data.settings ~= nil then
	-- 	local selectedProfile = br.data.settings[br.selectedSpec][br.selectedProfile]
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

function br.setValue(Value, Page, Amount)
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
function br.getOptionCheck(Value)
	return br.isChecked(Value)
end

function br.getOptionValue(Value)
	return br.getValue(Value)
end

function br.setOptionValue(Value, Amount)
	return br.setValue(Value, nil, Amount)
end

function br.getOptionText(Value)
	if br.data ~= nil and br.data.settings ~= nil then
		local selectedProfile = br.data.settings[br.selectedSpec][br.selectedProfile]
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

function br.convertName(name)
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

function br.devMode()
	if br.isChecked("Dev Mode") then
		_G.br = br
	else
		_G.br = nil
	end
end

function br.bossHPLimit(unit, hp)
	-- Boss Active/Health Max
	local bossHPMax = 0
	local inBossFight = false
	local enemyList = br.getEnemies("player", 40)
	for i = 1, #enemyList do
		local thisUnit = enemyList[i]
		if br.isBoss(thisUnit) then
			bossHPMax = br._G.UnitHealthMax(thisUnit)
			inBossFight = true
			break
		end
	end
	return (not inBossFight or (inBossFight and br._G.UnitHealthMax(unit) > bossHPMax * (hp / 100)))
end

function br.talentAnywhere()
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
		--br.ChatOverlay(tostring(selectedTalent).." | "..tostring(newTalent).." | "..tostring(selectedNew))
		if br.newTalent ~= nil then
			if br.selectedTalent ~= nil and br.selectedTalent ~= br.newTalent and not br.selectedNew and br.timer:useTimer("RemoveTalent", 0.1) then
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

function br.getEssenceRank(essenceName)
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

function br.addonDebug(msg, system)
	if msg == nil then
		return
	end
	if br.isChecked("Addon Debug Messages") then
		if system == true and (br.getValue("Addon Debug Messages") == 1 or br.getValue("Addon Debug Messages") == 3) then
			if br.timer:useTimer("System Delay", 0.1) then
				print(br.classColor .. "[BadRotations] System Debug: |cffFFFFFF" .. tostring(msg))
			end
		elseif system ~= true and (br.getValue("Addon Debug Messages") == 2 or br.getValue("Addon Debug Messages") == 3) then
			if br.timer:useTimer("Profile Delay", 0.1) then
				print(br.classColor .. "[BadRotations] Profile Debug: |cffFFFFFF" .. tostring(msg))
			end
		end
	end
end

function br.store(key, value)
	if br.profile == nil then
		br.profile = {}
	end
	br.profile[key] = value
	return true
end

function br.fetch(key, default)
	if br.profile == nil then
		br.profile = {}
	end
	local value = br.profile[key]
	return value == nil and default or value
end

function br.sanguineCheck(unit)
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

function br.isTableEmpty(table)
	if table == nil then
		return true
	end
	local retval = true
	if next(table) ~= nil then
		retval = false
	end
	return retval
end

function br.getItemGlow(object)
	return br._G.IsQuestObject(object)
end
