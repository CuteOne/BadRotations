local DiesalGUI = LibStub("DiesalGUI-1.0")

-- Window creators
function br.ui:createWindow(name, width, height, title)
    if title == nil then titleName = name end
    local window = DiesalGUI:Create('Window')
    window:SetTitle('BadRotations', title)
    window.settings.width = width or 250
    window.settings.height = height or 250
    window.settings.header = true
    window.frame:SetClampedToScreen(true)
    window:ApplySettings()

    window.closeButton:SetScript("OnClick", function(this, button)
        br:savePosition(name)
        br.data.settings[br.selectedSpec][name]["active"] = false
        DiesalGUI:OnMouse(this,button)
        PlaySound("gsTitleOptionExit")
        window:FireEvent("OnClose")
        window:Hide()
    end)

    local scrollFrame = DiesalGUI:Create('ScrollFrame')
    window:AddChild(scrollFrame)
    scrollFrame:SetParent(window.content)
    scrollFrame:SetAllPoints(window.content)
    scrollFrame.parent = window

    if br.selectedSpec == nil then br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization())) end
    if br.data.settings[br.selectedSpec] == nil then br.data.settings[br.selectedSpec] = {} end
    if br.data.settings[br.selectedSpec][name] == nil then br.data.settings[br.selectedSpec][name] = {} end
    local windows = br.data.settings[br.selectedSpec][name]
    if windows["point"] ~= nil then
        local point, relativeTo = windows["point"], windows["relativeTo"]
        local relativePoint     = windows["relativePoint"]
        local xOfs, yOfs        = windows["xOfs"], windows["yOfs"]
        scrollFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
    if windows["point2"] ~= nil then
        local point, relativeTo = windows["point2"], windows["relativeTo2"]
        local relativePoint     = windows["relativePoint2"]
        local xOfs, yOfs        = windows["xOfs2"], windows["yOfs2"]
        scrollFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
    if windows["width"] and windows["height"] then
        scrollFrame.parent:SetWidth(windows["width"])
        scrollFrame.parent:SetHeight(windows["height"])
    end

    br.ui:createLeftArrow(scrollFrame)
    br.ui:createRightArrow(scrollFrame)
    return scrollFrame
end

function br.ui:createMessageWindow(name, width, height, title)
    if title == nil then title = name end
    local window = DiesalGUI:Create('Window')
    window:SetTitle('BadRotations', title)
    window.settings.width = width or 300
    window.settings.height = height or 250
    window.frame:SetClampedToScreen(true)
    window:ApplySettings()

    window.closeButton:SetScript("OnClick", function(this, button)
        br:savePosition(name)
        br.data.settings[br.selectedSpec][name]["active"] = false
        DiesalGUI:OnMouse(this,button)
        PlaySound("gsTitleOptionExit")
        window:FireEvent("OnClose")
        window:Hide()
    end)

    local newMessageFrame = DiesalGUI:Create('ScrollingMessageFrameBR')
    window:AddChild(newMessageFrame)
    newMessageFrame:SetParent(window.content)
    newMessageFrame:SetAllPoints(window.content)
    newMessageFrame.parent = window

    if br.selectedSpec == nil then br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization())) end
    if br.data.settings[br.selectedSpec] == nil then br.data.settings[br.selectedSpec] = {} end
    if br.data.settings[br.selectedSpec][name] == nil then br.data.settings[br.selectedSpec][name] = {} end
    local windows = br.data.settings[br.selectedSpec][name]
    if windows["point"] ~= nil then
        local point, relativeTo = windows["point"], windows["relativeTo"]
        local relativePoint     = windows["relativePoint"]
        local xOfs, yOfs        = windows["xOfs"], windows["yOfs"]
        newMessageFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
    if windows["point2"] ~= nil then
        local point, relativeTo = windows["point2"], windows["relativeTo2"]
        local relativePoint     = windows["relativePoint2"]
        local xOfs, yOfs        = windows["xOfs2"], windows["yOfs2"]
        newMessageFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
    if windows["width"] and windows["height"] then
        newMessageFrame.parent:SetWidth(windows["width"])
        newMessageFrame.parent:SetHeight(windows["height"])
    end

    return newMessageFrame
end

-- Load saved position
function br.ui:loadWindowPositions(window,scrollFrame)
    local scrollFrame = scrollFrame    
    if br.selectedSpec == nil then br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization())) end
    if br.data.settings[br.selectedSpec] == nil then br.data.settings[br.selectedSpec] = {} end
    if br.data.settings[br.selectedSpec][window] == nil then br.data.settings[br.selectedSpec][window] = {} end
    local windows = br.data.settings[br.selectedSpec][window]
    if windows["point"] ~= nil then
        local point, relativeTo = windows["point"], windows["relativeTo"]
        local relativePoint     = windows["relativePoint"]
        local xOfs, yOfs        = windows["xOfs"], windows["yOfs"]
        scrollFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
    if windows["point2"] ~= nil then
        local point, relativeTo = windows["point2"], windows["relativeTo2"]
        local relativePoint     = windows["relativePoint2"]
        local xOfs, yOfs        = windows["xOfs2"], windows["yOfs2"]
        scrollFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
    if windows["width"] and windows["height"] then
        scrollFrame.parent:SetWidth(windows["width"])
        scrollFrame.parent:SetHeight(windows["height"])
    end
end

function br.ui:checkWindowStatus(windowName)
    if br.data.settings[br.selectedSpec][windowName] == nil then br.data.settings[br.selectedSpec][windowName] = {} end
    local windows = br.data.settings[br.selectedSpec][windowName]
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

function br.ui:recreateWindows()
    br.ui.window.config.parent.closeButton:Click()
    br.ui.window.debug.parent.closeButton:Click()
    br.ui.window.profile.parent.closeButton:Click()

    br.ui:createConfigWindow()
    br.ui:createDebugWindow()
end