local _, br = ...
-- TODO: create new debug frame
br.ui.window.debug = {}
function br.ui:createDebugWindow()
    -- br.ui.window.debug = br.ui:createMessageWindow("debug",300,250,"Rotation Log")
    br.ui.window.debug = br.ui:createWindow("debug", 300, 250, "Rotation Log", nil, true)
    br.ui.window.debug.parent.closeButton:SetScript(
        "OnClick",
        function()
            if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] ~= nil and br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["General"] ~= nil then
                br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["General"]["Rotation Log Check"] = false
                if br.data.ui["General"] == nil then br.data.ui["General"] = {} end
                br.data.ui["General"]["Rotation Log Check"] = false
            end
            if br.ui.rotationLog ~= nil then
                br.ui.rotationLog:SetChecked(false)
            end
            if br.data.settings[br.loader.selectedSpec].debug == nil then
                br.data.settings[br.loader.selectedSpec].debug = {}
            end
            br.data.settings[br.loader.selectedSpec].debug["active"] = false
            br.ui.window.debug.parent:Hide()
        end
    )
    br.ui:checkWindowStatus("debug")
end

function br.ui:toggleDebugWindow()
    if not br.ui.window["debug"]["parent"] then
        br.ui:createDebugWindow()
        br.ui:closeWindow("debug")
    end
    if br.functions.misc:getOptionCheck("Rotation Log") then
        if not br.ui.window["debug"]["parent"] then
            br.ui:createDebugWindow()
        end
        br.ui:showWindow("debug")
    elseif br.data.settings[br.loader.selectedSpec]["debug"] == nil then
        br.data.settings[br.loader.selectedSpec]["debug"] = {}
        br.data.settings[br.loader.selectedSpec]["debug"].active = false
    elseif br.data.settings[br.loader.selectedSpec]["debug"].active == true then
        br.ui:closeWindow("debug")
    end
end
