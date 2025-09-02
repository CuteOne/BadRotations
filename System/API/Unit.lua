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

    --- Check if a unit is an Aberration
    -- @function unit.aberration
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is an Aberration
    unit.aberration = function(thisUnit)
        local isAberration = br["isAberration"]
        if thisUnit == nil then thisUnit = "target" end
        return isAberration(thisUnit)
    end

    --- Check if a unit is a Beast
    -- @function unit.beast
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is a Beast
    unit.beast = function(thisUnit)
        local isBeast = br["isBeast"]
        if thisUnit == nil then thisUnit = "target" end
        return isBeast(thisUnit)
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

    --- Cancel current shapeshift form
    -- @function unit.cancelForm
    -- @return nil
    unit.cancelForm = function()
        local CancelShapeshiftForm = br._G["CancelShapeshiftForm"]
        return CancelShapeshiftForm() --or RunMacroText("/CancelForm")
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
        local spellName = br._G.GetSpellInfo(spellID)
        return tostring(spellCasting) == tostring(spellName)
    end

    --- Get combat time
    -- @function unit.combatTime
    -- @return number Time in combat in seconds
    unit.combatTime = function()
        return br.getCombatTime()
    end

    --- Get time out of combat
    -- @function unit.ooCombatTime
    -- @return number Time out of combat in seconds
    unit.ooCombatTime = function()
        local getOoCTime = br["getOoCTime()"]
        return getOoCTime()
    end

    --- Check if a unit is charmed
    -- @function unit.charmed
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is charmed
    unit.charmed = function(thisUnit)
        local UnitIsCharmed = br._G["UnitIsCharmed"]
        return UnitIsCharmed(thisUnit)
    end

    --- Clear current target
    -- @function unit.clearTarget
    -- @return nil
    unit.clearTarget = function()
        return br._G.ClearTarget()
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
        local isDemon = br["isDemon"]
        if thisUnit == nil then thisUnit = "target" end
        return isDemon(thisUnit)
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
        return br.getDistance(thisUnit, otherUnit)
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
        local UnitExists = br["GetUnitExists"]
        return UnitExists(thisUnit)
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
        return br.getFacing(thisUnit, otherUnit, degrees)
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
        local getFallTime = br["getFallTime"]
        return getFallTime()
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

    --- Get number of available shapeshift forms
    -- @function unit.formCount
    -- @return number Count of available shapeshift forms
    unit.formCount = function()
        local GetNumShapeshiftForms = br._G["GetNumShapeshiftForms"]
        return GetNumShapeshiftForms()
    end

    --- Check if a unit is friendly to another unit
    -- @function unit.friend
    -- @param thisUnit The unit to check
    -- @param playerUnit The reference unit, defaults to "player" if nil
    -- @return boolean True if thisUnit is friendly to playerUnit
    unit.friend = function(thisUnit, playerUnit)
        local UnitIsFriend = br["GetUnitIsFriend"]
        if playerUnit == nil then playerUnit = "player" end
        return UnitIsFriend(thisUnit, playerUnit)
    end

    --- Get global cooldown duration
    -- @function unit.gcd
    -- @param max Optional boolean to return maximum possible GCD instead of current
    -- @return number Global cooldown in seconds
    unit.gcd = function(max)
        return br.getGlobalCD(max)
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
        local getHP = br["getHP"]
        if thisUnit == nil then thisUnit = "player" end
        return br.round2(getHP(thisUnit), 2)
    end

    --- Check if a unit is a Humanoid
    -- @function unit.humanoid
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is a Humanoid
    unit.humanoid = function(thisUnit)
        local isHumanoid = br["isHumanoid"]
        if thisUnit == nil then thisUnit = "target" end
        return isHumanoid(thisUnit)
    end

    --- Get unit's ID
    -- @function unit.id
    -- @param thisUnit The unit to get ID for
    -- @return number Unit's ID
    unit.id = function(thisUnit)
        return br.GetObjectID(thisUnit)
    end

    --- Check if a unit is in combat
    -- @function unit.inCombat
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return boolean True if the unit is in combat or special conditions are met
    unit.inCombat = function(thisUnit)
        local UnitAffectingCombat = br._G["UnitAffectingCombat"]
        local GetNumGroupMembers = br._G["GetNumGroupMembers"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitAffectingCombat(thisUnit) or self.ui.checked("Ignore Combat")
            or (self.ui.checked("Tank Aggro = Player Aggro") and self.tankAggro())
            or (GetNumGroupMembers() > 1 and (UnitAffectingCombat(thisUnit) or UnitAffectingCombat("target")))
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
        return br.canInterrupt(thisUnit, castPercent)
    end

    --- Check if a unit is a boss
    -- @function unit.isBoss
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @return boolean True if the unit is a boss
    unit.isBoss = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.isBoss(thisUnit)
    end

    --- Check if a unit is casting
    -- @function unit.isCasting
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return boolean True if the unit is casting
    unit.isCasting = function(thisUnit)
        local isUnitCasting = br.isUnitCasting
        if thisUnit == nil then thisUnit = "player" end
        return isUnitCasting(thisUnit)
    end

    --- Check if a unit is a training dummy
    -- @function unit.isDummy
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is a training dummy
    unit.isDummy = function(thisUnit)
        return br.isDummy(thisUnit)
    end

    --- Check if a unit is an explosive orb (M+ affix)
    -- @function unit.isExplosive
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is an explosive orb
    unit.isExplosive = function(thisUnit)
        local isExplosive = br["isExplosive"]
        return isExplosive(thisUnit)
    end

    --- Check if a unit is tanking
    -- @function unit.isTanking
    -- @param thisUnit The unit to check, defaults to "player" if nil
    -- @return boolean True if the unit is tanking
    unit.isTanking = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.isTanking(thisUnit)
    end

    --- Check if a tank is in range
    -- @function unit.isTankInRange
    -- @return boolean True if a tank is in range
    unit.isTankInRange = function()
        return br.isTankInRange()
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
        local getLowestUnit = br["getLowestUnit"]
        if range == nil then range = 5 end
        return getLowestUnit(range)
    end

    --- Check if player is mounted
    -- @function unit.mounted
    -- @return boolean True if player is mounted
    unit.mounted = function()
        local IsMounted = br._G["IsMounted"]
        return IsMounted()
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
    local movingTimer
    unit.movingTime = function()
        local GetTime = br._G["GetTime"]
        if movingTimer == nil then movingTimer = GetTime() end
        if not unit.moving() then
            movingTimer = GetTime()
        end
        return GetTime() - movingTimer
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

    --- Check if a unit is a player
    -- @function unit.player
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is a player
    unit.player = function(thisUnit)
        local UnitIsPlayer = br._G["UnitIsPlayer"]
        return UnitIsPlayer(thisUnit)
    end

    --- Check if player is outdoors
    -- @function unit.outdoors
    -- @return boolean True if player is outdoors
    unit.outdoors = function()
        return br._G["IsOutdoors"]
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

    --- Get unit's reaction level towards another unit
    -- @function unit.reaction
    -- @param thisUnit The unit to check reaction of
    -- @param playerUnit The reference unit, defaults to "player" if nil
    -- @return number Reaction level (1-hostile to 8-friendly)
    unit.reaction = function(thisUnit, playerUnit)
        local GetUnitReaction = br["GetUnitReaction"]
        if playerUnit == nil then playerUnit = "player" end
        return GetUnitReaction(thisUnit, playerUnit)
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
        return #br.friend == 1
    end

    --- Get player's spell haste percentage
    -- @function unit.spellHaste
    -- @return number Spell haste percentage
    unit.spellHaste = function()
        return br._G.GetRangedHaste()
    end

    local standingTimer
    --- Get time a unit has been standing still
    -- @function unit.standingTime
    -- @return number Time in seconds the unit has been standing still
    unit.standingTime = function()
        local GetTime = br._G["GetTime"]
        if standingTimer == nil then standingTimer = GetTime() end
        if unit.moving() then
            standingTimer = GetTime()
        end
        return GetTime() - standingTimer
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
        return br.hasThreat(thisUnit)
    end

    --- Estimate time until unit dies
    -- @function unit.ttd
    -- @param thisUnit The unit to check, defaults to "target" if nil
    -- @param percent Optional health percentage to calculate time to
    -- @return number Estimated time until death in seconds
    unit.ttd = function(thisUnit, percent)
        if thisUnit == nil then thisUnit = "target" end
        return br.getTTD(thisUnit, percent) or 0
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
        local isUndead = br["isUndead"]
        return isUndead(thisUnit)
    end

    --- Check if a unit is valid for targeting
    -- @function unit.valid
    -- @param thisUnit The unit to check
    -- @return boolean True if the unit is valid
    unit.valid = function(thisUnit)
        return br.isValidUnit(thisUnit)
    end

    -- Weapon Imbue Fuctions
    unit.weaponImbue = unit.weaponImbue or {}

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
            for i = 1, #imbueId do
                if (offHand and hasOff) and offId == imbueId[i] then return true end
                if (not offHand and hasMain) and mainId == imbueId[i] then return true end
            end
            return false
        end
        if imbueId == nil then
            if offHand then imbueId = offId else imbueId = mainId end
        end
        if offHand and hasOff and offId == imbueId then return true end
        if not offHand and hasMain and mainId == imbueId then return true end
        return false
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
end
