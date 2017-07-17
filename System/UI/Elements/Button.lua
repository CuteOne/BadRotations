local DiesalGUI = LibStub("DiesalGUI-1.0")

function br.ui:createButton(parent, buttonName, x, y)
    local newButton = DiesalGUI:Create('Button')
    local parent = parent

    parent:AddChild(newButton)
    newButton:SetParent(parent.content)
    newButton:SetStylesheet(br.ui.buttonStyleSheet)
    newButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    newButton:SetText(buttonName)
    newButton:SetWidth(100)
    newButton:SetHeight(20)
    --newBox:SetEventListener("OnClick", function()
    --
    --end)

    parent:AddChild(newButton)

    return newButton
end

function br.ui:createSaveButton(parent, buttonName, x, y)
    local saveButton = DiesalGUI:Create('Button')
    local parent = parent

  --  parent:AddChild(saveButton)
    saveButton:SetParent(parent.content)
    saveButton:SetStylesheet(br.ui.buttonStyleSheet)
    saveButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    saveButton:SetText(buttonName)
    saveButton:SetWidth(100)
    saveButton:SetHeight(20)
    saveButton:SetEventListener("OnClick", function()
        if getOptionValue("Settings to Load") == 1 then
            br.dungeon = deepcopy(br.data)
            print("Dungeon Data Saved")
        elseif getOptionValue("Settings to Load") == 2 then
            --raiddata = brdata
            br.mdungeon = deepcopy(br.data)
            print("Mythic Dungeon Data Saved")
         elseif getOptionValue("Settings to Load") == 3 then
            --raiddata = brdata
            br.raid = deepcopy(br.data)
            print("Raid Data Saved")
         elseif getOptionValue("Settings to Load") == 4 then
            --raiddata = brdata
            br.mraid = deepcopy(br.data)
            print("Mythic Raid Data Saved")
        else 
            print("Save Error")
        end
    --    parent:Release()
    end)

    parent:AddChild(saveButton)

    return saveButton
end

function br.ui:createLoadButton(parent, buttonName, x, y)
    local loadButton = DiesalGUI:Create('Button')
    local parent = parent

   -- parent:AddChild(loadButton)
    loadButton:SetParent(parent.content)
    loadButton:SetStylesheet(br.ui.buttonStyleSheet)
    loadButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    loadButton:SetText(buttonName)
    loadButton:SetWidth(100)
    loadButton:SetHeight(20)
    loadButton:SetEventListener("OnClick", function()
        if getOptionValue("Settings to Load") == 1 then
            if br.dungeon ~= nil then
                br.data = {}
                br.data = deepcopy(br.dungeon)
                print("Dungeon Data Loaded")
                br.ui:closeWindow("all")
                br:loadSettings()
            else 
                print("Dungeon Settings do not exist.")
            end                         
        elseif getOptionValue("Settings to Load") == 2 then
            if br.mdungeon ~= nil then
                br.data = {}
                br.data = deepcopy(br.mdungeon)
                print("Mythic Dungeon Data Loaded")
                br.ui:closeWindow("all")
                br:loadSettings()
            else
                print("Mythic Dungeon settings do not exist.")
            end
        elseif getOptionValue("Settings to Load") == 3 then
            if br.raid ~= nil then
                br.data = {}
                br.data = deepcopy(br.raid)
                print("Raid Data Loaded")
                br.ui:closeWindow("all")
                br:loadSettings()
            else
                print("Raid settings do not exist.")
            end
        elseif getOptionValue("Settings to Load") == 4 then
            if br.mraid ~= nil then
                br.data = {}
                br.data = deepcopy(br.mraid)
                print("Mythic Raid Data Loaded")
                br.ui:closeWindow("all")
                br:loadSettings()
            else
                print("Mythic Raid settings do not exist.")
            end
        else
            print("Load Error")
        end
     --   parent:Release()
    end)

    parent:AddChild(loadButton)

    return loadButton
end
