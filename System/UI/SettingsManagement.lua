local _, br = ...
local function getFolderClassName(class)
	local formatClass = class:sub(1, 1):upper() .. class:sub(2):lower()
	if formatClass == "Deathknight" then
		formatClass = "Death Knight"
	end
	if formatClass == "Demonhunter" then
		formatClass = "Demon Hunter"
	end
	return formatClass
end

-- Check Directories
function br:checkDirectories(folder, class, spec, profile)
	-- Set Settings Directory
	local settingsDir = br._G.GetWoWDirectory() .. "\\Interface\\AddOns\\" .. br.addonName .. "\\Settings\\"

	-- Set Folder to Specified Folder if any
	if folder == nil then
		folder = ""
	else
		folder = folder .. "\\"
	end
	br.settingsDir = settingsDir .. folder
	if not br._G.DirectoryExists(br.settingsDir) then
		br._G.CreateDirectory(br.settingsDir)
	end

	-- Set the Class Directory
	if class == nil then
		class = select(2, br._G.UnitClass("player"))
	end
	local classDir = br.settingsDir .. getFolderClassName(class) .. "\\"
	if not br._G.DirectoryExists(classDir) then
		br._G.CreateDirectory(classDir)
	end

	-- Return Spec Directory if Profile is Tracker
	if profile ~= nil and profile == "Tracker" then
		return classDir
	end

	-- Set the Spec Directory
	if spec == nil then
		spec = br.selectedSpec
	end
	if spec == nil then
		spec = "Initial"
	end
	local specDir = classDir .. spec .. "\\"
	if not br._G.DirectoryExists(specDir) then
		br._G.CreateDirectory(specDir)
	end

	-- Set the Profile Directory
	if profile == nil then
		profile = br.selectedProfileName
	end
	-- Print("Profile by selectedProfileName: "..tostring(br.selectedProfileName))
	-- if (profile == "None" or profile == nil) and br.selectedSpec ~= "None" then
	-- 	profile = br.rotations[GetSpecializationInfo(GetSpecialization())][br.selectedProfile].name
	-- end
	-- Print("Profile by SpecID, selectedProfile: "..tostring(profile))
	local profileDir = specDir .. profile .. "\\"
	if not br._G.DirectoryExists(profileDir) then
		br._G.CreateDirectory(profileDir)
	end

	-- Return Path
	return profileDir
end

-- Load Settings
function br:loadSettings(folder, class, spec, profile)
	if br.unlocked and not br.data.loadedSettings then
		local loadDir = br:checkDirectories(folder, class, spec, profile)
		local brdata
		local brprofile
		local fileFound = false
		local profileFound = false
		-- Load Settings
		if br:findFileInFolder("savedSettings.lua", loadDir) then
			br._G.print("Loading Settings File From Directory: " .. loadDir)
			brdata = br.tableLoad(loadDir .. "savedSettings.lua")
			if brdata then
				fileFound = true
			end
		end
		-- Load Profile
		if br:findFileInFolder("savedProfile.lua", loadDir) then
			-- Print("Loading Saved Profiles")
			-- Print("From Directory: "..loadDir)
			brprofile = br.tableLoad(loadDir .. "savedProfile.lua")
			if brprofile then
				profileFound = true
			end
		end
		if fileFound then
			br.ui:closeWindow("all")
			br.data = br.deepcopy(brdata)
			if profileFound then
				br.profile = br.deepcopy(brprofile)
			end
			br._G.print("Loaded Settings for Profile " .. tostring(profile))
		end
		if not fileFound then
			br._G.print("No File Called 'savedSettings.lua' Found In " .. loadDir)
		end
		if spec == nil then
			spec = br.selectedSpec
		end
		if spec == "" then
			spec = "Initial"
		end
		if br.data.settings[spec].config == nil then
			br.data.settings[spec].config = {}
		end
		local initialLoad = br.data.settings[spec].config.initialLoad or false
		if initialLoad then
			br.ui:closeWindow("config")
		else
			br.ui:toggleWindow("config")
			br.data.settings[spec].config.initialLoad = true
		end
		br.data.loadedSettings = true
	end
end

-- Save Settings
function br:saveSettings(folder, class, spec, profile, wipe)
	local saveDir = br:checkDirectories(folder, class, spec, profile)
	local brdata = wipe and {} or br.deepcopy(br.data)
	local brprofile = wipe and {} or br.deepcopy(br.profile)
	br._G.print("Saving Profiles and Settings to Directory: " .. tostring(saveDir))
	-- Save Files
	br.tableSave(brdata, saveDir .. "savedSettings.lua")
	br.tableSave(brprofile, saveDir .. "savedProfile.lua")
	br._G.print("Saved Settings for Profile " .. profile)
end

function br:findFileInFolder(file, folder)
	br.fileList = {}
	br.fileList = br._G.GetDirectoryFiles(folder .. "*.lua")
	for i = 1, #br.fileList do
		if br.fileList[i] == file then
			return true
		end
	end
	return false
end

function br:loadLastProfileTracker()
	local loadDir = br:checkDirectories(nil, nil, nil, "Tracker")
	local selectedProfile = br.selectedSpec
	if br:findFileInFolder("lastProfileTracker.lua", loadDir) then
		local tracker = br.tableLoad(loadDir .. "lastProfileTracker.lua")
		local specID = br._G.GetSpecializationInfo(br._G.GetSpecialization())
		if br.data == nil then
			br.data = {}
		end
		if br.data.settings == nil then
			br.data.settings = {}
		end
		if br.data.settings[selectedProfile] == nil then
			br.data.settings[selectedProfile] = {}
		end
		if tracker ~= nil then
			br.data.tracker = tracker
		end
		if br.data.tracker[selectedProfile] == nil then
			br.data.tracker[selectedProfile] = {}
		end
		local rotationFound = false
		if br.data.tracker[br.selectedSpec]["RotationDropValue"] then
			for i = 1, #br.rotations[specID] do
				if br.rotations[specID][i].name == br.data.tracker[br.selectedSpec]["RotationDropValue"] then
					br.data.settings[br.selectedSpec]["RotationDropValue"] = br.data.tracker[br.selectedSpec]["RotationDropValue"]
					br.data.settings[br.selectedSpec]["RotationDrop"] = i
					rotationFound = true
					break
				end
			end
		end
		if not rotationFound then
			br.data.settings[br.selectedSpec]["RotationDropValue"] = br.rotations[specID][1].name
			br.data.settings[br.selectedSpec]["RotationDrop"] = 1
		end
		br._G.print("Tracker Load - Last Profile: " .. tostring(br.data.settings[selectedProfile]["RotationDrop"]))
		br._G.print("Tracker Load - Last Profile Name: " .. tostring(br.data.settings[selectedProfile]["RotationDropValue"]))
	else
		br._G.print("No Tracker found for " .. selectedProfile .. "! Creating Tracker....")
		br:saveLastProfileTracker()
	end
end

function br:saveLastProfileTracker()
	local saveDir = br:checkDirectories(nil, nil, nil, "Tracker")
	local specID = br._G.GetSpecializationInfo(br._G.GetSpecialization()) or br.selectedSpecID
	if br.data ~= nil and br.data.settings ~= nil and br.data.settings[br.selectedSpec] ~= nil then
		if br.data.tracker ~= nil then
			if br.data.tracker[br.selectedSpec] == nil then
				br.data.tracker[br.selectedSpec] = {}
			end
			if br.data.settings[br.selectedSpec]["RotationDropValue"] then
				local rotationFound = false
				for i = 1, #br.rotations[specID] do
					if br.rotations[specID][i].name == br.data.settings[br.selectedSpec]["RotationDropValue"] then
						br.data.tracker[br.selectedSpec]["RotationDropValue"] = br.data.settings[br.selectedSpec]["RotationDropValue"]
						br.data.tracker[br.selectedSpec]["RotationDrop"] = i
						rotationFound = true
						break
					end
				end
				if not rotationFound then
					br.data.tracker[br.selectedSpec]["RotationDropValue"] = br.rotations[specID][1].name
					br.data.tracker[br.selectedSpec]["RotationDrop"] = 1
				end
			else
				br.data.settings[br.selectedSpec]["RotationDropValue"] = br.rotations[specID][1].name
				br.data.tracker[br.selectedSpec]["RotationDropValue"] = br.rotations[specID][1].name
				br.data.settings[br.selectedSpec]["RotationDrop"] = 1
				br.data.tracker[br.selectedSpec]["RotationDrop"] = 1
			end
		end
	else
		br._G.print("Nothing found, recreating tracker")
		br.data.tracker = {}
		br.data.tracker[br.selectedSpec] = {}
		br.data.tracker[br.selectedSpec]["RotationDrop"] = 1
		br.data.tracker[br.selectedSpec]["RotationDropValue"] = br.rotations[specID][1].name
	end
	br._G.print("Saving Tracker to Directory: " .. tostring(saveDir))
	br.tableSave(br.data.tracker, saveDir .. "lastProfileTracker.lua")
end
