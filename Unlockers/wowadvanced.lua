local _, br = ...
local b = br._G
local unlock = br.unlock
local CurrentTable, OldTable
-- local _G = setmetatable({_G={}, otherVariableToHide = {}},{__index = _G})

local SecureCall = function(s)
    return function(...)
        return CallSecureFunction(s, ...)
    end
end

local function copyTable(datatable)
    local tblRes = {}
    if type(datatable) == "table" then
        for k, v in pairs(datatable) do
            tblRes[copyTable(k)] = copyTable(v)
        end
    else
        tblRes = datatable
    end
    return tblRes
end

local TagHandlerList = {'UnitInPhase', 'SetPortraitTexture', 'UnitUsingVehicle', 'UnitSex', 'UnitSelectionColor',
                        'UnitPower', 'UnitIsPVPSanctuary', 'UnitIsPVPFreeForAll', 'UnitIsAFK', 'UnitIsInMyGuild',
                        'GetPlayerInfoByGUID', 'UnitDefense', 'InviteUnit', 'GetUnitName', 'CombatTextSetActiveUnit',
                        'SummonFriend', 'CanSummonFriend', 'GrantLevel', 'CanGrantLevel', 'GetReadyCheckStatus',
                        'GetPartyAssignment', 'DemoteAssistant', 'PromoteToAssistant', "IsSpellInRange",
                        "IsItemInRange", "UnitInRange", "UnitAura", "UnitAuraSlots", "UnitPlayerControlled",
                        "UnitIsVisible", "GetUnitSpeed", "UnitClass", "UnitIsTappedByPlayer", "UnitThreatSituation",
                        "UnitCanAttack", "UnitCreatureType", "UnitIsDeadOrGhost", "UnitDetailedThreatSituation",
                        "UnitIsUnit", "UnitHealthMax", "UnitAffectingCombat", "UnitIsPlayer", "UnitIsDead",
                        "UnitInParty", "UnitInRaid", "UnitHealth", "UnitCastingInfo", "UnitChannelInfo", "UnitName",
                        "UnitBuff", "UnitDebuff", "UnitIsFriend", "UnitClassification", "UnitReaction",
                        "UnitGroupRolesAssigned", "UnitXPMax", "UnitXP", "UnitStat", "UnitPhaseReason",
                        "UnitResistance", "UnitRangedDamage", "UnitRangedAttackPower", "UnitRangedAttack", "UnitRace",
                        "UnitPowerType", "UnitPowerMax", "UnitPower", "UnitPVPName", "UnitPlayerOrPetInRaid",
                        "UnitPlayerOrPetInParty", "UnitManaMax", "UnitMana", "UnitLevel", "UnitIsTrivial",
                        "UnitIsTapped", "UnitIsSameServer", "UnitIsPossessed", "UnitIsPVP", "UnitIsGhost",
                        "UnitIsFeignDeath", "UnitIsEnemy", "UnitIsDND", "UnitIsCorpse", "UnitIsConnected",
                        "UnitIsCharmed", "UnitInBattleground", "UnitDamage", "UnitCreatureFamily", "UnitCanCooperate",
                        "UnitCanAssist", "UnitAttackSpeed", "UnitAttackPower", "UnitAttackBothHands", "UnitArmor",
                        "GetUnitPitch", "FollowUnit", "CheckInteractDistance", "InitiateTrade", "UnitOnTaxi",
                        "AssistUnit", "SpellTargetUnit", "CopyToClipboard", "SpellTargetItem", "SpellCanTargetUnit",
                        "SetRaidTarget", "GetRaidTargetIndex", "IsUnitOnQuest", "DropItemOnUnit", "GetDefaultLanguage",
                        "GetCritChanceFromAgility", "GetSpellCritChanceFromIntellect", "UnitGetTotalHealAbsorbs",
                        "UnitGetIncomingHeals", "CastSpellByName", "CastSpellByID", "UseItemByName", "SpellIsTargeting",
                        "InteractUnit", "CancelUnitBuff", "TargetUnit", "UnitGUID", "UnitExists"}
local UnlockList = {'PetAssistMode', 'PetPassiveMode', 'MoveForwardStop', 'Stuck', 'SwapRaidSubgroup', 'ToggleAutoRun',
                    'ToggleRun', 'UIObject_SetForbidden', 'UninviteUnit', 'UseContainerItem', 'AcceptBattlefieldPort',
                    'CancelItemTempEnchantment', "ToggleGameMenu", "RunMacroText", "UseInventoryItem",
                    "SpellStopCasting", "CameraOrSelectOrMoveStart", "CameraOrSelectOrMoveStop", "CancelShapeshiftForm",
                    "SpellStopTargeting", "AscendStop", "JumpOrAscendStart", "JumpOrAscendStop", "MoveBackwardStart",
                    "MoveBackwardStop", "MoveForwardStart", "StrafeLeftStart", "StrafeLeftStop", "StrafeRightStart",
                    "StrafeRightStop", "TurnLeftStart", "TurnLeftStop", "TurnRightStart", "TurnRightStop",
                    "PitchUpStart", "PitchDownStart", "PitchDownStop", "ClearTarget", "AcceptProposal", "CastPetAction",
                    "CastShapeshiftForm", "CastSpell", "ChangeActionBarPage", "ClearOverrideBindings", "CreateMacro",
                    "DeleteCursorItem", "DeleteMacro", "DescendStop", "DestroyTotem", "FocusUnit", "ForceQuit",
                    "GetUnscaledFrameRect", "GuildControlSetRank", "GuildControlSetRankFlag", "GuildDemote",
                    "GuildPromote", "GuildUninvite", "JoinBattlefield", "Logout", "PetAttack", "PetDefensiveAssistMode",
                    "PetDefensiveMode", "PetFollow", "PetStopAttack", "PetWait", "PickupAction", "PickupCompanion",
                    "PickupMacro", "PickupPetAction", "PickupSpell", "PickupSpellBookItem", "Quit", "Region_GetBottom",
                    "Region_GetCenter", "Region_GetPoint", "Region_GetRect", "Region_Hide", "Region_SetPoint",
                    "Region_Show", "RegisterForSave", "ReplaceEnchant", "ReplaceTradeEnchant", "RunMacro",
                    "SendChatMessage", "SetBinding", "SetBindingClick", "SetBindingItem", "SetBindingMacro",
                    "SetBindingSpell", "SetCurrentTitle", "SetMoveEnabled", "SetOverrideBinding",
                    "SetOverrideBindingClick", "SetOverrideBindingItem", "SetOverrideBindingMacro",
                    "SetOverrideBindingSpell", "SetTurnEnabled", "ShowUIPanel", "SitStandOrDescendStart",
                    "TargetLastEnemy", "TargetLastTarget", "TargetNearestEnemy", "TargetNearestFriend",
                    "TurnOrActionStart", "TurnOrActionStop", "UseAction", "UseToy", "UseToyByName", "AcceptTrade",
                    "AttackTarget", "CancelLogout", "StartAttack"}
local function EnumVisibleObjects()
    local table = {}
    for i = 1, GetObjectCount() do
        table[i] = GetObjectWithIndex(i)
    end
    return table;
end

local function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function unlock.WowAdUnlock()
    local unlocked = false
    for _, val in ipairs(TagHandlerList) do
        for _, rot in ipairs(UnlockList) do
            if val == rot then
                print(rot)
            end
        end
    end
    local function Unlock(method)
        b[method] = SecureCall(_G[method])
    end
    local function UnitTagHandler(method)
        b[method] = SecureCall(_G[method])

    end
    for _, method in ipairs(TagHandlerList) do
        UnitTagHandler(method)
    end
    for _, method in ipairs(UnlockList) do
        Unlock(method)
    end
    b.GetCameraPosition = function(...)
        return 0, 0, 0
    end
    b.AuraUtil = {}
    b.AuraUtil.FindAuraByName = function(...)
        return CallSecureFunction(_G.AuraUtil["FindAuraByName"], ...)
    end
    b.ObjectPointer = function(...)
        if b.UnitExists(...) then
            return b.UnitGUID
        end
    end -- compatibility change as LB returns GUIDs instead of Pointers in their OM
    b.ObjectPosition = function(...)
        return GetUnitPosition(...);
    end
    b.ObjectGUID = br._G.UnitGUID
    b.ObjectIsUnit = function(...)
        local ObjType = ObjectType(...)
        return ObjType == 5 or ObjType == 6 or ObjType == 7
    end
    b.ObjectIsGameObject = function(...)
        local ObjType = ObjectType(...)
        return ObjType == 8 or ObjType == 11
    end
    b.ObjectID = function(object)
        local GUID = b.ObjectGUID(object)       
        if GUID then
            local type, zero, server_id, instance_id, zone_uid, OBJECTID, spawn_uid = strsplit("-", GUID);
            return tonumber(OBJECTID);
        else
            return 0
        end
    end
    b.UnitMovementFlags = function(...)
        return GetUnitMovementFlags(...)
    end
    local TraceLineRaw = TraceLine
    b.TraceLine = function(...)
        local sx = select(1, ...)
        local sy = select(2, ...)
        local sz = select(3, ...)
        local dx = select(4, ...)
        local dy = select(5, ...)
        local dz = select(6, ...)
        local flags = select(7, ...)
        local hit, hitx, hity, hitz = TraceLineRaw(sx, sy, sz, dx, dy, dz, flags)
        if hit == 1 then
            return hitx, hity, hitz
        else
            return nil
        end
    end
    b.UnitTarget = function(unit)
        return ObjectField(unit, 0x1C58, 15)
    end
    b.IsQuestObject = function(obj)
        return false
    end
    b.UnitCastID = function(...)
        local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId =
            UnitCastingInfo(...)
        local _, _, _, _, endingTime, _, _, notInterruptiblee, spellIdd = UnitChannelInfo(...)
        local castGUID = ObjectField(select(1, ...), 0x1C58, 15);
        return spellId, spellIdd, castGUID, castGUID
    end
    b.GetWoWDirectory = GetWowDirectory
    b.CreateDirectory = CreateDirectory
    b.GetDirectoryFiles = function(...)
        local input = ...
        local filter = stringsplit(input, "*")
        local newFilter = "*.lua"
        local files = GetDirectoryFiles(filter[1], newFilter)
        local directoryFiles = stringsplit(files, "|")
        return directoryFiles
    end
    b.GetKeyState = GetKeyState
    b.WorldToScreen = function(...)
        local multiplier = UIParent:GetScale()
        local sX, sY = WorldToScreen(...)
        return sX * multiplier, -sY * multiplier
    end
    b.ScreenToWorld = function()
        return 0, 0
    end
    b.WorldToScreenRaw = function(...)
        local x, y = WorldToScreen(...)
        return x, y
    end
    b.GetDistanceBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2)
        return math.sqrt(math.pow(X2 - X1, 2) + math.pow(Y2 - Y1, 2) + math.pow(Z2 - Z1, 2))
    end

    b.GetAnglesBetweenObjects = function(Object1, Object2)
        local X1, Y1, Z1 = br._G.ObjectPosition(Object1)
        local X2, Y2, Z2 = br._G.ObjectPosition(Object2)
        -- print(Unit1,X1,Y1,Z1,unit2,X2,Y2,Z2)
        return math.atan2(Y2 - Y1, X2 - X1) % (math.pi * 2),
            math.atan((Z1 - Z2) / math.sqrt(math.pow(X1 - X2, 2) + math.pow(Y1 - Y2, 2))) % math.pi
    end

    b.GetAnglesBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2)
        return math.atan2(Y2 - Y1, X2 - X1) % (math.pi * 2),
            math.atan((Z1 - Z2) / math.sqrt(math.pow(X1 - X2, 2) + math.pow(Y1 - Y2, 2))) % math.pi
    end

    b.GetPositionFromPosition = function(X, Y, Z, Distance, AngleXY, AngleXYZ)
        return math.cos(AngleXY) * Distance + X, math.sin(AngleXY) * Distance + Y, math.sin(AngleXYZ) * Distance + Z
    end

    b.GetPositionBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2, DistanceFromPosition1)
        local AngleXY, AngleXYZ = b.GetAnglesBetweenPositions(X1, Y1, Z1, X2, Y2, Z2)
        return b.GetPositionFromPosition(X1, Y1, Z1, DistanceFromPosition1, AngleXY, AngleXYZ)
    end

    b.GetPositionBetweenObjects = function(unit1, unit2, DistanceFromPosition1)
        local X1, Y1, Z1 = br._G.ObjectPosition(unit1)

        local X2, Y2, Z2 = br._G.ObjectPosition(unit2)
        local AngleXY, AngleXYZ = b.GetAnglesBetweenPositions(X1, Y1, Z1, X2, Y2, Z2)
        return b.GetPositionFromPosition(X1, Y1, Z1, DistanceFromPosition1, AngleXY, AngleXYZ)
    end
    b.ObjectFacing = UnitFacing
    b.FaceDirection = function(arg)
        if type(arg) == "number" then
            FaceDirection(arg)
        else
            arg = b.GetAnglesBetweenObjects("player", arg)
            FaceDirection(arg)
        end
    end
    b.ObjectIsFacing = function(obj1, obj2, degrees)
        local Facing = UnitFacing(obj1)
        local AngleToUnit = b.GetAnglesBetweenObjects(obj1, obj2)
        local AngleDifference = Facing > AngleToUnit and Facing - AngleToUnit or AngleToUnit - Facing
        local ShortestAngle = AngleDifference < math.pi and AngleDifference or math.pi * 2 - AngleDifference
        degrees = degrees and br._G.rad(degrees) / 2 or math.pi / 2
        return ShortestAngle < degrees
    end
    b.ObjectInteract = function(unit)
        CallSecureFunction("InteractUnit", unit);
    end
    -- br.getFacing = ObjectFacingObject
    b.UnitCreator = function(unit)
        return ObjectField(unit, 0x13C8, 15)
    end
    b.ObjectName = ObjectName
    b.GetDistanceBetweenObjects = function(X1, Y1, Z1, X2, Y2, Z2)
        return math.sqrt(math.pow(X2 - X1, 2) + math.pow(Y2 - Y1, 2) + math.pow(Z2 - Z1, 2))
    end
    b.GetMapId = function()
        return select(8, GetInstanceInfo());
    end

    b.UnitIsMounted = function(...)
        return IsMounted()
    end
    b.SendMovementUpdate = UpdateMovement

    b.ObjectDynamicFlags = nil;

    b.IsHackEnabled = function(...)
        -- print(...)
        return false
    end
    b.UnitCombatReach = function(unit)
        return ObjectField(unit, 0x1CF0, 10)
    end
    b.ReadFile = ReadFile
    b.DirectoryExists = DirectoryExists
    b.WriteFile = WriteFile
    -- local addedOM,removedOM = {}, {}
    b.GetObjectCount = function()
        if not OldTable and not CurrentTable then
            CurrentTable = EnumVisibleObjects()
            return #CurrentTable, true, CurrentTable, {}
        else
            OldTable = CurrentTable
            CurrentTable = EnumVisibleObjects()
            local TempTable = copyTable(CurrentTable)
            local TempTableOld = copyTable(OldTable)
            for i = #TempTableOld, 1, -1 do
                for k = #TempTable, 1, -1 do
                    if TempTableOld[i] == TempTable[k] then
                        table.remove(TempTable, k)
                        table.remove(TempTableOld, i)
                        break
                    end
                end
            end
            return #CurrentTable, true, TempTable, TempTableOld
        end
    end
    b.GetObjectWithIndex = function(...)
        return GetObjectWithIndex(...)
    end
    b.GetObjectWithGUID = function(...)
        return ...
    end
    b.GetMousePosition = function()
        local cur_x, cur_y = br._G.GetCursorPosition()
        return cur_x, cur_y
    end
    b.ObjectIsVisible = function(unit)
        return CallSecureFunction("UnitIsVisible", unit)
    end
    b.ObjectExists = function(unit)
        return CallSecureFunction("UnitExists", unit)
    end
    -- br.GetUnitIsVisible = lb.ObjectExists
    b.IsAoEPending = function()
        return CallSecureFunction("SpellIsTargeting")
    end
    b.ClickPosition = function(...)
        return ClickPosition(...)
    end
    b.UnitBoundingRadius = function(...)
        return 0
    end
    b.CancelPendingSpell = function()
        return CallSecureFunction("SpellStopTargeting")
    end
    unlocked = true
    return unlocked
end
