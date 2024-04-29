
local _, br = ...
if br.api == nil then br.api = {} end
----------------------
--- ABOUT THIS API ---
----------------------

-- These calls help in retrieving information about unit based checks.
-- unit is the table located at br.player.unit, call this in profile to use.

br.api.unit = function(self)
    -- Local reference to unit
    local unit --= self.unit

    ----------------
    --- Unit API ---
    ----------------
    -- Aberration
    unit.aberration = function(thisUnit)
        local isAberration = br["isAberration"]
        if thisUnit == nil then thisUnit = "target" end
        return isAberration(thisUnit)
    end
    -- Beast
    unit.beast = function(thisUnit)
        local isBeast = br["isBeast"]
        if thisUnit == nil then thisUnit = "target" end
        return isBeast(thisUnit)
    end
    -- Can Attack
    unit.canAttack = function(thisUnit,playerUnit)
        local UnitCanAttack = br._G["UnitCanAttack"]
        if playerUnit == nil then playerUnit = "player" end
        return UnitCanAttack(thisUnit,playerUnit)
    end
    -- Cancelform
    unit.cancelForm = function()
        local RunMacroText = br._G.RunMacroText
        local CancelShapeshiftForm = br._G["CancelShapeshiftForm"]
        return CancelShapeshiftForm() or RunMacroText("/CancelForm")
    end
    -- Casting / Channelling
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

    -- Combat Time
    unit.combatTime = function()
        return br.getCombatTime()
    end
    unit.ooCombatTime = function()
        local getOoCTime = br["getOoCTime()"]
        return getOoCTime()
    end
    -- Charmed
    unit.charmed = function(thisUnit)
        local UnitIsCharmed = br._G["UnitIsCharmed"]
        return UnitIsCharmed(thisUnit)
    end
    -- Clear Targets
    unit.clearTarget = function()
        return br._G.ClearTarget()
    end
    -- Dead
    unit.deadOrGhost = function(thisUnit)
        local UnitIsDeadOrGhost = br._G["UnitIsDeadOrGhost"]
        return UnitIsDeadOrGhost(thisUnit)
    end
    -- Demon
    unit.demon = function(thisUnit)
        local isDemon = br["isDemon"]
        if thisUnit == nil then thisUnit = "target" end
        return isDemon(thisUnit)
    end
    -- Distance
    unit.distance = function(thisUnit,otherUnit)
        return br.getDistance(thisUnit,otherUnit)
    end
    -- Dual Wielding
    unit.dualWielding = function()
        local IsDualWielding = br._G["IsDualWielding"]
        return IsDualWielding()
    end
    -- Enemy
    unit.enemy = function(thisUnit,playerUnit)
        local UnitIsEnemy = br._G["UnitIsEnemy"]
        if playerUnit == nil then playerUnit = "player" end
        return UnitIsEnemy(thisUnit,playerUnit)
    end
    -- Exists
    unit.exists = function(thisUnit)
        local UnitExists = br["GetUnitExists"]
        return UnitExists(thisUnit)
    end
    -- Facing
    unit.facing = function(thisUnit,otherUnit,degrees)
        if otherUnit == nil then otherUnit = thisUnit; thisUnit = "player" end
        return br.getFacing(thisUnit,otherUnit,degrees)
    end
    -- Falling
    unit.falling = function()
        local IsFalling = br._G["IsFalling"]
        return IsFalling()
    end
    -- Fall Time
    unit.fallTime = function()
        local getFallTime = br["getFallTime"]
        return getFallTime()
    end
    -- Flying
    unit.flying = function()
        local IsFlying = br._G["IsFlying"]
        return IsFlying()
    end
    -- Forms
    unit.form = function()
        local GetShapeshiftForm = br._G["GetShapeshiftForm"]
        return GetShapeshiftForm()
    end
    unit.formCount = function()
        local GetNumShapeshiftForms = br._G["GetNumShapeshiftForms"]
        return GetNumShapeshiftForms()
    end
    -- Friend
    unit.friend = function(thisUnit,playerUnit)
        local UnitIsFriend = br["GetUnitIsFriend"]
        if playerUnit == nil then playerUnit = "player" end
        return UnitIsFriend(thisUnit,playerUnit)
    end
    -- Global Cooldown (option: Max Global Cooldown)
    unit.gcd = function(max)
        return br.getGlobalCD(max)
    end
    -- GUID
    unit.guid = function(thisUnit)
        local UnitGUID = br._G["UnitGUID"]
        return UnitGUID(thisUnit)
    end
    -- Health
    unit.health = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br._G.UnitHealth(thisUnit)
    end
    -- Health Max
    unit.healthMax = function(thisUnit)
        local UnitHealthMax = br._G["UnitHealthMax"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitHealthMax(thisUnit)
    end
    -- Health Percent
    unit.hp = function(thisUnit)
        local getHP = br["getHP"]
        if thisUnit == nil then thisUnit = "player" end
        return br.round2(getHP(thisUnit),2)
    end
    -- Humanoid
    unit.humanoid = function(thisUnit)
        local isHumanoid = br["isHumanoid"]
        if thisUnit == nil then thisUnit = "target" end
        return isHumanoid(thisUnit)
    end
    -- ID
    unit.id = function(thisUnit)
        return br.GetObjectID(thisUnit)
    end
    --  In Combat
    unit.inCombat = function(thisUnit)
        local UnitAffectingCombat = br._G["UnitAffectingCombat"]
        local GetNumGroupMembers = br._G["GetNumGroupMembers"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitAffectingCombat(thisUnit) or self.ui.checked("Ignore Combat")
            or (self.ui.checked("Tank Aggro = Player Aggro") and self.tankAggro())
            or (GetNumGroupMembers()>1 and (UnitAffectingCombat(thisUnit) or UnitAffectingCombat("target")))
    end
    -- Instance Type (IE: "party" / "raid")
    unit.instance = function(thisInstance)
        local select = _G["select"]
        local IsInInstance = br._G["IsInInstance"]
        local instanceType = select(2,IsInInstance())
        return thisInstance == nil and instanceType or instanceType == thisInstance
    end
    -- Interruptable
    unit.interruptable = function(thisUnit,castPercent)
        if thisUnit == nil then thisUnit = "target" end
        if castPercent == nil then castPercent = 0 end
        return br.canInterrupt(thisUnit,castPercent)
    end
    -- Is Boss
    unit.isBoss = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.isBoss(thisUnit)
    end
    -- Is Casting
    unit.isCasting = function(thisUnit)
        local isUnitCasting = br.isUnitCasting
        if thisUnit == nil then thisUnit = "player" end
        return isUnitCasting(thisUnit)
    end
    -- Is Dummy
    unit.isDummy = function(thisUnit)
        return br.isDummy(thisUnit)
    end
    -- Is Explosive
    unit.isExplosive = function(thisUnit)
        local isExplosive = br["isExplosive"]
        return isExplosive(thisUnit)
    end
    -- Is Tanking
    unit.isTanking = function(thisUnit)
        if thisUnit == nil then thisUnit = "player" end
        return br.isTanking(thisUnit)
    end
    -- Is Tank In Range
    unit.isTankInRange = function()
        return br.isTankInRange()
    end
    -- Is Unit
    unit.isUnit = function(thisUnit,otherUnit)
        local UnitIsUnit = br._G["UnitIsUnit"]
        if thisUnit == nil or otherUnit == nil then return false end
        return UnitIsUnit(thisUnit,otherUnit)
    end
    -- Level
    unit.level = function(thisUnit)
        local UnitLevel = br._G["UnitLevel"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitLevel(thisUnit)
    end
    -- Lowest Unit in Range
    unit.lowest = function(range)
        local getLowestUnit = br["getLowestUnit"]
        if range == nil then range = 5 end
        return getLowestUnit(range)
    end
    -- Mounted
    unit.mounted = function()
        local IsMounted = br._G["IsMounted"]
        return IsMounted()
    end
    -- Moving
    unit.moving = function(thisUnit)
        local GetUnitSpeed = br._G["GetUnitSpeed"]
        if thisUnit == nil then thisUnit = "player" end
        return GetUnitSpeed(thisUnit) > 0
    end
    -- Moving Time
    local movingTimer
    unit.movingTime = function()
        local GetTime = br._G["GetTime"]
        if movingTimer == nil then movingTimer = GetTime() end
        if not unit.moving() then
            movingTimer = GetTime()
        end
        return GetTime() - movingTimer
    end
    -- Name
    unit.name = function(thisUnit)
        local UnitName = br._G["UnitName"]
        return UnitName(thisUnit)
    end
    -- Player
    unit.player = function(thisUnit)
        local UnitIsPlayer = br._G["UnitIsPlayer"]
        return UnitIsPlayer(thisUnit)
    end
    -- Outdoors
    unit.outdoors = function()
        return br._G["IsOutdoors"]
    end
    -- Race
    unit.race = function(thisUnit)
        local select = _G["select"]
        local UnitRace = br._G["UnitRace"]
        if thisUnit == nil then thisUnit = "player" end
        return select(2,UnitRace(thisUnit))
    end
    -- Reaction
    unit.reaction = function(thisUnit,playerUnit)
        local GetUnitReaction = br["GetUnitReaction"]
        if playerUnit == nil then playerUnit = "player" end
        return GetUnitReaction(thisUnit,playerUnit)
    end
    -- Resting
    unit.resting = function()
        return br._G.IsResting()
    end
    -- Role
    unit.role = function(thisUnit)
        local UnitGroupRolesAssigned = br._G["UnitGroupRolesAssigned"]
        if thisUnit == nil then thisUnit = "target" end
        return UnitGroupRolesAssigned(thisUnit)
    end
    -- Solo
    unit.solo = function()
        return #br.friend == 1
    end
    -- Spell Haste
    unit.spellHaste = function()
        return br._G.GetRangedHaste()
    end
    -- Standing Time
    local standingTimer
    unit.standingTime = function()
        local GetTime = br._G["GetTime"]
        if standingTimer == nil then standingTimer = GetTime() end
        if unit.moving() then
            standingTimer = GetTime()
        end
        return GetTime() - standingTimer
    end
    -- Start Attack
    unit.startAttack = function()
        return br._G.StartAttack()
    end
    -- Stop Attack
    unit.stopAttack = function()
        return br._G.StopAttack()
    end
    -- Swimming
    unit.swimming = function()
        local IsSwimming = br._G["IsSwimming"]
        return IsSwimming()
    end
    -- Taxi
    unit.taxi = function(thisUnit)
        local UnitIsOnTaxi = br._G["UnitOnTaxi"]
        if thisUnit == nil then thisUnit = "player" end
        return UnitIsOnTaxi(thisUnit)
    end
    -- Threat
    unit.threat = function(thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        return br.hasThreat(thisUnit)
    end
    -- Time Till Death
    unit.ttd = function(thisUnit,percent)
        if thisUnit == nil then thisUnit = "target" end
        return br.getTTD(thisUnit,percent) or 0
    end
    -- Time Till Death Group
    unit.ttdGroup = function(range,percent)
        if range == nil then range = 5 end
        local enemies = self.enemies.get(range)
        local groupTTD = 0
        for i = 1, #enemies do
            groupTTD = groupTTD + unit.ttd(enemies[i],percent)
        end
        return groupTTD
    end
    -- Undead
    unit.undead = function(thisUnit)
        local isUndead = br["isUndead"]
        return isUndead(thisUnit)
    end
    -- Valid
    unit.valid = function(thisUnit)
        return br.isValidUnit(thisUnit)
    end
    -- Weapon Imbue Fuctions
    unit.weaponImbue = unit.weaponImbue or {}

    -- Weapon Imbue Exists
    unit.weaponImbue.exists = function(imbueId,offHand)
        local GetWeaponEnchantInfo = br._G["GetWeaponEnchantInfo"]
        local hasMain, _, _, mainId, hasOff, _, _, offId = GetWeaponEnchantInfo()
        if offHand == nil then offHand = false end
        if type(imbueId) == "table" then
            for i=1,#imbueId do
                if (offHand and hasOff) and offId==imbueId[i] then return true end
                if (not offHand and hasMain) and mainId==imbueId[i] then return true end
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
    -- Weapon Imbue Remains
    unit.weaponImbue.remain = function(imbueId,offHand)
        local GetWeaponEnchantInfo = br._G["GetWeaponEnchantInfo"]
        local _, mainExp, _, _, _, offExp = GetWeaponEnchantInfo()
        local timeRemain = 0
        if offHand and unit.weaponImbue.exists(imbueId,true) then timeRemain = offExp - br._G.GetTime() end
        if not offHand and unit.weaponImbue.exists(imbueId) then timeRemain = mainExp - br._G.GetTime() end
        return timeRemain > 0 and timeRemain or 0
    end
    -- Weapon Imbue Charges
    unit.weaponImbue.charges = function(imbueId,offHand)
        local GetWeaponEnchantInfo = br._G["GetWeaponEnchantInfo"]
        local _, _, mainCharges, _, _, _, offCharges = GetWeaponEnchantInfo()
        if offHand and unit.weaponImbue.exists(imbueId,true) then return offCharges end
        if not offHand and unit.weaponImbue.exists(imbueId) then return mainCharges end
        return 0
    end
end