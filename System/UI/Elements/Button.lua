local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalTools = _G.LibStub("DiesalTools-1.0")
local _, br = ...
function br.ui:createButton(parent, buttonName, x, y, onClickFunction, alignRight)
    if y == nil then
        y = -5
        for i = 1, #parent.children do
            if parent.children[i].type ~= "Spinner" and parent.children[i].type ~= "Dropdown" then
                y = y - parent.children[i].frame:GetHeight() * 1.2
            end
        end
        y = DiesalTools.Round(y)
    end
    if x == nil then
        x = 5
    end
    local newButton = DiesalGUI:Create("Button")
    local parent = parent

    newButton:SetParent(parent.content)
    parent:AddChild(newButton)
    newButton:SetStylesheet(br.ui.buttonStyleSheet)
    if alignRight then
        newButton:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", x, y)
    else
        newButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    end
    newButton:SetText(buttonName)
    newButton:SetWidth(100)
    newButton:SetHeight(20)
    newButton:SetEventListener(
        "OnClick",
        function()
            onClickFunction()
        end
    )
end

function br.ui:createSaveButton(parent, buttonName, x, y)
    local saveButton = DiesalGUI:Create("Button")
    local parent = parent

    --  parent:AddChild(saveButton)
    saveButton:SetParent(parent.content)
    saveButton:SetStylesheet(br.ui.buttonStyleSheet)
    saveButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    saveButton:SetText(buttonName)
    saveButton:SetWidth(20)
    saveButton:SetHeight(20)
    saveButton:SetEventListener(
        "OnClick",
        function()
            local newWindow = DiesalGUI:Create("Window")
            parent:AddChild(newWindow)
            newWindow:SetTitle("Create Profile")
            newWindow.settings.width = 200
            newWindow.settings.height = 75
            newWindow.settings.minWidth = newWindow.settings.width
            newWindow.settings.minHeight = newWindow.settings.height
            newWindow.settings.maxWidth = newWindow.settings.width
            newWindow.settings.maxHeight = newWindow.settings.height
            newWindow:ApplySettings()

            local profileInput = DiesalGUI:Create("Input")
            newWindow:AddChild(profileInput)
            profileInput:SetParent(newWindow.content)
            profileInput:SetPoint("TOPLEFT", newWindow.content, "TOPLEFT", 5, -5)
            profileInput:SetPoint("BOTTOMRIGHT", newWindow.content, "TOPRIGHT", -5, -25)
            profileInput:SetText("New Profile Name")

            local profileButton = DiesalGUI:Create("Button")
            newWindow:AddChild(profileButton)
            profileButton:SetParent(newWindow.content)
            profileButton:SetPoint("TOPLEFT", newWindow.content, "TOPLEFT", 5, -30)
            profileButton:SetPoint("BOTTOMRIGHT", newWindow.content, "TOPRIGHT", -5, -50)
            if profileButton.SetStylesheet then
                profileButton:SetStylesheet(br.ui.buttonStyleSheet)
            end
            profileButton:SetText("Create New Profile")
            profileButton:SetEventListener(
                "OnClick",
                function()
                    local profiles =
                        br.functions.settingsManagement:fetch(br.loader.selectedSpec .. "_" .. "profiles", { { key = "default", text = "Default" } })
                    local profileName = profileInput:GetText()
                    local pkey = string.gsub(profileName, "%s+", "")
                    if profileName ~= "" then
                        for _, p in ipairs(profiles) do
                            if p.key == pkey then
                                profileButton:SetText("|cffff3300Profile with that name exists!|r")
                                br._G.C_Timer.NewTicker(
                                    2,
                                    function()
                                        profileButton:SetText("Create New Profile")
                                    end,
                                    1
                                )
                                return false
                            end
                        end
                        table.insert(profiles, { key = pkey, text = br.settingsManagement:deepcopy(br.data.settings[br.loader.selectedSpec]) })
                        br.functions.settingsManagement:store(br.loader.selectedSpec .. "_" .. "profiles", profiles)
                        br.functions.settingsManagement:store(br.loader.selectedSpec .. "_" .. "profile", pkey)
                        newWindow:Hide()
                        parent:Hide()
                        parent:Release()
                        br.rotationChanged = true
                    end
                end
            )
            profileInput:SetEventListener(
                "OnEnterPressed",
                function()
                    local profiles =
                        br.functions.settingsManagement:fetch(br.loader.selectedSpec .. "_" .. "profiles", { { key = "default", text = "Default" } })
                    local profileName = profileInput:GetText()
                    local pkey = string.gsub(profileName, "%s+", "")
                    if profileName ~= "" then
                        for _, p in ipairs(profiles) do
                            if p.key == pkey then
                                profileButton:SetText("|cffff3300Profile with that name exists!|r")
                                br._G.C_Timer.NewTicker(
                                    2,
                                    function()
                                        profileButton:SetText("Create New Profile")
                                    end,
                                    1
                                )
                                return false
                            end
                        end
                        table.insert(profiles, { key = pkey, text = br.settingsManagement:deepcopy(br.data.settings[br.loader.selectedSpec]) })
                        br.functions.settingsManagement:store(br.loader.selectedSpec .. "_" .. "profiles", profiles)
                        br.functions.settingsManagement:store(br.loader.selectedSpec .. "_" .. "profile", pkey)
                        newWindow:Hide()
                        parent:Hide()
                        parent:Release()
                        br.rotationChanged = true
                    end
                end
            )
        end
    )

    parent:AddChild(saveButton)

    return saveButton
end

function br.ui:createDeleteButton(parent, buttonName, x, y)
    local deleteButton = DiesalGUI:Create("Button")
    local parent = parent

    --  parent:AddChild(saveButton)
    deleteButton:SetParent(parent.content)
    deleteButton:SetStylesheet(br.ui.buttonStyleSheet)
    deleteButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    deleteButton:SetText(buttonName)
    deleteButton:SetWidth(20)
    deleteButton:SetHeight(20)
    deleteButton:SetEventListener(
        "OnClick",
        function()
            local selectedProfile = br.profileDropValue
            local profiles = br.functions.settingsManagement:fetch(br.loader.selectedSpec .. "_" .. "profiles", { { key = "default", text = "Default" } })
            if selectedProfile ~= "default" then
                for i, p in ipairs(profiles) do
                    if p.key == selectedProfile then
                        profiles[i] = nil
                        br._G.print("Deleting " .. selectedProfile .. " profile!")
                        br.functions.settingsManagement:store(br.loader.selectedSpec .. "_" .. "profiles", profiles)
                        br.functions.settingsManagement:store(br.loader.selectedSpec .. "_" .. "profile", "default")
                        parent:Hide()
                        parent:Release()
                        br.rotationChanged = true
                    end
                end
            else
                br._G.print("Cannot delete default profile!")
            end
        end
    )

    parent:AddChild(deleteButton)

    return deleteButton
end

function br.ui:createLoadButton(parent, buttonName, x, y)
    local loadButton = DiesalGUI:Create("Button")
    local parent = parent

    -- parent:AddChild(loadButton)
    loadButton:SetParent(parent.content)
    loadButton:SetStylesheet(br.ui.buttonStyleSheet)
    loadButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    loadButton:SetText(buttonName)
    loadButton:SetWidth(100)
    loadButton:SetHeight(20)
    loadButton:SetEventListener(
        "OnClick",
        function()
            if br.profileDropValue == "default" then
                br._G.print("Please select a profile other than default!")
                return
            end
            if br.settingsManagement.profile ~= nil then
                if br.settingsManagement.profile[br.loader.selectedSpec .. "_" .. "profiles"] ~= nil then
                    local lProfile = br.settingsManagement.profile[br.loader.selectedSpec .. "_" .. "profiles"]
                    for _, v in pairs(lProfile) do
                        if v.key == br.profileDropValue then
                            br.data.settings[br.loader.selectedSpec] = br.settingsManagement:deepcopy(v.text)
                            br._G.print(v.key .. " profile found!")
                            br.rotationChanged = true
                            break
                        end
                    end
                end
            else
                print("Load Error")
            end
        end
    )

    parent:AddChild(loadButton)

    return loadButton
end

function br.ui:createExportButton(parent, buttonName, x, y)
    local exportButton = DiesalGUI:Create("Button")
    local parent = parent

    exportButton:SetParent(parent.content)
    exportButton:SetStylesheet(br.ui.buttonStyleSheet)
    exportButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    exportButton:SetText(buttonName)
    exportButton:SetWidth(100)
    exportButton:SetHeight(20)
    exportButton:SetEventListener(
        "OnClick",
        function()
            br.settingsManagement:cleanSettings()
            br.settingsManagement:saveSettings("Exported Settings", nil, br.loader.selectedSpec, br.loader.selectedProfileName)
            -- br.settingsManagement:saveSettings(nil,"Exported Settings")

            -- -- Save br.data for current profile to Settings folder
            -- local exportDir = br.settingsManagement:checkDirectories("Exported Settings")
            -- local savedSettings = deepcopy(br.data)
            -- local settingsFile = br.loader.selectedSpec..selectedProfileName
            -- if savedSettings ~= nil then
            --     br.tableSave(savedSettings,exportDir .. settingsFile .. ".lua")
            --     Print("Exported Settings for Profile "..settingsFile.." to Exported Settings Folder")
            -- else
            --     Print("Error Saving Settings File")
            -- end
        end
    )

    parent:AddChild(exportButton)

    return exportButton
end

function br.ui:createImportButton(parent, buttonName, x, y)
    local importButton = DiesalGUI:Create("Button")
    local parent = parent

    importButton:SetParent(parent.content)
    importButton:SetStylesheet(br.ui.buttonStyleSheet)
    importButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    importButton:SetText(buttonName)
    importButton:SetWidth(100)
    importButton:SetHeight(20)
    importButton:SetEventListener(
        "OnClick",
        function()
            br.data.loadedSettings = false
            br.settingsManagement:loadSettings("Exported Settings", nil, br.loader.selectedSpec, br.loader.selectedProfileName)
            br._G.ReloadUI()
            -- -- Load settings file matching profile to br.data
            -- local loadDir = br.settingsManagement:checkDirectories("Exported Settings")
            -- local brdata
            -- local brprofile
            -- local fileFound = false
            -- local profileFound = false
            -- -- Load Settings
            -- if br.settingsManagement:findFileInFolder(br.loader.settingsFile,loadDir) then
            -- 	Print("Loading Settings File: " .. br.loader.settingsFile)
            -- 	brdata = br.tableLoad(loadDir .. br.loader.settingsFile)
            -- 	fileFound = true
            -- end
            -- -- Load Profile
            -- if br.settingsManagement:findFileInFolder("savedProfile.lua",loadDir) then
            --     brprofile = br.tableLoad(loadDir .. br.loader.settingsFile)
            --     profileFound = true
            -- end
            -- if fileFound then
            --     br.ui:closeWindow("all")
            --     br.ui.toggles.mainButton:Hide()
            --     br.data = deepcopy(brdata)
            --     if profileFound then br.settingsManagement.profile = deepcopy(brprofile) end
            --     br.ui:recreateWindows()
            --     Print("Loaded Settings for Profile "..br.loader.selectedProfileName..", from Exported Settings Folder")
            --     ReloadUI()
            -- else
            --     Print("Error Loading Settings File")
            --     if not fileFound then Print("No File Called "..br.loader.settingsFile.." Found In "..loadDir) end
            -- end
        end
    )

    parent:AddChild(importButton)

    return importButton
end