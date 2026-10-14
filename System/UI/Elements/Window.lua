local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local _, br = ...
br.ui.window = {}

-- Window creators. messageWindow: nil/false a scroll frame, true a message frame, "copy" a text box
-- whose text can be selected and copied (Ctrl+C); returns the content, its window as .parent
function br.ui:createWindow(name, width, height, title, color, messageWindow)
    if title == nil then
        title = name
    end
    if color == nil then
        color = br.ui.colors.class
    end
    local window = DiesalGUI:Create("Window")
    window:SetTitle(color .. "BadRotations", title)
    window.settings.width = width or 250
    window.settings.height = height or 250
    window.settings.header = true
    window.settings.footer = true
    window.frame:SetClampedToScreen(true)
    window:ApplySettings()

    window.closeButton:SetScript(
        "OnClick",
        function(this, button)
            br.ui:savePosition(name)
            br.data.settings[br.loader.selectedSpec][name]["active"] = false
            DiesalGUI:OnMouse(this, button)
            br._G.PlaySound(799)
            window:FireEvent("OnClose")
            window:Hide()
        end
    )
    local scrollFrame
    if messageWindow == nil or messageWindow == false then
        scrollFrame = DiesalGUI:Create("ScrollFrame")
    elseif messageWindow == true then
        scrollFrame = DiesalGUI:Create("ScrollingMessageFrame")
        scrollFrame:SetStylesheet(br.ui.messageStylesheet)
    elseif messageWindow == "copy" then
        scrollFrame = DiesalGUI:Create("ScrollingEditBox")
        scrollFrame.settings.contentPadding = { 4, 4, 4, 4 }
        scrollFrame:ApplySettings()
        scrollFrame:SetEventListener("OnEscapePressed", function() scrollFrame.editBox:ClearFocus() end)
    end
    window:AddChild(scrollFrame)
    scrollFrame:SetParent(window.content)
    scrollFrame:SetAllPoints(window.content)
    scrollFrame.parent = window

    if br.data.settings and br.data.settings[br.loader.selectedSpec] == nil then
        br.data.settings[br.loader.selectedSpec] = {}
    end
    if br.data.settings and br.data.settings[br.loader.selectedSpec] and br.data.settings[br.loader.selectedSpec][name] == nil then
        br.data.settings[br.loader.selectedSpec][name] = {}
    end
    if br.data.settings[br.loader.selectedSpec][name] then
        local windows = br.data.settings[br.loader.selectedSpec][name]
        if windows["point"] ~= nil then
            local point, relativeTo = windows["point"], windows["relativeTo"]
            local relativePoint = windows["relativePoint"]
            local xOfs, yOfs = windows["xOfs"], windows["yOfs"]
            scrollFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
        end
        if windows["point2"] ~= nil then
            local point, relativeTo = windows["point2"], windows["relativeTo2"]
            local relativePoint = windows["relativePoint2"]
            local xOfs, yOfs = windows["xOfs2"], windows["yOfs2"]
            scrollFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
        end
        if windows["width"] and windows["height"] then
            scrollFrame.parent:SetWidth(windows["width"])
            scrollFrame.parent:SetHeight(windows["height"])
        end
    end

    if messageWindow == nil or messageWindow == false then
        br.ui:createLeftArrow(scrollFrame)
        br.ui:createRightArrow(scrollFrame)
    end

    return scrollFrame
end

-- Load saved position
function br.ui:loadWindowPositions(thisWindow)
    local scrollFrame = br.ui.window[thisWindow]
    if scrollFrame == nil then
        return
    end
    if br.data.settings[br.loader.selectedSpec] == nil then
        br.data.settings[br.loader.selectedSpec] = {}
    end
    if br.data.settings[br.loader.selectedSpec][thisWindow] == nil then
        br.data.settings[br.loader.selectedSpec][thisWindow] = {}
    end
    local windows = br.data.settings[br.loader.selectedSpec][thisWindow]
    if windows["point"] ~= nil then
        local point, relativeTo = windows["point"], windows["relativeTo"]
        local relativePoint = windows["relativePoint"]
        local xOfs, yOfs = windows["xOfs"], windows["yOfs"]
        scrollFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
    if windows["point2"] ~= nil then
        local point, relativeTo = windows["point2"], windows["relativeTo2"]
        local relativePoint = windows["relativePoint2"]
        local xOfs, yOfs = windows["xOfs2"], windows["yOfs2"]
        scrollFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
    if windows["width"] and windows["height"] then
        scrollFrame.parent:SetWidth(windows["width"])
        scrollFrame.parent:SetHeight(windows["height"])
    end
end

function br.ui:checkWindowStatus(windowName)
    if br.data.settings[br.loader.selectedSpec][windowName] == nil then
        br.data.settings[br.loader.selectedSpec][windowName] = {}
    end
    local windows = br.data.settings[br.loader.selectedSpec][windowName]
    if windows["active"] == true or windows["active"] == nil then
        if br.ui.window[windowName].parent then
            br.ui.window[windowName].parent:Show()
            return
        end
    else
        if br.ui.window[windowName].parent then
            br.ui.window[windowName].parent:Hide() --.closeButton:Click()
            return
        end
    end
end

function br.ui:savePosition(windowName)
    if br.data.settings[br.loader.selectedSpec] == nil then
        br.data.settings[br.loader.selectedSpec] = {}
    end
    if br.data.settings[br.loader.selectedSpec][windowName] == nil then
        br.data.settings[br.loader.selectedSpec][windowName] = {}
    end
    if br.ui.window[windowName] ~= nil then
        if br.ui.window[windowName].parent ~= nil then
            local point, relativeTo, relativePoint, xOfs, yOfs = br.ui.window[windowName].parent:GetPoint(1)
            br.data.settings[br.loader.selectedSpec][windowName]["point"] = point
            br.data.settings[br.loader.selectedSpec][windowName]["relativeTo"] = relativeTo:GetName()
            br.data.settings[br.loader.selectedSpec][windowName]["relativePoint"] = relativePoint
            br.data.settings[br.loader.selectedSpec][windowName]["xOfs"] = xOfs
            br.data.settings[br.loader.selectedSpec][windowName]["yOfs"] = yOfs
            point, relativeTo, relativePoint, xOfs, yOfs = br.ui.window[windowName].parent:GetPoint(2)
            if point then
                br.data.settings[br.loader.selectedSpec][windowName]["point2"] = point
                br.data.settings[br.loader.selectedSpec][windowName]["relativeTo2"] = relativeTo:GetName()
                br.data.settings[br.loader.selectedSpec][windowName]["relativePoint2"] = relativePoint
                br.data.settings[br.loader.selectedSpec][windowName]["xOfs2"] = xOfs
                br.data.settings[br.loader.selectedSpec][windowName]["yOfs2"] = yOfs
            end
            br.data.settings[br.loader.selectedSpec][windowName]["width"] = br.ui.window[windowName].parent:GetWidth()
            br.data.settings[br.loader.selectedSpec][windowName]["height"] = br.ui.window[windowName].parent:GetHeight()
        end
    end
end

function br.ui:saveWindowPosition()
    for k, _ in pairs(br.ui.window) do
        if br.ui.window[k].parent ~= nil then
            br.ui:savePosition(k)
        end
    end
end

function br.ui:showWindow(windowName)
    local window = br.ui.window[windowName]
    if window ~= nil and window.parent ~= nil then
        window.parent:Show()
        br.data.settings[br.loader.selectedSpec][windowName].active = true
    end
end

-- windowName "all" closes every open window, for every spec that has it saved as open
function br.ui:closeWindow(windowName)
    for name, window in pairs(br.ui.window) do
        if window.parent ~= nil then
            if name == windowName then
                window.parent.closeButton:Click()
                return
            elseif windowName == "all" then
                for _, specSettings in pairs(br.data.settings) do
                    local state = type(specSettings) == "table" and specSettings[name]
                    if type(state) == "table" and state.active ~= false then
                        window.parent.closeButton:Click()
                        state.active = false
                    end
                end
            end
        end
    end
end

function br.ui:toggleWindow(windowName)
    local window = br.ui.window[windowName]
    local state = br.data.settings[br.loader.selectedSpec][windowName]
    if window == nil or window.parent == nil or state == nil then return end
    if state.active then
        window.parent.closeButton:Click()
        state.active = false
    else
        window.parent:Show()
        state.active = true
    end
end

function br.ui:recreateWindows()
    -- Close only config and debug windows, not profile window
    -- Profile window is created by br.player:createOptions() and should not be destroyed here
    br.ui:closeWindow("config")
    -- Hidden, not closed: closing the Rotation Log unticks its option
    if br.ui.window.debug and br.ui.window.debug.parent then br.ui.window.debug.parent:Hide() end
    br.ui:createConfigWindow()
    br.ui:createDebugWindow()
end
