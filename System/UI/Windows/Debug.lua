-- TODO: create new debug frame
function br.ui:createDebugWindow()
    br.ui.window.debug = br.ui:createMessageWindow("debug",300,250,"Rotation Log")
    br.ui.window.debug.parent.closeButton:SetScript("OnClick", function()
		br.data.settings[br.selectedSpec][br.selectedProfile]["Rotation LogCheck"] = false
    	rotationLog:SetChecked(false)
        br.data.settings[br.selectedSpec].debug["active"] = false
        br.ui.window.debug.parent:Hide()
    end)
	br.ui:checkWindowStatus("debug")
end