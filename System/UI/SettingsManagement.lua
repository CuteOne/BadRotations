local _, br = ...
br.settingsManagement = br.settingsManagement or {}
local settingsManagement = br.settingsManagement
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
			br._G.print("Creating Directory " .. dir .. " failed!")
			return nil
		end
	end
end

--------------------------------------------------------------------------
-- Table Save/Load code from: http://lua-users.org/wiki/SaveTableToFile --
--------------------------------------------------------------------------
local function exportstring(s)
    return string.format("%q", s)
end

-- The Save Function
local tableSave = function(tbl, filename)
    local charS, charE = "   ", "\n"
    -- local file,err = io.open( filename, "wb" )
    -- if err then return err end
    -- br._G.WriteFile(filename, "", false)
    local content = ""
    -- initiate variables for save procedure
    local tables, lookup = { tbl }, { [tbl] = 1 }
    -- file:write( "return {"..charE )
    -- br._G.WriteFile(filename, "return {" .. charE, true)
    content = content .. "return {" .. charE

    for idx, t in ipairs(tables) do
        -- file:write( "-- Table: {"..idx.."}"..charE )
        -- br._G.WriteFile(filename, "-- Table: {" .. idx .. "}" .. charE, true)
        content = content .. "-- Table: {" .. idx .. "}" .. charE
        -- file:write( "{"..charE )
        -- br._G.WriteFile(filename, "{" .. charE, true)
        content = content .. "{" .. charE
        local thandled = {}

        for i, v in ipairs(t) do
            thandled[i] = true
            local stype = type(v)
            -- only handle value
            if stype == "table" then
                if not lookup[v] then
                    table.insert(tables, v)
                    lookup[v] = #tables
                end
                -- file:write( charS.."{"..lookup[v].."},"..charE )
                -- br._G.WriteFile(filename, charS .. "{" .. lookup[v] .. "}," .. charE, true)
                content = content .. charS .. "{" .. lookup[v] .. "}," .. charE
            elseif stype == "string" then
                -- file:write(  charS..exportstring( v )..","..charE )
                -- br._G.WriteFile(filename, charS .. exportstring(v) .. "," .. charE, true)
                content = content .. charS .. exportstring(v) .. "," .. charE
            elseif stype == "number" or stype == "boolean" then
                -- file:write(  charS..tostring( v )..","..charE )
                -- br._G.WriteFile(filename, charS .. tostring(v) .. "," .. charE, true)
                content = content .. charS .. tostring(v) .. "," .. charE
            end
        end

        for i, v in pairs(t) do
            -- escape handled values
            if (not thandled[i]) then
                local str = ""
                local stype = type(i)
                -- handle index
                if stype == "table" then
                    if not lookup[i] then
                        table.insert(tables, i)
                        lookup[i] = #tables
                    end
                    str = charS .. "[{" .. lookup[i] .. "}]="
                elseif stype == "string" then
                    str = charS .. "[" .. exportstring(i) .. "]="
                elseif stype == "number" then
                    str = charS .. "[" .. tostring(i) .. "]="
                elseif stype == "boolean" then
                    str = charS .. "[" .. i .. "]="
                end

                if str ~= "" then
                    stype = type(v)
                    -- handle value
                    if stype == "table" then
                        if not lookup[v] then
                            table.insert(tables, v)
                            lookup[v] = #tables
                        end
                        -- file:write( str.."{"..lookup[v].."},"..charE )
                        -- br._G.WriteFile(filename, str .. "{" .. lookup[v] .. "}," .. charE, true)
                        content = content .. str .. "{" .. lookup[v] .. "}," .. charE
                    elseif stype == "string" then
                        -- file:write( str..exportstring( v )..","..charE )
                        -- br._G.WriteFile(filename, str .. exportstring(v) .. "," .. charE, true)
                        content = content .. str .. exportstring(v) .. "," .. charE
                    elseif stype == "number" or stype == "boolean" then
                        -- file:write( str..tostring( v )..","..charE )
                        -- br._G.WriteFile(filename, str .. tostring(v) .. "," .. charE, true)
                        content = content .. str .. tostring(v) .. "," .. charE
                    end
                end
            end
        end
        -- file:write( "},"..charE )
        -- br._G.WriteFile(filename, "}," .. charE, true)
        content = content .. "}," .. charE
    end
    -- file:write( "}" )
    -- br._G.WriteFile(filename, "}", true)
    content = content .. "}"
    -- file:close()
    br._G.WriteFile(filename, content, false)
end

-- The Load Function
local tableLoad = function(sfile)
    local file = br._G.ReadFile(sfile)
    if file == nil or file == "" then
        return
    end
    local ftables = br._G.loadstring(file, sfile)
    -- local ftables,err = loadfile( sfile )
    -- if err then return _,err end
    local tables
    if (ftables) then
        tables = ftables()
    else
        tables = {}
    end
    -- return deepcopy(tables)
    for idx = 1, #tables do
        local tolinki = {}
        for i, v in pairs(tables[idx]) do
            if type(v) == "table" then
                tables[idx][i] = tables[v[1]]
            end
            if type(i) == "table" and tables[i[1]] then
                table.insert(tolinki, { i, tables[i[1]] })
            end
        end
        -- link indices
        for _, v in ipairs(tolinki) do
            tables[idx][v[2]], tables[idx][v[1]] = tables[idx][v[1]], nil
        end
    end
    return tables[1]
end


-- Default Settings
function settingsManagement:defaultSettings()
	br._G.C_Timer.After(2, function()
		if br.ui.window.config == nil then
			br.ui.window.config = {}
		end
		if br.ui.window.config.frame == nil then
			br.ui:createConfigWindow()
		end
		br.ui:toggleWindow("config")
		br.ui:closeWindow("config")
	end)
	-- Settings Per Spec
	if br.data.settings[br.loader.selectedSpec].toggles == nil then
		br.data.settings[br.loader.selectedSpec].toggles = {}
	end
	if br.data.settings[br.loader.selectedSpec]["RotationDrop"] == nil then
		br.loader.selectedProfile = 1
	else
		br.loader.selectedProfile = br.data.settings[br.loader.selectedSpec]["RotationDrop"]
	end
	if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] == nil then
		br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] = {}
	end
	-- Define Main Button if no settings exist
	if (br.data.settings and br.data.settings.mainButton == nil) then
		br.data.settings.mainButton = {
			pos = {
				anchor = "CENTER",
				x = -75,
				y = -200
			}
		}
		br.data.settings.buttonSize = 32
		br.data.settings.font = "Fonts/arialn.ttf"
		br.data.settings.fontsize = 16
		br.data.settings.wiped = true
	end
	-- Define Minimap Button if no settings exist
	if (br.data.settings and br.data.settings.minimapButton == nil) then
		br.data.settings.minimapButton = {
			pos = {
				x = 75.70,
				y = -6.63
			}
		}
	end
end

-- Load Saved Settings
function settingsManagement:loadSavedSettings()
	if settingsManagement.initializeSettings then
		br.loader.cBuilder:loadProfiles()
		br.settingsManagement:loadLastProfileTracker()
		if br.data.settings[br.loader.selectedSpec]["RotationDropValue"] then
			br.settingsManagement:loadSettings(nil, nil, nil, br.data.settings[br.loader.selectedSpec]["RotationDropValue"])
		elseif br.loader.rotations[br.loader.selectedSpec] then
			br.settingsManagement:loadSettings(nil, nil, nil, br.loader.rotations[br.loader.selectedSpec][1].name)
		else
			if not br.loader.rotations[br.loader.selectedSpec] then
				br.settingsManagement.initializeSettings = false
				return
			end
		end
		settingsManagement:defaultSettings()
		-- Build the Toggles
		br.ui.toggles:TogglesFrame()
		-- Restore Minimap Button Position
		br.ui.minimapButton.frame:SetPoint("CENTER", br.data.settings.minimapButton.pos.x,
			br.data.settings.minimapButton.pos.y)
		br.settingsManagement.initializeSettings = false
	end
end

settingsManagement.profile = settingsManagement.profile or {}
function settingsManagement:store(key, value)
	if settingsManagement.profile == nil then
		settingsManagement.profile = {}
	end
	settingsManagement.profile[key] = value
	return true
end

function settingsManagement:fetch(key, default)
	if settingsManagement.profile == nil then
		settingsManagement.profile = {}
	end
	local value = settingsManagement.profile[key]
	return value == nil and default or value
end

-- Check Directories
function settingsManagement:checkDirectories(folder, class, spec, profile, instance)
	-- Set Settings Directory
	local wowDir = br._G.GetWoWDirectory() or ""
	local mainDir = ""
	if wowDir:match('_retail_') then
		mainDir = wowDir .. sep .. "Interface" .. sep .. "AddOns" .. sep .. br.loader.addonName .. sep .. "Settings" .. sep
	else
		mainDir = wowDir .. sep .. br.loader.addonName .. sep .. "Settings" .. sep
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
		spec = br.loader.selectedSpec
	end
	if spec == nil then
		spec = "Initial"
	end
	local specDir = classDir .. spec .. sep
	checkDirectory(specDir)

	-- Set the Profile Directory
	if profile == nil then
		profile = br.loader.selectedProfileName
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

function settingsManagement:deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[settingsManagement:deepcopy(orig_key)] = settingsManagement:deepcopy(orig_value)
		end
		setmetatable(copy, settingsManagement:deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function settingsManagement:cleanSettings()
	if br.data and br.data.settings then
		if br.data.settings[br.loader.selectedSpec] and br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] then
			local settings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
			for page, _ in pairs(settings) do
				if type(page) == "table" then
					for option, _ in pairs(page) do
						if br.data.ui[page][option] == nil then
							print("Option: " ..
								tostring(option) ..
								" was not created has been removed from Page: " .. tostring(page) .. ".")
							settings[page][option] = nil
						end
					end
				elseif type(page) == "string" then
					local option = page
					if br.data.ui[option] == nil then
						print("Option: " ..
							tostring(option) ..
							" was not created and had been removed.")
						settings[option] = nil
					end
				end
			end
		end
	end
end

-- Load Settings
function settingsManagement:loadSettings(folder, class, spec, profile, instance)
	if br.unlocked and (not br.data.loadedSettings or br.rotationChanged) then
		local loadDir = settingsManagement:checkDirectories(folder, class, spec, profile, instance)
		if not loadDir then
			br._G.print("No settings directory found for " .. profile .. "!")
			return
		end
		local brdata
		local brprofile
		local fileFound = false
		local profileFound = false
		-- Load Settings
		if br.settingsManagement:findFileInFolder("savedSettings.lua", loadDir) then
			--br._G.print("Loading Settings File From Directory: " .. loadDir)
			brdata = tableLoad(loadDir .. "savedSettings.lua")
			if brdata then
				fileFound = true
			end
		end
		-- Load Profile
		if br.settingsManagement:findFileInFolder("savedProfile.lua", loadDir) then
			-- Print("Loading Saved Profiles")
			-- Print("From Directory: "..loadDir)
			brprofile = tableLoad(loadDir .. "savedProfile.lua")
			if brprofile then
				profileFound = true
			end
		end
		if fileFound then
			br.ui:closeWindow("all")
			br.data = settingsManagement:deepcopy(brdata)
			if profileFound then
				settingsManagement.profile = settingsManagement:deepcopy(brprofile)
			end
			br._G.print("Loaded Settings for Profile " .. tostring(profile))
			-- settingsManagement:cleanSettings()
		end
		if not fileFound then
			if br.loader.selectedProfileName ~= "None" then
				br._G.print("No File Called 'savedSettings.lua' Found In " .. loadDir)
			else
				br._G.print("No pre-existing settings to load.")
			end
		end
		if spec == nil then
			spec = br.loader.selectedSpec
		end
		if spec == "" then
			spec = "Initial"
		end
		if br.data.settings == nil then br.data.settings = {} end
		if br.data.settings[spec] == nil then br.data.settings[spec] = {} end
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
function settingsManagement:saveSettings(folder, class, spec, profile, instance, wipe)
	local saveDir = settingsManagement:checkDirectories(folder, class, spec, profile, instance)
	if not saveDir then
		br._G.print("No settings directory found for " .. profile .. "!")
		return
	end
	local brdata = wipe and {} or settingsManagement:deepcopy(br.data)
	local brprofile = wipe and {} or settingsManagement:deepcopy(settingsManagement.profile)
	br._G.print("Saving Profiles and Settings to Directory: " .. tostring(saveDir))
	-- Save Files
	tableSave(brdata, saveDir .. "savedSettings.lua")
	tableSave(brprofile, saveDir .. "savedProfile.lua")
	br._G.print("Saved Settings for Profile " .. profile)
end

settingsManagement.fileList = {}
function settingsManagement:findFileInFolder(file, folder)
	if folder == nil or folder == "" then return false end
	table.wipe(settingsManagement.fileList)
	settingsManagement.fileList = br._G.GetDirectoryFiles(folder .. "*.lua")
	for i = 1, #settingsManagement.fileList do
		if settingsManagement.fileList[i] == file then
			return true
		end
	end
	return false
end

function settingsManagement:loadLastProfileTracker()
	local loadDir = settingsManagement:checkDirectories(nil, nil, nil, "Tracker")
	local selectedProfile = br.loader.selectedSpec
	if settingsManagement:findFileInFolder("lastProfileTracker.lua", loadDir) then
		local tracker = tableLoad(loadDir .. "lastProfileTracker.lua")
		local specID = br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
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
		local trackerName = br.data.tracker[br.loader.selectedSpec]["RotationDropValue"]
		local specSettings = br.data.settings[br.loader.selectedSpec]
		if not br.loader.rotations[specID] then
			print("No rotations found for specID " .. specID)
			return
		end
		if trackerName then
			for i = 1, #br.loader.rotations[specID] do
				if br.loader.rotations[specID][i].name == trackerName then
					br.loader.selectedProfileName = trackerName
					specSettings["RotationDropValue"] = trackerName
					specSettings["RotationDrop"] = i
					rotationFound = true
					br._G.print("Found Last Used From Tracker: " .. trackerName)
					break
				end
			end
		end
		if not rotationFound then
			br._G.print("No Matching Rotation Found In Tracker, Defaulting to " .. br.loader.rotations[specID][1].name)
			specSettings["RotationDropValue"] = br.loader.rotations[specID][1].name
			specSettings["RotationDrop"] = 1
		end
		-- br._G.print("Tracker Load - Last Profile: " .. tostring(br.data.settings[selectedProfile]["RotationDrop"]))
		-- br._G.print("Tracker Load - Last Profile Name: " .. tostring(br.data.settings[selectedProfile]["RotationDropValue"]))
	else
		br._G.print("No Tracker found for " .. selectedProfile .. "! Creating Tracker....")
	end
	settingsManagement:saveLastProfileTracker()
end

function settingsManagement:saveLastProfileTracker()
	local saveDir = settingsManagement:checkDirectories(nil, nil, nil, "Tracker")
	local specID = br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization()) or br.loader.selectedSpecID
	if specID == 0 and br.loader.selectedSpecID ~= nil then specID = br.loader.selectedSpecID end
	if br.data ~= nil and br.data.settings ~= nil and br.data.settings[br.loader.selectedSpec] ~= nil and specID ~= 0 then
		if br.data.tracker ~= nil then
			if br.data.tracker[br.loader.selectedSpec] == nil then
				br.data.tracker[br.loader.selectedSpec] = {}
			end
			if br.data.settings[br.loader.selectedSpec]["RotationDropValue"] then
				local rotationFound = false
				for i = 1, #br.loader.rotations[specID] do
					if br.loader.rotations[specID][i].name == br.data.settings[br.loader.selectedSpec]["RotationDropValue"] then
						br.data.tracker[br.loader.selectedSpec]["RotationDropValue"] = br.data.settings[br.loader.selectedSpec]
							["RotationDropValue"]
						br.data.tracker[br.loader.selectedSpec]["RotationDrop"] = i
						rotationFound = true
						break
					end
				end
				if not rotationFound then
					br.data.tracker[br.loader.selectedSpec]["RotationDropValue"] = br.loader.rotations[specID][1].name
					br.data.tracker[br.loader.selectedSpec]["RotationDrop"] = 1
				end
			elseif br.loader.rotations and br.loader.rotations[specID] and br.loader.rotations[specID][1] and br.loader.rotations[specID][1].name ~= nil then
				br.data.settings[br.loader.selectedSpec]["RotationDropValue"] = br.loader.rotations[specID][1].name
				br.data.tracker[br.loader.selectedSpec]["RotationDropValue"] = br.loader.rotations[specID][1].name
				br.data.settings[br.loader.selectedSpec]["RotationDrop"] = 1
				br.data.tracker[br.loader.selectedSpec]["RotationDrop"] = 1
			else
				br.data.settings[br.loader.selectedSpec]["RotationDropValue"] = ""
				br.data.tracker[br.loader.selectedSpec]["RotationDropValue"] = ""
				br.data.settings[br.loader.selectedSpec]["RotationDrop"] = 1
				br.data.tracker[br.loader.selectedSpec]["RotationDrop"] = 1
			end
		end
	elseif specID ~= 0 then
		br._G.print("Nothing found, recreating tracker")
		br.data.tracker = {}
		br.data.tracker[br.loader.selectedSpec] = {}
		br.data.tracker[br.loader.selectedSpec]["RotationDrop"] = 1
		br.data.tracker[br.loader.selectedSpec]["RotationDropValue"] = br.loader.rotations[specID][1].name
	end
	br._G.print("Saving Tracker to Directory: " .. tostring(saveDir))
	tableSave(br.data.tracker, saveDir .. "lastProfileTracker.lua")
end
