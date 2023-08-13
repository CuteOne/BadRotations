local _, br = ...
function br.CancelUnitBuffID(unit, spellID, filter)
	-- local spellName = GetSpellInfo(spellID)
	for i = 1, 40 do
		local _, _, _, _, _, _, _, _, _, buffSpellID = br._G.UnitBuff(unit, i)
		if buffSpellID ~= nil then
			if buffSpellID == spellID then
				br._G.CancelUnitBuff(unit, i)
				return true
			end
		else
			return false
		end
	end
end
function br.UnitAuraID(unit, spellID, filter)
	local buff = br.UnitBuffID(unit, spellID, filter)
	local debuff = br.UnitDebuffID(unit, spellID, filter)
	if buff then
		return buff
	elseif debuff then
		return debuff
	else
		return nil
	end
end
function br.UnitBuffID(unit, spellID, filter)
	local spellName = br._G.GetSpellInfo(spellID)
	local exactSearch = filter ~= nil and br._G.strfind(br._G.strupper(filter), "EXACT")
	if exactSearch then
		for i = 1, 40 do
			local buffName, _, _, _, _, _, _, _, _, buffSpellID = br._G.UnitBuff(unit, i, "player")
			if buffName == nil then	return nil end
			if buffSpellID == spellID then
				return br._G.UnitBuff(unit, i)
			end
		end
	else
		if filter ~= nil and br._G.strfind(br._G.strupper(filter), "PLAYER") then return br._G.AuraUtil.FindAuraByName(spellName, unit, "HELPFUL|PLAYER") end
		return br._G.AuraUtil.FindAuraByName(spellName, unit, "HELPFUL")
	end
end

function br.UnitDebuffID(unit, spellID, filter)
	local thisUnit = br._G.ObjectPointer(unit)
	local spellName = br._G.GetSpellInfo(spellID)
	-- Check Cache
	if br.isChecked("Cache Debuffs") then
		if br.enemy[thisUnit] ~= nil then
			if filter == nil then filter = "player" else filter = br._G.ObjectPointer(filter) end
			if br.enemy[thisUnit].debuffs[filter] ~= nil then
				if br.enemy[thisUnit].debuffs[filter][spellID] ~= nil then
					return br.enemy[thisUnit].debuffs[filter][spellID](spellID,thisUnit)
				else
					return nil
				end
			end
		end
	end

	-- Failsafe if not cached
	local exactSearch = filter ~= nil and br._G.strfind(br._G.strupper(filter), "EXACT")
	if exactSearch then
		for i = 1, 40 do
			local buffName, _, _, _, _, _, _, _, _, buffSpellID = br._G.UnitDebuff(unit, i, "player")
			if buffName == nil then	return nil end
			if buffSpellID == spellID then
				return br._G.UnitDebuff(unit, i, "player")
			end
		end
	else
		if filter ~= nil and br._G.strfind(br._G.strupper(filter), "PLAYER") then return br._G.AuraUtil.FindAuraByName(spellName, unit, "HARMFUL|PLAYER")	end
		return br._G.AuraUtil.FindAuraByName(spellName, unit, "HARMFUL")
	end
end

local function Dispel(unit,stacks,buffDuration,buffRemain,buffSpellID,buff)
	if not buff then
		if buffSpellID == 288388 then
			if stacks >= br.getOptionValue("Reaping") or not br._G.UnitAffectingCombat("player") then
				return true
			else
				return false
			end
		elseif buffSpellID == 282566 then
			if stacks >= br.getOptionValue("Promise of Power") then
				return true
			else
				return false
			end
		elseif buffSpellID == 303657 and br.isChecked("Arcane Burst") and buffDuration - buffRemain > (br.getValue("Dispel delay") - 0.3 + math.random() * 0.6) then
			return true
		elseif br.novaEngineTables.DispelID[buffSpellID] ~= nil then
			if (stacks >= br.novaEngineTables.DispelID[buffSpellID].stacks or br.isChecked("Ignore Stack Count"))
			then
				if br.novaEngineTables.DispelID[buffSpellID].stacks ~= 0 and br.novaEngineTables.DispelID[buffSpellID].range == nil then
					return true
				else
					if buffDuration - buffRemain > (br.getValue("Dispel delay") - 0.3 + math.random() * 0.6) then -- Dispel Delay then
						if br.novaEngineTables.DispelID[buffSpellID].range ~= nil then
							if not br.isChecked("Ignore Range Check") and #br.getAllies(unit,br.novaEngineTables.DispelID[buffSpellID].range) > 1 then
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
		if br.novaEngineTables.PurgeID[buffSpellID] ~= nil then
			if (buffDuration - buffRemain) > (br.getValue("Dispel delay") - 0.3 + math.random() * 0.6) then
				return true
			end
			return false
		end
		return nil
	end
end

-- if br.canDispel("target",SpellID) == true then
function br.canDispel(Unit, spellID)
	-- first, check DoNotDispell list
	for i = 1, #br.novaEngineTables.DoNotDispellList do
		if br.novaEngineTables.DoNotDispellList[i].id == spellID then
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
		if spellID == 4987 then typesList = {"Poison", "Disease", "Magic"} end
		-- Cleanse Toxins (Ret, Prot)
		if spellID == 213644 then typesList = {"Poison", "Disease"}	end
	end
	if ClassNum == 3 then --Hunter
		if spellID == 19801 then typesList = {"Magic", ""}	end --tranq shot
	end
	if ClassNum == 4 then --Rogue
		if spellID == 31224 then typesList = {"Poison", "Curse", "Disease", "Magic"} end -- Cloak of Shadows
		if spellID == 5938 then	typesList = {""} end --shiv
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
		-- Remove Curse
		if spellID == 475 then typesList = {"Curse"} end
	end
	if ClassNum == 9 then --Warlock
		if spellID == 19505 then typesList = {"Magic"} end
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
	if ClassNum == 13 then -- Evoker
		-- Expunge
		if spellID == 365585 then typesList = {"Poison"} end
		-- Cauterizing Flame
		if spellID == 374251 then typesList = {"Bleed", "Poison", "Curse", "Disease"} end
		-- Naturalize
		if spellID == 360823 then typesList = {"Magic", "Poison"} end
	end
	if br.player.race == "BloodElf" then --Blood Elf
		-- Arcane Torrent
		if spellID == select(7, br._G.GetSpellInfo(69179)) then typesList = {"Magic"} end
	end
	if br.hasItem(177278) and spellID == 177278 then typesList = {"Disease", "Poison", "Curse", } end -- Phail of Serenity
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
	if not br._G.UnitPhaseReason(Unit) then
		if br.GetUnitIsFriend("player", Unit) then
			while br._G.UnitDebuff(Unit, i) do
				local _, _, stacks, debuffType, debuffDuration, debuffExpire, _, _, _, debuffid = br._G.UnitDebuff(Unit, i)
				local debuffRemain = debuffExpire - br._G.GetTime()
				local dispelUnitObj
				if (debuffType and ValidType(debuffType)) then
					if debuffid == 284663 then
						if br.GetHP(Unit) < br.getOptionValue("Bwonsamdi's Wrath HP") then
							HasValidDispel = true
							break
						elseif br._G.UnitGroupRolesAssigned(Unit) == "TANK" and (debuffDuration - debuffRemain) > (br.getValue("Dispel delay") - 0.3 + math.random() * 0.6) then
							HasValidDispel = true
							break
						end
					end
					for j = 1, #br.friend do
						local thisUnit = br.friend[j].unit
						if Unit == thisUnit then
							if Dispel(thisUnit,stacks,debuffDuration,debuffRemain,debuffid) ~= nil then
								dispelUnitObj = Dispel(thisUnit,stacks,debuffDuration,debuffRemain,debuffid)
							end
						end
					end
					if dispelUnitObj == nil and not br.isChecked("Dispel Only Whitelist") then
						if (debuffDuration - debuffRemain) > (br.getValue("Dispel delay") - 0.3 + math.random() * 0.6) then
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
			while br._G.UnitBuff(Unit, i) do
				local _, _, stacks, buffType, buffDuration, buffExpire, _, _, _, buffid = br._G.UnitBuff(Unit, i)
				local buffRemain = buffExpire - br._G.GetTime()
				local dispelUnitObj
				if (buffType and ValidType(buffType)) and not br._G.UnitIsPlayer(Unit) then
					if Dispel(Unit,stacks,buffDuration,buffRemain,buffid,true) ~= nil then
						dispelUnitObj = Dispel(Unit,stacks,buffDuration,buffRemain,buffid,true)
					end
					if dispelUnitObj == nil and not br.isChecked("Purge Only Whitelist") then
						if (buffDuration - buffRemain) > (br.getValue("Dispel delay") - 0.3 + math.random() * 0.6) then
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
		end
	end
	return HasValidDispel
end
function br.getAuraDuration(Unit, AuraID, Source)
	local duration = select(5, br.UnitAuraID(Unit, AuraID, Source))
	if duration ~= nil then
		duration = duration * 1
		return duration
	end
	--if UnitAuraID(Unit,AuraID,Source) ~= nil then
	--	return select(5,UnitAuraID(Unit,AuraID,Source))*1
	--end
	return 0
end
function br.getAuraRemain(Unit, AuraID, Source)
	local remain = select(6, br.UnitAuraID(Unit, AuraID, Source))
	if remain ~= nil then
		remain = remain - br._G.GetTime()
		return remain
	end
	-- if UnitAuraID(Unit,AuraID,Source) ~= nil then
	-- 	return (select(6,UnitAuraID(Unit,AuraID,Source)) - GetTime())
	-- end
	return 0
end
function br.getAuraStacks(Unit, AuraID, Source)
	local stacks = select(3, br.UnitAuraID(Unit, AuraID, Source))
	if stacks ~= nil then return stacks end
	-- if UnitAuraID(Unit,AuraID,Source) ~= nil then
	-- 	return select(3,UnitAuraID(Unit,AuraID,Source))
	-- end
	return 0
end

-- if br.getDebuffDuration("target",12345) < 3 then
function br.getDebuffDuration(Unit, DebuffID, Source)
	local duration = select(5, br.UnitDebuffID(Unit, DebuffID, Source))
	if duration ~= nil then
		duration = duration * 1
		return duration
	end
	-- if br.UnitDebuffID(Unit,DebuffID,Source) ~= nil then
	-- 	return select(5,br.UnitDebuffID(Unit,DebuffID,Source))*1
	-- end
	return 0
end
-- if br.getDebuffRemain("target",12345) < 3 then
function br.getDebuffRemain(Unit, DebuffID, Source)
	local remain = select(6, br.UnitDebuffID(Unit, DebuffID, Source))
	if remain ~= nil then
		remain = remain - br._G.GetTime()
		-- Print(GetSpellInfo(DebuffID)..": "..remain)
		return remain
	end
	-- if br.UnitDebuffID(Unit,DebuffID,Source) ~= nil then
	-- 	return (select(6,br.UnitDebuffID(Unit,DebuffID,Source)) - GetTime())
	-- end
	return 0
end
-- if br.getDebuffStacks("target",138756) > 0 then
function br.getDebuffStacks(Unit, DebuffID, Source)
	local stacks = select(3, br.UnitDebuffID(Unit, DebuffID, Source))
	if stacks ~= nil then
		return stacks
	end
	return 0
	-- if br.UnitDebuffID(Unit,DebuffID,Source) then
	-- 	return (select(3,br.UnitDebuffID(Unit,DebuffID,Source)))
	-- else
	-- 	return 0
	-- end
end
function br.getDebuffCount(spellID)
	local counter = 0
	for k, _ in pairs(br.enemy) do
		local thisUnit = br.enemy[k].unit
		-- check if unit is valid
		if br.GetObjectExists(thisUnit) then
			-- increase counter for each occurences
			if br.UnitDebuffID(thisUnit, spellID, "player") then
				counter = counter + 1
			end
		end
	end
	return tonumber(counter)
end
function br.getDebuffRemainCount(spellID, remain)
	local counter = 0
	for k, _ in pairs(br.enemy) do
		local thisUnit = br.enemy[k].unit
		-- check if unit is valid
		if br.GetObjectExists(thisUnit) then
			-- increase counter for each occurences
			if br.UnitDebuffID(thisUnit, spellID, "player") and br.getDebuffRemain(thisUnit, spellID, "player") >= remain then
				counter = counter + 1
			end
		end
	end
	return tonumber(counter)
end
function br.getDebuffMinMax(spell, range, debuffType, returnType, source)
	local thisMin = 99
	local thisMax = 0
	local lowestUnit = "target"
	local maxUnit = "target"
	for k, _ in pairs(br.enemy) do
		local thisUnit = br.enemy[k].unit
		local distance = br.getDistance(thisUnit,source)
		local thisDebuff = br.player.debuff[spell][debuffType](thisUnit)
		if br.getFacing("player",thisUnit) and distance <= range and thisDebuff >= 0
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
function br.getDebuffMinMaxButForPetsThisTime(spell, range, debuffType, returnType)
	local thisMin = 99
	local lowestUnit = "target"
	for k, _ in pairs(br.enemy) do
		local thisUnit = br.enemy[k].unit
		local distance = br.getDistance(thisUnit,"pet")
		local thisDebuff = br.player.debuff[spell][debuffType](thisUnit)
		if br.getFacing("player",thisUnit) and distance <= range and thisDebuff >= 0 and thisDebuff < thisMin then
			if returnType == "min" or returnType == nil then
				lowestUnit = thisUnit
				thisMin = thisDebuff
			end
		end
	end
	return lowestUnit
end
-- if getBuffDuration("target",12345) < 3 then
function br.getBuffDuration(Unit, BuffID, Source)
	local duration = select(5, br.UnitBuffID(Unit, BuffID, Source))
	if duration ~= nil then
		duration = duration * 1
		return duration
	end
	-- if br.UnitBuffID(Unit,BuffID,Source) ~= nil then
	-- 	return select(5,br.UnitBuffID(Unit,BuffID,Source))*1
	-- end
	return 0
end
-- if br.getBuffRemain("target",12345) < 3 then
function br.getBuffRemain(Unit, BuffID, Source)
	local remain = select(6, br.UnitBuffID(Unit, BuffID, Source))
	if remain ~= nil then
		remain = remain - br._G.GetTime()
		return remain
	end
	-- if br.UnitBuffID(Unit,BuffID,Source) ~= nil then
	-- 	return (select(6,br.UnitBuffID(Unit,BuffID,Source)) - GetTime())
	-- end
	return 0
end
-- if br.getBuffStacks(138756) > 0 then
function br.getBuffStacks(Unit, BuffID, Source)
	local stacks = select(3, br.UnitBuffID(Unit, BuffID, Source))
	if stacks ~= nil then
		return stacks
	end
	return 0
	-- if br.UnitBuffID(unit,BuffID,Source) then
	-- 	return (select(3,br.UnitBuffID(unit,BuffID,Source)))
	-- else
	-- 	return 0
	-- end
end
function br.getBuffCount(spellID)
	local counter = 0
	for i= 1, #br.friend do
		local thisUnit = br.friend[i].unit
		-- check if unit is valid
		if br.GetObjectExists(thisUnit) then
			-- increase counter for each occurences
			if br.UnitBuffID(thisUnit, spellID, "player") then
				counter = counter + 1
			end
		end
	end
	return tonumber(counter)
end
function br.getBuffReact(Unit, BuffID, Source)
	local _, _, _, _, duration, expire = br.UnitBuffID(Unit, BuffID, Source)
	if duration ~= nil then
		return (br._G.GetTime() - (expire - duration)) > 0.5
	end
	return false
end
-- if getDisease(30,true,min) < 2 then
function br.getDisease(range, aoe, mod)
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
	local dynTar = br.dynamicTarget(range, true)
	local dynTarAoE = br.dynamicTarget(range, false)
	local dist = br.getDistance("player", dynTar)
	local distAoE = br.getDistance("player", dynTarAoE)
	local ff = br.getDebuffRemain(dynTar, 55095, "player") or 0
	local ffAoE = br.getDebuffRemain(dynTarAoE, 55095, "player") or 0
	local bp = br.getDebuffRemain(dynTar, 55078, "player") or 0
	local bpAoE = br.getDebuffRemain(dynTarAoE, 55078, "player") or 0
	local np = br.getDebuffRemain(dynTar, 155159, "player") or 0
	local npAoE = br.getDebuffRemain(dynTarAoE, 155159, "player") or 0
	local diseases = {ff, bp}
	local diseasesAoE = {ffAoE, bpAoE}
	local minD = 99
	local maxD = 0
	if mod == "min" then
		if aoe == false then
			if dist < range then
				if br.getTalent(7, 1) then
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
				if br.getTalent(7, 1) then
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
				if br.getTalent(7, 1) then
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
				if br.getTalent(7, 1) then
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
function br.getLustID()
	for _, v in pairs(br.lists.spells.Shared.Shared.buffs["bloodLust"]) do
		if br.UnitBuffID("player", v) then return v end
	end
	return 0
end
function br.hasBloodLust()
	if br.UnitBuffID("player", 90355) or -- Ancient Hysteria
		br.UnitBuffID("player", 2825) or -- Bloodlust
		br.UnitBuffID("player", 146555) or -- Drums of Rage
		br.UnitBuffID("player", 390386) or -- Fury of the Aspects
		br.UnitBuffID("player", 32182) or -- Heroism
		br.UnitBuffID("player", 90355) or -- Netherwinds
		br.UnitBuffID("player", 80353) or -- Timewarp
		br.UnitBuffID("player", 230935) or -- Drums of the Mountain
		br.UnitBuffID("player", 256740) or -- Drums of the Maelstrom
		br.UnitBuffID("player", 264667) -- Primal Rage
	then
		return true
	else
		return false
	end
end
function br.hasBloodLustRemain()
	if br.UnitBuffID("player", 90355) then
		return br.getBuffRemain("player", 90355)
	elseif br.UnitBuffID("player", 2825) then
		return br.getBuffRemain("player", 2825)
	elseif br.UnitBuffID("player", 146555) then
		return br.getBuffRemain("player", 146555)
	elseif br.UnitBuffID("player", 390386) then
		return br.getBuffRemain("player", 390386)
	elseif br.UnitBuffID("player", 32182) then
		return br.getBuffRemain("player", 32182)
	elseif br.UnitBuffID("player", 80353) then
		return br.getBuffRemain("player", 80353)
	else
		return 0
	end
end
--- if isBuffed()
function br.isBuffed(UnitID, SpellID, TimeLeft, Filter)
	if not TimeLeft then
		TimeLeft = 0
	end
	if type(SpellID) == "number" then
		SpellID = {SpellID}
	end
	for i = 1, #SpellID do
		local spell, rank = br._G.GetSpellInfo(SpellID[i])
		if spell then
			local buff = select(6, br._G.UnitBuff(UnitID, spell, rank, Filter))
			if buff and (buff == 0 or buff - br._G.GetTime() > TimeLeft) then
				return true
			end
		end
	end
end
-- if isDeBuffed("target",{123,456,789},2,"player") then
function br.isDeBuffed(UnitID, DebuffID, TimeLeft, Filter)
	if not TimeLeft then
		TimeLeft = 0
	end
	if type(DebuffID) == "number" then
		DebuffID = {DebuffID}
	end
	for i = 1, #DebuffID do
		local spell, rank = br._G.GetSpellInfo(DebuffID[i])
		if spell then
			local debuff = select(6, br._G.UnitDebuff(UnitID, spell, rank, Filter))
			if debuff and (debuff == 0 or debuff - br._G.GetTime() > TimeLeft) then
				return true
			end
		end
	end
end
