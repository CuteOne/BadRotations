local _, br = ...
-- TODO: create new healing debug frame
br.ui.window.healing = {}
function br.ui:createHealingWindow()
    br.ui.window.healing = br.ui:createWindow("healing", 200, 150, "Healing Debug", nil, true)
    br.ui.window.healing.parent.closeButton:SetScript(
        "OnClick",
        function()
            if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] ~= nil then
                br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["Healing DebugCheck"] = false
            end
            if br.healingDebug ~= nil then
                br.healingDebug:SetChecked(false)
            end
            br.data.settings[br.loader.selectedSpec].healing["active"] = false
            br.ui.window.healing.parent:Hide()
        end
    )
    br.ui:checkWindowStatus("healing")
end
