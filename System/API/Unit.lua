--- Unit API for BadRotations
-- @module Unit
-- Provides unit-based check functionality for the rotation system.
-- These calls help in retrieving information about unit-based checks.
-- @usage local unit = br.player.unit

local _, br = ...
if br.api == nil then br.api = {} end
----------------------
--- ABOUT THIS API ---
----------------------

-- These calls help in retrieving information about unit based checks.
-- unit is the table located at br.player.unit, call this in profile to use.

br.api.unit = function(self)
    -- Local reference to unit
    local unit = self.unit

    ----------------
    --- Unit API ---
    ----------------

    --- Get the distance the player has fallen
    --- @function unit.fallDist

    -- Weapon Imbue Fuctions
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

    --- Get player's attack power
    -- @function unit.attackPower
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return number Total attack power (base + positive buffs + negative buffs)
    unit.attackPower = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        local UnitAttackPower = br._G["UnitAttackPower"]
        local base, posBuff, negBuff = UnitAttackPower(thisUnit)
        return base + posBuff + negBuff
    end

    --- Check if a unit is a Beast
    -- @function unit.beast
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is a Beast
    unit.beast = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.unit:isBeast(thisUnit)
    end

    --- Check if a unit is Dragonkin
    -- @function unit.dragonkin
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is Dragonkin
    unit.dragonkin = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.unit:isDragonkin(thisUnit)
    end

    --- Check if a unit can be attacked
    -- @function unit.canAttack
    -- @param thisUnit The unit to check
    -- @param playerUnit The attacking unit, defaults to "player" if nil
    -- @return boolean True if playerUnit can attack thisUnit
    unit.canAttack = function(thisUnit, playerUnit)
        local UnitCanAttack = br._G["UnitCanAttack"]
        if playerUnit == nil then playerUnit = "player" end
        return UnitCanAttack(thisUnit, playerUnit)
    end

    --- Check if it's safe to cancel form (enough mana to cast the spell and shift back).
    -- @function unit.canCancelFormFor
    -- @param outOfFormSpell Spell reference (id/name/spell table) you intend to cast after breaking form.
    -- @param returnFormSpell Spell reference (id/name/spell table) to shift back into.
    -- @param treatOutSpellAsFree If true, treat out-of-form spell cost as 0 (e.g., Clearcasting).
    -- @treturn boolean
    unit.canCancelFormFor = function(outOfFormSpell, returnFormSpell, treatOutSpellAsFree)
        local requiredMana, currentMana = unit.formBreakManaRequired(outOfFormSpell, returnFormSpell, treatOutSpellAsFree)
        if requiredMana <= 0 then return true end
        return currentMana >= requiredMana
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
        br.log:debug("Cancel Form [" .. tostring(spellRef and br.api.wow.GetSpellInfo(spellRef) or spellRef) .. "]")
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
        local spellCasting = br._G.UnitCastingInfo(thisUnit)
        if spellCasting == nil then
            spellCasting = br._G.UnitChannelInfo(thisUnit)
        end
        if spellID == nil then return spellCasting ~= nil end
        local spellName = br.api.wow.GetSpellInfo(spellID)
        return tostring(spellCasting) == tostring(spellName)
    end

    --- Check if a unit is charmed
    -- @function unit.charmed
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is charmed
    unit.charmed = function(thisUnit)
        return br._G.UnitIsCharmed(thisUnit)
    end

    --- Clear current target
    -- @function unit.clearTarget
    -- @return nil
    unit.clearTarget = function()
        br.functions.range:clearDistanceMemo()
        return br._G.ClearTarget()
    end

    --- Get combat time
    -- @function unit.combatTime
    -- @return number Time in combat in seconds
    unit.combatTime = function()
        return br.functions.combat:getCombatTime()
    end

    --- Get player's critical strike chance
    -- @function unit.critChance
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return number Critical strike chance percentage
    unit.critChance = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        local GetCritChance = br._G["GetCritChance"]
        return GetCritChance()
    end

    --- Check if a unit is dead or ghost
    -- @function unit.deadOrGhost
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is dead or a ghost
    unit.deadOrGhost = function(thisUnit)
        local UnitIsDeadOrGhost = br._G["UnitIsDeadOrGhost"]
        return UnitIsDeadOrGhost(thisUnit)
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

    --- Check if player is dual wielding weapons
    -- @function unit.dualWielding
    -- @return boolean True if player is dual wielding
    unit.dualWielding = function()
        local IsDualWielding = br._G["IsDualWielding"]
        return IsDualWielding()
    end

    --- Check if a unit is an enemy
    -- @function unit.enemy
    -- @param thisUnit The unit to check
    -- @param playerUnit The reference unit, defaults to "player" if nil
    -- @return boolean True if thisUnit is an enemy to playerUnit
    unit.enemy = function(thisUnit, playerUnit)
        local UnitIsEnemy = br._G["UnitIsEnemy"]
        if playerUnit == nil then playerUnit = "player" end
        return UnitIsEnemy(thisUnit, playerUnit)
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

    --- @return number Distance in yards the player has fallen
    unit.fallDist = function()
        return br.functions.misc:getFallDistance() or 0
    end

    --- Check if a unit is falling
    -- @function unit.falling
    -- @return boolean True if player is falling
    unit.falling = function()
        local IsFalling = br._G["IsFalling"]
        return IsFalling()
    end

    --- Get time the player has been falling
    -- @function unit.fallTime
    -- @return number Time in seconds player has been falling
    unit.fallTime = function()
        return br.functions.misc:getFallTime()
    end

    --- Check if player is flying
    -- @function unit.flying
    -- @return boolean True if player is flying
    unit.flying = function()
        local IsFlying = br._G["IsFlying"]
        return IsFlying()
    end

    --- Get current shapeshift form
    -- @function unit.form
    -- @return number Current shapeshift form ID
    unit.form = function()
        local GetShapeshiftForm = br._G["GetShapeshiftForm"]
        return GetShapeshiftForm()
    end

    --- Check if a specific form is active or if any form is active
    -- @function unit.formActive
    -- @param spellID Optional spell ID to check for a specific form. If nil, checks if any form is active
    -- @return boolean True if the specified form (or any form if no spellID provided) is active
    unit.formActive = function(spellID)
        local numForms = unit.formCount()
        if spellID then
            -- Check for specific form by spell ID
            for i = 1, numForms do
                local _, isActive, _, formSpellID = unit.formInfo(i)
                if isActive and formSpellID == spellID then
                    return true
                end
            end
            return false
        else
            -- Check if any form is active
            for i = 1, numForms do
                local _, isActive = unit.formInfo(i)
                if isActive then
                    return true
                end
            end
            return false
        end
    end

    --- Calculate mana required to safely break form for a spell and shift back.
    -- @function unit.formBreakManaRequired
    -- @param outOfFormSpell Spell reference (id/name/spell table) you intend to cast after breaking form.
    -- @param returnFormSpell Spell reference (id/name/spell table) to shift back into.
    -- @param treatOutSpellAsFree If true, treat out-of-form spell cost as 0 (e.g., Clearcasting).
    -- @treturn number requiredMana Total mana needed (out spell + return form).
    -- @treturn number currentMana Current player mana.
    unit.formBreakManaRequired = function(outOfFormSpell, returnFormSpell, treatOutSpellAsFree)
        local outCost = br.functions.power:getManaCostFromRef(outOfFormSpell, treatOutSpellAsFree)
        local backCost = br.functions.power:getManaCostFromRef(returnFormSpell, false)
        local requiredMana = outCost + backCost
        local currentMana = br._G.UnitPower("player", 0)
        return requiredMana, currentMana
    end

    --- Get number of available shapeshift forms
    -- @function unit.formCount
    -- @return number Count of available shapeshift forms
    unit.formCount = function()
        local GetNumShapeshiftForms = br._G["GetNumShapeshiftForms"]
        return GetNumShapeshiftForms()
    end

    --- Get information about a specific shapeshift form
    -- @function unit.formInfo
    -- @param formIndex The index of the form (1-based)
    -- @return texture, isActive, isCastable, spellID
    unit.formInfo = function(formIndex)
        local GetShapeshiftFormInfo = br._G["GetShapeshiftFormInfo"]
        if GetShapeshiftFormInfo then
            return GetShapeshiftFormInfo(formIndex)
        end
        return nil, false, false, nil
    end

    --- Check if a unit is friendly to another unit
    -- @function unit.friend
    -- @param thisUnit The unit to check
    -- @param playerUnit The reference unit, defaults to "player" if nil
    -- @return boolean True if thisUnit is friendly to playerUnit
    unit.friend = function(thisUnit, playerUnit)
        local UnitIsFriend = br._G["UnitIsFriend"]
        if playerUnit == nil then playerUnit = "player" end
        return UnitIsFriend(thisUnit, playerUnit)
    end

    --- Get global cooldown duration
    -- @function unit.gcd
    -- @param max Optional boolean to return maximum possible GCD instead of current
    -- @return number Global cooldown in seconds
    unit.gcd = function(max)
        return br.functions.spell:getGlobalCD(max)
    end

    --- Get the spell ID of the currently-active shapeshift form, or nil if no form is active.
    -- Used by L33's cast.macro extension to pass an associated spell ID when issuing
    -- /CancelForm macros, so the cast-gate's throttle (castTimers + castIntentLocks)
    -- can prevent re-fire bursts during the server-side form-change propagation window.
    -- @function unit.getCurrentFormSpellID
    -- @return number|nil Spell ID of the current form, or nil if no form is active.
    unit.getCurrentFormSpellID = function()
        return br.functions.unit:getFormSpellID()
    end

    --- Get number of members in the current group (including player; 0 if solo)
    -- @function unit.groupCount
    -- @return number Total group member count
    unit.groupCount = function()
        local GetNumGroupMembers = br._G["GetNumGroupMembers"]
        return GetNumGroupMembers()
    end

    --- Get unit's GUID (Globally Unique Identifier)
    -- @function unit.guid
    -- @param thisUnit The unit to get GUID for
    -- @return string Unit's GUID
    unit.guid = function(thisUnit)
        local UnitGUID = br._G["UnitGUID"]
        return UnitGUID(thisUnit)
    end

    --- Get unit's current health
    -- @function unit.health
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return number Current health of the unit
    unit.health = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        if unit.isDummy(thisUnit) then
            return br._G.UnitHealthMax(thisUnit)
        end
        return br._G.UnitHealth(thisUnit)
    end

    --- Get unit's maximum health
    -- @function unit.healthMax
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return number Maximum health of the unit
    unit.healthMax = function(thisUnit)
        local UnitHealthMax = br._G["UnitHealthMax"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitHealthMax(thisUnit)
    end

    --- Get unit's health percentage
    -- @function unit.hp
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return number Health percentage of the unit (0-100)
    unit.hp = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        if unit.isDummy(thisUnit) then
            return 100
        end
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
        return #br.engines.healingEngine.friend > 1
    end

    --- Check instance type or if in a specific instance type
    -- @function unit.instance
    -- @param thisInstance Optional specific instance type to check for
    -- @return string|boolean Returns instance type if no parameter, or boolean if matching specific instance
    unit.instance = function(thisInstance)
        local select = _G["select"]
        local IsInInstance = br._G["IsInInstance"]
        local instanceType = select(2, IsInInstance())
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

    --- Check if you're running away from an enemy that is chasing you
    -- @function unit.chased
    -- @number[opt=10] range How close the chasing enemy is
    -- @return boolean True while an enemy within range chases you as you move away from it
    -- @usage if unit.chased(10) and cast.able.dash() then
    unit.chased = function(range)
        return br.functions.unit:isChased(range)
    end

    --- Check if an enemy is close enough to start a fight
    -- @function unit.enemyNear
    -- @number range Yards to look within
    -- @return boolean True when an enemy is already fighting within range, or an idle one's aggro range reaches you
    -- @usage if not unit.inCombat() and unit.enemyNear(20) and cast.able.prowl() then
    unit.enemyNear = function(range)
        return br.functions.unit:isEnemyNear(range)
    end

    --- Check if it's a good moment to start a fight
    -- @function unit.readyToFight
    -- @return boolean True when you aren't low on health or mana or eating or drinking, and in a group the tanks aren't low (Ready To Fight options, Targeting page)
    -- @usage if not unit.inCombat() and unit.readyToFight() and cast.able.faerieFire("target") then
    unit.readyToFight = function()
        return br.functions.combat:isReadyToFight()
    end

    --- Check if an enemy is attacking someone other than you
    -- @function unit.attackingOthers
    -- @param thisUnit The enemy to check
    -- @return boolean True when it's in combat, not attacking you, and its target is friendly
    -- @usage local thisUnit = enemies.first(enemies.yards5, unit.attackingOthers) -- a mob to taunt
    unit.attackingOthers = function(thisUnit)
        return br.functions.unit:isAttackingOthers(thisUnit)
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
    unit.isTankInRange = function()
        return br.functions.unit:isTankInRange()
    end

    --- Check if two units are the same
    -- @function unit.isUnit
    -- @param thisUnit First unit to compare
    -- @param otherUnit Second unit to compare
    -- @return boolean True if both units are the same
    unit.isUnit = function(thisUnit, otherUnit)
        local UnitIsUnit = br._G["UnitIsUnit"]
        if thisUnit == nil or otherUnit == nil then return false end
        return UnitIsUnit(thisUnit, otherUnit)
    end

    --- Get unit's level
    -- @function unit.level
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return number The level of the unit
    unit.level = function(thisUnit)
        local UnitLevel = br._G["UnitLevel"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitLevel(thisUnit)
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
        local IsMounted = br._G["IsMounted"]
        return IsMounted()
    end

    --- Seconds since the player last landed from a mount
    -- @function unit.timeSinceDismount
    -- @return number|nil Seconds since dismounting, nil while mounted or if not mounted since login
    unit.timeSinceDismount = function()
        local dismountTime = br.player.state.dismountTime
        return dismountTime and (br._G.GetTime() - dismountTime) or nil
    end

    --- Check if a unit is moving
    -- @function unit.moving
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return boolean True if the unit is moving
    unit.moving = function(thisUnit)
        local GetUnitSpeed = br._G["GetUnitSpeed"]
        if thisUnit == nil then thisUnit = "player" end
        return GetUnitSpeed(thisUnit) > 0
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
        local UnitName = br._G["UnitName"]
        if thisUnit == nil then return "" end
        return UnitName(thisUnit)
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
        return br._G["IsOutdoors"]
    end

    --- Check if a unit is a player
    -- @function unit.player
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is a player
    unit.player = function(thisUnit)
        local UnitIsPlayer = br._G["UnitIsPlayer"]
        return UnitIsPlayer(thisUnit)
    end

    --- Get unit's race
    -- @function unit.race
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return string The race of the unit
    unit.race = function(thisUnit)
        local select = _G["select"]
        local UnitRace = br._G["UnitRace"]
        if thisUnit == nil then thisUnit = "player" end
        return select(2, UnitRace(thisUnit))
    end

    --- Get the player's current ranged attack speed in seconds.
    -- Reads the live haste-modified speed from UnitRangedDamage so it reflects
    -- Rapid Fire, Quiver haste, and other modifiers automatically.
    -- @function unit.rangedAttackSpeed
    -- @return number Ranged weapon speed in seconds, or 0 if unavailable
    unit.rangedAttackSpeed = function()
        local _, _, speed = br._G.UnitRangedDamage("player")
        return speed or 0
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

    --- Check if player is resting
    -- @function unit.resting
    -- @return boolean True if player is resting
    unit.resting = function()
        return br._G.IsResting()
    end

    --- Get unit's assigned role in group
    -- @function unit.role
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return string The role assigned to the unit ("TANK", "HEALER", "DAMAGER", "NONE")
    unit.role = function(thisUnit)
        local UnitGroupRolesAssigned = br._G["UnitGroupRolesAssigned"]
        if thisUnit == nil then thisUnit = "target" end
        return UnitGroupRolesAssigned(thisUnit)
    end

    --- Check if player is solo (no group)
    -- @function unit.solo
    -- @return boolean True if player is solo
    unit.solo = function()
        return #br.engines.healingEngine.friend == 1
    end

    --- Get player's spell haste percentage
    -- @function unit.spellHaste
    -- @return number Spell haste percentage
    unit.spellHaste = function()
        return br._G.GetRangedHaste()
    end

    --- Get time a unit has been standing still
    -- @function unit.standingTime
    -- @return number Time in seconds the unit has been standing still
    unit.standingTime = function()
        return br.functions.misc:getStandingTime()
    end

    --- Start auto-attack
    -- @function unit.startAttack
    -- @return nil
    unit.startAttack = function()
        return br._G.StartAttack()
    end

    --- Stop auto-attack
    -- @function unit.stopAttack
    -- @return nil
    unit.stopAttack = function()
        return br._G.StopAttack()
    end

    --- Check if player is swimming
    -- @function unit.swimming
    -- @return boolean True if player is swimming
    unit.swimming = function()
        local IsSwimming = br._G["IsSwimming"]
        return IsSwimming()
    end

    --- Get the current target of a unit
    -- @function unit.target
    -- @param thisUnit The unit whose target to get
    -- @return string|nil Unit token of thisUnit's current target, or nil if none
    unit.target = function(thisUnit)
        local UnitTarget = br._G["UnitTarget"]
        return UnitTarget(thisUnit)
    end

    --- Check if a unit is on a taxi
    -- @function unit.taxi
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return boolean True if the unit is on a taxi
    unit.taxi = function(thisUnit)
        local UnitIsOnTaxi = br._G["UnitOnTaxi"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitIsOnTaxi(thisUnit)
    end

    --- Check if a unit has threat
    -- @function unit.threat
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit has threat
    unit.threat = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.functions.combat:hasThreat(thisUnit)
    end

    --- Get the player's current threat status
    -- @function unit.threatStatus
    -- @return number Threat status: 0=no/low threat, 1=high threat (not primary target),
    --   2=primary target (another unit has 100%+ threat), 3=primary target (sole aggro)
    unit.threatStatus = function()
        return br.functions.custom:getThreat()
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
        local enemies = self.enemies.get(range)
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
        local UnitDamage = br._G["UnitDamage"]
        local minDmg, maxDmg = UnitDamage(thisUnit)
        return (minDmg + maxDmg) / 2
    end

    --- Get weapon imbue charges
    -- @function unit.weaponImbue.charges
    -- @param imbueId The ID of the imbue to check
    -- @param offHand Boolean whether to check offhand (true) or main hand (false, default)
    -- @return number Number of charges remaining on the weapon imbue
    unit.weaponImbue.charges = function(imbueId, offHand)
        local GetWeaponEnchantInfo = br._G["GetWeaponEnchantInfo"]
        local _, _, mainCharges, _, _, _, offCharges = GetWeaponEnchantInfo()
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
        local GetWeaponEnchantInfo = br._G["GetWeaponEnchantInfo"]
        local hasMain, _, _, mainId, hasOff, _, _, offId = GetWeaponEnchantInfo()
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
            -- ID matching failed (IDs may be nil, zero, or incorrect for this game version).
            -- Fall back to presence-only: if any enchant exists on the configured hand,
            -- accept it rather than looping with endless reapplication attempts.
            if not offHand and hasMain then return true end
            if offHand     and hasOff  then return true end
            return false
        end
        if imbueId == nil then
            if offHand then imbueId = offId else imbueId = mainId end
        end
        if offHand and hasOff and offId == imbueId then return true end
        if not offHand and hasMain and mainId == imbueId then return true end
        return false
    end

    --- Check if a weapon imbue is missing (needs to be applied)
    -- @function unit.weaponImbue.needed
    -- @param imbueId The ID of the imbue to check for
    -- @param offHand Boolean whether to check offhand (true) or main hand (false, default)
    -- @return boolean True if the imbue is NOT currently applied to the specified weapon
    unit.weaponImbue.needed = function(imbueId, offHand)
        return not unit.weaponImbue.exists(imbueId, offHand)
    end

    --- Get weapon imbue remaining time
    -- @function unit.weaponImbue.remain
    -- @param imbueId The ID of the imbue to check
    -- @param offHand Boolean whether to check offhand (true) or main hand (false, default)
    -- @return number Time remaining on the weapon imbue in seconds
    unit.weaponImbue.remain = function(imbueId, offHand)
        local GetWeaponEnchantInfo = br._G["GetWeaponEnchantInfo"]
        local _, mainExp, _, _, _, offExp = GetWeaponEnchantInfo()
        local timeRemain = 0
        if offHand and unit.weaponImbue.exists(imbueId, true) then timeRemain = offExp - br._G.GetTime() end
        if not offHand and unit.weaponImbue.exists(imbueId) then timeRemain = mainExp - br._G.GetTime() end
        return timeRemain > 0 and timeRemain or 0
    end

    --- Get the display name of a weapon imbue spell
    -- @function unit.weaponImbue.spellName
    -- @param spellKey The spell key string (e.g. "rockbiterWeapon") used in br.player.spells
    -- @return string The localised spell name, or the key as a fallback
    unit.weaponImbue.spellName = function(spellKey)
        local spellID = br.player.spells and br.player.spells[spellKey]
        return (spellID and br.api.wow.GetSpellInfo(spellID)) or spellKey
    end
end
