-- TODO: create new debug frame
br.ui.window.debug = {}
function br.ui:createDebugWindow()
    -- br.ui.window.debug = br.ui:createMessageWindow("debug",300,250,"Rotation Log")
    br.ui.window.debug = br.ui:createWindow("debug",300,250,"Rotation Log",nil,true)
    br.ui.window.debug.parent.closeButton:SetScript("OnClick", function()
    	if br.data.settings[br.selectedSpec][br.selectedProfile] ~= nil then
			br.data.settings[br.selectedSpec][br.selectedProfile]["Rotation LogCheck"] = false
		end
        if rotationLog ~= nil then rotationLog:SetChecked(false) end
        if br.data.settings[br.selectedSpec].debug == nil then br.data.settings[br.selectedSpec].debug = {} end
        br.data.settings[br.selectedSpec].debug["active"] = false
        br.ui.window.debug.parent:Hide()
    end)
	br.ui:checkWindowStatus("debug")
end
function br.ui:toggleDebugWindow()
    if not br.ui.window['debug']['parent'] then
        br.ui:createDebugWindow()
        br.ui:closeWindow("debug")
    end
    if getOptionCheck("Rotation Log") then
        if not br.ui.window['debug']['parent'] then br.ui:createDebugWindow() end
        br.ui:showWindow("debug")
    elseif br.data.settings[br.selectedSpec]["debug"] == nil then
            br.data.settings[br.selectedSpec]["debug"] = {}
            br.data.settings[br.selectedSpec]["debug"].active = false
    elseif br.data.settings[br.selectedSpec]["debug"].active == true then
        br.ui:closeWindow("debug")
    end
end