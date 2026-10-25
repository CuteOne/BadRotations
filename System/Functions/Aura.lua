local _, br = ...
---@class br.functions.aura
br.functions.aura = br.functions.aura or {}
local aura = br.functions.aura
-- Aura lookups are remembered for the rest of the frame (auras can't change within one), so the
-- exists / remain / duration / stack / refresh questions about the same aura share one scan.
-- Keyed by the unit itself, except tokens that can point at another unit later in the frame
-- (target, focus, mouseover, ...target after a retarget), which are keyed by their GUID.
local lookups, lookupsAt = {}, nil

local NOT_FOUND = {}

-- True for aura data that hasn't run out; expirationTime 0 is an aura that doesn't expire (forms).
local function isActive(auraInfo)
	return auraInfo ~= nil and (auraInfo.expirationTime == 0 or auraInfo.expirationTime > br.game.GetTime())
end

local function lookupKey(kind, unit, spellID, filter)
	if unit == nil then return nil end
	if type(unit) == "string" and (unit:find("target", 1, true) or unit == "focus" or unit == "mouseover") then
		unit = br.game.UnitGUID(unit)
		if not unit then return nil end
	end
	local now = br.game.GetTime()
	-- A new table each frame, and a new one when this context can't read it: once a lookup holding a
	-- secret value is stored, Forever marks the table secret, and tainted code (a slash command, a UI
	-- click) reading it raises "attempted to iterate a table that cannot be accessed while tainted"
	if lookupsAt ~= now or (br.game.canaccesstable and not br.game.canaccesstable(lookups)) then
		lookups = {}
		lookupsAt = now
	end
	return kind .. tostring(unit) .. ":" .. tostring(spellID) .. ":" .. tostring(filter)
end

local function remembered(key)
	local found = key and lookups[key]
	if found == NOT_FOUND then return true, nil end
	return found ~= nil, found
end

local function remember(key, found)
	if key then lookups[key] = found == nil and NOT_FOUND or found end
	return found
end

-- 	-- Failsafe if not cached
-- 	if unit == "player" then
-- 		local auraInfo = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
-- 	    if auraInfo and auraInfo.expirationTime > br.game.GetTime() then return auraInfo end
-- 	end
-- 	local exactSearch = filter ~= nil and br.game.strfind(br.game.strupper(filter), "EXACT")
-- 	if exactSearch then
-- 		for i = 1, 40 do
-- 			-- local buffName, _, _, _, _, _, _, _, _, buffSpellID = br.game.UnitDebuff(unit, i, "player")
-- 			local auraInfo = C_UnitAuras.GetDebuffDataByIndex(unit, i, "PLAYER")
-- 			if auraInfo and auraInfo.spellId == spellID then
-- 				return auraInfo --br.game.UnitDebuff(unit, i, "player")
-- 			end
-- 		end
-- 	else
-- 		if filter ~= nil and br.game.strfind(br.game.strupper(filter), "PLAYER") then
-- 			for i = 1, 40 do
-- 				local auraInfo = C_UnitAuras.GetDebuffDataByIndex(unit, i, "HARMFUL|PLAYER")
-- 				if auraInfo and auraInfo.name == spellName then return auraInfo end
-- 			end
-- 			-- return br.game.AuraUtil.FindAuraByName(spellName, unit, "HARMFUL|PLAYER")
-- 		end
-- 		for i = 1, 40 do
-- 			local auraInfo = C_UnitAuras.GetDebuffDataByIndex(unit, i, "HARMFUL")
-- 			if auraInfo and auraInfo.name == spellName then return auraInfo end
-- 		end
-- 		-- return br.game.AuraUtil.FindAuraByName(spellName, unit, "HARMFUL")
-- 	end
-- end
local _UnitDebuffID_lock = false

local function findDebuff(unit, spellID, filter)
        spellID = br.functions.spell:currentRank(spellID) -- a rank list: the rank in use
        local thisUnit = br.game["ObjectPointer"](unit)
        local spellName = br.functions.spell:getName(spellID)
        -- Check Cache
        if br.functions.misc:isChecked("Cache Debuffs") then
            if thisUnit and br.engines.enemiesEngine.enemy[thisUnit] ~= nil then
                if filter == nil then filter = "player" else filter = br.game["ObjectPointer"](filter) end
                if br.engines.enemiesEngine.enemy[thisUnit].debuffs[filter] ~= nil then
                    if br.engines.enemiesEngine.enemy[thisUnit].debuffs[filter][spellID] ~= nil then
                        return br.engines.enemiesEngine.enemy[thisUnit].debuffs[filter][spellID](spellID, thisUnit)
                    else
                        return nil
                    end
                end
            end
        end

        -- Failsafe if not cached
        if unit == "player" then
            local auraInfo = br.game.C_UnitAuras.GetPlayerAuraBySpellID(spellID)
            if isActive(auraInfo) then return auraInfo end
        end
        local exactSearch = filter ~= nil and br.game.strfind(br.game.strupper(filter), "EXACT")
        if exactSearch then
            for i = 1, 40 do
                local auraInfo = br.game.C_UnitAuras.GetDebuffDataByIndex(unit, i, "PLAYER")
                if not auraInfo then return nil end
                if auraInfo.spellId == spellID then
                    return auraInfo
                end
            end
        else
            if filter ~= nil and br.game.strfind(br.game.strupper(filter), "PLAYER") then
                for i = 1, 40 do
                    local auraInfo = br.game.C_UnitAuras.GetDebuffDataByIndex(unit, i, "HARMFUL|PLAYER")
                    if not auraInfo then return nil end
                    if auraInfo.name == spellName then return auraInfo end
                end
                return nil
            end
            for i = 1, 40 do
                local auraInfo = br.game.C_UnitAuras.GetDebuffDataByIndex(unit, i, "HARMFUL")
                if not auraInfo then return nil end
                if auraInfo.name == spellName then return auraInfo end
            end
        end
        return nil
end

local function Dispel(unit, stacks, buffDuration, buffRemain, buffSpellID, buff)
	if not buff then
		if buffSpellID == (br.functions.spell:getHighestSpellID("reaping")) then
			if stacks >= br.functions.misc:getOptionValue("Reaping") or not br.game.UnitAffectingCombat("player") then
				return true
			else
				return false
			end
		elseif buffSpellID == (br.functions.spell:getHighestSpellID("promiseOfPower")) then
			if stacks >= br.functions.misc:getOptionValue("Promise of Power") then
				return true
			else
				return false
			end
		elseif buffSpellID == (br.functions.spell:getHighestSpellID("arcaneBurst")) and br.functions.misc:isChecked("Arcane Burst")
			and buffDuration - buffRemain > (br.functions.misc:getValue("Dispel delay") - 0.3 + math.random() * 0.6)
		then
			return true
		elseif br.engines.healingEngineCollections.DispelID[buffSpellID] ~= nil then
			if (stacks >= br.engines.healingEngineCollections.DispelID[buffSpellID].stacks or br.functions.misc:isChecked("Ignore Stack Count"))
			then
				if br.engines.healingEngineCollections.DispelID[buffSpellID].stacks ~= 0
					and br.engines.healingEngineCollections.DispelID[buffSpellID].range == nil
				then
					return true
				else
					if buffDuration - buffRemain > (br.functions.misc:getValue("Dispel delay") - 0.3 + math.random() * 0.6) then -- Dispel Delay then
						if br.engines.healingEngineCollections.DispelID[buffSpellID].range ~= nil then
							if not br.functions.misc:isChecked("Ignore Range Check")
								and #br.engines.healingEngineFunctions:getAllies(unit, br.engines.healingEngineCollections.DispelID[buffSpellID].range) > 1
							then
								return false
							end
							return true
						end
						return true
					end
					return false
				end
			end
			return false
		end
		return nil
	elseif buff then
		if br.engines.healingEngineCollections.PurgeID[buffSpellID] ~= nil then
			if (buffDuration - buffRemain) > (br.functions.misc:getValue("Dispel delay") - 0.3 + math.random() * 0.6) then
				return true
			end
			return false
		end
		return nil
	end
end

-- Base tick interval (seconds) for DoTs used by debuff.ticksGainedOnRefresh.
local baseTickTimes = {
	rake = 3,
	rip = 2,
	moonfire = 2,
	moonfireFeral = 2,
	thrashCat = 3,
}

-- Bleed snapshot upkeep for Feral (103) and Assassination (259), run each tick. The combat
-- log reader records snapshots in combatLog.bleed / combatLog.exsa; this drops dead units and
-- zeroes snapshots for bleeds that are no longer applied.
-- br.functions.aura:cleanBleedSnapshots(br.loader.selectedSpecID)
local bleedSnapshotKeys = { rake = true, rip = true, rupture = true, garrote = true, crimsonTempest = true }

local exsanguinateKeys = { crimsonTempest = true, garrote = true, rupture = true }

-- One pass over a unit's buffs or debuffs for an aura with this name (aura:findByName)
local function scanByName(name, unit, filter, isHarmful)
	local read = isHarmful and br.game.C_UnitAuras.GetDebuffDataByIndex or br.game.C_UnitAuras.GetBuffDataByIndex
	for i = 1, 40 do
		local auraInfo = read(unit, i, filter)
		if not auraInfo then return nil end
		if auraInfo.name == name then return auraInfo end
	end
end

-- Cancels the player's buff (by spell ID)
function aura:cancelBuff(spellID)
	br.game.RunMacroText("/cancelaura " .. br.functions.spell:getName(spellID))
end

-- if br.functions.aura:canDispel("target",SpellID) == true then
function aura:canDispel(Unit, spellID)
	-- Initialize dispel tracking table if it doesn't exist
	if not br.dispelTracker then
		br.dispelTracker = {}
	end

	-- first, check DoNotDispell list
	for i = 1, #br.engines.healingEngineCollections.DoNotDispellList do
		if br.engines.healingEngineCollections.DoNotDispellList[i].id == spellID then
			return false
		end
	end
	local typesList = {}
	local HasValidDispel = false
	-- What the spell removes (br.lists.dispelTypes), found by matching it to the player's own spells
	local abilities = br.player and br.player.spells and br.player.spells.abilities or {}
	local function isSpell(key)
		local v = abilities[key]
		if type(v) == "table" then
			for i = 1, #v do if v[i] == spellID then return true end end
			return false
		end
		return v ~= nil and v == spellID
	end
	local _, playerClass = br.game.UnitClass("player")
	for key, types in pairs(br.lists.dispelTypes[playerClass] or {}) do
		if isSpell(key) then
			typesList = types
			break
		end
	end
	-- Arcane Torrent (Blood Elf)
	if br.functions.unit:getRace("player") == "BloodElf" and (isSpell("arcaneTorrent")
		or spellID == br.functions.spell:getSpellID(br.lists.racials and br.lists.racials._bloodElfBase))
	then
		typesList = { "Magic" }
	end
	-- Phial of Serenity
	local phial = br.functions.item:getHighestItemID("phialOfSerenity")
	if phial and spellID == phial and br.functions.item:hasItem(phial) then typesList = { "Disease", "Poison", "Curse" } end
	local function ValidType(debuffType)
		local typeCheck = false
		if typesList == nil then
			typeCheck = false
		else
			for i = 1, #typesList do
				if typesList[i] == debuffType then
					typeCheck = true
					break
				end
			end
		end
		return typeCheck
	end
	local i = 1
	if br.game.UnitPhaseReason(Unit) == nil then -- in the player's phase
		if br.functions.unit:GetUnitIsFriend("player", Unit) then
			while br.game.C_UnitAuras.GetDebuffDataByIndex(Unit, i) do
				local debuffInfo = br.game.C_UnitAuras.GetDebuffDataByIndex(Unit, i)
				local debuffRemain = debuffInfo.expirationTime - br.game.GetTime()
				if (debuffInfo.dispelName and ValidType(debuffInfo.dispelName)) then
					-- Create a unique key for this specific debuff instance
					local trackerKey = Unit .. "_" .. debuffInfo.spellId .. "_" .. debuffInfo.expirationTime

					-- If this is a new debuff, calculate and store a random reaction delay
					if not br.dispelTracker[trackerKey] then
						-- Human-like reaction time: base delay +/- 0.3 seconds
						local baseDelay = br.functions.misc:getValue("Dispel delay")
						local randomDelay = baseDelay - 0.3 + math.random() * 0.6
						br.dispelTracker[trackerKey] = randomDelay
					end

					local delay = br.dispelTracker[trackerKey]

					if debuffInfo.spellId == (br.functions.spell:getHighestSpellID("bwonsamdiWrath")) and (br.GetHP(Unit) < br.functions.misc:getOptionValue("Bwonsamdi's Wrath HP")
							or (br.game.UnitGroupRolesAssigned(Unit) == "TANK" and (debuffInfo.duration - debuffRemain) > delay)) then
						HasValidDispel = true
						break
					end
					local dispelUnitObj
					for j = 1, #br.engines.healingEngine.friend do
						local thisUnit = br.engines.healingEngine.friend[j].unit
						if Unit == thisUnit then
							dispelUnitObj = Dispel(thisUnit, debuffInfo.applications, debuffInfo.duration, debuffRemain, debuffInfo.spellId)
							if dispelUnitObj ~= nil then
								break
							end
						end
					end
					if dispelUnitObj == nil and not br.functions.misc:isChecked("Dispel Only Whitelist")
						and (debuffInfo.duration - debuffRemain) > delay then
						HasValidDispel = true
						-- Clean up the tracker once we've detected it (optional: keeps memory usage down)
						-- br.dispelTracker[trackerKey] = nil
						break
					elseif dispelUnitObj == true then
						HasValidDispel = true
						-- br.dispelTracker[trackerKey] = nil
						break
					end
				end
				i = i + 1
			end
		else
			while br.game.C_UnitAuras.GetBuffDataByIndex(Unit, i) do
				local buffInfo = br.game.C_UnitAuras.GetBuffDataByIndex(Unit, i)
				local buffRemain = buffInfo.expirationTime - br.game.GetTime()
				if (buffInfo.dispelName and ValidType(buffInfo.dispelName)) and not br.game.UnitIsPlayer(Unit) then
					-- Create a unique key for this specific buff instance
					local trackerKey = Unit .. "_" .. buffInfo.spellId .. "_" .. buffInfo.expirationTime

					-- If this is a new buff, calculate and store a random reaction delay
					if not br.dispelTracker[trackerKey] then
						-- Human-like reaction time: base delay +/- 0.3 seconds
						local baseDelay = br.functions.misc:getValue("Dispel delay")
						local randomDelay = baseDelay - 0.3 + math.random() * 0.6
						br.dispelTracker[trackerKey] = randomDelay
					end

					local delay = br.dispelTracker[trackerKey]

					local dispelUnitObj = Dispel(Unit, buffInfo.applications, buffInfo.duration, buffRemain, buffInfo.spellId, true)
					if dispelUnitObj == nil and not br.functions.misc:isChecked("Purge Only Whitelist") then
						if (buffInfo.duration - buffRemain) > delay then
							HasValidDispel = true
							-- br.dispelTracker[trackerKey] = nil
							break
						end
					elseif dispelUnitObj == true then
						HasValidDispel = true
						-- br.dispelTracker[trackerKey] = nil
						break
					end
				end
				i = i + 1
			end
		end
	end

	-- Periodically clean up old tracker entries to prevent memory bloat
	-- Run cleanup every 30 seconds
	if not br.dispelTrackerLastCleanup or (br.game.GetTime() - br.dispelTrackerLastCleanup) > 30 then
		br.dispelTracker = {}
		br.dispelTrackerLastCleanup = br.game.GetTime()
	end

	return HasValidDispel
end

function aura:cleanBleedSnapshots(spec)
	if spec ~= 103 and spec ~= 259 then return end
	local combatLog, ids = br.readers.combatLog, br.player and br.player.spells and br.player.spells.debuffs
	if ids == nil then return end
	for k in pairs(bleedSnapshotKeys) do
		local bleed = combatLog.bleed[k]
		if bleed and ids[k] then
			for thisUnit in pairs(bleed) do
				if br.functions.unit:GetUnitIsDeadOrGhost(thisUnit) then
					bleed[thisUnit] = nil
				elseif aura:UnitDebuffID(thisUnit, ids[k], "EXACT") == nil then
					bleed[thisUnit] = 0
				end
			end
		end
	end
	if spec ~= 259 then return end
	for k in pairs(exsanguinateKeys) do
		local exsa = combatLog.exsa[k]
		if exsa and ids[k] then
			for thisUnit in pairs(exsa) do
				if br.functions.unit:GetUnitIsDeadOrGhost(thisUnit) then
					exsa[thisUnit] = nil
				elseif aura:UnitDebuffID(thisUnit, ids[k], "player") == nil then
					exsa[thisUnit] = false
				end
			end
		end
	end
end

function aura:findBuff(unit, spellID, filter)
	spellID = br.functions.spell:currentRank(spellID) -- a rank list: the rank in use
	local spellName = br.functions.spell:getName(spellID)
	if not spellName then return nil end
	local exactSearch = filter ~= nil and br.game.strfind(br.game.strupper(filter), "EXACT")
 	if unit == "player" then
	    local auraInfo = br.game.C_UnitAuras.GetPlayerAuraBySpellID(spellID)
	    if isActive(auraInfo) then return auraInfo end
	end
	if exactSearch then
		for i = 1, 40 do
			local auraInfo = br.game.C_UnitAuras.GetBuffDataByIndex(unit, i, "player")
			if not auraInfo then return nil end
			if auraInfo.spellId == spellID then
				return br.game.C_UnitAuras.GetBuffDataByIndex(unit, i)
			end
		end
	else
		if filter ~= nil and br.game.strfind(br.game.strupper(filter), "PLAYER") then
			-- br.game.print("Unit: " .. tostring(unit) .. ", Spell: " .. tostring(spellName) .. ", ID: " .. tostring(spellID))
			return aura:findByName(spellName, unit, "HELPFUL|PLAYER")
		end
		return aura:findByName(spellName, unit, "HELPFUL")
	end
end

-- The first aura with this name on the unit, by its filter: HELPFUL / HARMFUL search buffs /
-- debuffs, PLAYER alone searches both for the player's own, no filter searches both.
-- (AuraUtil.FindAuraByName isn't used: it calls GetAuraDataBySpellName, which rejects the object
-- pointers some unlockers hand out as units.)
-- local aura = br.functions.aura:findByName("Rejuvenation", "target", "HELPFUL|PLAYER")
function aura:findByName(spellName, unit, filter)
	if not spellName or not unit then return nil end
	if not filter then
		return scanByName(spellName, unit, nil, false) or scanByName(spellName, unit, nil, true)
	end
	local upFilter = string.upper(filter)
	local hasHelpful = string.find(upFilter, "HELPFUL", 1, true)
	local hasHarmful = string.find(upFilter, "HARMFUL", 1, true)
	if hasHelpful or hasHarmful then
		return (hasHelpful and scanByName(spellName, unit, filter, false))
			or (hasHarmful and scanByName(spellName, unit, filter, true)) or nil
	end
	if string.find(upFilter, "PLAYER", 1, true) then
		return scanByName(spellName, unit, "PLAYER", false) or scanByName(spellName, unit, "PLAYER", true)
	end
	-- A filter without HELPFUL / HARMFUL / PLAYER: only the generic aura list covers it
	for i = 1, 40 do
		local auraInfo = br.game.C_UnitAuras.GetAuraDataByIndex(unit, i, filter)
		if not auraInfo then break end
		if auraInfo.name == spellName then return auraInfo end
	end
	return nil
end

-- function aura:UnitDebuffID(unit, spellID, filter)
-- 	local thisUnit = br.game["ObjectPointer"](unit)
-- 	local spellName = br.functions.spell:getName(spellID)
-- 	-- Check Cache
-- 	if br.functions.misc:isChecked("Cache Debuffs") then
-- 		if br.engines.enemiesEngine.enemy[thisUnit] ~= nil then
-- 			if filter == nil then filter = "player" else filter = br.game["ObjectPointer"](filter) end
-- 			if br.engines.enemiesEngine.enemy[thisUnit].debuffs[filter] ~= nil then
-- 				if br.engines.enemiesEngine.enemy[thisUnit].debuffs[filter][spellID] ~= nil then
-- 					return br.engines.enemiesEngine.enemy[thisUnit].debuffs[filter][spellID](spellID, thisUnit)
-- 				else
-- 					return nil
-- 				end
-- 			end
-- 		end
-- 	end

-- local tick = br.functions.aura:getBaseTickTime("rake")
function aura:getBaseTickTime(key)
	return baseTickTimes[key] or 3
end

function aura:getBuffCount(spellID)
	local counter = 0
	for i = 1, #br.engines.healingEngine.friend do
		local thisUnit = br.engines.healingEngine.friend[i].unit
		-- check if unit is valid
		-- if br.functions.unit:GetObjectExists(thisUnit) then
			-- increase counter for each occurences
			if aura:UnitBuffID(thisUnit, spellID, "player") then
				counter = counter + 1
			end
		-- end
	end
	return tonumber(counter)
end

-- if getBuffDuration("target",12345) < 3 then
function aura:getBuffDuration(Unit, BuffID, Source)
	local auraInfo = aura:UnitBuffID(Unit, BuffID, Source)
	return auraInfo and auraInfo.duration or 0
end

function aura:getBuffReact(Unit, BuffID, Source)
	local auraInfo, _, _, _, duration, expire = aura:UnitBuffID(Unit, BuffID, Source)
	if not auraInfo then return false end
	if auraInfo.duration then
		duration = auraInfo.duration
		expire = auraInfo.expirationTime
	end
	if duration ~= nil then
		return (br.game.GetTime() - (expire - duration)) > 0.5
	end
	return false
end

-- if br.functions.aura:getBuffRemain("target",12345) < 3 then
function aura:getBuffRemain(Unit, BuffID, Source)
	local auraInfo,_,_,_,_,expires = aura:UnitBuffID(Unit, BuffID, Source)
	if not auraInfo then return 0 end
	if auraInfo.expirationTime then
		return auraInfo.expirationTime - br.game.GetTime()
	else
		return (expires - br.game.GetTime()) or 0
	end
end

-- if br.functions.aura:getBuffStacks(138756) > 0 then
function aura:getBuffStacks(Unit, BuffID, Source)
	local auraInfo,_,stacks = aura:UnitBuffID(Unit, BuffID, Source)
	if not auraInfo then return 0 end
	if auraInfo.applications then
		return auraInfo.applications
	else
		return stacks or 0
 	end
end

function aura:getDebuffCount(spellID)
	local counter = 0
	for k, _ in pairs(br.engines.enemiesEngine.enemy) do
		local thisUnit = br.engines.enemiesEngine.enemy[k].unit
		-- check if unit is valid
		-- if br.functions.unit:GetObjectExists(thisUnit) then
			-- increase counter for each occurences
			if aura:UnitDebuffID(thisUnit, spellID, "player") then
				counter = counter + 1
			end
		-- end
	end
	return tonumber(counter)
end

-- if br.functions.aura:getDebuffDuration("target",12345) < 3 then
function aura:getDebuffDuration(Unit, DebuffID, Source)
	local auraInfo,_,_,_,duration = aura:UnitDebuffID(Unit, DebuffID, Source)
	if not auraInfo then return 0 end
	if auraInfo.duration then
		return auraInfo.duration * 1
	else
		return duration * 1 or 0
	end
end

-- The unit within range (and in front) with the lowest ("min") or highest ("max") value read(unit)
function aura:getDebuffMinMax(read, range, returnType, source)
	local thisMin = 99
	local thisMax = 0
	local lowestUnit = "target"
	local maxUnit = "target"
	for k, _ in pairs(br.engines.enemiesEngine.enemy) do
		local thisUnit = br.engines.enemiesEngine.enemy[k].unit
		local distance = br.functions.range:getDistance(thisUnit, source)
		local thisDebuff = read(thisUnit)
		if br.functions.unit:getFacing("player", thisUnit) and distance <= range and thisDebuff >= 0
			and ((returnType == "min" and thisDebuff < thisMin) or (returnType == "max" and thisDebuff > thisMax))
		then
			if returnType == "min" then
				lowestUnit = thisUnit
				thisMin = thisDebuff
			end
			if returnType == "max" then
				maxUnit = thisUnit
				thisMax = thisDebuff
			end
		end
	end
	if returnType == "min" then
		return lowestUnit
	end
	if returnType == "max" then
		return maxUnit
	end
end

function aura:getDebuffMinMaxButForPetsThisTime(read, range, returnType)
	local thisMin = 99
	local lowestUnit = "target"
	for k, _ in pairs(br.engines.enemiesEngine.enemy) do
		local thisUnit = br.engines.enemiesEngine.enemy[k].unit
		local distance = br.functions.range:getDistance(thisUnit, "pet")
		local thisDebuff = read(thisUnit)
		if br.functions.unit:getFacing("player", thisUnit) and distance <= range and thisDebuff >= 0 and thisDebuff < thisMin then
			if returnType == "min" or returnType == nil then
				lowestUnit = thisUnit
				thisMin = thisDebuff
			end
		end
	end
	return lowestUnit
end

-- if br.functions.aura:getDebuffRemain("target",12345) < 3 then
function aura:getDebuffRemain(Unit, DebuffID, Source)
	local auraInfo,_,_,_,_,expires = aura:UnitDebuffID(Unit, DebuffID, Source)
	if not auraInfo then return 0 end
	if auraInfo.expirationTime then
		return auraInfo.expirationTime - br.game.GetTime()
	else
		return (expires - br.game.GetTime()) or 0
	end
end

function aura:getDebuffRemainCount(spellID, remain)
	local counter = 0
	for k, _ in pairs(br.engines.enemiesEngine.enemy) do
		local thisUnit = br.engines.enemiesEngine.enemy[k].unit
		-- check if unit is valid
		-- if br.functions.unit:GetObjectExists(thisUnit) then
			-- increase counter for each occurences
			if aura:UnitDebuffID(thisUnit, spellID, "player") and aura:getDebuffRemain(thisUnit, spellID, "player") >= remain then
				counter = counter + 1
			end
		-- end
	end
	return tonumber(counter)
end

-- if br.functions.aura:getDebuffStacks("target",138756) > 0 then
function aura:getDebuffStacks(Unit, DebuffID, Source)
	local auraInfo,_,stacks = aura:UnitDebuffID(Unit, DebuffID, Source)
	if not auraInfo then return 0 end
	if auraInfo.applications then
		return auraInfo.applications
	else
		return stacks or 0
	end
end

-- TODO: update BL list
function aura:getLustID()
	for _, v in pairs(br.lists.spells.Shared.Shared.buffs["bloodLust"]) do
		if aura:UnitBuffID("player", v) then return v end
	end
	return 0
end

-- Snapshot strength of a bleed/DoT (Feral) used by debuff.calc; 0 when not applicable.
-- local value = br.functions.aura:getSnapshotValue(br.player.spells.debuffs.rip)
function aura:getSnapshotValue(dot)
	-- Feral Bleeds
	if br.loader.selectedSpecID == 103 then
		local multiplier = 1.00

		-- Each buff only counts where the current expansion's spell list has it (aura:isBuffUp)
		if aura:isBuffUp("tigersFury")      then multiplier = multiplier * 1.15 end
		if aura:isBuffUp("dreamOfCenarius") then multiplier = multiplier * 1.30 end
		if aura:isBuffUp("bloodtalons")     then multiplier = multiplier * 1.30 end
		if aura:isBuffUp("savageRoar")      then multiplier = multiplier * 1.45 end

		-- Get Attack Power for actual damage calculations
		local base, posBuff, negBuff = br.game.UnitAttackPower("player")
		local ap = base + posBuff + negBuff

		-- * Rip: 768% AP over 16 seconds (8 ticks, one every 2 seconds)
		if dot == br.player.spells.debuffs.rip then
			return ((7.68 * ap) / 8) * multiplier
		end
		-- * Rake: 155% AP over 15 seconds (9 ticks, one every 3 seconds)
		if dot == br.player.spells.debuffs.rake then
			local rakeMultiplier = 1.0
			-- Incarnation/Prowl/Shadowmeld bonus — only present on expansions that have them
			if aura:isBuffUp("incarnationAvatarOfAshamane") or aura:isBuffUp("prowl") or aura:isBuffUp("shadowmeld")
			then
				rakeMultiplier = 2.0
			end
			return ((0.155 * ap) / 9) * multiplier * rakeMultiplier
		end
	end
	-- Assassination Bleeds
	-- if br.loader.selectedSpecID == 259 then
	--     local multiplier = 1
	--     if br.player.buff.stealth.exists() and br.player.talent.nightstalker and (dot == br.player.spells.debuffs.rupture
	--             or dot == br.player.spells.debuffs.garrote) then
	--         multiplier = 1.5
	--     end
	--     if (br.player.buff.stealth.exists() or br.player.buff.vanish.exists()
	--             or (br.player.buff.subterfuge.exists() and br.player.buff.subterfuge.remain() >= 0.1
	--                 and br.player.buff.subterfuge.remain() >= br.functions.spell:getSpellCD(61304)))
	--         and dot == br.player.spells.debuffs.garrote and br.player.talent.subterfuge
	--     then
	--         multiplier = 1.8
	--     end
	--     return multiplier
	-- end
	return 0
end

-- True while the player has a Bloodlust-style haste buff: any in the global list's buffs.bloodLust.
-- if br.functions.aura:hasBloodLust() then
function aura:hasBloodLust()
	local shared = br.lists.spells and br.lists.spells.Shared and br.lists.spells.Shared.Shared
	local lusts = shared and shared.buffs and shared.buffs.bloodLust
	if lusts == nil then return false end
	for _, buffID in pairs(lusts) do
		if aura:UnitBuffID("player", buffID) then return true end
	end
	return false
end

-- True when the player's buff from the spell list (by key, e.g. "prowl") is up; false when the
-- class's lists have no such buff
-- if br.functions.aura:isBuffUp("clearcasting") then
function aura:isBuffUp(buffKey)
	local buffs = br.player and br.player.spells and br.player.spells.buffs
	local id = buffs and buffs[buffKey]
	return id ~= nil and aura:UnitBuffID("player", id) ~= nil
end

-- Overwrite UnitBuff
function aura:UnitBuffID(unit, spellID, filter)
	local key = lookupKey("B", unit, spellID, filter)
	local known, found = remembered(key)
	if known then return found end
	return remember(key, aura:findBuff(unit, spellID, filter))
end

-- Overwrite UnitDebuff
-- The debuff search behind aura:UnitDebuffID, run under pcall. A module function rather than a
-- closure made on every call. Aura indexes have no gaps, so each scan stops at the first empty slot
-- instead of reading all 40 (a unit without the debuff used to cost 40 reads).
function aura:UnitDebuffID(unit, spellID, filter)
    -- guard invalid input quickly
    if not unit or not spellID then return nil end

    -- prevent re-entrancy / infinite recursion that can cause "script ran too long"
    if _UnitDebuffID_lock then return nil end
    _UnitDebuffID_lock = true

    local key = lookupKey("D", unit, spellID, filter)
    local known, found = remembered(key)
    if known then
        _UnitDebuffID_lock = false
        return found
    end
    local ok, r1 = pcall(findDebuff, unit, spellID, filter)

    -- release lock and return the result (if pcall failed, nil and not remembered)
    _UnitDebuffID_lock = false
    if not ok then return nil end
    return remember(key, r1)
end
