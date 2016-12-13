function br.ui:createHelpWindow()
    br.ui:createHelpWindow()
    br.ui.window.help = br.ui:createMessageWindow("Help")
    local colorBlue = "|cff00CCFF"
    local colorGreen = "|cff00FF00"
    local colorRed = "|cffFF0011"
    local colorWhite = "|cffFFFFFF"
    local colorGold = "|cffFFDD11"
    br.ui.window.help:AddMessage(colorGreen.. "--- [[ AUTHORS ]] ---")
    br.ui.window.help:AddMessage(colorRed.. "CuteOne")
    br.ui.window.help:AddMessage("----------------------------------------")
    --
    br.ui.window.help:AddMessage(colorGreen.. "--- [[ TODO ]] ---")
    br.ui.window.help:AddMessage(colorGold.. "HELP WINDOW NOT FINISHED YET ! ")
    br.ui.window.help.parent:Hide()
end