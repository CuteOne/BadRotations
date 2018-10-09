function br.matchUnit(unit,table)
	for i = 1,#table do
		local guid = unit.guid
		if table[i].guid == guid then
			br.read.enraged.unit = table[i]
			return table[i]
		end
	end
end
-- function to compare spells to casting units
-- /run br.castOffensiveDispel(19801)
function br.castOffensiveDispel(spell)
	-- first make sure we will be able to cast the spell
	if isChecked("Enrages Handler") and canCast(spell,false,false) == true then
		-- ToDo if the user sets its selector to target, only interupt current target.
		-- ToDo:this is ugly...
		selectedMode,selectedTargets = getOptionValue("Enrages Handler"),{ }
		if selectedMode == 1 then
			selectedTargets = { "target" }
		elseif selectedMode == 2 then
			selectedTargets = { "target","mouseover","focus" }
		elseif selectedMode == 3 then
			selectedTargets = { "target","mouseover" }
		end
		-- make sure we cover melee range
		local allowedDistance = select(6,GetSpellInfo(spell))
		if allowedDistance < 5 then
			allowedDistance = 5
		end
		for i = 1, #br.read.enraged do
			if br.read.enraged[i] ~= nil then
				-- if i still dont know which unit it is compared to my fh units, find it.
				local thisUnit = br.read.enraged[i].unit
				if thisUnit == nil then
					thisUnit = br.matchUnit(br.read.enraged[i],br.enemy)
				end
				if thisUnit ~= nil then
					if GetObjectExists(thisUnit.unit) then
						--if selectedMode == 4 or isSelectedTarget(thisUnit.unit) then
						if getDistance("player",thisUnit.unit) < allowedDistance then
							if castSpell(thisUnit.unit,spell,false,false) then
								--Print("Cast Dispel "..thisUnit.name.." with "..spell)
								return true
							end
						end
						--end
					end
				end
			end
		end
	end
	return false
end
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
		for k, v in pairs(br.enemy) do
			-- check if unit is valid
			if GetObjectExists(br.enemy[k].unit) then
				-- if this unit is a cc candidate and is in range
				if br.enemy[k].cc == true and br.enemy[k].distance < spellDistance then
					-- cast the spell
					if castSpell(br.enemy[k].unit,SpellID,true,false) then
						return true
					end
				end
			end
		end
	else
		-- check if unit is valid
		if GetObjectExists(Unit) then
			-- if param target isnt "any", do our chwecks on requested unit.
			if isCrowdControlCandidates(Unit) == true and getDistance("player",Unit) < spellDistance then
				-- cast on that unit
				if castSpell(Unit,SpellID,true,false) then
					return true
				end
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
		for k, v in pairs(br.enemy) do
			local thisUnit = br.enemy[k]
			-- check if unit is valid
			if GetObjectExists(thisUnit.unit) then
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
	for k, v in pairs(br.enemy) do
		local thisUnit = br.enemy[k]
		if GetObjectExists(thisUnit.unit) then
			if thisUnit.distance <= spellDistance and thisUnit.offensiveBuff == true then
				if castSpell(thisUnit.unit,spell,false,false) then
					br:debug("Dispelled "..thisUnit.name.. " using "..spellName)
					return true
				end
			end
		end
	end
end
--[[-- Cone Logic for Enemies
function getEnemiesInCone(length,angle)
    local playerX, playerY, playerZ = GetObjectPosition("player")
    local facing = ObjectFacing("player")
    local units = 0
    local enemiesTable = getEnemies("player",length)

    for i = 1, #enemiesTable do
        local thisUnit = enemiesTable[i]
        if not GetUnitIsUnit(thisUnit,"player") and (isDummy(thisUnit) or UnitIsEnemy(thisUnit,"player")) then
            local unitX, unitY, unitZ = GetObjectPosition(thisUnit)
            if playerX and unitX then
                local angleToUnit = getAngles(playerX,playerY,playerZ,unitX,unitY,unitZ)
                local angleDifference = facing > angleToUnit and facing - angleToUnit or angleToUnit - facing
                local shortestAngle = angleDifference < math.pi and angleDifference or math.pi*2 - angleDifference
                local finalAngle = shortestAngle/math.pi*180
                if finalAngle < angle then
                    units = units + 1
                end
            end
        end
    end
    return units
end--]]

-- Percentage of enemies that are not in execute HP range
function getNonExecuteEnemiesPercent(executeHP)
    local executeCount = 0
    local nonexecuteCount = 0
    local nonexecutePercent = 0

	for k, v in pairs(br.enemy) do
		local thisUnit = br.enemy[k]
        if GetObjectExists(thisUnit.unit) then
            if getHP(thisUnit) < executeHP then
                executeCount = executeCount + 1
            else
                nonexecuteCount = nonexecuteCount + 1
            end
        end
    end
    local divisor = executeCount + nonexecuteCount
    if divisor > 0 then
        nonexecutePercent = nonexecuteCount / divisor
    end
    return nonexecutePercent
end
