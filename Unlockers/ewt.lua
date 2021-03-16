local _, br = ...
local b = br._G
local unlock = br.unlock
-- EWT Unlocker
function unlock.EWTUnlock()
    local unlocked = false
    -- Active Player
    b.StopFalling = StopFalling
    b.FaceDirection = FaceDirection
    -- Object
    b.ObjectTypes = ObjectTypes
    b.ObjectPointer = ObjectPointer
    b.ObjectExists = ObjectExists
    b.ObjectIsVisible = ObjectIsVisible
    b.ObjectPosition = ObjectPosition
    b.ObjectFacing = ObjectFacing
    b.ObjectName = ObjectName
    b.ObjectID = ObjectID
    b.ObjectIsUnit = ObjectIsUnit
    b.GetAnglesBetweenObjects = function(Object1, Object2)
        if b.ObjectIsVisible(Object1) and b.ObjectIsVisible(Object2) then
            local X1, Y1, Z1 = b.ObjectPosition(Object1)
            local X2, Y2, Z2 = b.ObjectPosition(Object2)
            -- print(Unit1,X1,Y1,Z1,unit2,X2,Y2,Z2)
            return math.atan2(Y2 - Y1, X2 - X1) % (math.pi * 2), math.atan((Z1 - Z2) / math.sqrt(math.pow(X1 - X2, 2) + math.pow(Y1 - Y2, 2))) % math.pi
        else
            return 0,0
        end
	end
    b.GetDistanceBetweenPositions = GetDistanceBetweenPositions
    b.GetDistanceBetweenObjects = GetDistanceBetweenObjects
    b.GetPositionBetweenObjects = GetPositionBetweenObjects
    b.GetPositionFromPosition = GetPositionFromPosition
    b.ObjectIsFacing = ObjectIsFacing
    b.ObjectInteract = ObjectInteract
    -- Object Manager
    b.GetObjectCount = GetObjectCount
    b.GetObjectWithIndex = GetObjectWithIndex
    b.GetObjectWithGUID = GetObjectWithGUID
    b.GetNpcCount = GetObjectCount
    b.GetPlayerCount = GetObjectCount
    b.GetNpcWithIndex = GetObjectWithIndex
    b.GetPlayerWithIndex = GetObjectWithIndex
    -- Unit
    b.UnitBoundingRadius = UnitBoundingRadius
    b.UnitCombatReach = UnitCombatReach
    b.UnitTarget = UnitTarget
    b.UnitCastID = UnitCastID
    -- World
    b.TraceLine = TraceLine
    b.GetCameraPosition = GetCameraPosition
    b.CancelPendingSpell = CancelPendingSpell
    b.ClickPosition = ClickPosition
    b.IsAoEPending = IsAoEPending
    b.GetTargetingSpell = GetTargetingSpell
    b.WorldToScreen = WorldToScreen
    b.ScreenToWorld = ScreenToWorld
    b.GetMousePosition = GetMousePosition
    -- Hacks
    b.IsHackEnabled = IsHackEnabled
    b.SetHackEnabled = SetHackEnabled
    -- Files
    b.GetDirectoryFiles = GetDirectoryFiles
    b.ReadFile = ReadFile
    b.WriteFile = WriteFile
    b.CreateDirectory = CreateDirectory
    b.DirectoryExists = DirectoryExists
    b.GetWoWDirectory = GetWoWDirectory
    -- Callbacks
    b.AddEventCallback = AddEventCallback
    -- Misc
    b.SendHTTPRequest = SendHTTPRequest
    b.GetKeyState = GetKeyState
    -- Drawing
    b.GetWoWWindow = GetWoWWindow
    b.Draw2DLine = Draw2DLine
    b.Draw2DText = Draw2DText
    b.WorldToScreenRaw = WorldToScreenRaw
    b.IsQuestObject = IsQuestObject
    unlocked = true
    return unlocked
end
