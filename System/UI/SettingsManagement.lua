local function getFolderClassName(class)
    local formatClass = class:sub(1,1):upper()..class:sub(2):lower()
    if formatClass == "Deathknight" then formatClass = "Death Knight" end
    if formatClass == "Demonhunter" then formatClass = "Demon Hunter" end
    return formatClass
end

-- Check Directories
function br:checkDirectories(folder,class,spec,profile)
	-- Set Settings Directory
	local settingsDir = GetWoWDirectory() .. '\\Interface\\AddOns\\'..br.addonName..'\\Settings\\'

	-- Set Folder to Specified Folder if any
	if folder == nil then folder = "" else folder = folder .. "\\" end
	br.settingsDir = settingsDir .. folder
	if not DirectoryExists(br.settingsDir) then CreateDirectory(br.settingsDir) end

	-- Set the Class Directory
	if class == nil then class = select(2,UnitClass("player")) end
	local classDir = br.settingsDir .. getFolderClassName(class) .. "\\"
	if not DirectoryExists(classDir) then CreateDirectory(classDir) end

	-- Return Spec Directory if Profile is Tracker
	if profile ~= nil and profile == "Tracker" then return classDir end

	-- Set the Spec Directory
	if spec == nil then spec = select(2,GetSpecializationInfo(GetSpecialization())) end
	if spec == nil then spec = br.currentSpec end
	if spec == '' then spec = "Initial" end
	local specDir = classDir .. spec .. "\\"
	if not DirectoryExists(specDir) then CreateDirectory(specDir) end

	-- Set the Profile Directory
	if profile == nil then profile = br.selectedProfileName end
	local profileDir = specDir .. profile .. "\\"
	if not DirectoryExists(profileDir) then CreateDirectory(profileDir) end

	-- Return Path
	return profileDir
end

-- Load Settings
function br:loadSettings(folder,class,spec,profile)
	if br.unlocked and not br.data.loadedSettings then
		local loadDir = br:checkDirectories(folder,class,spec,profile)
		local brdata
		local brprofile
        local fileFound = false
        local profileFound = false
		-- Load Settings
		if br:findFileInFolder("savedSettings.lua",loadDir) then
			Print("Loading Settings File From Directory: "..loadDir)
			brdata = br.tableLoad(loadDir .. "savedSettings.lua")
			-- br.data = deepcopy(brdata)
			-- brdata = nil
			fileFound = true
		end
		-- Load Profile
		if br:findFileInFolder("savedProfile.lua",loadDir) then
			-- Print("Loading Saved Profiles")
			-- Print("From Directory: "..loadDir)
			brprofile = br.tableLoad(loadDir .. "savedProfile.lua")
			-- br.profile = deepcopy(brprofile)
            -- brprofile = nil
            profileFound = true
        end
        if fileFound then
            br.ui:closeWindow("all")
            -- mainButton:Hide()
            br.data = deepcopy(brdata)
            if profileFound then br.profile = deepcopy(brprofile) end
            Print("Loaded Settings for Profile "..profile)
            -- br.ui:loadWindowPositions("config")
            -- br.ui:loadWindowPositions("profile")
            -- br.ui.window.config = {}
		    -- br.ui:createConfigWindow()  
            -- br.ui:toggleWindow("config")
            -- ReloadUI()
        end
        if not fileFound then 
            Print("No File Called 'savedSettings.lua' Found In "..loadDir)
        end
        TogglesFrame()
		br.ui.window.config = {}
		br.ui:createConfigWindow()
		br.ui:toggleWindow("config")
        -- br.ui:loadWindowPositions("config")
        -- br.ui:loadWindowPositions("profile")
        br.currentSpec = select(2,GetSpecializationInfo(GetSpecialization()))
        br.data.loadedSettings = true
	end
end

-- Save Settings
function br:saveSettings(folder,class,spec,profile,wipe)
	local saveDir = br:checkDirectories(folder,class,spec,profile)
	local brdata = wipe and {} or deepcopy(br.data)
	local brprofile = wipe and {} or deepcopy(br.profile)
	-- br:saveLastProfileTracker()
	Print("Saving Profiles and Settings to Directory: "..tostring(saveDir))
	-- -- Reset Files
	-- br.tableSave({},saveDir .. "savedSettings.lua")
	-- br.tableSave({},saveDir .. "savedProfile.lua")
	-- Save Files
	br.tableSave(brdata,saveDir .. "savedSettings.lua")
    br.tableSave(brprofile,saveDir .. "savedProfile.lua")
    Print("Saved Settings for Profile "..profile)
end

function br:findFileInFolder(file,folder)
	br.fileList = {}
	br.fileList = GetDirectoryFiles(folder .. '*.lua')
	for i = 1, #br.fileList do
		if br.fileList[i] == file then
			return true
		end
	end
	return false
end

function br:loadLastProfileTracker()
	local loadDir = br:checkDirectories(nil,nil,nil,"Tracker")
	-- Print("Loading Tracker from Directory: "..tostring(loadDir))
	if br:findFileInFolder("lastProfileTracker.lua",loadDir) then
        local tracker = br.tableLoad(loadDir .. "lastProfileTracker.lua")
        if br.data == nil then br.data = {} end
        if br.data.settings == nil then br.data.settings = {} end
        local selectedProfile = select(2,GetSpecializationInfo(GetSpecialization()))
        if br.data.settings[selectedProfile] == nil then br.data.settings[selectedProfile] = {} end
        if br.data.tracker[selectedProfile] == nil then br.data.tracker[selectedProfile] = {} end
        if tracker[selectedProfile] == nil then --[[Print("Tracker Load - No Data Found for: "..tostring(selectedProfile))]] return end
        if tracker[selectedProfile]['RotationDrop'] ~= nil then
            br.data.settings[selectedProfile]['RotationDrop'] = tracker[selectedProfile]['RotationDrop']
            br.data.tracker[selectedProfile]['RotationDrop'] = tracker[selectedProfile]['RotationDrop']
            -- Print("Tracker Load - Last Profile: "..tostring(br.data.settings[selectedProfile]['RotationDrop']))
        end
        if tracker[selectedProfile]['RotationDropValue'] ~= nil then
            br.data.settings[selectedProfile]['RotationDropValue'] = tracker[selectedProfile]['RotationDropValue']            
            br.data.tracker[selectedProfile]['RotationDropValue'] = tracker[selectedProfile]['RotationDropValue']
            -- Print("Tracker Load - Last Profile Name: "..tostring(br.data.settings[selectedProfile]['RotationDropValue']))
        end
    end
end

function br:saveLastProfileTracker()
	local saveDir = br:checkDirectories(nil,nil,nil,"Tracker")
    if br.data ~= nil and br.data.settings ~= nil and br.data.settings[br.selectedSpec] ~= nil then
        if br.data.tracker ~= nil then
            if br.data.tracker[br.selectedSpec] == nil then br.data.tracker[br.selectedSpec] = {} end
            br.data.tracker[br.selectedSpec]['RotationDrop'] = br.data.settings[br.selectedSpec]['RotationDrop']            
            br.data.tracker[br.selectedSpec]['RotationDropValue'] = br.data.settings[br.selectedSpec]['RotationDropValue']
        end
    end
    -- Print("Saving Tracker to Directory: "..tostring(saveDir))
	br.tableSave(br.data.tracker,saveDir .. "lastProfileTracker.lua")
end





-- br.loader = {}
-- local class = select(2,UnitClass('player'))
-- local level = UnitLevel('player')
-- local function getFolderClassName(class)
--     local formatClass = class:sub(1,1):upper()..class:sub(2):lower()
--     if formatClass == "Deathknight" then formatClass = "Death Knight" end
--     if formatClass == "Demonhunter" then formatClass = "Demon Hunter" end
--     return formatClass
-- end
-- local function getFolderSpecName(class,specID)
--     for k, v in pairs(br.lists.spec[class]) do
--         if v == specID then return tostring(k) end
--     end
-- end
-- local function rotationsDirectory()
--     return GetWoWDirectory() .. '\\Interface\\AddOns\\' .. br.addonName .. '\\Rotations\\'
-- end
-- local function settingsDirectory()
--     return GetWoWDirectory() .. '\\Interface\\AddOns\\' .. br.addonName .. '\\Settings\\'
-- end
-- local function loadFile(profile,file,support)
--     local loadProfile = loadstring(profile,file)
--     if loadProfile == nil then
--         Print("|cffff0000Failed to Load - |r"..tostring(file).."|cffff0000, contact dev.");
--     else
--         if support then Print("Loaded Support Rotation: "..file) end
--         loadProfile()
--     end
-- end

-- -- Load Rotation Files
-- function br.loader.loadProfiles()
--     -- Search each Profile in the Spec Folder
--     wipe(br.rotations)
--     local specID = GetSpecializationInfo(GetSpecialization())
--     local folderSpec = getFolderSpecName(class,specID)
--     local path = rotationsDirectory() .. getFolderClassName(class) .. '\\' .. folderSpec .. '\\'
--     local profiles = GetDirectoryFiles(path .. '*.lua')
--     local profileName = ""
--     for _, file in pairs(profiles) do
--         local profile = ReadFile(path..file)
--         local start = string.find(profile,"local id = ",1,true) or 0
--         local profileID = 0
--         if folderSpec == "Initial" then 
--             profileID = tonumber(string.sub(profile,start+10,start+14))
--         else
--             profileID = tonumber(string.sub(profile,start+10,start+13))
--         end
--         if profileID == specID then 
--             loadFile(profile,file,false) 
--             -- Get Rotation Name from File
--             start = string.find(profile,"local rotationName = ",1,true) or 0
--             local endString = string.find(profile,"\n",1,true) or 0
--             profileName = tostring(string.sub(profile,start+20,endString))
--             endString = string.find(profile,"\" -",1,true) or 0
--             if endString > 0 then profileName = tostring(string.sub(profile,start+20,endString)) end
--         end
--     end
--     path = settingsDirectory() .. getFolderClassName(class) .. '\\' .. folderSpec .. '\\' .. profileName .. '\\' 
--     local settings = GetDirectoryFiles(path .. '*.lua')
--     for _, file in pairs(settings) do
--         Print("File: "..tostring(file).." | Profile: "..profileName)
--     end
-- end