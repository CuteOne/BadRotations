-- TODO: create new healing debug frame
br.ui.window.healing = {}
function br.ui:createHealingWindow()
    br.ui.window.healing = br.ui:createMessageWindow("healing",200,150,"Healing Debug")
    br.ui.window.healing.parent.closeButton:SetScript("OnClick", function()
    	if br.data.settings[br.selectedSpec][br.selectedProfile] ~= nil then
			br.data.settings[br.selectedSpec][br.selectedProfile]["Healing DebugCheck"] = false
		end
    	if healingDebug ~= nil then healingDebug:SetChecked(false) end
        br.data.settings[br.selectedSpec].healing["active"] = false
        br.ui.window.healing.parent:Hide()
    end)
	br.ui:checkWindowStatus("healing")
end