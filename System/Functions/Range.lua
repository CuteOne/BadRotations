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
-- (Bear or Cat; none in caster form, where neither form's spells can be cast). A Druid's is worked out
-- once per frame, since getDistance asks on every call.
local druidKey, druidKeyAt = nil, nil
local function meleeListKey()
    if playerClass == nil then playerClass = select(2, br._G.UnitClass("player")) end
    if playerClass ~= "DRUID" then return playerClass end
    local now = br._G.GetTime()
    if druidKeyAt == now then return druidKey end
    druidKeyAt = now
    local form = br.functions.unit:getFormSpellID()
    if form == nil then druidKey = nil
    elseif form == br.functions.spell:getHighestSpellID("bearForm") then druidKey = "DRUID_BEAR"
    elseif form == br.functions.spell:getHighestSpellID("catForm") then druidKey = "DRUID_CAT"
    else druidKey = nil end
    return druidKey
end

-- Exact range rules, as the game's server applies them (see the comment above range:getEdgeDistance)
local DEFAULT_COMBAT_REACH = 1.5   -- a player's combat reach when the unit's can't be read
local MELEE_OFFSET = 4 / 3          -- added to both combat reaches for melee
local MELEE_MINIMUM = 5             -- melee reach is never less than this
local MELEE_BONUS = 1               -- the game's extra yard on melee (measured on Forever, as AzerothCore has it)
local LEEWAY = 8 / 3                -- extra reach while both units run
local LEEWAY_MIN_SPEED = 4.97       -- faster than walking
local OUT_OF_MELEE = 5.01           -- getDistance's least answer outside melee: just over 5
local ACROBATIC_STRIKES = 3         -- the Rogue talent's extra melee reach

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
--   * Melee:        centre distance (3D) <= max(5, both combat reaches + 4/3); the spell's range isn't used.
--                   The game adds 1 yd to that: measured on Forever with /br range (2026-10-11, the edge at
--                   about 6 yd for two 1.25-1.5 reaches), as AzerothCore does for melee spells
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

-- How far apart two units' centres can be for melee: max(5, both combat reaches + 4/3) + 1, plus the
-- running leeway.
function range:getMeleeReach(unit1, unit2)
    return math.max(MELEE_MINIMUM, range:getCombatReach(unit1) + range:getCombatReach(unit2) + MELEE_OFFSET)
        + MELEE_BONUS + range:getLeeway(unit1, unit2)
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
    if br.lists.range.meleeSpells[listKey] == nil then return nil, listKey end
    return resolveMeleeSpellName(listKey), listKey
end

-- Distance between two units, as profiles compare it: 0 in melee range, otherwise the edge-to-edge
-- distance (what spell ranges are measured against) but never 5 or less, so "< 5" and "<= 5" both mean
-- melee. Melee is the game's own answer for the player's melee spell when the player is one of the two
-- and the game gives one, else the melee rule (range:getMeleeReach). One unit: distance from the player.
-- Talents that change range (Astral Influence, Acrobatic Strikes) count unless option is "noMod".
-- 100 when a unit is missing or not visible, 999 without a position.
-- if br.functions.range:getDistance("target") < 5 then
function range:getDistance(Unit1, Unit2, option)
    if Unit2 == nil then
        Unit2 = Unit1
        Unit1 = "player"
    end
    if Unit1 == nil or Unit2 == nil then return 100 end
    local okSame, isSame = pcall(function() return Unit1 == Unit2 or br._G.UnitIsUnit(Unit1, Unit2) end)
    if okSame and isSame then return 0 end
    local unitFuncs = br.functions.unit
    local isPlayer1, isPlayer2 = unitFuncs:GetUnitIsUnit(Unit1, "player"), unitFuncs:GetUnitIsUnit(Unit2, "player")
    if not (isPlayer1 or (unitFuncs:GetObjectExists(Unit1) and unitFuncs:GetUnitIsVisible(Unit1) == true))
        or not (isPlayer2 or (unitFuncs:GetObjectExists(Unit2) and unitFuncs:GetUnitIsVisible(Unit2) == true))
    then
        return 100
    end
    local centre = range:getCenterDistance(Unit1, Unit2)
    if centre == nil then return 999 end
    local talent = option ~= "noMod" and br.player and br.player.talent
    -- Melee: the game's answer when it has one
    local inMelee = nil
    local other = (isPlayer1 and Unit2) or (isPlayer2 and Unit1) or nil
    if other then
        local meleeSpell = range:getMeleeSpellName()
        if meleeSpell then inMelee = br._G.C_Spell.IsSpellInRange(meleeSpell, other) end
    end
    if inMelee == nil then
        local reach = range:getMeleeReach(Unit1, Unit2)
        if talent and talent.acrobaticStrikes then reach = reach + ACROBATIC_STRIKES end
        inMelee = centre <= reach
    end
    if inMelee then return 0 end
    local edge = centre - range:getCombatReach(Unit1) - range:getCombatReach(Unit2)
    if talent and talent.astralInfluence then
        edge = edge - (talent.rank.astralInfluence == 1 and 1 or 3)
    end
    return math.max(OUT_OF_MELEE, edge)
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
-- Called after a spec change and when the spellbook changes.
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
