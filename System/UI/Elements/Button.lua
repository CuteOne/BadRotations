local DiesalGUI = LibStub("DiesalGUI-1.0")

function br.ui:createButton(parent, buttonName, x, y)
    local newButton = DiesalGUI:Create('Button')
    local parent = parent

    parent:AddChild(newButton)
    newButton:SetParent(parent.content)
    newButton:AddStyleSheet(br.ui.buttonStyleSheet)
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

function br.ui:createSettingsButton(parent, buttonName, x, y)
        local newButton = DiesalGUI:Create('Button')
        local parent = parent

        parent:AddChild(newButton)
        newButton:SetParent(parent.content)
        newButton:AddStyleSheet(br.ui.buttonStyleSheet)
        newButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
        newButton:SetText(buttonName)
        newButton:SetWidth(100)
        newButton:SetHeight(20)
        newButton:SetEventListener("OnClick", function()
            if buttonName == "Save" then
                if isChecked("Dungeons") and not isChecked("Raids") then
                    br.dungeon = deepcopy(br.data)
                    print("Dungeon Data Saved")
                elseif isChecked("Raids") and not isChecked("Dungeons") then
                    --raiddata = brdata
                    br.raid = deepcopy(br.data)
                    print("Raid Data Saved")
                else 
                    print("Save Error")
                end
            elseif buttonName == "Load" then
                if isChecked("Dungeons") and not isChecked("Raids") then
                    br.data = {}
                    if br.dungeon ~= nil then
                        br.data = deepcopy(br.dungeon)
                        print("Dungeon Data Loaded")
                        br.ui:closeWindow("all")
                        br:loadSettings()
                        if isChecked("Save/Load Settings") == true then
                            slsettings:SetChecked(false)
                        end
                    else 
                        print("Dungeon Settings do not exist.")
                    end                         
                elseif isChecked("Raids") and not isChecked("Dungeons") then
                    if br.raid ~= nil then
                        br.data = deepcopy(br.raid)
                        print("Raid Data Loaded")
                        br.ui:closeWindow("all")
                        br:loadSettings()
                        if isChecked("Save/Load Settings") == true then
                            slsettings:SetChecked(false)
                        end
                    else
                        print("Raid settings do not exist.")
                    end
                else
                    print("Load Error")
                end
            end
        end)

        parent:AddChild(newButton)

        return newButton
    end
