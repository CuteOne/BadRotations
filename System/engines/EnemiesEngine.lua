-- Function to create and populate table of enemies within a distance from player.
function EnemiesEngine()

-- Todo: So i think the prioritisation should be large by determined by threat or burn prio and then hp.
-- So design should be,
-- Check if the unit is on doNotTouchUnitCandidates list which means we should not attack them at all

-- Check towards doNotTouchUnitCandidatesBuffs (buffs/debuff), ie target we are not allowed to attack due to them having
-- a (de)buff that hurts us or not. Example http://www.wowhead.com/spell=163689

-- Is the unit on burn list, set high prio, burn list is a list of mobs that we specify for burn, is highest dps and prio.

-- We should then look at the threat situation, for tanks the this is of high prio if we are below 3 but all below 3
-- should have the same prio coefficent. For dps its not that important

-- Then we should check HP of the targets and set highest prio on low targets, this is also something we need to think
-- about if the target have a dot so it will die regardless or not. Should have a timetodie?


-- Stack: Interface\AddOns\BadBoy\System\EnemiesEngine.lua:224: in function `castInterrupt'
-- isBurnTarget(unit) - Bool - True if we should burn that target according to burnUnitCandidates
-- isSafeToAttack(unit) - Bool - True if we can attack target according to doNotTouchUnitCandidates
-- getEnemies(unit,Radius) - Number - Returns number of valid units within radius of unit
-- castInterrupt(spell,percent) - Multi-Target Interupts - for facing/in movements spells of all ranges.
-- makeEnemiesTable(55) - Triggered in badboy.lua - generate the enemiesTable

--[[------------------------------------------------------------------------------------------------------------------]]
--[[------------------------------------------------------------------------------------------------------------------]]
--[[------------------------------------------------------------------------------------------------------------------]]
--[[------------------------------------------------------------------------------------------------------------------]]
local varDir = BadBoy_data.options[GetSpecialization()]

function makeEnemiesTable(maxDistance)
	local  maxDistance = maxDistance or 50
	if enemiesTable then cleanupEngine() end
	if enemiesTable == nil or enemiesTableTimer == nil or enemiesTableTimer <= GetTime() - 1 then
		enemiesTableTimer = GetTime()
		-- create/empty table
		if enemiesTable == nil then
			enemiesTable = { }
		else
			table.wipe(enemiesTable)
		end
		-- use objectmanager to build up table
	 	for i = 1, ObjectCount() do
	 		-- define our unit
		  	local thisUnit = ObjectWithIndex(i)
	 		-- sanity checks
	 		if getSanity(thisUnit) == true then
  				-- get the unit distance
  				local unitDistance = getDistance("player",thisUnit)
				-- distance check according to profile needs
  				if unitDistance <= maxDistance then
		  			-- get unit Infos
		  			local safeUnit = isSafeToAttack(thisUnit)
		  			local burnValue = isBurnTarget(thisUnit) or 0
		  			local unitName = UnitName(thisUnit)
		  			local unitID = getUnitID(thisUnit)
		  			local shouldCC = isCrowdControlCandidates(thisUnit)
	  				local unitThreat = UnitThreatSituation("player",thisUnit) or -1
	  				local shieldValue = isShieldedTarget(thisUnit) or 0
	  				local X1,Y1,Z1 = ObjectPosition(thisUnit)
					local unitCoeficient = getUnitCoeficient(thisUnit,unitDistance,unitThreat,burnValue,shieldValue) or 0
  					local unitHP = getHP(thisUnit)
  					local inCombat = UnitAffectingCombat(thisUnit)
  					local longTimeCC = false
  					if getOptionCheck("Don't break CCs") then
						longTimeCC = isLongTimeCCed(thisUnit)
					end
		  			local shouldDispel = getOffensiveBuffs(thisUnit)
  					-- insert unit as a sub-array holding unit informations
   					tinsert(enemiesTable,
   						{
	   						name = unitName,
	   						guid = UnitGUID(thisUnit),
	   						id = unitID,
	   						coeficient = unitCoeficient,
	   						cc = shouldCC,
	   						isCC = longTimeCC,
	   						facing = getFacing("player",thisUnit),
	   						threat = unitThreat,
	   						unit = thisUnit,
	   						distance = unitDistance,
	   						hp = unitHP,
	   						hpabs = UnitHealth(thisUnit),
	   						safe = safeUnit,
	   						burn = burnUnit,
	   						offensiveBuff = shouldDispel,
	   						-- Here should track inc damage / healing as well in order to get a timetodie value
	   						-- we would need a more static design
	   						x = X1,
	   						y = Y1,
	   						z = Z1,
   						}
   					)
   				end
		  	end
	 	end
	 	-- sort them by coeficient
	 	table.sort(enemiesTable, function(x,y)
	 		return x.coeficient and y.coeficient and x.coeficient > y.coeficient or false
	 	end)
	end
end

-- remove invalid units on pulse
function cleanupEngine()
	for i = #enemiesTable, 1, -1 do
		-- here i want to scan the enemies table and find any occurances of invalid units
		if not ObjectExists(enemiesTable[i].unit) then
			-- i will remove such units from table
			tremove(enemiesTable,i)
		end
	end
end


-- returns prefered target for diferent spells
function dynamicTarget(range,facing)
	if getOptionCheck("Dynamic Targetting") then
		local bestUnitCoef = 0
		local bestUnit = "target"
		for i = 1, #enemiesTable do
			local thisUnit = enemiesTable[i]
			if ObjectExists(thisUnit.unit) then
				if (not safeCheck or thisUnit.safe) and thisUnit.isCC == false and thisUnit.distance < range and (facing == false or thisUnit.facing == true) then
					if thisUnit.coeficient >= 0 and thisUnit.coeficient >= bestUnitCoef then
						bestUnitCoef = thisUnit.coeficient
						bestUnit = thisUnit.unit
					end
				end
			end
		end
		return bestUnit
	else
		return "target"
	end
	return "target"
end

--[[------------------------------------------------------------------------------------------------------------------]]
--[[------------------------------------------------------------------------------------------------------------------]]
--[[------------------------------------------------------------------------------------------------------------------]]
--[[------------------------------------------------------------------------------------------------------------------]]


--[[           ]]		  --[[]]		--[[           ]]	--[[           ]]
--[[           ]]		 --[[  ]]		--[[           ]]	--[[           ]]
--[[]]				    --[[    ]] 		--[[ ]]					 --[[ ]]
--[[]]				   --[[      ]] 	--[[           ]]		 --[[ ]]
--[[]]				  --[[        ]]			  --[[ ]]		 --[[ ]]
--[[           ]]	 --[[]]    --[[]]	--[[           ]]		 --[[ ]]
--[[           ]]	--[[]]      --[[]]	--[[           ]]		 --[[ ]]

-- cast a cc spell on a given target or on "any" target
function castCrowdControl(Unit,SpellID)
	-- gather spell informations
	local spellName,_,_,_,_,spellDistance = GetSpellInfo(SpellID)
	if spellDistance < 5 then
		spellDistance = 5
	end
	-- if "any" parameter is provided to target, we scan all the targets
	if Unit == "any" then
		-- test all targets
		for i = 1, #enemiesTable do
			-- if this unit is a cc candidate and is in range
			if enemiesTable[i].cc == true and enemiesTable[i].distance < spellDistance then
				-- cast the spell
				if castSpell(enemiesTable[i].unit,SpellID,true,false) then
					return true
				end
			end
		end
	else
		-- if param target isnt "any", do our chwecks on requested unit.
		if isCrowdControlCandidates(Unit) == true and getDistance("player",Unit) < spellDistance then
			-- cast on that unit
			if castSpell(enemiesTable[i].unit,SpellID,true,false) then
				return true
			end
		end
	end
end

-- units can be "all" or a numeric value
function castDotCycle(units,spellID,range,facingCheck,movementCheck,duration)
	local units = units
	-- unit can be "all" or numeric
	if type(units) == "number" then
		units = units
	else
		units = 100
	end
	duration = duration or 1
	-- cycle our units if we want MORE DOTS
	if getDebuffCount(spellID) < units then
    	for i = 1, #enemiesTable do
     		local thisUnit = enemiesTable[i]
     		if thisUnit.isCC == false and UnitLevel(thisUnit.unit) < UnitLevel("player") + 5 then
	     		local dotRemains = getDebuffRemain(thisUnit.unit,spellID,"player")
	     		if dotRemains < duration then
	      			if castSpell(thisUnit.unit,spellID,facingCheck,movementCheck) then
	       				return true
		      		end
		     	end
		    end
	    end
	end
end
-- /run castDispelOffensiveBuffs(20271)
-- function to Dispel offensive buffs, provide it a valid spell id(purge/arcane shot/etc)
function castDispelOffensiveBuffs(spell)
	-- gather spell informations
	local spellName,_,_,_,_,spellDistance = GetSpellInfo(spell)
	if spellDistance < 5 then
		spellDistance = 5
	end
	-- iterate our enemies
	for i = 1,#enemiesTable do
		local thisUnit = enemiesTable[i]
		if ObjectExists(thisUnit.unit) then
			if thisUnit.distance <= spellDistance and thisUnit.offensiveBuff == true then
				if castSpell(thisUnit.unit,spell,false,false) then
					bb:debug("Dispelled "..thisUnit.name.. " using "..spellName)
					return true
				end
			end
		end
	end
end

--[[           ]]   --[[           ]]    --[[           ]]
--[[           ]]   --[[           ]]    --[[           ]]
--[[]]              --[[]]        		       --[[ ]]
--[[]]   --[[  ]]	--[[           ]]          --[[ ]]
--[[]]     --[[]]	--[[]]        		       --[[ ]]
--[[           ]]   --[[           ]]          --[[ ]]
--[[           ]]   --[[           ]]          --[[ ]]

-- get the best aoe interupt unit for a given range
function getBestAoEInterupt(Range)
	-- pulse our function that add casters around to castersTable
	findCastersAround(Range)
	-- dummy var
	local bestAoEInteruptAmount = 0
	local bestAoEInteruptTarget = "target"
	-- cycle spellCasters to find best case
	local spellCastersTable = bb.im.casters
	for i = 1, #spellCastersTable do
		-- if dummy beat old dummy, update
		if spellCastersTable[i].castersAround > bestAoEInteruptAmount then
			bestAoEInteruptAmount = spellCastersTable[i].castersAround
			bestAoEInteruptTarget = spellCastersTable[i].unit
		end
	end
	-- return best case
	return bestAoEInteruptTarget
end

function getDebuffCount(spellID)
  	local counter = 0
	for i=1,#enemiesTable do
		local thisUnit = enemiesTable[i].unit
		-- increase counter for each occurences
		if UnitDebuffID(thisUnit,spellID,"player") then
			counter = counter + 1
		end
	end
  	return counter
end

-- to enlight redundant checks in getDistance within getEnemies
function getDistanceXYZ(unit1,unit2)
	local x1, y1, z1 = ObjectPosition(unit1)
	local x2, y2, z2 = enemiesTable[unit2].x, enemiesTable[unit2].y, enemiesTable[unit2].z
	return math.sqrt(((x2-x1)^2)+((y2-y1)^2)+((z2-z1)^2));
end

-- /dump UnitGUID("target")
-- /dump getEnemies("target",10)
function getEnemies(unit,Radius)
	if ObjectExists(unit) and UnitIsVisible(unit) then
		local getEnemiesTable = { }
	 	for i = 1, #enemiesTable do
	 		thisUnit = enemiesTable[i].unit
		  	if getDistanceXYZ(unit,i) <= Radius then
		   		tinsert(getEnemiesTable,thisUnit)
		  	end
	 	end
	 	return getEnemiesTable
	else
	 	return { }
	end
end

-- returns true if unit have an Offensive Buff that we should dispel
function getOffensiveBuffs(unit)
	if ObjectExists(unit) then
		for i = 1,#dispellOffensiveBuffs do
			if UnitBuffID(unit,dispellOffensiveBuffs[i]) then
				return true
			end
		end
	end
	return false
end

-- returns true if Unit is a valid enemy
function getSanity(unit)
	if ObjectExists(unit) and bit.band(ObjectType(unit), ObjectTypes.Unit) == 8
	  and UnitIsVisible(unit) == true and getCreatureType(unit) == true
	  and UnitCanAttack(unit, "player") == true and UnitIsDeadOrGhost(unit) == false
	  and (UnitAffectingCombat(unit) or isDummy(unit)) then
	  	return true
	else
		return false
	end
end

-- This function will set the prioritisation of the units, ie which target should i attack
function getUnitCoeficient(unit,distance,threat,burnValue,shieldValue)
	local coef = 0
	-- if unit is out of range, bad prio(0)
	if distance < 40 then
		local unitHP = getHP(unit)
		-- if its our actual target we give it a bonus
		if UnitIsUnit("target",unit) == true then
			coef = coef + 1
		end

		-- if wise target checked, we look for best target by looking to the lowest or highest hp, otherwise we look for target
		if getOptionCheck("Wise Target") == true then
			if getOptionValue("Wise Target") == 1 then
				-- if highest is selected
				coef = unitHP
			else
				-- if lowest is selected
				coef = 100 - unitHP
			end
		end

		-- raid target management
		-- if the unit have the skull and we have param for it add 50
		if getOptionCheck("Skull First") and GetRaidTargetIndex(unit) == 8 then
			coef = coef + 50
		end

		-- if threat is checked, add 100 points of prio if we lost aggro on that target
		if getOptionCheck("Tank Threat") == true then
			if select(6, GetSpecializationInfo(GetSpecialization())) == "TANK" and threat < 3 and unitHP > 10 then
				coef = coef + 100
			end
		end

		-- if user checked burn target then we add the value otherwise will be 0
		coef = coef + burnValue
		-- if user checked avoid shielded, we add the % this shield remove to coef
		coef = coef + shieldValue
		local displayCoef = math.floor(coef*10)/10
		local displayName = UnitName(unit) or "invalid"
		-- print("Unit "..displayName.." - "..displayCoef)
	end
	return coef
end

--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]
	 --[[ ]]		--[[ ]]
	 --[[ ]]		--[[           ]]
	 --[[ ]]				  --[[ ]]
--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]

-- function to see if our unit is a blacklisted unit
function isBlackListed(Unit)
	for i = 1, #castersBlackList do
		if castersBlackList[i].unit == Unit then
			return true
		end
	end
end

-- returns true if target should be burnt
function isBurnTarget(unit)
	local coef = 0
	if getOptionCheck("Forced Burn") then
		local unitID = getUnitID(unit)
		local burnUnit = burnUnitCandidates[unitID]
			-- if unit have selected debuff
		if burnUnit and burnUnit.buff and UnitBuffID(unit,burnUnit.buff) then
			coef = burnUnit.coef
		end
	end
	return coef
end

-- check for a unit see if its a cc candidate
function isCrowdControlCandidates(Unit)
	local unitID = getUnitID(Unit)
	-- cycle list of candidates
	local crowdControlUnit = crowdControlCandidates[unitID]
	if crowdControlUnit then
		-- is in the list of candidates
		if (crowdControlUnit.buff == nil or UnitBuffID(Unit,crowdControlUnit.buff))
		  and (crowdControlUnit.spell == nil or getCastingInfo(Unit) == GetSpellInfo(crowdControlUnit.spell))
		then -- doesnt have more requirements or requirements are met
			return true
		end
	end
	return false
end

--if isLongTimeCCed("target") then
-- CCs with >=20 seconds
function isLongTimeCCed(Unit)
    if Unit == nil then return false end
    for i = 1, #longTimeCC do
        --local checkCC=longTimeCC[i]
        if UnitDebuffID(Unit,longTimeCC[i]) ~= nil then
            return true
        end
    end
    return false
end

-- returns true if we can safely attack this target
function isSafeToAttack(unit)
	if getOptionCheck("Safe Damage Check") == true then
		local unitID = getUnitID(unit)
		for i = 1, #doNotTouchUnitCandidates do
			if doNotTouchUnitCandidates[i].unitID == 1 or doNotTouchUnitCandidates[i].unitID == unitID then
				if UnitBuffID(unit,doNotTouchUnitCandidates[i].buff) or UnitDebuffID(unit,doNotTouchUnitCandidates[i].buff) then
					return false
				end
			end
		end
	end
	-- if all went fine return true
	return true
end

-- returns true if target is shielded or should be avoided
function isShieldedTarget(unit)
	local coef = 0
	if getOptionCheck("Avoid Shields") then
		local unitID = getUnitID(unit)
		local shieldedUnit = shieldedUnitCandidates[unitID]
		-- if unit have selected debuff
		if shieldedUnit and shieldedUnit.buff and UnitBuffID(unit,shieldedUnit.buff) then
			-- if it's a frontal buff, see if we are in front of it
			if shieldedUnit.frontal ~= true or getFacing(unit,"player") == true then
				coef = shieldedUnit.coef
			end
		end
	end
	return coef
end

end

-- ToDo: We need to think about if the target have a dot so it will die regardless or not. Should have a timetodie.