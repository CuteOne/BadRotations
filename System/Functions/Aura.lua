function CancelUnitBuffID(unit, spellID, filter)
	-- local spellName = GetSpellInfo(spellID)
	for i = 1, 40 do
		local _, _, _, _, _, _, buffCaster, _, _, buffSpellID = UnitBuff(unit, i)
		if buffSpellID ~= nil then
			if buffSpellID == spellID then
				CancelUnitBuff(unit, i)
				return true
			end
		else
			return false
		end
	end
end
function UnitAuraID(unit, spellID, filter)
	return UnitBuffID(unit, spellID, filter)
	-- local spellName = GetSpellInfo(spellID)
	-- if UnitAura(unit,spellName) ~= nil then
	-- 	return UnitAura(unit,spellName)
	-- elseif UnitAura(unit,spellName,nil,"PLAYER HARMFUL") ~= nil then
	-- 	return UnitAura(unit,spellName,nil,"PLAYER HARMFUL")
	-- else
	-- 	return nil
	-- end
end
function UnitBuffID(unit, spellID, filter)
	local spellName = GetSpellInfo(spellID)
	local exactSearch = filter ~= nil and strfind(strupper(filter), "EXACT")
	if exactSearch then
		for i = 1, 40 do
			local buffName, _, _, _, _, _, buffCaster, _, _, buffSpellID = UnitBuff(unit, i)
			if buffName == nil then	return nil end
			if buffSpellID == spellID then
				return UnitBuff(unit, i)
			end
		end
	else
		if filter ~= nil then return AuraUtil.FindAuraByName(spellName, unit, filter) end
		return AuraUtil.FindAuraByName(spellName, unit)
	end
end

function UnitDebuffID(unit, spellID, filter)
	local spellName = GetSpellInfo(spellID)
	local exactSearch = filter ~= nil and strfind(strupper(filter), "EXACT")
	if exactSearch then
		for i = 1, 40 do
			local buffName, _, _, _, _, _, buffCaster, _, _, buffSpellID = UnitDebuff(unit, i)
			if buffName == nil then	return nil end
			if buffSpellID == spellID then
				return UnitDebuff(unit, i)
			end
		end
	else
		if filter ~= nil and strfind(strupper(filter), "PLAYER") then return AuraUtil.FindAuraByName(spellName, unit, "HARMFUL|PLAYER")	end
		return AuraUtil.FindAuraByName(spellName, unit, "HARMFUL")
	end
end
-- 	local spellName = GetSpellInfo(spellID)
--  	local exactSearch = filter ~= nil and strfind(strupper(filter),"EXACT")
--  	local playerSearch = filter ~= nil and strfind(strupper(filter),"PLAYER")
-- 	for i=1,40 do
-- 		local buffName,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitDebuff(unit,i)
-- 		if buffSpellID == nil then return nil end
-- 		if (exactSearch and buffSpellID == spellID) or (not exactSearch and (buffName == spellName or buffSpellID == spellID)) then
-- 			if (not playerSearch) or (playerSearch and (buffCaster == "player")) then
-- 				if exactSearch or filter == nil then return UnitDebuff(unit,i) else return UnitDebuff(unit,i,filter) end
-- 			end
-- 		end
-- 	end
-- end

-- if canDispel("target",SpellID) == true then
function canDispel(Unit, spellID)
	-- first, check DoNotDispell list
	for i = 1, #novaEngineTables.DoNotDispellList do
		if novaEngineTables.DoNotDispellList[i].id == spellID then
			return false
		end
	end
	local typesList = {}
	local HasValidDispel = false
	local ClassNum = select(3, UnitClass("player"))
	if ClassNum == 1 then --Warrior
		typesList = {}
	end
	if ClassNum == 2 then --Paladin
		-- Cleanse (Holy)
		if spellID == 4987 then typesList = {"Poison", "Disease", "Magic"} end
		-- Cleanse Toxins (Ret, Prot)
		if spellID == 213644 then typesList = {"Poison", "Disease"}	end
	end
	if ClassNum == 3 then --Hunter
		if spellID == 264265 then typesList = {"Magic", ""}	end --spiritShock
		if spellID == 264028 then typesList = {"Magic", ""}	end --chiJiTranq
		if spellID == 264266 then typesList = {"Magic", ""}	end --naturesGrace
		if spellID == 264264 then typesList = {"Magic", ""}	end --netherShock
		if spellID == 264263 then typesList = {"Magic", ""}	end --sonicBlast
		if spellID == 254262 then typesList = {"Magic", ""}	end --soothingWater
		if spellID == 254056 then typesList = {"Magic", ""}	end --sporeCloud
	end
	if ClassNum == 4 then --Rogue
		-- Cloak of Shadows
		if spellID == 31224 then typesList = {"Poison", "Curse", "Disease", "Magic"} end
	end
	if ClassNum == 5 then --Priest
		-- Purify
		if spellID == 527 then typesList = {"Disease", "Magic"}	end
		-- Mass Dispell
		if spellID == 32375 then typesList = {"Magic"} end
		-- Dispel Magic
		if spellID == 528 then typesList = {"Magic"} end
	end
	if ClassNum == 6 then --Death Knight
		typesList = {}
	end
	if ClassNum == 7 then --Shaman
		-- Cleanse Spirit
		if spellID == 51886 then typesList = {"Curse"} end
		-- Purify Spirit
		if spellID == 77130 then typesList = {"Curse", "Magic"} end
		-- Purge
		if spellID == 370 then typesList = {"Magic"} end
	end
	if ClassNum == 8 then --Mage
		typesList = {}
	end
	if ClassNum == 9 then --Warlock
		typesList = {}
	end
	if ClassNum == 10 then --Monk
		-- Detox (MW)
		--if GetSpecialization() == 2 then
		if spellID == 115450 then typesList = {"Poison", "Disease", "Magic"} end
		-- Detox (WW or BM)
		--else
		if spellID == 218164 then typesList = {"Poison", "Disease"}	end
	--end
	-- Diffuse Magic
	-- if spellID == 122783 then typesList = { "Magic" } end
	end
	if ClassNum == 11 then --Druid
		-- Remove Corruption
		if spellID == 2782 then	typesList = {"Poison", "Curse"}	end
		-- Nature's Cure
		if spellID == 88423 then typesList = {"Poison", "Curse", "Magic"} end
		-- Symbiosis: Cleanse
		if spellID == 122288 then typesList = {"Poison", "Disease"}	end
		-- Soothe
		if spellID == 2908 then	typesList = {""}
		end
	end
	if ClassNum == 12 then --Demon Hunter
		-- Consume Magic
		if spellID == 278326 then typesList = {"Magic"}	end
	end
	-- local function Enraged()
	-- 	local enrageBuff = select(5,UnitAura(Unit))=="" or false
	-- 	if typesList == nil then
	-- 		return false
	-- 	else
	-- 		for i = 1,#typesList do
	-- 			if typesList[i]=="Enrage" and enrageBuff then
	-- 				return true
	-- 			else
	-- 				return false
	-- 			end
	-- 		end
	-- 	end
	-- end
	if br.player.race == "BloodElf" then --Blood Elf
		-- Arcane Torrent
		if spellID == select(7, GetSpellInfo(GetSpellInfo(69179))) then	typesList = {"Magic"} end
	end
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
	local ValidDebuffType = false
	local i = 1
	if UnitInPhase(Unit) then
		if GetUnitIsFriend("player", Unit) then
			while UnitDebuff(Unit, i) do
				local _, _, _, debuffType, debuffDuration, debuffExpire, _, _, _, debuffid = UnitDebuff(Unit, i)
				local debuffRemain = debuffExpire - GetTime()
				-- local _,_,_,_,debuffType,_,_,_,_,_,debuffid = UnitDebuff(Unit,i)
				-- Blackout Debuffs
				if (debuffType and ValidType(debuffType)) and debuffid ~= 138733 then --Ionization from Jin'rokh the Breaker
					for i = 1, #br.friend do
						local thisUnit = br.friend[i].unit
						if Unit == thisUnit then
							if br.friend[i].dispel ~= nil then
								dispelUnitObj = br.friend[i].dispel
							end
						end
					end
					if (dispelUnitObj == nil) then
						if (isChecked("Dispel delay") and (debuffDuration - debuffRemain) > (getValue("Dispel delay") - 0.3 + math.random() * 0.6)) or not isChecked("Dispel delay") then
							HasValidDispel = true
							break
						end
					elseif dispelUnitObj == true then
						HasValidDispel = true
						dispelUnitObj = nil
						break
					end
				end
				i = i + 1
			end
		else
			while UnitBuff(Unit, i) do
				local _, _, _, buffType, buffDuration, buffExpire, _, _, _, buffid = UnitBuff(Unit, i)
				local buffRemain = buffExpire - GetTime()
				-- local _,_,_,_,buffType,_,_,_,_,_,buffid = UnitBuff(Unit,i)
				-- Blackout Debuffs
				if (buffType and ValidType(buffType)) and buffid ~= 138733 then --Ionization from Jin'rokh the Breaker
					if (isChecked("Dispel delay") and (buffDuration - buffRemain) > (getValue("Dispel delay") - 0.3 + math.random() * 0.6)) or not isChecked("Dispel delay") then
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
function getAuraDuration(Unit, AuraID, Source)
	local duration = select(5, UnitAuraID(Unit, AuraID, Source))
	if duration ~= nil then
		duration = duration * 1
		return duration
	end
	--if UnitAuraID(Unit,AuraID,Source) ~= nil then
	--	return select(5,UnitAuraID(Unit,AuraID,Source))*1
	--end
	return 0
end
function getAuraRemain(Unit, AuraID, Source)
	local remain = select(6, UnitAuraID(Unit, AuraID, Source))
	if remain ~= nil then
		remain = remain - GetTime()
		return remain
	end
	-- if UnitAuraID(Unit,AuraID,Source) ~= nil then
	-- 	return (select(6,UnitAuraID(Unit,AuraID,Source)) - GetTime())
	-- end
	return 0
end
function getAuraStacks(Unit, AuraID, Source)
	local stacks = select(3, UnitAuraID(Unit, AuraID, Source))
	if stacks ~= nil then return stacks end
	-- if UnitAuraID(Unit,AuraID,Source) ~= nil then
	-- 	return select(3,UnitAuraID(Unit,AuraID,Source))
	-- end
	return 0
end

-- if getDebuffDuration("target",12345) < 3 then
function getDebuffDuration(Unit, DebuffID, Source)
	local duration = select(5, UnitDebuffID(Unit, DebuffID, Source))
	if duration ~= nil then
		duration = duration * 1
		return duration
	end
	-- if UnitDebuffID(Unit,DebuffID,Source) ~= nil then
	-- 	return select(5,UnitDebuffID(Unit,DebuffID,Source))*1
	-- end
	return 0
end
-- if getDebuffRemain("target",12345) < 3 then
function getDebuffRemain(Unit, DebuffID, Source)
	local remain = select(6, UnitDebuffID(Unit, DebuffID, Source))
	if remain ~= nil then
		remain = remain - GetTime()
		return remain
	end
	-- if UnitDebuffID(Unit,DebuffID,Source) ~= nil then
	-- 	return (select(6,UnitDebuffID(Unit,DebuffID,Source)) - GetTime())
	-- end
	return 0
end
-- if getDebuffStacks("target",138756) > 0 then
function getDebuffStacks(Unit, DebuffID, Source)
	local stacks = select(3, UnitDebuffID(Unit, DebuffID, Source))
	if stacks ~= nil then
		return stacks
	end
	return 0
	-- if UnitDebuffID(Unit,DebuffID,Source) then
	-- 	return (select(3,UnitDebuffID(Unit,DebuffID,Source)))
	-- else
	-- 	return 0
	-- end
end
function getDebuffCount(spellID)
	local counter = 0
	for k, v in pairs(br.enemy) do
		local thisUnit = br.enemy[k].unit
		-- check if unit is valid
		if GetObjectExists(thisUnit) then
			-- increase counter for each occurences
			if UnitDebuffID(thisUnit, spellID, "player") then
				counter = counter + 1
			end
		end
	end
	return tonumber(counter)
end
function getDebuffRemainCount(spellID, remain)
	local counter = 0
	for k, v in pairs(br.enemy) do
		local thisUnit = br.enemy[k].unit
		-- check if unit is valid
		if GetObjectExists(thisUnit) then
			-- increase counter for each occurences
			if UnitDebuffID(thisUnit, spellID, "player") and getDebuffRemain(thisUnit, spellID, "player") >= remain then
				counter = counter + 1
			end
		end
	end
	return tonumber(counter)
end
function getDebuffMinMax(spell, range, debuffType, returnType)
	local thisMin = 99
	local thisMax = 0
	local lowestUnit = "target"
	local maxUnit = "target"
	for k, v in pairs(br.enemy) do
		local thisUnit = br.enemy[k].unit
		local distance = getDistance(thisUnit)
		local thisDebuff = br.player.debuff[spell][debuffType](thisUnit)
		if getFacing("player",thisUnit) and distance < range and thisDebuff >= 0 
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
-- if getBuffDuration("target",12345) < 3 then
function getBuffDuration(Unit, BuffID, Source)
	local duration = select(5, UnitBuffID(Unit, BuffID, Source))
	if duration ~= nil then
		duration = duration * 1
		return duration
	end
	-- if UnitBuffID(Unit,BuffID,Source) ~= nil then
	-- 	return select(5,UnitBuffID(Unit,BuffID,Source))*1
	-- end
	return 0
end
-- if getBuffRemain("target",12345) < 3 then
function getBuffRemain(Unit, BuffID, Source)
	local remain = select(6, UnitBuffID(Unit, BuffID, Source))
	if remain ~= nil then
		remain = remain - GetTime()
		return remain
	end
	-- if UnitBuffID(Unit,BuffID,Source) ~= nil then
	-- 	return (select(6,UnitBuffID(Unit,BuffID,Source)) - GetTime())
	-- end
	return 0
end
-- if getBuffStacks(138756) > 0 then
function getBuffStacks(Unit, BuffID, Source)
	local stacks = select(3, UnitBuffID(Unit, BuffID, Source))
	if stacks ~= nil then
		return stacks
	end
	return 0
	-- if UnitBuffID(unit,BuffID,Source) then
	-- 	return (select(3,UnitBuffID(unit,BuffID,Source)))
	-- else
	-- 	return 0
	-- end
end
function getBuffCount(spellID)
	local counter = 0
	for k, v in pairs(br.friend) do
		local thisUnit = br.friend[k].unit
		-- check if unit is valid
		if GetObjectExists(thisUnit) then
			-- increase counter for each occurences
			if UnitBuffID(thisUnit, spellID, "player") then
				counter = counter + 1
			end
		end
	end
	return tonumber(counter)
end
-- if getDisease(30,true,min) < 2 then
function getDisease(range, aoe, mod)
	if mod == nil then
		mod = "min"
	end
	if range == nil then
		range = 5
	end
	if aoe == nil then
		aoe = false
	end
	local range = tonumber(range)
	local mod = tostring(mod)
	local dynTar = dynamicTarget(range, true)
	local dynTarAoE = dynamicTarget(range, false)
	local dist = getDistance("player", dynTar)
	local distAoE = getDistance("player", dynTarAoE)
	local ff = getDebuffRemain(dynTar, 55095, "player") or 0
	local ffAoE = getDebuffRemain(dynTarAoE, 55095, "player") or 0
	local bp = getDebuffRemain(dynTar, 55078, "player") or 0
	local bpAoE = getDebuffRemain(dynTarAoE, 55078, "player") or 0
	local np = getDebuffRemain(dynTar, 155159, "player") or 0
	local npAoE = getDebuffRemain(dynTarAoE, 155159, "player") or 0
	local diseases = {ff, bp}
	local diseasesAoE = {ffAoE, bpAoE}
	local minD = 99
	local maxD = 0
	if mod == "min" then
		if aoe == false then
			if dist < range then
				if getTalent(7, 1) then
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
				if getTalent(7, 1) then
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
				if getTalent(7, 1) then
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
				if getTalent(7, 1) then
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
function hasBloodLust()
	if UnitBuffID("player", 90355) or -- Ancient Hysteria
		UnitBuffID("player", 2825) or -- Bloodlust
		UnitBuffID("player", 146555) or -- Drums of Rage
		UnitBuffID("player", 32182) or -- Heroism
		UnitBuffID("player", 90355) or -- Netherwinds
        UnitBuffID("player", 80353) or -- Timewarp
        UnitBuffID("player", 230935) or -- Drums of the Mountain
        UnitBuffID("player", 256740) or -- Drums of the Maelstrom
		UnitBuffID("player", 264667) -- Primal Rage
	 then
		return true
	else
		return false
	end
end
function hasBloodLustRemain()
	if UnitBuffID("player", 90355) then
		return getBuffRemain("player", 90355)
	elseif UnitBuffID("player", 2825) then
		return getBuffRemain("player", 2825)
	elseif UnitBuffID("player", 146555) then
		return getBuffRemain("player", 146555)
	elseif UnitBuffID("player", 32182) then
		return getBuffRemain("player", 32182)
	elseif UnitBuffID("player", 90355) then
		return getBuffRemain("player", 90355)
	elseif UnitBuffID("player", 80353) then
		return getBuffRemain("player", 80353)
	else
		return 0
	end
end
--- if isBuffed()
function isBuffed(UnitID, SpellID, TimeLeft, Filter)
	if not TimeLeft then
		TimeLeft = 0
	end
	if type(SpellID) == "number" then
		SpellID = {SpellID}
	end
	for i = 1, #SpellID do
		local spell, rank = GetSpellInfo(SpellID[i])
		if spell then
			local buff = select(6, UnitBuff(UnitID, spell, rank, Filter))
			if buff and (buff == 0 or buff - GetTime() > TimeLeft) then
				return true
			end
		end
	end
end
-- if isDeBuffed("target",{123,456,789},2,"player") then
function isDeBuffed(UnitID, DebuffID, TimeLeft, Filter)
	if not TimeLeft then
		TimeLeft = 0
	end
	if type(DebuffID) == "number" then
		DebuffID = {DebuffID}
	end
	for i = 1, #DebuffID do
		local spell, rank = GetSpellInfo(DebuffID[i])
		if spell then
			local debuff = select(6, UnitDebuff(UnitID, spell, rank, Filter))
			if debuff and (debuff == 0 or debuff - GetTime() > TimeLeft) then
				return true
			end
		end
	end
end
