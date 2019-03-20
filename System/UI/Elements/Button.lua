local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalTools = LibStub("DiesalTools-1.0")

function br.ui:createButton(parent, buttonName, x, y)
    if y == nil then
        y = -5
        for i=1, #parent.children do
            if parent.children[i].type ~= "Spinner" and parent.children[i].type ~= "Dropdown" then
                y = y - parent.children[i].frame:GetHeight()*1.2
            end
        end
        y = DiesalTools.Round(y)
    end
    if x == nil then x = 5 end
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
        if getOptionValue("Load Prior Saved Settings") == 1 then
            if br.dungeon == nil then
                br.dungeon = deepcopy(br.data)
            elseif br.dungeon.settings == nil then
                br.dungeon.settings = {}
                br.dungeon.settings[br.selectedSpec] = deepcopy(br.data.settings[br.selectedSpec])
            else
                br.dungeon.settings[br.selectedSpec] = deepcopy(br.data.settings[br.selectedSpec])
            end
            print("Dungeon Data Saved")
        elseif getOptionValue("Load Prior Saved Settings") == 2 then
            if br.mdungeon == nil then
                br.mdungeon = deepcopy(br.data)
            elseif br.mdungeon.settings == nil then
                br.mdungeon.settings = {}
                br.mdungeon.settings[br.selectedSpec] = deepcopy(br.data.settings[br.selectedSpec])
            else
                br.mdungeon.settings[br.selectedSpec] = deepcopy(br.data.settings[br.selectedSpec])
            end
            --raiddata = brdata
            print("Mythic Dungeon Data Saved")
         elseif getOptionValue("Load Prior Saved Settings") == 3 then
            if br.raid == nil then
                br.raid = deepcopy(br.data)
            elseif br.raid.settings == nil then
                br.raid.settings = {}
                br.raid.settings[br.selectedSpec] = deepcopy(br.data.settings[br.selectedSpec])
            else
                br.raid.settings[br.selectedSpec] = deepcopy(br.data.settings[br.selectedSpec])
            end
            --raiddata = brdata
            print("Raid Data Saved")
         elseif getOptionValue("Load Prior Saved Settings") == 4 then
            if br.mraid == nil then
                br.mraid = deepcopy(br.data)
            elseif br.mraid.settings == nil then
                br.mraid.settings = {}
                br.mraid.settings[br.selectedSpec] = deepcopy(br.data.settings[br.selectedSpec])
            else
                br.mraid.settings[br.selectedSpec] = deepcopy(br.data.settings[br.selectedSpec])
            end
            --raiddata = brdata
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
        if getOptionValue("Load Prior Saved Settings") == 1 then
            if br.dungeon ~= nil then
                if br.dungeon.settings ~= nil then
                    if br.dungeon.settings[br.selectedSpec] ~= nil then
                        br.data.settings[br.selectedSpec] = {}
                        br.data.settings[br.selectedSpec] = deepcopy(br.dungeon.settings[br.selectedSpec])
                        print("Dungeon Data Loaded")
                        br.rotationChanged = true  
                    else
                        print("Dungeon Settings do not exist.")
                    end
                else
                    print("Dungeon Settings do not exist.")
                end
            else
                print("Dungeon Settings do not exist.")
            end
        elseif getOptionValue("Load Prior Saved Settings") == 2 then
            if br.mdungeon ~= nil then
                if br.mdungeon.settings ~= nil then
                    if br.mdungeon.settings[br.selectedSpec] ~= nil then
                        br.data.settings[br.selectedSpec] = {}
                        br.data.settings[br.selectedSpec] = deepcopy(br.mdungeon.settings[br.selectedSpec])
                        print("Mythic Dungeon Data Loaded")
                        br.rotationChanged = true
                    else
                        print("Mythic Dungeon settings do not exist.")
                    end
                else
                    print("Mythic Dungeon settings do not exist.")
                end
            else
                print("Mythic Dungeon settings do not exist.")
            end
        elseif getOptionValue("Load Prior Saved Settings") == 3 then
            if br.raid ~= nil then
                if br.raid.settings ~= nil then
                    if br.raid.settings[br.selectedSpec] ~= nil then
                        br.data.settings[br.selectedSpec] = {}
                        br.data.settings[br.selectedSpec] = deepcopy(br.raid.settings[br.selectedSpec])
                        print("Raid Data Loaded")
                        br.rotationChanged = true
                    else
                        print("Raid settings do not exist.")
                    end
                else
                    print("Raid settings do not exist.")
                end
            else
                print("Raid settings do not exist.")
            end
        elseif getOptionValue("Load Prior Saved Settings") == 4 then
            if br.mraid ~= nil then
                if br.mraid.settings ~= nil then
                    if br.mraid.settings[br.selectedSpec] ~= nil then
                        br.data.settings[br.selectedSpec] = {}
                        br.data.settings[br.selectedSpec] = deepcopy(br.mraid.settings[br.selectedSpec])
                        print("Mythic Raid Data Loaded")
                        br.rotationChanged = true
                    else
                        print("Mythic Raid settings do not exist.")
                    end
                else
                    print("Mythic Raid settings do not exist.")
                end
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
