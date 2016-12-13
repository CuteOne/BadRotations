function br.ui:createHelpWindow()
    br.ui.window.help   = br.ui:createMessageWindow("help",500,500,"Information")
    local colorBlue     = "|cff00CCFF"
    local colorGreen    = "|cff00FF00"
    local colorRed      = "|cffFF0011"
    local colorWhite    = "|cffFFFFFF"
    local colorGold     = "|cffFFDD11"
    br.ui.window.help:AddMessage(colorGold.. "--- [[ AUTHORS ]] ---")
    br.ui.window.help:AddMessage(colorRed.. "CuteOne, Cpoworks, Gabbz, Svs")
    br.ui.window.help:AddMessage(colorGold.. "--- [[ CONTRIBUTORS ]] ---")
    br.ui.window.help:AddMessage(colorGreen.. "Vilt")
    br.ui.window.help:AddMessage(colorGold.. "--- [[ PATRONS ]] ---")
    br.ui.window.help:AddMessage(colorBlue.. "Blyaat, dbtftw")
    br.ui.window.help:AddMessage("----------------------------------------")
    --
    br.ui.window.help:AddMessage(colorGold.. "--- [[ TODO ]] ---")
    br.ui.window.help:AddMessage(colorWhite.. "HELP WINDOW NOT FINISHED YET ! ")
    br.ui:checkWindowStatus("help")
end