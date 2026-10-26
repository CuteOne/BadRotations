--- Unit API for BadRotations
-- @module Unit
-- Provides unit-based check functionality for the rotation system.
-- These calls help in retrieving information about unit-based checks.

local _, br = ...
----------------------
--- ABOUT THIS API ---
----------------------

-- These calls help in retrieving information about unit based checks.
-- unit is the profile API table `unit` (br.api.profile.unit).

br.api.build.unit = function(api)
    -- Local reference to unit
    local unit = api.unit

    ----------------
    --- Unit API ---
    ----------------

    -- Weapon Imbue Functions
    unit.weaponImbue = unit.weaponImbue or {}

    ----------------------
    --- Combat Stats API ---
    ----------------------

    --- Check if a unit is an Aberration
    -- @function unit.aberration
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is an Aberration
    unit.aberration = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.unit:isAberration(thisUnit)
    end

    --- Get a unit's aggro radius against the player
    -- @function unit.aggroRange
    -- @param thisUnit The unit to check, defaults to "target"
    -- @return number Aggro radius in yards (20 +/- level difference, minimum 5)
    unit.aggroRange = function(thisUnit)
        return br.functions.unit:getAggroRange(thisUnit)
    end

    --- Check if any nearby enemy would aggro on the player
    -- @function unit.anyInAggroRange
    -- @param offset Optional extra yards added to each aggro radius
    -- @param radius Optional search radius in yards, defaults to 40
    -- @return boolean True if any enemy (in combat or not) is within its aggro radius
    unit.anyInAggroRange = function(offset, radius)
        return br.functions.unit:anyInAggroRange(offset, radius)
    end

    --- Check if an enemy is attacking someone other than you
    -- @function unit.attackingOthers
    -- @param thisUnit The enemy to check
    -- @return boolean True when it's in combat, not attacking you, and its target is friendly
    -- @usage local thisUnit = enemies.first(enemies.yards5, unit.attackingOthers) -- a mob to taunt
    unit.attackingOthers = function(thisUnit)
        return br.functions.unit:isAttackingOthers(thisUnit)
    end

    --- Get player's attack power
    -- @function unit.attackPower
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return number Total attack power (base + positive buffs + negative buffs)
    unit.attackPower = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.unit:getAttackPower(thisUnit)
    end

    --- Check if a unit is a Beast
    -- @function unit.beast
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is a Beast
    unit.beast = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.unit:isBeast(thisUnit)
    end

    --- Check if a unit can be attacked
    -- @function unit.canAttack
    -- @param thisUnit The unit to check
    -- @param playerUnit The attacking unit, defaults to "player" if nil
    -- @return boolean True if playerUnit can attack thisUnit
    unit.canAttack = function(thisUnit, playerUnit)
        if playerUnit == nil then playerUnit = "player" end
        return br.functions.combat:canAttack(thisUnit, playerUnit)
    end

    --- Cancel current shapeshift form. Does nothing if the player isn't in a form, or if a cancel was
    -- just sent and the server hasn't replied yet (the form still shows for a round trip).
    -- @function unit.cancelForm
    -- @treturn boolean True when a cancel was sent now.
    unit.cancelForm = function()
        return br.functions.unit:cancelShapeshiftForm()
    end

    --- Leave the current shapeshift form to cast a spell, when a player would: not while stealthed,
    -- not while tanking in a bear form, and only with the mana to cast it and shift back. In an
    -- emergency it leaves regardless. Shows "Cancel Form [<spell>]" in profile debug once, when the
    -- cancel is sent. In combat, until a form is up again, casts other than that spell leave the mana
    -- to shift back into the form left.
    -- @function unit.cancelFormFor
    -- @param outOfFormSpell Spell to cast once out of form (id/name/spell table).
    -- @param treatOutSpellAsFree If true, that spell costs nothing this time (e.g. Clearcasting).
    -- @param emergency If true, leave form regardless (e.g. an emergency heal).
    -- @treturn boolean True while the form is being left: cancelled now, or a cancel still on its way
    --   (keep waiting rather than acting as if still in form).
    unit.cancelFormFor = function(outOfFormSpell, treatOutSpellAsFree, emergency)
        if br.functions.unit:isFormCancelPending() then return true end
        if not br.functions.unit:shouldLeaveFormFor(outOfFormSpell, treatOutSpellAsFree, emergency) then
            return false
        end
        local formSpellID = br.functions.unit:getFormSpellID()
        if not unit.cancelForm() then return false end
        local spellRef = br.functions.spell:getSpellIdFromRef(outOfFormSpell)
        -- Until a form is up again, other casts leave the mana to shift back (see cast:getReshiftOwed)
        br.functions.cast:setReshiftOwed(formSpellID, spellRef)
        if br.debug.form then br.debug.form:noteLeftFormFor(spellRef) end
        br.log:debug("Cancel Form [" .. tostring(spellRef and br.functions.spell:getName(spellRef) or spellRef) .. "]")
        return true
    end

    --- Check if player can fly
    -- @function unit.canFly
    -- @return boolean True if the player can fly in the current area
    unit.canFly = function()
        return br.functions.action:canFly()
    end

    --- Check if a unit is casting or channeling a spell
    -- @function unit.casting
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @param spellID Optional spellID to check for
    -- @return boolean True if the unit is casting, or casting the specific spell if spellID provided
    unit.casting = function(thisUnit, spellID)
        if thisUnit == nil then thisUnit = "player" end
        local spellCasting = br.functions.cast:getCastName(thisUnit)
        if spellID == nil then return spellCasting ~= nil end
        local spellName = br.functions.spell:getName(spellID)
        return tostring(spellCasting) == tostring(spellName)
    end

    --- True while the unit casts a spell from the tank buster list (System/Lists/TankBusters.lua)
    -- @function unit.castingTankBuster
    -- @param thisUnit The unit to check, defaults to "target"
    -- @return boolean
    unit.castingTankBuster = function(thisUnit)
        return br.functions.unit:isCastingTankBuster(thisUnit or "target")
    end

    --- Check if a unit is charmed
    -- @function unit.charmed
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is charmed
    unit.charmed = function(thisUnit)
        return br.functions.unit:isCharmed(thisUnit)
    end

    --- Check if you're running away from an enemy that is chasing you
    -- @function unit.chased
    -- @number[opt=10] range How close the chasing enemy is
    -- @return boolean True while an enemy within range chases you as you move away from it
    -- @usage if unit.chased(10) and cast.able.dash() then
    unit.chased = function(range)
        return br.functions.unit:isChased(range)
    end

    --- Clear current target
    -- @function unit.clearTarget
    -- @return nil
    unit.clearTarget = function()
        br.functions.range:clearDistanceMemo()
        return br.functions.unit:clearTarget()
    end

    --- Get combat time
    -- @function unit.combatTime
    -- @return number Time in combat in seconds
    unit.combatTime = function()
        return br.functions.combat:getCombatTime()
    end

    --- Get the player's melee critical strike chance
    -- @function unit.critChance
    -- @return number Critical strike chance percentage
    unit.critChance = function()
        return br.functions.misc:getCritChance()
    end

    --- Get a dead player in your group, to resurrect
    -- @function unit.deadGroupMember
    -- @number range Yards to look within
    -- @param ... Optional roles to pick from ("TANK", "HEALER", "DAMAGER"); anyone when none are given
    -- @return string|nil The unit, or nil when there's none
    -- @usage local thisUnit = unit.deadGroupMember(30, "TANK", "HEALER")
    unit.deadGroupMember = function(range, ...)
        return br.functions.unit:getDeadGroupMember(range, ...)
    end

    --- Check if a unit is dead or ghost
    -- @function unit.deadOrGhost
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is dead or a ghost
    unit.deadOrGhost = function(thisUnit)
        return br.functions.unit:GetUnitIsDeadOrGhost(thisUnit)
    end

    --- Check if a unit is a Demon
    -- @function unit.demon
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is a Demon
    unit.demon = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.unit:isDemon(thisUnit)
    end

    --- Get distance between units
    -- @function unit.distance
    -- @param thisUnit First unit
    -- @param otherUnit Second unit (if nil, first unit is assumed to be the target and player is used)
    -- @return number Distance between units in yards
    unit.distance = function(thisUnit, otherUnit)
        if not otherUnit then
            otherUnit = thisUnit
            thisUnit = "player"
        end
        return br.functions.range:getDistance(thisUnit, otherUnit)
    end

    --- Check if a unit is Dragonkin
    -- @function unit.dragonkin
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is Dragonkin
    unit.dragonkin = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.unit:isDragonkin(thisUnit)
    end

    --- Check if player is dual wielding weapons
    -- @function unit.dualWielding
    -- @return boolean True if player is dual wielding
    unit.dualWielding = function()
        return br.functions.misc:isDualWielding()
    end

    --- Check if a unit is an enemy
    -- @function unit.enemy
    -- @param thisUnit The unit to check
    -- @param playerUnit The reference unit, defaults to "player" if nil
    -- @return boolean True if thisUnit is an enemy to playerUnit
    unit.enemy = function(thisUnit, playerUnit)
        if playerUnit == nil then playerUnit = "player" end
        return br.functions.unit:isEnemy(thisUnit, playerUnit)
    end

    --- Check if an enemy is close enough to start a fight
    -- @function unit.enemyNear
    -- @number range Yards to look within
    -- @return boolean True when an enemy is already fighting within range, or an idle one's aggro range reaches you
    -- @usage if not unit.inCombat() and unit.enemyNear(20) and cast.able.prowl() then
    unit.enemyNear = function(range)
        return br.functions.unit:isEnemyNear(range)
    end

    --- Check if a unit exists
    -- @function unit.exists
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit exists
    unit.exists = function(thisUnit)
        return br.functions.unit:GetUnitExists(thisUnit)
    end

    --- Check if a unit is facing another unit
    -- @function unit.facing
    -- @param thisUnit The unit to check facing from, defaults to "player" if only one parameter provided
    -- @param otherUnit The unit to check facing towards
    -- @param degrees Optional angle in degrees to consider "facing", defaults to normal game value
    -- @return boolean True if thisUnit is facing otherUnit within the specified degrees
    unit.facing = function(thisUnit, otherUnit, degrees)
        if otherUnit == nil then
            otherUnit = thisUnit; thisUnit = "player"
        end
        return br.functions.unit:getFacing(thisUnit, otherUnit, degrees)
    end

    --- The direction the unit faces, in radians
    -- @function unit.facingAngle
    -- @param thisUnit The unit to check, defaults to "player"
    -- @return number
    unit.facingAngle = function(thisUnit)
        return br.functions.unit:GetObjectFacing(thisUnit or "player")
    end

    --- How far to the side of the player's facing line the target stands (negative behind the player,
    -- 1000 when either can't be seen)
    -- @function unit.facingDistance
    -- @return number Yards
    unit.facingDistance = function()
        return br.functions.range:getFacingDistance()
    end

    --- How far the player has fallen
    -- @function unit.fallDist
    -- @return number Distance in yards the player has fallen
    unit.fallDist = function()
        return br.functions.misc:getFallDistance() or 0
    end

    --- Check if a unit is falling
    -- @function unit.falling
    -- @return boolean True if player is falling
    unit.falling = function()
        return br.functions.misc:isFalling()
    end

    --- Get time the player has been falling
    -- @function unit.fallTime
    -- @return number Time in seconds player has been falling
    unit.fallTime = function()
        return br.functions.misc:getFallTime()
    end

    --- The kind of fight, as SimC names them: fightStyle.dungeonRoute() in a Mythic+ key run,
    -- fightStyle.dungeonSlice() in another 5-man dungeon, fightStyle.patchwerk() anywhere else
    -- @table unit.fightStyle
    unit.fightStyle = {}

    --- Returns true when inside an active Mythic+ key run.
    -- @function unit.fightStyle.dungeonRoute
    -- @return boolean
    unit.fightStyle.dungeonRoute = function()
        return br.runner.state.instance == "party" and br.functions.misc:isInMythicPlus()
    end

    --- Returns true when inside a regular (non-Mythic+) 5-man dungeon.
    -- @function unit.fightStyle.dungeonSlice
    -- @return boolean
    unit.fightStyle.dungeonSlice = function()
        return br.runner.state.instance == "party" and not br.functions.misc:isInMythicPlus()
    end

    --- Returns true when not in a 5-man party instance (raid, outdoor, etc.).
    -- @function unit.fightStyle.patchwerk
    -- @return boolean
    unit.fightStyle.patchwerk = function()
        return br.runner.state.instance ~= "party"
    end

    --- Check if player is flying
    -- @function unit.flying
    -- @return boolean True if player is flying
    unit.flying = function()
        return br.functions.misc:isFlying()
    end

    --- Get current shapeshift form
    -- @function unit.form
    -- @return number Current shapeshift form ID
    unit.form = function()
        return br.functions.misc:getShapeshiftForm()
    end

    --- Check if a specific form is active or if any form is active
    -- @function unit.formActive
    -- @param spellID Optional spell ID to check for a specific form. If nil, checks if any form is active
    -- @return boolean True if the specified form (or any form if no spellID provided) is active
    unit.formActive = function(spellID)
        if spellID then return br.functions.unit:getFormSpellID() == spellID end
        return (br.functions.misc:getShapeshiftForm() or 0) > 0
    end

    --- Get number of available shapeshift forms
    -- @function unit.formCount
    -- @return number Count of available shapeshift forms
    unit.formCount = function()
        return br.functions.misc:getShapeshiftFormCount()
    end

    --- Get information about a specific shapeshift form
    -- @function unit.formInfo
    -- @param formIndex The index of the form (1-based)
    -- @return number, boolean, boolean, number icon, isActive, isCastable, spellID
    unit.formInfo = function(formIndex)
        return br.functions.misc:getShapeshiftFormInfo(formIndex)
    end

    --- Check if a unit is friendly to another unit
    -- @function unit.friend
    -- @param thisUnit The unit to check
    -- @param playerUnit The reference unit, defaults to "player" if nil
    -- @return boolean True if thisUnit is friendly to playerUnit
    unit.friend = function(thisUnit, playerUnit)
        if playerUnit == nil then playerUnit = "player" end
        return br.functions.unit:GetUnitIsFriend(thisUnit, playerUnit)
    end

    --- Get global cooldown duration
    -- @function unit.gcd
    -- @param max Optional boolean to return maximum possible GCD instead of current
    -- @return number Global cooldown in seconds
    unit.gcd = function(max)
        return br.functions.spell:getGlobalCD(max)
    end

    --- Get the spell ID of the current shapeshift form (the spell that shifts back into it), or nil
    -- when no form is active.
    -- @function unit.getCurrentFormSpellID
    -- @return number|nil Spell ID of the current form, or nil if no form is active.
    unit.getCurrentFormSpellID = function()
        return br.functions.unit:getFormSpellID()
    end

    --- Get number of members in the current group (including player; 0 if solo)
    -- @function unit.groupCount
    -- @return number Total group member count
    unit.groupCount = function()
        return br.functions.misc:getGroupSize()
    end

    --- Get unit's GUID (Globally Unique Identifier)
    -- @function unit.guid
    -- @param thisUnit The unit to get GUID for
    -- @return string Unit's GUID
    unit.guid = function(thisUnit)
        return br.functions.unit:getUnitGUID(thisUnit)
    end

    --- Get unit's current health
    -- @function unit.health
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return number Current health of the unit
    unit.health = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.unit:getHealth(thisUnit)
    end

    --- Get unit's maximum health
    -- @function unit.healthMax
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return number Maximum health of the unit
    unit.healthMax = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.unit:getHealthMax(thisUnit)
    end

    --- Get unit's health percentage
    -- @function unit.hp
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return number Health percentage of the unit (0-100)
    unit.hp = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.misc:round2(br.functions.unit:getHP(thisUnit), 2)
    end

    --- Check if a unit is a Humanoid
    -- @function unit.humanoid
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is a Humanoid
    unit.humanoid = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.unit:isHumanoid(thisUnit)
    end

    --- Get unit's ID
    -- @function unit.id
    -- @param thisUnit The unit to get ID for
    -- @return number Unit's ID
    unit.id = function(thisUnit)
        return br.functions.unit:GetObjectID(thisUnit)
    end

    --- Check if a unit would aggro on the player
    -- @function unit.inAggroRange
    -- @param thisUnit The unit to check, defaults to "target"
    -- @param offset Optional extra yards added to the aggro radius
    -- @return boolean True if hostile (or neutral and targeted) and within its aggro radius
    unit.inAggroRange = function(thisUnit, offset)
        return br.functions.unit:isInAggroRange(thisUnit, offset)
    end

    --- Check if a unit is in combat
    -- @function unit.inCombat
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return boolean True if the unit is in combat or special conditions are met
    unit.inCombat = function(thisUnit)
        return br.functions.combat:isInCombat(thisUnit)
    end

    --- Check if player is in a group (party or raid)
    -- @function unit.inGroup
    -- @return boolean True if player is in a group
    unit.inGroup = function()
        return br.functions.unit:isInGroup()
    end

    --- True while the player is in a raid group
    -- @function unit.inRaid
    -- @return boolean
    unit.inRaid = function()
        return br.functions.unit:isInRaid()
    end

    --- Check instance type or if in a specific instance type
    -- @function unit.instance
    -- @param thisInstance Optional specific instance type to check for
    -- @return string|boolean Returns instance type if no parameter, or boolean if matching specific instance
    unit.instance = function(thisInstance)
        local instanceType = br.functions.misc:getInstanceType()
        return thisInstance == nil and instanceType or instanceType == thisInstance
    end

    --- Check if a unit's cast can be interrupted
    -- @function unit.interruptable
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @param castPercent Optional cast percentage threshold
    -- @return boolean True if the unit's cast can be interrupted
    unit.interruptable = function(thisUnit, castPercent)
        if thisUnit == nil then thisUnit = "target" end
        if castPercent == nil then castPercent = 0 end
        return br.functions.spell:canInterrupt(thisUnit, castPercent)
    end

    --- True while the player rides a vehicle
    -- @function unit.inVehicle
    -- @return boolean
    unit.inVehicle = function()
        return br.functions.unit:inVehicle()
    end

    --- Check if a unit is behind another unit
    -- @function unit.isBehind
    -- @param thisUnit The unit being checked for facing (typically the target), defaults to "target" if nil
    -- @param otherUnit The reference unit (typically "player"), defaults to "player" if nil
    -- @param degrees Optional angle in degrees for the facing cone, defaults to normal game value
    -- @return boolean True if thisUnit is NOT facing otherUnit within the given degrees; false while the
    -- game has just refused a cast on thisUnit with "You must be behind your target"
    unit.isBehind = function(thisUnit, otherUnit, degrees)
        if thisUnit == nil then thisUnit = "target" end
        if otherUnit == nil then otherUnit = "player" end
        if br.functions.unit:GetUnitIsUnit(otherUnit, "player")
            and br.functions.cast:isRejected("behind", nil, thisUnit) then
            return false
        end

        local facing = br.functions.unit:getFacing(thisUnit, otherUnit, degrees)
        if facing == nil then return false end
        return not facing
    end

    --- Check if a unit is a boss
    -- @function unit.isBoss
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is a boss
    unit.isBoss = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.unit:isBoss(thisUnit)
    end

    --- Check if a unit is casting
    -- @function unit.isCasting
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return boolean True if the unit is casting or channelling
    unit.isCasting = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.cast:isUnitCasting(thisUnit)
    end

    --- Check if a unit is a training dummy
    -- @function unit.isDummy
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is a training dummy
    unit.isDummy = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.unit:isDummy(thisUnit)
    end

    --- Check if a unit is an Elemental
    -- @function unit.isElemental
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is an Elemental
    unit.isElemental = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.unit:isElemental(thisUnit)
    end

    --- Check if a unit is an explosive orb (M+ affix)
    -- @function unit.isExplosive
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is an explosive orb
    unit.isExplosive = function(thisUnit)
        return br.functions.unit:isExplosive(thisUnit)
    end

    --- Check if a unit is fleeing
    -- @function unit.isFleeing
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is fleeing
    unit.isFleeing = function(thisUnit)
        return br.functions.unit:isFleeing(thisUnit)
    end

    --- Check if a unit is moving away from another unit that is facing it (being chased)
    -- @function unit.isFleeingFrom
    -- @param thisUnit The unit that may be fleeing, defaults to "player"
    -- @param fromUnit The unit it may be fleeing from, defaults to "target"
    -- @return boolean True if thisUnit is running from fromUnit
    unit.isFleeingFrom = function(thisUnit, fromUnit)
        return br.functions.unit:isFleeingFrom(thisUnit, fromUnit)
    end

    --- Check if a unit is tanking
    -- @function unit.isTanking
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return boolean True if the unit is tanking
    unit.isTanking = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.combat:isTanking(thisUnit)
    end

    --- Check if a tank is in range
    -- @function unit.isTankInRange
    -- @return boolean True if a tank is in range
    -- @treturn string The tank
    unit.isTankInRange = function()
        return br.functions.unit:isTankInRange()
    end

    --- Check if two units are the same
    -- @function unit.isUnit
    -- @param thisUnit First unit to compare
    -- @param otherUnit Second unit to compare
    -- @return boolean True if both units are the same
    unit.isUnit = function(thisUnit, otherUnit)
        if thisUnit == nil or otherUnit == nil then return false end
        return br.functions.unit:GetUnitIsUnit(thisUnit, otherUnit)
    end

    --- Get unit's level
    -- @function unit.level
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return number The level of the unit
    unit.level = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.unit:getLevel(thisUnit)
    end

    --- Get the lowest health friendly unit in range
    -- @function unit.lowest
    -- @param range The range to check for units, defaults to 5 if nil
    -- @return unit The friendly unit with lowest health in range
    unit.lowest = function(range)
        if range == nil then range = 5 end
        return br.functions.unit:getLowestUnit(range)
    end

    --- Check if player is mounted
    -- @function unit.mounted
    -- @return boolean True if player is mounted
    unit.mounted = function()
        return br.functions.misc:isMounted()
    end

    --- Check if a unit is moving
    -- @function unit.moving
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return boolean True if the unit is moving
    unit.moving = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.misc:isMoving(thisUnit)
    end

    --- Get time a unit has been moving
    -- @function unit.movingTime
    -- @return number Time in seconds the unit has been moving
    unit.movingTime = function()
        return br.functions.misc:getMovingTime()
    end

    --- Get unit's name
    -- @function unit.name
    -- @param thisUnit The unit to get name of
    -- @return string The name of the unit
    unit.name = function(thisUnit)
        if thisUnit == nil then return "" end
        return br.functions.unit:getName(thisUnit)
    end

    --- Get time out of combat
    -- @function unit.ooCombatTime
    -- @return number Time out of combat in seconds
    unit.ooCombatTime = function()
        return br.functions.combat:getOoCTime()
    end

    --- Check if player is outdoors
    -- @function unit.outdoors
    -- @return boolean True if player is outdoors
    unit.outdoors = function()
        return br.functions.misc:isOutdoors()
    end

    --- Check if a unit is a player
    -- @function unit.player
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is a player
    unit.player = function(thisUnit)
        return br.functions.unit:isPlayer(thisUnit)
    end

    --- Where the unit stands
    -- @function unit.position
    -- @param thisUnit The unit to check, defaults to "player"
    -- @return number, number, number x, y, z
    unit.position = function(thisUnit)
        return br.functions.unit:GetObjectPosition(thisUnit or "player")
    end

    --- Returns the time remaining on the pull timer (DBM/BigWigs)
    -- @function unit.pullTimer
    -- @return number - Returns seconds remaining on pull timer
    unit.pullTimer = function()
        return br.functions.custom:PullTimerRemain()
    end

    --- Get unit's race
    -- @function unit.race
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return string The race of the unit
    unit.race = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.unit:getRace(thisUnit)
    end

    --- Get the player's current ranged attack speed in seconds.
    -- Reads the live haste-modified speed from UnitRangedDamage so it reflects
    -- Rapid Fire, Quiver haste, and other modifiers automatically.
    -- @function unit.rangedAttackSpeed
    -- @return number Ranged weapon speed in seconds, or 0 if unavailable
    unit.rangedAttackSpeed = function()
        return br.functions.misc:getRangedAttackSpeed()
    end

    --- Get unit's reaction level towards another unit
    -- @function unit.reaction
    -- @param thisUnit The unit to check reaction of
    -- @param playerUnit The reference unit, defaults to "player" if nil
    -- @return number Reaction level (1-hostile to 8-friendly)
    unit.reaction = function(thisUnit, playerUnit)
        if playerUnit == nil then playerUnit = "player" end
        return br.functions.unit:GetUnitReaction(thisUnit, playerUnit)
    end

    --- Check if it's a good moment to start a fight
    -- @function unit.readyToFight
    -- @return boolean True when you aren't low on health or mana or eating or drinking, and in a group the tanks aren't low (Ready To Fight options, Targeting page)
    -- @usage if not unit.inCombat() and unit.readyToFight() and cast.able.faerieFire("target") then
    unit.readyToFight = function()
        return br.functions.combat:isReadyToFight()
    end

    --- Check if player is resting
    -- @function unit.resting
    -- @return boolean True if player is resting
    unit.resting = function()
        return br.functions.misc:isResting()
    end

    --- Get unit's assigned role in group
    -- @function unit.role
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return string The role assigned to the unit ("TANK", "HEALER", "DAMAGER", "NONE")
    unit.role = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.unit:getRole(thisUnit)
    end

    --- Check if player is solo (no group)
    -- @function unit.solo
    -- @return boolean True if player is solo
    unit.solo = function()
        return not br.functions.unit:isInGroup()
    end

    --- The name of the player's spec as BR loads it ("Initial" before a spec is chosen)
    -- @function unit.spec
    -- @return string
    unit.spec = function()
        return br.loader.selectedSpec
    end

    --- Get player's spell haste percentage
    -- @function unit.spellHaste
    -- @return number Spell haste percentage
    unit.spellHaste = function()
        return br.functions.misc:getSpellHaste()
    end

    --- Get time a unit has been standing still
    -- @function unit.standingTime
    -- @return number Time in seconds the unit has been standing still
    unit.standingTime = function()
        return br.functions.misc:getStandingTime()
    end

    --- Start auto-attack. Not sent again while auto attack on that unit is already on or on its way
    -- (the game confirms a round trip later); a different unit always goes out.
    -- @function unit.startAttack
    -- @param[opt="target"] thisUnit The unit to attack
    -- @return boolean True when it was sent
    unit.startAttack = function(thisUnit)
        return br.functions.unit:startAttack(thisUnit)
    end

    --- Stop auto-attack
    -- @function unit.stopAttack
    -- @return nil
    unit.stopAttack = function()
        return br.functions.unit:stopAttack()
    end

    --- Check if player is swimming
    -- @function unit.swimming
    -- @return boolean True if player is swimming
    unit.swimming = function()
        return br.functions.misc:isSwimming()
    end

    --- The player's swing timer: seconds until the next swing (nil before the first swing), the
    -- weapon speed and when the last swing landed (util.time())
    -- @function unit.swing
    -- @string[opt="mh"] hand "mh" for melee (the main hand), "oh" for the off hand, "ranged" for Auto Shot
    -- @return number, number, number
    -- @usage local untilNext, speed, last = unit.swing("ranged")
    unit.swing = function(hand)
        return br.functions.unit:getSwing(hand)
    end

    --- Get the current target of a unit
    -- @function unit.target
    -- @param thisUnit The unit whose target to get
    -- @return string|nil Unit token of thisUnit's current target, or nil if none
    unit.target = function(thisUnit)
        return br.functions.unit:getTarget(thisUnit)
    end

    --- Check if a unit is on a taxi
    -- @function unit.taxi
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return boolean True if the unit is on a taxi
    unit.taxi = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.unit:isOnTaxi(thisUnit)
    end

    --- Check if a unit has threat
    -- @function unit.threat
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit has threat
    unit.threat = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.combat:hasThreat(thisUnit)
    end

    --- Get the player's current threat status, on one enemy or on any
    -- @function unit.threatStatus
    -- @param[opt] thisUnit The enemy; any enemy when nil
    -- @return number Threat status: 0=no/low threat, 1=high threat (not primary target),
    --   2=primary target (another unit has 100%+ threat), 3=primary target (sole aggro)
    unit.threatStatus = function(thisUnit)
        return br.functions.custom:getThreat(thisUnit)
    end

    --- Seconds since the player last landed from a mount
    -- @function unit.timeSinceDismount
    -- @return number|nil Seconds since dismounting, nil while mounted or if not mounted since login
    unit.timeSinceDismount = function()
        local dismountTime = br.runner.state.dismountTime
        return dismountTime and (br.functions.misc:getTime() - dismountTime) or nil
    end

    --- True for a totem
    -- @function unit.totem
    -- @param thisUnit The unit to check
    -- @return boolean
    unit.totem = function(thisUnit)
        return br.engines.enemiesEngineFunctions:isTotem(thisUnit)
    end

    --- Estimate time until unit dies
    -- @function unit.ttd
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @param percent Optional health percentage to calculate time to
    -- @return number Estimated time until death in seconds
    unit.ttd = function(thisUnit, percent)
        if thisUnit == nil then thisUnit = "target" end
        return br.engines.ttdTable:getTTD(thisUnit, percent) or 0
    end

    --- Get combined time to death for all enemies in range
    -- @function unit.ttdGroup
    -- @param range Range to check for enemies, defaults to 5 yards if nil
    -- @param percent Optional health percentage to calculate time to
    -- @return number Combined estimated time until death for all enemies in range
    unit.ttdGroup = function(range, percent)
        if range == nil then range = 5 end
        local enemies = api.enemies.get(range)
        local groupTTD = 0
        for i = 1, #enemies do
            groupTTD = groupTTD + unit.ttd(enemies[i], percent)
        end
        return groupTTD
    end

    --- Check if a unit is Undead
    -- @function unit.undead
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is Undead
    unit.undead = function(thisUnit)
        return br.functions.unit:isUndead(thisUnit)
    end

    --- Check if a unit is valid for targeting
    -- @function unit.valid
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is valid
    unit.valid = function(thisUnit)
        return (br.functions.misc:isValidUnit(thisUnit))
    end

    --- Get player's average weapon damage
    -- @function unit.weaponDamage
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return number Average weapon damage
    unit.weaponDamage = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.functions.unit:getWeaponDamage(thisUnit)
    end

    --- Get weapon imbue charges
    -- @function unit.weaponImbue.charges
    -- @param imbueId The ID of the imbue to check
    -- @param offHand Boolean whether to check offhand (true) or main hand (false, default)
    -- @return number Number of charges remaining on the weapon imbue
    unit.weaponImbue.charges = function(imbueId, offHand)
        local _, _, mainCharges, _, _, _, offCharges = br.functions.item:getWeaponEnchants()
        if offHand and unit.weaponImbue.exists(imbueId, true) then return offCharges end
        if not offHand and unit.weaponImbue.exists(imbueId) then return mainCharges end
        return 0
    end

    --- Check if a weapon imbue exists
    -- @function unit.weaponImbue.exists
    -- @param imbueId The ID of the imbue to check for
    -- @param offHand Boolean whether to check offhand (true) or main hand (false, default)
    -- @return boolean True if the imbue exists on the specified weapon
    unit.weaponImbue.exists = function(imbueId, offHand)
        local hasMain, _, _, mainId, hasOff, _, _, offId = br.functions.item:getWeaponEnchants()
        if offHand == nil then offHand = false end
        if type(imbueId) == "table" then
            -- If parallel spell rank data is embedded, check only the highest known rank
            -- so that a freshly-learned higher rank triggers reapplication.
            if imbueId.spells and br.functions.spell and br.functions.spell.getHighestKnownRank then
                local highestSpellId = br.functions.spell:getHighestKnownRank(imbueId.spells)
                local targetId = nil
                for i = 1, #imbueId.spells do
                    if imbueId.spells[i] == highestSpellId then
                        targetId = imbueId[i]
                        break
                    end
                end
                -- Strict rank check: if the exact highest-rank enchant is present, return immediately.
                if targetId ~= nil then
                    if offHand and hasOff and offId == targetId then return true end
                    if not offHand and hasMain and mainId == targetId then return true end
                end
                -- Strict rank not matched; fall through to any-match below to prevent
                -- spurious reapplication when enchant IDs don't perfectly align with game data.
            end
            -- Any matching enchant ID from the table satisfies the check
            for i = 1, #imbueId do
                if (offHand and hasOff) and offId == imbueId[i] then return true end
                if (not offHand and hasMain) and mainId == imbueId[i] then return true end
            end
            local present = (offHand and hasOff) or (not offHand and hasMain)
            -- An enchant BR knows (learned from its own casts, or another imbue's list): it is this
            -- imbue or it isn't
            if present then
                local onHand = br.functions.item:getImbueKey(offHand and offId or mainId)
                local mine = br.functions.item:getImbueKeyOf(imbueId)
                if onHand ~= nil and mine ~= nil then return onHand == mine end
            end
            -- ID matching failed (IDs may be nil, zero, or incorrect for this game version).
            -- Fall back to presence-only: if any enchant exists on the configured hand,
            -- accept it rather than looping with endless reapplication attempts (Imbue.log
            -- records the enchant, to correct the list).
            if present and br.debug.imbue then br.debug.imbue:noteUnlisted(offHand, offHand and offId or mainId, imbueId) end
            return present and true or false
        end
        if imbueId == nil then
            if offHand then imbueId = offId else imbueId = mainId end
        end
        if offHand and hasOff and offId == imbueId then return true end
        if not offHand and hasMain and mainId == imbueId then return true end
        return false
    end

    --- Check if a weapon imbue is missing (needs to be applied). Not while a cast of it is still being
    -- watched (the enchant shows a moment after the cast), nor on a weapon a cast of it showed nothing on
    -- (it doesn't hold it, e.g. a profession tool).
    -- @function unit.weaponImbue.needed
    -- @param imbueId The imbue list (imbues.<key>) or enchant ID to check for
    -- @param offHand Boolean whether to check offhand (true) or main hand (false, default)
    -- @return boolean True if the imbue is NOT currently applied to the specified weapon, and applying it would
    unit.weaponImbue.needed = function(imbueId, offHand)
        local key = type(imbueId) == "table" and br.functions.item:getImbueKeyOf(imbueId) or nil
        if key and (br.functions.item:isImbueWatched(key) or not br.functions.item:imbueTakes(key, offHand and 17 or 16)) then
            return false
        end
        return not unit.weaponImbue.exists(imbueId, offHand)
    end

    --- Get weapon imbue remaining time
    -- @function unit.weaponImbue.remain
    -- @param imbueId The ID of the imbue to check
    -- @param offHand Boolean whether to check offhand (true) or main hand (false, default)
    -- @return number Time remaining on the weapon imbue in seconds
    unit.weaponImbue.remain = function(imbueId, offHand)
        if not unit.weaponImbue.exists(imbueId, offHand) then return 0 end
        -- The game gives the time left in milliseconds
        local _, mainLeft, _, _, _, offLeft = br.functions.item:getWeaponEnchants()
        local timeRemain = ((offHand and offLeft or mainLeft) or 0) / 1000
        return timeRemain > 0 and timeRemain or 0
    end

    --- Get the display name of a weapon imbue spell
    -- @function unit.weaponImbue.spellName
    -- @param spellKey The spell key string (e.g. "rockbiterWeapon") used in br.runner.spells
    -- @return string The localised spell name, or the key as a fallback
    unit.weaponImbue.spellName = function(spellKey)
        return br.functions.spell:getKeyName(spellKey) or spellKey
    end
end
