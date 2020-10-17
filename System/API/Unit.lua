if br.api == nil then br.api = {} end
-- cd is the table located at br.player.cd
-- charges is the table located at br.player.charges
-- cast is the table located at br.player.cast
-- v is the spellID passed from the builder which cycles all the collected ability spells from the spell list for the spec
-- spell in the examples represent the name in the ability list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
br.api.unit = function(self,unit)
    -- Can Attack
    if unit.canAttack == nil then
        unit.canAttack = function(thisUnit,playerUnit)
            local UnitCanAttack = _G["UnitCanAttack"]
            if playerUnit == nil then playerUnit = "player" end
            return UnitCanAttack(thisUnit,playerUnit)
        end
    end
    -- Dead
    if unit.deadOrGhost == nil then
        unit.deadOrGhost = function(thisUnit)
            local UnitIsDeadOrGhost = _G["UnitIsDeadOrGhost"]
            return UnitIsDeadOrGhost(thisUnit)
        end
    end
    -- Distance
    if unit.distance == nil then
        unit.distance = function(thisUnit)
            local getDistance = _G["getDistance"]
            return getDistance(thisUnit)
        end
    end
    -- Enemy
    if unit.enemy == nil then
        unit.enemy = function(thisUnit,playerUnit)
            local UnitIsEnemy = _G["UnitIsEnemy"]
            if playerUnit == nil then playerUnit = "player" end
            return UnitIsEnemy(thisUnit,playerUnit)
        end
    end
    -- Exists
    if unit.exists == nil then
        unit.exists = function(thisUnit)
            local UnitExists = _G["GetUnitExists"]
            return UnitExists(thisUnit)
        end
    end
    -- Facing
    if unit.facing == nil then
        unit.facing = function(thisUnit,otherUnit)
            local getFacing = _G["getFacing"]
            if otherUnit == nil then otherUnit = "player" end
            return getFacing(thisUnit,otherUnit)
        end
    end 
    -- Flying
    if unit.flying == nil then
        unit.flying = function()
            return IsFlying()
        end
    end
    -- Friend
    if unit.friend == nil then
        unit.friend = function(thisUnit,playerUnit)
            local UnitIsFriend = _G["GetUnitIsFriend"]
            if playerUnit == nil then playerUnit = "player" end
            return UnitIsFriend(thisUnit,playerUnit)
        end
    end
    -- Global Cooldown (option: Max Global Cooldown)
    if unit.gcd == nil then
        unit.gcd = function(max)
            return getGlobalCD(max)
        end
    end
    -- Health
    if unit.health == nil then
        unit.health = function(thisUnit)
            local UnitHealth = _G["UnitHealth"]
            if thisUnit == nil then thisUnit = "player" end
            return UnitHealth(thisUnit)
        end
    end
    -- Health Max
    if unit.healthMax == nil then
        unit.healthMax = function(thisUnit)
            local UnitHealthMax = _G["UnitHealthMax"]
            if thisUnit == nil then thisUnit = "player" end
            return UnitHealthMax(thisUnit)
        end
    end
    -- Health Percent
    if unit.hp == nil then
        unit.hp = function(thisUnit)
            local getHP = _G["getHP"]
            if thisUnit == nil then thisUnit = "player" end
            return getHP(thisUnit)
        end
    end
    --  In Combat
    if unit.inCombat == nil then
        unit.inCombat = function(thisUnit)
            local UnitAffectingCombat = _G["UnitAffectingCombat"]
            local GetNumGroupMembers = _G["GetNumGroupMembers"]
            if thisUnit == nil then thisUnit = "player" end
            if UnitAffectingCombat(thisUnit) or self.ui.checked("Ignore Combat") 
                or (self.ui.checked("Tank Aggro = Player Aggro") and self.tankAggro())
                or (GetNumGroupMembers()>1 and (UnitAffectingCombat(thisUnit) or UnitAffectingCombat("target")))
            then
                return true
            end
            return false
        end
    end
    -- Instance Type (IE: "party" / "raid")
    if unit.instance == nil then
        unit.instance = function()
            return select(2,IsInInstance())
        end
    end
    -- Is Boss
    if unit.isBoss == nil then
        unit.isBoss = function(thisUnit)
            local isBoss = _G["isBoss"]
            return isBoss(thisUnit)
        end
    end
    -- Is Explosive
    if unit.isExplosive == nil then
        unit.isExplosive = function(thisUnit)
            local isExplosive = _G["isExplosive"]
            return isExplosive(thisUnit)
        end
    end
    -- Level
    if unit.level == nil then
        unit.level = function(thisUnit)
            if thisUnit == nil then thisUnit = "player" end
            return UnitLevel(thisUnit)
        end
    end
    -- Moving
    if unit.moving == nil then
        unit.moving = function(thisUnit)
            local GetUnitSpeed = _G["GetUnitSpeed"]
            if thisUnit == nil then thisUnit = "player" end
            return GetUnitSpeed(thisUnit) > 0
        end
    end
    -- Name
    if unit.name == nil then
        unit.name = function(thisUnit)
            local UnitName = _G["UnitName"]
            return UnitName(thisUnit)
        end
    end
    -- Player
    if unit.player == nil then
        unit.player = function(thisUnit)
            local UnitIsPlayer = _G["UnitIsPlayer"]
            return UnitIsPlayer(thisUnit)
        end
    end
    -- Reaction
    if unit.reaction == nil then
        unit.reaction = function(thisUnit,playerUnit)
            local GetUnitReaction = _G["GetUnitReaction"]
            if playerUnit == nil then playerUnit = "player" end
            return GetUnitReaction(thisUnit,playerUnit)
        end
    end
    -- Swimming
    if unit.swimming == nil then
        unit.swimming = function()
            return IsSwimming()
        end
    end
    -- Time Till Death
    if unit.ttd == nil then
        unit.ttd = function(thisUnit,percent)
            local getTTD = _G["getTTD"]
            if thisUnit == nil then thisUnit = "target" end
            return getTTD(thisUnit,percent)
        end
    end
    -- Valid
    if unit.valid == nil then
        unit.valid = function(thisUnit)
            local isValidUnit = _G["isValidUnit"]
            return isValidUnit(thisUnit)
        end
    end
end