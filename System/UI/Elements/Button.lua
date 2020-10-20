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
    saveButton:SetWidth(20)
    saveButton:SetHeight(20)
    saveButton:SetEventListener('OnClick', function()

        local newWindow = DiesalGUI:Create('Window')
        parent:AddChild(newWindow)
        newWindow:SetTitle("Create Profile")
        newWindow.settings.width = 200
        newWindow.settings.height = 75
        newWindow.settings.minWidth = newWindow.settings.width
        newWindow.settings.minHeight = newWindow.settings.height
        newWindow.settings.maxWidth = newWindow.settings.width
        newWindow.settings.maxHeight = newWindow.settings.height
        newWindow:ApplySettings()
  
        local profileInput = DiesalGUI:Create('Input')
        newWindow:AddChild(profileInput)
        profileInput:SetParent(newWindow.content)
        profileInput:SetPoint("TOPLEFT", newWindow.content, "TOPLEFT", 5, -5)
        profileInput:SetPoint("BOTTOMRIGHT", newWindow.content, "TOPRIGHT", -5, -25)
        profileInput:SetText("New Profile Name")
  
        local profileButton = DiesalGUI:Create('Button')
        newWindow:AddChild(profileButton)
        profileButton:SetParent(newWindow.content)
        profileButton:SetPoint("TOPLEFT", newWindow.content, "TOPLEFT", 5, -30)
        profileButton:SetPoint("BOTTOMRIGHT", newWindow.content, "TOPRIGHT", -5, -50)
        if profileButton.SetStylesheet then profileButton:SetStylesheet(br.ui.buttonStyleSheet) end
        profileButton:SetText("Create New Profile")
        profileButton:SetEventListener('OnClick', function()

            
          local profiles = br.fetch(br.selectedSpec .. '_' .. 'profiles', {{key='default',text='Default'}})
          local profileName = profileInput:GetText()
          local pkey = string.gsub(profileName, "%s+", "")
          if profileName ~= '' then
            for _,p in ipairs(profiles) do
              if p.key == pkey then
                profileButton:SetText('|cffff3300Profile with that name exists!|r')
                C_Timer.NewTicker(2, function()
                  profileButton:SetText("Create New Profile")
                end, 1)
                return false
              end
            end
            table.insert(profiles, { key = pkey, text = deepcopy(br.data.settings[br.selectedSpec])})
            br.store(br.selectedSpec .. '_' .. 'profiles', profiles)
            br.store(br.selectedSpec .. '_' .. 'profile', pkey)
            newWindow:Hide()
            parent:Hide()
            parent:Release()
            br.rotationChanged = true
          end
  
        end)
        profileInput:SetEventListener("OnEnterPressed", function()
  
          local profiles = br.fetch(br.selectedSpec .. '_' .. 'profiles', {{key='default',text='Default'}})
          local profileName = profileInput:GetText()
          local pkey = string.gsub(profileName, "%s+", "")
          if profileName ~= '' then
            for _,p in ipairs(profiles) do
              if p.key == pkey then
                profileButton:SetText('|cffff3300Profile with that name exists!|r')
                C_Timer.NewTicker(2, function()
                  profileButton:SetText("Create New Profile")
                end, 1)
                return false
              end
            end
            table.insert(profiles, { key = pkey, text = deepcopy(br.data.settings[br.selectedSpec]) })
            br.store(br.selectedSpec .. '_' .. 'profiles', profiles)
            br.store(br.selectedSpec .. '_' .. 'profile', pkey)
            newWindow:Hide()
            parent:Hide()
            parent:Release()
            br.rotationChanged = true
          end
  
        end)
  
    end)

    parent:AddChild(saveButton)

    return saveButton
end

function br.ui:createDeleteButton(parent, buttonName, x, y)
    local deleteButton = DiesalGUI:Create('Button')
    local parent = parent

  --  parent:AddChild(saveButton)
    deleteButton:SetParent(parent.content)
    deleteButton:SetStylesheet(br.ui.buttonStyleSheet)
    deleteButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    deleteButton:SetText(buttonName)
    deleteButton:SetWidth(20)
    deleteButton:SetHeight(20)
    deleteButton:SetEventListener('OnClick', function()
        local selectedProfile = br.profileDropValue
        local profiles = br.fetch(br.selectedSpec .. '_' .. 'profiles', {{key='default',text='Default'}})
        if selectedProfile ~= 'default' then
            for i,p in ipairs(profiles) do
                if p.key == selectedProfile then
                    profiles[i] = nil
                    Print("Deleting "..selectedProfile.." profile!")
                    br.store(br.selectedSpec .. '_' .. 'profiles', profiles)
                    br.store(br.selectedSpec .. '_' .. 'profile', 'default')
                    parent:Hide()
                    parent:Release()
                    br.rotationChanged = true
                end
            end
        else
        Print("Cannot delete default profile!")
      end
    end)

    parent:AddChild(deleteButton)

    return deleteButton
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
        if br.profileDropValue == 'default' then
            Print("Please select a profile other than default!")
            return
        end
        if br.profile ~= nil then
            if br.profile[br.selectedSpec .. '_' .. 'profiles'] ~= nil then
                local lProfile = br.profile[br.selectedSpec .. '_' .. 'profiles']
                for k,v in pairs(lProfile) do
                    if v.key == br.profileDropValue then
                        br.data.settings[br.selectedSpec] = deepcopy(v.text)
                        Print(v.key.." profile found!")
                        br.rotationChanged = true
                        break
                    end
                end
            end
        -- if getOptionValue("Load Prior Saved Settings") == 1 then
        --     if br.dungeon ~= nil then
        --         if br.dungeon.settings ~= nil then
        --             if br.dungeon.settings[br.selectedSpec] ~= nil then
        --                 br.data.settings[br.selectedSpec] = {}
        --                 br.data.settings[br.selectedSpec] = deepcopy(br.dungeon.settings[br.selectedSpec])
        --                 print("Dungeon Data Loaded")
        --                 br.rotationChanged = true  
        --             else
        --                 print("Dungeon Settings do not exist.")
        --             end
        --         else
        --             print("Dungeon Settings do not exist.")
        --         end
        --     else
        --         print("Dungeon Settings do not exist.")
        --     end
        -- elseif getOptionValue("Load Prior Saved Settings") == 2 then
        --     if br.mdungeon ~= nil then
        --         if br.mdungeon.settings ~= nil then
        --             if br.mdungeon.settings[br.selectedSpec] ~= nil then
        --                 br.data.settings[br.selectedSpec] = {}
        --                 br.data.settings[br.selectedSpec] = deepcopy(br.mdungeon.settings[br.selectedSpec])
        --                 print("Mythic Dungeon Data Loaded")
        --                 br.rotationChanged = true
        --             else
        --                 print("Mythic Dungeon settings do not exist.")
        --             end
        --         else
        --             print("Mythic Dungeon settings do not exist.")
        --         end
        --     else
        --         print("Mythic Dungeon settings do not exist.")
        --     end
        -- elseif getOptionValue("Load Prior Saved Settings") == 3 then
        --     if br.raid ~= nil then
        --         if br.raid.settings ~= nil then
        --             if br.raid.settings[br.selectedSpec] ~= nil then
        --                 br.data.settings[br.selectedSpec] = {}
        --                 br.data.settings[br.selectedSpec] = deepcopy(br.raid.settings[br.selectedSpec])
        --                 print("Raid Data Loaded")
        --                 br.rotationChanged = true
        --             else
        --                 print("Raid settings do not exist.")
        --             end
        --         else
        --             print("Raid settings do not exist.")
        --         end
        --     else
        --         print("Raid settings do not exist.")
        --     end
        -- elseif getOptionValue("Load Prior Saved Settings") == 4 then
        --     if br.mraid ~= nil then
        --         if br.mraid.settings ~= nil then
        --             if br.mraid.settings[br.selectedSpec] ~= nil then
        --                 br.data.settings[br.selectedSpec] = {}
        --                 br.data.settings[br.selectedSpec] = deepcopy(br.mraid.settings[br.selectedSpec])
        --                 print("Mythic Raid Data Loaded")
        --                 br.rotationChanged = true
        --             else
        --                 print("Mythic Raid settings do not exist.")
        --             end
        --         else
        --             print("Mythic Raid settings do not exist.")
        --         end
        --     else
        --         print("Mythic Raid settings do not exist.")
        --     end
        else
            print("Load Error")
        end
     --   parent:Release()
    end)

    parent:AddChild(loadButton)

    return loadButton
end

function br.ui:createExportButton(parent, buttonName, x, y)
    local exportButton = DiesalGUI:Create('Button')
    local parent = parent

    exportButton:SetParent(parent.content)
    exportButton:SetStylesheet(br.ui.buttonStyleSheet)
    exportButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    exportButton:SetText(buttonName)
    exportButton:SetWidth(100)
    exportButton:SetHeight(20)
    exportButton:SetEventListener("OnClick", function()
        -- Save br.data for current profile to Settings folder
        br.data.settings[br.selectedSpec]["toggleBar"] = {}
        br.data.settings[br.selectedSpec]["toggleBar"] = br.data.settings.mainButton
        br.data.settings[br.selectedSpec].toggleBar.size = br.data.settings.buttonSize
        local savedSettings = deepcopy(br.data.settings[br.selectedSpec][br.selectedProfile])
        if savedSettings ~= nil then
            br.tableSave(br.data.settings[br.selectedSpec],br.settingsFile)
            Print("Saved Settings for Profile "..br.selectedProfile..": "..br.selectedSpec..br.selectedProfileName..", to Settings Folder")
        else
            Print("Error Saving Settings File")
        end
    end)

    parent:AddChild(exportButton)

    return exportButton
end

function br.ui:createImportButton(parent, buttonName, x, y)
    local importButton = DiesalGUI:Create('Button')
    local parent = parent

    importButton:SetParent(parent.content)
    importButton:SetStylesheet(br.ui.buttonStyleSheet)
    importButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    importButton:SetText(buttonName)
    importButton:SetWidth(100)
    importButton:SetHeight(20)
    importButton:SetEventListener("OnClick", function()
        -- Load settings file matching profile to br.data
        if not DirectoryExists(br.settingsDir) then CreateDirectory(br.settingsDir) end
        local loadSettings = br.tableLoad(br.settingsFile)
        local fileFound = false
        local settingsFile = br.selectedSpec..br.selectedProfileName..".lua"
        br.fileList = GetDirectoryFiles(br.settingsDir..'*.lua')
        for i = 1, #br.fileList do
            if br.fileList[i] == settingsFile then
                fileFound = true
                break
            end
        end
        if fileFound and assert(loadSettings ~= nil) then
            br.ui:closeWindow("all")
            mainButton:Hide()
            br.data.settings[br.selectedSpec] = loadSettings
            br.data.settings.mainButton = br.data.settings[br.selectedSpec].toggleBar
            br.data.settings.buttonSize = br.data.settings[br.selectedSpec].toggleBar.size
            br.ui:recreateWindows()
            Print("Loaded Settings for Profile "..br.selectedProfile..": "..br.selectedProfileName..br.selectedSpec..", from Settings Folder")
            ReloadUI()
        else
            Print("Error Loading Settings File")
            if not fileFound then Print("No File Called "..settingsFile.." Found In "..br.settingsDir) end
        end
    end)

    parent:AddChild(importButton)

    return importButton
end

--------------------------------------------------------------------------
-- Table Save/Load code from: http://lua-users.org/wiki/SaveTableToFile --
--------------------------------------------------------------------------
local function exportstring( s )
    return string.format("%q", s)
end

--// The Save Function
br.tableSave = function(tbl,filename)
    local charS,charE = "   ","\n"
    -- local file,err = io.open( filename, "wb" )
    -- if err then return err end
    WriteFile(filename,"")
    -- initiate variables for save procedure
    local tables,lookup = { tbl },{ [tbl] = 1 }
    -- file:write( "return {"..charE )
    WriteFile(filename,"return {"..charE,true)

    for idx,t in ipairs( tables ) do
        -- file:write( "-- Table: {"..idx.."}"..charE )
        WriteFile(filename,"-- Table: {"..idx.."}"..charE,true)
        -- file:write( "{"..charE )
        WriteFile(filename,"{"..charE,true)
        local thandled = {}

        for i,v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )
            -- only handle value
            if stype == "table" then
                if not lookup[v] then
                    table.insert( tables, v )
                    lookup[v] = #tables
                end
                -- file:write( charS.."{"..lookup[v].."},"..charE )
                WriteFile(filename,charS.."{"..lookup[v].."},"..charE,true)
            elseif stype == "string" then
                -- file:write(  charS..exportstring( v )..","..charE )
                WriteFile(filename,charS..exportstring( v )..","..charE,true)
            elseif stype == "number" then
                -- file:write(  charS..tostring( v )..","..charE )
                WriteFile(filename,charS..tostring( v )..","..charE,true)
            elseif stype == "boolean" then
                WriteFile(filename,charS..tostring( v )..","..charE,true)
            end
        end

        for i,v in pairs( t ) do
            -- escape handled values
            if (not thandled[i]) then

                local str = ""
                local stype = type( i )
                -- handle index
                if stype == "table" then
                    if not lookup[i] then
                        table.insert( tables,i )
                        lookup[i] = #tables
                    end
                    str = charS.."[{"..lookup[i].."}]="
                elseif stype == "string" then
                    str = charS.."["..exportstring( i ).."]="
                elseif stype == "number" then
                    str = charS.."["..tostring( i ).."]="
                elseif stype == "boolean" then
                    str = charS.."["..i.."]="
                end

                if str ~= "" then
                    stype = type( v )
                    -- handle value
                    if stype == "table" then
                        if not lookup[v] then
                            table.insert( tables,v )
                            lookup[v] = #tables
                        end
                        -- file:write( str.."{"..lookup[v].."},"..charE )
                        WriteFile(filename,str.."{"..lookup[v].."},"..charE,true)
                    elseif stype == "string" then
                        -- file:write( str..exportstring( v )..","..charE )
                        WriteFile(filename,str..exportstring( v )..","..charE,true)
                    elseif stype == "number" then
                        -- file:write( str..tostring( v )..","..charE )
                        WriteFile(filename,str..tostring( v )..","..charE,true)
                    elseif stype == "boolean" then
                        WriteFile(filename,str..tostring( v )..","..charE,true)
                    end
                end
            end
        end
        -- file:write( "},"..charE )
        WriteFile(filename,"},"..charE,true)
    end
    -- file:write( "}" )
    WriteFile(filename,"}",true)
    -- file:close()
end

--// The Load Function
br.tableLoad = function( sfile )
    local file = ReadFile(sfile)
    if file == nil then return end
    local ftables = loadstring(file,sfile)
    -- local ftables,err = loadfile( sfile )
    -- if err then return _,err end
    local tables = ftables()
    -- return deepcopy(tables)
    for idx = 1,#tables do
        local tolinki = {}
        for i,v in pairs( tables[idx] ) do
            if type( v ) == "table" then
                tables[idx][i] = tables[v[1]]
            end
            if type( i ) == "table" and tables[i[1]] then
                table.insert( tolinki,{ i,tables[i[1]] } )
            end
        end
        -- link indices
        for _,v in ipairs( tolinki ) do
            tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
        end
    end
    br.loadFile = true
    return tables[1]
end