local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
local DiesalTools = LibStub("DiesalTools-1.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")

br.ui.window = {}

-- Window creators
function br.ui:createWindow(name, width, height, title, color, messageWindow)
    if title == nil then title = name end
    if color == nil then color = br.classColor end
    local window = DiesalGUI:Create('Window')
    window:SetTitle(color..'BadRotations', title)
    window.settings.width = width or 250
    window.settings.height = height or 250
    window.settings.header = true
    window.settings.footer = true
    window.frame:SetClampedToScreen(true)
    window:ApplySettings()

    window.closeButton:SetScript("OnClick", function(this, button)
        br.ui:savePosition(name)
        br.data.settings[br.selectedSpec][name]["active"] = false
        DiesalGUI:OnMouse(this,button)
        PlaySound(799)
        window:FireEvent("OnClose")
        window:Hide()
    end)

    if messageWindow == nil or messageWindow == false then
        scrollFrame = DiesalGUI:Create('ScrollFrame')
    elseif messageWindow == true then
        scrollFrame = DiesalGUI:Create('ScrollingMessageFrame')
        scrollFrame:SetStylesheet(br.ui.messageStylesheet)
    end
    window:AddChild(scrollFrame)
    scrollFrame:SetParent(window.content)
    scrollFrame:SetAllPoints(window.content)
    scrollFrame.parent = window

    if br.data.settings and br.data.settings[br.selectedSpec] == nil then br.data.settings[br.selectedSpec] = {} end
    if br.data.settings and br.data.settings[br.selectedSpec] and br.data.settings[br.selectedSpec][name] == nil then br.data.settings[br.selectedSpec][name] = {} end
    if br.data.settings[br.selectedSpec][name] then
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
    if scrollFrame == nil then return end
    if br.data.settings[br.selectedSpec] == nil then br.data.settings[br.selectedSpec] = {} end
    if br.data.settings[br.selectedSpec][thisWindow] == nil then br.data.settings[br.selectedSpec][thisWindow] = {} end
    local windows = br.data.settings[br.selectedSpec][thisWindow]
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

function br.ui:savePosition(windowName)
    if br.data.settings[br.selectedSpec] == nil then br.data.settings[br.selectedSpec] = {} end
    if br.data.settings[br.selectedSpec][windowName] == nil then br.data.settings[br.selectedSpec][windowName] = {} end
    if br.ui.window[windowName] ~= nil then
        if br.ui.window[windowName].parent ~= nil then
            local point, relativeTo, relativePoint, xOfs, yOfs = br.ui.window[windowName].parent:GetPoint(1)
            br.data.settings[br.selectedSpec][windowName]["point"] = point
            br.data.settings[br.selectedSpec][windowName]["relativeTo"] = relativeTo:GetName()
            br.data.settings[br.selectedSpec][windowName]["relativePoint"] = relativePoint
            br.data.settings[br.selectedSpec][windowName]["xOfs"] = xOfs
            br.data.settings[br.selectedSpec][windowName]["yOfs"] = yOfs
            point, relativeTo, relativePoint, xOfs, yOfs = br.ui.window[windowName].parent:GetPoint(2)
            if point then
                br.data.settings[br.selectedSpec][windowName]["point2"] = point
                br.data.settings[br.selectedSpec][windowName]["relativeTo2"] = relativeTo:GetName()
                br.data.settings[br.selectedSpec][windowName]["relativePoint2"] = relativePoint
                br.data.settings[br.selectedSpec][windowName]["xOfs2"] = xOfs
                br.data.settings[br.selectedSpec][windowName]["yOfs2"] = yOfs
            end
            br.data.settings[br.selectedSpec][windowName]["width"]  = br.ui.window[windowName].parent:GetWidth()
            br.data.settings[br.selectedSpec][windowName]["height"] = br.ui.window[windowName].parent:GetHeight()
        end
    end
end

function br.ui:saveWindowPosition()
    for k, v in pairs(br.ui.window) do
        if br.ui.window[k].parent ~= nil then
            br.ui:savePosition(k)
        end
    end
end

function br.ui:showWindow(windowName)
    for k, v in pairs(br.ui.window) do
        if k == windowName then
            if br.ui.window[k].parent ~= nil then
                br.ui.window[k].parent:Show()
                br.data.settings[br.selectedSpec][k].active = true
            end
        end
    end
end

function br.ui:closeWindow(windowName)
    for k, v in pairs(br.ui.window) do
        if k == windowName or windowName == "all" then
            if br.ui.window[k].parent ~= nil then
                if k == windowName then
                    br.ui.window[k].parent.closeButton:Click();
                    break
                else
                    for l, w in pairs(br.data.settings) do
                        if br.data.settings[tostring(l)] ~= nil and type(w) ~= "string" and type(w) ~= "number" and type(w) ~= "boolean" then
                            for m, x in pairs(br.data.settings[tostring(l)]) do
                                if m == k then
                                    if br.data.settings[br.selectedSpec].toggles ~= nil and br.data.settings[br.selectedSpec].toggles["Power"] ~= 1 then
                                        if br.data.settings[l][m].active == nil or br.data.settings[l][m].active then
                                            br.ui.window[k].parent.closeButton:Click()
                                            br.data.settings[l][m].active = false
                                        end
                                    elseif br.data.settings[l][m].active == nil or br.data.settings[l][m].active then
                                        br.ui.window[k].parent.closeButton:Click()
                                        br.data.settings[l][m].active = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function br.ui:toggleWindow(windowName)
    for k, v in pairs(br.ui.window) do
        if k == windowName then
            if br.ui.window[k].parent ~= nil then
                if br.data.settings[br.selectedSpec][k] ~= nil then
                    if br.data.settings[br.selectedSpec][k].active == nil then
                        br.ui.window[k].parent:Show()
                        br.data.settings[br.selectedSpec][k].active = true
                    elseif br.data.settings[br.selectedSpec][k].active then
                        br.ui.window[k].parent.closeButton:Click()
                        br.data.settings[br.selectedSpec][k].active = false
                    else
                        br.ui.window[k].parent:Show()
                        br.data.settings[br.selectedSpec][k].active = true
                    end
                end
            end
        end
    end
end

function br.ui:recreateWindows()
    br.ui:closeWindow("all")
    br.ui:createConfigWindow()
    br.ui:createDebugWindow()
end
