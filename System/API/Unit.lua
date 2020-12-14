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
    -- Aberration
    unit.aberration = function(thisUnit)
        local isAberration = _G["isAberration"]
        if thisUnit == nil then thisUnit = "target" end
        return isAberration(thisUnit)
    end
    -- Beast
    unit.beast = function(thisUnit)
        local isBeast = _G["isBeast"]
        if thisUnit == nil then thisUnit = "target" end
        return isBeast(thisUnit)
    end
    -- Can Attack
    unit.canAttack = function(thisUnit,playerUnit)
        local UnitCanAttack = _G["UnitCanAttack"]
        if playerUnit == nil then playerUnit = "player" end
        return UnitCanAttack(thisUnit,playerUnit)
    end
    -- Cancelform
    unit.cancelForm = function()
        local RunMacroText = _G["RunMacroText"]
        local CancelShapeshiftForm = _G["CancelShapeshiftForm"]
        return CancelShapeshiftForm() or RunMacroText("/CancelForm")
    end
    -- Combat Time
    unit.combatTime = function()
        local getCombatTime = _G["getCombatTime"]
        return getCombatTime()
    end
    unit.ooCombatTime = function()
        local getOoCTime = _G["getOoCTime()"]
        return getOoCTime()
    end
    -- Charmed
    unit.charmed = function(thisUnit)
        local UnitIsCharmed = _G["UnitIsCharmed"]
        return UnitIsCharmed(thisUnit)
    end
    -- Dead
    unit.deadOrGhost = function(thisUnit)
        local UnitIsDeadOrGhost = _G["UnitIsDeadOrGhost"]
        return UnitIsDeadOrGhost(thisUnit)
    end
    -- Demon
    unit.demon = function(thisUnit)
        local isDemon = _G["isDemon"]
        if thisUnit == nil then thisUnit = "target" end
        return isDemon(thisUnit)
    end
    -- Distance
    unit.distance = function(thisUnit,otherUnit)
        local getDistance = _G["getDistance"]
        return getDistance(thisUnit,otherUnit)
    end
    -- Dual Wielding
    unit.dualWielding = function()
        local IsDualWielding = _G["IsDualWielding"]
        return IsDualWielding()
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
    -- Falling
    unit.falling = function()
        local IsFalling = _G["IsFalling"]
        return IsFalling()
    end
    -- Fall Time
    unit.fallTime = function()
        local getFallTime = _G["getFallTime"]
        return getFallTime()
    end
    -- Flying
    unit.flying = function()
        local IsFlying = _G["IsFlying"]
        return IsFlying()
    end
    -- Forms
    unit.form = function()
        local GetShapeshiftForm = _G["GetShapeshiftForm"]
        return GetShapeshiftForm()
    end
    unit.formCount = function()
        local GetNumShapeshiftForms = _G["GetNumShapeshiftForms"]
        return GetNumShapeshiftForms()
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
    -- Humanoid
    unit.humanoid = function(thisUnit)
        local isHumanoid = _G["isHumanoid"]
        if thisUnit == nil then thisUnit = "target" end
        return isHumanoid(thisUnit)
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
    -- Interruptable
    unit.interruptable = function(thisUnit,castPercent)
        local canInterrupt = _G["canInterrupt"]
        if thisUnit == nil then thisUnit = "target" end
        if castPercent == nil then castPercent = 0 end
        return canInterrupt(thisUnit,castPercent)
    end
    -- Is Boss
    unit.isBoss = function(thisUnit)
        local isBoss = _G["isBoss"]
        if thisUnit == nil then thisUnit = "target" end
        return isBoss(thisUnit)
    end
    -- Is Casting
    unit.isCasting = function(thisUnit)
        local isUnitCasting = _G.isUnitCasting
        if thisUnit == nil then thisUnit = "player" end
        return isUnitCasting(thisUnit)
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
        if thisUnit == nil or otherUnit == nil then return false end
        return UnitIsUnit(thisUnit,otherUnit)
    end
    -- Level
    unit.level = function(thisUnit)
        local UnitLevel = _G["UnitLevel"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitLevel(thisUnit)
    end
    -- Lowest Unit in Range
    unit.lowest = function(range)
        local getLowestUnit = _G["getLowestUnit"]
        if range == nil then range = 5 end
        return getLowestUnit(range)
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
    -- Moving Time
    local movingTimer
    unit.movingTime = function()
        local GetTime = _G["GetTime"]
        if movingTimer == nil then movingTimer = GetTime() end
        if not self.unit.moving() then
            movingTimer = GetTime()
        end
        return GetTime() - movingTimer
    end
    -- Name
    unit.name = function(thisUnit)
        local UnitName = _G["UnitName"]
        return UnitName(thisUnit)
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
    -- Role
    unit.role = function(thisUnit)
        local UnitGroupRolesAssigned = _G["UnitGroupRolesAssigned"]
        if thisUnit == nil then thisUnit = "target" end
        return UnitGroupRolesAssigned(thisUnit)
    end
    -- Start Attack
    local autoAttackStarted
    unit.startAttack = function(thisUnit,autoShoot)
        local IsCurrentSpell = _G["IsCurrentSpell"]
        local StartAttack = _G["StartAttack"]
        -- if (autoShoot and not IsCurrentSpell(75)) or not IsCurrentSpell(6603) then
        if autoAttackStarted == nil or not unit.inCombat() then autoAttackStarted = false end
        -- if not IsCurrentSpell(6603) then
        StartAttack(thisUnit)
        if not autoAttackStarted then
            if autoShoot then 
                self.ui.debug("Casting Auto Shot")
            else
                self.ui.debug("Casting Auto Attack")
            end
            autoAttackStarted = true
        end
    end
    -- Swimming
    unit.swimming = function()
        local IsSwimming = _G["IsSwimming"]
        return IsSwimming()
    end
    -- Taxi
    unit.taxi = function(thisUnit)
        local UnitIsOnTaxi = _G["UnitOnTaxi"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitIsOnTaxi(thisUnit)
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
    -- Time Till Death Group
    unit.ttdGroup = function(range,percent)
        local getTTD = _G["getTTD"]
        if range == nil then range = 5 end
        local enemies = self.enemies.get(range)
        local groupTTD = 0
        for i = 1, #enemies do
            groupTTD = groupTTD + getTTD(enemies[i],percent)
        end
        return groupTTD
    end
    -- Undead
    unit.undead = function(thisUnit)
        local isUndead = _G["isUndead"]
        return isUndead(thisUnit)
    end
    -- Valid
    unit.valid = function(thisUnit)
        local isValidUnit = _G["isValidUnit"]
        return isValidUnit(thisUnit)
    end
    -- Weapon Imbue Fuctions
    if unit.weaponImbue == nil then unit.weaponImbue = {} end
    -- Weapon Imbue Exists
    unit.weaponImbue.exists = function(imbueId,offHand)
        local GetWeaponEnchantInfo = _G["GetWeaponEnchantInfo"]
        local hasMain, _, _, mainId, hasOff, _, _, offId = GetWeaponEnchantInfo()
        if offHand == nil then offHand = false end
        if imbueId == nil then
            if offHand then imbueId = offId else imbueId = mainId end
        end
        if offHand and hasOff and offId == imbueId then return true end
        if not offHand and hasMain and mainId == imbueId then return true end
        return false
    end
    -- Weapon Imbue Remains
    unit.weaponImbue.remain = function(imbueId,offHand)
        local GetWeaponEnchantInfo = _G["GetWeaponEnchantInfo"]
        local _, mainExp, _, _, _, offExp = GetWeaponEnchantInfo()
        local timeRemain = 0
        if offHand and self.unit.weaponImbue.exists(imbueId,true) then timeRemain = offExp - GetTime() end
        if not offHand and self.unit.weaponImbue.exists(imbueId) then timeRemain = mainExp - GetTime() end
        return timeRemain > 0 and timeRemain or 0
    end
    -- Weapon Imbue Charges
    unit.weaponImbue.charges = function(imbueId,offHand)
        local GetWeaponEnchantInfo = _G["GetWeaponEnchantInfo"]
        local _, _, mainCharges, _, _, _, offCharges = GetWeaponEnchantInfo()
        if offHand and self.unit.weaponImbue.exists(imbueId,true) then return offCharges end
        if not offHand and self.unit.weaponImbue.exists(imbueId) then return mainCharges end
        return 0
    end
end