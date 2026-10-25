local _, br = ...
br.ui.window.profile = {}
function br.ui:createProfileWindow(spec)
    if spec == "Initial" or not br.client.rules.hasSubSpecs then
        spec = br.game.UnitClass("player")
    end
    br.ui.window.profile = br.ui:createWindow("profile", 275, 400, spec)
    br.ui:checkWindowStatus("profile")
end
