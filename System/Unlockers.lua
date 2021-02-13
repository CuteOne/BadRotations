local _, br = ...
local b = br._G
function br:loadUnlockerAPI()
    local unlocked = false
    local class = br.class
    -- EWT Unlocker
    if EasyWoWToolbox ~= nil then -- Native Support - API found at https://ewtwow.com/EWT/ewt.lua
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
        unlocked = true
    end
    -- Minibot
    if wmbapi ~= nil then
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
            if b.UnitIsVisible(obj) then
                return b.UnitName(obj)
            else
                return ""
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
        -- Object Manager
        b.GetObjectCount = wmbapi.GetObjectCount
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
            local scale, x, y = b.UIParent:GetEffectiveScale(), select(2, wmbapi.WorldToScreen(...))
            local sx = b.GetScreenWidth() * scale
            local sy = b.GetScreenHeight() * scale
            return x * sx, y * sy
        end
        b.ScreenToWorld = function(X, Y)
            local scale = b.UIParent:GetEffectiveScale()
            local sx = b.GetScreenWidth() * scale
            local sy = b.GetScreenHeight() * scale
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
            ["cgobjectdata__dynamicflags"] = "CGObjectData__DynamicFlags"
        }
        b.GetOffset = function(offset)
            return wmbapi.GetObjectDescriptorsTable()[br.Offsets[string.lower(offset)]]
        end
        -- Drawing
        b.GetWoWWindow = b.GetPhysicalScreenSize
        b.Draw2DLine = _G.LibDraw.Draw2DLine
        b.Draw2DText = _G.LibDraw.Text
        b.WorldToScreenRaw = function(...)
            local x, y = select(2, wmbapi.WorldToScreen(...))
            return x, 1 - y
        end
        unlocked = true
    end
    -- No Unlocker
    if EasyWoWToolbox == nil and wmbapi == nil then
        -- -- Active Player
        -- StopFalling = function() return true end
        -- FaceDirection = function() return true end
        -- -- Object
        -- ObjectTypes = {
        --     None = 0,
        --     Object = 1,
        --     Item = 2,
        --     Container = 4,
        --     Unit = 8,
        --     Player = 16,
        --     GameObject = 32,
        --     DynamicObject = 64,
        --     Corpse = 128,
        --     AreaTrigger = 256,
        --     SceneObject = 512,
        --     All = -1
        -- };
        -- ObjectPointer = function() return "" end
        -- ObjectExists = UnitExists
        -- ObjectIsVisible = UnitIsVisible
        -- b.ObjectPosition = function() return 0,0,0 end
        -- ObjectFacing = function() return 0,0 end
        -- ObjectName = function() return "" end
        -- b.ObjectID = function() return 0 end
        -- ObjectIsUnit = UnitIsUnit
        -- GetDistanceBetweenPositions = function() return 999 end
        -- GetDistanceBetweenObjects = function() return 999 end
        -- GetPositionBetweenObjects = function() return 0,0,0 end
        -- GetPositionFromPosition = function() return 0,0,0 end
        -- ObjectIsFacing = function() return true end
        -- ObjectInteract = function() return true end
        -- -- Object Manager
        -- GetObjectCountBR = function() return 0,false,{},{} end
        -- GetObjectWithIndex = function() return "target" end
        -- GetObjectWithGUID = function() return "target" end
        -- -- Unit
        -- UnitBoundingRadius = function() return 0 end
        -- b.UnitCombatReach = function() return 0 end
        -- b.UnitTarget = function() return "target" end
        -- UnitCastID = function() return 0 end
        -- -- World
        -- TraceLine = function() return 0,0,0 end
        -- GetCameraPosition = function() return 0,0,0 end
        -- CancelPendingSpell = function() return true end
        -- ClickPosition = function() return true end
        -- IsAoEPending = function() return false end
        -- GetTargetingSpell = function() return 0 end
        -- WorldToScreen = function() return 0,0,true end
        -- ScreenToWorld = function() return 0,0,0 end
        -- GetMousePosition = function() return 0,0,0 end
        -- -- Hacks
        -- IsHackEnabled = function() return false end
        -- SetHackEnabled = function() return true end
        -- -- Files
        -- GetDirectoryFiles = function() return {} end
        -- ReadFile = function() return "" end
        -- WriteFile = function() return true end
        -- CreateDirectory = function() return true end
        -- GetWoWDirectory = function() return "" end
        -- -- Callbacks
        -- AddEventCallback = function() return true end
        -- -- Misc
        -- SendHTTPRequest = function() return true end
        -- GetKeyState = function() return false end
        unlocked = false
    end
    -- Set Spell Queue Window
    if class == 8 or class == 9 then
        if unlocked and br.prevQueueWindow ~= 400 then
            b.RunMacroText("/console SpellQueueWindow 400")
        end
    else
        if unlocked and br.prevQueueWindow ~= 0 then
            b.RunMacroText("/console SpellQueueWindow 0")
        end
    end
    return unlocked
end

-- Checks for BR Out of Date with current version based on TOC file
local brlocVersion
local brcurrVersion
local brUpdateTimer
function br:checkBrOutOfDate()
    brlocVersion = b.GetAddOnMetadata(br.addonName, "Version")
    if (not brUpdateTimer or (b.GetTime() - brUpdateTimer) > 300) and br.player ~= nil then --and EasyWoWToolbox ~= nil then
        local startTime = b.debugprofilestop()
        -- Request Current Version from GitHub
        if EasyWoWToolbox ~= nil then -- EWT
            --SendHTTPRequest('https://raw.githubusercontent.com/CuteOne/BadRotations/master/BadRotations.toc', nil, function(body) brcurrVersion =(string.match(body, "(%d+%p%d+%p%d+)")) end)

            -- Check for commit updates from System/Updater.lua, which relies on EWT
            br.updater:CheckOutdated()
            brUpdateTimer = b.GetTime()
        elseif wmbapi ~= nil then -- MB
            local info = {
                Url = "https://raw.githubusercontent.com/CuteOne/BadRotations/master/BadRotations.toc",
                Method = "GET"
            }
            if not br.locVersionRequest then
                br.locVersionRequest = b.SendHTTPRequest(info)
            else
                br.locVersionStatus, br.locVersionResponce = wmbapi.ReceiveHttpResponse(br.locVersionRequest)
                if br.locVersionResponce then
                    brcurrVersion = string.match(br.locVersionResponce.Body, "(%d+%p%d+%p%d+)")
                end
            end
            -- Check against current version installed
            if brlocVersion and brcurrVersion then
                -- Print("Local: "..tostring(brlocVersion).." | Remote: "..tostring(brcurrVersion))
                local brcleanCurr = b.gsub(tostring(brcurrVersion), "%p", "")
                local brcleanLoc = b.gsub(tostring(brlocVersion), "%p", "")
                if tonumber(brcleanCurr) ~= tonumber(brcleanLoc) then
                    local msg =
                        "BadRotations is currently out of date. Local Version: " ..
                        brlocVersion .. " Current Version: " .. brcurrVersion .. ".  Please download latest version for best performance."
                    if br.isChecked("Overlay Messages") then
                        b.RaidNotice_AddMessage(b.RaidWarningFrame, msg, {r = 1, g = 0.3, b = 0.1})
                    else
                        b.print(msg)
                    end
                end
            end
            brUpdateTimer = b.GetTime()
        end
        br.debug.cpu:updateDebug(startTime, "outOfDate")
    end
end
