-- define br global that will hold the bot global background features
br = {}
br.addonName = "BadRotations"
br.commandHelp = {}
br.data = {}
br.data.ui = {}
br.deadPet = false
-- developers debug, use /run br.data.settings[br.selectedSpec].toggles["isDebugging"] = true
br.debug = {}
br.dropOptions = {}
--br.dropOptions.Toggle = {"LeftCtrl","LeftShift","RightCtrl","RightShift","RightAlt","None"}
br.dropOptions.Toggle ={"LeftCtrl","LeftShift","RightCtrl","RightShift","RightAlt","None","MMouse","Mouse4","Mouse5" }
br.dropOptions.CD = {"Never","CDs","Always" }
br.engines = {}
br.loadedIn = false
br.loadFile = false
br.pauseCast = GetTime()
br.prevQueueWindow = GetCVar("SpellQueueWindow")
br.profile = {}
br.rotations = {}
br.selectedSpec = "None"
br.selectedProfile = 1
br.selectedProfileName = "None"
br.settingsDir = "\\"
br.settingsFile = "None.lua"

local nameSet = false
function br:setAddonName()
	if not nameSet then
		for i = 1, GetNumAddOns() do
			local name, title = GetAddOnInfo(i)
			if title == "|cffa330c9BadRotations" then
				br.addonName = name
				if br.addonName ~= "BadRotations" then
					Print("Currently known as "..tostring(br.addonName))
				end
				nameSet = true
				break
			end
		end
	end
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
	local loadDir
	loadDir = br:checkDirectories("Tracker")
	if br.data.tracker == nil then br.data.tracker = {} end
	if br:findFileInFolder("lastProfileTracker.lua",loadDir) then
		br.data.tracker = br.tableLoad(loadDir .. "lastProfileTracker.lua")
	end
	if br.data.tracker ~= nil and br.data.tracker.lastProfile == nil then br.data.tracker.lastProfile = 1 end
end

-- Cache all non-nil return values from GetSpellInfo in a table to improve performance
local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end
-- Custom Print
function br.debug:Print(message)
	if br.data.settings[br.selectedSpec].toggles["isDebugging"] == true then
		Print(message)
	end
end
-- Run
function br:Run()		
	if br.selectedSpec == nil then br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization())) end
	-- rc = LibStub("LibRangeCheck-2.0")
	-- minRange, maxRange = rc:GetRange('target')
	--[[Init the readers codes (System/Reader.lua)]]
	-- -- combat log
	-- br.read.combatLog()
	-- -- other readers
	-- br.read.commonReaders()
	-- The colors Duke, the colors!
	br.classColors = {
		[1]				= {class = "Warrior", 		B=0.43,	G=0.61,	R=0.78,	hex="c79c6e"},
		[2]				= {class = "Paladin", 		B=0.73,	G=0.55,	R=0.96,	hex="f58cba"},
		[3]				= {class = "Hunter",		B=0.45,	G=0.83,	R=0.67,	hex="abd473"},
		[4]				= {class = "Rogue",			B=0.41,	G=0.96,	R=1,	hex="fff569"},
		[5]				= {class = "Priest",		B=1,	G=1,	R=1,	hex="ffffff"},
		[6]				= {class = "Deathknight",	B=0.23,	G=0.12,	R=0.77,	hex="c41f3b"},
		[7]				= {class = "Shaman",		B=0.87,	G=0.44,	R=0,	hex="0070de"},
		[8]				= {class = "Mage",			B=0.94,	G=0.8,	R=0.41,	hex="69ccf0"},
		[9]				= {class = "Warlock", 		B=0.79,	G=0.51,	R=0.58,	hex="9482c9"},
		[10]			= {class = "Monk",			B=0.59,	G=1,	R=0,	hex="00ff96"},
		[11]			= {class = "Druid", 		B=0.04,	G=0.49,	R=1,	hex="ff7d0a"},
		[12] 			= {class = "Demonhunter", 	B=0.79, G=0.19, R=0.64, hex="a330c9"},
	}
	br.classColor = tostring("|cff"..br.classColors[select(3,UnitClass("player"))].hex)
	br.qualityColors = {
		blue = "0070dd",
		green = "1eff00",
		white = "ffffff",
		grey = "9d9d9d"
	}
	-- load common used stuff on first load
	br:defaultSettings()

	-- br:loadSettings()
	-- Build up pulse frame (hearth)
	if not br.loadedIn then
		-- Start Logs
		-- combat log
		br.read.combatLog()
		-- other readers
		br.read.commonReaders()
		-- Start Engines
		br:Engine()
		br:ObjectManager()
		-- Complete Loadin
		ChatOverlay("-= BadRotations Loaded =-")
		Print("Loaded")
		br.loadedIn = true
	end
end
-- Default Settings
function br:defaultSettings()
	if br.data == nil then br.data = {} end	
	if br.data.tracker == nil then br.data.tracker = {} end
	if br.data.settings == nil then
		br.data.settings = {
			mainButton = {
				pos = {
					anchor = "CENTER",
					x = -75,
					y = -200
				}
			},
			buttonSize = 32,
			font = "Fonts/arialn.ttf",
			fontsize = 16,
			wiped = true,
		}
	end
	-- Settings Per Spec
	if br.data.settings[br.selectedSpec] == nil then br.data.settings[br.selectedSpec] = {} end
	if br.data.settings[br.selectedSpec].toggles == nil then br.data.settings[br.selectedSpec].toggles = {} end
	if br.data.settings[br.selectedSpec]["RotationDrop"] == nil then
		if br.data.tracker.lastProfile ~= nil then br.selectedProfile = br.data.tracker.lastProfile else br.selectedProfile = 1 end
	else
		br.selectedProfile = br.data.settings[br.selectedSpec]["RotationDrop"]
	end
	if br.data.settings[br.selectedSpec][br.selectedProfile] == nil then br.data.settings[br.selectedSpec][br.selectedProfile] = {} end
	-- Initialize Minimap Button
	br:MinimapButton()
end
-- Check Directories
function br:checkDirectories(folder)
	if folder == nil then folder = "" end
	-- Set the Settings Directory
	if folder == "Exported Settings" then
		br.settingsDir = GetWoWDirectory() .. '\\Interface\\AddOns\\'..br.addonName..'\\Settings\\Exported Settings\\'
	else
		br.settingsDir = GetWoWDirectory() .. '\\Interface\\AddOns\\'..br.addonName..'\\Settings\\'
	end
	-- Make Settings Directory
	if not DirectoryExists(br.settingsDir) then CreateDirectory(br.settingsDir) end

	-- Set the Class Directory
	local classDir = br.settingsDir .. select(2,UnitClass("player")) .. "\\"
	-- Make Class Directory
	if not DirectoryExists(classDir) then CreateDirectory(classDir) end

	-- Set the Spec Directory
	local specDir = classDir .. br.selectedSpec .. "\\"
	-- Make Spec Directory
	if not DirectoryExists(specDir) then CreateDirectory(specDir) end
	if folder == "Tracker" then return specDir end

	-- Set the Save/Load Directory
	local saveLoadDir = specDir .. br.selectedProfileName .. "\\"
	-- Make Save/Load Directory
	if not DirectoryExists(saveLoadDir) then CreateDirectory(saveLoadDir) end
	return saveLoadDir
end
-- Load Saved Settings
function br:loadSavedSettings(export)
	if br.unlocked and not br.data.loadedSettings then
		local loadDir = br:checkDirectories(export)
		local brdata
		local brprofile
		local fileFound = false
		-- Load Settings
		if br:findFileInFolder(br.settingsFile,loadDir) then
			Print("Loading Settings File: " .. br.settingsFile)
			-- Print("From Directory: "..loadDir)
			brdata = br.tableLoad(loadDir .. br.settingsFile)
			br.data = deepcopy(brdata)
			brdata = nil
			fileFound = true
		end
		-- Load Profile
		if br:findFileInFolder("savedProfile.lua",loadDir) then
			-- Print("Loading Saved Profiles")
			-- Print("From Directory: "..loadDir)
			brprofile = br.tableLoad(loadDir .. br.settingsFile)
			br.profile = deepcopy(brprofile)
			brprofile = nil
		end
		TogglesFrame()
		br.ui.window.config = {}
		br.ui:createConfigWindow()
		-- br.ui:toggleWindow("config")
		br.data.loadedSettings = true
	end
end
-- Save Settings
function br:saveSettings(wipe,export)
	local saveDir
	local brdata = wipe and {} or deepcopy(br.data)
	local brprofile = wipe and {} or deepcopy(br.profile)
	Print("Saving Profiles and Settings To: "..br.settingsFile)
	saveDir = br:checkDirectories("Tracker")
	br.tableSave(br.data.tracker, saveDir .. "lastProfileTracker.lua")
	saveDir = br:checkDirectories(export)
	-- Reset Files
	br.tableSave({},saveDir .. br.settingsFile)
	br.tableSave({},saveDir .. "savedProfile.lua")
	-- Save Files
	br.tableSave(brdata,saveDir .. br.settingsFile)
	br.tableSave(brprofile,saveDir .. "savedProfile.lua")
end
local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterUnitEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("LOADING_SCREEN_ENABLED")
frame:RegisterEvent("LOADING_SCREEN_DISABLED")
function frame:OnEvent(event, arg1, arg2, arg3, arg4, arg5)
	if event == "LOADING_SCREEN_ENABLED" then
		br.disablePulse = true
	end
	if event == "LOADING_SCREEN_DISABLED" then
		br.disablePulse = false
	end
	if event == "PLAYER_LOGOUT" then
		if br.unlocked then
			-- Return queue window to previous setting
			if GetCVar("SpellQueueWindow") =="0" then 
				RunMacroText("/console SpellQueueWindow "..br.prevQueueWindow)
			end 
			br.ui:saveWindowPosition()
			if getOptionCheck("Reset Options") then
				-- Reset Settings
				br:saveSettings(true)
			else
				-- Save Settings
				br:saveSettings()
			end
		end
	end
	if event == "PLAYER_ENTERING_WORLD" then
		-- Update Selected Spec
		br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization()))
		br.activeSpecGroup = GetActiveSpecGroup()
		br.equipHasChanged = true
		if not br.loadedIn then
			if br.damaged == nil then br.damaged = {} end
			br.bagsUpdated = true
			br:Run()
		end
	end
end
frame:SetScript("OnEvent", frame.OnEvent)
