


-- Functions from coders for public use

--[[                                                                                                ]]
--[[ ragnar                                                                                         ]]
--[[                                                                                                ]]
function getTooltipSize(SpellID)
	-- description
		-- get the dmg or heal value from a tooltip

	-- return:
		-- number
		
	-- example:
		-- getTooltipSize(2061)

	_, _, n1, n2 = GetSpellDescription(SpellID):find("(%d+),(%d%d%d)")
	return tonumber(n1..n2)
end

function castBossButton(target)
	if target==nil then
		RunMacroText("/click ExtraActionButton1")
		return true
	else
		TargetUnit(target)
		RunMacroText("/click ExtraActionButton1")
		return true
	end
end

-- get threat situation on player and return the number
function getThreat()
	if UnitThreatSituation("player") ~= nil then
		return UnitThreatSituation("player")
	end
	-- 0 - Unit has less than 100% raw threat (default UI shows no indicator)
	-- 1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
	-- 2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
	-- 3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
	return 0
end

function RaidBuff(BuffSlot,myBuffSpellID)
	-- description: 
		-- check for raidbuff and cast if missing

	-- returns:
		-- true: 	someone was without buff and spell casted
		-- false: 	"BuffSlot" or "myBuffSpellID" is missing
		-- nil: 	all raidmembers in range are buffed

	-- example:
		-- Check for Stamina as Priest:
			-- Buffslot Stamina: 2
			-- Power Word: Fortitude Spell ID: 21562
			-- RaidBuff(2,21562)
	-- Buffslots:
		-- 1 Stats
		-- 2 Stamina
		-- 3 Attack Power
		-- 4 Haste
		-- 5 Spell Power
		-- 6 Critical Strike
		-- 7 Mastery
		-- 8 Multistrike
		-- 9 Versatility

	if BuffSlot==nil or myBuffSpellID==nil then return false end
	
	local id = BuffSlot
	local SpellID = myBuffSpellID
	local bufftable = {
		stats = {1126,115921,116781,20217,160206,159988,160017,90363,160077},
		stamina = {21562,166928,469,160199,50256,160003,90364},
		attackPower = {57330,19506,6673},
		spellPower = {1459,61316,109773,160205,128433,90364,126309},
		mastery = {155522,24907,19740,116956,160198,93435,160039,128997,160073},
		haste = {55610,49868,113742,116956,160203,128432,160003,135670,160074},
		crit = {17007,1459,61316,116781,160200,90309,126373,160052,90363,126309,24604},
		multistrike = {166916,49868,113742,109773,172968,50519,57386,58604,54889,24844},
		versatility = {55610,1126,167187,167188,172967,159735,35290,57386,160045,50518,173035,160007}
	}

	if id == 1 then
		chosenTable = bufftable.stats
	elseif id == 2 then
		chosenTable = bufftable.stamina
	elseif id == 3 then
		chosenTable = bufftable.attackPower
	elseif id == 4 then
		chosenTable = bufftable.spellPower
	elseif id == 5 then
		chosenTable = bufftable.mastery
	elseif id == 6 then
		chosenTable = bufftable.haste
	elseif id == 7 then
		chosenTable = bufftable.crit
	elseif id == 8 then
		chosenTable = bufftable.multistrike
	elseif id == 9 then
		chosenTable = bufftable.versatility
	end
		
	if GetNumGroupMembers()==0 then
		if not UnitIsDeadOrGhost("player") then
			if not GetRaidBuffTrayAuraInfo(id) then
				if castSpell("player",SpellID) then return true end
			end
		end
	else 
		if UnitIsDeadOrGhost("player") then
			return false
		else 
			for index=1,GetNumGroupMembers() do
				local name, _, subgroup, _, _, _, zone, online, isDead, _, _ = GetRaidRosterInfo(index)
				if online and not isDead and 1==IsSpellInRange(select(1,GetSpellInfo(SpellID)), "raid"..index) then
					local playerBuffed=false
					for auraIndex=1,#chosenTable do
						if getBuffRemain("raid"..index,chosenTable[auraIndex])>0 then break end
						if getBuffRemain("raid"..index,chosenTable[auraIndex])<=0 then
							if castSpell("player",PWF,true,false) then return true end
						end
					end
				end
			end
		end
	end
end

function getUnitCluster(minUnits,maxRange)
	-- Description:
		-- returns the enemy with minUnits around in maxRange
	
	-- rerturns:
		-- "0x0000000110E4F09C"
	
	-- how to use:
		-- castSpell(getUnitCluster(2,10),SpellID,...,...)
		-- use "getUnitCluster(minUnits,maxRange)" instead of "target"

	if type(minUnits) ~= "number" then return nil end
	if type(maxRange) ~= "number" then return nil end

	local range = maxRange
	local enemies = minUnits
	local enemiesInRange = 0
	
	local theReturnUnit

	for i=1,#enemiesTable do
		local thisUnit = enemiesTable[i].unit
		local thisEnemies = getNumEnemies(thisUnit,range)
		if thisEnemies>=enemies and thisEnemies>=enemiesInRange then
			theReturnUnit = thisUnit
		end
	end
	return select(1,theReturnUnit)
end

function getBiggestUnitCluster(maxRange)
	-- Description:
		-- returns the enemy with most enemies around in maxRange
	
	-- rerturns:
		-- "0x0000000110E4F09C"
	
	-- how to use:
		-- castSpell(getBiggestUnitCluster(10),SpellID,...,...)
		-- use "getBiggestUnitCluster(minUnits,maxRange)" instead of "target"

	if type(maxRange) ~= "number" then return nil end

	local range = maxRange
	local enemiesInRange = 0
	
	local theReturnUnit

	for i=1,#enemiesTable do
		local thisUnit = enemiesTable[i].unit
		if getNumEnemies(thisUnit,range)>=enemiesInRange then
			theReturnUnit = thisUnit
		end
	end
	return select(1,theReturnUnit)
end



--[[                                                                                                ]]
--[[ Defmaster                                                                                      ]]
--[[                                                                                                ]]

function SalvageHelper()
	-- Description:
		-- salvage your boxes from garrision mission
		-- only when in 'Salvage Yard'
		-- abort if empytSlots in inventory < 3
		-- salvageWaiting = wait x sec before starting again

	-- Returns:
		-- nothing

	if isChecked("Salvage") and GetMinimapZoneText() == "Salvage Yard" then

		local salvageWaiting = getValue("Salvage")

		if salvageTimer == nil or (GetTime() - salvageTimer > salvageWaiting) then
			local freeSlots = 0

			for i=1,5 do 
				freeSlots = freeSlots + GetContainerNumFreeSlots(i-1)
			end

			if freeSlots > 3 then
				-- Bag of Salvaged Goods
				if GetItemCount(114116, false, false) > 0 then
					UseItemByName(114116)
				-- Crate of Salvage
				elseif GetItemCount(114119, false, false) > 0 then
					UseItemByName(114119)
				-- Big Crate of Salvage
				elseif GetItemCount(114120, false, false) > 0 then
					UseItemByName(114120)
				end
			else
				salvageTimer = GetTime() -- if no more free slots, start timer
			end -- freeSlots
		end -- gettime()
	end -- isChecked()
end -- salvage()
	