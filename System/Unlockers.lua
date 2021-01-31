function br:loadUnlockerAPI()
    local unlocked = false
    local class = br.class
    -- EWT Unlocker
    if EasyWoWToolbox ~= nil then -- Native Support - API found at https://ewtwow.com/EWT/ewt.lua
        -- Active Player
        StopFalling = StopFalling
        FaceDirection = FaceDirection
        -- Object
        ObjectTypes = ObjectTypes
        ObjectPointer = ObjectPointer
        ObjectExists = ObjectExists
        ObjectIsVisible = ObjectIsVisible
        ObjectPosition = ObjectPosition
        ObjectFacing = ObjectFacing
        ObjectName = ObjectName
        ObjectID = ObjectID
        ObjectIsUnit = ObjectIsUnit
        GetDistanceBetweenPositions = GetDistanceBetweenPositions
        GetDistanceBetweenObjects = GetDistanceBetweenObjects
        GetPositionBetweenObjects = GetPositionBetweenObjects
        GetPositionFromPosition = GetPositionFromPosition
        ObjectIsFacing = ObjectIsFacing
        ObjectInteract = ObjectInteract
        -- Object Manager
        GetObjectCountBR = GetObjectCount
        GetObjectWithIndex = GetObjectWithIndex
        GetObjectWithGUID = GetObjectWithGUID
        GetNpcCount = GetObjectCount
        GetPlayerCount = GetObjectCount
        GetNpcWithIndex = GetObjectWithIndex
        GetPlayerWithIndex = GetObjectWithIndex
        -- Unit
        UnitBoundingRadius = UnitBoundingRadius
        UnitCombatReach = UnitCombatReach
        UnitTarget = UnitTarget
        UnitCastID = UnitCastID
        -- World
        TraceLine = TraceLine
        GetCameraPosition = GetCameraPosition
        CancelPendingSpell = CancelPendingSpell
        ClickPosition = ClickPosition
        IsAoEPending = IsAoEPending
        GetTargetingSpell = GetTargetingSpell
        WorldToScreen = WorldToScreen
        ScreenToWorld = ScreenToWorld
        GetMousePosition = GetMousePosition
        -- Hacks
        IsHackEnabled = IsHackEnabled
        SetHackEnabled = SetHackEnabled
        -- Files
        GetDirectoryFiles = GetDirectoryFiles
        ReadFile = ReadFile
        WriteFile = WriteFile
        CreateDirectory = CreateDirectory
        DirectoryExists = DirectoryExists
        GetWoWDirectory = GetWoWDirectory
        -- Callbacks
        AddEventCallback = AddEventCallback
        -- Misc
        SendHTTPRequest = SendHTTPRequest
        GetKeyState = GetKeyState
        -- Drawing
        GetWoWWindow = GetWoWWindow
        Draw2DLine = Draw2DLine
        Draw2DText = Draw2DText
        WorldToScreenRaw = WorldToScreenRaw
        unlocked = true
    end
    -- Minibot
    if wmbapi ~= nil then
        -- Active Player
        StopFalling = wmbapi.StopFalling
        FaceDirection = function(a) if wmbapi.GetObject(a) then wmbapi.FaceDirection(GetAnglesBetweenObjects(a,"player"),true) else wmbapi.FaceDirection(a,true) end end
        -- Object
        ObjectTypeFlags = wmbapi.ObjectTypeFlags
        ObjectPointer = function(obj) 
            if UnitIsVisible(obj) then
                return wmbapi.GetObject(obj)
            else
                return ""
            end
        end
        ObjectExists = wmbapi.ObjectExists
        ObjectIsVisible = UnitIsVisible
        ObjectPosition = function(obj) 
            local x,y,z = wmbapi.ObjectPosition(obj) 
            if x then
                return x,y,z
            else
                return 0,0,0
            end
        end
        ObjectFacing = function(obj) 
            if UnitIsVisible(obj) then
                return wmbapi.ObjectFacing(obj)
            else
                return 0
            end
        end
        ObjectName = function(obj) 
            if UnitIsVisible(obj) then
                return UnitName(obj)
            else
                return ""
            end
        end
        ObjectID = function(obj) 
            if UnitIsVisible(obj) then
                return wmbapi.ObjectId(obj)
            else
                return 0
            end
        end
        ObjectDescriptor = function(obj,offset,type) return UnitIsVisible(obj) and wmbapi.ObjectDescriptor(obj,offset,type) end
        ObjectIsUnit = function(obj) return UnitIsVisible(obj) and wmbapi.ObjectIsType(obj,wmbapi.GetObjectTypeFlagsTable().Unit) end
        GetDistanceBetweenPositions = function(...) return (... and wmbapi.GetDistanceBetweenPositions(...)) or 0 end
        GetDistanceBetweenObjects = function(obj1,obj2) 
            if UnitIsVisible(obj1) and UnitIsVisible(obj2) then
                return wmbapi.GetDistanceBetweenObjects(obj1,obj2)
            else
                return 0
            end
        end
        GetPositionBetweenObjects = function(obj1,obj2,dist) 
            if UnitIsVisible(obj1) and UnitIsVisible(obj2) then
                return wmbapi.GetPositionBetweenObjects(obj1,obj2,dist)
            else
                return 0,0,0
            end
        end
        GetPositionFromPosition = function(...) return (... and wmbapi.GetPositionFromPosition(...)) or 0,0,0 end
        ObjectIsFacing = function(obj1,obj2,toler) 
            if UnitIsVisible(obj1) and UnitIsVisible(obj2) then
                return (toler and wmbapi.ObjectIsFacing(obj1,obj2,toler)) or (not toler and wmbapi.ObjectIsFacing(obj1,obj2))
            end
        end
        ObjectInteract = InteractUnit
        -- Object Manager
        GetObjectCountBR = wmbapi.GetObjectCount
        GetNpcCount = wmbapi.GetNpcCount
        GetPlayerCount = wmbapi.GetPlayerCount
        GetObjectWithIndex = wmbapi.GetObjectWithIndex
        GetNpcWithIndex = wmbapi.GetNpcWithIndex
        GetPlayerWithIndex = wmbapi.GetPlayerWithIndex
        GetObjectWithGUID = function(GUID)
            if GUID and #GUID > 1 then
                return wmbapi.GetObjectWithGUID(GUID)
            else
                return "" 
            end
        end
        -- Unit
        UnitBoundingRadius = function(obj) 
            if UnitIsVisible(obj) then
                return wmbapi.UnitBoundingRadius(obj)
            else
                return 0
            end
        end
        UnitCombatReach = function(obj) 
            if UnitIsVisible(obj) then
                return wmbapi.UnitCombatReach(obj)
            else
                return 0
            end
        end
        UnitTarget = function(obj) 
            if UnitIsVisible(obj) then
                return wmbapi.UnitTarget(obj)
            else
                return ""
            end
        end
        UnitCastID = function(obj)
            if UnitIsVisible(obj) then
                local spellId,target = wmbapi.UnitCasting(obj)
                return spellId or 0,spellId or 0,target or "",target or ""
            else
                return 0,0,"",""
            end
        end
        UnitCreator = function(obj) 
            if UnitIsVisible(obj) then
                return wmbapi.UnitCreator(obj)
            else
                return ""
            end
        end
        -- World
        TraceLine = wmbapi.TraceLine
        GetCameraPosition = wmbapi.GetCameraPosition
        CancelPendingSpell = wmbapi.CancelPendingSpell
        ClickPosition = wmbapi.ClickPosition
        IsAoEPending = wmbapi.IsAoEPending
        GetTargetingSpell = wmbapi.IsAoEPending
        WorldToScreen = function(...) 
            local scale, x, y = UIParent:GetEffectiveScale(), select(2,wmbapi.WorldToScreen(...))
            local sx = GetScreenWidth() * scale
            local sy = GetScreenHeight() * scale
            return x * sx, y * sy
        end
        ScreenToWorld = function(X, Y) 
            local scale = UIParent:GetEffectiveScale()
            local sx = GetScreenWidth() * scale
            local sy = GetScreenHeight() * scale
            return wmbapi.ScreenToWorld(X / sx, Y / sy)
        end
        GetMousePosition = function()
            local cur_x, cur_y = GetCursorPosition()
            return cur_x, cur_y
        end
        -- Hacks
        IsHackEnabled = function() return end
        SetHackEnabled = function() return true end
        -- Files
        GetDirectoryFiles = wmbapi.GetDirectoryFiles
        ReadFile = wmbapi.ReadFile
        WriteFile = wmbapi.WriteFile
        CreateDirectory = wmbapi.CreateDirectory
        GetWoWDirectory = wmbapi.GetWoWDirectory
        DirectoryExists = wmbapi.DirectoryExists
        -- Callbacks
        AddEventCallback = function(Event, Callback)
            if not BRFrames then
                BRFrames = CreateFrame("Frame")
                BRFrames:SetScript("OnEvent",BRFrames_OnEvent)
            end
            BRFrames:RegisterEvent(Event)
            if not BRFramesEvent[Event] then
                BRFramesEvent[Event] = Callback
            end
        end
        -- Misc
        SendHTTPRequest = wmbapi.SendHttpRequest
        GetKeyState = wmbapi.GetKeyState
        Offsets = {            
            ["cggameobjectdata__flags"]="CGGameObjectData__Flags",
            ["cgobjectdata__dynamicflags"]="CGObjectData__DynamicFlags"
        }
        GetOffset = function(offset)
            return wmbapi.GetObjectDescriptorsTable()[Offsets[string.lower(offset)]]
        end
        -- Drawing
        GetWoWWindow = GetPhysicalScreenSize
        Draw2DLine = LibDraw.Draw2DLine
        Draw2DText = function(textX, textY, text)
            local F = tremove(LibDraw.fontstrings) or LibDraw.canvas:CreateFontString(nil, "BACKGROUND")
            F:SetFontObject("GameFontNormal")
            F:SetText(text)
            F:SetTextColor(LibDraw.line.r, LibDraw.line.g, LibDraw.line.b, LibDraw.line.a)
            if p then
                local width = F:GetStringWidth() - 4
                local offsetX = width*0.5
                local offsetY = F:GetStringHeight() + 3.5
                local pwidth = width*p*0.01
                FHAugment.drawLine(textX-offsetX, textY-offsetY, (textX+offsetX), textY-offsetY, 4, r, g, b, 0.25)
                FHAugment.drawLine(textX-offsetX, textY-offsetY, (textX+offsetX)-(width-pwidth), textY-offsetY, 4, r, g, b, 1)
            end
            F:SetPoint("TOPLEFT", UIParent, "TOPLEFT", textX-(F:GetStringWidth()*0.5), textY)
            F:Show()
            tinsert(LibDraw.fontstrings_used, F) 
        end
        WorldToScreenRaw = function(...)
            local x, y = select(2,wmbapi.WorldToScreen(...))
            return x, 1-y
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
        -- ObjectPosition = function() return 0,0,0 end
        -- ObjectFacing = function() return 0,0 end
        -- ObjectName = function() return "" end
        -- ObjectID = function() return 0 end
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
        -- UnitCombatReach = function() return 0 end
        -- UnitTarget = function() return "target" end
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
        if unlocked and br.prevQueueWindow ~= 400 then RunMacroText("/console SpellQueueWindow 400") end
    else
        if unlocked and br.prevQueueWindow ~= 0 then RunMacroText("/console SpellQueueWindow 0") end
    end
    return unlocked
end

-- Checks for BR Out of Date with current version based on TOC file
local brlocVersion
local brcurrVersion
local brUpdateTimer
function br:checkBrOutOfDate()
    brlocVersion = GetAddOnMetadata(br.addonName,"Version")
    if (not brUpdateTimer or (GetTime() - brUpdateTimer) > 300) and br.player ~= nil then --and EasyWoWToolbox ~= nil then
        local startTime = debugprofilestop()
        -- Request Current Version from GitHub
        if EasyWoWToolbox ~= nil then -- EWT
            --SendHTTPRequest('https://raw.githubusercontent.com/CuteOne/BadRotations/master/BadRotations.toc', nil, function(body) brcurrVersion =(string.match(body, "(%d+%p%d+%p%d+)")) end)
            
            -- Check for commit updates from System/Updater.lua, which relies on EWT
            br.updater:CheckOutdated()
            brUpdateTimer = GetTime()
        elseif wmbapi ~= nil then -- MB
            local info = {
            Url = 'https://raw.githubusercontent.com/CuteOne/BadRotations/master/BadRotations.toc',
            Method = 'GET'
            }
            if not brlocVersionRequest then
                brlocVersionRequest = SendHTTPRequest(info)
            else
                brlocVersionStatus, brlocVersionResponce = wmbapi.ReceiveHttpResponse(brlocVersionRequest)
                if brlocVersionResponce then
                    brcurrVersion = string.match(brlocVersionResponce.Body, "(%d+%p%d+%p%d+)")
                end
            end
            -- Check against current version installed
            if brlocVersion and brcurrVersion then
                -- Print("Local: "..tostring(brlocVersion).." | Remote: "..tostring(brcurrVersion))
                brcleanCurr = gsub(tostring(brcurrVersion),"%p","")
                brcleanLoc = gsub(tostring(brlocVersion),"%p","")
                if tonumber(brcleanCurr) ~= tonumber(brcleanLoc) then 
                    local msg = "BadRotations is currently out of date. Local Version: "..brlocVersion.. " Current Version: "..brcurrVersion..".  Please download latest version for best performance."
                    if isChecked("Overlay Messages") then
                        RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1, g=0.3, b=0.1})
                    else
                        Print(msg)
                    end
                end
            end
            brUpdateTimer = GetTime()
        end
        br.debug.cpu:updateDebug(startTime, "outOfDate")
    end
end
