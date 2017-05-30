function CancelUnitBuffID(unit,spellID,filter)
	local spellName = GetSpellInfo(spellID)
	for i=1,40 do
		local _,_,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitBuff(unit,i)
		if buffSpellID ~= nil then
			if buffSpellID == spellID then
				CancelUnitBuff(unit,i);
				return true
			end
		else
			return false
		end
	end
end
function UnitAuraID(unit,spellID)
	local spellName = GetSpellInfo(spellID)
	if UnitAura(unit,spellName) ~= nil then
		return UnitAura(unit,spellName)
	elseif UnitAura(unit,spellName,nil,"PLAYER HARMFUL") ~= nil then
		return UnitAura(unit,spellName,nil,"PLAYER HARMFUL")
	else
		return nil
	end
end
function UnitBuffID(unit,spellID,filter)
	local spellName = GetSpellInfo(spellID)
	if filter == nil then
		return UnitBuff(unit,spellName)
	else
		local exactSearch = strfind(strupper(filter),"EXACT")
		local playerSearch = strfind(strupper(filter),"PLAYER")
		if exactSearch then
			for i=1,40 do
				local _,_,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitBuff(unit,i)
				if buffSpellID ~= nil then
					if buffSpellID == spellID then
						if (not playerSearch) or (playerSearch and (buffCaster == "player")) then
							return UnitBuff(unit,i)
						end
					end
				else
					return nil
				end
			end
		else
			return UnitBuff(unit,spellName,nil,filter)
		end
	end
end
-- function UnitBuffID(unit,spellID)
-- 	for i=1,40 do
-- 		local _,_,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitBuff(unit,i)
-- 		if buffSpellID ~= nil then
-- 			if buffSpellID == spellID then
-- 				return true
-- 			end
-- 		end
-- 	end
-- 	return false
-- end

function UnitDebuffID(unit,spellID,filter)
	local spellName = GetSpellInfo(spellID)
	if filter == nil then
		return UnitDebuff(unit,spellName)
	else
		local exactSearch = strfind(strupper(filter),"EXACT")
		local playerSearch = strfind(strupper(filter),"PLAYER")
		if exactSearch then
			for i=1,40 do
				local _,_,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitDebuff(unit,i)
				if buffSpellID ~= nil then
					if buffSpellID == spellID then
						if (not playerSearch) or (playerSearch and (buffCaster == "player")) then
							return UnitDebuff(unit,i)
						end
					end
				else
					return nil
				end
			end
		else
			return UnitDebuff(unit,spellName,nil,filter)
		end
	end
end

-- if canDispel("target",SpellID) == true then
function canDispel(Unit,spellID)
	local HasValidDispel = false
	local ClassNum = select(3,UnitClass("player"))
	if ClassNum == 1 then --Warrior
		typesList = { }
	end
	if ClassNum == 2 then --Paladin
		-- Cleanse Toxin
		if spellID == 213644 then typesList = { "Poison","Disease" } end
	end
	if ClassNum == 3 then --Hunter
		typesList = { }
	end
	if ClassNum == 4 then --Rogue
		-- Cloak of Shadows
		if spellID == 31224 then typesList = { "Poison","Curse","Disease","Magic" } end
	end
	if ClassNum == 5 then --Priest
		typesList = { }
	end
	if ClassNum == 6 then --Death Knight
		typesList = { }
	end
	if ClassNum == 7 then --Shaman
		-- Cleanse Spirit
		if spellID == 51886 then typesList = { "Curse" } end
		-- Purge
		if spellID == 370 then typesList = { "Magic" } end
	end
	if ClassNum == 8 then --Mage
		typesList = { }
	end
	if ClassNum == 9 then --Warlock
		typesList = { }
	end
	if ClassNum == 10 then --Monk
		-- Detox
		if spellID == 218164 then typesList = { "Poison","Disease" } end
		-- Diffuse Magic
		-- if spellID == 122783 then typesList = { "Magic" } end
	end
	if ClassNum == 11 then --Druid
		-- Remove Corruption
		if spellID == 2782 then typesList = { "Poison","Curse" } end
		-- Nature's Cure
		if spellID == 88423 then typesList = { "Poison","Curse","Magic" } end
		-- Symbiosis: Cleanse
		if spellID == 122288 then typesList = { "Poison","Disease" } end
		-- -- Soothe
		-- if sellID == 2908 then typeList = { "Enrage" } end
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
	local function ValidType(debuffType)
		if typesList == nil then
			return false
		else
			for i = 1,#typesList do
				if typesList[i] == debuffType then
					return true
				else
					return false
				end
			end
		end
	end
	local ValidDebuffType = false
	local i = 1
	if UnitIsFriend("player",Unit) then
		while UnitDebuff(Unit,i) do
			local _,_,_,_,debuffType,_,_,_,_,_,debuffid = UnitDebuff(Unit,i)
			-- Blackout Debuffs
			if ((debuffType and ValidType(debuffType))) --or Enraged())
				and debuffid ~= 138732 --Ionization from Jin'rokh the Breaker - ptr
				and debuffid ~= 138733 --Ionization from Jin'rokh the Breaker - live
			then
				HasValidDispel = true
				break
			end
			i = i + 1
		end
	else
		while UnitBuff(Unit,i) do
			local _,_,_,_,buffType,_,_,_,_,_,buffid = UnitBuff(Unit,i)
			-- Blackout Debuffs
			if ((buffType and ValidType(buffType))) --or Enraged())
				and buffid ~= 138732 --Ionization from Jin'rokh the Breaker - ptr
				and buffid ~= 138733 --Ionization from Jin'rokh the Breaker - live
			then
				HasValidDispel = true
				break
			end
			i = i + 1
		end
	end
	return HasValidDispel
end
function getAuraDuration(Unit,AuraID,Source)
	if UnitAuraID(Unit,AuraID,Source) ~= nil then
		return select(6,UnitAuraID(Unit,AuraID,Source))*1
	end
	return 0
end
function getAuraRemain(Unit,AuraID,Source)
	if UnitAuraID(Unit,AuraID,Source) ~= nil then
		return (select(7,UnitAuraID(Unit,AuraID,Source)) - GetTime())
	end
	return 0
end
function getAuraStacks(Unit,AuraID,Source)
	if UnitAuraID(Unit,AuraID,Source) ~= nil then
		return select(4,UnitAuraID(Unit,AuraID,Source))
	end
	return 0
end

-- if getDebuffDuration("target",12345) < 3 then
function getDebuffDuration(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) ~= nil then
		return select(6,UnitDebuffID(Unit,DebuffID,Source))*1
	end
	return 0
end
-- if getDebuffRemain("target",12345) < 3 then
function getDebuffRemain(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) ~= nil then
		return (select(7,UnitDebuffID(Unit,DebuffID,Source)) - GetTime())
	end
	return 0
end
-- if getDebuffStacks("target",138756) > 0 then
function getDebuffStacks(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) then
		return (select(4,UnitDebuffID(Unit,DebuffID,Source)))
	else
		return 0
	end
end
function getDebuffCount(spellID)
  local counter = 0
  for k, v in pairs(br.enemy) do
    local thisUnit = br.enemy[k].unit
    -- check if unit is valid
    if GetObjectExists(thisUnit) then
      -- increase counter for each occurences
      if UnitDebuffID(thisUnit,spellID,"player") then
        counter = counter + 1
      end
    end
  end
  return tonumber(counter)
end
-- if getBuffDuration("target",12345) < 3 then
function getBuffDuration(Unit,BuffID,Source)
	if UnitBuffID(Unit,BuffID,Source) ~= nil then
		return select(6,UnitBuffID(Unit,BuffID,Source))*1
	end
	return 0
end
-- if getBuffRemain("target",12345) < 3 then
function getBuffRemain(Unit,BuffID,Source)
	if UnitBuffID(Unit,BuffID,Source) ~= nil then
		return (select(7,UnitBuffID(Unit,BuffID,Source)) - GetTime())
	end
	return 0
end
-- if getBuffStacks(138756) > 0 then
function getBuffStacks(unit,BuffID,Source)
	if UnitBuffID(unit,BuffID,Source) then
		return (select(4,UnitBuffID(unit,BuffID,Source)))
	else
		return 0
	end
end
function getBuffCount(spellID)
  	local counter = 0
  	for k, v in pairs(br.friend) do
    	local thisUnit = br.friend[k].unit
    	-- check if unit is valid
    	if GetObjectExists(thisUnit) then
      		-- increase counter for each occurences
      		if UnitBuffID(thisUnit,spellID,"player") then
        		counter = counter + 1
      		end
    	end
  	end
  	return tonumber(counter)
end
-- if getDebuffDuration("target",12345) < 3 then
function getDebuffDuration(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) ~= nil then
		return select(6,UnitDebuffID(Unit,DebuffID,Source))*1
	end
	return 0
end
-- if getDebuffRemain("target",12345) < 3 then
function getDebuffRemain(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) ~= nil then
		return (select(7,UnitDebuffID(Unit,DebuffID,Source)) - GetTime())
	end
	return 0
end
-- if getDebuffStacks("target",138756) > 0 then
function getDebuffStacks(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) then
		return (select(4,UnitDebuffID(Unit,DebuffID,Source)))
	else
		return 0
	end
end
-- if getDisease(30,true,min) < 2 then
function getDisease(range,aoe,mod)
    if mod == nil then mod = "min" end
    if range == nil then range = 5 end
    if aoe == nil then aoe = false end
    local range     	= tonumber(range)
    local mod 			= tostring(mod)
    local dynTar 		= dynamicTarget(range,true)
    local dynTarAoE 	= dynamicTarget(range,false)
    local dist 			= getDistance("player",dynTar)
    local distAoE 		= getDistance("player",dynTarAoE)
    local ff 			= getDebuffRemain(dynTar,55095,"player") or 0
    local ffAoE 		= getDebuffRemain(dynTarAoE,55095,"player") or 0
    local bp 			= getDebuffRemain(dynTar,55078,"player") or 0
    local bpAoE 		= getDebuffRemain(dynTarAoE,55078,"player") or 0
    local np 			= getDebuffRemain(dynTar,155159,"player") or 0
    local npAoE 		= getDebuffRemain(dynTarAoE,155159,"player") or 0
    local diseases 		= {ff,bp}
    local diseasesAoE 	= {ffAoE,bpAoE}
    local minD			= 99
    local maxD 			= 0
    if mod == "min" then
      	if aoe == false then
        	if dist < range then
          		if getTalent(7,1) then
            		return np
            	else
            		for i = 1, #diseases do
            			if diseases[i]>0 and diseases[i]<minD then
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
          		if getTalent(7,1) then
            		return npAoE
            	else
            		for i = 1, #diseasesAoE do
            			if diseases[i]>0 and diseases[i]<minD then
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
          		if getTalent(7,1) then
            		return np
            	else
            		for i = 1, #diseases do
            			if diseases[i]>0 and diseases[i]>maxD then
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
          		if getTalent(7,1) then
            		return npAoE
            	else
            		for i = 1, #diseasesAoE do
            			if diseases[i]>0 and diseases[i]<maxD then
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
	if UnitBuffID("player",90355)       	-- Ancient Hysteria
		or UnitBuffID("player",2825)        -- Bloodlust
		or UnitBuffID("player",146555)      -- Drums of Rage
		or UnitBuffID("player",32182)       -- Heroism
		or UnitBuffID("player",90355) 		-- Netherwinds
		or UnitBuffID("player",80353)       -- Timewarp
	then
		return true
	else
		return false
	end
end
function hasBloodLustRemain()
	if UnitBuffID("player",90355) then
		return getBuffRemain("player",90355)
	elseif UnitBuffID("player",2825) then
		return getBuffRemain("player",2825)
	elseif UnitBuffID("player",146555) then
		return getBuffRemain("player",146555)
	elseif UnitBuffID("player",32182) then
		return getBuffRemain("player",32182)
	elseif UnitBuffID("player",90355) then
		return getBuffRemain("player",90355)
	elseif UnitBuffID("player",80353) then
		return getBuffRemain("player",80353)
	else
		return 0
	end
end
--- if isBuffed()
function isBuffed(UnitID,SpellID,TimeLeft,Filter)
	if not TimeLeft then TimeLeft = 0 end
	if type(SpellID) == "number" then SpellID = { SpellID } end
	for i=1,#SpellID do
		local spell,rank = GetSpellInfo(SpellID[i])
		if spell then
			local buff = select(7,UnitBuff(UnitID,spell,rank,Filter))
			if buff and ( buff == 0 or buff - GetTime() > TimeLeft ) then return true end
		end
	end
end
-- if isDeBuffed("target",{123,456,789},2,"player") then
function isDeBuffed(UnitID,DebuffID,TimeLeft,Filter)
	if not TimeLeft then
		TimeLeft = 0
	end
	if type(DebuffID) == "number" then
		DebuffID = { DebuffID }
	end
	for i=1,#DebuffID do
		local spell,rank = GetSpellInfo(DebuffID[i])
		if spell then
			local debuff = select(7,UnitDebuff(UnitID,spell,rank,Filter))
			if debuff and ( debuff == 0 or debuff - GetTime() > TimeLeft ) then
				return true
			end
		end
	end
end