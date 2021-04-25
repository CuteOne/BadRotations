local _, br = ...
local b = br._G
local unlock = br.unlock
-- UCS Unlocker
function unlock.UCSUnlock()
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
    b.GetAnglesBetweenObjects = GetAnglesBetweenObjects
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
    br.unlocker = "UCS"
    unlocked = true
    return unlocked
end
