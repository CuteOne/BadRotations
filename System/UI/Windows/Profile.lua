function br.ui:createProfileWindow(spec)
    br.ui.window.profile = br.ui:createWindow("profile", 275, 400, spec, classColors[select(3,UnitClass("player"))].hex)
    -- local window = DiesalGUI:Create('Window')
    -- window:SetTitle('BadRotations', name)
    -- window.settings.width = width or 300
    -- window.settings.height = height or 250
    -- window.settings.header = true
    -- window.frame:SetClampedToScreen(true)
    -- window:ApplySettings()

    -- window.closeButton:SetScript("OnClick", function(this, button)
    --     br:savePosition("profile")--br:saveProfileWindowPosition()
    --     br.data.settings[br.selectedSpec].profile["active"] = false
    --     DiesalGUI:OnMouse(this,button)
    --     PlaySound("gsTitleOptionExit")
    --     window:FireEvent("OnClose")
    --     window:Hide()
    -- end)

    -- local scrollFrame = DiesalGUI:Create('ScrollFrame')
    -- window:AddChild(scrollFrame)
    -- scrollFrame:SetParent(window.content)
    -- scrollFrame:SetAllPoints(window.content)
    -- scrollFrame.parent = window

    -- br.ui:loadWindowPositions("profile")

    br.ui:checkWindowStatus("profile")

    -- br.ui:createLeftArrow(scrollFrame)
    -- br.ui:createRightArrow(scrollFrame)
    -- return scrollFrame
end