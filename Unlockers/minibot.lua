local _, br = ...
local b = br._G
local unlock = br.unlock
-- Minibot
function unlock.MBUnlock()
    local wmbapi = _G.wmbapi
    local unlocked = false
    -- Active Player
    b.StopFalling = wmbapi.StopFalling
    b.GetAnglesBetweenObjects = function(obj1, obj2)
        if b.UnitIsVisible(obj1) and b.UnitIsVisible(obj2) then
            return wmbapi.GetAnglesBetweenObjects(obj1, obj2)
        else
            return 0, 0
        end
    end
    b.FaceDirection = function(a)
        if wmbapi.GetObject(a) then
            wmbapi.FaceDirection(b.GetAnglesBetweenObjects(a, "player"), true)
        else
            wmbapi.FaceDirection(a, true)
        end
    end
    -- Object
    b.ObjectTypeFlags = wmbapi.ObjectTypeFlags
    b.ObjectPointer = function(obj)
        if b.UnitIsVisible(obj) then
            return wmbapi.GetObject(obj)
        else
            return ""
        end
    end
    b.ObjectExists = wmbapi.ObjectExists
    b.ObjectIsVisible = b.UnitIsVisible
    b.ObjectPosition = function(obj)
        local x, y, z = wmbapi.ObjectPosition(obj)
        if x then
            return x, y, z
        else
            return 0, 0, 0
        end
    end
    b.ObjectFacing = function(obj)
        if b.UnitIsVisible(obj) then
            return wmbapi.ObjectFacing(obj)
        else
            return 0
        end
    end
    b.ObjectName = function(obj)
        if b.ObjectExists(obj) then
            return b.UnitName(obj)
        else
            return "Unknown"
        end
    end
    b.ObjectID = function(obj)
        if b.UnitIsVisible(obj) then
            return wmbapi.ObjectId(obj)
        else
            return 0
        end
    end
    b.ObjectDescriptor = function(obj, offset, type)
        return b.UnitIsVisible(obj) and wmbapi.ObjectDescriptor(obj, offset, type)
    end
    b.ObjectIsUnit = function(obj)
        return b.UnitIsVisible(obj) and wmbapi.ObjectIsType(obj, wmbapi.GetObjectTypeFlagsTable().Unit)
    end
    b.GetDistanceBetweenPositions = function(...)
        return (... and wmbapi.GetDistanceBetweenPositions(...)) or 0
    end
    b.GetDistanceBetweenObjects = function(obj1, obj2)
        if b.UnitIsVisible(obj1) and b.UnitIsVisible(obj2) then
            return wmbapi.GetDistanceBetweenObjects(obj1, obj2)
        else
            return 0
        end
    end
    b.GetPositionBetweenObjects = function(obj1, obj2, dist)
        if b.UnitIsVisible(obj1) and b.UnitIsVisible(obj2) then
            return wmbapi.GetPositionBetweenObjects(obj1, obj2, dist)
        else
            return 0, 0, 0
        end
    end
    b.GetPositionFromPosition = function(...)
        return (... and wmbapi.GetPositionFromPosition(...)) or 0, 0, 0
    end
    b.ObjectIsFacing = function(obj1, obj2, toler)
        if b.UnitIsVisible(obj1) and b.UnitIsVisible(obj2) then
            return (toler and wmbapi.ObjectIsFacing(obj1, obj2, toler)) or (not toler and wmbapi.ObjectIsFacing(obj1, obj2))
        end
    end
    b.ObjectInteract = b.InteractUnit
    --------------------------------
    -- internal unit manager
    --------------------------------
    local const_updateObjectListTickDelay = 10
    local g_lastKnownObjectList = {}
    local g_lastObjectCount = nil
    local g_lastObjectGuid = nil
    local g_lastUpdateTick = 0

    b.GetObjectCount = wmbapi.GetObjectCount

    b.GetNewObjects = function()
        local added, removed = {}, {}
        added, removed = select(3, wmbapi.GetObjectCount()), select(4, wmbapi.GetObjectCount())
        return added, removed
    end

    b.GetNpcCount = wmbapi.GetNpcCount
    b.GetPlayerCount = wmbapi.GetPlayerCount
    b.GetObjectWithIndex = wmbapi.GetObjectWithIndex
    b.GetNpcWithIndex = wmbapi.GetNpcWithIndex
    b.GetPlayerWithIndex = wmbapi.GetPlayerWithIndex
    b.GetObjectWithGUID = function(GUID)
        if GUID and #GUID > 1 then
            return wmbapi.GetObjectWithGUID(GUID)
        else
            return ""
        end
    end
    -- Unit
    b.UnitBoundingRadius = function(obj)
        if b.UnitIsVisible(obj) then
            return wmbapi.UnitBoundingRadius(obj)
        else
            return 0
        end
    end
    b.UnitCombatReach = function(obj)
        if b.UnitIsVisible(obj) then
            return wmbapi.UnitCombatReach(obj)
        else
            return 0
        end
    end
    b.UnitTarget = function(obj)
        if b.UnitIsVisible(obj) then
            return wmbapi.UnitTarget(obj)
        else
            return ""
        end
    end
    b.UnitCastID = function(obj)
        if b.UnitIsVisible(obj) then
            local spellId, target = wmbapi.UnitCasting(obj)
            return spellId or 0, spellId or 0, target or "", target or ""
        else
            return 0, 0, "", ""
        end
    end
    b.UnitCreator = function(obj)
        if b.UnitIsVisible(obj) then
            return wmbapi.UnitCreator(obj)
        else
            return ""
        end
    end
    -- World
    b.TraceLine = wmbapi.TraceLine
    b.GetCameraPosition = wmbapi.GetCameraPosition
    b.CancelPendingSpell = wmbapi.CancelPendingSpell
    b.ClickPosition = wmbapi.ClickPosition
    b.IsAoEPending = wmbapi.IsAoEPending
    b.GetTargetingSpell = wmbapi.IsAoEPending
    b.WorldToScreen = function(...)
        local scale, x, y = UIParent:GetEffectiveScale(), select(2, wmbapi.WorldToScreen(...))
        local sx = GetScreenWidth() * scale
        local sy = GetScreenHeight() * scale
        return x * sx, y * sy
    end
    b.ScreenToWorld = function(X, Y)
        local scale = UIParent:GetEffectiveScale()
        local sx = GetScreenWidth() * scale
        local sy = GetScreenHeight() * scale
        return wmbapi.ScreenToWorld(X / sx, Y / sy)
    end
    b.GetMousePosition = function()
        local cur_x, cur_y = b.GetCursorPosition()
        return cur_x, cur_y
    end
    -- Hacks
    b.IsHackEnabled = function()
        return
    end
    b.SetHackEnabled = function()
        return true
    end
    -- Files
    b.GetDirectoryFiles = wmbapi.GetDirectoryFiles
    b.ReadFile = wmbapi.ReadFile
    b.WriteFile = wmbapi.WriteFile
    b.CreateDirectory = wmbapi.CreateDirectory
    b.GetWoWDirectory = wmbapi.GetWoWDirectory
    b.DirectoryExists = wmbapi.DirectoryExists
    -- Callbacks
    b.AddEventCallback = function(Event, Callback)
        if not b.BRFrames then
            b.BRFrames = b.CreateFrame("Frame")
            b.BRFrames:SetScript("OnEvent", b.BRFrames_OnEvent)
        end
        b.BRFrames:RegisterEvent(Event)
        if not b.BRFramesEvent[Event] then
            b.BRFramesEvent[Event] = Callback
        end
    end
    -- Misc
    b.SendHTTPRequest = wmbapi.SendHttpRequest
    b.GetKeyState = wmbapi.GetKeyState
    br.Offsets = {
        ["cggameobjectdata__flags"] = "CGGameObjectData__Flags",
    }
    b.GetOffset = function(offset)
        return wmbapi.GetObjectDescriptorsTable()[br.Offsets[string.lower(offset)]]
    end
    -- Drawing
    b.GetWoWWindow = b.GetPhysicalScreenSize
    b.Draw2DLine = _G.LibStub("LibDraw-BR").Draw2DLine
    b.Draw2DText = _G.LibStub("LibDraw-BR").Text
    b.WorldToScreenRaw = function(...)
        local x, y = select(2, wmbapi.WorldToScreen(...))
        return x, 1 - y
    end
    b.IsQuestObject = function(...)
        return wmbapi.ObjectIsQuestObjective(...,false)
    end
    unlocked = true
    return unlocked
end
