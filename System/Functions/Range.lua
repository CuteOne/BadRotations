local _, br = ...
---@class br.functions.range
br.functions.range = br.functions.range or {}
local range = br.functions.range
local sqrt, abs, atan, deg = math.sqrt, math.abs, math.atan, math.deg

-- The player's class, and per melee spell list (br.lists.range.meleeSpells) the name of the first spell
-- the player knows, or false. Kept until the spellbook or spec changes (invalidateMeleeSpellCache).
local playerClass = nil

local meleeSpellNames = {}

-- The melee spell list (br.lists.range.meleeSpells) for the player now: the class's, a Druid's by form
-- (Bear or Cat; none in caster form, where neither form's spells can be cast)
local function meleeListKey()
    if playerClass == nil then playerClass = select(2, br._G.UnitClass("player")) end
    if playerClass ~= "DRUID" then return playerClass end
    local bearForm = br.functions.spell:getHighestSpellID("bearForm")
    if bearForm and br.functions.aura:UnitBuffID("player", bearForm) then return "DRUID_BEAR" end
    local catForm = br.functions.spell:getHighestSpellID("catForm")
    if catForm and br.functions.aura:UnitBuffID("player", catForm) then return "DRUID_CAT" end
    return nil
end

-- Exact range rules, as the game's server applies them (see the comment above range:getEdgeDistance)
local DEFAULT_COMBAT_REACH = 1.5   -- a player's combat reach when the unit's can't be read
local MELEE_OFFSET = 4 / 3          -- added to both combat reaches for melee
local MELEE_MINIMUM = 5             -- melee reach is never less than this
local LEEWAY = 8 / 3                -- extra reach while both units run
local LEEWAY_MIN_SPEED = 4.97       -- faster than walking

local function resolveMeleeSpellName(listKey)
    local known = meleeSpellNames[listKey]
    if known ~= nil then return known or nil end
    local name = false
    local keys = br.lists.range.meleeSpells[listKey]
    for i = 1, keys and #keys or 0 do
        local spellID = br.functions.spell:getHighestSpellID(keys[i])
        if spellID and br.functions.spell:isKnown(spellID) then
            name = br.functions.spell:getName(spellID) or false
            break
        end
    end
    -- Only once the player's spells are compiled: before that the class lists may not be loaded
    if br.player and br.player.spells then meleeSpellNames[listKey] = name end
    return name or nil
end

-- How the game measures range. The server checks distances between unit centres and allows for each
-- unit's combat reach (its hitbox radius), differently per kind of check. TrinityCore, CMaNGOS Classic
-- and AzerothCore agree on these rules:
--   * Spell range:  centre distance (3D) <= range + both combat reaches  -> edge distance <= range
--   * Melee:        centre distance (3D) <= max(5, both combat reaches + 4/3); the spell's range isn't used
--   * AoE:          a unit is hit when its centre is within radius + its own combat reach of the AoE's
--                   centre (the caster's reach doesn't count); 2D, and the height difference within radius
--   * Running:      melee (and spells on players) get 8/3 yd more while both units run
-- One distance number can't serve all three, which is why these are separate functions.

-- The unit's combat reach (hitbox radius) used in range checks.
function range:getCombatReach(unit)
    local reach = unit and br._G.UnitCombatReach(unit)
    return (reach and reach > 0) and reach or DEFAULT_COMBAT_REACH
end

-- Distance between two units' centres: 3D, 2D and the height difference; nil when either has no position.
function range:getCenterDistance(unit1, unit2)
    local x1, y1, z1 = br.functions.unit:GetObjectPosition(unit1)
    local x2, y2, z2 = br.functions.unit:GetObjectPosition(unit2)
    if x1 == nil or x2 == nil then return nil end
    local dx, dy, dz = x2 - x1, y2 - y1, z2 - z1
    local flat = dx * dx + dy * dy
    return sqrt(flat + dz * dz), sqrt(flat), dz
end

-- Edge-to-edge distance between two units: what a spell's range is compared with (in range when this is
-- no more than the spell's range). nil when either has no position.
-- if br.functions.range:getEdgeDistance("player", "target") <= 30 then
function range:getEdgeDistance(unit1, unit2)
    local centre = range:getCenterDistance(unit1, unit2)
    if centre == nil then return nil end
    return math.max(0, centre - range:getCombatReach(unit1) - range:getCombatReach(unit2))
end

-- The extra reach both units running gives: 8/3 yd when both move faster than a walk, else 0.
function range:getLeeway(unit1, unit2)
    local speed1, speed2 = br._G.GetUnitSpeed(unit1) or 0, br._G.GetUnitSpeed(unit2) or 0
    return (speed1 > LEEWAY_MIN_SPEED and speed2 > LEEWAY_MIN_SPEED) and LEEWAY or 0
end

-- How far apart two units' centres can be for melee: max(5, both combat reaches + 4/3), plus the
-- running leeway.
function range:getMeleeReach(unit1, unit2)
    return math.max(MELEE_MINIMUM, range:getCombatReach(unit1) + range:getCombatReach(unit2) + MELEE_OFFSET)
        + range:getLeeway(unit1, unit2)
end

-- True when the two units are in melee range of each other.
-- if br.functions.range:isInMelee("player", "target") then
function range:isInMelee(unit1, unit2)
    local centre = range:getCenterDistance(unit1, unit2)
    return centre ~= nil and centre <= range:getMeleeReach(unit1, unit2)
end

-- How far a unit is from an AoE's centre, as the AoE sees it: the 2D distance from the centre unit to
-- the unit's centre, less the unit's combat reach. A radius-R AoE hits it when this is no more than R
-- (and the height difference is within R; heightDiff is returned for that). nil without positions.
-- local d, dz = br.functions.range:getAoEDistance("player", thisUnit); if d <= 8 and math.abs(dz) <= 8 then
function range:getAoEDistance(centreUnit, unit)
    local _, flat, dz = range:getCenterDistance(centreUnit, unit)
    if flat == nil then return nil end
    return math.max(0, flat - range:getCombatReach(unit)), dz
end

-- The name of the spell the game is asked "is it in melee range" with (br.lists.range.meleeSpells: the
-- first known spell of the class's list, a Druid's by form), or nil.
function range:getMeleeSpellName()
    local listKey = meleeListKey()
    if br.lists.range.meleeSpells[listKey] == nil then return nil end
    return resolveMeleeSpellName(listKey)
end

function range:getDistance(Unit1, Unit2, option)
    if Unit2 == nil then
        Unit2 = Unit1
        Unit1 = "player"
    end
    -- if br.engines.enemiesEngine.units ~= nil then
    --     if (Unit1 == "player" and br.engines.enemiesEngine.units[br._G.ObjectPointer(Unit2)] ~= nil) then
    --         return br.engines.enemiesEngine.units[br._G.ObjectPointer(Unit2)].range
    --     end
    --     if (br.engines.enemiesEngine.units[br._G.ObjectPointer(Unit1)] ~= nil and Unit2 == "player") then
    --         return br.engines.enemiesEngine.units[br._G.ObjectPointer(Unit1)].range
    --     end
    --     local thisUnit = Unit1 == "player" and br.engines.enemiesEngine.units[br._G.ObjectPointer(Unit2)] or
    --         br.engines.enemiesEngine.units[br._G.ObjectPointer(Unit1)]
    --     if thisUnit ~= nil then return thisUnit.range end
    -- end
    return range:getDistanceCalc(Unit1, Unit2, option)
end

function range:getDistanceCalc(Unit1, Unit2, option)
    local currentDist = 100
    local hasMeleeList = br.lists.range.meleeSpells[meleeListKey()] ~= nil
    local meleeSpellName = range:getMeleeSpellName()
    -- If Unit2 is nil we compare player to Unit1
    if Unit2 == nil then
        Unit2 = Unit1
        Unit1 = "player"
    end
    if Unit1 == nil or Unit2 == nil then return 100 end
    local _ok1, _isSame1 = pcall(function() return Unit1 == Unit2 or br._G.UnitIsUnit(Unit1, Unit2) end)
    if _ok1 and _isSame1 then return 0 end
    if option == nil then option = "none" end
    -- Check if objects exists and are visible
    if (br.functions.unit:GetUnitIsUnit(Unit1, "player") or (br.functions.unit:GetObjectExists(Unit1) and br.functions.unit:GetUnitIsVisible(Unit1) == true))
        and (br.functions.unit:GetUnitIsUnit(Unit2, "player") or (br.functions.unit:GetObjectExists(Unit2) and br.functions.unit:GetUnitIsVisible(Unit2) == true))
    then
        -- If melee spell is in range, return 0 (accurate melee range detection)
        if meleeSpellName ~= nil then
            if br._G.UnitIsUnit(Unit2, "player") and not br._G.UnitIsUnit(Unit1, "player") then
                if br._G.C_Spell.IsSpellInRange(meleeSpellName, Unit1) == true then
                    return 0
                end
            end
            if br._G.UnitIsUnit(Unit1, "player") and not br._G.UnitIsUnit(Unit2, "player") then
                if br._G.C_Spell.IsSpellInRange(meleeSpellName, Unit2) == true then
                    return 0
                end
            end
        end
        local rangeMod = 0
        --See if we already have a position, else get position
        local X1, Y1, Z1, X2, Y2, Z2 = 0, 0, 0, 0, 0, 0
        -- if not string.find(Unit1,"0x") then Unit1 = br._G.GetObjectWithGUID(br._G.UnitGUID(Unit1)) end
        -- if not string.find(Unit2,"0x") then Unit2 = br._G.GetObjectWithGUID(br._G.UnitGUID(Unit2)) end
        --Unit1 Position
        local unit1GUID = select(2, br.functions.unit:getGUID(Unit1))
        local _p1ok = pcall(function()
            if br.engines.enemiesEngine ~= nil and br.engines.enemiesEngine.records[Unit1] ~= nil and br.engines.enemiesEngine.records[Unit1].posX ~= nil then
                X1, Y1, Z1 = br.engines.enemiesEngine.records[Unit1].posX, br.engines.enemiesEngine.records[Unit1].posY, br.engines.enemiesEngine.records[Unit1].posZ
            elseif br.functions.unit:GetUnitIsUnit(Unit1, "player") and br.player ~= nil and br.player.state.posX ~= nil then
                X1, Y1, Z1 = br.player.state.posX, br.player.state.posY, br.player.state.posZ
            elseif br.functions.misc:isChecked("HE Active") and br.engines.healingEngine.memberSetup ~= nil and br.engines.healingEngine.memberSetup.cache[unit1GUID] ~= nil and br.engines.healingEngine.memberSetup.cache[unit1GUID].x ~= nil then
                X1, Y1, Z1 = br.engines.healingEngine.memberSetup.cache[unit1GUID].x, br.engines.healingEngine.memberSetup.cache[unit1GUID].y,
                    br.engines.healingEngine.memberSetup.cache[unit1GUID].z
            else
                X1, Y1, Z1 = br.functions.unit:GetObjectPosition(Unit1)
            end
        end)
        if not _p1ok then X1, Y1, Z1 = br.functions.unit:GetObjectPosition(Unit1) end
        if not X1 then return 999 end
        --Unit2 Position
        local unit2GUID = select(2, br.functions.unit:getGUID(Unit2))
        local _p2ok = pcall(function()
            if br.engines.enemiesEngine ~= nil and br.engines.enemiesEngine.records[Unit2] ~= nil and br.engines.enemiesEngine.records[Unit2].posX ~= nil then
                X2, Y2, Z2 = br.engines.enemiesEngine.records[Unit2].posX, br.engines.enemiesEngine.records[Unit2].posY, br.engines.enemiesEngine.records[Unit2].posZ
            elseif br.functions.unit:GetUnitIsUnit(Unit2, "player") and br.player ~= nil and br.player.state.posX ~= nil then
                X2, Y2, Z2 = br.player.state.posX, br.player.state.posY, br.player.state.posZ
            elseif br.functions.misc:isChecked("HE Active") and br.engines.healingEngine.memberSetup ~= nil and br.engines.healingEngine.memberSetup.cache[unit2GUID] ~= nil and br.engines.healingEngine.memberSetup.cache[unit2GUID].x ~= nil then
                X2, Y2, Z2 = br.engines.healingEngine.memberSetup.cache[unit2GUID].x, br.engines.healingEngine.memberSetup.cache[unit2GUID].y,
                    br.engines.healingEngine.memberSetup.cache[unit2GUID].z
            else
                X2, Y2, Z2 = br.functions.unit:GetObjectPosition(Unit2)
            end
        end)
        if not _p2ok then X2, Y2, Z2 = br.functions.unit:GetObjectPosition(Unit2) end
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
        local MeleeCombatReachConstant = 7 / 3
        local IfSourceAndTargetAreRunning = 0
        if br.functions.misc:isMoving(Unit1) and br.functions.misc:isMoving(Unit2) then IfSourceAndTargetAreRunning = 8 / 3 end

        -- Classic/TBC fallback: determine melee range from positions alone.
        -- Uses the same constants as the meleeRange calculation below.
        if not br.api.hasSubSpecs and hasMeleeList and (br._G.UnitIsUnit(Unit1, "player") or br._G.UnitIsUnit(Unit2, "player")) then
            local edgeToEdge = sqrt(((X2 - X1) ^ 2) + ((Y2 - Y1) ^ 2) + ((Z2 - Z1) ^ 2)) - (PlayerCombatReach + TargetCombatReach)
            local meleeEdgeDistance = MeleeCombatReachConstant + IfSourceAndTargetAreRunning + rangeMod
            if edgeToEdge <= meleeEdgeDistance then
                return 0
            end
        end
        -- Rogue Melee Range Increase Mod
        if br.player ~= nil then
            if br.player.talent.acrobaticStrikes ~= nil and meleeSpellName ~= nil then
                if br.player.talent.acrobaticStrikes and option ~= "noMod" and br._G.C_Spell.IsSpellInRange(meleeSpellName, Unit2) == true then
                    rangeMod = 3
                end
            end
        end
        local dist = sqrt(((X2 - X1) ^ 2) + ((Y2 - Y1) ^ 2) + ((Z2 - Z1) ^ 2)) - (PlayerCombatReach + TargetCombatReach) -
            rangeMod
        local dist2 = dist + 0.03 * ((13 - dist) / 0.13)
        local dist3 = dist + 0.05 * ((8 - dist) / 0.15) --+ 1
        local dist4 = dist + (PlayerCombatReach + TargetCombatReach)
        local meleeRange = br._G.max(6,
            PlayerCombatReach + TargetCombatReach + MeleeCombatReachConstant + IfSourceAndTargetAreRunning)
        if option == "dist" then return dist end
        if option == "dist2" then return dist2 end
        if option == "dist3" then return dist3 end
        if option == "dist4" then return dist4 end
        if option == "meleeRange" then return meleeRange end
        -- currentDist = br._G.max(dist, meleeRange, 0)
        if dist > 13 then
            currentDist = br._G.max(0, dist)
        elseif dist2 > 8 and dist3 > 8 then
            currentDist = dist2
        elseif dist3 > 5 and dist4 > 5 then
            currentDist = dist3
        elseif dist4 > meleeRange then -- Thanks Ssateneth
            currentDist = dist4
        else
            currentDist = 5
        end
        -- Modifier for Mastery: Sniper Training (Hunter - Marksmanship)
        -- if currentDist < 100 and br.functions.spell:isKnown(193468) and option ~= "noMod" and (Unit1 == "player" or Unit2 == "player") then
        --     currentDist = currentDist - (currentDist * (GetMasteryEffect() / 100))
        -- end
    end
    return currentDist
end

function range:getFacingDistance()
    if br.functions.unit:GetUnitIsVisible("player") and br.functions.unit:GetUnitIsVisible("target") then
        --local targetDistance = getRealDistance("target")
        local targetDistance = br.functions.range:getDistance("target")
        local Y1, X1 = br.functions.unit:GetObjectPosition("player");
        local Y2, X2 = br.functions.unit:GetObjectPosition("target");
        local angle1 = br.functions.unit:GetObjectFacing("player")
        local angle2
        local deltaY = Y2 - Y1
        local deltaX = X2 - X1
        angle1 = deg(abs(angle1 - math.pi * 2))
        if deltaX > 0 then
            angle2 = deg(atan(deltaY / deltaX) + (math.pi / 2) + math.pi)
        elseif deltaX < 0 then
            angle2 = deg(atan(deltaY / deltaX) + (math.pi / 2))
        end
        local Dist = br.functions.misc:round2(math.tan(abs(angle2 - angle1) * math.pi / 180) * targetDistance * 10000) / 10000
        if br._G.ObjectIsFacing("player", "target") then
            return Dist
        else
            return -(abs(Dist))
        end
    else
        return 1000
    end
end

-- Invalidate the cached class/spec/meleeSpell when the player changes specialization.
-- Called by Core.lua after a spec change (or on first-use via lazy init in getDistanceCalc).
function range:invalidateMeleeSpellCache()
    playerClass = nil
    br._G.wipe(meleeSpellNames)
end

function range:isSafeToAoE(spellID, Unit, effectRng, minUnits, aoeType, enemies)
    if not br.functions.misc:isChecked("Safe Damage Check") then return true end
    local enemiesValid, enemiesAll
    local maxRange = select(6, br.api.wow.GetSpellInfo(spellID))
    if effectRng == nil then effectRng = 5 end
    if maxRange == nil or maxRange == 0 then
        -- No range: an AoE around the unit, the call's radius (at least 8 yards). It used to be 8
        -- whatever the call asked for.
        maxRange = tonumber(effectRng)
        effectRng = math.max(tonumber(effectRng) or 5, 8)
    else
        maxRange = tonumber(maxRange)
    end
    if minUnits == nil then minUnits = 1 end
    if aoeType == "rect" then
        enemiesValid = br.engines.enemiesEngineFunctions:getEnemiesInRect(effectRng, maxRange, false)
        enemiesAll   = not enemies and br.engines.enemiesEngineFunctions:getEnemiesInRect(effectRng, maxRange, false, true) or enemies
    elseif aoeType == "cone" then
        enemiesValid = br.engines.enemiesEngineFunctions:getEnemiesInCone(effectRng, maxRange, false)
        enemiesAll   = not enemies and br.engines.enemiesEngineFunctions:getEnemiesInCone(effectRng, maxRange, true) or enemies
    else
        enemiesValid = #br.engines.enemiesEngineFunctions:getEnemies(Unit, effectRng)
        enemiesAll   = not enemies and #br.engines.enemiesEngineFunctions:getEnemies(Unit, effectRng, true) or enemies
    end
    return enemiesValid >= minUnits and enemiesValid >= enemiesAll
end
