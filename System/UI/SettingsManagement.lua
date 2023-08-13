local _, br = ...

local sep = IsMacClient() and "/" or "\\"

local function getFolderClassName(class)
	if class == nil then class = "" end
	local formatClass = class:sub(1, 1):upper() .. class:sub(2):lower()
	if formatClass == "Deathknight" then
		formatClass = "Death Knight"
	end
	if formatClass == "Demonhunter" then
		formatClass = "Demon Hunter"
	end
	return formatClass
end

local function checkDirectory(dir)
	if not br._G.DirectoryExists(dir) then
		br._G.CreateDirectory(dir)
		if not br._G.DirectoryExists(dir) then
		-- Return Path
			br._G.print("Creating Directory "..dir.." failed!")
			return nil
		end
	end
end

-- Check Directories
function br:checkDirectories(folder, class, spec, profile, instance)
	-- Set Settings Directory
	local wowDir = br._G.GetWoWDirectory() or ""
	local mainDir = ""
	if wowDir:match('_retail_') then
		mainDir = wowDir .. sep .. "Interface" .. sep .. "AddOns" .. sep .. br.addonName .. sep .. "Settings" .. sep
	else
		mainDir = wowDir .. sep .. br.addonName .. sep .. "Settings" .. sep
	end

	-- Set Folder to Specified Folder if any
	if folder == nil then
		folder = ""
	else
		folder = folder .. sep
	end
	local settingsDir = mainDir .. folder
	checkDirectory(settingsDir)

	-- Set the Class Directory
	if class == nil then
		class = select(2, br._G.UnitClass("player"))
	end
	local classDir = settingsDir .. getFolderClassName(class) .. sep
	checkDirectory(classDir)

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
	local specDir = classDir .. spec .. sep
	checkDirectory(specDir)

	-- Set the Profile Directory
	if profile == nil then
		profile = br.selectedProfileName
	end
	local profileDir = specDir .. profile .. sep
	checkDirectory(profileDir)
	if not instance then
		-- Return Path
		return profileDir
	elseif instance then
		local instanceDir = profileDir .. instance .. sep
		checkDirectory(instanceDir)
		return instanceDir
	end
	br._G.print("Unknown Error Creating Directories")
	return nil
end

function br.deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[br.deepcopy(orig_key)] = br.deepcopy(orig_value)
		end
		setmetatable(copy, br.deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

-- Load Settings
function br:loadSettings(folder, class, spec, profile, instance)
	if br.unlocked and (not br.data.loadedSettings or br.rotationChanged) then
		local loadDir = br:checkDirectories(folder, class, spec, profile, instance)
		if not loadDir then
			br._G.print("No settings directory found for "..profile.."!")
			return
		end
		local brdata
		local brprofile
		local fileFound = false
		local profileFound = false
		-- Load Settings
		if br:findFileInFolder("savedSettings.lua", loadDir) then
			--br._G.print("Loading Settings File From Directory: " .. loadDir)
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
			if br.selectedProfileName ~= "None" then
				br._G.print("No File Called 'savedSettings.lua' Found In " .. loadDir)
			else
				br._G.print("No pre-existing settings to load.")
			end
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
function br:saveSettings(folder, class, spec, profile, instance, wipe)
	local saveDir = br:checkDirectories(folder, class, spec, profile, instance)
	if not saveDir then
		br._G.print("No settings directory found for "..profile.."!")
		return
	end
	local brdata = wipe and {} or br.deepcopy(br.data)
	local brprofile = wipe and {} or br.deepcopy(br.profile)
	br._G.print("Saving Profiles and Settings to Directory: " .. tostring(saveDir))
	-- Save Files
	br.tableSave(brdata, saveDir .. "savedSettings.lua")
	br.tableSave(brprofile, saveDir .. "savedProfile.lua")
	br._G.print("Saved Settings for Profile " .. profile)
end

br.fileList = {}
function br:findFileInFolder(file, folder)
	if folder == nil or folder == "" then return false end
	table.wipe(br.fileList)
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
		local trackerName = br.data.tracker[br.selectedSpec]["RotationDropValue"]
		local specSettings = br.data.settings[br.selectedSpec]
		if not br.rotations[specID] then print("No rotations found for specID ".. specID) return end
		if trackerName then
			for i = 1, #br.rotations[specID] do
				if br.rotations[specID][i].name == trackerName then
					br.selectedProfileName = trackerName
					specSettings["RotationDropValue"] = trackerName
					specSettings["RotationDrop"] = i
					rotationFound = true
					br._G.print("Found Last Used From Tracker: "..trackerName)
					break
				end
			end
		end
		if not rotationFound then
			br._G.print("No Matching Rotation Found In Tracker, Defaulting to "..br.rotations[specID][1].name)
			specSettings["RotationDropValue"] = br.rotations[specID][1].name
			specSettings["RotationDrop"] = 1
		end
		-- br._G.print("Tracker Load - Last Profile: " .. tostring(br.data.settings[selectedProfile]["RotationDrop"]))
		-- br._G.print("Tracker Load - Last Profile Name: " .. tostring(br.data.settings[selectedProfile]["RotationDropValue"]))
	else
		br._G.print("No Tracker found for " .. selectedProfile .. "! Creating Tracker....")
	end
	br:saveLastProfileTracker()
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
			elseif br.rotations and br.rotations[specID] and br.rotations[specID][1] and br.rotations[specID][1].name ~= nil then
				br.data.settings[br.selectedSpec]["RotationDropValue"] = br.rotations[specID][1].name
				br.data.tracker[br.selectedSpec]["RotationDropValue"] = br.rotations[specID][1].name
				br.data.settings[br.selectedSpec]["RotationDrop"] = 1
				br.data.tracker[br.selectedSpec]["RotationDrop"] = 1
			else
				br.data.settings[br.selectedSpec]["RotationDropValue"] = ""
				br.data.tracker[br.selectedSpec]["RotationDropValue"] = ""
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
