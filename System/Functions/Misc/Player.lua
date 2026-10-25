local _, br = ...
-- The player's own state: latency, movement and standing time, falling, looting, combat.
---@class br.functions.misc
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc
local movingTimer

local standingTimer

function misc:AcceptQueues()
	if misc:getOptionCheck("Accept Queues") then
		-- Accept Queues
		-- local randomReady = math.random(8, 15)
		-- add some randomness
		if misc.readyToAccept and misc.readyToAccept <= br.game.GetTime() - 5 then
			br.game.AcceptProposal()
			misc.readyToAccept = nil
			-- randomReady = nil
		end
	end
end

--Calculate Agility
function misc:getAgility()
	local AgiBase, _, AgiPos, AgiNeg = br.game.UnitStat("player", 2)
	local Agi = AgiBase + AgiPos + AgiNeg
	return Agi
end

-- The player's melee crit chance in percent
function misc:getCritChance()
	return br.game.GetCritChance()
end

function misc:getFallDistance()
	local zDist
	local zCoord = nil
	local _, _, position = br.functions.unit:GetObjectPosition("player")

	if position == nil then return 0 end
	if zCoord == nil then
		zCoord = position
	end
	if not br.game.IsFalling() or br.game.IsFlying() then
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
	if br.game.IsFalling() and br.functions.misc:getFallDistance() < 0 then
		if br.fallStarted == 0 then
			br.fallStarted = br.game.GetTime()
		end
		if br.fallStarted ~= 0 then
			br.fallTime = (math.floor((br.game.GetTime() - br.fallStarted) * 1000) / 1000)
		end
	end
	if not br.game.IsFalling() then
		br.fallStarted = 0
		br.fallTime = 0
	end
	return br.fallTime
end

-- Members in the player's group or raid (0 when alone)
function misc:getGroupSize()
	return br.game.GetNumGroupMembers()
end

-- Home latency (to the realm server) in seconds, unclamped.
function misc:getHomeLatency()
	return (select(3, br.game.GetNetStats()) or 0) / 1000
end

-- The kind of instance the player is in ("none", "party", "raid", "pvp", "arena", "scenario")
function misc:getInstanceType()
	return select(2, br.game.IsInInstance())
end

-- getLatency()
function misc:getLatency()
	-- local lag = ((select(3,GetNetStats()) + select(4,GetNetStats())) / 1000)
	local lag = select(4, br.game.GetNetStats()) / 1000
	if lag < .05 then
		lag = .05
	elseif lag > .4 then
		lag = .4
	end
	return lag
end

-- Seconds the player has been moving (0 while standing still).
-- if br.functions.misc:getMovingTime() > 2 then
function misc:getMovingTime()
	local now = br.game.GetTime()
	if movingTimer == nil or br.game.GetUnitSpeed("player") == 0 then movingTimer = now end
	return now - movingTimer
end

-- The player's ranged weapon speed in seconds, with haste (Rapid Fire, quiver) applied; 0 without one
function misc:getRangedAttackSpeed()
	local _, _, speed = br.game.UnitRangedDamage("player")
	return speed or 0
end

-- How long to wait for the server to answer something BR sent: a round trip plus a margin.
-- @param latency home latency in seconds; read from the client when not given
function misc:getRoundTripHold(latency)
	latency = latency or misc:getHomeLatency()
	return math.max(0.20, latency * 2 + 0.10)
end

-- The index of the player's form on the stance bar (0 = none)
function misc:getShapeshiftForm()
	return br.game.GetShapeshiftForm()
end

function misc:getShapeshiftFormCount()
	return br.game.GetNumShapeshiftForms()
end

-- The stance bar form at that index: icon, active, castable, spellID
function misc:getShapeshiftFormInfo(formIndex)
	return br.game.GetShapeshiftFormInfo(formIndex)
end

-- The player's spell haste in percent
function misc:getSpellHaste()
	return br.game.UnitSpellHaste("player")
end

-- Seconds the player has been standing still (0 while moving).
-- if br.functions.misc:getStandingTime() > 2 then
function misc:getStandingTime()
	local now = br.game.GetTime()
	if standingTimer == nil or br.game.GetUnitSpeed("player") > 0 then standingTimer = now end
	return now - standingTimer
end

function misc:isDualWielding()
	return br.game.IsDualWielding()
end

function misc:isFalling()
	return br.game.IsFalling()
end

function misc:isFlying()
	return br.game.IsFlying()
end

-- if isInCombat("target") then
function misc:isInCombat(Unit)
	if br.game.UnitAffectingCombat(Unit) or br.functions.misc:isChecked("Ignore Combat") then
		return true
	else
		return false
	end
end

-- True inside an active Mythic+ key run (C_ChallengeMode, Retail)
function misc:isInMythicPlus()
	local challenge = br.game.C_ChallengeMode
	return challenge ~= nil and challenge.GetActiveChallengeMapID() ~= nil
end

function misc:isInProvingGround()
	local currentMapID = br.game.C_Map.GetBestMapForUnit("player")
	return currentMapID == 480
end

-- if isLooting() then
function misc:isLooting()
	return br.game.GetNumLootItems() > 0
end

function misc:isMounted()
	return br.game.IsMounted()
end

-- if not isMoving("target") then
function misc:isMoving(Unit)
	if Unit == nil then
		return false
	end
	return br.game.GetUnitSpeed(Unit) > 0
end

br.lifecycle:onTick(85, "dungeon queues", function() misc:AcceptQueues() end)

function misc:isOutdoors()
	return br.game.IsOutdoors()
end

function misc:isResting()
	return br.game.IsResting()
end

function misc:isSwimming()
	return br.game.IsSwimming()
end
