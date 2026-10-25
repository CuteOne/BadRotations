local _, br = ...
-- Line of sight between units and to world points, with a short cache.
---@class br.functions.misc
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc
-- Cached player -> unit line of sight, keyed by GUID so unit tokens and object
-- pointers share entries. TraceLine is costly; cast checks hit the same few units
-- every tick. A stale "visible" costs one rejected cast, which the cast module's
-- rejection memory then catches.
local losCache = {}

local LOS_CACHE_TTL = 0.25

local LOS_CACHE_PRUNE_INTERVAL = 10

local losCacheNextPrune = 0

-- if br.functions.misc:canSee("target") then
function misc:canSee(Unit)
	if Unit == nil then return false end
	if br.functions.unit:GetUnitIsUnit(Unit, "player") then return true end
	local guid = br.game.UnitGUID(Unit)
	if guid == nil then return misc:getLineOfSight("player", Unit) end
	local now = br.game.GetTime()
	-- Drop expired entries now and then so the cache doesn't grow across a session.
	if now >= losCacheNextPrune then
		losCacheNextPrune = now + LOS_CACHE_PRUNE_INTERVAL
		for k, v in pairs(losCache) do
			if now >= v.expires then losCache[k] = nil end
		end
	end
	local entry = losCache[guid]
	if entry and now < entry.expires then return entry.los end
	local los = misc:getLineOfSight("player", Unit)
	if entry then
		entry.los, entry.expires = los, now + LOS_CACHE_TTL
	else
		losCache[guid] = { los = los, expires = now + LOS_CACHE_TTL }
	end
	return los
end

-- Line of sight from the player to a world point, for ground-targeted spells. Traces
-- at the same height above both ends as getLineOfSight, as if a unit stood there.
-- if br.functions.misc:canSeePosition(x, y, z) then
function misc:canSeePosition(X2, Y2, Z2)
	if X2 == nil or Y2 == nil or Z2 == nil then return false end
	local X1, Y1, Z1 = br.functions.unit:GetObjectPosition("player")
	if X1 == nil then return false end
	return br.game.TraceLine(X1, Y1, Z1 + 2.25, X2, Y2, Z2 + 2.25, bit.bor(0x10, 0x100)) == nil
end

-- True when Unit1 can see Unit2 (one unit: the player and it). NPCs in br.lists.los are always seen.
-- if br.functions.misc:getLineOfSight("target") then
function misc:getLineOfSight(Unit1, Unit2)
	if Unit2 == nil then
		Unit2 = Unit1
		if Unit2 == "player" then
			Unit1 = "target"
		else
			Unit1 = "player"
		end
	end

	-- First check: units must be visible
	if not (br.functions.unit:GetObjectExists(Unit1) and br.functions.unit:GetUnitIsVisible(Unit1) and
	        br.functions.unit:GetObjectExists(Unit2) and br.functions.unit:GetUnitIsVisible(Unit2)) then
		return false
	end

	local skipLoSTable = br.lists.los
	if skipLoSTable[br.functions.unit:GetObjectID(Unit1)] or skipLoSTable[br.functions.unit:GetObjectID(Unit2)] then
		return true
	end

	local X1, Y1, Z1 = br.functions.unit:GetObjectPosition(Unit1)
	local X2, Y2, Z2 = br.functions.unit:GetObjectPosition(Unit2)
	if X1 == nil or X2 == nil then return false end
	-- TraceLine returns a hit position when something blocks the line
	local trace = br.game.TraceLine(X1, Y1, Z1 + 2.25, X2, Y2, Z2 + 2.25, bit.bor(0x10, 0x100))
	return trace == nil or trace == false
end
