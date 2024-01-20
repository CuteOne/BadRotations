local _, br = ...
local sqrt, abs, atan, deg, tan = math.sqrt, math.abs, math.atan, math.deg, math.tan
local testSpell = {
    ["WARRIOR"] = 6552,
    ["PALADIN"] = 35395,
    ["ROGUE"] = 1766,
    ["DEATHKNIGHT"] = 49998,
    ["MONK"] = 100780,
    ["SHAMAN"] = 73899,
    ["DRUIDC"] = 5221,
    ["DRUIDB"] = 33917,
    ["DHH"] = 162794,
    ["DHV"] = 214743,
    ["SHUNTER"] = 186270
}

function br.getDistance(Unit1,Unit2,option)
    if Unit2 == nil then
        Unit2 = Unit1
        Unit1 = "player"
    end
    if br.units ~= nil then
        if (Unit1 == "player" and br.units[br._G.ObjectPointer(Unit2)] ~= nil) then
            return br.units[br._G.ObjectPointer(Unit2)].range
        end
        if (br.units[br._G.ObjectPointer(Unit1)] ~= nil and Unit2 == "player") then
            return br.units[br._G.ObjectPointer(Unit1)].range
        end
        -- local thisUnit = Unit1 == "player" and br.units[br._G.ObjectPointer(Unit2)] or br.units[br._G.ObjectPointer(Unit1)]
        -- if thisUnit ~= nil then return thisUnit.range end
    end
    return br.getDistanceCalc(Unit1,Unit2,option)
end
function br.getDistanceCalc(Unit1,Unit2,option)
    local currentDist = 100
    local meleeSpell = nil
    local playerClass = select(2,br._G.UnitClass("player"))
    local playerSpec = br._G.GetSpecializationInfo(br._G.GetSpecialization())
    if testSpell[playerClass] ~= nil then
        meleeSpell = testSpell[playerClass]
    elseif playerClass == "DRUID" and br.UnitBuffID("player",768) then
        meleeSpell = testSpell["DRUIDC"]
    elseif playerClass == "DRUID" and br.UnitBuffID("player",5487) then
        meleeSpell = testSpell["DRUIDB"]
    elseif playerSpec == 255 then
        meleeSpell = testSpell["SHUNTER"]
    elseif playerSpec == 263 then
        meleeSpell = testSpell["SHAMAN"]
    elseif playerSpec == 577 then
        meleeSpell = testSpell["DHH"]
    elseif playerSpec == 581 then
        meleeSpell = testSpell["DHV"]
    end
    -- If Unit2 is nil we compare player to Unit1
    if Unit2 == nil then
        Unit2 = Unit1
        Unit1 = "player"
    end
    if Unit1 == nil or Unit2 == nil then return 100 end
    if option == nil then option = "none" end
    -- Check if objects exists and are visible
    if (br.GetUnitIsUnit(Unit1,"player") or (br.GetObjectExists(Unit1) and br.GetUnitIsVisible(Unit1) == true))
        and (br.GetUnitIsUnit(Unit2,"player") or (br.GetObjectExists(Unit2) and br.GetUnitIsVisible(Unit2) == true))
    then
        -- If melee spell is usable, ignore all other calcs
        if meleeSpell ~= nil then
            if Unit2 == "player" then
                if br._G.IsSpellInRange(select(1,br._G.GetSpellInfo(meleeSpell)),Unit1) == 1 then
                    return 0
                end
            else
                if br._G.IsSpellInRange(select(1,br._G.GetSpellInfo(meleeSpell)),Unit2) == 1 then
                    return 0
                end
            end
        end
        local rangeMod = 0
        --See if we already have a position, else get position
        local X1,Y1,Z1,X2,Y2,Z2 = 0,0,0,0,0,0
        -- if not string.find(Unit1,"0x") then Unit1 = br._G.GetObjectWithGUID(br._G.UnitGUID(Unit1)) end
        -- if not string.find(Unit2,"0x") then Unit2 = br._G.GetObjectWithGUID(br._G.UnitGUID(Unit2)) end
        --Unit1 Position
        local unit1GUID = select(2,br.getGUID(Unit1))
        if br.unitSetup ~= nil and br.unitSetup.cache[Unit1] ~= nil and br.unitSetup.cache[Unit1].posX ~= nil then
          X1,Y1,Z1 = br.unitSetup.cache[Unit1].posX, br.unitSetup.cache[Unit1].posY, br.unitSetup.cache[Unit1].posZ
        elseif br.GetUnitIsUnit(Unit1,"player") and br.player ~= nil and br.player.posX ~= nil then
          X1,Y1,Z1 = br.player.posX, br.player.posY, br.player.posZ
        elseif br.isChecked("HE Active") and br.memberSetup ~= nil and br.memberSetup.cache[unit1GUID] ~= nil and br.memberSetup.cache[unit1GUID].x ~= nil then
          X1,Y1,Z1 = br.memberSetup.cache[unit1GUID].x, br.memberSetup.cache[unit1GUID].y, br.memberSetup.cache[unit1GUID].z
        else
          X1,Y1,Z1 = br.GetObjectPosition(Unit1)
        end
        if not X1 then return 999 end
        --Unit2 Position
        local unit2GUID = select(2,br.getGUID(Unit2))
        if br.unitSetup ~= nil and br.unitSetup.cache[Unit2] ~= nil and br.unitSetup.cache[Unit2].posX ~= nil then
          X2,Y2,Z2 = br.unitSetup.cache[Unit2].posX, br.unitSetup.cache[Unit2].posY, br.unitSetup.cache[Unit2].posZ
        elseif br.GetUnitIsUnit(Unit2,"player") and br.player ~= nil and br.player.posX ~= nil then
          X2,Y2,Z2 = br.player.posX, br.player.posY, br.player.posZ
        elseif br.isChecked("HE Active") and br.memberSetup ~= nil and br.memberSetup.cache[unit2GUID] ~= nil and br.memberSetup.cache[unit2GUID].x ~= nil then
          X2,Y2,Z2 = br.memberSetup.cache[unit2GUID].x, br.memberSetup.cache[unit2GUID].y, br.memberSetup.cache[unit2GUID].z
        else
          X2,Y2,Z2 = br.GetObjectPosition(Unit2)
        end
        if not X2 then return 999 end
        -- Melee Range Bypass
        if br.player ~= nil then
            -- Modifier for Balance Affinity range change (Druid - Not Balance)
            if br.player.talent.astralInfluence ~= nil then
                if br.player.talent.astralInfluence and option ~= "noMod" then
                    rangeMod = br.player.talent.rank.astralInfluence == 1 and 1 or 3
                end
            end
        end
        -- Get the distance
        local TargetCombatReach = br._G.UnitCombatReach(Unit2) or 0
        local PlayerCombatReach = br._G.UnitCombatReach(Unit1) or 0
        local MeleeCombatReachConstant = 7/3
        local IfSourceAndTargetAreRunning = 0
        if br.isMoving(Unit1) and br.isMoving(Unit2) then IfSourceAndTargetAreRunning = 8/3 end
        -- Rogue Melee Range Increase Mod
        if br.player ~= nil then
            if br.player.talent.acrobaticStrikes ~= nil and meleeSpell ~= nil then
                if br.player.talent.acrobaticStrikes and option ~= "noMod" and br._G.IsSpellInRange(select(1,br._G.GetSpellInfo(meleeSpell)),Unit2) == 1 then
                    rangeMod = 3
                end
            end
        end
        local dist = sqrt(((X2-X1)^2) + ((Y2-Y1)^2) + ((Z2-Z1)^2)) - (PlayerCombatReach + TargetCombatReach) - rangeMod
        local dist2 = dist + 0.03 * ((13 - dist) / 0.13)
        local dist3 = dist + 0.05 * ((8 - dist) / 0.15) + 1
        local dist4 = dist + (PlayerCombatReach + TargetCombatReach)
        local meleeRange = br._G.max(6, PlayerCombatReach + TargetCombatReach + MeleeCombatReachConstant + IfSourceAndTargetAreRunning)
        if option == "dist" then return dist end
        if option == "dist2" then return dist2 end
        if option == "dist3" then return dist3 end
        if option == "dist4" then return dist4 end
        if option == "meleeRange" then return meleeRange end
        -- if (br._G.UnitIsUnit("target",Unit1) or br._G.UnitIsUnit("target",Unit2)) then
        --     br._G.print("Dist: "..tostring(br.round2(dist,0)))
        -- end
        -- if dist > 13 then
            currentDist = br._G.max(0,dist)
        -- elseif dist2 > 8 and dist3 > 8 then
        --     currentDist = dist2
        -- elseif dist3 > 5 and dist4 > 5 then
        --     currentDist = dist3
        -- elseif dist4 > meleeRange then -- Thanks Ssateneth
        --     currentDist = dist4
        -- else
        --     currentDist = 0
        -- end
        -- Modifier for Mastery: Sniper Training (Hunter - Marksmanship)
        -- if currentDist < 100 and br.isKnown(193468) and option ~= "noMod" and (Unit1 == "player" or Unit2 == "player") then
        --     currentDist = currentDist - (currentDist * (GetMasteryEffect() / 100))
        -- end
    end
    return currentDist
end
function br.isInRange(spellID,unit)
	return br._G.LibStub("SpellRange-1.0").IsSpellInRange(spellID,unit)
end
function br.getDistanceToLocation(Unit1,X2,Y2,Z2)
	if Unit1 == nil then
		Unit1 = "player"
	end
	if br.GetObjectExists(Unit1) and br.GetUnitIsVisible(Unit1) then
		local X1,Y1,Z1 = br.GetObjectPosition(Unit1)
		return sqrt(((X2-X1)^2) + ((Y2-Y1)^2) + ((Z2-Z1)^2))
	else
		return 100
	end
end

function br.getFacingDistance()
    if br.GetUnitIsVisible("player") and br.GetUnitIsVisible("target") then
        --local targetDistance = getRealDistance("target")
        local targetDistance = br.getDistance("target")
        local Y1,X1 = br.GetObjectPosition("player");
        local Y2,X2 = br.GetObjectPosition("target");
        local angle1 = br.GetObjectFacing("player")
        local angle2
        local deltaY = Y2 - Y1
        local deltaX = X2 - X1
        angle1 = deg(abs(angle1-math.pi*2))
        if deltaX > 0 then
            angle2 = deg(atan(deltaY/deltaX)+(math.pi/2)+math.pi)
        elseif deltaX <0 then
            angle2 = deg(atan(deltaY/deltaX)+(math.pi/2))
        end
        local Dist = br.round2(math.tan(abs(angle2 - angle1)*math.pi/180)*targetDistance*10000)/10000
        if br._G.ObjectIsFacing("player","target") then
            return Dist
        else
            return -(abs(Dist))
        end
    else
        return 1000
    end
end
-- /dump getTotemDistance("target")
function br.getTotemDistance(Unit1)
  if Unit1 == nil then
    Unit1 = "player"
  end

  if br.GetUnitIsVisible(Unit1) then
    -- local objectCount = GetObjectCountBR() or 0
    local X2, Y2, Z2
    for i = 1,br._G.GetObjectCount() do
      if br.GetUnitIsUnit(br._G.UnitCreator(br._G.GetObjectWithIndex(i)), "Player") and (br._G.UnitName(br._G.GetObjectWithIndex(i)) == "Searing Totem" or br._G.UnitName(br._G.GetObjectWithIndex(i)) == "Magma Totem") then
        X2,Y2,Z2 = br.GetObjectPosition(br._G.GetObjectWithIndex(i))
      end
    end
    local X1,Y1,Z1 = br.GetObjectPosition(Unit1)
    local totemDistance = sqrt(((X2-X1)^2)+((Y2-Y1)^2)+((Z2-Z1)^2))
    --Print(TotemDistance)
    return totemDistance
  else
    return 0
  end
end
-- if isInMelee() then
function br.isInMelee(Unit)
  if Unit == nil then
    Unit = "target"
  end
  if br.getDistance(Unit) < 4 then
    return true
  else
    return false
  end
end

function br.isSafeToAoE(spellID,Unit,effectRng,minUnits,aoeType, enemies)
    if not br.isChecked("Safe Damage Check") then return true end
    local enemiesValid, enemiesAll
    local maxRange = select(6,br._G.GetSpellInfo(spellID))
    if effectRng == nil then effectRng = 5 end
    if maxRange == nil or maxRange == 0 then maxRange = tonumber(effectRng) effectRng = 8 else maxRange = tonumber(maxRange) end
    if minUnits == nil then minUnits = 1 end
    if aoeType == "rect" then
        enemiesValid    = br.getEnemiesInRect(effectRng,maxRange,false)
        enemiesAll      = not enemies and br.getEnemiesInRect(effectRng,maxRange,false,true) or enemies
    elseif aoeType == "cone" then
        enemiesValid    = br.getEnemiesInCone(180,effectRng,false)
        enemiesAll      = not enemies and br.getEnemiesInCone(180,effectRng,false,true) or enemies
    else
        enemiesValid    = #br.getEnemies(Unit,effectRng)
        enemiesAll      = not enemies and #br.getEnemies(Unit,effectRng,true) or enemies
    end
    return enemiesValid >= minUnits and enemiesValid >= enemiesAll
end

function br.inRange(spellID,unit)
    local spellName = br._G.GetSpellInfo(spellID)
    if unit == nil then unit = "target" end
    local inRange = br._G.IsSpellInRange(spellName,unit)
    if inRange ~= nil then
        return br._G.IsSpellInRange(spellName,unit) == 1
    else
        return false
    end
end

function br.getBaseDistance(unit1, unit2)
    if unit2 == nil then
        unit2 = "player"
    end
    local x1, y1, z1 = br._G.ObjectPosition(unit1)
    local x2, y2, z2 = br._G.ObjectPosition(unit2)
    return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2)) -
        ((br._G.UnitCombatReach(unit1) or 0) + (br._G.UnitCombatReach(unit2) or 0)), z2 - z1
end