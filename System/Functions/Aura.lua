local _, br = ...
br.functions.aura = br.functions.aura or {}
local aura = br.functions.aura

-- Aura lookups are remembered for the rest of the frame (auras can't change within one), so the
-- exists / remain / duration / stack / refresh questions about the same aura share one scan.
-- Keyed by the unit itself, except tokens that can point at another unit later in the frame
-- (target, focus, mouseover, ...target after a retarget), which are keyed by their GUID.
local lookups, lookupsAt = {}, nil
local NOT_FOUND = {}
local function lookupKey(kind, unit, spellID, filter)
	if unit == nil then return nil end
	if type(unit) == "string" and (unit:find("target", 1, true) or unit == "focus" or unit == "mouseover") then
		unit = br._G.UnitGUID(unit)
		if not unit then return nil end
	end
	local now = br._G.GetTime()
	if lookupsAt ~= now then
		br._G.wipe(lookups)
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

function aura:AuraData(unit, index, filter)
	local auraData = br.api.wow.GetAuraDataByIndex(unit, index, filter)
	if not auraData then return nil end
	if _G.AuraUtil and _G.AuraUtil.UnpackAuraData then
		return _G.AuraUtil.UnpackAuraData(auraData)
	end
	-- If AuraUtil doesn't exist, return the auraData structure
	return auraData
end

-- Overwrite UnitBuff
function aura:UnitBuff(unit, index, filter)
	return aura:AuraData(unit, index, filter)
end

-- Overwrite UnitDebuff
function aura:UnitDebuff(unit, index, filter)
	return aura:AuraData(unit, index, filter)
end

function aura:UnitBuffID(unit, spellID, filter)
	local key = lookupKey("B", unit, spellID, filter)
	local known, found = remembered(key)
	if known then return found end
	return remember(key, aura:findBuff(unit, spellID, filter))
end

function aura:findBuff(unit, spellID, filter)
	local spellName = br.api.wow.GetSpellInfo(spellID)
	if not spellName then return nil end
	local exactSearch = filter ~= nil and br._G.strfind(br._G.strupper(filter), "EXACT")
 	if unit == "player" then
	    local auraInfo = br.api.wow.GetPlayerAuraBySpellID(spellID)
	    if auraInfo and auraInfo.expirationTime > br._G.GetTime() then return auraInfo end
	end
	if exactSearch then
		for i = 1, 40 do
			local auraInfo = br.api.wow.GetBuffDataByIndex(unit, i, "player")
			if not auraInfo then return nil end
			if auraInfo.spellId == spellID then
				return br.api.wow.GetBuffDataByIndex(unit, i)
			end
		end
	else
		if filter ~= nil and br._G.strfind(br._G.strupper(filter), "PLAYER") then
			-- br._G.print("Unit: " .. tostring(unit) .. ", Spell: " .. tostring(spellName) .. ", ID: " .. tostring(spellID))
			return br.api.wow.FindAuraByName(spellName, unit, "HELPFUL|PLAYER")
		end
		return br.api.wow.FindAuraByName(spellName, unit, "HELPFUL")
	end
end

-- function aura:UnitDebuffID(unit, spellID, filter)
-- 	local thisUnit = br._G["ObjectPointer"](unit)
-- 	local spellName = br.api.wow.GetSpellInfo(spellID)
-- 	-- Check Cache
-- 	if br.functions.misc:isChecked("Cache Debuffs") then
-- 		if br.engines.enemiesEngine.enemy[thisUnit] ~= nil then
-- 			if filter == nil then filter = "player" else filter = br._G["ObjectPointer"](filter) end
-- 			if br.engines.enemiesEngine.enemy[thisUnit].debuffs[filter] ~= nil then
-- 				if br.engines.enemiesEngine.enemy[thisUnit].debuffs[filter][spellID] ~= nil then
-- 					return br.engines.enemiesEngine.enemy[thisUnit].debuffs[filter][spellID](spellID, thisUnit)
-- 				else
-- 					return nil
-- 				end
-- 			end
-- 		end
-- 	end

-- 	-- Failsafe if not cached
-- 	if unit == "player" then
-- 		local auraInfo = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
-- 	    if auraInfo and auraInfo.expirationTime > br._G.GetTime() then return auraInfo end
-- 	end
-- 	local exactSearch = filter ~= nil and br._G.strfind(br._G.strupper(filter), "EXACT")
-- 	if exactSearch then
-- 		for i = 1, 40 do
-- 			-- local buffName, _, _, _, _, _, _, _, _, buffSpellID = br._G.UnitDebuff(unit, i, "player")
-- 			local auraInfo = C_UnitAuras.GetDebuffDataByIndex(unit, i, "PLAYER")
-- 			if auraInfo and auraInfo.spellId == spellID then
-- 				return auraInfo --br._G.UnitDebuff(unit, i, "player")
-- 			end
-- 		end
-- 	else
-- 		if filter ~= nil and br._G.strfind(br._G.strupper(filter), "PLAYER") then
-- 			for i = 1, 40 do
-- 				local auraInfo = C_UnitAuras.GetDebuffDataByIndex(unit, i, "HARMFUL|PLAYER")
-- 				if auraInfo and auraInfo.name == spellName then return auraInfo end
-- 			end
-- 			-- return br._G.AuraUtil.FindAuraByName(spellName, unit, "HARMFUL|PLAYER")
-- 		end
-- 		for i = 1, 40 do
-- 			local auraInfo = C_UnitAuras.GetDebuffDataByIndex(unit, i, "HARMFUL")
-- 			if auraInfo and auraInfo.name == spellName then return auraInfo end
-- 		end
-- 		-- return br._G.AuraUtil.FindAuraByName(spellName, unit, "HARMFUL")
-- 	end
-- end
local _UnitDebuffID_lock = false

-- The debuff search behind aura:UnitDebuffID, run under pcall. A module function rather than a
-- closure made on every call. Aura indexes have no gaps, so each scan stops at the first empty slot
-- instead of reading all 40 (a unit without the debuff used to cost 40 reads).
local function findDebuff(unit, spellID, filter)
        local thisUnit = br._G["ObjectPointer"](unit)
        local spellName = br.api.wow.GetSpellInfo(spellID)
        -- Check Cache
        if br.functions.misc:isChecked("Cache Debuffs") then
            if thisUnit and br.engines.enemiesEngine.enemy[thisUnit] ~= nil then
                if filter == nil then filter = "player" else filter = br._G["ObjectPointer"](filter) end
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
            local auraInfo = br.api.wow.GetPlayerAuraBySpellID(spellID)
            if auraInfo and auraInfo.expirationTime > br._G.GetTime() then return auraInfo end
        end
        local exactSearch = filter ~= nil and br._G.strfind(br._G.strupper(filter), "EXACT")
        if exactSearch then
            for i = 1, 40 do
                local auraInfo = br.api.wow.GetDebuffDataByIndex(unit, i, "PLAYER")
                if not auraInfo then return nil end
                if auraInfo.spellId == spellID then
                    return auraInfo
                end
            end
        else
            if filter ~= nil and br._G.strfind(br._G.strupper(filter), "PLAYER") then
                for i = 1, 40 do
                    local auraInfo = br.api.wow.GetDebuffDataByIndex(unit, i, "HARMFUL|PLAYER")
                    if not auraInfo then return nil end
                    if auraInfo.name == spellName then return auraInfo end
                end
                return nil
            end
            for i = 1, 40 do
                local auraInfo = br.api.wow.GetDebuffDataByIndex(unit, i, "HARMFUL")
                if not auraInfo then return nil end
                if auraInfo.name == spellName then return auraInfo end
            end
        end
        return nil
end

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

local function Dispel(unit, stacks, buffDuration, buffRemain, buffSpellID, buff)
	if not buff then
		if buffSpellID == (br.functions.spell:getHighestSpellID("reaping") or 288388) then
			if stacks >= br.functions.misc:getOptionValue("Reaping") or not br._G.UnitAffectingCombat("player") then
				return true
			else
				return false
			end
		elseif buffSpellID == (br.functions.spell:getHighestSpellID("promiseOfPower") or 282566) then
			if stacks >= br.functions.misc:getOptionValue("Promise of Power") then
				return true
			else
				return false
			end
		elseif buffSpellID == (br.functions.spell:getHighestSpellID("arcaneBurst") or 303657) and br.functions.misc:isChecked("Arcane Burst")
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
	local ClassNum = select(3, br._G.UnitClass("player"))
	if ClassNum == 1 then --Warrior
		typesList = {}
	end
	if ClassNum == 2 then --Paladin
		-- Cleanse (Holy)
		if spellID == (br.functions.spell:getHighestSpellID("cleanse") or 4987) then typesList = { "Poison", "Disease", "Magic" } end
		-- Cleanse Toxins (Ret, Prot)
		if spellID == (br.functions.spell:getHighestSpellID("cleanseToxins") or 213644) then typesList = { "Poison", "Disease" } end
	end
	if ClassNum == 3 then --Hunter
		if spellID == (br.functions.spell:getHighestSpellID("tranquilizingShot") or 19801) then typesList = { "Magic", "" } end                     --tranq shot
	end
	if ClassNum == 4 then --Rogue
		if spellID == (br.functions.spell:getHighestSpellID("cloakOfShadows") or 31224) then typesList = { "Poison", "Curse", "Disease", "Magic" } end -- Cloak of Shadows
		if spellID == (br.functions.spell:getHighestSpellID("shiv") or 5938) then typesList = { "" } end                               --shiv
	end
	if ClassNum == 5 then --Priest
		-- Purify
		if spellID == (br.functions.spell:getHighestSpellID("purify") or 527) then typesList = { "Disease", "Magic" } end
		-- Mass Dispell
		if spellID == (br.functions.spell:getHighestSpellID("massDispel") or 32375) then typesList = { "Magic" } end
		-- Dispel Magic
		if spellID == (br.functions.spell:getHighestSpellID("dispelMagic") or 528) then typesList = { "Magic" } end
	end
	if ClassNum == 6 then --Death Knight
		typesList = {}
	end
	if ClassNum == 7 then --Shaman
		-- Cleanse Spirit
		if spellID == (br.functions.spell:getHighestSpellID("cleanseSpirit") or 51886) then typesList = { "Curse" } end
		-- Purify Spirit
		if spellID == (br.functions.spell:getHighestSpellID("purifySpirit") or 77130) then typesList = { "Curse", "Magic" } end
		-- Purge
		if spellID == (br.functions.spell:getHighestSpellID("purge") or 370) then typesList = { "Magic" } end
	end
	if ClassNum == 8 then --Mage
		-- Remove Curse
		if spellID == (br.functions.spell:getHighestSpellID("removeCurse") or 475) then typesList = { "Curse" } end
	end
	if ClassNum == 9 then --Warlock
		if spellID == (br.functions.spell:getHighestSpellID("devourMagic") or 19505) then typesList = { "Magic" } end
	end
	if ClassNum == 10 then --Monk
		-- Detox (MW)
		--if GetSpecialization() == 2 then
		if spellID == (br.functions.spell:getHighestSpellID("detox") or 115450) or spellID == 218164 then typesList = { "Poison", "Disease" } end --, "Magic" } end
		-- Detox (WW or BM) handled above via detox key or fallback 218164
		-- Diffuse Magic
		-- if spellID == 122783 then typesList = { "Magic" } end
	end
	if ClassNum == 11 then --Druid
		-- Abolish Poison
		if spellID == (br.functions.spell:getHighestSpellID("abolishPoison") or 2893) then typesList = { "Poison" } end
		-- Cure Poison
		if spellID == (br.functions.spell:getHighestSpellID("curePoison") or 8946) then typesList = { "Poison" } end
		-- Remove Corruption
		if spellID == (br.functions.spell:getHighestSpellID("removeCorruption") or 2782) then typesList = { "Poison", "Curse" } end
		-- Remove Curse
		if spellID == 2783 then typesList = { "Curse" } end
		-- Nature's Cure
		if spellID == (br.functions.spell:getHighestSpellID("naturesCure") or 88423) then typesList = { "Poison", "Curse", "Magic" } end
		-- Symbiosis: Cleanse
		if spellID == 122288 then typesList = { "Poison", "Disease" } end
		-- Soothe
		if spellID == (br.functions.spell:getHighestSpellID("soothe") or 2908) then
			typesList = { "" }
		end
	end
	if ClassNum == 12 then --Demon Hunter
		-- Consume Magic
		if spellID == (br.functions.spell:getHighestSpellID("consumeMagic") or 278326) then typesList = { "Magic" } end
	end
	if ClassNum == 13 then -- Evoker
		-- Expunge
		if spellID == (br.functions.spell:getHighestSpellID("expunge") or 365585) then typesList = { "Poison" } end
		-- Cauterizing Flame
		if spellID == (br.functions.spell:getHighestSpellID("cauterizingFlame") or 374251) then typesList = { "Bleed", "Poison", "Curse", "Disease" } end
		-- Naturalize
		if spellID == (br.functions.spell:getHighestSpellID("naturalize") or 360823) then typesList = { "Magic", "Poison" } end
	end
	if br.player.race == "BloodElf" then --Blood Elf
		-- Arcane Torrent
		if spellID == select(7, br.api.wow.GetSpellInfo(br.lists.racials and br.lists.racials._bloodElfBase or 69179)) then typesList = { "Magic" } end
	end
	if br.functions.item:hasItem(br.functions.item:getHighestItemID("phialOfSerenity") or 177278) and spellID == (br.functions.item:getHighestItemID("phialOfSerenity") or 177278) then typesList = { "Disease", "Poison", "Curse", } end -- Phail of Serenity
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
	if br._G.UnitInPhase(Unit) then
		if br.functions.unit:GetUnitIsFriend("player", Unit) then
			while br.api.wow.GetDebuffDataByIndex(Unit, i) do
				local debuffInfo = br.api.wow.GetDebuffDataByIndex(Unit, i)
				local debuffRemain = debuffInfo.expirationTime - br._G.GetTime()
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

					if debuffInfo.spellId == (br.functions.spell:getHighestSpellID("bwonsamdiWrath") or 284663) and (br.GetHP(Unit) < br.functions.misc:getOptionValue("Bwonsamdi's Wrath HP")
							or (br._G.UnitGroupRolesAssigned(Unit) == "TANK" and (debuffInfo.duration - debuffRemain) > delay)) then
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
			while br.api.wow.GetBuffDataByIndex(Unit, i) do
				local buffInfo = br.api.wow.GetBuffDataByIndex(Unit, i)
				local buffRemain = buffInfo.expirationTime - br._G.GetTime()
				if (buffInfo.dispelName and ValidType(buffInfo.dispelName)) and not br._G.UnitIsPlayer(Unit) then
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
	if not br.dispelTrackerLastCleanup or (br._G.GetTime() - br.dispelTrackerLastCleanup) > 30 then
		br.dispelTracker = {}
		br.dispelTrackerLastCleanup = br._G.GetTime()
	end

	return HasValidDispel
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

-- if br.functions.aura:getDebuffRemain("target",12345) < 3 then
function aura:getDebuffRemain(Unit, DebuffID, Source)
	local auraInfo,_,_,_,_,expires = aura:UnitDebuffID(Unit, DebuffID, Source)
	if not auraInfo then return 0 end
	if auraInfo.expirationTime then
		return auraInfo.expirationTime - br._G.GetTime()
	else
		return (expires - br._G.GetTime()) or 0
	end
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

function aura:getDebuffMinMax(spell, range, debuffType, returnType, source)
	local thisMin = 99
	local thisMax = 0
	local lowestUnit = "target"
	local maxUnit = "target"
	for k, _ in pairs(br.engines.enemiesEngine.enemy) do
		local thisUnit = br.engines.enemiesEngine.enemy[k].unit
		local distance = br.functions.range:getDistance(thisUnit, source)
		local thisDebuff = br.player.debuff[spell][debuffType](thisUnit)
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

function aura:getDebuffMinMaxButForPetsThisTime(spell, range, debuffType, returnType)
	local thisMin = 99
	local lowestUnit = "target"
	for k, _ in pairs(br.engines.enemiesEngine.enemy) do
		local thisUnit = br.engines.enemiesEngine.enemy[k].unit
		local distance = br.functions.range:getDistance(thisUnit, "pet")
		local thisDebuff = br.player.debuff[spell][debuffType](thisUnit)
		if br.functions.unit:getFacing("player", thisUnit) and distance <= range and thisDebuff >= 0 and thisDebuff < thisMin then
			if returnType == "min" or returnType == nil then
				lowestUnit = thisUnit
				thisMin = thisDebuff
			end
		end
	end
	return lowestUnit
end

-- if getBuffDuration("target",12345) < 3 then
function aura:getBuffDuration(Unit, BuffID, Source)
	local auraInfo,_,_,_,duration = aura:UnitBuffID(Unit, BuffID, Source)
	if not auraInfo then return 0 end
	if auraInfo.duration then
		return auraInfo.duration * 1
	else
		return duration * 1 or 0
	end
end

-- if br.functions.aura:getBuffRemain("target",12345) < 3 then
function aura:getBuffRemain(Unit, BuffID, Source)
	local auraInfo,_,_,_,_,expires = aura:UnitBuffID(Unit, BuffID, Source)
	if not auraInfo then return 0 end
	if auraInfo.expirationTime then
		return auraInfo.expirationTime - br._G.GetTime()
	else
		return (expires - br._G.GetTime()) or 0
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

function aura:getBuffReact(Unit, BuffID, Source)
	local auraInfo, _, _, _, duration, expire = aura:UnitBuffID(Unit, BuffID, Source)
	if not auraInfo then return false end
	if auraInfo.duration then
		duration = auraInfo.duration
		expire = auraInfo.expirationTime
	end
	if duration ~= nil then
		return (br._G.GetTime() - (expire - duration)) > 0.5
	end
	return false
end

-- TODO: update BL list
function aura:getLustID()
	for _, v in pairs(br.lists.spells.Shared.Shared.buffs["bloodLust"]) do
		if aura:UnitBuffID("player", v) then return v end
	end
	return 0
end

function aura:hasBloodLust()
	if aura:UnitBuffID("player", 90355) or -- Ancient Hysteria
		aura:UnitBuffID("player", 2825) or -- Bloodlust
		aura:UnitBuffID("player", 146555) or -- Drums of Rage
		aura:UnitBuffID("player", 390386) or -- Fury of the Aspects
		aura:UnitBuffID("player", 32182) or -- Heroism
		aura:UnitBuffID("player", 90355) or -- Netherwinds
		aura:UnitBuffID("player", 80353) or -- Timewarp
		aura:UnitBuffID("player", 230935) or -- Drums of the Mountain
		aura:UnitBuffID("player", 256740) or -- Drums of the Maelstrom
		aura:UnitBuffID("player", 441076) or -- Timeless Drums
		aura:UnitBuffID("player", 264667) -- Primal Rage
	then
		return true
	else
		return false
	end
end

-- Snapshot strength of a bleed/DoT (Feral) used by debuff.calc; 0 when not applicable.
-- local value = br.functions.aura:getSnapshotValue(br.player.spells.debuffs.rip)
function aura:getSnapshotValue(dot)
	-- Feral Bleeds
	if br.loader.selectedSpecID == 103 then
		local multiplier = 1.00

		-- Each buff only fires if it exists in the current expansion's spell list.
		-- Spells absent from the list leave br.player.buff[name] nil, so the nil-guard
		-- prevents both errors and false positives without any expansion flag checks.
		if br.player.buff.tigersFury               and br.player.buff.tigersFury.exists()               then multiplier = multiplier * 1.15 end
		if br.player.buff.dreamOfCenarius          and br.player.buff.dreamOfCenarius.exists()          then multiplier = multiplier * 1.30 end
		if br.player.buff.bloodtalons              and br.player.buff.bloodtalons.exists()              then multiplier = multiplier * 1.30 end
		if br.player.buff.savageRoar               and br.player.buff.savageRoar.exists()               then multiplier = multiplier * 1.45 end

		-- Get Attack Power for actual damage calculations
		local base, posBuff, negBuff = br._G.UnitAttackPower("player")
		local ap = base + posBuff + negBuff

		-- * Rip: 768% AP over 16 seconds (8 ticks, one every 2 seconds)
		if dot == br.player.spells.debuffs.rip then
			return ((7.68 * ap) / 8) * multiplier
		end
		-- * Rake: 155% AP over 15 seconds (9 ticks, one every 3 seconds)
		if dot == br.player.spells.debuffs.rake then
			local rakeMultiplier = 1.0
			-- Incarnation/Prowl/Shadowmeld bonus — only present on expansions that have them
			if (br.player.buff.incarnationAvatarOfAshamane and br.player.buff.incarnationAvatarOfAshamane.exists())
				or (br.player.buff.prowl        and br.player.buff.prowl.exists())
				or (br.player.buff.shadowmeld   and br.player.buff.shadowmeld.exists())
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

-- Base tick interval (seconds) for DoTs used by debuff.ticksGainedOnRefresh.
local baseTickTimes = {
	rake = 3,
	rip = 2,
	moonfire = 2,
	moonfireFeral = 2,
	thrashCat = 3,
}
-- local tick = br.functions.aura:getBaseTickTime("rake")
function aura:getBaseTickTime(key)
	return baseTickTimes[key] or 3
end

-- Bleed snapshot upkeep for Feral (103) and Assassination (259), run each tick. The combat
-- log reader records snapshots in debuff.X.bleed / debuff.X.exsa; this drops dead units and
-- zeroes snapshots for bleeds that are no longer applied.
-- br.functions.aura:cleanBleedSnapshots(br.player.debuff, br.loader.selectedSpecID)
local bleedSnapshotKeys = { rake = true, rip = true, rupture = true, garrote = true, crimsonTempest = true }
local exsanguinateKeys = { crimsonTempest = true, garrote = true, rupture = true }
function aura:cleanBleedSnapshots(debuff, spec)
	if debuff == nil or (spec ~= 103 and spec ~= 259) then return end
	for k in pairs(bleedSnapshotKeys) do
		local thisDebuff = debuff[k]
		if thisDebuff then
			if thisDebuff.bleed == nil then thisDebuff.bleed = {} end
			for thisUnit in pairs(thisDebuff.bleed) do
				if br.functions.unit:GetUnitIsDeadOrGhost(thisUnit) then
					thisDebuff.bleed[thisUnit] = nil
				elseif not thisDebuff.exists(thisUnit, "EXACT") then
					thisDebuff.bleed[thisUnit] = 0
				end
			end
		end
	end
	if spec ~= 259 then return end
	for k in pairs(exsanguinateKeys) do
		local thisDebuff = debuff[k]
		if thisDebuff then
			if thisDebuff.exsa == nil then thisDebuff.exsa = {} end
			for thisUnit in pairs(thisDebuff.exsa) do
				if br.functions.unit:GetUnitIsDeadOrGhost(thisUnit) then
					thisDebuff.exsa[thisUnit] = nil
				elseif not thisDebuff.exists(thisUnit) then
					thisDebuff.exsa[thisUnit] = false
				end
			end
		end
	end
end
