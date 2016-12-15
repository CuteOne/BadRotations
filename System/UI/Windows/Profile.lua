br.ui.window.profile = {}
function br.ui:createProfileWindow(spec)
    br.ui.window.profile = br.ui:createWindow("profile", 275, 400, spec)
    br.ui:checkWindowStatus("profile")
end