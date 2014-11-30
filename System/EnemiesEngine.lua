-- Function to create and populate table of enemies within a distance from player.
function EnemiesEngine()


-- Todo: So i think the prioritisation should be large by determined by threat or burn prio and then hp.
-- So design should be, 
-- Check if the unit is on doNotTouchUnitCandidates list which means we should not attack them at all
-- Check towards doNotTouchUnitCandidatesBuffs (buffs/debuff), ie target we are not allowed to attack due to them having a (de)buff that hurts us or not. Example http://www.wowhead.com/spell=163689
-- Is the unit on burn list, set high prio, burn list is a list of mobs that we specify for burn, is highest dps and prio.
-- We should then look at the threat situation, for tanks the this is of high prio if we are below 3 but all below 3 should have the same prio coefficent. For dps its not that important
-- Then we should check HP of the targets and set highest prio on low targets, this is also something we need to think about if the target have a dot so it will die regardless or not. Should have a timetodie?


-- Stack: Interface\AddOns\BadBoy\System\EnemiesEngine.lua:224: in function `castInterupt'
-- burnTarget(unit) - Bool - True if we should burn that target according to burnUnitCandidates
-- safeToAttack(unit) - Bool - True if we can attack target according to doNotTouchUnitCandidates
-- getEnemies(unit,Radius) - Number - Returns number of valid units within radius of unit
-- castInterupt(spell,percent) - Multi-Target Interupts - for facing/in movements spells of all ranges.
-- makeEnemiesTable(55) - Triggered in badboy.lua - generate the enemiesTable
-- makeSpellCastersTable() - Makes an interupt table based on enemiesTable

-- burnUnitCandidates = List of UnitID/Names we should have highest prio on.
-- could declare more filters
burnUnitCandidates = {
	{ unitID = 71603 }, -- immersus ooze, kill on sight
	-- Shadowmoon Burial Grounds
	{ unitID = 75966 }, -- Defiled Spirit, need to be cc and snared and is not allowed to reach boss.
	{ unitID = 75899 }, -- Possessed Soul, 
	{ unitID = 76518 }, -- Ritual of Bones, marked one... Todo: Can we check if mobs is marked with skull?
	-- Auchindon
	{ unitID = 77812 }, -- Sargerei Souldbinder, cast a MC
	-- Grimrail Depot
	{ unitID = 80937 }, -- Gromkar Gunner
} 

-- doNotTouchUnitCandidates - List of units that we should not attack for any reason
-- can declare more filters: buff, debuff
doNotTouchUnitCandidates = { 
	-- Iron Docks
  	{ unitID = 87451, 	buff = 164504, spell = 164426 }, --Fleshrender Nok'gar, do not attack during defensive stance buff, Todo: Should stop when he cast 164504
  	{ unitID = 1, 		buff = 163689 }, -- Never attack Sanguine Sphere
}

crowdControlCandidates = {
	-- Shadowmoon Burial Grounds
	{ unitID = 75966, spell = 1 }, -- Defiled Spirit, need to be cc and snared and is not allowed to reach boss.
	{ unitID = 76446, spell = 1 }, -- Shadowmoon Enslavers
	{ unitID = 75899, spell = 1 }, -- Possessed Soul, only for melee i guess
	{ unitID = 79510, spell = 1 }, -- Crackling Pyromaniacs
	-- Grimrail Depot
	{ unitID = 81236, spell = 163966 }, -- Grimrail Technicians channeling Activating
	{ unitID = 80937, spell = 1 }, -- Gromkar Gunner


}

-- Units with spells that should be interrupted if possible. Good to have units so we can save interrupting spells when targeting them.
interruptCandidates = {
	-- Shadowmoon Burial Grounds
	{ unitID = 75652, spell = 152964 }, -- Void Spawn casting Void Pulse, trash mobs 
	{ unitID = 76446, spell = 156776 }, -- Shadowmoon Enslavers channeling Rending Voidlash
	{ unitID = 76104, spell = 156717 }, -- Monstrous Corpse Spider casting Death Venom
	--Auchindon
	{ unitID = 77812, spell = 154527 }, -- Bend Will, MC a friendly.
	{ unitID = 77131, spell = 154623 }, -- Void Mending
	{ unitID = 76263, spell = 157794 }, -- Arcane Bomb
	{ unitID = 86218, spell = 154415 }, -- Mind Spike
	{ unitID = 76284, spell = 154218 }, -- Arbiters Hammer
	{ unitID = 76296, spell = 154235 }, -- Arcane Bolt
	{ unitID = 79510, spell = 154221 }, -- Fel Blast
	{ unitID = 78437, spell = 156854 }, -- Drain Life
	{ unitID = 86330, spell = 156854 }, -- Drain Life, Terengor
	{ unitID = 86330, spell = 156857 }, -- Rain Of Fire
	{ unitID = 86330, spell = 164846 }, -- Chaos Bolt
	{ unitID = 86330, spell = 156963 }, -- Incenerate
	--Grimral Depot 
	{ unitID = 82579, spell = 166335 }, -- Storm Shield
} 

-- List of units that are hitting hard, ie when its good to use defensive CDs
dangerousUnits  = {
	-- Shadowmoon Burial Grounds
	{ unitID = 86234, buff = 162696, spell = 162696 }, -- Sadana buffed with deathspikes
	{ unitID = 75829, buff = 152792, spell = 152792 }, -- Nhallish casting Void Blast or buffed
	{ unitID = 86226, buff = 161092, spell = 1      }, -- Borkas unmanged Agression
	--{ unitID = 86226, buff = 1, 	 spell = 161089 }, -- Borkas Mad Dash, small CD Todo: We should add minor major values to this so we can determine if its a big CD or small to be used.
	-- Grimrail Depot
	{ unitID = 83775, buff = 178412, spell = 178412      }, -- Borkas unmanged Agression
	

} 

dispellOffensiveBuffs = {
		-- Auchindon
		160312, -- Void Shell
	

}

function makeEnemiesTable(maxDistance)
	local  maxDistance = maxDistance or 50
	if enemiesTable == nil or enemiesTableTimer == nil or enemiesTableTimer <= GetTime() - 1 then
		enemiesTableTimer = GetTime()
		-- create/empty table
		enemiesTable = { }
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
		  			local safeUnit = safeToAttack(thisUnit)
		  			local burnUnit = burnTarget(thisUnit)
		  			local unitName = UnitName(thisUnit)
	  				local unitThreat = UnitThreatSituation("player",thisUnit) or -1
	  				local unitCasting, unitCastLenght, unitCastTime, unitCanBeInterrupt, unitCastType = getCastingInfo(thisUnit)
	  				local X1, Y1, Z1 = ObjectPosition(thisUnit)
					local unitCoeficient = getUnitCoeficient(thisUnit,unitDistance,unitThreat) or 0
  					local unitHP = getHP(thisUnit)
  					local inCombat = UnitAffectingCombat(thisUnit)
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
   						playerFacing = getFacing("player",thisUnit),
   						threat = unitThreat, 
   						unit = thisUnit, 
   						distance = unitDistance, 
   						hp = unitHP, 
   						safe = safeUnit,
   						burn = burnUnit,
   						-- Here should track inc damage / healing as well in order to get a timetodie value
   						x = X1, y = Y1, z = Z1 
   						})
	   				end
			  	end
		 	end

		 	-- sort them by coeficient
		 	table.sort(enemiesTable, function(x,y)
	 		return x.coeficient and y.coeficient and x.coeficient > y.coeficient or false
	 	end)
	end
end

-- This function will set the prioritisation of the units, ie which target should i attack
function getUnitCoeficient(unit, distance, threat)
	local coef = 0

	-- if unit is out of range, bad prio(0)
	if distance < 40 then
		local unitHP = getHP(unit)
		-- safe check set to 0 if bad unit
		if isChecked("Safe Damage Check") then
			if safeToAttack(unit) ~= true then
				return 0
			end
		end

		-- if wise target checked, we look for best target by looking to the lowest or highest hp, otherwise we look for target
		if isChecked("Wise Target") ~= true then
			-- if its our actual target we give it a bonus
			if UnitGUID("target") == UnitGUID(unit) then
				coef = coef + 100
			end
		else
			if getValue("Wise Target") == 1 then
				-- if lowest is selected
				coef = 100 - unitHP  
			else
				-- if highest is selected
				coef = unitHP  
			end
		end

		-- if threat is checked, add 100 points of prio if we lost aggro on that target
		if isChecked("Tank Threat") then
			if select(6, GetSpecializationInfo(GetSpecialization())) == "TANK" and threat < 3 and unitHP > 10 then
				coef = coef + 100
			end
		end

		-- if user checked burn target then we check is unit should be burnt
		if isChecked("Forced Burn") then
			if burnTarget(unit) == true then
				coef = coef + 100
			end	
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
		return false, 250, 250, true, "nothing"
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
	local x1, y1, z1 = ObjectPosition(unit1)
	local x2, y2, z2 = enemiesTable[unit2].x, enemiesTable[unit2].y, enemiesTable[unit2].z
	return math.sqrt(((x2-x1)^2)+((y2-y1)^2)+((z2-z1)^2));
end

function getFacingXYZ(unit1,unit2)
	local angle1 = ObjectFacing(unit1)
	local y1,x1 = ObjectPosition(unit1)
    local y2,x2 = enemiesTable[unit2].y, enemiesTable[unit2].x
    if y1 and x1 and angle1 and y2 and x2 then
    	local angle2, angle3
        local deltaY = y2 - y1
        local deltaX = x2 - x1
        angle1 = math.deg(math.abs(angle1-math.pi*2))
        if deltaX > 0 then
            angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2)+math.pi)
        elseif deltaX <0 then
            angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2))
        end
        if angle2-angle1 > 180 then
        	angle3 = math.abs(angle2-angle1-360)
        else
        	angle3 = math.abs(angle2-angle1)
        end
        if angle3 < Degrees then 
        	return true 
        else 
        	return false
        end
    end
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
		if enemiesTable[i].cast.casting ~= false and enemiesTable[i].cast.canBeInterrupted == true then
		  	tinsert(spellCastersTable, { unit = enemiesTable[i].unit, castName = enemiesTable[i].cast.casting, 
		  	  castLenght = enemiesTable[i].cast.castLenght, castEnd = enemiesTable[i].cast.castTime, distance = enemiesTable[i].distance, })
		end
	end
end

-- function to compare spells to casting units
function castInterupt(spell,percent)
	if castersBlackList == nil then castersBlackList = { } end

	-- removing cause issues when removing many at once


	for i = 1, #castersBlackList do
		local j = #castersBlackList + 1 - i
		if castersBlackList[j].time ~= nil and castersBlackList[j].time < GetTime() - 0.5 then
			tremove(castersBlackList, j)
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

-- returns true if target should be burnt
function burnTarget(unit)
	for i = 1, #burnUnitCandidates do
		if getUnitID(unit) == burnUnitCandidates.unitID then
			-- add other conditions here
			return true
		end
	end
	return false
end

-- returns true if we can safely attack this target
function safeToAttack(unit)
	for i = 1, #doNotTouchUnitCandidates do
		-- holds candidate ID
		local candidateUnit = doNotTouchUnitCandidates[i].unitID
		-- we only scan units #s until we find a match
		if getUnitID(unit) == candidateUnit then

			--if condition is a buff
			local candidateBuff = doNotTouchUnitCandidates[i].buff
			if candidateBuff ~= nil then
				if UnitBuffID(unit,candidateBuff) ~= nil then
					return false
				end
			end

			-- if condition is a debuff
			local candidateDebuff = doNotTouchUnitCandidates[i].deBuff
			if candidateDebuff ~= nil then
				if UnitDebuffID(unit,candidateDebuff) ~= nil then
					return false
				end
			end
		end
	end
	-- if all went fine return true
	return true
end


-- a function to gather prefered target for dirrefent spells
function dynamicTarget(range,facing)
	for i = 1, #enemiesTable do
		if enemiesTable[i].distance < range and (facing == false or enemiesTable[i].facing == true) then
			return enemiesTable[i].unit
		end
	end
end

--if isLongTimeCCed("target") then
-- CCs with >=20 seconds
function isLongTimeCCed(Unit)
	if Unit == nil then return false; end
	local longTimeCC = {
		339,	-- Druid - Entangling Roots
		102359,	-- Druid - Mass Entanglement
		1499,	-- Hunter - Freezing Trap
		19386,	-- Hunter - Wyvern Sting
		118,	-- Mage - Polymorph
		115078,	-- Monk - Paralysis
		20066,	-- Paladin - Repentance
		10326,	-- Paladin - Turn Evil
		9484,	-- Priest - Shackle Undead
		605,	-- Priest - Dominate Mind
		6770,	-- Rogue - Sap
		2094,	-- Rogue - Blind
		51514,	-- Shaman - Hex
		710,	-- Warlock - Banish
		5782,	-- Warlock - Fear
		5484,	-- Warlock - Howl of Terror
		115268,	-- Warlock - Mesmerize
		6358,	-- Warlock - Seduction
	}
	for i=1, #longTimeCC do
		--local checkCC=longTimeCC[i]
		if UnitDebuffID(Unit, longTimeCC[i])~=nil then	
			return true
		end
	end
	return false
end



end

-- ToDo: Add list of units to stun, either always or udner certain condition such as having a buff or wirldwinding etc
-- ToDo: We need to think about if the target have a dot so it will die regardless or not. Should have a timetodie.