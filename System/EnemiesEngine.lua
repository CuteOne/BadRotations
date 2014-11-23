-- Function to create and populate table of enemies within a distance from player.
function EnemiesEngine()


-- burnTarget(unit) - Bool - True if we should burn that target according to burnUnitCandidates
-- safeToAttack(unit) - Bool - True if we can attack target according to doNotTouchUnitCandidates



-- Todo, nice to have is enemies around any unit, in order to compute AOE toggling. Ie (enemesAround("HEALER")
-- we will use coords for this
-- Todo: Add list of units to stun, either always or udner certain condition such as having a buff or wirldwinding etc



burnUnitCandidates = {
	{ unitID = 71603 }, -- immersus ooze, kill on sight
} -- List of UnitID/Names we should have highest prio on.
-- we will use UnitID with getUnitID()

-- doNotTouchUnitCandidates {} -- List of units that we should not attack for any reason
-- doNotTouchUnitCandidatesBuffs {} -- List of debuffs/buffs that forces us to switch targets
doNotTouchUnitCandidates = { 
	{ unitID = 166591 }, -- Never attack Sanguine Sphere
  	{ unitID = 71515 , buff = 143593 }, --do not attack during defensive stance buff
}


function makeEnemiesTable(maxDistance)
	local  maxDistance = maxDistance or 50
	-- Throttle this 1 sec.
	if enemiesTable == nil or enemiesTableTimer == nil or enemiesTableTimer <= GetTime() - 1 then
		-- create/empty table
		enemiesTable = { }
		-- use objectmanager to build up table
	 	for i=1,ObjectCount() do
	 		-- define our unit
		  	local thisUnit = ObjectWithIndex(i);
	 		-- sanity checks
	 		if getSanity(thisUnit) == true then
  				-- get the unit distance
  				local unitDistance = getDistance("player",thisUnit)
				-- distance check according to profile needs
  				if unitDistance <= maxDistance then
		  			-- get unit Infos
		  			local unitName = UnitName(thisUnit)
	  				local unitThreat = UnitThreatSituation("player",thisUnit) or -1
	  				local unitCasting, unitCastLenght, unitCastTime, unitCanBeInterrupt, unitCastType = getCastingInfo(thisUnit)
	  				local X1, Y1, Z1 = ObjectPosition(thisUnit)
					local unitCoeficient = getUnitCoeficient(thisUnit,unitDistance,unitThreat) or 0
  					local unitHP = getHP(thisUnit)
  					-- insert unit as a sub-array holding unit informations
   					tinsert(enemiesTable, { 
   						name = unitName, 
   						coeficient = unitCoeficient, 
   						cast = {  --List of casting information
   							casting = unitCasting or false, 
   							castLenght = unitCastLenght, 
   							castTime = unitCastTime, 
   							canBeInterrupted = unitCanBeInterrupt or false, 
   							castType = unitCastType 
   								}, 
   						threat = unitThreat, 
   						unit = thisUnit, 
   						distance = unitDistance, 
   						hp = unitHP, 
   						-- Here should track inc damage / healing as well in order to get a timetodie value
   						x = X1, y = Y1, z = Z1 
   						})
	   				end
			  	end
		 	end

		 	-- sort them by coeficient
		 	table.sort(enemiesTable, function(x,y)
	 		return x.coeficient and y.coeficient and x.coeficient < y.coeficient or false
	 	end)
	end
end


-- This function will set the prioritisation of the units, ie which target should i attack
-- Todo: So i think the prioritisation should be large by determined by threat or burn prio and then hp.
-- So design should be, 
-- Check if the unit is on doNotTouchUnitCandidates list which means we should not attack them at all

-- Check towards doNotTouchUnitCandidatesBuffs (buffs/debuff), ie target we are not allowed to attack due to them 
-- having a (de)buff that hurts us or not. Example http://www.wowhead.com/spell=163689

-- Is the unit on burn list, set high prio, burn list is a list of mobs that we specify for burn, is highest dps and prio.

-- We should then look at the threat situation, for tanks the this is of high prio if we are below 3 but all below 3 should have the same prio coefficent. For dps its not that important

-- Then we should check HP of the targets and set highest prio on low targets, this is also something we need to think about if the target have a dot so it will die regardless or not. Should have a timetodie?


function getUnitCoeficient(unit, distance, threat)
	local coef = 0
	if distance < 40 then  -- If target is not in range have prio set to 250.
		coef = getHP(unit)  -- Use the healthpercentage of the target as baseline, we want to prioritise low health targets as a tank. Could be mobs that we need to kill at the same time tough. Nice to have a list.
		if select(6, GetSpecializationInfo(GetSpecialization())) == "TANK" then -- If we are tanking, then we should also look into threat. ToDos: Why should not dps also want to use threat? Not pulling aggro is a good thing. Also instead of role we should use http://www.wowwiki.com/API_GetSpecialization, http://www.wowwiki.com/API_GetSpecializationRole
			coef = coef + threat*10
		end
		-- if its our actual target we give it a bonus
		if UnitGUID("target") == UnitGUID(unit) then
			coef = coef + 50
		end
		-- if its a burn target we max his coef
		if burnTarget(unit) == true then
			coef = 250
		end
	end
	return coef
end

-- returns anme fo cast/channel and casting("cast") or channelling("chan") /dump getCastingInfo("target")
function getCastingInfo(unit)
	if UnitCastingInfo(unit) ~= nil then
		local unitCastName, _, _, _, unitCastStart, unitCastEnd, _, unitCastID, unitCastNotInteruptible = UnitCastingInfo(unit)
		return unitCastName, getCastLenght(unitCastStart,unitCastEnd), getTimeUntilCastEnd(unitCastEnd), unitCastNotInteruptible == false, "cast"
	elseif UnitChannelInfo(unit) ~= nil then
		local unitCastName, _, _, _, unitCastStart, unitCastEnd, _, unitCastID, unitCastNotInteruptible = UnitChannelInfo(unit)
		return unitCastName, getCastLenght(unitCastStart,unitCastEnd), getTimeUntilCastEnd(unitCastEnd), unitCastNotInteruptible == false, "chan"
	else
		return false, "none"
	end
end

-- returns true if Unit is a valid enemy
function getSanity(unit)
	if UnitExists(unit) and bit.band(ObjectType(unit), ObjectTypes.Unit) == 8 
	  and UnitIsVisible(unit) == true and getCreatureType(unit) == true
	  and UnitCanAttack(unit, "player") == true and UnitIsDeadOrGhost(unit) == false then
	  	return true
	else
		return false
	end
end

-- /dump UnitGUID("target")
-- /dump getEnemies("target",10)
function getEnemies(unit,Radius)
	local getEnemiesTable = { }
 	for i = 1, #enemiesTable do
 		thisUnit = enemiesTable[i].unit
	  	if getDistanceXYZ(unit,i) <= Radius then
	   		tinsert(getEnemiesTable,thisUnit)
	  	end
 	end
 	return getEnemiesTable
end

-- to enlight redundant checks in getDistance within getEnemies
function getDistanceXYZ(unit1,unit2)
	local x1, y1, z1 = ObjectPosition(unit1);
	local x2, y2, z2 = enemiesTable[unit2].x, enemiesTable[unit2].y, enemiesTable[unit2].z
	return math.sqrt(((x2-x1)^2)+((y2-y1)^2)+((z2-z1)^2));
end


-- casting informations
function getCastLenght(castStart,castEnd)
	return (castEnd-castStart)/1000
end

function getTimeUntilCastEnd(castEnd)
	return math.floor((castEnd/1000 - GetTime())*100)/100
end

-- casters table
function makeSpellCastersTable()
	spellCastersTable = { }
	for i = 1, #enemiesTable do
		if enemiesTable[i].cast.casting ~= false and enemiesTable[i].cast.canBeInterrupted == true 
		  and getFacing("player",enemiesTable[i].unit) == true then
		  	tinsert(spellCastersTable, { unit = enemiesTable[i].unit, castName = enemiesTable[i].cast.casting, 
		  	  castLenght = enemiesTable[i].cast.castLenght, castEnd = enemiesTable[i].cast.castTime, distance = enemiesTable[i].distance, })
		end
	end
end

-- function to compare spells to casting units
function castInterupt(spell,percent)
	if castersBlackList == nil then castersBlackList = { } end
	for i = 1, #castersBlackList do
		if castersBlackList[i].time ~= nil and castersBlackList[i].time < GetTime() - 0.5 then
			tremove(castersBlackList, i)
		end
	end
	if canCast(spell,false,false) == true then
		for i = 1, #spellCastersTable do
			local blackListedUnit = false
			for j = 1, #castersBlackList do
				if castersBlackList[j].unit == spellCastersTable[i].unit then
					blackListedUnit = true
					break
				end
			end
			if blackListedUnit == false then
				-- make sure we cover melee range
				local allowedDistance = select(6,GetSpellInfo(spell))
				if allowedDistance < 5 then 
					allowedDistance = 5 
				end
				
				if getSpellCD(spell) < spellCastersTable[i].castEnd 
				  and spellCastersTable[i].castEnd/spellCastersTable[i].castLenght < (100 - percent)/100
				  and spellCastersTable[i].distance < allowedDistance then
					if castSpell(spellCastersTable[i].unit,spell,false,false) then 
						tinsert(castersBlackList, { unit = spellCastersTable[i].unit, time = GetTime() })
						return 
					end
				end
			end
		end
	end
end









function burnTarget(unit)
	for i = 1, #burnUnitCandidates do
		if getUnitID(unit) == burnUnitCandidates.unitID then

			-- add other conditions here


			return true
		end
	end
	return false
end

function safeToAttack(unit)
	for i = 1, #doNotTouchUnitCandidates do
		-- holds candidate ID
		local candidateUnit = doNotTouchUnitCandidates[i].unitID
		-- we only scan units #s until we find a match
		if getUnitID(unit) == candidateUnit then

			--if condition is a buff
			local dontTouchStatus = false
			local candidateBuff = doNotTouchUnitCandidates[i].buff
			if candidateBuff ~= nil then
				if UnitBuffID(unit,candidateBuff) ~= nil then
					break
				end
			end

			-- if condition is a debuff
			local candidateDebuff = doNotTouchUnitCandidates[i].deBuff
			if candidateDebuff ~= nil then
				if UnitDebuffID(unit,candidateDebuff) ~= nil then
					break
				end
			end

			-- if all went fine, true otherwise we break out of iteration and return false if we need to stop
			return true
		end
	end
	return false
end







end


