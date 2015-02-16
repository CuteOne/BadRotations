function bb.matchUnit(unit,table)
  for i = 1,#table do
    local guid = unit.guid
    if table[i].guid == guid then
      bb.read.enraged.unit = table[i]
      return table[i]
    end
  end
end
-- function to compare spells to casting units
-- /run bb.castOffensiveDispel(19801)
function bb.castOffensiveDispel(spell)
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
    for i = 1, #bb.read.enraged do
      if bb.read.enraged[i] ~= nil then
        -- if i still dont know which unit it is compared to my fh units, find it.
        local thisUnit = bb.read.enraged[i].unit
        if thisUnit == nil then
          thisUnit = bb.matchUnit(bb.read.enraged[i],enemiesTable)
        end
        if thisUnit ~= nil then
          if GetObjectExists(thisUnit.unit) then
            --if selectedMode == 4 or isSelectedTarget(thisUnit.unit) then
            if getDistance("player",thisUnit.unit) < allowedDistance then
              if castSpell(thisUnit.unit,spell,false,false) then
                --print("Cast Dispel "..thisUnit.name.." with "..spell)
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
    if GetObjectExists(thisUnit.unit) then
      if thisUnit.distance <= spellDistance and thisUnit.offensiveBuff == true then
        if castSpell(thisUnit.unit,spell,false,false) then
          bb:debug("Dispelled "..thisUnit.name.. " using "..spellName)
          return true
        end
      end
    end
  end
end
