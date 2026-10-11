local _, br = ...
-- The player's own state: latency, movement and standing time, falling, looting, combat.
br.functions.misc = br.functions.misc or {}
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

-- Home latency (to the realm server) in seconds, unclamped.
function misc:getHomeLatency()
	return (select(3, br._G.GetNetStats()) or 0) / 1000
end

-- How long to wait for the server to answer something BR sent: a round trip plus a margin.
-- @param latency home latency in seconds; read from the client when not given
function misc:getRoundTripHold(latency)
	latency = latency or misc:getHomeLatency()
	return math.max(0.20, latency * 2 + 0.10)
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

-- if isInCombat("target") then
function misc:isInCombat(Unit)
	if br._G.UnitAffectingCombat(Unit) or br.functions.misc:isChecked("Ignore Combat") then
		return true
	else
		return false
	end
end

function misc:isInProvingGround()
	local currentMapID = br._G.C_Map.GetBestMapForUnit("player")
	return currentMapID == 480
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

-- Seconds the player has been moving (0 while standing still).
-- if br.functions.misc:getMovingTime() > 2 then
local movingTimer

function misc:getMovingTime()
	local now = br._G.GetTime()
	if movingTimer == nil or br._G.GetUnitSpeed("player") == 0 then movingTimer = now end
	return now - movingTimer
end

-- Seconds the player has been standing still (0 while moving).
-- if br.functions.misc:getStandingTime() > 2 then
local standingTimer

function misc:getStandingTime()
	local now = br._G.GetTime()
	if standingTimer == nil or br._G.GetUnitSpeed("player") > 0 then standingTimer = now end
	return now - standingTimer
end
