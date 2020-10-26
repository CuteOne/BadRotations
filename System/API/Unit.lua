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

    -- Can Attack
    unit.canAttack = function(thisUnit,playerUnit)
        local UnitCanAttack = _G["UnitCanAttack"]
        if playerUnit == nil then playerUnit = "player" end
        return UnitCanAttack(thisUnit,playerUnit)
    end
    -- Dead
    unit.deadOrGhost = function(thisUnit)
        local UnitIsDeadOrGhost = _G["UnitIsDeadOrGhost"]
        return UnitIsDeadOrGhost(thisUnit)
    end
    -- Distance
    unit.distance = function(thisUnit,otherUnit)
        local getDistance = _G["getDistance"]
        return getDistance(thisUnit,otherUnit)
    end
    -- Enemy
    unit.enemy = function(thisUnit,playerUnit)
        local UnitIsEnemy = _G["UnitIsEnemy"]
        if playerUnit == nil then playerUnit = "player" end
        return UnitIsEnemy(thisUnit,playerUnit)
    end
    -- Exists
    unit.exists = function(thisUnit)
        local UnitExists = _G["GetUnitExists"]
        return UnitExists(thisUnit)
    end
    -- Facing
    unit.facing = function(thisUnit,otherUnit,degrees)
        local getFacing = _G["getFacing"]
        if otherUnit == nil then otherUnit = "player" end
        return getFacing(thisUnit,otherUnit,degrees)
    end
    -- Flying
    unit.flying = function()
        local IsFlying = _G["IsFlying"]
        return IsFlying()
    end
    -- Friend
    unit.friend = function(thisUnit,playerUnit)
        local UnitIsFriend = _G["GetUnitIsFriend"]
        if playerUnit == nil then playerUnit = "player" end
        return UnitIsFriend(thisUnit,playerUnit)
    end
    -- Global Cooldown (option: Max Global Cooldown)
    unit.gcd = function(max)
        local getGlobalCD = _G["getGlobalCD"]
        return getGlobalCD(max)
    end
    -- Health
    unit.health = function(thisUnit)
        local UnitHealth = _G["UnitHealth"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitHealth(thisUnit)
    end
    -- Health Max
    unit.healthMax = function(thisUnit)
        local UnitHealthMax = _G["UnitHealthMax"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitHealthMax(thisUnit)
    end
    -- Health Percent
    unit.hp = function(thisUnit)
        local getHP = _G["getHP"]
        if thisUnit == nil then thisUnit = "player" end
        return getHP(thisUnit)
    end
    --  In Combat
    unit.inCombat = function(thisUnit)
        local UnitAffectingCombat = _G["UnitAffectingCombat"]
        local GetNumGroupMembers = _G["GetNumGroupMembers"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitAffectingCombat(thisUnit) or self.ui.checked("Ignore Combat") 
            or (self.ui.checked("Tank Aggro = Player Aggro") and self.tankAggro())
            or (GetNumGroupMembers()>1 and (UnitAffectingCombat(thisUnit) or UnitAffectingCombat("target")))
    end
    -- Instance Type (IE: "party" / "raid")
    unit.instance = function(thisInstance)
        local select = _G["select"]
        local IsInInstance = _G["IsInInstance"]
        local instanceType = select(2,IsInInstance())
        return thisInstance == nil and instanceType or instanceType == thisInstance
    end
    -- Is Boss
    unit.isBoss = function(thisUnit)
        local isBoss = _G["isBoss"]
        return isBoss(thisUnit)
    end
    -- Is Dummy
    unit.isDummy = function(thisUnit)
        local isDummy = _G["isDummy"]
        return isDummy(thisUnit)
    end
    -- Is Explosive
    unit.isExplosive = function(thisUnit)
        local isExplosive = _G["isExplosive"]
        return isExplosive(thisUnit)
    end
    -- Is Unit
    unit.isUnit = function(thisUnit,otherUnit)
        local UnitIsUnit = _G["UnitIsUnit"]
        return UnitIsUnit(thisUnit,otherUnit)
    end
    -- Level
    unit.level = function(thisUnit)
        local UnitLevel = _G["UnitLevel"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitLevel(thisUnit)
    end
    -- Mounted
    unit.mounted = function()
        local IsMounted = _G["IsMounted"]
        return IsMounted()
    end
    -- Moving
    unit.moving = function(thisUnit)
        local GetUnitSpeed = _G["GetUnitSpeed"]
        if thisUnit == nil then thisUnit = "player" end
        return GetUnitSpeed(thisUnit) > 0
    end
    -- Name
    unit.name = function(thisUnit)
        local UnitName = _G["UnitName"]
        return UnitName(thisUnit)
    end
    -- No Control
    unit.noControl = function()
        local noControl = _G["hasNoControl"]
        return hasNoControl()
    end
    -- Player
    unit.player = function(thisUnit)
        local UnitIsPlayer = _G["UnitIsPlayer"]
        return UnitIsPlayer(thisUnit)
    end
    -- Race
    unit.race = function(thisUnit)
        local select = _G["select"]
        local UnitRace = _G["UnitRace"]
        if thisUnit == nil then thisUnit = "player" end
        return select(2,UnitRace("player"))
    end
    -- Reaction
    unit.reaction = function(thisUnit,playerUnit)
        local GetUnitReaction = _G["GetUnitReaction"]
        if playerUnit == nil then playerUnit = "player" end
        return GetUnitReaction(thisUnit,playerUnit)
    end
    -- Swimming
    unit.swimming = function()
        local IsSwimming = _G["IsSwimming"]
        return IsSwimming()
    end
    -- Threat
    unit.threat = function(thisUnit)
        local hasThreat = _G["hasThreat"]
        if thisUnit == nil then thisUnit = "target" end
        return hasThreat(thisUnit)
    end
    -- Time Till Death
    unit.ttd = function(thisUnit,percent)
        local getTTD = _G["getTTD"]
        if thisUnit == nil then thisUnit = "target" end
        return getTTD(thisUnit,percent)
    end
    -- Valid
    unit.valid = function(thisUnit)
        local isValidUnit = _G["isValidUnit"]
        return isValidUnit(thisUnit)
    end
end