local _, br = ...
br.functions.aura = br.functions.aura or {}
local aura = br.functions.aura

function aura:AuraData(unit, index, filter)
	local auraData = br._G.C_UnitAuras.GetAuraDataByIndex(unit, index, filter)
	if not auraData then return nil end
	return AuraUtil.UnpackAuraData(auraData)
end

-- Overwrite UnitBuff
function aura:UnitBuff(unit, index, filter)
	return aura:AuraData(unit, index, filter)
end

-- Overwrite UnitDebuff
function aura:UnitDebuff(unit, index, filter)
	return aura:AuraData(unit, index, filter)
end

function aura:CancelUnitBuffID(unit, spellID, filter)
	-- local spellName = GetSpellInfo(spellID)
	for i = 1, 40 do
		local _, _, _, _, _, _, _, _, _, buffSpellID = aura:UnitBuff(unit, i)
		if buffSpellID ~= nil then
			if buffSpellID == spellID then
				br._G.CancelUnitBuff(unit, i, filter)
				return true
			end
		else
			return false
		end
	end
end

function aura:UnitAuraID(unit, spellID, filter)
	local buff = aura:UnitBuffID(unit, spellID, filter)
	local debuff = aura:UnitDebuffID(unit, spellID, filter)
	if buff then
		return buff
	elseif debuff then
		return debuff
	else
		return nil
	end
end

function aura:UnitBuffID(unit, spellID, filter)
	local spellName = br._G.GetSpellInfo(spellID)
	local exactSearch = filter ~= nil and br._G.strfind(br._G.strupper(filter), "EXACT")
 	if unit == "player" then
	    local auraInfo = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
	    if auraInfo and auraInfo.expirationTime > br._G.GetTime() then return auraInfo end
	end
	if exactSearch then
		for i = 1, 40 do
			local buffName, _, _, _, _, _, _, _, _, buffSpellID = aura:UnitBuff(unit, i, "player")
			-- print("Unit: " .. tostring(unit) .. ", Spell: " .. tostring(spellName) .. ", ID: " .. tostring(spellID) .. ", Buff: " .. tostring(buffName) .. ", BuffID: " .. tostring(buffSpellID))
			if buffName == nil then return nil end
			if buffSpellID == spellID then
				return aura:UnitBuff(unit, i)
			end
		end
	else
		if filter ~= nil and br._G.strfind(br._G.strupper(filter), "PLAYER") then
			-- br._G.print("Unit: " .. tostring(unit) .. ", Spell: " .. tostring(spellName) .. ", ID: " .. tostring(spellID))
			return br._G.AuraUtil.FindAuraByName(spellName, unit, "HELPFUL|PLAYER")
		end
		return br._G.AuraUtil.FindAuraByName(spellName, unit, "HELPFUL")
	end
end

-- function aura:UnitDebuffID(unit, spellID, filter)
-- 	local thisUnit = br._G["ObjectPointer"](unit)
-- 	local spellName = br._G.GetSpellInfo(spellID)
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
function aura:UnitDebuffID(unit, spellID, filter)
    -- guard invalid input quickly
    if not unit or not spellID then return nil end

    -- prevent re-entrancy / infinite recursion that can cause "script ran too long"
    if _UnitDebuffID_lock then return nil end
    _UnitDebuffID_lock = true

    local ok, r1, r2, r3, r4, r5 = pcall(function()
        local thisUnit = br._G["ObjectPointer"](unit)
        local spellName = br._G.GetSpellInfo(spellID)
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
            local auraInfo = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
            if auraInfo and auraInfo.expirationTime > br._G.GetTime() then return auraInfo end
        end
        local exactSearch = filter ~= nil and br._G.strfind(br._G.strupper(filter), "EXACT")
        if exactSearch then
            for i = 1, 40 do
                local auraInfo = C_UnitAuras.GetDebuffDataByIndex(unit, i, "PLAYER")
                if auraInfo and auraInfo.spellId == spellID then
                    return auraInfo
                end
            end
        else
            if filter ~= nil and br._G.strfind(br._G.strupper(filter), "PLAYER") then
                for i = 1, 40 do
                    local auraInfo = C_UnitAuras.GetDebuffDataByIndex(unit, i, "HARMFUL|PLAYER")
                    if auraInfo and auraInfo.name == spellName then return auraInfo end
                end
            end
            for i = 1, 40 do
                local auraInfo = C_UnitAuras.GetDebuffDataByIndex(unit, i, "HARMFUL")
                if auraInfo and auraInfo.name == spellName then return auraInfo end
            end
        end
        return nil
    end)

    -- release lock and return results (if pcall failed, return nil)
    _UnitDebuffID_lock = false
    if not ok then return nil end
    return r1, r2, r3, r4, r5
end

local function Dispel(unit, stacks, buffDuration, buffRemain, buffSpellID, buff)
	if not buff then
		if buffSpellID == 288388 then
			if stacks >= br.functions.misc:getOptionValue("Reaping") or not br._G.UnitAffectingCombat("player") then
				return true
			else
				return false
			end
		elseif buffSpellID == 282566 then
			if stacks >= br.functions.misc:getOptionValue("Promise of Power") then
				return true
			else
				return false
			end
		elseif buffSpellID == 303657 and br.functions.misc:isChecked("Arcane Burst")
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
		if spellID == 4987 then typesList = { "Poison", "Disease", "Magic" } end
		-- Cleanse Toxins (Ret, Prot)
		if spellID == 213644 then typesList = { "Poison", "Disease" } end
	end
	if ClassNum == 3 then --Hunter
		if spellID == 19801 then typesList = { "Magic", "" } end                     --tranq shot
	end
	if ClassNum == 4 then --Rogue
		if spellID == 31224 then typesList = { "Poison", "Curse", "Disease", "Magic" } end -- Cloak of Shadows
		if spellID == 5938 then typesList = { "" } end                               --shiv
	end
	if ClassNum == 5 then --Priest
		-- Purify
		if spellID == 527 then typesList = { "Disease", "Magic" } end
		-- Mass Dispell
		if spellID == 32375 then typesList = { "Magic" } end
		-- Dispel Magic
		if spellID == 528 then typesList = { "Magic" } end
	end
	if ClassNum == 6 then --Death Knight
		typesList = {}
	end
	if ClassNum == 7 then --Shaman
		-- Cleanse Spirit
		if spellID == 51886 then typesList = { "Curse" } end
		-- Purify Spirit
		if spellID == 77130 then typesList = { "Curse", "Magic" } end
		-- Purge
		if spellID == 370 then typesList = { "Magic" } end
	end
	if ClassNum == 8 then --Mage
		-- Remove Curse
		if spellID == 475 then typesList = { "Curse" } end
	end
	if ClassNum == 9 then --Warlock
		if spellID == 19505 then typesList = { "Magic" } end
	end
	if ClassNum == 10 then --Monk
		-- Detox (MW)
		--if GetSpecialization() == 2 then
		if spellID == 115450 then typesList = { "Poison", "Disease" } end --, "Magic" } end
		-- Detox (WW or BM)
		--else
		if spellID == 218164 then typesList = { "Poison", "Disease" } end
		--end
		-- Diffuse Magic
		-- if spellID == 122783 then typesList = { "Magic" } end
	end
	if ClassNum == 11 then --Druid
		-- Remove Corruption
		if spellID == 2782 then typesList = { "Poison", "Curse" } end
		-- Nature's Cure
		if spellID == 88423 then typesList = { "Poison", "Curse", "Magic" } end
		-- Symbiosis: Cleanse
		if spellID == 122288 then typesList = { "Poison", "Disease" } end
		-- Soothe
		if spellID == 2908 then
			typesList = { "" }
		end
	end
	if ClassNum == 12 then --Demon Hunter
		-- Consume Magic
		if spellID == 278326 then typesList = { "Magic" } end
	end
	if ClassNum == 13 then -- Evoker
		-- Expunge
		if spellID == 365585 then typesList = { "Poison" } end
		-- Cauterizing Flame
		if spellID == 374251 then typesList = { "Bleed", "Poison", "Curse", "Disease" } end
		-- Naturalize
		if spellID == 360823 then typesList = { "Magic", "Poison" } end
	end
	if br.player.race == "BloodElf" then --Blood Elf
		-- Arcane Torrent
		if spellID == select(7, br._G.GetSpellInfo(69179)) then typesList = { "Magic" } end
	end
	if br.functions.item:hasItem(177278) and spellID == 177278 then typesList = { "Disease", "Poison", "Curse", } end -- Phail of Serenity
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
			while br._G.C_UnitAuras.GetDebuffDataByIndex(Unit, i) do
				local debuffInfo = br._G.C_UnitAuras.GetDebuffDataByIndex(Unit, i)
				local debuffRemain = debuffInfo.expirationTime - br._G.GetTime()
				if (debuffInfo.dispelName and ValidType(debuffInfo.dispelName)) then
					local delay = br.functions.misc:getValue("Dispel delay") - 0.3 + math.random() * 0.6
					if debuffInfo.spellId == 284663 and (br.GetHP(Unit) < br.functions.misc:getOptionValue("Bwonsamdi's Wrath HP")
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
						break
					elseif dispelUnitObj == true then
						HasValidDispel = true
						break
					end
				end
				i = i + 1
			end
		else
			while br._G.C_UnitAuras.GetBuffDataByIndex(Unit, i) do
				local buffInfo = br._G.C_UnitAuras.GetBuffDataByIndex(Unit, i)
				local buffRemain = buffInfo.expirationTime - br._G.GetTime()
				if (buffInfo.dispelName and ValidType(buffInfo.dispelName)) and not br._G.UnitIsPlayer(Unit) then
					local dispelUnitObj = Dispel(Unit, buffInfo.applications, buffInfo.duration, buffRemain, buffInfo.spellId, true)
					if dispelUnitObj == nil and not br.functions.misc:isChecked("Purge Only Whitelist") then
						if (buffInfo.duration - buffRemain) > (br.functions.misc:getValue("Dispel delay") - 0.3 + math.random() * 0.6) then
							HasValidDispel = true
							break
						end
					elseif dispelUnitObj == true then
						HasValidDispel = true
						break
					end
				end
				i = i + 1
			end
		end
	end
	return HasValidDispel
end

function aura:getAuraDuration(Unit, AuraID, Source)
	local auraInfo,_,_,_,duration = aura:UnitAuraID(Unit, AuraID, Source)
	if not auraInfo then return 0 end
	if auraInfo.duration then
		return auraInfo.duration * 1
	else
		return duration * 1 or 0
	end
end

function aura:getAuraRemain(Unit, AuraID, Source)
	local auraInfo,_,_,_,_,expires = aura:UnitAuraID(Unit, AuraID, Source)
	if not auraInfo then return 0 end
	if auraInfo.expirationTime then
		return auraInfo.expirationTime - br._G.GetTime()
	else
		return (expires - br._G.GetTime()) or 0
	end
end

function aura:getAuraStacks(Unit, AuraID, Source)
	local auraInfo,_,stacks = aura:UnitAuraID(Unit, AuraID, Source)
	if not auraInfo then return 0 end
	if auraInfo.applications then
		return auraInfo.applications
	else
		return stacks or 0
	end
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

-- if getDisease(30,true,min) < 2 then
function aura:getDisease(range, aoe, mod)
	if mod == nil then
		mod = "min"
	end
	if range == nil then
		range = 5
	end
	if aoe == nil then
		aoe = false
	end
	range = tonumber(range)
	mod = tostring(mod)
	local dynTar = br.engines.enemiesEngineFunctions:dynamicTarget(range, true)
	local dynTarAoE = br.engines.enemiesEngineFunctions:dynamicTarget(range, false)
	local dist = br.functions.range:getDistance("player", dynTar)
	local distAoE = br.functions.range:getDistance("player", dynTarAoE)
	local ff = aura:getDebuffRemain(dynTar, 55095, "player") or 0
	local ffAoE = aura:getDebuffRemain(dynTarAoE, 55095, "player") or 0
	local bp = aura:getDebuffRemain(dynTar, 55078, "player") or 0
	local bpAoE = aura:getDebuffRemain(dynTarAoE, 55078, "player") or 0
	local np = aura:getDebuffRemain(dynTar, 155159, "player") or 0
	local npAoE = aura:getDebuffRemain(dynTarAoE, 155159, "player") or 0
	local diseases = { ff, bp }
	local diseasesAoE = { ffAoE, bpAoE }
	local minD = 99
	local maxD = 0
	if mod == "min" then
		if aoe == false then
			if dist < range then
				if br.functions.misc:getTalent(7, 1) then
					return np
				else
					for i = 1, #diseases do
						if diseases[i] > 0 and diseases[i] < minD then
							minD = diseases[i]
						end
					end
					return minD
				end
			else
				return 99
			end
		elseif aoe == true then
			if distAoE < range then
				if br.functions.misc:getTalent(7, 1) then
					return npAoE
				else
					for i = 1, #diseasesAoE do
						if diseases[i] > 0 and diseases[i] < minD then
							minD = diseases[i]
						end
					end
					return minD
				end
			else
				return 99
			end
		end
	elseif mod == "max" then
		if aoe == false then
			if dist < range then
				if br.functions.misc:getTalent(7, 1) then
					return np
				else
					for i = 1, #diseases do
						if diseases[i] > 0 and diseases[i] > maxD then
							maxD = diseases[i]
						end
					end
					return maxD
				end
			else
				return 0
			end
		elseif aoe == true then
			if distAoE < range then
				if br.functions.misc:getTalent(7, 1) then
					return npAoE
				else
					for i = 1, #diseasesAoE do
						if diseases[i] > 0 and diseases[i] < maxD then
							maxD = diseases[i]
						end
					end
					return maxD
				end
			else
				return 0
			end
		end
	end
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

function aura:hasBloodLustRemain()
	if aura:UnitBuffID("player", 90355) then
		return aura:getBuffRemain("player", 90355)
	elseif aura:UnitBuffID("player", 2825) then
		return aura:getBuffRemain("player", 2825)
	elseif aura:UnitBuffID("player", 146555) then
		return aura:getBuffRemain("player", 146555)
	elseif aura:UnitBuffID("player", 390386) then
		return aura:getBuffRemain("player", 390386)
	elseif aura:UnitBuffID("player", 32182) then
		return aura:getBuffRemain("player", 32182)
	elseif aura:UnitBuffID("player", 80353) then
		return aura:getBuffRemain("player", 80353)
	else
		return 0
	end
end
